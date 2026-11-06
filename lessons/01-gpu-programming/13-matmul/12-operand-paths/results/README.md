# Operand paths versus tuned prefetch

The active comparison uses **operand paths**, **independently tuned 10c prefetch**, **same-geometry prefetch**, and **GPU Torch**. All native waves load and compute. Dedicated loader waves and ready/free handoffs remain in the research archive; [lesson 12 explains the measured choice](../README.md#why-the-course-keeps-prefetch).

The 2026-11-07 course-path validation uses fresh seeds `2026112901–03`, with three rounds per seed, seven shuffled paired batches per round and twenty replays per batch. Tests ran on Radeon 8060S (`gfx1151`), FlyDSL 0.4.1, Torch 2.13.0+rocm10.0.0 and reported HIP 7.15.26333. Inputs/output remain contiguous row-major BF16 with FP32 accumulation. Warm buffers, preallocated output/workspace, and one kernel per GEMM are shared contracts; allocation, initialization and the CPU reference are outside timing.

## Locked configurations

The native factory remains `c1a259c38ffb5490e13f30b2cc541a7546a5734dc8b82c02984ef7399b34a3a3`. The 10c control preserves the original combined prefetch builder. No configurations were retuned for this validation.

| Shape M,N,K | Output tile | K chunk | Compute waves | Independent groups | Split K | Unroll | A path |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 16,1024,8192 | 16×64 | 32 | 2 | 1 | 4 | 8 | Registers |
| 32,1024,8192 | 32×64 | 32 | 2 | 1 | 4 | 8 | Registers |
| 16,4096,8192 | 16×64 | 16 | 1 | 2 | 1 | 4 | LDS |

All use A policy 0 and B policy 2. [Selection](prefetch-comparison-selection.json) locks the operand-path configs; [prefetch-control.json](prefetch-control.json) locks the independently tuned control. The latter uses K=32/U2 for M=16, K=64/U2 for M=32, and K=16/U4 for the wide case. Same-geometry prefetch instead holds lesson 12's geometry, unroll and cache policy fixed, changing only A's route to LDS.

## Warm graph throughput

| Shape M,N,K | Operand paths µs | Tuned 10c µs | Same-geometry prefetch µs | Paired ratio to tuned 10c | Rounds below 0.95 |
| --- | --- | --- | --- | --- | --- |
| 16,1024,8192 | 20.26 | 21.67 | 21.31 | 0.9327 | 9/9 |
| 32,1024,8192 | 23.75 | 28.07 | 27.11 | 0.8506 | 9/9 |
| 16,4096,8192 | 273.43 | 273.48 | 273.77 | 0.9997 | 0/9 |

M=32 is about **15% lower in paired time** than tuned prefetch, with all nine rounds passing the strict 5% win criterion. Same-geometry prefetch gives a roughly 12% gain, also in all nine rounds. This supports A's register route separately from other tuning changes.

M=16 passes nine rounds against independently tuned prefetch in this run, but its worst ratio is 0.9498, close to the 0.95 boundary. The earlier [seeds 2026112801–03](prefetch-comparison/16x1024x8192-graph-host.json) passed eight of nine rounds. Against same-geometry prefetch, the new run passes five of nine rounds. This is a smaller gain whose strict classification varies across runs. The wide case remains at parity, consistent with both selectors retaining A/B LDS staging.

A win requires every round's median paired ratio below 0.95. Parity requires every round at or below 1.05 when that win criterion fails. Displayed times are medians of round medians; paired ratios are computed inside batches, so ratios of displayed aggregate times can differ. Captures contain exactly 32 kernel nodes for 32 GEMMs, with changed-input replay and output/workspace guards checked before timing. Synchronized host time is divided by GEMMs per replay; these are warm throughput results, not isolated device-event latency.

Raw reports: [M=16](20261107-course-path/16x1024x8192-graph-host.json), [M=32](20261107-course-path/32x1024x8192-graph-host.json), [wide N](20261107-course-path/16x4096x8192-graph-host.json).

## Ordinary calls and Torch

| Shape M,N,K | Operand paths, direct µs | Tuned 10c, direct µs | Paired direct ratio |
| --- | --- | --- | --- |
| 16,1024,8192 | 55.23 | 55.51 | 1.0009 |
| 32,1024,8192 | 55.38 | 55.32 | 1.0065 |
| 16,4096,8192 | 276.98 | 277.56 | 1.0019 |

All three ordinary-dispatch comparisons meet prefetch parity. None establishes the graph-throughput gain as a strict all-round Python-call latency gain. Complete direct reports: [M=16](20261107-course-path/16x1024x8192-direct-host.json), [M=32](20261107-course-path/32x1024x8192-direct-host.json), [wide N](20261107-course-path/16x4096x8192-direct-host.json).

| Shape M,N,K | Operand paths, graph µs | GPU Torch, graph µs | Torch win rounds |
| --- | --- | --- | --- |
| 16,1024,8192 | 20.26 | 34.53 | 9/9 |
| 32,1024,8192 | 23.75 | 59.32 | 9/9 |
| 16,4096,8192 | 273.43 | 290.27 | 9/9 |

All 27 graph rounds satisfy the Torch win criterion. Ordinary calls do not establish consistent strict Torch wins across all rounds. Keep those measurement scopes separate.

## Native evidence and validation

The retained controlled M=32 profile changes only A's path. LDS instructions fall from 638976 to 557056, and the bank-conflict metric falls from 6.25% to zero. Global-load instructions double, while L1→L2 and external 128-byte read requests remain nearly unchanged. That is consistent with A reuse being served above L2 or by coalescing; it does not locate every cache hit. Instrumented profile time is separate from the benchmark: [A in LDS](profile-A-lds/summary.json), [A in registers](profile-A-registers/summary.json). Counter collection was not repeated for this course restructuring because the native factory is unchanged.

The [new validation record](20261107-course-path/validation.json) and [course log](20261107-course-path/course-check.log) cover all **35 native solutions** and extra GPU checks. The selected kernel and temporary completed practice each pass all nine shape/split combinations, trace/random CPU references, signed workspace reuses, tagged K boundaries, NaN output replacement, sentinels and counter reset. Both ordinary CLIs, the intended unfinished starter and AST equivalence pass. [Ownership checking](20261107-course-path/ownership.log) verifies all 14336 illustrated offsets.

Fresh ISA captures confirm exact LDS allocation, zero scratch, BF16 WMMA, vector global loads, wave32 WGP mode and agent-scope split-K ordering: [M=16](20261107-course-path/inspection-16x1024x8192/summary.json), [M=32](20261107-course-path/inspection-32x1024x8192/summary.json), [wide N](20261107-course-path/inspection-16x4096x8192/summary.json). Static resources do not establish occupancy or overlapped cycles.

The [audit](20261107-course-path/audit.json) reconciles source snapshots, the unchanged factory, frozen configurations, research search totals, graph-node counts, and matched profile configurations. The active harness imports 09's measurement utilities and 10c's native kernel directly. It has no wave-specialized reference.

The [initial study](initial-study.md) retains the original same-session wave-specialization comparison. The prior prefetch-only verification remains in [prefetch-comparison](prefetch-comparison/validation.json). Original source snapshots, dates, hashes and producer paths are preserved.

## Reproduce

Run from the repository root with fresh output paths:

```bash
pixi run python lessons/01-gpu-programming/13-matmul/12-operand-paths/solution.py
pixi run python lessons/01-gpu-programming/13-matmul/12-operand-paths/tune.py \
  --verify --shape 32 1024 8192 --output /tmp/operand-vs-prefetch-graph.json
pixi run python lessons/01-gpu-programming/13-matmul/12-operand-paths/tune.py \
  --verify --shape 32 1024 8192 --timing direct-host --output /tmp/operand-vs-prefetch-direct.json
pixi run python lessons/01-gpu-programming/13-matmul/12-operand-paths/verify.py \
  --seeds 2026112901 2026112902 2026112903 --output /tmp/operand-vs-prefetch-all
pixi run python lessons/01-gpu-programming/13-matmul/12-operand-paths/audit.py \
  --verification /tmp/operand-vs-prefetch-all --output /tmp/operand-vs-prefetch-audit.json
```

The solution and completed practice print operand-path, tuned-prefetch, same-geometry-prefetch and Torch times, followed by paired ratios. A different `--seeds` set supplies new held-out inputs. Correctness has no performance threshold.
