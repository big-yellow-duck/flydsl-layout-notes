# 08 · Tune register reuse and operand fragments

A larger output tile lets each block reuse its inputs across more results. It also needs more accumulators, so the useful question is: **how much output work can a block own while keeping its operand fragments small?**

Build on [stage 07](../07-interleaved-loads/README.md), retaining its global prefetch, padded A LDS, packed B LDS, and native WMMA copies. Keep **M=N=K=1024**, row-major BF16 inputs/output, and FP32 accumulation. The [solution](solution.py) selects:

```python
SELECTED_CONFIG = Config(128, 128, 32, 1, 4, "prefetch")
```

This means a **128×128 output tile**, a **32-wide K stage**, **1×4 wave groups**, and **one LDS buffer per operand**. The strategy combines more output reuse with 16-wide operand fragments, vectorized global staging, and grouped block traversal.

## Watch the full strategy

[![Static preview of the matmul strategy video: output blocks, K staging and prefetch, and wave-owned accumulator tiles.](../../../../assets/01-gpu-programming/13-matmul/08-parameter-tuning/strategy.png)](../../../../assets/01-gpu-programming/13-matmul/08-parameter-tuning/strategy.mp4)

[Open the video](../../../../assets/01-gpu-programming/13-matmul/08-parameter-tuning/strategy.mp4) to play, pause, and scrub through the 4½-minute walkthrough. Read the three panels together: the whole output grid on the left, staging/LDS/operand registers in the middle, and the selected block's accumulator tiles on the right. The first K stage shows every M/N repetition with a two-second hold per update. Later stages summarize those repetitions while tracing all 32 K stages. The final section shows grouped block mapping, with each block independently performing its own K reduction.

<details><summary>Video chapters</summary>

| Time | Strategy step |
| --- | --- |
| 00:00 | Choose an output block |
| 00:06 | Prologue: publish tile 0 to LDS |
| 00:19 | Prefetch the next global tile |
| 00:24 | First K stage: M/N operand reuse |
| 01:36 | Reader barrier and LDS handoff |
| 01:44 | Reduce the remaining K stages |
| 03:44 | Drain the final K stage |
| 03:57 | Convert and store BF16 output |
| 04:03 | Group output blocks along M |
| 04:23 | K reduction and M/N reuse recap |

</details>

Orange borders mark WMMA updates; the bottom strip tracks K stages. The video illustrates logical dataflow, rather than GPU clock timing. A [static overview](../../../../assets/01-gpu-programming/13-matmul/08-parameter-tuning/strategy.svg) is also available.

## 1. Give the same threads more output work

![A 32×32 reference tile uses a 2×2 wave arrangement; the selected 128×128 tile uses 1×4 waves and repeats ownership over 16 atom tiles per wave.](../../../../assets/01-gpu-programming/13-matmul/08-parameter-tuning/register-reuse.svg)

Each cell is a **16×16 output tile**. Follow wave 0 in the larger block: it owns every tile row in tile columns 0 and 4. Repeated labels give the same wave more work. Both blocks still launch 128 threads.

For `WM` by `WN` wave groups:

```text
threads             = 32 * WM * WN
register_M_tiles    = BLOCK_M // (16 * WM)
register_N_tiles    = BLOCK_N // (16 * WN)
accumulators/thread = 8 * register_M_tiles * register_N_tiles
```

| Property | Stage 07 | Selected configuration |
| --- | ---: | ---: |
| Block M×N×K | 32×32×32 | 128×128×32 |
| Wave arrangement | 2×2 | 1×4 |
| Threads | 128 | 128 |
| Register M/N repetitions | 1×1 | 8×2 |
| FP32 accumulators per thread | 8 | 128 |
| Blocks for the full output | 1024 | 64 |
| LDS bytes per block | 4608 | 18432 |
| Logical staged input payload | 128 MiB | 32 MiB |

Within each selected wave, an A operand fragment serves two output-column tiles, and a B fragment serves eight output-row tiles. The extra accumulators retain those results throughout the K loop.

The staged payload counts input movement before cache reuse. For one K stage, arithmetic per byte of BF16 input is `BLOCK_M*BLOCK_N/(BLOCK_M+BLOCK_N)`: 16 FLOP/byte for a 32×32 output tile and 64 for 128×128. Increasing M/N improves this reuse. Increasing K changes the staging granularity instead.

## 2. Derive ownership from the wave arrangement

The selected MMA uses:

