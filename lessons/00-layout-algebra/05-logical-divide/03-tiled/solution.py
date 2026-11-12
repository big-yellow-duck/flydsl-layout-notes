"""tiled_divide: view a matrix, divide it, select a tile, and read it."""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def _copy_tile(source: fx.Tensor, out: fx.Tensor):
    # 1. Describe the matrix indexing. This layout contains no data.
    matrix_layout = fx.make_layout((4, 8), (8, 1))
    # 2. Apply that indexing to source's existing GPU storage. No copy occurs.
    matrix = fx.make_view(fx.get_iter(source), matrix_layout)
    # 3. Expose 2-row by 4-column windows.
    windows = fx.tiled_divide(matrix, (2, 4))
    # 4. Select tile row 1, tile column 1.
    tile = fx.slice(windows, (None, 1, 1))

    # Read the selected tile: eight threads, one local position each.
    thread_id = fx.thread_idx.x
    thread_layout = fx.make_ordered_layout((2, 4), (1, 0))
    local_coordinate = fx.idx2crd(thread_id, thread_layout)
    out[thread_id] = tile[local_coordinate]


@flyc.jit
def _launch_copy_tile(
    source: fx.Tensor,
    out: fx.Tensor,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
):
    _copy_tile(source, out).launch(grid=(1, 1, 1), block=(8, 1, 1), stream=stream)


def copy_tile(source, *, out=None, stream=None):
    """Validate inputs, allocate output if needed, and launch this lesson's kernel."""
    for name, tensor in (("source", source),):
        if not isinstance(tensor, torch.Tensor) or tensor.dtype != torch.int32:
            raise TypeError(f"{name} must be a torch.int32 tensor")
        if not tensor.is_cuda or tensor.ndim != 1 or not tensor.is_contiguous():
            raise ValueError(f"{name} must be a contiguous 1-D tensor on a ROCm GPU")
        if tensor.device != source.device:
            raise ValueError("Inputs must use the same device")
        if tensor.is_neg() or (torch.is_grad_enabled() and tensor.requires_grad):
            raise ValueError(f"{name} must be materialized and used without autograd")
    if tuple(source.shape) != (32,):
        raise ValueError("Input shape must be (32,)")
    if out is not None:
        if not isinstance(out, torch.Tensor) or out.dtype != torch.int32:
            raise TypeError("out has the wrong tensor type or dtype")
        if out.device != source.device or out.shape != (8,) or not out.is_contiguous():
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
            out = torch.empty((8,), dtype=source.dtype, device=source.device)
        _launch_copy_tile(
            source, out, stream=fx.Stream(torch.cuda.current_stream(source.device))
        )
    if supplied_out:
        torch.autograd.graph.increment_version(out)
    return out


def solve():
    source = torch.arange(32, dtype=torch.int32, device="cuda") + 100
    out = torch.full((8,), -1, dtype=torch.int32, device="cuda")
    copy_tile(source, out=out)
    torch.cuda.synchronize()
    actual = out.cpu().tolist()
    expected = [120, 121, 122, 123, 128, 129, 130, 131]
    assert actual == expected, (actual, expected)
    return actual


if __name__ == "__main__":
    try:
        print("Exercise passed:", solve())
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None
