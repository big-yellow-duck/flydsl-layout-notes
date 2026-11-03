# 08 · Tune register reuse and verify the selected parameters

Build on [stage 07](../07-interleaved-loads/README.md), retaining its one-tile global prefetch, padded A LDS, packed B LDS, native WMMA copies, and **1024³ BF16 input/output with FP32 accumulation**. This lesson searches block M/N/K dimensions, wave arrangement, and one/two LDS buffers, then locks a configuration before testing it on new data. **The selected tuple won two nine-round direct-launch captures and a nine-round graph capture under shared GPU load. These measurements do not establish isolated GPU performance.**

The [solution](solution.py) is a native configuration family. Its current selection is `Config(128,64,32,2,2,"prefetch")`: four wave32 groups, 128 threads, 128 output blocks, 64 FP32 accumulator values per thread, and 14336 LDS bytes. Global A, B, and output remain row-major; there is no B prepacking or library call inside the GPU kernel.

![A 32×32 block gives one 16×16 output tile to each wave; the larger 128×64 block repeats the four-wave ownership over an 8×4 grid of atom tiles.](../../../../assets/01-gpu-programming/13-matmul/08-parameter-tuning/register-reuse.svg)

Each cell is a **16×16 output tile**, and its label identifies the owning wave group. Repeated labels mean more work for the same wave, not additional threads. The [native ownership checker](ownership.py) stores thread IDs through the actual MMA-derived C copy and checks every output position.

## 1. Give each operand load more output work

Stage 07's block has one 16×16 output atom tile per wave. The current larger block repeats that ownership four times along M and twice along N. Each A operand fragment can serve two output-column tiles; each B fragment can serve four output-row tiles.

For `WM` by `WN` wave groups:

```text
threads             = 32 * WM * WN
register_M_tiles    = BLOCK_M // (16 * WM)
register_N_tiles    = BLOCK_N // (16 * WN)
accumulators/thread = 8 * register_M_tiles * register_N_tiles
```

| Property | Stage-07-sized configuration | Current larger configuration |
| --- | ---: | ---: |
| Block M×N×K | 32×32×32 | 128×64×32 |
| Waves / threads | 4 / 128 | 4 / 128 |
| Register M/N repetitions | 1×1 | 4×2 |
| FP32 accumulators per thread | 8 | 64 |
| Blocks for 1024×1024 output | 1024 | 128 |
| LDS bytes | 4608 | 14336 |
| Staged input payload over the full product | 128 MiB | 48 MiB |

The payload calculation counts logical global-to-LDS input movement before cache reuse; it is not a measured DRAM traffic claim. For one K stage, arithmetic intensity relative to its BF16 input payload is `BLOCK_M*BLOCK_N/(BLOCK_M+BLOCK_N)` FLOP/byte: 16 for a 32×32 output block and about 42.67 for 128×64.

Increasing block K has a different effect: fewer staging iterations and barriers, but larger operand/storage requirements. It does not change that M/N reuse formula. The bounded search tests K=16,32,64 rather than assuming larger K always wins.

## 2. Keep MMA ownership distinct from view repetitions

The four-wave layout remains:

```python
mma = fx.make_tiled_mma(atom, fx.make_layout((WAVES_M, WAVES_N, 1), (1, WAVES_M, 0)))
```

For `(WM,WN)=(2,2)`, the MMA's natural footprint is still **32×32×16**. Giving `make_fragment_A/B/C` larger block views adds static repetitions. `fx.gemm` walks those repeated M/N/K fragments; the hardware instruction remains 16×16×16 WMMA.

A wave's aggregate output values are not necessarily a contiguous 64×32 rectangle. With the 2×2 group layout, 16-row/column tile stripes alternate between wave groups. For thread 17 in block 0:

```text
lane = 17, wave = 0
row = 32*m_repeat + 2*slot + 1   slot=0..7, m_repeat=0..3
col = 32*n_repeat + 1           n_repeat=0..1
```

It owns `(row,col)=(1,1),(1,33),(3,1),(3,33),…` and 64 positions altogether. The checker confirms all 8192 positions and equal per-thread coverage. A fixed eight-slot conversion/store loop would leave most of this block unwritten; conversion must use the derived accumulator count.

## 3. Derive A and B staging plans separately

The copy atom still moves eight BF16 values per 128-bit operation. Rectangular block tiles need separate A/B ownership geometry:

```python
left_copy_threads = fx.make_ordered_layout(
    (THREADS_PER_BLOCK // (BLOCK_K // 8), BLOCK_K // 8), (1, 0)
)
right_copy_threads = fx.make_ordered_layout(
    (THREADS_PER_BLOCK // (BLOCK_N // 8), BLOCK_N // 8), (1, 0)
)
copy_values = fx.make_ordered_layout((1, 8), (1, 0))
```

