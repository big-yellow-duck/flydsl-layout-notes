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

[← Shapes and strides](00-shapes-and-strides.md) · [Next: nested layouts →](02-nested-layouts.md)
