"""BF16 matmul: 06-lds-swizzle.

Run: pixi run python lessons/01-gpu-programming/13-matmul/06-lds-swizzle/solution.py
"""

import runpy
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch

BLOCK_M = 32
BLOCK_N = 32
BLOCK_K = 32
THREADS_PER_BLOCK = 128


@fx.struct
class SharedStorage:
    left: fx.Array[fx.BFloat16, BLOCK_M * BLOCK_K, 16]
    right: fx.Array[fx.BFloat16, BLOCK_K * BLOCK_N, 16]


@fx.struct
class PaddedSharedStorage:
    left: fx.Array[fx.BFloat16, BLOCK_M * (BLOCK_K + 8), 16]
    right: fx.Array[fx.BFloat16, BLOCK_K * BLOCK_N, 16]


def create_lds_views(layout_mode):
    """Tracing-time selection: the storage wrappers never cross a runtime branch."""
    # Packed/swizzled A needs 1024 elements; padded A reserves 32*40 elements.
    if layout_mode == "padded":
        lds = fx.SharedAllocator().allocate(PaddedSharedStorage).peek()
        left_lds_layout = fx.make_layout((BLOCK_M, BLOCK_K), (BLOCK_K + 8, 1))
    else:
        lds = fx.SharedAllocator().allocate(SharedStorage).peek()
        left_lds_base_layout = fx.make_layout((BLOCK_M, BLOCK_K), (BLOCK_K, 1))
        left_lds_layout = left_lds_base_layout
        if layout_mode == "swizzle":
            # Element-offset bits 6..8 XOR into bits 3..5; low 3 stay intact.
            swizzle = fx.static(fx.SwizzleType.get(3, 3, 3))
            left_lds_layout = fx.make_composed_layout(swizzle, 0, left_lds_base_layout)
    left_lds_view = lds.left.view(left_lds_layout)
    # Keep B packed in every variant to isolate A's physical placement.
    right_lds_view = lds.right.view(fx.make_layout((BLOCK_K, BLOCK_N), (BLOCK_N, 1)))

    return left_lds_view, right_lds_view


