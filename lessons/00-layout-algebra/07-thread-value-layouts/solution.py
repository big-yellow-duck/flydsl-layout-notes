"""Native GPU lesson: 07-thread-value-layouts. See README.md for the exercise."""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def _thread_value_offsets(out: fx.Tensor):
    thread_id = fx.thread_idx.x
    # A coordinate is (thread_id, value_id); each of four threads owns two values.
    # TODO: Build adjacent and interleaved ownership layouts.
    adjacent = fx.make_layout((4, 2), (2, 1))
    interleaved = fx.make_layout((4, 2), (1, 4))
    for value_id in range(2):
        coordinate = fx.make_coord(thread_id, value_id)
        out[thread_id * 4 + value_id] = fx.get_scalar(fx.crd2idx(coordinate, adjacent))
        out[thread_id * 4 + 2 + value_id] = fx.get_scalar(
            fx.crd2idx(coordinate, interleaved)
        )


@flyc.jit
def _launch_thread_value_offsets(
    out: fx.Tensor,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
):
    _thread_value_offsets(out).launch(grid=(1, 1, 1), block=(4, 1, 1), stream=stream)


def thread_value_offsets(*, out=None, device="cuda", stream=None):
    """Evaluate this lesson's complete coordinate domain on the GPU."""
    if out is not None:
        if not isinstance(out, torch.Tensor):
            raise TypeError("out must be a torch.Tensor")
        device = out.device
    device = torch.device(device)
    if device.type != "cuda":
        raise ValueError("device must be a ROCm GPU")
    if torch.version.hip is None:
        raise RuntimeError("This lesson requires ROCm")
    supplied_out = out is not None
    with torch.cuda.device(device), torch.cuda.stream(stream):
        if out is None:
            out = torch.empty((16,), dtype=torch.int32, device=device)
        if (
            out.dtype != torch.int32
            or tuple(out.shape) != (16,)
            or not out.is_contiguous()
        ):
            raise ValueError("out must be a contiguous int32 tensor of shape (16,)")
        _launch_thread_value_offsets(
            out, stream=fx.Stream(torch.cuda.current_stream(device))
        )
    if supplied_out:
        torch.autograd.graph.increment_version(out)
    return out


def solve():
    out = torch.full((16,), -1, dtype=torch.int32, device="cuda")
    thread_value_offsets(out=out)
    torch.cuda.synchronize()
    rows = out.cpu().reshape(4, 4).tolist()
    assert rows == [[0, 1, 0, 4], [2, 3, 1, 5], [4, 5, 2, 6], [6, 7, 3, 7]], rows
    return rows


if __name__ == "__main__":
    try:
        print("Exercise passed:", solve())
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None
