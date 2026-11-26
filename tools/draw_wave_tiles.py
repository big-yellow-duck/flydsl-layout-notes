"""Reproduce the independent-wave lesson diagrams (requires Pillow)."""

from html import escape

from draw_lesson_visuals import BLUE, GOLD, INK, PURPLE, TEAL, Diagram

BASE = "01-gpu-programming/13-matmul/10-wave-local-tiles"


def describe(diagram, description):
    diagram.svg[0] = diagram.svg[0].replace(
        'role="img"', 'role="img" aria-labelledby="title desc"'
    )
    diagram.svg[1] = diagram.svg[1].replace("<title>", '<title id="title">')
    diagram.svg.insert(2, f'<desc id="desc">{escape(description)}</desc>')


def down_arrow(diagram, x, y1, y2):
    points = [(x, y1), (x, y2), (x - 7, y2 - 8), (x, y2), (x + 7, y2 - 8)]
    diagram.draw.line([(px * 2, py * 2) for px, py in points], fill=INK, width=4)
    coords = " ".join(f"{px},{py}" for px, py in points)
    diagram.svg.append(
        f'<polyline points="{coords}" fill="none" stroke="{INK}" stroke-width="2"/>'
    )


def wave_tiles():
    d = Diagram(850, "10 - Two independent waves select two output tiles")
    describe(
        d,
        "Physical block 2 has two independent wave32 groups. Wave 0 selects logical tile 4 and columns 256 through 319; wave 1 selects tile 5 and columns 320 through 383. Each wave has disjoint single-stage LDS storage.",
    )
    d.text(32, 66, "M=16, N=4096, K=8192; per-wave tile 16 x 64 x 16; split_k=1.", 20)
    d.card(
        32,
        112,
        893,
        "32 physical blocks x 2 waves = 64 logical output tiles",
        "Block 2 selects 16 x 128 outputs, then slices two 16 x 64 wave tiles.",
        BLUE,
    )
    for wave, color in enumerate((TEAL, GOLD)):
        x = 32 + wave * 460
        d.box(x, 242, 433, 145, color)
        d.text(
            x + 14,
            259,
            f"Wave {wave}: physical threads {32 * wave}..{32 * wave + 31}",
            21,
        )
        d.text(x + 14, 301, f"Logical tile {4 + wave}: output rows 0..15", 20)
        d.text(x + 14, 342, f"Output columns {256 + 64 * wave}..{319 + 64 * wave}", 21)
        down_arrow(d, x + 215, 402, 437)
        d.box(x, 453, 433, 116, color)
        d.text(x + 14, 466, f"A LDS: BF16 offsets {384 * wave}..{384 * wave + 383}", 20)
        d.text(
            x + 14, 507, f"B LDS: BF16 offsets {1024 * wave}..{1024 * wave + 1023}", 20
        )
        d.text(x + 14, 542, "768 bytes A + 2048 bytes B", 18)
    d.text(
        32,
        609,
        "A and B offsets are relative to their separate LDS allocations, in BF16 elements.",
        18,
    )
    d.card(
        32,
        653,
        893,
        "One current LDS tile per wave; the next tile stays in private registers",
        "Full-workgroup barriers protect the reader and publication handoffs.",
        BLUE,
    )
    d.text(
        32,
        777,
        "Boundary trace: K=48, A tile tags [1,2,4], B=1 -> every output = 16*7 = 112.",
        19,
    )
    d.text(
        32,
        815,
        "The two waves own different output columns; they do not reduce each other's values.",
        18,
    )
    d.save(f"{BASE}/wave-tiles")


def wave_grid_2d():
    d = Diagram(910, "10 - Select a physical block, then its 2D wave tiles")
    describe(
        d,
        "M64 N256 K8192, per-wave M16 N64 K16. A 2 by 2 wave-group grid gives each physical block a 32 by 128 output region and four disjoint A/B LDS pairs. Wave columns vary first. Group M two orders physical block rows before K splits and physical columns.",
    )
    d.text(
        32,
        72,
        "M=64, N=256, K=8192; each wave computes 16 x 64, with K chunks of 16.",
        20,
    )
    d.card(
        32,
        118,
        893,
        "Physical block 0: C rows 0..31, columns 0..127",
        "Group shape (2,2): 4 wave32 tiles, 128 threads, 11264 LDS bytes.",
        BLUE,
    )
    for wave, color in enumerate((TEAL, GOLD, BLUE, PURPLE)):
        row, col = divmod(wave, 2)
        x, y = 32 + col * 460, 248 + row * 174
        d.box(x, y, 433, 147, color)
        d.text(x + 14, y + 12, f"Wave {wave}: (group_row,group_col)=({row},{col})", 20)
        d.text(
            x + 14,
            y + 48,
            f"C rows {row * 16}..{row * 16 + 15}, cols {col * 64}..{col * 64 + 63}",
            20,
        )
        d.text(
            x + 14,
            y + 83,
            f"Threads {wave * 32}..{wave * 32 + 31}; local IDs 0..31",
            19,
        )
        d.text(x + 14, y + 117, "Private A/B LDS: 768 + 2048 bytes", 19)
    d.text(
        32,
        607,
        "Waves 0/1 repeat A; waves 0/2 repeat B. Every copy remains private.",
        20,
    )
    d.card(
        32,
        652,
        893,
        "traversal_group_m=2 orders physical block rows with split_k=2",
        "First four block IDs at physical column 0: row 0/split 0, row 1/split 0,",
        BLUE,
    )
    d.text(
        44,
        747,
        "then row 0/split 1, row 1/split 1. Each block's four waves use one split.",
        20,
    )
    d.text(
        32,
        807,
        "out_block_view: 32 x 128  ->  divide 16 x 64  ->  slice (group_row,group_col)",
        20,
    )
    d.text(
        32,
        853,
        "Physical block rows and wave rows are different axes; LDS uses both wave axes.",
        19,
    )
    d.save(f"{BASE}/wave-grid-2d")


if __name__ == "__main__":
    wave_tiles()
    wave_grid_2d()
