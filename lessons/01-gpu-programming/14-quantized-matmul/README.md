# 14 · Quantized matrix multiplication

Start with the MXFP4 format and decode the weights into BF16 for the [stage 15 matmul](../13-matmul/15-edge-load-widths/README.md). Then fuse decoding into the mixed-width WMMA pipeline. The fused kernels prefetch compact operands, decode into BF16 tile storage, accumulate in FP32, and return BF16 output. The measured kernels use BF16 WMMA on gfx1151. The fused kernels use the [BF16 tuning configuration fields](../13-matmul/README.md#read-a-tuning-configuration) for tile geometry, staged K, and wave ownership.

| Lesson | What to trace |
| --- | --- |
| [01 · MXFP4 W4A16](01-mxfp4-w4a16/README.md) | Read the four-bit format, decode one weight per GPU thread, fuse arithmetic decode, then use a register lookup. |
| [02 · MXFP8 block-scale matmul](02-mxfp8-blockscale/README.md) | E4M3FN values on both operands. Follow the two E8M0 scale addresses for the same K coordinate. |
| [03 · NVFP4 W4A16](03-nvfp4-w4a16/README.md) | Decode 16-weight E4M3 blocks with a tensor-wide FP32 multiplier, then stage the weights with arithmetic, register lookup, and decoded-scale reuse. |

[Previous: BF16 matmul](../13-matmul/README.md) · [GPU programming](../README.md) · [Course overview](../../../README.md)

The fused launchers select a configuration for each tuned shape. `right_in_registers`
is one of the search dimensions alongside tile geometry, split-K, and cache policy.
The W4A16 search can also vary A staging. MXFP8 has a cooperative A path. Use
the measured shape default or pass an explicit config to compare alternatives on your
workload. [Why B registers can help](../13-matmul/16-right-register-staging/README.md#why-put-b-in-registers)

Each format's report shows its best verified timings for both B routes and the
configuration selected for each measured gfx1151 shape. [MXFP8 results](02-mxfp8-blockscale/results/README.md#shape-tuning-with-b-registers) · [NVFP4 results](03-nvfp4-w4a16/results/README.md)
