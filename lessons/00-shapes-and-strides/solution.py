"""Worked solution: Measure a padded layout.

Run this file with Python 3.10+; only the local layout.py model is used.

The coordinate (2, 3) gives 2*5 + 3*1 = 13. There are 3*4 = 12
logical positions. The largest reachable offset is 13, so the span is 14;
offsets 4 and 9 are padding holes, not additional logical positions.
"""

from layout import Layout, size


def solve():
    """Return (offset_at_2_3, logical_size, storage_span), a tuple of three integers."""
    # Given: three rows, four columns, and a row pitch of five elements.
    layout = Layout((3, 4), (5, 1))
    coordinate = (2, 3)

    # Step 1: Call the layout with the explicit (row, column) coordinate.
    element_offset = layout(coordinate)
    # Step 2: Count logical positions using size(layout.shape).
    logical_size = size(layout.shape)
    # Step 3: Find the storage span using layout.cosize().
    storage_span = layout.cosize()

    return element_offset, logical_size, storage_span


if __name__ == "__main__":
    actual = solve()
    expected = (13, 12, 14)
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
