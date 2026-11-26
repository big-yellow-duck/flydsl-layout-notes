"""BF16 matmul: 07b-operand-staging.

Run: pixi run python lessons/01-gpu-programming/13-matmul/07b-operand-staging/solution.py
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


@fx.struct
class SharedStorage:
    # Retain stage 06's measured padded A layout and packed B layout.
    a: fx.Array[fx.BFloat16, BLOCK_M * (BLOCK_K + 8), 16]
    b: fx.Array[fx.BFloat16, BLOCK_K * BLOCK_N, 16]


@flyc.kernel
def _matmul_bf16(
    a: fx.Tensor,
    b: fx.Tensor,
    c: fx.Tensor,
    m: fx.Constexpr,
    n: fx.Constexpr,
    k: fx.Constexpr,
):
    # 1. Buffer resources retain the existing row-major matrix layouts.
    a_buffer = fx.rocdl.make_buffer_tensor(a)
    b_buffer = fx.rocdl.make_buffer_tensor(b)
    c_buffer = fx.rocdl.make_buffer_tensor(c)
    a_global_view = fx.make_view(
        fx.get_iter(a_buffer), fx.make_layout((m, k), (k, 1))
    )
    b_global_view = fx.make_view(
        fx.get_iter(b_buffer), fx.make_layout((k, n), (n, 1))
    )
    c_global_view = fx.make_view(
        fx.get_iter(c_buffer), fx.make_layout((m, n), (n, 1))
    )
    block_row = fx.block_idx.y
    block_col = fx.block_idx.x

    # 2. Select a four-wave block tile, retaining global row strides.
    a_tiled_view = fx.flat_divide(a_global_view, (BLOCK_M, BLOCK_K))
    b_tiled_view = fx.flat_divide(b_global_view, (BLOCK_K, BLOCK_N))
    c_tiled_view = fx.flat_divide(c_global_view, (BLOCK_M, BLOCK_N))
    c_block_view = fx.slice(c_tiled_view, (None, None, block_row, block_col))

    # 3. Keep one LDS tile per operand for the register-prefetch schedule.
    lds = fx.SharedAllocator().allocate(SharedStorage).peek()
    a_lds_view = lds.a.view(fx.make_layout((BLOCK_M, BLOCK_K), (BLOCK_K + 8, 1)))
    b_lds_view = lds.b.view(fx.make_layout((BLOCK_K, BLOCK_N), (BLOCK_N, 1)))

    # 4. Derive each operand's staging geometry from its contiguous extent.
    copy_128b = fx.make_copy_atom(fx.UniversalCopy128b(), fx.BFloat16)
    gmem_load_128b = fx.make_copy_atom(fx.rocdl.BufferCopy128b(), fx.BFloat16)
    a_staging_thread_layout = fx.make_ordered_layout(
        (THREADS_PER_BLOCK // (BLOCK_K // 8), BLOCK_K // 8), (1, 0)
    )
    b_staging_thread_layout = fx.make_ordered_layout(
        (THREADS_PER_BLOCK // (BLOCK_N // 8), BLOCK_N // 8), (1, 0)
    )
    staging_value_layout = fx.make_ordered_layout((1, 8), (1, 0))
    a_staging_copy_tile, a_staging_copy_tv = fx.make_layout_tv(
        a_staging_thread_layout, staging_value_layout
    )
    b_staging_copy_tile, b_staging_copy_tv = fx.make_layout_tv(
        b_staging_thread_layout, staging_value_layout
    )
    a_staging_copy_plan = fx.make_tiled_copy(
        copy_128b, a_staging_copy_tv, a_staging_copy_tile
    )
    b_staging_copy_plan = fx.make_tiled_copy(
        copy_128b, b_staging_copy_tv, b_staging_copy_tile
    )
    a_thread_staging_copy = a_staging_copy_plan.get_slice(fx.thread_idx.x)
    b_thread_staging_copy = b_staging_copy_plan.get_slice(fx.thread_idx.x)
    a_lds_destination = a_thread_staging_copy.partition_D(a_lds_view)
    b_lds_destination = b_thread_staging_copy.partition_D(b_lds_view)
    a_staging_fragment = fx.make_fragment_like(a_lds_destination)
    b_staging_fragment = fx.make_fragment_like(b_lds_destination)

    # create tiled view ready for mma to consume
    a_lds_tiled = fx.flat_divide(a_lds_view, (BLOCK_M, MMA_K))
    b_lds_transposed_view = fx.make_view(
        fx.get_iter(b_lds_view), fx.make_layout((BLOCK_N, BLOCK_K), (1, BLOCK_N))
    )
    b_lds_transposed_tiled = fx.flat_divide(
        b_lds_transposed_view, (BLOCK_N, MMA_K)
    )

    # setup initial views
    a_lds_initial_view = fx.slice(a_lds_tiled, (None, None, 0, 0))
    b_lds_transposed_initial_view = fx.slice(
        b_lds_transposed_tiled, (None, None, 0, 0)
    )
    # setup mma
    mma_atom = fx.make_mma_atom(
        fx.rocdl.WMMA(MMA_M, MMA_N, MMA_K, fx.BFloat16, fx.Float32)
    )
    mma = fx.make_tiled_mma(mma_atom, fx.make_layout((2, 2, 1), (1, 2, 0)))

    thread_mma = mma.thr_slice(fx.thread_idx.x)
    c_accum = thread_mma.make_fragment_C(c_block_view)
    ACCUMULATOR_VALUES = fx.size(c_accum.shape).to_py_value()
    c_accum.fill(0)

    # lds to register copies using mma compatible plans
    copy_16b = fx.make_copy_atom(fx.UniversalCopy16b(), fx.BFloat16)
    a_lds2reg_copy_plan = fx.make_tiled_copy_A(copy_16b, mma)
    b_lds2reg_copy_plan = fx.make_tiled_copy_B(copy_16b, mma)

    a_lds2reg_thread_copy = a_lds2reg_copy_plan.get_slice(fx.thread_idx.x)
    b_lds2reg_thread_copy = b_lds2reg_copy_plan.get_slice(fx.thread_idx.x)

    a_r_tile = thread_mma.make_fragment_A(a_lds_initial_view)
    b_r_tile = thread_mma.make_fragment_B(b_lds_transposed_initial_view)

    a_r_destination = a_lds2reg_thread_copy.retile(a_r_tile)
    b_r_destination = b_lds2reg_thread_copy.retile(b_r_tile)

    def create_gmem2reg_sources(a_block_view, b_block_view):
        return (
            a_thread_staging_copy.partition_S(a_block_view),
            b_thread_staging_copy.partition_S(b_block_view),
        )

    def gmem2reg_load_tile(tile_k):
        a_block_view = fx.slice(a_tiled_view, (None, None, block_row, tile_k))
        b_block_view = fx.slice(b_tiled_view, (None, None, tile_k, block_col))
        a_global_source, b_global_source = create_gmem2reg_sources(
            a_block_view, b_block_view
        )
        fx.copy(gmem_load_128b, a_global_source, a_staging_fragment)
        fx.copy(gmem_load_128b, b_global_source, b_staging_fragment)

    def reg2lds_copy_tile():
        fx.copy(copy_128b, a_staging_fragment, a_lds_destination)
        fx.copy(copy_128b, b_staging_fragment, b_lds_destination)
        fx.barrier()

    def compute_lds():
        for inner_k in fx.range_constexpr(BLOCK_K // MMA_K):
            a_mma_view = fx.slice(a_lds_tiled, (None, None, 0, inner_k))
            b_mma_view = fx.slice(
                b_lds_transposed_tiled, (None, None, 0, inner_k)
            )
            a_r_source = a_lds2reg_thread_copy.partition_S(a_mma_view)
            b_r_source = b_lds2reg_thread_copy.partition_S(b_mma_view)
            fx.copy(copy_16b, a_r_source, a_r_destination)
            fx.copy(copy_16b, b_r_source, b_r_destination)
            fx.gemm(mma_atom, c_accum, a_r_tile, b_r_tile, c_accum)

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
    c_registers = fx.make_rmem_tensor(c_accum.layout, fx.BFloat16)
    for slot in fx.range_constexpr(ACCUMULATOR_VALUES):
        c_registers[slot] = c_accum[slot].to(fx.BFloat16)
    # Replace stage 04's one-thread output plan with the collective C plan.
    gmem_store_16b = fx.make_copy_atom(fx.rocdl.BufferCopy16b(), fx.BFloat16)
    reg2gmem_copy_plan = fx.make_tiled_copy_C(gmem_store_16b, mma)
    reg2gmem_thread_copy = reg2gmem_copy_plan.get_slice(fx.thread_idx.x)
    reg2gmem_source = reg2gmem_thread_copy.retile(c_registers)
    reg2gmem_dest = reg2gmem_thread_copy.partition_D(c_block_view)
    fx.copy(gmem_store_16b, reg2gmem_source, reg2gmem_dest)


@flyc.jit
def _launch_matmul_bf16(
    a: fx.Tensor,
    b: fx.Tensor,
    c: fx.Tensor,
    m: fx.Constexpr,
    n: fx.Constexpr,
    k: fx.Constexpr,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
):
    _matmul_bf16(a, b, c, m, n, k).launch(
        grid=(n // BLOCK_N, m // BLOCK_M, 1),
        block=(THREADS_PER_BLOCK, 1, 1),
        stream=stream,
    )


def matmul_bf16(input, other, *, out=None, stream=None):
    """Multiply complete BF16 matrix tiles with this lesson's kernel."""
    a = input
    b = other
    c = out
    tensors = [("input", a), ("other", b)]
    if c is not None:
        tensors.append(("out", c))
    for name, tensor in tensors:
        if type(tensor) not in (torch.Tensor, torch.nn.Parameter):
            raise TypeError(
                f"{name} must be a torch.Tensor; custom tensor subclasses are unsupported"
            )
    if torch._C._are_functorch_transforms_active():
        raise RuntimeError("matmul_bf16 does not support vmap or tensor transforms")
    if torch.autograd.forward_ad._current_level >= 0:
        raise RuntimeError("matmul_bf16 does not support forward-mode autograd")
    if torch.is_autocast_enabled("cuda"):
        raise RuntimeError(
            "matmul_bf16 requires explicit BF16 inputs; disable autocast"
        )
    for name, tensor in tensors:
        if tensor.dtype != torch.bfloat16:
            raise TypeError(
                f"{name} must have dtype torch.bfloat16; got {tensor.dtype}"
            )
        if not tensor.is_cuda:
            raise ValueError(f"{name} must be on a ROCm GPU")
        if tensor.device != a.device:
            raise ValueError(f"{name} must be on the same device as input")
        if tensor.layout != torch.strided or not tensor.is_contiguous():
            raise ValueError(f"{name} must be contiguous and row-major")
        if tensor.is_neg():
            raise ValueError(
                f"{name} must not be a negative view; call resolve_neg() first"
            )
        if torch.is_grad_enabled() and tensor.requires_grad:
            raise RuntimeError(
                f"{name} requires gradients; matmul_bf16 has no autograd support, use torch.no_grad()"
            )
    if a.ndim != 2 or b.ndim != 2:
        raise ValueError("input and other must be two-dimensional matrices")
    if a.shape[1] != b.shape[0]:
        raise ValueError(
            f"K dimensions must match; got {a.shape[1]} and {b.shape[0]}"
        )
    if a.data_ptr() % 16 or b.data_ptr() % 16:
        raise ValueError("input and other must have 16-byte aligned data pointers")
    if torch.version.hip is None:
        raise RuntimeError("matmul_bf16 requires ROCm")
    arch = torch.cuda.get_device_properties(a.device).gcnArchName.split(":")[0]
    if arch not in ("gfx1151", "gfx1152"):
        raise RuntimeError(f"matmul_bf16 requires gfx1151/gfx1152; detected {arch}")
    shape = (a.shape[0], b.shape[1], a.shape[1])
    if (
        min(shape) <= 0
        or shape[0] % BLOCK_M
        or shape[1] % BLOCK_N
        or shape[2] % BLOCK_K
    ):
        raise ValueError("M,N,K must contain complete positive block tiles")
    if c is not None:
        if c.shape != (shape[0], shape[1]):
            raise ValueError(
                f"out must have shape {(shape[0], shape[1])}; got {tuple(c.shape)}"
            )
        start = c.data_ptr()
        stop = start + c.numel() * c.element_size()
        for name, tensor in tensors[:2]:
            if (
                start < tensor.data_ptr() + tensor.numel() * tensor.element_size()
                and tensor.data_ptr() < stop
            ):
                raise ValueError(f"out must not overlap {name}")
    if stream is not None and stream.device != a.device:
        raise ValueError("Stream and inputs must use the same device")
    supplied_out = c is not None
    with torch.cuda.device(a.device), torch.cuda.stream(stream):
        if c is None:
            c = torch.empty(
                (shape[0], shape[1]), dtype=a.dtype, device=a.device
            )
        _launch_matmul_bf16(
            a,
            b,
            c,
            *shape,
            stream=fx.Stream(torch.cuda.current_stream(a.device)),
        )
        if supplied_out:
            torch.autograd.graph.increment_version(c)
    return c


