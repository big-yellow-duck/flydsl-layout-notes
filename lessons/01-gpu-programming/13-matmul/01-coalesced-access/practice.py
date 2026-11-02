"""BF16 matmul: 01-coalesced-access. See README.md for the exercise."""

import runpy
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch

RIGHT_LAYOUT = "column-major"


@flyc.kernel
def exercise_kernel(
    left: fx.Tensor,
    right: fx.Tensor,
    out: fx.Tensor,
    m: fx.Constexpr,
    n: fx.Constexpr,
    k: fx.Constexpr,
):
    # 1. A/C are row-major; B is physically column-major with logical shape (K,N).
    left_global_view = fx.make_view(fx.get_iter(left), fx.make_layout((m, k), (k, 1)))
    right_global_view = fx.make_view(fx.get_iter(right), fx.make_layout((k, n), (1, k)))
    out_global_view = fx.make_view(fx.get_iter(out), fx.make_layout((m, n), (n, 1)))
    block_row = fx.block_idx.y
    block_col = fx.block_idx.x
    # 2. Select this block's full-K input windows and 16 x 16 output window.
    left_tiled_view = fx.flat_divide(left_global_view, (16, k))
    right_tiled_view = fx.flat_divide(right_global_view, (k, 16))
    out_tiled_view = fx.flat_divide(out_global_view, (16, 16))
    left_block_view = fx.slice(left_tiled_view, (None, None, block_row, 0))
    right_block_view = fx.slice(right_tiled_view, (None, None, 0, block_col))
    out_block_view = fx.slice(out_tiled_view, (None, None, block_row, block_col))
    # 3. Keep one output per thread; both selected inputs are contiguous along K.
    # TODO 1: Fill in thread_layout; see README.md.
    thread_layout = None
    thread_layout = fx.make_ordered_layout((16, 16), (1, 0))
    if thread_layout is None:
        raise NotImplementedError("Fill in thread_layout.")
    # TODO 2: Fill in thread_coordinate; see README.md.
    thread_coordinate = None
    thread_index_x = fx.thread_idx.x
    thread_coordinate = fx.idx2crd(thread_index_x, thread_layout)
    if thread_coordinate is None:
        raise NotImplementedError("Fill in thread_coordinate.")
    left_row = fx.slice(left_block_view, (thread_coordinate[0], None))
    right_column = fx.slice(right_block_view, (None, thread_coordinate[1]))
    # 4. Widen scalar loads before multiplying; retain FP32 across all K.
    accumulator = fx.Float32(0)
    for inner in range(k):
        a = fx.Float32(left_row[inner])
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
            left = a_cpu.cuda()
            # Pack B's columns before launching. Logical values and shape stay (K,N).
            right = b_cpu.cuda().t().contiguous().t()
            assert right.shape == (k, n) and right.stride() == (1, k)
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
        right_layout=RIGHT_LAYOUT,
    )
