# 07 · Give each thread multiple values

A thread ID need not identify just one element. Introduce a second coordinate, `value_id`, to identify a value owned by that thread. Four threads with two values each still cover an eight-element tile.

The kernel follows **describe ownership → select this thread's value coordinates → map them to tile positions → record the positions**. It has no input data to load yet. The following lesson attaches an ownership plan to real source and destination views.

## Two ownership plans

```python
adjacent = fx.make_layout((4, 2), (2, 1))
interleaved = fx.make_layout((4, 2), (1, 4))
coordinate = fx.make_coord(thread_id, value_id)
local_index = fx.crd2idx(coordinate, adjacent)
```

| Thread | Adjacent values | Interleaved values |
| --- | --- | --- |
| 0 | 0, 1 | 0, 4 |
| 1 | 2, 3 | 1, 5 |
| 2 | 4, 5 | 2, 6 |
| 3 | 6, 7 | 3, 7 |

For adjacent ownership, `local_index = 2*thread_id + value_id`. For interleaved ownership, `local_index = thread_id + 4*value_id`. These formulas explain the two native layouts; the kernel evaluates them with `crd2idx`.

The launch has **four threads**, not eight. Each thread executes two statically unrolled value positions. Python `range(2)` runs during tracing and emits operations for both values; the resulting loads or stores would execute on the GPU.

In earlier lessons a compact thread layout mapped positions to thread IDs, and we inverted it. Here the domain explicitly includes both thread and value IDs, and we map forward to tile positions. These are different directions of mapping, not contradictory conventions.

## Practice

Construct `adjacent` and `interleaved` using the two shape/stride pairs above. Each output row holds `[adjacent_value_0, adjacent_value_1, interleaved_value_0, interleaved_value_1]`. The checker verifies the complete ownership table.

Trace thread 2 before running: it should output `[4,5,2,6]`. Both plans cover offsets 0–7 exactly once. Neither duplicates or omits an element.

## What this says about performance

At `value_id=0`, adjacent ownership gives threads 0–3 offsets `0,2,4,6`; interleaved ownership gives `0,1,2,3`. Across values, adjacent ownership gives each thread a contiguous pair. Which is better depends on copy width and generated instructions. A four-thread correctness exercise is not a bandwidth benchmark.

**Check yourself:** how would eight threads each owning four adjacent values be represented?

<details><summary>Answer</summary>

Shape `(8,4)`, strides `(4,1)`, giving 32 positions. Launch eight threads and enumerate four values per thread. Block selection remains a separate operation.

</details>

Next, use a copy atom and a thread/value plan to turn ownership into actual data movement.

## Run and compare

From the repository root in the pinned FlyDSL/ROCm environment:

```bash
pixi run python lessons/00-layout-algebra/07-thread-value-layouts/practice.py
pixi run python lessons/00-layout-algebra/07-thread-value-layouts/solution.py
```

The practice file deliberately raises `Practice not finished` until its TODO expressions are completed. Keep the host checker and supplied launch. Compare with the [worked solution](solution.py) after your attempt. These programs execute on the GPU; the host only prepares inputs and checks or times results.

[← Previous lesson](../06-select-block-tile/README.md) · [Next lesson →](../../01-gpu-programming/08-tiled-copy/README.md)
