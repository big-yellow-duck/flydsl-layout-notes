"""Regenerate exact SVG + PNG diagrams. Optional dependency: Pillow.

Run from the repository root: python3 tools/draw_diagrams.py
SVGs are native vector assets; PNGs are convenient for local previews.
"""

from html import escape
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "assets"
INK, MUTED, BORDER = "#14253d", "#52657a", "#c9d5e3"
BLUE, TEAL, GOLD, PURPLE = "#dcecff", "#ccefe6", "#ffedbe", "#e5dcff"
FONT_DIR = Path("/usr/share/fonts/truetype/dejavu")


class Canvas:
    def __init__(self, title, subtitle, height=480):
        self.w, self.h = 960, height
        self.parts = [
            f'<svg xmlns="http://www.w3.org/2000/svg" width="960" height="{height}" viewBox="0 0 960 {height}" role="img">',
            f"<title>{escape(title)}</title><desc>{escape(subtitle)}</desc>",
            '<rect width="100%" height="100%" fill="#f8fafc"/>',
        ]
        self.im = Image.new("RGB", (self.w * 2, self.h * 2), "#f8fafc")
        self.draw = ImageDraw.Draw(self.im)
        self.text(32, 22, title, 28, bold=True)
        self.text(32, 62, subtitle, 17, color=MUTED)

    def text(self, x, y, value, size=20, color=INK, bold=False, center=False):
        value = str(value)
        font_path = FONT_DIR / ("DejaVuSans-Bold.ttf" if bold else "DejaVuSans.ttf")
        if not font_path.exists():
            candidates = [
                Path("/usr/share/fonts/dejavu-sans-fonts") / font_path.name,
                Path("/usr/share/fonts/google-noto")
                / ("NotoSans-Bold.ttf" if bold else "NotoSans-Regular.ttf"),
            ]
            font_path = next((path for path in candidates if path.exists()), font_path)
        font = ImageFont.truetype(str(font_path), size * 2)
        width = self.draw.textlength(value, font=font) / 2
        if center:
            x -= width / 2
        if x < 0 or x + width > self.w:
            raise ValueError(f"Text outside canvas: {value}")
        self.draw.text((x * 2, y * 2), value, font=font, fill=color, anchor="lt")
        self.parts.append(
            f'<text x="{x}" y="{y}" fill="{color}" font-family="DejaVu Sans, sans-serif" font-size="{size}" font-weight="{700 if bold else 400}" dominant-baseline="text-before-edge">{escape(value)}</text>'
        )

    def box(self, x, y, w, h, color="white", stroke=BORDER, width=1):
        self.draw.rounded_rectangle(
            (x * 2, y * 2, (x + w) * 2, (y + h) * 2),
            radius=12,
            fill=color,
            outline=stroke,
            width=width * 2,
        )
        self.parts.append(
            f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="6" fill="{color}" stroke="{stroke}" stroke-width="{width}"/>'
        )

    def line(self, x1, y1, x2, y2, color=MUTED, width=2):
        self.draw.line((x1 * 2, y1 * 2, x2 * 2, y2 * 2), fill=color, width=width * 2)
        self.parts.append(
            f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{color}" stroke-width="{width}"/>'
        )

    def cell(self, x, y, value, color=BLUE, w=60, h=48):
        self.box(x, y, w, h, color)
        self.text(x + w / 2, y + (h - 24) / 2, value, 20, bold=True, center=True)

    def save(self, name):
        (OUT / name).parent.mkdir(parents=True, exist_ok=True)
        (OUT / f"{name}.svg").write_text("\n".join(self.parts + ["</svg>"]) + "\n")
        self.im.save(OUT / f"{name}.png", optimize=True)


def shape_stride():
    c = Canvas(
        "Shape chooses coordinates. Stride chooses offsets.",
        "Each cell shows an element offset; row increases downward, column to the right.",
        440,
    )
    for start, stride, title, color in [
        (55, (4, 1), "Row-major  (3,4):(4,1)", BLUE),
        (520, (1, 3), "Column-major  (3,4):(1,3)", TEAL),
    ]:
        c.text(start, 110, title, 21, bold=True)
        for row in range(3):
            for col in range(4):
                c.cell(
                    start + col * 80,
                    155 + row * 60,
                    row * stride[0] + col * stride[1],
                    color,
                    w=70,
                    h=50,
                )
        c.text(start, 350, f"(2,1) maps to {2 * stride[0] + stride[1]}", 20)
    c.save("00-layout-algebra/00-shapes-and-strides/shapes-strides")


def nested():
    c = Canvas(
        "Nested parentheses preserve hierarchy",
        "L = ((2,2),3):((1,4),8)    •    L((a,b),c) = a + 4b + 8c",
        500,
    )
    c.box(40, 115, 400, 70, BLUE)
    c.text(240, 130, "mode 0: (a,b), shape (2,2)", 21, bold=True, center=True)
    c.box(520, 115, 390, 70, TEAL)
    c.text(715, 130, "mode 1: c, shape 3", 21, bold=True, center=True)
    c.line(140, 185, 140, 222)
    c.line(340, 185, 340, 222)
    c.box(60, 222, 160, 70, "white")
    c.text(140, 238, "a: stride 1", 20, center=True)
    c.box(260, 222, 160, 70, "white")
    c.text(340, 238, "b: stride 4", 20, center=True)
    c.line(715, 185, 715, 222)
    c.box(625, 222, 180, 70, "white")
    c.text(715, 238, "c: stride 8", 20, center=True)
    c.text(40, 335, "Offsets grouped by c; inner order is a first, then b:", 20)
    for i, values in enumerate(["0, 1, 4, 5", "8, 9, 12, 13", "16, 17, 20, 21"]):
        x = 40 + i * 305
        c.box(x, 378, 280, 68, [BLUE, TEAL, GOLD][i])
        c.text(x + 140, 388, f"c = {i}", 16, center=True)
        c.text(x + 140, 414, values, 20, bold=True, center=True)
    c.save("00-layout-algebra/02-nested-layouts/nested-layout")


