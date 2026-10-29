"""Practice: Follow both stages of composition.

Read the Practice section in README.md, then replace the TODO None values.
Run this file with Python 3.10+; only the local layout.py model is used.
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
        # TODO 1: Apply B to q. This produces the intermediate coordinate for A.
        intermediate = None
        if intermediate is None:
            raise NotImplementedError("Fill in intermediate = ... using b(q).")

        # This check uses A's logical size, not its physical storage span.
        assert 0 <= intermediate < size(a.shape), (
            "B emitted an invalid coordinate for A"
        )
        assert intermediate == expected_intermediates[q], f"At q={q}, apply B first"
        # TODO 2: Apply A to that intermediate scalar coordinate.
        final_offset = None
        if final_offset is None:
            raise NotImplementedError(
                "Fill in final_offset = ... using a(intermediate)."
            )

        offsets.append(final_offset)
    return offsets


if __name__ == "__main__":
    try:
        actual = solve()
    except NotImplementedError as error:
        raise SystemExit(
            f"Practice not finished: {error} See README.md for steps and hints."
        ) from None
    expected = [0, 1, 2, 3, 4, 5, 6, 7]
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
