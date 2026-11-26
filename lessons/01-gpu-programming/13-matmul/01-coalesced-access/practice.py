"""BF16 matmul: 01-coalesced-access. See README.md for the exercise."""

import runpy
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch

RIGHT_LAYOUT = "column-major"


@flyc.kernel
def _matmul_bf16(
    a: fx.Tensor,
    b: fx.Tensor,
    c: fx.Tensor,
    m: fx.Constexpr,
    n: fx.Constexpr,
    k: fx.Constexpr,
):
    # 1. A/C are row-major; B is physically column-major with logical shape (K,N).
    a_global_view = fx.make_view(fx.get_iter(a), fx.make_layout((m, k), (k, 1)))
    b_global_view = fx.make_view(fx.get_iter(b), fx.make_layout((k, n), (1, k)))
    c_global_view = fx.make_view(fx.get_iter(c), fx.make_layout((m, n), (n, 1)))
    block_row = fx.block_idx.y
    block_col = fx.block_idx.x
    # 2. Select this block's full-K input windows and 16 x 16 output window.
    a_tiled_view = fx.flat_divide(a_global_view, (16, k))
    b_tiled_view = fx.flat_divide(b_global_view, (k, 16))
    c_tiled_view = fx.flat_divide(c_global_view, (16, 16))
    a_block_view = fx.slice(a_tiled_view, (None, None, block_row, 0))
    b_block_view = fx.slice(b_tiled_view, (None, None, 0, block_col))
    c_block_view = fx.slice(c_tiled_view, (None, None, block_row, block_col))
    # 3. Keep one output per thread; both selected inputs are contiguous along K.
    # TODO 1: Fill in thread_layout; see README.md.
    thread_layout = None
    if thread_layout is None:
        raise NotImplementedError("Fill in thread_layout.")
    # TODO 2: Fill in thread_coordinate; see README.md.
    thread_coordinate = None
    if thread_coordinate is None:
        raise NotImplementedError("Fill in thread_coordinate.")
    a_row = fx.slice(a_block_view, (thread_coordinate[0], None))
    b_column = fx.slice(b_block_view, (None, thread_coordinate[1]))
    # 4. Widen scalar loads before multiplying; retain FP32 across all K.
    c_accum = fx.Float32(0)
    for inner in range(k):
        a_value = fx.Float32(a_row[inner])
        b_value = fx.Float32(b_column[inner])
        c_accum = c_accum + a_value * b_value
    c_block_view[thread_coordinate] = c_accum.to(fx.BFloat16)


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
        grid=(n // 16, m // 16, 1), block=(256, 1, 1), stream=stream
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
        if name == "other":
            if (
                tensor.ndim != 2
                or tensor.layout != torch.strided
                or tensor.stride() != (1, tensor.shape[0])
            ):
                raise ValueError(
                    "other must store B columns contiguously, with stride (1, K)"
                )
        elif tensor.layout != torch.strided or not tensor.is_contiguous():
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
    shape = (a.shape[0], b.shape[1], a.shape[1])
    if min(shape) <= 0 or shape[0] % 16 or shape[1] % 16:
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
            a = a_cpu.cuda()
            # Pack B's columns before launching. Logical values and shape stay (K,N).
            b = b_cpu.cuda().t().contiguous().t()
            assert b.shape == (k, n) and b.stride() == (1, k)
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
    return {"shapes_MNK": shapes, "patterns": 2, "first_four": checkpoint}


if __name__ == "__main__":
    benchmark = runpy.run_path(
        str(Path(__file__).resolve().parents[4] / "examples/matmul_benchmark.py")
    )
    benchmark["lesson_main"](
        matmul_bf16,
        solve,
        Path(__file__).parent.name,
        check_only=globals().get("_COURSE_CHECK_ONLY", False),
        right_layout=RIGHT_LAYOUT,
    )
