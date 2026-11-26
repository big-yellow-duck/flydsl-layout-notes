"""Draw the MXFP4 block scales, scalar decode, fused suffix, and register lookup."""

from draw_lesson_visuals import BLUE, GOLD, TEAL, Diagram
from draw_wave_tiles import describe, down_arrow

BASE = "01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16"


def block_scales():
    d = Diagram(380, "One scale per column in each K block")
    describe(
        d,
        "B has 33 rows and 3 columns. Each group of up to 32 K rows has "
        "one scale per column. In column 1, scale bytes 127 and 126 "
        "decode to multipliers 1 and 0.5.",
    )
    d.text(
        32,
        70,
        "B has shape (33, 3). The cells show E8M0 bytes and their multipliers.",
        21,
    )
    for column in range(3):
        d.text(334 + column * 194, 124, f"Column {column}", 21)
    for block, (label, values) in enumerate(
        (
            ("K rows 0–31", ("128 to 2", "127 to 1", "126 to 0.5")),
            ("K row 32", ("129 to 4", "126 to 0.5", "125 to 0.25")),
        )
    ):
        y = 180 + block * 64
        d.text(32, y + 7, label, 22)
        for column, value in enumerate(values):
            d.cell(310 + column * 194, y, value, GOLD if column == 1 else BLUE, 178)
    d.text(
        32,
        319,
        "In column 1, code 0x1 (0.5) gives 0.5 in block 0 and 0.25 in block 1.",
        21,
    )
    d.save(f"{BASE}/01-mxfp4-format/block-scales")


def scalar_decode():
    d = Diagram(403, "One thread decodes B[32, 1]")
    describe(
        d,
        "Block 1, thread 33 owns weight index 97. The high nibble of packed "
        "byte 48 gives code 0x1. Scale byte 126 at (1,1) multiplies the code's "
        "value 0.5 by 0.5. The thread writes 0.25 to B at (32,1).",
    )
    d.text(32, 70, "Block 1, thread 33 owns flat index 1 × 64 + 33 = 97.", 23)
    d.card(
        32,
        123,
        425,
        "Read packed byte 48",
        "0x10 gives high nibble 0x1 (value 0.5)",
        GOLD,
    )
    d.card(
        499, 123, 426, "Read scales[1, 1]", "126 gives scale 2^(126 − 127) = 0.5", GOLD
    )
    down_arrow(d, 244, 213, 236)
    down_arrow(d, 712, 213, 236)
    d.card(
        32,
        240,
        893,
        "Write B[32, 1] = 0.5 × 0.5 = 0.25",
        "The decoded value is stored in BF16.",
        TEAL,
    )
    d.text(32, 357, "Stage 15 reads the decoded (33, 3) matrix as its B operand.", 21)
    d.save(f"{BASE}/02-scalar-dequant/scalar-decode")


def draw():
    d = Diagram(634, "14.1 - Decode five packed B values at the physical edge")
    describe(
        d,
        "The last row of B starts the N=72 suffix on the high nibble of byte 1768. Three packed bytes and five block-scale bytes decode into BF16 for the LDS tile.",
    )
    d.text(32, 68, "Follow B[45, 72:77] in the 17 x 77 x 46 example.", 23)
    d.card(32, 122, 331, "Packed bytes 1768–1770", "0xe8, 0x68, 0x52", GOLD)
    d.card(
        378,
        122,
        547,
        "Load 2 bytes, then 1 byte",
        "Shift right by 4 bits to start at nibble 3537.",
        BLUE,
    )
    d.arrow(365, 166, 376, 166)
    d.text(32, 232, "K block 1 supplies five scale bytes at offsets 149–153.", 21)
    d.text(32, 269, "Load four scale bytes and one scale byte.", 18)

    rows = [
        ("N column", (72, 73, 74, 75, 76), BLUE),
        ("E2M1 code", ("0xe", "0x8", "0x6", "0x2", "0x5"), GOLD),
        ("E8M0 byte", (125, 125, 125, 126, 126), GOLD),
        ("Decoded BF16", ("−1.0", "−0.0", "1.0", "0.5", "1.5"), TEAL),
    ]
    for row, (title, items, color) in enumerate(rows):
        y = 312 + row * 52
        d.text(32, y + 8, title, 20)
        for col, value in enumerate(items):
            d.cell(256 + col * 132, y, value, color, 124)

    d.text(
        32,
        547,
        "Write the decoded vector into B's LDS tile. The C store stops at N = 77.",
        20,
    )
    d.text(
        32,
        583,
        "C[16, 76] accumulates across all 46 K values and rounds to 2.28125.",
        18,
    )
    d.save(f"{BASE}/mxfp4-w4a16")


def register_lookup():
    d = Diagram(464, "Two register lookups decode the magnitudes of eight weights")
    describe(
        d,
        "Packed bytes 0x91, 0xb2, 0xd4, and 0xf6 supply even selectors "
        "1, 2, 4, 6 and odd selectors 1, 3, 5, 7. The register table returns "
        "doubled magnitudes 1, 2, 4, 8 and 1, 3, 6, 12 respectively.",
    )
    d.text(
        32,
        68,
        "Register table [0, 1, 2, 3 | 4, 6, 8, 12] stores twice each magnitude.",
        21,
    )
    rows = (
        ("Packed bytes", ("0x91", "0xb2", "0xd4", "0xf6"), BLUE),
        ("Even selectors", (1, 2, 4, 6), GOLD),
        ("Even table bytes", (1, 2, 4, 8), TEAL),
        ("Odd selectors", (1, 3, 5, 7), GOLD),
        ("Odd table bytes", (1, 3, 6, 12), TEAL),
    )
    for row, (label, values, color) in enumerate(rows):
        y = 121 + row * 56
        d.text(32, y + 9, label, 21)
        for column, value in enumerate(values):
            d.cell(286 + column * 156, y, value, color, 146)
    d.text(
        32,
        415,
        "Interleave even and odd results, then apply each original sign and scale.",
        21,
    )
    d.save(f"{BASE}/04-lut-decode/register-lookup")


if __name__ == "__main__":
    block_scales()
    scalar_decode()
    draw()
    register_lookup()
