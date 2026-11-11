"""BF16 matmul: 02-register-tiling. See README.md for the exercise."""

import runpy
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch

BLOCK_M = 64
BLOCK_N = 64
VECTOR_WIDTH = 128
THREADS_PER_BLOCK = 256


@flyc.kernel
def exercise_kernel(
    left: fx.Tensor,
    right: fx.Tensor,
    out: fx.Tensor,
    m: fx.Constexpr,
    n: fx.Constexpr,
    k: fx.Constexpr,
):
    # 1. Describe the global row-major matrices.
    left_global_view = fx.make_view(fx.get_iter(left), fx.make_layout((m, k), (k, 1)))
    right_global_view = fx.make_view(fx.get_iter(right), fx.make_layout((k, n), (n, 1)))
    out_global_view = fx.make_view(fx.get_iter(out), fx.make_layout((m, n), (n, 1)))
    block_row = fx.block_idx.y
    block_col = fx.block_idx.x

    # 2. Select this block's full-K input windows and 16 x 16 output window.
    left_tiled_view = fx.flat_divide(left_global_view, (BLOCK_M, k))
    right_tiled_view = fx.flat_divide(right_global_view, (k, BLOCK_N))
    out_tiled_view = fx.flat_divide(out_global_view, (BLOCK_M, BLOCK_N))
    left_block_view = fx.slice(left_tiled_view, (None, None, block_row, 0))
    right_block_view = fx.slice(right_tiled_view, (None, None, 0, block_col))
    out_block_view = fx.slice(out_tiled_view, (None, None, block_row, block_col))
    print(left_tiled_view.shape)
    print("left block view:")
    print(left_block_view)
    print("right block view")
    print(right_block_view)

    # 3. A (16,16) thread layout selects a four-row group and one column.
    # use 64 threads to compute (16*16 output)
    thread_layout = fx.make_ordered_layout((16, 16), (1, 0))
    thread_coordinate = fx.idx2crd(fx.thread_idx.x, thread_layout)
    # slice out per thread work of (4,1)
    out_thread_tiled_view = fx.flat_divide(out_block_view, (4, 4))
    out_thread_view = fx.slice(
        out_thread_tiled_view, (None, None, thread_coordinate[0], thread_coordinate[1])
    )
    left_thread_tiled_view = fx.flat_divide(left_block_view, (4, k))  # noqa: F841 -- used by the practice TODOs
    print("left thread tiled view:")
    print(left_thread_tiled_view)

    right_thread_tiled_view = fx.flat_divide(right_block_view, (k, 4))
    print("right thread tiled view")
    print(right_thread_tiled_view)
    # TODO 1: Fill in left_thread_view; see README.md.
    left_thread_view = None
    if left_thread_view is None:
        raise NotImplementedError("Fill in left_thread_view.")
    print("left thread view:")
    print(left_thread_view)

    right_thread_view = fx.slice(
        right_thread_tiled_view, (None, None, 0, thread_coordinate[1])
    )
    
    accumulators = fx.make_rmem_tensor(fx.make_layout((4, 4), (4, 1)), fx.Float32)
    accumulators.fill(0)
    # 4. Each thread accumulates a 4 x 4 tile. Reuse each B value for both rows.
    for inner in range(k):
        for col in fx.range_constexpr(4):
            b = fx.Float32(right_thread_view[fx.make_coord(inner, col)])
            for row in fx.range_constexpr(4):
                a = fx.Float32(left_thread_view[fx.make_coord(row, inner)])
                coord = fx.make_coord(row, col)
                updated = accumulators[coord] + a * b
                accumulators[coord] = updated

    for row in fx.range_constexpr(4):
        for col in fx.range_constexpr(4):
            coord = fx.make_coord(row, col)
            out_thread_view[coord] = accumulators[coord].to(fx.BFloat16)

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
        grid=(n // BLOCK_M, m // BLOCK_N, 1), block=(THREADS_PER_BLOCK, 1, 1)
    )


def solve():
    # Fixed workload: 64 x 64 output tiles, with a full-K reduction per thread.
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
