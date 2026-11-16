# Two-dimensional independent wave groups

The active kernels in lessons 10, 10a, 10b, 10c and 12 select an explicit physical output region, then slice it into private wave tiles. `wave_groups_m` and `wave_groups_n` each range over 1 and 2. `group_m` orders physical block rows. All waves in a block process the same K split.

The six-axis native launch layout encodes `(wave_row,wave_col,row_in_group,split_id,physical_column,m_group)`. LDS views also carry both wave axes. Cooperating `waves_m/waves_n` remain separate parameters. Lesson 12 rounds its bounded M domain to the physical block height and allocates workspace for padded wave tiles.

## Search and measurements

Measured on Radeon 8060S (`gfx1151`), FlyDSL 0.4.1, Torch 2.13.0+rocm10.1.0. Each of the five tutorials is swept on all three existing workloads. The independent-wave candidates use a common 16-row tile, one compute wave, and every shape in `(1,1),(1,2),(2,1),(2,2)`. The original selected configuration is retained as a control; K chunk, split-K, cache policy and unroll stay fixed per workload. On M=32 this changes the control's per-tile M extent from 32 to 16 for the independent sweep, making both M arrangements legal. Comparisons between the four independent arrangements hold per-wave geometry fixed; comparisons with the original control can also change cooperation and per-tile M.

Each candidate passes full structured/random CPU-reference comparison, sign-changing reuse, output/workspace sentinels and tagged pipeline-boundary checks before timing. Each seed is validated again, including captured changed-input replay and poisoned output. Timing uses seven shuffled batches and ten replays per batch; each graph has exactly 32 GEMM kernel nodes, plus explicit workspace-initialization nodes where required. Reported times divide by 32 and exclude compilation, allocation and CPU reference work.

The table gives median µs/GEMM across seed-level medians for seeds 13, 29 and 47. A dash is an explicitly rejected physical-tile shape. M=16 cannot fit two full 16-row tiles along M in lessons 10–10c. Lesson 12 permits those arrangements by bounding the extra wave rows; their extra work is measured rather than hidden.

| Lesson | M×N×K | Original control | (1,1) | (1,2) | (2,1) | (2,2) | Selected |
| --- | --- | ---: | ---: | ---: | ---: | ---: | --- |
| 10 | 16×1024×8192 | 22.75 | 23.80 | 25.01 | — | — | original (1,1) |
| 10 | 16×4096×8192 | 355.59 | 293.27 | 355.77 | — | — | independent (1,1) |
| 10 | 32×1024×8192 | 28.90 | 37.90 | 39.13 | 36.51 | 37.95 | original (1,1) |
| 10a | 16×1024×8192 | 22.52 | 23.73 | 22.26 | — | — | independent (1,2) |
| 10a | 16×4096×8192 | 295.98 | 301.28 | 295.95 | — | — | original (1,2) |
| 10a | 32×1024×8192 | 29.39 | 38.00 | 40.34 | 35.11 | 34.43 | original (1,1) |
| 10b | 16×1024×8192 | 21.59 | 23.24 | 21.48 | — | — | original (1,1) |
| 10b | 16×4096×8192 | 279.27 | 285.57 | 279.05 | — | — | original (1,2) |
| 10b | 32×1024×8192 | 28.51 | 39.13 | 40.41 | 34.64 | 35.18 | original (1,1) |
| 10c | 16×1024×8192 | 21.63 | 22.33 | 21.47 | — | — | original (1,1) |
| 10c | 16×4096×8192 | 273.35 | 286.32 | 273.97 | — | — | original (1,2) |
| 10c | 32×1024×8192 | 28.16 | 52.80 | 40.80 | 37.00 | 38.58 | original (1,1) |
| 12 | 16×1024×8192 | 20.40 | 21.59 | 21.20 | 30.61 | 31.88 | original (1,1) |
| 12 | 16×4096×8192 | 273.47 | 286.46 | 273.35 | 287.21 | 282.73 | original (1,2) |
| 12 | 32×1024×8192 | 23.12 | 36.87 | 38.98 | 31.37 | 32.33 | original (1,1) |

The selection policy retains the original control unless a candidate reduces median time by at least 1%. The fastest raw sample is recorded even when it is inside that margin. Two configurations were promoted; both were checked on held-out seeds 2026111601, 2026111602 and 2026111603. No `(2,2)` configuration wins against the existing controls on these three workloads. Full 2D support does not imply that four waves per block are faster.

## Held-out checks

| Promotion | Previous graph µs | Selected graph µs | Previous direct µs | Selected direct µs |
| --- | ---: | ---: | ---: | ---: |
| 10-wave-local-tiles [16, 4096, 8192] | 354.55 | 293.25 | 370.60 | 306.22 |
| 10a-synchronization-scope [16, 1024, 8192] | 22.29 | 22.01 | 109.45 | 107.93 |

The lesson-10 wide selector becomes `(1,1)` while its teaching walkthrough explicitly demonstrates `(1,2)` and `(2,2)`. Full-workgroup handoffs remain the lesson-10 baseline. Lesson 10a's M=16/N=1024 selector changes from two cooperating waves to two independent neighboring N tiles, with subgroup scope. Direct-host measurements of this small split-K workload vary more than graph replay; the graph-selected improvement is small and is not a universal latency claim. Other selectors retain their previous tile, cooperation, split and unroll choices, expressed with the new 2D fields.

## Artifacts and reproduction

- [Selected configurations](selected-configurations.json).
- [Full sweep reports](tuning/): all valid configurations, exclusions, correctness checkpoints, raw samples, orders, graph metadata, environment and source hashes.
- [Held-out graph results](held-out/) and [ordinary dispatch results](held-out-direct/).
- [Pre-selection source snapshots](source-snapshots/): preserve the kernels used for the initial sweep before updating selectors.
- [Repository API and practice checks](style/validation.json).
- [Native and practice validation](validation/validation.json): snapshots, completed-practice AST checks, native ISA/resources for selected controls and `(2,2)`, grouped split-K and bounded M-tail checks.

Run from the repository root with fresh output directories:

```bash
pixi run python tools/tune_wave_group_shapes.py --output /tmp/wave-group-sweep
pixi run python tools/tune_wave_group_shapes.py --verify-from /tmp/wave-group-sweep --seeds 2026111601 2026111602 2026111603 --output /tmp/wave-group-held-out
pixi run python tools/validate_skinny_lessons.py --output /tmp/wave-group-validation
pixi run python tools/check_lesson_style.py --gpu --practices --output /tmp/wave-group-style
```

The sweep reads the current selectors as its controls. To reproduce the original baseline exactly, use the pre-selection source snapshots in an isolated copy or the explicit configurations recorded in the original reports. Historical scalar `wave_groups` JSON selections can be read with `Config.from_dict`; scalar values are interpreted as N groups. Kernel launch and tuning parameters use the explicit M/N dimensions.

Validation passed all 35 native course solutions, 35 grouped launch/GEMM/workspace probes, and 48 bounded M-tail cases plus nine selected shape/split cases. Each of the five lessons also passed its selected nine shape/split checks, temporary practice completions and `(2,2)` native ISA/resource capture.

Existing learner answers in practice files are retained. Temporary completions replace the two documented expression regions and are compared to solution ASTs; unfinished exercises remain unfinished. The original combined experiment is retained as historical evidence, while active lessons use the new mapping.
