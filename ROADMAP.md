# Learning roadmap

The course now has two sections. Work through each lesson's README and practice kernel, then compare the native FlyDSL solution. The foundational examples prioritize tracing ownership and memory access. The BF16 matmul series applies those ideas to a fixed 1024×1024×1024 comparison, then extends the strategy to declared skinny workloads.

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
- [13-matmul](lessons/01-gpu-programming/13-matmul/README.md): BF16 GPU optimization, eighteen stages complete through 12, including the 07a buffer-access, 07b operand-staging, and 07c grouped-traversal bridges

All 35 native programs (13 foundational lessons, four focused divide tutorials, eighteen completed matmul stages) compile and run on gfx1151 with the pinned FlyDSL 0.4.1 / ROCm environment. Run `pixi run lessons-check`, or `pixi run gpu-check` to include the extra layout and sliced-view checks. Lesson 12 runs a small copy benchmark; individual matmul files print local timing comparisons, and `pixi run matmul-bench` compares the twelve 1024³ kernels. Results are observations, not pass/fail performance thresholds.

The vector-add lesson uses per-value guarded scalar accesses for both full tiles and tails. The full-tile fragment lesson separately teaches tiled copies. A full-block vectorized path plus a guarded tail path is a useful next optimization, not a prerequisite for correctness.

## 13 · BF16 matmul: complete through operand paths

Stages 00–08 and their GPU PyTorch baseline use **M=N=K=1024**; stages 09–12 target three declared skinny K=8192 workloads. All use contiguous BF16 input/output and FP32 accumulation. Diagrams zoom into tiles of the full workload. Each stage includes its README, reproducible SVG/PNG diagram, `practice.py`, and `solution.py`.

| Stage | Learning goal | Status |
| --- | --- | --- |
| [00 · Naive](lessons/01-gpu-programming/13-matmul/00-naive/README.md) | Native block/thread views, row/column dot products, and FP32 accumulation | Complete; gfx1151 checked |
| [01 · Contiguous K access](lessons/01-gpu-programming/13-matmul/01-coalesced-access/README.md) | Column-major B gives both per-thread K views stride 1 | Complete; gfx1151 checked |
| [02 · Register tiling](lessons/01-gpu-programming/13-matmul/02-register-tiling/README.md) | Four outputs per thread and B reuse | Complete; gfx1151 checked |
| [03 · Shared memory](lessons/01-gpu-programming/13-matmul/03-shared-memory/README.md) | Cooperative LDS staging and two synchronization points | Complete; gfx1151 checked |
| [04 · Vectorized copies](lessons/01-gpu-programming/13-matmul/04-vectorized-copy/README.md) | UniversalCopy128b staging and 4×4 register tiles | Complete; gfx1151 checked |
| [05 · Matrix instructions](lessons/01-gpu-programming/13-matmul/05-matrix-instructions/README.md) | Four-wave `(2,2,1)` BF16 WMMA tiling and FP32 fragments | Complete; gfx1151 checked |
| [06 · LDS bank conflicts](lessons/01-gpu-programming/13-matmul/06-lds-swizzle/README.md) | Native swizzling and padding; raw counter, ISA, and timing evidence | Complete; gfx1151 checked |
| [07 · Interleaved loads](lessons/01-gpu-programming/13-matmul/07-interleaved-loads/README.md) | Prefetch into registers while computing from one current LDS tile; verify instruction order | Complete; gfx1151 checked |
| [07a · Buffer access](lessons/01-gpu-programming/13-matmul/07a-buffer-access/README.md) | Buffer global transfers with the shared staging plan at fixed 64×64×64 | Complete; gfx1151 checked |
| [07b · Operand staging](lessons/01-gpu-programming/13-matmul/07b-operand-staging/README.md) | Separate A/B staging plans derived from contiguous K/N | Complete; gfx1151 checked |
| [07c · Grouped traversal](lessons/01-gpu-programming/13-matmul/07c-grouped-traversal/README.md) | Remap block IDs into two-row groups to encourage B cache reuse at fixed 64×64×64 | Complete; gfx1151 checked |
| [08 · Parameter tuning](lessons/01-gpu-programming/13-matmul/08-parameter-tuning/README.md) | Larger register tiles, bounded sweep, matched graph capture, and held-out PyTorch comparison | Complete; gfx1151 checked; revised kernel wins 18 direct rounds and meets graph parity |
| [09 · Skinny split-K](lessons/01-gpu-programming/13-matmul/09-split-k/README.md) | Split K across blocks and finalize FP32 partials in one kernel, with reusable workspace | Complete; gfx1151 checked |
| [10 · Independent wave tiles](lessons/01-gpu-programming/13-matmul/10-wave-local-tiles/README.md) | Map physical waves to disjoint logical output tiles and LDS regions | Complete; gfx1151 checked |
| [10a · Synchronization scope](lessons/01-gpu-programming/13-matmul/10a-synchronization-scope/README.md) | Separate memory address spaces from participating threads | Complete; gfx1151 checked |
| [10b · B cache policy](lessons/01-gpu-programming/13-matmul/10b-cache-policy/README.md) | Compare cache-policy hints with addresses and ownership fixed | Complete; gfx1151 checked |
| [10c · K-loop unrolling](lessons/01-gpu-programming/13-matmul/10c-k-unrolling/README.md) | Group steady steps, cover tails, and measure physical registers | Complete; gfx1151 checked |
| [12 · Operand paths](lessons/01-gpu-programming/13-matmul/12-operand-paths/README.md) | Profile Torch; compare direct A registers against tuned prefetch while preserving coalesced B staging | Complete; gfx1151 checked; M=32 wins 9/9 graph rounds versus tuned prefetch |

