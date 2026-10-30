"""Exact lesson diagrams: python3 tools/draw_lesson_visuals.py (Pillow required).

These figures illustrate the fixed examples in the READMEs, not GPU execution.
"""

from html import escape

from draw_divide_comparison import COLORS, INK, Figure

BLUE, TEAL, GOLD, PURPLE = COLORS
GRAY = "#e2e8f0"


class Diagram(Figure):
    def box(self, x, y, w, h, color="white"):
        self.draw.rectangle(
            (x * 2, y * 2, (x + w) * 2, (y + h) * 2),
            fill=color,
            outline="#8294aa",
            width=2,
        )
        self.svg.append(
            f'<rect x="{x}" y="{y}" width="{w}" height="{h}" fill="{color}" stroke="#8294aa"/>'
        )

    def arrow(self, x1, y1, x2, y2):
        direction = 1 if x2 > x1 else -1
        points = [
            (x1, y1),
            (x2, y2),
            (x2 - 8 * direction, y2 - 5),
            (x2, y2),
            (x2 - 8 * direction, y2 + 5),
        ]
        self.draw.line([(x * 2, y * 2) for x, y in points], fill=INK, width=4)
        coords = " ".join(f"{x},{y}" for x, y in points)
        self.svg.append(
            f'<polyline points="{escape(coords)}" fill="none" stroke="{INK}" stroke-width="2"/>'
        )

    def card(self, x, y, w, title, detail, color):
        self.box(x, y, w, 87, color)
        self.text(x + 12, y + 12, title, 21)
        self.text(x + 12, y + 49, detail, 18)


def coordinates():
    d = Diagram(530, "A scalar coordinate is expanded before strides are applied")
    d.text(
        32,
        66,
        "L = (2, 4):(4, 1). The first coordinate increases fastest when expanding q.",
    )
    for x, title, scalar in [
        (32, "Logical scalar coordinates q", True),
        (508, "Memory offsets L(row, col)", False),
    ]:
        d.text(x, 115, title, 22)
        for row in range(2):
            for col in range(4):
                d.cell(
                    x + col * 99,
                    160 + row * 50,
                    row + 2 * col if scalar else 4 * row + col,
                    GOLD if (row, col) == (1, 1) else BLUE,
                    93,
                )
        d.text(x, 276, "Rows down; columns right. Gold = (1, 1).", 17)
    d.card(32, 326, 220, "Scalar q = 3", "Expand using shape", BLUE)
    d.arrow(264, 370, 307, 370)
    d.card(320, 326, 270, "Coordinate (1, 1)", "Apply strides: 1*4 + 1", GOLD)
    d.arrow(602, 370, 645, 370)
    d.card(658, 326, 270, "Element offset = 5", "Relative to view base", TEAL)
    d.text(
        32,
        454,
        "For float32: address = base pointer + 5 * 4 bytes = base pointer + 20 bytes.",
    )
    d.text(
        32,
        491,
        "The layout computes a position. A memory view adds the storage pointer.",
    )
    d.save("00-layout-algebra/01-coordinates-and-views/coordinates-and-offsets")


def divide_variants():
    variants = [
        ("logical", "((r, R), (c, C))", "((r, 1), (c, 1))", "((None, 1), (None, 1))"),
        ("zipped", "((r, c), (R, C))", "((r, c), (1, 1))", "(None, (1, 1))"),
        ("tiled", "((r, c), R, C)", "((r, c), 1, 1)", "(None, 1, 1)"),
        ("flat", "(r, c, R, C)", "(r, c, 1, 1)", "(None, None, 1, 1)"),
    ]
    for index, (name, grouping, selected, slicing) in enumerate(variants, 1):
        d = Diagram(630, f"{name}_divide: select the same 2-by-4 window")
        d.text(
            32,
            65,
            "r, c = local row / column; R, C = tile row / column. Cells show original offsets.",
            18,
        )
        d.text(32, 114, "Original matrix (4, 8):(8, 1)", 22)
        for row in range(4):
            for col in range(8):
                d.cell(
                    32 + col * 55,
                    160 + row * 48,
                    8 * row + col,
                    GOLD if row >= 2 and col >= 4 else GRAY,
                    53,
                )
        d.text(508, 114, "Coordinate grouping", 22)
        d.text(508, 163, grouping, 24)
        d.text(508, 217, "Fix tile (R, C) = (1, 1):", 20)
        d.text(508, 258, selected, 23)
        d.text(508, 311, f"Slice: {slicing}", 18)
        d.text(
            32, 379, "Selected view: base offset 20; shape (2, 4); strides (8, 1)", 23
        )
        for row in range(2):
            for col in range(4):
                d.cell(32 + col * 72, 426 + row * 48, 20 + 8 * row + col, GOLD, 69)
        d.text(380, 431, "Thread 6 owns local (1, 2).", 21)
        d.text(380, 477, "Offset = 20 + 1*8 + 2 = 30; loaded value = 130.", 19)
        d.text(
            32,
            556,
            "The row stride stays 8: selecting a window does not pack or copy its values.",
            19,
        )
        d.text(
            32,
            594,
            "Gold marks the selected positions. All four divide variants select these same offsets.",
            18,
        )
        d.save(
            f"00-layout-algebra/05-logical-divide/{index:02d}-{name}/divide-{name}-selection"
        )