```python
mma = fx.make_tiled_mma(
    atom, fx.make_layout((WAVES_M, WAVES_N, 1), (1, WAVES_M, 0))
)
```

With `(WM,WN)=(1,4)`, the natural footprint is **16×64×16**. The 128×128 output view repeats this footprint eight times along M and twice along N. The hardware instruction remains 16×16×16 WMMA.

Follow thread 17 in block 0. It has lane 17 and wave 0, and owns:

```text
row = 16*m_repeat + 2*slot + 1   m_repeat=0..7, slot=0..7
col = 64*n_repeat + 1           n_repeat=0..1
```

Its positions begin `(1,1),(1,65),(3,1),(3,65),…`: 128 values altogether. The [native ownership checker](ownership.py) checks all 16384 output positions and equal per-thread coverage. The conversion/store path must include every repeated accumulator tile; an eight-slot conversion loop would leave most of this block unwritten.

## 3. Stage K=32, consume K=16

The output accumulators must survive the whole product. Operand registers only need to survive their current WMMA update. Keep those lifetimes separate:

```text
next global K tile → staging registers
current K tile    → LDS → 16-wide operand registers → WMMA → accumulators
```

![A 32-wide LDS K stage is consumed as two 16-wide operand fragments, updating the same output accumulator.](../../../../assets/01-gpu-programming/13-matmul/08-parameter-tuning/fragment-lifetime.svg)

Trace stage 0. First, copy K=0–15 from LDS into operand registers and update the accumulator. Then reuse those registers for K=16–31 and update the same accumulator again. The prefetched next global tile waits in separate staging registers until the LDS handoff.

The solution allocates MMA operand fragments for K=16 and slices each LDS stage into matching subviews. This API fragment shows the compute step:

```python
for rk in fx.range_constexpr(BLOCK_K // 16):
    left_subview = fx.slice(
        fx.flat_divide(left_view, (BLOCK_M, 16)), (None, None, 0, rk)
    )
    right_subview = fx.slice(
        fx.flat_divide(right_operand, (BLOCK_N, 16)), (None, None, 0, rk)
    )
    left_source = lds2reg_left_thread_copy.partition_S(left_subview)
    right_source = lds2reg_right_thread_copy.partition_S(right_subview)
    fx.copy(copy_16b, left_source, left_r_destination)
    fx.copy(copy_16b, right_source, right_r_destination)
    fx.gemm(atom, accumulator, left_r_tile, right_r_tile, accumulator)
```

A 32-wide LDS stage amortizes global staging and barriers across two WMMA K updates. Smaller operand fragments limit the register storage needed for each update while all 128 output accumulators remain live.

## 4. Match staging to each operand

Each staging chunk contains eight BF16 values, or 128 bits. A is contiguous along K; B is contiguous along N. Their thread layouts therefore use different extents:

```python
left_copy_threads = fx.make_ordered_layout(
    (THREADS_PER_BLOCK // (BLOCK_K // 8), BLOCK_K // 8), (1, 0)
)
right_copy_threads = fx.make_ordered_layout(
    (THREADS_PER_BLOCK // (BLOCK_N // 8), BLOCK_N // 8), (1, 0)
)
copy_values = fx.make_ordered_layout((1, 8), (1, 0))
```

Build each plan with `make_layout_tv` and `make_tiled_copy`, then partition its own global and LDS views. For the selected tuple, A's thread layout is `(32,4)` and B's is `(8,16)`. Staging thread 17 loads:

| Operand | Block-local positions in one K stage |
| --- | --- |
| A | Rows 4,36,68,100; K columns 8–15 |
| B | K rows 1,9,17,25; output columns 8–15 |

Each thread stages 32 values of each operand in four chunks. These positions differ from its accumulator ownership: staging distributes input chunks across the block, while MMA distributes output arithmetic across waves.

Global views use `fx.rocdl.make_buffer_tensor` with `BufferCopy128b` for loads and `BufferCopy16b` for BF16 output. LDS copies use `UniversalCopy` atoms. The row-major input layouts stay unchanged. A retains the padded LDS row stride `BLOCK_K+8`; B retains stride `BLOCK_N`.

The block traversal also encourages reuse between workgroups. With eight output tile rows, logical blocks 0–7 visit `(row,col)=(0,0)` through `(7,0)`, then block 8 visits `(0,1)`. Those first eight blocks read the same B band, giving nearby workgroups an opportunity to reuse it in cache.

## 5. Tune the tradeoffs together

