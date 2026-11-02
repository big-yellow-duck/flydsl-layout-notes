"""BF16 matmul: 04-matrix-instructions. See README.md for the exercise."""

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
    # 1. Describe the global row-major matrices.
    left_global_view = fx.make_view(fx.get_iter(left), fx.make_layout((m, k), (k, 1)))
    right_global_view = fx.make_view(fx.get_iter(right), fx.make_layout((k, n), (n, 1)))
    out_global_view = fx.make_view(fx.get_iter(out), fx.make_layout((m, n), (n, 1)))
    block_row = fx.block_idx.y
    block_col = fx.block_idx.x
    # 2. Expose 16-wide K windows; select the output tile once.
    left_tiled_view = fx.flat_divide(left_global_view, (16, 16))
    right_tiled_view = fx.flat_divide(right_global_view, (16, 16))
    out_tiled_view = fx.flat_divide(out_global_view, (16, 16))
    out_block_view = fx.slice(out_tiled_view, (None, None, block_row, block_col))
    # Allocate separate physical LDS storage, then attach ordinary 2-D layouts.
    allocator = fx.SharedAllocator()
    left_shared_view = (
        allocator.allocate(fx.Array[fx.BFloat16, 256])
        .peek()
        .view(fx.make_layout((16, 16), (16, 1)))
    )
    right_shared_view = (
        allocator.allocate(fx.Array[fx.BFloat16, 256])
        .peek()
        .view(fx.make_layout((16, 16), (16, 1)))
    )
    copy_layout = fx.make_ordered_layout((16, 16), (1, 0))
    # 3. Describe MMA operand coordinates over the existing LDS storage.
    left_mma_view = left_shared_view
    # TODO 1: Fill in right_mma_view; see README.md.
    right_mma_view = None
    if right_mma_view is None:
        raise NotImplementedError("Fill in right_mma_view.")
    # TODO 2: Fill in atom; see README.md.
    atom = None
    if atom is None:
        raise NotImplementedError("Fill in atom.")
    mma = fx.make_tiled_mma(atom, fx.make_layout((1, 1, 1), (0, 0, 0)))
    thread_mma = mma.thr_slice(fx.thread_idx.x)
    accumulators = thread_mma.make_fragment_C(out_block_view)
    accumulators.fill(0)
    copy_ab = fx.make_copy_atom(fx.UniversalCopy(16), fx.BFloat16)
    copy_c = fx.make_copy_atom(fx.UniversalCopy(16), fx.BFloat16)
    thread_a = fx.make_tiled_copy_A(copy_ab, mma).get_slice(fx.thread_idx.x)
    thread_b = fx.make_tiled_copy_B(copy_ab, mma).get_slice(fx.thread_idx.x)
    thread_c = fx.make_tiled_copy_C(copy_c, mma).get_slice(fx.thread_idx.x)
    fragment_a = thread_mma.make_fragment_A(left_mma_view)
    fragment_b = thread_mma.make_fragment_B(right_mma_view)
    source_a = thread_a.partition_S(left_mma_view)
    source_b = thread_b.partition_S(right_mma_view)
    register_a = thread_a.retile(fragment_a)
    register_b = thread_b.retile(fragment_b)
    # 4. Keep the same native K windows and cooperative LDS staging as lesson 03.
    for tile_k in range(k // 16):
        left_block_view = fx.slice(left_tiled_view, (None, None, block_row, tile_k))
        right_block_view = fx.slice(right_tiled_view, (None, None, tile_k, block_col))
        # The copy coordinate is local to both the global window and its LDS tile.
        for load_slot in fx.range_constexpr(8):
            copy_coordinate = fx.idx2crd(fx.thread_idx.x + load_slot * 32, copy_layout)
            left_shared_view[copy_coordinate] = left_block_view[copy_coordinate]
            right_shared_view[copy_coordinate] = right_block_view[copy_coordinate]
        fx.gpu.barrier()
        fx.copy(copy_ab, source_a, register_a)
        fx.copy(copy_ab, source_b, register_b)
        fx.gemm(atom, accumulators, fragment_a, fragment_b, accumulators)
        fx.gpu.barrier()
    # 5. Convert once to BF16 and store via the instruction's output ownership.
    result = fx.make_rmem_tensor(accumulators.layout, fx.BFloat16)
    for slot in fx.range_constexpr(8):
        result[slot] = accumulators[slot].to(fx.BFloat16)
    destination = thread_c.partition_S(out_block_view)
    fx.copy(copy_c, thread_c.retile(result), destination)


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
        grid=(n // 16, m // 16, 1), block=(32, 1, 1)
    )


def solve():
    architecture = torch.cuda.get_device_properties(0).gcnArchName.split(":")[0]
    if architecture not in ("gfx1151", "gfx1152"):
        raise RuntimeError(
            f"This lesson supports gfx1151/gfx1152; detected {architecture}"
        )
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
    benchmark = runpy.run_path(
        str(Path(__file__).resolve().parents[4] / "examples/matmul_benchmark.py")
    )
    benchmark["lesson_main"](
        run,
        solve,
        Path(__file__).parent.name,
        check_only=globals().get("_COURSE_CHECK_ONLY", False),
    )
