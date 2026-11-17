"""Draw the fused MXFP4 W4A16 path used by lesson 14.1."""

from draw_lesson_visuals import BLUE, GOLD, TEAL, Diagram
from draw_wave_tiles import describe

BASE = "01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16"


def draw():
    d = Diagram(820, "14.1 - Fuse MXFP4 decode into W4A16 matmul")
    describe(
        d,
        "OCP MXFP4 stores two E2M1 values per byte and one E8M0 scale per 32 K values in each output column. The gfx1152 kernel decodes packed B words into BF16 registers and stages each tile in LDS before WMMA consumes it.",
    )
    d.text(32, 68, "Packed B tile: K values are grouped in blocks of 32", 23)
    d.card(32, 150, 230, "PACKED + SCALE", "0x32; E8M0 byte 127", GOLD)
    d.arrow(270, 193, 286, 193)
    d.card(298, 150, 208, "DECODE", "8 BF16 register values", BLUE)
    d.arrow(514, 201, 562, 201)
    d.card(575, 150, 210, "BF16 B TILE", "one 128-bit LDS store", TEAL)

    d.text(32, 365, "Stage B while the WMMA tile is being computed", 23)
    d.card(32, 410, 220, "ACTIVATION A", "BF16; registers or LDS", GOLD)
    d.arrow(262, 454, 702, 454)
    d.card(32, 530, 190, "PACKED B", "coalesced global reads", BLUE)
    d.card(267, 530, 190, "DECODE", "private BF16 registers", BLUE)
    d.card(502, 530, 190, "LDS", "private B tile", TEAL)
    d.arrow(232, 574, 257, 574)
    d.arrow(467, 574, 492, 574)
    d.arrow(680, 574, 702, 500)
    d.card(715, 410, 210, "WMMA", "FP32 sum; BF16 C", GOLD)
    d.text(
        32,
        645,
        "BF16 exists only in the LDS tile; the full (K,N) matrix is never materialized.",
        17,
    )
    d.text(
        32,
        690,
        "32 packed values use 16 data bytes plus one scale byte; as BF16 they use 64 bytes.",
        17,
    )
    d.text(
        32,
        735,
        "The fused path uses BF16 WMMA, not native MXFP4 matrix instructions.",
        17,
    )
    d.save(f"{BASE}/mxfp4-w4a16")


if __name__ == "__main__":
    draw()
