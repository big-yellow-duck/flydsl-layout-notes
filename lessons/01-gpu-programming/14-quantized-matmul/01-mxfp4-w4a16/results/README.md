# MXFP4 W4A16 results

## Register lookup decode

Two `perm_b32` lookups produce eight doubled E2M1 magnitudes. The fused stage applies the corresponding E8M0 power with `ldexp` and restores the sign from each nibble. The decoder matches the CPU BF16 result for all 4,096 code-and-scale pairs in every slot of an eight-value chunk. [Comparison and raw samples](lookup-decode.json)

The installed decoder ran against the previous arithmetic decoder and Torch emulation at matched geometry on Radeon 8060S. The table reports the median GPU-event time across three rounds with 32 GEMMs per replay. Torch starts with the same packed weights and includes decoding them. The lookup improved every workload in all three paired rounds.

| M × N × K | Previous fused ms | Lookup ms / TFLOP/s | Torch emulation ms / TFLOP/s | Latency reduction |
| --- | ---: | ---: | ---: | ---: |
| 16 × 1024 × 8192 | 0.047054 | 0.032230 / 8.329 | 0.090377 / 2.970 | 31.5% |
| 32 × 1024 × 8192 | 0.053746 | 0.038415 / 13.976 | 0.123967 / 4.331 | 28.5% |
| 16 × 4096 × 8192 | 0.126987 | 0.087509 / 12.270 | 0.769876 / 1.395 | 31.1% |
| 17 × 77 × 46 | 0.002832 | 0.002577 / 0.047 | 0.005704 / 0.021 | 9.0% |
| 17 × 1046 × 8214 | 0.073610 | 0.054124 / 5.397 | 0.116158 / 2.515 | 26.5% |
| 31 × 1025 × 8193 | 0.078208 | 0.057764 / 9.014 | 0.130227 / 3.998 | 26.1% |
| 1030 × 1046 × 1022 | 0.100319 | 0.088557 / 24.867 | 0.101237 / 21.753 | 11.7% |

The illustrated `16×64×32` group tile emits narrow packed and scale loads, wide BF16 A loads, `v_perm_b32` and `v_ldexp_f32` for the lookup decoder, and BF16 WMMA. It uses 4,096 bytes of LDS and zero private scratch. [Trace ISA summary](trace-isa.json)

```bash
pixi run python lessons/01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16/tune.py \
  --verify-only --output /tmp/mxfp4-lookup.json
```

## Mixed-width fused kernel on gfx1151

This comparison records the arithmetic decoder before the register lookup.

The search considered 325 geometry and schedule candidates across seven workloads on Radeon 8060S `gfx1151` with FlyDSL 0.4.1, PyTorch 2.13.0+rocm10.1.0, and HIP 7.16.26385. Eleven candidates failed copy-geometry validation. The other 314 passed the CPU comparison and changed-input replay. After adding the grouped wide path for odd N, 24 finalists were retimed with the current kernel. [Original tuning search](mixed-width-tuning.json)

The comparison below retimes the installed configs. FlyDSL and Torch both start from the same BF16 activations, packed MXFP4 weights, and E8M0 scales. TorchInductor compiles a GPU decoder that writes BF16 weights for `torch.matmul` on each replay. The Torch timing includes both stages. Lesson 15 gives a separate predecoded BF16 reference, and the prior fused baseline uses the original lesson-12-based source on the same GPU and inputs. [Matched emulation results and raw samples](torch-emulation.json)

GPU-event timing uses three seeds, seven shuffled batches, ten replays per batch, and 32 GEMMs per replay. The table reports the median of the three round medians. Effective throughput uses `2 * M * N * K`. Offline encoding, compilation, and graph capture are outside timing.

| M × N × K | Fused MXFP4 ms / TFLOP/s | Torch MXFP4 emulation ms / TFLOP/s | Lesson 15 BF16 ms / TFLOP/s | Prior fused ms | Speedup over Torch |
| --- | ---: | ---: | ---: | ---: | ---: |
| 16 × 1024 × 8192 | 0.047021 / 5.709 | 0.090103 / 2.979 | 0.022066 / 12.165 | 0.059287 | 1.92× |
| 32 × 1024 × 8192 | 0.053777 / 9.983 | 0.123762 / 4.338 | 0.035546 / 15.104 | 0.073671 | 2.30× |
| 16 × 4096 × 8192 | 0.127066 / 8.450 | 0.773024 / 1.389 | 0.363835 / 2.951 | 0.366079 | 6.08× |
| 17 × 77 × 46 | 0.002842 / 0.042 | 0.005724 / 0.021 | 0.003646 / 0.033 | — | 2.01× |
| 17 × 1046 × 8214 | 0.073645 / 3.967 | 0.115879 / 2.521 | 0.031195 / 9.364 | — | 1.57× |
| 31 × 1025 × 8193 | 0.077411 / 6.726 | 0.130799 / 3.981 | 0.033624 / 15.485 | — | 1.69× |
| 1030 × 1046 × 1022 | 0.100685 / 21.872 | 0.101879 / 21.615 | 0.074721 / 29.472 | — | 1.01× |

