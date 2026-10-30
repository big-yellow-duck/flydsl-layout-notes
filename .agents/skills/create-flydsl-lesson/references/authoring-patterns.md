# Lesson authoring patterns

Use these patterns while drafting a new lesson. They describe the repository's teaching contract; adapt the headings and amount of explanation to the concept. Repository paths in this reference are relative to the repository root.

## Plan the walkthrough before drafting

Choose a learning question that has an observable answer, such as “How does a block select its own window?” Choose one small example, then write down:

| Item | Example for block selection |
| --- | --- |
| Existing data | 32 values with `source[i] = 100 + i` |
| Work division | Four windows of eight values |
| Launch | Four blocks, eight threads per block |
| Trace | Block 2, thread 3 |
| Mapping | Base offset 16, local coordinate 3, original offset 19 |
| Actual read | Value 119 |
| Common confusion | Adding the selected view's base offset twice |
| Checker | Compare the complete copied vector, then return one tile as the checkpoint |

Use these facts consistently in the diagram, prose, kernel, and host checker. The small trace explains the operation; the complete check establishes that the other positions work too.

## README sequence

Use `# <number> · <learning action or concept>` for the title. The outline below is a writing guide, not a set of headings to copy verbatim.

1. **Introduce the concept and outcome.** Explain what the operation does and why it is needed using terms already taught. Name prerequisites when they matter.
2. **Establish the example and show it.** State the domain, layouts, input values, and launch dimensions as applicable. Embed the first diagram early enough to orient the reader.
3. **Walk through the operation.** Use short sections and focused code fragments in execution or mapping order. Explain each intermediate before using it. Follow one coordinate or thread through to the result.
4. **Explain the important distinction.** For example, show why the number of values owned by a thread does not require those positions to be neighbors, or why slicing retains the original row stride.
5. **Define the practice.** Name the expressions to implement and what the supplied scaffold already does. Explain the output shape, expected checkpoint, and complete checker coverage.
6. **Ask a revision question.** Include an answer in `<details><summary>Answer</summary>`, with blank lines around its Markdown content. A small variation is useful when it reinforces the same concept.
7. **Provide run commands and continuation.** Give commands from the repository root for both programs, explain unfinished versus passing output, and link the worked solution and adjacent lessons. Put the question near the end of the teaching content; run instructions and navigation can follow it.

Use natural teaching prose: “Follow thread 2. Its local coordinate is `(1,2)`, so the relative offset is 10. The selected view already carries base offset 20, giving original offset 30.” Avoid reply-style openings such as “Yes, exactly,” and references such as “as discussed earlier” when they rely on a private conversation. Public links to preceding lessons provide the necessary context.

A diagram caption should explain how to read it: “Read the gold window first. The cells show original storage offsets; selecting the window preserves the row stride of 8.” Repeating the image title adds little guidance.

## Program contract

Adapt a nearby working lesson rather than inventing a new FlyDSL harness. The common structure is:

| Program part | Responsibility |
| --- | --- |
| Module docstring | Identify the lesson and its root-relative run command |
| `@flyc.kernel exercise_kernel(...)` | Describe indexing, ownership, and native GPU operations; include numbered conceptual comments |
| `@flyc.jit run(...)` | Launch with grid and block dimensions matching the example |
| Host `solve()` | Prepare inputs/output, call `run`, synchronize, check every result, return a readable checkpoint |
| CLI entry point | Print `Exercise passed:` or turn an unfinished expression into `Practice not finished:` |

Use `flydsl.compiler as flyc`, `flydsl.expr as fx`, and PyTorch host allocation as in the neighboring lessons. ROCm PyTorch uses `device="cuda"` here. Preserve the launch and type conventions that the example needs; optional stream parameters are not required for every lesson.

A practice expression follows this pattern inside the kernel:

```python
# TODO 1: Fill in element_offset; see README.md.
element_offset = None
if element_offset is None:
    raise NotImplementedError("Fill in element_offset.")
```

The corresponding solution assigns the native expression directly, with a comment explaining its role. Supply the surrounding data setup, output stores, launch, and independent host assertions in both files. Leave incidental mechanics supplied when they are not the learning objective, such as the structured GPU branch in the bounds lesson.

Only use a focused lint suppression when the unfinished scaffold creates an unavoidable unused variable. Do not turn off unrelated checks or leave placeholder scaffolding in the solution.

## Checks by lesson type

| Type | Checks that establish the lesson's claim |
| --- | --- |
| Layout-only | Evaluate every small-domain coordinate using thread-dependent inputs. Check the ordered mapping, not just the set of reached offsets. |
| Composition | Check intermediate logical indices as well as final offsets when the distinction matters. Use the original layout's logical size for bounds. |
| Coalescing | Compare corresponding scalar logical positions before and after simplification; the tuple coordinate structure may change. |
| Divide/slice | Fix explicit tile coordinates, preserve the selected view's base and strides, and verify actual loaded values. Compare corresponding named coordinates across variants, since equal scalars can differ. |
| Ownership | Verify each thread's complete value list and coverage/uniqueness for the regular plans being taught. Distinguish slot counts from physical placement. |
| Copy/fragment | Compare the complete destination with an independent host reference. Distinguish fragment allocation from initialization and loading. |
| Tails | Use exact-sized inputs and test tile boundaries as well as a partial tile. Guard both reads and writes per value; output sentinels check stray writes but do not prove read safety. |
| Measurement | Validate both variants, compile and warm up before timing, hold ownership/input size constant, record the timing method and GPU/version, and inspect generated instructions before claiming an instruction-level change. |

Do not claim that all static layout algebra runs as runtime GPU arithmetic: the compiler may fold it. Keep runtime thread coordinates so the checker still exercises the complete example.

## Diagram mechanics

The generators in `tools/` save SVG/PNG pairs under paths relative to `assets/`. For example, a lesson-specific generator can reuse the existing helper like this:

```python
from draw_divide_comparison import COLORS, Figure

fig = Figure(260, "A shape gives four logical positions")
fig.text(32, 70, "Cells show logical coordinates q for shape 4.")
for q in range(4):
    fig.cell(32 + q * 110, 125, q, COLORS[0], 100)
fig.text(32, 205, "Strides determine which offsets these coordinates will reach.")
# Save to assets/<section>/<lesson>/<diagram-name>, supplying a concrete path.
```

Choose the actual lesson path in `fig.save(...)` before running the generator. Keep drawing code under `tools/`, where imports from the existing helpers work when launched as `python3 tools/<generator>.py`. Existing helpers create the destination directories. Use readable labels and text that also survives the PNG font choice; inspect both labels and arrow directions after rendering.

SVGs are the embedded artifacts and PNGs are convenient previews. Keep each pair in the same lesson folder, retain shared figures at their introducing lesson, and update generator commands in `CONTRIBUTING.md` when adding a new entry point.
