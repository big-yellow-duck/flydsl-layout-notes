"""Lesson exercise using the CPU layout model; Python 3.10+."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "examples"))
from layout_walkthrough import Layout, expand, size


def solve():
    # Tile a (4, 8) row-major matrix into (2, 4) tiles.
    # Return offsets for tile (1, 1), in row-major local order.
    divided = Layout((2, 4, 2, 2), (8, 1, 16, 4))
    return [divided((m, n, 1, 1)) for m in range(2) for n in range(4)]


if __name__ == "__main__":
    actual = solve()
    expected = [20, 21, 22, 23, 28, 29, 30, 31]
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
