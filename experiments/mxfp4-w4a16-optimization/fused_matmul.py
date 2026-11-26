"""12: keep A in WMMA registers while staging B through LDS. See README.md."""

import argparse
import ctypes
import json
import runpy
from dataclasses import dataclass
from functools import lru_cache
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch
from flydsl._mlir import ir
from flydsl._mlir.dialects import gpu, scf


@dataclass(frozen=True)
class Config:
    block_m: int = 16
    block_n: int = 64
    block_k: int = 64
    waves_m: int = 1
    waves_n: int = 2
    group_m: int = 1
    split_k: int = 4
    wave_groups_m: int = 1
    wave_groups_n: int = 1
    k_unroll: int = 8
    right_cache_modifier: int = 2
    left_cache_modifier: int = 0
    left_in_registers: bool = True

    @property
    def name(self):
        return f"m{self.block_m}n{self.block_n}k{self.block_k}_w{self.waves_m}x{self.waves_n}_prefetch_lds1_gm{self.group_m}_sk{self.split_k}_wg{self.wave_groups_m}x{self.wave_groups_n}_u{self.k_unroll}_ac{self.left_cache_modifier}_bc{self.right_cache_modifier}_ar{int(self.left_in_registers)}"

    @property
    def wave_groups(self):
        return self.wave_groups_m * self.wave_groups_n

    @classmethod
    def from_dict(cls, values):
        """Read current configurations and archived scalar N-group selections."""
        values = dict(values)
        for current, old in {
            "group_tile_m": "block_m",
            "group_tile_n": "block_n",
            "stage_k": "block_k",
            "waves_per_group_m": "waves_m",
            "waves_per_group_n": "waves_n",
            "traversal_group_m": "group_m",
        }.items():
            if current in values:
                values.setdefault(old, values.pop(current))
        if "wave_groups" in values:
            values["wave_groups_n"] = values.pop("wave_groups")
        return cls(**values)

    @property
    def compute_threads(self):
        return 32 * self.waves_m * self.waves_n

    @property
    def threads(self):
        return self.compute_threads * self.wave_groups

    @property
    def accumulator_values(self):
        return (
            8
            * (self.block_m // (16 * self.waves_m))
            * (self.block_n // (16 * self.waves_n))
        )

    @property
    def lds_bytes(self):
        left_values = 0 if self.left_in_registers else self.block_m * (self.block_k + 8)
        return 2 * self.wave_groups * (left_values + self.block_k * self.block_n)


def validate_config(config, shape=(16, 1024, 8192)):
    bm, bn, bk = config.block_m, config.block_n, config.block_k
    if any(value <= 0 for value in (bm, bn, bk)):
        raise ValueError("Block dimensions must be positive")
    if len(shape) != 3 or any(value <= 0 for value in shape):
        raise ValueError("Shape must contain positive M,N,K")
    if any(size % tile for size, tile in zip(shape[1:], (bn, bk), strict=True)):
        raise ValueError("N and K must contain complete block tiles")
    if config.split_k not in (1, 2, 4):
        raise ValueError("split_k must be 1, 2, or 4")
    if shape[2] % (bk * config.split_k):
        raise ValueError("K must contain complete, equal split-K partitions")
    if (
        config.waves_m < 1
        or config.waves_n < 1
        or config.threads not in (32, 64, 128, 256)
    ):
        raise ValueError("Use one, two, four, or eight wave32 groups")
    if bm % (16 * config.waves_m) or bn % (16 * config.waves_n) or bk % 16:
        raise ValueError("Block tile must contain whole WMMA groups and K fragments")
    if any(
        value not in (1, 2) for value in (config.wave_groups_m, config.wave_groups_n)
    ):
        raise ValueError("Each wave-group dimension must be 1 or 2")
    if config.wave_groups > 1 and config.compute_threads != 32:
        raise ValueError("Independent groups each contain exactly one wave32")
    if config.k_unroll not in (1, 2, 4, 8, 16):
        raise ValueError("k_unroll must be 1, 2, 4, 8, or 16")
    if config.right_cache_modifier not in range(
        8
    ) or config.left_cache_modifier not in range(8):
        raise ValueError("gfx11 cache modifiers must fit three bits")
    physical_m = bm * config.wave_groups_m
    physical_n = bn * config.wave_groups_n
    if shape[1] % physical_n:
        raise ValueError("N must contain complete physical block tiles")
    staging_tiles = ((bk, bn),) if config.left_in_registers else ((bm, bk), (bk, bn))
    for rows, columns in staging_tiles:
        chunks = columns // 8
        if (
            columns % 8
            or chunks > config.compute_threads
            or config.compute_threads % chunks
        ):
            raise ValueError("Copy geometry must distribute aligned eight-BF16 chunks")
        if rows % (config.compute_threads // chunks):
            raise ValueError(
                "Every cooperative staging thread must own complete chunks"
            )
    if config.group_m < 1:
        raise ValueError("group_m must be positive")
    tile_rows = (shape[0] + physical_m - 1) // physical_m
    if tile_rows % min(config.group_m, tile_rows):
        raise ValueError("group_m must form complete physical block row groups")
    if config.lds_bytes > 65536:
        raise ValueError("LDS allocation exceeds this lesson's 64 KiB limit")
    return config


def _create_staging_views(
    a_model,
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
        b: fx.Array[fx.BFloat16, WAVE_GROUPS * BLOCK_K * BLOCK_N, 16]

    @fx.struct
    class BothSharedStorage:
        a: fx.Array[fx.BFloat16, WAVE_GROUPS * BLOCK_M * (BLOCK_K + 8), 16]
        b: fx.Array[fx.BFloat16, WAVE_GROUPS * BLOCK_K * BLOCK_N, 16]

    if LEFT_IN_REGISTERS:
        lds = fx.SharedAllocator().allocate(SharedStorage).peek()
        a_view = a_model
    else:
        lds = fx.SharedAllocator().allocate(BothSharedStorage).peek()
        a_lds_all = lds.a.view(
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
        a_view = fx.slice(a_lds_all, (wave_row, wave_col, None, None))
    b_lds_all = lds.b.view(
        fx.make_layout(
            (WAVE_GROUPS_M, WAVE_GROUPS_N, BLOCK_K, BLOCK_N),
            (WAVE_GROUPS_N * BLOCK_K * BLOCK_N, BLOCK_K * BLOCK_N, BLOCK_N, 1),
        )
    )
    # Slice both group axes to select this group's disjoint B tile.
    b_view = fx.slice(b_lds_all, (wave_row, wave_col, None, None))
    return a_view, b_view


@flyc.kernel
def _matmul_w4a16(
    a: fx.Tensor,
    b: fx.Tensor,
    b_packed: fx.Tensor,
    b_scales: fx.Tensor,
    c: fx.Tensor,
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
    a_buffer = fx.rocdl.make_buffer_tensor(
        a, num_records_bytes=m * k * 2 if m % PHYSICAL_M else None
    )
    c_buffer = fx.rocdl.make_buffer_tensor(
        c, num_records_bytes=m * n * 2 if m % PHYSICAL_M else None
    )
    b_packed_count = k * n // 2
    packed_global_view = fx.make_view(
        fx.recast_iter(fx.Uint32, fx.get_iter(b_packed)),
        fx.make_layout(b_packed_count // 4, 1),
    )
    packed_global_view = fx.rocdl.make_buffer_tensor(
        packed_global_view, num_records_bytes=b_packed_count
    )
    scales_global_view = fx.make_view(
        fx.recast_iter(fx.Uint64, fx.get_iter(b_scales)),
        fx.make_layout((k // 32) * (n // 8), 1),
    )
    scales_global_view = fx.rocdl.make_buffer_tensor(
        scales_global_view, num_records_bytes=(k // 32) * n
    )
    b_buffer = fx.rocdl.make_buffer_tensor(b)
    a_global_view = fx.make_view(
        fx.get_iter(a_buffer),
        fx.make_layout((PADDED_M, k), (k, 1)),
    )
    b_global_view = fx.make_view(
        fx.get_iter(b_buffer),
        fx.make_layout((k, n), (n, 1)),
    )
    c_global_view = fx.make_view(
        fx.get_iter(c_buffer),
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
    a_tiled_view = fx.flat_divide(a_global_view, (BLOCK_M, BLOCK_K))
    b_tiled_view = fx.flat_divide(b_global_view, (BLOCK_K, BLOCK_N))
    c_tiled_view = fx.flat_divide(c_global_view, (PHYSICAL_M, PHYSICAL_N))
    c_block_view = fx.slice(
        c_tiled_view, (None, None, physical_block_row, physical_block_col)
    )
    c_wave_tiles = fx.flat_divide(c_block_view, (BLOCK_M, BLOCK_N))
    c_wave_view = fx.slice(c_wave_tiles, (None, None, wave_row, wave_col))

    # 3. Keep one packed B tile per independent wave group in LDS.
    a_global_model = fx.slice(a_tiled_view, (None, None, 0, 0))
    a_lds_view, b_lds_view = _create_staging_views(
        a_global_model,
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
    b_k_lane = compute_thread_id // (BLOCK_N // 8)
    b_n_lane = compute_thread_id % (BLOCK_N // 8)
    b_gmem_load_128b = fx.make_copy_atom(
        fx.rocdl.BufferCopy128b(RIGHT_CACHE_MODIFIER), fx.BFloat16
    )
    b_staging_thread_layout = fx.make_ordered_layout(
        (THREADS_PER_GROUP // (BLOCK_N // 8), BLOCK_N // 8), (1, 0)
    )
    b_staging_copy_tile, b_staging_copy_tv = fx.make_layout_tv(
        b_staging_thread_layout, staging_value_layout
    )
    b_staging_copy_plan = fx.make_tiled_copy(
        copy_128b, b_staging_copy_tv, b_staging_copy_tile
    )
    b_thread_staging_copy = b_staging_copy_plan.get_slice(compute_thread_id)
    b_lds_destination = b_thread_staging_copy.partition_D(b_lds_view)
    b_staging_fragment = fx.make_fragment_like(b_lds_destination)

    # Reinterpret B as (N,K) for WMMA without moving its physical data.
    b_lds_transposed_view = fx.make_view(
        fx.get_iter(b_lds_view),
        fx.make_layout((BLOCK_N, BLOCK_K), (1, BLOCK_N)),
    )
    b_lds_transposed_tiled = fx.flat_divide(
        b_lds_transposed_view, (BLOCK_N, MMA_K)
    )

    # A single K=16 B view determines the operand register shape.
    b_lds_transposed_initial_view = fx.slice(
        b_lds_transposed_tiled, (None, None, 0, 0)
    )
    # 5. Retain native WMMA ownership and its FP32 accumulator.
    mma_atom = fx.make_mma_atom(
        fx.rocdl.WMMA(MMA_M, MMA_N, MMA_K, fx.BFloat16, fx.Float32)
    )
    mma = fx.make_tiled_mma(
        mma_atom, fx.make_layout((WAVES_M, WAVES_N, 1), (1, WAVES_M, 0))
    )

    thread_mma = mma.thr_slice(compute_thread_id)
    c_accum = thread_mma.make_fragment_C(c_wave_view)
    ACCUMULATOR_VALUES = fx.size(c_accum.shape).to_py_value()
    c_accum.fill(0)

    # B uses the existing MMA-compatible LDS copy plan.
    copy_16b = fx.make_copy_atom(fx.UniversalCopy16b(), fx.BFloat16)
    b_lds2reg_copy_plan = fx.make_tiled_copy_B(copy_16b, mma)

    b_lds2reg_thread_copy = b_lds2reg_copy_plan.get_slice(compute_thread_id)

    # A has contiguous K: partition global memory with a WMMA A copy plan.
    a_k16_model = fx.slice(
        fx.flat_divide(a_global_model, (BLOCK_M, MMA_K)), (None, None, 0, 0)
    )
    a_r_tile = thread_mma.make_fragment_A(a_k16_model)
    b_r_tile = thread_mma.make_fragment_B(b_lds_transposed_initial_view)

    b_r_destination = b_lds2reg_thread_copy.retile(b_r_tile)

    a_full_fragment = thread_mma.make_fragment_A(a_global_model)
    a_compute_fragment = fx.make_fragment_like(a_full_fragment)
    a_full_tiled = fx.flat_divide(
        a_compute_fragment, (16, BLOCK_M // (16 * WAVES_M), 1)
    )
    a_direct_atom = fx.make_copy_atom(
        fx.rocdl.BufferCopy128b(LEFT_CACHE_MODIFIER), fx.BFloat16
    )
    a_direct_plan = fx.make_tiled_copy_A(a_direct_atom, mma).get_slice(
        compute_thread_id
    )
    a_direct_destination = a_direct_plan.retile(a_full_fragment)

    # The optional A staging path is the stage-10 control, selected for wide N.
    # Clamp this unused model's thread layout in register mode, where A need
    # not satisfy cooperative staging geometry.
    LEFT_COPY_THREADS = THREADS_PER_GROUP if not LEFT_IN_REGISTERS else 32
    a_staging_thread_layout = fx.make_ordered_layout(
        (LEFT_COPY_THREADS // (BLOCK_K // 8), BLOCK_K // 8), (1, 0)
    )
    a_staging_copy_tile, a_staging_copy_tv = fx.make_layout_tv(
        a_staging_thread_layout, staging_value_layout
    )
    a_thread_staging_copy = fx.make_tiled_copy(
        copy_128b, a_staging_copy_tv, a_staging_copy_tile
    ).get_slice(compute_thread_id)
    a_lds_destination = a_thread_staging_copy.partition_D(a_lds_view)
    a_staging_fragment = fx.make_fragment_like(a_lds_destination)
    a_staging_atom = fx.make_copy_atom(
        fx.rocdl.BufferCopy128b(LEFT_CACHE_MODIFIER), fx.BFloat16
    )
    a_lds_tiled = fx.flat_divide(a_lds_view, (BLOCK_M, MMA_K))
    a_operand_plan = fx.make_tiled_copy_A(copy_16b, mma).get_slice(compute_thread_id)
    a_operand_destination = a_operand_plan.retile(a_r_tile)

    def gmem2reg_load_tile(
        tile_k,
        b_packed_fragment,
        b_scale_fragment,
        b_thread_staging_copy,
    ):
        a_block_view = fx.slice(a_tiled_view, (None, None, block_row, tile_k))
        a_direct_source = a_direct_plan.partition_S(a_block_view)
        a_global_source = a_thread_staging_copy.partition_S(a_block_view)
        if LEFT_IN_REGISTERS:
            fx.copy(a_direct_atom, a_direct_source, a_direct_destination)
        else:
            fx.copy(a_staging_atom, a_global_source, a_staging_fragment)
        if FUSED_MXFP4:
            for row_slot in fx.range_constexpr(RIGHT_ROWS_PER_THREAD):
                local_row = b_k_lane + row_slot * RIGHT_K_THREADS
                global_row = tile_k * BLOCK_K + local_row
                global_col = block_col * BLOCK_N + b_n_lane * 8
                packed_word_id = (global_row * n + global_col) // 8
                scale_word_id = (global_row // 32) * (n // 8) + global_col // 8
                b_packed_fragment[row_slot] = fx.Uint32(
                    fx.get_scalar(packed_global_view[packed_word_id])
                )
                b_scale_fragment[row_slot] = fx.Uint64(
                    fx.get_scalar(scales_global_view[scale_word_id])
                )
        else:
            b_block_view = fx.slice(
                b_tiled_view, (None, None, tile_k, block_col)
            )
            b_global_source = b_thread_staging_copy.partition_S(
                b_block_view
            )
            fx.copy(b_gmem_load_128b, b_global_source, b_staging_fragment)

    def reg2lds_copy_tile(b_packed_fragment, b_scale_fragment):
        # Advance A privately; publish only B to the shared tile.
        if LEFT_IN_REGISTERS:
            fx.copy(copy_16b, a_full_fragment, a_compute_fragment)
        else:
            fx.copy(copy_128b, a_staging_fragment, a_lds_destination)
        if FUSED_MXFP4:
            for row_slot in fx.range_constexpr(RIGHT_ROWS_PER_THREAD):
                local_row = b_k_lane + row_slot * RIGHT_K_THREADS
                local_col = b_n_lane * 8
                b_packed_word = b_packed_fragment[row_slot]
                b_scale_word = b_scale_fragment[row_slot]
                output = fx.make_rmem_tensor(8, fx.BFloat16)
                for value_id in fx.range_constexpr(8):
                    code = (b_packed_word >> fx.Uint32(value_id * 4)) & 15
                    magnitude = code & 7
                    b_scale_byte = (
                        (b_scale_word >> fx.Uint64(value_id * 8)) & fx.Uint64(255)
                    ).to(fx.Int32)
                    exponent = b_scale_byte + (magnitude >> 1).to(fx.Int32) - 1
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
                b_lds_output = fx.make_view(
                    fx.get_iter(b_lds_view)
                    + local_row * BLOCK_N
                    + local_col,
                    fx.make_layout(8, 1),
                )
                fx.copy(copy_128b, output, b_lds_output)
        else:
            fx.copy(copy_128b, b_staging_fragment, b_lds_destination)
        lds_barrier()

    def compute_lds():
        for inner_k in fx.range_constexpr(BLOCK_K // MMA_K):
            b_mma_view = fx.slice(
                b_lds_transposed_tiled, (None, None, 0, inner_k)
            )
            b_r_source = b_lds2reg_thread_copy.partition_S(b_mma_view)
            a_current = fx.slice(a_full_tiled, (None, None, None, 0, 0, inner_k))
            a_mma_view = fx.slice(a_lds_tiled, (None, None, 0, inner_k))
            a_operand_source = a_operand_plan.partition_S(a_mma_view)
            if LEFT_IN_REGISTERS:
                fx.copy(copy_16b, a_current, a_r_tile)
            else:
                fx.copy(copy_16b, a_operand_source, a_operand_destination)
            fx.copy(copy_16b, b_r_source, b_r_destination)
            fx.gemm(mma_atom, c_accum, a_r_tile, b_r_tile, c_accum)

    # 6. Prefetch next globals while consuming the current LDS tile.
    # Prologue: make tile 0 visible in LDS before any consumer reads it.
    tiles_per_split = k // (BLOCK_K * SPLIT_K)
    initial_tile_k = split_id * tiles_per_split
    b_packed_fragment = fx.make_rmem_tensor(RIGHT_ROWS_PER_THREAD, fx.Uint32)
    b_scale_fragment = fx.make_rmem_tensor(RIGHT_ROWS_PER_THREAD, fx.Uint64)
    gmem2reg_load_tile(
        initial_tile_k,
        b_packed_fragment,
        b_scale_fragment,
        b_thread_staging_copy,
    )
    reg2lds_copy_tile(b_packed_fragment, b_scale_fragment)
    # Steady state: prefetch next globals into private registers, consume LDS,
    # protect current readers, then publish the next tile into the same LDS.
    for group_k in range((tiles_per_split - 1) // K_UNROLL):
        for step in fx.range_constexpr(K_UNROLL):
            next_tile_k = initial_tile_k + group_k * K_UNROLL + step + 1
            gmem2reg_load_tile(
                next_tile_k,
                b_packed_fragment,
                b_scale_fragment,
                b_thread_staging_copy,
            )
            compute_lds()
            lds_barrier()
            reg2lds_copy_tile(b_packed_fragment, b_scale_fragment)
    for tail in fx.range_constexpr((tiles_per_split - 1) % K_UNROLL):
        next_tile_k = (
            initial_tile_k + ((tiles_per_split - 1) // K_UNROLL) * K_UNROLL + tail + 1
        )
        gmem2reg_load_tile(
            next_tile_k,
            b_packed_fragment,
            b_scale_fragment,
            b_thread_staging_copy,
        )
        compute_lds()
        lds_barrier()
        reg2lds_copy_tile(b_packed_fragment, b_scale_fragment)
    # Drain: the final tile is already in LDS; do not read a nonexistent next tile.
    compute_lds()
    lds_barrier()

    def store_output():
        c_registers = fx.make_rmem_tensor(c_accum.layout, fx.BFloat16)
        for slot in fx.range_constexpr(ACCUMULATOR_VALUES):
            c_registers[slot] = c_accum[slot].to(fx.BFloat16)
        # Replace stage 04's one-thread output plan with the collective C plan.
        gmem_store_16b = fx.make_copy_atom(fx.rocdl.BufferCopy16b(), fx.BFloat16)
        reg2gmem_copy_plan = fx.make_tiled_copy_C(gmem_store_16b, mma)
        reg2gmem_thread_copy = reg2gmem_copy_plan.get_slice(compute_thread_id)
        reg2gmem_source = reg2gmem_thread_copy.retile(c_registers)
        reg2gmem_dest = reg2gmem_thread_copy.partition_D(c_wave_view)
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
            fx.get_iter(partials) + partial_offset, c_accum.layout
        )
        copy_128b_f32 = fx.make_copy_atom(fx.UniversalCopy128b(), fx.Float32)
        fx.copy(copy_128b_f32, c_accum, partial_view)

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
            c_accum.fill(0)
            partial_registers = fx.make_fragment_like(c_accum)
            for part in fx.range_constexpr(SPLIT_K):
                source_offset = (
                    flat_block_id * SPLIT_K + part
                ) * tile_values + thread_offset
                partial_source = fx.make_view(
                    fx.get_iter(partials) + source_offset, c_accum.layout
                )
                fx.copy(copy_128b_f32, partial_source, partial_registers)
                for slot in fx.range_constexpr(ACCUMULATOR_VALUES):
                    c_accum[slot] = c_accum[slot] + partial_registers[slot]
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
def _launch_matmul_bf16(
    a: fx.Tensor,
    b: fx.Tensor,
    c: fx.Tensor,
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
    _matmul_w4a16(
        a,
        b,
        b,
        b,
        c,
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
        FUSED_MXFP4=False,
    ).launch(
        grid=(
            ((m + PHYSICAL_M - 1) // PHYSICAL_M) * (n // PHYSICAL_N) * SPLIT_K,
            1,
            1,
        ),
        block=(THREADS_PER_BLOCK, 1, 1),
        stream=stream,
    )


@flyc.jit
def _launch_matmul_mxfp4_fused(
    a: fx.Tensor,
    b_packed: fx.Tensor,
    b_scales: fx.Tensor,
    c: fx.Tensor,
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
    _matmul_w4a16(
        a,
        c,
        b_packed,
        b_scales,
        c,
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


SHAPES = ((16, 1024, 8192), (32, 1024, 8192), (16, 4096, 8192))
CONFIGS_BY_SHAPE = {
    (16, 1024, 8192): Config(
        block_m=16,
        block_n=64,
        block_k=32,
        waves_m=1,
        waves_n=2,
        group_m=1,
        split_k=4,
        wave_groups_m=1,
        wave_groups_n=1,
        k_unroll=8,
        right_cache_modifier=2,
        left_cache_modifier=0,
        left_in_registers=True,
    ),
    (16, 4096, 8192): Config(
        block_m=16,
        block_n=64,
        block_k=16,
        waves_m=1,
        waves_n=1,
        group_m=1,
        split_k=1,
        wave_groups_m=1,
        wave_groups_n=2,
        k_unroll=4,
        right_cache_modifier=2,
        left_cache_modifier=0,
        left_in_registers=False,
    ),
    (32, 1024, 8192): Config(
        block_m=32,
        block_n=64,
        block_k=32,
        waves_m=1,
        waves_n=2,
        group_m=1,
        split_k=4,
        wave_groups_m=1,
        wave_groups_n=1,
        k_unroll=8,
        right_cache_modifier=2,
        left_cache_modifier=0,
        left_in_registers=True,
    ),
}


@lru_cache(maxsize=128)
def _workspace_for(config, shape, device, stream, capture_id):
    """Cache buffers per config/device/stream/capture; this never launches GEMM."""
    if config.split_k == 1:
        return None
    m, n, _ = shape
    physical_m = config.block_m * config.wave_groups_m
    tiles = (
        ((m + physical_m - 1) // physical_m)
        * config.wave_groups_m
        * (n // config.block_n)
    )
    partial_count = tiles * config.split_k * config.block_m * config.block_n
    counter_count = tiles * config.compute_threads
    with torch.cuda.device(device), torch.cuda.stream(stream):
        partials = torch.empty(partial_count + 16, dtype=torch.float32, device=device)
        counters = torch.zeros(counter_count + 16, dtype=torch.int32, device=device)
        partials[-16:] = -777
        counters[-16:] = -123
    return partials, counters


def check_workspace(workspace):
    if workspace is None:
        return
    partials, counters = workspace
    assert torch.all(partials[-16:] == -777).item(), "Partial sentinel changed"
    assert torch.all(counters[-16:] == -123).item(), "Counter sentinel changed"
    assert torch.all(counters[:-16] == 0).item(), "Arrival counters not reset"


@lru_cache(None)
def _capture_info_function():
    runtime = ctypes.CDLL("libamdhip64.so")
    function = runtime.hipStreamGetCaptureInfo
    function.argtypes = [
        ctypes.c_void_p,
        ctypes.POINTER(ctypes.c_int),
        ctypes.POINTER(ctypes.c_ulonglong),
    ]
    function.restype = ctypes.c_int
    return function


def _capture_id(stream):
    if not torch.cuda.is_current_stream_capturing():
        return 0
    status, identifier = ctypes.c_int(), ctypes.c_ulonglong()
    error = _capture_info_function()(
        ctypes.c_void_p(stream.cuda_stream),
        ctypes.byref(status),
        ctypes.byref(identifier),
    )
    if error:
        raise RuntimeError(f"hipStreamGetCaptureInfo failed: {error}")
    return identifier.value + 1  # Reserve zero for ordinary eager calls.


def matmul_mxfp4_fused(activations, packed_weights, scales, *, out=None, config=None):
    """Experimental fused decode plus the lesson-12 BF16 WMMA pipeline."""
    a = activations
    b_packed = packed_weights
    b_scales = scales
    c = out
    m, k = a.shape
    n = b_scales.shape[1]
    shape = (m, n, k)
    if config is None:
        config = CONFIGS_BY_SHAPE[shape]
    validate_config(config, shape)
    stream = torch.cuda.current_stream(a.device)
    if c is None:
        c = torch.empty((m, n), dtype=torch.bfloat16, device=a.device)
    partials, counters = fx.Empty(), fx.Empty()
    if config.split_k > 1:
        workspace = _workspace_for(
            config, shape, a.device, stream, _capture_id(stream)
        )
        partials, counters = (storage[:-16] for storage in workspace)
    _launch_matmul_mxfp4_fused(
        a,
        b_packed.view(torch.int32),
        b_scales.view(torch.int64),
        c,
        partials,
        counters,
        *shape,
        fx.Stream(stream),
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
    return c


def matmul_bf16(input, other, *, out=None, config=None, stream=None):
    """Launch contiguous 2-D BF16 matmul on gfx1151/gfx1152.

    Unsupported calls raise an error. Supply config for compatible shapes
    outside CONFIGS_BY_SHAPE. Split-K scratch is cached per device/stream/capture
    and allocated only for split_k > 1. Warm up before graph capture.
    """
    a = input
    b = other
    c = out
    tensors = [("input", a), ("other", b)]
    if c is not None:
        tensors.append(("out", c))
    for name, tensor in tensors:
        if type(tensor) not in (torch.Tensor, torch.nn.Parameter):
            raise TypeError(
                f"{name} must be a torch.Tensor; custom tensor subclasses are unsupported"
            )
    if torch._C._are_functorch_transforms_active():
        raise RuntimeError("matmul_bf16 does not support vmap or tensor transforms")
    if torch.autograd.forward_ad._current_level >= 0:
        raise RuntimeError("matmul_bf16 does not support forward-mode autograd")
    if torch.is_autocast_enabled("cuda"):
        raise RuntimeError(
            "matmul_bf16 requires explicit BF16 inputs; disable autocast"
        )
    for name, tensor in tensors:
        if tensor.dtype != torch.bfloat16:
            raise TypeError(
                f"{name} must have dtype torch.bfloat16; got {tensor.dtype}"
            )
        if not tensor.is_cuda:
            raise ValueError(f"{name} must be on a ROCm GPU")
        if tensor.device != a.device:
            raise ValueError(f"{name} must be on the same device as input")
        if tensor.layout != torch.strided or not tensor.is_contiguous():
            raise ValueError(f"{name} must be contiguous and row-major")
        if tensor.is_neg():
            raise ValueError(
                f"{name} must not be a negative view; call resolve_neg() first"
            )
        if torch.is_grad_enabled() and tensor.requires_grad:
            raise RuntimeError(
                f"{name} requires gradients; matmul_bf16 has no autograd support, use torch.no_grad()"
            )
    if a.ndim != 2 or b.ndim != 2:
        raise ValueError("input and other must be two-dimensional matrices")
    if a.shape[1] != b.shape[0]:
        raise ValueError(
            f"K dimensions must match; got {a.shape[1]} and {b.shape[0]}"
        )
    if a.data_ptr() % 16 or b.data_ptr() % 16:
        raise ValueError("input and other must have 16-byte aligned data pointers")
    if torch.version.hip is None:
        raise RuntimeError("matmul_bf16 requires ROCm")
    arch = torch.cuda.get_device_properties(a.device).gcnArchName.split(":")[0]
    if arch not in ("gfx1151", "gfx1152"):
        raise RuntimeError(f"matmul_bf16 requires gfx1151/gfx1152; detected {arch}")
    shape = (a.shape[0], b.shape[1], a.shape[1])
    if config is None:
        config = CONFIGS_BY_SHAPE.get(shape)
        if config is None:
            raise ValueError(
                f"No default config for M,N,K={shape}; supply config=Config(...)"
            )
    if not isinstance(config, Config):
        raise TypeError("config must be a Config")
    validate_config(config, shape)
    if c is not None:
        if c.shape != (shape[0], shape[1]):
            raise ValueError(
                f"out must have shape {(shape[0], shape[1])}; got {tuple(c.shape)}"
            )
        start = c.data_ptr()
        stop = start + c.numel() * c.element_size()
        for name, tensor in tensors[:2]:
            if (
                start < tensor.data_ptr() + tensor.numel() * tensor.element_size()
                and tensor.data_ptr() < stop
            ):
                raise ValueError(f"out must not overlap {name}")
    if stream is not None and stream.device != a.device:
        raise ValueError("Stream and inputs must use the same device")
    supplied_out = c is not None
    with torch.cuda.device(a.device), torch.cuda.stream(stream):
        current_stream = torch.cuda.current_stream(a.device)
        if c is None:
            c = torch.empty(
                (shape[0], shape[1]), dtype=a.dtype, device=a.device
            )
        partials, counters = fx.Empty(), fx.Empty()
        if config.split_k > 1:
            workspace = _workspace_for(
                config, shape, a.device, current_stream, _capture_id(current_stream)
            )
            partials, counters = (storage[:-16] for storage in workspace)
        _launch_matmul_bf16(
            a,
            b,
            c,
            partials,
            counters,
            *shape,
            fx.Stream(current_stream),
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
        if supplied_out:
            torch.autograd.graph.increment_version(c)
    return c


def check_boundaries(config):
    """Trace every split's partials through one, two, and three local K tiles."""
    checked = []
    for tiles_per_split in sorted(
        {1, 2, 3, config.k_unroll, config.k_unroll + 1, config.k_unroll + 2}
    ):
        m, n = (
            config.block_m * config.wave_groups_m,
            config.block_n * config.wave_groups_n,
        )
        k = config.block_k * config.split_k * tiles_per_split
        tile_ids = torch.arange(k) // config.block_k
        split_ids = tile_ids // tiles_per_split
        tags = (split_ids + 1) * 2 ** (tile_ids % tiles_per_split)
        a = tags.to(torch.bfloat16).expand(m, k).contiguous().cuda()
        b = torch.ones((k, n), dtype=torch.bfloat16, device="cuda")
        storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
        c = storage[:-16].view(m, n)
        c.fill_(float("nan"))

        matmul_bf16(a, b, out=c, config=config)
        torch.cuda.synchronize()
        partials = [
            config.block_k * (part + 1) * (2**tiles_per_split - 1)
            for part in range(config.split_k)
        ]
        expected = torch.full((m, n), sum(partials), dtype=torch.bfloat16)
        torch.testing.assert_close(c.cpu(), expected, rtol=0, atol=0)
        if config.split_k > 1:
            actual_partials = (
                _workspace_for(
                    config, (m, n, k), a.device, torch.cuda.current_stream(a.device), 0
                )[0][:-16]
                .view(config.wave_groups, config.split_k, -1)
                .cpu()
            )
            for part, expected_partial in enumerate(partials):
                torch.testing.assert_close(
                    actual_partials[:, part],
                    torch.full_like(actual_partials[:, part], expected_partial),
                    rtol=0,
                    atol=0,
                )
        check_workspace(
            _workspace_for(
                config, (m, n, k), a.device, torch.cuda.current_stream(a.device), 0
            )
        )
        assert torch.all(storage[-16:] == -99).item(), (
            "Boundary output sentinel changed"
        )
        checked.append(
            {
                "tiles_per_split": tiles_per_split,
                "partial_values": partials,
                "sum_before_bf16": sum(partials),
            }
        )
    return checked


def solve(config=None, shape=SHAPES[1], seed=13):
    shape = tuple(shape)
    config = CONFIGS_BY_SHAPE[shape] if config is None else config
    validate_config(config, shape)
    arch = torch.cuda.get_device_properties(0).gcnArchName.split(":")[0]
    if arch not in ("gfx1151", "gfx1152"):
        raise RuntimeError(f"This lesson supports gfx1151/gfx1152; detected {arch}")
    m, n, k = shape

    generator = torch.Generator().manual_seed(seed)
    boundaries = check_boundaries(config)
    first_four = None
    for pattern in ("trace", "random"):
        if pattern == "trace":
            a_cpu = ((torch.arange(m * k).reshape(m, k) % 5) - 2).to(torch.bfloat16)
            b_cpu = ((torch.arange(k * n).reshape(k, n) % 7) - 3).to(torch.bfloat16)
        else:
            a_cpu = torch.randn(m, k, generator=generator).to(torch.bfloat16)
            b_cpu = torch.randn(k, n, generator=generator).to(torch.bfloat16)
        a, b = a_cpu.cuda(), b_cpu.cuda()
        storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
        c = storage[:-16].view(m, n)
        expected = (a_cpu.float() @ b_cpu.float()).to(torch.bfloat16)
        for sign in (1, -1, 1):
            # Change inputs and poison output between reuses of the SAME workspace.
            a.copy_(a_cpu * sign)
            c.fill_(float("nan"))
            matmul_bf16(a, b, out=c, config=config)
            torch.cuda.synchronize()
            torch.testing.assert_close(
                c.cpu(),
                expected * sign,
                rtol=0 if pattern == "trace" else 0.016,
                atol=0.001 if pattern == "trace" else 0.03125,
            )
            assert torch.all(storage[-16:] == -99).item(), "Output sentinel changed"
            check_workspace(
                _workspace_for(
                    config, (m, n, k), a.device, torch.cuda.current_stream(a.device), 0
                )
            )
        if pattern == "trace":
            first_four = c[0, :4].cpu().tolist()
    return {
        "shape_MNK": shape,
        "config": config.name,
        "first_four": first_four,
        "patterns": 2,
        "workspace_reuses_per_pattern": 3,
        "split_boundaries": boundaries,
    }


def main():
    torch.set_num_threads(1)
    if globals().get("_COURSE_CHECK_ONLY", False):
        from dataclasses import replace

        for shape, config in CONFIGS_BY_SHAPE.items():
            for split_k in (1, 2, 4):
                print(
                    "Exercise passed:",
                    solve(replace(config, split_k=split_k), shape),
                    flush=True,
                )
        return
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, default=SHAPES[1])
    parser.add_argument("--split-k", type=int, choices=(1, 2, 4), default=None)
    parser.add_argument("--check-only", action="store_true")
    parser.add_argument(
        "--timing", choices=("graph-host", "direct-host"), default="graph-host"
    )
    args = parser.parse_args()
    shape = tuple(args.shape)
    if shape not in CONFIGS_BY_SHAPE:
        parser.error("Choose a supported skinny shape")
    config = CONFIGS_BY_SHAPE[shape]
    if args.split_k is not None:
        from dataclasses import replace

        config = replace(config, split_k=args.split_k)
    try:
        print("Exercise passed:", solve(config, shape), flush=True)
        if not args.check_only:
            benchmark = runpy.run_path(str(Path(__file__).with_name("tune.py")))
            report = benchmark["compare"](
                config, shape, args.timing, matmul=matmul_bf16
            )
            print(
                json.dumps(
                    {
                        "timing": args.timing,
                        "shape_MNK": shape,
                        "graph_metadata": report["graph_metadata"],
                        "scope": "warm inputs, preallocated output, cached workspace; graph workspace initialization included",
                    }
                )
            )
            labels = {
                "operand_paths": config.name,
                "prefetch": "tuned_prefetch",
                "matched_prefetch": "same_geometry_prefetch",
                "torch": "torch.matmul",
            }
            for name, elapsed in report["median_ms"].items():
                print(
                    json.dumps(
                        {
                            "name": labels[name],
                            "ms": elapsed,
                            "effective_TFLOP_s": 2
                            * shape[0]
                            * shape[1]
                            * shape[2]
                            / (elapsed * 1e9),
                        }
                    )
                )
            print(
                json.dumps(
                    {
                        "paired_native_prefetch_ratio": report["ratio_to_prefetch"],
                        "paired_native_torch_ratio": report["paired_ratio"],
                    }
                )
            )
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None


if __name__ == "__main__":
    main()
