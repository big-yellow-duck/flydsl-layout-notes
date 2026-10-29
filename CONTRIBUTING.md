# Extending these notes

Keep each lesson focused on one question. Start with intuition, trace one small example, then explain one common confusion. Finish with a revision question and a collapsible answer.

- Preserve the coordinate/offset distinction and show parentheses explicitly.
- Use exact diagrams with readable labels; keep the drawing source in `tools/`.
- Use native FlyDSL operations in lessons; do not add a Python layout interpreter. Run `pixi run gpu-check` and record the FlyDSL version and target GPU. Use thread-dependent coordinates to check the whole small domain.
- Link to the relevant upstream source. Mark API patterns, pseudocode, and runnable programs clearly.
- Update the roadmap when a new lesson is completed.

To regenerate diagrams, install Pillow in your preferred Python environment, then run:

```bash
python3 tools/draw_diagrams.py
```

The lessons embed SVGs; PNG copies are included for convenient previews. The numerical walkthrough requires the pinned FlyDSL/ROCm GPU environment. Keep practice TODOs unfinished and solutions runnable.

For new kernels, present data views before ownership and access: create or reuse views, select the work, assign ownership, then load/compute/store. Name intermediate views rather than nesting view creation inside partition calls. Reuse an incoming layout when it already fits. Keep layout-only exercises focused on mappings and keep broad equivalence checks separate from the first access example. Explain coordinate tensors explicitly as index-only views. Keep practice TODO names and README instructions aligned.
