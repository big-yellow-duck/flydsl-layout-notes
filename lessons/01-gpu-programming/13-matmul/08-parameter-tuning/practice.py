"""Tune native BF16 WMMA block tiles without changing global input layouts."""

import argparse
import json
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
    group_m: int = 8

    @property
    def name(self):
        return f"m{self.block_m}n{self.block_n}k{self.block_k}_w{self.waves_m}x{self.waves_n}_prefetch_lds1_gm{self.group_m}"

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
        return 2 * (self.block_m * (self.block_k + 8) + self.block_k * self.block_n)


def validate_config(config, shape=(1024, 1024, 1024)):
    bm, bn, bk = config.block_m, config.block_n, config.block_k
    if any(value <= 0 for value in (bm, bn, bk)):
        raise ValueError("Block dimensions must be positive")
    if len(shape) != 3 or any(value <= 0 for value in shape):
        raise ValueError("Shape must contain positive M,N,K")
    if any(size % tile for size, tile in zip(shape, (bm, bn, bk), strict=True)):
        raise ValueError("Shape must contain complete block tiles")
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
    validate_config(config, (config.block_m, config.block_n, config.block_k))
    BLOCK_M, BLOCK_N, BLOCK_K = config.block_m, config.block_n, config.block_k
    MMA_M, MMA_N, MMA_K = 16, 16, 16
    WAVES_M, WAVES_N = config.waves_m, config.waves_n
    THREADS_PER_BLOCK = 32 * WAVES_M * WAVES_N
    # TODO 1: Derive the accumulator values from the M/N repetitions.
    ACCUMULATOR_VALUES = None
    GROUP_M = config.group_m

    @fx.struct
    class SharedStorage:
        # Retain stage 06's measured padded A layout and packed B layout.
        left: fx.Array[fx.BFloat16, BLOCK_M * (BLOCK_K + 8), 16]
        right: fx.Array[fx.BFloat16, BLOCK_K * BLOCK_N, 16]

    @flyc.kernel
    def exercise_kernel(
        left: fx.Tensor,
        right: fx.Tensor,
        out: fx.Tensor,
        m: fx.Constexpr,
        n: fx.Constexpr,
        k: fx.Constexpr,
    ):
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
        flat_block_id = fx.block_idx.x
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

        # 4. Derive each operand's staging geometry from its contiguous extent.
        copy_128b = fx.make_copy_atom(fx.UniversalCopy128b(), fx.BFloat16)
        gmem_load_128b = fx.make_copy_atom(fx.rocdl.BufferCopy128b(), fx.BFloat16)
        left_copy_threads = fx.make_ordered_layout(
            (THREADS_PER_BLOCK // (BLOCK_K // 8), BLOCK_K // 8), (1, 0)
        )
        # TODO 2: Derive B's staging thread layout for eight-BF16 chunks.
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

        thread_mma = mma.thr_slice(fx.thread_idx.x)
        accumulator = thread_mma.make_fragment_C(out_block_view)
        accumulator.fill(0)

        # lds to register copies using mma compatible plans
        copy_16b = fx.make_copy_atom(fx.UniversalCopy16b(), fx.BFloat16)
        lds2reg_left_copy_plan = fx.make_tiled_copy_A(copy_16b, mma)
        lds2reg_right_copy_plan = fx.make_tiled_copy_B(copy_16b, mma)

        lds2reg_left_thread_copy = lds2reg_left_copy_plan.get_slice(fx.thread_idx.x)
        lds2reg_right_thread_copy = lds2reg_right_copy_plan.get_slice(fx.thread_idx.x)

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
            fx.copy(gmem_load_128b, left_lds_source, left_fragment)
            fx.copy(gmem_load_128b, right_lds_source, right_fragment)

        def reg2lds_copy_tile():
            fx.copy(copy_128b, left_fragment, gmem2lds_left_destination)
            fx.copy(copy_128b, right_fragment, gmem2lds_right_destination)
            fx.barrier()

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
        initial_tile_k = 0
        gmem2reg_load_tile(initial_tile_k)
        reg2lds_copy_tile()
        # Steady state: prefetch next globals into private registers, consume LDS,
        # protect current readers, then publish the next tile into the same LDS.
        for tile_k in range(k // BLOCK_K - 1):
            next_tile_k = tile_k + 1
            gmem2reg_load_tile(next_tile_k)
            compute_lds()
            fx.barrier()
            reg2lds_copy_tile()
        # Drain: the final tile is already in LDS; do not read a nonexistent next tile.
        compute_lds()
        fx.barrier()

        # 7. Convert to BF16, then store through the instruction's C ownership.
        out_registers = fx.make_rmem_tensor(accumulator.layout, fx.BFloat16)
        if ACCUMULATOR_VALUES is None:
            raise NotImplementedError("Fill in ACCUMULATOR_VALUES.")
        for slot in fx.range_constexpr(ACCUMULATOR_VALUES):
            out_registers[slot] = accumulator[slot].to(fx.BFloat16)
        # Replace stage 04's one-thread output plan with the collective C plan.
        gmem_store_16b = fx.make_copy_atom(fx.rocdl.BufferCopy16b(), fx.BFloat16)
        reg2gmem_copy_plan = fx.make_tiled_copy_C(gmem_store_16b, mma)
        reg2gmem_thread_copy = reg2gmem_copy_plan.get_slice(fx.thread_idx.x)
        reg2gmem_source = reg2gmem_thread_copy.retile(out_registers)
        reg2gmem_dest = reg2gmem_thread_copy.partition_D(out_block_view)
        fx.copy(gmem_store_16b, reg2gmem_source, reg2gmem_dest)

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
            grid=((m // BLOCK_M) * (n // BLOCK_N), 1, 1),
            block=(THREADS_PER_BLOCK, 1, 1),
            stream=stream,
        )

    return run


SELECTED_CONFIG = Config(128, 128, 32, 1, 4, group_m=8)
CONFIGS_BY_SHAPE = {
    (1024, 1024, 1024): SELECTED_CONFIG,
    (1024, 4096, 2048): Config(128, 128, 32, 1, 4, group_m=2),
}
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


def solve(config=None, shape=(1024, 1024, 1024)):
    shape = tuple(shape)
    if config is None:
        config = CONFIGS_BY_SHAPE[shape]
    validate_config(config, shape)
    architecture = torch.cuda.get_device_properties(0).gcnArchName.split(":")[0]
    if architecture not in ("gfx1151", "gfx1152"):
        raise RuntimeError(
            f"This lesson supports gfx1151/gfx1152; detected {architecture}"
        )
    launch = build(config)
    boundaries = check_boundaries(config)
    generator = torch.Generator().manual_seed(13)
    checkpoint = None
    m, n, k = shape
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
        "shapes_MNK": [shape],
        "patterns": 2,
        "first_four": checkpoint,
        "config": config.name,
        "accumulator_values": config.accumulator_values,
        "lds_bytes": config.lds_bytes,
        "pipeline_boundaries": boundaries,
    }


def main():
    torch.set_num_threads(1)
    if globals().get("_COURSE_CHECK_ONLY", False):
        for shape in CONFIGS_BY_SHAPE:
            print("Exercise passed:", solve(shape=shape), flush=True)
        return
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--shape",
        type=int,
        nargs=3,
        default=(1024, 1024, 1024),
        metavar=("M", "N", "K"),
    )
    parser.add_argument("--check-only", action="store_true")
    parser.add_argument(
        "--timing", choices=("auto", "host", "gpu-event"), default="auto"
    )
    parser.add_argument("--repeats", type=int, default=20)
    args = parser.parse_args()
    shape = tuple(args.shape)
    if shape not in CONFIGS_BY_SHAPE:
        parser.error(
            "No locked config for this shape; use tune.py --shape M N K --sweep first"
        )
    if args.repeats < 1:
        parser.error("repeats must be positive")
    try:
        print("Exercise passed:", solve(shape=shape), flush=True)
        if args.check_only:
            return
        benchmark = runpy.run_path(
            str(Path(__file__).resolve().parents[4] / "examples/matmul_benchmark.py")
        )
        config = CONFIGS_BY_SHAPE[shape]
        metadata, rows = benchmark["comparison"](
            {config.name: build(config)}, args.timing, args.repeats, shape=shape
        )
        print(json.dumps(metadata))
        for row in rows:
            print(json.dumps(row))
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None


if __name__ == "__main__":
    main()
