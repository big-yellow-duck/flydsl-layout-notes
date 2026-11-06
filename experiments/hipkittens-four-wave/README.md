# Test HipKittens' four-wave interleave pattern on skinny GEMM

The gfx1151 adaptation works, but **does not establish a speedup over tuned prefetch** on any of the three declared workloads. A bounded search measured 396 configurations and ablations, followed by longer training confirmation and fresh-seed verification. The course's lesson-10/11 defaults are unchanged; this remains an experiment rather than a new completed optimization lesson.

## What the pattern means

HipKittens' [four-wave interleave pattern](https://arxiv.org/html/2511.08083v1#S3.SS3.SSS2) makes every wave issue both memory and matrix instructions, using small tiles and carefully staggered operations. Its CDNA implementation places one wave per SIMD. The inspected [four-wave FP8 kernel](https://github.com/HazyResearch/HipKittens/blob/8cde3dd146bd1c4be78023b582c1f4375c48489f/kernels/cdna4/gemm/fp8fp32/FP8_4wave/4_wave.cu) and [memory helpers](https://github.com/HazyResearch/HipKittens/blob/8cde3dd146bd1c4be78023b582c1f4375c48489f/kernels/cdna4/gemm/fp8fp32/FP8_4wave/utils.cpp) interleave individual MFMA, direct global-to-LDS loads, and LDS reads, with compiler scheduling fences.

