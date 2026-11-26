"""14.1: fuse MXFP4 decode into the mixed-width WMMA pipeline."""

import argparse
import runpy
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch
from flydsl._mlir import ir
from flydsl._mlir.dialects import gpu, llvm, scf
from flydsl.expr.typing import Vector as Vec

BLOCK_THREADS = 256
MX_BLOCK_K = 32
ALIGNED_SHAPES = ((16, 1024, 8192), (32, 1024, 8192), (16, 4096, 8192))
EDGE_SHAPES = ((17, 77, 46), (17, 1046, 8214), (31, 1025, 8193), (1030, 1046, 1022))
SHAPES = (*ALIGNED_SHAPES, *EDGE_SHAPES)
_EDGE_LOADS = runpy.run_path(
    str(
        Path(__file__).resolve().parents[2]
        / "13-matmul/15-edge-load-widths/solution.py"
    )
)
Config = _EDGE_LOADS["Config"]
validate_config = _EDGE_LOADS["validate_config"]
_copy_valid_columns = _EDGE_LOADS["_copy_valid_columns"]
_copy_tail_segments = _EDGE_LOADS["_copy_tail_segments"]
_tail_segments = _EDGE_LOADS["_tail_segments"]
_create_staging_views = _EDGE_LOADS["_create_staging_views"]
_workspace_for = _EDGE_LOADS["_workspace_for"]
_capture_id = _EDGE_LOADS["_capture_id"]
check_workspace = _EDGE_LOADS["check_workspace"]

# Selected by the gfx1151 mixed-width fused sweep. See results/README.md.
CONFIGS_BY_SHAPE = {
    (16, 1024, 8192): Config(
        block_m=16,
        block_n=64,
        block_k=32,
        waves_m=1,
        waves_n=2,
        split_k=4,
        k_unroll=2,
        right_cache_modifier=0,
        left_in_registers=True,
    ),
    (32, 1024, 8192): Config(
        block_m=32,
        block_n=64,
        block_k=32,
        waves_m=1,
        waves_n=2,
        split_k=4,
        k_unroll=2,
        right_cache_modifier=0,
        left_in_registers=True,
    ),
    (16, 4096, 8192): Config(
        block_m=16,
        block_n=64,
        block_k=64,
        waves_m=1,
        waves_n=2,
        group_m=2,
        split_k=4,
        k_unroll=2,
        left_in_registers=True,
    ),
    (17, 77, 46): Config(
        block_m=16,
        block_n=32,
        block_k=64,
        waves_m=1,
        waves_n=1,
        split_k=1,
        k_unroll=2,
        right_cache_modifier=0,
        left_in_registers=True,
    ),
    (17, 1046, 8214): Config(
        block_m=32,
        block_n=128,
        block_k=32,
        waves_m=1,
        waves_n=4,
        split_k=4,
        k_unroll=2,
        left_in_registers=True,
    ),
    (31, 1025, 8193): Config(
        block_m=32,
        block_n=128,
        block_k=64,
        waves_m=1,
        waves_n=4,
        split_k=4,
        k_unroll=2,
        left_cache_modifier=2,
        left_in_registers=False,
    ),
    (1030, 1046, 1022): Config(
        block_m=128,
        block_n=64,
        block_k=32,
        waves_m=2,
        waves_n=2,
        group_m=4,
        split_k=1,
        k_unroll=2,
        right_cache_modifier=0,
        left_in_registers=True,
    ),
}


def default_config(shape):
    if shape in CONFIGS_BY_SHAPE:
        return CONFIGS_BY_SHAPE[shape]
    return _EDGE_LOADS["default_config"](shape)


def _load_buffer_word(resource, byte_offset, dtype, cache_modifier):
    # Byte addressing preserves unaligned row starts for odd widths.
    result_type = (
        ir.VectorType.get([2], fx.Uint32.ir_type)
        if dtype == fx.Uint64
        else dtype.ir_type
    )
    word = fx.rocdl.raw_ptr_buffer_load(
        result_type, resource, fx.Int32(byte_offset), fx.Int32(0), aux=cache_modifier
    )
    if dtype == fx.Uint64:
        return Vec(word, dtype=fx.Uint32).bitcast(fx.Uint64)[0]
    return dtype(word)


def _load_tail_bytes(resource, byte_offset, count, dtype, cache_modifier):
    # Assemble 4-, 2-, and 1-byte pieces at their original word offsets.
    word = dtype(0)
    byte = 0
    for width, piece_type in ((4, fx.Uint32), (2, fx.Uint16), (1, fx.Uint8)):
        if count & width:
            piece = _load_buffer_word(
                resource, byte_offset + byte, piece_type, cache_modifier
            )
            word = word | (piece.to(dtype) << (8 * byte))
            byte += width
    return word


