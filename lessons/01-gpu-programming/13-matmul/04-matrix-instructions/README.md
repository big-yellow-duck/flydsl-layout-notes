# 04 · Multiply a tile with a BF16 matrix instruction

The [LDS kernel](../03-shared-memory/README.md) shares inputs but still computes scalar multiply-adds. A wave matrix multiply-accumulate instruction (WMMA) lets a group of lanes cooperate on a matrix tile. Keep **M=N=K=1024**, BF16 inputs/output, FP32 accumulation, and the same 16×16 LDS staging tiles. Replace the scalar computation with a 16×16×16 BF16 WMMA operation.

This lesson targets the gfx11 wave32 convention used by **gfx1151 and gfx1152**. It was executed on gfx1151; gfx1152 is an intended target that has not yet been hardware-validated for these new lessons. Other instruction families and fragment conventions require their own checks.

![Wave32 WMMA operand views and output ownership; lane 1 owns the even rows of column 1 and lane 17 owns the odd rows.](../../../../assets/01-gpu-programming/13-matmul/04-matrix-instructions/wave-fragments.svg)

The instruction shape is `(M_atom,N_atom,K_atom)=(16,16,16)`, not the full matrix shape. A 64×64 grid of blocks still covers the full output, and each block accumulates across 64 K tiles. Each block now launches one wave of 32 threads. All lanes execute each WMMA collectively.

## Keep physical B storage, change its operand view

A is an `(M,K)` operand, but the MMA API names B's modes `(N,K)`. Physical B remains row-major `(K,N)`. For one LDS tile:

```python
a_tile = fx.make_view(fx.get_iter(shared_a), fx.make_layout((16, 16), (16, 1)))
b_tile = fx.make_view(fx.get_iter(shared_b), fx.make_layout((16, 16), (1, 16)))
```

For B's logical `(n,k)=(1,2)`, the second layout gives element offset `1 + 2*16 = 33`, the stored value at physical `(k,n)=(2,1)`. A view permutation does not allocate a transposed buffer or change the public operation from `A @ B`.

The output view uses global row stride 1024. `fx.zipped_divide(c_view,(16,16))` exposes local and block coordinates; slicing `(block_y,block_x)` selects the output tile while retaining its global row stride. The selected view carries the base offset once.

## Build the instruction and its thread slice

```python
atom = fx.make_mma_atom(fx.rocdl.WMMA(16, 16, 16, fx.BFloat16, fx.Float32))
mma = fx.make_tiled_mma(atom, fx.make_layout((1, 1, 1), (0, 0, 0)))
thread_mma = mma.thr_slice(tid)
```

The single-atom layout adds no wave repetitions along M, N, or K. `make_fragment_A/B/C` allocates registers in the operation's required layouts. A/B fragments contain 16 BF16 values per lane in the gfx11 convention. Lanes 16–31 replicate the inputs of lanes 0–15. This is an instruction requirement, not duplicate output work.

The output layout has eight FP32 accumulator slots per lane. Local `column = lane % 16`, `row = 2*slot + lane//16`. Lane 1 owns rows 0,2,…,14 at column 1; lane 17 owns rows 1,3,…,15 at column 1. All 256 outputs still have one writer. These rules differ from the four adjacent rows per thread in lesson 03.

## Copy according to the instruction's ownership

`fx.make_tiled_copy_A/B/C` derives copies compatible with the MMA layout. `partition_S` names a thread's input positions; `retile` presents its register fragment through the same copy plan. The supplied 16-bit `UniversalCopy` loads from LDS into BF16 register fragments. Do not substitute a hand-written four-row ownership rule here.

The 32 threads stage eight positions per operand, `tid + slot*32`, before the first barrier. Copies then populate the instruction operands. The accumulation step is:

```python
fx.gemm(atom, accumulators, fragment_a, fragment_b, accumulators)
```

This performs the current 16-wide K update. Accumulators are initialized only once, before the 64-iteration K-tile loop, and remain FP32 throughout. Both barriers remain in the staging loop. At the end, the supplied eight-slot conversion makes a BF16 result fragment; the C copy writes it through the output tile view.

## Verify the compiled instruction

From the repository root:

```bash
FLYDSL_DUMP_IR=1 FLYDSL_DUMP_DIR=/tmp/flydsl-matmul-wmma \
  pixi run python lessons/01-gpu-programming/13-matmul/04-matrix-instructions/solution.py
rg 'v_wmma' /tmp/flydsl-matmul-wmma -g '*.s'
```

On gfx1151 with FlyDSL 0.4.1, final assembly contains `v_wmma_f32_16x16x16_bf16`, with LDS load/store instructions around the operand staging. This establishes that a matrix instruction was emitted. It does not establish a speedup or a win over a BLAS library. See the [series benchmark](../README.md#compare-the-stages) for the fixed-size comparison.

TODO 1 is `b_tile`, including the `(N,K)` stride convention; TODO 2 is `atom`, specifying BF16 input and FP32 accumulation. Fragment copying, accumulation, conversion, and stores are supplied.

## Practice and checkpoint

Complete the two numbered expressions in `practice.py`. Keep the supplied launch, initialization, stores, and checker. The unfinished starter reports `Practice not finished: ...` and exits with status 1.

Every exercise runs **M = N = K = 1024**: row-major BF16 inputs, FP32 accumulation, and BF16 output. The checker evaluates all 1,048,576 outputs for two input patterns. The trace pattern uses `A[r,k] = ((r*1024+k) % 5)-2` and `B[k,c] = ((k*1024+c) % 7)-3`; the first four values of output row 0 are `[3, -6, -1, -3]`. A second pattern uses seeded random values quantized to BF16 before either implementation sees them. An independent CPU FP32 matrix product, rounded to BF16, supplies the untimed reference. Trace checks use `rtol=0, atol=0.001` to accommodate the small WMMA residue near zero; random checks use `rtol=0.016, atol=0.03125` for BF16 rounding and accumulation differences. These are exercise tolerances, not a numerical guarantee for arbitrary inputs.

Sixteen output sentinels must remain unchanged. Output data starts as NaN, so incomplete writes fail the reference comparison. The sentinel checks writes; full-tile dimension constraints make all input reads in these programs valid. No tails are implemented here.

**Check yourself:** Do replicated A/B fragments mean every output is computed and stored twice?

<details><summary>Answer</summary>

No. Replicated inputs satisfy the gfx11 instruction convention. C ownership is injective: lane 1 and lane 17 own different row parities, with eight accumulator slots each. The result copy uses that C ownership.

</details>

Run from the repository root:

```bash
pixi run python lessons/01-gpu-programming/13-matmul/04-matrix-instructions/practice.py
pixi run python lessons/01-gpu-programming/13-matmul/04-matrix-instructions/solution.py
```

A completed practice prints `Exercise passed:` with `shapes_MNK: [(1024, 1024, 1024)]`, two patterns, and the first-four checkpoint. Compare your implementation with the [worked solution](solution.py).

[Previous](../03-shared-memory/README.md) · [Matmul series](../README.md) · [Next steps](../../../../ROADMAP.md#matmul-continuation-planned)

Sources: [FlyDSL 0.4.1 kernel guide](https://github.com/ROCm/FlyDSL/blob/888d7d80528f0cf2abab8a86610d5ccca47f205d/docs/kernel_authoring_guide.md), [gfx11 WMMA tests and fragment convention](https://github.com/ROCm/FlyDSL/blob/888d7d80528f0cf2abab8a86610d5ccca47f205d/tests/kernels/test_rdna3_wmma_atom.py). API expressions were checked against the installed 0.4.1 package.
