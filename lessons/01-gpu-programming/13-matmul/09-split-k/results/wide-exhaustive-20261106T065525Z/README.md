# Exhaustive tile/wave/split search for 16×4096×8192

Run on 2026-11-06 after the hardware cooling repair, using the unchanged single-kernel implementation on gfx1151. The tuner now supports `--exhaustive`. This search fixes `group_m=1`, one LDS stage, A padding of eight BF16 values, 128-bit global staging copies, and the existing K-partition mapping.

| Dimension | Enumerated values |
| --- | --- |
| Block M / waves M | 16 / 1 |
| Block N | 16,32,64,128,256,512,1024,2048,4096 |
| Block K | 16,32,64,128,256,512,1024,2048,4096,8192 |
| Waves N | 1,2,4,8 |
| Split K | 1,2,4 |

This is the full complete-tile/wave/split space within the current kernel's limits for this shape. It is not a search over other staging algorithms, copy widths, padding, or memory layouts.

The [training report](training.json) enumerates **1080 combinations**: **948** are pruned before compilation for K-partition, whole-WMMA, cooperative-copy, or 64-KiB LDS constraints; **132** compile and pass full trace/random correctness. There are no compilation or numerical rejections among the valid configurations. This adds 30 legal configurations beyond the earlier 102-case sweep, including K=256/512 and eight-wave choices.

Each valid configuration is timed against GPU Torch on the same seed-13 input using three alternating batches of five 32-GEMM graph replays. Every native capture contains exactly 32 kernel nodes and no clear/reduction pass; input mutation, output sentinels, and workspace reset are checked. Samples, paired orders, source hashes, and pruning counts remain in the JSON.

## Training confirmation and selection

[confirmation.json](confirmation.json) rotates the top three candidates and the leading split-K candidate through three longer seed-13 rounds, with seven alternating batches and ten graph replays per batch. Selection minimizes the worst paired native/Torch ratio across those three training rounds. The training-selected tuple is **BM=16, BN=64, BK=16, waves=1×1, split_k=1**. The best split-enabled candidate still used split_k=2 and remained slower in training.

The tuple was locked before [fresh-seed verification](verification-best.json) using seeds 2026111001–2026111003. The [existing default](verification-existing.json), BM=16, BN=32, BK=16, waves=1×1, split_k=1, was checked on the same fresh seeds as a control. Each has nine rounds of seven alternating batches, with twenty graph replays per batch.

| Configuration | Native µs | GPU Torch µs | Worst paired native/Torch ratio | Classification |
| --- | ---: | ---: | ---: | --- |
| Training-selected 16×64×16 / 1×1 / split 1 | 300.98 | 290.43 | 1.0420 | match |
| Existing 16×32×16 / 1×1 / split 1 | 301.95 | 290.15 | 1.0429 | match |

Times are medians of round medians from synchronized host timing of matched graph replay. The selected candidate is about 3.6% slower than Torch; the existing default is about 4.1% slower. Both meet the previously declared 5% parity band, and neither meets the all-round win criterion (every paired round ratio below 0.95). Their sub-percent difference does not justify changing the default. The existing solution and practice configuration tables remain unchanged.

Full-output, tagged boundary, workspace reuse, sentinels, reset counters, and changed-input graph checks passed. Kernel-factory hashes agree across search, confirmation, and both verification reports. The kernel implementation was not changed for this search.

[Search telemetry](telemetry.json) contains 102 once-per-second samples; GPU edge temperature ranged from 36 to 63 °C. [Confirmation telemetry](confirmation-telemetry.json) is retained separately. No clock or power settings were changed.

Reproduce with fresh output paths and unused verification seeds:

```bash
pixi run python lessons/01-gpu-programming/13-matmul/09-split-k/tune.py \
  --sweep --exhaustive --shape 16 4096 8192 \
  --timing graph-host --output /tmp/wide-exhaustive-training.json
pixi run python lessons/01-gpu-programming/13-matmul/09-split-k/tune.py \
  --verify --shape 16 4096 8192 --config 16,64,16,1,1,1 \
  --seeds 2026111101 2026111102 2026111103 --output /tmp/wide-exhaustive-heldout.json
```

[Lesson](../../README.md) · [All measurement records](../README.md)
