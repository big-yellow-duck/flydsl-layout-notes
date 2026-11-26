# Small-N B staging results

Measured on AMD Radeon 8060S Graphics with FlyDSL 0.4.1, PyTorch 2.13.0+rocm10.1.0, and HIP 7.16.26385. The matched pair uses a `16×16×32` tile, one wave, split-K 4, and unroll 2. The search tests five settings per route, varying K-stage depth, split count, M tile size, and unroll. A is held in registers for BF16 and the FP4 paths. MXFP8 uses A through LDS.

Each graph contains 16 matmuls with preallocated output. The scalar FP4 rows also include one dequantization into a preallocated BF16 B per matmul. Each candidate checks the full result, the output sentinel, and replay after flipping B's sign. The search chooses a finalist per route. The tables report medians from three verification rounds with seven shuffled batches of eight replays. Configuration fields, individual timings, and source hashes are in the raw archive. [Raw results](gfx1151-small-n.json)

On the single-column workload, tuned B registers reduce BF16 latency by 16.1% and MXFP4 LUT latency by 18.6%. The tuned BF16 routes both use a 64-row K stage. The tuned MXFP4 LUT register route chooses a 16-row K stage, and the matched 32-row comparison also favors registers. LDS wins all nine pairs on each of the two wider shapes. The direct gather remains an opt-in route.

## 16 × 1 × 4096

| Kernel | Matched LDS µs | Matched registers µs | Tuned LDS µs | Tuned registers µs | Tuned latency change |
| --- | ---: | ---: | ---: | ---: | ---: |
| BF16 | 8.132 | 8.228 | 7.627 | 6.396 | -16.1% |
| MXFP4 scalar + BF16 | 9.938 | 10.038 | 9.442 | 8.212 | -13.0% |
| MXFP4 arithmetic | 13.522 | 13.523 | 13.522 | 13.041 | -3.6% |
| MXFP4 LUT | 10.464 | 8.628 | 10.464 | 8.517 | -18.6% |
| MXFP8 | 18.424 | 27.183 | 17.767 | 27.183 | +53.0% |
| NVFP4 scalar + BF16 | 9.925 | 10.025 | 9.422 | 8.192 | -13.1% |
| NVFP4 arithmetic | 19.915 | 25.609 | 18.792 | 25.126 | +33.7% |
| NVFP4 LUT | 17.721 | 19.264 | 17.721 | 18.253 | +3.0% |
| NVFP4 scale reuse | 17.290 | 20.034 | 17.290 | 18.191 | +5.2% |

## 16 × 7 × 4097

| Kernel | Matched LDS µs | Matched registers µs | Tuned LDS µs | Tuned registers µs | Tuned latency change |
| --- | ---: | ---: | ---: | ---: | ---: |
| BF16 | 10.510 | 12.493 | 8.823 | 11.363 | +28.8% |
| MXFP4 scalar + BF16 | 12.567 | 14.556 | 10.896 | 13.429 | +23.2% |
| MXFP4 arithmetic | 20.795 | 42.681 | 18.947 | 40.947 | +116.1% |
| MXFP4 LUT | 17.598 | 30.439 | 16.209 | 27.931 | +72.3% |
| MXFP8 | 23.209 | 33.834 | 21.812 | 33.834 | +55.1% |
| NVFP4 scalar + BF16 | 12.612 | 14.592 | 10.939 | 13.467 | +23.1% |
| NVFP4 arithmetic | 27.779 | 41.523 | 27.362 | 37.280 | +36.2% |
| NVFP4 LUT | 25.142 | 35.897 | 24.093 | 34.457 | +43.0% |
| NVFP4 scale reuse | 25.615 | 33.797 | 22.998 | 33.634 | +46.2% |

## 128 × 16 × 4096

| Kernel | Matched LDS µs | Matched registers µs | Tuned LDS µs | Tuned registers µs | Tuned latency change |
| --- | ---: | ---: | ---: | ---: | ---: |
| BF16 | 6.819 | 6.984 | 6.124 | 6.722 | +9.8% |
| MXFP4 scalar + BF16 | 9.387 | 9.651 | 8.797 | 9.377 | +6.6% |
| MXFP4 arithmetic | 12.072 | 26.509 | 10.649 | 24.995 | +134.7% |
| MXFP4 LUT | 8.969 | 20.598 | 8.024 | 19.550 | +143.6% |
| MXFP8 | 15.464 | 20.505 | 14.456 | 19.077 | +32.0% |
| NVFP4 scalar + BF16 | 9.511 | 9.801 | 8.925 | 9.497 | +6.4% |
| NVFP4 arithmetic | 14.576 | 25.591 | 14.069 | 25.047 | +78.0% |
| NVFP4 LUT | 13.518 | 22.892 | 12.711 | 20.256 | +59.4% |
| NVFP4 scale reuse | 13.127 | 23.106 | 12.744 | 20.246 | +58.9% |

## Inspect the teaching shape

At `3×7×17` with A in registers, switching B from LDS to registers changes the compiler's LDS allocation from 512 bytes to zero. The static ISA contains 32 LDS load sites and two LDS store sites with B in LDS, and zero of each with B in registers. Both variants emit two WMMA sites and use zero private scratch. The direct route uses 59 VGPRs, up from 44 for the LDS route.

```bash
FLYDSL_DUMP_IR=1 FLYDSL_DUMP_DIR=/tmp/b-register-isa \
  pixi run python lessons/01-gpu-programming/13-matmul/16-right-register-staging/solution.py \
  --right-in-registers
```

Run the same command with a separate dump directory and `--no-right-in-registers` to compare the two `22_final_isa.s` files.

[Back · Stage B directly in WMMA registers](../README.md)
