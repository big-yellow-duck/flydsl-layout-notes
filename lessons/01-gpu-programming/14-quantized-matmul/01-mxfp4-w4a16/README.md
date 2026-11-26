# 14.1 · Fuse MXFP4 decode into W4A16 matmul

Keep A in BF16 and load B as packed MXFP4. Each lane prefetches B's codes and scales, expands them into a BF16 LDS tile, then feeds BF16 WMMA. [Mixed-width edge loads](../../13-matmul/15-edge-load-widths/README.md) supplies the A staging paths, edge guards, and split-K schedule. The only dense BF16 B tile in the fused path is local to the wave group.

## Trace the last five B values

Use `(M,N,K) = (17,77,46)` and `Config(stage_k=32, waves_per_group_n=1, split_k=4, k_unroll=2)` to follow the illustrated `16×64×32` group tile. The shape selector uses the measured benchmark default. A is contiguous BF16 with shape `(M,K)`. B's `(K,N)` values are packed in flat row-major order, with the even index in the low nibble. The scale matrix has shape `(ceil(K/32),N)`, with one E8M0 byte per output column for each group of 32 K values. The last K block keeps its scale row and stores only the actual weights. [OCP MX Formats](https://www.opencompute.org/documents/ocp-microscaling-formats-mx-v1-0-spec-final-pdf)

![The last five B values start on the high nibble of packed byte 1768 and use five E8M0 scale bytes from the second K block.](../../../../assets/01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16/mxfp4-w4a16.svg)

The last N group begins at 64. It contains a complete eight-value chunk at columns `64–71` and five values at columns `72–76`. Follow `B[45,72]` at flat element index `45 * 77 + 72 = 3537`. It starts on the high nibble of byte `1768`. A 16-bit load and an 8-bit load supply the three remaining packed bytes. Shifting by four bits brings the first valid code into the low nibble. The five E8M0 scales start at byte `1 * 77 + 72 = 149` and use a 32-bit load and an 8-bit load.

The low three bits of an E2M1 code map to `0, 0.5, 1, 1.5, 2, 3, 4, 6`. The top bit supplies the sign. Code `0xe` decodes to `−4`, and E8M0 byte `125` scales it by `2^(125−127) = 1/4`, giving `−1` in the first slot. Byte `255` supplies a NaN scale to its entire MX block.

## Carry the stage through WMMA

`load_nonempty_stage` prefetches the next A stage and calls `load_right_stage` for B's packed words and scales. For a complete eight-column chunk B needs four packed bytes, plus one byte for the final nibble when the row starts on a high nibble. Eight adjacent columns use eight different scale bytes. A lane reuses its scale word for the K rows it owns in the same 32-value MX block. The packed and scale descriptors each have their own physical byte limits. For odd N, a complete N group takes the wide path, and earlier MX blocks can stay wide while both buffers have a later row.

`publish_stage` looks up twice the E2M1 magnitude using the byte table `0, 1, 2, 3, 4, 6, 8, 12`. Two `perm_b32` operations handle the four even nibbles and four odd nibbles. Each slot takes its sign from the original nibble and applies `ldexp(doubled_magnitude, scale_byte - 128)`. The subtracted bias accounts for the factor of two in the table. The resulting BF16 vector goes to B's LDS tile with one 128-bit store.

`compute_stage` slices that tile into K=16 WMMA operands. A either uses the same padded LDS staging as lesson 15 or goes straight into WMMA-owned registers. A's partial K stage uses the mixed-width BF16 copies. Missing split-K stages load zeros, and C's store masks columns past N. FP32 partials are reduced inside the kernel before BF16 output.

## Practice

Fill two expressions in `publish_stage` in [practice.py](practice.py).

1. `nibble` extracts one E2M1 code from the packed register word so the decoder can recover its sign.
2. `scale_byte` extracts the matching E8M0 byte from the scale word.

For `--shape 17 77 46`, the first four outputs are **`[0.34375, 3.921875, 9.875, 4.90625]`** and `C[16,76]` is `2.28125`. The checker compares every output against an independent CPU FP32 product with decoded BF16 B. The edge suite checks all seven suffix widths, short rows, both A routes, exact logical sizes with poisoned backing, nonfinite data, and split-K sentinels. [Worked solution](solution.py)

```bash
pixi run python lessons/01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16/practice.py --shape 17 77 46 --check-only
pixi run python lessons/01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16/solution.py --shape 17 77 46 --check-only --edge-checks
pixi run python lessons/01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16/tune.py --output /tmp/mxfp4-tuning.json
```

## Measure fused decode

The tuner changes the packed weight signs during graph verification to check that every replay reads the current bytes. It searches tile sizes, waves, K depth, split count, A staging, unroll, and cache policy. Both FlyDSL and Torch start with the same BF16 activations, packed weights, and scale bytes. TorchInductor compiles the unpack and scale operations into a GPU decoder that feeds BF16 `torch.matmul` on every call. Both stages count toward the Torch timing. Lesson 15's dense BF16 timing provides a separate reference. [Per-shape timings and raw samples](results/README.md)

The register-unpack control retains the packed `perm_b32` lookup adapted from FlyDSL. [FlyDSL PR #1374](https://github.com/ROCm/FlyDSL/pull/1374/files) · [Profiler archive](../../../../experiments/mxfp4-w4a16-optimization/README.md)

## Revision question

Why can the packed B load use three bytes for the five-value suffix, while its scales require five bytes?

<details><summary>Answer</summary>

The flat layout stores two E2M1 nibbles per byte, and the five values in this example begin at the high nibble of the first byte. Each value belongs to a different output column. The scale row is byte-addressed, with one E8M0 byte per column.

</details>

[Previous · Mixed-width BF16 edge loads](../../13-matmul/15-edge-load-widths/README.md) · [Quantized matmul](../README.md) · [Next · MXFP8 block-scale matmul](../02-mxfp8-blockscale/README.md)
