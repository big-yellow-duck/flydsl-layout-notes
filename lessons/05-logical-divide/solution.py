"""Worked solution: Enumerate one tile of a matrix.

Run this file with Python 3.10+; only the local layout.py model is used.

One local row steps 8 elements, one local column steps 1, one tile row
steps 2*8 = 16, and one tile column steps 4*1 = 4. Tile (1, 1) begins
at 16+4 = 20. Explicit nested loops enumerate the first local row before
the second; .sequence() would instead use first-mode-fastest order.
The divided layout is constructed explicitly, not by a CPU divide API.
"""

from layout import Layout


def solve():
    """Return eight offsets for tile (1, 1), in row-major local order (n changes fastest)."""
    # Given: original row/column strides and a contiguous 2-by-4 tile.
    original = Layout((4, 8), (8, 1))
    tile_shape = (2, 4)
    tile_coordinate = (1, 1)

    # A flat-divide coordinate is (m, n, p, q): local row/column, tile row/column.
    # Step 1: Supply the four strides in that order. Local strides come from
    # original.stride; tile strides multiply them by the matching tile sizes.
    divided_stride = (
        original.stride[0],
        original.stride[1],
        tile_shape[0] * original.stride[0],
        tile_shape[1] * original.stride[1],
    )
    divided = Layout((2, 4, 2, 2), divided_stride)

    p, q = tile_coordinate
    offsets = []
    for m in range(tile_shape[0]):
        for n in range(tile_shape[1]):
            # Step 2: Evaluate divided at the explicit tuple (m, n, p, q).
            memory_offset = divided((m, n, p, q))
            offsets.append(memory_offset)
    return offsets


if __name__ == "__main__":
    actual = solve()
    expected = [20, 21, 22, 23, 28, 29, 30, 31]
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
