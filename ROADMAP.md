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
- [13-matmul](lessons/01-gpu-programming/13-matmul/README.md): BF16 GPU optimization, stages 00–04 complete

All 22 worked programs (13 foundational lessons, four focused divide tutorials, and five matmul stages) compile and run on gfx1151 with the pinned FlyDSL 0.4.1 / ROCm environment. Run `pixi run lessons-check`, or `pixi run gpu-check` to include the extra layout and sliced-view checks. Lesson 12 runs a small copy benchmark; matmul performance comparisons run separately with `pixi run matmul-bench`. Results are observations, not pass/fail performance thresholds.

The vector-add lesson uses per-value guarded scalar accesses for both full tiles and tails. The full-tile fragment lesson separately teaches tiled copies. A full-block vectorized path plus a guarded tail path is a useful next optimization, not a prerequisite for correctness.

## 13 · BF16 matmul: complete through matrix instructions

All five exercises and the GPU PyTorch baseline use **M=N=K=1024**, contiguous BF16 input/output, and FP32 accumulation. Diagrams zoom into tiles of the full workload. Each stage includes its README, reproducible SVG/PNG diagram, `practice.py`, and `solution.py`.

| Stage | Learning goal | Status |
| --- | --- | --- |
| [00 · Naive](lessons/01-gpu-programming/13-matmul/00-naive/README.md) | Row/column dot products and FP32 accumulation | Complete; gfx1151 checked |
| [01 · Coalesced access](lessons/01-gpu-programming/13-matmul/01-coalesced-access/README.md) | Adjacent threads access adjacent B columns | Complete; gfx1151 checked |
| [02 · Register tiling](lessons/01-gpu-programming/13-matmul/02-register-tiling/README.md) | Four outputs per thread and B reuse | Complete; gfx1151 checked |
| [03 · Shared memory](lessons/01-gpu-programming/13-matmul/03-shared-memory/README.md) | Cooperative LDS staging and two synchronization points | Complete; gfx1151 checked |
| [04 · Matrix instructions](lessons/01-gpu-programming/13-matmul/04-matrix-instructions/README.md) | gfx11 wave32 BF16 WMMA and FP32 fragments | Complete; gfx1151 checked |

Correctness stays in `pixi run gpu-check`; timed comparisons stay in `pixi run matmul-bench`. The baseline is GPU `torch.matmul` on the same BF16 buffers with a preallocated GPU output. The harness reports unavailable event timing honestly and offers explicit synchronized host timing. Host timing still runs GPU computation and includes dispatch/synchronization overhead. The underlying PyTorch BLAS backend is not yet identified. The new lessons have not yet been hardware-validated on gfx1152.

## Matmul continuation (planned)

1. **05 · Pipelining:** introduce another staging buffer, establish its producer/consumer ordering, and investigate overlap on the target. Keep the same 1024³ workload and verify the generated instructions before claiming overlap.
2. **06 · Shape and resource tuning:** first tune block tiles, wave ownership, register pressure, and LDS layouts for 1024³. Add explicit handling and correctness coverage for other shapes, strides, and tails in a later extension rather than silently changing the comparison.
3. **07 · Library challenge:** identify the actual hipBLAS/hipBLASLt baseline, match arithmetic and measurement policies, collect repeatable results, and investigate whether a specialized kernel can win for 1024³ on the named GPU. A win is a measured target, not a promised lesson outcome.

Reliable timing is required before a performance claim. The gfx1151 setup currently reports zero GPU event durations; synchronized host timing is labeled separately. Preserve the fixed shape, BF16 contract, preallocated outputs, and independent correctness reference across comparisons.

## Further study

Asynchronous copies, reductions, dynamic shapes, general strided tilers, and broader occupancy/register-pressure tuning remain beyond the completed sequence. Extend the correctness checks before tuning a new access pattern.
