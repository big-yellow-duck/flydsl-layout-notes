"""Worked solution: Trace a nested coordinate.

Run this file with Python 3.10+; only the local layout.py model is used.

The size is (2*2)*3 = 12. Splitting q=7 by the first mode's size 4
gives (3, 1), then expanding 3 inside (2, 2) gives (1, 1). The full
coordinate is ((1, 1), 1), whose offset is 1*1 + 1*4 + 1*8 = 13.
"""

from layout import Layout, expand, size


def solve():
    """Return (logical_size, expanded_coordinate, memory_offset) for scalar coordinate 7."""
    # Given: two top-level modes; the first contains two leaf axes.
    layout = Layout(((2, 2), 3), ((1, 4), 8))
    q = 7

    # Step 1: Count all logical positions with size(layout.shape).
    logical_size = size(layout.shape)
    # Step 2: Expand q recursively through layout.shape with expand(...).
    coordinate = expand(q, layout.shape)
    # Step 3: Evaluate the layout at the nested coordinate you just found.
    memory_offset = layout(coordinate)

    return logical_size, coordinate, memory_offset


if __name__ == "__main__":
    actual = solve()
    expected = (12, ((1, 1), 1), 13)
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