@flyc.kernel
def exercise_kernel(
    left: fx.Tensor,
    right: fx.Tensor,
    out: fx.Tensor,
    m: fx.Constexpr,
    n: fx.Constexpr,
    k: fx.Constexpr,
    layout_mode: fx.Constexpr = "swizzle",
):
    # 1. Describe the global row-major matrices, as in stage 04.
    left_global_view = fx.make_view(fx.get_iter(left), fx.make_layout((m, k), (k, 1)))
    right_global_view = fx.make_view(fx.get_iter(right), fx.make_layout((k, n), (n, 1)))
    out_global_view = fx.make_view(fx.get_iter(out), fx.make_layout((m, n), (n, 1)))
    block_row = fx.block_idx.y
    block_col = fx.block_idx.x

    # 2. Select a four-wave block tile, retaining global row strides.
    left_tiled_view = fx.flat_divide(left_global_view, (BLOCK_M, BLOCK_K))
    right_tiled_view = fx.flat_divide(right_global_view, (BLOCK_K, BLOCK_N))
    out_tiled_view = fx.flat_divide(out_global_view, (BLOCK_M, BLOCK_N))
    out_block_view = fx.slice(out_tiled_view, (None, None, block_row, block_col))

    # 3. Change A's physical placement while retaining logical (M,K) coordinates.
    left_lds_view, right_lds_view = create_lds_views(layout_mode)

    # 4. Keep stage 04's generic staging plan; adapt ownership to 128 threads.
    copy_128b = fx.make_copy_atom(fx.UniversalCopy128b(), fx.BFloat16)
    gmem2lds_thread_layout = fx.make_ordered_layout((32, 4), (1, 0))
    gmem2lds_val_layout = fx.make_ordered_layout((1, 8), (1, 0))
    gmem2lds_tilemn, gmem2lds_tv_layout = fx.make_layout_tv(
        gmem2lds_thread_layout, gmem2lds_val_layout
    )
    gmem2lds_copy_plan = fx.make_tiled_copy(
        copy_128b, gmem2lds_tv_layout, gmem2lds_tilemn
    )
    gmem2lds_thread_copy = gmem2lds_copy_plan.get_slice(fx.thread_idx.x)
    left_lds_destination = gmem2lds_thread_copy.partition_D(left_lds_view)
    right_lds_destination = gmem2lds_thread_copy.partition_D(right_lds_view)
    left_fragment = fx.make_fragment_like(left_lds_destination)
    right_fragment = fx.make_fragment_like(right_lds_destination)

    # 5. Let WMMA define operand and accumulator ownership instead of a 4x4 tile.
    left_mma_view = left_lds_view  # (M,K)
    right_mma_view = fx.make_view(
        fx.get_iter(right_lds_view), fx.make_layout((BLOCK_N, BLOCK_K), (1, BLOCK_N))
    )  # (N,K), over the existing row-major B storage; no data transpose.
    atom = fx.make_mma_atom(fx.rocdl.WMMA(16, 16, 16, fx.BFloat16, fx.Float32))
    mma = fx.make_tiled_mma(atom, fx.make_layout((2, 2, 1), (1, 2, 0)))
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
    left_r_source = lds2reg_left_thread_copy.partition_S(left_mma_view)
    right_r_source = lds2reg_right_thread_copy.partition_S(right_mma_view)
    left_r_destination = lds2reg_left_thread_copy.retile(left_r_tile)
    right_r_destination = lds2reg_right_thread_copy.retile(right_r_tile)

    # Tracing-time helper keeps the copy wrapper outside runtime loop state.
    def create_gmem2lds_sources(left_block_view, right_block_view):
        return (
            gmem2lds_thread_copy.partition_S(left_block_view),
            gmem2lds_thread_copy.partition_S(right_block_view),
        )

    # 6. Stage, synchronize, load operands, execute WMMA, then protect LDS reuse.
    for tile_k in range(k // BLOCK_K):
        left_block_view = fx.slice(left_tiled_view, (None, None, block_row, tile_k))
        right_block_view = fx.slice(right_tiled_view, (None, None, tile_k, block_col))
        left_lds_source, right_lds_source = create_gmem2lds_sources(
            left_block_view, right_block_view
        )
        fx.copy(copy_128b, left_lds_source, left_fragment)
        fx.copy(copy_128b, right_lds_source, right_fragment)
        fx.copy(copy_128b, left_fragment, left_lds_destination)
        fx.copy(copy_128b, right_fragment, right_lds_destination)
        fx.barrier()
        # Load 32 K positions per operand; GEMM iterates two 16-wide K fragments.
        fx.copy(copy_16b, left_r_source, left_r_destination)
        fx.copy(copy_16b, right_r_source, right_r_destination)
        fx.gemm(atom, accumulator, left_r_tile, right_r_tile, accumulator)
        fx.barrier()

    # 7. Convert to BF16, then store through the instruction's C ownership.
    out_registers = fx.make_rmem_tensor(accumulator.layout, fx.BFloat16)
    for slot in fx.range_constexpr(8):
        out_registers[slot] = accumulator[slot].to(fx.BFloat16)
    # Replace stage 04's one-thread output plan with the collective C plan.
    reg2gmem_copy_plan = fx.make_tiled_copy_C(copy_16b, mma)
    reg2gmem_thread_copy = reg2gmem_copy_plan.get_slice(fx.thread_idx.x)
    reg2gmem_source = reg2gmem_thread_copy.retile(out_registers)
    reg2gmem_dest = reg2gmem_thread_copy.partition_D(out_block_view)
    fx.copy(copy_16b, reg2gmem_source, reg2gmem_dest)


@flyc.jit
def run(
    left: fx.Tensor,
    right: fx.Tensor,
    out: fx.Tensor,
    m: fx.Constexpr,
    n: fx.Constexpr,
    k: fx.Constexpr,
    layout_mode: fx.Constexpr = "swizzle",
):
    exercise_kernel(left, right, out, m, n, k, layout_mode).launch(
        grid=(n // BLOCK_N, m // BLOCK_M, 1), block=(THREADS_PER_BLOCK, 1, 1)
    )


def solve(layout_mode="padded"):
    if layout_mode not in ("packed", "swizzle", "padded"):
        raise ValueError(f"Unknown LDS layout: {layout_mode}")
    architecture = torch.cuda.get_device_properties(0).gcnArchName.split(":")[0]
    if architecture not in ("gfx1151", "gfx1152"):
        raise RuntimeError(
            f"This lesson supports gfx1151/gfx1152; detected {architecture}"
        )
    # Fixed comparison workload: 32 x 32 output tiles, each with 32 K tiles.
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
            run(left, right, out, m, n, k, layout_mode)
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
