# 04 · Coalescing: simplify the blueprint

**Mental model from our discussion:** like flattening an indexing blueprint while preserving the offset sequence. No tensor values move. Unlike NumPy's `flatten()`, this operation does not copy array data.

For valid **scalar logical coordinates** q, coalescing preserves:

```text
coalesced(q) = original(q)
size(coalesced) = size(original)
```

The coordinate tree may change. An old nested tuple coordinate is not necessarily valid for the result.

![Compatible and incompatible modes for coalescing](../../assets/coalescing.svg)

## When can two adjacent leaf modes merge?

For `(s0,s1):(d0,d1)`, if `d1 = s0*d0`, they become `(s0*s1):d0`. A statically known size-1 mode can also disappear because its coordinate is always zero.

| Original | Result | Reason |
| --- | --- | --- |
| `(2,4):(1,2)` | `8:1` | `2 = 2*1` |
| `(2,3):(2,4)` | `6:2` | `4 = 2*2`; contiguous bytes are not required |
| `((2,1),4):((1,99),2)` | `8:1` | Remove size-1 mode, then merge |
| `(2,4):(4,1)` | remains multi-mode | `1 != 2*4` |

## Worked non-example

`(2,4):(4,1)` visits offsets `0,4,1,5,2,6,3,7` in scalar-coordinate order. No single constant stride generates that sequence.

Even though it covers a compact set of eight memory offsets, it cannot coalesce to `8:1` without changing the function. **Same set of offsets is weaker than same ordered mapping.**

For the nested layout `((2,2),3):((1,4),8)`, the first two leaves cannot merge. The last two can: `8 = 2*4`. A simplified mapping is `(2,6):(1,4)`.

```python
# Inside a FlyDSL tracing context
simple = fx.coalesce(fx.make_layout((2, 4), (1, 2)))  # 8:1
```

**Trap:** flattening a tuple hierarchy and merging all modes are different steps. Coalescing may stop with several modes.

**Check yourself:** can `(2,3):(3,6)` coalesce? What is the result?

<details><summary>Answer</summary>

Yes: `6:3`, because `6 = 2*3`. Offsets remain `0,3,6,9,12,15`.

</details>

[← Composition](../03-composition/README.md) · [Next: logical divide →](../05-logical-divide/README.md)

## Practice

Run `python3 practice.py`, complete `solve()`, and compare with `solution.py` after the checks pass. Both use the repository’s CPU layout model; the FlyDSL examples above require a tracing context.
