"""Solution: Trace nested coordinates.

Run from the repository root:
    pixi run python lessons/00-layout-algebra/02-nested-layouts/solution.py
Layout algebra is traced by FlyDSL; thread-dependent mappings run on the GPU.
"""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def _nested_offsets(out: fx.Tensor):
    thread_id = fx.thread_idx.x
    data_layout = fx.make_layout(((2, 2), 3), ((1, 4), 8))
    thread_layout = fx.make_ordered_layout(fx.get_shape(data_layout), ((0, 1), 2))
    # Compute: Count all positions, expand thread_id with its hierarchy, and map it.
    logical_size = fx.size(data_layout)
    coordinate = fx.idx2crd(thread_id, thread_layout)
    memory_offset = fx.crd2idx(coordinate, data_layout)
    out[thread_id * 6] = fx.get_scalar(logical_size)
    out[thread_id * 6 + 1] = fx.get_scalar(coordinate[0][0])
    out[thread_id * 6 + 2] = fx.get_scalar(coordinate[0][1])
    out[thread_id * 6 + 3] = fx.get_scalar(coordinate[1])
    out[thread_id * 6 + 4] = fx.get_scalar(memory_offset)
    out[thread_id * 6 + 5] = fx.get_scalar(fx.crd2idx(thread_id, data_layout))


@flyc.jit
def _launch_nested_offsets(
    out: fx.Tensor,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
):
    _nested_offsets(out).launch(grid=(1, 1, 1), block=(12, 1, 1), stream=stream)


def nested_offsets(*, out=None, device="cuda", stream=None):
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
            out = torch.empty((72,), dtype=torch.int32, device=device)
        if (
            out.dtype != torch.int32
            or tuple(out.shape) != (72,)
            or not out.is_contiguous()
        ):
            raise ValueError("out must be a contiguous int32 tensor of shape (72,)")
        _launch_nested_offsets(out, stream=fx.Stream(torch.cuda.current_stream(device)))
    if supplied_out:
        torch.autograd.graph.increment_version(out)
    return out


def solve():
    """Launch the exercise, check every GPU result, and return the lesson checkpoint."""
    out = torch.full((72,), -1, dtype=torch.int32, device="cuda")
    nested_offsets(out=out)
    torch.cuda.synchronize()
    rows = out.cpu().reshape(12, 6).tolist()
    # Host code only checks and formats results; it does not implement layouts.
    expected_offsets = [0, 1, 4, 5, 8, 9, 12, 13, 16, 17, 20, 21]
    expected = [
        [12, thread_id % 2, (thread_id // 2) % 2, thread_id // 4, offset, offset]
        for thread_id, offset in enumerate(expected_offsets)
    ]
    assert rows == expected, rows
    count, a, b, c, offset, _direct = rows[7]
    return count, ((a, b), c), offset


if __name__ == "__main__":
    try:
        actual = solve()
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error} See README.md.") from None
    expected = (12, ((1, 1), 1), 13)
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
