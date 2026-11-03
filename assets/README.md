# Lesson diagrams

Diagrams follow the same section and lesson hierarchy as `lessons/`. Open the folder for a lesson to find its illustrations. Each diagram has an SVG used in the lesson and a matching PNG for previews; keep the pair together.

```text
assets/
├── 00-layout-algebra/
│   ├── 00-shapes-and-strides/
│   ├── 01-coordinates-and-views/
│   ├── …
│   ├── 05-logical-divide/
│   │   ├── logical-divide.svg
│   │   ├── logical-divide.png
│   │   ├── divide-comparison-before.svg
│   │   ├── divide-comparison-before.png
│   │   ├── divide-comparison-after.svg
│   │   ├── divide-comparison-after.png
│   │   ├── 01-logical/
│   │   ├── 02-zipped/
│   │   ├── 03-tiled/
│   │   └── 04-flat/
│   ├── 06-select-block-tile/
│   └── 07-thread-value-layouts/
└── 01-gpu-programming/
    ├── 08-tiled-copy/
    ├── 09-register-fragments/
    ├── 10-predicates-and-tails/
    ├── 11-vector-addition/
    ├── 12-inspect-and-tune/
    └── 13-matmul/
        ├── 00-naive/
        ├── 01-coalesced-access/
        ├── 02-register-tiling/
        ├── 03-shared-memory/
        ├── 04-vectorized-copy/
        ├── 05-matrix-instructions/
        ├── 06-lds-swizzle/
        ├── 07-interleaved-loads/
        └── 08-parameter-tuning/
```

Stage 05 includes `tiled-mma-waves.svg` and its PNG preview, showing the four wave32 groups in a 32×32 output block.

Shared illustrations stay with the lesson that introduces their concept. For example, the course overview uses the logical-divide figure from lesson 05; it links to that asset directly.

The drawing sources live in [`tools/`](../tools/). Regeneration commands and contribution guidelines are in [CONTRIBUTING.md](../CONTRIBUTING.md). When adding a diagram, have its generator save both formats into the corresponding lesson folder, then link the SVG from the lesson README.

Stage 06 includes `lds-bank-map.svg` and its PNG preview. Regenerate it with `python3 tools/draw_matmul_lessons.py`; bank labels sketch addresses, while the lesson's captured profiler counters establish the measured conflict ratio.

Stage 07 includes `load-compute-schedule.svg` and its PNG preview. The diagram shows program order and buffer contents across prologue, steady state, and drain, rather than measured cycle durations. Regenerate it with `python3 tools/draw_matmul_lessons.py`.

The stage-08 `register-reuse` SVG/PNG compares 32×32 and selected 128×64 tiles with the same four-wave MMA ownership. Cells identify wave owners; captions state derived accumulators, grid size, and LDS allocation. Performance measurements are recorded separately in the lesson.
