"""Worked solution: Build and verify a simpler layout.

Run this file with Python 3.10+; only the local layout.py model is used.

The merge rule holds because 6 = 2*3. The merged shape is 2*3 = 6
and its stride stays 3, giving Layout(6, 3). Both layouts visit the
same ordered offsets. Sorting the lists or comparing sets would hide
mapping changes and would not verify coalescing.
"""

from layout import Layout, size


def solve():
    """Return (original_offsets, simplified_offsets), a tuple containing two lists."""
    # Given: the second stride is the first shape times the first stride.
    original = Layout((2, 3), (3, 6))

    # Step 1: Multiply the two shape sizes to get a single integer shape.
    merged_shape = size(original.shape)
    # Step 2: Keep the first mode's stride as the merged stride.
    merged_stride = original.stride[0]

    simplified = Layout(merged_shape, merged_stride)
    assert size(original.shape) == size(simplified.shape), (
        "Coalescing must preserve size"
    )
    # Step 3: Use .sequence() on each layout; preserve scalar-coordinate order.
    original_offsets = original.sequence()
    simplified_offsets = simplified.sequence()

    return original_offsets, simplified_offsets


if __name__ == "__main__":
    actual = solve()
    expected = ([0, 3, 6, 9, 12, 15], [0, 3, 6, 9, 12, 15])
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
