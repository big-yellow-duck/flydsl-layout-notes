"""Practice 10a-synchronization-scope: fill the two expressions described in README.md."""

import argparse
import json
import runpy
from dataclasses import dataclass
from functools import lru_cache
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch
from flydsl._mlir import ir
from flydsl._mlir.dialects import gpu, scf  # noqa: F401 -- gpu is used by TODO 2


@dataclass(frozen=True)
class Config:
    block_m: int = 16
    block_n: int = 64
    block_k: int = 64
    waves_m: int = 1
    waves_n: int = 2
    group_m: int = 1
    split_k: int = 4
    wave_groups: int = 1
    sync_mode: str = "lds-subgroup"

    @property
    def name(self):
        return f"10a_m{self.block_m}n{self.block_n}k{self.block_k}_w{self.waves_m}x{self.waves_n}_sk{self.split_k}_wg{self.wave_groups}_sync{self.sync_mode}"

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
    if config.wave_groups not in (1, 2, 4, 8):
        raise ValueError("wave_groups must be 1, 2, 4, or 8")
    if config.wave_groups > 1 and config.compute_threads != 32:
        raise ValueError("Independent groups each contain exactly one wave32")
    if config.sync_mode not in ("workgroup", "lds-workgroup", "lds-subgroup"):
        raise ValueError(
            "Use workgroup, lds-workgroup, or lds-subgroup synchronization"
        )
    logical_blocks = (shape[0] // bm) * (shape[1] // bn) * config.split_k
    if logical_blocks % config.wave_groups:
        raise ValueError("Logical blocks must form complete independent wave groups")
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
    tile_rows = shape[0] // bm
    if tile_rows % min(config.group_m, tile_rows):
        raise ValueError("group_m must form complete output tile row groups")
    if config.lds_bytes > 65536:
        raise ValueError("LDS allocation exceeds this lesson's 64 KiB limit")
    return config


@lru_cache(None)
def build(config):
    """Create one native specialization; compilation is lazy on its first launch."""
    validate_config(
        config,
        (
            config.block_m,
            config.block_n * config.wave_groups,
            config.block_k * config.split_k,
        ),
    )
    BLOCK_M, BLOCK_N, BLOCK_K = config.block_m, config.block_n, config.block_k
    MMA_M, MMA_N, MMA_K = 16, 16, 16
    WAVES_M, WAVES_N = config.waves_m, config.waves_n
    THREADS_PER_GROUP = 32 * WAVES_M * WAVES_N
    THREADS_PER_BLOCK = THREADS_PER_GROUP * config.wave_groups
    WAVE_GROUPS = config.wave_groups
    SYNC_MODE = config.sync_mode
    ACCUMULATOR_VALUES = 8 * (BLOCK_M // (16 * WAVES_M)) * (BLOCK_N // (16 * WAVES_N))
    GROUP_M = config.group_m
    SPLIT_K = config.split_k

    @fx.struct
    class SharedStorage:
        # Retain stage 06's measured padded A layout and packed B layout.
        left: fx.Array[fx.BFloat16, WAVE_GROUPS * BLOCK_M * (BLOCK_K + 8), 16]
        right: fx.Array[fx.BFloat16, WAVE_GROUPS * BLOCK_K * BLOCK_N, 16]

    @flyc.kernel
    def exercise_kernel(
        left: fx.Tensor,
        right: fx.Tensor,
        out: fx.Tensor,
        partials: fx.Tensor,
        counters: fx.Tensor,
        m: fx.Constexpr,
        n: fx.Constexpr,
        k: fx.Constexpr,
    ):
        # Map each physical block's independent wave to one logical block.
        wave_group = fx.thread_idx.x // THREADS_PER_GROUP
        compute_thread_id = fx.thread_idx.x % THREADS_PER_GROUP
        logical_block_id = fx.block_idx.x * WAVE_GROUPS + wave_group
        # TODO 1: Select the LDS memory address space.
        lds_address_spaces = None
        if lds_address_spaces is None:
            raise NotImplementedError("Fill in lds_address_spaces.")
        # TODO 2: Use subgroup execution only for an independent single-wave group.
        barrier_scope = None
        if barrier_scope is None:
            raise NotImplementedError("Fill in barrier_scope.")

        def lds_barrier():
            # LDS-only ordering; global split-K publication keeps its agent atomics.
            if SYNC_MODE == "workgroup":
                fx.barrier()
            else:
                fx.barrier(address_spaces=lds_address_spaces, scope=barrier_scope)

        # 1. Buffer resources retain the existing row-major matrix layouts.
        left_buffer = fx.rocdl.make_buffer_tensor(left)
        right_buffer = fx.rocdl.make_buffer_tensor(right)
        out_buffer = fx.rocdl.make_buffer_tensor(out)
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
        # Keep the grouped strategy; express block selection with native layouts.
        tiles_m = m // BLOCK_M
        tiles_n = n // BLOCK_N
        split_block_layout = fx.make_layout((SPLIT_K, tiles_m * tiles_n), (1, SPLIT_K))
        split_block_coords = fx.idx2crd(logical_block_id, split_block_layout)
        split_id = fx.get_scalar(split_block_coords[0])
        flat_block_id = fx.get_scalar(split_block_coords[1])
        group_width = min(GROUP_M, tiles_m)
        block_tile_order = fx.make_layout(
            (group_width, tiles_n, tiles_m // group_width),
            (tiles_n, 1, group_width * tiles_n),
        )
        output_tile_offset = fx.crd2idx(flat_block_id, block_tile_order)
        output_tile_layout = fx.make_layout((tiles_m, tiles_n), (tiles_n, 1))
        output_tile_coords = fx.idx2crd(output_tile_offset, output_tile_layout)
        block_row = fx.get_scalar(output_tile_coords[0])
        block_col = fx.get_scalar(output_tile_coords[1])

        # 2. Group neighboring blocks along M to share B tiles in cache.
        left_tiled_view = fx.flat_divide(left_global_view, (BLOCK_M, BLOCK_K))
        right_tiled_view = fx.flat_divide(right_global_view, (BLOCK_K, BLOCK_N))
        out_tiled_view = fx.flat_divide(out_global_view, (BLOCK_M, BLOCK_N))
        out_block_view = fx.slice(out_tiled_view, (None, None, block_row, block_col))

        # 3. Keep one padded A tile and one packed B tile in LDS.
        lds = fx.SharedAllocator().allocate(SharedStorage).peek()
        left_lds_view = lds.left.view(
            fx.make_layout((BLOCK_M, BLOCK_K), (BLOCK_K + 8, 1))
        )
        right_lds_view = lds.right.view(
            fx.make_layout((BLOCK_K, BLOCK_N), (BLOCK_N, 1))
        )

        # Each independent group has disjoint LDS storage for its own tile.
        left_lds_view = fx.make_view(
            fx.get_iter(left_lds_view) + wave_group * BLOCK_M * (BLOCK_K + 8),
            left_lds_view.layout,
        )
        right_lds_view = fx.make_view(
            fx.get_iter(right_lds_view) + wave_group * BLOCK_K * BLOCK_N,
            right_lds_view.layout,
        )

        # 4. Derive each operand's staging geometry from its contiguous extent.
        copy_128b = fx.make_copy_atom(fx.UniversalCopy128b(), fx.BFloat16)
        gmem_left_load_128b = fx.make_copy_atom(fx.rocdl.BufferCopy128b(), fx.BFloat16)
        gmem_right_load_128b = fx.make_copy_atom(fx.rocdl.BufferCopy128b(), fx.BFloat16)
        left_copy_threads = fx.make_ordered_layout(
            (THREADS_PER_GROUP // (BLOCK_K // 8), BLOCK_K // 8), (1, 0)
        )
        right_copy_threads = fx.make_ordered_layout(
            (THREADS_PER_GROUP // (BLOCK_N // 8), BLOCK_N // 8), (1, 0)
        )
        copy_values = fx.make_ordered_layout((1, 8), (1, 0))
        left_copy_tile, left_copy_tv = fx.make_layout_tv(left_copy_threads, copy_values)
        right_copy_tile, right_copy_tv = fx.make_layout_tv(
            right_copy_threads, copy_values
        )
        left_copy_plan = fx.make_tiled_copy(copy_128b, left_copy_tv, left_copy_tile)
        right_copy_plan = fx.make_tiled_copy(copy_128b, right_copy_tv, right_copy_tile)
        left_thread_copy = left_copy_plan.get_slice(compute_thread_id)
        right_thread_copy = right_copy_plan.get_slice(compute_thread_id)
        gmem2lds_left_destination = left_thread_copy.partition_D(left_lds_view)
        gmem2lds_right_destination = right_thread_copy.partition_D(right_lds_view)
        left_fragment = fx.make_fragment_like(gmem2lds_left_destination)
        right_fragment = fx.make_fragment_like(gmem2lds_right_destination)

        # create tiled view ready for mma to consume
        left_lds_tiled = fx.flat_divide(left_lds_view, (BLOCK_M, MMA_K))
        right_lds_tranposed_view = fx.make_view(
            fx.get_iter(right_lds_view),
            fx.make_layout((BLOCK_N, BLOCK_K), (1, BLOCK_N)),
        )
        right_lds_transposed_tiled = fx.flat_divide(
            right_lds_tranposed_view, (BLOCK_N, MMA_K)
        )

        # setup initial views
        left_lds_initial_view = fx.slice(left_lds_tiled, (None, None, 0, 0))
        right_lds_transposed_initial_view = fx.slice(
            right_lds_transposed_tiled, (None, None, 0, 0)
        )
        # setup mma
        mma_atom = fx.make_mma_atom(
            fx.rocdl.WMMA(MMA_M, MMA_N, MMA_K, fx.BFloat16, fx.Float32)
        )
        mma = fx.make_tiled_mma(
            mma_atom, fx.make_layout((WAVES_M, WAVES_N, 1), (1, WAVES_M, 0))
        )

        thread_mma = mma.thr_slice(compute_thread_id)
        accumulator = thread_mma.make_fragment_C(out_block_view)
        accumulator.fill(0)

        # lds to register copies using mma compatible plans
        copy_16b = fx.make_copy_atom(fx.UniversalCopy16b(), fx.BFloat16)
        lds2reg_left_copy_plan = fx.make_tiled_copy_A(copy_16b, mma)
        lds2reg_right_copy_plan = fx.make_tiled_copy_B(copy_16b, mma)

        lds2reg_left_thread_copy = lds2reg_left_copy_plan.get_slice(compute_thread_id)
        lds2reg_right_thread_copy = lds2reg_right_copy_plan.get_slice(compute_thread_id)

        left_r_tile = thread_mma.make_fragment_A(left_lds_initial_view)
        right_r_tile = thread_mma.make_fragment_B(right_lds_transposed_initial_view)

        left_r_destination = lds2reg_left_thread_copy.retile(left_r_tile)
        right_r_destination = lds2reg_right_thread_copy.retile(right_r_tile)

        def create_gmem2lds_sources(left_block_view, right_block_view):
            return (
                left_thread_copy.partition_S(left_block_view),
                right_thread_copy.partition_S(right_block_view),
            )

        def gmem2reg_load_tile(tile_k):
            left_block_view = fx.slice(left_tiled_view, (None, None, block_row, tile_k))
            right_block_view = fx.slice(
                right_tiled_view, (None, None, tile_k, block_col)
            )
            left_lds_source, right_lds_source = create_gmem2lds_sources(
                left_block_view, right_block_view
            )
            fx.copy(gmem_left_load_128b, left_lds_source, left_fragment)
            fx.copy(gmem_right_load_128b, right_lds_source, right_fragment)

        def reg2lds_copy_tile():
            fx.copy(copy_128b, left_fragment, gmem2lds_left_destination)
            fx.copy(copy_128b, right_fragment, gmem2lds_right_destination)
            lds_barrier()

        def compute_lds():
            for inner_k in fx.range_constexpr(BLOCK_K // MMA_K):
                left_mma_view = fx.slice(left_lds_tiled, (None, None, 0, inner_k))
                right_mma_view = fx.slice(
                    right_lds_transposed_tiled, (None, None, 0, inner_k)
                )
                left_r_source = lds2reg_left_thread_copy.partition_S(left_mma_view)
                right_r_source = lds2reg_right_thread_copy.partition_S(right_mma_view)
                fx.copy(copy_16b, left_r_source, left_r_destination)
                fx.copy(copy_16b, right_r_source, right_r_destination)
                fx.gemm(mma_atom, accumulator, left_r_tile, right_r_tile, accumulator)

        # 6. Prefetch next globals while consuming the current LDS tile.
        # Prologue: make tile 0 visible in LDS before any consumer reads it.
        tiles_per_split = k // (BLOCK_K * SPLIT_K)
        initial_tile_k = split_id * tiles_per_split
        gmem2reg_load_tile(initial_tile_k)
        reg2lds_copy_tile()
        # Steady state: prefetch next globals into private registers, consume LDS,
        # protect current readers, then publish the next tile into the same LDS.
        for local_tile in range(tiles_per_split - 1):
            next_tile_k = initial_tile_k + local_tile + 1
            gmem2reg_load_tile(next_tile_k)
            compute_lds()
            lds_barrier()
            reg2lds_copy_tile()
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
            reg2gmem_dest = reg2gmem_thread_copy.partition_D(out_block_view)
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
    def run(
        left: fx.Tensor,
        right: fx.Tensor,
        out: fx.Tensor,
        partials: fx.Tensor,
        counters: fx.Tensor,
        m: fx.Constexpr,
        n: fx.Constexpr,
        k: fx.Constexpr,
        stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
    ):
        exercise_kernel(left, right, out, partials, counters, m, n, k).launch(
            grid=((m // BLOCK_M) * (n // BLOCK_N) * SPLIT_K // WAVE_GROUPS, 1, 1),
            block=(THREADS_PER_BLOCK, 1, 1),
            stream=stream,
        )

    return run


SHAPES = ((16, 1024, 8192), (32, 1024, 8192), (16, 4096, 8192))
CONFIGS_BY_SHAPE = {
    (16, 1024, 8192): Config(16, 64, 32, 1, 2, split_k=4, sync_mode="lds-subgroup"),
    (32, 1024, 8192): Config(32, 64, 64, 1, 2, split_k=4, sync_mode="lds-subgroup"),
    (16, 4096, 8192): Config(
        16, 64, 16, 1, 1, split_k=1, wave_groups=2, sync_mode="lds-subgroup"
    ),
}


def make_workspace(config, shape):
    """Allocate once; only counters need initialization. Reuse on one stream."""
    validate_config(config, shape)
    m, n, _ = shape
    tiles = (m // config.block_m) * (n // config.block_n)
    partial_count = tiles * config.split_k * config.block_m * config.block_n
    counter_count = tiles * config.compute_threads
    partial_storage = torch.full(
        (partial_count + 16,), -777, dtype=torch.float32, device="cuda"
    )
    counter_storage = torch.zeros(
        (counter_count + 16,), dtype=torch.int32, device="cuda"
    )
    counter_storage[-16:] = -123
    return partial_storage, counter_storage


def launch_for(config, shape):
    run = build(config)
    partial_storage, counter_storage = make_workspace(config, shape)

    def launch(left, right, out, stream=None):
        stream_arg = fx.Stream(None) if stream is None else fx.Stream(stream)
        run(
            left,
            right,
            out,
            partial_storage[:-16],
            counter_storage[:-16],
            *shape,
            stream_arg,
        )

    launch.workspace = (partial_storage, counter_storage)
    return launch


def check_workspace(launch):
    partial_storage, counter_storage = launch.workspace
    assert torch.all(partial_storage[-16:] == -777).item(), "Partial sentinel changed"
    assert torch.all(counter_storage[:-16] == 0).item(), "Arrival counters not reset"
    assert torch.all(counter_storage[-16:] == -123).item(), "Counter sentinel changed"


def check_boundaries(config):
    """Trace every split's partials through one, two, and three local K tiles."""
    checked = []
    for tiles_per_split in (1, 2, 3):
        m, n = config.block_m, config.block_n * config.wave_groups
        k = config.block_k * config.split_k * tiles_per_split
        tile_ids = torch.arange(k) // config.block_k
        split_ids = tile_ids // tiles_per_split
        tags = (split_ids + 1) * 2 ** (tile_ids % tiles_per_split)
        a = tags.to(torch.bfloat16).expand(m, k).contiguous().cuda()
        b = torch.ones((k, n), dtype=torch.bfloat16, device="cuda")
        storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
        out = storage[:-16].view(m, n)
        out.fill_(float("nan"))
        launch = launch_for(config, (m, n, k))
        launch(a, b, out)
        torch.cuda.synchronize()
        partials = [
            config.block_k * (part + 1) * (2**tiles_per_split - 1)
            for part in range(config.split_k)
        ]
        expected = torch.full((m, n), sum(partials), dtype=torch.bfloat16)
        torch.testing.assert_close(out.cpu(), expected, rtol=0, atol=0)
        if config.split_k > 1:
            actual_partials = (
                launch.workspace[0][:-16]
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
        check_workspace(launch)
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


def solve(config=None, shape=SHAPES[2], seed=13):
    shape = tuple(shape)
    config = CONFIGS_BY_SHAPE[shape] if config is None else config
    validate_config(config, shape)
    arch = torch.cuda.get_device_properties(0).gcnArchName.split(":")[0]
    if arch not in ("gfx1151", "gfx1152"):
        raise RuntimeError(f"This lesson supports gfx1151/gfx1152; detected {arch}")
    m, n, k = shape
    launch = launch_for(config, shape)
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
            launch(a, b, out)
            torch.cuda.synchronize()
            torch.testing.assert_close(
                out.cpu(),
                expected * sign,
                rtol=0 if pattern == "trace" else 0.016,
                atol=0.001 if pattern == "trace" else 0.03125,
            )
            assert torch.all(storage[-16:] == -99).item(), "Output sentinel changed"
            check_workspace(launch)
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
                config, shape, args.timing, launch_factory=launch_for
            )
            print(
                json.dumps(
                    {
                        "timing": args.timing,
                        "shape_MNK": shape,
                        "graph_metadata": report["graph_metadata"],
                        "scope": "warm inputs, preallocated output/workspace, initialization excluded",
                    }
                )
            )
            for name, elapsed in report["median_ms"].items():
                label = config.name if name == "stage" else name
                print(
                    json.dumps(
                        {
                            "name": label,
                            "ms": elapsed,
                            "effective_TFLOP_s": 2
                            * shape[0]
                            * shape[1]
                            * shape[2]
                            / (elapsed * 1e9),
                        }
                    )
                )
            print(json.dumps({"paired_native_torch_ratio": report["paired_ratio"]}))
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None


if __name__ == "__main__":
    main()
