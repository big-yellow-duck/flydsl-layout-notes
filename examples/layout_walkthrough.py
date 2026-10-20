"""Run with Python 3.10+. A small arithmetic model, not the FlyDSL compiler.

Integer coordinates are expanded first-mode-fastest. Explicit tuple coordinates
must match the shape tree. Only positive static shapes/nonnegative strides are
modelled. Composition below is function evaluation, not symbolic simplification.
"""

from dataclasses import dataclass
from math import prod
from typing import Union

Tree = Union[int, tuple["Tree", ...]]


def size(shape: Tree) -> int:
    return shape if isinstance(shape, int) else prod(size(x) for x in shape)


def leaves(tree: Tree) -> tuple[int, ...]:
    if isinstance(tree, int):
        return (tree,)
    return tuple(v for child in tree for v in leaves(child))


def expand(q: int, shape: Tree) -> Tree:
    """Expand a scalar *logical coordinate*, not a memory offset."""
    if not 0 <= q < size(shape):
        raise ValueError(f"logical coordinate {q} outside shape {shape}")
    if isinstance(shape, int):
        return q
    result = []
    for child in shape:
        q, within = divmod(q, size(child))
        result.append(expand(within, child))
    return tuple(result)


def offset(coord: Tree, shape: Tree, stride: Tree) -> int:
    if isinstance(coord, int):
        coord = expand(coord, shape)
    if isinstance(shape, int):
        if not isinstance(stride, int) or not isinstance(coord, int):
            raise ValueError("coordinate/stride tree mismatch")
        return coord * stride
    if not isinstance(stride, tuple) or not isinstance(coord, tuple):
        raise ValueError("coordinate/stride tree mismatch")
    if not len(coord) == len(shape) == len(stride):
        raise ValueError("coordinate/stride tree mismatch")
    return sum(offset(c, s, d) for c, s, d in zip(coord, shape, stride))


@dataclass(frozen=True)
class Layout:
    shape: Tree
    stride: Tree

    def __call__(self, coord: Tree) -> int:
        return offset(coord, self.shape, self.stride)

    def sequence(self) -> list[int]:
        return [self(q) for q in range(size(self.shape))]

    def cosize(self) -> int:
        return max(self.sequence()) + 1


def require_equal(actual, expected, label: str) -> None:
    if actual != expected:
        raise AssertionError(f"{label}: {actual!r} != {expected!r}")


def equivalent(a: Layout, b: Layout) -> None:
    require_equal(a.sequence(), b.sequence(), f"{a} versus {b}")