| Parameter | What increasing or changing it does | Cost to weigh |
| --- | --- | --- |
| Block M/N | Reuses operands across more output tiles | More accumulators/LDS and fewer output blocks |
| Block K | Processes more K values per staging handoff | Larger staging fragments and LDS allocation |
| Wave arrangement | Redistributes M/N repetitions among waves | Changes each wave's operand reuse and register demand |
| LDS buffers | Allows publication into a different shared tile | Doubles LDS storage |

One LDS buffer occupies `2*(BLOCK_M*(BLOCK_K+8) + BLOCK_K*BLOCK_N)` bytes. With two buffers, stage parity selects the current and future planes. The preceding ready barrier protects a plane's readers before reuse, so the extra single-buffer reader barrier can be omitted. Over 32 stages this reduces block barriers from 64 to 33, but doubles LDS. The search selected **one buffer**.

The [tuner](tune.py) searches 132 valid tile/wave/buffer configurations. It rejects incomplete copy or WMMA groups and allocations above 64 KiB, then checks every candidate before timing. Select on training inputs, lock the tuple, and verify it on new inputs. This distinguishes a useful configuration from a favorable training measurement.

## The measured winner

For this 1024³ product, the selected kernel beat GPU `torch.matmul` in both direct-launch verification and GPU kernel traces:

| Measurement | Native | GPU PyTorch |
| --- | ---: | ---: |
| Direct-launch confirmation, host time | 0.0723 ms | 0.0767 ms |
| Profiler confirmation, GPU kernel duration | 59.10 µs | 63.24 µs |

The 18 held-out direct-launch rounds each had more than 5% lower median paired time. Both paths use identical logical inputs and preallocated BF16 output. See [validation notes](../../../../SOURCES.md#stage-08-parameter-tuning-2026-11-04) for measurement details.

The kernel combines output reuse, smaller operand fragments, aligned staging, and cache-friendly block traversal. Its specialization uses **18432 LDS bytes, 212 compiler VGPRs, and zero private scratch**. The larger output tile still needs substantial register storage; the measured combination determines whether that tradeoff pays off.

## Practice and run commands

[practice.py](practice.py) supplies the selected family. TODO 1 derives `right_copy_threads` from N's extent. TODO 2 derives `converted_slots` from the M/N repetitions. Compare with the [worked solution](solution.py).

Run from the repository root:

```bash
pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/practice.py --check-only
pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/solution.py
pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/ownership.py
```

The starter reports `Practice not finished:`. The solution and completed practice check the full trace/random product against a CPU reference and return the trace checkpoint `[3,-6,-1,-3]`. One-, two-, and three-K-tile cases separately check the prefetch prologue, handoffs, and drain. The ordinary solution command also prints the native/PyTorch timing comparison.

To explore another configuration, run a fresh search and verify its winner. Replace `--config` and `--buffers` with the selected tuple and use new verification seeds after each retune:

```bash
pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/tune.py \
  --sweep --timing direct-host --output /tmp/tile-search.json
pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/tune.py \
  --verify --timing direct-host --config 128,128,32,1,4 --buffers 1 \
  --seeds 2026110410 2026110411 2026110412 --output /tmp/tile-heldout.json
```

The [profiler](profile.py) compares GPU dispatch durations and LDS counters; the [inspector](inspect_kernel.py) checks generated WMMA and static register/LDS usage:

```bash
pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/profile.py \
  --collect --output /tmp/tile-profile
pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/inspect_kernel.py \
  --output /tmp/tile-isa
```

**Check yourself:** Why can a larger output tile help, while a larger operand fragment hurts?

<details><summary>Answer</summary>

A larger output tile reuses each operand across more results, reducing repeated input movement. A larger operand fragment keeps more input values live in registers at once. The selected kernel keeps the output reuse of a 128×128 tile, stages K=32 in LDS, and reuses K=16 operand fragments between WMMA updates. Accumulators survive across those updates; operand registers can be reused.

</details>

[Previous: interleaved loads](../07-interleaved-loads/README.md) · [Matmul series](../README.md) · [Roadmap](../../../../ROADMAP.md#matmul-continuation-planned)

Sources: [FlyDSL RDNA3 register tiling and grouped scheduling](https://github.com/ROCm/FlyDSL/blob/888d7d80528f0cf2abab8a86610d5ccca47f205d/kernels/gemm/rdna3_f16_gemm.py), [FlyDSL tuning guidance](https://github.com/ROCm/FlyDSL/blob/888d7d80528f0cf2abab8a86610d5ccca47f205d/docs/kernel_tuning_guide.md).
