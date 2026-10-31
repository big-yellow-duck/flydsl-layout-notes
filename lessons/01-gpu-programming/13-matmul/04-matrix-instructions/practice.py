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
    # 1. Reuse contiguous input views; each block owns a 16 x 16 output tile.
    tid = fx.thread_idx.x
    row_base = fx.block_idx.y * 16
    col_base = fx.block_idx.x * 16
    left = fx.make_view(fx.get_iter(left), fx.make_layout(m * k, 1))
    right = fx.make_view(fx.get_iter(right), fx.make_layout(k * n, 1))
    # 2. Stage ordinary row-major inputs, then describe the MMA operand views.
    allocator = fx.SharedAllocator()
    shared_a = (
        allocator.allocate(fx.Array[fx.BFloat16, 256])
        .peek()
        .view(fx.make_layout(256, 1))
    )
    shared_b = (
        allocator.allocate(fx.Array[fx.BFloat16, 256])
        .peek()
        .view(fx.make_layout(256, 1))
    )
    a_tile = fx.make_view(fx.get_iter(shared_a), fx.make_layout((16, 16), (16, 1)))
    # MMA names B's modes (N,K); the underlying LDS values remain row-major (K,N).
    # TODO 1: Fill in b_tile; see README.md.
    b_tile = None
    if b_tile is None:
        raise NotImplementedError("Fill in b_tile.")
    c_view = fx.make_view(fx.get_iter(out), fx.make_layout((m, n), (n, 1)))
    c_tiles = fx.zipped_divide(c_view, (16, 16))
    c_tile = fx.slice(c_tiles, (None, (fx.block_idx.y, fx.block_idx.x)))
    # 3. One wave32 executes a BF16 16x16x16 WMMA with FP32 accumulators.
    # TODO 2: Fill in atom; see README.md.
    atom = None
    if atom is None:
        raise NotImplementedError("Fill in atom.")
    mma = fx.make_tiled_mma(atom, fx.make_layout((1, 1, 1), (0, 0, 0)))
    thread_mma = mma.thr_slice(tid)
    accumulators = thread_mma.make_fragment_C(c_tile)
    accumulators.fill(0)
    copy_ab = fx.make_copy_atom(fx.UniversalCopy(16), fx.BFloat16)
    copy_c = fx.make_copy_atom(fx.UniversalCopy(16), fx.BFloat16)
    thread_a = fx.make_tiled_copy_A(copy_ab, mma).get_slice(tid)
    thread_b = fx.make_tiled_copy_B(copy_ab, mma).get_slice(tid)
    thread_c = fx.make_tiled_copy_C(copy_c, mma).get_slice(tid)
    fragment_a = thread_mma.make_fragment_A(a_tile)
    fragment_b = thread_mma.make_fragment_B(b_tile)
    source_a = thread_a.partition_S(a_tile)
    source_b = thread_b.partition_S(b_tile)
    register_a = thread_a.retile(fragment_a)
    register_b = thread_b.retile(fragment_b)
    for tile_k in range(k // 16):
        # The wave stages each input once; WMMA's replicated operands load from LDS.
        for slot in fx.range_constexpr(8):
            position = tid + slot * 32
            tile_row = position // 16
            tile_col = position % 16
            shared_a[position] = left[
                (row_base + tile_row) * k + tile_k * 16 + tile_col
            ]
            shared_b[position] = right[
                (tile_k * 16 + tile_row) * n + col_base + tile_col
            ]
        fx.gpu.barrier()
        fx.copy(copy_ab, source_a, register_a)
        fx.copy(copy_ab, source_b, register_b)
        fx.gemm(atom, accumulators, fragment_a, fragment_b, accumulators)
        fx.gpu.barrier()
    # 4. Convert the FP32 result fragment once, then copy its BF16 representation.
    result = fx.make_rmem_tensor(accumulators.layout, fx.BFloat16)
    for slot in fx.range_constexpr(8):
        result[slot] = accumulators[slot].to(fx.BFloat16)
    destination = thread_c.partition_S(c_tile)
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
