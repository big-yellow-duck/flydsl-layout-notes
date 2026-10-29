# 01 · Coordinates and views

**Mental model:** a coordinate names a logical position; an offset names a position relative to a base pointer. They are different kinds of numbers.

## Why can a 2-D layout accept one integer?

CuTe-style scalar coordinates enumerate the **first shape mode fastest**, recursively. The shape expands the integer into a coordinate; the strides then map that coordinate to an offset.

For `L = (2,4):(4,1)`:

```text
coordinate(q) = (q % 2, q // 2), for 0 <= q < 8
L(q)          = (q % 2)*4 + (q // 2)
```

| Scalar coordinate `q` | Expanded coordinate | Memory offset `L(q)` |
| --- | --- | --- |
| 0 | `(0,0)` | 0 |
| 1 | `(1,0)` | 4 |
| 2 | `(0,1)` | 1 |
| 3 | `(1,1)` | 5 |
| 4 | `(0,2)` | 2 |
| 5 | `(1,2)` | 6 |
| 6 | `(0,3)` | 3 |
| 7 | `(1,3)` | 7 |

So `L(3) = L(1,1) = 5`. Scalar coordinate 3 is **not** memory offset 3.

This is the bridge we need for composition: the output of one layout can be a scalar coordinate for another, even when their shapes differ.

## A tensor view adds storage

For these ordinary memory views, think of a tensor as **base pointer + layout**:

```text
address(coord) = base_pointer + L(coord)*sizeof(element)
```

Making another layout or view does not rearrange the allocation. Later, a load/store/copy uses that view to access data. A register fragment is actual storage and will come later.

**Trap:** do not assume a general layout has a unique inverse from memory offsets to coordinates. Holes may be unreachable, and zero strides may give several coordinates the same offset. Shape-based scalar enumeration is not an inverse of every stride mapping.

**Check yourself:** what is `L(5)` for `(3,2):(2,1)`?

<details><summary>Answer</summary>

Expand 5 as `(5 % 3, 5 // 3) = (2,1)`. Offset is `2*2 + 1 = 5`. The matching input and output numbers are incidental.

</details>

## Practice

### Goal and starting data

For **`L = (2,4):(4,1)`**, trace every scalar logical coordinate `q` from `0` through `7`. For each `q`, return both its expanded `(row,column)` coordinate and its memory offset. The purpose is to keep the two transformations visible:

```text
q --expand through shape--> (row,column) --apply strides--> memory offset
```

Open [`practice.py`](practice.py). The layout, result list, loop bounds, and append operation are provided. Fill in the two `None` values inside the loop. The helpers come from the local [`layout.py`](layout.py):

| Expression | Meaning |
| --- | --- |
| `size(layout.shape)` | Number of scalar logical coordinates, 8 here |
| `expand(q, layout.shape)` | Expand a scalar through the shape, first mode fastest |
| `layout(coordinate)` | Map an explicit tuple to an element offset |
| `layout(q)` | Shorthand that expands the scalar and then applies strides |

### Complete `solve()`

1. Trace `q=2` on paper: `2 % 2 = 0`, `2 // 2 = 1`, so its tuple is `(0,1)`. The memory offset is `0*4 + 1*1 = 1`.
2. Set `coordinate` with `expand(q, layout.shape)`.
3. Set `memory_offset` by passing that tuple to `layout`. Keep the expansion explicit for this exercise.
4. Keep the provided append and return statements. Return a **list of eight pairs** in increasing `q` order, with each pair shaped as `((row,column), memory_offset)`. For example, the entry for `q=2` is `((0,1), 1)`.

### Run and check

From the repository root, run:

```bash
python3 lessons/01-coordinates-and-views/practice.py
python3 lessons/01-coordinates-and-views/solution.py
```

From this lesson directory, use `python3 practice.py` and `python3 solution.py`. The untouched starter reports `Practice not finished: ...`; replace the TODO values and run again. Success prints `Exercise passed:` followed by the list. Compare your code with the commented [worked solution](solution.py) after your attempt.

Check that the first two entries are `((0,0), 0)` and `((1,0), 4)`. The offset column should begin `0,4,1,5`, not `0,1,2,3`. Sorting the offsets or using a row-major nested loop changes the required order. `expand` takes the shape, not the strides, and its input is a logical coordinate, not an offset to invert.

### Try another case

Use scratch code so the required checker stays unchanged:

- Keep shape `(2,4)` but change strides to `(1,2)`. Which column of your result changes: expanded coordinates or offsets? Verify all eight entries.
- With the original layout, apply `layout(q)` directly and check that it agrees with `layout(expand(q, layout.shape))` for every `q`.

[← Shapes and strides](../00-shapes-and-strides/README.md) · [Next: nested layouts →](../02-nested-layouts/README.md)
