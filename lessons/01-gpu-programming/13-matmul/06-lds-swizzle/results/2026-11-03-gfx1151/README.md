# gfx1151 LDS-layout capture · 2026-11-03

This capture compares the three compile-time modes in [solution.py](../../solution.py). The input problem is 1024³, BF16 A/B/C with FP32 accumulation, row-major global storage, 32×32×32 blocks, four wave32 groups, and 128 block threads. Only A's physical LDS placement changes. B and the MMA ownership remain fixed.

Reproduce from the repository root:

```bash
pixi run python lessons/01-gpu-programming/13-matmul/06-lds-swizzle/profile.py \
  --collect --output /tmp/flydsl-lds-fresh-capture
```

The collector runs the full trace/random checker and sentinels for each mode, then three warm-ups and five sampled matmuls. Only `exercise_kernel` dispatches are selected. Ten dispatches must be present; the last five are summarized. Counter results repeated exactly across both captures. Separate uninstrumented timing uses the existing common benchmark and independent full-output validation.

Files:

- `summary.json`: final capture, five raw samples per counter, source SHA-256 hashes, command arguments, environment, static ISA counts, resources, and separate timing metadata/results.
- `repeat-summary.json`: preceding complete capture with the same native kernel and collection protocol; shows host-timing variation. It predates the collector's ISA-count and source-hash reporting additions.
- `{packed,swizzle,padded}_counter_collection.csv`: original counter CSVs, including all ten matmul dispatches.
- `{packed,swizzle,padded}_agent_info.csv`: original profiler device records.
- `{packed,swizzle,padded}.s`: final ISA for each specialization, copied from the compiler dump.
- `{mode}-stdout.txt` and `{mode}-stderr.txt`: worker correctness checkpoints, compiler dump paths, and profiler logs.
- `profiler-version.txt`: exact installed profiler build information.
- `counter-definitions.txt`: relevant verbatim blocks from `rocprofv3 --list-avail`, including the conflict-ratio formula and the emulated/C1 event descriptions.

The final swizzle conflict ratio is 30.769231%, versus packed 46.153846% and padded 6.666667%. This confirms a reduction for the specified profiler metric, not conflict freedom. The swizzle increases LDS instructions and VGPR use; its host timing changes ordering relative to packed between captures. Padding preserves vector loads and is faster in both recorded host-timed captures. No GPU-event, profiler-duration, or gfx1152 performance claim is made: GPU events were unavailable and counter-record start/end timestamps were equal.

Recorded commands contain the original local absolute paths and process IDs as provenance. New captures need not reproduce those paths or IDs. The captured `rocm_version` is the SDK release; `torch.version.hip` separately reports the HIP runtime build. These are distinct version strings.
