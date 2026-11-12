# CTA-level split-K finalizer comparison

One counter per output tile reduces arrival atomics by 64× for a 64-thread CTA, but this experiment did not establish a useful end-to-end speedup. Both strategies remain available in the completed [practice](../../practice.py), selected with `--counter-scope thread|cta`; the default is `thread`.

Measured on 2026-11-12 with Radeon 8060S Graphics (`gfx1151`), FlyDSL 0.4.1, PyTorch 2.13.0+rocm10.1.0, and reported HIP 7.16.26385. [Raw measurements](comparison.json) include environment, source hashes, all samples, pairing orders, validation results, and capture metadata. The [run log](benchmark.log), source snapshots, and generated ISA retain the measured implementation.

## Controlled comparison

Both modes use the same input/output buffers, matmul pipeline, tile geometry, split count, thread-contiguous partial layout, four-fragment reduction, and BF16 conversion. Only arrival/election/reset coordination and counter allocation change. No butterfly, second kernel, operand packing, or per-launch workspace initialization is introduced. The reduction deliberately keeps the baseline's zero initialization and four fragment additions; optimization of that arithmetic is outside this comparison.

All measured configurations use `block_n=64`, `block_k=64`, `waves_m=1`, `waves_n=2`, `group_m=1`, and `split_k=4`. `block_m` is 16, 32, and 16 respectively. The wide workload deliberately uses the same 64-thread split-K strategy as the narrow example; its usual lesson-selected configuration disables splitting and is not the baseline in this experiment. These results compare counter strategies, not performance against Torch or the best configuration for each shape.

For the 16×64 tile, each strategy writes and reads four FP32 partial tiles: 32 KiB total logical traffic per output tile. Per-thread mode uses 64 counters and 256 atomic increments; CTA mode uses one counter and four increments. Partial addressing is identical, so improved coalescing is not assumed.

## Publication and election

1. Every thread stores its fragment and executes an agent-scope release fence.
2. A full workgroup barrier joins the writers before thread 0 increments the tile's agent-scope acquire/release counter.
3. Thread 0 writes whether it received old count `split_k - 1` into an aligned LDS word. The compute phase has drained, so this word reuses operand storage.
4. A second workgroup barrier broadcasts the election result. Every winning thread executes an agent-scope acquire fence, reads all four partial fragments, and stores its output slots.
5. A final workgroup barrier joins the finalizers before thread 0 resets the counter with an agent-scope release store.

Only the winning CTA enters the collective reduction, and its election predicate is uniform across the CTA. Earlier CTAs do not wait for other CTAs. Workspace reuse requires serialized launches on the same stream, as with the baseline. The synchronization design follows the [LLVM AMDGPU memory model](https://llvm.org/docs/AMDGPUMemoryModel.html) and [execution-barrier rules](https://llvm.org/docs/AMDGPUUsage.html#execution-barriers).

## Timing

Graph-host measurements capture exactly 32 kernel nodes for 32 GEMMs and time 50 replays per batch. Each of seeds 13, 29, and 47 has nine alternating thread/CTA batches after five warmups. Thus each row below summarizes 27 paired batches. Graph replay is validated with changed input signs, NaN output poisoning, output/workspace sentinels, and counter reset. Compilation, allocation, initialization, and CPU reference checks are excluded from timing. Timings use a synchronized host clock, not isolated device events.

| M,N,K | Per-thread median | CTA median | Median paired CTA/thread |
| --- | ---: | ---: | ---: |
| 16,1024,8192 | 21.641 µs | 21.786 µs | 1.0069 |
| 32,1024,8192 | 28.215 µs | 28.365 µs | 1.0058 |
| 16,4096,8192 | 499.052 µs | 497.517 µs | 0.9964 |

Ratios below 1 favor CTA counters. Ratios are medians of paired samples, rather than quotients of independently aggregated times. Direct-host median paired ratios were 0.9958, 0.9977, and 0.9955 respectively; direct calls include Python dispatch. The observed differences are small, and these measurements do not establish a useful gain. No profiler attribution or gfx1152 validation is claimed.

## Correctness and generated code

All 26 correctness configurations passed: both modes on all three lesson-selected geometries with splits 1/2/4, plus both modes with 32/64/128/256 threads, multiple output tiles, and `group_m=2`. Each configuration checks tagged one/two/three-local-K-tile boundaries, FP32 partial values, trace/random products, changed-sign workspace reuse, complete BF16 output, trailing sentinels, and counter reset. Another 600 launches check each individual output while alternating input signs and poisoning the output, using the six benchmark workspaces.

The [inspection report](inspection.json) and retained [thread ISA](thread-isa.s), [CTA ISA](cta-isa.s), [thread publication IR](thread-publication.mlir.txt), and [CTA publication IR](cta-publication.mlir.txt) show the expected atomics and ordering. The CTA atomic is guarded by thread ID zero; the flag is stored in LDS and read after a workgroup barrier. Both default specializations use 10,496 bytes of LDS, 163 VGPRs, 19 SGPRs, and zero private scratch. Static workgroup-barrier sites increase from four to seven. Static atomic instruction-site count is one in each kernel; executed lane operations differ because only thread 0 executes the CTA arrival.

The full [GPU regression check](gpu-check.log) also passed all 35 native course solutions and additional mapping/sliced-load checks. Targeted Ruff, local documentation links, source hashes, and whitespace checks passed.

Extra synchronization is a plausible reason that the reduced atomic count did not improve timing, but resource counts and static inspection do not measure the time spent in each phase.

## Reproduce

Run from the repository root in the pinned environment. Inspection output directories must be fresh.

```bash
pixi run python lessons/01-gpu-programming/13-matmul/09-split-k/benchmark_counters.py --output /tmp/split-k-counters.json
pixi run python lessons/01-gpu-programming/13-matmul/09-split-k/inspect_kernel.py --implementation practice --counter-scope thread --output /tmp/split-k-thread-inspection
pixi run python lessons/01-gpu-programming/13-matmul/09-split-k/inspect_kernel.py --implementation practice --counter-scope cta --output /tmp/split-k-cta-inspection
```
