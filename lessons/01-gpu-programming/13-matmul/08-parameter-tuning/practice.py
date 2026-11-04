"""Tune native BF16 WMMA block tiles without changing global input layouts."""

import runpy
from dataclasses import dataclass
from functools import lru_cache
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@dataclass(frozen=True)
class Config:
    block_m: int = 64
    block_n: int = 64
    block_k: int = 32
    waves_m: int = 2
    waves_n: int = 2
    schedule: str = "prefetch"
    buffers: int = 1

    @property
    def name(self):
        return f"m{self.block_m}n{self.block_n}k{self.block_k}_w{self.waves_m}x{self.waves_n}_{self.schedule}_lds{self.buffers}"

    @property
    def threads(self):
        return 32 * self.waves_m * self.waves_n

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
            self.buffers
            * 2
            * (self.block_m * (self.block_k + 8) + self.block_k * self.block_n)
        )


def validate_config(config):
    bm, bn, bk = config.block_m, config.block_n, config.block_k
    if any(value <= 0 or 1024 % value for value in (bm, bn, bk)):
        raise ValueError("Block dimensions must be positive divisors of 1024")
    if config.waves_m < 1 or config.waves_n < 1 or config.threads not in (64, 128, 256):
        raise ValueError("Use two, four, or eight wave32 groups")
    if bm % (16 * config.waves_m) or bn % (16 * config.waves_n) or bk % 16:
        raise ValueError("Block tile must contain whole WMMA groups and K fragments")
    for rows, columns in ((bm, bk), (bk, bn)):
        chunks = columns // 8
        if columns % 8 or chunks > config.threads or config.threads % chunks:
            raise ValueError("Copy geometry must distribute aligned eight-BF16 chunks")
        if rows % (config.threads // chunks):
            raise ValueError(
                "Every cooperative staging thread must own complete chunks"
            )
    if config.buffers not in (1, 2):
        raise ValueError("Use one or two LDS buffers")
    if config.lds_bytes > 65536:
        raise ValueError("LDS allocation exceeds this lesson's 64 KiB limit")
    if config.schedule not in ("serial", "prefetch"):
        raise ValueError("Unknown schedule")
    return config


@lru_cache(None)
def build(config):
    """Create one native specialization; compilation is lazy on its first launch."""
    validate_config(config)
    BLOCK_M, BLOCK_N, BLOCK_K = config.block_m, config.block_n, config.block_k
    WAVES_M, WAVES_N = config.waves_m, config.waves_n
    THREADS_PER_BLOCK = 32 * WAVES_M * WAVES_N
    schedule = config.schedule
    LDS_STAGES = config.buffers

    @fx.struct
    class SharedStorage:
        # Retain stage 06's measured padded A layout and packed B layout.
        left: fx.Array[fx.BFloat16, LDS_STAGES * BLOCK_M * (BLOCK_K + 8), 16]
        right: fx.Array[fx.BFloat16, LDS_STAGES * BLOCK_K * BLOCK_N, 16]

    @flyc.kernel
    def exercise_kernel(
        left: fx.Tensor,
        right: fx.Tensor,
        out: fx.Tensor,
        m: fx.Constexpr,
        n: fx.Constexpr,
        k: fx.Constexpr,
    ):
        # 1. Describe the global row-major matrices, as in stage 04.
        left_global_view = fx.make_view(
            fx.get_iter(fx.rocdl.make_buffer_tensor(left)),
            fx.make_layout((m, k), (k, 1)),
        )
        right_global_view = fx.make_view(
            fx.get_iter(fx.rocdl.make_buffer_tensor(right)),
            fx.make_layout((k, n), (n, 1)),
        )
        out_global_view = fx.make_view(
            fx.get_iter(fx.rocdl.make_buffer_tensor(out)),
            fx.make_layout((m, n), (n, 1)),
        )
        pid = fx.block_idx.x + fx.block_idx.y * (n // BLOCK_N)
        group_width = min(8, m // BLOCK_M)
        block_row = (
            pid // (group_width * (n // BLOCK_N))
        ) * group_width + pid % group_width
        block_col = (pid % (group_width * (n // BLOCK_N))) // group_width

        # 2. Group neighboring blocks along M to share B tiles in cache.
        left_tiled_view = fx.flat_divide(left_global_view, (BLOCK_M, BLOCK_K))
        right_tiled_view = fx.flat_divide(right_global_view, (BLOCK_K, BLOCK_N))
        out_tiled_view = fx.flat_divide(out_global_view, (BLOCK_M, BLOCK_N))
        out_block_view = fx.slice(out_tiled_view, (None, None, block_row, block_col))

        # 3. Scale padded storage with the tile and optional ping-pong stage count.
        lds = fx.SharedAllocator().allocate(SharedStorage).peek()
        left_lds_buffers = lds.left.view(
            fx.make_layout(
                (BLOCK_M, BLOCK_K, LDS_STAGES),
                (BLOCK_K + 8, 1, BLOCK_M * (BLOCK_K + 8)),
            )
        )
        right_lds_buffers = lds.right.view(
            fx.make_layout(
                (BLOCK_K, BLOCK_N, LDS_STAGES), (BLOCK_N, 1, BLOCK_K * BLOCK_N)
            )
        )
        left_lds_view = fx.slice(left_lds_buffers, (None, None, 0))
        right_lds_view = fx.slice(right_lds_buffers, (None, None, 0))

        # 4. Keep stage 04's generic staging plan; adapt ownership to 128 threads.
        copy_128b = fx.make_copy_atom(fx.UniversalCopy128b(), fx.BFloat16)
        left_copy_threads = fx.make_ordered_layout(
            (THREADS_PER_BLOCK // (BLOCK_K // 8), BLOCK_K // 8), (1, 0)
        )
        # TODO 1: Derive B's staging thread layout for eight-BF16 chunks.
        right_copy_threads = None
        if right_copy_threads is None:
            raise NotImplementedError("Fill in right_copy_threads.")
        copy_values = fx.make_ordered_layout((1, 8), (1, 0))
        left_copy_tile, left_copy_tv = fx.make_layout_tv(left_copy_threads, copy_values)
        right_copy_tile, right_copy_tv = fx.make_layout_tv(
            right_copy_threads, copy_values
        )
        left_copy_plan = fx.make_tiled_copy(copy_128b, left_copy_tv, left_copy_tile)
        right_copy_plan = fx.make_tiled_copy(copy_128b, right_copy_tv, right_copy_tile)
        left_thread_copy = left_copy_plan.get_slice(fx.thread_idx.x)
        right_thread_copy = right_copy_plan.get_slice(fx.thread_idx.x)
        left_lds_destination = left_thread_copy.partition_D(left_lds_view)
        right_lds_destination = right_thread_copy.partition_D(right_lds_view)
        left_fragment = fx.make_fragment_like(left_lds_destination)
        right_fragment = fx.make_fragment_like(right_lds_destination)

        # 5. Keep only one 16-wide K fragment live for each WMMA step.
        left_mma_view = fx.slice(
            fx.flat_divide(left_lds_view, (BLOCK_M, 16)), (None, None, 0, 0)
        )
        right_mma_view = fx.make_view(
            fx.get_iter(right_lds_view),
            fx.make_layout((BLOCK_N, 16), (1, BLOCK_N)),
        )  # (N,K), over the existing row-major B storage; no data transpose.
        atom = fx.make_mma_atom(fx.rocdl.WMMA(16, 16, 16, fx.BFloat16, fx.Float32))
        mma = fx.make_tiled_mma(
            atom, fx.make_layout((WAVES_M, WAVES_N, 1), (1, WAVES_M, 0))
        )
        thread_mma = mma.thr_slice(fx.thread_idx.x)
        accumulator = thread_mma.make_fragment_C(out_block_view)
        accumulator.fill(0)

        # Replace manual operand thread/value layouts with instruction-derived plans.
        copy_16b = fx.make_copy_atom(fx.UniversalCopy16b(), fx.BFloat16)
        lds2reg_left_copy_plan = fx.make_tiled_copy_A(copy_16b, mma)
        lds2reg_right_copy_plan = fx.make_tiled_copy_B(copy_16b, mma)
        # Full block thread IDs select both wave group and lane ownership.
        lds2reg_left_thread_copy = lds2reg_left_copy_plan.get_slice(fx.thread_idx.x)
        lds2reg_right_thread_copy = lds2reg_right_copy_plan.get_slice(fx.thread_idx.x)
        # MMA defines the fragment layout. Retile provides a copy-compatible alias.
        left_r_tile = thread_mma.make_fragment_A(left_mma_view)
        right_r_tile = thread_mma.make_fragment_B(right_mma_view)
        left_r_destination = lds2reg_left_thread_copy.retile(left_r_tile)
        right_r_destination = lds2reg_right_thread_copy.retile(right_r_tile)

        # Tracing-time helper keeps the copy wrapper outside runtime loop state.
        def create_gmem2lds_sources(left_block_view, right_block_view):
            return (
                left_thread_copy.partition_S(left_block_view),
                right_thread_copy.partition_S(right_block_view),
            )

        # Tracing helpers emit ordinary copies and WMMA; they launch no extra kernels.
        def load_global_tile(tile_k):
            left_block_view = fx.slice(left_tiled_view, (None, None, block_row, tile_k))
            right_block_view = fx.slice(
                right_tiled_view, (None, None, tile_k, block_col)
            )
            left_lds_source, right_lds_source = create_gmem2lds_sources(
                left_block_view, right_block_view
            )
            fx.copy(
                fx.make_copy_atom(fx.rocdl.BufferCopy128b(), fx.BFloat16),
                left_lds_source,
                left_fragment,
            )
            fx.copy(
                fx.make_copy_atom(fx.rocdl.BufferCopy128b(), fx.BFloat16),
                right_lds_source,
                right_fragment,
            )

        def publish_lds_tile(buffer_index):
            left_view = fx.slice(left_lds_buffers, (None, None, buffer_index))
            right_view = fx.slice(right_lds_buffers, (None, None, buffer_index))
            left_destination = left_thread_copy.partition_D(left_view)
            right_destination = right_thread_copy.partition_D(right_view)
            fx.copy(copy_128b, left_fragment, left_destination)
            fx.copy(copy_128b, right_fragment, right_destination)
            fx.barrier()

        def compute_lds_tile(buffer_index):
            left_view = fx.slice(left_lds_buffers, (None, None, buffer_index))
            right_view = fx.slice(right_lds_buffers, (None, None, buffer_index))
            right_operand = fx.make_view(
                fx.get_iter(right_view),
                fx.make_layout((BLOCK_N, BLOCK_K), (1, BLOCK_N)),
            )
            for rk in fx.range_constexpr(BLOCK_K // 16):
                left_subview = fx.slice(
                    fx.flat_divide(left_view, (BLOCK_M, 16)), (None, None, 0, rk)
                )
                right_subview = fx.slice(
                    fx.flat_divide(right_operand, (BLOCK_N, 16)), (None, None, 0, rk)
                )
                left_source = lds2reg_left_thread_copy.partition_S(left_subview)
                right_source = lds2reg_right_thread_copy.partition_S(right_subview)
                fx.copy(copy_16b, left_source, left_r_destination)
                fx.copy(copy_16b, right_source, right_r_destination)
                fx.gemm(atom, accumulator, left_r_tile, right_r_tile, accumulator)

        # 6. Compare the same padded kernel with two compile-time schedules.
        if schedule == "serial":
            for tile_k in range(k // BLOCK_K):
                load_global_tile(tile_k)
                publish_lds_tile(tile_k % LDS_STAGES)
                compute_lds_tile(tile_k % LDS_STAGES)
                fx.barrier()
        else:
            # Prologue: make tile 0 visible in LDS before any consumer reads it.
            initial_tile_k = 0
            load_global_tile(initial_tile_k)
            publish_lds_tile(0)
            # Steady state: prefetch next globals into private registers, consume LDS,
            # then publish the next tile. A single buffer needs a reader barrier;
            # ping-pong writes a different buffer and uses the prior ready barrier.
            for tile_k in range(k // BLOCK_K - 1):
                next_tile_k = tile_k + 1
                load_global_tile(next_tile_k)
                compute_lds_tile(tile_k % LDS_STAGES)
                if LDS_STAGES == 1:
                    fx.barrier()
                publish_lds_tile(next_tile_k % LDS_STAGES)
            # Drain: the final tile is already in LDS; do not read a nonexistent next tile.
            compute_lds_tile((k // BLOCK_K - 1) % LDS_STAGES)
            fx.barrier()

        # 7. Convert to BF16, then store through the instruction's C ownership.
        out_registers = fx.make_rmem_tensor(accumulator.layout, fx.BFloat16)
        # TODO 2: Include every repeated M/N accumulator tile in conversion.
        converted_slots = None
        if converted_slots is None:
            raise NotImplementedError("Fill in converted_slots.")
        for slot in fx.range_constexpr(converted_slots):
            out_registers[slot] = accumulator[slot].to(fx.BFloat16)
        # Replace stage 04's one-thread output plan with the collective C plan.
        copy_out = fx.make_copy_atom(fx.rocdl.BufferCopy16b(), fx.BFloat16)
        reg2gmem_copy_plan = fx.make_tiled_copy_C(copy_out, mma)
        reg2gmem_thread_copy = reg2gmem_copy_plan.get_slice(fx.thread_idx.x)
        reg2gmem_source = reg2gmem_thread_copy.retile(out_registers)
        reg2gmem_dest = reg2gmem_thread_copy.partition_D(out_block_view)
        fx.copy(copy_out, reg2gmem_source, reg2gmem_dest)

    @flyc.jit
    def run(
        left: fx.Tensor,
        right: fx.Tensor,
        out: fx.Tensor,
        m: fx.Constexpr,
        n: fx.Constexpr,
        k: fx.Constexpr,
        stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
    ):
        exercise_kernel(left, right, out, m, n, k).launch(
            grid=(n // BLOCK_N, m // BLOCK_M, 1),
            block=(THREADS_PER_BLOCK, 1, 1),
            stream=stream,
        )

    return run


SELECTED_CONFIG = Config(128, 128, 32, 1, 4, "prefetch")
run = build(SELECTED_CONFIG)


def check_boundaries(config):
    launch = build(config)
    checked = []
    for tiles in (1, 2, 3):
        m, n, k = config.block_m, config.block_n, config.block_k * tiles
        tags = (2 ** (torch.arange(k, dtype=torch.int32) // config.block_k)).to(
            torch.bfloat16
        )
        left = tags.expand(m, k).contiguous().cuda()
        right = torch.ones((k, n), dtype=torch.bfloat16, device="cuda")
        storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
        out = storage[: m * n].view(m, n)
        out.fill_(float("nan"))
        launch(left, right, out, m, n, k)
        torch.cuda.synchronize()
        expected = config.block_k * (2**tiles - 1)
        torch.testing.assert_close(
            out.cpu(),
            torch.full((m, n), expected, dtype=torch.bfloat16),
            rtol=0,
            atol=0,
        )
        assert torch.all(storage[m * n :] == -99).item(), "Boundary sentinel changed"
        checked.append({"K_tiles": tiles, "expected": expected})
    return checked


def solve(config=SELECTED_CONFIG):
    architecture = torch.cuda.get_device_properties(0).gcnArchName.split(":")[0]
    if architecture not in ("gfx1151", "gfx1152"):
        raise RuntimeError(
            f"This lesson supports gfx1151/gfx1152; detected {architecture}"
        )
    launch = build(config)
    boundaries = check_boundaries(config)
    generator = torch.Generator().manual_seed(13)
    checkpoint = None
    m = n = k = 1024
    for pattern in ("trace", "random"):
        if pattern == "trace":
            a_cpu = ((torch.arange(m * k).reshape(m, k) % 5) - 2).to(torch.bfloat16)
            b_cpu = ((torch.arange(k * n).reshape(k, n) % 7) - 3).to(torch.bfloat16)
        else:
            a_cpu = torch.randn(m, k, generator=generator).to(torch.bfloat16)
            b_cpu = torch.randn(k, n, generator=generator).to(torch.bfloat16)
        left, right = a_cpu.cuda(), b_cpu.cuda()
        storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
        out = storage[: m * n].view(m, n)
        out.fill_(float("nan"))
        launch(left, right, out, m, n, k)
        torch.cuda.synchronize()
        expected = (a_cpu.float() @ b_cpu.float()).to(torch.bfloat16)
        torch.testing.assert_close(
            out.cpu(),
            expected,
            rtol=0 if pattern == "trace" else 0.016,
            atol=0.001 if pattern == "trace" else 0.03125,
        )
        assert torch.all(storage[m * n :] == -99).item(), "Output sentinel changed"
        if pattern == "trace":
            checkpoint = out[0, :4].cpu().tolist()
    return {
        "shapes_MNK": [(1024, 1024, 1024)],
        "patterns": 2,
        "first_four": checkpoint,
        "config": config.name,
        "accumulator_values": config.accumulator_values,
        "lds_bytes": config.lds_bytes,
        "pipeline_boundaries": boundaries,
    }


if __name__ == "__main__":
    benchmark = runpy.run_path(
        str(Path(__file__).resolve().parents[4] / "examples/matmul_benchmark.py")
    )
    benchmark["lesson_main"](
        run,
        solve,
        Path(__file__).parent.name,
        check_only=globals().get("_COURSE_CHECK_ONLY", False),
    )
