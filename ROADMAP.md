# Learning roadmap

The course now has two sections. Work through each lesson's README and practice kernel, then compare the native FlyDSL solution. The tiny examples prioritize tracing ownership and memory access over performance.

## 00 · Layout algebra

- [00-shapes-and-strides](lessons/00-layout-algebra/00-shapes-and-strides/README.md)
- [01-coordinates-and-views](lessons/00-layout-algebra/01-coordinates-and-views/README.md)
- [02-nested-layouts](lessons/00-layout-algebra/02-nested-layouts/README.md)
- [03-composition](lessons/00-layout-algebra/03-composition/README.md)
- [04-coalescing](lessons/00-layout-algebra/04-coalescing/README.md)
- [05-logical-divide](lessons/00-layout-algebra/05-logical-divide/README.md)
- [06-select-block-tile](lessons/00-layout-algebra/06-select-block-tile/README.md)
- [07-thread-value-layouts](lessons/00-layout-algebra/07-thread-value-layouts/README.md)

## 01 · GPU programming

- [08-tiled-copy](lessons/01-gpu-programming/08-tiled-copy/README.md)
- [09-register-fragments](lessons/01-gpu-programming/09-register-fragments/README.md)
- [10-predicates-and-tails](lessons/01-gpu-programming/10-predicates-and-tails/README.md)
- [11-vector-addition](lessons/01-gpu-programming/11-vector-addition/README.md)
- [12-inspect-and-tune](lessons/01-gpu-programming/12-inspect-and-tune/README.md)

All thirteen worked solutions compile and run on the pinned FlyDSL 0.4.1 / ROCm environment. Run `pixi run lessons-check`, or `pixi run gpu-check` to include the extra layout and sliced-view checks. The last lesson runs a small event-timed benchmark; its results are observations, not pass/fail performance thresholds.

The vector-add lesson uses per-value guarded scalar accesses for both full tiles and tails. The full-tile fragment lesson separately teaches tiled copies. A full-block vectorized path plus a guarded tail path is a useful next optimization, not a prerequisite for correctness.

## Further study

Shared-memory staging and synchronization, asynchronous copies, reductions, matrix operations, dynamic shapes, general strided tilers, and occupancy/register-pressure tuning remain beyond this sequence. Extend the correctness checks before tuning a new access pattern.
