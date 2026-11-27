# 14.1.2 · Decode one weight per thread and call BF16 matmul

Build W4A16 with two GPU launches. First expand packed B into a contiguous BF16 matrix with a scalar FlyDSL kernel. Then call `matmul_bf16` with BF16 A and the decoded B. The exercise uses the stage 15 LDS route exposed by stage 16. This keeps the familiar mixed-width loads, BF16 WMMA, and FP32 accumulation in the matmul. [MXFP4 format](../01-mxfp4-format/README.md) · [Stage 15 · Mixed-width edge loads](../../../13-matmul/15-edge-load-widths/README.md)

## Follow one thread

Keep the `(33,3)` B and scale rows from the format lesson. The exercise cycles the raw codes `0x0` through `0xf` in flat order. Each block has 64 threads, and each thread owns one weight at `flat_index = block_id * 64 + thread_id`. Two blocks cover the 99 weights. Threads with `flat_index >= 99` skip both input reads and the output store.

![Block 1, thread 33 decodes B[32,1] from the high nibble of packed byte 48 and scale byte 126 at scales[1,1]. It writes BF16 0.25.](../../../../../assets/01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16/02-scalar-dequant/scalar-decode.svg)

Follow block 1, thread 33. It gets flat index `97` and dense coordinate `(97 // 3, 97 % 3) = (32,1)`. Index `97` is odd, so shift packed byte `48` right by four bits. That byte holds `0x10`, with the code for `B[32,0]` in its low nibble and `B[32,1]` in its high nibble.

The kernel works from the E2M1 fields directly. If the exponent is zero, the magnitude is half the mantissa bit. Otherwise it is `(1 + mantissa / 2) × 2^(exponent − 1)`. Apply the sign, then read the byte at `b_scales[row // 32, column]`. Widen it from unsigned 8 bits to signed 32 bits so that subtracting 127 can produce a negative exponent. `ldexp(value, b_scale_byte - 127)` multiplies the decoded value by that power of two. The code `0x1` gives `0.5`, the scale byte `126` gives a factor of `0.5`, and the kernel stores `0.25` at `B[32,1]`. If the scale byte is `255`, the kernel stores NaN.

## Pass dense B to BF16 matmul

The complete program uses these two calls in `solve()`. The launches share the current GPU stream, so the matmul reads B after the decode finishes.

```python
b_bf16 = dequantize_mxfp4(b_packed.cuda(), b_scales.cuda(), k)
c = matmul_bf16(a.cuda(), b_bf16)
```

The decoder takes the exact K from the caller. The scale shape gives the number of K blocks, and the byte count may include a spare nibble. The matmul infers its dimensions from the two dense matrices.

The scalar launch writes one BF16 value for each logical weight. This two-launch path is the control for the fused K-tail timings. [Matched timings](../../results/README.md#masking-the-quantized-k-tail)

A has shape `(2,33)`. Its first row has a single one at K coordinate 32, so the first row of C copies the three weights at `B[32,:]`. Its second row has ones at K coordinates 31 and 32, so the second output row adds those two B rows across the scale boundary. For column 1, that gives `C[1,1] = −4 + 0.25 = −3.75`.

The decoder writes the full BF16 B to global memory, where the BF16 matmul reads it back. The next sub-lesson moves decode into the B staging step and keeps the expanded weights in each workgroup's LDS tile.

The teaching shape uses 64 threads per block. For the seven benchmark shapes, the launcher selects the measured 32-thread block size. To reproduce the tuned two-launch timings, pass the corresponding `selected.separate.config` fields to stage 15's `Config` and supply it to `matmul_bf16`. [Sweep results](../results/README.md#scalar-fused-arithmetic-and-fused-lut-sweep)

## Practice

Fill the three expressions in [practice.py](practice.py).

1. `nibble` shifts the selected packed byte by zero or four bits and keeps the low four bits. Use `flat_index` to choose the shift.
2. `b_scale_row` selects the 32-row block containing `row`.
3. `power` removes the exponent bias from `b_scale_byte`.

The expected checkpoint is **`B[32, 1] = 0.25`** and **`C = [[0.0, 0.25, 0.25], [-6.0, -3.75, -2.75]]`**. The checker compares all 99 decoded weights and all six outputs with a CPU reference. It also checks all 4,096 code and scale pairs, including signed zero and NaN scales. [Worked solution](solution.py)

## Revision question

Why does the shift use `flat_index % 2` for `B[1,0]`?

<details><summary>Answer</summary>

With three columns, `B[1,0]` has flat index 3. It takes the high nibble of byte 1. Column index 0 would select the low nibble, which belongs to `B[0,2]`.

</details>

Run from the repository root. The starter reports `Practice not finished` until all three expressions are filled.

```bash
pixi run python lessons/01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16/02-scalar-dequant/practice.py
pixi run python lessons/01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16/02-scalar-dequant/solution.py
```

[Previous · Read an MXFP4 weight](../01-mxfp4-format/README.md) · [MXFP4 W4A16](../README.md) · [Next · Fuse decode into staging](../03-fused-staging/README.md)

The follow-on BF16 multiply uses its LDS route in this walkthrough. Stage 16 compares both B routes, including separate-decode timings that include both GPU launches. [BF16 stage 16](../../../13-matmul/16-right-register-staging/README.md)
