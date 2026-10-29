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

Each lesson directory contains notes, a `practice.py` exercise, and a worked `solution.py`. Read the notes, run the practice file and complete `solve()`, then compare your answer with the solution. For example:

```bash
python3 lessons/00-shapes-and-strides/practice.py
python3 lessons/00-shapes-and-strides/solution.py
```

The exercises use the CPU arithmetic model below, while the notes also show FlyDSL API patterns.

![A matrix divided into tiles, with one tile selected](assets/logical-divide.svg)

## Come back here for revision

- [One-page cheat sheet](CHEATSHEET.md)
- [Roadmap: vector addition and GPU thread layouts](ROADMAP.md)
- [Sources and version scope](SOURCES.md)

Run all numerical examples with Python 3.10+; no GPU or extra package is required:

```bash
python3 examples/layout_walkthrough.py
```

This is a CPU model of the arithmetic, not a replacement implementation of FlyDSL. `fx.*` snippets in the lessons are API patterns for use inside a FlyDSL tracing context (`@flyc.jit` or `@flyc.kernel`); they are not standalone Python programs. The optional GPU check below exercises selected mappings with FlyDSL.

**Where we left off:** the windowing idea is understood. Next, fix a tile coordinate with `slice`, then give each GPU thread a portion of that tile.

## GPU validation

The included Pixi environment targets Linux x86-64 and AMD `gfx1152` (Radeon 860M), with ROCm 10, PyTorch and FlyDSL pinned in `pixi.lock`. Install [Pixi](https://pixi.sh/), ensure the host GPU driver and `/dev/kfd` and render-node permissions are available, then run:

```bash
pixi install --locked
pixi run cpu-check
pixi run gpu-check
```

The first install downloads the ROCm SDK and PyTorch and can be large. Other GPU architectures need a matching ROCm device package and architecture configuration; this lockfile was tested on `gfx1152`. To run with another already configured FlyDSL and ROCm-enabled PyTorch environment:

```bash
python examples/gpu_layout_check.py
```

This checks one mapping from each lesson on the GPU and checks all 32 coordinates of the 2-D flat-divide example using thread-dependent coordinates. The other five checks use static coordinates and may be evaluated during compilation. It does not test every API example or a vector-add kernel. Verified on AMD Radeon 860M (gfx1152), ROCm 10, PyTorch 2.13.0+rocm10.0.0, and FlyDSL 0.4.1.
