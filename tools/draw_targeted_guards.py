"""Draw the exact address examples for matmul stage 14 (Pillow required)."""

from draw_lesson_visuals import BLUE, GOLD, TEAL, Diagram
from draw_wave_tiles import describe


def main():
    figure = Diagram(532, "14 - Which matrix edges need a coordinate check?")
    describe(
        figure,
        "For M=17, N=65, K=33, the first excess M row of A begins outside the "
        "descriptor, and an excess K row of B is outside its descriptor at a valid "
        "column. An excess K column of A and an excess N column of C can each alias "
        "the following row inside the buffer. Masks protect these columns. A stage "
        "with no real K tile is rejected before selecting either input view.",
    )
    figure.text(
        32,
        63,
        "M=17, N=65, K=33. Offsets count BF16 elements from each matrix base.",
        19,
    )
    for y, name, detail, action, color in (
        (
            108,
            "M row in A",
            "A[17,0] at 561, beyond element 560",
            "Descriptor returns zero",
            BLUE,
        ),
        (
            187,
            "K row in B",
            "B[33,64] at 2209, beyond element 2144",
            "Descriptor returns zero",
            BLUE,
        ),
        (
            266,
            "K column in A",
            "A[15,33] at 528 aliases A[16,0]",
            "Mask A's final K stage",
            GOLD,
        ),
        (
            345,
            "N column in C",
            "C[15,65] at 1040 aliases C[16,0]",
            "Mask C's edge group",
            GOLD,
        ),
    ):
        figure.box(32, y, 896, 64, color)
        figure.text(44, y + 12, name, 20)
        figure.text(239, y + 13, detail, 18)
        figure.text(656, y + 13, action, 18)
    figure.card(
        32,
        424,
        896,
        "Empty split-K stage",
        "Real stages are 0 and 1. Slots 2 and 3 zero both inputs before any tile selection.",
        TEAL,
    )
    figure.save("01-gpu-programming/13-matmul/14-targeted-guards/guarded-axes")


if __name__ == "__main__":
    main()
