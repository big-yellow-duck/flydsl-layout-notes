# 14 · Quantized matrix multiplication

This sequence studies how low-bit weights change the path into a matrix multiply. It keeps activations in BF16, accumulates in FP32, and returns BF16 output. Begin with [01 · MXFP4 W4A16](01-mxfp4-w4a16/README.md), which decodes packed OCP MXFP4 weights and then reuses the measured operand-specific WMMA path from [lesson 12](../13-matmul/12-operand-paths/README.md).

The first implementation targets gfx1151/gfx1152. Those GPUs run the BF16 WMMA kernel, so the lesson makes its MXFP4-to-BF16 conversion explicit as a preceding GPU kernel. This provides a portable correctness and measurement baseline for later hardware-specific MXFP4 instructions.

[Previous: BF16 matmul](../13-matmul/README.md) · [GPU programming](../README.md) · [Course overview](../../../README.md)