def composition():
    c = Canvas(
        "Composition connects integer mappings",
        "A = (2,4):(4,1)    •    B = (4,2):(2,1)    •    R = A ∘ B",
        460,
    )
    stages = [
        (40, 200, BLUE, "B coordinate", "(u,v) = (2,1)"),
        (300, 250, GOLD, "B emits q = 5", "A expands: (1,2)"),
        (610, 300, TEAL, "A returns offset 6", "R(2,1) = 6"),
    ]
    for x, w, color, a, b in stages:
        c.box(x, 145, w, 115, color)
        c.text(x + w / 2, 166, a, 20, bold=True, center=True)
        c.text(x + w / 2, 211, b, 19, center=True)
    for x in [248, 558]:
        c.line(x, 202, x + 40, 202)
        c.line(x + 40, 202, x + 31, 196)
        c.line(x + 40, 202, x + 31, 208)
    c.text(
        40,
        305,
        "B chooses a logical position in A; A supplies its memory offset.",
        22,
        bold=True,
    )
    c.text(40, 350, "R(u,v) = u + 4v    →    equivalent layout (4,2):(1,4)", 23)
    c.text(
        40,
        399,
        "Different shapes are fine. No values move during composition.",
        19,
        color=MUTED,
    )
    c.save("00-layout-algebra/03-composition/composition")


def coalescing():
    c = Canvas(
        "Coalescing preserves the ordered offset sequence",
        "Merge adjacent modes only when their scalar-coordinate mapping can stay unchanged.",
        480,
    )
    c.text(40, 112, "(2,4):(1,2)  →  8:1", 23, bold=True)
    for i in range(8):
        c.cell(40 + i * 65, 158, i, TEAL, w=58)
    c.text(600, 163, "Compatible: 2 = 2 × 1", 20)
    c.text(40, 250, "(2,4):(4,1)  stays multi-mode", 23, bold=True)
    for i, v in enumerate([0, 4, 1, 5, 2, 6, 3, 7]):
        c.cell(40 + i * 65, 296, v, GOLD, w=58)
    c.text(600, 302, "No single constant stride", 19)
    c.text(40, 399, "Same offset set does not mean the same mapping.", 23, bold=True)
    c.save("00-layout-algebra/04-coalescing/coalescing")


def divide():
    c = Canvas(
        "Logical divide creates tile coordinates",
        "A = (4,8):(8,1)    •    Tile shape (2,4)    •    Numbers are original element offsets.",
        580,
    )
    for r in range(4):
        for n in range(8):
            p, q = r // 2, n // 4
            color = [BLUE, TEAL, GOLD, PURPLE][p * 2 + q]
            c.cell(40 + n * 62, 140 + r * 59, r * 8 + n, color, w=56, h=50)
    c.box(
        40 + 4 * 62 - 5,
        140 + 2 * 59 - 5,
        4 * 62 + 4,
        2 * 59 - 1,
        PURPLE,
        stroke="#7552ad",
        width=3,
    )
    # Redraw the selected tile's cells above its highlighted backdrop.
    for r in range(2, 4):
        for n in range(4, 8):
            c.cell(40 + n * 62, 140 + r * 59, r * 8 + n, PURPLE, w=56, h=50)
    c.text(580, 140, "Selected tile (p,q)=(1,1)", 21, bold=True)
    c.text(580, 183, "Base offset = 20", 22)
    c.text(580, 225, "Local (m,n) = (1,2)", 21)
    c.text(580, 264, "Original (row,col) = (3,6)", 20)
    c.text(580, 305, "Final offset = 30", 23, bold=True)
    c.text(40, 408, "Logical coordinate: ((m,p),(n,q)) = ((1,1),(2,1))", 22)
    c.text(40, 450, "Flat coordinate: (m,n,p,q) = (1,2,1,1)", 22)
    c.text(
        40,
        511,
        "Same storage and tile access; different grouping of coordinates.",
        20,
        color=MUTED,
    )
    c.save("00-layout-algebra/05-logical-divide/logical-divide")


def ownership():
    c = Canvas(
        "A thread-value layout assigns ownership",
        "Four toy threads × two values cover an eight-element block tile. Colors show the owner.",
        480,
    )
    colors = [BLUE, TEAL, GOLD, PURPLE]
    c.text(40, 112, "Blocked: index = 2*thread + value", 23, bold=True)
    for i in range(8):
        c.cell(40 + i * 110, 158, i, colors[i // 2], w=99, h=55)
        c.text(40 + i * 110 + 49, 225, f"T{i // 2}, V{i % 2}", 17, center=True)
    c.text(40, 290, "Interleaved: index = thread + 4*value", 23, bold=True)
    for i in range(8):
        c.cell(40 + i * 110, 337, i, colors[i % 4], w=99, h=55)
        c.text(40 + i * 110 + 49, 405, f"T{i % 4}, V{i // 4}", 17, center=True)
    c.save("00-layout-algebra/07-thread-value-layouts/thread-ownership")


if __name__ == "__main__":
    for diagram in [shape_stride, nested, composition, coalescing, divide, ownership]:
        diagram()
    print("Generated six SVG diagrams and six PNG previews in assets/.")
