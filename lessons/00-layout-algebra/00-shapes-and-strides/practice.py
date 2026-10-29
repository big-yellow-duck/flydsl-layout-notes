# ruff: noqa: F841 -- Supplied inputs are used when the learner fills the TODOs.
"""Practice: Measure a padded layout.

Run from the repository root:
    pixi run python lessons/00-layout-algebra/00-shapes-and-strides/practice.py
Layout algebra is traced by FlyDSL; thread-dependent mappings run on the GPU.
"""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def exercise_kernel(out: fx.Tensor):
    q = fx.thread_idx.x
    data_layout = fx.make_layout((3, 4), (5, 1))
    # Each GPU thread visits one explicit coordinate, first mode fastest.
    thread_layout = fx.make_ordered_layout((3,4), (0,1))
    coordinate  = fx.idx2crd(q, thread_layout)
    # TASK: Map the coordinate, count logical positions, and measure the span.
    # TODO 1: Fill in element_offset using the native API described in README.md.
    element_offset = None
    element_offset = fx.crd2idx(coordinate, data_layout)
    if element_offset is None:
        raise NotImplementedError("Fill in element_offset in exercise_kernel().")
    # TODO 2: Fill in logical_size using the native API described in README.md.
    logical_size = None
    logical_size = fx.size(data_layout)
    if logical_size is None:
        raise NotImplementedError("Fill in logical_size in exercise_kernel().")
    # TODO 3: Fill in storage_span using the native API described in README.md.
    storage_span = None
    storage_span = fx.cosize(data_layout)
    if storage_span is None:
        raise NotImplementedError("Fill in storage_span in exercise_kernel().")
    out[q * 3] = fx.get_scalar(element_offset)
    out[q * 3 + 1] = fx.get_scalar(logical_size)
    out[q * 3 + 2] = fx.get_scalar(storage_span)


@flyc.jit
def run(out: fx.Tensor, stream: fx.Stream = fx.Stream(None)):  # noqa: B008 -- FlyDSL stream default
    # Exactly 12 threads: every thread owns one output row; no tail mask needed.
    exercise_kernel(out).launch(grid=(1, 1, 1), block=(12, 1, 1), stream=stream)


def solve():
    """Launch the exercise, check every GPU result, and return the lesson checkpoint."""
    out = torch.full((36,), -1, dtype=torch.int32, device="cuda")
    run(out)
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
