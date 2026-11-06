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
        ├── 07a-buffer-access/
        ├── 07b-operand-staging/
        ├── 07c-grouped-traversal/
        ├── 08-parameter-tuning/
        ├── 09-split-k/
        ├── 10-wave-local-tiles/
        ├── 10a-synchronization-scope/
        ├── 10b-cache-policy/
        ├── 10c-k-unrolling/
        └── 12-operand-paths/
```

Stage 05 includes `tiled-mma-waves.svg` and its PNG preview, showing the four wave32 groups in a 32×32 output block.

Shared illustrations stay with the lesson that introduces their concept. For example, the course overview uses the logical-divide figure from lesson 05; it links to that asset directly.

The drawing sources live in [`tools/`](../tools/). Regeneration commands and contribution guidelines are in [CONTRIBUTING.md](../CONTRIBUTING.md). When adding a diagram, have its generator save both formats into the corresponding lesson folder, then link the SVG from the lesson README.

Stage 06 includes `lds-bank-map.svg` and its PNG preview. Regenerate it with `python3 tools/draw_matmul_lessons.py`; bank labels sketch addresses, while the lesson's captured profiler counters establish the measured conflict ratio.

Stage 07 includes `load-compute-schedule.svg` and its PNG preview. The diagram shows program order and buffer contents across prologue, steady state, and drain, rather than measured cycle durations. Regenerate it with `python3 tools/draw_matmul_lessons.py`.

The stage-08 `register-reuse` SVG/PNG compares a 32×32 reference with the selected 128×128 output tile and its 1×4 wave arrangement. `fragment-lifetime` shows a 32-wide LDS stage consumed through two 16-wide operand fragments.

Stage 08 includes `strategy.mp4`, a 4½-minute H.264 video of the complete dataflow, with `strategy.svg` and `strategy.png` as static previews. It distinguishes grouped output-block mapping, the K reduction, and M/N operand reuse. Longer holds, embedded chapters, and keyframes at every visual step support pausing and scrubbing. Regenerate these assets with `python3 tools/animate_matmul_tuning.py` (Pillow and FFmpeg with libx264 required); use `--ffmpeg PATH` to select a full FFmpeg build. Durations illustrate the sequence rather than GPU timing.

Stage 07a includes `buffer-staging.svg` and its PNG preview, tracing buffer global transfers with the existing shared staging plan at the fixed 64×64×64 tile. Regenerate with `python3 tools/draw_matmul_lessons.py`.

Stage 07b includes `operand-staging.svg` and its PNG preview, deriving A and B ownership from contiguous K and N at fixed 64×64×64 dimensions. Regenerate with `python3 tools/draw_matmul_lessons.py`.

Stage 07c includes `grouped-traversal.svg` and its PNG preview. It compares row-major and two-row grouped block IDs at the same 64×64×64 tile size. Regenerate with `python3 tools/draw_grouped_traversal.py`.

Stage 09 includes `split-domain` and `last-arrival` SVG/PNG pairs. They trace output-tile/K-partition ownership and the in-kernel FP32 finalizer. Regenerate with `python3 tools/draw_split_k.py`.

Stages 10–10c each include one SVG/PNG pair: `wave-tiles`, `synchronization-scope`, `cache-policy`, and `k-unrolling`. They trace independent output ownership, memory versus execution scope, eight-value copy vectors versus 32-value staging fragments, and full-group/tail/drain steps. Regenerate all four with `python3 tools/draw_skinny_lessons.py`.

The original combined-wave and specialized-wave figures live with their [research archives](../experiments/README.md), outside the main course assets. Their generators are in the corresponding experiment directories.

Stage 12 includes `operand-paths` and `operand-trace` SVG/PNG pairs. They show the private A register path, coalesced B staging through LDS, and exact global/LDS element offsets for native compute thread 3. Regenerate with `python3 tools/draw_operand_paths.py`; `ownership.py` checks every illustrated ownership mapping.
