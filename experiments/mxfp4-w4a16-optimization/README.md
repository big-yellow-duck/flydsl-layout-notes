# MXFP4 W4A16 optimization experiments

Experiment archive for profiler-guided changes to lesson 14. The fused B-staging kernel was promoted into the lesson after it passed the correctness checks and repeated shape comparisons. The lesson contains the runnable public implementation and its retuned defaults; this directory preserves the copied research harness, profiler traces, and original experiment measurements.

`profile_pipeline.py` uses `rocprofv3` ROCTx-selected regions to separate the MXFP4 unpack kernel from the lesson-12 BF16 WMMA kernel. Counter passes are diagnostic and instrumented; use CUDA-graph timing for throughput comparisons.

## AMD Quark Qwen3.8-27B MXFP4 against vLLM on gfx1151

This is a linear-layer microbenchmark of [AMD's Quark checkpoint](https://huggingface.co/amd/Qwen3.8-27B-Quark-AWQ-MXFP4). The [tensor fetcher](fetch_qwen38_quark_linears.py) reads the safetensors header and downloads the byte ranges for six representative TP=1 projections. It assembles vLLM's fused projections in checkpoint shard order. The harness uses the resulting checkpoint weights and E8M0 scales with seeded synthetic activations. [Checkpoint configuration](https://huggingface.co/amd/Qwen3.8-27B-Quark-AWQ-MXFP4/blob/93245f7c00f1a8964b66a97c6e02e2fd09080be4/config.json)

| vLLM text projection | N | K | Occurrences |
| --- | ---: | ---: | ---: |
| MLP gate/up | 34,816 | 5,120 | 64 |
| MLP down | 5,120 | 17,408 | 64 |
| Gated DeltaNet QKVZ | 16,384 | 5,120 | 48 |
| Gated DeltaNet B/A | 96 | 5,120 | 48 |
| Full attention QKV with output gate | 14,336 | 5,120 | 16 |
| Attention output, shared shape across both attention types | 5,120 | 6,144 | 64 |

On Radeon 8060S, the fork selects `QuarkLinearMethod` → `QuarkOCP_MX` → `EmulationMxfp4LinearKernel`. The checkpoint requests dynamic MXFP4 activations. vLLM quantizes and dequantizes the activation, expands the packed weights to BF16, and calls a BF16 linear. The timed FlyDSL path calls the same activation QDQ operation, then consumes the packed weights with its fused W4A16 kernel. The RDNA hybrid GPTQ/AWQ fast path accepts integer INT4 weights. [Quark scheme](https://github.com/big-yellow-duck/vllm/blob/5b5b371e3217550c79da02b8dd8bd3f1e3859324/vllm/model_executor/layers/quantization/quark/schemes/quark_ocp_mx.py#L240) · [Emulation](https://github.com/big-yellow-duck/vllm/blob/5b5b371e3217550c79da02b8dd8bd3f1e3859324/vllm/model_executor/kernels/linear/mxfp4/emulation.py) · [Hybrid INT4 kernel](https://github.com/big-yellow-duck/vllm/blob/5b5b371e3217550c79da02b8dd8bd3f1e3859324/vllm/model_executor/kernels/linear/mixed_precision/rdna_hybrid_w4a16.py#L836)

The [harness](benchmark_qwen38_vllm.py) runs both paths in one process using vLLM fork `5b5b371e3217550c79da02b8dd8bd3f1e3859324`, FlyDSL 0.4.1, and the PyTorch and Quark runtime from `vllm/vllm-openai-rocm:v0.32.0`. It replays the schedules tuned on matching dimensions and tunes the additional B/A projection with checkpoint weights. GPU events measure shuffled graph replays. Output checks use a dense FP32 reference and repeat after flipping the packed weights' signs.

### Matched linear timings

FlyDSL won all 30 cases on each of the three verification seeds. Each layer-weighted total sums the six measured projection medians multiplied by their occurrence counts above. The totals describe linear calls measured in isolation.

| Activation rows | Tuned FlyDSL (ms) | vLLM selected (ms) | Speedup |
| ---: | ---: | ---: | ---: |
| 1 | 61.73 | 555.07 | 8.99× |
| 8 | 72.31 | 559.30 | 7.74× |
| 32 | 89.12 | 594.74 | 6.67× |
| 128 | 209.75 | 784.37 | 3.74× |
| 512 | 789.37 | 1279.05 | 1.62× |

Each cell below gives tuned FlyDSL / selected vLLM GPU-event microseconds for one linear call.

| Projection | 1 row | 8 rows | 32 rows | 128 rows | 512 rows |
| --- | ---: | ---: | ---: | ---: | ---: |
| MLP gate/up | 430.5 / 3762.2 | 546.1 / 3777.3 | 612.2 / 3870.0 | 1382.8 / 5042.7 | 5192.7 / 7753.9 |
| MLP down | 219.7 / 1977.6 | 241.8 / 1996.7 | 328.8 / 2285.1 | 811.6 / 2792.2 | 3218.7 / 5219.2 |
| GDN QKVZ | 237.3 / 1937.4 | 269.6 / 1947.6 | 315.7 / 2006.7 | 768.0 / 2677.6 | 2631.4 / 3981.5 |
| GDN B/A | 13.2 / 104.4 | 16.7 / 106.5 | 26.0 / 110.4 | 70.7 / 154.7 | 210.2 / 271.2 |
| Attention QKV | 194.3 / 1634.6 | 190.5 / 1644.0 | 258.0 / 1706.1 | 615.0 / 2371.3 | 2364.6 / 3624.9 |
| Attention output | 77.9 / 993.1 | 79.6 / 1013.6 | 130.6 / 1123.4 | 300.2 / 1703.8 | 1200.2 / 2916.3 |

[Raw timings, configurations, and held-out samples](results/qwen38-27b-quark-vllm-gfx1151.json)

To reproduce, run the fetcher from the repository root. Run the benchmark in the ROCm environment with the fork and FlyDSL 0.4.1 on the Python import path.

```bash
experiment=experiments/mxfp4-w4a16-optimization
python "$experiment/fetch_qwen38_quark_linears.py" /tmp/qwen38-quark-weights
BENCHMARK_VLLM_REVISION=5b5b371e3217550c79da02b8dd8bd3f1e3859324 \
  python "$experiment/benchmark_qwen38_vllm.py" --weights /tmp/qwen38-quark-weights \
  --out /tmp/qwen38-quark-paired.json --search staged
```

Pass `--configs-from` with a completed report to replay its selected schedules.

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
