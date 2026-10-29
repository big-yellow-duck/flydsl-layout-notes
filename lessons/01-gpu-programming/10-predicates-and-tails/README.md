# 10 · Protect the last partial tile

For 19 elements and 8-element tiles, launch three blocks. The third tile has only three valid positions. The layout still describes a full tile; it does not check allocation bounds.

## Coordinates can be a tensor without an allocation

```python
coordinates = fx.make_view(fx.make_int_tuple(0), fx.make_layout(24, 1))
coordinate_tiles = fx.logical_divide(coordinates, fx.make_layout(8, 1))
block_coordinates = fx.slice(coordinate_tiles, (None, block_id))
```

The integer iterator starts at zero. Indexing this coordinate view produces an index, rather than loading a float from memory. Its padded domain covers the launch: 24 positions. This makes it possible to ask which positions are valid without accessing either input allocation.

Use ownership `(4,2):(2,1)` to get each thread's local positions, then index `block_coordinates` to obtain their global indices.

| Thread in block 2 | Global indices | Valid for count 19 |
| --- | --- | --- |
| 0 | 16, 17 | Both |
| 1 | 18, 19 | Only 18 |
| 2 | 20, 21 | Neither |
| 3 | 22, 23 | Neither |

The predicate is `global_index < count`. All indices here are nonnegative by construction. In particular, thread 1 needs a **per-value** predicate; one boolean for the entire thread would be insufficient.

## Guard the reads and the write

The solution emits a native structured-control-flow branch around the two loads, addition, and store. It uses `scf.IfOp`, an IR insertion point, and `scf.yield_` from the MLIR bindings shipped with FlyDSL 0.4.1. These are low-level compiler APIs, provided in the scaffold so the exercise stays focused on the predicate. A Python `if` in this directly traced kernel cannot choose a branch based on a runtime GPU value.

The important placement is:

```text
if global_index < count, on the GPU:
    load left[global_index]
    load right[global_index]
    add the loaded values
    store out[global_index]
```

Do not load first and only guard the store. An output allocation with spare capacity does not make reads beyond the two exact-sized input allocations valid.

## Practice

Fill `valid` with the bound comparison. Keep all memory accesses inside the supplied branch. The checker uses exact-sized input arrays and eight sentinel output elements after the logical result. It checks the 19 sums and verifies the sentinels are unchanged.

Sentinels detect invalid writes; they do not prove the absence of every invalid read. The code structure supplies that guarantee here: both loads are inside the same bounds branch. All valid positions have exactly one owner under the thread/value layout.

**Check yourself:** what predicate would `global_index <= count` produce for index 19?

<details><summary>Answer</summary>

True, incorrectly. The last valid index is 18. An array of count elements has valid indices from 0 to count minus one.

</details>

This deliberately uses scalar guarded loads rather than applying a wide unmasked copy atom to a partial tile. We combine it into the complete vector-add launch next.

## Run and compare

From the repository root in the pinned FlyDSL/ROCm environment:

```bash
pixi run python lessons/01-gpu-programming/10-predicates-and-tails/practice.py
pixi run python lessons/01-gpu-programming/10-predicates-and-tails/solution.py
```

The practice file deliberately raises `Practice not finished` until its TODO expressions are completed. Keep the host checker and supplied launch. Compare with the [worked solution](solution.py) after your attempt. These programs execute on the GPU; the host only prepares inputs and checks or times results.

[← Previous lesson](../09-register-fragments/README.md) · [Next lesson →](../11-vector-addition/README.md)
