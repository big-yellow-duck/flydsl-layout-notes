"""14.2 practice: fuse block-scaled E4M3FN operands into BF16 WMMA on gfx11."""

import argparse
import runpy
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch
from flydsl._mlir import ir
from flydsl._mlir.dialects import gpu, scf

_MXFP4 = runpy.run_path(
    str(Path(__file__).resolve().parent.parent / "01-mxfp4-w4a16/solution.py")
)
MX_BLOCK_K = _MXFP4["MX_BLOCK_K"]
Config = _MXFP4["Config"]
_create_staging_views = _MXFP4["_create_staging_views"]
_copy_valid_columns = _MXFP4["_copy_valid_columns"]
_load_buffer_word = _MXFP4["_load_buffer_word"]
_load_tail_bytes = _MXFP4["_load_tail_bytes"]
_load_row_word = _MXFP4["_load_row_word"]
_gpu_input = _MXFP4["_gpu_input"]
_workspace_for = _MXFP4["_workspace_for"]
_capture_id = _MXFP4["_capture_id"]
check_workspace = _MXFP4["check_workspace"]

TRACE_SHAPE = (17, 77, 46)
# Selected by the gfx1151 MXFP8 sweep. See results/README.md.
CONFIGS_BY_SHAPE = {
    (17, 77, 46): Config(
        group_tile_m=16,
        group_tile_n=64,
        stage_k=64,
        waves_per_group_m=1,
        waves_per_group_n=2,
        split_k=1,
        k_unroll=2,
        right_cache_modifier=1,
        left_in_registers=False,
    ),
    (32, 1024, 8192): Config(
        group_tile_m=32,
        group_tile_n=128,
        stage_k=32,
        waves_per_group_m=1,
        waves_per_group_n=4,
        split_k=4,
        k_unroll=2,
        left_in_registers=False,
    ),
    (31, 1025, 8193): Config(
        group_tile_m=32,
        group_tile_n=128,
        stage_k=32,
        waves_per_group_m=1,
        waves_per_group_n=4,
        split_k=4,
        k_unroll=2,
        left_in_registers=False,
    ),
    (512, 512, 512): Config(
        group_tile_m=64,
        group_tile_n=64,
        stage_k=32,
        waves_per_group_m=2,
        waves_per_group_n=2,
        split_k=2,
        k_unroll=1,
        left_in_registers=False,
    ),
}
SHAPES = tuple(CONFIGS_BY_SHAPE)


def default_config(shape):
    return CONFIGS_BY_SHAPE.get(
        shape,
        Config(
            stage_k=32,
            waves_per_group_n=1,
            split_k=1,
            k_unroll=2,
            left_in_registers=False,
        ),
    )


def validate_config(config, shape):
    _MXFP4["validate_config"](config, shape)
    if config.left_in_registers:
        raise ValueError("MXFP8 decodes both operands cooperatively into LDS")


def _lookup_e4m3_subnormals(word):
    # The three mantissa bits select the high FP16 byte of an E4M3 subnormal.
    # The eight entries represent 0, 1, ..., 7 times 2^-9.
    low, high = fx.Uint32(0x1E1C1800), fx.Uint32(0x23222120)
    first = word.to(fx.Uint32) & 0x07070707
    second = (word >> 32).to(fx.Uint32) & 0x07070707
    return (
        fx.Uint32(fx.rocdl.perm_b32(high, low, first)),
        fx.Uint32(fx.rocdl.perm_b32(high, low, second)),
    )


