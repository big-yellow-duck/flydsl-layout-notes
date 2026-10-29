# Layout algebra: quick revision

| Concept | Remember | Tiny example |
| --- | --- | --- |
| Shape | Valid coordinate extents | `(3,4)` has 12 positions |
| Stride | Offset increment per axis, in elements | `(4,1)` means row +4, col +1 |
| Layout | Coordinate → offset | `(3,4):(4,1)` maps `(2,1)` to 9 |
| Scalar coordinate | Expand by shape, first mode fastest | For shape `(2,4)`, 5 means `(1,2)` |
| Nested mode | Keep hierarchy in the blueprint | `((2,2),3)` has rank 2, size 12 |
| Tensor view | Base pointer + layout | Same storage can have several views |
| Composition | B picks logical positions in A | `R(c) = A(B(c))` |
| Coverage | Application choice, not required for composition | B can select a subset of A |
| Coalesce | Preserve scalar-coordinate offset sequence | `(2,4):(1,2)` → `8:1` |
| Logical divide | Expose within-tile and tile-number modes | `16:1 / 4:1` → `(4,4):(1,4)` |
| Slice | Fix a coordinate; keep `None` modes | `(None,2)` selects tile 2 |

## Three calculations to remember

```text
offset = sum(coordinate_leaf * stride_leaf)
composition(A,B)(c) = A(B(c))
contiguous 1-D tiling: original_index = within + tile_size*tile_number
```

## Two-dimensional divide grouping

For original `(M,N)` tiled by `(TM,TN)`; `RM=M/TM`, `RN=N/TN` here:

| Divide | Result shape |
| --- | --- |
| Logical | `((TM,RM),(TN,RN))` |
| Zipped | `((TM,TN),(RM,RN))` |
| Tiled | `((TM,TN),RM,RN)` |
| Flat | `(TM,TN,RM,RN)` |

## Common confusions

- Shape says how many positions, not how storage is ordered.
- A scalar logical coordinate is not generally a memory offset.
- Coalescing preserves an ordered mapping, not just an offset set.
- Neither composition nor division physically copies values.
- Logical divide's nested pairs are not four top-level modes.
- A layout tiler and a tuple of per-mode tilers have different semantics.
- Valid layout arithmetic does not automatically guarantee bounds-safe GPU memory access.

For a refresh, recompute composition at `(2,1)` in [lesson 03](lessons/03-composition/README.md), then the selected tile offset in [lesson 05](lessons/05-logical-divide/README.md).

## Native API reminders

Inside a FlyDSL kernel, construct with `fx.make_layout(shape, stride)` and map with `fx.crd2idx(coord, layout)`. Use `fx.size(layout)` and `fx.cosize(layout)` for count and span, and `fx.get_scalar(...)` to store a scalar integer-tuple result.

To expand logical q for a flat 2-D shape, use `fx.idx2crd(q, fx.make_ordered_layout(shape, (0,1)))`. `idx2crd` uses the supplied layout's strides; it is not a shape-only expansion when passed the data layout. Nested shapes need a matching nested order, as in lesson 02.

Run `pixi run lessons-check` for the six native worked solutions or `pixi run gpu-check` for additional mapping and sliced-view checks.
