"""Worked solution: Separate scalar coordinates from offsets.

Run this file with Python 3.10+; only the local layout.py model is used.

For each q, expand gives (q % 2, q // 2). Applying the layout then gives
row*4 + column. The first coordinate advances fastest even though its
memory stride is larger. layout(q) is a shorthand for the same two steps.
"""

from layout import Layout, expand, size


def solve():
    """Return a list of eight (expanded_coordinate, memory_offset) pairs, ordered by q."""
    # Given: a two-row, four-column row-major layout.
    layout = Layout((2, 4), (4, 1))
    rows = []
    for q in range(size(layout.shape)):
        # Step 1: Expand q through the shape, using expand(q, layout.shape).
        coordinate = expand(q, layout.shape)
        # Step 2: Map the expanded tuple to its memory offset with layout(...).
        memory_offset = layout(coordinate)

        rows.append((coordinate, memory_offset))
    return rows


if __name__ == "__main__":
    actual = solve()
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
