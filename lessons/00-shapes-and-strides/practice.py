"""Practice: Measure a padded layout.

Read the Practice section in README.md, then replace the TODO None values.
Run this file with Python 3.10+; only the local layout.py model is used.
"""

from layout import Layout, size


def solve():
    """Return (offset_at_2_3, logical_size, storage_span), a tuple of three integers."""
    # Given: three rows, four columns, and a row pitch of five elements.
    layout = Layout((3, 4), (5, 1))
    coordinate = (2, 3)

    # TODO 1: Call the layout with the explicit (row, column) coordinate.
    element_offset = None
    # TODO 2: Count logical positions using size(layout.shape).
    logical_size = None
    # TODO 3: Find the storage span using layout.cosize().
    storage_span = None

    if element_offset is None or logical_size is None or storage_span is None:
        raise NotImplementedError("Replace the three None values in solve().")

    return element_offset, logical_size, storage_span


if __name__ == "__main__":
    try:
        actual = solve()
    except NotImplementedError as error:
        raise SystemExit(
            f"Practice not finished: {error} See README.md for steps and hints."
        ) from None
    expected = (13, 12, 14)
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
