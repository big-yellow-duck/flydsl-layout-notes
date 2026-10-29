"""Lesson exercise using the CPU layout model; Python 3.10+."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "examples"))
from layout_walkthrough import Layout, expand, size


def solve():
    # Expand scalar coordinates 0..7 and calculate their offsets.
    raise NotImplementedError("Complete this exercise")


if __name__ == "__main__":
    actual = solve()
    expected = [((0, 0), 0), ((1, 0), 4), ((0, 1), 1), ((1, 1), 5), ((0, 2), 2), ((1, 2), 6), ((0, 3), 3), ((1, 3), 7)]
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
