"""Native GPU lesson: 06-select-block-tile. See README.md for the exercise."""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def _copy_block_tiles(source: fx.Tensor, out: fx.Tensor):
    # 1. Reuse the incoming 1-D tensor views: they already have the right layout.
    block_id = fx.block_idx.x
    tile_layout = fx.make_layout(8, 1)
    # 2. Expose source and destination windows, then select this block's tiles.
    source_windows = fx.logical_divide(source, tile_layout)
    destination_windows = fx.logical_divide(out, tile_layout)
    source_tile = fx.slice(source_windows, (None, block_id))
    destination_tile = fx.slice(destination_windows, (None, block_id))

    # 3. Assign the eight local positions to eight threads.
    thread_id = fx.thread_idx.x
    thread_layout = fx.make_ordered_layout(8, 0)
    local_coordinate = fx.idx2crd(thread_id, thread_layout)
    # 4. Load and store through the selected views; their bases are already set.
    destination_tile[local_coordinate] = source_tile[local_coordinate]


@flyc.jit
def _launch_copy_block_tiles(
    source: fx.Tensor,
    out: fx.Tensor,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
):
    _copy_block_tiles(source, out).launch(
        grid=(4, 1, 1), block=(8, 1, 1), stream=stream
    )


def copy_block_tiles(source, *, out=None, stream=None):
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
    if tuple(source.shape) != (32,):
        raise ValueError("Input shape must be (32,)")
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
        _launch_copy_block_tiles(
            source, out, stream=fx.Stream(torch.cuda.current_stream(source.device))
        )
    if supplied_out:
        torch.autograd.graph.increment_version(out)
    return out


def solve():
    source = torch.arange(32, dtype=torch.float32, device="cuda") + 100
    out = torch.full_like(source, -1)
    copy_block_tiles(source, out=out)
    torch.cuda.synchronize()
    torch.testing.assert_close(out, source)
    return out[16:24].cpu().tolist()


if __name__ == "__main__":
    try:
        print("Exercise passed:", solve())
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None
