"""Draw exact edge predicates and a cross-row address trap (Pillow required)."""

from draw_lesson_visuals import BLUE, GOLD, GRAY, TEAL, Diagram
from draw_wave_tiles import describe

BASE = "01-gpu-programming/13-matmul/13-edge-safety"


def edges():
    d = Diagram(820, "13 - Full WMMA tiles, exact matrix bounds")
    describe(
        d,
        "For M=17, N=65, K=33 and a 16 by 64 by 32 tile, output block row one and column one begins at row sixteen and column sixty-four. Its final K stage begins at thirty-two. Only A row sixteen K thirty-two, B K thirty-two column sixty-four, and C row sixteen column sixty-four are valid in the shown corner. All other shown A and B coordinates become zero; invalid C stores are skipped.",
    )
    d.text(
        32, 68, "M=17, N=65, K=33; tile 16 x 64 x 32; final K stage starts at 32.", 20
    )
    d.text(
        32,
        112,
        "Zoom: first four positions in each edge window. Cells show coordinates.",
        20,
    )
    for start, label, rows, cols, bounds in (
        (32, "A: row < 17 and k < 33", (16, 17, 18), (32, 33, 34, 35), (17, 33)),
        (508, "B: k < 33 and column < 65", (32, 33, 34), (64, 65, 66, 67), (33, 65)),
    ):
        d.text(start, 168, label, 21)
        for r, row in enumerate(rows):
            for c, col in enumerate(cols):
                valid = row < bounds[0] and col < bounds[1]
                d.cell(
                    start + c * 105,
                    215 + r * 51,
                    f"({row},{col})",
                    TEAL if valid else GRAY,
                    102,
                )
        d.text(start, 387, "Green: load. Gray: keep register zero.", 18)
    d.text(32, 446, "C: row < 17 and column < 65", 23)
    for r, row in enumerate((16, 17, 18)):
        for c, col in enumerate((64, 65, 66, 67)):
            d.cell(
                32 + c * 105,
                493 + r * 51,
                f"({row},{col})",
                GOLD if row == 16 and col == 64 else GRAY,
                102,
            )
    d.text(508, 500, "Only C[16,64] is stored here.", 21)
    d.text(508, 545, "A[16,32] = -2; B[32,64] = -1.", 19)
    d.text(508, 587, "Final K stage contributes 2.", 20)
    d.text(
        32,
        689,
        "The full K reduction gives C[16,64] = 1 for the lesson's trace inputs.",
        20,
    )
    d.text(
        32,
        738,
        "Predicates follow each copy plan; LDS tiles and WMMA fragments stay full-sized.",
        19,
    )
    d.save(f"{BASE}/edge-predicates")


def cross_row():
    d = Diagram(600, "13 - A valid byte address can name an invalid matrix coordinate")
    describe(
        d,
        "A row-major 3 by 5 BF16 matrix has strides five and one. The invalid coordinate row zero column five maps to element offset five, which belongs to valid coordinate row one column zero. A whole-buffer descriptor accepts the offset, so a per-axis predicate must reject column five. Likewise, for K=33 the final eight-position A chunk at K thirty-two contains one valid element. The lesson selects scalar copies when the row extent is odd.",
    )
    d.text(
        32,
        67,
        "Small address example: A has shape (3,5), strides (5,1), and 15 BF16 values.",
        19,
    )
    for r in range(3):
        d.text(32, 130 + r * 58, f"row {r}", 21)
        for c in range(5):
            d.cell(
                145 + c * 120,
                123 + r * 58,
                f"offset {5 * r + c}",
                GOLD if (r, c) == (1, 0) else BLUE,
                116,
            )
    d.text(
        32,
        337,
        "Invalid A[0,5]: element offset = 0*5+5 = 5; byte displacement = 10.",
        21,
    )
    d.text(
        32,
        384,
        "That address holds A[1,0]. A 30-byte buffer bound allows the access.",
        21,
    )
    d.card(
        32,
        451,
        420,
        "Coordinate predicate: column < 5",
        "5 < 5 is false: do not load.",
        TEAL,
    )
    d.card(
        490,
        451,
        435,
        "Vector predicate: column + width <= 5",
        "The complete copy atom must fit the row.",
        GOLD,
    )
    d.save(f"{BASE}/cross-row-bounds")


if __name__ == "__main__":
    edges()
    cross_row()
