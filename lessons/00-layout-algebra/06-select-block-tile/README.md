# 06 · Select a block tile

A divided view exposes all windows. Now use the GPU block ID to choose one window, then use the thread ID to choose a position within it.

## From one window to a grid of windows

The input contains 32 float32 values. A tile has 8 values, so launch 4 blocks with 8 threads each. The launch is one-dimensional; the view supplies the window interpretation.

```python
thread_id = fx.thread_idx.x
block_id = fx.block_idx.x
divided = fx.logical_divide(source, fx.make_layout(8, 1))
block_tile = fx.slice(divided, (None, block_id))
```

`divided` has shape `(8,4)` and strides `(1,8)`. The first coordinate is `local_index`; the second is `block_id`. Fixing the second selects one tile and advances the tensor view's base pointer.

| Block ID | Original indices | Base offset |
| --- | --- | --- |
| 0 | 0–7 | 0 |
| 1 | 8–15 | 8 |
| 2 | 16–23 | 16 |
| 3 | 24–31 | 24 |

The thread layout `fx.make_ordered_layout(8, 0)` is `8:1`. `idx2crd(thread_id, thread_layout)` gives the local index. Block 2, thread 3 loads `block_tile[3]`, which reads original offset 19. The base has already moved to 16: do not add it a second time.

The solution copies each loaded value into its corresponding output slot. The input values are `100 + index`, so the checkpoint for block 2 is **116 through 123**, not 16 through 23. This distinguishes loaded data from an offset calculation.

## Practice

Fill `divided` using `fx.logical_divide` and `block_tile` using `fx.slice`. Keep the supplied thread layout and load/store. `solve()` checks the entire copied vector, then returns block 2's values.

**Check yourself:** what does block 3, thread 1 read?

<details><summary>Answer</summary>

Original index 25, value 125. The tile base is 24 and the local index is 1.

</details>

Try tile size 4 in a scratch copy. Update the grid to 8 blocks, the block size to 4, the thread layout, output indexing, and checkpoint together. This example is evenly divisible; changing only the launch is not sufficient.

## Run and compare

From the repository root in the pinned FlyDSL/ROCm environment:

```bash
pixi run python lessons/00-layout-algebra/06-select-block-tile/practice.py
pixi run python lessons/00-layout-algebra/06-select-block-tile/solution.py
```

The practice file deliberately raises `Practice not finished` until its TODO expressions are completed. Keep the host checker and supplied launch. Compare with the [worked solution](solution.py) after your attempt. These programs execute on the GPU; the host only prepares inputs and checks or times results.

[← Previous lesson](../05-logical-divide/README.md) · [Next lesson →](../07-thread-value-layouts/README.md)
