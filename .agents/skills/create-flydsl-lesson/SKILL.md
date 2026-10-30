---
name: create-flydsl-lesson
description: Create or extend illustrated FlyDSL lessons in this repository, including standalone teaching READMEs, reproducible diagrams, native GPU practice/solution pairs, course navigation, and validation. Use when adding a lesson or restructuring a tutorial to follow this course's established format.
---

# Create a FlyDSL lesson

Produce a lesson that teaches one concept through a small, traceable example. Preserve the course's teaching voice, visual explanations, and native GPU exercises. A lesson is complete when its prose, diagrams, runnable solution, practice scaffold, and checker describe the same operation.

## Establish the local pattern

All repository paths below are relative to the repository root. Resolve them there even when invoked from a lesson subdirectory. Read [CONTRIBUTING.md](../../../CONTRIBUTING.md), the relevant section index, and the neighboring lesson before choosing a location. Check the working tree so existing learner edits remain intact.

Choose the closest reference rather than reading every lesson:

| New lesson concerns | Reference to inspect, including its practice and solution |
| --- | --- |
| Layout mappings and algebra | `lessons/00-layout-algebra/03-composition/` |
| Dividing and slicing a data view | `lessons/00-layout-algebra/05-logical-divide/01-logical/` |
| Block selection | `lessons/00-layout-algebra/06-select-block-tile/` |
| Explaining ownership visually | `lessons/00-layout-algebra/07-thread-value-layouts/` |
| Copy plans and atoms | `lessons/01-gpu-programming/08-tiled-copy/` |
| Per-thread temporary storage | `lessons/01-gpu-programming/09-register-fragments/` |
| Runtime bounds branches | `lessons/01-gpu-programming/10-predicates-and-tails/` |
| Controlled performance experiments | `lessons/01-gpu-programming/12-inspect-and-tune/` |

Read [authoring-patterns.md](references/authoring-patterns.md) when drafting the README or adapting an exercise. It explains the teaching sequence, program contract, and checks for each exercise type. Existing lesson code and the installed package take precedence over stale API examples.

## Define one teachable example

State the learning question and prerequisites. Pick the smallest domain that exposes the concept and can be checked completely. Decide which coordinate, thread, or block the walkthrough will follow. Work out its coordinates, offsets, ownership, and actual loaded values before writing the kernel.

Use `lessons/<section>/<number>-<topic>/` with `README.md`, `practice.py`, and `solution.py`. Continue the existing numbering and section organization. Focused subtopics can live under an established lesson, as in lesson 05. Do not renumber existing lessons just to add one.

## Build the solution and checker together

Use the pinned environment in `pixi.toml` and `pixi.lock`; verify unfamiliar APIs against the installed FlyDSL source. The currently documented baseline is FlyDSL 0.4.1 / ROCm 10 on `gfx1152`; record the environment actually tested rather than assuming it is unchanged.

Keep the established boundary: native FlyDSL operations implement the example inside `@flyc.kernel`; `@flyc.jit` defines its launch; host `solve()` allocates buffers, runs, synchronizes, checks, and returns a readable checkpoint. Expected tables or PyTorch arithmetic provide independent checks, not a replacement Python layout implementation.

For memory lessons, make the access path visible:

```text
create or reuse data views → select work → assign ownership
→ partition if needed → load → compute → store
```

Name intermediate views. Reuse incoming views when their layouts already fit. Mapping-only lessons can evaluate layouts and record offsets without inventing input storage or a data movement step.

Preserve these distinctions in the prose, diagrams, and code:

- A scalar logical coordinate, tuple coordinate, element offset, byte displacement, and stored value have different meanings. Show parentheses and units explicitly.
- Shape describes a coordinate domain; strides describe its mapping. A tile shape and a thread/value domain can differ.
- Explain the direction of each ownership map. Early lessons invert a compact coordinate-to-thread layout with `idx2crd`; lesson 07 maps `(thread_id, value_id)` forward to tile positions.
- A layout has no pointer. Slicing a memory view carries the selected base offset; local accesses must not add that base a second time.
- View creation, division, slicing, and partitioning describe accesses. Loads, stores, copies, and arithmetic operate on values. Allocating a fragment does not initialize it.
- A coordinate-only view produces indices without loading memory. Its padded domain does not enlarge any input allocation.
- Runtime predicates guard input reads as well as output writes, for each owned value. Python tracing-time control flow cannot replace a GPU runtime branch; follow the pinned API pattern in lesson 10.

