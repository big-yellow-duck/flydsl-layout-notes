# FlyDSL layout algebra notes

Short lessons for rebuilding the intuition behind FlyDSL layouts: **a layout is an indexing blueprint**. It tells us which offset a coordinate names. Algebra changes that blueprint; loads, stores, and copies move the data.

These notes preserve the learning sequence from our discussion through logical divide. The examples are deliberately small enough to work out by hand. They are reconstructed teaching examples, not a verbatim transcript.

## Learning path

| Lesson | Question it answers |
| --- | --- |
| [00 · Shapes and strides](lessons/00-shapes-and-strides.md) | How does a coordinate become an offset? |
| [01 · Coordinates and views](lessons/01-coordinates-and-views.md) | What does a single integer mean for a multidimensional layout? |
| [02 · Nested layouts](lessons/02-nested-layouts.md) | How can one dimension contain smaller dimensions? |
| [03 · Composition](lessons/03-composition.md) | How can we index a layout with another layout? |
| [04 · Coalescing](lessons/04-coalescing.md) | Can we simplify the blueprint while preserving its offsets? |
| [05 · Logical divide](lessons/05-logical-divide.md) | How do we expose windows into the original layout? |

Each lesson has a mental model, worked example, trap to avoid, and a quick revision question.

![A matrix divided into tiles, with one tile selected](assets/logical-divide.svg)

## Come back here for revision

- [One-page cheat sheet](CHEATSHEET.md)
- [Roadmap: vector addition and GPU thread layouts](ROADMAP.md)
- [Sources and version scope](SOURCES.md)

Run all numerical examples with Python 3.10+; no GPU or extra package is required:

```bash
python3 examples/layout_walkthrough.py
```

This is a CPU model of the arithmetic, not a replacement implementation of FlyDSL. `fx.*` snippets in the lessons are API patterns for use inside a FlyDSL tracing context (`@flyc.jit` or `@flyc.kernel`); they are not standalone Python programs. The repository does not yet contain a runnable GPU kernel.

**Where we left off:** the windowing idea is understood. Next, fix a tile coordinate with `slice`, then give each GPU thread a portion of that tile.
