"""Solution: Separate scalar coordinates from offsets.

Run from the repository root:
    pixi run python lessons/00-layout-algebra/01-coordinates-and-views/solution.py
Layout algebra is traced by FlyDSL; thread-dependent mappings run on the GPU.
"""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def _coordinate_offsets(out: fx.Tensor):
    thread_id = fx.thread_idx.x
    data_layout = fx.make_layout((2, 4), (4, 1))
    # Ordered compact strides enumerate the first mode fastest: (1, 2).
    thread_layout = fx.make_ordered_layout(fx.get_shape(data_layout), (0, 1))
    # Compute: Decode the thread ID through thread_layout, then apply the data layout.
    coordinate = fx.idx2crd(thread_id, thread_layout)
    memory_offset = fx.crd2idx(coordinate, data_layout)
    out[thread_id * 4] = fx.get_scalar(coordinate[0])
    out[thread_id * 4 + 1] = fx.get_scalar(coordinate[1])
    out[thread_id * 4 + 2] = fx.get_scalar(memory_offset)
    # Native scalar mapping must agree with the two explicit steps.
    out[thread_id * 4 + 3] = fx.get_scalar(fx.crd2idx(thread_id, data_layout))


@flyc.jit
def _launch_coordinate_offsets(
    out: fx.Tensor,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
):
    _coordinate_offsets(out).launch(grid=(1, 1, 1), block=(8, 1, 1), stream=stream)


def coordinate_offsets(*, out=None, device="cuda", stream=None):
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
            out = torch.empty((32,), dtype=torch.int32, device=device)
        if (
            out.dtype != torch.int32
            or tuple(out.shape) != (32,)
            or not out.is_contiguous()
        ):
            raise ValueError("out must be a contiguous int32 tensor of shape (32,)")
        _launch_coordinate_offsets(
            out, stream=fx.Stream(torch.cuda.current_stream(device))
        )
    if supplied_out:
        torch.autograd.graph.increment_version(out)
    return out


def solve():
    """Launch the exercise, check every GPU result, and return the lesson checkpoint."""
    out = torch.full((32,), -1, dtype=torch.int32, device="cuda")
    coordinate_offsets(out=out)
    torch.cuda.synchronize()
    rows = out.cpu().reshape(8, 4).tolist()
    # Host code only checks and formats results; it does not implement layouts.
    expected = [
        [0, 0, 0, 0],
        [1, 0, 4, 4],
        [0, 1, 1, 1],
        [1, 1, 5, 5],
        [0, 2, 2, 2],
        [1, 2, 6, 6],
        [0, 3, 3, 3],
        [1, 3, 7, 7],
    ]
    assert rows == expected, rows
    return [((r, c), offset) for r, c, offset, direct in rows]


if __name__ == "__main__":
    try:
        actual = solve()
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error} See README.md.") from None
    expected = [
        ((0, 0), 0),
        ((1, 0), 4),
        ((0, 1), 1),
        ((1, 1), 5),
        ((0, 2), 2),
        ((1, 2), 6),
        ((0, 3), 3),
        ((1, 3), 7),
    ]
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
