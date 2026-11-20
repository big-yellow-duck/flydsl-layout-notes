"""Draw the A and B scale lookups in the fused MXFP8 lesson."""

from draw_lesson_visuals import BLUE, GOLD, TEAL, Diagram
from draw_wave_tiles import describe

BASE = "01-gpu-programming/14-quantized-matmul/02-mxfp8-blockscale"


def draw():
    d = Diagram(558, "14.2 - Two scale lookups for one MXFP8 product")
    describe(
        d,
        "K coordinate 44 lies in the second MX block of A and B. A row 16 uses scale 119 and B column 76 uses scale 120. The decoded BF16 pair contributes 0.765625 to C[16,76].",
    )
    d.text(32, 69, "Follow K = 44 in the dot product for C[16, 76].", 23)
    d.text(32, 109, "Both operands select K block 44 // 32 = 1.", 20)

    for y, value_title, raw, scale_title, scale, decoded in (
        (
            158,
            "A[16, 44]",
            "Byte 780 = 0x7e",
            "A scale[16, 1]",
            "Byte 33 = 119",
            "448 × 2⁻⁸ = 1.75",
        ),
        (
            279,
            "B[44, 76]",
            "Byte 3464 = 0x66",
            "B scale[1, 76]",
            "Byte 153 = 120",
            "56 × 2⁻⁷ = 0.4375",
        ),
    ):
        d.card(32, y, 232, value_title, raw, BLUE)
        d.text(280, y + 27, "+", 22)
        d.card(315, y, 252, scale_title, scale, GOLD)
        d.arrow(581, y + 44, 622, y + 44)
        d.card(639, y, 286, "BF16 staging value", decoded, TEAL)

    d.text(32, 423, "This K coordinate contributes 1.75 × 0.4375 = 0.765625.", 21)
    d.text(
        32, 462, "WMMA accumulates the 46 terms in FP32. BF16 C[16, 76] is 2.40625.", 20
    )
    d.text(
        32,
        506,
        "A's scale is shared along a row. B's scale is shared down a column.",
        18,
    )
    d.save(f"{BASE}/blockscale-lookups")


if __name__ == "__main__":
    draw()
