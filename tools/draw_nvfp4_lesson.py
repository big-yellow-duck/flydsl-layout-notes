"""Reproduce the NVFP4 lesson figures."""

from draw_lesson_visuals import BLUE, GOLD, TEAL, Diagram
from draw_wave_tiles import describe

BASE = "01-gpu-programming/14-quantized-matmul/03-nvfp4-w4a16"


def scale_boundary():
    d = Diagram(330, "A K-block boundary changes the block scale")
    describe(d, "Two equal FP4 codes in column 1 decode to 0.5 and 0.75.")
    d.text(32, 73, "Column 1 of B has tensor scale 0.5 in both blocks.", 22)
    d.card(
        32, 127, 433, "B[15, 1] uses scale row 0", "Code 0x2 = 1. Scale 0x38 = 1.", BLUE
    )
    d.card(
        493,
        127,
        433,
        "B[16, 1] uses scale row 1",
        "Code 0x2 = 1. Scale 0x3c = 1.5.",
        GOLD,
    )
    d.text(46, 250, "BF16 result   1 × 1 × 0.5 = 0.5", 22)
    d.text(507, 250, "BF16 result   1 × 1.5 × 0.5 = 0.75", 22)
    d.save(f"{BASE}/01-nvfp4-format/scale-boundary")


def one_weight():
    d = Diagram(390, "One GPU thread decodes B[16, 1]")
    describe(d, "Thread 17 of block 2 reads a packed nibble and two scale values.")
    d.text(32, 72, "Block 2, thread 17 owns flat index 145.", 22)
    d.card(32, 125, 276, "Packed byte 72", "0x29 gives high nibble 0x2", GOLD)
    d.card(341, 125, 270, "Block scale [1, 1]", "E4M3 byte 0x3c gives 1.5", GOLD)
    d.card(644, 125, 281, "Tensor scale [0]", "FP32 value 0.5", BLUE)
    d.card(
        32,
        261,
        893,
        "Store B[16, 1] = 1 × 1.5 × 0.5 = 0.75",
        "Round to BF16 for stage 15.",
        TEAL,
    )
    d.save(f"{BASE}/02-scalar-dequant/one-weight")


def scale_ownership():
    d = Diagram(410, "A 32-row stage spans two NVFP4 blocks")
    describe(d, "Lane 0 owns columns 0 through 7 and four K slots per block.")
    d.text(32, 71, "Lane 0 owns B columns 0 through 7.", 22)
    for i, (label, ks, color) in enumerate(
        (
            ("Scale word from row 0", (0, 4, 8, 12), BLUE),
            ("Scale word from row 1", (16, 20, 24, 28), GOLD),
        )
    ):
        y = 126 + i * 100
        d.text(32, y + 8, label, 20)
        for j, k in enumerate(ks):
            d.cell(305 + j * 143, y, k, color if k < 17 else "#e2e8f0", 134)
        d.text(
            306,
            y + 52,
            "All four K slots are valid."
            if i == 0
            else "K = 17. Slots 20, 24, and 28 publish zeros.",
            18,
        )
    d.text(
        32,
        346,
        "The cells show K coordinates, and each scale word holds eight column scales.",
        19,
    )
    d.save(f"{BASE}/03-fused-staging/scale-ownership")


def register_lookup():
    d = Diagram(420, "Two register lookups expand eight E2M1 magnitudes")
    describe(d, "Four packed bytes give two sets of selectors and FP32 magnitude bytes.")
    d.text(32, 66, "Packed B values for row 16, columns 0 through 7.", 21)
    rows = (
        ("Packed bytes", ("0x29", "0x43", "0x65", "0xf7"), BLUE),
        ("Even selectors", (1, 3, 5, 7), GOLD),
        ("Even table bytes", ("0xfc", "0xff", "0x01", "0x03"), TEAL),
        ("Odd selectors", (2, 4, 6, 7), GOLD),
        ("Odd table bytes", ("0xfe", "0x00", "0x02", "0x03"), TEAL),
    )
    for i, (label, values, color) in enumerate(rows):
        y = 108 + i * 52
        d.text(32, y + 8, label, 20)
        for j, val in enumerate(values):
            d.cell(290 + j * 150, y, val, color, 140)
    d.text(
        32,
        378,
        "Rebuild signed FP32 weights, then apply the block scale and tensor scale.",
        19,
    )
    d.save(f"{BASE}/04-lut-decode/lookup")


def decoded_scale_reuse():
    d = Diagram(419, "Decode one scale word and publish its owned K slots")
    describe(
        d,
        "Lane 0 decodes eight FP32 scales for each scale slot. Slot 0 supplies K rows 0, 4, 8, 12. Slot 1 supplies row 16 and three padded slots.",
    )
    d.text(32, 69, "Lane 0, B columns 0 through 7. Cells show K coordinates.", 21)
    for i, (color, coordinates) in enumerate(
        ((BLUE, (0, 4, 8, 12)), (GOLD, (16, 20, 24, 28)))
    ):
        y = 123 + i * 111
        d.card(
            32,
            y,
            350,
            f"Decode scale slot {i}",
            "Keep eight FP32 scales in registers.",
            color,
        )
        d.arrow(388, y + 42, 427, y + 42)
        for j, k in enumerate(coordinates):
            d.cell(447 + j * 117, y + 23, k, color if k < 17 else "#e2e8f0", 106)
    d.text(32, 359, "For K = 17, rows 20, 24, and 28 publish zeros.", 20)
    d.save(f"{BASE}/05-scale-reuse/decoded-scale-reuse")


if __name__ == "__main__":
    scale_boundary()
    one_weight()
    scale_ownership()
    register_lookup()
    decoded_scale_reuse()
