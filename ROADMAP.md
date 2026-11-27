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
- [13-matmul](lessons/01-gpu-programming/13-matmul/README.md): BF16 GPU optimization, twenty-two stages complete through 16, including the 07a buffer-access, 07b operand-staging, and 07c grouped-traversal bridges

The course contains 50 native programs (13 foundational lessons, four focused divide tutorials, twenty-two BF16 matmul stages, eight quantized matmul programs, and three BF16 MoE stages). Mixed-width edge loads are validated on Radeon 8060S `gfx1151` with the pinned FlyDSL 0.4.1 / ROCm environment. Earlier gfx1152 validation covers 36 programs. Run `pixi run lessons-check`, or `pixi run gpu-check` to include the extra layout and sliced-view checks. Lesson 12 runs a small copy benchmark. Individual matmul files print local timing comparisons, and `pixi run matmul-bench` compares the twelve 1024³ kernels. Stage 14 has a matched multi-shape guard comparison.

The vector-add lesson uses per-value guarded scalar accesses for both full tiles and tails. The full-tile fragment lesson separately teaches tiled copies. A full-block vectorized path plus a guarded tail path is a useful next optimization, not a prerequisite for correctness.

## 13 · BF16 matmul through mixed-width edge loads

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
| [10 · Independent wave tiles](lessons/01-gpu-programming/13-matmul/10-wave-local-tiles/README.md) | Slice physical output regions into a 2D arrangement of private wave tiles; tune all four 1–2 × 1–2 shapes through lesson 12 | Complete; gfx1151 checked |
| [10a · Synchronization scope](lessons/01-gpu-programming/13-matmul/10a-synchronization-scope/README.md) | Separate memory address spaces from participating threads | Complete; gfx1151 checked |
| [10b · B cache policy](lessons/01-gpu-programming/13-matmul/10b-cache-policy/README.md) | Compare cache-policy hints with addresses and ownership fixed | Complete; gfx1151 checked |
| [10c · K-loop unrolling](lessons/01-gpu-programming/13-matmul/10c-k-unrolling/README.md) | Group steady steps, cover tails, and measure physical registers | Complete; gfx1151 checked |
| [12 · Operand paths](lessons/01-gpu-programming/13-matmul/12-operand-paths/README.md) | Profile Torch; compare direct A registers against tuned prefetch while preserving coalesced B staging | Complete; gfx1151 checked; M=32 wins 9/9 graph rounds versus tuned prefetch |
| [13 · Edge safety](lessons/01-gpu-programming/13-matmul/13-edge-safety/README.md) | Predicate exact-shaped A/B/C views, zero skipped inputs, cover arbitrary positive M/N/K and empty split-K work | Complete; gfx1151 checked; measured vector-width edge examples versus Torch |
| [14 · Targeted M/N/K guards](lessons/01-gpu-programming/13-matmul/14-targeted-guards/README.md) | Use descriptor bounds for whole rows, guard the remaining aliasing columns and empty K slots | Complete. Matched graph timing versus stage 13 and Torch on gfx1151. |
| [15 · Mixed-width edge loads](lessons/01-gpu-programming/13-matmul/15-edge-load-widths/README.md) | Retain wide loads for complete chunks, split the remainder, and specialize B near its physical edge | Complete. Matched timing versus stage 14 and Torch on gfx1151. |
| [16 · B register staging](lessons/01-gpu-programming/13-matmul/16-right-register-staging/README.md) | Gather B columns into WMMA registers | Matched and tuned small-N comparison for BF16 and quantized operands |

The course-wide `pixi run gpu-check` runs matmul correctness only. Individual matmul solutions and completed practices can print their own GPU PyTorch timing/TFLOP/s comparison after checking correctness; `--check-only` skips it. `pixi run matmul-bench` compares the twelve 1024³ stages; 09–12 have dedicated skinny benchmarks. The baseline is GPU `torch.matmul` on the same BF16 buffers with a preallocated GPU output. Stage 01 uses column-major B; other stages use row-major B. Full-series results are grouped by B layout and include a matching PyTorch baseline for each. Packing is outside timing. Default automatic timing retimes all compared implementations with synchronized host batches if any event duration is unavailable; the actual method is printed. Explicit event-only and host modes are also available. Host timing still runs GPU computation and includes dispatch/synchronization overhead. The [skinny-shape investigation](experiments/torch-strategy/README.md) identifies hipBLASLt for those calls; it does not identify the fixed 1024³ call's selected solution. The new lessons have not yet been hardware-validated on gfx1152.

Stages 01–07 use the same named native-view path as the naive lesson. Register tiling selects 4×1 per-thread output windows with `flat_divide`; the standard LDS kernel selects 16-wide K windows and WMMA selects 32-wide K windows; vectorized-copy stage 04 uses 64-wide windows and 4×4 thread output tiles. Stage 05 inherits its 128-bit staging pipeline with a 128-thread staging plan and a `(2,2,1)` four-wave MMA layout. Global block views retain row stride 1024, while packed LDS views use their local row width. The READMEs trace those domains and distinguish staging ownership from compute/WMMA ownership.

