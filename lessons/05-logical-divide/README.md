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

[← Coalescing](../04-coalescing/README.md) · [Continue with the roadmap →](../../ROADMAP.md)

## Practice

Run `python3 practice.py`, complete `solve()`, and compare with `solution.py` after the checks pass. Both use the repository’s CPU layout model; the FlyDSL examples above require a tracing context.
