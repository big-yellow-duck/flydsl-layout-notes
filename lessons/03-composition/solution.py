"""Worked solution: Follow both stages of composition.

Run this file with Python 3.10+; only the local layout.py model is used.

B visits 0, 2, 4, 6, 1, 3, 5, 7 in its scalar-coordinate order.
A interprets each of those outputs through shape (2, 4), yielding the
final offsets 0..7. For example q=1 gives B(1)=2, then A(2)=1.
This is function evaluation in the CPU model, not symbolic composition.
"""

from layout import Layout, size


def solve():
    """Return a list of eight final offsets A(B(q)), ordered by scalar coordinates q of B."""
    # Given: B's output is a scalar logical coordinate for A.
    a = Layout((2, 4), (4, 1))
    b = Layout((4, 2), (2, 1))
    # Check the intermediate stage too: the final sequence alone hides reversal.
    expected_intermediates = (0, 2, 4, 6, 1, 3, 5, 7)
    offsets = []
    for q in range(size(b.shape)):
        # Step 1: Apply B to q. This produces the intermediate coordinate for A.
        intermediate = b(q)

        # This check uses A's logical size, not its physical storage span.
        assert 0 <= intermediate < size(a.shape), (
            "B emitted an invalid coordinate for A"
        )
        assert intermediate == expected_intermediates[q], f"At q={q}, apply B first"
        # Step 2: Apply A to that intermediate scalar coordinate.
        final_offset = a(intermediate)

        offsets.append(final_offset)
    return offsets


if __name__ == "__main__":
    actual = solve()
    expected = [0, 1, 2, 3, 4, 5, 6, 7]
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
