# Profiles and measurements for independent wave tiles

All records below were collected on **2026-11-06**, after the reported cooling repair, using Radeon 8060S Graphics (`gfx1151`), FlyDSL 0.4.1, PyTorch 2.13.0+rocm10.0.0, HIP 7.15.26333, ROCm SDK 10.0.0, and ROCprofiler-SDK 1.3.5. The inputs/output are contiguous row-major BF16 with FP32 accumulation. CPU FP32 products provide the independent reference outside timing.

## Identify the bottleneck

The [stage-09 wide profile](20261106/stage09-wide/summary.json) compares its locked 16×32×16, one-wave, split_k=1 kernel with Torch. Each counter pass records eight native and eight Torch dispatches in alternating order after 20 warm-ups per implementation. ROCTx selected regions exclude allocation, compilation, warm-up, and validation. Each group runs in a separate process; all raw CSVs, worker metadata, profiler commands, available counters, and stderr are retained beside the summary.

| Median metric per dispatch | Stage 09 | Torch |
| --- | --- | --- |
| Memory-unit busy, including stalls | 97.90% | 98.51% |
| LDS bank-conflict ratio | 7.14% | 23.07% |
| ALU stalled by LDS | 0.75% | 22.35% |
| LDS instructions | 2,424,832 | 4,850,688 |
| L1→L2 128-byte read requests | 1,065,281.5 | 1,229,052 |
| External 128-byte read requests | 528,263 | 542,869 |
| Launched waves | 128 | 256 |
| Allocated LDS bytes per block | 2048 | 4096 |
| Profiler VGPR count / scratch bytes | 64 / 0 | 80 / 0 |

The native kernel is already ahead on LDS metrics. Its approximately 64.49 MiB of 128-byte external reads is close to the 64 MiB B input plus 0.25 MiB A. The cache-request path is therefore a stronger optimization target than further LDS bank tuning. This is an inference from counters, instruction inspection, and the controlled ablations below; busy percentages alone do not establish bandwidth saturation.

The [16×1024 capture](20261106/stage09-16x1024/summary.json) and [32×1024 capture](20261106/stage09-32x1024/summary.json) profile the two split-K defaults as well. Their native memory-unit busy medians are 77.14% and 74.07%, below the wide case's 97.90%. Their policies remain shape-specific; the wide-case optimization does not replace their split-K geometry.

The [stage-10 wide profile](20261106/stage10-wide/summary.json) records **533,093.5** L1→L2 requests and **526,337.5** external 128-byte reads. Cache requests fall about 50%; external reads change less than 1%. Native launched waves fall to 64, LDS allocation becomes 5632 bytes, and VGPR count rises to 120 with zero scratch. These resource counts describe the specialization, not measured occupancy. The SDK's [counter-definition excerpts](20261106/counter-definitions.yaml) preserve the installed descriptions, expressions, architecture mappings, and full configuration hash. Several counters have emulation qualifiers; instruction counters are not byte counters or spill measurements.

Profiler trace medians are 285.65/288.29 µs for stage 09/Torch and 270.45/290.17 µs for stage 10/Torch. Those are **instrumented dispatch durations**, collected separately from both counter passes and uninstrumented throughput. They are not the basis of the performance classification.

The [ISA/LLVM capture](20261106/inspection/summary.json) verifies BF16 WMMA, wavefront fences with local-address-space metadata, no global invalidation or workgroup barrier in the wide split_k=1 specialization, 5632 LDS bytes, and zero scratch. Generic stage-09 barriers emit `buffer_gl0_inv` in the K loop. The initial [source snapshot](20261106/profile-source-snapshot.txt) matches the module hash in its profile and first verification. The final host checker additionally covers unroll boundaries; its native `build` factory hash is identical.

The [LDS-only control profile](20261106/lds-only-ablation/summary.json) keeps the original 32-column geometry: LDS instructions remain 2,424,832 and load instructions remain 196,608, while the SDK's TEX_STORE counter falls from 133,120 to 2048. The ISA removes cache invalidations and retains output stores. Treating that counter difference as eliminated spill or partial-result bytes would be incorrect; both specializations have zero scratch. A separate [split_k=4 inspection](20261106/inspection-split-k4/summary.json) verifies that agent-scope acquire/release arrivals and release resets survive the LDS-only change.

The Torch kernel's complete Tensile name is retained per dispatch. This study compares the installed GPU `torch.matmul` path; it does not generalize the result to every BLAS backend or a separately selected library algorithm.

## Add the changes one at a time

[ablation.json](20261106/ablation.json) uses seed 13, the same shape and arithmetic, three rounds, and a shuffled variant order per round. Each measurement pairs five native/Torch graph batches with ten replays of a 32-operation capture. All variants pass complete trace/random output and changed-input replay checks.

| Cumulative change | Median native / Torch, µs |
| --- | --- |
| Original stage 09 | 295.24 / 290.07 |
| LDS-only fences | 293.98 / 289.96 |
| 64-column per-wave tile | 293.59 / 289.87 |
| Two independent waves per physical block | 286.60 / 289.83 |
| B cache modifier 2 | 279.25 / 290.42 |
| Four-step loop unroll | 274.44 / 290.04 |

