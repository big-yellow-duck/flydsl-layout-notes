# ruff: noqa: F841, RUF059 -- Inputs become used when TODOs are filled.
"""Native GPU lesson: 08-tiled-copy. See README.md for the exercise."""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def _copy_tile(source: fx.Tensor, out: fx.Tensor):
    # 1. Each input is one complete tile: attach the tile's indexing to its storage.
    tile_layout = fx.make_layout((2, 4), (1, 2))
    source_tile = fx.make_view(fx.get_iter(source), tile_layout)
    destination_tile = fx.make_view(fx.get_iter(out), tile_layout)

    # 2. Assign two adjacent values to each of four threads.
    thread_layout = fx.make_layout((1, 4), (4, 1))
    value_layout = fx.make_layout((2, 1), (1, 2))
    tile_shape, thread_value_layout = fx.make_layout_tv(thread_layout, value_layout)
    atom = fx.make_copy_atom(fx.UniversalCopy32b(), fx.Float32)
    # TODO 1: Fill in plan; see README.md.
    plan = None
    if plan is None:
        raise NotImplementedError("Fill in plan.")

    # 3. Select this thread's source and destination views.
    thread_id = fx.thread_idx.x
    # TODO 2: Fill in thread_copy; see README.md.
    thread_copy = None
    if thread_copy is None:
        raise NotImplementedError("Fill in thread_copy.")
    source_part = thread_copy.partition_S(source_tile)
    destination_part = thread_copy.partition_D(destination_tile)

    # 4. Move the values. None of the setup above reads or writes them.
    fx.copy(atom, source_part, destination_part)


@flyc.jit
def _launch_copy_tile(
    source: fx.Tensor,
    out: fx.Tensor,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
):
    _copy_tile(source, out).launch(grid=(1, 1, 1), block=(4, 1, 1), stream=stream)


def copy_tile(source, *, out=None, stream=None):
    """Validate inputs, allocate output if needed, and launch this lesson's kernel."""
    for name, tensor in (("source", source),):
        if not isinstance(tensor, torch.Tensor) or tensor.dtype != torch.float32:
            raise TypeError(f"{name} must be a torch.float32 tensor")
        if not tensor.is_cuda or tensor.ndim != 1 or not tensor.is_contiguous():
            raise ValueError(f"{name} must be a contiguous 1-D tensor on a ROCm GPU")
        if tensor.device != source.device:
            raise ValueError("Inputs must use the same device")
        if tensor.is_neg() or (torch.is_grad_enabled() and tensor.requires_grad):
            raise ValueError(f"{name} must be materialized and used without autograd")
    if tuple(source.shape) != (8,):
        raise ValueError("Input shape must be (8,)")
    if out is not None:
        if not isinstance(out, torch.Tensor) or out.dtype != torch.float32:
            raise TypeError("out has the wrong tensor type or dtype")
        if (
            out.device != source.device
            or out.shape != source.shape
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
    with torch.cuda.device(source.device), torch.cuda.stream(stream):
        if out is None:
            out = torch.empty(source.shape, dtype=source.dtype, device=source.device)
        _launch_copy_tile(
            source, out, stream=fx.Stream(torch.cuda.current_stream(source.device))
        )
    if supplied_out:
        torch.autograd.graph.increment_version(out)
    return out


def solve():
    source = torch.arange(8, dtype=torch.float32, device="cuda") * 3 + 7
    out = torch.full_like(source, -1)
    copy_tile(source, out=out)
    torch.cuda.synchronize()
    torch.testing.assert_close(out, source)
    return out.cpu().tolist()


if __name__ == "__main__":
    try:
        print("Exercise passed:", solve())
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None
