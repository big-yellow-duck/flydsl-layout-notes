# 07 · Interleave next-tile loads with current-tile compute

[Stage 06](../06-lds-swizzle/README.md) compared A's LDS layouts and measured aligned padding as the stronger candidate on gfx1151. Keep that padded layout and the same **32×32×32 block tile, 128 threads, four-wave `(2,2,1)` WMMA layout, and 1024³ problem**. This lesson changes the schedule: issue the next tile's global loads before computing from the current LDS tile.

The [solution](solution.py) supplies `schedule="serial"` and `schedule="prefetch"` specializations. Both use padded A `(M,K):(40,1)`, packed B `(K,N):(32,1)`, **4608 LDS bytes**, BF16 inputs/output, and FP32 accumulation. The normal lesson CLI uses `prefetch`. The [profiling driver](profile.py) compares both schedules with the same input storage, ownership, arithmetic, and tile dimensions.

![Program-order diagram: publish tile 0, then prefetch tile t+1 into private registers while tile t remains in LDS; compute, protect readers, publish, and drain the last tile.](../../../../assets/01-gpu-programming/13-matmul/07-interleaved-loads/load-compute-schedule.svg)

Read the buffer contents as well as the arrows. During steady-state computation, **LDS holds tile t while private staging registers hold tile t+1**. These are different storage locations. The diagram describes program order, not measured clock cycles.

## 1. Separate the storage roles

The input path remains the one established in stages 04–06:

```text
selected global block view → per-thread staging registers → LDS
→ instruction-compatible operand registers → WMMA → accumulator
```

| Storage | Variables | Contents during steady-state compute |
| --- | --- | --- |
| Private global staging registers | `left_fragment`, `right_fragment` | Next global K tile, `t+1` |
| Shared LDS buffers | `left_lds_view`, `right_lds_view` | Current K tile, `t` |
| Private MMA operand registers | `left_r_tile`, `right_r_tile` | Current tile's two 16-wide K fragments |
| Private FP32 accumulator | `accumulator` | Eight owned output sums across all processed K tiles |

Each thread stages eight BF16 values per operand. The MMA fragments hold 32 BF16 values per operand per thread for a 32-wide K stage. A global staging fragment cannot replace an MMA operand fragment: their ownership and register layouts differ.

There is one shared tile per operand. Future data waits in private registers until every wave has finished reading the current LDS contents. This first pipeline step does not allocate a second LDS tile or require a new asynchronous-copy API.

## 2. Name the three operations

Tracing-time helpers make the schedule visible without changing the copy plans:

```python
def load_global_tile(tile_k):
    left_block_view = fx.slice(left_tiled_view, (None, None, block_row, tile_k))
    right_block_view = fx.slice(right_tiled_view, (None, None, tile_k, block_col))
    left_lds_source, right_lds_source = create_gmem2lds_sources(
        left_block_view, right_block_view
    )
    fx.copy(copy_128b, left_lds_source, left_fragment)
    fx.copy(copy_128b, right_lds_source, right_fragment)
```

`load_global_tile` writes only the calling thread's staging registers. It does not overwrite LDS. Slicing and partitioning select the global addresses; the two `fx.copy` calls load values.

```python
def publish_lds_tile():
    fx.copy(copy_128b, left_fragment, left_lds_destination)
    fx.copy(copy_128b, right_fragment, right_lds_destination)
    fx.barrier()


def compute_lds_tile():
    fx.copy(copy_16b, left_r_source, left_r_destination)
    fx.copy(copy_16b, right_r_source, right_r_destination)
    fx.gemm(atom, accumulator, left_r_tile, right_r_tile, accumulator)
```

`publish_lds_tile` stores the staged values and waits until the block can consume them. `compute_lds_tile` reads the existing LDS tile and performs its two 16-wide WMMA K updates per wave. The helpers expand into the same kernel during tracing; they do not launch kernels or introduce host work between GPU steps.

## 3. Compare serial order with one-tile lookahead

The serial specialization matches the padded stage-06 schedule:

```python
for tile_k in range(k // BLOCK_K):
    load_global_tile(tile_k)
    publish_lds_tile()
    compute_lds_tile()
    fx.barrier()
```

Each stage must obtain and publish its input before doing useful compute. The prefetch specialization moves the next global read earlier:

```python
# Prologue: establish a valid first tile in LDS.
initial_tile_k = 0
load_global_tile(initial_tile_k)
publish_lds_tile()

# Steady state: consume t while the staging registers hold t+1.
for tile_k in range(k // BLOCK_K - 1):
    next_tile_k = tile_k + 1
    load_global_tile(next_tile_k)
    compute_lds_tile()
    fx.barrier()  # All readers must finish before LDS is reused.
    publish_lds_tile()  # Store t+1, then wait until it is ready.

# Drain: the last tile is already in LDS; no future global read is needed.
compute_lds_tile()
fx.barrier()
```

