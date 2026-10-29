# FlyDSL layout algebra notes

Short lessons for rebuilding the intuition behind FlyDSL layouts: **a layout is an indexing blueprint**. It tells us which offset a coordinate names. Algebra changes that blueprint; loads, stores, and copies move the data.

These notes preserve the learning sequence from our discussion through logical divide. The examples are deliberately small enough to work out by hand. They are reconstructed teaching examples, not a verbatim transcript.

## Learning path

| Section | Lessons | What you learn |
| --- | --- | --- |
| [00 · Layout algebra](lessons/00-layout-algebra/README.md) | 00–07 | Shapes, coordinates, composition, coalescing, tiling, block windows, thread/value ownership |
| [01 · GPU programming](lessons/01-gpu-programming/README.md) | 08–12 | Tiled copies, register fragments, predicates, vector addition, ISA inspection and measurement |

Start with layout algebra; lessons 06 and 07 still develop the coordinate and ownership fundamentals. Actual copy plans begin in lesson 08.

Each lesson contains notes, a scaffolded `practice.py`, and a commented `solution.py`. Both programs use native FlyDSL APIs inside GPU kernels. There is no Python layout implementation: PyTorch allocates GPU buffers and the host checks the returned results.

## Set up and start

The included Pixi environment pins FlyDSL 0.4.1, ROCm 10, and PyTorch 2.13.0+rocm10.0.0 for Linux x86-64 and AMD `gfx1152` (Radeon 860M). Install [Pixi](https://pixi.sh/), ensure the host GPU driver and `/dev/kfd` and render-node permissions are available, then run:

```bash
pixi install --locked
pixi run python lessons/00-layout-algebra/00-shapes-and-strides/practice.py
```

The starter reports `Practice not finished: ...` and exits with status 1. Read the lesson's **Practice** section and replace the numbered `None` TODOs in `exercise_kernel()`. Keep the supplied stores, launch, and checker. A completed exercise prints `Exercise passed: ...`; incorrect results fail the host assertions.

After your attempt, compare with the worked solution:

```bash
pixi run python lessons/00-layout-algebra/00-shapes-and-strides/solution.py
```

Exercises require the GPU environment; plain system Python is not enough. The first install downloads the ROCm SDK and PyTorch and can be large. Other GPU architectures need matching ROCm device packages and architecture configuration. With an already configured FlyDSL/ROCm PyTorch environment, use `python` in place of `pixi run python`.

## What executes where

- `@flyc.kernel` traces native `fx.make_layout`, `fx.crd2idx`, `fx.composition`, `fx.coalesce`, and divide operations. Static algebra can simplify at compile time.
- `fx.thread_idx.x` supplies a runtime thread ID. The initial layout lessons use `thread_layout = fx.make_ordered_layout(...)` and `fx.idx2crd` to decode its logical coordinate. Every exercise evaluates the complete small coordinate domain on the GPU, with one output row per thread.
- `@flyc.jit` launches the kernel. `solve()` allocates buffers, synchronizes, and checks results on the host. The expected tables are independent checks, not replacement layout APIs.

`fx.*` snippets in the notes belong inside a tracing context. The practice and solution files provide complete runnable programs. The thread layout maps logical coordinates to owning thread IDs; `fx.idx2crd` reverses that mapping. A separate data layout maps coordinates to storage offsets. `fx.make_ordered_layout(shape, order)` assigns each axis a speed rank (0 is fastest) and derives compact strides; `fx.make_layout(shape, stride)` accepts explicit strides, including padding.

Lessons 00–04 use first-mode-fastest thread ownership, so the thread ID also equals the original scalar logical index. Lesson 05 uses order `(1,0,3,2)` to place consecutive threads along tile columns. Coalescing keeps a scalar-index comparison because its result can have a different coordinate shape. Applying `idx2crd` directly to the data layout would instead interpret memory indices.

![A matrix divided into tiles, with one tile selected](assets/logical-divide.svg)

## Come back here for revision

- [One-page cheat sheet](CHEATSHEET.md)
- [Roadmap: vector addition and GPU thread layouts](ROADMAP.md)
- [Sources and version scope](SOURCES.md)

Run all thirteen worked lessons:

```bash
pixi run lessons-check
```

Run the lessons plus the additional examples from the notes:

```bash
pixi run gpu-check
```

The GPU check covers padding, aliasing, scalar and nested coordinates, full and subset composition, coalescing (including size-1 and unmergeable cases), every position across all four 2-D divide groupings, and actual loads through sliced 1-D and 2-D tensor views. The selected matrix tile returns values from offsets `20,21,22,23,28,29,30,31`.

Validated on AMD Radeon 860M Graphics (`gfx1152`) with the pinned environment. The checks now include copy plans, register fragments, guarded vector addition, and a small copy-width benchmark. Lesson 12 explains how to dump generated ISA and interpret timing results.

**Continue after logical divide:** [select a block tile](lessons/00-layout-algebra/06-select-block-tile/README.md), then [assign multiple values per thread](lessons/00-layout-algebra/07-thread-value-layouts/README.md).
