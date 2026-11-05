# 13 · Optimize BF16 matrix multiplication

Build one GPU matrix product in twelve steps: a naive dot product, a column-major B storage experiment, native four-row thread windows, LDS staging, vectorized copies, a matrix instruction, measured LDS bank-conflict reduction, interleaved loads with compute, buffer global access, separate operand staging plans, grouped block traversal, and measured parameter tuning. Complete [lesson 12](../12-inspect-and-tune/README.md) first. Each stage has an illustrated walkthrough, two expression-sized practice TODOs, a worked solution, and a checker.

All runnable exercises and comparisons use **M = N = K = 1024**. A is row-major BF16. Stage 01 supplies a column-major BF16 B to make each thread's K walk contiguous; other stages supply row-major BF16 B. All tensors are on the GPU. Kernels accumulate in FP32 and write a BF16 matrix C implementing `C = A @ B`. There is no bias, activation, or alpha/beta scaling. Stage-01 B packing and all allocations are outside timing. Diagrams zoom into block tiles and thread fragments within this same workload; each stage states its tile dimensions.

| Stage | What it teaches | Block tile / threads |
| --- | --- | --- |
| [00 · Naive](00-naive/README.md) | Native global/tiled/block/thread views and one FP32 dot product per thread | 16×16 / 256 |
| [01 · Contiguous K access](01-coalesced-access/README.md) | Column-major B makes both per-thread K walks contiguous | 16×16 / 256 |
| [02 · Register tiling](02-register-tiling/README.md) | Select 4×1 thread output windows and reuse B | 16×16 / 64 |
| [03 · Shared memory](03-shared-memory/README.md) | Select native K windows, stage them in LDS, and synchronize | 16×16 / 64 |
| [04 · Vectorized copies](04-vectorized-copy/README.md) | Keep 4×4 thread accumulators; stage inputs with UniversalCopy128b | 64×64 / 256 |
| [05 · Matrix instructions](05-matrix-instructions/README.md) | Keep the stage-04 copy structure; derive A/B/C plans from WMMA and consume explicit K=16 slices | 64×64 / 128 |
| [06 · LDS bank conflicts](06-lds-swizzle/README.md) | Compare native swizzling and aligned padding with counter, ISA, and timing evidence | 64×64 / 128 |
| [07 · Interleaved loads](07-interleaved-loads/README.md) | Keep stage 06's padded tile; prefetch next globals while WMMA consumes current LDS | 64×64 / 128 |
| [07a · Buffer access](07a-buffer-access/README.md) | Buffer global loads/stores with the existing shared staging plan | 64×64 / 128 |
| [07b · Operand staging](07b-operand-staging/README.md) | Derive A/B copy ownership independently from contiguous K/N extents | 64×64 / 128 |
| [07c · Grouped traversal](07c-grouped-traversal/README.md) | Group block IDs along M to encourage B reuse through cache | 64×64 / 128 |
| [08 · Parameter tuning](08-parameter-tuning/README.md) | Tile/wave/buffer search, register reuse, and held-out paired PyTorch verification | 128×128 / 128 |

Start with the [naive walkthrough](00-naive/README.md). Read each diagram's labels carefully: input values, storage offsets, thread IDs, and accumulator slots describe different things. Keep the same arithmetic and shape while changing one part of the implementation at a time. All stages use named `*_global_view`, `*_tiled_view`, `*_block_view`, and thread/fragment views instead of handwritten global storage offsets. Stages 00–02 select full-K input windows; stage 03 selects 16-wide K windows (64 in its 4×4 variant), stage 04 selects 64-wide windows, stages 05–07c select 64-wide windows. Changes in block size and instruction ownership are stated explicitly; they also affect resource usage.

Stage 08 additionally supports a separately tuned **(M,N,K)=(1024,4096,2048)** workload through its shape selector. The standard course benchmark keeps the original 1024³ comparison. See [stage 08](08-parameter-tuning/README.md) for per-shape configurations and verification.

## Practice workflow

From the repository root:

```bash
pixi run python lessons/01-gpu-programming/13-matmul/00-naive/practice.py
pixi run python lessons/01-gpu-programming/13-matmul/00-naive/solution.py
pixi run gpu-check
```

The starter is intentionally unfinished and reports `Practice not finished: ...`. Complete its two TODOs and compare with its solution before continuing to the next stage. All twelve check the entire 1024×1024 output with trace and seeded random inputs, against an untimed CPU FP32 reference computed from the quantized BF16 inputs and rounded to BF16. Sixteen trailing sentinels check for stray writes. The common trace checkpoint is `[3, -6, -1, -3]` for the first four outputs in row 0. Each walkthrough specifies the numerical tolerances.

Stages 00–03 use a 64×64 grid of 16×16 output tiles. Stage 04 follows the shared-memory 4×4 variant: a 16×16 grid of 64×64 output tiles with 16 K stages of width 64. Stages 05–07c use a 16×16 grid of 64×64 output tiles, four waves per block, and 16 K stages of width 64, consumed through four explicit K=16 inner steps. The standard LDS kernel uses 64 K stages of width 16. These kernels assume complete tiles and contiguous storage. General strides and partial tiles belong to the later shape-tuning work.

## Compare the stages

Each lesson solution and completed practice now prints its own kernel versus GPU `torch.matmul` table after correctness, with milliseconds and TFLOP/s. Practice files time the learner's kernel. Use `--check-only` to skip timing for an individual file; the course-wide checkers already do this for matmul. The shared implementation lives in `examples/matmul_benchmark.py`. CLI reference checks use one CPU thread outside timing to avoid competing for the APU power budget.