The course-wide `pixi run gpu-check` runs matmul correctness only. Individual matmul solutions and completed practices print their own GPU PyTorch timing/TFLOP/s comparison after checking correctness; `--check-only` skips it. `pixi run matmul-bench` compares the twelve 1024³ stages; 09–12 have dedicated skinny benchmarks. The baseline is GPU `torch.matmul` on the same BF16 buffers with a preallocated GPU output. Stage 01 uses column-major B; other stages use row-major B. Full-series results are grouped by B layout and include a matching PyTorch baseline for each. Packing is outside timing. Default automatic timing retimes all compared implementations with synchronized host batches if any event duration is unavailable; the actual method is printed. Explicit event-only and host modes are also available. Host timing still runs GPU computation and includes dispatch/synchronization overhead. The [skinny-shape investigation](experiments/torch-strategy/README.md) identifies hipBLASLt for those calls; it does not identify the fixed 1024³ call's selected solution. The new lessons have not yet been hardware-validated on gfx1152.

Stages 01–07 use the same named native-view path as the naive lesson. Register tiling selects 4×1 per-thread output windows with `flat_divide`; the standard LDS kernel selects 16-wide K windows and WMMA selects 32-wide K windows; vectorized-copy stage 04 uses 64-wide windows and 4×4 thread output tiles. Stage 05 inherits its 128-bit staging pipeline with a 128-thread staging plan and a `(2,2,1)` four-wave MMA layout. Global block views retain row stride 1024, while packed LDS views use their local row width. The READMEs trace those domains and distinguish staging ownership from compute/WMMA ownership.

Stage 06 holds the stage-05 block and MMA ownership fixed while comparing packed, native-swizzled, and padded A LDS placement. Its reproducible rocprofv3 capture checks conflict numerator/denominator, generated instructions, and separately measured time. Padding was the stronger measured candidate on gfx1151; the default swizzle demonstrates conflict reduction without assuming a speedup.

Stage 07 retains the padded layout and one LDS tile per operand, then prefetches the next global tile into private registers before current-tile WMMA. Its captured ISA places the VMEM wait after both WMMA updates; separate host captures observed about 8% lower time than the matched serial padded schedule. One-/two-/three-tile checks exercise prologue, handoff, and drain. This verifies a latency-hiding opportunity, not a cycle-level overlap measurement.

## Matmul continuation (planned)

1. **13 · Deeper software pipelines:** build on stage 12's all-wave prefetch, investigate earlier operand loads and finer operand-load/WMMA interleaving, and measure whether deeper queues repay their resource cost. Retain the fixed 1024³ reference and verify generated instructions before claiming overlap.
2. **14 · Shape and resource tuning:** extend the matmul families to other shapes, strides, and tails with explicit handling and full correctness coverage. Revisit register pressure, LDS layouts, and wave ownership for each declared workload; retain the fixed 1024³ reference.
3. **15 · Library challenge:** extend the skinny hipBLASLt investigation to the fixed 1024³ workload, match arithmetic and measurement policies, collect repeatable results, and investigate whether a specialized kernel can win for 1024³ on the named GPU. A win is a measured target, not a promised lesson outcome.

Reliable timing is required before a performance claim. The gfx1151 setup currently reports zero GPU event durations; synchronized host timing is labeled separately. Preserve the fixed shape, BF16 contract, preallocated outputs, and independent correctness reference across comparisons.

The [HipKittens four-wave investigation](experiments/hipkittens-four-wave/README.md) tests all-wave loading/compute with fine instruction interleaving on the declared skinny shapes. Its 396 measured configurations and ablations lead to prefetch parity in fresh verification, so it remains an experiment. The following [Torch profiling study](experiments/torch-strategy/README.md) motivates stage 12's operand paths.

## Further study

Asynchronous copies, reductions, dynamic shapes, general strided tilers, and broader occupancy/register-pressure tuning remain beyond the completed sequence. Extend the correctness checks before tuning a new access pattern.

Stage 08 now also has a separately locked `(M,N,K)=(1024,4096,2048)` configuration with `group_m=2`. It passed all 18 direct-launch held-out win rounds against GPU Torch; graph replay met parity. This extends aligned per-shape tuning without adding general tails or changing the standard 1024³ benchmark. See the [rectangular workload measurements](lessons/01-gpu-programming/13-matmul/08-parameter-tuning/README.md#select-a-configuration-for-a-rectangular-workload).

The main skinny path is **09 → 10 → 10a → 10b → 10c → 12**. [Wave specialization and semaphore handoffs](experiments/wave-specialization/README.md) are archived research. [Lesson 12](lessons/01-gpu-programming/13-matmul/12-operand-paths/README.md#why-the-course-keeps-prefetch) explains their measured tradeoffs and why ordinary prefetch remains the course strategy. Global split-K arrival counters remain part of the single-kernel finalizer.