def main() -> None:
    # 00: Strides, padding, size versus span, aliasing.
    row = Layout((3, 4), (4, 1))
    col = Layout((3, 4), (1, 3))
    require_equal((row((2, 1)), col((2, 1))), (9, 5), "row/column")
    padded = Layout((3, 4), (5, 1))
    require_equal((padded((2, 3)), size(padded.shape), padded.cosize()),
                  (13, 12, 14), "padding")
    require_equal(Layout(4, 2).cosize(), 7, "strided span")
    require_equal(Layout((2, 3), (0, 1)).sequence(), [0, 0, 1, 1, 2, 2], "aliasing")
    print("00 shapes/strides: offsets, padding, holes, and repeated offsets checked")

    # 01: Scalar logical enumeration is independent of memory order.
    a = Layout((2, 4), (4, 1))
    require_equal(a.sequence(), [0, 4, 1, 5, 2, 6, 3, 7], "scalar order")
    require_equal(Layout((3, 2), (2, 1))(5), 5, "coordinate exercise")
    print("01 scalar coordinates:", a.sequence())

    # 02/03: Composition, including a subset and a nested input.
    nested = Layout(((2, 2), 3), ((1, 4), 8))
    require_equal(nested(((1, 1), 2)), 21, "nested tuple")
    require_equal(expand(7, nested.shape), ((1, 1), 1), "nested expansion")
    require_equal(nested(7), 13, "nested scalar")
    require_equal(nested(((0, 1), 1)), 12, "nested exercise")
    equivalent(nested, Layout((2, 2, 3), (1, 4, 8)))
    b = Layout((4, 2), (2, 1))
    r = Layout((4, 2), (1, 4))
    for q in range(size(b.shape)):
        c = expand(q, b.shape)
        require_equal(a(b(c)), r(c), "composition A(B(c))")
    require_equal([a(Layout(2, 2)(q)) for q in range(2)], [0, 1], "subset")
    bn = Layout((2, 3), (2, 4))
    rn = Layout((2, 3), (4, 8))
    for q in range(size(bn.shape)):
        c = expand(q, bn.shape)
        require_equal(nested(bn(c)), rn(c), "nested composition")
    require_equal(nested(bn((1, 2))), 20, "nested composition example")
    print("02/03 nested layouts and composition: all input coordinates checked")

    # 04: Compare full scalar sequences, not just the offset sets.
    for original, simplified in [
        (Layout((2, 4), (1, 2)), Layout(8, 1)),
        (Layout((2, 3), (2, 4)), Layout(6, 2)),
        (Layout(((2, 1), 4), ((1, 99), 2)), Layout(8, 1)),
        (nested, Layout((2, 6), (1, 4))),
        (Layout((2, 3), (3, 6)), Layout(6, 3)),
    ]:
        equivalent(original, simplified)
    require_equal(set(a.sequence()), set(Layout(8, 1).sequence()), "same offset set")
    require_equal(a.sequence() == Layout(8, 1).sequence(), False, "different mapping")
    print("04 coalescing: equivalent sequences and a non-example checked")

    # 05: These are explicit expected layouts for the lesson's regular tiles.
    d1 = Layout((4, 4), (1, 4))
    require_equal([d1((i, 2)) for i in range(4)], [8, 9, 10, 11], "1D tile 2")
    original = Layout((4, 8), (8, 1))
    logical = Layout(((2, 2), (4, 2)), ((8, 16), (1, 4)))
    zipped = Layout(((2, 4), (2, 2)), ((8, 1), (16, 4)))
    tiled = Layout(((2, 4), 2, 2), ((8, 1), 16, 4))
    flat = Layout((2, 4, 2, 2), (8, 1, 16, 4))
    visited = []
    for p in range(2):
        for q in range(2):
            for m in range(2):
                for n in range(4):
                    expected = original((m + 2*p, n + 4*q))
                    actual = [logical(((m, p), (n, q))), zipped(((m, n), (p, q))),
                              tiled(((m, n), p, q)), flat((m, n, p, q))]
                    require_equal(actual, [expected]*4, "divide variants")
                    visited.append(expected)
    require_equal(sorted(visited), list(range(32)), "tile coverage")
    require_equal(flat((1, 2, 1, 1)), 30, "tile (1,1) example")
    require_equal(flat((1, 3, 0, 1)), 15, "divide exercise")
    print("05 divide: all 32 elements agree across logical/zipped/tiled/flat views")

    # Roadmap: CPU simulation of a 4-thread x 2-value vector-add ownership plan.
    # Predication protects both reads and the write; no GPU code is executed.
    for count in [1, 8, 19, 32]:
        av = list(range(count))
        bv = [100 - i for i in range(count)]
        cv = [None] * count
        writes = [0] * count
        for block in range((count + 7) // 8):
            for thread in range(4):
                for value in range(2):
                    i = block*8 + thread*2 + value
                    if i < count:
                        cv[i] = av[i] + bv[i]
                        writes[i] += 1
        require_equal(cv, [x + y for x, y in zip(av, bv)], "CPU vector addition")
        require_equal(writes, [1] * count, "one owner per element")
    print("Roadmap: CPU ownership/predication simulation passed for N=1,8,19,32")
    print("All arithmetic checks passed. FlyDSL compilation/GPU execution not tested.")


if __name__ == "__main__":
    main()
