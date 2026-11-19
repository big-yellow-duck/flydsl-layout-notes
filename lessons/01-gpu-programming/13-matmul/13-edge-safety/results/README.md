# Edge-safety measurements

The active lesson uses always-predicated copies and 128-bit A/B loads, automatically narrowed where row alignment requires it. Width and edge-only knobs were removed after these studies; archived source and reports retain the alternatives.

## Descriptor-only bounds experiment

The experiment derives a temporary kernel from the lesson solution. It keeps `make_buffer_tensor(..., max_size=False)` for A, B, and C, and replaces all three predicated transfers with ordinary buffer copies. The copy widths, launch geometry, prefetch schedule, and split-K reduction match the predicated kernel for each shape.

On Radeon 8060S (`gfx1151`), three seeds and nine shuffled graph-replay batches per seed gave these medians per GEMM. Effective TFLOP/s counts `2 * M * N * K` for each implementation.

| M,N,K | Edge | Predicated ms / TFLOP/s | Descriptor-only ms / TFLOP/s | Torch ms / TFLOP/s |
| --- | --- | ---: | ---: | ---: |
| 16,1024,8192 | Complete tiles | 0.021758 / 12.34 | 0.021749 / 12.34 | 0.034429 / 7.797 |
| 17,1024,8192 | M only | 0.039524 / 7.216 | 0.034522 / 8.262 | 0.065090 / 4.382 |
| 16,1024,8200 | K only | 0.036008 / 7.462 | 0.022142 / 12.14 | 0.035055 / 7.665 |
| 16,1032,8192 | N only | 0.029425 / 9.194 | Incorrect | 0.033272 / 8.131 |
| 16,64,24 | Empty split-K slots | 0.003109 / 0.01581 | Incorrect | 0.003740 / 0.01314 |

The descriptor-only kernel also failed all four declared lesson shapes, each of which has a partial N tile. The report times the predicated and Torch paths for those shapes. It includes descriptor-only timings only when the variant passes the lesson’s CPU-reference, poisoned-backing, and guard checks, plus the changed-input graph replay check. [Raw samples and correctness failures](descriptor-only.json)

- **Partial N.** The output column `1032` is outside its row, but its linear offset is the same as column `0` in the next row. The descriptor sees an in-range byte address, so the extra store can overwrite valid output. The N-only trace had 738 mismatches out of 16,512 outputs.
- **Empty split-K.** With `K=24`, `STAGE_K=32`, and four splits, the A and B views each have one K tile. The divided K-stage axis has stride zero. A separate all-ones check produced split partials `[24, 24, 24, 24]` with descriptor-only copies and `[24, 0, 0, 0]` with predicates. The extra splits addressed the real tile again, so the byte bounds accepted the loads.

Run from the repository root with a fresh output path.

```bash
pixi run python lessons/01-gpu-programming/13-matmul/13-edge-safety/results/compare_descriptor_bounds.py --output /tmp/descriptor-only.json
```

## Simplified lesson verification

After removing both configuration knobs and the full-tile branch, the fixed always-predicated path was rechecked on fresh seeds 1313/1414/1515. Seven paired batches per seed and ten graph replays per batch retain the timing scope below. Median times across verification rounds:

| M,N,K | FlyDSL graph μs | Torch graph μs |
| --- | ---: | ---: |
| 7,1032,8200 | 27.44 | 33.58 |
| 17,1032,8200 | 35.21 | 54.97 |
| 31,1048,8184 | 32.20 | 55.15 |

Raw reports and matching source hashes: [M=7](simplified-graph-7x1032x8200.json), [M=17](simplified-graph-17x1032x8200.json), [M=31](simplified-graph-31x1048x8184.json). Measured source snapshots: [solution](simplified-solution.py.txt), [practice](simplified-practice.py.txt), [tuner](simplified-tune.py.txt).

The simplified implementation passes [all 37 GPU solutions](validation/simplified-gpu-check.log), [76 structures, 37 public APIs, and 78 practice paths](validation/simplified-lesson-style.json), and [41 small edge cases plus the four examples](validation/simplified-edge-cases.log). Native inspection retains zero scratch, BF16 WMMA, and the expected loads for [128-bit vector shapes](isa/simplified-vector/summary.json) and [scalar edge shapes](isa/simplified-scalar/summary.json).

## Earlier measurements

The edge-safe kernel is faster than GPU Torch in graph-replay measurements for three declared workloads. All have partial M, N, and K tiles while keeping N/K divisible by eight BF16 values. These results apply to Radeon 8060S (`gfx1151`), FlyDSL 0.4.1, PyTorch 2.13.0+rocm10.1.0, and reported HIP 7.16.26385 on 2026-11-17.

| M,N,K | FlyDSL graph μs | Torch graph μs | Paired ratio range across fresh seeds |
| --- | ---: | ---: | ---: |
| 7,1032,8200 | 27.49 | 33.53 | 0.817–0.822 |
| 17,1032,8200 | 35.24 | 54.98 | 0.640–0.643 |
| 31,1048,8184 | 32.30 | 55.15 | 0.582–0.586 |

