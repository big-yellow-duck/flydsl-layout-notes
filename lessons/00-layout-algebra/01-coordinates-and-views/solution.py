"""Solution: Separate scalar coordinates from offsets.

Run from the repository root:
    pixi run python lessons/00-layout-algebra/01-coordinates-and-views/solution.py
Layout algebra is traced by FlyDSL; thread-dependent mappings run on the GPU.
"""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def exercise_kernel(out: fx.Tensor):
    q = fx.thread_idx.x
    data_layout = fx.make_layout((2, 4), (4, 1))
    # Ordered compact strides enumerate the first mode fastest: (1, 2).
    thread_layout = fx.make_ordered_layout(fx.get_shape(data_layout), (0, 1))
    # TASK: Decode the thread ID through thread_layout, then apply the data layout.
    coordinate = fx.idx2crd(q, thread_layout)
    memory_offset = fx.crd2idx(coordinate, data_layout)
    out[q * 4] = fx.get_scalar(coordinate[0])
    out[q * 4 + 1] = fx.get_scalar(coordinate[1])
    out[q * 4 + 2] = fx.get_scalar(memory_offset)
    # Native scalar mapping must agree with the two explicit steps.
    out[q * 4 + 3] = fx.get_scalar(fx.crd2idx(q, data_layout))


@flyc.jit
def run(out: fx.Tensor, stream: fx.Stream = fx.Stream(None)):  # noqa: B008 -- FlyDSL stream default
    # Exactly 8 threads: every thread owns one output row; no tail mask needed.
    exercise_kernel(out).launch(grid=(1, 1, 1), block=(8, 1, 1), stream=stream)


def solve():
    """Launch the exercise, check every GPU result, and return the lesson checkpoint."""
    out = torch.full((32,), -1, dtype=torch.int32, device="cuda")
    run(out)
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
