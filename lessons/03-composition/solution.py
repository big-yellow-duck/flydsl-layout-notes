"""Lesson exercise using the CPU layout model; Python 3.10+."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "examples"))
from layout_walkthrough import Layout, expand, size


def solve():
    # Evaluate A(B(c)) for every scalar coordinate of B.
    a = Layout((2, 4), (4, 1))
    b = Layout((4, 2), (2, 1))
    return [a(b(q)) for q in range(size(b.shape))]


if __name__ == "__main__":
    actual = solve()
    expected = [0, 1, 2, 3, 4, 5, 6, 7]
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
