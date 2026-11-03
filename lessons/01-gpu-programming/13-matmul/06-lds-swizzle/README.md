# 06 · Measure LDS bank conflicts before choosing a layout

Build on [stage 05's four-wave WMMA kernel](../05-matrix-instructions/README.md). Keep **M=N=K=1024**, BF16 inputs/output, FP32 accumulation, a **32×32×32** block tile, **128 threads**, and the MMA atom layout `(2,2,1):(1,2,0)`. Change only A's physical LDS placement. Does a native FlyDSL swizzle reduce bank conflicts, and does that make the whole kernel faster?

The [solution](solution.py) includes three compile-time `layout_mode` choices. The normal lesson CLI uses `"swizzle"`; the [profiling driver](profile.py) checks and measures all three:

| Mode | Logical A shape | Physical A element mapping | Total block LDS |
| --- | --- | --- | --- |
| `packed` | `(32,32)` | `e = row*32 + k` | 4096 bytes |
| `swizzle` | `(32,32)` | `e ^ ((e & 0x1c0) >> 3)`, starting from packed `e` | 4096 bytes |
| `padded` | `(32,32)` | `row*40 + k` | 4608 bytes |

B remains packed row-major in all modes. Global storage, staging thread/value ownership, MMA ownership, barriers, accumulator conversion, and output stores match stage 05. Changing the A layout affects both the cooperative LDS stores and the instruction-compatible operand reads.

![At fixed K=2, compare packed, swizzled, and padded A element offsets and four-byte bank indices for rows 0–7.](../../../../assets/01-gpu-programming/13-matmul/06-lds-swizzle/lds-bank-map.svg)

Read row 2 first: the same logical A element `(row,k)=(2,2)` uses packed element offset 66, swizzled offset 74, or padded offset 82. These numbers are storage offsets, not matrix values. The drawing sketches bank placement; the measured instruction access pattern determines actual conflicts.

## 1. Why row-major LDS can conflict

For this target's 32 four-byte banks, a byte address maps to `bank = (byte_address // 4) % 32`. A BF16 occupies two bytes, so a relative element offset `e` maps to `(e // 2) % 32`, up to the buffer base's bank rotation. A 32-element row occupies 64 bytes: at fixed K, adjacent rows alternate between two banks. By contrast, adjacent columns of packed B walk neighboring words.

A conflict involves different addresses served through the same bank in the same instruction service phase. Reads of the same word can broadcast; vector instructions have their own lane/address grouping. Counting duplicate bank numbers across an entire wave is therefore only an address sketch. Inspect the emitted loads and collect counters from the complete kernel, including staging writes, rather than declaring a conflict rate from one thread's stride.

## 2. Compose a native swizzle with A's element-offset layout

Inside the tracing-time `create_lds_views` helper, the swizzled path constructs:

```python
left_lds_base_layout = fx.make_layout((BLOCK_M, BLOCK_K), (BLOCK_K, 1))
swizzle = fx.static(fx.SwizzleType.get(3, 3, 3))
left_lds_layout = fx.make_composed_layout(swizzle, 0, left_lds_base_layout)
left_lds_view = lds.left.view(left_lds_layout)
```

`SwizzleType.get(B,M,S)` describes an XOR swizzle. Here `B=3` selects three bits, `M=3` leaves the lowest three bits unchanged, and `S=3` places the source bits three positions above the destination bits. The packed layout first computes an **element** offset. The composition then XORs offset bits 6–8 into bits 3–5:

```text
packed e      = row*32 + k
physical e    = e XOR ((e AND 0x1c0) >> 3)
byte offset   = physical e * 2
```

The standalone native [layout checker](layout_check.py) evaluates all 1024 coordinates, checks the XOR formula and permutation coverage, and verifies that all 128 eight-value chunks stay contiguous. Run it with `pixi run python lessons/01-gpu-programming/13-matmul/06-lds-swizzle/layout_check.py`; its trace is `[66,74,82]` for packed/swizzled/padded `(2,2)`.

At `(2,2)`, packed `e=66`; its selected source bits produce XOR mask 8, so `66 XOR 8 = 74`. The BF16 value lives at byte offset 148, bank 5. The matrix coordinates and value have not changed.

This swizzle permutes the 1024-element allocation without expanding it. Preserving the low three bits keeps each aligned eight-BF16 staging chunk contiguous: a 128-bit store still writes the intended eight logical elements. A swizzle that changes those low bits would require a different staging transfer; retaining the wide store blindly can corrupt the tile. The runnable checker validates the entire result, not just one address.

The storage declaration stays `fx.Array[fx.BFloat16, BLOCK_M * BLOCK_K, 16]`. Layout construction and attaching a view allocate no additional data buffer and load no values. The helper runs while tracing the compile-time mode; it introduces no runtime layout branch.

## 3. Reuse that layout for both writes and reads

The existing generic staging plan partitions the swizzled LDS view:

```python
left_lds_destination = gmem2lds_thread_copy.partition_D(left_lds_view)
fx.copy(copy_128b, left_lds_source, left_fragment)
fx.copy(copy_128b, left_fragment, left_lds_destination)
fx.barrier()
```

The source retains global row stride 1024. The destination maps the same logical coordinates to the new physical locations. After the barrier, `left_mma_view = left_lds_view` preserves the swizzle for the A operand plan:

```python
lds2reg_left_copy_plan = fx.make_tiled_copy_A(copy_16b, mma)
lds2reg_left_thread_copy = lds2reg_left_copy_plan.get_slice(fx.thread_idx.x)
left_r_source = lds2reg_left_thread_copy.partition_S(left_mma_view)
left_r_destination = lds2reg_left_thread_copy.retile(left_r_tile)
fx.copy(copy_16b, left_r_source, left_r_destination)
```

The MMA fragments still have the instruction's required register layout. The source view supplies physical addresses; `retile` supplies a compatible alias of the existing register storage. `fx.gemm` consumes the two 16-wide K fragments just as in stage 05. All four waves participate, and the second barrier protects LDS reuse.

B retains its packed `(K,N):(32,1)` LDS view and `(N,K):(1,32)` MMA view. Reconstructing A as a plain row-major view after staging would discard the swizzle and read the wrong values.

## 4. Compare padding as a separate layout

The padded mode reserves `32*40` BF16 elements for A and attaches:

```python
left_lds_layout = fx.make_layout((BLOCK_M, BLOCK_K), (BLOCK_K + 8, 1))
```

The logical domain remains 32×32; the eight extra positions per physical row are unused. Reserve the larger allocation before applying the stride: changing a view alone does not enlarge its buffer. B still reserves 32×32 BF16 elements. Together they use `(32*40 + 32*32)*2 = 4608` bytes.

A 40-element row starts on an 80-byte boundary relative to the previous row. Every row still starts at a multiple of 16 bytes, preserving the staging alignment. At `(2,2)`, offset `2*40+2=82` reaches bank 9. Padding and swizzling are measured independently here; combining them is not automatically better.

## 5. Reproduce the counter evidence

Run from the repository root in the pinned environment. `rocprofv3` is supplied by its ROCm SDK; check counter availability on the actual GPU:

```bash
pixi run rocprofv3 --list-avail
pixi run python lessons/01-gpu-programming/13-matmul/06-lds-swizzle/profile.py \
  --collect --output /tmp/flydsl-lds-profile-new
```

Use a fresh output directory. For each mode, the driver first checks every output for trace and seeded random inputs against CPU FP32 matmul on the quantized inputs, rounded to BF16, including 16 trailing sentinels. It then launches three warm-ups and five sampled matmuls on the same seeded BF16 inputs. The profiler filters `exercise_kernel`; the summary requires ten matmul dispatches, discards the two checker dispatches and three warm-ups, and reports the final five. An unsuccessful correctness check or incomplete collection fails the driver.

The exact profiler argv is recorded in `summary.json`. Its essential counter request is:

```bash
pixi run rocprofv3 \
  --pmc LDSBankConflict SQC_LDS_BANK_CONFLICT_sum SQC_LDS_IDX_ACTIVE_sum SQ_INSTS_LDS_sum \
  --kernel-include-regex exercise_kernel --output-format csv \
  -d /tmp/flydsl-one-layout -o swizzle -- \
  python lessons/01-gpu-programming/13-matmul/06-lds-swizzle/profile.py --worker swizzle
```

On this SDK, the metric is defined as:

```text
LDSBankConflict = 100 * sum(SQC_LDS_BANK_CONFLICT) / sum(SQC_LDS_IDX_ACTIVE)
```

The raw counter descriptions mark these gfx1151 events **emulated, C1**. Treat the result as the profiler's defined conflict ratio, not a percentage of total wall time or a count of conflicting lanes. The driver retains the raw numerator, denominator, instruction count, LDS allocation, and register count. Counters cover the entire matmul dispatch, including LDS staging and both operands; they do not isolate A-load cycles.

The [checked-in capture](results/2026-11-03-gfx1151/README.md) was taken on Radeon 8060S Graphics (`gfx1151`), FlyDSL 0.4.1, ROCm SDK 10.0.0, ROCprofiler-SDK 1.3.5, and PyTorch 2.13.0+rocm10.0.0. Each of the final five dispatches reported the same counter values:

| Mode | Conflict ratio | Conflict numerator | Indexed LDS denominator | LDS instructions | VGPRs | LDS bytes |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Packed | 46.153846% | 6,291,456 | 13,631,488 | 4,980,736 | 56 | 4096 |
| Swizzle | 30.769231% | 4,194,304 | 13,631,488 | 8,650,752 | 88 | 4096 |
| Padded | 6.666667% | 524,288 | 7,864,320 | 4,980,736 | 56 | 4608 |

The swizzle reduced the conflict numerator by **one third**, with the same denominator, and passed full-output checks. It did not eliminate conflicts. Padding reduced the numerator by **91.7%**, while also reducing indexed LDS activity. None of these claims depends on timing.

## 6. Inspect lowering and measure the complete kernel separately

The driver dumps each mode's IR and final ISA under `<output>/<mode>/assembly/`. The capture includes the final `.s` files. All modes retained two `global_load_b128` sites, two `ds_store_b128` sites, and two `v_wmma_f32_16x16x16_bf16` sites in the K-stage loop. Static instruction sites are not dynamic counter totals.

Packed and padded A loads retained four `ds_load_b128` sites, alongside 32 scalar BF16 load sites for B. In the swizzled version, the A vector loads became scalar BF16 loads too: 64 scalar sites total and no `ds_load_b128`. Register usage rose from 56 to 88 VGPRs. These changes explain why conflict reduction alone is insufficient to predict kernel speed.

After profiling subprocesses exit, the driver separately benchmarks all three variants and GPU `torch.matmul`, with preallocated outputs and warm repeated buffers. Automatic timing fell back to synchronized **host timing** because GPU events were unavailable. Profiler start/end timestamps were equal on this setup as well, so they are not used for duration claims. Host results include dispatch and synchronization overhead.

| Mode | Recorded host median, ms | Repeat capture, ms |
| --- | ---: | ---: |
| Packed | 0.4121 | 0.3847 |
| Swizzle | 0.3995 | 0.4048 |
| Padded | 0.3014 | 0.2897 |
| GPU torch.matmul | 0.1354 | 0.1293 |

Each column uses five batches of 20 launches after three warm-ups. The packed/swizzle ordering reversed between captures; these measurements do not establish a reliable swizzle speedup. Padding was faster in both host-timed captures and used fewer registers than the swizzle, making it the better measured candidate here. This remains a result for this workload and environment, not a hardware-independent recommendation. gfx1152 has not been hardware-validated.

## Practice and checkpoint

In [practice.py](practice.py), TODO 1 constructs the native swizzle descriptor. TODO 2 composes it with `left_lds_base_layout` and zero offset. The surrounding staging, MMA, padded comparison path, and checker are supplied. The default `swizzle` path reaches both TODOs; leave the compile-time mode unchanged while completing them.

```bash
pixi run python lessons/01-gpu-programming/13-matmul/06-lds-swizzle/practice.py --check-only
pixi run python lessons/01-gpu-programming/13-matmul/06-lds-swizzle/solution.py --check-only
# Omit --check-only for the usual per-file GPU PyTorch timing comparison.
```

The starter reports `Practice not finished:`. A completed practice and solution report `Exercise passed:` with `shapes_MNK: [(1024,1024,1024)]`, two patterns, and `first_four: [3,-6,-1,-3]`. Trace tolerances are `rtol=0, atol=0.001`; random tolerances are `rtol=0.016, atol=0.03125`. Output starts as NaN. The profiling driver additionally checks all three layout modes; it never treats a performance improvement as a correctness requirement.

**Check yourself:** Why can a correct swizzle reduce the bank-conflict metric without making the whole kernel consistently faster?

<details><summary>Answer</summary>

The compiler can change LDS instruction widths and address arithmetic. Here the swizzle reduced the conflict numerator but scalarized A's loads, increased dynamic LDS instruction count, and used more registers. Padding preserved A's vector loads at the cost of 512 extra LDS bytes. Compare correctness, raw counters, ISA, resources, and separately measured kernel time together.

</details>

[Previous: matrix instructions](../05-matrix-instructions/README.md) · [Matmul series](../README.md) · [Next: interleaved loads](../07-interleaved-loads/README.md)

Sources: [FlyDSL composed layouts and swizzles](https://github.com/ROCm/FlyDSL/blob/888d7d80528f0cf2abab8a86610d5ccca47f205d/python/flydsl/expr/primitive.py), [AMD LDS and bank conflicts](https://rocm.docs.amd.com/projects/HIP/en/latest/understand/performance_optimization.html), [rocprofv3 counter collection](https://rocmdocs.amd.com/projects/rocprofiler-sdk/en/latest/how-to/using-rocprofv3.html). The installed 0.4.1 implementation and captured counter definitions take precedence over newer documentation.
