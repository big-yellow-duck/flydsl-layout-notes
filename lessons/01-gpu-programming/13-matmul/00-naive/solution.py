"""BF16 matmul: 00-naive. See README.md for the exercise."""

import runpy
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def exercise_kernel(
    left: fx.Tensor,
    right: fx.Tensor,
    out: fx.Tensor,
    m: fx.Constexpr,
    n: fx.Constexpr,
    k: fx.Constexpr,
):
    # 1. Describe the row-major matrices, then select this block's windows.
    left_global_view = fx.make_view(fx.get_iter(left), fx.make_layout((m, k), (k, 1)))
    right_global_view = fx.make_view(fx.get_iter(right), fx.make_layout((k, n), (n, 1)))
    out_global_view = fx.make_view(fx.get_iter(out), fx.make_layout((m, n), (n, 1)))

    left_tiled_view = fx.flat_divide(left_global_view, (16, k))
    right_tiled_view = fx.flat_divide(right_global_view, (k, 16))
    out_tiled_view = fx.flat_divide(out_global_view, (16, 16))
    block_row = fx.block_idx.y
    block_col = fx.block_idx.x

    # flat_divide exposes (local_row, local_col, tile_row, tile_col).
    left_block_view = fx.slice(left_tiled_view, (None, None, block_row, 0))
    right_block_view = fx.slice(right_tiled_view, (None, None, 0, block_col))
    out_block_view = fx.slice(out_tiled_view, (None, None, block_row, block_col))

    # 2. A 16 x 16 row major thread layout assigns one local output coordinate per thread.
    thread_layout = fx.make_ordered_layout((16, 16), (1, 0))
    thread_coordinate = fx.idx2crd(fx.thread_idx.x, thread_layout)
    left_row = fx.slice(left_block_view, (thread_coordinate[0], None))
    right_column = fx.slice(right_block_view, (None, thread_coordinate[1]))

    # 3. Reduce this thread's row and column in FP32, then store through its tile.
    accumulator = fx.Float32(0)
    for inner in range(k):
        # Widen the loaded BF16 value before multiplying.
        a = fx.Float32(left_row[inner])
        # The column view retains the global row stride of N.
        b = fx.Float32(right_column[inner])
        accumulator = accumulator + a * b
    out_block_view[thread_coordinate] = accumulator.to(fx.BFloat16)


@flyc.jit
def run(
    left: fx.Tensor,
    right: fx.Tensor,
    out: fx.Tensor,
    m: fx.Constexpr,
    n: fx.Constexpr,
    k: fx.Constexpr,
):
    exercise_kernel(left, right, out, m, n, k).launch(
        grid=(n // 16, m // 16, 1), block=(256, 1, 1)
    )


def solve():
    # Fixed workload: 64 x 64 output tiles; each thread reduces all 1024 K values.
    shapes = [(1024, 1024, 1024)]
    generator = torch.Generator().manual_seed(13)
    checkpoint = None
    for m, n, k in shapes:
        for pattern in ("trace", "random"):
            if pattern == "trace":
                a_cpu = ((torch.arange(m * k).reshape(m, k) % 5) - 2).to(torch.bfloat16)
                b_cpu = ((torch.arange(k * n).reshape(k, n) % 7) - 3).to(torch.bfloat16)
            else:
                a_cpu = torch.randn(m, k, generator=generator).to(torch.bfloat16)
                b_cpu = torch.randn(k, n, generator=generator).to(torch.bfloat16)
            left, right = a_cpu.cuda(), b_cpu.cuda()
            storage = torch.full(
                (m * n + 16,), -99, dtype=torch.bfloat16, device="cuda"
            )
            out = storage[: m * n].view(m, n)
            out.fill_(float("nan"))
            run(left, right, out, m, n, k)
            torch.cuda.synchronize()
            # CPU FP32 arithmetic on the actual quantized BF16 inputs is independent
            # of the GPU kernel. Round the reference to the same output dtype.
            expected = (a_cpu.float() @ b_cpu.float()).to(torch.bfloat16)
            torch.testing.assert_close(
                out.cpu(),
                expected,
                rtol=0 if pattern == "trace" else 0.016,
                atol=0.001 if pattern == "trace" else 0.03125,
            )
            assert torch.all(storage[m * n :] == -99).item(), "Output sentinel changed"
            if (m, n, k) == (1024, 1024, 1024) and pattern == "trace":
                checkpoint = out[0, :4].cpu().tolist()
    return {"shapes_MNK": shapes, "patterns": 2, "first_four": checkpoint}


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
