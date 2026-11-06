> Historical first-study results. Use [the current prefetch comparison](README.md) for the active benchmark and reproduction commands. The command examples below describe the original comparison harness.

# Measured operand paths on gfx1151

The selected kernels beat GPU Torch in **all 27 held-out graph-replay rounds** across the three declared shapes. The new mixed path gives a consistent improvement over wave specialization for **M=32**. M=16 reaches parity with that control, and the wide selector retains the existing A/B LDS path. Ordinary Python calls do not establish consistent all-round Torch wins.

Tests ran on 2026-11-06 with Radeon 8060S (`gfx1151`), FlyDSL 0.4.1, Torch 2.13.0+rocm10.0.0 and reported HIP 7.15.26333. Contiguous row-major BF16 inputs/output, FP32 accumulation, warm input buffers, preallocated output/workspace, and one native kernel per GEMM are shared contracts. Allocation, initialization and the CPU reference are outside timing. No gfx1152 execution is claimed.

## Lock the configurations before verification

| Shape M,N,K | Output tile M,N | K chunk | Compute waves | Independent groups | Split K | Unroll | A path |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 16,1024,8192 | 16,64 | 32 | 2 | 1 | 4 | 8 | Registers |
| 32,1024,8192 | 32,64 | 32 | 2 | 1 | 4 | 8 | Registers |
| 16,4096,8192 | 16,64 | 16 | 1 | 2 | 1 | 4 | LDS |

All use A cache policy 0 and B policy 2. B retains packed LDS staging in every configuration. See [selection.json](selection.json) for exact fields and the frozen native factory hash.

The [Torch profiling investigation and search](../../../../../experiments/torch-strategy/README.md) retain the actual library binaries' metadata, counter captures, unsuccessful prototypes, and explicit search lists. The mixed-path search proposed 512 measurements, measured 441 and pruned 71, with zero numerical rejections. Counts include repeated settings in separate phases. Coarse exploration uses a direct-A prototype; final refinement, focused combinations, confirmation and verification use the final lesson factory. Source archives and hashes make that distinction explicit.

Training seed 13 supplies all selection inputs. Each shape's three finalists receives full correctness/boundary checks and three shuffled confirmation rounds, seven batches with twelve replays per batch. [The complete confirmation](confirmation/selection.json) selects the smallest worst-round ratio to both independently tuned prefetch and wave specialization. Final native factory SHA-256 is `c1a259c38ffb5490e13f30b2cc541a7546a5734dc8b82c02984ef7399b34a3a3`; held-out verification checks it against every selected record.

## Fresh graph-replay verification

Three new seeds, `2026112601`, `2026112602`, and `2026112603`, each run three rounds. Each round has seven shuffled paired batches and twenty graph replays per implementation per batch. Captures contain **exactly 32 kernel nodes for 32 GEMMs**. Changed-input replay, NaN output replacement and workspace guards are checked before timing. Times use a synchronized host clock divided by the number of GEMMs; they are warm replay throughput, not isolated device-event latency.

| Shape M,N,K | Native µs | Retuned prefetch µs | Wave specialized µs | GPU Torch µs | Native/Torch paired ratio | Torch win rounds |
| --- | --- | --- | --- | --- | --- | --- |
| 16,1024,8192 | 20.28 | 21.68 | 21.01 | 34.50 | 0.5875 | 9/9 |
| 32,1024,8192 | 23.65 | 28.10 | 26.16 | 59.16 | 0.3993 | 9/9 |
| 16,4096,8192 | 273.69 | 273.66 | 272.40 | 289.75 | 0.9441 | 9/9 |

Each time is the median of round medians. Ratios are medians of within-round paired ratios, so they need not equal ratios of displayed aggregate times. A win requires **every** round's median paired ratio below 0.95; parity requires every round at or below 1.05. Worst Torch ratios are 0.5886, 0.4063 and 0.9462, respectively.

M=32 has about **9% lower time than wave specialization**, winning all nine rounds (worst ratio 0.9152). It also wins all nine against retuned prefetch and same-geometry prefetch. The latter takes 27.31 µs, with native/control median paired ratio 0.8769. That comparison keeps the 32×64×32 tile, waves, split count, unroll and B policy fixed while changing A's path.

For M=16, the new path wins all nine rounds against retuned prefetch, but meets parity against wave specialization. Its same-geometry unroll-8 prefetch control is 21.35 µs; only five of nine rounds clear the strict 5% win threshold. The wide case meets parity with both existing strategies. These results do not establish a new improvement for every shape.

Raw graph samples and capture metadata: [M=16](verification/16x1024x8192-graph-host.json), [M=32](verification/32x1024x8192-graph-host.json), [wide N](verification/16x4096x8192-graph-host.json).

## Ordinary Python dispatch

| Shape M,N,K | Native µs | GPU Torch µs | Strict Torch win rounds |
| --- | --- | --- | --- |
| 16,1024,8192 | 55.03 | 36.61 | 0/9 |
| 32,1024,8192 | 54.47 | 59.84 | 5/9 |
| 16,4096,8192 | 277.20 | 291.91 | 6/9 |

The all-round criterion is not satisfied for any of these direct-host comparisons. M=16 is slower; the other shapes have favorable median ratios but do not clear the 5% threshold consistently. This includes the native Python launcher and synchronization overhead. A graph-throughput result should not be presented as an ordinary-call latency win.

