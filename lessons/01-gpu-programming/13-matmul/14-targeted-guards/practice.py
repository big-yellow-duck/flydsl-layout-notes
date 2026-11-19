"""14: practice targeted matrix-edge guards for BF16 WMMA. See README.md."""

import argparse
import ctypes
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
    if config.split_k not in (1, 2, 4):
        raise ValueError("split_k must be 1, 2, or 4")
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
    if config.lds_bytes > 65536:
        raise ValueError("LDS allocation exceeds this lesson's 64 KiB limit")
    return config


def _copy_valid_columns(atom, source, destination, coordinates, extent, width):
    """Guard the contiguous axis with one predicate per copy atom."""
    values = fx.size(coordinates.shape[0]).to_py_value()
    rest_rows = fx.size(coordinates.shape[1]).to_py_value()
    rest_columns = fx.size(coordinates.shape[2]).to_py_value()
    atoms = values // width
    # The leading value mode has one boolean per vector, not per BF16.
    predicate = fx.make_rmem_tensor(
        fx.make_layout(
            ((1, atoms), rest_rows, rest_columns), ((0, 1), atoms, atoms * rest_rows)
        ),
        fx.Boolean,
    )
    for z in fx.range_constexpr(rest_columns):
        for y in fx.range_constexpr(rest_rows):
            for x in fx.range_constexpr(atoms):
                coordinate = coordinates[(x * width, y, z)]
                column = fx.get_scalar(coordinate[1])
                valid = column + width <= extent
                predicate[(x, y, z)] = valid
    fx.copy(atom, source, destination, pred=predicate)


def _create_staging_views(
    left_group_global_view,
    GROUP_TILE_M,
    GROUP_TILE_N,
    STAGE_K,
    LEFT_IN_REGISTERS,
    WAVE_GROUPS_M,
    WAVE_GROUPS_N,
    group_row,
    group_col,
):
    WAVE_GROUPS = WAVE_GROUPS_M * WAVE_GROUPS_N

    @fx.struct
    class SharedStorage:
        # Only B crosses LDS; A stays in each WMMA owner's registers.
        right: fx.Array[fx.BFloat16, WAVE_GROUPS * STAGE_K * GROUP_TILE_N, 16]

    @fx.struct
    class BothSharedStorage:
        left: fx.Array[fx.BFloat16, WAVE_GROUPS * GROUP_TILE_M * (STAGE_K + 8), 16]
        right: fx.Array[fx.BFloat16, WAVE_GROUPS * STAGE_K * GROUP_TILE_N, 16]

    if fx.const_expr(LEFT_IN_REGISTERS):
        lds = fx.SharedAllocator().allocate(SharedStorage).peek()
        left_group_staging_view = left_group_global_view
    else:
        lds = fx.SharedAllocator().allocate(BothSharedStorage).peek()
        left_lds_all = lds.left.view(
            fx.make_layout(
                (WAVE_GROUPS_M, WAVE_GROUPS_N, GROUP_TILE_M, STAGE_K),
                (
                    WAVE_GROUPS_N * GROUP_TILE_M * (STAGE_K + 8),
                    GROUP_TILE_M * (STAGE_K + 8),
                    STAGE_K + 8,
                    1,
                ),
            )
        )
        left_group_staging_view = fx.slice(
            left_lds_all, (group_row, group_col, None, None)
        )
    right_lds_all = lds.right.view(
        fx.make_layout(
            (WAVE_GROUPS_M, WAVE_GROUPS_N, STAGE_K, GROUP_TILE_N),
            (
                WAVE_GROUPS_N * STAGE_K * GROUP_TILE_N,
                STAGE_K * GROUP_TILE_N,
                GROUP_TILE_N,
                1,
            ),
        )
    )
    # Slice both group axes to select this group's disjoint B tile.
    right_group_staging_view = fx.slice(
        right_lds_all, (group_row, group_col, None, None)
    )
    return left_group_staging_view, right_group_staging_view


