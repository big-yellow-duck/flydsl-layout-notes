# 2. `zipped_divide`

**Goal:** take a 4-row × 8-column matrix, expose 2-row × 4-column windows, and read tile `(1,1)`.

Group the local position and the tile position separately. This is convenient when selecting an entire tile using one grouped tile coordinate.

## Follow these four steps

`source` is the GPU tensor passed into the kernel. The host creates it as 32 values in a one-dimensional view. We want to interpret those same values as a matrix.

```python
# 1. Describe the matrix indexing.
matrix_layout = fx.make_layout((4, 8), (8, 1))

# 2. Apply that indexing to existing GPU storage.
matrix = fx.make_view(fx.get_iter(source), matrix_layout)

# 3. Expose tile windows.
windows = fx.zipped_divide(matrix, (2, 4))

# 4. Select tile row 1, tile column 1.
tile = fx.slice(windows, (None, (1, 1)))
```

| Name | What it means |
| --- | --- |
| `source` | Existing GPU storage, initially viewed as 32 elements |
| `matrix_layout` | The indexing rule `(4,8):(8,1)`; no data or pointer |
| `matrix` | The same storage interpreted as a 4-by-8 matrix |
| `windows` | The same storage addressed using local and tile coordinates |
| `tile` | One selected 2-by-4 window into that storage |

`fx.get_iter(source)` gets the start of the existing storage. `fx.make_view` attaches the matrix indexing rule to it. Neither operation copies values or allocates another matrix. The actual read happens later at `tile[local_coordinate]`.

## What the divide produces

The tuple `(2,4)` means two original rows and four original columns per tile. It gives a 2-by-2 grid of windows. A layout tiler has different semantics; see the [visual comparison](../tuple-vs-layout.md) when you want to explore that distinction.

This variant organizes `windows` as:

```text
Coordinate: ((local_row, local_col), (tile_row, tile_col))
Shape:      ((2,4),(2,2))
Stride:     ((8,1),(16,4))
```

For all four variants, the original position is:

```text
row = local_row + 2 * tile_row
col = local_col + 4 * tile_col
```

Only the coordinate grouping differs. The positions and underlying storage remain the same.

## Read the slice against that grouping

```python
tile = fx.slice(windows, (None, (1, 1)))
```

The first `None` keeps the entire local group `(local_row, local_col)`. The second group `(1,1)` fixes `(tile_row, tile_col)`.

After fixing the tile coordinates, only `(local_row, local_col)` remains. The selected view has shape `(2,4)`, strides `(8,1)`, and its base starts at original offset 20.

```text
Selected storage offsets:       Values stored there:
20 21 22 23                     120 121 122 123
28 29 30 31                     128 129 130 131
```

The host initializes each value as `100 + offset`. That is why the returned values are not the offsets themselves. The selected tile's row stride stays 8: slicing does not pack its rows into a new allocation.

## Give eight threads the eight local positions

Once the tile is selected, all four variants have the same local shape. They can therefore use the **same** thread layout:

```python
thread_id = fx.thread_idx.x
thread_layout = fx.make_ordered_layout((2, 4), (1, 0))
local_coordinate = fx.idx2crd(thread_id, thread_layout)
out[thread_id] = tile[local_coordinate]
```

Order `(1,0)` makes local columns advance fastest. Threads 0–3 read the first local row; threads 4–7 read the second.

Trace thread 6: its local coordinate is `(1,2)`. The relative offset within the tile is `1*8 + 2 = 10`. The selected view already carries base offset 20, so it reads original offset 30 and returns value **130**. Do not add the base again.

You only need a four-coordinate thread layout when assigning threads across **all windows before slicing**. That more advanced comparison is in the [overview](../README.md#optional-thread-layouts-before-selecting-a-tile) and the [combined exercise](../solution.py). Here, select first and index locally.

## Practice

Open [practice.py](practice.py). The matrix setup, local thread layout, launch, and checker are supplied. Fill the two expressions if unfinished:

1. `windows = fx.zipped_divide(matrix, (2,4))`
2. `tile = fx.slice(windows, (None, (1, 1)))`

From the repository root:

```bash
pixi run python lessons/00-layout-algebra/05-logical-divide/02-zipped/practice.py
pixi run python lessons/00-layout-algebra/05-logical-divide/02-zipped/solution.py
```

A completed exercise prints `Exercise passed: [120,121,122,123,128,129,130,131]` (with normal Python spacing). It checks all eight actual GPU loads from the selected tile. The [worked solution](solution.py) follows the same four-step flow. The combined exercise separately checks every matrix position across all variants.

**Check yourself:** why is the tile's row stride 8 rather than 4?

<details><summary>Answer</summary>

It still refers to rows of the original eight-column matrix. Selecting four columns does not move those values or close the gap between rows.

</details>

[Divide overview](../README.md) · [Previous variant](../01-logical/README.md) · [Next variant](../03-tiled/README.md)
