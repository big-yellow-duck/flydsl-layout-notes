# Extending these notes

Write every README as a standalone teaching document for a public reader. Introduce the concept, walk through a concrete example, and connect each diagram to the code that follows. Avoid replies to prior feedback, references to a private discussion, and editing-history claims such as exercises having been reset.

Keep each lesson focused on one question. Start with intuition, trace one small example, then explain one common confusion. Finish with a revision question and a collapsible answer.

- Preserve the coordinate/offset distinction and show parentheses explicitly.
- Use exact diagrams with readable labels; keep the drawing source in `tools/`.
- Use native FlyDSL operations in lessons; do not add a Python layout interpreter. Run `pixi run gpu-check` and record the FlyDSL version and target GPU. Use thread-dependent coordinates to check the whole small domain.
- Link to the relevant upstream source. Mark API patterns, pseudocode, and runnable programs clearly.
- Update the roadmap when a new lesson is completed.

For assisted lesson authoring, use the repository's [create-flydsl-lesson skill](.agents/skills/create-flydsl-lesson/SKILL.md). It connects the teaching style to the exercise, diagram, navigation, and validation requirements. In Codex, include the skill name with the topic, for example:

```text
$create-flydsl-lesson Add a lesson on shared-memory staging after the current GPU sequence.
```

The skill lives under `.agents/skills/`, the [repository skill location documented by OpenAI](https://developers.openai.com/codex/skills/#where-to-save-skills).

To regenerate diagrams, install Pillow in your preferred Python environment, then run:

```bash
python3 tools/draw_diagrams.py
python3 tools/draw_divide_comparison.py
python3 tools/draw_thread_value_layouts.py
python3 tools/draw_lesson_visuals.py
python3 tools/draw_matmul_lessons.py
```

The lesson-specific generators reuse the drawing helpers in `tools/`. `draw_lesson_visuals.py` covers coordinates, divide selections, block windows, copies, fragments, tails, launches, and copy widths.

Store diagrams under `assets/<section>/<lesson>/`, mirroring the `lessons/` hierarchy, including the four divide tutorial subfolders. Keep each SVG beside its matching PNG preview. Shared figures stay with the lesson that introduces them; other pages link to that same asset. See the [asset directory guide](assets/README.md) for the structure. Generators create their destination folders automatically.

The lessons embed SVGs; PNG copies are included for convenient previews. The numerical walkthrough requires the pinned FlyDSL/ROCm GPU environment. Keep practice TODOs unfinished and solutions runnable.

For new kernels, present data views before ownership and access: create or reuse views, select the work, assign ownership, then load/compute/store. Name intermediate views rather than nesting view creation inside partition calls. Reuse an incoming layout when it already fits. Keep layout-only exercises focused on mappings and keep broad equivalence checks separate from the first access example. Explain coordinate tensors explicitly as index-only views. Keep practice TODO names and README instructions aligned.
