"""Reproduce the single-kernel split-K lesson diagrams (requires Pillow)."""

from html import escape

from draw_lesson_visuals import BLUE, GOLD, PURPLE, TEAL, Diagram

BASE = "01-gpu-programming/13-matmul/09-split-k"


def describe(diagram, description):
    diagram.svg[0] = diagram.svg[0].replace(
        'role="img"', 'role="img" aria-labelledby="title desc"'
    )
    diagram.svg[1] = diagram.svg[1].replace("<title>", '<title id="title">')
    diagram.svg.insert(2, f'<desc id="desc">{escape(description)}</desc>')


def grouped_split_order():
    d = Diagram(670, "09 - Group M before advancing K splits")
    describe(
        d,
        "A four by two output tile grid with group_m two and split_k two visits adjacent M rows at the same split, then advances K split, column, and M group.",
    )
    d.text(32, 67, "Output grid: 4 rows x 2 columns; group_m=2; split_k=2.", 21)
    d.text(
        32,
        107,
        "Fastest to slowest: row within group -> K split -> column -> M group.",
        19,
    )
    visits = [
        (row, col, split)
        for first in (0, 2)
        for col in (0, 1)
        for split in (0, 1)
        for row in (first, first + 1)
    ]
    for logical_id, (row, col, split) in enumerate(visits):
        x = 32 + (logical_id % 4) * 230
        y = 158 + (logical_id // 4) * 110
        d.box(x, y, 213, 86, BLUE if split == 0 else TEAL)
        d.text(x + 10, y + 12, f"ID {logical_id}: row {row}, col {col}", 18)
        d.text(x + 10, y + 46, f"K split {split}; tile ID {row * 2 + col}", 18)
    d.text(
        32,
        609,
        "Tile IDs index workspace in row-major order; launch order is grouped.",
        19,
    )
    d.save(f"{BASE}/grouped-split-order")


def main():
    d = Diagram(830, "09 - Give a skinny output more blocks along K")
    describe(
        d,
        "Sixteen output tiles become sixty-four blocks with four disjoint K ranges per tile. Blocks 8 through 11 share output tile 2.",
    )
    d.text(32, 65, "M=16, N=1024, K=8192; block 16 x 64 x 64; split_k=4.", 21)
    d.text(
        32,
        106,
        "The 1 x 16 logical output grid has only 16 tiles. Launch 64 blocks.",
        20,
    )
    for tile in range(16):
        x = 32 + tile * 56
        d.box(x, 152, 52, 62, GOLD if tile == 2 else BLUE)
        d.text(x + 6, 170, str(tile), 19)
    d.text(
        32,
        239,
        "Cells label output tile IDs. Trace tile 2: output rows 0..15, columns 128..191.",
        19,
    )
    d.text(
        32,
        292,
        "Here group_m=1: physical ID = tile_id * 4 + split_id.",
        20,
    )
    colors = (BLUE, TEAL, GOLD, PURPLE)
    for part, color in enumerate(colors):
        x = 32 + part * 230
        d.box(x, 342, 213, 112, color)
        d.text(x + 12, 357, f"block {8 + part}, split {part}", 21)
        d.text(x + 12, 394, f"K [{part * 2048},{(part + 1) * 2048})", 20)
        d.text(x + 12, 426, "32 local K tiles", 17)
    d.text(
        32,
        500,
        "Trace block 10: split_id=2, initial_tile_k=64, first matrix K index=4096.",
        20,
    )
    d.card(
        32,
        552,
        893,
        "Within each split: retain stage 08's prefetch pipeline",
        "next globals -> private staging; current LDS -> K=16 WMMA -> FP32 partials",
        BLUE,
    )
    d.text(
        32,
        675,
        "Each block owns a disjoint K range and has its own single LDS tile per operand.",
        19,
    )
    d.text(
        32,
        717,
        "The output tile repeats across splits; output values are combined before BF16 storage.",
        18,
    )
    d.text(
        32,
        766,
        "Output tile ID, split ID, K-tile index, and matrix K index are different coordinates.",
        18,
    )
    d.save(f"{BASE}/split-domain")

    d = Diagram(810, "09 - The final arriving thread finishes its output slots")
    describe(
        d,
        "Four peers publish FP32 partials 448, 896, 1344, and 1792. The final arriving thread sums to 4480, writes BF16 output, and resets its counter.",
    )
    d.text(
        32,
        65,
        "One counter per (output tile, thread ID); peers differ only in split_id.",
        20,
    )
    d.text(
        32,
        105,
        "Numeric boundary check: K=768, BLOCK_K=64, three K tiles per split.",
        20,
    )
    for part, color in enumerate(colors):
        x = 32 + part * 230
        d.box(x, 151, 213, 103, color)
        d.text(x + 13, 166, f"split {part}: A tags", 21)
        d.text(x + 13, 202, str([part + 1, 2 * (part + 1), 4 * (part + 1)]), 21)
    d.text(
        32,
        287,
        "B contains 1. Each FP32 output partial = 64 * sum(the split's three tags).",
        19,
    )
    d.text(32, 333, "FP32 partial slots:", 21)
    for part, value in enumerate((448, 896, 1344, 1792)):
        x = 250 + part * 170
        d.box(x, 326, 150, 51, colors[part])
        d.text(x + 23, 340, str(value), 23)
    d.card(
        32,
        412,
        893,
        "Publish each thread's partials, then atomic_add(counter, 1)",
        "Agent-scope acquire/release orders the FP32 stores before a peer reads them.",
        TEAL,
    )
    d.text(
        32,
        524,
        "Only the peer receiving old counter value 3 reduces: 448+896+1344+1792=4480.",
        19,
    )
    d.card(
        32,
        572,
        893,
        "One final BF16 conversion -> output; reset this counter to 0",
        "Earlier arrivals leave. No polling, global barrier, clear pass, or reduction launch.",
        GOLD,
    )
    d.text(
        32,
        691,
        "Each thread finalizes only its own WMMA C slots; winners may come from different blocks.",
        18,
    )
    d.text(
        32,
        737,
        "Reuse workspace on the same stream. Overlapping calls need independent workspaces.",
        19,
    )
    d.save(f"{BASE}/last-arrival")
    grouped_split_order()


if __name__ == "__main__":
    main()
