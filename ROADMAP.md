# Learning roadmap

The course now has two sections. Work through each lesson's README and practice kernel, then compare the native FlyDSL solution. The foundational examples prioritize tracing ownership and memory access. The BF16 matmul series then applies those ideas to a fixed 1024×1024×1024 workload.

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
- [13-matmul](lessons/01-gpu-programming/13-matmul/README.md): BF16 GPU optimization, stages 00–05 complete

All 23 worked programs (13 foundational lessons, four focused divide tutorials, and six matmul stages) compile and run on gfx1151 with the pinned FlyDSL 0.4.1 / ROCm environment. Run `pixi run lessons-check`, or `pixi run gpu-check` to include the extra layout and sliced-view checks. Lesson 12 runs a small copy benchmark; individual matmul files print local timing comparisons, and `pixi run matmul-bench` compares the full series. Results are observations, not pass/fail performance thresholds.

The vector-add lesson uses per-value guarded scalar accesses for both full tiles and tails. The full-tile fragment lesson separately teaches tiled copies. A full-block vectorized path plus a guarded tail path is a useful next optimization, not a prerequisite for correctness.

## 13 · BF16 matmul: complete through matrix instructions

All six exercises and the GPU PyTorch baseline use **M=N=K=1024**, contiguous BF16 input/output, and FP32 accumulation. Diagrams zoom into tiles of the full workload. Each stage includes its README, reproducible SVG/PNG diagram, `practice.py`, and `solution.py`.

| Stage | Learning goal | Status |
| --- | --- | --- |
| [00 · Naive](lessons/01-gpu-programming/13-matmul/00-naive/README.md) | Native block/thread views, row/column dot products, and FP32 accumulation | Complete; gfx1151 checked |
| [01 · Contiguous K access](lessons/01-gpu-programming/13-matmul/01-coalesced-access/README.md) | Column-major B gives both per-thread K views stride 1 | Complete; gfx1151 checked |
| [02 · Register tiling](lessons/01-gpu-programming/13-matmul/02-register-tiling/README.md) | Four outputs per thread and B reuse | Complete; gfx1151 checked |
| [03 · Shared memory](lessons/01-gpu-programming/13-matmul/03-shared-memory/README.md) | Cooperative LDS staging and two synchronization points | Complete; gfx1151 checked |
| [04 · Vectorized copies](lessons/01-gpu-programming/13-matmul/04-vectorized-copy/README.md) | UniversalCopy128b staging and 4×4 register tiles | Complete; gfx1151 checked |
| [05 · Matrix instructions](lessons/01-gpu-programming/13-matmul/05-matrix-instructions/README.md) | gfx11 wave32 BF16 WMMA and FP32 fragments | Complete; gfx1151 checked |

The course-wide `pixi run gpu-check` runs matmul correctness only. Individual matmul solutions and completed practices print their own GPU PyTorch timing/TFLOP/s comparison after checking correctness; `--check-only` skips it. `pixi run matmul-bench` compares all six stages together. The baseline is GPU `torch.matmul` on the same BF16 buffers with a preallocated GPU output. Stage 01 uses column-major B; other stages use row-major B. Full-series results are grouped by B layout and include a matching PyTorch baseline for each. Packing is outside timing. Default automatic timing retimes all compared implementations with synchronized host batches if any event duration is unavailable; the actual method is printed. Explicit event-only and host modes are also available. Host timing still runs GPU computation and includes dispatch/synchronization overhead. The underlying PyTorch BLAS backend is not yet identified. The new lessons have not yet been hardware-validated on gfx1152.

Stages 01–05 use the same named native-view path as the naive lesson. Register tiling selects 4×1 per-thread output windows with `flat_divide`; The standard LDS and WMMA kernels select matching 16-wide K windows; vectorized-copy stage 04 uses 64-wide windows and 4×4 thread output tiles. Stage 05 inherits its 128-bit staging pipeline with a single-wave copy plan. Global block views retain row stride 1024, while packed LDS views use their local row width. The READMEs trace those domains and distinguish staging ownership from compute/WMMA ownership.

## Matmul continuation (planned)

1. **06 · Pipelining:** introduce another staging buffer, establish its producer/consumer ordering, and investigate overlap on the target. Keep the same 1024³ workload and verify the generated instructions before claiming overlap.
2. **07 · Shape and resource tuning:** first tune block tiles, wave ownership, register pressure, and LDS layouts for 1024³. Add explicit handling and correctness coverage for other shapes, strides, and tails in a later extension rather than silently changing the comparison.
3. **08 · Library challenge:** identify the actual hipBLAS/hipBLASLt baseline, match arithmetic and measurement policies, collect repeatable results, and investigate whether a specialized kernel can win for 1024³ on the named GPU. A win is a measured target, not a promised lesson outcome.

Reliable timing is required before a performance claim. The gfx1151 setup currently reports zero GPU event durations; synchronized host timing is labeled separately. Preserve the fixed shape, BF16 contract, preallocated outputs, and independent correctness reference across comparisons.

## Further study

Asynchronous copies, reductions, dynamic shapes, general strided tilers, and broader occupancy/register-pressure tuning remain beyond the completed sequence. Extend the correctness checks before tuning a new access pattern.
