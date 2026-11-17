# Physical M grouping after wave-local tiling

`wave_groups_m` supplies locality within a physical block; `group_m` can extend
that locality across physical blocks. M packing therefore does not generally
replace grouped block traversal. If packing leaves one physical M row, however,
`group_m` is exactly redundant in this kernel.

All three current lesson-12 defaults already have one physical M row: their
compute tiles are 16 rows for M=16 and 32 rows for M=32, with `wave_groups_m=1`.
They correctly use `group_m=1` even before adding M wave packing. The M=32
experiment also tests smaller 16-row wave tiles: `(1,1)` and `(1,2)` then have
two physical M rows, whereas `(2,1)` and `(2,2)` have one.

This study uses the unchanged [lesson-12 solution](../../solution.py), with
row-major BF16 A/B/C, FP32 accumulation, prefetch, and the existing single-kernel
split-K finalizer. Measurements ran on Radeon 8060S (`gfx1151`), FlyDSL 0.4.1,
Torch 2.13.0+rocm10.1.0 and reported HIP 7.16.26385. HIP reports 2 MiB L2.
The results apply to this hardware and bounded search.

## Follow the two locality levels

Let `BM`, `BN` be a wave's output dimensions, `WM`, `WN` its independent-wave
packing, and `S` the K split count. The physical grid has

```text
Pm = ceil(M / (BM * WM))
Pn = N / (BN * WN)
G  = min(group_m, Pm)
```

With complete groups, physical block ID `p` decodes as

```text
row   = p % G + (p // (G*S*Pn)) * G
split = (p // G) % S
col   = (p // (G*S)) % Pn
```

Each block then places its own `WM*WN` waves. All its waves use the same K
split. Neighbors along M request the same B elements but stage separate copies;
neighbors along N request the same A elements. The native six-axis layout
implements this mapping without Python coordinate computation in the kernel.

For M=32, BM=16 and WM=2, Pm=1, so every positive `group_m` clamps to G=1.
For M=256 with the same BM/WM, Pm=8. G=4 brings four physical blocks at the
same B column and split to adjacent launch positions: their eight M wave tiles
cover 128 output rows. Packing has exposed two M tiles per block; traversal
still controls which of the other M blocks are nearby.

| Property | Increase `wave_groups_m` | Change `group_m` at fixed packing |
| --- | --- | --- |
| M locality opportunity | Between waves of one block | Between physical blocks |
| Threads and private LDS per block | Increase | Unchanged |
| Number of physical blocks | Decreases | Unchanged |
| Mathematical global-load requests | Same for complete tiles | Same |
| Hardware-cache hits | Depend on scheduling and cache behavior | Depend on scheduling and cache behavior |

Fixed fragment shapes do not require identical compiler register counts: changing
index arithmetic can still affect generated registers and instructions.

The unique B band for one physical N column and split has
`2*(K/S)*BN*WN` bytes, before cache-line rounding. Increasing G lets more M
tiles request this band close together; it does not remove their load
instructions or guarantee those requests reach L2. The whole B matrix is
`2*K*N` bytes. With G=1, a physical M row traverses the N columns before the
next M row. A large B matrix can displace data before the next row requests it.
Larger G also changes A locality and can hurt performance.

The B-band size counts unique data over the complete reduction, rather than
the simultaneously resident working set. Waves stream K chunks through the
pipeline. Concurrent blocks, their progress through K, A/output traffic and
cache policy all affect residency; fitting the whole band in L2 is neither
a necessary condition nor a sufficient guarantee of reuse.

The exact no-op case Pm=1 follows from constant folding in the mapping, without
a timing experiment. Another degenerate case is Pn*S=1: all blocks are in one
column and split, so changing a valid G also preserves their row order. A
negligible timing change on a larger grid is an empirical outcome, rather than
proof that two parameters encode the same mapping.

