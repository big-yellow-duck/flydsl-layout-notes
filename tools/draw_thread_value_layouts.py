"""Regenerate lesson 07's SVG diagrams and PNG previews (requires Pillow).

Run from the repository root: python3 tools/draw_thread_value_layouts.py
"""

from draw_divide_comparison import COLORS, Figure


def ownership():
    fig = Figure(820, "Two values per thread: two ways to choose their positions")
    fig.text(
        32,
        65,
        "T = thread ID; V = value slot within that thread. Numbers are tile offsets.",
    )
    for y, title, strides in [
        (112, "A. Neighbor pairs (adjacent)", (2, 1)),
        (458, "B. One value per thread, repeated (interleaved)", (1, 4)),
    ]:
        fig.text(32, y, title, 24)
        fig.text(32, y + 40, "Memory order: left to right = offsets 0 through 7", 18)
        for offset in range(8):
            thread, value = (
                divmod(offset, 2) if strides == (2, 1) else (offset % 4, offset // 4)
            )
            x = 32 + offset * 112
            fig.cell(x, y + 76, offset, COLORS[thread], 106)
            fig.text(x + 6, y + 127, f"T{thread} / V{value}", 17)
        fig.text(
            32,
            y + 170,
            "Regroup by owner: each thread still gets exactly TWO offsets",
            18,
        )
        for thread in range(4):
            x = 32 + thread * 226
            fig.text(x, y + 208, f"Thread {thread}", 20)
            for value in range(2):
                offset = thread * strides[0] + value * strides[1]
                fig.cell(x + value * 95, y + 244, offset, COLORS[thread], 88)
                fig.text(x + value * 95 + 19, y + 292, f"V{value}", 16)
    fig.text(
        32, 794, "Same eight offsets. Same four owners. Same two slots per owner.", 18
    )
    fig.save("00-layout-algebra/07-thread-value-layouts/thread-value-ownership")


def strides():
    fig = Figure(470, "Read (4, 2) as (four threads, two slots per thread)")
    fig.text(
        32,
        65,
        "Shape sets the counts. Strides choose the positions assigned to those slots.",
    )
    for x, title, layout, stride in [
        (32, "A. Neighbor pairs", "(4, 2) : (2, 1)", (2, 1)),
        (490, "B. Repeated across threads", "(4, 2) : (1, 4)", (1, 4)),
    ]:
        fig.text(x, 118, title, 23)
        fig.text(x, 162, layout, 27)
        fig.text(x, 217, f"Next thread, same slot: +{stride[0]}", 19)
        fig.text(x, 254, f"Same thread, next slot: +{stride[1]}", 19)
        fig.text(x, 310, "Follow thread 2:", 21)
        for value in range(2):
            offset = 2 * stride[0] + value * stride[1]
            fig.text(
                x,
                354 + value * 43,
                f"offset(2, {value}) = 2 * {stride[0]} + {value} * {stride[1]} = {offset}",
                20,
            )
    fig.text(
        32,
        435,
        "V0 and V1 name local slots; they do not require neighboring memory positions.",
        18,
    )
    fig.save("00-layout-algebra/07-thread-value-layouts/thread-value-strides")


if __name__ == "__main__":
    ownership()
    strides()
    print("Generated lesson 07 SVG diagrams and PNG previews in assets/.")
