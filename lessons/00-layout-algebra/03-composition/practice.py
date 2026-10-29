# ruff: noqa: F841 -- Supplied inputs are used when the learner fills the TODOs.
"""Practice: Compose two layouts.

Run from the repository root:
    pixi run python lessons/00-layout-algebra/03-composition/practice.py
Layout algebra is traced by FlyDSL; thread-dependent mappings run on the GPU.
"""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def exercise_kernel(out: fx.Tensor):
    q = fx.thread_idx.x
    a = fx.make_layout((2, 4), (4, 1))
    b = fx.make_layout((4, 2), (2, 1))
    # Assign threads to B's coordinate domain, first mode fastest.
    thread_layout = fx.make_ordered_layout(fx.get_shape(b), (0, 1))
    coordinate = fx.idx2crd(q, thread_layout)
    # TASK: Build the compiler's composed layout; B runs first.
    # TODO 1: Fill in composed using the native API described in README.md.
    composed = None
    composed = fx.composition(a,b)
    if composed is None:
        raise NotImplementedError("Fill in composed in exercise_kernel().")
    # TODO 2: Fill in intermediate using the native API described in README.md.
    intermediate = None
    intermediate = fx.crd2idx(coordinate, b)
    if intermediate is None:
        raise NotImplementedError("Fill in intermediate in exercise_kernel().")
    # TODO 3: Fill in final_offset using the native API described in README.md.
    final_offset = None
    final_offset = fx.crd2idx(coordinate, composed)
    if final_offset is None:
        raise NotImplementedError("Fill in final_offset in exercise_kernel().")
    out[q * 3] = fx.get_scalar(intermediate)
    out[q * 3 + 1] = fx.get_scalar(final_offset)
    # Compare native composition with explicit two-stage native evaluation.
    out[q * 3 + 2] = fx.get_scalar(fx.crd2idx(intermediate, a))


@flyc.jit
def run(out: fx.Tensor, stream: fx.Stream = fx.Stream(None)):  # noqa: B008 -- FlyDSL stream default
    # Exactly 8 threads: every thread owns one output row; no tail mask needed.
    exercise_kernel(out).launch(grid=(1, 1, 1), block=(8, 1, 1), stream=stream)


def solve():
    """Launch the exercise, check every GPU result, and return the lesson checkpoint."""
    out = torch.full((24,), -1, dtype=torch.int32, device="cuda")
    run(out)
    torch.cuda.synchronize()
    rows = out.cpu().reshape(8, 3).tolist()
    # Host code only checks and formats results; it does not implement layouts.
    intermediates = [0, 2, 4, 6, 1, 3, 5, 7]
    assert rows == [[value, q, q] for q, value in enumerate(intermediates)], rows
    return [row[1] for row in rows]


if __name__ == "__main__":
    try:
        actual = solve()
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error} See README.md.") from None
    expected = list(range(8))
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
