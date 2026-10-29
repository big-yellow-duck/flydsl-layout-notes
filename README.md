# FlyDSL layout algebra notes

Short lessons for rebuilding the intuition behind FlyDSL layouts: **a layout is an indexing blueprint**. It tells us which offset a coordinate names. Algebra changes that blueprint; loads, stores, and copies move the data.

These notes preserve the learning sequence from our discussion through logical divide. The examples are deliberately small enough to work out by hand. They are reconstructed teaching examples, not a verbatim transcript.

## Learning path

| Lesson | Question it answers |
| --- | --- |
| [00 · Shapes and strides](lessons/00-shapes-and-strides/README.md) | How does a coordinate become an offset? |
| [01 · Coordinates and views](lessons/01-coordinates-and-views/README.md) | What does a single integer mean for a multidimensional layout? |
| [02 · Nested layouts](lessons/02-nested-layouts/README.md) | How can one dimension contain smaller dimensions? |
| [03 · Composition](lessons/03-composition/README.md) | How can we index a layout with another layout? |
| [04 · Coalescing](lessons/04-coalescing/README.md) | Can we simplify the blueprint while preserving its offsets? |
| [05 · Logical divide](lessons/05-logical-divide/README.md) | How do we expose windows into the original layout? |

Each lesson contains notes, a scaffolded `practice.py`, and a commented `solution.py`. Both programs use native FlyDSL APIs inside GPU kernels. There is no Python layout implementation: PyTorch allocates GPU buffers and the host checks the returned results.

## Set up and start

The included Pixi environment pins FlyDSL 0.4.1, ROCm 10, and PyTorch 2.13.0+rocm10.0.0 for Linux x86-64 and AMD `gfx1152` (Radeon 860M). Install [Pixi](https://pixi.sh/), ensure the host GPU driver and `/dev/kfd` and render-node permissions are available, then run:

```bash
pixi install --locked
pixi run python lessons/00-shapes-and-strides/practice.py
```

The starter reports `Practice not finished: ...` and exits with status 1. Read the lesson's **Practice** section and replace the numbered `None` TODOs in `exercise_kernel()`. Keep the supplied stores, launch, and checker. A completed exercise prints `Exercise passed: ...`; incorrect results fail the host assertions.

After your attempt, compare with the worked solution:

```bash
pixi run python lessons/00-shapes-and-strides/solution.py
```

All six practice files are reset for a fresh attempt. Exercises require the GPU environment; plain system Python is not enough. The first install downloads the ROCm SDK and PyTorch and can be large. Other GPU architectures need matching ROCm device packages and architecture configuration. With an already configured FlyDSL/ROCm PyTorch environment, use `python` in place of `pixi run python`.

## What executes where

- `@flyc.kernel` traces native `fx.make_layout`, `fx.crd2idx`, `fx.composition`, `fx.coalesce`, and divide operations. Static algebra can simplify at compile time.
- `fx.thread_idx.x` supplies runtime coordinates. Every exercise evaluates the complete small coordinate domain on the GPU, with one output row per thread.
- `@flyc.jit` launches the kernel. `solve()` allocates buffers, synchronizes, and checks results on the host. The expected tables are independent checks, not replacement layout APIs.

`fx.*` snippets in the notes belong inside a tracing context. The practice and solution files provide complete runnable programs. In lessons 01 and 02, `fx.idx2crd` expands logical scalar coordinates using a compact `fx.make_ordered_layout`; applying it directly to the data layout would instead interpret memory indices.

![A matrix divided into tiles, with one tile selected](assets/logical-divide.svg)

## Come back here for revision

- [One-page cheat sheet](CHEATSHEET.md)
- [Roadmap: vector addition and GPU thread layouts](ROADMAP.md)
- [Sources and version scope](SOURCES.md)

Run all six worked lessons:

```bash
pixi run lessons-check
```

Run the lessons plus the additional examples from the notes:

```bash
pixi run gpu-check
```

The GPU check covers padding, aliasing, scalar and nested coordinates, full and subset composition, coalescing (including size-1 and unmergeable cases), every position across all four 2-D divide groupings, and actual loads through sliced 1-D and 2-D tensor views. The selected matrix tile returns values from offsets `20,21,22,23,28,29,30,31`.

Validated on AMD Radeon 860M Graphics (`gfx1152`) with the pinned environment. These are correctness checks, not performance benchmarks or ISA validation. Vector addition, thread/value copy plans, and tail predicates remain in the roadmap.

**Where we left off:** the windowing idea is understood. Next, fix a tile coordinate with `slice`, then give each GPU thread a portion of that tile.
