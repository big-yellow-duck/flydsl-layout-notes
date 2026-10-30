"""Draw exact SVG and PNG figures for the divider comparison (requires Pillow)."""

from html import escape
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
COLORS = ["#dcecff", "#ccefe6", "#ffedbe", "#e5dcff"]
INK = "#14253d"


class Figure:
    def __init__(self, height, title):
        self.image = Image.new("RGB", (1920, height * 2), "#f8fafc")
        self.draw = ImageDraw.Draw(self.image)
        self.svg = [
            f'<svg xmlns="http://www.w3.org/2000/svg" width="960" height="{height}" viewBox="0 0 960 {height}" role="img">',
            f"<title>{escape(title)}</title>",
            '<rect width="100%" height="100%" fill="#f8fafc"/>',
        ]
        self.text(32, 20, title, 27)

    def text(self, x, y, text, size=18):
        candidates = [
            "/usr/share/fonts/google-noto/NotoSans-Regular.ttf",
            "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        ]
        font = ImageFont.truetype(
            next(p for p in candidates if Path(p).exists()), size * 2
        )
        assert x + self.draw.textlength(str(text), font=font) / 2 <= 950, text
        self.draw.text((x * 2, y * 2), str(text), font=font, fill=INK, anchor="lt")
        self.svg.append(
            f'<text x="{x}" y="{y}" dominant-baseline="text-before-edge" font-family="Noto Sans, sans-serif" font-size="{size}" fill="{INK}">{escape(str(text))}</text>'
        )

    def cell(self, x, y, value, color, width=48):
        self.draw.rectangle(
            (x * 2, y * 2, (x + width - 3) * 2, (y + 43) * 2),
            fill=color,
            outline="#8294aa",
            width=2,
        )
        self.svg.append(
            f'<rect x="{x}" y="{y}" width="{width - 3}" height="43" fill="{color}" stroke="#8294aa"/>'
        )
        self.text(x + 10, y + 9, value, 19)

    def grid(self, x, y, value, color, width=48):
        for row in range(4):
            for col in range(8):
                self.cell(
                    x + col * width,
                    y + row * 47,
                    value(row, col),
                    color(row, col),
                    width,
                )

    def save(self, name):
        base = ROOT / "assets" / name
        base.parent.mkdir(parents=True, exist_ok=True)
        base.with_suffix(".svg").write_text("\n".join(self.svg + ["</svg>"]) + "\n")
        self.image.save(base.with_suffix(".png"))


def main():
    fig = Figure(660, "Before: one matrix, two different kinds of index")
    fig.text(
        32,
        66,
        "Original layout: shape (4, 8), strides (8, 1). Rows go down; columns go right.",
    )
    fig.text(70, 110, "Storage offsets: offset = 8 * row + column", 21)
    fig.grid(70, 151, lambda r, c: 8 * r + c, lambda r, c: "#ffffff", 80)
    fig.text(70, 362, "Scalar logical indices: index = row + 4 * column", 21)
    fig.grid(
        70,
        403,
        lambda r, c: r + 4 * c,
        lambda r, c: COLORS[0] if c < 2 else "#ffffff",
        80,
    )
    fig.text(
        70, 605, "Blue = logical indices 0 through 7: all four rows, first two columns."
    )
    fig.save("00-layout-algebra/05-logical-divide/divide-comparison-before")

    fig = Figure(780, "After: same storage, different tile windows")
    fig.text(
        32, 67, "Cells show STORAGE OFFSETS. Colors identify tiles; no data has moved."
    )
    fig.text(32, 116, "Tuple tiler: (2, 4)", 23)
    fig.text(512, 116, "Layout tiler: (2, 4):(1, 2)", 23)
    fig.text(32, 150, "Split each original axis independently.")
    fig.text(512, 150, "Group eight scalar logical indices.")
    fig.grid(
        32, 190, lambda r, c: 8 * r + c, lambda r, c: COLORS[(r // 2) * 2 + c // 4]
    )
    fig.grid(512, 190, lambda r, c: 8 * r + c, lambda r, c: COLORS[c // 2])
    for index, label in enumerate(["(0,0)", "(0,1)", "(1,0)", "(1,1)"]):
        fig.cell(32 + index * 105, 393, label, COLORS[index], 100)
        fig.cell(512 + index * 105, 393, index, COLORS[index], 100)
    fig.text(32, 451, "Tile coordinates: (tile_row, tile_col)", 17)
    fig.text(512, 451, "Pattern repetition: tile_index", 17)
    fig.text(32, 500, "First window: 2 rows x 4 columns", 21)
    fig.text(512, 500, "First window: 4 rows x 2 columns", 21)
    for row in range(2):
        for col in range(4):
            fig.cell(32 + col * 65, 542 + row * 47, 8 * row + col, COLORS[0], 65)
    for row in range(4):
        for col in range(2):
            fig.cell(512 + col * 65, 542 + row * 47, 8 * row + col, COLORS[0], 65)
    fig.text(32, 660, "Offsets: 0, 1, 2, 3, 8, 9, 10, 11", 17)
    fig.text(512, 745, "Offsets: 0, 1, 8, 9, 16, 17, 24, 25", 17)
    fig.save("00-layout-algebra/05-logical-divide/divide-comparison-after")


if __name__ == "__main__":
    main()