The benchmark runs all twelve **GPU** kernels and **GPU `torch.matmul`** on identical logical BF16 inputs and a preallocated BF16 GPU output. The full-series benchmark groups kernels by physical B layout and runs a GPU PyTorch baseline for each group. Each JSON row includes `right_layout` and `right_stride`; compare a kernel against the PyTorch row in its matching layout group. It verifies each implementation before timing. CPU arithmetic is only the untimed correctness reference. The PyTorch baseline uses `torch.matmul(left, right, out=out)` with both inputs and `out` on `device="cuda"` through ROCm.

```bash
pixi run matmul-bench
# Explicit alternative when GPU events are unavailable on the host:
pixi run matmul-bench --timing host
```

The fixed shape is 1024×1024×1024 for every row. B packing is excluded from timing. A row-major baseline and a column-major baseline are separate records; their timings can differ. The stage-01 storage experiment teaches contiguous K accesses within each thread, not coalesced input requests across lanes. All implementations get three warm-up launches before timing, which also excludes compilation. The result is the median of five batches of 20 launches using warm repeated buffers. `--repeats` changes the number of launches per batch, not the problem shape. The reported operation count is `2*M*N*K`, and effective TFLOP/s is this count divided by elapsed seconds and 10¹².

Default `auto` timing tries GPU events, then retimes every compared implementation with synchronized host batches if any median is unavailable. The output reports the requested and actual timing method and the reason for fallback. Both rows in a lesson always use the same method.

Explicit `--timing gpu-event` uses GPU events on the current/default stream without fallback. Zero median event duration produces `ms: null`, `effective_TFLOP_s: null`, and an unavailable status. It never becomes infinite throughput or a pass/fail performance assertion. On the tested gfx1151 setup, events can report zero even for completed GPU work.

Explicit `host` timing uses a monotonic CPU clock around GPU launches, with GPU synchronization before and after each batch. **Computation still runs on the GPU.** This measurement includes Python dispatch, launch gaps, and batch synchronization, so it measures host-observed execution cost rather than isolated device time. Compare rows only under the same timing method and rerun to assess variation. The output records the GPU, architecture, versions, method, and scope; it prints no automatic winner.

`torch.matmul` is a practical baseline, but this harness has not identified its underlying BLAS backend. A later library challenge must identify whether the comparison is hipBLAS, hipBLASLt, or another path and match dtype, accumulation, layout, output, and timing policies. No current lesson claims to beat hipBLAS.

## Measure LDS layout changes

[Stage 06](06-lds-swizzle/README.md) retains stage 05's four-wave 64×64×64 tile and explicit inner K loop while comparing packed, native-swizzled, and padded A LDS layouts. Its profiling driver records raw bank-conflict counters and generated ISA, then times the variants separately. On gfx1151, both layout changes reduced the conflict metric, while padding preserved vector loads and gave the better host-timed result. The main series benchmark uses the stage-06 default swizzle; run its dedicated profiler to compare all three modes.

## Interleave loads with compute

[Stage 07](07-interleaved-loads/README.md) retains the measured padded A layout and compares serial staging with a one-tile global prefetch. Private staging registers hold the future tile while WMMA consumes current LDS. Prologue, reader/ready barriers, and drain protect a single shared tile per operand. Its dedicated profiler verifies final instruction/wait order, checks one-/two-/three-tile boundaries, and times both schedules with the same layout; the full-series benchmark uses the prefetch default.

## Group blocks for cache reuse

[Stage 07c](07c-grouped-traversal/README.md) keeps 07b's 64×64×64 tile and maps nearby block IDs to two output tile rows at the same column. It checks every native block coordinate and the complete matmul. Blocks retain independent LDS and K reductions; the mapping encourages B cache reuse without assuming an execution order or a speedup. Stage 08 retains this strategy while tuning tile and wave parameters.

## Tune and verify register reuse

[Stage 08](08-parameter-tuning/README.md) stages full K tiles in LDS but consumes 16-wide operand fragments, uses native buffer-addressed global copies, and groups output blocks to reuse B in cache. Its 132-candidate tile/wave/buffer search selected 128×128×32 with 1×4 waves and one LDS buffer. All candidates passed full-output correctness. Two locked direct-launch verifications passed the strict win criterion in all 18 rounds across six fresh seeds; graph verification met parity. Three ordinary lesson CLI runs also beat GPU PyTorch using available GPU-event timing. The [measured comparison](08-parameter-tuning/README.md#the-measured-winner) includes commands for reproducing the benchmark and profiler measurements. These results apply to the fixed 1024³ workload on gfx1151.

## Scope and next experiments

These twelve stages were executed on Radeon 8060S (`gfx1151`) with FlyDSL 0.4.1 and the shared Pixi environment. WMMA uses the gfx11 wave32 convention intended for gfx1151/gfx1152; the new lessons still need hardware validation on gfx1152. The final kernel is a teaching baseline with 128-bit staging copies and one staging buffer per operand.

The [roadmap](../../../ROADMAP.md#matmul-continuation-planned) continues with deeper software pipelines, shape/resource tuning, and a named-library challenge. Those stages are planned, not completed. Preserve this fixed 1024³ comparison while testing each new optimization; do not infer a general GPU result from one shape.

[Previous: inspect and measure](../12-inspect-and-tune/README.md) · [GPU programming](../README.md) · [Course overview](../../../README.md)
