"""Lesson exercise using the CPU layout model; Python 3.10+."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "examples"))
from layout_walkthrough import Layout, expand, size


def solve():
    # Construct a coalesced layout with the same scalar mapping.
    raise NotImplementedError("Complete this exercise")


if __name__ == "__main__":
    actual = solve()
    expected = ([0, 3, 6, 9, 12, 15], [0, 3, 6, 9, 12, 15])
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
