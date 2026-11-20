# 14 · Quantized matrix multiplication

These lessons fuse low-bit decoding into the [mixed-width WMMA pipeline](../13-matmul/15-edge-load-widths/README.md). Both kernels prefetch compact operands, decode into BF16 tile storage, accumulate in FP32, and return BF16 output. The measured kernels use BF16 WMMA on gfx1151.

| Lesson | What to trace |
| --- | --- |
| [01 · MXFP4 W4A16](01-mxfp4-w4a16/README.md) | BF16 activations and packed E2M1 weights. Follow the nibble shift and the separate weight and scale byte limits. |
| [02 · MXFP8 block-scale matmul](02-mxfp8-blockscale/README.md) | E4M3FN values on both operands. Follow the two E8M0 scale addresses for the same K coordinate. |

[Previous: BF16 matmul](../13-matmul/README.md) · [GPU programming](../README.md) · [Course overview](../../../README.md)
