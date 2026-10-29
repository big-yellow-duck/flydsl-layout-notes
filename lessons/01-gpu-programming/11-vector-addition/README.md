# 11 · Launch a bounds-safe vector addition

Assemble block selection, thread/value ownership, coordinate views, and predicates into a complete operation: `out[index] = left[index] + right[index]` for every valid index.

## The full path

| Layer | Responsibility |
| --- | --- |
| Host `solve()` | Allocate contiguous float32 inputs and output; choose count; compare results |
| `@flyc.jit run` | Convert PyTorch arguments through FlyDSL's runtime and launch enough blocks |
| `@flyc.kernel` | Build coordinate tiles and compute each thread's owned positions |
| Bounds branch | Allow input loads and output stores only for valid indices |

The block has four threads and each thread owns two values. Therefore `grid = ((count + 7) // 8, 1, 1)` covers count elements. Count is passed as `fx.Constexpr`, so this lesson specializes compiled code to each tested count. It is not demonstrating one dynamically shaped binary for all sizes.

Inputs are contiguous one-dimensional float32 tensors on the same GPU. The lesson allocates them that way. Supporting arbitrary strides, dtypes, overlapping inputs/outputs, or empty inputs would need an explicit extended contract; the worked examples use positive counts and distinct output storage.

## Why the tail-safe path uses scalar accesses

Lesson 09 demonstrates full-tile copies into register fragments. Here each thread's individual values may cross the boundary, so we retain lesson 10's native per-value branch around scalar loads and stores. Values loaded this way are GPU computation values too; a fragment allocation is not required for every arithmetic operation.

This is the simple correct path for both full tiles and tails. A later optimization can use tiled copies for full blocks and dispatch a separate guarded tail path. Do not make a wide copy cross the end of an input merely because most of its values are valid.

## Practice

Fill `result` with `left[global_index] + right[global_index]` **inside** the guarded region. Keep the launch and predicate unchanged. The checker tests counts `1,7,8,9,19,32,257,4099`, including tiny inputs, exact tile boundaries, and partial final blocks. It checks results against PyTorch and verifies eight sentinel output elements after each result.

At count 9, block 1 has only index 8 valid: thread 0's first value. The other seven potential positions must perform no input load or output store.

**Check yourself:** how many blocks are required for 257 elements, and how many values are valid in the last block?

<details><summary>Answer</summary>

33 blocks. The first 32 cover 256 elements; the final block has only index 256 valid.

</details>

This is a correctness-oriented teaching kernel, not a tuned vector-add implementation. The next lesson changes a controlled copy parameter and measures the result separately from compilation.

## Run and compare

From the repository root in the pinned FlyDSL/ROCm environment:

```bash
pixi run python lessons/01-gpu-programming/11-vector-addition/practice.py
pixi run python lessons/01-gpu-programming/11-vector-addition/solution.py
```

The practice file deliberately raises `Practice not finished` until its TODO expressions are completed. Keep the host checker and supplied launch. Compare with the [worked solution](solution.py) after your attempt. These programs execute on the GPU; the host only prepares inputs and checks or times results.

[← Previous lesson](../10-predicates-and-tails/README.md) · [Next lesson →](../12-inspect-and-tune/README.md)
