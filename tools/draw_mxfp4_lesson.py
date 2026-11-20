"""Draw the packed suffix used by the fused MXFP4 lesson."""

from draw_lesson_visuals import BLUE, GOLD, TEAL, Diagram
from draw_wave_tiles import describe

BASE = "01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16"


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


if __name__ == "__main__":
    draw()
