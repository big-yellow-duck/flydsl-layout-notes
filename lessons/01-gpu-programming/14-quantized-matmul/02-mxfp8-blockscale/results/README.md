# MXFP8 block-scale matmul results

## Subnormal lookup decode

An eight-entry table supplies exact FP16 bits for the E4M3 subnormals. The decoder constructs normal values directly, applies E8M0 in FP32, and rounds to BF16. Every code-and-scale pair matched the CPU in each slot. [Comparison and raw samples](lookup-decode.json)

These GPU-event medians compare the installed decoder with the previous decoder and Torch emulation at matched geometry on Radeon 8060S. The two skinny shapes and `512³` improved in all three rounds. The tiny shape stayed near parity.

| M × N × K | Previous fused ms | Lookup ms / TFLOP/s | Torch emulation ms / TFLOP/s | Latency reduction |
| --- | ---: | ---: | ---: | ---: |
| 17 × 77 × 46 | 0.003155 | 0.003135 / 0.038 | 0.007548 / 0.016 | 0.6% |
| 32 × 1024 × 8192 | 0.078200 | 0.077319 / 6.944 | 0.128514 / 4.178 | 1.1% |
| 31 × 1025 × 8193 | 0.099993 | 0.098551 / 5.283 | 0.138577 / 3.757 | 1.4% |
| 512 × 512 × 512 | 0.026817 | 0.026497 / 10.131 | 0.023586 / 11.381 | 1.2% |

```bash
pixi run python lessons/01-gpu-programming/14-quantized-matmul/02-mxfp8-blockscale/tune.py \
  --verify-only --output /tmp/mxfp8-lookup.json
```

The illustrated `16×64×32` group tile compiles to 64-, 32-, 16-, and 8-bit buffer load sites, `v_perm_b32` for the subnormal lookup, and BF16 WMMA. It uses 5,376 bytes of LDS and zero private scratch. [Trace ISA summary](trace-isa.json)

## Torch comparison before the lookup

Radeon 8060S `gfx1151` ran the fused kernel with FlyDSL 0.4.1, PyTorch 2.13.0+rocm10.1.0, and HIP 7.16.26385. Of 110 configurations considered, 101 passed geometry validation, the CPU comparison, and changed-input replay. The tuner screens on seed 17 and reranks on seed 37. [Original tuning search](tuning.json)

The installed configurations were retimed against Torch MXFP8 emulation on seeds 5101, 5202, and 5303. Both paths begin with the same E4M3FN byte tensors and E8M0 scales. TorchInductor decodes both operands to BF16, then `torch.matmul` consumes the decoded matrices. The Torch timing includes both conversions and the multiply. Lesson 15 gives a predecoded BF16 reference. All paths use preallocated output. [Matched emulation results and raw samples](torch-emulation.json)

GPU-event timing uses seven shuffled batches, ten replays per batch, and 32 GEMMs per replay. Each row reports the median of the three round medians and effective throughput using `2 * M * N * K`.

| M × N × K | Fused MXFP8 ms / TFLOP/s | Torch MXFP8 emulation ms / TFLOP/s | Lesson 15 BF16 ms / TFLOP/s | Torch / FlyDSL time |
| --- | ---: | ---: | ---: | ---: |
| 17 × 77 × 46 | 0.003131 / 0.038 | 0.007520 / 0.016 | 0.003602 / 0.033 | 2.40× |
| 32 × 1024 × 8192 | 0.078149 / 6.870 | 0.128364 / 4.182 | 0.035323 / 15.199 | 1.64× |
| 31 × 1025 × 8193 | 0.099821 / 5.216 | 0.138383 / 3.762 | 0.034036 / 15.298 | 1.39× |
| 512 × 512 × 512 | 0.026715 / 10.048 | 0.024286 / 11.053 | 0.010619 / 25.278 | 0.91× |

Fused MXFP8 leads on the tiny and two skinny workloads in all three rounds. Torch emulation takes about 9% less time on `512³`. The long odd workload uses a `32×128×32` group tile, four cooperating N waves, and split-K 4. The original tuning search found a 74% reduction from its initial FP8 configuration.

## Profile the square workload

Before the subnormal lookup, `rocprofv3` collected separate trace and counter passes on Radeon 8060S. Each pass measured eight warmed calls per path. The BF16 control uses the same `64×64×32` group tile, four waves per group, and split-K 2. Both kernels have 512 dispatched waves and use 9,216 bytes of LDS. The Torch trace shows two decode kernels followed by the BF16 GEMM. [Profiler summary and graph samples](profile-square.json)

| Per-dispatch median | Fused MXFP8 | Matched BF16 |
| --- | ---: | ---: |
| Vector ALU instructions | 2,906,617 | 148,981 |
| LDS instructions | 311,296 | 311,296 |
| External 128-byte read requests | 4,439.5 | 10,517 |
| VGPRs / scratch bytes | 120 / 0 | 96 / 0 |

The extra vector work points to decoding and scaling inside each output tile. On this geometry, each A tile feeds eight N tiles and each B tile feeds eight M tiles. The fused path repeats the decode for those output tiles, while Torch decodes each operand once per GEMM. Reusing decoded values across more outputs targets that cost.

Two decoder prototypes replaced the scale calculation with `ldexp`; the second also used subtraction to decode E4M3FN subnormals. Both matched the CPU for all 65,536 code-and-scale pairs. In a separate three-seed graph comparison, the square took 0.02678 ms with the lesson decoder, 0.02753 ms with `ldexp`, and 0.02788 ms with both changes. The combined prototype took 0.09655 ms for `31×1025×8193` versus 0.10037 ms for the lesson decoder, about 3.8% less time. It increased the aligned skinny time from 0.07831 to 0.08275 ms. [Matched prototype samples](profile-square.json)

```bash
pixi run python lessons/01-gpu-programming/14-quantized-matmul/02-mxfp8-blockscale/profile_mxfp8.py \
  --output /tmp/mxfp8-square-profile
```
