# 08 · Turn an ownership plan into a copy

An ownership layout describes who accesses which positions. A tiled copy combines that distribution with a **copy atom**, the primitive transfer operation.

## Build the plan before moving data

Our eight values are viewed as a compact `(2,4):(1,2)` tile: axis 0 contains the two adjacent values per thread, and axis 1 locates the four threads.

```python
thread_layout = fx.make_layout((1, 4), (4, 1))
value_layout = fx.make_layout((2, 1), (1, 2))
tile_shape, thread_value_layout = fx.make_layout_tv(thread_layout, value_layout)
atom = fx.make_copy_atom(fx.UniversalCopy32b(), fx.Float32)
plan = fx.make_tiled_copy(atom, thread_value_layout, tile_shape)
```

The separate layouts describe how thread and value coordinates occupy the same two-axis tile space. In this example, `make_layout_tv` returns tile shape `(2,4)` and thread/value mapping `(4,2):(2,1)`, the adjacent ownership from lesson 07. Do not confuse the tile shape `(2,4)` with the thread/value domain `(4,2)`.

`UniversalCopy32b` transfers 32 bits per atom: one float32, not 32 bytes. The overall plan assigns two float32 values to each thread, so a thread has more work than one atom invocation.

## Partitioning does not perform a load

```python
thread_copy = plan.get_slice(thread_id)
source_part = thread_copy.partition_S(source_tile)
destination_part = thread_copy.partition_D(destination_tile)
fx.copy(atom, source_part, destination_part)
```

| Operation | Result | Moves data? |
| --- | --- | --- |
| `get_slice` | Copy plan specialized to one thread | No |
| `partition_S` | This thread's source view | No |
| `partition_D` | This thread's destination view | No |
| `fx.copy` | Transfer source values into destination storage | Yes |

Thread 2's source view addresses offsets 4 and 5. Its destination view addresses offsets 4 and 5 in a different allocation. Their correspondence is established by the shared plan. Partition shapes can contain atom and repetition modes; you need not hand-construct those compiler layouts.

The input values are `3*index + 7`, so thread 2 copies 19 and 22. A copy preserves values; it does not add the source and destination offsets.

## Practice

Fill `plan` and `thread_copy`. Keep the supplied native partition calls and `fx.copy`. The checker compares every output value to its source. A correct result is `[7,10,13,16,19,22,25,28]`.

**Check yourself:** if you remove `fx.copy` but keep both partitions, what happens?

<details><summary>Answer</summary>

The output remains at its initialized sentinel values. Constructing views and ownership plans does not transfer data.

</details>

This example performs a global-to-global copy. The next lesson makes the temporary register storage explicit so computation can happen between the load and store.

## Run and compare

From the repository root in the pinned FlyDSL/ROCm environment:

```bash
pixi run python lessons/01-gpu-programming/08-tiled-copy/practice.py
pixi run python lessons/01-gpu-programming/08-tiled-copy/solution.py
```

The practice file deliberately raises `Practice not finished` until its TODO expressions are completed. Keep the host checker and supplied launch. Compare with the [worked solution](solution.py) after your attempt. These programs execute on the GPU; the host only prepares inputs and checks or times results.

[← Previous lesson](../../00-layout-algebra/07-thread-value-layouts/README.md) · [Next lesson →](../09-register-fragments/README.md)
