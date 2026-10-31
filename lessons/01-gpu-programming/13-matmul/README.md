# 13 · Optimize BF16 matrix multiplication

Build one GPU matrix product in five steps: a naive dot product, a more contiguous thread order, register reuse, LDS staging, and a matrix instruction. Complete [lesson 12](../12-inspect-and-tune/README.md) first. Each stage has an illustrated walkthrough, two expression-sized practice TODOs, a worked solution, and a checker.

All runnable exercises and comparisons use **M = N = K = 1024**. Inputs A and B are contiguous row-major BF16 matrices on the GPU. Kernels accumulate in FP32 and write a BF16 matrix C implementing `C = A @ B`. There is no bias, activation, transpose allocation, alpha/beta scaling, or timed allocation. Diagrams zoom into individual 16×16 tiles and thread fragments within this same workload.

| Stage | What changes | Threads per 16×16 output tile |
| --- | --- | --- |
| [00 · Naive](00-naive/README.md) | One output per thread; explicit row-major offsets and FP32 reduction | 256 |
| [01 · Coalesced access](01-coalesced-access/README.md) | Adjacent threads compute adjacent columns | 256 |
| [02 · Register tiling](02-register-tiling/README.md) | Reuse one B value across four output rows | 64 |
| [03 · Shared memory](03-shared-memory/README.md) | Cooperatively stage BF16 tiles in LDS; synchronize before use and reuse | 64 |
| [04 · Matrix instructions](04-matrix-instructions/README.md) | Keep LDS staging and use wave32 BF16 WMMA with FP32 accumulator fragments | 32 |

Start with the [naive walkthrough](00-naive/README.md). Read each diagram's labels carefully: input values, storage offsets, thread IDs, and accumulator slots describe different things. Keep the same arithmetic and shape while changing one part of the implementation at a time. Changes in block size and instruction ownership are stated explicitly; they also affect resource usage.

## Practice workflow

From the repository root:

```bash
pixi run python lessons/01-gpu-programming/13-matmul/00-naive/practice.py
pixi run python lessons/01-gpu-programming/13-matmul/00-naive/solution.py
pixi run gpu-check
```

The starter is intentionally unfinished and reports `Practice not finished: ...`. Complete its two TODOs and compare with its solution before continuing to the next stage. All five check the entire 1024×1024 output with trace and seeded random inputs, against an untimed CPU FP32 reference computed from the quantized BF16 inputs and rounded to BF16. Sixteen trailing sentinels check for stray writes. The common trace checkpoint is `[3, -6, -1, -3]` for the first four outputs in row 0. Each walkthrough specifies the numerical tolerances.

The full problem divides into a 64×64 grid of 16×16 output tiles. LDS and WMMA stages traverse 64 K tiles. These kernels assume complete tiles and contiguous storage. General strides and partial tiles belong to the later shape-tuning work.

## Compare the stages

The benchmark runs all five **GPU** kernels and **GPU `torch.matmul`** on the same BF16 input tensors and a preallocated BF16 GPU output. It verifies each implementation before timing. CPU arithmetic is only the untimed correctness reference. The PyTorch baseline uses `torch.matmul(left, right, out=out)` with both inputs and `out` on `device="cuda"` through ROCm.

```bash
pixi run matmul-bench
# Explicit alternative when GPU events are unavailable on the host:
pixi run matmul-bench --timing host
```

The fixed shape is 1024×1024×1024 for every row. All implementations get three warm-up launches before timing, which also excludes compilation. The result is the median of five batches of 20 launches using warm repeated buffers. `--repeats` changes the number of launches per batch, not the problem shape. The reported operation count is `2*M*N*K`, and effective TFLOP/s is this count divided by elapsed seconds and 10¹².

Default `gpu-event` timing uses GPU events on the current/default stream. Zero median event duration produces `ms: null`, `effective_TFLOP_s: null`, and an unavailable status. It never becomes infinite throughput or a pass/fail performance assertion. On the tested gfx1151 setup, events can report zero even for completed GPU work.

Explicit `host` timing uses a monotonic CPU clock around GPU launches, with GPU synchronization before and after each batch. **Computation still runs on the GPU.** This measurement includes Python dispatch, launch gaps, and batch synchronization, so it measures host-observed execution cost rather than isolated device time. Compare rows only under the same timing method and rerun to assess variation. The output records the GPU, architecture, versions, method, and scope; it prints no automatic winner.

`torch.matmul` is a practical baseline, but this harness has not identified its underlying BLAS backend. A later library challenge must identify whether the comparison is hipBLAS, hipBLASLt, or another path and match dtype, accumulation, layout, output, and timing policies. No current lesson claims to beat hipBLAS.

## Scope and next experiments

These five stages were executed on Radeon 8060S (`gfx1151`) with FlyDSL 0.4.1 and the shared Pixi environment. WMMA uses the gfx11 wave32 convention intended for gfx1151/gfx1152; the new lessons still need hardware validation on gfx1152. The final kernel is a teaching baseline with simple copies and one staging buffer per operand.

The [roadmap](../../../ROADMAP.md#matmul-continuation-planned) continues with pipelining, shape/resource tuning, and a named-library challenge. Those stages are planned, not completed. Preserve this fixed 1024³ comparison while testing each new optimization; do not infer a general GPU result from one shape.

[Previous: inspect and measure](../12-inspect-and-tune/README.md) · [GPU programming](../README.md) · [Course overview](../../../README.md)
