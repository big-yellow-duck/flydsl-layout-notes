"""Native GPU lesson: 09-register-fragments. See README.md for the exercise."""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def _add_fragments(left: fx.Tensor, right: fx.Tensor, out: fx.Tensor):
    # 1. Each input is one complete tile: attach the tile's indexing to its storage.
    tile_layout = fx.make_layout((2, 4), (1, 2))
    left_tile = fx.make_view(fx.get_iter(left), tile_layout)
    right_tile = fx.make_view(fx.get_iter(right), tile_layout)
    destination_tile = fx.make_view(fx.get_iter(out), tile_layout)

    # 2. Assign two adjacent values to each of four threads.
    thread_layout = fx.make_layout((1, 4), (4, 1))
    value_layout = fx.make_layout((2, 1), (1, 2))
    tile_shape, thread_value_layout = fx.make_layout_tv(thread_layout, value_layout)
    atom = fx.make_copy_atom(fx.UniversalCopy32b(), fx.Float32)
    plan = fx.make_tiled_copy(atom, thread_value_layout, tile_shape)

    # 3. Select this thread's source and destination views.
    thread_id = fx.thread_idx.x
    thread_copy = plan.get_slice(thread_id)
    left_part = thread_copy.partition_S(left_tile)
    right_part = thread_copy.partition_S(right_tile)
    destination_part = thread_copy.partition_D(destination_tile)

    # 4. Allocate per-thread storage, then load both inputs into it.
    left_registers = fx.make_fragment_like(left_part)
    right_registers = fx.make_fragment_like(right_part)
    fx.copy(atom, left_part, left_registers)
    fx.copy(atom, right_part, right_registers)
    # 5. Compute on the loaded values, then store the result.
    for value_id in range(2):
        # TODO 1: Fill in result; see README.md.
        result = None
        if result is None:
            raise NotImplementedError("Fill in result.")
        left_registers[value_id] = result
    fx.copy(atom, left_registers, destination_part)


@flyc.jit
def _launch_add_fragments(
    left: fx.Tensor,
    right: fx.Tensor,
    out: fx.Tensor,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
):
    _add_fragments(left, right, out).launch(
        grid=(1, 1, 1), block=(4, 1, 1), stream=stream
    )


def add_fragments(left, right, *, out=None, stream=None):
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
    if tuple(left.shape) != (8,):
        raise ValueError("Input shape must be (8,)")
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
        _launch_add_fragments(
            left, right, out, stream=fx.Stream(torch.cuda.current_stream(left.device))
        )
    if supplied_out:
        torch.autograd.graph.increment_version(out)
    return out


def solve():
    left = torch.arange(8, dtype=torch.float32, device="cuda")
    right = left * 2 + 10
    out = torch.full_like(left, -1)
    add_fragments(left, right, out=out)
    torch.cuda.synchronize()
    torch.testing.assert_close(out, left + right)
    return out.cpu().tolist()


if __name__ == "__main__":
    try:
        print("Exercise passed:", solve())
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None
