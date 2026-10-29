# 05 · Logical divide: expose tile windows

**Mental model from our discussion:** create windows into the original layout. Each coordinate now says both **where inside a tile** and **which tile**.

## Start in one dimension

Divide `A = 16:1` by the contiguous tiler `T = 4:1`:

```text
D = (4,4):(1,4)
D(within,tile) = within + 4*tile
```

Tile 2 names offsets `8,9,10,11`. This is a view into the original storage.

```python
# Inside a FlyDSL tracing context; A is a tensor view
divided = fx.logical_divide(A, fx.make_layout(4, 1))
tile_2 = fx.slice(divided, (None, 2))
```

`None` keeps all positions of that mode; fixing the tile number removes that mode. Slicing a tensor view carries the selected tile's base offset. A bare layout alone describes relative offsets, not the allocation base.

## Why composition appears underneath

For this contiguous example, the tiler is `T = 4:1`, and its complement within logical size 16 is `T* = 4:4`. The complement tells us how to repeat the tile.

```text
logical_divide(A,T) = composition(A, (T,T*))
```

Think **tile pattern + repetition pattern**, then pass the combined logical indices through A. General strided tilers can select noncontiguous patterns; the simple quotient formula below is for contiguous, evenly dividing tiles.

## Two dimensions: make the parentheses explicit

Take row-major `A = (4,8):(8,1)` and tile shape `(2,4)`. There are `(2,2)` tiles.

![Matrix tiles, selected window, and nested coordinate](../../assets/logical-divide.svg)

For local coordinates `(m,n)` and tile coordinates `(p,q)`:

```text
original row    = m + 2*p
original column = n + 4*q
offset = (m + 2*p)*8 + (n + 4*q)
       = 8*m + 16*p + n + 4*q
```

All four divide variants describe this same tiled access with different grouping:

| Variant | Shape | Stride | Coordinate form |
| --- | --- | --- | --- |
| `logical_divide` | `((2,2),(4,2))` | `((8,16),(1,4))` | `((m,p),(n,q))` |
| `zipped_divide` | `((2,4),(2,2))` | `((8,1),(16,4))` | `((m,n),(p,q))` |
| `tiled_divide` | `((2,4),2,2)` | `((8,1),16,4)` | `((m,n),p,q)` |
| `flat_divide` | `(2,4,2,2)` | `(8,1,16,4)` | `(m,n,p,q)` |

This refines our earlier “four dimensions” description: there are four leaf coordinates, but logical divide keeps them nested by original axis. **Flat divide** gives four top-level modes in this example. Corresponding tuple coordinates agree on offsets; using the same scalar coordinate across reordered variants need not agree.

```python
# Inside a FlyDSL tracing context
layout = fx.make_layout((4, 8), (8, 1))
logical = fx.logical_divide(layout, (2, 4))  # tuple tiler: split by mode
flat = fx.flat_divide(layout, (2, 4))

# For a tensor view A with that layout:
zipped = fx.zipped_divide(A, (2, 4))
tile = fx.slice(zipped, (None, (1, 1)))
```

Tile `(1,1)` has base offset `2*8 + 4 = 20` and relative layout `(2,4):(8,1)`. Local `(1,2)` maps to original `(3,6)`, offset `30`.

**Trap:** `fx.make_layout((2,4),(1,2))` is one layout tiler acting on a scalar domain. Passing the tuple tiler `(2,4)` requests a split of each original mode. These are not interchangeable.

## Boundaries come next

All examples here divide evenly. Real vector addition often ends with a partial tile. A divided view does not make an out-of-bounds load safe: the eventual kernel needs a suitable mask/predicate (or a separately handled tail). We will derive that with coordinate tensors.

**Check yourself:** in tile `(0,1)`, where does local `(1,3)` land? Give the logical-divide and flat-divide coordinates.

<details><summary>Answer</summary>

Original `(1,7)`, offset 15. Logical coordinate `((1,0),(3,1))`; flat coordinate `(1,3,0,1)`.

</details>

## Practice

### Goal and starting data

Start with a row-major matrix **`A = (4,8):(8,1)`**, split it into **`(2,4)` tiles**, and enumerate the offsets of **tile `(1,1)`**. Tile coordinates and local coordinates are zero-based. The matrix has two tile rows and two tile columns.

Open [`practice.py`](practice.py). The original layout, tile shape, selected tile, flat-divide shape, and nested loops are provided. Fill in `divided_stride` and `memory_offset`. The local [`layout.py`](layout.py) evaluates explicitly constructed layouts; it has no `logical_divide`, `flat_divide`, or slicing API to call in this exercise.

### Derive the divided layout

Use a flat coordinate **`(m,n,p,q)`**:

| Name | Meaning | Valid values |
| --- | --- | --- |
| `m` | Row within the tile | `0..1` |
| `n` | Column within the tile | `0..3` |
| `p` | Tile row | `0..1` |
| `q` | Tile column | `0..1` |

The original coordinate is `(m + 2*p, n + 4*q)`. Derive each stride by changing just one coordinate by one:

1. A step in `m` advances one original row, so use the original row stride.
2. A step in `n` advances one original column, so use the original column stride.
3. A step in `p` advances `tile_shape[0]` original rows, so multiply the row stride by that tile size.
4. A step in `q` advances `tile_shape[1]` original columns, so multiply the column stride by that tile size.

### Complete `solve()`

1. Set `divided_stride` to the **four-integer tuple** you derived, ordered `(m,n,p,q)`. The provided `Layout((2,4,2,2), divided_stride)` represents the flat-divide view.
2. Keep `p,q` fixed at the selected tile `(1,1)`. The provided loops enumerate `m` outside and `n` inside, giving **row-major local order**.
3. Set `memory_offset` by calling `divided` with the explicit tuple `(m,n,p,q)`.
4. Keep the append and return statements. Return a **flat list of eight integers**, the first local row followed by the second.

As a separate checkpoint, tile `(0,1)` begins at original coordinate `(0,4)`, offset 4. Its local coordinate `(1,2)` lands at `(1,6)`, offset 14. For any tile, you can verify a divided offset independently with `original((m + 2*p, n + 4*q))`.

### Run and check

From the repository root:

```bash
python3 lessons/05-logical-divide/practice.py
python3 lessons/05-logical-divide/solution.py
```

From this lesson directory, use `python3 practice.py` and `python3 solution.py`. The untouched file reports `Practice not finished: ...`. After completing both TODOs, expect `Exercise passed: [20, 21, 22, 23, 28, 29, 30, 31]`. Compare with the commented [worked solution](solution.py) after your attempt.

If you get `20,28,21,29,...`, you enumerated the local row first-mode-fastest rather than using the required row-major local order. If you get `0,1,2,3,8,9,10,11`, you omitted the selected tile's base offset. `divided((m,n,p,q))` already includes that base; do not add it again. Logical-divide coordinates have a different nesting, `((m,p),(n,q))`, and cannot be passed unchanged to this flat layout.

### Try another case

Use scratch code so the required checker stays unchanged:

- Select tile `(0,1)` and verify all eight offsets against the original matrix coordinates.
- Loop over all four tiles and collect their eight offsets. Check that sorting the resulting 32 offsets gives `list(range(32))`, with each original position visited once.
- Construct the lesson's logical-divide layout `Layout(((2,2),(4,2)), ((8,16),(1,4)))`. For every local and tile coordinate, compare `logical(((m,p),(n,q)))` with `divided((m,n,p,q))`. Use matching explicit coordinates, not equal scalar indices across regrouped variants.

[← Coalescing](../04-coalescing/README.md) · [Continue with the roadmap →](../../ROADMAP.md)
