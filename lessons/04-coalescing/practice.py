"""Practice: Build and verify a simpler layout.

Read the Practice section in README.md, then replace the TODO None values.
Run this file with Python 3.10+; only the local layout.py model is used.
"""

from layout import Layout, size


def solve():
    """Return (original_offsets, simplified_offsets), a tuple containing two lists."""
    # Given: the second stride is the first shape times the first stride.
    original = Layout((2, 3), (3, 6))

    # TODO 1: Multiply the two shape sizes to get a single integer shape.
    merged_shape = None
    # TODO 2: Keep the first mode's stride as the merged stride.
    merged_stride = None
    if merged_shape is None or merged_stride is None:
        raise NotImplementedError(
            "Fill in merged_shape and merged_stride before constructing the layout."
        )

    simplified = Layout(merged_shape, merged_stride)
    assert size(original.shape) == size(simplified.shape), (
        "Coalescing must preserve size"
    )
    # TODO 3: Use .sequence() on each layout; preserve scalar-coordinate order.
    original_offsets = None
    simplified_offsets = None
    if original_offsets is None or simplified_offsets is None:
        raise NotImplementedError("Fill in both offset lists using .sequence().")

    return original_offsets, simplified_offsets


if __name__ == "__main__":
    try:
        actual = solve()
    except NotImplementedError as error:
        raise SystemExit(
            f"Practice not finished: {error} See README.md for steps and hints."
        ) from None
    expected = ([0, 3, 6, 9, 12, 15], [0, 3, 6, 9, 12, 15])
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
