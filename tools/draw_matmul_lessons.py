"""Reproduce the BF16 matmul lesson SVG/PNG pairs (requires Pillow)."""

from draw_divide_comparison import COLORS, Figure
from draw_lesson_visuals import Diagram

BASE = "01-gpu-programming/13-matmul"
BLUE, TEAL, GOLD, PURPLE = COLORS


def strip(fig, y, values, highlight=1):
    for i, value in enumerate(values):
        fig.cell(64 + i * 52, y, value, GOLD if i == highlight else BLUE, 52)


def naive():
    f = Figure(510, "00 - One thread computes one BF16 output")
    f.text(
        32,
        66,
        "A, B, C: (1024,1024). Zoom: first 16 K positions; cells are INPUT VALUES.",
    )
    f.text(32, 112, "A row 0: A[0,k], k increases to the right")
    strip(f, 148, [k % 5 - 2 for k in range(16)])
    f.text(32, 218, "B column 1: B[k,1], k increases to the right")
    strip(f, 254, [(k * 1024 + 1) % 7 - 3 for k in range(16)])
    f.text(
        32,
        326,
        "First 16 pairs contribute 4. The full dot product uses all 1,024 pairs.",
        22,
    )
    f.text(
        32, 373, "Block (0,0), thread 16 owns C[0,1]. Output offset = 0 * 1024 + 1 = 1."
    )
    f.text(32, 418, "BF16 loads -> FP32 multiplication and accumulation -> BF16 store")
    f.text(
        32,
        460,
        "Gold marks k=1: (-1) * 0 = 0. This is a tile zoom of the 1024 x 1024 workload.",
        17,
    )
    f.save(f"{BASE}/00-naive/dot-product")


def coalesced():
    f = Figure(530, "01 - Change thread ownership to change neighboring accesses")
    f.text(32, 66, "A 16 x 16 block tile. Labels are THREAD IDS, not matrix values.")
    f.text(32, 113, "Before: row = tid % 16, column = tid // 16")
    for r in range(2):
        for c in range(8):
            f.cell(64 + c * 100, 151 + r * 47, r + c * 16, BLUE, 100)
    f.text(32, 265, "After: row = tid // 16, column = tid % 16")
    for r in range(2):
        for c in range(8):
            f.cell(64 + c * 100, 303 + r * 47, r * 16 + c, TEAL, 100)
    f.text(32, 416, "At fixed k, lanes 0..15 read B[k,0..15]: adjacent BF16 elements.")
    f.text(
        32,
        459,
        "Shown: rows 0..1 and columns 0..7. Both kernels cover the full 16 x 16 tile.",
        17,
    )
    f.save(f"{BASE}/01-coalesced-access/thread-order")


def registers():
    f = Diagram(550, "02 - Reuse one B value across four output rows")
    f.text(32, 66, "64 threads per block; thread 1 owns rows 0,1,2,3 at column 1.")
    f.card(32, 120, 260, "Load B[k,1] once", "One FP32 register value", TEAL)
    for row in range(4):
        y = 235 + row * 61
        f.box(32, y, 255, 45, BLUE)
        f.text(44, y + 10, f"Load A[{row},k]", 19)
        f.arrow(297, y + 22, 350, y + 22)
        f.box(365, y, 550, 45, GOLD)
        f.text(380, y + 10, f"acc[{row}] += A[{row},k] * B[k,1]", 19)
    f.text(
        32,
        505,
        "Four FP32 accumulators survive across K. Convert each final result to BF16.",
        17,
    )
    f.save(f"{BASE}/02-register-tiling/register-reuse")


def shared():
    f = Diagram(570, "03 - Stage a K tile once, then share it within the block")
    f.text(32, 66, "Each K step covers 16 columns of A and 16 rows of B.")
    f.card(32, 119, 410, "A block: 16 x 16 BF16", "512 bytes in global memory", BLUE)
    f.card(515, 119, 410, "B block: 16 x 16 BF16", "512 bytes in global memory", TEAL)
    f.text(195, 228, "stage to LDS", 17)
    f.text(678, 228, "stage to LDS", 17)
    f.box(32, 270, 893, 65, GOLD)
    f.text(
        48,
        282,
        "LDS: 1,024 bytes total. Thread t loads offsets t, t+64, t+128, t+192.",
        18,
    )
    f.box(32, 365, 893, 65, PURPLE)
    f.text(
        48,
        379,
        "Barrier -> consume 16 K values -> barrier -> overwrite for next K tile",
        19,
    )
    f.text(
        32,
        466,
        "Thread 1 still updates C[0..3,1]; ownership is unchanged from lesson 02.",
    )
    f.text(
        32,
        511,
        "The second barrier protects readers from early writes by another wave.",
        18,
    )
    f.save(f"{BASE}/03-shared-memory/lds-staging")


def matrix():
    f = Diagram(650, "04 - A wave32 owns one 16 x 16 WMMA result")
    f.text(
        32, 66, "gfx11 BF16 WMMA: 32 lanes cooperate on a 16 x 16 x 16 multiplication."
    )
    f.card(32, 115, 410, "A operand view: (M,K)", "LDS strides (16,1)", BLUE)
    f.card(515, 115, 410, "B operand view: (N,K)", "LDS strides (1,16)", TEAL)
    f.text(
        32,
        227,
        "Both lane halves load replicated A/B fragments: 16 BF16 values per lane.",
        18,
    )
    f.text(32, 270, "C ownership: column = lane % 16; row = 2 * slot + lane // 16", 20)
    for row in range(4):
        f.text(32, 322 + row * 47, f"r{row}", 17)
        for col in range(8):
            lane = col + (row % 2) * 16
            f.cell(
                85 + col * 100,
                311 + row * 47,
                f"L{lane}",
                GOLD if col == 1 else PURPLE,
                100,
            )
    f.text(
        32,
        523,
        "Shown: output rows 0..3, columns 0..7. Labels identify owning LANES.",
        17,
    )
    f.text(
        32,
        562,
        "Lane 1 owns rows 0,2,...,14 at column 1: eight FP32 accumulator slots.",
        18,
    )
    f.text(
        32,
        603,
        "Replicated inputs are intentional; every output still has a unique writer.",
        18,
    )
    f.save(f"{BASE}/04-matrix-instructions/wave-fragments")


def main():
    naive()
    coalesced()
    registers()
    shared()
    matrix()


if __name__ == "__main__":
    main()
