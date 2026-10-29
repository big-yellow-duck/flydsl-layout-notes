# 05 · Logical divide: expose tile windows

**The question:** given a layout for a whole array, how can we address it using both a position **inside a tile** and the identity of **the tile**?

Logical divide constructs that new coordinate system. The result is another layout over the original storage. Its coordinates tell us more about the position we are addressing:

```text
Before: original position
After:  (position within a tile, which tile)
```

Start with the data layout, derive its tiled coordinates, and then assign GPU threads to those coordinates. Dividing a layout does not itself choose the thread assignment or launch any GPU work.

## 1. Split one axis before thinking about a matrix

Take a vector with layout `A = 16:1`: 16 positions, each one element apart. We want tiles of four consecutive positions.

```text
Original index:  0  1  2  3 | 4  5  6  7 | 8  9 10 11 |12 13 14 15
Tile number:    0  0  0  0 | 1  1  1  1 | 2  2  2  2 | 3  3  3  3
Within tile:    0  1  2  3 | 0  1  2  3 | 0  1  2  3 | 0  1  2  3
```

Let `local_index` be the position within a tile and `tile_index` the tile number. The original index is:

```text
original_index = local_index + 4*tile_index
```

Both coordinates range from 0 through 3. Increasing `local_index` by one advances one element; increasing `tile_index` by one advances four elements. That gives the divided layout:

```text
D = (4,4):(1,4)
     │ │   │ │
     │ │   │ └─ stride between tiles
     │ │   └─── stride within a tile
     │ └─────── number of tiles: 16/4
     └───────── positions per tile: 4
```

There are still `4*4 = 16` logical positions. We have factored the coordinate space, not reduced the number of elements.

In native FlyDSL, inside a kernel or other tracing context:

```python
original = fx.make_layout(16, 1)
tiler = fx.make_layout(4, 1)
divided = fx.logical_divide(original, tiler)
offset = fx.crd2idx(fx.make_coord(2, 2), divided)  # 10
```

The **tiler** describes how to visit positions within one tile. Here `4:1` selects four consecutive logical positions. FlyDSL supplies the repetition pattern needed to cover the original domain. For tile 2, coordinates `(0,2)`, `(1,2)`, `(2,2)`, `(3,2)` name offsets `8,9,10,11`.

**Manual checkpoint:** why is `D(1,3)` equal to 13? The local coordinate contributes 1; the tile coordinate contributes `3*4`.

## 2. Why this is layout algebra, not just integer division

`16/4 = 4` tells us how many tiles there are. It does not describe how their coordinates map to memory. Logical divide constructs the whole mapping, including the strides and coordinate grouping.

For our contiguous tiler, think of two patterns:

| Pattern | Layout | Indices it contributes |
| --- | --- | --- |
| Within one tile | `T = 4:1` | `0,1,2,3` |
| Repeat the tile | `T* = 4:4` | `0,4,8,12` |

The repetition pattern is called a **complement**. Combining the patterns gives `local_index + 4*tile_index`, a logical index into A. Composition then applies A's mapping:

```text
D(local_index,tile_index) = A(T(local_index) + T*(tile_index))
    = A(local_index + 4*tile_index)
```

For this example, the combined layout is `(4,4):(1,4)`. This is the connection to lesson 03: a layout first chooses logical positions in A, then A maps them to storage offsets.

The original strides still matter. If A instead had stride 2, the same logical tiling would produce data strides `(2,8)`: a local step advances two storage elements and a tile step advances eight. The tiler describes logical positions in A, not a byte count or an allocation.

We use contiguous, evenly dividing tiles throughout this lesson. General strided tilers and their complements need more algebra than the simple quotient above.

## 3. Divide the rows and columns independently

Now take the row-major matrix:

```text
A = (4,8):(8,1)
offset(row,column) = 8*row + column
```

We want tiles with **2 rows and 4 columns**. The tile shape `(2,4)` tells us how much of each original axis goes inside a tile. There are `4/2 = 2` tile rows and `8/4 = 2` tile columns: four tiles, each with eight positions.

![Matrix tiles, selected window, and nested coordinate](../../../assets/logical-divide.svg)

Use distinct names for the four coordinates:

