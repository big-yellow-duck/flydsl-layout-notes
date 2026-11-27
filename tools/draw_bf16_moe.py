"""Regenerate BF16 MoE lesson figures with Pillow."""

from draw_lesson_visuals import BLUE, GOLD, GRAY, PURPLE, TEAL, Diagram

ASSETS = "01-gpu-programming/15-bf16-moe"


def routes():
    d = Diagram(350, "A route identifies a token and a top-k slot")
    for x, title in (
        (33, "Token"),
        (165, "Slot 0 (expert, route)"),
        (432, "Slot 1 (expert, route)"),
    ):
        d.text(x, 78, title, 21)
    for token, pair in enumerate(((0, 1), (1, 0), (0, 2))):
        y = 124 + token * 54
        d.cell(33, y, str(token), GRAY, 86)
        for slot, expert in enumerate(pair):
            route = 2 * token + slot
            d.cell(
                165 + slot * 267,
                y,
                f"Expert {expert} / route {route}",
                (GOLD, BLUE, TEAL)[expert],
                250,
            )
    d.card(726, 124, 203, "Route 3", "Token 1, slot 1", GOLD)
    d.text(
        33,
        304,
        "Multiply each down projection by its route weight before summing by token.",
        19,
    )
    d.save(f"{ASSETS}/00-naive/route-order")


def worklist():
    d = Diagram(385, "Group routes so an output tile uses a single expert")
    for x, label in (
        (33, "Expert"),
        (166, "Compact rows"),
        (359, "Route IDs in the rows"),
        (688, "WMMA M tile"),
    ):
        d.text(x, 76, label, 20)
    entries = [
        ("0", "[0, 3)", "{0, 3, 4}", "Tile 0 • 3 valid", GOLD),
        ("1", "[3, 5)", "{1, 2}", "Tile 1 • 2 valid", BLUE),
        ("2", "[5, 6)", "{5}", "Tile 2 • 1 valid", TEAL),
        ("3", "[6, 6)", "{}", "0 tiles", GRAY),
    ]
    for index, (expert, rows, ids, tile, color) in enumerate(entries):
        y = 123 + index * 50
        for x, value, width in (
            (33, expert, 116),
            (166, rows, 178),
            (359, ids, 310),
            (688, tile, 240),
        ):
            d.cell(x, y, value, color, width)
    d.text(
        33,
        338,
        "The sets show membership. Atomic scatter may choose any order within each set.",
        19,
    )
    d.save(f"{ASSETS}/01-grouped-wmma/expert-worklist")


def epilogues():
    d = Diagram(325, "Keep the gate and up accumulators in the projection")
    d.card(33, 77, 263, "Gate/up WMMA", "FP32 gate and up", BLUE)
    d.arrow(305, 120, 337, 120)
    d.card(347, 77, 263, "SwiGLU epilogue", "One BF16 activation", TEAL)
    d.arrow(619, 120, 651, 120)
    d.card(661, 77, 266, "Down WMMA", "FP32 expert result", BLUE)
    d.card(33, 184, 263, "Weighted down", "Apply the route weight", GOLD)
    d.arrow(305, 227, 337, 227)
    d.card(347, 184, 263, "Token reduction", "Sum FP32 contributions", PURPLE)
    d.arrow(619, 227, 651, 227)
    d.card(661, 184, 266, "Output", "Round once to BF16", TEAL)
    d.text(
        33,
        290,
        "Read left to right across the top, then continue on the bottom row.",
        17,
    )
    d.save(f"{ASSETS}/02-fused/epilogues")


if __name__ == "__main__":
    routes()
    worklist()
    epilogues()
