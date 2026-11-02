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
        32, 373, "Block (0,0), thread 1 owns C[0,1]. Output offset = 0 * 1024 + 1 = 1."
    )
    f.text(32, 418, "BF16 loads -> FP32 multiplication and accumulation -> BF16 store")
    f.text(
        32,
        460,
        "Gold marks k=1: (-1) * 0 = 0. This is a tile zoom of the 1024 x 1024 workload.",
        17,
    )
    f.save(f"{BASE}/00-naive/dot-product")


def naive_views():
    f = Diagram(740, "00 - Native views select a block, then one thread's dot product")
    f.text(
        32, 66, "Fixed workload: A, B, C are 1024 x 1024. Labels below are view SHAPES."
    )
    f.card(32, 112, 410, "left_global_view", "(1024,1024), strides (1024,1)", BLUE)
    f.card(515, 112, 410, "right_global_view", "(1024,1024), strides (1024,1)", TEAL)
    f.text(32, 225, "flat_divide(left, (16,K))", 20)
    f.text(515, 225, "flat_divide(right, (K,16))", 20)
    f.card(32, 268, 410, "left_tiled_view", "(16,1024,64,1)", BLUE)
    f.card(515, 268, 410, "right_tiled_view", "(1024,16,1,64)", TEAL)
    f.text(32, 380, "Select tile row 2, column 0", 19)
    f.text(515, 380, "Select tile row 0, column 1", 19)
    f.card(
        32, 422, 410, "left_block_view: (16,1024)", "Global A rows 32..47; all K", BLUE
    )
    f.card(
        515,
        422,
        410,
        "right_block_view: (1024,16)",
        "All K; global B columns 16..31",
        TEAL,
    )
    f.text(
        32, 537, "Thread 17 -> local coordinate (1,1) in the 16 x 16 thread layout.", 20
    )
    f.text(
        32,
        580,
        "left_row: shape 1024, stride 1. right_column: shape 1024, stride 1024.",
        18,
    )
    f.box(32, 625, 893, 75, GOLD)
    f.text(48, 638, "Reduce A[33,k] * B[k,17] for k=0..1023, then store C[33,17].", 19)
    f.text(
        48,
        670,
        "out_block_view[1,1] carries the selected block base; output offset = 33809.",
        17,
    )
    f.save(f"{BASE}/00-naive/view-hierarchy")


def naive_block_windows():
    f = Diagram(560, "Step 1 - One block selects matching windows from A, B, and C")
    f.text(
        32,
        66,
        "Block (x,y)=(1,2): output tile row 2, tile column 1. Full matrices: 1024 x 1024.",
        18,
    )
    f.text(
        32,
        105,
        "Each cell below represents a 16 x 16 tile. Only tile rows/columns 0..3 are shown.",
        17,
    )
    for x, title, mode in [
        (32, "A: left_global_view", "A"),
        (350, "B: right_global_view", "B"),
        (668, "C: out_global_view", "C"),
    ]:
        f.text(x, 150, title, 19)
        for col in range(4):
            f.text(x + 38 + col * 50, 188, str(col), 16)
        for row in range(4):
            f.text(x, 228 + row * 47, str(row), 16)
            for col in range(4):
                selected = (
                    row == 2
                    if mode == "A"
                    else col == 1
                    if mode == "B"
                    else (row, col) == (2, 1)
                )
                color = BLUE if mode == "A" else TEAL if mode == "B" else GOLD
                f.cell(
                    x + 25 + col * 50,
                    217 + row * 47,
                    "*" if selected else "",
                    color if selected else "#ffffff",
                    50,
                )
    f.text(32, 425, "A: rows 32..47, all K", 18)
    f.text(350, 425, "B: all K, columns 16..31", 18)
    f.text(668, 425, "C: rows 32..47, cols 16..31", 17)
    f.text(
        32,
        477,
        "The blue and green bands each span all 1024 K positions; these cells are a visual zoom.",
        17,
    )
    f.text(
        32, 515, "A window: 16 x 1024. B window: 1024 x 16. Output window: 16 x 16.", 18
    )
    f.save(f"{BASE}/00-naive/block-windows")


