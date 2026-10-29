# 02 · Nested layouts

**Mental model:** parentheses preserve hierarchy. One top-level mode can contain its own smaller coordinate system.

```text
L = ((2,2),3):((1,4),8)
coordinate = ((a,b),c)
L((a,b),c) = a + 4*b + 8*c
```

There are two top-level modes: `(2,2)` and `3`. Total size is `2*2*3 = 12`. There are three leaf axes, but the top-level rank is 2.

![Nested layout hierarchy and offsets](../../assets/nested-layout.svg)

## Worked example

For `((1,1),2)`, the offset is `1 + 4 + 16 = 21`.

A scalar coordinate still expands first-mode-fastest. First split into the top-level sizes `(4,3)`, then split the first coordinate into `(2,2)`:

```text
q = 7
top-level: (7 % 4, 7 // 4) = (3,1)
inner:     (3 % 2, 3 // 2) = (1,1)
coordinate: ((1,1),1)
offset: 1 + 4 + 8 = 13
```

## Flattening structure versus coalescing

Writing `(2,2,3):(1,4,8)` removes the grouping while keeping the same leaf order and scalar-coordinate mapping. It does not guarantee a single mode: the sequence has gaps.

Nested modes become useful names for levels such as `(value-within-thread, thread)` or `(position-within-tile, tile-number)`. The algebra does not assign those meanings automatically; we choose them.

```python
# Inside a FlyDSL tracing context
layout = fx.make_layout(((2, 2), 3), ((1, 4), 8))
offset = fx.crd2idx(fx.make_coord((1, 1), 2), layout)  # 21
```

**Trap:** matching shape and stride trees matters. `((2,2),3)` pairs with `((1,4),8)`, not the differently nested `(1,(4,8))`.

**Check yourself:** what are the size, rank, and offset of `((0,1),1)`?

<details><summary>Answer</summary>

Size 12, rank 2, offset 12.

</details>

## Practice

Trace every scalar coordinate of `((2,2),3):((1,4),8)` on 12 GPU threads. The returned checkpoint for `q=7` is `(12, ((1,1),1), 13)`.

Open [`practice.py`](practice.py) and complete the numbered TODOs in **`exercise_kernel()`**. All practice files start unfinished. The allocation, launch, stores, and host checker are supplied; the algebra belongs inside the kernel's FlyDSL tracing context.

### Native APIs and output

`fx.make_ordered_layout(fx.get_shape(layout), ((0,1),2))` constructs the compact nested enumeration layout `((2,2),3):((1,2),4)`. The order ranks leaf strides from fastest to slowest. Inverting that compact mapping expands a logical scalar while preserving the shape tree. Inverting the gapped data layout is a different operation.

`coordinate[0][0]`, `coordinate[0][1]`, and `coordinate[1]` extract the three leaves. The original `coordinate` still has structure `((a,b),c)` when passed to `crd2idx`.

### Complete the kernel

1. Predict the hierarchy at `q=7`: split by 4, then split the remainder by 2.
2. Fill `logical_size` with `fx.size(layout)`.
3. Fill `coordinate` with `fx.idx2crd(q, enumeration)`.
4. Fill `memory_offset` with `fx.crd2idx(coordinate, layout)`. Keep the stores and full-domain checker.

### Run and check

From the repository root, using the [configured GPU environment](../../README.md):

```bash
pixi run python lessons/02-nested-layouts/practice.py
pixi run python lessons/02-nested-layouts/solution.py
```

An unfinished starter exits with `Practice not finished: ...` during tracing. Fill each TODO with a native API expression, then rerun. A correct exercise prints `Exercise passed:` and its checkpoint. Compare with the commented [worked solution](solution.py) after your attempt.

`@flyc.kernel` traces the device computation; `@flyc.jit` traces its launch. `solve()` allocates a PyTorch GPU output, launches exactly as many threads as there are positions, synchronizes, and copies results to the host for assertions. PyTorch uses the device name `cuda` on ROCm too. These tiny launches need no tail predicate because each thread has one valid output row. General-sized launches will need bounds handling.

### Troubleshooting and another case

An answer of 2 for size confuses rank with logical size. Check `q=4`: `((0,0),1)` maps to 8. In a scratch kernel compare scalar offsets with the flat layout `(2,2,3):(1,4,8)`.

Use a scratch copy for extensions and update its launch size and expected results together. Do not replace computations with the expected constants. Static layout construction may fold during compilation; mappings depend on `fx.thread_idx.x` and are checked across the complete small domain.

[← Coordinates and views](../01-coordinates-and-views/README.md) · [Next: composition →](../03-composition/README.md)
