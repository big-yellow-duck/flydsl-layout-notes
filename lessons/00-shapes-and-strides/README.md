# 00 · Shapes and strides

**Mental model:** shape tells you the valid coordinates; stride tells you the offset change for one step along each coordinate axis.

We write a layout as `Shape:Stride`. For ordinary integer strides:

```text
L = (3,4):(4,1)
L(row,col) = row*4 + col*1
```

The first axis has 3 positions, the second has 4. `(2,1)` maps to `2*4 + 1 = 9`.

![Row-major and column-major offset grids](../../assets/shapes-strides.svg)

## Same shape, different indexing blueprint

| Layout | Step along row | Step along column | Offset of `(2,1)` |
| --- | --- | --- | --- |
| `(3,4):(4,1)` | +4 | +1 | 9 |
| `(3,4):(1,3)` | +1 | +3 | 5 |

We draw the first coordinate vertically and the second horizontally. The stride chooses the memory order; the shape alone does not.

```python
# Inside a FlyDSL tracing context
row_major = fx.make_layout((3, 4), (4, 1))
col_major = fx.make_layout((3, 4), (1, 3))
offset = fx.crd2idx(fx.make_coord(2, 1), row_major)  # 9
```

## Count and span are different

`size(L)` counts logical positions. For the nonnegative integer strides used here, `cosize(L)` is the largest reachable offset plus one.

| Layout | Reachable offsets | Size | Cosize |
| --- | --- | --- | --- |
| `4:1` | 0, 1, 2, 3 | 4 | 4 |
| `4:2` | 0, 2, 4, 6 | 4 | 7 |
| `(2,3):(0,1)` | 0, 1, 2, each twice | 6 | 3 |

Gaps are possible; repeated offsets are possible too. A zero stride means stepping along that axis leaves the offset unchanged.

**Trap:** strides here count elements, not bytes. For a float32 tensor, element offset 9 corresponds to byte displacement 36 from its base pointer. A layout by itself has no dtype or allocation.

**Check yourself:** for `(3,4):(5,1)`, what are `L(2,3)`, size, and cosize?

<details><summary>Answer</summary>

Offset 13, size 12, cosize 14. The row pitch introduces holes at offsets 4 and 9.

</details>

## Practice

### Goal and starting data

Measure the padded layout **`(3,4):(5,1)`** at coordinate **`(2,3)`**. There are three rows and four columns; each new row begins five elements after the previous one. Coordinates are zero-based, so valid rows are `0..2` and columns are `0..3`.

Open [`practice.py`](practice.py). `solve()` already constructs `layout = Layout((3, 4), (5, 1))` and sets `coordinate = (2, 3)`. Replace the three `None` values at the TODO comments. You do not need to write a class or change [`layout.py`](layout.py).

### First, try the helper API

All exercises use this directory's small CPU arithmetic model. `Layout(shape, stride)` describes an offset mapping; calling the resulting object calculates an element offset. `size` takes a **shape**, while `cosize` is a method on a **layout**.

For a smaller, separate example, run this from the lesson directory:

```bash
cd lessons/00-shapes-and-strides
python3 - <<'PYTHON'
from layout import Layout, size

small = Layout((2, 3), (4, 1))
print(small((1, 2)))      # 6: 1*4 + 2*1
print(size(small.shape))  # 6 logical positions: 2*3
print(small.cosize())     # 7 elements of span: offsets 0 through 6
PYTHON
```

The extra parentheses in `small((1, 2))` pass **one tuple argument**. `small(1, 2)` would pass two arguments and fail.

### Complete `solve()`

1. On paper, list the offsets in row 0, then find where rows 1 and 2 begin. Each column adds the column stride; each row adds the row stride.
2. Set `element_offset` by calling `layout(coordinate)`. Check it against `row*row_stride + column*column_stride`.
3. Set `logical_size` using `size(layout.shape)`. Padding does not add valid coordinates.
4. Set `storage_span` using `layout.cosize()`. It is the largest reachable offset **plus one**, including holes before that offset.
5. Keep the provided return statement. The contract is `(element_offset, logical_size, storage_span)`, a tuple of three integers in that order. Calculate the entries from the layout rather than returning the checker’s constants.

### Run and check

From the repository root:

```bash
python3 lessons/00-shapes-and-strides/practice.py
python3 lessons/00-shapes-and-strides/solution.py
```

If you used `cd` above, run `python3 practice.py` and `python3 solution.py` from that lesson directory instead. An untouched practice file exits with `Practice not finished: ...`; this is the starting state. After filling in the TODOs, expect `Exercise passed: (13, 12, 14)`. Compare with the commented [worked solution](solution.py) after your attempt.

If your span equals your logical size, revisit the holes at offsets 4 and 9. If your span is 13, remember that offsets start at zero. These are element offsets; do not multiply by a dtype's byte width.

### Try another case

Use scratch code for these extensions so the required exercise's checker stays unchanged:

- Change only the strides to `(4,1)`. Predict which of the three results change, then evaluate the model.
- Try `Layout((2,3), (0,1))`. List its offsets and explain how six logical positions fit into a span of three elements.

[Next: coordinates and views →](../01-coordinates-and-views/README.md)
