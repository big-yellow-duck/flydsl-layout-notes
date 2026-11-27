# BF16 MoE measurements on gfx1151

Measured on the Radeon 8060S with FlyDSL 0.4.1, ROCm SDK 10.1.0 and PyTorch 2.13.0+rocm10.1.0. The harness warms and checks each implementation, captures six MoE invocations per graph, and shuffles the timing order in each round. The graph check changes expert IDs in place and includes a replay with invalid routes. GPU events measure complete invocations including GPU worklist construction. Direct launches also include the gaps between Python enqueues on the measured stream.

The per-expert Torch control uses BF16 GEMMs with FP32 output and the lesson's rounding points. It builds the fixed expert index plan before timing. Weight initialization, compilation, reference checks, and FlyDSL scratch allocation take place before timing.

## Decode and prefill

All rows use H=512, I=384, E=32 and top-2. Padding describes the fraction of unused rows in the default 16-row grouped tiles. Values are median graph-replay microseconds per MoE invocation.

| Tokens | Routing | Mean routes per active expert | Padding | Torch per expert | Naive | Grouped WMMA | Fused grouped | Fused auto |
| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | balanced | 1 | 94% | 60.57 | 48.16 | 28.44 | 26.52 | **13.26** |
| 8 | balanced | 1 | 94% | 382.23 | 48.63 | 43.71 | 41.52 | **29.18** |
| 64 | balanced | 4 | 75% | 959.46 | 174.75 | 146.46 | 137.64 | 141.09 |
| 256 | balanced | 16 | 0% | 1014.81 | 540.66 | 171.81 | 152.38 | 151.84 |
| 256 | skewed | 16 | 43% | 1023.37 | 432.27 | 180.93 | 164.78 | 164.59 |

At one token, eight K lanes per output column gave 13.31 µs versus 16.38 µs for direct WMMA. At eight tokens, two K lanes gave 29.11 µs versus 33.30 µs for direct WMMA. At 64 tokens, direct WMMA took 244.53 µs. The grouped layout reads an expert's weight tile once for several routes and amortizes its worklist.

The matched 256-token balanced case drops from 171.81 to 152.38 µs when SwiGLU and the routing weight move into the projection epilogues. The atomic variant took 149.15 µs while shrinking the down scratch by top-k. The slot reduction remains the default for its fixed summation order. Prefetch and wider tiles helped some small cases. The default 16×32×32 geometry held up on both 256-token cases. The skewed case showed similar times with and without expert-local M traversal at the default geometry. [Raw samples and direct-launch timings](gfx1151-sweep.json)

```bash
pixi run python lessons/01-gpu-programming/15-bf16-moe/benchmark.py \
  --tune --rounds 5 --iterations 12 --seed 31
```

## Wider projections

The H=1024, I=768, E=64, top-4 sweep changes the decode choice. With one token, direct WMMA took 36.11 µs, versus 47.40 µs for GEMV with two K lanes and 92.99 µs with eight. On a fresh seed the released automatic path took 36.02 µs and direct WMMA took 36.08 µs. At eight tokens the two paths measured 691.59 and 688.96 µs, with grouped WMMA at 702.20 µs. The width cutoff is a shape heuristic based on these measured regimes.

At 128 balanced tokens, fused grouped WMMA took 1.40 ms versus 10.53 ms for the naive path. At 192 skewed tokens it took 1.42 ms versus 4.02 ms. Prefetch with a 64-column tile reached 1.37 and 1.39 ms on those cases. [Wide sweep before selecting the width cutoff](gfx1151-wide-sweep.json) · [Wide decode verification using the final dispatch](gfx1151-wide-decode-verification.json)

## Individual GPU phases

Profiled 12 direct invocations at T=256, H=512, I=384, E=32 and balanced top-2. Values are median GPU kernel durations in microseconds under the profiler. The worklist column sums its four kernels per invocation. The atomic path also spent 1.80 µs clearing the FP32 output scratch.

| Variant | Worklist | Gate/up | Separate activation | Down | Finalize |
| --- | ---: | ---: | ---: | ---: | ---: |
| Grouped WMMA | 5.32 | 97.94 | 5.26 | 52.22 | 4.20 |
| Fused grouped | 5.68 | 91.60 | — | 48.86 | 3.48 |
| Fused atomic | 5.98 | 82.78 | — | 47.50 | 2.56 |

The trace shows seven kernels for fused group-and-reduce and eight for the separate activation path. Use the graph-replay table to compare end-to-end times. [Per-phase samples](gfx1151-phase-profile.json)

```bash
pixi run python lessons/01-gpu-programming/15-bf16-moe/benchmark.py \
  --case 256,512,32,384,2,balanced --only grouped fused-grouped fused-atomic \
  --rounds 2 --iterations 12 --trace /tmp/moe-traces
```

## vLLM Triton comparison

Both backends ran in `vllm/vllm-openai-rocm:v0.32.0` with FlyDSL 0.4.1 and the image's PyTorch 2.13.0+git733fca1. vLLM used its default Triton MoE configuration. Weight transposition was done before timing. The vLLM callback includes a copy from its returned tensor to the shared output buffer. It was checked using a looser tolerance for its different intermediate rounding.

| Tokens | Routing | FlyDSL fused auto, graph µs | vLLM Triton, graph µs | FlyDSL fused auto, direct µs | vLLM Triton, direct µs |
| ---: | --- | ---: | ---: | ---: | ---: |
| 1 | balanced | 13.40 | 20.41 | 219.65 | 150.78 |
| 8 | balanced | 29.56 | 67.45 | 225.03 | 169.47 |
| 64 | balanced | 166.87 | 255.80 | 379.31 | 283.38 |
| 256 | balanced | 157.19 | 292.17 | 379.91 | 316.09 |
| 256 | skewed | 167.50 | 271.74 | 378.19 | 296.98 |

The FlyDSL timings include its Python validation and launch overhead in direct mode. The same runs show lower FlyDSL latency during graph replay. [Raw samples](gfx1151-vllm-triton.json)

Run the following command in the image with FlyDSL 0.4.1 on the import path.

```bash
python lessons/01-gpu-programming/15-bf16-moe/benchmark.py --vllm \
  --only naive grouped fused-grouped fused-auto vllm-triton \
  --rounds 5 --iterations 16 --seed 43
```