This reasoning follows the grouped-launch cache-locality mechanism described in
[Triton's matrix multiplication tutorial](https://triton-lang.org/main/getting-started/tutorials/03-matrix-multiplication.html#l2-cache-optimizations).
[AMD's HIP hardware guide](https://rocmdocs.amd.com/projects/HIP/en/develop/understand/hardware_implementation.html)
describes L2 as shared across WGPs. Neither source promises cache residency from
launch adjacency. Counter collection below checks the actual traffic separately.

## Search and verification

The benchmark includes these `(M,N,K)` shapes:

| Workload | Shapes | B size |
| --- | --- | --- |
| Skinny course selectors | 16×1024×8192; 32×1024×8192; 16×4096×8192 | 16; 16; 64 MiB |
| Square GEMMs | 1024³; 2048³; 4096³ | 2; 8; 32 MiB |
| Wide rectangular | 512×2048×1024 | 4 MiB |
| Tall rectangular | 2048×512×1024 | 1 MiB |
| Long-K rectangular | 256×4096×8192 | 64 MiB |

Each shape tests independent-wave packings `(1,1)`, `(1,2)`, `(2,1)`, `(2,2)`.
Lesson 12 permits padded M bounds, so M=16 with two 16-row wave tiles along M
includes an inactive output wave row. These cases are controls, rather than
recommendations to add padding work to the skinny selectors.
For the skinny cases, the initial per-wave tile is 16×64 with K chunks
16/32/64 and both A routes, retaining the course selector's split, unroll and
B policy initially. Larger shapes start from five `(BM,BN,BK,unroll)` templates:
`(16,64,16,4)`, `(16,64,32,4)`, `(32,64,32,2)`, `(32,64,64,2)`,
`(32,128,32,2)`, each with B cache modifier 0/2, A in registers and S=1.

For every packing, both G=1 and G=min(4,Pm) are evaluated. Each branch's fastest
training candidate is refined over unroll 1/2/4/8, splits 1/2/4, and the other
A route. The fastest candidate in each branch then receives a fixed-geometry
group_m sweep over distinct effective values from 1/2/4/8. Invalid copy, LDS
or incomplete-group configurations are recorded as exclusions. This is a
bounded sequential refinement, not an exhaustive Cartesian search.

Selection uses only seed 13, three batches and three graph replays per batch.
For each packing, the fastest measured G=1 and G>1 configurations are locked.
Both also receive matched controls using the other branch's group size while
retaining their own geometry. This tests both practical retuning and the causal
effect of changing traversal alone. Existing cooperating course selections and
the prior 1024³/2048³ cooperating selections are included as controls; the
search does not claim independent waves are always the best GEMM strategy.

Held-out seeds 29/47/71 each use seven shuffled measurement batches and ten
repetitions per batch. Graph replay captures 32 GEMMs; synchronized host elapsed
time is divided by 32. Ordinary Python launches are measured separately.
Buffers are reused and warmed, with preallocated outputs and workspace.
Compilation, allocation, correctness checking and CPU reference computation
are outside timed regions. These are warm-workload measurements, without an
explicit cache flush or a claim of cold-DRAM latency.

Every training configuration passes full-output random validation against CPU
FP32 arithmetic on the BF16 inputs, rounded to BF16. Every locked configuration
also passes the lesson's structured/random, changed-sign workspace reuse,
NaN-output, sentinel, counter-reset and tagged K-boundary checker. Graph capture
checks node counts and changed-input replay, including graph-owned split-K
workspace. Fresh inputs are validated before each held-out seed's timings.

## Measured effect after M wave packing

The run evaluated **1015 distinct training configurations**, checked **92 locked
shape/configuration pairs**, and completed **54 held-out seed/timing runs**.
The [full tables](summary/tables.md) include all four independent-wave layouts,
ordinary calls, seed ranges and cooperating controls. The
[machine-readable comparisons](summary/comparisons.json) retain both matched
geometries. Positive percentages below mean less elapsed time with grouping.

| M,N,K | Change only group_m, packing (2,1) | Change only group_m, packing (2,2) | Retune both branches, packing (2,2) |
| --- | ---: | ---: | ---: |
| 16,1024,8192 | Exact no-op | Exact no-op | Exact no-op |
| 32,1024,8192 | Exact no-op | Exact no-op | Exact no-op |
| 16,4096,8192 | Exact no-op | Exact no-op | Exact no-op |
| 1024,1024,1024 | +1.4% | **+12.0%** | +9.2% |
| 2048,2048,2048 | +9.6% | **+9.6%** | +4.5% |
| 4096,4096,4096 | −0.3% | +0.4% | +0.4% |
| 512,2048,1024 | **+30.3%** | **+33.2%** | +30.4% |
| 2048,512,1024 | +0.2% | −0.1% | −0.1% |
| 256,4096,8192 | −0.1% | **+23.9%** | +23.0% |

These are graph-host results, summarized as the median of three seed-level
median paired time ratios. The matched columns use the tuned grouped geometry
and change only `group_m`; the retuned column compares separately selected
geometries. The full tables' displayed absolute times summarize each tuned
branch, so their ratio need not equal a matched percentage.

![Horizontal bars compare fixed-geometry and separately tuned group_m effects for M-packed wave layouts across all nine shapes. Skinny shapes have one physical M row; wide and long-K rectangles show substantial gains, while 4096 cubed and the tall rectangle remain near parity.](../../../../../../assets/01-gpu-programming/13-matmul/12-operand-paths/group-m-comparison.svg)

Read the left panel for a traversal-only change and the right panel for the
practical tuning comparison. Whiskers show the three seed-level extremes,
rather than confidence intervals. In the `(2,2)` matched comparisons, the seed
ranges are 11.6–12.7% for 1024³ and 32.0–33.5% for the wide rectangle; exact
ranges for every case are in the full tables.

The larger square and tall rectangle do not justify grouping on elapsed time.
The wide rectangle and long-K `(2,2)` layout do. The long-K `(2,1)` layout stays
at parity even though `(2,2)` benefits substantially: M packing alone does not
determine the remaining traversal benefit. The 2048³ retuned gain is modest
and below the course's 5% win threshold, despite its larger matched gain.

For M=32 with 16-row tiles and N-only `(1,2)` packing, two physical M rows
remain. Grouping reduces matched graph time by 6.4%; changing to M packing
collapses those rows and makes `group_m` an exact no-op. The original
cooperating-wave default remains faster than those independent-wave choices.
The prior cooperating square controls also remain competitive or faster;
this study does not select independent waves as a universal GEMM strategy.

### Load the tuned configurations

The [locked configurations](summary/locked-configurations.json) contain every
shape, wave layout and matched control. For `(2,2)` packing, the selected
grouped configurations on the larger shapes are:

| M,N,K | Per-wave M,N,K | group_m | K unroll | B cache modifier |
| --- | --- | ---: | ---: | ---: |
| 1024,1024,1024 | 32,64,32 | 8 | 4 | 0 |
| 2048,2048,2048 | 32,64,32 | 2 | 4 | 0 |
| 4096,4096,4096 | 32,64,32 | 2 | 2 | 2 |
| 512,2048,1024 | 32,64,32 | 4 | 4 | 0 |
| 2048,512,1024 | 16,64,32 | 2 | 4 | 0 |
| 256,4096,8192 | 32,64,32 | 4 | 8 | 0 |

All six use one compute wave per tile, A in registers, split_k=1, and A cache
modifier 0. The parity cases above illustrate why a training winner alone does
not justify promoting grouping. No course defaults are changed. Load a saved
choice using `Config.from_dict(selections[shape_key]["2x2"]["tuned_grouped"])`
and pass it to `matmul_bf16(..., config=choice)`.

### Inspect the cache traffic separately

Cache profiles compare the grouped geometry at G=1 and its selected G>1.
Each configuration gets separate trace, L1, L2 and external-read passes, with
20 warmups followed by eight alternating native/Torch dispatch pairs.
Full CPU-reference, sentinel and workspace validation passes before and after
each collection. Counter/trace timings are instrumented; the elapsed-time
conclusions above use the separate uninstrumented benchmark.

The counters aggregate the whole kernel, including A, B and output traffic.
They cannot identify B hits separately. L2 hit fraction is computed from the
median `GL2C_HIT_sum` and `GL2C_MISS_sum` counts. External read requests use
`GL2C_MC_RDREQ_sum`; these counts are not converted into DRAM bytes or bandwidth.

| M,N,K | G | L1 misses, thousands | L2 lookups, thousands | L2 hit fraction | External read requests, thousands |
| --- | ---: | ---: | ---: | ---: | ---: |
| 1024,1024,1024 | 1 | 531.7 | 526.4 | 86.1% | 55.2 |
| 1024,1024,1024 | 8 | 436.7 | 436.5 | 79.7% | 72.1 |
| 512,2048,1024 | 1 | 623.4 | 629.2 | 88.0% | 59.5 |
| 512,2048,1024 | 4 | 431.6 | 439.3 | 86.2% | 44.0 |
| 256,4096,8192 | 1 | 5747.8 | 5847.9 | 43.7% | 3355.0 |
| 256,4096,8192 | 4 | 4692.4 | 4251.6 | 65.7% | 1648.6 |
| 4096,4096,4096 | 1 | 49572.1 | 49270.5 | 33.6% | 32413.6 |
| 4096,4096,4096 | 2 | 51452.9 | 51677.9 | 40.1% | 30791.9 |

The long-K case supports an L2 reuse benefit: its hit fraction increases by
22 percentage points and external read requests fall 50.9%. The wide rectangle
has 30.8% fewer L1 misses and 26.1% fewer external reads, despite a slightly
lower L2 hit fraction. The number of requests reaching each level matters as
well as the fraction that hits there.

The 1024³ result also prevents attributing every gain to L2: L1 misses fall
17.9%, while L2 hit fraction falls and external requests increase 30.7%.
Conversely, 4096³ improves its L2 hit fraction and reduces external requests
5.0%, but L1 misses rise and uninstrumented elapsed time stays at parity.
These aggregate measurements establish a change in cache traffic; they do
not isolate one operand or prove that one cache metric causes the time change.

Each matched pair has the same reported VGPR count, zero scratch, 16 KiB LDS,
128 threads per block and the same grid size. VGPR counts are 216 for 1024³
and the wide rectangle, 224 for long K, and 208 for 4096³. There is no measured
register-allocation change in these pairs.

All **32 profiling passes** passed validation. Raw counters, per-dispatch
resources, commands and environment metadata are retained for
[1024³](profile-1024x1024x1024/summary.json),
[the wide rectangle](profile-512x2048x1024/summary.json),
[long K](profile-256x4096x8192/summary.json), and
[4096³](profile-4096x4096x4096/summary.json). The
[full course GPU check](gpu-check.log) also passes all 35 native solutions and
the additional mapping and sliced-load checks.

## Recommendation

Use `group_m=1` and skip its tuning when there is one physical M row. For a
multi-row grid, keep it tunable alongside both wave-group dimensions. A short
matched sweep identifies whether it still helps that particular configuration;
separate retuning checks whether the improvement survives a stronger G=1
baseline. Neither M wave packing nor the whole-matrix size guarantees a
particular L2 hit rate.

## Reproduce

Run from the repository root using fresh output directories:

```bash
pixi run python tools/benchmark_group_m.py --output /tmp/group-m-benchmark
pixi run python tools/summarize_group_m.py \
  --benchmark-directory /tmp/group-m-benchmark --output /tmp/group-m-summary
pixi run python tools/profile_group_m.py \
  --benchmark-report /tmp/group-m-benchmark/512x2048x1024.json \
  --layouts 2x2 --output /tmp/group-m-profile
pixi run uv run --no-project --with matplotlib==3.11.2 python tools/plot_group_m.py \
  --comparisons /tmp/group-m-summary/comparisons.json \
  --output /tmp/group-m-comparison
```

Use repeated `--shape M N K` to select a subset. To repeat the locked choices
on different seeds without tuning again:

```bash
pixi run python tools/benchmark_group_m.py \
  --verify-from /tmp/group-m-benchmark --seeds 101 131 173 \
  --output /tmp/group-m-confirmation
```

The tool verifies source hashes before reusing selections. Per-shape JSON
reports contain full configurations, physical geometry, exclusions, every
training sample, held-out samples and measurement orders. Source snapshots
and environment metadata are retained with the reports. No lesson defaults or
learner exercises are changed by this study.

The [validation summary](validation-summary.json) records checks and counts.
A separate [seed-101 reload smoke check](reload-check.json) verifies loading
the locked M=16/N=1024/K=8192 selections in both timing modes. Its single
batch/repetition is excluded from the performance summaries above.
