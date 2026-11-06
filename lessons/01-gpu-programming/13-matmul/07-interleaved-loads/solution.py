"""BF16 matmul: 07-interleaved-loads.

Run: pixi run python lessons/01-gpu-programming/13-matmul/07-interleaved-loads/solution.py
"""

import runpy
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch

BLOCK_M = 64
BLOCK_N = 64
BLOCK_K = 64
MMA_M = 16
MMA_N = 16
MMA_K = 16
THREADS_PER_BLOCK = 128
ACCUMULATOR_VALUES = BLOCK_M * BLOCK_N // THREADS_PER_BLOCK


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
    schedule: fx.Constexpr = "serial",
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

    # 3. Keep one LDS tile per operand; only the load/compute schedule changes.
    lds = fx.SharedAllocator().allocate(SharedStorage).peek()
    left_lds_view = lds.left.view(fx.make_layout((BLOCK_M, BLOCK_K), (BLOCK_K + 8, 1)))
    right_lds_view = lds.right.view(fx.make_layout((BLOCK_K, BLOCK_N), (BLOCK_N, 1)))

    copy_128b = fx.make_copy_atom(fx.UniversalCopy128b(), fx.BFloat16)
    gmem2lds_thread_layout = fx.make_ordered_layout((16, 8), (1, 0))
    gmem2lds_val_layout = fx.make_ordered_layout((1, 8), (1, 0))
    gmem2lds_tilemn, gmem2lds_tv_layout = fx.make_layout_tv(
        gmem2lds_thread_layout, gmem2lds_val_layout
    )
    gmem2lds_copy_plan = fx.make_tiled_copy(
        copy_128b, gmem2lds_tv_layout, gmem2lds_tilemn
    )
    gmem2lds_thread_copy = gmem2lds_copy_plan.get_slice(fx.thread_idx.x)
    gmem2lds_left_destination = gmem2lds_thread_copy.partition_D(left_lds_view)
    gmem2lds_right_destination = gmem2lds_thread_copy.partition_D(right_lds_view)
    left_fragment = fx.make_fragment_like(gmem2lds_left_destination)
    right_fragment = fx.make_fragment_like(gmem2lds_right_destination)

    # create tiled view ready for mma to consume
    left_lds_tiled = fx.flat_divide(left_lds_view, (BLOCK_M, MMA_K))
    right_lds_tranposed_view = fx.make_view(
        fx.get_iter(right_lds_view), fx.make_layout((BLOCK_N, BLOCK_K), (1, BLOCK_N))
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
    mma = fx.make_tiled_mma(mma_atom, fx.make_layout((2, 2, 1), (1, 2, 0)))

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
            gmem2lds_thread_copy.partition_S(left_block_view),
            gmem2lds_thread_copy.partition_S(right_block_view),
        )

    def gmem2reg_load_tile(tile_k):
        left_block_view = fx.slice(left_tiled_view, (None, None, block_row, tile_k))
        right_block_view = fx.slice(right_tiled_view, (None, None, tile_k, block_col))
        left_lds_source, right_lds_source = create_gmem2lds_sources(
            left_block_view, right_block_view
        )
        fx.copy(copy_128b, left_lds_source, left_fragment)
        fx.copy(copy_128b, right_lds_source, right_fragment)

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


    if schedule == "serial":
        for tile_k in range(k // BLOCK_K):
            gmem2reg_load_tile(tile_k)
            reg2lds_copy_tile()
            compute_lds()
            fx.barrier()
    else:
        # get the first block ready
        initial_tile_k = 0
        gmem2reg_load_tile(initial_tile_k)
        reg2lds_copy_tile()

        for tile_k in range(k // BLOCK_K - 1):
            next_tile_k = tile_k + 1
            gmem2reg_load_tile(next_tile_k)
            compute_lds()
            fx.barrier()
            reg2lds_copy_tile()
        # Drain the final LDS tile once, even when the steady-state loop is empty.
        compute_lds()
        fx.barrier()
    # 7. Convert to BF16, then store through the instruction's C ownership.
    out_registers = fx.make_rmem_tensor(accumulator.layout, fx.BFloat16)
    for slot in fx.range_constexpr(ACCUMULATOR_VALUES):
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
    schedule: fx.Constexpr = "prefetch",
):
    exercise_kernel(left, right, out, m, n, k, schedule).launch(
        grid=(n // BLOCK_N, m // BLOCK_M, 1), block=(THREADS_PER_BLOCK, 1, 1)
    )


def check_boundaries(schedule):
    """Exact stage tags catch an omitted/duplicated prologue, handoff, or drain."""
    checked = []
    for tiles in (1, 2, 3):
        m, n = BLOCK_M, BLOCK_N
        k = BLOCK_K * tiles
        # A's K tiles contain 1,2,4; B contains 1. Expected sums are 64,192,448.
        tags = (2 ** (torch.arange(k, dtype=torch.int32) // BLOCK_K)).to(torch.bfloat16)
        left = tags.expand(m, k).contiguous().cuda()
        right = torch.ones((k, n), dtype=torch.bfloat16, device="cuda")
        storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
        out = storage[: m * n].view(m, n)
        out.fill_(float("nan"))
        run(left, right, out, m, n, k, schedule)
        torch.cuda.synchronize()
        expected = BLOCK_K * (2**tiles - 1)
        torch.testing.assert_close(
            out.cpu(),
            torch.full((m, n), expected, dtype=torch.bfloat16),
            rtol=0,
            atol=0,
        )
        assert torch.all(storage[m * n :] == -99).item(), "Boundary sentinel changed"
        checked.append({"K_tiles": tiles, "expected": expected})
    return checked


def solve(schedule="prefetch"):
    if schedule not in ("serial", "prefetch"):
        raise ValueError(f"Unknown schedule: {schedule}")
    architecture = torch.cuda.get_device_properties(0).gcnArchName.split(":")[0]
    if architecture not in ("gfx1151", "gfx1152"):
        raise RuntimeError(
            f"This lesson supports gfx1151/gfx1152; detected {architecture}"
        )
    boundaries = check_boundaries(schedule)
    # Fixed comparison workload: 16 x 16 output tiles, each with 16 K tiles.
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
            run(left, right, out, m, n, k, schedule)
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
    return {
        "shapes_MNK": shapes,
        "patterns": 2,
        "first_four": checkpoint,
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
