# Synchronization profiling

All six parent-benchmark configurations were profiled on gfx1151 with rocprofv3
1.4.1 / ROCm 10.1.0. A seventh uses LDS-only workgroup synchronization for the
independent N64/K16 tiles, isolating execution scope from memory ordering scope.

## Fixed-geometry synchronization control

Every row uses two independent N64/K16 wave tiles, 64 threads, 32 physical
blocks, 5632 LDS bytes/block, 103 VGPRs/thread, and zero scratch.
Uninstrumented times are medians of three seed-level medians from the new
[synchronization-only benchmark](../sync-graph.json), with seven shuffled batches
and twenty 32-GEMM graph replays per batch. Times do not come from profiling.

| Synchronization | Graph µs/GEMM | Raw barrier-wait count/GEMM | SDK LDS issue stall metric | LDS bank-conflict metric |
| --- | ---: | ---: | ---: | ---: |
| LDS ordering, subgroup execution | **288.55** | **0** | 0.246% | 4.167% |
| LDS ordering, workgroup execution | 354.01 | 5,018,355 | 3.251% | 4.167% |
| Ordinary workgroup barrier | 351.38 | 5,110,712 | 3.165% | 4.167% |

Changing execution scope from workgroup to subgroup, retaining LDS-only ordering,
reduces elapsed time by 65.45 µs (18.5%). Narrowing memory ordering while keeping
the workgroup rendezvous does not help in this measurement. All three variants
have identical instruction and conflict counts:

- SQ_WAVES_sum: 64
- SQ_INSTS_TEX_LOAD_sum: 163840
- SQ_INSTS_LDS_sum: 2326528
- SQ_INSTS_SALU_sum: 66240
- SQC_LDS_BANK_CONFLICT_sum: 131072
- SQC_LDS_IDX_ACTIVE_sum: 3145728

Native ISA confirms four static workgroup barrier sites in both workgroup
variants and zero in the subgroup variant. With 512 K chunks, prologue + two
handoffs per steady iteration + drain execute 1024 workgroup barriers per wave.
Subgroup scope removes the cross-wave rendezvous; LDS completion ordering remains.

Together, the controlled timing and counters support a substantial cost from
workgroup synchronization and its resulting scheduling constraints in this
pipeline. This does not measure the latency of one barrier instruction:
waves execute concurrently, and synchronization affects memory progress.

## All configurations

Each counter entry is the median of eight native dispatches in its own pass.
Counter groups are collected separately, not simultaneously.

| Configuration | Waves/GEMM | Raw barrier waits | SDK LDS issue stall metric | LDS bank-conflict metric |
| --- | ---: | ---: | ---: | ---: |
| Single N64/K16 wave per block | 64 | 0 | 1.508% | 4.167% |
| Packed N64/K16, subgroup | 64 | 0 | 0.246% | 4.167% |
| Cooperative N64/K32 | 128 | 5,097,230 | 17.316% | 3.846% |
| Cooperative N128/K32 | 64 | 5,217,432.5 | 14.187% | 2.174% |
| Packed N64/K32, subgroup | 64 | 0 | 2.299% | 4.167% |
| Packed N64/K16, ordinary workgroup | 64 | 5,110,712 | 3.165% | 4.167% |
| Packed N64/K16, LDS-only workgroup | 64 | 5,018,355 | 3.251% | 4.167% |

The cooperative cases have barrier waits and higher LDS issue stalls despite
lower bank-conflict metrics. They also change tile geometry, wave count or
register demand. Their entire performance difference cannot be attributed to
barriers. Packed K32 loses to packed K16 even with zero barrier waits, showing
costs beyond cross-wave synchronization.

Cooperating waves consume data staged by other waves, so subgroup synchronization
would not preserve their dependencies. Independent-wave ownership is what makes
the narrower scope valid.

## Interpretation, validation, and reproduction

`WaveReuseBarrierWait` is exactly `reduce(SQ_WAIT_BARRIER,sum)`. The installed
SDK maps SQ_WAIT_BARRIER to SQ event 42 but leaves its units and description
empty. These are raw reduced values, not nanoseconds or percentages.
`ALUStalledByLDS` is the SDK's derived LDS issue-stall metric, not barrier time.
`LDSBankConflict` is a separate metric. Definitions and their SDK source hash
are retained in [counter-definitions-excerpt.yaml](counter-definitions-excerpt.yaml).

Each configuration has five separate passes: trace, waits, occupancy,
instructions, and LDS. Workers perform 20 warmups per implementation and
alternate eight native/Torch pairs. CPU-reference output, output sentinels, and
applicable workspace checks pass before and after each pass. All 35 passes
completed. Native ISA capture separately validates resources and correctness.
No occupancy limit or barrier-time percentage is inferred from these counters.

Raw counters, trace durations, commands, environment, and validation metadata:
[summary.json](summary.json). Per-configuration directories contain CSVs,
worker reports, stdout and stderr. Counter-pass and trace timings are
instrumented; use separate parent benchmarks for performance comparisons.

Reproduce from the repository root with fresh output paths:

```bash
pixi run python tools/profile_wave_group_reuse.py \
  --benchmark-report lessons/01-gpu-programming/13-matmul/10-wave-local-tiles/results/20261116-wave-group-reuse/graph.json \
  --output /tmp/wave-reuse-profile
pixi run python tools/measure_wave_group_reuse.py --sync-only --output /tmp/wave-reuse-sync.json
```