A's contiguous axis has extent K; B's has extent N. Build each plan with `make_layout_tv` and `make_tiled_copy`, then partition its own global and LDS views. MMA operand/output plans still come from `make_tiled_copy_A/B/C`.

For the current 128×64×32 selection, A's thread layout is `(32,4)` and B's is `(16,8)`. Thread 17 stages:

| Operand | Block-local positions within one K stage |
| --- | --- |
| A | Rows 4,36,68,100; K columns 8–15 |
| B | K rows 2,18; output columns 8–15 |

Each thread therefore stages 32 BF16 values of A and 16 of B, using four and two 128-bit chunks respectively. This staging ownership is independent of its C accumulator ownership. A's physical LDS row stride remains `BLOCK_K+8`; B's is `BLOCK_N`. With one LDS buffer, the allocation is `2*(BLOCK_M*(BLOCK_K+8) + BLOCK_K*BLOCK_N)` bytes; multiply by `Config.buffers` for the optional second buffer.

## 4. Bound the search before measuring

`tune.py --sweep` enumerates 71 valid configurations: the stage-07-sized reference plus combinations of M/N in 64/128, K in 16/32/64, and wave arrangements `(2,2)`, `(4,1)`, `(1,4)`. The initial one-buffer search had 37 candidates; the extended search adds the second-buffer alternatives and prunes three that exceed 64 KiB. All searched layouts have four waves. `validate_config` checks whole WMMA groups, complete aligned staging chunks, divisibility of the fixed workload, and the 64 KiB LDS limit.

Every candidate must pass full trace and seeded-random 1024³ output comparisons before it contributes timing data. Compilation and correctness checks finish before search timing begins. Candidate order is shuffled with a fixed seed. Each timing batch pairs a candidate with GPU `torch.matmul` on the same preallocated output and inputs, alternating which runs first.

The search score is the median of the paired `candidate_ms / torch_ms` ratios. Select the timing objective explicitly: the final tuple was chosen by `--timing direct-host`; the earlier graph search chose a different tuple. It selects a candidate using training seed 13; it does not prove that candidate will match PyTorch on subsequent measurements. Changing the search space or selecting another tuple after observing held-out results requires another independent verification.

### Try ping-pong LDS as a parameter

`Config.buffers` is 1 or 2. The training search selected one buffer. Two buffers double the allocation; slice an extra layout mode with `tile_k % 2` to select current storage, and `(tile_k+1) % 2` for the future tile. The MMA register layouts and global input contract stay unchanged.

A one-buffer handoff needs a reader barrier before overwriting the current tile. With two buffers, publication writes the other buffer, whose last readers finished at the preceding ready barrier. The extra reader barrier can therefore be omitted, while the publication/ready barrier remains essential. For 32 K stages this reduces block barriers from 64 to 33, including prologue and drain. It does not itself prove instruction overlap or a speedup.

All 71 valid configurations passed full trace/random comparisons. The selected tile with both buffer counts also passed exact one-/two-/three-tile handoff checks. Restrict a search with `--buffers 1`, or use the default one/two-buffer sweep. A locked two-buffer verification requires `--verify --buffers 2`; the verifier accepts only one locked buffer count.

## 5. Remove dispatch noise without capturing an empty graph

The default tuning metric is `graph-host`: both implementations are captured as 32 actual GPU matmuls per graph replay, then timed using synchronized host batches. This amortizes Python launch overhead. It is graph-replay throughput, not a device-event latency measurement. `--timing direct-host` retains the direct-launch comparison used in earlier lessons.

The native launcher accepts an explicit `fx.Stream`, so FlyDSL launches enter the same stream being captured by PyTorch. The harness queries HIP graph nodes, requires at least 32 kernel nodes, and records node counts. It then negates A in place, clears output to NaN, replays, and checks the entire new result against the negated CPU reference. It restores A and repeats the check. Both paths check trailing output sentinels. An empty graph, wrong stream, stale captured values, or missing output fails validation before timing.

CPU reference work is limited to one CPU thread and stays outside timing. A one-second pre-measurement probe records sysfs GPU activity while no benchmark kernels run. This helps detect other GPU users; it does not prove exclusive access throughout the measurement.

```bash
pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/tune.py \
  --sweep --timing direct-host --output /tmp/tile-search-new.json
pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/tune.py \
  --verify --timing direct-host --output /tmp/tile-heldout-new.json
```

Use fresh output files so failed measurements remain available. After retuning, choose three previously unused seeds with `--seeds`; repeated default seeds are not independent held-out evidence. To verify a different locked tuple, supply `--config BM,BN,BK,WM,WN` explicitly.

## 6. Verify a locked choice and inspect its cost

The default held-out verification uses three seeds and three rounds per seed, with seven paired batches per round. Graph batches replay 20 graphs of 32 matmuls; direct-host batches use 50 launches. Every held-out input pair is checked for both implementations against CPU FP32 matmul on the quantized inputs, rounded to BF16.

The predeclared performance labels are:

- `win`: every held-out round has median paired ratio below 0.95.
- `match`: every round has ratio at most 1.05.
- `slower`: either criterion is unproven.

Performance labels are recorded observations, not correctness test requirements. The lesson's ordinary checker never requires a speedup. Apply the labels only to the recorded measurement conditions. A graph-replay win under shared GPU load does not establish isolated device latency or direct-launch parity.

The original, contended-host search and its failed held-out verification are retained under `results/initial-contended-host/`. A first graph verification on the remote machine also changed ordering while a separate model service kept the GPU busy. These exploratory results must not be promoted to a clean win.

### Recorded shared-GPU verification

The 71-candidate direct-launch training search selected 128×64×32, four waves, and one LDS buffer. That tuple was fixed before all three captures below; each used three new seeds and nine rounds. No configuration was changed between captures.

| Capture | Native median ms | PyTorch median ms | Worst round paired ratio | Criterion |
| --- | ---: | ---: | ---: | --- |
| [Direct held-out](results/gmk-shared-gpu/selected-direct-heldout.json) | 0.2152 | 0.3734 | 0.8571 | win |
| [Direct confirmation](results/gmk-shared-gpu/selected-direct-confirmation.json) | 0.2613 | 0.3142 | 0.8983 | win |
| [Graph held-out](results/gmk-shared-gpu/selected-graph-heldout.json) | 0.2630 | 0.3702 | 0.7458 | win |

The medians summarize nine per-round medians. The label uses the worst round's median paired ratio, rather than dividing the two summary medians. Both direct captures meet the predeclared win criterion in all 18 rounds. The graph capture also passes; each implementation has 32 real matmul kernel nodes and passes changed-input replay checks. Both implementations retain the same row-major BF16 inputs, preallocated BF16 output, and FP32 accumulation contract.

A separate model service remained running. Every pre-measurement idle probe reported 100% GPU activity; it was not an exclusive-GPU capture. These are repeatable wins under that shared-load condition. Native/PyTorch summary times vary between captures, so they do not establish isolated device latency or a universal speedup. The [results directory](results/gmk-shared-gpu/README.md) retains earlier failed verifications, including the graph-selected 64×64×32 tuple's failed direct-launch check. Do not choose parameters using held-out results: each new timing objective or retune requires a new training selection and unused verification seeds.

Inspect the selected kernel independently:

```bash
pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/inspect_kernel.py \
  --output /tmp/tile-isa-new
```

The inspector runs the checker, verifies that the dumped IR is the 1024³ specialization, requires WMMA in final ISA, and records static LDS/register/scratch metadata. The selected 128×64×32 specialization reports 14336 LDS bytes, 165 compiler VGPRs, and zero private scratch bytes. These are static resources, not measured occupancy. Larger register tiles can improve reuse while reducing the number of resident waves; the sweep must measure that tradeoff.

## Practice and correctness

[practice.py](practice.py) supplies the native family and selected tuple. TODO 1 derives B's staging thread layout from its N extent. TODO 2 derives the number of accumulator values to convert from the per-wave M/N repetitions. Complete those expressions, then compare with the [worked solution](solution.py).

```bash
pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/practice.py --check-only
pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/solution.py --check-only
pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/ownership.py
```

The unfinished scaffold reports `Practice not finished:`. The solution and completed practice check the full 1024³ trace/random workload, with first four trace outputs `[3,-6,-1,-3]`, NaN-initialized output, and 16 trailing sentinels. Tolerances remain `rtol=0, atol=0.001` for trace and `rtol=0.016, atol=0.03125` for random BF16-rounded outputs. One-, two-, and three-K-tile tag cases separately test prologue, handoffs, and drain. Only complete positive tiles are supported; broader shapes and tails are outside this tuning example.

**Check yourself:** Why can enlarging the block improve input reuse but still lose performance?

<details><summary>Answer</summary>

A larger M/N block reuses operands across more outputs, but also needs more accumulators and operand storage, consumes more LDS, and launches fewer blocks. Register pressure, scratch spills, insufficient parallelism, and changes in staging geometry can offset reuse. Correctness, resource inspection, and held-out paired measurements are needed together; the largest block is not automatically the winner.

</details>

[Previous: interleaved loads](../07-interleaved-loads/README.md) · [Matmul series](../README.md) · [Roadmap](../../../../ROADMAP.md#matmul-continuation-planned)

Sources: [FlyDSL RDNA3 configurable register tiling](https://github.com/ROCm/FlyDSL/blob/888d7d80528f0cf2abab8a86610d5ccca47f205d/kernels/gemm/rdna3_f16_gemm.py), [FlyDSL tuning guidance](https://github.com/ROCm/FlyDSL/blob/888d7d80528f0cf2abab8a86610d5ccca47f205d/docs/kernel_tuning_guide.md). The family was implemented from the preceding lesson, keeps row-major global B, and does not import the upstream pretransposed-B kernel.
