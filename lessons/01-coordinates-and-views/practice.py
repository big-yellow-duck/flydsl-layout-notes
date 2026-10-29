"""Practice: Separate scalar coordinates from offsets.

Read the Practice section in README.md, then replace the TODO None values.
Run this file with Python 3.10+; only the local layout.py model is used.
"""

from layout import Layout, expand, size


def solve():
    """Return a list of eight (expanded_coordinate, memory_offset) pairs, ordered by q."""
    # Given: a two-row, four-column row-major layout.
    layout = Layout((2, 4), (4, 1))
    rows = []
    for q in range(size(layout.shape)):
        # TODO 1: Expand q through the shape, using expand(q, layout.shape).
        coordinate = None
        # TODO 2: Map the expanded tuple to its memory offset with layout(...).
        memory_offset = None

        if coordinate is None or memory_offset is None:
            raise NotImplementedError(
                "Fill in coordinate and memory_offset in the loop."
            )

        rows.append((coordinate, memory_offset))
    return rows


if __name__ == "__main__":
    try:
        actual = solve()
    except NotImplementedError as error:
        raise SystemExit(
            f"Practice not finished: {error} See README.md for steps and hints."
        ) from None
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
