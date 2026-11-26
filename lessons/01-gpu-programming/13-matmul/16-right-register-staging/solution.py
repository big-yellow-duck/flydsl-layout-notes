"""16: load row-major B directly into WMMA registers. See README.md."""

import argparse
import ctypes
from dataclasses import dataclass, replace
from functools import lru_cache

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch
from flydsl._mlir import ir
from flydsl._mlir.dialects import gpu, scf


@dataclass(frozen=True)
class Config:
    group_tile_m: int = 16
    group_tile_n: int = 64
    stage_k: int = 64
    waves_per_group_m: int = 1
    waves_per_group_n: int = 2
    traversal_group_m: int = 1
    split_k: int = 4
    wave_groups_m: int = 1
    wave_groups_n: int = 1
    k_unroll: int = 8
    right_cache_modifier: int = 2
    left_cache_modifier: int = 0
    left_in_registers: bool = True
    right_in_registers: bool = False

    @property
    def name(self):
        return (
            f"16_tile{self.group_tile_m}x{self.group_tile_n}_stagek{self.stage_k}"
            f"_waves{self.waves_per_group_m}x{self.waves_per_group_n}_groups{self.wave_groups_m}x{self.wave_groups_n}"
            f"_traversalm{self.traversal_group_m}_splitk{self.split_k}"
            f"_u{self.k_unroll}_ac{self.left_cache_modifier}_bc{self.right_cache_modifier}_ar{int(self.left_in_registers)}"
            + ("_br1" if self.right_in_registers else "")
        )

    @property
    def wave_groups(self):
        return self.wave_groups_m * self.wave_groups_n

    @property
    def compute_threads(self):
        return 32 * self.waves_per_group_m * self.waves_per_group_n

    @property
    def threads(self):
        return self.compute_threads * self.wave_groups

    @property
    def accumulator_values(self):
        return (
            8
            * (self.group_tile_m // (16 * self.waves_per_group_m))
            * (self.group_tile_n // (16 * self.waves_per_group_n))
        )

    @property
    def lds_bytes(self):
        left_values = (
            0 if self.left_in_registers else self.group_tile_m * (self.stage_k + 8)
        )
        right_values = (
            0 if self.right_in_registers else self.stage_k * self.group_tile_n
        )
        return 2 * self.wave_groups * (left_values + right_values)


def validate_config(config, shape=(16, 1024, 8192)):
    bm, bn, bk = config.group_tile_m, config.group_tile_n, config.stage_k
    if any(value <= 0 for value in (bm, bn, bk)):
        raise ValueError("Group tile dimensions and stage_k must be positive")
    if len(shape) != 3 or any(value <= 0 for value in shape):
        raise ValueError("Shape must contain positive M,N,K")
    if config.split_k not in (1, 2, 4):
        raise ValueError("split_k must be 1, 2, or 4")
    if (
        config.waves_per_group_m < 1
        or config.waves_per_group_n < 1
        or config.threads not in (32, 64, 128, 256)
    ):
        raise ValueError("Use one, two, four, or eight wave32 waves per block")
    if (
        bm % (16 * config.waves_per_group_m)
        or bn % (16 * config.waves_per_group_n)
        or bk % 16
    ):
        raise ValueError(
            "Group tile and stage_k must contain whole WMMA tiles and K fragments"
        )
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
    staging_tiles = []
    if not config.left_in_registers:
        staging_tiles.append((bm, bk))
    if not config.right_in_registers:
        staging_tiles.append((bk, bn))
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
    if config.traversal_group_m < 1:
        raise ValueError("traversal_group_m must be positive")
    if config.lds_bytes > 65536:
        raise ValueError("LDS allocation exceeds this lesson's 64 KiB limit")
    return config


def _copy_valid_columns(atom, source, destination, coordinates, extent, width, first=0):
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
                if first:
                    valid = (column >= first) & valid
                predicate[(x, y, z)] = valid
    fx.copy(atom, source, destination, pred=predicate)


def _tail_segments(extent):
    """Decompose the suffix after the last eight-value chunk at trace time."""
    column = extent // 8 * 8
    segments = []
    for width in (4, 2, 1):
        if extent & width:
            segments.append((column, width))
            column += width
    return tuple(segments)


def _copy_tail_segments(
    segments, cache_modifier, make_thread_copy, tile, coordinates, fragment
):
    # Each narrow plan retains the wide plan's lane ownership.
    for index in fx.range_constexpr(len(segments)):
        first, width = segments[index]
        atom = fx.make_copy_atom(
            fx.rocdl.BufferCopy(16 * width, cache_modifier), fx.BFloat16
        )
        thread_copy = make_thread_copy(atom)
        source = thread_copy.partition_S(tile)
        destination = thread_copy.retile(fragment)
        thread_coordinates = thread_copy.partition_S(coordinates)
        _copy_valid_columns(
            atom, source, destination, thread_coordinates, first + width, width, first
        )


def _create_staging_views(
    a_group_global_view,
    GROUP_TILE_M,
    GROUP_TILE_N,
    STAGE_K,
    LEFT_IN_REGISTERS,
    WAVE_GROUPS_M,
    WAVE_GROUPS_N,
    group_row,
    group_col,
    RIGHT_IN_REGISTERS=False,
):
    WAVE_GROUPS = WAVE_GROUPS_M * WAVE_GROUPS_N

    @fx.struct
    class BSharedStorage:
        b: fx.Array[fx.BFloat16, WAVE_GROUPS * STAGE_K * GROUP_TILE_N, 16]

    @fx.struct
    class ASharedStorage:
        a: fx.Array[fx.BFloat16, WAVE_GROUPS * GROUP_TILE_M * (STAGE_K + 8), 16]

    @fx.struct
    class BothSharedStorage:
        a: fx.Array[fx.BFloat16, WAVE_GROUPS * GROUP_TILE_M * (STAGE_K + 8), 16]
        b: fx.Array[fx.BFloat16, WAVE_GROUPS * STAGE_K * GROUP_TILE_N, 16]

    if fx.const_expr(not LEFT_IN_REGISTERS and not RIGHT_IN_REGISTERS):
        lds = fx.SharedAllocator().allocate(BothSharedStorage).peek()
    elif fx.const_expr(not LEFT_IN_REGISTERS):
        lds = fx.SharedAllocator().allocate(ASharedStorage).peek()
    elif fx.const_expr(not RIGHT_IN_REGISTERS):
        lds = fx.SharedAllocator().allocate(BSharedStorage).peek()

    a_group_staging_view = a_group_global_view
    if fx.const_expr(not LEFT_IN_REGISTERS):
        a_lds_all = lds.a.view(
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
        a_group_staging_view = fx.slice(
            a_lds_all, (group_row, group_col, None, None)
        )
    b_group_staging_view = None
    if fx.const_expr(not RIGHT_IN_REGISTERS):
        b_lds_all = lds.b.view(
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
        b_group_staging_view = fx.slice(
            b_lds_all, (group_row, group_col, None, None)
        )
    return a_group_staging_view, b_group_staging_view


@flyc.kernel
def _matmul_bf16(
    a: fx.Tensor,
    b: fx.Tensor,
    c: fx.Tensor,
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
    RIGHT_IN_REGISTERS: fx.Constexpr,
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
        if fx.const_expr(not LEFT_IN_REGISTERS or not RIGHT_IN_REGISTERS):
            fx.barrier(address_spaces=lds_address_spaces, scope=barrier_scope)

    # 1. Bound the physical buffers. Whole rows past M or K land beyond them.
    a_buffer = fx.rocdl.make_buffer_tensor(a, max_size=False)
    b_buffer = fx.rocdl.make_buffer_tensor(b, max_size=False)
    c_buffer = fx.rocdl.make_buffer_tensor(c, max_size=False)
    a_global_view = fx.make_view(
        fx.get_iter(a_buffer),
        fx.make_layout((m, k), (k, 1)),
    )
    b_global_view = fx.make_view(
        fx.get_iter(b_buffer),
        fx.make_layout((k, n), (n, 1)),
    )
    c_global_view = fx.make_view(
        fx.get_iter(c_buffer),
        fx.make_layout((m, n), (n, 1)),
    )
    # Coordinate views are needed only where a contiguous axis can cross rows.
    LEFT_TAIL_SEGMENTS = _tail_segments(k)
    RIGHT_TAIL_SEGMENTS = _tail_segments(n)
    REAL_K_STAGES = (k + STAGE_K - 1) // STAGE_K
    HAS_EMPTY_K_STAGES = REAL_K_STAGES % SPLIT_K != 0
    HAS_K_TAIL = k % STAGE_K != 0
    HAS_N_TAIL = n % BLOCK_N != 0
    if fx.const_expr(HAS_K_TAIL):
        a_coordinates = fx.make_view(
            fx.make_int_tuple((0, 0)), fx.make_identity_layout((m, k))
        )
        a_coordinate_tiles = fx.flat_divide(a_coordinates, (BLOCK_M, STAGE_K))
    if fx.const_expr(HAS_N_TAIL):
        c_coordinates = fx.make_view(
            fx.make_int_tuple((0, 0)), fx.make_identity_layout((m, n))
        )
        c_coordinate_tiles = fx.flat_divide(c_coordinates, (BLOCK_M, BLOCK_N))
    if fx.const_expr(len(RIGHT_TAIL_SEGMENTS) > 0):
        b_coordinates = fx.make_view(
            fx.make_int_tuple((0, 0)), fx.make_identity_layout((k, n))
        )
        b_coordinate_tiles = fx.flat_divide(b_coordinates, (STAGE_K, BLOCK_N))
    # 2. Decode block traversal separately from groups inside the block.
    group_layout = fx.make_layout((WAVE_GROUPS_M, WAVE_GROUPS_N), (WAVE_GROUPS_N, 1))
    group_coords = fx.idx2crd(wave_group, group_layout)
    group_row = fx.get_scalar(group_coords[0])
    group_col = fx.get_scalar(group_coords[1])

    c_block_tiles = fx.flat_divide(c_global_view, (BLOCK_M, BLOCK_N))
    blocks_m = fx.size(c_block_tiles.shape[2]).to_py_value()
    blocks_n = fx.size(c_block_tiles.shape[3]).to_py_value()
    group_m_width = min(GROUP_M, blocks_m)
    full_m_groups, tail_m_group_rows = divmod(blocks_m, group_m_width)
    # Each block owns one K split and iterates over its assigned stages.
    split_block_layout = fx.make_ordered_layout(
        (group_m_width, SPLIT_K, blocks_n, full_m_groups),
        (0, 1, 2, 3),
    )
    full_block_count = full_m_groups * group_m_width * SPLIT_K * blocks_n

    # FlyDSL uses these initial values to type the runtime if/else results.
    block_row = fx.Int32(0)
    split_id = fx.Int32(0)
    block_col = fx.Int32(0)
    if tail_m_group_rows > 0 and fx.block_idx.x >= full_block_count:
        # Decode the short final group with the same axis order and its real row count.
        tail_block_layout = fx.make_ordered_layout(
            (tail_m_group_rows, SPLIT_K, blocks_n), (0, 1, 2)
        )
        tail_coords = fx.idx2crd(fx.block_idx.x - full_block_count, tail_block_layout)
        block_row = full_m_groups * group_m_width + fx.get_scalar(tail_coords[0])
        split_id = fx.Int32(fx.get_scalar(tail_coords[1]))
        block_col = fx.Int32(fx.get_scalar(tail_coords[2]))
    else:
        block_coords = fx.idx2crd(fx.block_idx.x, split_block_layout)
        block_row = fx.get_scalar(block_coords[3]) * group_m_width + fx.get_scalar(
            block_coords[0]
        )
        split_id = fx.Int32(fx.get_scalar(block_coords[1]))
        block_col = fx.Int32(fx.get_scalar(block_coords[2]))

    # Select the complete block output, then this group's output tile.
    c_block_view = fx.slice(c_block_tiles, (None, None, block_row, block_col))
    c_group_tiles = fx.flat_divide(c_block_view, (GROUP_TILE_M, GROUP_TILE_N))
    c_group_view = fx.slice(c_group_tiles, (None, None, group_row, group_col))

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
    a_block_tiles = fx.flat_divide(a_global_view, (BLOCK_M, STAGE_K))
    b_block_tiles = fx.flat_divide(b_global_view, (STAGE_K, BLOCK_N))

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
    a_block_model = fx.slice(a_block_tiles, (None, None, 0, 0))
    a_group_models = fx.flat_divide(a_block_model, (GROUP_TILE_M, STAGE_K))
    a_group_global_view = fx.slice(a_group_models, (None, None, 0, 0))

    # Direct A uses the global shape model and skips LDS allocation for A.
    a_group_staging_view, b_group_staging_view = _create_staging_views(
        a_group_global_view,
        GROUP_TILE_M,
        GROUP_TILE_N,
        STAGE_K,
        LEFT_IN_REGISTERS,
        WAVE_GROUPS_M,
        WAVE_GROUPS_N,
        group_row,
        group_col,
        RIGHT_IN_REGISTERS,
    )

    thread_mma = mma.thr_slice(thread_id_in_wave_group)
    c_accum = thread_mma.make_fragment_C(c_group_view)
    ACCUMULATOR_VALUES = fx.size(c_accum.shape).to_py_value()
    c_accum.fill(0)

    # Staging copies for A and B.
    staging_value_layout = fx.make_ordered_layout((1, 8), (1, 0))
    a_gmem_load = fx.make_copy_atom(
        fx.rocdl.BufferCopy128b(LEFT_CACHE_MODIFIER), fx.BFloat16
    )
    if fx.const_expr(LEFT_IN_REGISTERS):
        # Allocate per-thread registers for two full A stages in WMMA layout.
        # Staging holds the next load while compute holds the current stage.
        a_staging_fragment = thread_mma.make_fragment_A(a_group_global_view)
        a_compute_fragment = fx.make_fragment_like(a_staging_fragment)
    else:
        # Cooperatively load contiguous K chunks for the padded A tile in LDS.
        a_staging_thread_layout = fx.make_ordered_layout(
            (THREADS_PER_GROUP // (STAGE_K // 8), STAGE_K // 8), (1, 0)
        )
        a_staging_copy_tile, a_staging_copy_tv = fx.make_layout_tv(
            a_staging_thread_layout, staging_value_layout
        )
        a_staging_thread_copy = fx.make_tiled_copy(
            copy_128b, a_staging_copy_tv, a_staging_copy_tile
        ).get_slice(thread_id_in_wave_group)
        a_staging_destination = a_staging_thread_copy.partition_D(
            a_group_staging_view
        )
        a_staging_fragment = fx.make_fragment_like(a_staging_destination)

    def make_a_global_copy(atom):
        if fx.const_expr(LEFT_IN_REGISTERS):
            return fx.make_tiled_copy_A(atom, mma).get_slice(thread_id_in_wave_group)
        else:
            return fx.make_tiled_copy(
                atom, a_staging_copy_tv, a_staging_copy_tile
            ).get_slice(thread_id_in_wave_group)

    # Both widths write into views of the same staging fragment.
    a_global_thread_copy = make_a_global_copy(a_gmem_load)
    a_global_destination = a_global_thread_copy.retile(a_staging_fragment)

    if fx.const_expr(not RIGHT_IN_REGISTERS):
        # Cooperatively load contiguous N chunks for B's tile in LDS.
        b_gmem_load = fx.make_copy_atom(
            fx.rocdl.BufferCopy128b(RIGHT_CACHE_MODIFIER), fx.BFloat16
        )
        b_staging_thread_layout = fx.make_ordered_layout(
            (THREADS_PER_GROUP // (GROUP_TILE_N // 8), GROUP_TILE_N // 8), (1, 0)
        )
        b_staging_copy_tile, b_staging_copy_tv = fx.make_layout_tv(
            b_staging_thread_layout, staging_value_layout
        )
        b_staging_copy_plan = fx.make_tiled_copy(
            copy_128b, b_staging_copy_tv, b_staging_copy_tile
        )
        b_thread_staging_copy = b_staging_copy_plan.get_slice(
            thread_id_in_wave_group
        )
        b_staging_destination = b_thread_staging_copy.partition_D(
            b_group_staging_view
        )
        b_staging_fragment = fx.make_fragment_like(b_staging_destination)

        def make_b_global_copy(atom):
            return fx.make_tiled_copy(
                atom, b_staging_copy_tv, b_staging_copy_tile
            ).get_slice(thread_id_in_wave_group)

        b_global_thread_copy = make_b_global_copy(b_gmem_load)
        b_global_destination = b_global_thread_copy.retile(b_staging_fragment)

    # MMA copies for A and B.
    a_group_staging_tiled = fx.flat_divide(
        a_group_staging_view, (GROUP_TILE_M, MMA_K)
    )
    a_group_staging_mma_initial_view = fx.slice(
        a_group_staging_tiled, (None, None, 0, 0)
    )
    # WMMA consumes one MMA_K step at a time.
    a_r_tile = thread_mma.make_fragment_A(a_group_staging_mma_initial_view)
    if fx.const_expr(LEFT_IN_REGISTERS):
        # Divide the three fragment axes into three inner and three outer axes.
        # For example, (16, 2, 2) becomes (16, 2, 1, 1, 1, 2) for two K steps.
        a_compute_tiled = fx.flat_divide(
            a_compute_fragment, (MMA_K, GROUP_TILE_M // (MMA_M * WAVES_M), 1)
        )
        a_r_destination = a_r_tile
    else:
        a_lds2reg_thread_copy = fx.make_tiled_copy_A(copy_16b, mma).get_slice(
            thread_id_in_wave_group
        )
        a_r_destination = a_lds2reg_thread_copy.retile(a_r_tile)

    if fx.const_expr(RIGHT_IN_REGISTERS):
        # A typed shape model gives the WMMA register layout of (N,K).
        b_group_model = fx.make_view(
            fx.get_iter(b_buffer),
            fx.make_layout((GROUP_TILE_N, STAGE_K), (1, GROUP_TILE_N)),
        )
        b_stage_model = fx.flat_divide(b_group_model, (GROUP_TILE_N, MMA_K))
        b_r_tile = thread_mma.make_fragment_B(
            fx.slice(b_stage_model, (None, None, 0, 0))
        )
        b_r_destination = b_r_tile
        b_staging_fragment = thread_mma.make_fragment_B(b_group_model)
        b_compute_fragment = fx.make_fragment_like(b_staging_fragment)
        B_COLUMNS_PER_THREAD = GROUP_TILE_N // (MMA_N * WAVES_N)
        b_compute_tiled = fx.flat_divide(
            b_compute_fragment, (MMA_K, B_COLUMNS_PER_THREAD, 1)
        )
        # gfx11 WMMA duplicates each lane's B column in the other half-wave.
        wave_n = (thread_id_in_wave_group // 32) // WAVES_M
        b_first_column = output_group_col * GROUP_TILE_N + wave_n * MMA_N
        b_first_column = b_first_column + thread_id_in_wave_group % MMA_N
    else:
        # Reinterpret B as (N,K) for WMMA without moving its physical data.
        b_group_staging_transposed_view = fx.make_view(
            fx.get_iter(b_group_staging_view),
            fx.make_layout((GROUP_TILE_N, STAGE_K), (1, GROUP_TILE_N)),
        )
        b_group_staging_transposed_tiled = fx.flat_divide(
            b_group_staging_transposed_view, (GROUP_TILE_N, MMA_K)
        )

        # One K=16 slice of B determines the operand register shape.
        b_group_staging_transposed_initial_view = fx.slice(
            b_group_staging_transposed_tiled, (None, None, 0, 0)
        )

        b_group_staging2reg_copy_plan = fx.make_tiled_copy_B(copy_16b, mma)

        b_lds2reg_thread_copy = b_group_staging2reg_copy_plan.get_slice(
            thread_id_in_wave_group
        )

        b_r_tile = thread_mma.make_fragment_B(
            b_group_staging_transposed_initial_view
        )

        b_r_destination = b_lds2reg_thread_copy.retile(b_r_tile)

    def load_b_registers(tile_k):
        b_resource = fx.rocdl.get_buffer_rsrc(fx.get_iter(b_buffer))
        for column_slot in fx.range_constexpr(B_COLUMNS_PER_THREAD):
            b_column = b_first_column + column_slot * MMA_N * WAVES_N
            for step in fx.range_constexpr(STAGE_K // MMA_K):
                for value_id in fx.range_constexpr(MMA_K):
                    b_row = tile_k * STAGE_K + step * MMA_K + value_id
                    b_offset = b_row * n + b_column
                    if fx.const_expr(HAS_N_TAIL):
                        b_offset = (b_column < n).select(b_offset, k * n)
                    bits = fx.rocdl.raw_ptr_buffer_load(
                        fx.Uint16.ir_type,
                        b_resource,
                        fx.Int32(b_offset * 2),
                        fx.Int32(0),
                        aux=RIGHT_CACHE_MODIFIER,
                    )
                    b_staging_fragment[(value_id, column_slot, step)] = fx.Uint16(
                        bits
                    ).bitcast(fx.BFloat16)

    def load_b_edge(tile_k, b_group_view, b_source):
        coordinate_block = fx.slice(
            b_coordinate_tiles, (None, None, tile_k, block_col)
        )
        coordinate_groups = fx.flat_divide(coordinate_block, (STAGE_K, GROUP_TILE_N))
        b_group_coordinates = fx.slice(
            coordinate_groups, (None, None, 0, group_col)
        )
        b_global_destination.fill(0)
        if fx.const_expr(n % GROUP_TILE_N >= 8):
            thread_coordinates = b_global_thread_copy.partition_S(
                b_group_coordinates
            )
            _copy_valid_columns(
                b_gmem_load,
                b_source,
                b_global_destination,
                thread_coordinates,
                n,
                8,
            )
        _copy_tail_segments(
            RIGHT_TAIL_SEGMENTS,
            RIGHT_CACHE_MODIFIER,
            make_b_global_copy,
            b_group_view,
            b_group_coordinates,
            b_staging_fragment,
        )

    def load_k_tail(tile_k, a_group_view, a_source):
        coordinate_block = fx.slice(
            a_coordinate_tiles, (None, None, block_row, tile_k)
        )
        coordinate_groups = fx.flat_divide(coordinate_block, (GROUP_TILE_M, STAGE_K))
        group_coordinates = fx.slice(coordinate_groups, (None, None, group_row, 0))
        a_global_destination.fill(0)
        if fx.const_expr(k % STAGE_K >= 8):
            thread_coordinates = a_global_thread_copy.partition_S(group_coordinates)
            _copy_valid_columns(
                a_gmem_load,
                a_source,
                a_global_destination,
                thread_coordinates,
                k,
                8,
            )
        _copy_tail_segments(
            LEFT_TAIL_SEGMENTS,
            LEFT_CACHE_MODIFIER,
            make_a_global_copy,
            a_group_view,
            group_coordinates,
            a_staging_fragment,
        )

    def load_nonempty_stage(tile_k):
        a_block_view = fx.slice(a_block_tiles, (None, None, block_row, tile_k))
        a_group_tiles = fx.flat_divide(a_block_view, (GROUP_TILE_M, STAGE_K))
        a_group_view = fx.slice(a_group_tiles, (None, None, group_row, 0))
        a_source = a_global_thread_copy.partition_S(a_group_view)
        if fx.const_expr(RIGHT_IN_REGISTERS):
            load_b_registers(tile_k)
        else:
            b_block_view = fx.slice(b_block_tiles, (None, None, tile_k, block_col))
            b_group_tiles = fx.flat_divide(b_block_view, (STAGE_K, GROUP_TILE_N))
            b_group_view = fx.slice(b_group_tiles, (None, None, 0, group_col))
            b_source = b_global_thread_copy.partition_S(b_group_view)

            # Full groups use only wide B loads, even when the row pitch is odd.
            if fx.const_expr(len(RIGHT_TAIL_SEGMENTS) > 0):
                wide_b = (output_group_col + 1) * GROUP_TILE_N <= n
                if fx.const_expr(n >= 8):
                    # Before the last K stage, a valid B column has a full vector
                    # within the buffer. C's mask discards columns beyond N.
                    wide_b = wide_b or (tile_k < REAL_K_STAGES - 1)
                if wide_b:
                    fx.copy(b_gmem_load, b_source, b_global_destination)
                else:
                    load_b_edge(tile_k, b_group_view, b_source)
            else:
                fx.copy(b_gmem_load, b_source, b_global_destination)

        if fx.const_expr(HAS_K_TAIL):
            # A's extra K columns can alias the next row, including nonfinite values.
            is_k_tail = tile_k == REAL_K_STAGES - 1
            if is_k_tail:
                load_k_tail(tile_k, a_group_view, a_source)
            else:
                fx.copy(a_gmem_load, a_source, a_global_destination)
        else:
            fx.copy(a_gmem_load, a_source, a_global_destination)

    def load_stage(tile_k):
        if fx.const_expr(HAS_EMPTY_K_STAGES):
            # Check the stage before slicing. A singleton K-stage stride can be zero.
            stage_exists = tile_k < REAL_K_STAGES
            a_global_destination.fill(0)
            if fx.const_expr(RIGHT_IN_REGISTERS):
                b_staging_fragment.fill(0)
            else:
                b_global_destination.fill(0)
            if stage_exists:
                load_nonempty_stage(tile_k)
        else:
            load_nonempty_stage(tile_k)

    def publish_stage():
        if fx.const_expr(LEFT_IN_REGISTERS):
            # Make the prefetched A stage current within each lane. This frees
            # the staging registers for the next global load.
            fx.copy(copy_16b, a_staging_fragment, a_compute_fragment)
        else:
            fx.copy(copy_128b, a_staging_fragment, a_staging_destination)
        if fx.const_expr(RIGHT_IN_REGISTERS):
            fx.copy(copy_16b, b_staging_fragment, b_compute_fragment)
        else:
            fx.copy(copy_128b, b_staging_fragment, b_staging_destination)
        lds_barrier()

    def compute_stage():
        for inner_k in fx.range_constexpr(STAGE_K // MMA_K):
            if fx.const_expr(LEFT_IN_REGISTERS):
                # Keep the three inner axes that match a_r_tile. The outer
                # register-slot and M axes have one tile each, so only K varies.
                # The copy below moves this chunk into a_r_tile within the lane.
                a_source = fx.slice(
                    a_compute_tiled, (None, None, None, 0, 0, inner_k)
                )
            else:
                a_mma_view = fx.slice(
                    a_group_staging_tiled, (None, None, 0, inner_k)
                )
                a_source = a_lds2reg_thread_copy.partition_S(a_mma_view)
            if fx.const_expr(RIGHT_IN_REGISTERS):
                b_source = fx.slice(b_compute_tiled, (None, None, None, 0, 0, inner_k))
            else:
                b_mma_view = fx.slice(
                    b_group_staging_transposed_tiled, (None, None, 0, inner_k)
                )
                b_source = b_lds2reg_thread_copy.partition_S(b_mma_view)
            fx.copy(copy_16b, a_source, a_r_destination)
            fx.copy(copy_16b, b_source, b_r_destination)
            fx.gemm(mma_atom, c_accum, a_r_tile, b_r_tile, c_accum)

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

    def store_n_tail(
        gmem_store_16b, reg2gmem_thread_copy, reg2gmem_source, reg2gmem_dest
    ):
        coordinate_block = fx.slice(
            c_coordinate_tiles, (None, None, block_row, block_col)
        )
        coordinate_groups = fx.flat_divide(
            coordinate_block, (GROUP_TILE_M, GROUP_TILE_N)
        )
        group_coordinates = fx.slice(
            coordinate_groups, (None, None, group_row, group_col)
        )
        output_thread_coordinates = reg2gmem_thread_copy.partition_D(group_coordinates)
        _copy_valid_columns(
            gmem_store_16b,
            reg2gmem_source,
            reg2gmem_dest,
            output_thread_coordinates,
            n,
            1,
        )

    def store_output():
        c_registers = fx.make_rmem_tensor(c_accum.layout, fx.BFloat16)
        for slot in fx.range_constexpr(ACCUMULATOR_VALUES):
            c_registers[slot] = c_accum[slot].to(fx.BFloat16)
        # The MMA C plan stores into this group's selected output view.
        gmem_store_16b = fx.make_copy_atom(fx.rocdl.BufferCopy16b(), fx.BFloat16)
        reg2gmem_copy_plan = fx.make_tiled_copy_C(gmem_store_16b, mma)
        reg2gmem_thread_copy = reg2gmem_copy_plan.get_slice(thread_id_in_wave_group)
        reg2gmem_source = reg2gmem_thread_copy.retile(c_registers)
        reg2gmem_dest = reg2gmem_thread_copy.partition_D(c_group_view)
        # Complete groups store through C's descriptor, which also handles M tails.
        if fx.const_expr(HAS_N_TAIL):
            complete_n = (output_group_col + 1) * GROUP_TILE_N <= n
            if complete_n:
                fx.copy(gmem_store_16b, reg2gmem_source, reg2gmem_dest)
            else:
                store_n_tail(
                    gmem_store_16b, reg2gmem_thread_copy, reg2gmem_source, reg2gmem_dest
                )
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
            fx.get_iter(partials) + partial_offset, c_accum.layout
        )
        copy_128b_f32 = fx.make_copy_atom(fx.UniversalCopy128b(), fx.Float32)
        fx.copy(copy_128b_f32, c_accum, partial_view)

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
            c_accum.fill(0)
            partial_registers = fx.make_fragment_like(c_accum)
            for part in fx.range_constexpr(SPLIT_K):
                source_offset = (
                    flat_group_id * SPLIT_K + part
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
    RIGHT_IN_REGISTERS: fx.Constexpr,
    GROUP_M: fx.Constexpr,
    SPLIT_K: fx.Constexpr,
):
    WAVE_GROUPS = WAVE_GROUPS_M * WAVE_GROUPS_N
    BLOCK_M = GROUP_TILE_M * WAVE_GROUPS_M
    BLOCK_N = GROUP_TILE_N * WAVE_GROUPS_N
    THREADS_PER_GROUP = 32 * WAVES_M * WAVES_N
    THREADS_PER_BLOCK = THREADS_PER_GROUP * WAVE_GROUPS
    _matmul_bf16(
        a,
        b,
        c,
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
        RIGHT_IN_REGISTERS=RIGHT_IN_REGISTERS,
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


TRACE_SHAPE = (3, 7, 17)
CONFIGS_BY_SHAPE = {
    TRACE_SHAPE: Config(
        group_tile_n=16,
        stage_k=16,
        waves_per_group_n=1,
        split_k=1,
        k_unroll=1,
        right_in_registers=True,
    ),
}


def default_config(shape):
    return CONFIGS_BY_SHAPE.get(
        tuple(shape),
        Config(
            group_tile_n=16 if shape[1] <= 16 else 32,
            stage_k=32,
            waves_per_group_n=1,
            split_k=4 if shape[2] >= 256 else 1,
            k_unroll=2,
        ),
    )


@lru_cache(maxsize=128)
def _workspace_for(config, shape, device, stream, capture_id):
    """Cache buffers per config/device/stream/capture; this never launches GEMM."""
    if config.split_k == 1:
        return None
    m, n, _ = shape
    physical_m = config.group_tile_m * config.wave_groups_m
    tiles = (
        ((m + physical_m - 1) // physical_m)
        * config.wave_groups_m
        * (
            (n + config.group_tile_n * config.wave_groups_n - 1)
            // (config.group_tile_n * config.wave_groups_n)
        )
        * config.wave_groups_n
    )
    partial_count = tiles * config.split_k * config.group_tile_m * config.group_tile_n
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
        config = default_config(shape)
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
            LEFT_IN_REGISTERS=config.left_in_registers,
            RIGHT_IN_REGISTERS=config.right_in_registers,
            GROUP_M=config.traversal_group_m,
            SPLIT_K=config.split_k,
        )
        if supplied_out:
            torch.autograd.graph.increment_version(c)
    return c


def solve(config=None, shape=TRACE_SHAPE, seed=13):
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
        c = storage[: m * n].view(m, n)
        expected = (a_cpu.float() @ b_cpu.float()).bfloat16()
        for reuse, sign in enumerate((1, -1, 1)):
            if reuse == 1:
                a = a_guard[: m * k].view(m, k)
                b = b_guard[: k * n].view(k, n)
            a.copy_(a_cpu * sign)
            b.copy_(b_cpu)
            c.fill_(float("nan"))
            matmul_bf16(a, b, out=c, config=config)
            torch.cuda.synchronize()
            torch.testing.assert_close(
                c.cpu(),
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
            first_four = c[0, :4].cpu().tolist()
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
    base = CONFIGS_BY_SHAPE[TRACE_SHAPE]
    for direct_a in (True, False):
        for direct_b in (True, False):
            config = replace(
                base,
                group_tile_n=32,
                stage_k=32,
                split_k=4,
                left_in_registers=direct_a,
                right_in_registers=direct_b,
            )
            solve(config, (17, 19, 65))
    config = replace(
        base, group_tile_m=32, group_tile_n=32, waves_per_group_m=2,
        waves_per_group_n=2, stage_k=32, split_k=2,
    )
    solve(config, (35, 37, 49))
    config = replace(base, wave_groups_m=2, wave_groups_n=2, split_k=2)
    solve(config, (47, 23, 41))


def main():
    torch.set_num_threads(1)
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, default=TRACE_SHAPE)
    parser.add_argument("--check-only", action="store_true", help="Run the shape check")
    parser.add_argument("--edge-checks", action="store_true")
    parser.add_argument("--right-in-registers", action=argparse.BooleanOptionalAction)
    args = parser.parse_args([] if globals().get("_COURSE_CHECK_ONLY", False) else None)
    shape = tuple(args.shape)
    config = default_config(shape)
    if args.right_in_registers is not None:
        config = replace(config, right_in_registers=args.right_in_registers)
    try:
        print("Exercise passed:", solve(config, shape), flush=True)
        if args.edge_checks or globals().get("_COURSE_CHECK_ONLY", False):
            check_edges()
            print("B register staging edge checks passed", flush=True)
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None


if __name__ == "__main__":
    main()