Times are medians of the three verification-round medians. Ratios are FlyDSL/Torch, calculated from paired batches; below 1 is faster. Every one of the 21 paired batches for each shape was below the declared 1.05 parity limit. The slowest ratios were 0.943, 0.731, and 0.697 respectively. A performance threshold is a reporting convention, not a correctness assertion.

Each shape had a bounded 24-configuration search on training seed 13. The chosen geometry, A route, and split count were locked before the first verification on seeds 101/202/303, then rechecked on **404/505/606** with the final source/configuration table. The lesson's solution and completed practice use those locked configurations. M=17 stages A through LDS; the other two keep A in registers. Every selection uses 64-column, 32-K group tiles, two cooperating wave32s, and split-K 4. The per-group M tiles are 16, 32, and 32 respectively.

Final raw reports:

- [7×1032×8200](graph-host-7x1032x8200.json), [17×1032×8200](graph-host-17x1032x8200.json), [31×1048×8184](graph-host-31x1048x8184.json).
- Training candidates and first verification: [M=7](training-7x1032x8200.json), [M=17](training-17x1032x8200.json), [M=31](training-31x1048x8184.json).
- Timed source snapshots: [solution](solution.py.txt), [practice](practice.py.txt), [benchmark](tune.py.txt). Final reports record source hashes; training reports retain hashes from their earlier source revision.

## Timing scope

Both implementations use identical logical row-major BF16 GPU inputs and the same preallocated BF16 output. CPU FP32 arithmetic supplies an untimed independent correctness reference. Warmup excludes compilation and ordinary allocations. Each round alternates the order of seven paired batches, with ten graph replays per batch and **32 GEMMs per replay**. The synchronized host elapsed time is divided by the GEMM count. These are host-observed replay-throughput measurements.

The FlyDSL graph has 35 nodes: 32 GEMM kernels plus three one-time workspace initialization nodes. Torch has 32 kernel nodes. Scratch initialization remains included in replay timing. The capture checker changes input signs, poisons output, replays, verifies every result and output guard, then restores input and checks again. Workspace guards and counter reset also pass. The native GEMM itself includes split-K finalization and counter reset in one kernel per multiplication.

## Ordinary Python calls

The same locked configurations lose to Torch with `direct-host`, which includes public-launcher dispatch and synchronization overhead. Keep this result separate from graph throughput.

| M,N,K | FlyDSL direct μs | Torch direct μs | Paired ratio range |
| --- | ---: | ---: | ---: |
| 7,1032,8200 | 112.76 | 38.40 | 2.496–3.019 |
| 17,1032,8200 | 112.46 | 59.23 | 1.552–1.939 |
| 31,1048,8184 | 113.47 | 59.78 | 1.577–1.901 |

Raw samples: [M=7](direct-host-7x1032x8200.json), [M=17](direct-host-17x1032x8200.json), [M=31](direct-host-31x1048x8184.json).

## Fully odd dimensions

The kernel also accepts **(31,1025,8193)** and passes the reference, replay, sentinel, and workspace checks. With scalar global copies on both operands, the best of the same bounded search takes about **253–257 μs** against Torch's **55–57 μs**. The three paired round ratios are **4.568, 4.614, and 4.448**. The [full training and counterexample report](odd-shape-counterexample.json) retains all candidates and samples. This is a supported shape, with a performance cost; it is not one of the competitive vector-width examples.

The tiny `(17,65,33)` example teaches all three coordinate predicates and runs in the solution/practice. Its purpose is a hand-traceable checker. It is not included in the performance-win table.

## Reproduce

From the repository root, use a fresh output path:

```bash
pixi run python lessons/01-gpu-programming/13-matmul/13-edge-safety/solution.py
pixi run python lessons/01-gpu-programming/13-matmul/13-edge-safety/tune.py --shape 7 1032 8200 --seeds 404 505 606 --output /tmp/edge-7-graph.json
pixi run python lessons/01-gpu-programming/13-matmul/13-edge-safety/tune.py --shape 17 1032 8200 --timing direct-host --seeds 404 505 606 --output /tmp/edge-17-direct.json
pixi run python lessons/01-gpu-programming/13-matmul/13-edge-safety/tune.py --shape 31 1025 8193 --sweep --output /tmp/edge-odd-search.json
```

Use `--sweep` to repeat training; default runs verify the lesson's selected configuration. An explicit `--config` JSON object can reproduce the original geometry-training configurations; use the frozen study driver for the later width/predicate variants. Subsequent timing variation does not change correctness.

## Predicate placement

A controlled comparison holds tile geometry, waves, split count, operand route, and buffer widths fixed. It measures always-predicated copies against (a) independent full-tile guards for A/B/C and (b) the combined `full_m & full_n & full_k` input guard. Each row has three fresh seeds, nine shuffled paired batches per seed, and ten replays of 32 GEMMs per batch. The buffer cap is 128 bits; real row extents can narrow it.