def check_boundaries():
    """Exact stage tags catch an omitted/duplicated prologue, handoff, or drain."""
    checked = []
    for tiles in (1, 2, 3):
        m, n = BLOCK_M, BLOCK_N
        k = BLOCK_K * tiles
        # A's K tiles contain 1,2,4; B contains 1. Expected sums are 64,192,448.
        tags = (2 ** (torch.arange(k, dtype=torch.int32) // BLOCK_K)).to(torch.bfloat16)
        a = tags.expand(m, k).contiguous().cuda()
        b = torch.ones((k, n), dtype=torch.bfloat16, device="cuda")
        storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
        c = storage[: m * n].view(m, n)
        c.fill_(float("nan"))
        matmul_bf16(a, b, out=c)
        torch.cuda.synchronize()
        expected = BLOCK_K * (2**tiles - 1)
        torch.testing.assert_close(
            c.cpu(),
            torch.full((m, n), expected, dtype=torch.bfloat16),
            rtol=0,
            atol=0,
        )
        assert torch.all(storage[m * n :] == -99).item(), "Boundary sentinel changed"
        checked.append({"K_tiles": tiles, "expected": expected})
    return checked


def solve():
    architecture = torch.cuda.get_device_properties(0).gcnArchName.split(":")[0]
    if architecture not in ("gfx1151", "gfx1152"):
        raise RuntimeError(
            f"This lesson supports gfx1151/gfx1152; detected {architecture}"
        )
    boundaries = check_boundaries()
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
            a, b = a_cpu.cuda(), b_cpu.cuda()
            storage = torch.full(
                (m * n + 16,), -99, dtype=torch.bfloat16, device="cuda"
            )
            c = storage[: m * n].view(m, n)
            c.fill_(float("nan"))
            matmul_bf16(a, b, out=c)
            torch.cuda.synchronize()
            # CPU FP32 arithmetic on the actual quantized BF16 inputs is independent
            # of the GPU kernel. Round the reference to the same output dtype.
            expected = (a_cpu.float() @ b_cpu.float()).to(torch.bfloat16)
            torch.testing.assert_close(
                c.cpu(),
                expected,
                rtol=0 if pattern == "trace" else 0.016,
                atol=0.001 if pattern == "trace" else 0.03125,
            )
            assert torch.all(storage[m * n :] == -99).item(), "Output sentinel changed"
            if (m, n, k) == (1024, 1024, 1024) and pattern == "trace":
                checkpoint = c[0, :4].cpu().tolist()
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
        matmul_bf16,
        solve,
        Path(__file__).parent.name,
        check_only=globals().get("_COURSE_CHECK_ONLY", False),
    )
