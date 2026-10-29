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

Expand each scalar logical coordinate of `(2,4):(4,1)` and map the resulting tuple to an offset. Eight threads cover `q=0..7`.

Open [`practice.py`](practice.py) and complete the numbered TODOs in **`exercise_kernel()`**. All practice files start unfinished. The allocation, launch, stores, and host checker are supplied; the algebra belongs inside the kernel's FlyDSL tracing context.

### Native APIs and output

`enumeration = fx.make_ordered_layout(fx.get_shape(layout), (0,1))` makes a compact first-mode-fastest layout with strides `(1,2)`. **`idx2crd` uses strides:** applying it to the data layout would interpret q as a memory index, not as a scalar logical coordinate. Applying it to the compact enumeration layout performs the shape expansion we want.

`solve()` returns eight `((row,column), offset)` pairs; the first two are `((0,0),0)` and `((1,0),4)`.

### Complete the kernel

1. Trace `q=2`: the logical tuple is `(0,1)` and its offset is 1.
2. Fill `coordinate` with `fx.idx2crd(q, enumeration)`.
3. Fill `memory_offset` with `fx.crd2idx(coordinate, layout)`.
4. Keep all four stores: row, column, explicit-coordinate offset, and direct scalar-coordinate offset. The last two must agree for every thread.

### Run and check

From the repository root, using the [configured GPU environment](../../README.md):

```bash
pixi run python lessons/01-coordinates-and-views/practice.py
pixi run python lessons/01-coordinates-and-views/solution.py
```

An unfinished starter exits with `Practice not finished: ...` during tracing. Fill each TODO with a native API expression, then rerun. A correct exercise prints `Exercise passed:` and its checkpoint. Compare with the commented [worked solution](solution.py) after your attempt.

`@flyc.kernel` traces the device computation; `@flyc.jit` traces its launch. `solve()` allocates a PyTorch GPU output, launches exactly as many threads as there are positions, synchronizes, and copies results to the host for assertions. PyTorch uses the device name `cuda` on ROCm too. These tiny launches need no tail predicate because each thread has one valid output row. General-sized launches will need bounds handling.

### Troubleshooting and another case

The offset sequence must begin `0,4,1,5`; do not sort it. In a scratch copy, change the data strides to `(1,2)`: the expanded coordinates stay the same while the offsets change.

Use a scratch copy for extensions and update its launch size and expected results together. Do not replace computations with the expected constants. Static layout construction may fold during compilation; mappings depend on `fx.thread_idx.x` and are checked across the complete small domain.

[← Shapes and strides](../00-shapes-and-strides/README.md) · [Next: nested layouts →](../02-nested-layouts/README.md)
