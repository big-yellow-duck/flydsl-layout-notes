# MXFP4 W4A16 results

## Tested setup

The fused lesson implementation was measured on AMD Radeon 860M Graphics (`gfx1152`), FlyDSL 0.4.1, PyTorch 2.13.0+rocm10.1.0, and HIP 7.16.26385. The fused kernel decodes MXFP4 B tiles into BF16 LDS and uses gfx1152 BF16 WMMA; it does not issue native MXFP4 matrix instructions.

## Tuned comparison

The tuner checked five, six, and five valid configurations for the three shapes. Each candidate passed the CPU-reference check before timing. The selected configurations use split-K values 4, 4, and 1, with K unrolls 2, 2, and 4. The final comparison uses seven batches of twenty replays of a captured graph containing eight GEMMs. GPU events measure milliseconds per GEMM.

| Shape M×N×K | Candidates | Fused decode + WMMA | Register unpack + WMMA | Scalar unpack + WMMA | Torch dense BF16 | Fused / Torch |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 16×1024×8192 | 5 | 0.184 ms | 0.432 ms | 0.702 ms | 0.257 ms | 0.716× |
| 32×1024×8192 | 6 | 0.270 ms | 0.439 ms | 0.620 ms | 0.282 ms | 0.956× |
| 16×4096×8192 | 5 | 0.722 ms | 1.553 ms | 2.296 ms | 1.051 ms | 0.686× |

The fused path reduces latency by **57.5%, 38.4%, and 53.5%** versus the separate register-unpack pipeline at these selected configs. It is 2.35×, 1.62×, and 2.15× faster, respectively. Against the scalar reference pipeline, the reductions are 73.8%, 56.4%, and 68.6%. The fused path is about 28% faster than Torch for `(16,1024,8192)`, about 4% faster for `(32,1024,8192)`, and about 31% faster for the wide-N case.

Torch receives BF16 weights decoded once from the same packed input; its timing excludes decode. Fused FlyDSL timing includes loading packed B, decoding and staging it into LDS, and running WMMA. Register and scalar FlyDSL reference timings include the standalone decoder plus the lesson-12 BF16 matrix path. This comparison reports these tested shapes on gfx1152 and does not claim native MXFP4 performance.

The complete candidate samples, selected configs, and final graph replay data are in [the integrated tuning report](gfx1152-20261117-fused/tuning.json). The original [scalar-unpack sweep](gfx1152-20261117/tuning.json) and [register-unpack sweep](gfx1152-20261117-register-unpack/tuning.json) remain as historical results from before fusion.

## What changed

The previous pipeline wrote and reread a full dense BF16 B matrix. The fused solution writes only each tile's decoded BF16 values to LDS before WMMA consumes it. For `(16,1024,8192)`, profiler-guided scratch runs showed about 168k combined external 128-byte read requests for separate unpack and GEMM versus about 40k for fused execution. Those are instrumented counter results, not elapsed time. The direct E2M1-to-BF16 mapping alone did not improve performance; eliminating the full dense intermediate did.

The source weights retain their compact representation: each 32-value block per output column uses 16 packed data bytes plus one scale byte, about 3.76× smaller than BF16. Split-K partials are still allocated for the first two selected configurations. Additional profiler traces and experiments are in [the separate optimization directory](../../../../../experiments/mxfp4-w4a16-optimization/README.md).

The solution checks its standalone register decoder exactly against the CPU BF16 decode, then checks fused outputs against an independent CPU FP32 product and verifies output sentinels. The fused edge checker also covers all 16 E2M1 codes across 243 finite E8M0 scales. Full profiler and tuning methods are documented with the [experiment artifacts](../../../../../experiments/mxfp4-w4a16-optimization/README.md).
