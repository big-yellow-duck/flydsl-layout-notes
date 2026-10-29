"""Lesson exercise using the CPU layout model; Python 3.10+."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "examples"))
from layout_walkthrough import Layout, expand, size


def solve():
    # Return the offset at (2, 3), logical size, and storage span.
    layout = Layout((3, 4), (5, 1))
    return layout((2, 3)), size(layout.shape), layout.cosize()


if __name__ == "__main__":
    actual = solve()
    expected = (13, 12, 14)
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
