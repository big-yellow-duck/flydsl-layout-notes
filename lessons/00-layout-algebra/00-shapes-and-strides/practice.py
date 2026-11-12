# ruff: noqa: F841 -- Inputs become used when TODOs are filled.
"""Practice: Measure a padded layout.

Run from the repository root:
    pixi run python lessons/00-layout-algebra/00-shapes-and-strides/practice.py
Layout algebra is traced by FlyDSL; thread-dependent mappings run on the GPU.
"""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def _shape_stride_offsets(out: fx.Tensor):
    thread_id = fx.thread_idx.x
    data_layout = fx.make_layout((3, 4), (5, 1))
    # Each GPU thread visits one explicit coordinate, first mode fastest.
    thread_layout = fx.make_ordered_layout((3, 4), (0, 1))
    coordinate = fx.idx2crd(thread_id, thread_layout)
    # Compute: Map the coordinate, count logical positions, and measure the span.
    # TODO 1: Fill in element_offset; see README.md.
    element_offset = None
    if element_offset is None:
        raise NotImplementedError("Fill in element_offset.")
    # TODO 2: Fill in logical_size; see README.md.
    logical_size = None
    if logical_size is None:
        raise NotImplementedError("Fill in logical_size.")
    # TODO 3: Fill in storage_span; see README.md.
    storage_span = None
    if storage_span is None:
        raise NotImplementedError("Fill in storage_span.")
    out[thread_id * 3] = fx.get_scalar(element_offset)
    out[thread_id * 3 + 1] = fx.get_scalar(logical_size)
    out[thread_id * 3 + 2] = fx.get_scalar(storage_span)


@flyc.jit
def _launch_shape_stride_offsets(
    out: fx.Tensor,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
):
    _shape_stride_offsets(out).launch(grid=(1, 1, 1), block=(12, 1, 1), stream=stream)


def shape_stride_offsets(*, out=None, device="cuda", stream=None):
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
            out = torch.empty((36,), dtype=torch.int32, device=device)
        if (
            out.dtype != torch.int32
            or tuple(out.shape) != (36,)
            or not out.is_contiguous()
        ):
            raise ValueError("out must be a contiguous int32 tensor of shape (36,)")
        _launch_shape_stride_offsets(
            out, stream=fx.Stream(torch.cuda.current_stream(device))
        )
    if supplied_out:
        torch.autograd.graph.increment_version(out)
    return out


def solve():
    """Launch the exercise, check every GPU result, and return the lesson checkpoint."""
    out = torch.full((36,), -1, dtype=torch.int32, device="cuda")
    shape_stride_offsets(out=out)
    torch.cuda.synchronize()
    rows = out.cpu().reshape(12, 3).tolist()
    # Host code only checks and formats results; it does not implement layouts.
    expected_offsets = [0, 5, 10, 1, 6, 11, 2, 7, 12, 3, 8, 13]
    assert rows == [[offset, 12, 14] for offset in expected_offsets], rows
    return tuple(rows[11])  # Coordinate (2, 3).


if __name__ == "__main__":
    try:
        actual = solve()
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error} See README.md.") from None
    expected = (13, 12, 14)
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