def naive_flat_modes():
    f = Diagram(590, "Steps 2-3 - Four modes become one selected two-dimensional view")
    f.text(32, 66, "out_tiled_view = flat_divide(out_global_view, (16,16))", 21)
    labels = ["local row", "local column", "tile row", "tile column"]
    for i, (label, extent, coord) in enumerate(
        zip(labels, [16, 16, 64, 64], ["None", "None", "2", "1"])
    ):
        x = 32 + i * 230
        f.box(x, 123, 207, 107, BLUE if i < 2 else GOLD)
        f.text(x + 12, 136, label, 20)
        f.text(x + 12, 179, f"extent {extent}", 19)
        f.box(x, 270, 207, 73, BLUE if i < 2 else GOLD)
        f.text(x + 12, 283, coord, 23)
        f.text(x + 12, 316, "keep this mode" if i < 2 else "fix this tile", 15)
    f.text(32, 382, "out_block_view = slice(out_tiled_view, (None, None, 2, 1))", 21)
    f.card(
        32,
        438,
        893,
        "Result: shape (16,16), strides (1024,1)",
        "Two None entries keep local coordinates; fixed tile coordinates select the base.",
        TEAL,
    )
    f.text(
        32,
        550,
        "A smaller view still uses the original matrix row stride. No data has been copied.",
        17,
    )
    f.save(f"{BASE}/00-naive/flat-modes")


def naive_thread_map():
    f = Diagram(580, "Steps 4-5 - Thread 17 owns local output coordinate (1,1)")
    f.text(32, 66, "thread_layout = make_ordered_layout((16,16), (1,0))", 21)
    f.text(
        32,
        107,
        "Cells contain THREAD IDS. Local columns run left to right; local rows run downward.",
        17,
    )
    for col in range(16):
        f.text(90 + col * 52, 148, str(col), 14)
    for row in range(4):
        f.text(32, 190 + row * 47, f"r{row}", 17)
        for col in range(16):
            f.cell(
                80 + col * 52,
                179 + row * 47,
                row * 16 + col,
                GOLD if (row, col) == (1, 1) else BLUE,
                52,
            )
    f.text(
        32, 388, "Rows 0..3 shown; the complete layout has 16 rows and 256 threads.", 17
    )
    f.text(32, 430, "idx2crd(17, thread_layout) -> (1,1)", 23)
    f.text(
        32,
        477,
        "Local row 1 selects left_row; local column 1 selects right_column.",
        19,
    )
    f.text(32, 522, "Block (1,2): global output = (32+1,16+1) = (33,17).", 21)
    f.save(f"{BASE}/00-naive/thread-map")


def naive_scalar_steps():
    f = Diagram(
        650, "Step 6 - Match one A value and one B value at each inner position"
    )
    f.text(
        32,
        66,
        "Block (1,2), thread 17: A row 33 and B column 17. Cells contain VALUES.",
        18,
    )
    inner_values = list(range(6))
    left = [(33 * 1024 + i) % 5 - 2 for i in inner_values]
    right = [(i * 1024 + 17) % 7 - 3 for i in inner_values]
    products = [a * b for a, b in zip(left, right)]
    partial = []
    for product in products:
        partial.append((partial[-1] if partial else 0) + product)
    for col, inner in enumerate(inner_values):
        f.text(285 + col * 100, 118, f"inner={inner}", 16)
    for row, (label, values, color) in enumerate(
        [
            ("left_row[inner]", left, BLUE),
            ("right_column[inner]", right, TEAL),
            ("a * b (FP32)", products, GOLD),
            ("accumulator (FP32)", partial, PURPLE),
        ]
    ):
        y = 158 + row * 80
        f.text(32, y + 10, label, 18)
        for col, value in enumerate(values):
            f.cell(280 + col * 100, y, value, color, 90)
    f.text(32, 492, "After inner=5, accumulator=-3. Keep going through inner=1023.", 20)
    result = sum(
        ((33 * 1024 + i) % 5 - 2) * ((i * 1024 + 17) % 7 - 3) for i in range(1024)
    )
    f.text(
        32,
        536,
        f"Final accumulator={result}; convert once to BF16 and store out_block_view[(1,1)].",
        18,
    )
    f.text(
        32,
        585,
        "left_row strides by 1 element; right_column strides by 1024 elements.",
        18,
    )
    f.save(f"{BASE}/00-naive/scalar-steps")


