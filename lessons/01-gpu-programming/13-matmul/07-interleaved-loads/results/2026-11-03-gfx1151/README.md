# gfx1151 interleaved-load capture · 2026-11-03

Compare `serial` and `prefetch` schedules in [solution.py](../../solution.py), holding the stage-06 padded A layout fixed: 32×32×32 tiles, 128 threads, four wave32 groups, packed B, and 4608 bytes of block LDS. The main problem is 1024³ with BF16 inputs/output and FP32 accumulation.

Reproduce from the repository root:

```bash
pixi run python lessons/01-gpu-programming/13-matmul/07-interleaved-loads/profile.py \
  --collect --output /tmp/flydsl-interleaved-fresh
```

Each worker first checks one-, two-, and three-tile boundary cases, then the main trace/random cases. Three subsequent warm-ups and five sampled launches use the fixed 1024³ workload. The counter parser requires three small boundary dispatches and ten full-workload dispatches, and summarizes the final five full-workload dispatches. All checks compare complete outputs and include trailing write sentinels.

Files:

- `summary.json`: final capture, raw samples, resources, source SHA-256 hashes, commands, environment, static ISA counts, main-loop order, and separately measured timing.
- `repeat-summary.json`: preceding successful capture with the same native kernel and collection protocol; predates the collector's full-shape origin-IR check.
- `{serial,prefetch}_counter_collection.csv` and `_agent_info.csv`: original counter/device data.
- `{serial,prefetch}.s`: complete final ISA for the 1024³ specialization.
- `{serial,prefetch}-origin.mlir`: corresponding source IR, confirming full global shapes and loop bounds. Boundary specializations are compiled before the full workload so their dumps do not replace these files.
- `{serial,prefetch}-loop-order.txt`: selected main-loop instructions with line numbers into the complete assembly. Scalar LDS loads and LDS waits are omitted from these short excerpts.
- `{mode}-stdout.txt` and `-stderr.txt`: worker correctness checkpoints, compilation paths, and profiler logs.
- `profiler-version.txt` and `counter-definitions.txt`: exact build information and relevant counter definitions, including the emulated/C1 descriptions.

The serial loop waits for global loads and publishes them before LDS reads and WMMA. The prefetch loop issues next-tile globals at ISA lines 73/85, reads current LDS at 102–105 (plus scalar B loads), executes WMMA at 139/142, waits for VMEM at 143, and writes the future LDS tile at 146/147. This verifies an instruction schedule permitting latency overlap; it is not a cycle-level overlap measurement.

Both schedules report conflict ratio 6.666667%, conflict numerator 524,288, indexed LDS denominator 7,864,320, and dynamic LDS instruction count 4,980,736. Both use 4608 LDS bytes and no scratch; profiler-reported VGPR counts are 56 serial and 64 prefetch. Static instruction-site totals differ because prefetch has a separate prologue and drain; dynamic work remains the same.

Separate uninstrumented synchronized-host medians were 0.3106 ms serial, 0.2849 ms prefetch, and 0.1381 ms GPU torch.matmul. The repeat capture measured 0.2978, 0.2747, and 0.1299 ms. Each used three warm-ups and five batches of 20 launches. GPU events were unavailable; counter-record timestamps were equal and are not used for timing. The roughly 8% lower host-observed time is specific to this workload and environment, not a device-only timing or general guarantee.

Recorded commands contain the original local absolute paths and process IDs as provenance. New captures need not reproduce those paths or IDs. The SDK release and `torch.version.hip` runtime build are recorded separately. gfx1152 has not been hardware-validated.
