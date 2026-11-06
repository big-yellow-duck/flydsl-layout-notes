"""Reproduce the independent-wave lesson diagrams (requires Pillow)."""

from html import escape

from draw_lesson_visuals import BLUE, GOLD, INK, TEAL, Diagram

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
        "Follow physical block 2: logical_block_id = 2 * 2 + wave_group.",
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


if __name__ == "__main__":
    wave_tiles()
