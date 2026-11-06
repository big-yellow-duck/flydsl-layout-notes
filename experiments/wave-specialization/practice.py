"""Dedicated loader/compute waves exchange BF16 GEMM tiles through an LDS ring.

Run from the repository root:
    pixi run python lessons/01-gpu-programming/13-matmul/11-wave-specialization/practice.py
    pixi run python lessons/01-gpu-programming/13-matmul/11-wave-specialization/solution.py
"""

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
from flydsl._mlir.dialects import gpu, scf


def copy_values(rows, columns, threads):
    """Choose the widest complete per-thread vector for this loader domain."""
    for values in (8, 4, 2, 1):
        chunks = columns // values
        if columns % values or chunks > threads or threads % chunks:
            continue
        if rows % (threads // chunks) == 0:
            return values
    raise ValueError("Loader waves must own complete cooperative copy vectors")


@dataclass(frozen=True)
class Config:
    block_m: int = 32
    block_n: int = 64
    block_k: int = 64
    waves_m: int = 1
    waves_n: int = 2
    group_m: int = 1
    split_k: int = 4
    loader_waves: int = 1
    lds_stages: int = 2
    right_cache_modifier: int = 2
    poll_sleep: int = 0
    signal_mode: str = "auto"
    protocol: str = "barrier"

    @property
    def name(self):
        return f"m{self.block_m}n{self.block_n}k{self.block_k}_cw{self.waves_m}x{self.waves_n}_lw{self.loader_waves}_lds{self.lds_stages}_sk{self.split_k}_bc{self.right_cache_modifier}_sleep{self.poll_sleep}_{self.signal_mode}_{self.protocol}"

    @property
    def compute_waves(self):
        return self.waves_m * self.waves_n

    @property
    def compute_threads(self):
        return 32 * self.compute_waves

    @property
    def loader_threads(self):
        return 32 * self.loader_waves

    @property
    def threads(self):
        return self.loader_threads + self.compute_threads

    @property
    def accumulator_values(self):
        return (
            8
            * (self.block_m // (16 * self.waves_m))
            * (self.block_n // (16 * self.waves_n))
        )

    @property
    def left_copy_values(self):
        return copy_values(self.block_m, self.block_k, self.loader_threads)

    @property
    def right_copy_values(self):
        return copy_values(self.block_k, self.block_n, self.loader_threads)

    @property
    def lds_bytes(self):
        return self.lds_stages * (
            2 * (self.block_m * (self.block_k + 8) + self.block_k * self.block_n)
            + (16 if self.protocol == "semaphore" else 0)
        )


def validate_config(config, shape=(32, 1024, 8192)):
    bm, bn, bk = config.block_m, config.block_n, config.block_k
    if len(shape) != 3 or any(value <= 0 for value in (*shape, bm, bn, bk)):
        raise ValueError("Shape and block extents must be positive")
    if any(size % tile for size, tile in zip(shape, (bm, bn, bk), strict=True)):
        raise ValueError("Shape must contain complete block tiles")
    if config.split_k not in (1, 2, 4) or shape[2] % (bk * config.split_k):
        raise ValueError("Use 1/2/4 complete, equal K partitions")
    if config.loader_waves not in (1, 2, 4):
        raise ValueError("Use one, two, or four loader waves")
    if (
        config.waves_m < 1
        or config.waves_n < 1
        or config.compute_waves not in (1, 2, 4)
    ):
        raise ValueError("Use one, two, or four compute waves")
    if config.threads > 256:
        raise ValueError("Use at most eight resident wave32 groups per block")
    if bm % (16 * config.waves_m) or bn % (16 * config.waves_n) or bk % 16:
        raise ValueError("Block tile must contain whole WMMA groups and K fragments")
    if config.lds_stages not in (1, 2, 3, 4):
        raise ValueError("Use one to four LDS ring slots")
    if config.right_cache_modifier not in (0, 2) or config.poll_sleep not in (0, 1, 2):
        raise ValueError("Use B cache modifier 0/2 and polling sleep 0/1/2")
    if config.protocol == "barrier" and (
        config.poll_sleep != 0 or config.signal_mode != "auto"
    ):
        raise ValueError("Polling and signal controls apply to the semaphore protocol")
    if config.protocol not in ("barrier", "semaphore"):
        raise ValueError("Use barrier or semaphore wave specialization")
    if config.signal_mode not in ("auto", "atomic"):
        raise ValueError("Use auto single-writer stores or atomic signals")
    if config.group_m < 1 or (shape[0] // bm) % min(config.group_m, shape[0] // bm):
        raise ValueError("group_m must form complete output tile row groups")
    if config.lds_bytes > 65536:
        raise ValueError("LDS allocation exceeds this lesson's 64 KiB limit")
    copy_values(bm, bk, config.loader_threads)
    copy_values(bk, bn, config.loader_threads)
    return config


@lru_cache(None)
def build(config, debug=False):
    """Build one native producer/consumer specialization; no compute-wave prefetch."""
    validate_config(
        config, (config.block_m, config.block_n, config.block_k * config.split_k)
    )
    BLOCK_M, BLOCK_N, BLOCK_K = config.block_m, config.block_n, config.block_k
    WAVES_M, WAVES_N = config.waves_m, config.waves_n
    LOADER_WAVES, COMPUTE_WAVES = config.loader_waves, config.compute_waves
    LOADER_THREADS, COMPUTE_THREADS = config.loader_threads, config.compute_threads
    THREADS_PER_BLOCK = config.threads
    STAGES, SPLIT_K, GROUP_M = config.lds_stages, config.split_k, config.group_m
    LEFT_VALUES, RIGHT_VALUES = config.left_copy_values, config.right_copy_values
    LEFT_STAGE_VALUES = BLOCK_M * (BLOCK_K + 8)
    RIGHT_STAGE_VALUES = BLOCK_K * BLOCK_N
    RIGHT_CACHE_MODIFIER, POLL_SLEEP = config.right_cache_modifier, config.poll_sleep
    ATOMIC_SIGNALS = config.signal_mode == "atomic"
    ACCUMULATOR_VALUES = config.accumulator_values
    MMA_M, MMA_N, MMA_K = 16, 16, 16
    DEBUG = debug
    PROTOCOL = config.protocol
    LOCAL_SCOPE = fx.rocdl.SyncScope.WorkgroupOneAs

    @fx.struct
    class SharedStorage:
        left: fx.Array[fx.BFloat16, STAGES * LEFT_STAGE_VALUES, 16]
        right: fx.Array[fx.BFloat16, STAGES * RIGHT_STAGE_VALUES, 16]
        # Per slot: ready arrivals, finished-reader arrivals, two diagnostic guards.
        sync: fx.Array[fx.Int32, 4 * STAGES, 16]

    @flyc.kernel
    def exercise_kernel(
        left: fx.Tensor,
        right: fx.Tensor,
        out: fx.Tensor,
        partials: fx.Tensor,
        counters: fx.Tensor,
        sync_trace: fx.Tensor,
        m: fx.Constexpr,
        n: fx.Constexpr,
        k: fx.Constexpr,
    ):
        # 1. Preserve the flat output-tile / split-K mapping from stage 09.
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
        tiles_m, tiles_n = m // BLOCK_M, n // BLOCK_N
        split_block_layout = fx.make_layout((SPLIT_K, tiles_m * tiles_n), (1, SPLIT_K))
        split_block_coords = fx.idx2crd(fx.block_idx.x, split_block_layout)
        split_id = fx.get_scalar(split_block_coords[0])
        flat_block_id = fx.get_scalar(split_block_coords[1])
        group_width = min(GROUP_M, tiles_m)
        block_tile_order = fx.make_layout(
            (group_width, tiles_n, tiles_m // group_width),
            (tiles_n, 1, group_width * tiles_n),
        )
        output_tile_offset = fx.crd2idx(flat_block_id, block_tile_order)
        output_tile_coords = fx.idx2crd(
            output_tile_offset, fx.make_layout((tiles_m, tiles_n), (tiles_n, 1))
        )
        block_row = fx.get_scalar(output_tile_coords[0])
        block_col = fx.get_scalar(output_tile_coords[1])
        left_tiled_view = fx.flat_divide(left_global_view, (BLOCK_M, BLOCK_K))
        right_tiled_view = fx.flat_divide(right_global_view, (BLOCK_K, BLOCK_N))
        out_tiled_view = fx.flat_divide(out_global_view, (BLOCK_M, BLOCK_N))
        out_block_view = fx.slice(out_tiled_view, (None, None, block_row, block_col))
        tiles_per_split = k // (BLOCK_K * SPLIT_K)
        initial_tile_k = split_id * tiles_per_split

        # 2. One shared ring and counters, reinitialized inside this GEMM kernel.
        lds = fx.SharedAllocator().allocate(SharedStorage).peek()
        sync_view = lds.sync.view(fx.make_layout(4 * STAGES, 1))
        sync_base = fx.get_iter(sync_view)
        spaces = ir.ArrayAttr.get([ir.Attribute.parse("#gpu.address_space<workgroup>")])
        lane = fx.thread_idx.x % 32

        def wave_barrier():
            fx.barrier(address_spaces=spaces, scope=gpu.BarrierScope.Subgroup)

        def wait_counter(ptr, target):
            # Local atomic acquire reads pair with ready/free release publications.
            wait = scf.WhileOp([], [])
            before = wait.before.blocks.append()
            after = wait.after.blocks.append()
            with ir.InsertionPoint(before):
                observed = fx.generic_load(
                    ptr, memory_order=fx.AtomicOrdering.Acquire, syncscope=LOCAL_SCOPE
                )
                scf.condition((observed < target).ir_value(), [])
            with ir.InsertionPoint(after):
                if POLL_SLEEP:
                    fx.rocdl.s_sleep(POLL_SLEEP)
                scf.yield_([])

        def signal_counter(ptr, target, participants):
            # The leader publishes reads/writes completed by every lane in its wave.
            wave_barrier()
            leader = scf.IfOp((lane == 0).ir_value(), [], has_else=False)
            with ir.InsertionPoint(leader.then_block):
                if participants == 1 and not ATOMIC_SIGNALS:
                    fx.generic_store(
                        ptr,
                        target,
                        memory_order=fx.AtomicOrdering.Release,
                        syncscope=LOCAL_SCOPE,
                    )
                else:
                    fx.atomic_add(
                        ptr, 1, ordering=fx.AtomicOrdering.AcqRel, syncscope=LOCAL_SCOPE
                    )
                scf.yield_([])

        if PROTOCOL == "semaphore" or DEBUG:
            initialize = scf.IfOp(
                (fx.thread_idx.x < STAGES).ir_value(), [], has_else=False
            )
            with ir.InsertionPoint(initialize.then_block):
                sync_view[fx.thread_idx.x * 4] = 0
                sync_view[fx.thread_idx.x * 4 + 1] = 0
                sync_view[fx.thread_idx.x * 4 + 2] = -17
                sync_view[fx.thread_idx.x * 4 + 3] = -23
                scf.yield_([])
            fx.barrier(address_spaces=spaces)

        # 3. Roles share metadata; only their branch issues global loads or WMMA.
        loader_thread_id = fx.thread_idx.x
        left_loader_lds_view = lds.left.view(
            fx.make_layout((BLOCK_M, BLOCK_K), (BLOCK_K + 8, 1))
        )
        right_loader_lds_view = lds.right.view(
            fx.make_layout((BLOCK_K, BLOCK_N), (BLOCK_N, 1))
        )
        left_lds_base = fx.get_iter(left_loader_lds_view)  # noqa: F841 -- used by TODO 2
        right_lds_base = fx.get_iter(right_loader_lds_view)
        left_copy_atom = fx.make_copy_atom(
            fx.UniversalCopy(16 * LEFT_VALUES), fx.BFloat16
        )
        right_copy_atom = fx.make_copy_atom(
            fx.UniversalCopy(16 * RIGHT_VALUES), fx.BFloat16
        )
        left_load_atom = fx.make_copy_atom(
            fx.rocdl.BufferCopy(16 * LEFT_VALUES), fx.BFloat16
        )
        right_load_atom = fx.make_copy_atom(
            fx.rocdl.BufferCopy(16 * RIGHT_VALUES, RIGHT_CACHE_MODIFIER),
            fx.BFloat16,
        )
        left_copy_threads = fx.make_ordered_layout(
            (LOADER_THREADS // (BLOCK_K // LEFT_VALUES), BLOCK_K // LEFT_VALUES),
            (1, 0),
        )
        right_copy_threads = fx.make_ordered_layout(
            (LOADER_THREADS // (BLOCK_N // RIGHT_VALUES), BLOCK_N // RIGHT_VALUES),
            (1, 0),
        )
        left_copy_values = fx.make_ordered_layout((1, LEFT_VALUES), (1, 0))
        right_copy_values = fx.make_ordered_layout((1, RIGHT_VALUES), (1, 0))
        left_copy_tile, left_copy_tv = fx.make_layout_tv(
            left_copy_threads, left_copy_values
        )
        right_copy_tile, right_copy_tv = fx.make_layout_tv(
            right_copy_threads, right_copy_values
        )
        left_thread_copy = fx.make_tiled_copy(
            left_copy_atom, left_copy_tv, left_copy_tile
        ).get_slice(loader_thread_id)
        right_thread_copy = fx.make_tiled_copy(
            right_copy_atom, right_copy_tv, right_copy_tile
        ).get_slice(loader_thread_id)
        left_fragment = fx.make_fragment_like(
            left_thread_copy.partition_D(left_loader_lds_view)
        )
        right_fragment = fx.make_fragment_like(
            right_thread_copy.partition_D(right_loader_lds_view)
        )

        def gmem2reg_load_tile(tile_k):
            left_block_view = fx.slice(left_tiled_view, (None, None, block_row, tile_k))
            right_block_view = fx.slice(
                right_tiled_view, (None, None, tile_k, block_col)
            )
            left_source = left_thread_copy.partition_S(left_block_view)
            right_source = right_thread_copy.partition_S(right_block_view)
            fx.copy(left_load_atom, left_source, left_fragment)
            fx.copy(right_load_atom, right_source, right_fragment)

        def reg2lds_copy_tile(stage):
            # TODO 2: Select the A region for this LDS ring slot.
            left_destination_ptr = None
            if left_destination_ptr is None:
                raise NotImplementedError("Fill in left_destination_ptr.")
            left_destination = fx.make_view(
                left_destination_ptr,
                left_loader_lds_view.layout,
            )
            right_destination = fx.make_view(
                right_lds_base + stage * RIGHT_STAGE_VALUES,
                right_loader_lds_view.layout,
            )
            fx.copy(
                left_copy_atom,
                left_fragment,
                left_thread_copy.partition_D(left_destination),
            )
            fx.copy(
                right_copy_atom,
                right_fragment,
                right_thread_copy.partition_D(right_destination),
            )

        def produce(stage, tile_k, generation):
            # Global reads may run while a consumer still reads the old LDS contents.
            gmem2reg_load_tile(initial_tile_k + tile_k)
            free_target = (generation - 1) * COMPUTE_WAVES
            wait_counter(sync_base + stage * 4 + 1, free_target)
            reg2lds_copy_tile(stage)
            signal_counter(
                sync_base + stage * 4, generation * LOADER_WAVES, LOADER_WAVES
            )

        # TODO 1: Map a physical compute thread to its compute-group thread ID.
        compute_thread_id = None
        if compute_thread_id is None:
            raise NotImplementedError("Fill in compute_thread_id.")
        # Distinct view objects keep producer loop-carried values out of this branch.
        left_lds_view = lds.left.view(
            fx.make_layout((BLOCK_M, BLOCK_K), (BLOCK_K + 8, 1))
        )
        right_lds_view = lds.right.view(
            fx.make_layout((BLOCK_K, BLOCK_N), (BLOCK_N, 1))
        )
        left_compute_base = fx.get_iter(left_lds_view)
        right_compute_base = fx.get_iter(right_lds_view)
        left_lds_initial_view = fx.make_view(
            left_compute_base, fx.make_layout((BLOCK_M, MMA_K), (BLOCK_K + 8, 1))
        )
        right_lds_transposed_initial_view = fx.make_view(
            right_compute_base, fx.make_layout((BLOCK_N, MMA_K), (1, BLOCK_N))
        )
        mma_atom = fx.make_mma_atom(
            fx.rocdl.WMMA(MMA_M, MMA_N, MMA_K, fx.BFloat16, fx.Float32)
        )
        mma = fx.make_tiled_mma(
            mma_atom, fx.make_layout((WAVES_M, WAVES_N, 1), (1, WAVES_M, 0))
        )
        thread_mma = mma.thr_slice(compute_thread_id)
        accumulator = thread_mma.make_fragment_C(out_block_view)
        accumulator.fill(0)
        copy_16b = fx.make_copy_atom(fx.UniversalCopy16b(), fx.BFloat16)
        lds2reg_left_thread_copy = fx.make_tiled_copy_A(copy_16b, mma).get_slice(
            compute_thread_id
        )
        lds2reg_right_thread_copy = fx.make_tiled_copy_B(copy_16b, mma).get_slice(
            compute_thread_id
        )
        left_r_tile = thread_mma.make_fragment_A(left_lds_initial_view)
        right_r_tile = thread_mma.make_fragment_B(right_lds_transposed_initial_view)
        left_r_destination = lds2reg_left_thread_copy.retile(left_r_tile)
        right_r_destination = lds2reg_right_thread_copy.retile(right_r_tile)

        def compute_lds(stage):
            for inner_k in fx.range_constexpr(BLOCK_K // MMA_K):
                left_mma_view = fx.make_view(
                    left_compute_base + stage * LEFT_STAGE_VALUES + inner_k * MMA_K,
                    fx.make_layout((BLOCK_M, MMA_K), (BLOCK_K + 8, 1)),
                )
                right_mma_view = fx.make_view(
                    right_compute_base
                    + stage * RIGHT_STAGE_VALUES
                    + inner_k * MMA_K * BLOCK_N,
                    fx.make_layout((BLOCK_N, MMA_K), (1, BLOCK_N)),
                )
                left_r_source = lds2reg_left_thread_copy.partition_S(left_mma_view)
                right_r_source = lds2reg_right_thread_copy.partition_S(right_mma_view)
                fx.copy(copy_16b, left_r_source, left_r_destination)
                fx.copy(copy_16b, right_r_source, right_r_destination)
                fx.gemm(mma_atom, accumulator, left_r_tile, right_r_tile, accumulator)

        def consume(stage, generation):
            ready_target = generation * LOADER_WAVES
            wait_counter(sync_base + stage * 4, ready_target)
            compute_lds(stage)
            signal_counter(
                sync_base + stage * 4 + 1, generation * COMPUTE_WAVES, COMPUTE_WAVES
            )

        def finish_output(accumulator):
            def store_output():
                out_registers = fx.make_rmem_tensor(accumulator.layout, fx.BFloat16)
                for slot in fx.range_constexpr(ACCUMULATOR_VALUES):
                    out_registers[slot] = accumulator[slot].to(fx.BFloat16)
                # Replace stage 04's one-thread output plan with the collective C plan.
                gmem_store_16b = fx.make_copy_atom(
                    fx.rocdl.BufferCopy16b(), fx.BFloat16
                )
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
                    + flat_block_id * COMPUTE_THREADS
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
                            accumulator[slot] = (
                                accumulator[slot] + partial_registers[slot]
                            )
                    store_output()
                    # Same-stream launches can reuse the workspace without a clear kernel.
                    fx.generic_store(
                        counter_ptr,
                        fx.Int32(0),
                        memory_order=fx.AtomicOrdering.Release,
                        syncscope=fx.rocdl.SyncScope.Agent,
                    )
                    scf.yield_([])

        if PROTOCOL == "semaphore":
            role = scf.IfOp(
                (fx.thread_idx.x < LOADER_THREADS).ir_value(), [], has_else=True
            )
            with ir.InsertionPoint(role.then_block):
                for loader_cycle in range(tiles_per_split // STAGES):
                    for stage in fx.range_constexpr(STAGES):
                        produce(stage, loader_cycle * STAGES + stage, loader_cycle + 1)
                for stage in fx.range_constexpr(tiles_per_split % STAGES):
                    produce(
                        stage,
                        (tiles_per_split // STAGES) * STAGES + stage,
                        tiles_per_split // STAGES + 1,
                    )
                scf.yield_([])
            with ir.InsertionPoint(role.else_block):
                for compute_cycle in range(tiles_per_split // STAGES):
                    for stage in fx.range_constexpr(STAGES):
                        consume(stage, compute_cycle + 1)
                for stage in fx.range_constexpr(tiles_per_split % STAGES):
                    consume(stage, tiles_per_split // STAGES + 1)
                finish_output(accumulator)
                scf.yield_([])
        else:

            def debug_ready(stage, tile_k):
                if DEBUG:
                    signal_counter(
                        sync_base + stage * 4,
                        (tile_k // STAGES + 1) * LOADER_WAVES,
                        LOADER_WAVES,
                    )

            def debug_free(stage, tile_k):
                if DEBUG:
                    signal_counter(
                        sync_base + stage * 4 + 1,
                        (tile_k // STAGES + 1) * COMPUTE_WAVES,
                        COMPUTE_WAVES,
                    )

            # Prologue: all threads meet at the same ready barrier outside the role branch.
            initial = scf.IfOp(
                (fx.thread_idx.x < LOADER_THREADS).ir_value(), [], has_else=False
            )
            with ir.InsertionPoint(initial.then_block):
                gmem2reg_load_tile(initial_tile_k)
                reg2lds_copy_tile(0)
                debug_ready(0, 0)
                scf.yield_([])
            fx.barrier(address_spaces=spaces)

            def step(current_stage, next_stage, tile_k):
                # Loader VMEM (and, with >1 slot, LDS stores) overlaps current WMMA.
                work = scf.IfOp(
                    (fx.thread_idx.x < LOADER_THREADS).ir_value(), [], has_else=True
                )
                with ir.InsertionPoint(work.then_block):
                    gmem2reg_load_tile(initial_tile_k + tile_k + 1)
                    if STAGES > 1:
                        reg2lds_copy_tile(next_stage)
                        debug_ready(next_stage, tile_k + 1)
                    scf.yield_([])
                with ir.InsertionPoint(work.else_block):
                    compute_lds(current_stage)
                    debug_free(current_stage, tile_k)
                    scf.yield_([])
                fx.barrier(address_spaces=spaces)
                if STAGES == 1:
                    publish = scf.IfOp(
                        (fx.thread_idx.x < LOADER_THREADS).ir_value(),
                        [],
                        has_else=False,
                    )
                    with ir.InsertionPoint(publish.then_block):
                        reg2lds_copy_tile(0)
                        debug_ready(0, tile_k + 1)
                        scf.yield_([])
                    fx.barrier(address_spaces=spaces)

            for tile_group in range((tiles_per_split - 1) // STAGES):
                for stage in fx.range_constexpr(STAGES):
                    step(stage, (stage + 1) % STAGES, tile_group * STAGES + stage)
            for stage in fx.range_constexpr((tiles_per_split - 1) % STAGES):
                step(
                    stage,
                    (stage + 1) % STAGES,
                    ((tiles_per_split - 1) // STAGES) * STAGES + stage,
                )
            drain = scf.IfOp(
                (fx.thread_idx.x >= LOADER_THREADS).ir_value(), [], has_else=False
            )
            with ir.InsertionPoint(drain.then_block):
                compute_lds((tiles_per_split - 1) % STAGES)
                debug_free((tiles_per_split - 1) % STAGES, tiles_per_split - 1)
                finish_output(accumulator)
                scf.yield_([])

        if DEBUG:
            # Only diagnostic specializations rendezvous at the end and record all slots.
            fx.barrier(address_spaces=spaces)
            record = scf.IfOp((fx.thread_idx.x < STAGES).ir_value(), [], has_else=False)
            with ir.InsertionPoint(record.then_block):
                for field in fx.range_constexpr(4):
                    sync_trace[
                        fx.block_idx.x * (4 * STAGES) + fx.thread_idx.x * 4 + field
                    ] = fx.generic_load(sync_base + fx.thread_idx.x * 4 + field)
                scf.yield_([])

    @flyc.jit
    def run(
        left: fx.Tensor,
        right: fx.Tensor,
        out: fx.Tensor,
        partials: fx.Tensor,
        counters: fx.Tensor,
        sync_trace: fx.Tensor,
        m: fx.Constexpr,
        n: fx.Constexpr,
        k: fx.Constexpr,
        stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
    ):
        exercise_kernel(
            left, right, out, partials, counters, sync_trace, m, n, k
        ).launch(
            grid=((m // BLOCK_M) * (n // BLOCK_N) * SPLIT_K, 1, 1),
            block=(THREADS_PER_BLOCK, 1, 1),
            stream=stream,
        )

    return run


SHAPES = ((16, 1024, 8192), (32, 1024, 8192), (16, 4096, 8192))
CONFIGS_BY_SHAPE = {
    (16, 1024, 8192): Config(
        block_m=16,
        block_n=64,
        block_k=64,
        waves_m=1,
        waves_n=2,
        group_m=1,
        split_k=4,
        loader_waves=1,
        lds_stages=2,
        right_cache_modifier=2,
        poll_sleep=0,
        signal_mode="auto",
        protocol="barrier",
    ),
    (32, 1024, 8192): Config(
        block_m=32,
        block_n=64,
        block_k=64,
        waves_m=1,
        waves_n=2,
        group_m=1,
        split_k=4,
        loader_waves=1,
        lds_stages=2,
        right_cache_modifier=2,
        poll_sleep=0,
        signal_mode="auto",
        protocol="barrier",
    ),
    (16, 4096, 8192): Config(
        block_m=16,
        block_n=128,
        block_k=16,
        waves_m=1,
        waves_n=4,
        group_m=1,
        split_k=1,
        loader_waves=2,
        lds_stages=1,
        right_cache_modifier=2,
        poll_sleep=0,
        signal_mode="auto",
        protocol="semaphore",
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


def launch_for(config, shape, debug=False):
    run = build(config, debug)
    partial_storage, counter_storage = make_workspace(config, shape)
    blocks = (
        (shape[0] // config.block_m) * (shape[1] // config.block_n) * config.split_k
    )
    trace_count = blocks * config.lds_stages * 4 if debug else 1
    sync_storage = torch.full(
        (trace_count + 16,), -345, dtype=torch.int32, device="cuda"
    )

    def launch(left, right, out, stream=None):
        stream_arg = fx.Stream(None) if stream is None else fx.Stream(stream)
        run(
            left,
            right,
            out,
            partial_storage[:-16],
            counter_storage[:-16],
            sync_storage[:-16],
            *shape,
            stream_arg,
        )

    launch.workspace = (partial_storage, counter_storage)
    launch.sync_trace = sync_storage
    launch.debug = debug
    return launch


def check_workspace(launch):
    partial_storage, counter_storage = launch.workspace
    assert torch.all(launch.sync_trace[-16:] == -345).item(), (
        "Sync trace sentinel changed"
    )
    if not launch.debug:
        assert torch.all(launch.sync_trace == -345).item(), (
            "Production kernel wrote diagnostics"
        )
    assert torch.all(partial_storage[-16:] == -777).item(), "Partial sentinel changed"
    assert torch.all(counter_storage[:-16] == 0).item(), "Arrival counters not reset"
    assert torch.all(counter_storage[-16:] == -123).item(), "Counter sentinel changed"


def check_boundaries(config):
    """Trace every split's partials through one, two, and three local K tiles."""
    checked = []
    for tiles_per_split in sorted(
        {
            1,
            2,
            3,
            max(1, config.lds_stages - 1),
            config.lds_stages,
            config.lds_stages + 1,
            2 * config.lds_stages + 1,
        }
    ):
        m, n = config.block_m, config.block_n
        k = config.block_k * config.split_k * tiles_per_split
        tile_ids = torch.arange(k) // config.block_k
        split_ids = tile_ids // tiles_per_split
        tags = (split_ids + 1) * 2 ** (tile_ids % tiles_per_split)
        a = tags.to(torch.bfloat16).expand(m, k).contiguous().cuda()
        b = torch.ones((k, n), dtype=torch.bfloat16, device="cuda")
        storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
        out = storage[:-16].view(m, n)
        out.fill_(float("nan"))
        launch = launch_for(config, (m, n, k), debug=True)
        launch(a, b, out)
        torch.cuda.synchronize()
        partials = [
            config.block_k * (part + 1) * (2**tiles_per_split - 1)
            for part in range(config.split_k)
        ]
        expected = torch.full((m, n), sum(partials), dtype=torch.bfloat16)
        torch.testing.assert_close(out.cpu(), expected, rtol=0, atol=0)
        if config.split_k > 1:
            actual_partials = launch.workspace[0][:-16].view(config.split_k, -1).cpu()
            for part, expected_partial in enumerate(partials):
                torch.testing.assert_close(
                    actual_partials[part],
                    torch.full_like(actual_partials[part], expected_partial),
                    rtol=0,
                    atol=0,
                )
        check_workspace(launch)
        flags = launch.sync_trace[:-16].view(-1, config.lds_stages, 4).cpu()
        for stage in range(config.lds_stages):
            visits = max(0, (tiles_per_split - 1 - stage) // config.lds_stages + 1)
            expected_flags = torch.tensor(
                [visits * config.loader_waves, visits * config.compute_waves, -17, -23],
                dtype=torch.int32,
            )
            torch.testing.assert_close(
                flags[:, stage],
                expected_flags.expand_as(flags[:, stage]),
                rtol=0,
                atol=0,
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
            for name, key in (
                (config.name, "specialized"),
                ("stage-10 prefetch", "prefetch"),
                ("retuned prefetch", "tuned_prefetch"),
                ("torch.matmul", "torch"),
            ):
                if key not in report["median_ms"]:
                    continue
                elapsed = report["median_ms"][key]
                print(
                    json.dumps(
                        {
                            "name": name,
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
                        "paired_specialized_prefetch_ratio": report[
                            "ratio_to_prefetch"
                        ],
                        "paired_specialized_torch_ratio": report["ratio_to_torch"],
                        **(
                            {
                                "paired_specialized_tuned_prefetch_ratio": report[
                                    "ratio_to_tuned_prefetch"
                                ]
                            }
                            if "ratio_to_tuned_prefetch" in report
                            else {}
                        ),
                    }
                )
            )
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None


if __name__ == "__main__":
    main()
