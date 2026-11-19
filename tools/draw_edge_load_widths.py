"""Draw the mixed-width BF16 edge trace for stage 15 (Pillow required)."""

from draw_lesson_visuals import BLUE, GOLD, GRAY, TEAL, Diagram
from draw_wave_tiles import describe


def main():
    figure = Diagram(414, "15 - Fill a 14-value tail with three copy widths")
    describe(
        figure,
        "The last A K stage starts at K 32 and the last B N group starts at N 64. "
        "Both have fourteen valid BF16 values. The first eight use one 128-bit load. "
        "Values eight through eleven use one 64-bit load and values twelve and "
        "thirteen use one 32-bit load. Positions fourteen and fifteen stay zero.",
    )
    figure.text(
        32,
        65,
        "M=17, N=78, K=46. The shown window starts at K=32 for A and N=64 for B.",
        18,
    )
    for x, title in ((32, "128-bit"), (480, "64-bit"), (704, "32-bit"), (816, "Zero")):
        figure.text(x, 112, title, 20)
    colors = [BLUE] * 8 + [TEAL] * 4 + [GOLD] * 2 + [GRAY] * 2
    for y, label, first in ((163, "A K coordinates", 32), (257, "B N coordinates", 64)):
        figure.text(32, y - 29, label, 17)
        for local, color in enumerate(colors):
            figure.cell(32 + local * 56, y, first + local, color, 55)
    figure.text(
        32,
        339,
        "The narrow copies fill only the tail slots. The last two shown slots stay zero.",
        18,
    )
    figure.text(
        32, 375, "A and B then use their existing register and LDS paths to WMMA.", 18
    )
    figure.save("01-gpu-programming/13-matmul/15-edge-load-widths/mixed-width-tail")


if __name__ == "__main__":
    main()