| Coordinate | Meaning | Range |
| --- | --- | --- |
| `local_row` | Local row within a tile | `0..1` |
| `local_col` | Local column within a tile | `0..3` |
| `tile_row` | Tile row | `0..1` |
| `tile_col` | Tile column | `0..1` |

Use `thread_id` for the GPU thread ID. It identifies an owner, while the four coordinates above identify a position in the tiled matrix.

Split each original axis just as we split the vector:

```text
row    = local_row + 2*tile_row
column = local_col + 4*tile_col
```

Substitute those into A's mapping:

```text
offset = 8*(local_row + 2*tile_row) + (local_col + 4*tile_col)
       = 8*local_row + 16*tile_row + local_col + 4*tile_col
```

Read off the strides by moving one coordinate at a time:

| Step | Change in the original matrix | Offset increment |
| --- | --- | --- |
| `local_row += 1` | One row | 8 |
| `tile_row += 1` | Two rows | 16 |
| `local_col += 1` | One column | 1 |
| `tile_col += 1` | Four columns | 4 |

Logical divide keeps each original axis together: the row becomes `(local row, tile row)`, and the column becomes `(local column, tile column)`.

```text
original shape: (4, 8)
divided shape:  ((2, 2), (4, 2))
coordinate:     ((local_row, tile_row), (local_col, tile_col))
stride:         ((8, 16), (1, 4))
```

So there are **two top-level modes**, each containing two coordinates. The size is still `(2*2)*(4*2) = 32`.

```python
original = fx.make_layout((4, 8), (8, 1))
logical = fx.logical_divide(original, (2, 4))
coordinate = fx.make_coord((1, 1), (2, 1))
offset = fx.crd2idx(coordinate, logical)  # 30
```

Trace it: local `(1,2)` in tile `(1,1)` becomes original `(3,6)`, whose offset is `3*8 + 6 = 30`.

### Why pass `(2,4)` rather than `make_layout((2,4),(1,2))`?

The tuple `(2,4)` requests **per-mode tiling**: divide the row mode into groups of 2 and the column mode into groups of 4.

A single layout tiler such as `fx.make_layout((2,4),(1,2))` describes one mapping into the original layout's scalar logical domain. It does not request the same independent row/column split. Having eight positions in either tiler is not enough to make them equivalent. Use the tuple tiler for this matrix exercise.

## 4. Four divide variants: choose how to group the coordinates

For these regular tiles, all four variants represent the same accesses. They organize the coordinate tree differently:

| Variant | How to read its coordinate | Shape | Stride |
| --- | --- | --- | --- |
| `logical_divide` | `((local_row,tile_row),(local_col,tile_col))`: keep each original axis together | `((2,2),(4,2))` | `((8,16),(1,4))` |
| `zipped_divide` | `((local_row,local_col),(tile_row,tile_col))`: all local coordinates, then all tile coordinates | `((2,4),(2,2))` | `((8,1),(16,4))` |
| `tiled_divide` | `((local_row,local_col),tile_row,tile_col)`: keep the local tile grouped; expose tile axes separately | `((2,4),2,2)` | `((8,1),16,4)` |
| `flat_divide` | `(local_row,local_col,tile_row,tile_col)`: expose all four axes separately | `(2,4,2,2)` | `(8,1,16,4)` |

The names are easier to remember with the coordinate tree beside them. Logical divide explains how each original axis splits. Zipped divide is convenient for selecting an entire tile. Flat divide makes the four axes explicit in this exercise.

Here is the **same position**, evaluated through each native variant:

```python
logical = fx.logical_divide(original, (2, 4))
zipped = fx.zipped_divide(original, (2, 4))
tiled = fx.tiled_divide(original, (2, 4))
flat = fx.flat_divide(original, (2, 4))

local_row, local_col = 1, 2
tile_row, tile_col = 1, 1

# Same named position, different grouping: every result is offset 30.
logical_coord = fx.make_coord((local_row, tile_row), (local_col, tile_col))
zipped_coord = fx.make_coord((local_row, local_col), (tile_row, tile_col))
tiled_coord = fx.make_coord((local_row, local_col), tile_row, tile_col)
flat_coord = fx.make_coord(local_row, local_col, tile_row, tile_col)

fx.crd2idx(logical_coord, logical)
fx.crd2idx(zipped_coord, zipped)
fx.crd2idx(tiled_coord, tiled)
fx.crd2idx(flat_coord, flat)
```

