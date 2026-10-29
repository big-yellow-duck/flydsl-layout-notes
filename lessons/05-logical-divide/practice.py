"""Practice: Enumerate one tile of a matrix.

Read the Practice section in README.md, then replace the TODO None values.
Run this file with Python 3.10+; only the local layout.py model is used.
"""

from layout import Layout


def solve():
    """Return eight offsets for tile (1, 1), in row-major local order (n changes fastest)."""
    # Given: original row/column strides and a contiguous 2-by-4 tile.
    original = Layout((4, 8), (8, 1))
    tile_shape = (2, 4)
    tile_coordinate = (1, 1)

    # A flat-divide coordinate is (m, n, p, q): local row/column, tile row/column.
    # TODO 1: Supply the four strides in that order. Local strides come from
    # original.stride; tile strides multiply them by the matching tile sizes.
    divided_stride = None
    if divided_stride is None:
        raise NotImplementedError("Fill in divided_stride as a tuple of four integers.")
    divided = Layout((2, 4, 2, 2), divided_stride)

    p, q = tile_coordinate
    offsets = []
    for m in range(tile_shape[0]):
        for n in range(tile_shape[1]):
            # TODO 2: Evaluate divided at the explicit tuple (m, n, p, q).
            memory_offset = None
            if memory_offset is None:
                raise NotImplementedError(
                    "Fill in memory_offset inside the nested loops."
                )
            offsets.append(memory_offset)
    return offsets


if __name__ == "__main__":
    try:
        actual = solve()
    except NotImplementedError as error:
        raise SystemExit(
            f"Practice not finished: {error} See README.md for steps and hints."
        ) from None
    expected = [20, 21, 22, 23, 28, 29, 30, 31]
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
