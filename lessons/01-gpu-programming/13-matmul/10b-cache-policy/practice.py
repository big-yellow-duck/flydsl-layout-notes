"""Practice 10b-cache-policy: fill the two expressions described in README.md."""

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
    right_cache_modifier: int = 0

    @property
    def name(self):
        return f"10b_m{self.block_m}n{self.block_n}k{self.block_k}_w{self.waves_m}x{self.waves_n}_sk{self.split_k}_wg{self.wave_groups_m}x{self.wave_groups_n}_bc{self.right_cache_modifier}"

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
        return (
            2
            * self.wave_groups
            * (self.block_m * (self.block_k + 8) + self.block_k * self.block_n)
        )


def validate_config(config, shape=(16, 1024, 8192)):
    bm, bn, bk = config.block_m, config.block_n, config.block_k
    if any(value <= 0 for value in (bm, bn, bk)):
        raise ValueError("Block dimensions must be positive")
    if len(shape) != 3 or any(value <= 0 for value in shape):
        raise ValueError("Shape must contain positive M,N,K")
    if any(size % tile for size, tile in zip(shape, (bm, bn, bk), strict=True)):
        raise ValueError("Shape must contain complete block tiles")
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
    if config.right_cache_modifier not in (0, 2):
        raise ValueError("Use the measured gfx11 B cache modifiers 0 or 2")
    physical_m = bm * config.wave_groups_m
    physical_n = bn * config.wave_groups_n
    if shape[1] % physical_n:
        raise ValueError("N must contain complete physical block tiles")
    if shape[0] % physical_m:
        raise ValueError("M must contain complete physical block tiles")
    for rows, columns in ((bm, bk), (bk, bn)):
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
    tile_rows = shape[0] // physical_m
    if tile_rows % min(config.group_m, tile_rows):
        raise ValueError("group_m must form complete physical block row groups")
    if config.lds_bytes > 65536:
        raise ValueError("LDS allocation exceeds this lesson's 64 KiB limit")
    return config


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
    RIGHT_CACHE_MODIFIER: fx.Constexpr,
    GROUP_M: fx.Constexpr,
    SPLIT_K: fx.Constexpr,
):
    MMA_M = 16
    MMA_N = 16
    MMA_K = 16
    WAVE_GROUPS = WAVE_GROUPS_M * WAVE_GROUPS_N
    # The physical thread block covers this output region in C.
    BLOCK_M = GROUP_TILE_M * WAVE_GROUPS_M
    BLOCK_N = GROUP_TILE_N * WAVE_GROUPS_N
    THREADS_PER_GROUP = 32 * WAVES_M * WAVES_N
    wave_group = fx.thread_idx.x // THREADS_PER_GROUP
    thread_id_in_wave_group = fx.thread_idx.x % THREADS_PER_GROUP

    group_layout = fx.make_layout((WAVE_GROUPS_M, WAVE_GROUPS_N), (WAVE_GROUPS_N, 1))
    group_coords = fx.idx2crd(wave_group, group_layout)
    group_row = fx.get_scalar(group_coords[0])
    group_col = fx.get_scalar(group_coords[1])

    blocks_m = m // BLOCK_M
    blocks_n = n // BLOCK_N
    group_m_width = min(blocks_m, GROUP_M)
    split_block_layout = fx.make_ordered_layout(
        (
            group_m_width,
            SPLIT_K,
            blocks_n,
            (blocks_m // group_m_width),
        ),
        (0, 1, 2, 3),
    )
    block_coords = fx.idx2crd(fx.block_idx.x, split_block_layout)
    row_in_group = fx.get_scalar(block_coords[0])
    split_id = fx.get_scalar(block_coords[1])
    block_col = fx.get_scalar(block_coords[2])
    m_group_id = fx.get_scalar(block_coords[3])

    block_row = m_group_id * group_m_width + row_in_group
    # setup global memory views
    left_buffer = fx.rocdl.make_buffer_tensor(left)
    right_buffer = fx.rocdl.make_buffer_tensor(right)
    out_buffer = fx.rocdl.make_buffer_tensor(out)

    left_global_view = fx.make_view(
        fx.get_iter(left_buffer), fx.make_layout((m, k), (k, 1))
    )
    right_global_view = fx.make_view(
        fx.get_iter(right_buffer), fx.make_layout((k, n), (n, 1))
    )
    out_global_view = fx.make_view(
        fx.get_iter(out_buffer), fx.make_layout((m, n), (n, 1))
    )

    out_block_tiles = fx.flat_divide(out_global_view, (BLOCK_M, BLOCK_N))
    out_block_view = fx.slice(out_block_tiles, (None, None, block_row, block_col))

    out_group_tiles = fx.flat_divide(out_block_view, (GROUP_TILE_M, GROUP_TILE_N))
    out_group_view = fx.slice(out_group_tiles, (None, None, group_row, group_col))

    # Workspace IDs name group output tiles independently of launch order.
    output_group_layout = fx.make_layout(
        (m // GROUP_TILE_M, n // GROUP_TILE_N),
        (n // GROUP_TILE_N, 1),
    )
    output_group_row = block_row * WAVE_GROUPS_M + group_row
    output_group_col = block_col * WAVE_GROUPS_N + group_col
    flat_group_id = fx.get_scalar(
        fx.crd2idx((output_group_row, output_group_col), output_group_layout)
    )

    # A/B block tiles cover the same output rows/columns for one K stage.
    left_block_tiles = fx.flat_divide(left_global_view, (BLOCK_M, STAGE_K))
    right_block_tiles = fx.flat_divide(right_global_view, (STAGE_K, BLOCK_N))

    # setup shared mem for each wave group
    @fx.struct
    class SharedMem:
        left: fx.Array[fx.BFloat16, WAVE_GROUPS * GROUP_TILE_M * (STAGE_K + 8), 16]
        right: fx.Array[fx.BFloat16, WAVE_GROUPS * GROUP_TILE_N * STAGE_K, 16]

    lds = fx.SharedAllocator().allocate(SharedMem).peek()

    # Independent wave groups synchronize only their own LDS readers/writers.
    lds_address_spaces = ir.ArrayAttr.get([
        ir.Attribute.parse("#gpu.address_space<workgroup>")
    ])
    barrier_scope = (
        gpu.BarrierScope.Subgroup if WAVE_GROUPS > 1 else gpu.BarrierScope.Workgroup
    )

    def lds_barrier():
        # LDS-only ordering; global split-K publication keeps its agent atomics.
        fx.barrier(address_spaces=lds_address_spaces, scope=barrier_scope)

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

    # get the lds views for each wave group
    left_group_lds_view = fx.slice(left_lds_all, (group_row, group_col, None, None))
    right_group_lds_view = fx.slice(right_lds_all, (group_row, group_col, None, None))

    # create copies for group
    copy_128b = fx.make_copy_atom(fx.UniversalCopy128b(), fx.BFloat16)
    gmem_left_load_128b = fx.make_copy_atom(fx.rocdl.BufferCopy128b(), fx.BFloat16)

    # use cache hint for right copies
    # TODO 1: Construct the B buffer operation with its cache-policy bits.
    right_load_operation = None
    if right_load_operation is None:
        raise NotImplementedError("Fill in right_load_operation.")
    # TODO 2: Wrap the buffer operation in a BF16 copy atom.
    gmem_right_load_128b = None
    if gmem_right_load_128b is None:
        raise NotImplementedError("Fill in gmem_right_load_128b.")

    # setup copies for gmem to register and registers to lds
    left_staging_thread_layout = fx.make_ordered_layout(
        (THREADS_PER_GROUP // (STAGE_K // 8), STAGE_K // 8), (1, 0)
    )
    right_staging_thread_layout = fx.make_ordered_layout(
        (THREADS_PER_GROUP // (GROUP_TILE_N // 8), GROUP_TILE_N // 8), (1, 0)
    )
    staging_value_layout = fx.make_ordered_layout((1, 8), (1, 0))
    left_staging_copy_tile, left_staging_copy_tv = fx.make_layout_tv(
        left_staging_thread_layout, staging_value_layout
    )
    right_staging_copy_tile, right_staging_copy_tv = fx.make_layout_tv(
        right_staging_thread_layout, staging_value_layout
    )
    left_staging_copy_plan = fx.make_tiled_copy(
        copy_128b, left_staging_copy_tv, left_staging_copy_tile
    )
    right_staging_copy_plan = fx.make_tiled_copy(
        copy_128b, right_staging_copy_tv, right_staging_copy_tile
    )
    # Select each thread's staging ownership within its compute group.
    left_thread_staging_copy = left_staging_copy_plan.get_slice(thread_id_in_wave_group)
    right_thread_staging_copy = right_staging_copy_plan.get_slice(
        thread_id_in_wave_group
    )
    left_lds_destination = left_thread_staging_copy.partition_D(left_group_lds_view)
    right_lds_destination = right_thread_staging_copy.partition_D(right_group_lds_view)
    left_staging_fragment = fx.make_fragment_like(left_lds_destination)
    right_staging_fragment = fx.make_fragment_like(right_lds_destination)

    # setup tiled views for mma to consume
    left_group_lds_tiled = fx.flat_divide(left_group_lds_view, (GROUP_TILE_M, MMA_K))
    right_lds_group_transposed_view = fx.make_view(
        fx.get_iter(right_group_lds_view),
        fx.make_layout((GROUP_TILE_N, STAGE_K), (1, GROUP_TILE_N)),
    )
    right_lds_group_transposed_tiled = fx.flat_divide(
        right_lds_group_transposed_view, (GROUP_TILE_N, MMA_K)
    )

    # initial views for loading to registers
    left_lds_group_initial_view = fx.slice(left_group_lds_tiled, (None, None, 0, 0))
    right_lds_group_transposed_initial_view = fx.slice(
        right_lds_group_transposed_tiled, (None, None, 0, 0)
    )
    mma_atom = fx.make_mma_atom(
        fx.rocdl.WMMA(MMA_M, MMA_N, MMA_K, fx.BFloat16, fx.Float32)
    )

    mma = fx.make_tiled_mma(
        mma_atom, fx.make_layout((WAVES_M, WAVES_N, 1), (1, WAVES_M, 0))
    )
    thread_mma = mma.thr_slice(thread_id_in_wave_group)
    accumulator = thread_mma.make_fragment_C(out_group_view)
    ACCUMULATOR_VALUES = fx.size(accumulator.shape).to_py_value()
    accumulator.fill(0)

    # lds to register copies
    copy_16b = fx.make_copy_atom(fx.UniversalCopy16b(), fx.BFloat16)
    left_lds2reg_copy_plan = fx.make_tiled_copy_A(copy_16b, mma)
    right_lds2reg_copy_plan = fx.make_tiled_copy_B(copy_16b, mma)

    left_lds2reg_thread_copy = left_lds2reg_copy_plan.get_slice(thread_id_in_wave_group)
    right_lds2reg_thread_copy = right_lds2reg_copy_plan.get_slice(
        thread_id_in_wave_group
    )

    left_r_tile = thread_mma.make_fragment_A(left_lds_group_initial_view)
    right_r_tile = thread_mma.make_fragment_B(right_lds_group_transposed_initial_view)

    left_r_destination = left_lds2reg_thread_copy.retile(left_r_tile)
    right_r_destination = right_lds2reg_thread_copy.retile(right_r_tile)

    def create_gmem2reg_source(left_block_view, right_block_view):
        return (
            left_thread_staging_copy.partition_S(left_block_view),
            right_thread_staging_copy.partition_S(right_block_view),
        )

    def gmem2reg_load_tile(tile_k):
        # tile_k is the global K-stage index, including the split's starting stage.
        left_block_view = fx.slice(left_block_tiles, (None, None, block_row, tile_k))
        right_block_view = fx.slice(right_block_tiles, (None, None, tile_k, block_col))
        left_group_tiles = fx.flat_divide(left_block_view, (GROUP_TILE_M, STAGE_K))
        right_group_tiles = fx.flat_divide(right_block_view, (STAGE_K, GROUP_TILE_N))
        # A varies with the group's M coordinate; B varies with its N coordinate.
        left_group_view = fx.slice(left_group_tiles, (None, None, group_row, 0))
        right_group_view = fx.slice(right_group_tiles, (None, None, 0, group_col))
        left_global_source, right_global_source = create_gmem2reg_source(
            left_group_view, right_group_view
        )
        fx.copy(gmem_left_load_128b, left_global_source, left_staging_fragment)
        fx.copy(gmem_right_load_128b, right_global_source, right_staging_fragment)

    def reg2lds_copy_tile():
        fx.copy(copy_128b, left_staging_fragment, left_lds_destination)
        fx.copy(copy_128b, right_staging_fragment, right_lds_destination)
        lds_barrier()

    def compute_lds():
        # Consume this group's staged operands in MMA_K-wide register fragments.
        for inner_k in fx.range_constexpr(STAGE_K // MMA_K):
            left_mma_view = fx.slice(left_group_lds_tiled, (None, None, 0, inner_k))
            right_mma_view = fx.slice(
                right_lds_group_transposed_tiled, (None, None, 0, inner_k)
            )
            left_r_source = left_lds2reg_thread_copy.partition_S(left_mma_view)
            right_r_source = right_lds2reg_thread_copy.partition_S(right_mma_view)
            fx.copy(copy_16b, left_r_source, left_r_destination)
            fx.copy(copy_16b, right_r_source, right_r_destination)
            fx.gemm(mma_atom, accumulator, left_r_tile, right_r_tile, accumulator)

    # compute
    tiles_per_split = k // (STAGE_K * SPLIT_K)
    initial_tile_k = split_id * tiles_per_split
    gmem2reg_load_tile(initial_tile_k)
    reg2lds_copy_tile()

    for local_tile in range(tiles_per_split - 1):
        next_tile_k = initial_tile_k + local_tile + 1
        gmem2reg_load_tile(next_tile_k)
        compute_lds()
        lds_barrier()
        reg2lds_copy_tile()

    compute_lds()
    lds_barrier()

    def store_output():
        out_registers = fx.make_rmem_tensor(accumulator.layout, fx.BFloat16)
        for slot in fx.range_constexpr(ACCUMULATOR_VALUES):
            out_registers[slot] = accumulator[slot].to(fx.BFloat16)
        # The MMA C plan maps each thread's slots into this group's output view.
        gmem_store_16b = fx.make_copy_atom(fx.rocdl.BufferCopy16b(), fx.BFloat16)
        reg2gmem_copy_plan = fx.make_tiled_copy_C(gmem_store_16b, mma)
        reg2gmem_thread_copy = reg2gmem_copy_plan.get_slice(thread_id_in_wave_group)
        reg2gmem_source = reg2gmem_thread_copy.retile(out_registers)
        reg2gmem_dest = reg2gmem_thread_copy.partition_D(out_group_view)
        fx.copy(gmem_store_16b, reg2gmem_source, reg2gmem_dest)

    if SPLIT_K == 1:
        store_output()
    else:

        # Publish this thread's FP32 slots to the group's distinct split plane.
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

        # One counter per (group output tile, thread), shared by split-K peers.
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
    RIGHT_CACHE_MODIFIER: fx.Constexpr,
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
        RIGHT_CACHE_MODIFIER=RIGHT_CACHE_MODIFIER,
        GROUP_M=GROUP_M,
        SPLIT_K=SPLIT_K,
    ).launch(
        grid=(m // BLOCK_M * (n // BLOCK_N) * SPLIT_K, 1, 1),
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
        right_cache_modifier=2,
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
        right_cache_modifier=2,
    ),
    (32, 1024, 8192): Config(
        block_m=32,
        block_n=64,
        block_k=64,
        waves_m=1,
        waves_n=2,
        group_m=1,
        split_k=4,
        wave_groups_m=1,
        wave_groups_n=1,
        right_cache_modifier=2,
    ),
}


@lru_cache(maxsize=128)
def _workspace_for(config, shape, device, stream, capture_id):
    """Cache buffers per config/device/stream/capture; this never launches GEMM."""
    if config.split_k == 1:
        return None
    m, n, _ = shape
    tiles = (m // config.block_m) * (n // config.block_n)
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

    Unsupported calls raise an error. Supply config for compatible shapes
    outside CONFIGS_BY_SHAPE. Split-K scratch is cached per device/stream/capture
    and allocated only for split_k > 1. Warm up before graph capture.
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
        config = CONFIGS_BY_SHAPE.get(shape)
        if config is None:
            raise ValueError(
                f"No default config for M,N,K={shape}; supply config=Config(...)"
            )
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
            RIGHT_CACHE_MODIFIER=config.right_cache_modifier,
            GROUP_M=config.group_m,
            SPLIT_K=config.split_k,
        )
        if supplied_out:
            torch.autograd.graph.increment_version(out)
    return out


def check_boundaries(config):
    """Trace every split's partials through one, two, and three local K tiles."""
    checked = []
    for tiles_per_split in (1, 2, 3):
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
        out = storage[:-16].view(m, n)
        out.fill_(float("nan"))

        matmul_bf16(a, b, out=out, config=config)
        torch.cuda.synchronize()
        partials = [
            config.block_k * (part + 1) * (2**tiles_per_split - 1)
            for part in range(config.split_k)
        ]
        expected = torch.full((m, n), sum(partials), dtype=torch.bfloat16)
        torch.testing.assert_close(out.cpu(), expected, rtol=0, atol=0)
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
        checked.append({
            "tiles_per_split": tiles_per_split,
            "partial_values": partials,
            "sum_before_bf16": sum(partials),
        })
    return checked


def solve(config=None, shape=SHAPES[2], seed=13):
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
        out = storage[:-16].view(m, n)
        expected = (a_cpu.float() @ b_cpu.float()).to(torch.bfloat16)
        for sign in (1, -1, 1):
            # Change inputs and poison output between reuses of the SAME workspace.
            a.copy_(a_cpu * sign)
            out.fill_(float("nan"))
            matmul_bf16(a, b, out=out, config=config)
            torch.cuda.synchronize()
            torch.testing.assert_close(
                out.cpu(),
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
            first_four = out[0, :4].cpu().tolist()
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
    parser.add_argument("--shape", type=int, nargs=3, default=SHAPES[2])
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
                json.dumps({
                    "timing": args.timing,
                    "shape_MNK": shape,
                    "graph_metadata": report["graph_metadata"],
                    "scope": "warm inputs, preallocated output, cached workspace; graph workspace initialization included",
                })
            )
            for name, elapsed in report["median_ms"].items():
                label = config.name if name == "stage" else name
                print(
                    json.dumps({
                        "name": label,
                        "ms": elapsed,
                        "effective_TFLOP_s": 2
                        * shape[0]
                        * shape[1]
                        * shape[2]
                        / (elapsed * 1e9),
                    })
                )
            print(json.dumps({"paired_native_torch_ratio": report["paired_ratio"]}))
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None


if __name__ == "__main__":
    main()
