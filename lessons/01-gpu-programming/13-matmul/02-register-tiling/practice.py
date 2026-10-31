"""BF16 matmul: 02-register-tiling. See README.md for the exercise."""

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
    # 1. Reuse contiguous input views; each block owns a 16 x 16 output tile.
    # Flat views make scalar indices explicit row-major storage offsets.
    left = fx.make_view(fx.get_iter(left), fx.make_layout(m * k, 1))
    right = fx.make_view(fx.get_iter(right), fx.make_layout(k * n, 1))
    out = fx.make_view(fx.get_iter(out), fx.make_layout(m * n, 1))
    tid = fx.thread_idx.x
    row_base = fx.block_idx.y * 16  # noqa: F841 -- used by the practice TODOs
    col_base = fx.block_idx.x * 16
    # 2. Each thread owns four rows at one column; reuse B across those rows.
    # TODO 1: Fill in row; see README.md.
    row = None
    if row is None:
        raise NotImplementedError("Fill in row.")
    col = col_base + tid % 16
    accumulators = fx.make_rmem_tensor(fx.make_layout(4, 1), fx.Float32)
    accumulators.fill(0)
    for inner in range(k):
        b = fx.Float32(right[inner * n + col])  # noqa: F841 -- used by the practice TODOs
        for slot in fx.range_constexpr(4):
            a = fx.Float32(left[(row + slot) * k + inner])  # noqa: F841 -- used by the practice TODOs
            # TODO 2: Fill in updated; see README.md.
            updated = None
            if updated is None:
                raise NotImplementedError("Fill in updated.")
            accumulators[slot] = updated
    # 3. Each output element has exactly one writer.
    for slot in fx.range_constexpr(4):
        out[(row + slot) * n + col] = accumulators[slot].to(fx.BFloat16)


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
        grid=(n // 16, m // 16, 1), block=(64, 1, 1)
    )


def solve():
    # Fixed comparison workload: 64 x 64 output tiles, each with 64 K tiles.
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
    try:
        print("Exercise passed:", solve())
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None
