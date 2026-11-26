# 14 · Quantized matrix multiplication

Start with the MXFP4 format and decode the weights into BF16 for the [stage 15 matmul](../13-matmul/15-edge-load-widths/README.md). Then fuse decoding into the mixed-width WMMA pipeline. The fused kernels prefetch compact operands, decode into BF16 tile storage, accumulate in FP32, and return BF16 output. The measured kernels use BF16 WMMA on gfx1151. Both lessons use the [BF16 tuning configuration fields](../13-matmul/README.md#read-a-tuning-configuration) for tile geometry, staged K, and wave ownership.

| Lesson | What to trace |
| --- | --- |
| [01 · MXFP4 W4A16](01-mxfp4-w4a16/README.md) | Read the four-bit format, decode one weight per GPU thread, fuse arithmetic decode, then use a register lookup. |
| [02 · MXFP8 block-scale matmul](02-mxfp8-blockscale/README.md) | E4M3FN values on both operands. Follow the two E8M0 scale addresses for the same K coordinate. |

[Previous: BF16 matmul](../13-matmul/README.md) · [GPU programming](../README.md) · [Course overview](../../../README.md)
