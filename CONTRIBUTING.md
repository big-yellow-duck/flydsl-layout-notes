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
python3 tools/draw_grouped_traversal.py
python3 tools/draw_split_k.py
python3 tools/draw_skinny_lessons.py
python3 tools/draw_operand_paths.py
python3 tools/animate_matmul_tuning.py
```

The video generator also requires FFmpeg with the libx264 encoder; pass `--ffmpeg PATH` to select a full FFmpeg build. It writes a chaptered MP4 with keyframes at every visual step for scrubbing.

The lesson-specific generators reuse the drawing helpers in `tools/`. `draw_lesson_visuals.py` covers coordinates, divide selections, block windows, copies, fragments, tails, launches, and copy widths.

Store diagrams under `assets/<section>/<lesson>/`, mirroring the `lessons/` hierarchy, including the four divide tutorial subfolders. Keep each SVG beside its matching PNG preview. Shared figures stay with the lesson that introduces them; other pages link to that same asset. See the [asset directory guide](assets/README.md) for the structure. Generators create their destination folders automatically.

The lessons embed SVGs; PNG copies are included for convenient previews. The numerical walkthrough requires the pinned FlyDSL/ROCm GPU environment. Keep practice TODOs unfinished and solutions runnable.

For new kernels, present data views before ownership and access: create or reuse views, select the work, assign ownership, then load/compute/store. Name intermediate views rather than nesting view creation inside partition calls. Reuse an incoming layout when it already fits. Keep layout-only exercises focused on mappings and keep broad equivalence checks separate from the first access example. Explain coordinate tensors explicitly as index-only views. Keep practice TODO names and README instructions aligned.

Archived research figures can be regenerated separately with `python3 experiments/wave-local-prefetch/draw_figures.py` and `python3 experiments/wave-specialization/draw_figures.py`. Their native sources and raw result snapshots retain the original experiments.

Name copy ownership for its role. A plan shared by global-to-register loads and register-to-LDS stores uses `staging_thread_layout`, `staging_value_layout`, `staging_copy_tile`, `staging_copy_tv`, `staging_copy_plan`, and `thread_staging_copy`. Prefix operand-specific plans with `left_` or `right_`, as in `left_staging_thread_layout` and `left_thread_staging_copy`. Use `left_staging_fragment` / `right_staging_fragment` for temporary registers, `left_global_source` / `right_global_source` for global partitions, and `left_lds_destination` / `right_lds_destination` for LDS partitions. Name operand-consumption plans `left_lds2reg_copy_plan` / `right_lds2reg_copy_plan`; a thread slice uses `left_lds2reg_thread_copy` / `right_lds2reg_thread_copy`. Keep these identifiers consistent in solutions, practice TODOs, and README examples.