Our target is Radeon 8060S (`gfx1151`, RDNA3.5), using BF16 wave32 WMMA. Four waves mean **128 threads** here. AMD documents the [gfx115x WGP hierarchy](https://rocm.docs.amd.com/projects/rocprofiler-compute/en/docs-10.0.0/conceptual/rdna/wgp.html) separately from CDNA; an identical mapping or speedup cannot be inferred from the paper. Native inspection confirms wave32 WGP mode, without claiming measured per-SIMD placement or occupancy.

Installed FlyDSL 0.4.1 explicitly rejects `BufferCopyLDS` / `raw_ptr_buffer_load_lds` on gfx11. Therefore this prototype uses global→private registers→LDS, with existing gfx11 WMMA layouts, rather than reproducing the CDNA DMA path. It does not use CDNA MFMA, AGPR pinning, or XCD swizzling. [research.json](research.json) records the upstream commit/blob hashes, authoritative links, and the installed DMA guard's source hash. This experiment evaluates an adaptation of the scheduling idea, not the original HipKittens binary on supported Instinct hardware.

## How the adaptation works

[kernel.py](kernel.py) starts from lesson 10's native view/ownership path and retains contiguous row-major BF16 inputs/output, FP32 accumulation, one LDS tile per operand per compute group, and the single-kernel split-K finalizer. All waves load and compute. Native copy plans select the widest complete vector supported by their domain: eight, four, two, or one BF16 values.

The `interleave` schedule slices operand and accumulator fragments down to one 16×16×16 WMMA atom. It loads each A/B operand fragment once per K slice and preserves reuse across M/N repetitions. Two global-issue variants were tested:

| Variant | Next-tile global loads | Current-tile LDS reads and compute |
| --- | --- | --- |
| `spread` | Divide complete input-copy vectors among groups of 1/2/4 WMMA atoms | Load small operand fragments and issue individual WMMA atoms |
| `front` | Issue all next-tile loads before current computation | Keep the same fine operand-read/WMMA sequence |
| `bulk` control | Issue all next-tile loads first | Original whole-fragment copies and bulk `fx.gemm` |

`compiler_fence=True` inserts `fx.rocdl.sched_barrier(0)` around instruction clusters. LLVM defines this as an [instruction-scheduling constraint](https://llvm.org/docs/AMDGPUUsage.html); it is distinct from an execution barrier between waves. LDS reuse still uses the supplied subgroup/workgroup barriers. Cooperative waves share one tile and use workgroup scope; independent single-wave groups own disjoint LDS regions and use subgroup scope.

The front variant tests whether spreading global reads too late loses their latency-hiding window. All three final configurations select front-loaded global reads. Two also select no explicit compiler scheduling fences, leaving the backend free to schedule their small native operations.

## Search and controls

Tests ran on 2026-11-06 with Radeon 8060S, FlyDSL 0.4.1, PyTorch 2.13.0+rocm10.0.0 and reported HIP 7.15.26333. All tensors and timed arithmetic are on the GPU; CPU FP32 arithmetic on the actual BF16 inputs supplies the untimed reference. No gfx1152 execution is claimed.

| Phase | Proposed | Measured | Invalid/pruned | Numerical rejections |
| --- | --- | --- | --- | --- |
| Four-wave coarse grids | 324 | 198 | 126 | 0 |
| Local refinement and two-wave ablations | 162 | 134 | 28 | 0 |
| Front-issue ablations | 64 | 64 | 0 | 0 |
| Total | **550** | **396** | **154** | **0** |

The measured set contains 362 four-wave configurations and 34 two-wave ablations. The two preliminary pilot measurements are retained separately and excluded from these totals. This is a bounded search, not an exhaustive global optimum.

Coarse grids use BM=M, BN=32/64/128/256, BK=16/32/64, split counts 1/2/4, and four physical waves arranged as cooperative 1×4 or 2×2 groups, or four independent waves. Refinement changes one coordinate around leaders: BM=16/32 where legal, BN through 256, BK through 128, cache modifier 0/2, unroll 1/2/4/8, issue group 1/2/4, compiler fences on/off, and two-wave ablations. Front-issue tests revisit leading geometries with fences on/off, including the previously tuned prefetch geometry. Full tiles, complete copy/WMMA geometry, and the 64-KiB LDS bound are required.

Every measured configuration also times a **same-geometry bulk-prefetch control**. Separate controls include lesson 11's independently retuned lesson-10 prefetch configuration, GPU Torch, and, during verification, lesson 11's wave-specialized winner. Leading bulk geometries are separately reconfirmed rather than assuming the same-geometry control is the best prefetch option.

Training uses seed 13. [confirm.py](confirm.py) rotates finalists over three longer rounds, seven shuffled timing batches and ten graph replays per batch. It minimizes the worst round ratio to both independently tuned controls. The [locked selection](results/selection.json) is made before held-out seeds. All three independently confirmed bulk controls retain the existing tuned prefetch geometries.

## Fresh verification

Seeds **2026112201–2026112203** each contribute three rounds per shape. Each round contains seven shuffled batches, with 20 graph replays per implementation per batch. Every graph has exactly **32 kernel nodes for 32 GEMMs**, including split-K finalization. Times below are medians of nine round medians, measured with synchronized host graph-replay batches, warm inputs and preallocated output/workspace.

| Shape (M,N,K) | Four-wave adaptation, µs | Tuned prefetch, µs | Lesson-11 wave specialization, µs | GPU Torch, µs |
| --- | --- | --- | --- | --- |
| [16,1024,8192](results/20261106/verification/16x1024x8192-graph-host.json) | 21.528 | 21.608 | 21.079 | 34.499 |
| [32,1024,8192](results/20261106/verification/32x1024x8192-graph-host.json) | 28.076 | 28.031 | 25.903 | 59.199 |
| [16,4096,8192](results/20261106/verification/16x4096x8192-graph-host.json) | 274.118 | 273.879 | 272.181 | 290.165 |

All three reach **parity with tuned prefetch**. A win requires every round's median paired candidate/reference ratio below 0.95; parity requires all at or below 1.05 when that win criterion fails. The M=32 adaptation is slower than lesson 11's wave-specialized kernel. All 27 primary graph rounds still meet the Torch win criterion, which the existing kernels already achieved.

Ordinary direct-host calls also reach prefetch parity: **53.277 / 53.120 µs**, **53.690 / 53.346 µs**, and **275.656 / 275.498 µs** for candidate / tuned prefetch in shape order. Those samples include Python dispatch. They do not establish an additional prefetch speedup either. Full samples, paired ratios, execution orders, metadata, and failures of performance thresholds are retained in [verification](results/20261106/verification/).

## What native inspection establishes

| Selected configuration | Geometry and grouping | LDS bytes | Compiler VGPRs | Scratch bytes |
| --- | --- | --- | --- | --- |
| M=16, N=1024 | 16×128×64; cooperative 1×4 waves; split 4; fences on | 18688 | 80 | 0 |
| M=32, N=1024 | 32×128×128; cooperative 1×4 waves; split 4; fences off | 41472 | 252 | 0 |
| M=16, N=4096 | 16×64×16 per wave; four independent waves; split 1; unroll 4; fences off | 11264 | 120 | 0 |

The [M=16 inspection](results/20261106/verification/inspection-16x1024x8192/summary.json) retains 32 static compiler-scheduling-fence calls. Its [same-geometry bulk control](results/20261106/verification/inspection-bulk-16x1024x8192/summary.json) uses 161 compiler VGPRs, compared with 80 for fine interleaving. That reduction does not translate into a reliable overall win against independently tuned prefetch.

The [M=32 selection](results/20261106/verification/inspection-32x1024x8192/summary.json) and its [matched bulk control](results/20261106/verification/inspection-bulk-32x1024x8192/summary.json) both use 252 VGPRs. The [wide selection](results/20261106/verification/inspection-16x4096x8192/summary.json) has no workgroup rendezvous, consistent with its independent single-wave groups. LLVM/ISA dumps verify BF16 WMMA, buffer loads, wave32 WGP mode, and unchanged agent-scope split-K publication/reset. These static observations do not measure occupancy or cycle-level overlap, and this study adds no new profiler-counter attribution.

The complete checker passes all [nine shape/split combinations](results/20261106/verification/all-shape-split-checks.log), trace/random CPU references, signed-input workspace reuse, NaN output replacement, sentinels/reset counters, and tagged K-boundary partial planes. Every captured implementation passes mutated-input replay and graph-node checks. The [ordinary kernel CLI](results/20261106/verification/ordinary-cli.log) also passes.

## Reproduce

Run from the repository root, choosing fresh output paths:

```bash
pixi run python experiments/hipkittens-four-wave/kernel.py --check-only
pixi run python experiments/hipkittens-four-wave/benchmark.py \
  --sweep --shape 32 1024 8192 --output /tmp/hk-four-wave-coarse.json
pixi run python experiments/hipkittens-four-wave/benchmark.py \
  --sweep --shape 32 1024 8192 --refine /tmp/hk-four-wave-coarse.json \
  --output /tmp/hk-four-wave-refine.json
pixi run python experiments/hipkittens-four-wave/benchmark.py \
  --verify --shape 32 1024 8192 --output /tmp/hk-four-wave-graph.json
pixi run python experiments/hipkittens-four-wave/benchmark.py \
  --verify --shape 32 1024 8192 --timing direct-host \
  --output /tmp/hk-four-wave-direct.json
```

`--configs` takes an explicit JSON list, including the retained `front-configs-*.json` lists. `--config` and `--bulk-config` take explicit locked JSON objects. Without overrides, verification uses the locked configurations in this directory. [verify.py](verify.py) reproduces all held-out comparisons, native inspections, nine-case checks, and the ordinary CLI:

```bash
pixi run python experiments/hipkittens-four-wave/verify.py \
  --confirmation experiments/hipkittens-four-wave/results/20261106/confirmation \
  --output /tmp/hk-four-wave-recheck
```

Reusing the seeds repeats this verification; it is not a new held-out experiment. Source snapshots are retained for the initial spread-only factory, final combined front/spread factory, confirmation, and verification. `benchmark.py --module PATH` can replay an archived native source text file. The finalist factory was reconfirmed before verification; host default changes do not change its native builder hash. The [audit](results/audit.json) reconciles counts and checks final factory hashes against all held-out reports.

[Previous experiment: dedicated loader waves](../wave-specialization/README.md) · [Matmul series](../../lessons/01-gpu-programming/13-matmul/README.md)
