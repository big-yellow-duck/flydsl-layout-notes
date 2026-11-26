# 14.3 · NVFP4 W4A16 matmul

Keep A in BF16 and store B as packed NVFP4. The weight nibbles are the same E2M1 codes used in MXFP4. The scale changes to one E4M3 byte per 16 weights and one FP32 multiplier for the entire weight tensor. This lesson places each 16-weight block along K in a column of B. The fused kernels decode to BF16 for WMMA on gfx1151 and gfx1152. [NVIDIA Transformer Engine NVFP4 format](https://docs.nvidia.com/deeplearning/transformer-engine/features/low_precision_training/nvfp4/nvfp4.html)

| Sub-lesson | What to trace |
| --- | --- |
| [01 · Read an NVFP4 weight](01-nvfp4-format/README.md) | Recover a weight from its E2M1 code, E4M3 block scale, and FP32 tensor scale. |
| [02 · Decode one weight per thread](02-scalar-dequant/README.md) | Expand the packed weights to dense BF16, then call the BF16 matmul. |
| [03 · Fuse arithmetic decode into staging](03-fused-staging/README.md) | Decode into the B tile in LDS and handle a scale change within a K stage. |
| [04 · Decode with a register lookup](04-lut-decode/README.md) | Use two register lookups for eight E2M1 magnitudes and keep the two scale multiplications. |
| [05 · Reuse decoded scales](05-scale-reuse/README.md) | Decode eight E4M3 scales per lane-owned slot and reuse them across its K rows. |

## Tune the fused stages

Choose settings by shape on the target GPU. The NVFP4 tuner searches both A and B staging routes, tile and wave geometry, K-stage depth, split-K, unroll, cache policy, and eligible group traversal. It searches the scale-reuse kernel first and remeasures leading configurations for arithmetic and LUT decode. The small-N pass starts from the Stage 16 geometries and adds LDS-A candidates. Use `--independent` to run the full search for every stage, `--beam 2` to refine more candidates per route, and `--small-n` to include the three Stage 16 shapes. [Verified selections](results/README.md)

```bash
pixi run python lessons/01-gpu-programming/14-quantized-matmul/03-nvfp4-w4a16/tune.py \
  --small-n --output /tmp/nvfp4-tuning.json
```

[Previous · MXFP8 block-scale matmul](../02-mxfp8-blockscale/README.md) · [Quantized matmul](../README.md) · [Start · Read an NVFP4 weight](01-nvfp4-format/README.md)