def coalesced():
    f = Figure(530, "01 - Change thread ownership to change neighboring accesses")
    f.text(32, 66, "A 16 x 16 block tile. Labels are THREAD IDS, not matrix values.")
    f.text(32, 113, "Alternative: row = tid % 16, column = tid // 16")
    for r in range(2):
        for c in range(8):
            f.cell(64 + c * 100, 151 + r * 47, r + c * 16, BLUE, 100)
    f.text(32, 265, "Supplied: row = tid // 16, column = tid % 16")
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


def register_thread_windows():
    f = Diagram(630, "02 - A thread selects a 4 x 1 output window with native division")
    f.text(
        32,
        66,
        "Block (1,2), thread 17: thread_coordinate=(1,1) in a (4,16) thread layout.",
        18,
    )
    f.text(32, 112, "out_thread_tiled_view = flat_divide(out_block_view, (4,1))", 21)
    f.text(
        32,
        154,
        "Shape (4,1,4,16): (local row, local column, row group, column group)",
        18,
    )
    f.text(32, 199, "slice(..., (None,None,1,1)) -> out_thread_view: shape (4,1)", 20)
    f.text(
        32,
        244,
        "Crop of output block: local rows 4..7, columns 0..7. Labels are local coordinates.",
        17,
    )
    for r in range(4):
        for c in range(8):
            f.cell(
                64 + c * 103,
                285 + r * 47,
                f"({r + 4},{c})",
                GOLD if c == 1 else BLUE,
                103,
            )
    f.text(
        32,
        510,
        "Four slots -> global C rows 36..39 at column 17. Output row stride stays 1024.",
        18,
    )
    f.text(
        32,
        554,
        "left_thread_view: (4,1024); right_column: 1024. One B value updates four sums.",
        17,
    )
    f.save(f"{BASE}/02-register-tiling/thread-windows")


def staged_k_windows():
    f = Diagram(
        700, "03 - Select matching K windows, then copy into separate LDS storage"
    )
    f.text(
        32,
        66,
        "Block (1,2), tile_k=2. All tiled global views have shape (16,16,64,64).",
        18,
    )
    f.card(
        32, 114, 410, "left_block_view: (16,16)", "slice(left, (None,None,2,2))", BLUE
    )
    f.card(
        515,
        114,
        410,
        "right_block_view: (16,16)",
        "slice(right, (None,None,2,1))",
        TEAL,
    )
    f.text(32, 233, "A: rows 32..47, K 32..47", 18)
    f.text(515, 233, "B: K 32..47, columns 16..31", 18)
    f.text(
        32,
        279,
        "Global windows retain row stride 1024. Each LDS view has row stride 16.",
        18,
    )
    f.box(32, 327, 893, 102, GOLD)
    f.text(48, 340, "copy_coordinate = idx2crd(tid + load_slot*64, copy_layout)", 20)
    f.text(48, 380, "shared_view[copy_coordinate] = block_view[copy_coordinate]", 20)
    f.text(
        32,
        462,
        "Thread 17, load_slot=0 -> (1,1): copy A[33,33] and B[33,17] into LDS.",
        18,
    )
    f.box(32, 510, 893, 77, PURPLE)
    f.text(
        48,
        522,
        "Barrier -> compute from LDS -> barrier -> select the next K windows",
        20,
    )
    f.text(
        48,
        557,
        "The views select data; scalar assignments perform the actual transfers.",
        17,
    )
    f.text(
        32,
        625,
        "Four-row register ownership is unchanged. Repeat tile_k=0..63; store once at the end.",
        17,
    )
    f.save(f"{BASE}/03-shared-memory/k-windows")


