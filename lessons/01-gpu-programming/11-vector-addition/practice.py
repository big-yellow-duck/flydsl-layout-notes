"""Bounds-safe native FlyDSL indexing with coordinate views."""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch
from flydsl._mlir import ir
from flydsl._mlir.dialects import scf


@flyc.kernel
def _vector_add(left: fx.Tensor, right: fx.Tensor, out: fx.Tensor, count: fx.Constexpr):
    padded_count = ((count + 7) // 8) * 8
    # 1. Reuse left/right/out as memory views. Build a separate index-only view.
    coordinate_layout = fx.make_layout(padded_count, 1)
    index_origin = fx.make_int_tuple(0)
    coordinates = fx.make_view(index_origin, coordinate_layout)
    # 2. Expose coordinate windows and select this block's window.
    block_id = fx.block_idx.x
    coordinate_tiles = fx.logical_divide(coordinates, fx.make_layout(8, 1))
    block_coordinates = fx.slice(coordinate_tiles, (None, block_id))
    # 3. Assign two local positions to each thread.
    thread_id = fx.thread_idx.x
    ownership = fx.make_layout((4, 2), (2, 1))
    for value_id in range(2):
        local_index = fx.crd2idx(fx.make_coord(thread_id, value_id), ownership)
        global_index = fx.get_scalar(block_coordinates[local_index])
        # 4. Check bounds before touching either input or the output.
        valid = global_index < count
        # Python if cannot branch on a runtime GPU value in this tracing API.
        branch = scf.IfOp(valid.ir_value(), [], has_else=False)
        with ir.InsertionPoint(branch.then_block):
            # 5. Load, compute, and store only this valid position.
            # TODO 1: Fill in result; see README.md.
            result = None
            if result is None:
                raise NotImplementedError("Fill in result.")
            out[global_index] = result
            scf.yield_([])


@flyc.jit
def _launch_vector_add(
    left: fx.Tensor,
    right: fx.Tensor,
    out: fx.Tensor,
    count: fx.Constexpr,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
):
    _vector_add(left, right, out, count).launch(
        grid=((count + 7) // 8, 1, 1), block=(4, 1, 1), stream=stream
    )


def vector_add(left, right, *, out=None, stream=None):
    """Validate inputs, allocate output if needed, and launch this lesson's kernel."""
    for name, tensor in (
        ("left", left),
        ("right", right),
    ):
        if not isinstance(tensor, torch.Tensor) or tensor.dtype != torch.float32:
            raise TypeError(f"{name} must be a torch.float32 tensor")
        if not tensor.is_cuda or tensor.ndim != 1 or not tensor.is_contiguous():
            raise ValueError(f"{name} must be a contiguous 1-D tensor on a ROCm GPU")
        if tensor.device != left.device:
            raise ValueError("Inputs must use the same device")
        if tensor.is_neg() or (torch.is_grad_enabled() and tensor.requires_grad):
            raise ValueError(f"{name} must be materialized and used without autograd")
    if left.shape != right.shape:
        raise ValueError("Input shapes must match")
    if left.numel() == 0:
        raise ValueError("Input must not be empty")
    if out is not None:
        if not isinstance(out, torch.Tensor) or out.dtype != torch.float32:
            raise TypeError("out has the wrong tensor type or dtype")
        if (
            out.device != left.device
            or out.shape != left.shape
            or not out.is_contiguous()
        ):
            raise ValueError(
                "out must be contiguous with the expected shape on the input device"
            )
        if out.is_neg() or (torch.is_grad_enabled() and out.requires_grad):
            raise ValueError("out must be materialized and used without autograd")
    if torch.version.hip is None:
        raise RuntimeError("This lesson requires ROCm")
    supplied_out = out is not None
    with torch.cuda.device(left.device), torch.cuda.stream(stream):
        if out is None:
            out = torch.empty(left.shape, dtype=left.dtype, device=left.device)
        _launch_vector_add(
            left,
            right,
            out,
            left.numel(),
            stream=fx.Stream(torch.cuda.current_stream(left.device)),
        )
    if supplied_out:
        torch.autograd.graph.increment_version(out)
    return out


def solve():
    for count in [1, 7, 8, 9, 19, 32, 257, 4099]:
        left = torch.arange(count, dtype=torch.float32, device="cuda") * 0.25
        right = torch.arange(count, dtype=torch.float32, device="cuda") * -0.5 + 3
        # Inputs are exact-sized. Extra output storage checks for stray writes.
        out = torch.full((count + 8,), -999.0, dtype=torch.float32, device="cuda")
        vector_add(left, right, out=out[:count])
        torch.cuda.synchronize()
        torch.testing.assert_close(out[:count], left + right)
        assert torch.all(out[count:] == -999).item(), "Wrote beyond the logical output"
    return "passed sizes " + str([1, 7, 8, 9, 19, 32, 257, 4099])


if __name__ == "__main__":
    try:
        print("Exercise passed:", solve())
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None