Use thread-dependent coordinates to check the full small domain. Choose input data that differs from offsets, such as `100 + index`, when teaching actual reads. Keep benchmarks separate from correctness and avoid assertions that an optimization must win.

## Write a standalone teaching walkthrough

Write for a public reader who has not seen the conversation. Introduce the concept, follow a concrete example, and explain why each step leads to the next. Avoid conversational replies, private-discussion references, edit history, and unexplained terms.

Use the sequence in the reference as a guide, adapting headings to the topic. Introduce data and coordinate meanings before ownership and accesses. Place diagrams near the explanation they support; follow each with a short instruction about what to trace. Explain one likely confusion through the example rather than accumulating warnings.

Include the native API expressions being taught, the expected practice checkpoint and what it represents, root-relative run commands, a linked worked solution, one revision question with a collapsible answer, and previous/next navigation. Distinguish API fragments and conceptual pseudocode from complete runnable programs. Link relevant authoritative sources and state any version-specific limits.

## Draw reproducible illustrations

Create exact diagrams with the drawing helpers in `tools/`; these mappings benefit from precise grids, labels, and arrows. Reuse `Figure` from `tools/draw_divide_comparison.py` or `Diagram` from `tools/draw_lesson_visuals.py` when suitable. Add a focused generator if the existing ones no longer fit.

Save each SVG and matching PNG under `assets/<section>/<lesson>/`, mirroring lesson subdirectories. Shared figures stay with the lesson that introduces them. Generators must create missing parent directories. Follow [assets/README.md](../../../assets/README.md).

Label what the numbers represent. Use consistent owner colors within an explanation, plus text labels so color is not the only cue. Include a clear title, readable text, SVG accessibility information, and descriptive Markdown alt text. Show both memory order and per-thread grouping when that distinction is the lesson's point. Do not illustrate a different shape or input from the walkthrough without explaining the change.

Regenerate the affected figures and inspect rendered images. Check small-screen readability, labels, arrows, missing glyphs, overlaps, and the highlighted numeric trace. A successful generator alone is not visual validation.

## Derive the practice scaffold

Start from the verified solution. Replace only the expressions that teach this lesson with numbered `None` TODOs and `NotImplementedError` guards, following a nearby exercise. Keep the same inputs, launch, stores, and host checker in both files. The README must use the same variable names and TODO order.

Keep the new starter unfinished and its solution runnable. Do not reset or overwrite completed exercises elsewhere. The CLI should report `Practice not finished: ...` for an incomplete starter and `Exercise passed: ...` with a readable checkpoint for a completed program.

## Integrate and verify

Update the section index, course overview, previous/next links, and `ROADMAP.md` where the new lesson changes the learning path. Add a concise reference to `CHEATSHEET.md` when introducing an operation that belongs there. Record sources, tested versions, GPU target, and the scope of the checks in `SOURCES.md`. Update documented lesson counts where necessary.

`examples/layout_walkthrough.py` discovers `lessons/**/solution.py` recursively. A new standard lesson is included automatically; do not add a second manual registry. Add an extra cross-check to `examples/gpu_layout_check.py` only when the concept needs coverage beyond its own checker.

Run from the repository root, substituting the new lesson's actual path:

```bash
pixi run python lessons/<section>/<lesson>/solution.py
pixi run python lessons/<section>/<lesson>/practice.py
pixi run gpu-check
```

The starter command should exit with its intended unfinished-practice message. Verify the completed practice path in a temporary copy by filling the intended expressions and running its checker; leave the repository's starter unfinished. Confirm the full GPU check includes the new solution. Use targeted Ruff checks for changed Python files, check local links and SVG/PNG pairs, and run `git diff --check`.

If GPU execution is unavailable, finish the documentation, diagrams, code, and static checks that can be completed; report the unverified commands explicitly and do not label native execution as passed. For prose-only revisions, rerun relevant link/visual checks; do not claim a new GPU validation run.

Before delivery, trace the chosen example across the README, image labels, solution, and expected table. Report the lesson location, learning outcome, visual additions, and actual validation results.