def mma_native_views():
    f = Diagram(
        790, "04 - Keep native block windows; let WMMA define register ownership"
    )
    f.text(
        32,
        66,
        "Global/tiled/block views and two barriers follow lesson 03. One wave has 32 lanes.",
        17,
    )
    f.card(32, 113, 410, "left_block_view: (16,16)", "Global strides (1024,1)", BLUE)
    f.card(515, 113, 410, "right_block_view: (16,16)", "Global strides (1024,1)", TEAL)
    f.text(
        32,
        229,
        "idx2crd(tid + load_slot*32, copy_layout): eight staged values per lane.",
        19,
    )
    f.card(32, 276, 410, "left_shared_view: (16,16)", "LDS strides (16,1)", BLUE)
    f.card(515, 276, 410, "right_shared_view: (16,16)", "LDS strides (16,1)", TEAL)
    f.text(32, 391, "MMA operand views: left (M,K):(16,1), right (N,K):(1,16).", 20)
    f.text(
        32,
        434,
        "right_mma_view reinterprets the existing LDS storage; it does not transpose data.",
        17,
    )
    f.box(32, 483, 893, 82, GOLD)
    f.text(
        48,
        496,
        "make_tiled_copy_A/B -> partition_S + retile -> fx.copy into fragments",
        19,
    )
    f.text(
        48, 532, "fx.gemm(atom, accumulators, fragment_a, fragment_b, accumulators)", 18
    )
    f.text(
        32,
        601,
        "A/B: 16 BF16 values per lane, replicated across lane halves on gfx11.",
        19,
    )
    f.text(
        32,
        645,
        "C: eight unique FP32 outputs per lane; convert only after all 64 K tiles.",
        19,
    )
    f.text(
        32,
        694,
        "The C copy plan stores through out_block_view, retaining its global row stride 1024.",
        17,
    )
    f.text(
        32,
        739,
        "The staging copy layout and WMMA fragment layout serve different ownership rules.",
        17,
    )
    f.save(f"{BASE}/04-matrix-instructions/native-mma-views")


def column_major_b():
    f = Diagram(650, "01 - Column-major B makes a single thread's K walk contiguous")
    f.text(
        32,
        66,
        "Cells show STORAGE OFFSETS, not values. Crop: B inner=0..3, column=0..3.",
        18,
    )
    f.text(32, 115, "Row-major B: strides (1024,1)", 21)
    f.text(515, 115, "Column-major B: strides (1,1024)", 21)
    for row in range(4):
        for col in range(4):
            color = GOLD if col == 1 else BLUE
            f.cell(32 + col * 104, 169 + row * 47, row * 1024 + col, color, 104)
            f.cell(515 + col * 104, 169 + row * 47, row + col * 1024, color, 104)
    f.text(32, 389, "Down column 1: +1024 per K step", 18)
    f.text(515, 389, "Down column 1: +1 per K step", 18)
    f.text(32, 442, "Block (1,2), thread 17: A row 33 and B column 17.", 21)
    f.text(
        32, 487, "A row offsets: 33792,33793,...  B column offsets: 17408,17409,...", 19
    )
    f.text(
        32,
        534,
        "At fixed inner, neighboring output-column lanes still read B addresses +1024 apart.",
        17,
    )
    f.text(
        32,
        581,
        "This is contiguous K access per thread; wave-wide coalescing needs a different mapping.",
        17,
    )
    f.save(f"{BASE}/01-coalesced-access/b-column-major")


def main():
    naive()
    naive_views()
    naive_block_windows()
    naive_flat_modes()
    naive_thread_map()
    naive_scalar_steps()
    coalesced()
    column_major_b()
    registers()
    register_thread_windows()
    shared()
    staged_k_windows()
    matrix()
    mma_native_views()


if __name__ == "__main__":
    main()
