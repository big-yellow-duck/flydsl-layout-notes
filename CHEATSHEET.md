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
| Partial 1-D tile | Divide rounds up; predicate guards data accesses | `19:1 / 8:1` → `(8,3):(1,8)`; valid if index < 19 |
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

For a refresh, recompute composition at `(2,1)` in [lesson 03](lessons/00-layout-algebra/03-composition/README.md), then the selected tile offset in [lesson 05](lessons/00-layout-algebra/05-logical-divide/README.md).

## Native API reminders

Inside a FlyDSL kernel, construct with `fx.make_layout(shape, stride)` and map with `fx.crd2idx(coord, layout)`. Use `fx.size(layout)` and `fx.cosize(layout)` for count and span, and `fx.get_scalar(...)` to store a scalar integer-tuple result.

To assign threads in first-mode-fastest order for a flat 2-D shape, use `fx.idx2crd(q, fx.make_ordered_layout(shape, (0,1)))`. `idx2crd` uses the supplied layout's strides; it is not a shape-only expansion when passed the data layout. Nested shapes need a matching nested order, as in lesson 02.

Run `pixi run lessons-check` for the lesson solutions and focused divide tutorials or `pixi run gpu-check` for additional mapping and sliced-view checks.

A thread layout maps coordinates to thread IDs; invert it with `fx.idx2crd(thread_id, thread_layout)`, then map that coordinate through the data layout. The launch can remain one-dimensional. With `make_ordered_layout`, order entries are speed ranks per axis (0 fastest), not explicit strides or an axis permutation list. Lesson 05 uses `(1,0,3,2)` for axes `(local_row,local_column,tile_row,tile_column)`.

## BF16 matmul reminders

For the [1024³ matmul series](lessons/01-gpu-programming/13-matmul/README.md), flat row-major element offsets are `A: row*K+inner`, `B: inner*N+column`, `C: row*N+column`. Widen BF16 loads before scalar FP32 arithmetic; round once when storing BF16 output.

`fx.make_rmem_tensor(layout, fx.Float32)` allocates private accumulator slots; initialize them with `fill(0)`. `fx.SharedAllocator().allocate(fx.Array[fx.BFloat16, 256]).peek().view(layout)` creates a workgroup LDS view. Use `fx.gpu.barrier()` both after cooperative staging and before overwriting a tile still in use.

On the series' gfx11 wave32 targets, `fx.rocdl.WMMA(16,16,16,fx.BFloat16,fx.Float32)` describes one matrix operation; `fx.make_mma_atom`, `fx.make_tiled_mma`, and `fx.make_tiled_copy_A/B/C` derive its fragments and copies. MMA B uses logical `(N,K)`: row-major physical `(K,N)` storage has operand strides `(1,N)`. This is a view, not a transpose allocation. See lesson 04 for the target-specific lane convention.

Native matmul windows follow `*_global_view -> *_tiled_view -> *_block_view -> *_thread_view`. With `flat_divide`, two-dimensional tiles expose `(local_row,local_col,tile_row,tile_col)`. A `(4,1)` tiler over the `(16,16)` output block yields shape `(4,1,4,16)`; slicing the last two modes selects four output rows for one thread. The resulting `(4,1)` view has row stride 1024 and a canonical singleton-column stride of 0. Stages 00–02 use full-K input windows; stages 03–04 tile K by 16 before staging into LDS.

Stage 01 packs B as `b_gpu.t().contiguous().t()` before launching, preserving logical shape `(K,N)` and values with physical strides `(1,K)`. Its native B global view must use those same strides. Both a row of row-major A and a column of column-major B then have K stride 1. This per-thread property does not establish coalescing across lanes; the per-layout GPU PyTorch baselines use identical packed inputs and exclude packing time. Stages 00/02/03/04 continue to expect row-major B.
