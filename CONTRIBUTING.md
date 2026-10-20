# Extending these notes

Keep each lesson focused on one question. Start with intuition, trace one small example, then explain one common confusion. Finish with a revision question and a collapsible answer.

- Preserve the coordinate/offset distinction and show parentheses explicitly.
- Use exact diagrams with readable labels; keep the drawing source in `tools/`.
- Check numerical examples with the CPU walkthrough. If adding real GPU code, validate it separately and record the FlyDSL version and target GPU.
- Link to the relevant upstream source. Mark API patterns, pseudocode, and runnable programs clearly.
- Update the roadmap when a new lesson is completed.

To regenerate diagrams, install Pillow in your preferred Python environment, then run:

```bash
python3 tools/draw_diagrams.py
```

The lessons embed SVGs; PNG copies are included for convenient previews. The numerical walkthrough only needs Python's standard library.
