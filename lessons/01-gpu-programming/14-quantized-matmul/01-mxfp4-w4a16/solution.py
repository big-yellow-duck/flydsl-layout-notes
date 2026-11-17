"""14.1: unpack OCP MXFP4 weights, then use the lesson-12 W4A16 path."""

import argparse
import runpy
from dataclasses import replace
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch
from flydsl._mlir import ir
from flydsl._mlir.dialects import gpu, scf
from flydsl.expr.typing import Vector as Vec

BLOCK_THREADS = 256
SHAPES = ((16, 1024, 8192), (32, 1024, 8192), (16, 4096, 8192))
_OPERAND_PATHS = runpy.run_path(
    str(
        Path(__file__).resolve().parents[2]
        / "13-matmul"
        / "12-operand-paths"
        / "solution.py"
    )
)
Config = _OPERAND_PATHS["Config"]
BASE_CONFIGS_BY_SHAPE = dict(_OPERAND_PATHS["CONFIGS_BY_SHAPE"])
CONFIGS_BY_SHAPE = dict(BASE_CONFIGS_BY_SHAPE)
# Selected by the fused-kernel sweep on gfx1152. tune.py explores nearby configs.
CONFIGS_BY_SHAPE[(16, 1024, 8192)] = replace(
    CONFIGS_BY_SHAPE[(16, 1024, 8192)], k_unroll=2
)
CONFIGS_BY_SHAPE[(32, 1024, 8192)] = replace(
    CONFIGS_BY_SHAPE[(32, 1024, 8192)], k_unroll=2
)


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
            fx.rocdl.perm_b32(
                table_high, table_low, even_nibbles & 0x07070707
            )
        ) | ((even_nibbles & 0x08080808) << 4)
        odd_values = fx.Uint32(
            fx.rocdl.perm_b32(
                table_high, table_low, odd_nibbles & 0x07070707
            )
        ) | ((odd_nibbles & 0x08080808) << 4)
        value_words = Vec.from_elements(
            [
                fx.Uint32(
                    fx.rocdl.perm_b32(
                        odd_values, even_values, fx.Uint32(0x05010400)
                    )
                ),
                fx.Uint32(
                    fx.rocdl.perm_b32(
                        odd_values, even_values, fx.Uint32(0x07030602)
                    )
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
            scale_byte = (
                (scale_word >> fx.Uint64(value_id * 8)) & fx.Uint64(255)
            ).to(fx.Int32)
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


def _create_staging_views(
    left_model,
    BLOCK_M,
    BLOCK_N,
    BLOCK_K,
    LEFT_IN_REGISTERS,
    WAVE_GROUPS_M,
    WAVE_GROUPS_N,
    wave_row,
    wave_col,
):
    WAVE_GROUPS = WAVE_GROUPS_M * WAVE_GROUPS_N

    @fx.struct
    class SharedStorage:
        # Only B crosses LDS; A stays in each WMMA owner's registers.
        right: fx.Array[fx.BFloat16, WAVE_GROUPS * BLOCK_K * BLOCK_N, 16]

    @fx.struct
    class BothSharedStorage:
        left: fx.Array[fx.BFloat16, WAVE_GROUPS * BLOCK_M * (BLOCK_K + 8), 16]
        right: fx.Array[fx.BFloat16, WAVE_GROUPS * BLOCK_K * BLOCK_N, 16]

    if LEFT_IN_REGISTERS:
        lds = fx.SharedAllocator().allocate(SharedStorage).peek()
        left_view = left_model
    else:
        lds = fx.SharedAllocator().allocate(BothSharedStorage).peek()
        left_lds_all = lds.left.view(
            fx.make_layout(
                (WAVE_GROUPS_M, WAVE_GROUPS_N, BLOCK_M, BLOCK_K),
                (
                    WAVE_GROUPS_N * BLOCK_M * (BLOCK_K + 8),
                    BLOCK_M * (BLOCK_K + 8),
                    BLOCK_K + 8,
                    1,
                ),
            )
        )
        left_view = fx.slice(left_lds_all, (wave_row, wave_col, None, None))
    right_lds_all = lds.right.view(
        fx.make_layout(
            (WAVE_GROUPS_M, WAVE_GROUPS_N, BLOCK_K, BLOCK_N),
            (WAVE_GROUPS_N * BLOCK_K * BLOCK_N, BLOCK_K * BLOCK_N, BLOCK_N, 1),
        )
    )
    # Slice both group axes to select this group's disjoint B tile.
    right_view = fx.slice(right_lds_all, (wave_row, wave_col, None, None))
    return left_view, right_view


@flyc.kernel
def _matmul_mxfp4_w4a16_fused_impl(
    left: fx.Tensor,
    right: fx.Tensor,
    packed_weights: fx.Tensor,
    scales: fx.Tensor,
    out: fx.Tensor,
    partials,
    counters,
    m: fx.Constexpr,
    n: fx.Constexpr,
    k: fx.Constexpr,
    *,
    BLOCK_M: fx.Constexpr,
    BLOCK_N: fx.Constexpr,
    BLOCK_K: fx.Constexpr,
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
    FUSED_MXFP4: fx.Constexpr,
):
    MMA_M, MMA_N, MMA_K = 16, 16, 16
    WAVE_GROUPS = WAVE_GROUPS_M * WAVE_GROUPS_N
    PHYSICAL_M = BLOCK_M * WAVE_GROUPS_M
    PHYSICAL_N = BLOCK_N * WAVE_GROUPS_N
    THREADS_PER_GROUP = 32 * WAVES_M * WAVES_N
    wave_group = fx.thread_idx.x // THREADS_PER_GROUP
    compute_thread_id = fx.thread_idx.x % THREADS_PER_GROUP
    launch_coordinate = fx.block_idx.x * WAVE_GROUPS + wave_group
    lds_address_spaces = ir.ArrayAttr.get(
        [ir.Attribute.parse("#gpu.address_space<workgroup>")]
    )
    barrier_scope = (
        gpu.BarrierScope.Subgroup if WAVE_GROUPS > 1 else gpu.BarrierScope.Workgroup
    )

    def lds_barrier():
        # LDS-only ordering; global split-K publication keeps its agent atomics.
        fx.barrier(address_spaces=lds_address_spaces, scope=barrier_scope)

    # 1. Buffer resources retain the existing row-major matrix layouts.
    # M tails use descriptor bounds: missing A rows read zero, C stores drop.
    PADDED_M = ((m + PHYSICAL_M - 1) // PHYSICAL_M) * PHYSICAL_M
    left_buffer = fx.rocdl.make_buffer_tensor(
        left, num_records_bytes=m * k * 2 if m % PHYSICAL_M else None
    )
    out_buffer = fx.rocdl.make_buffer_tensor(
        out, num_records_bytes=m * n * 2 if m % PHYSICAL_M else None
    )
    packed_count = k * n // 2
    packed_global_view = fx.make_view(
        fx.recast_iter(fx.Uint32, fx.get_iter(packed_weights)),
        fx.make_layout(packed_count // 4, 1),
    )
    packed_global_view = fx.rocdl.make_buffer_tensor(
        packed_global_view, num_records_bytes=packed_count
    )
    scales_global_view = fx.make_view(
        fx.recast_iter(fx.Uint64, fx.get_iter(scales)),
        fx.make_layout((k // 32) * (n // 8), 1),
    )
    scales_global_view = fx.rocdl.make_buffer_tensor(
        scales_global_view, num_records_bytes=(k // 32) * n
    )
    right_buffer = fx.rocdl.make_buffer_tensor(right)
    left_global_view = fx.make_view(
        fx.get_iter(left_buffer),
        fx.make_layout((PADDED_M, k), (k, 1)),
    )
    right_global_view = fx.make_view(
        fx.get_iter(right_buffer),
        fx.make_layout((k, n), (n, 1)),
    )
    out_global_view = fx.make_view(
        fx.get_iter(out_buffer),
        fx.make_layout((PADDED_M, n), (n, 1)),
    )
    # Decode wave coordinates inside the physical block, then grouped block order.
    physical_tiles_m = PADDED_M // PHYSICAL_M
    physical_tiles_n = n // PHYSICAL_N
    tiles_m = physical_tiles_m * WAVE_GROUPS_M
    tiles_n = physical_tiles_n * WAVE_GROUPS_N
    group_width = min(GROUP_M, physical_tiles_m)
    split_block_layout = fx.make_layout(
        (
            WAVE_GROUPS_M,
            WAVE_GROUPS_N,
            group_width,
            SPLIT_K,
            physical_tiles_n,
            physical_tiles_m // group_width,
        ),
        (
            WAVE_GROUPS_N,
            1,
            WAVE_GROUPS,
            WAVE_GROUPS * group_width,
            WAVE_GROUPS * group_width * SPLIT_K,
            WAVE_GROUPS * group_width * SPLIT_K * physical_tiles_n,
        ),
    )
    split_block_coords = fx.idx2crd(launch_coordinate, split_block_layout)
    wave_row = fx.get_scalar(split_block_coords[0])
    wave_col = fx.get_scalar(split_block_coords[1])
    row_in_group = fx.get_scalar(split_block_coords[2])
    split_id = fx.get_scalar(split_block_coords[3])
    physical_block_col = fx.get_scalar(split_block_coords[4])
    group_id = fx.get_scalar(split_block_coords[5])
    physical_block_row = row_in_group + group_id * group_width
    block_row = physical_block_row * WAVE_GROUPS_M + wave_row
    block_col = physical_block_col * WAVE_GROUPS_N + wave_col
    # Workspace IDs follow output coordinates independently of launch order.
    output_tile_layout = fx.make_layout((tiles_m, tiles_n), (tiles_n, 1))
    flat_block_id = fx.get_scalar(
        fx.crd2idx((block_row, block_col), output_tile_layout)
    )

    # 2. Select the physical C region, then each wave tile; A/B use wave coordinates.
    left_tiled_view = fx.flat_divide(left_global_view, (BLOCK_M, BLOCK_K))
    right_tiled_view = fx.flat_divide(right_global_view, (BLOCK_K, BLOCK_N))
    out_tiled_view = fx.flat_divide(out_global_view, (PHYSICAL_M, PHYSICAL_N))
    out_block_view = fx.slice(
        out_tiled_view, (None, None, physical_block_row, physical_block_col)
    )
    out_wave_tiles = fx.flat_divide(out_block_view, (BLOCK_M, BLOCK_N))
    out_wave_view = fx.slice(out_wave_tiles, (None, None, wave_row, wave_col))

    # 3. Keep one packed B tile per independent wave group in LDS.
    left_global_model = fx.slice(left_tiled_view, (None, None, 0, 0))
    left_lds_view, right_lds_view = _create_staging_views(
        left_global_model,
        BLOCK_M,
        BLOCK_N,
        BLOCK_K,
        LEFT_IN_REGISTERS,
        WAVE_GROUPS_M,
        WAVE_GROUPS_N,
        wave_row,
        wave_col,
    )

    # 4. Preserve coalesced global reads for B, whose K axis is strided.
    copy_128b = fx.make_copy_atom(fx.UniversalCopy128b(), fx.BFloat16)
    staging_value_layout = fx.make_ordered_layout((1, 8), (1, 0))
    RIGHT_K_THREADS = THREADS_PER_GROUP // (BLOCK_N // 8)
    RIGHT_ROWS_PER_THREAD = BLOCK_K // RIGHT_K_THREADS
    right_k_lane = compute_thread_id // (BLOCK_N // 8)
    right_n_lane = compute_thread_id % (BLOCK_N // 8)
    gmem_right_load_128b = fx.make_copy_atom(
        fx.rocdl.BufferCopy128b(RIGHT_CACHE_MODIFIER), fx.BFloat16
    )
    right_staging_thread_layout = fx.make_ordered_layout(
        (THREADS_PER_GROUP // (BLOCK_N // 8), BLOCK_N // 8), (1, 0)
    )
    right_staging_copy_tile, right_staging_copy_tv = fx.make_layout_tv(
        right_staging_thread_layout, staging_value_layout
    )
    right_staging_copy_plan = fx.make_tiled_copy(
        copy_128b, right_staging_copy_tv, right_staging_copy_tile
    )
    right_thread_staging_copy = right_staging_copy_plan.get_slice(compute_thread_id)
    right_lds_destination = right_thread_staging_copy.partition_D(right_lds_view)
    right_staging_fragment = fx.make_fragment_like(right_lds_destination)

    # Reinterpret B as (N,K) for WMMA without moving its physical data.
    right_lds_transposed_view = fx.make_view(
        fx.get_iter(right_lds_view),
        fx.make_layout((BLOCK_N, BLOCK_K), (1, BLOCK_N)),
    )
    right_lds_transposed_tiled = fx.flat_divide(
        right_lds_transposed_view, (BLOCK_N, MMA_K)
    )

    # A single K=16 B view determines the operand register shape.
    right_lds_transposed_initial_view = fx.slice(
        right_lds_transposed_tiled, (None, None, 0, 0)
    )
    # 5. Retain native WMMA ownership and its FP32 accumulator.
    mma_atom = fx.make_mma_atom(
        fx.rocdl.WMMA(MMA_M, MMA_N, MMA_K, fx.BFloat16, fx.Float32)
    )
    mma = fx.make_tiled_mma(
        mma_atom, fx.make_layout((WAVES_M, WAVES_N, 1), (1, WAVES_M, 0))
    )

    thread_mma = mma.thr_slice(compute_thread_id)
    accumulator = thread_mma.make_fragment_C(out_wave_view)
    ACCUMULATOR_VALUES = fx.size(accumulator.shape).to_py_value()
    accumulator.fill(0)

    # B uses the existing MMA-compatible LDS copy plan.
    copy_16b = fx.make_copy_atom(fx.UniversalCopy16b(), fx.BFloat16)
    right_lds2reg_copy_plan = fx.make_tiled_copy_B(copy_16b, mma)

    right_lds2reg_thread_copy = right_lds2reg_copy_plan.get_slice(compute_thread_id)

    # A has contiguous K: partition global memory with a WMMA A copy plan.
    left_k16_model = fx.slice(
        fx.flat_divide(left_global_model, (BLOCK_M, MMA_K)), (None, None, 0, 0)
    )
    left_r_tile = thread_mma.make_fragment_A(left_k16_model)
    right_r_tile = thread_mma.make_fragment_B(right_lds_transposed_initial_view)

    right_r_destination = right_lds2reg_thread_copy.retile(right_r_tile)

    left_full_fragment = thread_mma.make_fragment_A(left_global_model)
    left_compute_fragment = fx.make_fragment_like(left_full_fragment)
    left_full_tiled = fx.flat_divide(
        left_compute_fragment, (16, BLOCK_M // (16 * WAVES_M), 1)
    )
    left_direct_atom = fx.make_copy_atom(
        fx.rocdl.BufferCopy128b(LEFT_CACHE_MODIFIER), fx.BFloat16
    )
    left_direct_plan = fx.make_tiled_copy_A(left_direct_atom, mma).get_slice(
        compute_thread_id
    )
    left_direct_destination = left_direct_plan.retile(left_full_fragment)

    # The optional A staging path is the stage-10 control, selected for wide N.
    # Clamp this unused model's thread layout in register mode, where A need
    # not satisfy cooperative staging geometry.
    LEFT_COPY_THREADS = THREADS_PER_GROUP if not LEFT_IN_REGISTERS else 32
    left_staging_thread_layout = fx.make_ordered_layout(
        (LEFT_COPY_THREADS // (BLOCK_K // 8), BLOCK_K // 8), (1, 0)
    )
    left_staging_copy_tile, left_staging_copy_tv = fx.make_layout_tv(
        left_staging_thread_layout, staging_value_layout
    )
    left_thread_staging_copy = fx.make_tiled_copy(
        copy_128b, left_staging_copy_tv, left_staging_copy_tile
    ).get_slice(compute_thread_id)
    left_lds_destination = left_thread_staging_copy.partition_D(left_lds_view)
    left_staging_fragment = fx.make_fragment_like(left_lds_destination)
    left_staging_atom = fx.make_copy_atom(
        fx.rocdl.BufferCopy128b(LEFT_CACHE_MODIFIER), fx.BFloat16
    )
    left_lds_tiled = fx.flat_divide(left_lds_view, (BLOCK_M, MMA_K))
    left_operand_plan = fx.make_tiled_copy_A(copy_16b, mma).get_slice(compute_thread_id)
    left_operand_destination = left_operand_plan.retile(left_r_tile)

    def gmem2reg_load_tile(
        tile_k,
        right_packed_fragment,
        right_scale_fragment,
        right_thread_staging_copy,
    ):
        left_block_view = fx.slice(left_tiled_view, (None, None, block_row, tile_k))
        left_direct_source = left_direct_plan.partition_S(left_block_view)
        left_global_source = left_thread_staging_copy.partition_S(left_block_view)
        if LEFT_IN_REGISTERS:
            fx.copy(left_direct_atom, left_direct_source, left_direct_destination)
        else:
            fx.copy(left_staging_atom, left_global_source, left_staging_fragment)
        if FUSED_MXFP4:
            for row_slot in fx.range_constexpr(RIGHT_ROWS_PER_THREAD):
                local_row = right_k_lane + row_slot * RIGHT_K_THREADS
                global_row = tile_k * BLOCK_K + local_row
                global_col = block_col * BLOCK_N + right_n_lane * 8
                packed_word_id = (global_row * n + global_col) // 8
                scale_word_id = (global_row // 32) * (n // 8) + global_col // 8
                right_packed_fragment[row_slot] = fx.Uint32(
                    fx.get_scalar(packed_global_view[packed_word_id])
                )
                right_scale_fragment[row_slot] = fx.Uint64(
                    fx.get_scalar(scales_global_view[scale_word_id])
                )
        else:
            right_block_view = fx.slice(
                right_tiled_view, (None, None, tile_k, block_col)
            )
            right_global_source = right_thread_staging_copy.partition_S(
                right_block_view
            )
            fx.copy(gmem_right_load_128b, right_global_source, right_staging_fragment)

    def reg2lds_copy_tile(right_packed_fragment, right_scale_fragment):
        # Advance A privately; publish only B to the shared tile.
        if LEFT_IN_REGISTERS:
            fx.copy(copy_16b, left_full_fragment, left_compute_fragment)
        else:
            fx.copy(copy_128b, left_staging_fragment, left_lds_destination)
        if FUSED_MXFP4:
            for row_slot in fx.range_constexpr(RIGHT_ROWS_PER_THREAD):
                local_row = right_k_lane + row_slot * RIGHT_K_THREADS
                local_col = right_n_lane * 8
                packed_word = right_packed_fragment[row_slot]
                scale_word = right_scale_fragment[row_slot]
                output = fx.make_rmem_tensor(8, fx.BFloat16)
                for value_id in fx.range_constexpr(8):
                    code = (packed_word >> fx.Uint32(value_id * 4)) & 15
                    magnitude = code & 7
                    scale_byte = (
                        (scale_word >> fx.Uint64(value_id * 8)) & fx.Uint64(255)
                    ).to(fx.Int32)
                    exponent = scale_byte + (magnitude >> 1).to(fx.Int32) - 1
                    is_zero = magnitude == 0
                    is_subnormal = exponent <= 0
                    is_overflow = exponent >= 255
                    sign = ((code >> 3) & 1) << 15
                    fraction = ((magnitude & 1) << 6).to(fx.Uint32)
                    fraction = (magnitude == 1).select(0, fraction)
                    significand = fx.Uint32(128) + fraction
                    subnormal_shift = (1 - exponent).to(fx.Uint32)
                    subnormal_fraction = significand >> subnormal_shift
                    fraction = is_subnormal.select(subnormal_fraction, fraction)
                    fraction = is_overflow.select(0, fraction)
                    fraction = is_zero.select(0, fraction)
                    exponent_bits = is_subnormal.select(0, exponent).to(fx.Uint32)
                    exponent_bits = is_overflow.select(255, exponent_bits)
                    exponent_bits = is_zero.select(0, exponent_bits)
                    bf16_bits = (sign | (exponent_bits << 7) | fraction).to(
                        fx.Uint16
                    )
                    output[value_id] = bf16_bits.bitcast(fx.BFloat16)
                right_lds_output = fx.make_view(
                    fx.get_iter(right_lds_view)
                    + local_row * BLOCK_N
                    + local_col,
                    fx.make_layout(8, 1),
                )
                fx.copy(copy_128b, output, right_lds_output)
        else:
            fx.copy(copy_128b, right_staging_fragment, right_lds_destination)
        lds_barrier()

    def compute_lds():
        for inner_k in fx.range_constexpr(BLOCK_K // MMA_K):
            right_mma_view = fx.slice(
                right_lds_transposed_tiled, (None, None, 0, inner_k)
            )
            right_r_source = right_lds2reg_thread_copy.partition_S(right_mma_view)
            left_current = fx.slice(left_full_tiled, (None, None, None, 0, 0, inner_k))
            left_mma_view = fx.slice(left_lds_tiled, (None, None, 0, inner_k))
            left_operand_source = left_operand_plan.partition_S(left_mma_view)
            if LEFT_IN_REGISTERS:
                fx.copy(copy_16b, left_current, left_r_tile)
            else:
                fx.copy(copy_16b, left_operand_source, left_operand_destination)
            fx.copy(copy_16b, right_r_source, right_r_destination)
            fx.gemm(mma_atom, accumulator, left_r_tile, right_r_tile, accumulator)

    # 6. Prefetch next globals while consuming the current LDS tile.
    # Prologue: make tile 0 visible in LDS before any consumer reads it.
    tiles_per_split = k // (BLOCK_K * SPLIT_K)
    initial_tile_k = split_id * tiles_per_split
    right_packed_fragment = fx.make_rmem_tensor(RIGHT_ROWS_PER_THREAD, fx.Uint32)
    right_scale_fragment = fx.make_rmem_tensor(RIGHT_ROWS_PER_THREAD, fx.Uint64)
    gmem2reg_load_tile(
        initial_tile_k,
        right_packed_fragment,
        right_scale_fragment,
        right_thread_staging_copy,
    )
    reg2lds_copy_tile(right_packed_fragment, right_scale_fragment)
    # Steady state: prefetch next globals into private registers, consume LDS,
    # protect current readers, then publish the next tile into the same LDS.
    for group_k in range((tiles_per_split - 1) // K_UNROLL):
        for step in fx.range_constexpr(K_UNROLL):
            next_tile_k = initial_tile_k + group_k * K_UNROLL + step + 1
            gmem2reg_load_tile(
                next_tile_k,
                right_packed_fragment,
                right_scale_fragment,
                right_thread_staging_copy,
            )
            compute_lds()
            lds_barrier()
            reg2lds_copy_tile(right_packed_fragment, right_scale_fragment)
    for tail in fx.range_constexpr((tiles_per_split - 1) % K_UNROLL):
        next_tile_k = (
            initial_tile_k + ((tiles_per_split - 1) // K_UNROLL) * K_UNROLL + tail + 1
        )
        gmem2reg_load_tile(
            next_tile_k,
            right_packed_fragment,
            right_scale_fragment,
            right_thread_staging_copy,
        )
        compute_lds()
        lds_barrier()
        reg2lds_copy_tile(right_packed_fragment, right_scale_fragment)
    # Drain: the final tile is already in LDS; do not read a nonexistent next tile.
    compute_lds()
    lds_barrier()

    def store_output():
        out_registers = fx.make_rmem_tensor(accumulator.layout, fx.BFloat16)
        for slot in fx.range_constexpr(ACCUMULATOR_VALUES):
            out_registers[slot] = accumulator[slot].to(fx.BFloat16)
        # Replace stage 04's one-thread output plan with the collective C plan.
        gmem_store_16b = fx.make_copy_atom(fx.rocdl.BufferCopy16b(), fx.BFloat16)
        reg2gmem_copy_plan = fx.make_tiled_copy_C(gmem_store_16b, mma)
        reg2gmem_thread_copy = reg2gmem_copy_plan.get_slice(compute_thread_id)
        reg2gmem_source = reg2gmem_thread_copy.retile(out_registers)
        reg2gmem_dest = reg2gmem_thread_copy.partition_D(out_wave_view)
        fx.copy(gmem_store_16b, reg2gmem_source, reg2gmem_dest)

    if SPLIT_K == 1:
        store_output()
    else:
        # 7. Each thread publishes its FP32 slots to a distinct split plane.
        tile_values = BLOCK_M * BLOCK_N
        thread_offset = compute_thread_id * ACCUMULATOR_VALUES
        partial_offset = (
            flat_block_id * SPLIT_K + split_id
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
            + flat_block_id * THREADS_PER_GROUP
            + compute_thread_id
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
                    flat_block_id * SPLIT_K + part
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
    BLOCK_M: fx.Constexpr,
    BLOCK_N: fx.Constexpr,
    BLOCK_K: fx.Constexpr,
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
    PHYSICAL_M = BLOCK_M * WAVE_GROUPS_M
    PHYSICAL_N = BLOCK_N * WAVE_GROUPS_N
    THREADS_PER_GROUP = 32 * WAVES_M * WAVES_N
    THREADS_PER_BLOCK = THREADS_PER_GROUP * WAVE_GROUPS
    _matmul_mxfp4_w4a16_fused_impl(
        left,
        out,
        packed_weights,
        scales,
        out,
        partials,
        counters,
        m,
        n,
        k,
        BLOCK_M=BLOCK_M,
        BLOCK_N=BLOCK_N,
        BLOCK_K=BLOCK_K,
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
        FUSED_MXFP4=True,
    ).launch(
        grid=(
            ((m + PHYSICAL_M - 1) // PHYSICAL_M) * (n // PHYSICAL_N) * SPLIT_K,
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
        if not tensor.is_cuda or tensor.layout != torch.strided or not tensor.is_contiguous():
            raise ValueError(f"{name} must be contiguous on a ROCm GPU")
        if tensor.is_neg():
            raise ValueError(f"{name} must not be a negative view")
        if torch.is_grad_enabled() and tensor.requires_grad:
            raise RuntimeError("matmul_mxfp4_w4a16 does not support autograd")
    if activations.ndim != 2:
        raise ValueError("activations must be a 2-D row-major matrix")
    m, k = activations.shape
    if k % 32:
        raise ValueError("K must be divisible by the MXFP4 block size 32")
    if packed_weights.ndim != 1 or scales.ndim != 2:
        raise ValueError("packed weights must be flat and scales must be 2-D")
    n = scales.shape[1]
    if packed_weights.numel() != (k * n) // 2 or scales.shape != (k // 32, n):
        raise ValueError("packed weights or scale shape does not match K and N")
    if n % 64 or (k * n) % 512:
        raise ValueError("N and K*N must satisfy this lesson's complete-tile layout")
    if any(not t.is_contiguous() for t in (packed_weights, scales)):
        raise ValueError("packed weights and scales must be contiguous")
    shape = (m, n, k)
    if config is None:
        config = CONFIGS_BY_SHAPE.get(shape)
        if config is None:
            raise ValueError(f"Supply a lesson-12 Config for shape M,N,K={shape}")
    _OPERAND_PATHS["validate_config"](config, shape)
    if out is not None:
        if type(out) not in (torch.Tensor, torch.nn.Parameter):
            raise TypeError("out must be a torch.Tensor")
        if out.dtype != torch.bfloat16 or out.shape != (m, n):
            raise ValueError("out must be a BF16 matrix with shape (M,N)")
        if out.device != activations.device or not out.is_contiguous():
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
    arch = torch.cuda.get_device_properties(activations.device).gcnArchName.split(":")[0]
    if arch not in ("gfx1151", "gfx1152"):
        raise RuntimeError(f"This software-dequantized lesson requires gfx1151/gfx1152; detected {arch}")

    with torch.cuda.device(activations.device), torch.cuda.stream(stream):
        current_stream = torch.cuda.current_stream(activations.device)
        if out is None:
            out = torch.empty((m, n), dtype=torch.bfloat16, device=activations.device)
        partials, counters = fx.Empty(), fx.Empty()
        if config.split_k > 1:
            workspace = _OPERAND_PATHS["_workspace_for"](
                config,
                shape,
                activations.device,
                current_stream,
                _OPERAND_PATHS["_capture_id"](current_stream),
            )
            partials, counters = (storage[:-16] for storage in workspace)
        _launch_matmul_mxfp4_w4a16_fused_impl(
            activations,
            packed_weights.view(torch.int32),
            scales.view(torch.int64),
            out,
            partials,
            counters,
            m,
            n,
            k,
            stream=fx.Stream(current_stream),
            BLOCK_M=config.block_m,
            BLOCK_N=config.block_n,
            BLOCK_K=config.block_k,
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
    return out


def quantize_mxfp4(weight_bf16):
    """Offline OCP MXFP4 reference encoder for B[K,N], block-scales along K."""
    k, n = weight_bf16.shape
    if k % 32 or n % 2:
        raise ValueError("MXFP4 weights need K divisible by 32 and even N")
    blocks = weight_bf16.float().reshape(k // 32, 32, n)
    maxima = blocks.abs().amax(dim=1)
    exponents = torch.floor(torch.log2(maxima.clamp_min(2.0**-127))) - 2
    exponents = exponents.clamp(-127, 127).to(torch.int16)
    scale = torch.exp2(exponents.float())
    normalized = (blocks / scale[:, None, :]).clamp(-6.0, 6.0)
    levels = torch.tensor(
        [0.0, 0.5, 1.0, 1.5, 2.0, 3.0, 4.0, 6.0], dtype=torch.float32
    )
    distances = (normalized.abs()[..., None] - levels).abs()
    minima = distances.amin(dim=-1, keepdim=True)
    candidate_ids = torch.arange(8).view(1, 1, 1, 8).expand_as(distances)
    tied_even_ids = torch.where(
        (distances == minima) & (candidate_ids % 2 == 0), candidate_ids, 8
    )
    magnitude_codes = tied_even_ids.amin(dim=-1).to(torch.uint8)
    codes = magnitude_codes | (normalized.signbit().to(torch.uint8) << 3)
    codes = codes.reshape(k, n).contiguous()
    packed = (codes[:, 0::2] | (codes[:, 1::2] << 4)).reshape(-1).contiguous()
    scale_bytes = (exponents + 127).to(torch.uint8).contiguous()
    dense = torch.empty((k, n), dtype=torch.float32)
    decoded_levels = levels[codes.to(torch.int64) & 7]
    decoded = torch.where((codes & 8) != 0, -decoded_levels, decoded_levels)
    decoded *= torch.exp2(exponents.float())[:, None, :].expand(-1, 32, -1).reshape(k, n)
    dense.copy_(decoded)
    return packed, scale_bytes, dense.to(torch.bfloat16)


def torch_dequantize_mxfp4(packed_weights, scales, shape):
    """Torch GPU implementation of the same MXFP4 decoding for comparisons."""
    k, n = shape
    index = torch.arange(k * n, device=packed_weights.device)
    byte = packed_weights[index // 2].to(torch.int32)
    code = torch.where((index & 1) == 0, byte & 15, byte >> 4)
    exponent = (code >> 1) & 3
    mantissa = (code & 1).float()
    magnitude = torch.where(
        exponent == 0,
        mantissa * 0.5,
        (1.0 + mantissa * 0.5) * torch.exp2(exponent.float() - 1.0),
    )
    value = torch.where((code & 8) != 0, -magnitude, magnitude)
    row, col = index // n, index % n
    scale_index = (row // 32) * n + col
    scale = torch.exp2(scales.reshape(-1)[scale_index].float() - 127.0)
    return (value * scale).to(torch.bfloat16).view(k, n)


def solve(shape=(32, 1024, 8192), seed=13):
    m, n, k = shape
    generator = torch.Generator().manual_seed(seed)
    a_cpu = torch.randn((m, k), generator=generator).to(torch.bfloat16)
    b_cpu = torch.randn((k, n), generator=generator).to(torch.bfloat16)
    packed_cpu, scales_cpu, dense_cpu = quantize_mxfp4(b_cpu)
    a = a_cpu.cuda()
    packed = packed_cpu.cuda()
    scales = scales_cpu.cuda()
    dense_gpu = torch_dequantize_mxfp4(packed, scales, (k, n))
    torch.testing.assert_close(dense_gpu.cpu(), dense_cpu, rtol=0, atol=0)
    decoded_gpu = torch.empty((k, n), dtype=torch.bfloat16, device="cuda")
    _launch_matmul_mxfp4_w4a16(
        packed.view(torch.int32),
        scales.view(torch.int64),
        decoded_gpu,
        k,
        n,
        True,
    )
    torch.cuda.synchronize()
    torch.testing.assert_close(decoded_gpu.cpu(), dense_cpu, rtol=0, atol=0)
    config = CONFIGS_BY_SHAPE[shape]
    storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
    out = storage[:-16].view(m, n)
    matmul_mxfp4_w4a16(a, packed, scales, out=out, config=config)
    torch.cuda.synchronize()
    expected = a_cpu.float() @ dense_cpu.float()
    torch.testing.assert_close(out.cpu(), expected.to(torch.bfloat16), rtol=0.016, atol=0.03125)
    assert torch.all(storage[-16:] == -99).item(), "Output sentinel changed"
    return {
        "shape_MNK": shape,
        "config": config.name,
        "first_four": out[0, :4].cpu().tolist(),
        "packed_bytes": packed.numel(),
        "scale_bytes": scales.numel(),
        "dense_reference_bytes": dense_cpu.numel() * dense_cpu.element_size(),
        "runtime_dense_temporary_bytes": 0,
    }


def main():
    if globals().get("_COURSE_CHECK_ONLY", False):
        for shape in SHAPES:
            print("Exercise passed:", solve(shape), flush=True)
        return
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, default=SHAPES[1])
    parser.add_argument("--check-only", action="store_true")
    args = parser.parse_args()
    shape = tuple(args.shape)
    if shape not in SHAPES:
        parser.error(f"Choose one of {SHAPES}")
    print("Exercise passed:", solve(shape), flush=True)
    if not args.check_only:
        benchmark = runpy.run_path(str(Path(__file__).with_name("tune.py")))
        print(benchmark["compare"](shape, CONFIGS_BY_SHAPE[shape]), flush=True)


if __name__ == "__main__":
    main()