Complete direct samples: [M=16](verification/16x1024x8192-direct-host.json), [M=32](verification/32x1024x8192-direct-host.json), [wide N](verification/16x4096x8192-direct-host.json).

## Native inspection and correctness

The [inspector](../inspect_kernel.py) verifies BF16 WMMA, vector global loads, exact shared allocation, wave32 WGP mode, zero private scratch, and agent-scope split-K publication/reset ordering. Retained final ISA/LLVM dumps sit beside each [M=16](verification/inspection-16x1024x8192/summary.json), [M=32](verification/inspection-32x1024x8192/summary.json), and [wide](verification/inspection-16x4096x8192/summary.json) report. Resource counts are compiler metadata, not measured occupancy.

Both selected direct-A kernels use **4096 LDS bytes**, with 130 VGPRs for M=16 and 173 for M=32, plus 21 SGPRs and zero scratch. Their emitted LDS operand reads are 16-bit B reads; the earlier vector A LDS reads are absent. The source still supplies the staged-A alternative, but tracing selects one path for each compiled configuration.

### Isolate A's path in the profiler

Two fresh eight-pair counter captures hold M=32's tile/waves/split/unroll/cache policies fixed, changing only `left_in_registers`. Each capture independently validates native and Torch outputs. The actual Torch symbol still matches the extracted hipBLASLt solution 754.

| Per-dispatch median | A through LDS | Direct A registers |
| --- | --- | --- |
| Waves | 128 | 128 |
| LDS instructions | 638976 | 557056 |
| Global-load instructions | 49152 | 98304 |
| LDS wait counter (`SQ_WAIT_INST_LDS_sum`) | 1657750 | 343114 |
| LDS bank-conflict metric | 6.25% | 0% |
| `ALUStalledByLDS` | 57.03% | 12.18% |
| 128-byte L1→L2 read requests | 144988 | 144848 |
| External 128-byte read requests | 135241 | 135234 |

Removing A's shared path reduces LDS instructions by **12.8%**, despite doubling global-load instructions. Lower-level read traffic stays nearly unchanged. This is consistent with repeated A reads being coalesced or served by hardware caches above L2; the counters do not locate each individual hit. The result is not a reduction in required matrix arithmetic, nor proof that issuing more global instructions is generally beneficial.

The A-LDS control's K=32 padding still has conflicts, unlike the earlier K=64 wave-specialized geometry. Removing that path also removes its conflicts and many LDS waits. `ALUStalledByLDS` is a hardware metric, not a fraction of wall time. Instrumented trace medians are separate from the uninstrumented performance results above. Raw counters, metric definitions, dispatches and commands: [A in LDS](profile-A-lds/summary.json), [A in registers](profile-A-registers/summary.json).

The recorded SDK definition labels `SQ_WAIT_INST_LDS` as per-SIMD wave-cycle waits in units of four cycles and marks it nondeterministic. The summed counter is not a dispatch's elapsed cycle count.

The [validation record](verification/validation.json) covers all 33 course solutions and extra GPU checks, all nine selected shape/split combinations, the completed practice's nine combinations, ordinary solution/completed-practice CLIs, the intended unfinished-practice message, and AST equivalence between the completed practice and solution. Structured/random CPU references, three signed workspace reuses, NaN outputs, trailing sentinels and reset counters are checked. Tagged boundary lengths cover prologue, unrolled body and drain. [The native ownership trace](verification/ownership.log) checks all 14336 illustrated offsets and confirms the duplicate A owners.

[audit.json](audit.json) reconciles the search totals, archived source hashes, locked native factory, verified practice snapshots, all captured graph nodes, and the controlled A-path profiles. The archived `.txt` prototype also passes a [native replay smoke check](verification/archive-replay-smoke.json); that one-batch check is not an additional performance result or part of the search count.

## Reproduce

Run from the repository root with fresh output paths:

```bash
pixi run python lessons/01-gpu-programming/13-matmul/12-operand-paths/solution.py
pixi run python lessons/01-gpu-programming/13-matmul/12-operand-paths/solution.py --shape 16 4096 8192 --check-only
pixi run python lessons/01-gpu-programming/13-matmul/12-operand-paths/tune.py \
  --verify --shape 32 1024 8192 --output /tmp/operand-graph.json
pixi run python lessons/01-gpu-programming/13-matmul/12-operand-paths/tune.py \
  --verify --shape 32 1024 8192 --timing direct-host --output /tmp/operand-direct.json
pixi run python lessons/01-gpu-programming/13-matmul/12-operand-paths/verify.py \
  --output /tmp/operand-full-verification
pixi run python lessons/01-gpu-programming/13-matmul/12-operand-paths/profile.py \
  --left-path registers --output /tmp/operand-profile-registers
pixi run python lessons/01-gpu-programming/13-matmul/12-operand-paths/profile.py \
  --left-path lds --output /tmp/operand-profile-lds
```

Reusing the listed seeds repeats this verification. Supply a new `--seeds` set for a new held-out experiment. The verification driver checks the locked factory/configurations, saves source snapshots, runs both timing modes and native inspectors, fills a temporary practice copy, leaves the starter unfinished, and runs the complete course GPU check.
