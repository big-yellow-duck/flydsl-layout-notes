"""Practice: Trace a nested coordinate.

Read the Practice section in README.md, then replace the TODO None values.
Run this file with Python 3.10+; only the local layout.py model is used.
"""

from layout import Layout, expand, size


def solve():
    """Return (logical_size, expanded_coordinate, memory_offset) for scalar coordinate 7."""
    # Given: two top-level modes; the first contains two leaf axes.
    layout = Layout(((2, 2), 3), ((1, 4), 8))
    q = 7

    # TODO 1: Count all logical positions with size(layout.shape).
    logical_size = None
    # TODO 2: Expand q recursively through layout.shape with expand(...).
    coordinate = None
    # TODO 3: Evaluate the layout at the nested coordinate you just found.
    memory_offset = None

    if logical_size is None or coordinate is None or memory_offset is None:
        raise NotImplementedError("Replace the three None values in solve().")

    return logical_size, coordinate, memory_offset


if __name__ == "__main__":
    try:
        actual = solve()
    except NotImplementedError as error:
        raise SystemExit(
            f"Practice not finished: {error} See README.md for steps and hints."
        ) from None
    expected = (12, ((1, 1), 1), 13)
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
