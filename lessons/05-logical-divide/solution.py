"""Solution: Divide a matrix into tiles.

Run from the repository root:
    pixi run python lessons/05-logical-divide/solution.py
Layout algebra is traced by FlyDSL; thread-dependent mappings run on the GPU.
"""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def exercise_kernel(out: fx.Tensor):
    q = fx.thread_idx.x
    original = fx.make_layout((4, 8), (8, 1))
    # Eight threads per tile; local columns change fastest for this exercise.
    m = (q // 4) % 2
    n = q % 4
    p = q // 16
    tile_column = (q // 8) % 2
    # TASK: Split each original mode using the tuple tiler (2, 4).
    divided = fx.flat_divide(original, (2, 4))
    memory_offset = fx.crd2idx(fx.make_coord(m, n, p, tile_column), divided)
    out[q * 5] = fx.get_scalar(memory_offset)
    # The other groupings must agree at CORRESPONDING explicit coordinates.
    logical = fx.logical_divide(original, (2, 4))
    zipped = fx.zipped_divide(original, (2, 4))
    tiled = fx.tiled_divide(original, (2, 4))
    out[q * 5 + 1] = fx.get_scalar(
        fx.crd2idx(fx.make_coord((m, p), (n, tile_column)), logical)
    )
    out[q * 5 + 2] = fx.get_scalar(
        fx.crd2idx(fx.make_coord((m, n), (p, tile_column)), zipped)
    )
    out[q * 5 + 3] = fx.get_scalar(
        fx.crd2idx(fx.make_coord((m, n), p, tile_column), tiled)
    )
    out[q * 5 + 4] = fx.get_scalar(
        fx.crd2idx(fx.make_coord(m + 2 * p, n + 4 * tile_column), original)
    )


@flyc.jit
def run(out: fx.Tensor, stream: fx.Stream = fx.Stream(None)):  # noqa: B008 -- FlyDSL stream default
    # Exactly 32 threads: every thread owns one output row; no tail mask needed.
    exercise_kernel(out).launch(grid=(1, 1, 1), block=(32, 1, 1), stream=stream)


def solve():
    """Launch the exercise, check every GPU result, and return the lesson checkpoint."""
    out = torch.full((160,), -1, dtype=torch.int32, device="cuda")
    run(out)
    torch.cuda.synchronize()
    rows = out.cpu().reshape(32, 5).tolist()
    # Host code only checks and formats results; it does not implement layouts.
    expected_offsets = [
        0,
        1,
        2,
        3,
        8,
        9,
        10,
        11,
        4,
        5,
        6,
        7,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        24,
        25,
        26,
        27,
        20,
        21,
        22,
        23,
        28,
        29,
        30,
        31,
    ]
    assert rows == [[offset] * 5 for offset in expected_offsets], rows
    assert sorted(row[0] for row in rows) == list(range(32)), rows
    return [row[0] for row in rows[24:32]]  # Tile (1, 1), row-major locally.


if __name__ == "__main__":
    try:
        actual = solve()
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error} See README.md.") from None
    expected = [20, 21, 22, 23, 28, 29, 30, 31]
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
