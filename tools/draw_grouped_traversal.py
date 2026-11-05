"""Reproduce the 07c grouped block traversal SVG/PNG pair (requires Pillow)."""

from draw_divide_comparison import COLORS
from draw_lesson_visuals import Diagram


def main():
    blue, teal, gold, _ = COLORS
    d = Diagram(860, "07c - Group output blocks along M to reuse B")
    d.text(
        32, 65, "1024 x 1024 output; 64 x 64 tiles; 16 tile rows x 16 tile columns.", 20
    )
    d.text(
        32,
        99,
        "Cells label flattened physical block IDs (pid). Gold = pid 0 and 1.",
        19,
    )
    d.text(
        32,
        130,
        "Zoom: tile columns 0..3; columns 4..15 are omitted. All 16 rows are shown.",
        18,
    )
    for x, title, grouped in (
        (32, "07b: columns change first", False),
        (510, "07c: GROUP_M = 2", True),
    ):
        d.text(x, 176, title, 22)
        d.text(x, 212, "row", 15)
        for col in range(4):
            d.text(x + 62 + col * 81, 212, f"col {col}", 15)
        for row in range(16):
            y = 242 + row * 27
            d.text(x + 7, y + 4, str(row), 14)
            for col in range(4):
                pid = (row // 2) * 32 + col * 2 + row % 2 if grouped else row * 16 + col
                color = gold if pid < 2 else (teal if (row // 2) % 2 == 0 else blue)
                d.box(x + 51 + col * 81, y, 77, 25, color)
                d.text(x + 60 + col * 81, y + 3, str(pid), 15)
    d.text(32, 692, "Trace pid 2: (row,col) = (0,2) before; (0,1) after grouping.", 20)
    d.text(
        32,
        731,
        "Grouped pid 0 and 1 read different A rows and the same B[:,0:64] band.",
        19,
    )
    d.text(
        32,
        769,
        "Cache reuse is an opportunity: block IDs do not guarantee execution order.",
        18,
    )
    d.text(
        32,
        814,
        "Native traversal layout: (2,16,8):(16,1,32) -> row-major tile offset",
        19,
    )
    d.save("01-gpu-programming/13-matmul/07c-grouped-traversal/grouped-traversal")


if __name__ == "__main__":
    main()