The loop invariant is: **at the start of iteration t, LDS contains tile t**. The prefetch writes the private staging registers while that LDS tile remains intact. Once tile t is consumed and all readers reach the barrier, publishing those registers establishes tile t+1 for the following iteration.

For 1024³, there are 32 K tiles. The loop runs for `t=0..30`, loading future tiles `1..31`; the drain computes tile 31. It never loads tile 32. The one-tile boundary has a zero-trip steady-state loop: only the prologue and drain execute.

Both schedules load each tile once and consume it once. Each executes 64 block barriers for the 32-stage workload. The prefetch source has separate prologue and drain instructions, so its static ISA listing contains additional instruction sites; that does not mean it doubles the dynamic data movement.

## 4. Follow thread 17 at the handoff

In block `(x,y)=(1,2)`, the output window is global rows 64–95 and columns 32–63. The unchanged staging layout is `(32,4):(4,1)` with eight contiguous values per thread. Thread 17 has staging row `17//4=4` and starts at staging column `(17%4)*8=8`.

During steady-state iteration `t=2`:

| Location | K tile | Thread-17 trace |
| --- | --- | --- |
| Current A/B LDS storage | 2 | A covers global K=64–95; B covers global K=64–95 |
| Future A staging fragment | 3 | Loads global `A[68,104..111]` |
| Future B staging fragment | 3 | Loads global `B[100,40..47]` |
| Current WMMA output ownership | Current K=64–95 | Lane 17 in wave 0 contributes to C rows 65,67,…,79 at column 33 |

The future staging coordinates differ from this thread's MMA ownership. WMMA is collective across all lanes. It uses current LDS-derived operand fragments, while the global loads obtain chunks for the next cooperative LDS tile. After the reader barrier, all 128 threads publish those future chunks together.

The first barrier cannot be replaced by a single thread's memory wait: another wave might still be reading the shared tile. The ready barrier after publication cannot be removed either: another wave might not have finished its cooperative stores.

## 5. Inspect whether the compiler preserves useful instruction order

Moving Python statements is only the source-level schedule. The final machine instructions and waits determine whether independent compute can proceed before the prefetched values are required. The compiler handles the memory dependencies; this lesson adds no manually encoded `s_waitcnt` or scheduling assembly.

Run from the repository root:

```bash
pixi run python lessons/01-gpu-programming/13-matmul/07-interleaved-loads/profile.py \
  --collect --output /tmp/flydsl-interleaved-new
```

Use a fresh output directory. The driver checks both schedules, captures rocprofv3 counters, dumps final ISA and origin IR, and records a main-loop excerpt with source line numbers. It verifies that the dump is the full 1024³ specialization rather than an overwritten boundary-case specialization. It also checks that prefetch global loads precede WMMA and that the first VMEM wait follows both WMMA updates, before the LDS stores.

The [recorded capture](results/2026-11-03-gfx1151/README.md) on gfx1151 contains:

| Serial main-loop order | Prefetch main-loop order |
| --- | --- |
| Issue current global loads | Issue next global loads |
| VMEM waits, then LDS stores | Read current LDS operands |
| Ready barrier | Execute both current WMMA updates |
| Read LDS, execute WMMA | VMEM wait, then reader barrier |
| Reader barrier | Publish next LDS tile; ready barrier |

In [prefetch.s](results/2026-11-03-gfx1151/prefetch.s), next-tile global loads occur at lines 73 and 85; current LDS vector reads at lines 102–105; WMMA at lines 139 and 142; `s_waitcnt vmcnt(0)` at line 143; and future LDS stores at lines 146–147. Scalar B loads and LDS waits are present between these selected instructions; see the complete assembly rather than treating the excerpt as a complete instruction stream.

This confirms an **opportunity to overlap global-memory latency with current-tile work**: the explicit VMEM wait no longer blocks before WMMA. It does not prove how many cycles overlapped, that the loads remained outstanding throughout compute, or that global latency was completely hidden. That would need a suitable cycle-level hardware trace.

## 6. Check that the improvement is scheduling, then measure time

Both schedules retain the padded layout's profiler conflict ratio and dynamic LDS instruction total:

| Property | Serial | Prefetch |
| --- | ---: | ---: |
| Block LDS bytes | 4608 | 4608 |
| Profiler-reported VGPR count | 56 | 64 |
| Scratch bytes | 0 | 0 |
| `LDSBankConflict` | 6.666667% | 6.666667% |
| Conflict numerator | 524,288 | 524,288 |
| Indexed LDS denominator | 7,864,320 | 7,864,320 |
| Dynamic LDS instruction count | 4,980,736 | 4,980,736 |

The events retain stage 06's **emulated/C1** counter descriptions. Their ratio is the SDK-defined conflict metric, not a wall-time percentage. Unchanged values support that this comparison did not introduce a new bank-layout optimization. The higher register count reflects the changed live ranges; the measured LDS allocation did not grow.

After profiling subprocesses exit, the driver separately times both schedules and GPU `torch.matmul` with preallocated outputs, three warm-ups, and five batches of 20 launches:

| GPU implementation | Final host median, ms | Repeat capture, ms |
| --- | ---: | ---: |
| Serial padded | 0.3106 | 0.2978 |
| Prefetch padded | 0.2849 | 0.2747 |
| GPU torch.matmul | 0.1381 | 0.1299 |

The prefetch schedule had about **8% lower host-observed time** in both captures. GPU event timing was unavailable, and profiler start/end timestamps were equal, so these are synchronized **host timings**, including dispatch and synchronization overhead. They are observations for this 1024³ workload on Radeon 8060S Graphics, FlyDSL 0.4.1, ROCm SDK 10.0.0, and ROCprofiler-SDK 1.3.5. They are not device-only timings or a general speedup guarantee. gfx1152 still needs hardware validation.

The driver retains original counter CSVs, agent metadata, complete ISA, origin IR, loop-order excerpts, worker logs, source hashes, profiler version, and both timing captures. It checks three small boundary dispatches and ten full-workload dispatches per schedule; only the final five full-workload dispatches contribute counter samples. Counter collection and timing do not run concurrently.

## Practice and verification

In [practice.py](practice.py), TODO 1 chooses `initial_tile_k` for the prologue. TODO 2 chooses `next_tile_k` inside the steady-state loop. The copy plans, positive full-tile workload contract, reader/ready barriers, drain, output conversion, and checker are supplied. Compare with the [worked solution](solution.py).

```bash
pixi run python lessons/01-gpu-programming/13-matmul/07-interleaved-loads/practice.py --check-only
pixi run python lessons/01-gpu-programming/13-matmul/07-interleaved-loads/solution.py --check-only
# Omit --check-only for the usual per-file GPU PyTorch comparison.
```

The scaffold reports `Practice not finished:`. A completed practice and solution report `Exercise passed:` with the fixed main comparison `shapes_MNK: [(1024,1024,1024)]`, two patterns, and `first_four: [3,-6,-1,-3]`. Trace tolerances remain `rtol=0, atol=0.001`; seeded BF16 random checks use `rtol=0.016, atol=0.03125`, against independent CPU FP32 matmul rounded to BF16. Output starts as NaN; 16 trailing sentinels check stray writes.

The additional `pipeline_boundaries` checkpoint covers 32×32 outputs with **one, two, and three K tiles**. A's successive K tiles contain values 1,2,4 and B contains 1, so every output must equal 32, 96, or 224 exactly. These checks exercise the zero-trip loop, first handoff, and repeated handoff without changing the 1024³ performance comparison. No partial tile or K=0 path is implemented.

**Check yourself:** Why does the final tile need a separate drain instead of one more prefetch iteration?

<details><summary>Answer</summary>

The steady-state iteration loads tile `t+1`. For the final current tile, that would address a nonexistent next tile. After the loop's last publication, the final valid tile is already in LDS, so compute it once without another global load. With only one K tile, the same rule makes the steady-state loop empty while prologue and drain still do all required work.

</details>

[Previous: LDS bank conflicts](../06-lds-swizzle/README.md) · [Matmul series](../README.md) · [Next: planned LDS double buffering](../../../../ROADMAP.md#matmul-continuation-planned)

Sources: [FlyDSL global-prefetch/compute pipeline example](https://github.com/ROCm/FlyDSL/blob/888d7d80528f0cf2abab8a86610d5ccca47f205d/kernels/gemm/rdna3_f16_gemm.py), [native tiled-copy and MMA helpers](https://github.com/ROCm/FlyDSL/blob/888d7d80528f0cf2abab8a86610d5ccca47f205d/python/flydsl/expr/derived.py), [rocprofv3 counter collection](https://rocmdocs.amd.com/projects/rocprofiler-sdk/en/latest/how-to/using-rocprofv3.html). The upstream production pipeline also uses two LDS buffers and other optimizations; this teaching kernel isolates one shared-tile lookahead into registers. API expressions were checked against installed FlyDSL 0.4.1.