This prevents assigning the full improvement to barrier narrowing or tile width alone. The [exploratory records](20261106/exploration) also preserve seed-13 probes for cache hints, copy widths, register lookahead, transposed B staging, K rotation, direct operand reads, and two LDS stages. The two-stage probe covers even full-size K-tile counts only; it is not a general tail-safe lesson implementation. Text source snapshots describe the experimental builders, while the supported lesson keeps the verified single-stage pipeline. These short training measurements selected a candidate; they are separate from the locked verification.

## Verify the locked choice

The wide tuple is `16×64×16`, `waves_m=waves_n=1`, `wave_groups=2`, `split_k=1`, `k_unroll=4`, and `right_cache_modifier=2`. The two narrow configurations retain 16×64×64 and 32×64×64 tiles, two cooperative waves, split_k=4, wave_groups=1, k_unroll=1, and cache modifier 0.

Each verification has three seeds, three rounds per seed, seven alternating paired batches per round, and five warm-up batches. Graph batches replay a 32-operation capture twenty times; direct batches use fifty ordinary Python calls. Graph inspection requires exactly 32 kernel nodes for native, with no reduction, clear, or memset pass. Every capture is replayed after negating A and poisoning output, then checked again after restoring A. Workspace and output sentinels and reset counters are checked throughout.

| Verification | Native / Torch median, µs | Worst paired round | Classification |
| --- | --- | --- | --- |
| [16×1024 graph](20261106/verification-16x1024-graph.json) | 22.78 / 34.39 | 0.6825 | Win |
| [32×1024 graph](20261106/verification-32x1024-graph.json) | 28.90 / 64.99 | 0.4593 | Win |
| [16×4096 graph, fresh repeat](20261106/verification-wide-repeat.json) | 273.47 / 290.39 | 0.9443 | Win |
| [16×4096 graph, initial](20261106/verification-wide-graph.json) | 273.64 / 290.35 | 0.9441 | Win |
| [16×4096 direct](20261106/verification-wide-direct.json) | 275.78 / 290.87 | 0.9556 | Parity |
| [Stage-09 wide graph](20261106/verification-stage09-wide.json) | 301.85 / 290.57 | 1.0406 | Parity |

The initial wide benchmark uses seeds 2026111201–2026111203; the first seed was also used by the initial baseline profiling worker. Candidate selection uses seed 13 only. The fresh wide repeat and the other rows use 2026111301–2026111303, with no subsequent parameter changes. The native factory hash agrees across both wide verifications, profiling, and the final kernel. Logs and complete paired samples accompany each JSON file.

Win means **every round** has a median paired native/Torch ratio below 0.95. Parity means every round is at or below 1.05. The primary three-shape graph verification passes 27/27 rounds; the two wide graph runs pass 18/18. Wide graph throughput is about 6% faster than matched Torch and about 9% faster than the freshly reverified stage-09 fallback. The direct result does not meet the strict all-round win threshold. These are warm, preallocated, synchronized host measurements on one GPU, not a general latency or cross-device claim.

## Correctness and practice checks

The [course check](20261106/gpu-check.log) passes all 31 native solutions plus the additional layout/view checks. Stage 10 covers all nine shape/split combinations. Its wide tagged boundaries include 1–6 local K tiles, and random/trace tests change inputs between repeated workspace uses. The [completed temporary practice](20261106/completed-practice-all.log) passes the same nine combinations, and [its ordinary CLI](20261106/completed-practice-cli.log) passes correctness and its own graph benchmark. Filling the two intended expressions produces the same Python AST as the solution. The [checked-in starter](20261106/unfinished-practice.log) retains its intended unfinished-practice message.

## Reproduce from the repository root

Use fresh output paths:

```bash
pixi run python lessons/01-gpu-programming/13-matmul/09-split-k/profile.py \
  --collect --output /tmp/stage09-skinny-profile
pixi run python lessons/01-gpu-programming/13-matmul/09-split-k/profile.py \
  --collect --module experiments/wave-local-prefetch/solution.py \
  --output /tmp/stage10-skinny-profile
pixi run python experiments/wave-local-prefetch/inspect_kernel.py \
  --output /tmp/stage10-skinny-isa
pixi run python experiments/wave-local-prefetch/inspect_kernel.py \
  --split-k 4 --output /tmp/stage10-split-k-isa
pixi run python experiments/wave-local-prefetch/tune.py \
  --ablate --output /tmp/stage10-skinny-ablation.json
pixi run python experiments/wave-local-prefetch/tune.py \
  --verify --seeds 2026111301 2026111302 2026111303 \
  --output /tmp/stage10-skinny-heldout.json
```

Pass `--shape 16 1024 8192` or `--shape 32 1024 8192` for the narrow verifications, and `--timing direct-host` for ordinary dispatch. `profile.py` accepts the same shape selector. Its optional `--group` restricts collection to a named counter group. `tune.py --sweep` exposes a bounded 96-combination tile/group/unroll/cache search at the selected split count; reserve unused seeds after any new selection. The exploratory measurements above do not claim a completed run of that new combined CLI search.
