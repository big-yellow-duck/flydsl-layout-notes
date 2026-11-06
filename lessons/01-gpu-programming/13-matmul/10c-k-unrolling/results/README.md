# Focused skinny-prefetch measurements

Lessons [10](../../10-wave-local-tiles/README.md), [10a](../../10a-synchronization-scope/README.md), [10b](../../10b-cache-policy/README.md), and [10c](../README.md) isolate four decisions from the [original combined experiment](../../../../../experiments/wave-local-prefetch/README.md). All retain BF16 row-major inputs/output, FP32 accumulation, prefetch, and the same single-kernel split-K finalizer. Lesson 10c preserves the original native builder exactly.

Tests ran on Radeon 8060S (`gfx1151`), FlyDSL 0.4.1, Torch 2.13.0+rocm10.0.0, and reported HIP 7.15.26333. Hardware validation on gfx1152 remains pending.

## Controlled wide-shape comparisons

The workload is `(16,4096,8192)`. Each wave computes a 16×64 output tile with K chunks of 16, one current LDS stage, and `split_k=1`. The selected two-wave block has disjoint per-wave regions. Change only the named feature within each paired report:

| Lesson / control | Median µs per GEMM | Selected / control paired ratio |
| --- | --- | --- |
| 10: two independent waves, full-workgroup barriers | 350.91 | 1.1962 versus one wave per block |
| 10 control: one wave per block | 293.30 | — |
| 10a: LDS ordering and subgroup execution | 288.09 | 0.8159 versus default workgroup barrier |
| 10a control: default workgroup barrier | 352.24 | — |
| 10a control: LDS-only workgroup barrier | 353.87 | 0.8131 selected / this control |
| 10b: B policy 2, rolled K loop | 280.51 | 0.9721 versus policy 0 |
| 10b control: B policy 0 | 288.27 | — |
| 10c: unroll 4 | 273.74 | 0.9736 versus unroll 1 |
| 10c control: unroll 1 | 280.57 | — |
| 10c control: unroll 2 | 277.56 | 0.9854 selected / this control |
| 10c control: unroll 8 | 278.56 | 0.9822 selected / this control |

Raw paired reports: [10](20261107-validation-v2/10-wave-local-tiles-comparison.json), [10a](20261107-validation-v2/10a-synchronization-scope-comparison.json), [10b](20261107-validation-v2/10b-cache-policy-comparison.json), [10c](20261107-validation-v2/10c-k-unrolling-comparison.json).

Independent wave grouping alone loses here because the conservative full-block rendezvous still couples the waves. The 10a comparison shows that narrowing memory ordering alone is insufficient in this capture; narrowing the execution rendezvous gives the substantial gain. This is an interaction between choices, not a promise that every individual lesson must be faster.

Policy 2 and unroll 4 then provide smaller improvements. These are **single-session controlled observations**, using seed 13, five shuffled batches and eight replays per batch. Each replay has exactly 32 kernel nodes for 32 GEMMs. Synchronized host time is divided by the number of GEMMs; it measures warm replay throughput. All variants validate trace/random products, changed-input replay, NaN output replacement, workspace reset and sentinels. Allocation and CPU reference work are outside timing.

GPU Torch measures about 290 µs in these reports. The original combined research and [lesson-12 verification](../../12-operand-paths/results/README.md) provide separate held-out studies; the small isolated gains above do not claim those studies' all-round win criteria. Compare ratios within one report, rather than subtracting timings from separate runs.

## Logical fragments and generated resources

For the same wide geometry, every unroll factor has **32 logical BF16 B staging values per thread**, **5632 LDS bytes per physical block**, and **zero scratch**. Native compiler metadata reports:

| Unroll | VGPRs | SGPRs | Static B SLC load sites |
| --- | --- | --- | --- |
| 1 | 103 | 14 | 8 |
| 2 | 125 | 15 | 16 |
| 4 | 120 | 14 | 32 |
| 8 | 105 | 16 | 64 |

Native captures: [U1](20261107-validation-v2/10c-k-unrolling-isa-unroll_1/summary.json), [U2](20261107-validation-v2/10c-k-unrolling-isa-unroll_2/summary.json), [U4](20261107-validation-v2/10c-k-unrolling-isa-selected/summary.json), [U8](20261107-validation-v2/10c-k-unrolling-isa-unroll_8/summary.json). Counts are static instruction sites, not executed requests. More expanded instructions do not imply proportionally more allocated registers. Resource metadata alone does not establish occupancy or overlapped cycles.

The [10 default](20261107-validation-v2/10-wave-local-tiles-isa-selected/summary.json) has four static workgroup barrier sites. [10a's LDS-workgroup control](20261107-validation-v2/10a-synchronization-scope-isa-lds-workgroup/summary.json) retains four and adds LDS-only ordering metadata. [10a's subgroup selection](20261107-validation-v2/10a-synchronization-scope-isa-selected/summary.json) records wavefront scope and zero workgroup barrier sites. [10b policy 0](20261107-validation-v2/10b-cache-policy-isa-B_cache_0/summary.json) has zero SLC B load sites; [policy 2](20261107-validation-v2/10b-cache-policy-isa-selected/summary.json) has eight. All captures verify BF16 WMMA, 128-bit buffer reads, wave32 WGP mode, exact LDS allocation and zero scratch.

## Correctness and practice fidelity

The [validation record](20261107-validation-v2/validation.json) and [course log](20261107-validation-v2/course-check.log) show all **35 native solutions** and extra GPU checks passing. Each of these four selected kernels and each temporary completed practice passes all nine shape/split combinations. Ordinary solution and completed-practice CLIs pass, and all four unfinished starters fail with the intended practice message. Filling only the two documented expressions makes each practice AST equivalent to its solution.

Tagged K-boundary checks cover prologue, steady state, drain, and split partials. Unrolling additionally checks local tile counts `1,2,3,U,U+1,U+2`, including the illustrated six-tile result 1008 for U4. Every wide control receives a full native correctness/ISA capture. Source snapshots and the exact completed practices are retained with the run. The four lesson figures were regenerated and visually inspected.

The 10c builder SHA-256 remains `cf53f704e9250a051af983d029c86639d242366b4c901c2404cf2ba7b06492d9`. [Archive provenance](../../../../../experiments/course-restructure.json) records the original full-file hashes. Historical raw records retain their original producer paths; the current course imports 10c directly.

Reproduce from the repository root, using a fresh directory:

```bash
pixi run python tools/validate_skinny_lessons.py --output /tmp/focused-skinny-validation
```

Use an individual lesson's `tune.py` or `inspect_kernel.py` to repeat one comparison without running the full validation sequence. Performance observations do not gate correctness.