Compare **corresponding tuple coordinates**, not equal scalar indices. A scalar enumerates the shape first-mode-fastest, so changing the leaf order can change what that scalar names. For example, scalar 2 maps to offset 16 in logical divide but offset 1 in flat divide. That does not contradict their agreement at corresponding positions.

## 5. Select one window with `slice`

Dividing exposes all the tiles. Slicing fixes which one we want.

Suppose `A` is a **tensor view** with the matrix layout above:

```python
# Inside a tracing context; A includes a pointer to the matrix storage.
zipped = fx.zipped_divide(A, (2, 4))
tile = fx.slice(zipped, (None, (1, 1)))
```

Read the slice coordinate against the zipped grouping `((local_row,local_col),(tile_row,tile_col))`:

- `None` keeps the entire local-coordinate group `(local_row,local_col)`.
- `(1,1)` fixes the tile-coordinate group `(tile_row,tile_col)`.

The remaining view has local layout `(2,4):(8,1)` and starts at original offset `2*8 + 4 = 20`. Its local positions address:

| Local row | Column 0 | Column 1 | Column 2 | Column 3 |
| --- | --- | --- | --- | --- |
| 0 | 20 | 21 | 22 | 23 |
| 1 | 28 | 29 | 30 | 31 |

The row stride stays **8**, even though the tile has only four columns. A tile is a window into the original matrix; its two rows have not been packed into a new contiguous allocation.

For local `(1,2)`, the relative offset is `1*8 + 2 = 10`, and the view's base contributes 20. A load through `tile` therefore reads original offset 30. Do not add the tile base again when indexing that view.

This base adjustment belongs to the tensor view. A bare layout describes relative offsets and has no storage pointer to advance. The [GPU check](../../../examples/gpu_layout_check.py) tests actual loads through sliced views, including this matrix tile and the vector's tile 2.

## 6. Give GPU threads positions in the divided layout

We now have a data mapping with flat coordinates `(local_row,local_col,tile_row,tile_col)`. A separate thread layout tells us which thread owns each coordinate.

The exercise assigns 32 threads, one per matrix position. We want consecutive threads to move across a tile's columns, then its rows, then move to the next tile column, and finally the next tile row:

```python
thread_id = fx.thread_idx.x
# Axes: (local_row, local_col, tile_row, tile_col).
thread_layout = fx.make_ordered_layout((2, 4, 2, 2), (1, 0, 3, 2))
coordinate = fx.idx2crd(thread_id, thread_layout)

original = fx.make_layout((4, 8), (8, 1))
divided = fx.flat_divide(original, (2, 4))
memory_offset = fx.crd2idx(coordinate, divided)
```

The order entries are **speed ranks per axis**: `local_col` has rank 0, `local_row` rank 1, `tile_col` rank 2, and `tile_row` rank 3. FlyDSL derives thread strides `(4,1,16,8)`.

Compare the two mappings on exactly the same coordinate domain:

```text
# Same coordinate: (local_row, local_col, tile_row, tile_col)
thread_id   = 4*local_row + local_col + 16*tile_row + 8*tile_col
data_offset = 8*local_row + local_col + 16*tile_row + 4*tile_col
```

The kernel reverses the first mapping with `idx2crd`, then applies the second with `crd2idx`. The GPU block remains one-dimensional; these layouts give its thread IDs meaning.

| `thread_id` | Decoded `(local_row,local_col,tile_row,tile_col)` | Original `(row,column)` | Data offset |
| --- | --- | --- | --- |
| 0 | `(0,0,0,0)` | `(0,0)` | 0 |
| 4 | `(1,0,0,0)` | `(1,0)` | 8 |
| 8 | `(0,0,0,1)` | `(0,4)` | 4 |
| 24 | `(0,0,1,1)` | `(2,4)` | 20 |
| 30 | `(1,2,1,1)` | `(3,6)` | 30 |

Threads 0–7 own tile `(0,0)`, 8–15 own `(0,1)`, 16–23 own `(1,0)`, and 24–31 own `(1,1)`. Eight threads per tile is our teaching assignment; divide itself does not prescribe it. Later, each thread can own multiple values.

