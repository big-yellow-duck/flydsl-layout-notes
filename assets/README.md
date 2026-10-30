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
    └── 12-inspect-and-tune/
```

Shared illustrations stay with the lesson that introduces their concept. For example, the course overview uses the logical-divide figure from lesson 05; it links to that asset directly.

The drawing sources live in [`tools/`](../tools/). Regeneration commands and contribution guidelines are in [CONTRIBUTING.md](../CONTRIBUTING.md). When adding a diagram, have its generator save both formats into the corresponding lesson folder, then link the SVG from the lesson README.