@flyc.kernel
def _matmul_bf16(
    left: fx.Tensor,
    right: fx.Tensor,
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
    right_buffer = fx.rocdl.make_buffer_tensor(right, max_size=False)
    out_buffer = fx.rocdl.make_buffer_tensor(out, max_size=False)
    left_global_view = fx.make_view(
        fx.get_iter(left_buffer),
        fx.make_layout((m, k), (k, 1)),
    )
    right_global_view = fx.make_view(
        fx.get_iter(right_buffer),
        fx.make_layout((k, n), (n, 1)),
    )
    out_global_view = fx.make_view(
        fx.get_iter(out_buffer),
        fx.make_layout((m, n), (n, 1)),
    )
    # Coordinate views are needed only where a contiguous axis can cross rows.
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
    # A vector must fit the row stride and the last valid contiguous extent.
    LEFT_WIDTH = min(8, k & -k)
    RIGHT_WIDTH = min(8, n & -n)
    # 2. Decode block traversal separately from groups inside the block.
    group_layout = fx.make_layout((WAVE_GROUPS_M, WAVE_GROUPS_N), (WAVE_GROUPS_N, 1))
    group_coords = fx.idx2crd(wave_group, group_layout)
    group_row = fx.get_scalar(group_coords[0])
    group_col = fx.get_scalar(group_coords[1])

    out_block_tiles = fx.flat_divide(out_global_view, (BLOCK_M, BLOCK_N))
    blocks_m = fx.size(out_block_tiles.shape[2]).to_py_value()
    blocks_n = fx.size(out_block_tiles.shape[3]).to_py_value()
    group_m_width = min(GROUP_M, blocks_m)
    # The final M group can be shorter, without launching duplicate blocks.
    output_block_id = fx.block_idx.x // SPLIT_K
    split_id = fx.block_idx.x % SPLIT_K
    full_group_size = group_m_width * blocks_n
    m_group_id = output_block_id // full_group_size
    first_group_row = m_group_id * group_m_width
    rows_in_group = fx.min(group_m_width, blocks_m - first_group_row)
    block_in_group = output_block_id % full_group_size
    block_row = first_group_row + block_in_group % rows_in_group
    block_col = block_in_group // rows_in_group

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

    # A/B block tiles cover the same output rows/columns for one K stage.
    left_block_tiles = fx.flat_divide(left_global_view, (BLOCK_M, STAGE_K))
    right_block_tiles = fx.flat_divide(right_global_view, (STAGE_K, BLOCK_N))

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
        fx.rocdl.BufferCopy(16 * LEFT_WIDTH, LEFT_CACHE_MODIFIER), fx.BFloat16
    )
    if fx.const_expr(LEFT_IN_REGISTERS):
        # Allocate per-thread registers for two full A stages in WMMA layout.
        # Staging holds the next load while compute holds the current stage.
        left_staging_fragment = thread_mma.make_fragment_A(left_group_global_view)
        left_compute_fragment = fx.make_fragment_like(left_staging_fragment)
        # The copy plan assigns global values to WMMA lanes. Retile gives the
        # staging registers the view that this copy plan expects.
        left_global_thread_copy = fx.make_tiled_copy_A(gmem_left_load, mma).get_slice(
            thread_id_in_wave_group
        )
        left_global_destination = left_global_thread_copy.retile(left_staging_fragment)
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
        # Use the same cooperative ownership for the width-selected global load.
        left_global_thread_copy = fx.make_tiled_copy(
            gmem_left_load, left_staging_copy_tv, left_staging_copy_tile
        ).get_slice(thread_id_in_wave_group)
        left_global_destination = left_global_thread_copy.retile(left_staging_fragment)

    # Cooperatively load contiguous N chunks for B's tile in LDS.
    gmem_right_load = fx.make_copy_atom(
        fx.rocdl.BufferCopy(16 * RIGHT_WIDTH, RIGHT_CACHE_MODIFIER), fx.BFloat16
    )
    right_staging_thread_layout = fx.make_ordered_layout(
        (THREADS_PER_GROUP // (GROUP_TILE_N // 8), GROUP_TILE_N // 8), (1, 0)
    )
    right_staging_copy_tile, right_staging_copy_tv = fx.make_layout_tv(
        right_staging_thread_layout, staging_value_layout
    )
    right_staging_copy_plan = fx.make_tiled_copy(
        copy_128b, right_staging_copy_tv, right_staging_copy_tile
    )
    right_thread_staging_copy = right_staging_copy_plan.get_slice(
        thread_id_in_wave_group
    )
    right_staging_destination = right_thread_staging_copy.partition_D(
        right_group_staging_view
    )
    right_staging_fragment = fx.make_fragment_like(right_staging_destination)
    right_global_thread_copy = fx.make_tiled_copy(
        gmem_right_load, right_staging_copy_tv, right_staging_copy_tile
    ).get_slice(thread_id_in_wave_group)
    right_global_destination = right_global_thread_copy.retile(right_staging_fragment)

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

    def load_nonempty_stage(tile_k):
        left_block_view = fx.slice(left_block_tiles, (None, None, block_row, tile_k))
        right_block_view = fx.slice(right_block_tiles, (None, None, tile_k, block_col))
        left_group_tiles = fx.flat_divide(left_block_view, (GROUP_TILE_M, STAGE_K))
        right_group_tiles = fx.flat_divide(right_block_view, (STAGE_K, GROUP_TILE_N))
        left_group_view = fx.slice(left_group_tiles, (None, None, group_row, 0))
        right_group_view = fx.slice(right_group_tiles, (None, None, 0, group_col))
        left_source = left_global_thread_copy.partition_S(left_group_view)
        right_source = right_global_thread_copy.partition_S(right_group_view)

        # B rows past K are outside its descriptor for every valid output column.
        fx.copy(gmem_right_load, right_source, right_global_destination)
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
                left_thread_coordinates = left_global_thread_copy.partition_S(
                    group_coordinates
                )
                left_global_destination.fill(0)
                _copy_valid_columns(
                    gmem_left_load,
                    left_source,
                    left_global_destination,
                    left_thread_coordinates,
                    k,
                    LEFT_WIDTH,
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
            # TODO 1: Fill in stage_exists. See README.md.
            stage_exists = None
            if stage_exists is None:
                raise NotImplementedError("Fill in stage_exists.")
            stage = scf.IfOp(stage_exists.ir_value(), [], has_else=True)
            with ir.InsertionPoint(stage.then_block):
                load_nonempty_stage(tile_k)
                scf.yield_([])
            with ir.InsertionPoint(stage.else_block):
                left_global_destination.fill(0)
                right_global_destination.fill(0)
                scf.yield_([])
        else:
            load_nonempty_stage(tile_k)

    def publish_stage():
        if fx.const_expr(LEFT_IN_REGISTERS):
            # Make the prefetched A stage current within each lane. This frees
            # the staging registers for the next global load.
            fx.copy(copy_16b, left_staging_fragment, left_compute_fragment)
        else:
            fx.copy(copy_128b, left_staging_fragment, left_staging_destination)
        fx.copy(copy_128b, right_staging_fragment, right_staging_destination)
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
    publish_stage()

    full_groups, tail_stages = divmod(tiles_per_split - 1, K_UNROLL)
    for group_k in range(full_groups):
        for step in fx.range_constexpr(K_UNROLL):
            next_tile_k = initial_tile_k + group_k * K_UNROLL + step + 1
            load_stage(next_tile_k)
            compute_stage()
            lds_barrier()
            publish_stage()
    for tail in fx.range_constexpr(tail_stages):
        next_tile_k = initial_tile_k + full_groups * K_UNROLL + tail + 1
        load_stage(next_tile_k)
        compute_stage()
        lds_barrier()
        publish_stage()

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
            # TODO 2: Fill in complete_n. See README.md.
            complete_n = None
            if complete_n is None:
                raise NotImplementedError("Fill in complete_n.")
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
def _launch_matmul_bf16(
    left: fx.Tensor,
    right: fx.Tensor,
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
    _matmul_bf16(
        left,
        right,
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


# The tiny trace comes first, followed by the locked edge and square examples.
CONFIGS_BY_SHAPE = {
    (17, 65, 33): Config(block_k=32, waves_n=1, split_k=4, k_unroll=2),
    (7, 1032, 8200): Config(
        block_m=16,
        block_n=64,
        block_k=32,
        waves_m=1,
        waves_n=2,
        group_m=1,
        split_k=4,
        wave_groups_m=1,
        wave_groups_n=1,
        k_unroll=2,
        right_cache_modifier=2,
        left_cache_modifier=0,
        left_in_registers=True,
    ),
    (17, 1032, 8200): Config(
        block_m=32,
        block_n=64,
        block_k=32,
        waves_m=1,
        waves_n=2,
        group_m=1,
        split_k=4,
        wave_groups_m=1,
        wave_groups_n=1,
        k_unroll=2,
        right_cache_modifier=2,
        left_cache_modifier=0,
        left_in_registers=False,
    ),
    (31, 1048, 8184): Config(
        block_m=32,
        block_n=64,
        block_k=32,
        waves_m=1,
        waves_n=2,
        group_m=1,
        split_k=4,
        wave_groups_m=1,
        wave_groups_n=1,
        k_unroll=2,
        right_cache_modifier=2,
        left_cache_modifier=0,
        left_in_registers=True,
    ),
    (512, 512, 512): Config(
        block_m=64,
        block_n=64,
        block_k=32,
        waves_m=2,
        waves_n=2,
        group_m=4,
        split_k=1,
        k_unroll=2,
    ),
    (1024, 1024, 1024): Config(
        block_m=128,
        block_n=128,
        block_k=32,
        waves_m=1,
        waves_n=4,
        group_m=4,
        split_k=1,
        k_unroll=2,
        right_cache_modifier=0,
        left_in_registers=False,
    ),
    (2048, 2048, 2048): Config(
        block_m=64,
        block_n=64,
        block_k=64,
        waves_m=1,
        waves_n=2,
        group_m=2,
        split_k=1,
        k_unroll=2,
        right_cache_modifier=1,
    ),
    (1032, 1048, 1016): Config(
        block_m=64,
        block_n=64,
        block_k=32,
        waves_m=2,
        waves_n=2,
        group_m=4,
        split_k=1,
        k_unroll=2,
    ),
    (1025, 1025, 1025): Config(
        block_m=128,
        block_n=128,
        block_k=32,
        waves_m=1,
        waves_n=4,
        group_m=4,
        split_k=1,
        k_unroll=2,
        right_cache_modifier=0,
        left_in_registers=False,
    ),
}
SHAPES = tuple(CONFIGS_BY_SHAPE)


def default_config(shape):
    """A correctness default for every positive shape; examples can be tuned."""
    return CONFIGS_BY_SHAPE.get(
        tuple(shape),
        Config(block_k=32, waves_n=1, split_k=4 if shape[2] >= 256 else 1, k_unroll=2),
    )


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
        * (
            (n + config.block_n * config.wave_groups_n - 1)
            // (config.block_n * config.wave_groups_n)
        )
        * config.wave_groups_n
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


def matmul_bf16(input, other, *, out=None, config=None, stream=None):
    """Launch contiguous 2-D BF16 matmul on gfx1151/gfx1152.

    All positive M,N,K are supported with contiguous BF16 inputs.
    Supply config to override the shape-based default. Split-K scratch is cached
    per device/stream/capture and allocated only for split_k > 1. Warm up before graph capture.
    """
    tensors = [("input", input), ("other", other)]
    if out is not None:
        tensors.append(("out", out))
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
        if tensor.device != input.device:
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
    if input.ndim != 2 or other.ndim != 2:
        raise ValueError("input and other must be two-dimensional matrices")
    if input.shape[1] != other.shape[0]:
        raise ValueError(
            f"K dimensions must match; got {input.shape[1]} and {other.shape[0]}"
        )
    if input.data_ptr() % 16 or other.data_ptr() % 16:
        raise ValueError("input and other must have 16-byte aligned data pointers")
    if torch.version.hip is None:
        raise RuntimeError("matmul_bf16 requires ROCm")
    arch = torch.cuda.get_device_properties(input.device).gcnArchName.split(":")[0]
    if arch not in ("gfx1151", "gfx1152"):
        raise RuntimeError(f"matmul_bf16 requires gfx1151/gfx1152; detected {arch}")
    shape = (input.shape[0], other.shape[1], input.shape[1])
    if config is None:
        config = default_config(shape)
    if not isinstance(config, Config):
        raise TypeError("config must be a Config")
    validate_config(config, shape)
    if out is not None:
        if out.shape != (shape[0], shape[1]):
            raise ValueError(
                f"out must have shape {(shape[0], shape[1])}; got {tuple(out.shape)}"
            )
        start = out.data_ptr()
        stop = start + out.numel() * out.element_size()
        for name, tensor in tensors[:2]:
            if (
                start < tensor.data_ptr() + tensor.numel() * tensor.element_size()
                and tensor.data_ptr() < stop
            ):
                raise ValueError(f"out must not overlap {name}")
    if stream is not None and stream.device != input.device:
        raise ValueError("Stream and inputs must use the same device")
    supplied_out = out is not None
    with torch.cuda.device(input.device), torch.cuda.stream(stream):
        current_stream = torch.cuda.current_stream(input.device)
        if out is None:
            out = torch.empty(
                (shape[0], shape[1]), dtype=input.dtype, device=input.device
            )
        partials, counters = fx.Empty(), fx.Empty()
        if config.split_k > 1:
            workspace = _workspace_for(
                config, shape, input.device, current_stream, _capture_id(current_stream)
            )
            partials, counters = (storage[:-16] for storage in workspace)
        _launch_matmul_bf16(
            input,
            other,
            out,
            partials,
            counters,
            *shape,
            fx.Stream(current_stream),
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


def solve(config=None, shape=SHAPES[0], seed=13):
    """Check trace/random data, cross-row reads, output guards, and scratch reuse."""
    shape = tuple(shape)
    config = default_config(shape) if config is None else config
    validate_config(config, shape)
    m, n, k = shape
    generator = torch.Generator().manual_seed(seed)
    first_four = None
    for pattern in ("trace", "random"):
        if pattern == "trace":
            a_cpu = ((torch.arange(m * k).reshape(m, k) % 5) - 2).bfloat16()
            b_cpu = ((torch.arange(k * n).reshape(k, n) % 7) - 3).bfloat16()
        else:
            a_cpu = torch.randn(m, k, generator=generator).bfloat16()
            b_cpu = torch.randn(k, n, generator=generator).bfloat16()
        # First check exact input allocations. Logical views with poisoned
        # backing storage then check reads that would escape into valid memory.
        a, b = a_cpu.cuda(), b_cpu.cuda()
        a_guard = torch.full(
            (m * k + 64,), float("nan"), dtype=torch.bfloat16, device="cuda"
        )
        b_guard = torch.full(
            (k * n + 64,), float("nan"), dtype=torch.bfloat16, device="cuda"
        )
        storage = torch.full((m * n + 64,), -99, dtype=torch.bfloat16, device="cuda")
        out = storage[: m * n].view(m, n)
        expected = (a_cpu.float() @ b_cpu.float()).bfloat16()
        for reuse, sign in enumerate((1, -1, 1)):
            if reuse == 1:
                a = a_guard[: m * k].view(m, k)
                b = b_guard[: k * n].view(k, n)
            a.copy_(a_cpu * sign)
            b.copy_(b_cpu)
            out.fill_(float("nan"))
            matmul_bf16(a, b, out=out, config=config)
            torch.cuda.synchronize()
            torch.testing.assert_close(
                out.cpu(),
                expected * sign,
                rtol=0 if pattern == "trace" else 0.016,
                atol=0.001 if pattern == "trace" else 0.03125,
            )
            assert torch.all(storage[m * n :] == -99).item(), "Output guard changed"
            assert torch.all(torch.isnan(a_guard[m * k :])).item()
            assert torch.all(torch.isnan(b_guard[k * n :])).item()
            check_workspace(
                _workspace_for(
                    config, shape, a.device, torch.cuda.current_stream(a.device), 0
                )
            )
        if pattern == "trace":
            first_four = out[0, :4].cpu().tolist()
    return {
        "shape_MNK": shape,
        "config": config.name,
        "first_four": first_four,
        "patterns": 2,
        "workspace_reuses_per_pattern": 3,
        "exact_inputs_and_poisoned_backing": "passed",
        "guards": "passed",
    }


def check_edges():
    """Small, complementary cases exercise all transfer widths and empty splits."""
    from dataclasses import replace

    cases = []
    for shape in (
        (1, 1, 1),
        (15, 31, 7),
        (16, 64, 32),
        (17, 65, 33),
        (31, 66, 34),
        (33, 68, 36),
        (65, 72, 40),
        (2, 65, 40),
        (2, 72, 33),
        (2, 66, 36),
        (2, 68, 34),
    ):
        for registers in (True, False):
            config = Config(
                block_k=32,
                waves_n=1,
                split_k=4,
                k_unroll=2,
                wave_groups_m=2,
                wave_groups_n=2,
                group_m=2,
                left_in_registers=registers,
            )
            cases.append(solve(config, shape))
    # One-/two-/three-stage prologues, unroll boundaries, and all split counts.
    base = Config(block_k=16, waves_n=1, k_unroll=2)
    for split in (1, 2, 4):
        for k in (15, 16, 17, 47, 49):
            cases.append(solve(replace(base, split_k=split), (3, 9, k)))
    for gm, gn in ((1, 2), (2, 1)):
        config = Config(
            block_k=32,
            waves_n=1,
            wave_groups_m=gm,
            wave_groups_n=gn,
            split_k=2,
            k_unroll=2,
            group_m=3,
        )
        cases.append(solve(config, (97, 75, 71)))
    for registers in (True, False):
        config = Config(
            block_m=32,
            block_k=32,
            waves_m=2,
            waves_n=1,
            split_k=2,
            k_unroll=2,
            group_m=3,
            left_in_registers=registers,
        )
        cases.append(solve(config, (97, 75, 71)))
    return cases


def check_nonfinite_k_tail():
    """An A K tail must not read nonfinite values from the next row."""
    from dataclasses import replace

    shape = (3, 65, 33)
    m, n, k = shape
    a = torch.ones((m, k), dtype=torch.bfloat16)
    b = torch.ones((k, n), dtype=torch.bfloat16)
    a[1, 0] = float("nan")
    a[2, 0] = float("inf")
    expected = (a.float() @ b.float()).bfloat16()
    gpu_a, gpu_b = a.cuda(), b.cuda()
    base = default_config(shape)
    for split in (1, 4):
        for registers in (True, False):
            config = replace(base, split_k=split, left_in_registers=registers)
            actual = matmul_bf16(gpu_a, gpu_b, config=config).cpu()
            torch.testing.assert_close(actual, expected, rtol=0, atol=0, equal_nan=True)


def main():
    torch.set_num_threads(1)
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--shape",
        type=int,
        nargs=3,
        help="Any positive M N K; default: all lesson examples",
    )
    parser.add_argument("--split-k", type=int, choices=(1, 2, 4))
    parser.add_argument("--check-only", action="store_true")
    parser.add_argument(
        "--timing", choices=("graph-host", "direct-host"), default="graph-host"
    )
    args = parser.parse_args([] if globals().get("_COURSE_CHECK_ONLY", False) else None)
    try:
        if args.shape is None:
            print("Edge cases passed:", len(check_edges()), flush=True)
            check_nonfinite_k_tail()
            print("Nonfinite K-tail cases passed: 4", flush=True)
        for shape in (tuple(args.shape),) if args.shape else SHAPES:
            config = default_config(shape)
            if args.split_k:
                from dataclasses import replace

                config = replace(config, split_k=args.split_k)
            print("Exercise passed:", solve(config, shape), flush=True)
            if not args.check_only and not globals().get("_COURSE_CHECK_ONLY", False):
                benchmark = runpy.run_path(str(Path(__file__).with_name("tune.py")))
                report = benchmark["compare"](
                    config, shape, args.timing, matmul=matmul_bf16
                )
                benchmark["print_comparison"](report)
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None


if __name__ == "__main__":
    main()