def _load_packed_word(resource, row, column, k, n, cache_modifier, check_boundary=True):
    first = row * n + column
    byte_offset = first // 2
    if n % 8 == 0:
        return _load_buffer_word(resource, byte_offset, fx.Uint32, cache_modifier)

    if n % 2:
        # Odd row pitches can start on the high nibble. The fifth byte
        # supplies the last nibble of a full chunk in that case.
        shift = (first % 2 * 4).to(fx.Uint32)

    def load_wide():
        low = _load_buffer_word(resource, byte_offset, fx.Uint32, cache_modifier)
        if n % 2:
            high = _load_buffer_word(
                resource, byte_offset + 4, fx.Uint8, cache_modifier
            )
            word = low.to(fx.Uint64) | (high.to(fx.Uint64) << 32)
            return (word >> shift.to(fx.Uint64)).to(fx.Uint32)
        return low

    if not check_boundary:
        return load_wide()

    # A read that crosses a logical N boundary can feed invalid C columns.
    # Narrow it only near the end of the physical packed allocation.
    wide = first + 8 <= k * n
    edge = scf.IfOp(wide.ir_value(), [fx.Uint32.ir_type], has_else=True)
    with ir.InsertionPoint(edge.then_block):
        scf.yield_([load_wide().ir_value()])
    with ir.InsertionPoint(edge.else_block):
        suffix = column == (n // 8) * 8
        valid = suffix & (row < k)
        offset = valid.select(byte_offset, (k * n + 1) // 2)
        tail = _load_tail_bytes(
            resource, offset, (n % 8 + 1) // 2, fx.Uint32, cache_modifier
        )
        if n % 2:
            tail = tail >> shift
        scf.yield_([tail.ir_value()])
    return fx.Uint32(edge.results[0])


def _load_row_word(resource, row, column, rows, n, cache_modifier, check_boundary=True):
    offset = row * n + column
    if n % 8 == 0 or not check_boundary:
        return _load_buffer_word(resource, offset, fx.Uint64, cache_modifier)

    # Full words may cross logical rows while the physical allocation has room.
    byte_count = rows * n
    wide = offset + 8 <= byte_count
    edge = scf.IfOp(wide.ir_value(), [fx.Uint64.ir_type], has_else=True)
    with ir.InsertionPoint(edge.then_block):
        word = _load_buffer_word(resource, offset, fx.Uint64, cache_modifier)
        scf.yield_([word.ir_value()])
    with ir.InsertionPoint(edge.else_block):
        suffix = column == (n // 8) * 8
        valid = suffix & (row < rows)
        offset = valid.select(offset, byte_count)
        word = _load_tail_bytes(resource, offset, n % 8, fx.Uint64, cache_modifier)
        scf.yield_([word.ir_value()])
    return fx.Uint64(edge.results[0])


def _lookup_e2m1_magnitudes(packed_word):
    # The eight little-endian byte entries are twice the E2M1 magnitudes.
    # Each perm_b32 looks up the four even or four odd nibbles in parallel.
    low, high = fx.Uint32(0x03020100), fx.Uint32(0x0C080604)
    even_codes = packed_word & 0x07070707
    odd_codes = (packed_word >> 4) & 0x07070707
    return (
        fx.Uint32(fx.rocdl.perm_b32(high, low, even_codes)),
        fx.Uint32(fx.rocdl.perm_b32(high, low, odd_codes)),
    )


def _decode_scaled_e2m1(code, scale_byte, doubled_magnitude):
    value = doubled_magnitude.to(fx.Float32)
    # The extra factor of two in the lookup moves the scale bias from 127 to 128.
    power = scale_byte - 128
    scaled = fx.Float32(
        llvm.intr_ldexp(fx.Float32.ir_type, value.ir_value(), power.ir_value())
    )
    # Finite FP32 results fit exactly in BF16. Take the high bits and add the sign.
    bits = (scaled.bitcast(fx.Uint32) >> 16) | ((code & 8) << 12)
    bits = (scale_byte == 255).select(fx.Uint32(0x7FC0), bits)
    return bits.to(fx.Uint16).bitcast(fx.BFloat16)


@flyc.kernel
def _matmul_mxfp4_w4a16(
    packed_weights: fx.Tensor,
    scales: fx.Tensor,
    dense_weights: fx.Tensor,
    K: fx.Constexpr,
    N: fx.Constexpr,
    REGISTER_UNPACK: fx.Constexpr,
):
    """Expand MXFP4 values to BF16; the register path handles eight per lane."""
    element_count = K * N
    packed_count = element_count // 2
    dense_view = fx.make_view(
        fx.get_iter(dense_weights), fx.make_layout(element_count, 1)
    )

    if REGISTER_UNPACK:
        # PR #1374 expands four packed bytes with perm_b32 lookups. This path
        # converts those eight E2M1 values directly to scaled BF16 bit patterns.
        packed_words = fx.make_view(
            fx.recast_iter(fx.Uint32, fx.get_iter(packed_weights)),
            fx.make_layout(packed_count // 4, 1),
        )
        packed_words = fx.rocdl.make_buffer_tensor(
            packed_words, num_records_bytes=packed_count
        )
        scale_words = fx.make_view(
            fx.recast_iter(fx.Uint64, fx.get_iter(scales)),
            fx.make_layout((K // 32) * (N // 8), 1),
        )
        scale_words = fx.rocdl.make_buffer_tensor(
            scale_words, num_records_bytes=(K // 32) * N
        )
        word_id = fx.block_idx.x * BLOCK_THREADS + fx.thread_idx.x
        packed_word = fx.Uint32(fx.get_scalar(packed_words[word_id]))
        even_nibbles = packed_word & 0x0F0F0F0F
        odd_nibbles = packed_word.shrui(fx.Uint32(4)) & 0x0F0F0F0F
        table_low = fx.Uint32(0x3E3C3800)
        table_high = fx.Uint32(0x46444240)
        even_values = fx.Uint32(
            fx.rocdl.perm_b32(table_high, table_low, even_nibbles & 0x07070707)
        ) | ((even_nibbles & 0x08080808) << 4)
        odd_values = fx.Uint32(
            fx.rocdl.perm_b32(table_high, table_low, odd_nibbles & 0x07070707)
        ) | ((odd_nibbles & 0x08080808) << 4)
        value_words = Vec.from_elements(
            [
                fx.Uint32(
                    fx.rocdl.perm_b32(odd_values, even_values, fx.Uint32(0x05010400))
                ),
                fx.Uint32(
                    fx.rocdl.perm_b32(odd_values, even_values, fx.Uint32(0x07030602))
                ),
            ],
            fx.Uint32,
        )
        e5m2_codes = fx.make_rmem_tensor(8, fx.Uint8)
        e5m2_codes.store(value_words.bitcast(fx.Uint8))

        first_index = word_id * 8
        row = first_index // N
        col = first_index % N
        scale_id = (row // 32) * (N // 8) + col // 8
        scale_word = fx.Uint64(fx.get_scalar(scale_words[scale_id]))
        output = fx.make_rmem_tensor(8, fx.BFloat16)
        for value_id in fx.range_constexpr(8):
            code = fx.Uint32(e5m2_codes[value_id])
            scale_byte = ((scale_word >> fx.Uint64(value_id * 8)) & fx.Uint64(255)).to(
                fx.Int32
            )
            exponent = ((code >> 2) & 31).to(fx.Int32) + scale_byte - 15
            is_zero = (code & 127) == 0
            is_subnormal = exponent <= 0
            is_overflow = exponent >= 255
            sign = ((code >> 7) & 1) << 15
            significand = 128 + ((code & 3) << 5)
            subnormal_shift = is_subnormal.select(1 - exponent, 1).to(fx.Uint32)
            subnormal_fraction = significand >> subnormal_shift
            normal_fraction = (code & 3) << 5
            fraction = is_subnormal.select(subnormal_fraction, normal_fraction)
            fraction = is_overflow.select(0, fraction)
            fraction = is_zero.select(0, fraction)
            exponent_bits = is_subnormal.select(0, exponent).to(fx.Uint32)
            exponent_bits = is_overflow.select(255, exponent_bits)
            exponent_bits = is_zero.select(0, exponent_bits)
            bf16_bits = (sign | (exponent_bits << 7) | fraction).to(fx.Uint16)
            output[value_id] = bf16_bits.bitcast(fx.BFloat16)
        output_view = fx.make_view(
            fx.get_iter(dense_weights) + first_index, fx.make_layout(8, 1)
        )
        fx.copy(
            fx.make_copy_atom(fx.UniversalCopy128b(), fx.BFloat16),
            output,
            output_view,
        )
    else:
        packed_view = fx.make_view(
            fx.recast_iter(fx.Uint8, fx.get_iter(packed_weights)),
            fx.make_layout(packed_count, 1),
        )
        scale_view = fx.make_view(
            fx.recast_iter(fx.Uint8, fx.get_iter(scales)),
            fx.make_layout((K // 32) * N, 1),
        )
        pair_coordinates = fx.make_view(
            fx.make_int_tuple(0), fx.make_layout(packed_count, 1)
        )
        pair_tiles = fx.logical_divide(pair_coordinates, fx.make_layout(256, 1))
        block_pairs = fx.slice(pair_tiles, (None, fx.block_idx.x))
        pair_id = fx.get_scalar(block_pairs[fx.thread_idx.x])
        packed_byte = fx.get_scalar(packed_view[pair_id]).to(fx.Int32)

        low_code = packed_byte & 15
        high_code = packed_byte >> 4
        low_index = pair_id * 2
        high_index = low_index + 1

        low_row = low_index // N
        low_col = low_index % N
        high_row = high_index // N
        high_col = high_index % N
        low_scale_id = (low_row // 32) * N + low_col
        high_scale_id = (high_row // 32) * N + high_col
        low_scale_byte = fx.get_scalar(scale_view[low_scale_id]).to(fx.Int32)
        high_scale_byte = fx.get_scalar(scale_view[high_scale_id]).to(fx.Int32)

        # Decode the two nibbles and apply each value's shared K-block scale.
        low_decoded = _decode_e2m1(low_code)
        high_decoded = _decode_e2m1(high_code)
        low_value = low_decoded * fx.exp2(low_scale_byte.to(fx.Float32) - 127.0)
        high_value = high_decoded * fx.exp2(high_scale_byte.to(fx.Float32) - 127.0)
        dense_view[low_index] = low_value.to(fx.BFloat16)
        dense_view[high_index] = high_value.to(fx.BFloat16)


@flyc.jit
def _launch_matmul_mxfp4_w4a16(
    packed_weights: fx.Tensor,
    scales: fx.Tensor,
    dense_weights: fx.Tensor,
    K: fx.Constexpr,
    N: fx.Constexpr,
    REGISTER_UNPACK: fx.Constexpr,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
):
    _matmul_mxfp4_w4a16(
        packed_weights, scales, dense_weights, K, N, REGISTER_UNPACK
    ).launch(
        grid=((K * N // (8 if REGISTER_UNPACK else 2)) // BLOCK_THREADS, 1, 1),
        block=(BLOCK_THREADS, 1, 1),
        stream=stream,
    )


@flyc.kernel
def _matmul_mxfp4_w4a16_fused_impl(
    left: fx.Tensor,
    packed_weights: fx.Tensor,
    scales: fx.Tensor,
    out: fx.Tensor,
    partials,
    counters,
    m: fx.Constexpr,
    n: fx.Constexpr,
    k: fx.Constexpr,
    *,
    GROUP_TILE_M: fx.Constexpr,
    GROUP_TILE_N: fx.Constexpr,
    STAGE_K: fx.Constexpr,
    WAVES_M: fx.Constexpr,
    WAVES_N: fx.Constexpr,
    WAVE_GROUPS_M: fx.Constexpr,
    WAVE_GROUPS_N: fx.Constexpr,
    K_UNROLL: fx.Constexpr,
    RIGHT_CACHE_MODIFIER: fx.Constexpr,
    LEFT_CACHE_MODIFIER: fx.Constexpr,
    LEFT_IN_REGISTERS: fx.Constexpr,
    GROUP_M: fx.Constexpr,
    SPLIT_K: fx.Constexpr,
):
    MMA_M, MMA_N, MMA_K = 16, 16, 16
    WAVE_GROUPS = WAVE_GROUPS_M * WAVE_GROUPS_N
    BLOCK_M = GROUP_TILE_M * WAVE_GROUPS_M
    BLOCK_N = GROUP_TILE_N * WAVE_GROUPS_N
    THREADS_PER_GROUP = 32 * WAVES_M * WAVES_N
    wave_group = fx.thread_idx.x // THREADS_PER_GROUP
    thread_id_in_wave_group = fx.thread_idx.x % THREADS_PER_GROUP
    lds_address_spaces = ir.ArrayAttr.get(
        [ir.Attribute.parse("#gpu.address_space<workgroup>")]
    )
    barrier_scope = (
        gpu.BarrierScope.Subgroup if WAVE_GROUPS > 1 else gpu.BarrierScope.Workgroup
    )

    def lds_barrier():
        # LDS-only ordering; global split-K publication keeps its agent atomics.
        fx.barrier(address_spaces=lds_address_spaces, scope=barrier_scope)

    # 1. Bound the physical buffers. Whole rows past M or K land beyond them.
    left_buffer = fx.rocdl.make_buffer_tensor(left, max_size=False)
    # Flat packed nibbles use ceil(K*N/2) bytes. Scales belong to K blocks.
    SCALE_ROWS = (k + MX_BLOCK_K - 1) // MX_BLOCK_K
    packed_buffer = fx.rocdl.make_buffer_tensor(packed_weights, max_size=False)
    scale_buffer = fx.rocdl.make_buffer_tensor(scales, max_size=False)
    packed_resource = fx.rocdl.get_buffer_rsrc(fx.get_iter(packed_buffer))
    scale_resource = fx.rocdl.get_buffer_rsrc(fx.get_iter(scale_buffer))
    out_buffer = fx.rocdl.make_buffer_tensor(out, max_size=False)
    left_global_view = fx.make_view(
        fx.get_iter(left_buffer),
        fx.make_layout((m, k), (k, 1)),
    )
    out_global_view = fx.make_view(
        fx.get_iter(out_buffer),
        fx.make_layout((m, n), (n, 1)),
    )
    # Coordinate views are needed only where a contiguous axis can cross rows.
    LEFT_TAIL_SEGMENTS = _tail_segments(k)
    REAL_K_STAGES = (k + STAGE_K - 1) // STAGE_K
    HAS_EMPTY_K_STAGES = REAL_K_STAGES % SPLIT_K != 0
    HAS_K_TAIL = k % STAGE_K != 0
    HAS_N_TAIL = n % BLOCK_N != 0
    if fx.const_expr(HAS_K_TAIL):
        left_coordinates = fx.make_view(
            fx.make_int_tuple((0, 0)), fx.make_identity_layout((m, k))
        )
        left_coordinate_tiles = fx.flat_divide(left_coordinates, (BLOCK_M, STAGE_K))
    if fx.const_expr(HAS_N_TAIL):
        out_coordinates = fx.make_view(
            fx.make_int_tuple((0, 0)), fx.make_identity_layout((m, n))
        )
        out_coordinate_tiles = fx.flat_divide(out_coordinates, (BLOCK_M, BLOCK_N))
    # 2. Decode block traversal separately from groups inside the block.
    group_layout = fx.make_layout((WAVE_GROUPS_M, WAVE_GROUPS_N), (WAVE_GROUPS_N, 1))
    group_coords = fx.idx2crd(wave_group, group_layout)
    group_row = fx.get_scalar(group_coords[0])
    group_col = fx.get_scalar(group_coords[1])

    out_block_tiles = fx.flat_divide(out_global_view, (BLOCK_M, BLOCK_N))
    blocks_m = fx.size(out_block_tiles.shape[2]).to_py_value()
    blocks_n = fx.size(out_block_tiles.shape[3]).to_py_value()
    group_m_width = min(GROUP_M, blocks_m)
    # Consecutive splits share an output tile. Decode the output tile ID next.
    output_block_id = fx.block_idx.x // SPLIT_K
    split_id = fx.block_idx.x % SPLIT_K
    full_m_groups, tail_rows = divmod(blocks_m, group_m_width)
    full_rows = full_m_groups * group_m_width
    full_tile_count = full_rows * blocks_n

    # Five tile rows, two columns and group width three give full tile IDs
    # 0–5 and tail tile IDs 6–9. Tail-local IDs 0–3 cover rows 3–4.
    block_row = fx.Int32(0)
    block_col = fx.Int32(0)
    if tail_rows > 0 and output_block_id >= full_tile_count:
        tail_layout = fx.make_ordered_layout((tail_rows, blocks_n), (0, 1))
        tail_coords = fx.idx2crd(output_block_id - full_tile_count, tail_layout)
        block_row = full_rows + fx.get_scalar(tail_coords[0])
        block_col = fx.Int32(fx.get_scalar(tail_coords[1]))
    else:
        full_layout = fx.make_ordered_layout(
            (group_m_width, blocks_n, full_m_groups), (0, 1, 2)
        )
        full_coords = fx.idx2crd(output_block_id, full_layout)
        block_row = fx.get_scalar(full_coords[2]) * group_m_width + fx.get_scalar(
            full_coords[0]
        )
        block_col = fx.Int32(fx.get_scalar(full_coords[1]))

    # Select the complete block output, then this group's output tile.
    out_block_view = fx.slice(out_block_tiles, (None, None, block_row, block_col))
    out_group_tiles = fx.flat_divide(out_block_view, (GROUP_TILE_M, GROUP_TILE_N))
    out_group_view = fx.slice(out_group_tiles, (None, None, group_row, group_col))

    # Workspace IDs name group output tiles independently of launch order.
    output_group_layout = fx.make_layout(
        (blocks_m * WAVE_GROUPS_M, blocks_n * WAVE_GROUPS_N),
        (blocks_n * WAVE_GROUPS_N, 1),
    )
    output_group_row = block_row * WAVE_GROUPS_M + group_row
    output_group_col = block_col * WAVE_GROUPS_N + group_col
    flat_group_id = fx.get_scalar(
        fx.crd2idx((output_group_row, output_group_col), output_group_layout)
    )

    # A block tiles cover the output rows for one K stage.
    left_block_tiles = fx.flat_divide(left_global_view, (BLOCK_M, STAGE_K))

    mma_atom = fx.make_mma_atom(
        fx.rocdl.WMMA(MMA_M, MMA_N, MMA_K, fx.BFloat16, fx.Float32)
    )
    mma = fx.make_tiled_mma(
        mma_atom, fx.make_layout((WAVES_M, WAVES_N, 1), (1, WAVES_M, 0))
    )
    copy_128b = fx.make_copy_atom(fx.UniversalCopy128b(), fx.BFloat16)
    copy_16b = fx.make_copy_atom(fx.UniversalCopy16b(), fx.BFloat16)

    # The first global A tile supplies the full-stage shape (GROUP_TILE_M, STAGE_K).
    # load_stage selects the actual source using block_row, group_row, and tile_k.
    left_block_model = fx.slice(left_block_tiles, (None, None, 0, 0))
    left_group_models = fx.flat_divide(left_block_model, (GROUP_TILE_M, STAGE_K))
    left_group_global_view = fx.slice(left_group_models, (None, None, 0, 0))

    # Direct A uses the global shape model and skips LDS allocation for A.
    left_group_staging_view, right_group_staging_view = _create_staging_views(
        left_group_global_view,
        GROUP_TILE_M,
        GROUP_TILE_N,
        STAGE_K,
        LEFT_IN_REGISTERS,
        WAVE_GROUPS_M,
        WAVE_GROUPS_N,
        group_row,
        group_col,
    )

    thread_mma = mma.thr_slice(thread_id_in_wave_group)
    accumulator = thread_mma.make_fragment_C(out_group_view)
    ACCUMULATOR_VALUES = fx.size(accumulator.shape).to_py_value()
    accumulator.fill(0)

    # Staging copies for A and B.
    staging_value_layout = fx.make_ordered_layout((1, 8), (1, 0))
    gmem_left_load = fx.make_copy_atom(
        fx.rocdl.BufferCopy128b(LEFT_CACHE_MODIFIER), fx.BFloat16
    )
    if fx.const_expr(LEFT_IN_REGISTERS):
        # Allocate per-thread registers for two full A stages in WMMA layout.
        # Staging holds the next load while compute holds the current stage.
        left_staging_fragment = thread_mma.make_fragment_A(left_group_global_view)
        left_compute_fragment = fx.make_fragment_like(left_staging_fragment)
    else:
        # Cooperatively load contiguous K chunks for the padded A tile in LDS.
        left_staging_thread_layout = fx.make_ordered_layout(
            (THREADS_PER_GROUP // (STAGE_K // 8), STAGE_K // 8), (1, 0)
        )
        left_staging_copy_tile, left_staging_copy_tv = fx.make_layout_tv(
            left_staging_thread_layout, staging_value_layout
        )
        left_staging_thread_copy = fx.make_tiled_copy(
            copy_128b, left_staging_copy_tv, left_staging_copy_tile
        ).get_slice(thread_id_in_wave_group)
        left_staging_destination = left_staging_thread_copy.partition_D(
            left_group_staging_view
        )
        left_staging_fragment = fx.make_fragment_like(left_staging_destination)

    def make_left_global_copy(atom):
        if fx.const_expr(LEFT_IN_REGISTERS):
            return fx.make_tiled_copy_A(atom, mma).get_slice(thread_id_in_wave_group)
        else:
            return fx.make_tiled_copy(
                atom, left_staging_copy_tv, left_staging_copy_tile
            ).get_slice(thread_id_in_wave_group)

    # Both widths write into views of the same staging fragment.
    left_global_thread_copy = make_left_global_copy(gmem_left_load)
    left_global_destination = left_global_thread_copy.retile(left_staging_fragment)

    # Read eight adjacent N values per lane. Packed weights and scale bytes
    # stay in registers until publish_stage expands them into this group's LDS.
    RIGHT_N_THREADS = GROUP_TILE_N // 8
    RIGHT_K_THREADS = THREADS_PER_GROUP // RIGHT_N_THREADS
    RIGHT_ROWS_PER_THREAD = STAGE_K // RIGHT_K_THREADS
    right_k_lane = thread_id_in_wave_group // RIGHT_N_THREADS
    right_col = thread_id_in_wave_group % RIGHT_N_THREADS * 8
    global_col = output_group_col * GROUP_TILE_N + right_col

    # Reuse a scale word for rows this lane owns in the same MX block.
    if fx.const_expr(STAGE_K in (16, 32)):
        ROW_SLOTS_PER_SCALE = RIGHT_ROWS_PER_THREAD
    elif fx.const_expr(STAGE_K % MX_BLOCK_K == 0 and MX_BLOCK_K % RIGHT_K_THREADS == 0):
        ROW_SLOTS_PER_SCALE = MX_BLOCK_K // RIGHT_K_THREADS
    else:
        ROW_SLOTS_PER_SCALE = 1
    RIGHT_SCALE_SLOTS = RIGHT_ROWS_PER_THREAD // ROW_SLOTS_PER_SCALE
    right_packed_fragment = fx.make_rmem_tensor(RIGHT_ROWS_PER_THREAD, fx.Uint32)
    right_scale_fragment = fx.make_rmem_tensor(RIGHT_SCALE_SLOTS, fx.Uint64)

    # MMA copies for A and B.
    left_group_staging_tiled = fx.flat_divide(
        left_group_staging_view, (GROUP_TILE_M, MMA_K)
    )
    left_group_staging_mma_initial_view = fx.slice(
        left_group_staging_tiled, (None, None, 0, 0)
    )
    # WMMA consumes one MMA_K step at a time.
    left_r_tile = thread_mma.make_fragment_A(left_group_staging_mma_initial_view)
    if fx.const_expr(LEFT_IN_REGISTERS):
        # Divide the three fragment axes into three inner and three outer axes.
        # For example, (16, 2, 2) becomes (16, 2, 1, 1, 1, 2) for two K steps.
        left_compute_tiled = fx.flat_divide(
            left_compute_fragment, (MMA_K, GROUP_TILE_M // (MMA_M * WAVES_M), 1)
        )
        left_r_destination = left_r_tile
    else:
        left_lds2reg_thread_copy = fx.make_tiled_copy_A(copy_16b, mma).get_slice(
            thread_id_in_wave_group
        )
        left_r_destination = left_lds2reg_thread_copy.retile(left_r_tile)

    # Reinterpret B as (N,K) for WMMA without moving its physical data.
    right_group_staging_transposed_view = fx.make_view(
        fx.get_iter(right_group_staging_view),
        fx.make_layout((GROUP_TILE_N, STAGE_K), (1, GROUP_TILE_N)),
    )
    right_group_staging_transposed_tiled = fx.flat_divide(
        right_group_staging_transposed_view, (GROUP_TILE_N, MMA_K)
    )

    # One K=16 slice of B determines the operand register shape.
    right_group_staging_transposed_initial_view = fx.slice(
        right_group_staging_transposed_tiled, (None, None, 0, 0)
    )

    right_group_staging2reg_copy_plan = fx.make_tiled_copy_B(copy_16b, mma)

    right_lds2reg_thread_copy = right_group_staging2reg_copy_plan.get_slice(
        thread_id_in_wave_group
    )

    right_r_tile = thread_mma.make_fragment_B(
        right_group_staging_transposed_initial_view
    )

    right_r_destination = right_lds2reg_thread_copy.retile(right_r_tile)

    def load_right_stage(tile_k, check_boundary):
        first_row = tile_k * STAGE_K + right_k_lane
        for row_slot in fx.range_constexpr(RIGHT_ROWS_PER_THREAD):
            right_row = first_row + row_slot * RIGHT_K_THREADS
            right_packed_fragment[row_slot] = _load_packed_word(
                packed_resource,
                right_row,
                global_col,
                k,
                n,
                RIGHT_CACHE_MODIFIER,
                check_boundary,
            )
        for scale_slot in fx.range_constexpr(RIGHT_SCALE_SLOTS):
            scale_row = (
                first_row + scale_slot * ROW_SLOTS_PER_SCALE * RIGHT_K_THREADS
            ) // MX_BLOCK_K
            right_scale_fragment[scale_slot] = _load_row_word(
                scale_resource,
                scale_row,
                global_col,
                SCALE_ROWS,
                n,
                RIGHT_CACHE_MODIFIER,
                check_boundary,
            )

    def load_nonempty_stage(tile_k):
        left_block_view = fx.slice(left_block_tiles, (None, None, block_row, tile_k))
        left_group_tiles = fx.flat_divide(left_block_view, (GROUP_TILE_M, STAGE_K))
        left_group_view = fx.slice(left_group_tiles, (None, None, group_row, 0))
        left_source = left_global_thread_copy.partition_S(left_group_view)

        # A complete N group can stay wide. In an earlier MX block,
        # the next rows of packed values and scales are still allocated.
        if fx.const_expr(n >= 8 and n % 2 != 0):
            full_group = (output_group_col + 1) * GROUP_TILE_N <= n
            before_final_scale = (tile_k + 1) * STAGE_K <= (SCALE_ROWS - 1) * MX_BLOCK_K
            edge = scf.IfOp(
                (full_group | before_final_scale).ir_value(), [], has_else=True
            )
            with ir.InsertionPoint(edge.then_block):
                load_right_stage(tile_k, False)
                scf.yield_([])
            with ir.InsertionPoint(edge.else_block):
                load_right_stage(tile_k, True)
                scf.yield_([])
        else:
            load_right_stage(tile_k, True)

        if fx.const_expr(HAS_K_TAIL):
            # A's extra K columns can alias the next row, including nonfinite values.
            is_k_tail = tile_k == REAL_K_STAGES - 1
            tail = scf.IfOp(is_k_tail.ir_value(), [], has_else=True)
            with ir.InsertionPoint(tail.then_block):
                coordinate_block = fx.slice(
                    left_coordinate_tiles, (None, None, block_row, tile_k)
                )
                coordinate_groups = fx.flat_divide(
                    coordinate_block, (GROUP_TILE_M, STAGE_K)
                )
                group_coordinates = fx.slice(
                    coordinate_groups, (None, None, group_row, 0)
                )
                left_global_destination.fill(0)
                if fx.const_expr(k % STAGE_K >= 8):
                    thread_coordinates = left_global_thread_copy.partition_S(
                        group_coordinates
                    )
                    _copy_valid_columns(
                        gmem_left_load,
                        left_source,
                        left_global_destination,
                        thread_coordinates,
                        k,
                        8,
                    )
                _copy_tail_segments(
                    LEFT_TAIL_SEGMENTS,
                    LEFT_CACHE_MODIFIER,
                    make_left_global_copy,
                    left_group_view,
                    group_coordinates,
                    left_staging_fragment,
                )
                scf.yield_([])
            with ir.InsertionPoint(tail.else_block):
                fx.copy(gmem_left_load, left_source, left_global_destination)
                scf.yield_([])
        else:
            fx.copy(gmem_left_load, left_source, left_global_destination)

    def load_stage(tile_k):
        if fx.const_expr(HAS_EMPTY_K_STAGES):
            # Check the stage before slicing. A singleton K-stage stride can be zero.
            stage_exists = tile_k < REAL_K_STAGES
            left_global_destination.fill(0)
            right_packed_fragment.fill(0)
            right_scale_fragment.fill(0)
            if stage_exists:
                load_nonempty_stage(tile_k)
        else:
            load_nonempty_stage(tile_k)

    def publish_stage(tile_k):
        if fx.const_expr(LEFT_IN_REGISTERS):
            # Make the prefetched A stage current within each lane. This frees
            # the staging registers for the next global load.
            fx.copy(copy_16b, left_staging_fragment, left_compute_fragment)
        else:
            fx.copy(copy_128b, left_staging_fragment, left_staging_destination)
        # Expand this lane's prefetched codes only as the B tile is published.
        for row_slot in fx.range_constexpr(RIGHT_ROWS_PER_THREAD):
            local_row = right_k_lane + row_slot * RIGHT_K_THREADS
            packed_word = fx.Uint32(right_packed_fragment[row_slot])
            scale_word = fx.Uint64(
                right_scale_fragment[row_slot // ROW_SLOTS_PER_SCALE]
            )
            if fx.const_expr(HAS_K_TAIL):
                valid_k = tile_k * STAGE_K + local_row < k
                packed_word = valid_k.select(packed_word, fx.Uint32(0))
                scale_word = valid_k.select(scale_word, fx.Uint64(0))
            even_magnitudes, odd_magnitudes = _lookup_e2m1_magnitudes(packed_word)
            right_staging_fragment = fx.make_rmem_tensor(8, fx.BFloat16)
            for value_id in fx.range_constexpr(8):
                nibble = (packed_word >> (value_id * 4)) & 15
                scale_byte = ((scale_word >> (value_id * 8)) & 255).to(fx.Int32)
                if fx.const_expr(value_id % 2 == 0):
                    magnitudes = even_magnitudes
                else:
                    magnitudes = odd_magnitudes
                doubled_magnitude = ((magnitudes >> (8 * (value_id // 2))) & 255).to(
                    fx.Int32
                )
                right_staging_fragment[value_id] = _decode_scaled_e2m1(
                    nibble, scale_byte, doubled_magnitude
                )
            right_lds_destination = fx.make_view(
                fx.get_iter(right_group_staging_view)
                + local_row * GROUP_TILE_N
                + right_col,
                fx.make_layout(8, 1),
            )
            fx.copy(copy_128b, right_staging_fragment, right_lds_destination)
        lds_barrier()

    def compute_stage():
        for inner_k in fx.range_constexpr(STAGE_K // MMA_K):
            if fx.const_expr(LEFT_IN_REGISTERS):
                # Keep the three inner axes that match left_r_tile. The outer
                # register-slot and M axes have one tile each, so only K varies.
                # The copy below moves this chunk into left_r_tile within the lane.
                left_source = fx.slice(
                    left_compute_tiled, (None, None, None, 0, 0, inner_k)
                )
            else:
                left_mma_view = fx.slice(
                    left_group_staging_tiled, (None, None, 0, inner_k)
                )
                left_source = left_lds2reg_thread_copy.partition_S(left_mma_view)
            right_mma_view = fx.slice(
                right_group_staging_transposed_tiled, (None, None, 0, inner_k)
            )
            right_source = right_lds2reg_thread_copy.partition_S(right_mma_view)
            fx.copy(copy_16b, left_source, left_r_destination)
            fx.copy(copy_16b, right_source, right_r_destination)
            fx.gemm(mma_atom, accumulator, left_r_tile, right_r_tile, accumulator)

    # Prime one stage, then prefetch the next stage before consuming the current one.
    # Equal ceiling-counted slots cover K once. Surplus stages load zeros.
    tiles_per_split = (k + STAGE_K * SPLIT_K - 1) // (STAGE_K * SPLIT_K)
    initial_tile_k = split_id * tiles_per_split
    load_stage(initial_tile_k)
    publish_stage(initial_tile_k)

    full_groups, tail_stages = divmod(tiles_per_split - 1, K_UNROLL)
    for group_k in range(full_groups):
        for step in fx.range_constexpr(K_UNROLL):
            next_tile_k = initial_tile_k + group_k * K_UNROLL + step + 1
            load_stage(next_tile_k)
            compute_stage()
            lds_barrier()
            publish_stage(next_tile_k)
    for tail in fx.range_constexpr(tail_stages):
        next_tile_k = initial_tile_k + full_groups * K_UNROLL + tail + 1
        load_stage(next_tile_k)
        compute_stage()
        lds_barrier()
        publish_stage(next_tile_k)

    # Drain the last published stage.
    compute_stage()
    lds_barrier()

    def store_output():
        out_registers = fx.make_rmem_tensor(accumulator.layout, fx.BFloat16)
        for slot in fx.range_constexpr(ACCUMULATOR_VALUES):
            out_registers[slot] = accumulator[slot].to(fx.BFloat16)
        # The MMA C plan stores into this group's selected output view.
        gmem_store_16b = fx.make_copy_atom(fx.rocdl.BufferCopy16b(), fx.BFloat16)
        reg2gmem_copy_plan = fx.make_tiled_copy_C(gmem_store_16b, mma)
        reg2gmem_thread_copy = reg2gmem_copy_plan.get_slice(thread_id_in_wave_group)
        reg2gmem_source = reg2gmem_thread_copy.retile(out_registers)
        reg2gmem_dest = reg2gmem_thread_copy.partition_D(out_group_view)
        # Complete groups store through C's descriptor, which also handles M tails.
        if fx.const_expr(HAS_N_TAIL):
            complete_n = (output_group_col + 1) * GROUP_TILE_N <= n
            n_tile = scf.IfOp(complete_n.ir_value(), [], has_else=True)
            with ir.InsertionPoint(n_tile.then_block):
                fx.copy(gmem_store_16b, reg2gmem_source, reg2gmem_dest)
                scf.yield_([])
            with ir.InsertionPoint(n_tile.else_block):
                coordinate_block = fx.slice(
                    out_coordinate_tiles, (None, None, block_row, block_col)
                )
                coordinate_groups = fx.flat_divide(
                    coordinate_block, (GROUP_TILE_M, GROUP_TILE_N)
                )
                group_coordinates = fx.slice(
                    coordinate_groups, (None, None, group_row, group_col)
                )
                output_thread_coordinates = reg2gmem_thread_copy.partition_D(
                    group_coordinates
                )
                _copy_valid_columns(
                    gmem_store_16b,
                    reg2gmem_source,
                    reg2gmem_dest,
                    output_thread_coordinates,
                    n,
                    1,
                )
                scf.yield_([])
        else:
            fx.copy(gmem_store_16b, reg2gmem_source, reg2gmem_dest)

    if SPLIT_K == 1:
        store_output()
    else:
        # Publish each thread's FP32 slots to the group's distinct split plane.
        tile_values = GROUP_TILE_M * GROUP_TILE_N
        thread_offset = thread_id_in_wave_group * ACCUMULATOR_VALUES
        partial_offset = (
            flat_group_id * SPLIT_K + split_id
        ) * tile_values + thread_offset
        partial_view = fx.make_view(
            fx.get_iter(partials) + partial_offset, accumulator.layout
        )
        copy_128b_f32 = fx.make_copy_atom(fx.UniversalCopy128b(), fx.Float32)
        fx.copy(copy_128b_f32, accumulator, partial_view)

        # One counter per (output tile, thread), shared by its split-K peers.
        # AcqRel publishes this thread's stores and acquires all earlier arrivals.
        counter_ptr = (
            fx.get_iter(counters)
            + flat_group_id * THREADS_PER_GROUP
            + thread_id_in_wave_group
        )
        arrived = fx.atomic_add(
            counter_ptr,
            1,
            ordering=fx.AtomicOrdering.AcqRel,
            syncscope=fx.rocdl.SyncScope.Agent,
        )
        last_arrival = arrived == SPLIT_K - 1
        finalizer = scf.IfOp(last_arrival.ir_value(), [], has_else=False)
        with ir.InsertionPoint(finalizer.then_block):
            # No polling: only the last thread for these output slots reduces.
            accumulator.fill(0)
            partial_registers = fx.make_fragment_like(accumulator)
            for part in fx.range_constexpr(SPLIT_K):
                source_offset = (
                    flat_group_id * SPLIT_K + part
                ) * tile_values + thread_offset
                partial_source = fx.make_view(
                    fx.get_iter(partials) + source_offset, accumulator.layout
                )
                fx.copy(copy_128b_f32, partial_source, partial_registers)
                for slot in fx.range_constexpr(ACCUMULATOR_VALUES):
                    accumulator[slot] = accumulator[slot] + partial_registers[slot]
            store_output()
            # Same-stream launches can reuse the workspace without a clear kernel.
            fx.generic_store(
                counter_ptr,
                fx.Int32(0),
                memory_order=fx.AtomicOrdering.Release,
                syncscope=fx.rocdl.SyncScope.Agent,
            )
            scf.yield_([])


@flyc.jit
def _launch_matmul_mxfp4_w4a16_fused_impl(
    left: fx.Tensor,
    packed_weights: fx.Tensor,
    scales: fx.Tensor,
    out: fx.Tensor,
    partials,
    counters,
    m: fx.Constexpr,
    n: fx.Constexpr,
    k: fx.Constexpr,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
    *,
    GROUP_TILE_M: fx.Constexpr,
    GROUP_TILE_N: fx.Constexpr,
    STAGE_K: fx.Constexpr,
    WAVES_M: fx.Constexpr,
    WAVES_N: fx.Constexpr,
    WAVE_GROUPS_M: fx.Constexpr,
    WAVE_GROUPS_N: fx.Constexpr,
    K_UNROLL: fx.Constexpr,
    RIGHT_CACHE_MODIFIER: fx.Constexpr,
    LEFT_CACHE_MODIFIER: fx.Constexpr,
    LEFT_IN_REGISTERS: fx.Constexpr,
    GROUP_M: fx.Constexpr,
    SPLIT_K: fx.Constexpr,
):
    WAVE_GROUPS = WAVE_GROUPS_M * WAVE_GROUPS_N
    BLOCK_M = GROUP_TILE_M * WAVE_GROUPS_M
    BLOCK_N = GROUP_TILE_N * WAVE_GROUPS_N
    THREADS_PER_GROUP = 32 * WAVES_M * WAVES_N
    THREADS_PER_BLOCK = THREADS_PER_GROUP * WAVE_GROUPS
    _matmul_mxfp4_w4a16_fused_impl(
        left,
        packed_weights,
        scales,
        out,
        partials,
        counters,
        m,
        n,
        k,
        GROUP_TILE_M=GROUP_TILE_M,
        GROUP_TILE_N=GROUP_TILE_N,
        STAGE_K=STAGE_K,
        WAVES_M=WAVES_M,
        WAVES_N=WAVES_N,
        WAVE_GROUPS_M=WAVE_GROUPS_M,
        WAVE_GROUPS_N=WAVE_GROUPS_N,
        K_UNROLL=K_UNROLL,
        RIGHT_CACHE_MODIFIER=RIGHT_CACHE_MODIFIER,
        LEFT_CACHE_MODIFIER=LEFT_CACHE_MODIFIER,
        LEFT_IN_REGISTERS=LEFT_IN_REGISTERS,
        GROUP_M=GROUP_M,
        SPLIT_K=SPLIT_K,
    ).launch(
        grid=(
            fx.ceildiv(m, BLOCK_M) * fx.ceildiv(n, BLOCK_N) * SPLIT_K,
            1,
            1,
        ),
        block=(THREADS_PER_BLOCK, 1, 1),
        stream=stream,
    )


def _decode_e2m1(code):
    sign = (code & 8) != 0
    exponent = (code >> 1) & 3
    mantissa = code & 1
    subnormal = mantissa.to(fx.Float32) * 0.5
    normal = (1.0 + mantissa.to(fx.Float32) * 0.5) * fx.exp2(
        exponent.to(fx.Float32) - 1.0
    )
    magnitude = (exponent == 0).select(subnormal, normal)
    return sign.select(-magnitude, magnitude)


def matmul_mxfp4_w4a16(
    activations, packed_weights, scales, *, out=None, config=None, stream=None
):
    """BF16 A times packed MXFP4 B, decoding B into LDS as WMMA consumes it."""
    for name, tensor in (
        ("activations", activations),
        ("packed_weights", packed_weights),
        ("scales", scales),
    ):
        if type(tensor) not in (torch.Tensor, torch.nn.Parameter):
            raise TypeError(f"{name} must be a torch.Tensor")
    if activations.dtype != torch.bfloat16 or not activations.is_cuda:
        raise TypeError("activations must be a BF16 ROCm GPU tensor")
    if packed_weights.dtype != torch.uint8 or scales.dtype != torch.uint8:
        raise TypeError("packed_weights and scales must use torch.uint8")
    if any(t.device != activations.device for t in (packed_weights, scales)):
        raise ValueError("all tensors must be on the same device")
    for name, tensor in (
        ("activations", activations),
        ("packed_weights", packed_weights),
        ("scales", scales),
    ):
        if (
            not tensor.is_cuda
            or tensor.layout != torch.strided
            or not tensor.is_contiguous()
        ):
            raise ValueError(f"{name} must be contiguous on a ROCm GPU")
        if tensor.is_neg():
            raise ValueError(f"{name} must not be a negative view")
        if torch.is_grad_enabled() and tensor.requires_grad:
            raise RuntimeError("matmul_mxfp4_w4a16 does not support autograd")
    if activations.ndim != 2:
        raise ValueError("activations must be a 2-D row-major matrix")
    m, k = activations.shape
    if packed_weights.ndim != 1 or scales.ndim != 2:
        raise ValueError("packed weights must be flat and scales must be 2-D")
    n = scales.shape[1]
    if packed_weights.numel() != (k * n + 1) // 2 or scales.shape != (
        (k + MX_BLOCK_K - 1) // MX_BLOCK_K,
        n,
    ):
        raise ValueError("packed weights or scale shape does not match K and N")
    shape = (m, n, k)
    if config is None:
        config = default_config(shape)
    validate_config(config, shape)
    if out is not None:
        if type(out) not in (torch.Tensor, torch.nn.Parameter):
            raise TypeError("out must be a torch.Tensor")
        if out.dtype != torch.bfloat16 or out.shape != (m, n):
            raise ValueError("out must be a BF16 matrix with shape (M,N)")
        if (
            out.device != activations.device
            or out.layout != torch.strided
            or not out.is_contiguous()
            or out.is_neg()
        ):
            raise ValueError("out must be contiguous on the input device")
        if torch.is_grad_enabled() and out.requires_grad:
            raise RuntimeError("matmul_mxfp4_w4a16 does not support autograd")
        output_start = out.data_ptr()
        output_stop = output_start + out.numel() * out.element_size()
        for name, tensor in (
            ("activations", activations),
            ("packed_weights", packed_weights),
            ("scales", scales),
        ):
            input_start = tensor.data_ptr()
            input_stop = input_start + tensor.numel() * tensor.element_size()
            if output_start < input_stop and input_start < output_stop:
                raise ValueError(f"out must not overlap {name}")
    if stream is not None and stream.device != activations.device:
        raise ValueError("stream and inputs must use the same device")
    if torch.version.hip is None:
        raise RuntimeError("This lesson requires ROCm")
    arch = torch.cuda.get_device_properties(activations.device).gcnArchName.split(":")[
        0
    ]
    if arch not in ("gfx1151", "gfx1152"):
        raise RuntimeError(
            f"This software-dequantized lesson requires gfx1151/gfx1152; detected {arch}"
        )

    supplied_out = out is not None
    with torch.cuda.device(activations.device), torch.cuda.stream(stream):
        current_stream = torch.cuda.current_stream(activations.device)
        if out is None:
            out = torch.empty((m, n), dtype=torch.bfloat16, device=activations.device)
        partials, counters = fx.Empty(), fx.Empty()
        if config.split_k > 1:
            workspace = _workspace_for(
                config,
                shape,
                activations.device,
                current_stream,
                _capture_id(current_stream),
            )
            partials, counters = (storage[:-16] for storage in workspace)
        _launch_matmul_mxfp4_w4a16_fused_impl(
            activations,
            packed_weights,
            scales,
            out,
            partials,
            counters,
            m,
            n,
            k,
            stream=fx.Stream(current_stream),
            GROUP_TILE_M=config.block_m,
            GROUP_TILE_N=config.block_n,
            STAGE_K=config.block_k,
            WAVES_M=config.waves_m,
            WAVES_N=config.waves_n,
            WAVE_GROUPS_M=config.wave_groups_m,
            WAVE_GROUPS_N=config.wave_groups_n,
            K_UNROLL=config.k_unroll,
            RIGHT_CACHE_MODIFIER=config.right_cache_modifier,
            LEFT_CACHE_MODIFIER=config.left_cache_modifier,
            LEFT_IN_REGISTERS=config.left_in_registers,
            GROUP_M=config.group_m,
            SPLIT_K=config.split_k,
        )
        if supplied_out:
            torch.autograd.graph.increment_version(out)
    return out


def quantize_mxfp4(weight_bf16):
    """Offline E2M1 encoder with block scales along K and flat nibble packing."""
    k, n = weight_bf16.shape
    if min(k, n) <= 0:
        raise ValueError("K and N must be positive")
    weights = torch.nn.functional.pad(weight_bf16.float(), (0, 0, 0, (-k) % MX_BLOCK_K))
    blocks = weights.reshape(-1, MX_BLOCK_K, n)
    maxima = blocks.abs().amax(dim=1)
    exponents = (
        torch.floor(torch.log2(maxima.masked_fill(maxima.isnan(), 0))) - 2
    ).clamp(-127, 127)
    scale = torch.exp2(exponents)
    normalized = blocks / scale[:, None, :]

    # Midpoints between E2M1 magnitudes. At a midpoint, choose the even code.
    boundaries = normalized.new_tensor([0.25, 0.75, 1.25, 1.75, 2.5, 3.5, 5.0])
    absolute = normalized.abs()
    magnitude = torch.zeros_like(absolute, dtype=torch.uint8)
    for code, midpoint in enumerate(boundaries):
        above = absolute > midpoint if code % 2 == 0 else absolute >= midpoint
        magnitude += above
    codes = magnitude | (normalized.signbit().to(torch.uint8) << 3)
    codes = codes.reshape(-1, n)[:k].reshape(-1)
    codes = torch.nn.functional.pad(codes, (0, (k * n) % 2))
    packed = codes[0::2] | (codes[1::2] << 4)
    scale_bytes = torch.where(maxima.isnan(), 255, exponents + 127).to(torch.uint8)
    dense = torch_dequantize_mxfp4(packed, scale_bytes, (k, n))
    return packed, scale_bytes, dense


def torch_dequantize_mxfp4(packed_weights, scales, shape):
    """Unpack the row-major nibbles and apply their own K-block scales."""
    k, n = shape
    codes = torch.stack((packed_weights & 15, packed_weights >> 4), dim=1)
    codes = codes.reshape(-1)[: k * n].reshape(k, n)
    levels = torch.tensor(
        [0.0, 0.5, 1.0, 1.5, 2.0, 3.0, 4.0, 6.0],
        dtype=torch.float32,
        device=packed_weights.device,
    )
    magnitudes = levels[(codes & 7).long()]
    values = torch.where((codes & 8) == 0, magnitudes, -magnitudes)
    scale = torch.exp2(scales.float() - 127)
    scale = torch.where(scales == 255, torch.nan, scale)
    scale_by_row = scale.repeat_interleave(MX_BLOCK_K, dim=0)[:k]
    return (values * scale_by_row).to(torch.bfloat16)


def _gpu_input(tensor, poison=None):
    if poison is None:
        return tensor.cuda()
    storage = torch.full(
        (tensor.numel() + 16,), poison, dtype=tensor.dtype, device="cuda"
    )
    view = storage[:-16].view(tensor.shape)
    view.copy_(tensor)
    return view


def _check_matmul(inputs, dense_cpu, config, *, poison=False):
    a_cpu, packed_cpu, scales_cpu = inputs
    a = _gpu_input(a_cpu, float("nan") if poison else None)
    packed = _gpu_input(packed_cpu, 255 if poison else None)
    scales = _gpu_input(scales_cpu, 255 if poison else None)
    m, k = a.shape
    n = scales.shape[1]
    storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device=a.device)
    out = storage[:-16].view(m, n)
    for _ in range(2):
        out.fill_(float("nan"))
        assert matmul_mxfp4_w4a16(a, packed, scales, out=out, config=config) is out
    torch.cuda.synchronize()
    expected = (a_cpu.float() @ dense_cpu.float()).to(torch.bfloat16)
    torch.testing.assert_close(
        out.cpu(), expected, rtol=0.016, atol=0.03125, equal_nan=True
    )
    assert torch.all(storage[-16:] == -99).item(), "Output sentinel changed"
    if config.split_k > 1:
        stream = torch.cuda.current_stream(a.device)
        check_workspace(
            _workspace_for(config, (m, n, k), a.device, stream, _capture_id(stream))
        )
    return out


def solve(shape=ALIGNED_SHAPES[1], seed=13, config=None, *, poison=False):
    m, n, k = shape
    generator = torch.Generator().manual_seed(seed)
    a_cpu = torch.randn((m, k), generator=generator).to(torch.bfloat16)
    b_cpu = torch.randn((k, n), generator=generator).to(torch.bfloat16)
    packed_cpu, scales_cpu, dense_cpu = quantize_mxfp4(b_cpu)
    if k % MX_BLOCK_K == 0 and n % 8 == 0 and k * n % (8 * BLOCK_THREADS) == 0:
        decoded_gpu = torch.empty((k, n), dtype=torch.bfloat16, device="cuda")
        _launch_matmul_mxfp4_w4a16(
            packed_cpu.cuda().view(torch.int32),
            scales_cpu.cuda().view(torch.int64),
            decoded_gpu,
            k,
            n,
            True,
        )
        torch.cuda.synchronize()
        torch.testing.assert_close(decoded_gpu.cpu(), dense_cpu, rtol=0, atol=0)
    if config is None:
        config = default_config(shape)
    out = _check_matmul(
        (a_cpu, packed_cpu, scales_cpu), dense_cpu, config, poison=poison
    )
    return {
        "shape_MNK": shape,
        "config": config.name,
        "first_four": out[0, :4].cpu().tolist(),
        "last_value": out[-1, -1].item(),
        "packed_bytes": packed_cpu.numel(),
        "scale_bytes": scales_cpu.numel(),
        "dense_reference_bytes": dense_cpu.numel() * dense_cpu.element_size(),
        "runtime_dense_temporary_bytes": 0,
    }


def check_edges():
    # Scale 127 keeps these E2M1 midpoints and odd codes directly visible.
    trace = torch.tensor(
        [0.5, 1.5, 3.0, 0.25, 0.75, 1.25, 1.75, 2.5, 3.5, 5.0],
        dtype=torch.bfloat16,
    ).view(-1, 1)
    packed, scales, _ = quantize_mxfp4(trace)
    assert scales.item() == 127 and packed.tolist() == [0x31, 0x05, 0x22, 0x44, 0x66]

    for registers in (True, False):
        config = Config(
            block_m=16,
            block_n=32,
            block_k=32,
            waves_n=1,
            split_k=4,
            k_unroll=2,
            left_in_registers=registers,
        )
        for suffix in range(1, 8):
            for n in (suffix, 32 + suffix):
                solve((3, n, 32 + suffix), config=config, poison=True)

        # A's first row must stay finite even though the next row contains NaN.
        a = torch.ones((2, 7), dtype=torch.bfloat16)
        a[1].fill_(float("nan"))
        packed = torch.full((32,), 0x22, dtype=torch.uint8)
        scales = torch.full((1, 9), 127, dtype=torch.uint8)
        scales[0, -1] = 255
        dense = torch_dequantize_mxfp4(packed, scales, (7, 9))
        _check_matmul((a, packed, scales), dense, config, poison=True)


def main():
    if globals().get("_COURSE_CHECK_ONLY", False):
        for shape in SHAPES:
            print("Exercise passed:", solve(shape), flush=True)
        return
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, default=SHAPES[1])
    parser.add_argument("--check-only", action="store_true")
    parser.add_argument("--edge-checks", action="store_true")
    args = parser.parse_args()
    shape = tuple(args.shape)
    if min(shape) <= 0:
        parser.error("M, N, and K must be positive")
    print("Exercise passed:", solve(shape), flush=True)
    if args.edge_checks:
        check_edges()
        print("MXFP4 edge checks passed", flush=True)
    if not args.check_only:
        benchmark = runpy.run_path(str(Path(__file__).with_name("tune.py")))
        print(benchmark["compare"](shape, default_config(shape)), flush=True)


if __name__ == "__main__":
    main()