Use `local_row, local_col, tile_row, tile_col = coordinate.unpack()` to name the four decoded values. `make_coord` can then regroup them for the other divide variants. That regrouping preserves the logical position; it does not manually decode the thread ID.

## Practice

Open [`practice.py`](practice.py). The thread layout, launch, stores, and host checker are supplied. Complete the two TODOs in `exercise_kernel()`:

1. Derive the flat data strides `(8,1,16,4)` on paper by changing each coordinate by one. Keep these distinct from the thread strides `(4,1,16,8)`.
2. Fill `divided` with `fx.flat_divide(original, (2,4))`.
3. Fill `memory_offset` with `fx.crd2idx(coordinate, divided)`.
4. Keep the four additional output stores. They check logical, zipped, tiled, and original-matrix mappings against your flat-divide result.

Before running, trace thread 8: its coordinate is `(0,0,0,1)`, so the data offset must be 4. This catches the mistake of returning the thread ID as the data offset.

From the repository root, using the [configured GPU environment](../../../README.md):

```bash
pixi run python lessons/00-layout-algebra/05-logical-divide/practice.py
pixi run python lessons/00-layout-algebra/05-logical-divide/solution.py
```

An unfinished starter exits with `Practice not finished: ...` during tracing. A correct exercise prints:

```text
Exercise passed: [20, 21, 22, 23, 28, 29, 30, 31]
```

That printed list is tile `(1,1)`, in local row-major order. Before returning it, `solve()` checks **all 32 positions across all five output columns** and verifies that the tiles cover offsets `0..31` exactly once. Compare with the [worked solution](solution.py) after your attempt. Run `pixi run gpu-check` to check the sliced tensor loads too.

`@flyc.kernel` traces the layout operations and GPU computation; `@flyc.jit` traces the launch. Static layout algebra can simplify during compilation. The coordinates depend on `fx.thread_idx.x`, so the mappings are evaluated for GPU threads. The host allocates output storage, synchronizes, and checks the returned values.

### Troubleshooting

| Observation | What to check |
| --- | --- |
| Selected offsets begin `20,28,21,29` | Your thread order advances local rows before columns. |
| Selected offsets begin `0,1,2,3` | You omitted the tile coordinate or selected tile `(0,0)`. |
| Thread 8 returns offset 8 | You may be using the thread layout as the data layout. |
| Coordinate structure is rejected | Match the nesting to the divide variant; logical divide expects `((local_row,tile_row),(local_col,tile_col))`. |
| Sliced loads read the wrong tile | Check the fixed tile coordinate and whether you added the base offset twice. |

### Check yourself

In tile `(0,1)`, where does local `(1,3)` land? Give the original matrix coordinate, logical-divide coordinate, flat-divide coordinate, and owning thread ID under this exercise's thread layout.

<details><summary>Answer</summary>

Original coordinate `(1,7)`, data offset 15. The logical-divide coordinate is `((1,0),(3,1))`; the flat-divide coordinate is `(1,3,0,1)`. Its owner is thread `4*1 + 3 + 16*0 + 8*1 = 15`. That matching ID and offset is incidental; thread 8 and offset 4 above demonstrate the distinction.

</details>

### Try another thread assignment

In a scratch copy, change the thread order to `(0,1,2,3)`. Keep the data layout and divide operation unchanged. Predict the first four coordinates and their offsets before running. The first four data offsets become `0,8,1,9`; the matrix storage has not changed, but ownership and output order have. Update the expected output in that copy: local rows now change fastest, and the tile order becomes `(0,0)`, `(1,0)`, `(0,1)`, `(1,1)`. Each tile still has eight consecutive owners, but their local traversal and the middle two tile assignments change.

## Boundaries come next

These tiles divide the matrix evenly, and the launch has exactly one thread per valid position. Real workloads can have partial tiles. A divided view does not make out-of-bounds loads safe; those accesses need predicates or separate tail handling. The next lessons will connect tile selection, thread/value ownership, and guarded loads and stores.

[← Coalescing](../04-coalescing/README.md) · [Next: select a block tile →](../06-select-block-tile/README.md)
