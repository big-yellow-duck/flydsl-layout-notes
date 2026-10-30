# 07 · Give each thread two values

A thread can own several positions in a tile. Represent each position with two coordinates: a thread ID and a value slot within that thread. This lesson assigns **two values to each of four threads**, covering an eight-position tile, and compares two ways to place those values.

Begin by comparing the two ownership diagrams. Each color identifies one thread. The large numbers are **tile offsets**, not the data stored there. `T2 / V1` means “thread 2's second value slot.”

![Two ownership plans in memory order and regrouped by thread. Neighbor pairs give T0 offsets 0 and 1, T1 offsets 2 and 3, T2 offsets 4 and 5, and T3 offsets 6 and 7. Repeating across threads gives T0 offsets 0 and 4, T1 offsets 1 and 5, T2 offsets 2 and 6, and T3 offsets 3 and 7.](../../../assets/00-layout-algebra/07-thread-value-layouts/thread-value-ownership.svg)

## Separate the slot count from the positions

The two plans assign the same number of positions to every thread:

| Plan | How to assign the eight positions | Thread 2 owns | Name in the exercise |
| --- | --- | --- | --- |
| **Neighbor pairs** | Give T0 two neighbors, then T1 two neighbors, and so on | `4, 5` | `adjacent` |
| **One value per thread, repeated** | Assign offsets 0–3 to T0–T3, then offsets 4–7 to T0–T3 again | `2, 6` | `interleaved` |

“Adjacent” describes the positions owned by **one thread**. “Interleaved” describes the **owners as you scan memory**: `T0, T1, T2, T3, T0, T1, T2, T3`. Both plans describe ownership of the existing positions; constructing either plan leaves stored data in place.

For the repeated plan, read the picture as two groups:

```text
value_id = 0:   T0 → 0   T1 → 1   T2 → 2   T3 → 3
value_id = 1:   T0 → 4   T1 → 5   T2 → 6   T3 → 7
                         ↑
                    T1 owns 1 and 5
```

These groups explain the assignment, not a timing guarantee or synchronization between threads. The kernel launches **four threads**. Each thread handles its own `value_id=0` and `value_id=1`.

## Turn the picture into a layout

A coordinate is `(thread_id, value_id)`. Here `value_id` is a **slot number within a thread**, either 0 or 1. It is neither the data value nor its tile offset.

```python
# Native FlyDSL API pattern; both layouts have the same shape.
# Shape: (threads, slots). Strides: (thread stride, slot stride).
adjacent = fx.make_layout((4, 2), (2, 1))     # Neighbor pairs
interleaved = fx.make_layout((4, 2), (1, 4))  # Repeat across threads

coordinate = fx.make_coord(thread_id, value_id)
local_index = fx.crd2idx(coordinate, adjacent)
```

The shape `(4, 2)` fixes **how many**: four threads, two slots each. The strides decide **where**:

![The same shape with two stride choices. For neighbor pairs, advancing the thread adds 2 and advancing its slot adds 1. For repeated assignment, advancing the thread adds 1 and advancing its slot adds 4. Thread 2 maps to offsets 4 and 5 or offsets 2 and 6 respectively.](../../../assets/00-layout-algebra/07-thread-value-layouts/thread-value-strides.svg)

For these layouts, `crd2idx` evaluates:

```text
Neighbor pairs:          tile_offset = 2 * thread_id + value_id
Repeat across threads:   tile_offset = thread_id + 4 * value_id
```

Trace thread 2: its coordinates are **the same** in both plans, `(2, 0)` and `(2, 1)`. Neighbor pairs map them to `4, 5`; repeating across threads maps them to `2, 6`. Changing strides changes the positions, while each thread still owns two slots.

The earlier thread layouts map tile positions to thread IDs; `idx2crd` reverses that mapping. Here the ownership layout maps `(thread_id, value_id)` directly to tile positions. The extra coordinate lets one thread own multiple positions.

## Practice: record both pairs

Construct `adjacent` (neighbor pairs) and `interleaved` (repeat across threads) using the shape/stride pairs above. The kernel records **offsets**; it has no input data to load yet.

```python
for value_id in range(2):
    coordinate = fx.make_coord(thread_id, value_id)
    # Map this coordinate with each layout and record the resulting offsets.
```

Python `range(2)` runs during tracing and emits GPU operations for both slots. Each thread writes four diagnostic numbers: its two offsets under plan A, then its two offsets under plan B.

| Thread | A: slot 0 | A: slot 1 | B: slot 0 | B: slot 1 |
| --- | --- | --- | --- | --- |
| T0 | 0 | 1 | 0 | 4 |
| T1 | 2 | 3 | 1 | 5 |
| T2 | 4 | 5 | 2 | 6 |
| T3 | 6 | 7 | 3 | 7 |

Trace thread 2 before running: its output row should be `[4, 5, 2, 6]`. The four columns compare two alternative plans; **each plan assigns only two values per thread**. This diagnostic output has 16 entries because it records both plans for the same eight-position tile. Within either plan, offsets 0–7 appear exactly once.

## Why use the repeated plan?

Look across threads at one fixed slot:

| Slot | Neighbor pairs: offsets for T0, T1, T2, T3 | Repeat across threads: offsets for T0, T1, T2, T3 |
| --- | --- | --- |
| `value_id=0` | `0, 2, 4, 6` | `0, 1, 2, 3` |
| `value_id=1` | `1, 3, 5, 7` | `4, 5, 6, 7` |

Repeating across threads puts neighboring threads on neighboring positions for each slot. Neighbor pairs put each thread's own two positions together. Both are useful ways to distribute the same tile. Actual memory efficiency depends on the generated copy instructions, copy width, and hardware; this four-thread mapping exercise is not a bandwidth benchmark.

**Check yourself:** how would eight threads each owning four neighboring values be represented, and which offsets would thread 2 own?

<details><summary>Answer</summary>

Shape `(8, 4)`, strides `(4, 1)`, giving 32 positions. Launch eight threads and enumerate four slots per thread. Thread 2 owns offsets `8, 9, 10, 11` because `tile_offset = 4 * thread_id + value_id`. Block selection remains a separate operation.

</details>

Next, use a copy atom and a thread/value plan to turn ownership into actual data movement. Lesson 08 uses the neighbor-pairs plan (`adjacent`).

## Run and compare

From the repository root in the pinned FlyDSL/ROCm environment:

```bash
pixi run python lessons/00-layout-algebra/07-thread-value-layouts/practice.py
pixi run python lessons/00-layout-algebra/07-thread-value-layouts/solution.py
```

In the starter exercise, an incomplete expression raises `Practice not finished` during tracing. Complete both layout expressions, run the checker, then compare the [worked solution](solution.py). The four-thread launch evaluates both slots under each layout; the host checks the complete ownership table.

Validation: `pixi run gpu-check` passed on 2026-10-30 with FlyDSL 0.4.1 on AMD Radeon 860M Graphics (`gfx1152`), including the complete lesson 07 ownership table.

Reference: [FlyDSL layout system guide](https://github.com/ROCm/FlyDSL/blob/0653ff888bad3787c759eabeeeefbfa1aa2df50b/docs/layout_system_guide.md) (background snapshot; runnable examples use the repository's pinned FlyDSL 0.4.1).

Diagram sources: [draw_thread_value_layouts.py](../../../tools/draw_thread_value_layouts.py). Regenerate SVGs and PNG previews with `python3 tools/draw_thread_value_layouts.py` (requires Pillow).

[← Previous lesson](../06-select-block-tile/README.md) · [Next lesson →](../../01-gpu-programming/08-tiled-copy/README.md)