Fused MXFP4 leads Torch emulation on all seven shapes in all three paired rounds. The near-square case is within about 1–2%. The grouped wide path reduced the long odd workload from about 0.110 to 0.081 ms at matched geometry before the last round of configuration tuning. [Matched odd-load experiment](mixed-width-tuning.json)

```bash
git show b3274c6:lessons/01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16/solution.py > /tmp/mxfp4-prior.py
pixi run python lessons/01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16/tune.py \
  --verify-only --legacy-source /tmp/mxfp4-prior.py --output /tmp/mxfp4-emulation.json
```

## Historical fused kernel on gfx1152

The fused lesson implementation was measured on AMD Radeon 860M Graphics (`gfx1152`), FlyDSL 0.4.1, PyTorch 2.13.0+rocm10.1.0, and HIP 7.16.26385. The fused kernel decodes MXFP4 B tiles into BF16 LDS and uses gfx1152 BF16 WMMA; it does not issue native MXFP4 matrix instructions.

### Tuned comparison

The tuner checked five, six, and five valid configurations for the three shapes. Each candidate passed the CPU-reference check before timing. The selected configurations use split-K values 4, 4, and 1, with K unrolls 2, 2, and 4. The final comparison uses seven batches of twenty replays of a captured graph containing eight GEMMs. GPU events measure milliseconds per GEMM.

| Shape M×N×K | Candidates | Fused decode + WMMA | Register unpack + WMMA | Scalar unpack + WMMA | Torch dense BF16 | Fused / Torch |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 16×1024×8192 | 5 | 0.184 ms | 0.432 ms | 0.702 ms | 0.257 ms | 0.716× |
| 32×1024×8192 | 6 | 0.270 ms | 0.439 ms | 0.620 ms | 0.282 ms | 0.956× |
| 16×4096×8192 | 5 | 0.722 ms | 1.553 ms | 2.296 ms | 1.051 ms | 0.686× |

The fused path reduces latency by **57.5%, 38.4%, and 53.5%** versus the separate register-unpack pipeline at these selected configs. It is 2.35×, 1.62×, and 2.15× faster, respectively. Against the scalar reference pipeline, the reductions are 73.8%, 56.4%, and 68.6%. The fused path is about 28% faster than Torch for `(16,1024,8192)`, about 4% faster for `(32,1024,8192)`, and about 31% faster for the wide-N case.

Torch receives BF16 weights decoded once from the same packed input; its timing excludes decode. Fused FlyDSL timing includes loading packed B, decoding and staging it into LDS, and running WMMA. Register and scalar FlyDSL reference timings include the standalone decoder plus the lesson-12 BF16 matrix path. This comparison reports these tested shapes on gfx1152 and does not claim native MXFP4 performance.

The complete candidate samples, selected configs, and final graph replay data are in [the integrated tuning report](gfx1152-20261117-fused/tuning.json). The original [scalar-unpack sweep](gfx1152-20261117/tuning.json) and [register-unpack sweep](gfx1152-20261117-register-unpack/tuning.json) remain as historical results from before fusion.

### What changed

The previous pipeline wrote and reread a full dense BF16 B matrix. The fused solution writes only each tile's decoded BF16 values to LDS before WMMA consumes it. For `(16,1024,8192)`, profiler-guided scratch runs showed about 168k combined external 128-byte read requests for separate unpack and GEMM versus about 40k for fused execution. Those are instrumented counter results, not elapsed time. The direct E2M1-to-BF16 mapping alone did not improve performance; eliminating the full dense intermediate did.

The source weights retain their compact representation: each 32-value block per output column uses 16 packed data bytes plus one scale byte, about 3.76× smaller than BF16. Split-K partials are still allocated for the first two selected configurations. Additional profiler traces and experiments are in [the separate optimization directory](../../../../../experiments/mxfp4-w4a16-optimization/README.md).

The solution checks its standalone register decoder exactly against the CPU BF16 decode, then checks fused outputs against an independent CPU FP32 product and verifies output sentinels. The fused edge checker also covers all 16 E2M1 codes across 243 finite E8M0 scales. Full profiler and tuning methods are documented with the [experiment artifacts](../../../../../experiments/mxfp4-w4a16-optimization/README.md).
