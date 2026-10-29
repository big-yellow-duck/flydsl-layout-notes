"""Lesson-local arithmetic model, not the FlyDSL compiler.

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
