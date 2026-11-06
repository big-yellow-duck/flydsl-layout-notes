"""Draw the mixed operand path and its exact native-copy walkthrough."""

from draw_lesson_visuals import BLUE, GOLD, TEAL, Diagram
from draw_wave_tiles import describe

BASE = "01-gpu-programming/13-matmul/12-operand-paths"


def paths():
    d = Diagram(740, "12 - Choose the memory path for each operand")
    describe(
        d,
        "A 32 by 64 by 64 block keeps A in private WMMA-compatible register fragments. B uses coalesced 128-bit global loads, a private staging fragment, packed LDS, then WMMA-compatible LDS reads. Only B uses the 8192-byte shared tile. All compute waves perform their own loading and WMMA.",
    )
    d.text(
        32,
        68,
        "Walkthrough: M=32, N=1024, K=8192; block 32 x 64 x 64; two wave32 groups.",
        19,
    )
    d.text(32, 118, "A: contiguous K values already fit each WMMA thread's operand", 23)
    for x, w, title, detail in (
        (32, 200, "GLOBAL A", "Row-major; K stride 1"),
        (286, 260, "NEXT A REGISTERS", "128-bit reads; MMA plan"),
        (602, 323, "CURRENT A REGISTERS", "Select one K=16 fragment"),
    ):
        d.card(x, 172, w, title, detail, GOLD)
    d.arrow(240, 215, 276, 215)
    d.arrow(554, 215, 592, 215)
    d.text(
        32,
        291,
        "A values stay private. Other N waves and duplicate lanes can read the same input.",
        19,
    )
    d.text(
        32,
        350,
        "B: keep global loads contiguous along N, then redistribute through LDS",
        22,
    )
    for x, w, title, detail in (
        (32, 190, "GLOBAL B", "N stride 1"),
        (263, 194, "COPY REGISTERS", "128-bit B loads"),
        (498, 190, "PACKED LDS", "8192 bytes; B only"),
        (729, 196, "WMMA B", "K is strided in LDS"),
    ):
        d.card(x, 403, w, title, detail, BLUE if x < 498 else TEAL)
    for x1, x2 in ((230, 253), (465, 488), (696, 719)):
        d.arrow(x1, 447, x2, 447)
    d.text(
        32,
        525,
        "Different copy owners stage B; the WMMA plan selects each compute thread's values.",
        19,
    )
    d.card(
        32,
        580,
        893,
        "Same matrix instruction, FP32 accumulation, and single-kernel split-K finalizer",
        "All waves load and compute. Workgroup barriers protect the shared B tile.",
        GOLD,
    )
    d.text(
        32,
        702,
        "The wide workload can select A-through-LDS when its measured time is lower.",
        20,
    )
    d.save(f"{BASE}/operand-paths")


def trace():
    d = Diagram(830, "12 - Follow thread 3 through the two operand paths")
    describe(
        d,
        "For block zero and inner K slice one, thread three reads A row three at K sixteen through twenty-three. Global element offsets are 24592 through 24599, and trace values are zero, one, two, minus two, minus one, zero, one, two. Its B staging copy loads columns twenty-four through thirty-one of global row zero. Its WMMA B reads instead use LDS offsets 1027, 1091, 1155 and onward, separated by sixty-four BF16 elements.",
    )
    d.text(
        32,
        67,
        "Physical block 0, split 0, local K tile 0, inner_k=1; compute thread 3.",
        20,
    )
    d.text(32, 117, "A row 3, K=16..23: offset = 3*8192 + K (BF16 elements)", 23)
    for i in range(8):
        x = 32 + 112 * i
        d.box(x, 167, 106, 105, GOLD)
        d.text(x + 12, 180, str(24592 + i), 21)
        d.text(x + 12, 229, f"value {(24592 + i) % 5 - 2}", 18)
    d.text(
        32,
        300,
        "One 128-bit copy reads these eight BF16 values. The next copy reads K=24..31.",
        19,
    )
    d.text(
        32,
        340,
        "First element: 24592 elements * 2 bytes = 49184-byte displacement from A's base.",
        19,
    )
    d.text(32, 401, "B staging owner 3: global row 0, columns 24..31", 23)
    for i in range(8):
        x = 32 + 112 * i
        d.box(x, 446, 106, 58, BLUE)
        d.text(x + 29, 463, str(24 + i), 22)
    d.text(
        32,
        530,
        "Cells show global element offsets. This contiguous N vector is written to packed LDS.",
        19,
    )
    d.text(32, 589, "WMMA consumer 3: B at local K=16..23, column 3", 23)
    for i in range(8):
        x = 32 + 112 * i
        d.box(x, 634, 106, 58, TEAL)
        d.text(x + 24, 651, str(1027 + 64 * i), 22)
    d.text(
        32,
        718,
        "Cells show LDS element offsets: 16*64+3, 17*64+3, ...; K stride is 64 elements.",
        19,
    )
    d.text(
        32,
        773,
        "Native ownership.py checks all 14336 offsets, including the duplicated A owners.",
        20,
    )
    d.save(f"{BASE}/operand-trace")


if __name__ == "__main__":
    paths()
    trace()
