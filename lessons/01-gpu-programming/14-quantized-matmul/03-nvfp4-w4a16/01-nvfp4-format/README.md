# 14.3.1 · Read an NVFP4 weight

NVFP4 represents a weight as an E2M1 value times an E4M3 block scale times an FP32 tensor scale. The block scale is shared by 16 elements. The tensor scale adjusts the range of the entire tensor so the smaller E4M3 scales can describe the ranges of individual blocks. [NVIDIA Transformer Engine NVFP4 format](https://docs.nvidia.com/deeplearning/transformer-engine/features/low_precision_training/nvfp4/nvfp4.html)

| E2M1 magnitude bits | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Magnitude | 0 | 0.5 | 1 | 1.5 | 2 | 3 | 4 | 6 |

The top bit adds the sign. E4M3 has its own exponent and mantissa, so the scale can be a value such as `1.5`. The combined scale in the example below is `1.5 × 0.5 = 0.75`. A weight near `0.78` can be quantized at that scale to E2M1 code `0x2` and recovered as `0.75`.

## Trace a scale boundary

The exercise stores B with shape `(K,N) = (17,9)`. Flatten the logical weight matrix in row-major order and put even indices in the low nibble of each byte. A block scale belongs to one column and up to 16 K rows. The scale tensor has shape `(2,9)`, and the tensor scale is `0.5`. This is the course's plain row-major layout for tracing on ROCm. NVIDIA's native kernels have their own scale layouts and also support a 2D weight scaling recipe. [NVIDIA block-scale conversion](https://docs.nvidia.com/deeplearning/cudnn/latest/operations/BlockScaling/nvfp4_block_scale_conversion)

![B[15,1] and B[16,1] both use E2M1 code 0x2. Their E4M3 scale bytes decode to 1 and 1.5, giving weights 0.5 and 0.75 with tensor scale 0.5.](../../../../../assets/01-gpu-programming/14-quantized-matmul/03-nvfp4-w4a16/01-nvfp4-format/scale-boundary.svg)

Follow column 1 across the K boundary. Rows 15 and 16 have the same E2M1 code, `0x2`, which means 1. Their E4M3 bytes are `0x38` and `0x3c`. Both have exponent field 7, giving a power of `2^(7 − 7) = 1`. The mantissa fields are 0 and 4, giving block multipliers `1 + 0/8 = 1` and `1 + 4/8 = 1.5`. After applying the tensor multiplier, the weights are `0.5` and `0.75`.

A full 16-weight block stores eight weight bytes and one scale byte. The tensor multiplier adds four bytes once. The exercise stores 153 weights in 77 packed bytes, 18 scale bytes, and one FP32 multiplier.

## Revision question

What happens to both recovered weights if the tensor scale doubles?

<details><summary>Answer</summary>

They become `1.0` and `1.5`. The nibbles and block scales stay the same, while each recovered value uses the new tensor multiplier.

</details>

[Previous · MXFP8 block-scale matmul](../../02-mxfp8-blockscale/README.md) · [NVFP4 W4A16](../README.md) · [Next · Decode one weight per thread](../02-scalar-dequant/README.md)