def _subnormal_byte(table, value_id):
    # One lookup word holds four consecutive values from the staging chunk.
    return ((table[value_id // 4] >> (8 * (value_id % 4))) & 255).to(fx.Int32)


def _decode_scaled_e4m3(code, scale_byte, subnormal_byte):
    """Expand E4M3 exactly to FP16, then apply the scale in FP32."""
    magnitude = (code & 127).to(fx.Int32)
    normal_bits = ((15 - 7) << 10) + (magnitude << 7)
    value_bits = (magnitude < 8).select(subnormal_byte << 8, normal_bits)
    value_bits = (magnitude == 127).select(0x7E00, value_bits)
    sign = (code & 128).to(fx.Int32) << 8
    value = (value_bits | sign).to(fx.Uint16).bitcast(fx.Float16).to(fx.Float32)

    # E8M0 byte 0 is 2^-127, a subnormal in FP32. Byte 255 is NaN.
    scale_bits = (scale_byte == 0).select(0x00400000, scale_byte << 23)
    scale_bits = (scale_byte == 255).select(0x7FC00000, scale_bits)
    scale = scale_bits.bitcast(fx.Float32)
    return (value * scale).to(fx.BFloat16)


def _load_left_tail(resource, row, column, m, k, cache_modifier):
    # Unlike B's N edge, a partial K chunk cannot borrow the next row.
    offset = row * k + column
    complete = column + 8 <= k
    edge = scf.IfOp(complete.ir_value(), [fx.Uint64.ir_type], has_else=True)
    with ir.InsertionPoint(edge.then_block):
        word = _load_buffer_word(resource, offset, fx.Uint64, cache_modifier)
        scf.yield_([word.ir_value()])
    with ir.InsertionPoint(edge.else_block):
        if k % 8:
            valid_suffix = (column == k // 8 * 8) & (row < m)
            suffix_offset = valid_suffix.select(offset, m * k)
            word = _load_tail_bytes(
                resource, suffix_offset, k % 8, fx.Uint64, cache_modifier
            )
        else:
            word = fx.Uint64(0)
        scf.yield_([word.ir_value()])
    return fx.Uint64(edge.results[0])


@flyc.kernel
def _matmul_mxfp8(
    left: fx.Tensor,
    right: fx.Tensor,
    left_scales: fx.Tensor,
    right_scales: fx.Tensor,
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

    # 1. The source descriptors bound the four compact allocations.
    left_resource = fx.rocdl.get_buffer_rsrc(
        fx.rocdl.make_buffer_ptr(fx.get_iter(left), num_records_bytes=m * k)
    )
    right_resource = fx.rocdl.get_buffer_rsrc(
        fx.rocdl.make_buffer_ptr(fx.get_iter(right), num_records_bytes=k * n)
    )
    SCALE_ROWS = (k + MX_BLOCK_K - 1) // MX_BLOCK_K
    left_scale_resource = fx.rocdl.get_buffer_rsrc(
        fx.rocdl.make_buffer_ptr(
            fx.get_iter(left_scales), num_records_bytes=m * SCALE_ROWS
        )
    )
    right_scale_resource = fx.rocdl.get_buffer_rsrc(
        fx.rocdl.make_buffer_ptr(
            fx.get_iter(right_scales), num_records_bytes=SCALE_ROWS * n
        )
    )
    out_buffer = fx.rocdl.make_buffer_tensor(out, max_size=False)
    out_global_view = fx.make_view(
        fx.get_iter(out_buffer), fx.make_layout((m, n), (n, 1))
    )
    REAL_K_STAGES = (k + STAGE_K - 1) // STAGE_K
    HAS_EMPTY_K_STAGES = REAL_K_STAGES % SPLIT_K != 0
    HAS_K_TAIL = k % STAGE_K != 0
    HAS_N_TAIL = n % BLOCK_N != 0
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

    mma_atom = fx.make_mma_atom(
        fx.rocdl.WMMA(MMA_M, MMA_N, MMA_K, fx.BFloat16, fx.Float32)
    )
    mma = fx.make_tiled_mma(
        mma_atom, fx.make_layout((WAVES_M, WAVES_N, 1), (1, WAVES_M, 0))
    )
    copy_128b = fx.make_copy_atom(fx.UniversalCopy128b(), fx.BFloat16)
    copy_16b = fx.make_copy_atom(fx.UniversalCopy16b(), fx.BFloat16)

    # 3. Each independent group owns padded A and row-major B in LDS.
    left_group_staging_view, right_group_staging_view = _create_staging_views(
        None,
        GROUP_TILE_M,
        GROUP_TILE_N,
        STAGE_K,
        False,
        WAVE_GROUPS_M,
        WAVE_GROUPS_N,
        group_row,
        group_col,
    )

    thread_mma = mma.thr_slice(thread_id_in_wave_group)
    accumulator = thread_mma.make_fragment_C(out_group_view)
    ACCUMULATOR_VALUES = fx.size(accumulator.shape).to_py_value()
    accumulator.fill(0)

    # Staging ownership. Every lane loads eight contiguous FP8 bytes per chunk.
    LEFT_K_THREADS = STAGE_K // 8
    LEFT_M_THREADS = THREADS_PER_GROUP // LEFT_K_THREADS
    LEFT_ROWS_PER_THREAD = GROUP_TILE_M // LEFT_M_THREADS
    left_m_lane = thread_id_in_wave_group // LEFT_K_THREADS
    left_k_col = thread_id_in_wave_group % LEFT_K_THREADS * 8
    left_codes = fx.make_rmem_tensor(LEFT_ROWS_PER_THREAD, fx.Uint64)
    left_scale_bytes = fx.make_rmem_tensor(LEFT_ROWS_PER_THREAD, fx.Uint8)

    RIGHT_N_THREADS = GROUP_TILE_N // 8
    RIGHT_K_THREADS = THREADS_PER_GROUP // RIGHT_N_THREADS
    RIGHT_ROWS_PER_THREAD = STAGE_K // RIGHT_K_THREADS
    right_k_lane = thread_id_in_wave_group // RIGHT_N_THREADS
    right_n_col = thread_id_in_wave_group % RIGHT_N_THREADS * 8
    global_n_col = output_group_col * GROUP_TILE_N + right_n_col
    if fx.const_expr(STAGE_K in (16, 32)):
        ROW_SLOTS_PER_SCALE = RIGHT_ROWS_PER_THREAD
    elif fx.const_expr(STAGE_K % MX_BLOCK_K == 0 and MX_BLOCK_K % RIGHT_K_THREADS == 0):
        ROW_SLOTS_PER_SCALE = MX_BLOCK_K // RIGHT_K_THREADS
    else:
        ROW_SLOTS_PER_SCALE = 1
    RIGHT_SCALE_SLOTS = RIGHT_ROWS_PER_THREAD // ROW_SLOTS_PER_SCALE
    right_codes = fx.make_rmem_tensor(RIGHT_ROWS_PER_THREAD, fx.Uint64)
    right_scale_words = fx.make_rmem_tensor(RIGHT_SCALE_SLOTS, fx.Uint64)

    # MMA copies for A and B.
    left_group_staging_tiled = fx.flat_divide(
        left_group_staging_view, (GROUP_TILE_M, MMA_K)
    )
    left_group_staging_mma_initial_view = fx.slice(
        left_group_staging_tiled, (None, None, 0, 0)
    )
    # WMMA consumes one MMA_K step at a time.
    left_r_tile = thread_mma.make_fragment_A(left_group_staging_mma_initial_view)
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

    def load_left_stage(tile_k, is_tail):
        column = tile_k * STAGE_K + left_k_col
        for row_slot in fx.range_constexpr(LEFT_ROWS_PER_THREAD):
            local_row = left_m_lane + row_slot * LEFT_M_THREADS
            row = output_group_row * GROUP_TILE_M + local_row
            if fx.const_expr(is_tail):
                word = _load_left_tail(
                    left_resource, row, column, m, k, LEFT_CACHE_MODIFIER
                )
            else:
                word = _load_buffer_word(
                    left_resource, row * k + column, fx.Uint64, LEFT_CACHE_MODIFIER
                )
            left_codes[row_slot] = word
            # TODO 1: Select the A row and the K scale block. See README.md.
            scale_offset = None
            if scale_offset is None:
                raise NotImplementedError("Fill in scale_offset.")
            left_scale_bytes[row_slot] = _load_buffer_word(
                left_scale_resource, scale_offset, fx.Uint8, LEFT_CACHE_MODIFIER
            )

    def load_right_stage(tile_k, check_boundary):
        first_row = tile_k * STAGE_K + right_k_lane
        for row_slot in fx.range_constexpr(RIGHT_ROWS_PER_THREAD):
            row = first_row + row_slot * RIGHT_K_THREADS
            right_codes[row_slot] = _load_row_word(
                right_resource,
                row,
                global_n_col,
                k,
                n,
                RIGHT_CACHE_MODIFIER,
                check_boundary,
            )
        for scale_slot in fx.range_constexpr(RIGHT_SCALE_SLOTS):
            # TODO 2: Select the K block for this B scale word. See README.md.
            scale_row = None
            if scale_row is None:
                raise NotImplementedError("Fill in scale_row.")
            right_scale_words[scale_slot] = _load_row_word(
                right_scale_resource,
                scale_row,
                global_n_col,
                SCALE_ROWS,
                n,
                RIGHT_CACHE_MODIFIER,
                check_boundary,
            )

    def load_nonempty_stage(tile_k):
        if fx.const_expr(HAS_K_TAIL):
            last_stage = tile_k == REAL_K_STAGES - 1
            edge = scf.IfOp(last_stage.ir_value(), [], has_else=True)
            with ir.InsertionPoint(edge.then_block):
                load_left_stage(tile_k, True)
                scf.yield_([])
            with ir.InsertionPoint(edge.else_block):
                load_left_stage(tile_k, False)
                scf.yield_([])
        else:
            load_left_stage(tile_k, False)

        # A complete N group can stay wide. In an earlier MX block,
        # the next rows of packed values and scales are still allocated.
        if fx.const_expr(n >= 8 and n % 8 != 0):
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

    def load_stage(tile_k):
        if fx.const_expr(HAS_EMPTY_K_STAGES):
            stage_exists = tile_k < REAL_K_STAGES
            left_codes.fill(0)
            left_scale_bytes.fill(0)
            right_codes.fill(0)
            right_scale_words.fill(0)
            if stage_exists:
                load_nonempty_stage(tile_k)
        else:
            load_nonempty_stage(tile_k)

    def publish_stage(tile_k):
        # Eight A bytes share one scale along K. Each B byte has its own
        # column scale, which rows in the same 32-K block reuse.
        for row_slot in fx.range_constexpr(LEFT_ROWS_PER_THREAD):
            local_row = left_m_lane + row_slot * LEFT_M_THREADS
            word = fx.Uint64(left_codes[row_slot])
            scale_byte = fx.Uint8(left_scale_bytes[row_slot]).to(fx.Int32)
            subnormals = _lookup_e4m3_subnormals(word)
            left_staging_fragment = fx.make_rmem_tensor(8, fx.BFloat16)
            for value_id in fx.range_constexpr(8):
                code = (word >> (8 * value_id)).to(fx.Uint8)
                value = _decode_scaled_e4m3(
                    code, scale_byte, _subnormal_byte(subnormals, value_id)
                )
                if fx.const_expr(HAS_K_TAIL):
                    valid_k = tile_k * STAGE_K + left_k_col + value_id < k
                    value = valid_k.select(value, fx.BFloat16(0))
                left_staging_fragment[value_id] = value
            left_lds_destination = fx.make_view(
                fx.get_iter(left_group_staging_view)
                + local_row * (STAGE_K + 8)
                + left_k_col,
                fx.make_layout(8, 1),
            )
            fx.copy(copy_128b, left_staging_fragment, left_lds_destination)

        for row_slot in fx.range_constexpr(RIGHT_ROWS_PER_THREAD):
            local_row = right_k_lane + row_slot * RIGHT_K_THREADS
            word = fx.Uint64(right_codes[row_slot])
            scale_word = fx.Uint64(right_scale_words[row_slot // ROW_SLOTS_PER_SCALE])
            if fx.const_expr(HAS_K_TAIL):
                valid_k = tile_k * STAGE_K + local_row < k
                word = valid_k.select(word, fx.Uint64(0))
                scale_word = valid_k.select(scale_word, fx.Uint64(0))
            subnormals = _lookup_e4m3_subnormals(word)
            right_staging_fragment = fx.make_rmem_tensor(8, fx.BFloat16)
            for value_id in fx.range_constexpr(8):
                code = (word >> (8 * value_id)).to(fx.Uint8)
                scale_byte = (scale_word >> (8 * value_id)).to(fx.Uint8).to(fx.Int32)
                right_staging_fragment[value_id] = _decode_scaled_e4m3(
                    code, scale_byte, _subnormal_byte(subnormals, value_id)
                )
            right_lds_destination = fx.make_view(
                fx.get_iter(right_group_staging_view)
                + local_row * GROUP_TILE_N
                + right_n_col,
                fx.make_layout(8, 1),
            )
            fx.copy(copy_128b, right_staging_fragment, right_lds_destination)
        lds_barrier()

    def compute_stage():
        for inner_k in fx.range_constexpr(STAGE_K // MMA_K):
            left_mma_view = fx.slice(left_group_staging_tiled, (None, None, 0, inner_k))
            right_mma_view = fx.slice(
                right_group_staging_transposed_tiled, (None, None, 0, inner_k)
            )
            left_source = left_lds2reg_thread_copy.partition_S(left_mma_view)
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
def _launch_matmul_mxfp8(
    left: fx.Tensor,
    right: fx.Tensor,
    left_scales: fx.Tensor,
    right_scales: fx.Tensor,
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
    GROUP_M: fx.Constexpr,
    SPLIT_K: fx.Constexpr,
):
    WAVE_GROUPS = WAVE_GROUPS_M * WAVE_GROUPS_N
    BLOCK_M = GROUP_TILE_M * WAVE_GROUPS_M
    BLOCK_N = GROUP_TILE_N * WAVE_GROUPS_N
    THREADS_PER_GROUP = 32 * WAVES_M * WAVES_N
    THREADS_PER_BLOCK = THREADS_PER_GROUP * WAVE_GROUPS
    _matmul_mxfp8(
        left,
        right,
        left_scales,
        right_scales,
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


def matmul_mxfp8(
    left, right, left_scales, right_scales, *, out=None, config=None, stream=None
):
    """Multiply row-major E4M3FN A and B with E8M0 scales along K."""
    tensors = (
        ("left", left),
        ("right", right),
        ("left_scales", left_scales),
        ("right_scales", right_scales),
    )
    for name, tensor in tensors:
        if (
            type(tensor) not in (torch.Tensor, torch.nn.Parameter)
            or tensor.dtype != torch.uint8
        ):
            raise TypeError(f"{name} must be a uint8 byte tensor")
        if (
            tensor.ndim != 2
            or not tensor.is_cuda
            or tensor.layout != torch.strided
            or not tensor.is_contiguous()
        ):
            raise ValueError(f"{name} must be a contiguous ROCm GPU matrix")
        if tensor.is_neg() or tensor.device != left.device:
            raise ValueError(
                f"{name} must be on the input device with ordinary strides"
            )
    m, k = left.shape
    other_k, n = right.shape
    if k != other_k or min(m, n, k) <= 0:
        raise ValueError(
            "M, N and K must be positive and the reduction axes must match"
        )
    scale_rows = (k + MX_BLOCK_K - 1) // MX_BLOCK_K
    if left_scales.shape != (m, scale_rows) or right_scales.shape != (scale_rows, n):
        raise ValueError("Expected scale shapes (M, ceil(K/32)) and (ceil(K/32), N)")
    if torch.version.hip is None:
        raise RuntimeError("This lesson requires ROCm")
    arch = torch.cuda.get_device_properties(left.device).gcnArchName.split(":")[0]
    if arch not in ("gfx1151", "gfx1152"):
        raise RuntimeError(f"This lesson requires gfx1151/gfx1152; detected {arch}")
    shape = (m, n, k)
    if config is None:
        config = default_config(shape)
    if not isinstance(config, Config):
        raise TypeError("config must be a Config")
    validate_config(config, shape)
    if stream is not None and stream.device != left.device:
        raise ValueError("stream and inputs must use the same device")

    supplied_out = out is not None
    if supplied_out:
        if (
            type(out) not in (torch.Tensor, torch.nn.Parameter)
            or out.dtype != torch.bfloat16
        ):
            raise TypeError("out must be a BF16 tensor")
        if (
            out.shape != (m, n)
            or out.layout != torch.strided
            or not out.is_contiguous()
            or out.device != left.device
            or out.is_neg()
        ):
            raise ValueError(
                "out must be a contiguous (M,N) matrix on the input device"
            )
        if torch.is_grad_enabled() and out.requires_grad:
            raise RuntimeError("matmul_mxfp8 does not support autograd")
        start = out.data_ptr()
        stop = start + out.nbytes
        for name, tensor in tensors:
            address = tensor.data_ptr()
            if start < address + tensor.nbytes and address < stop:
                raise ValueError(f"out must not overlap {name}")

    with torch.cuda.device(left.device), torch.cuda.stream(stream):
        current_stream = torch.cuda.current_stream(left.device)
        if out is None:
            out = torch.empty((m, n), dtype=torch.bfloat16, device=left.device)
        partials, counters = fx.Empty(), fx.Empty()
        if config.split_k > 1:
            workspace = _workspace_for(
                config, shape, left.device, current_stream, _capture_id(current_stream)
            )
            partials, counters = (storage[:-16] for storage in workspace)
        _launch_matmul_mxfp8(
            left,
            right,
            left_scales,
            right_scales,
            out,
            partials,
            counters,
            *shape,
            fx.Stream(current_stream),
            GROUP_TILE_M=config.group_tile_m,
            GROUP_TILE_N=config.group_tile_n,
            STAGE_K=config.stage_k,
            WAVES_M=config.waves_per_group_m,
            WAVES_N=config.waves_per_group_n,
            WAVE_GROUPS_M=config.wave_groups_m,
            WAVE_GROUPS_N=config.wave_groups_n,
            K_UNROLL=config.k_unroll,
            RIGHT_CACHE_MODIFIER=config.right_cache_modifier,
            LEFT_CACHE_MODIFIER=config.left_cache_modifier,
            GROUP_M=config.traversal_group_m,
            SPLIT_K=config.split_k,
        )
        if supplied_out:
            torch.autograd.graph.increment_version(out)
    return out


def torch_dequantize_mxfp8(values, scales):
    """Decode a [K, columns] byte matrix with a scale per K block and column."""
    k = values.shape[0]
    base = values.view(torch.float8_e4m3fn).float()
    scale = torch.exp2(scales.float() - 127)
    scale = torch.where(scales == 255, torch.nan, scale)
    return (base * scale.repeat_interleave(MX_BLOCK_K, dim=0)[:k]).bfloat16()


def quantize_mxfp8(values):
    """Offline E4M3FN encoder for the same [K, columns] layout."""
    k, columns = values.shape
    padded = torch.nn.functional.pad(values.float(), (0, 0, 0, (-k) % MX_BLOCK_K))
    blocks = padded.reshape(-1, MX_BLOCK_K, columns)
    maxima = blocks.abs().amax(dim=1)
    exponent = (
        torch.floor(torch.log2(maxima.masked_fill(maxima.isnan(), 0))) - 8
    ).clamp(-127, 127)
    normalized = (blocks / torch.exp2(exponent[:, None, :])).clamp(-448, 448)
    encoded = normalized.reshape(-1, columns)[:k].to(torch.float8_e4m3fn)
    data = encoded.view(torch.uint8).contiguous()
    scales = torch.where(maxima.isnan(), 255, exponent + 127).to(torch.uint8)
    return data, scales, torch_dequantize_mxfp8(data, scales)


def make_inputs(shape, seed):
    m, n, k = shape
    generator = torch.Generator().manual_seed(seed)
    left = torch.randn((m, k), generator=generator).bfloat16()
    right = torch.randn((k, n), generator=generator).bfloat16()
    a, a_scales, dense_a = quantize_mxfp8(left.T)
    b, b_scales, dense_b = quantize_mxfp8(right)
    a, a_scales, dense_a = (
        a.T.contiguous(),
        a_scales.T.contiguous(),
        dense_a.T.contiguous(),
    )
    expected = (dense_a.float() @ dense_b.float()).bfloat16()
    return (a, b, a_scales, b_scales), dense_a, dense_b, expected


def _check_matmul(quantized, expected, config, *, poison=False):
    a, b, a_scales, b_scales = (
        _gpu_input(tensor, 255 if poison else None) for tensor in quantized
    )
    m, k = a.shape
    n = b.shape[1]
    storage = torch.full((m * n + 16,), -99.0, dtype=torch.bfloat16, device=a.device)
    output = storage[:-16].view(m, n)
    for _ in range(2):
        output.fill_(float("nan"))
        assert (
            matmul_mxfp8(a, b, a_scales, b_scales, out=output, config=config) is output
        )
    torch.cuda.synchronize()
    torch.testing.assert_close(
        output.cpu(), expected, rtol=0.016, atol=0.03125, equal_nan=True
    )
    assert torch.all(storage[-16:] == -99).item(), "Output sentinel changed"
    if config.split_k > 1:
        stream = torch.cuda.current_stream(a.device)
        check_workspace(
            _workspace_for(config, (m, n, k), a.device, stream, _capture_id(stream))
        )
    return output


def solve(shape=TRACE_SHAPE, seed=13, config=None, *, poison=False):
    quantized, _, _, expected = make_inputs(shape, seed)
    if config is None:
        config = default_config(shape)
    output = _check_matmul(quantized, expected, config, poison=poison)
    a, b, a_scales, b_scales = quantized
    return {
        "shape_MNK": shape,
        "config": config.name,
        "first_four": output[0, :4].cpu().tolist(),
        "last_value": output[-1, -1].item(),
        "activation_bytes": a.numel() + a_scales.numel(),
        "weight_bytes": b.numel() + b_scales.numel(),
        "runtime_dense_temporary_bytes": 0,
    }


def check_edges():
    config = CONFIGS_BY_SHAPE[TRACE_SHAPE]
    for suffix in range(1, 8):
        for n in (suffix, 64 + suffix):
            solve((3, n, 32 + suffix), config=config, poison=True)

    a = torch.full((2, 7), 0x38, dtype=torch.uint8)
    a[1, 0] = 0x7F  # E4M3FN NaN in the next row.
    b = torch.full((7, 9), 0x38, dtype=torch.uint8)
    a_scales = torch.full((2, 1), 127, dtype=torch.uint8)
    b_scales = torch.full((1, 9), 127, dtype=torch.uint8)
    b_scales[0, -1] = 255  # This last column alone uses a NaN scale.
    dense_a = torch_dequantize_mxfp8(a.T, a_scales.T).T
    dense_b = torch_dequantize_mxfp8(b, b_scales)
    expected = (dense_a.float() @ dense_b.float()).bfloat16()
    _check_matmul((a, b, a_scales, b_scales), expected, config, poison=True)


def main():
    course = globals().get("_COURSE_CHECK_ONLY", False)
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, default=TRACE_SHAPE)
    parser.add_argument("--check-only", action="store_true")
    parser.add_argument("--edge-checks", action="store_true")
    args = parser.parse_args([] if course else None)
    shapes = SHAPES if course else (tuple(args.shape),)
    for shape in shapes:
        if min(shape) <= 0:
            parser.error("M, N and K must be positive")
        print("Exercise passed:", solve(shape), flush=True)
    if args.edge_checks:
        check_edges()
        print("MXFP8 edge checks passed", flush=True)
    if not course and not args.check_only:
        benchmark = runpy.run_path(str(Path(__file__).with_name("tune.py")))
        print(benchmark["compare"](shape), flush=True)


if __name__ == "__main__":
    try:
        main()
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None
