# 14.1 · MXFP4 W4A16 matmul

Start with [stage 15's BF16 matmul](../../13-matmul/15-edge-load-widths/README.md). Keep the activations in BF16 and change how weights are stored. MXFP4 uses a four-bit floating-point code for each weight and a shared scale for each group of 32 weights along K. Follow one weight through its code, its scale, and its use in a dot product.

| Sub-lesson | What to trace |
| --- | --- |
| [01 · Read an MXFP4 weight](01-mxfp4-format/README.md) | Build intuition for low precision. Find the levels four bits can represent, see how a shared scale changes their range, and pack two codes per byte. |
| [02 · Decode one weight per thread](02-scalar-dequant/README.md) | Write a simple GPU decoder, then pass its dense BF16 output to the matmul. |
| [03 · Fuse decode into staging](03-fused-staging/README.md) | Decode and scale weights in the mixed-width pipeline, then publish the BF16 B tile to LDS for WMMA. |
| [04 · Decode with a register lookup](04-lut-decode/README.md) | Replace per-weight magnitude arithmetic with two byte lookups per eight weights. Compare the three implementations on the GPU. |

[Previous · Mixed-width BF16 edge loads](../../13-matmul/15-edge-load-widths/README.md) · [Quantized matmul](../README.md) · [Next · Read an MXFP4 weight](01-mxfp4-format/README.md)
