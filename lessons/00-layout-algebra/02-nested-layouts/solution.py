"""Solution: Trace nested coordinates.

Run from the repository root:
    pixi run python lessons/00-layout-algebra/02-nested-layouts/solution.py
Layout algebra is traced by FlyDSL; thread-dependent mappings run on the GPU.
"""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def exercise_kernel(out: fx.Tensor):
    q = fx.thread_idx.x
    data_layout = fx.make_layout(((2, 2), 3), ((1, 4), 8))
    thread_layout = fx.make_ordered_layout(fx.get_shape(data_layout), ((0, 1), 2))
    # TASK: Count all positions, expand q with its hierarchy, and map it.
    logical_size = fx.size(data_layout)
    coordinate = fx.idx2crd(q, thread_layout)
    memory_offset = fx.crd2idx(coordinate, data_layout)
    out[q * 6] = fx.get_scalar(logical_size)
    out[q * 6 + 1] = fx.get_scalar(coordinate[0][0])
    out[q * 6 + 2] = fx.get_scalar(coordinate[0][1])
    out[q * 6 + 3] = fx.get_scalar(coordinate[1])
    out[q * 6 + 4] = fx.get_scalar(memory_offset)
    out[q * 6 + 5] = fx.get_scalar(fx.crd2idx(q, data_layout))


@flyc.jit
def run(out: fx.Tensor, stream: fx.Stream = fx.Stream(None)):  # noqa: B008 -- FlyDSL stream default
    # Exactly 12 threads: every thread owns one output row; no tail mask needed.
    exercise_kernel(out).launch(grid=(1, 1, 1), block=(12, 1, 1), stream=stream)


def solve():
    """Launch the exercise, check every GPU result, and return the lesson checkpoint."""
    out = torch.full((72,), -1, dtype=torch.int32, device="cuda")
    run(out)
    torch.cuda.synchronize()
    rows = out.cpu().reshape(12, 6).tolist()
    # Host code only checks and formats results; it does not implement layouts.
    expected_offsets = [0, 1, 4, 5, 8, 9, 12, 13, 16, 17, 20, 21]
    expected = [
        [12, q % 2, (q // 2) % 2, q // 4, offset, offset]
        for q, offset in enumerate(expected_offsets)
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