def block_tile():
    d = Diagram(560, "Block selects a window; thread selects a position inside it")
    d.text(
        32,
        66,
        "32 source values; tile size 8; launch 4 blocks with 8 threads per block.",
    )
    for block in range(4):
        y = 115 + block * 66
        d.text(32, y + 9, f"Block {block}", 20)
        for local in range(8):
            d.cell(160 + local * 82, y, 8 * block + local, COLORS[block], 77)
    d.text(32, 391, "Cells above show original offsets. Follow block 2, thread 3:", 21)
    d.card(32, 436, 262, "Selected tile base: 16", "Local coordinate: 3", GOLD)
    d.arrow(306, 478, 355, 478)
    d.card(368, 436, 260, "Original offset: 19", "16 + 3 = 19", GOLD)
    d.arrow(640, 478, 681, 478)
    d.card(694, 436, 234, "Loaded value: 119", "source[i] = 100 + i", TEAL)
    d.save("00-layout-algebra/06-select-block-tile/block-tile-selection")


def tiled_copy():
    d = Diagram(610, "One ownership plan connects two separate allocations")
    d.text(
        32,
        66,
        "Four threads; two neighbor values per thread. Color identifies the owner.",
    )
    for y, label in [
        (149, "SOURCE: source[i] = 3*i + 7"),
        (410, "DESTINATION: after fx.copy"),
    ]:
        d.text(32, y - 41, label, 22)
        for offset in range(8):
            x = 32 + offset * 112
            d.cell(x, y, 3 * offset + 7, COLORS[offset // 2], 105)
            d.text(x + 4, y + 53, f"i={offset} / T{offset // 2}", 17)
    d.card(
        32, 251, 315, "partition_S / partition_D", "Describe this thread's views", BLUE
    )
    d.arrow(361, 293, 419, 293)
    d.card(
        432,
        251,
        496,
        "fx.copy moves the values",
        "Thread 2 copies 19 and 22 at offsets 4 and 5",
        GOLD,
    )
    d.text(
        32,
        513,
        "Numbers in cells are DATA VALUES. i labels the offset in each allocation.",
        19,
    )
    d.text(
        32,
        556,
        "Partitioning chooses positions; the copy reads source and writes destination.",
        19,
    )
    d.save("01-gpu-programming/08-tiled-copy/tiled-copy-flow")


def registers():
    d = Diagram(600, "Follow thread 2: load two pairs, add, store one pair")
    d.text(
        32,
        66,
        "Thread 2 owns offsets 4 and 5 in each global view. Boxes below show data values.",
    )
    d.card(32, 127, 380, "Global left: [4, 5]", "left[i] = i", BLUE)
    d.arrow(426, 170, 497, 170)
    d.card(512, 127, 416, "Left fragment: [4, 5]", "fx.copy loads the values", BLUE)
    d.card(32, 248, 380, "Global right: [18, 20]", "right[i] = 2*i + 10", TEAL)
    d.arrow(426, 291, 497, 291)
    d.card(512, 248, 416, "Right fragment: [18, 20]", "fx.copy loads the values", TEAL)
    d.text(512, 362, "Add matching slots: 4+18, 5+20", 22)
    d.card(
        512,
        408,
        416,
        "Reuse left fragment: [22, 25]",
        "Per-thread temporary storage",
        GOLD,
    )
    d.card(32, 408, 380, "Destination offsets 4, 5", "fx.copy stores [22, 25]", PURPLE)
    d.text(
        32,
        527,
        "Allocate fragments before loading: make_fragment_like does not initialize data.",
        19,
    )
    d.text(
        32,
        565,
        "Flow: global inputs -> load -> per-thread arithmetic -> store -> global output.",
        18,
    )
    # Store arrow points left toward the destination.
    d.arrow(500, 452, 425, 452)
    d.save("01-gpu-programming/09-register-fragments/register-fragments-flow")


def tails():
    d = Diagram(670, "A partial tile needs a check for every value slot")
    d.text(
        32,
        66,
        "count = 19; 8 positions per block. Cells show candidate GLOBAL INDICES, not data.",
    )
    for block in range(3):
        y = 118 + block * 95
        d.text(32, y + 7, f"Block {block}", 20)
        for local in range(8):
            index = 8 * block + local
            x = 157 + local * 96
            d.cell(x, y, index, COLORS[local // 2] if index < 19 else GRAY, 90)
            d.text(x + 5, y + 49, "valid" if index < 19 else "skip", 17)
    d.text(
        32,
        418,
        "In block 2, thread 1 owns indices 18 and 19: only its first slot is valid.",
        21,
    )
    d.card(32, 477, 255, "global_index < 19?", "Check before any load", GOLD)
    d.arrow(300, 520, 351, 520)
    d.card(
        364,
        477,
        564,
        "Yes: load left + load right -> add -> store",
        "No: skip both input reads and the output write",
        TEAL,
    )
    d.text(
        32,
        595,
        "Divide 19:1 by 8:1 -> (8,3):(1,8): 24 candidate indices, 19 input values.",
        18,
    )
    d.text(
        32,
        633,
        "Gray positions have no valid input data. Computing their indices does not read memory.",
        18,
    )
    d.save("01-gpu-programming/10-predicates-and-tails/tail-predicates")


def vector_add():
    d = Diagram(595, "A complete launch: 9 elements need two blocks")
    d.text(
        32,
        66,
        "Each block: 4 threads × 2 values = 8 candidate positions. grid = (count + 7) // 8.",
    )
    for block in range(2):
        y = 120 + block * 124
        d.text(32, y + 7, f"Block {block}", 21)
        for local in range(8):
            index = 8 * block + local
            x = 157 + local * 96
            d.cell(x, y, index, COLORS[local // 2] if index < 9 else GRAY, 90)
            d.text(x + 2, y + 50, f"T{local // 2} / V{local % 2}", 17)
    d.text(
        32,
        357,
        "Cells show global indices. In block 1, only T0 / V0 (index 8) passes the check.",
        19,
    )
    d.card(32, 412, 264, "Choose global index", "8*block + 2*thread + slot", BLUE)
    d.arrow(308, 455, 347, 455)
    d.card(360, 412, 210, "Check index < 9", "Per value slot", GOLD)
    d.arrow(582, 455, 621, 455)
    d.card(634, 412, 294, "Read, add, write", "out[i] = left[i] + right[i]", TEAL)
    d.text(
        32,
        536,
        "Every valid index has one owner. Skipped positions perform no input or output access.",
        18,
    )
    d.save("01-gpu-programming/11-vector-addition/vector-add-launch")


def copy_widths():
    d = Diagram(590, "Same four values per thread; change only the copy atom")
    d.text(
        32,
        66,
        "One block: 64 threads × 4 float32 values = 256 elements. Follow thread 2.",
    )
    for y, title, wide in [
        (154, "32-bit atom: one float32 per atom transfer", False),
        (339, "128-bit atom: four float32 values per atom transfer", True),
    ]:
        d.text(32, y - 43, title, 22)
        for slot in range(4):
            d.cell(32 + slot * 112, y, 8 + slot, GOLD, 106)
            d.text(38 + slot * 112, y + 50, f"V{slot}", 18)
        if wide:
            d.box(520, y, 408, 44, TEAL)
            d.text(535, y + 9, "One 16-byte group", 20)
        else:
            for slot in range(4):
                d.cell(520 + slot * 103, y, "4 B", BLUE, 97)
        d.text(520, y + 55, "Requested grouping; inspect final instructions.", 17)
    d.text(
        32,
        451,
        "Cells on the left show offsets 8, 9, 10, 11. Ownership is identical in both variants.",
        18,
    )
    d.text(
        32,
        494,
        "Check correctness -> compile and warm up -> time GPU events -> compare medians.",
        18,
    )
    d.text(
        32,
        537,
        "Inspect the ISA separately. A wider request does not by itself prove a faster copy.",
        18,
    )
    d.save("01-gpu-programming/12-inspect-and-tune/copy-width-comparison")


if __name__ == "__main__":
    for draw in [
        coordinates,
        divide_variants,
        block_tile,
        tiled_copy,
        registers,
        tails,
        vector_add,
        copy_widths,
    ]:
        draw()
    print("Generated 11 SVG lesson diagrams and their PNG previews in assets/.")
