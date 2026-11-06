"""Reproduce the independent-wave lesson diagrams (requires Pillow)."""

import json
import sys
from html import escape
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "tools"))

from draw_lesson_visuals import BLUE, GOLD, INK, TEAL, Diagram

BASE = str(Path(__file__).resolve().parent / "assets")
ROOT = Path(__file__).resolve().parents[2]


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
        "Subgroup rendezvous + LDS-only memory fence protects each wave's handoffs.",
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


def memory_requests():
    results = Path(__file__).resolve().parent / "results" / "20261106"
    reports = {
        name: json.loads((results / name / "summary.json").read_text())
        for name in ("stage09-wide", "stage10-wide")
    }
    counter = "GL1C_GL2_REQ_READ_128B_sum"
    values = [
        reports[name]["profiles"]["l1-read-sizes"]["median_counters"]["native"][counter]
        for name in reports
    ]
    external = [
        reports[name]["profiles"]["l2"]["median_counters"]["native"][
            "GL2C_EA_RDREQ_128B_sum"
        ]
        for name in reports
    ]
    d = Diagram(715, "10 - Reduce cache requests while streaming the same B")
    describe(
        d,
        "Separate rocprofv3 counter passes show about half as many 128-byte L1-to-L2 read requests in stage 10. External read requests remain close to the 64 MiB B input in both stages. These are counter medians rather than timed throughput.",
    )
    d.text(32, 66, "Same 16 x 4096 x 8192 BF16 GEMM; B occupies 64 MiB.", 21)
    d.text(
        32, 114, "L1 -> L2: median number of 128-byte read requests per dispatch", 21
    )
    for index, (value, color) in enumerate(zip(values, (BLUE, TEAL), strict=True)):
        y = 172 + index * 100
        d.text(32, y + 14, f"Stage {9 + index:02d}", 23)
        d.box(190, y, 540 * value / max(values), 52, color)
        d.text(752, y + 14, f"{value:,.0f}", 21)
    d.text(
        32, 380, "L2 -> external memory: median number of 128-byte read requests", 21
    )
    for index, (value, color) in enumerate(zip(external, (BLUE, TEAL), strict=True)):
        y = 433 + index * 85
        d.text(32, y + 10, f"Stage {9 + index:02d}", 23)
        d.box(190, y, 540 * value / max(values), 46, color)
        d.text(752, y + 10, f"{value:,.0f}", 21)
    d.text(
        32,
        612,
        "Read the two comparisons separately: fewer cache requests, similar external bytes.",
        19,
    )
    d.text(
        32,
        652,
        "Eight native dispatches per counter pass; raw CSVs and definitions accompany the lesson.",
        18,
    )
    d.text(
        32,
        687,
        "Counter collection and uninstrumented timing are separate experiments.",
        18,
    )
    d.save(f"{BASE}/memory-requests")


if __name__ == "__main__":
    wave_tiles()
    memory_requests()