| M,N,K | Per-operand edge-only / always | Combined edge-only / always |
| --- | ---: | ---: |
| 16,1024,8192 | 0.994–1.000 | 0.991–0.999 |
| 7,1032,8200 | 1.219–1.220 | 1.049–1.049 |
| 17,1032,8200 | 0.973–0.974 | 0.969–0.970 |
| 31,1048,8184 | 1.048–1.061 | 0.968–0.973 |
| 65,1032,8200 | 0.995–1.001 | 1.076–1.082 |
| 31,1025,8193 | 0.575–0.577 | 0.929–0.930 |

The simpler **always-predicated default** keeps the competitive vector examples. The full-tile branch has no consistent advantage across them: the small improvements stay inside a 5% parity band, while some variants regress. Scalar loads can benefit materially: independent operand guards reduce the fully odd case's time by about 42%. The edge-only alternative remains in the frozen study source; the public lesson omits the option.

The fully odd row here uses the generic default geometry, rather than the separately tuned geometry in the earlier counterexample table. Its absolute times are approximately 489 μs always-predicated and 281 μs with per-operand edge guards. Compare strategies within this fixed geometry; both remain slower than Torch.

Additional 32-bit and 64-bit effective-width cases show that the decision is shape-specific: `(31,1034,8202)` regresses about 6% with per-operand guards, while `(31,1036,8204)` improves about 7%.

Raw data: [per-operand guards](predicate-ablation.json), [combined guard](predicate-combined.json), [32-bit effective widths](predicate-width2.json), [64-bit effective widths](predicate-width4.json). Native study sources: [operand guards](predicate-ablation-source.py.txt), [combined guards](predicate-combined-source.py.txt); [original driver](predicate-ablation-driver.py.txt). The studies precede the explicit configurable width cap; the default cap and native predicate algorithms are the same.

## Buffer width tuning

The archived study used `Config.buffer_copy_bits` to cap **A/B global buffer loads only**, at 16/32/64/128 bits. Each operand narrows that cap to fit its real row extent. LDS publication remains `UniversalCopy128b`; MMA operand transfers remain `UniversalCopy16b`; output stores remain `BufferCopy16b`.

The following medians use always-predicated copies and identical geometry within each row. Each width has three fresh seeds (1001/1002/1003), nine paired batches, and the same graph-replay policy:

| M,N,K | 16-bit μs | 32-bit μs | 64-bit μs | 128-bit μs |
| --- | ---: | ---: | ---: | ---: |
| 7,1032,8200 | 228.87 | 41.33 | 31.82 | **27.20** |
| 17,1032,8200 | 226.88 | 46.18 | 38.92 | **35.21** |
| 31,1048,8184 | 252.04 | 42.11 | 62.74 | **32.71** |

All widths passed the independent reference, changed-input replay, output guard, and workspace checks. Width is a tuning parameter: 64 bits is not uniformly between 32 and 128 in elapsed time. The three teaching examples retain 128-bit loads. All three still beat their matched Torch graph measurements with the chosen always-predicated path.

Reports include both predicate strategies: [M=7](buffer-width-7x1032x8200.json), [M=17](buffer-width-17x1032x8200.json), [M=31](buffer-width-31x1048x8184.json). Pre-simplification study [solution](width-study-solution.py.txt), [practice](width-study-practice.py.txt), [tuner](width-study-tune.py.txt), and [comparison driver](width-study-compare_predicates.py.txt) snapshots include the configurable cap and expanded host checker. Earlier reports retain hashes from their measured revision.

The intermediate tuner offered 192 bounded geometry/operand/split/width/predicate combinations. The active tuner returns to 24 geometry/operand/split candidates; width and predicate placement are fixed. Reproduce the alternatives with the frozen study driver and its pinned native source under this directory.

```bash
pixi run python lessons/01-gpu-programming/13-matmul/13-edge-safety/results/compare_predicates.py --shape 17 1032 8200 --buffer-copy-bits 16 32 64 128 --output /tmp/buffer-width-study.json
pixi run python lessons/01-gpu-programming/13-matmul/13-edge-safety/results/compare_predicates.py --combined-bounds --output /tmp/combined-predicate-study.json
pixi run python lessons/01-gpu-programming/13-matmul/13-edge-safety/solution.py --shape 17 1032 8200
```

## Native validation

The pre-simplification source passes all **37** course solutions and extra mapping/sliced-load checks. The style suite passes **76** program structures, **37** public GPU APIs, and **78** starter/completed-practice runs. That checker contains **57** small cases; running the entire checker with each predicate strategy passes **114** cases in total. A completed practice also runs its own 32-bit, edge-only graph comparison successfully. [Validation logs and report](validation/lesson-style.json), [GPU course log](validation/gpu-check.log), [both predicate modes](validation/both-predicate-modes.log), and [lesson-12 M-tail regression](validation/lesson12-m-tails.json) retain the checks.

Pre-simplification native inspection confirms BF16 WMMA, the expected LDS allocations, agent-scope split-K ordering, and zero scratch for [128-bit vector loads](isa/vector128/summary.json), [scalar edge loads](isa/scalar16/summary.json), and [32-bit atoms with full-tile guards](isa/vector32-edge/summary.json). The last variant also contains 128-bit ISA loads: the compiler can combine adjacent unpredicated operations. The configuration selects copy-atom widths, while generated instruction widths remain a compiler result. ISA files are beside each summary.
