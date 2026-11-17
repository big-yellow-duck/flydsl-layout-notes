# MXFP4 W4A16 optimization experiments

Experiment archive for profiler-guided changes to lesson 14. The fused B-staging kernel was promoted into the lesson after it passed the correctness checks and repeated shape comparisons. The lesson contains the runnable public implementation and its retuned defaults; this directory preserves the copied research harness, profiler traces, and original experiment measurements.

`profile_pipeline.py` uses `rocprofv3` ROCTx-selected regions to separate the MXFP4 unpack kernel from the lesson-12 BF16 WMMA kernel. Counter passes are diagnostic and instrumented; use CUDA-graph timing for throughput comparisons.

## Findings

The baseline trace for `(M,N,K)=(16,1024,8192)` attributed a median **309 μs** to register unpack and **165 μs** to BF16 WMMA. These are instrumented dispatch durations, so compare them only as a profile; the independent CUDA-graph measurements are in the JSON result files.

The direct E2M1-to-BF16 bit mapping was bitwise correct but did not improve the full path. The useful change was to decode each packed B tile into LDS as the matmul consumes it, removing the global dense-BF16 write and reread. A small fused-kernel sweep selected K unroll 4 for the first two shapes and K unroll 2 for the wide-N shape.

| Shape (M,N,K) | Unpack + BF16 WMMA | Fused path | Torch dense BF16 | Fused vs prior path |
|---|---:|---:|---:|---:|
| (16, 1024, 8192) | 0.406 ms | 0.240 ms | 0.256 ms | 1.69× |
| (32, 1024, 8192) | 0.426 ms | 0.264 ms | 0.262 ms | 1.61× |
| (16, 4096, 8192) | 1.550 ms | 0.758 ms | 1.092 ms | 2.04× |

These are medians over seven batches of 20 CUDA-graph replays, with eight GEMMs per graph. Every fused output matched the quantized BF16 reference within the lesson tolerance. The fused path is about 31% faster than Torch for the wide-N case, about 1% slower for `(32,1024,8192)`, and about 6% faster for `(16,1024,8192)`.

The counter passes support the same diagnosis. For `(16,1024,8192)`, the separate unpack and GEMM passes issued about **168k** combined 128-byte external read requests; the fused pass issued about **40k**. The initial fused configuration used 216 VGPRs per thread; K unroll 4 reduced that to 168 and lowered the raw LDS wait counter. Counter values and profile durations are instrumented and should not be interpreted as elapsed-time equivalents.

## Artifacts

- [Baseline pipeline profile](results/20261117-baseline-16x1024/summary.json)
- [Fused profile with initial tile config](results/20261117-fused-profile-16x1024/summary.json)
- [Fused profile after K-unroll tuning](results/20261117-fused-tuned-profile-16x1024/summary.json)
- [Fused configuration sweep](results/20261117-fused-tuning.json)
- [Final selected-config comparisons](results/20261117-fused-selected-final.json)
- [E2M1/scale code edge check](verify_fused_edges.py)