Stage 06 holds the stage-05 block and MMA ownership fixed while comparing packed, native-swizzled, and padded A LDS placement. Its reproducible rocprofv3 capture checks conflict numerator/denominator, generated instructions, and separately measured time. Padding was the stronger measured candidate on gfx1151; the default swizzle demonstrates conflict reduction without assuming a speedup.

Stage 07 retains the padded layout and one LDS tile per operand, then prefetches the next global tile into private registers before current-tile WMMA. Its captured ISA places the VMEM wait after both WMMA updates; separate host captures observed about 8% lower time than the matched serial padded schedule. One-/two-/three-tile checks exercise prologue, handoff, and drain. This verifies a latency-hiding opportunity, not a cycle-level overlap measurement.

## Matmul continuation (planned)

1. **Deeper software pipelines:** build on stage 12's all-wave prefetch, investigate earlier operand loads and finer operand-load/WMMA interleaving, and measure whether deeper queues repay their resource cost. Retain the fixed 1024³ reference and verify generated instructions before claiming overlap.
2. **Shape and resource tuning:** build on stage 15's contiguous edge safety to tune general strides and more shape/resource families with full correctness coverage. Revisit register pressure, LDS layouts, and wave ownership for each declared workload; retain the fixed 1024³ reference.
3. **Library challenge:** extend the skinny hipBLASLt investigation to the fixed 1024³ workload, match arithmetic and measurement policies, collect repeatable results, and investigate whether a specialized kernel can win for 1024³ on the named GPU. A win is a measured target, not a promised lesson outcome.

Reliable timing is required before a performance claim. The gfx1151 setup currently reports zero GPU event durations; synchronized host timing is labeled separately. Preserve the fixed shape, BF16 contract, preallocated outputs, and independent correctness reference across comparisons.

The [HipKittens four-wave investigation](experiments/hipkittens-four-wave/README.md) tests all-wave loading/compute with fine instruction interleaving on the declared skinny shapes. Its 396 measured configurations and ablations lead to prefetch parity in fresh verification, so it remains an experiment. The following [Torch profiling study](experiments/torch-strategy/README.md) motivates stage 12's operand paths.

## Further study

Asynchronous copies, reductions, dynamic shapes, general strided tilers, and broader occupancy/register-pressure tuning remain beyond the completed sequence. Extend the correctness checks before tuning a new access pattern.

Stage 08 now also has a separately locked `(M,N,K)=(1024,4096,2048)` configuration with `traversal_group_m=2`. It passed all 18 direct-launch held-out win rounds against GPU Torch; graph replay met parity. This extends aligned per-shape tuning without adding general tails or changing the standard 1024³ benchmark. See the [rectangular workload measurements](lessons/01-gpu-programming/13-matmul/08-parameter-tuning/README.md#select-a-configuration-for-a-rectangular-workload).

## 14 · Quantized matmul

[Lesson 14](lessons/01-gpu-programming/14-quantized-matmul/README.md) begins with the [MXFP4 format](lessons/01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16/01-mxfp4-format/README.md). [Scalar decode](lessons/01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16/02-scalar-dequant/README.md) expands one weight per GPU thread and passes dense BF16 B to stage 15. [Fused staging](lessons/01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16/03-fused-staging/README.md) decodes packed E2M1 nibbles and E8M0 block scales into each BF16 LDS tile. [Register lookup](lessons/01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16/04-lut-decode/README.md) replaces magnitude arithmetic and tunes the three paths. The next lesson, [MXFP8 block-scale matmul](lessons/01-gpu-programming/14-quantized-matmul/02-mxfp8-blockscale/README.md), applies independent E8M0 scales to E4M3FN A and B. The fused kernels cover partial K blocks and odd N with the mixed-width pipeline. [NVFP4 W4A16](lessons/01-gpu-programming/14-quantized-matmul/03-nvfp4-w4a16/README.md) adds the format, scalar dequantization, fused arithmetic staging, register lookup, and decoded-scale reuse for E2M1 weights with E4M3 block scales and one FP32 tensor multiplier.

The MXFP4 and MXFP8 benchmarks compare fused execution with Torch's compiled decode and BF16 matmul from the same quantized inputs. Future hardware-specific lessons can use native microscaled matrix instructions. [MXFP4 results](lessons/01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16/results/README.md) · [MXFP8 results](lessons/01-gpu-programming/14-quantized-matmul/02-mxfp8-blockscale/results/README.md)

The main skinny path is **09 → 10 → 10a → 10b → 10c → 12 → 13**. [Wave specialization and semaphore handoffs](experiments/wave-specialization/README.md) are archived research. [Lesson 12](lessons/01-gpu-programming/13-matmul/12-operand-paths/README.md#why-the-course-keeps-prefetch) explains their measured tradeoffs and why ordinary prefetch remains the course strategy. Global split-K arrival counters remain part of the single-kernel finalizer.

## 15 · BF16 MoE

[Lesson 15](lessons/01-gpu-programming/15-bf16-moe/README.md) follows a route from its expert assignment through SwiGLU and the token sum. It moves from scalar dot products to GPU worklist construction and grouped WMMA, then fuses activation and routing weights into the projections. The fused stage compares deterministic slot reduction, FP32 atomic accumulation, and direct GEMV for sparse decode. [gfx1151 measurements](lessons/01-gpu-programming/15-bf16-moe/results/README.md)
