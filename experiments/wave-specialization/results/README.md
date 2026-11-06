# Wave-specialization measurement record

The experiment asks whether dedicated loader waves beat compute-wave register prefetch for three declared skinny BF16 GEMMs. A two-slot hardware-barrier schedule establishes a repeatable gain for **32×1024×8192**. The other shapes meet parity with retuned prefetch. The [lesson](../README.md) teaches the ownership and handoffs; this directory retains the search, controls, verification, profiles, and native-code evidence.

## Environment and timing contract

Tested on 2026-11-06 with AMD Radeon 8060S Graphics (`gfx1151`), FlyDSL 0.4.1, PyTorch 2.13.0+rocm10.0.0, reported HIP 7.15.26333, and ROCprofiler-SDK 1.3.5. Reports include the environment, configuration, source hashes, samples, paired ratios, and execution orders. Read-only telemetry and experiment logs remain beside the searches. No gfx1152 execution is claimed.

All implementations receive identical quantized BF16 inputs and a preallocated BF16 output. Native kernels accumulate in FP32. CPU FP32 arithmetic on the actual BF16 inputs, rounded to BF16, checks the complete result outside timing. Output/workspace sentinels, changed-input replay, poisoned output, partial-plane checks, and reset counters are checked separately from performance.

**Graph-host** timing uses synchronized host batches of warm captured replay. Every graph has exactly **32 kernel nodes for 32 GEMMs**, including split-K finalization. Each measured round has seven batches; each batch shuffles all implementation orders and performs 20 graph replays. Reported per-GEMM times divide by 32. Three warm-up callbacks precede sampling. Compilation, allocation, capture, and initial workspace clearing are excluded. Persistent workspace reuse is serialized on one stream.

**Direct-host** timing instead issues 50 ordinary calls per batch and divides by the number of calls. It includes Python dispatch and synchronization. Neither method is an isolated device-event latency measurement. Instrumented profiler timestamps are recorded separately and do not classify performance.

A **win** requires every round's median paired specialized/reference ratio below 0.95. **Parity** requires every round at or below 1.05 when the win criterion fails. A slower classification means at least one round exceeds 1.05. Classification uses paired ratios, not a ratio of two separately aggregated medians.

## Search and select without held-out inputs

| Search family | Raw candidate tuples | Measured | Pruned | Numerical rejections |
| --- | --- | --- | --- | --- |
| [Independent LDS semaphores](20261106-search) | 1150 | 952 | 198 | 0 |
| [Common hardware barriers](20261106-barrier-search) | 848 | 691 | 157 | 0 |
| [Retuned stage-10 prefetch controls](20261106-prefetch-controls) | 390 | 362 | 28 | 0 |
| Total | 2388 | 2005 | 383 | 0 |

These are bounded searches across distinct native source implementations, not an exhaustive Cartesian search of every parameter combination. Each measured candidate passes trace/random products, workspace checks, and changed-input graph replay before its timing enters the ranking. Search rounds use seed **13**, three timing batches, and three replays per batch.

The semaphore coarse grid has 324 tuples per shape: `BM=M`, `BN=32/64/128`, `BK=16/32/64`, loader waves `1/2`, compute waves `1/2/4` along N, slots `1/2/4`, and split counts `1/4`. The initial B cache modifier is 0 for N=1024 and 2 for N=4096. The barrier coarse grid uses the same dimensions with slots `1/2`, giving 216 tuples per shape.

Refinement takes the four leading coarse choices plus the leader for each compute-wave count, then changes one coordinate at a time. Bounds include BM=16/32 where legal, BN through 256, BK through 128, loader waves through 4, slot 3, split 2, B cache modifier 0/2, polling sleep 0/1/2, single-writer/atomic signals, and alternative 2-D compute-wave arrangements. Barrier candidates omit polling/signal variants. Validation requires complete WMMA/copy geometry, equal K partitions, at most eight total waves, and at most 64 KiB LDS. Previously measured tuples are excluded from refinement.

The prefetch control search matches leading specialized tile/wave/split/cache tuples and tests `k_unroll=1/2/4/8`. It also revisits stage 10's independent-wave family at BK=16 with BN=16/32/64/128, `wave_groups=1/2/4/8`, cache 0/2, and unroll 1/4. This distinguishes specialization gains from ordinary tile and cache tuning. The historical stage-10 defaults remain an additional timed reference.

The [count audit](search-audit.json), reproduced by [its host-only source](search-audit-source.txt), accounts for eight trailing invalid wide prefetch tuples absent from the original control report's final snapshot. Its writer saved only after legal candidates. All eight fail the same configuration validator before launch; their configurations and errors are retained in the audit. Original timing samples and reports are unchanged. No legal unmeasured candidate is hidden by this reconciliation.

[Longer confirmation](20261106-confirmation) uses three seed-13 rounds, seven batches, and ten replays per batch, with shuffled candidate orders. Leading prefetch controls are selected first; then the leading candidates from both specialized families are tested in the **final combined factory** against those controls. Selection minimizes the worst training-round ratio to retuned prefetch, breaking ties by the median. [selection.json](selection.json) locks the choices before any held-out measurement.

| Shape | Specialized BM×BN×BK | Compute / loader waves | Slots / split / protocol | Retuned prefetch BM×BN×BK; waves; groups; unroll |
| --- | --- | --- | --- | --- |
| 16×1024×8192 | 16×64×64 | 2 / 1 | 2 / 4 / barrier | 16×64×32; 2; 1; 2 |
| 32×1024×8192 | 32×64×64 | 2 / 1 | 2 / 4 / barrier | 32×64×64; 2; 1; 2 |
| 16×4096×8192 | 16×128×16 | 4 / 2 | 1 / 1 / semaphore | 16×64×16; 1; 2; 4 |

All locked configurations use `group_m=1`, B cache modifier 2, and compute waves along N. Specialized choices use `poll_sleep=0`, `signal_mode="auto"`. Prefetch controls use the same split count as the corresponding specialized choice. The wide prefetch control is the existing stage-10 default.

## Fresh graph verification

Seeds **2026112001–2026112003** each contribute three rounds per shape. The following values are medians of nine round medians, in microseconds:

| Shape | Specialized | Stage-10 default | Retuned prefetch | GPU Torch | Worst paired ratio to retuned / Torch |
| --- | --- | --- | --- | --- | --- |
| [16×1024×8192](20261106-verification/16x1024x8192-graph-host.json) | 21.032 | 23.344 | 21.460 | 34.477 | 0.9817 / 0.6098 |
| [32×1024×8192](20261106-verification/32x1024x8192-graph-host.json) | 25.634 | 28.970 | 27.664 | 59.056 | **0.9326** / 0.4414 |
| [16×4096×8192](20261106-verification/16x4096x8192-graph-host.json) | 272.233 | 273.419 | 273.459 | 289.983 | 0.9972 / 0.9425 |

M=32 wins against **both** prefetch references in all nine rounds. M=16, N=1024 wins against the historical default but reaches parity against the retuned control. N=4096 reaches parity with both prefetch references. All 27 primary rounds pass the Torch win criterion.

An [independent M=32 repeat](20261106-evidence/repeat-32x1024-graph.json) uses new seeds **2026112101–2026112103**, with no retuning. Times are **25.764 / 29.179 / 27.571 / 59.093 µs** for specialized / historical prefetch / retuned prefetch / Torch. Its worst specialized/retuned ratio is **0.9342**. Thus **18/18 independent verification rounds** meet the 5% win threshold against retuned prefetch. Median time reductions versus retuned prefetch are 7.34% in primary verification and 6.55% in the repeat. This supports an approximately 7% captured-throughput improvement for this declared workload.

## Ordinary calls have different costs

The same locked configurations and primary verification seeds were checked with direct-host timing:

| Shape | Specialized, µs | Retuned prefetch, µs | GPU Torch, µs | Versus retuned prefetch |
| --- | --- | --- | --- | --- |
| [16×1024×8192](20261106-verification/16x1024x8192-direct-host.json) | 57.536 | 53.307 | 35.091 | Slower; worst ratio 1.1606 |
| [32×1024×8192](20261106-verification/32x1024x8192-direct-host.json) | 57.751 | 53.574 | 58.981 | Slower; worst ratio 1.1240 |
| [16×4096×8192](20261106-verification/16x4096x8192-direct-host.json) | 274.223 | 274.943 | 290.923 | Parity; worst ratio 1.0008 |

The wide direct Torch comparison narrowly passes the strict threshold, with worst ratio 0.9497. Narrow direct Torch comparisons fail it. The new lesson therefore demonstrates a workload- and launch-path-specific scheduling gain; it does not justify replacing prefetch across every shape or Python call path.

## Profile the winning pair

The [specialized profile](20261106-evidence/profile-specialized-32x1024/summary.json) and [retuned prefetch profile](20261106-evidence/profile-retuned-prefetch-32x1024/summary.json) use the same M=32 tile, compute-wave, split, and B cache parameters. Each counter group captures eight native and eight Torch dispatches in alternating order after 20 warmups, using selected ROCTx regions. Counter groups run in separate processes. Raw CSVs, worker configuration/source metadata, exact commands, profiler version, and SDK counter definitions remain in each profile directory.

| Native metric, median per dispatch | Specialized | Retuned prefetch |
| --- | --- | --- |
| `SQ_WAVES_sum` | 192 | 128 |
| `SQ_INSTS_TEX_LOAD_sum` | 49152 | 49152 |
| `SQ_INSTS_TEX_STORE_sum` | 1280 | 1280 |
| `SQ_INSTS_LDS_sum` | 638976 | 638976 |
| `SQ_INSTS_VALU_sum` | 145632 | 133920 |
| `SQ_INSTS_SALU_sum` | 48416 | 13536 |
| `LDSBankConflict` | 0 | 0 |
| `SQC_LDS_IDX_ACTIVE_sum` | 983040 | 983040 |
| `ALUStalledByLDS`, % | 49.4722 | 65.2296 |
| `SQ_WAIT_INST_LDS_sum` | 1741574.5 | 1829547.5 |
| `GL1C_GL2_REQ_READ_128B_sum` | 145833 | 144266 |
| `GL2C_EA_RDREQ_128B_sum` | 135202 | 135187 |
| `MemUnitBusy`, % | 66.2381 | 75.7275 |

The same load/LDS instruction counts and almost equal external requests support interpreting this as a scheduling experiment. It does not reproduce stage 10's roughly halved L1-to-L2 request count. Additional loader waves change the population counted by stall metrics; those percentages are not wall-time shares, and the profile does not prove which cycles overlap. Both bank-conflict metrics are zero.

Separate instrumented trace medians are 24.1395 µs native / 50.958 µs Torch in the specialized pass and 26.319 / 58.6385 µs in the prefetch pass. Torch's variation across processes illustrates why these timestamps are not substituted for the four-way paired verification above.

## Inspect the native kernels

| Compiler metadata | [M=32 barrier](20261106-evidence/inspection-32x1024/summary.json) | [Wide semaphore](20261106-evidence/inspection-wide/summary.json) |
| --- | --- | --- |
| LDS bytes | 25600 | 4880 |
| VGPR count | 198 | 46 |
| SGPR count | 22 | 15 |
| Private scratch bytes | 0 | 0 |
| Static workgroup-barrier instruction sites | 4 | 1 |

Static sites are not dynamic barrier counts. The default M=32 kernel executes one prologue and 31 steady-state barriers per partition. Barrier production builds contain no LDS counter polling; their debug builds separately record slot arrivals. The wide semaphore dump uses LDS acquire/release handoffs and has no global-cache invalidation for split_k=1. Split-K M=32 retains agent-scope acquire/release global publication and release counter reset. Dumps retain final LLVM IR and ISA; intermediate compiler passes were removed to keep the artifact set smaller.

Profiler resource fields are retained independently: its M=32 trace reports 248 VGPRs and 128 SGPRs for both native strategies, 25600 versus 12800 LDS bytes, and zero scratch. Those runtime fields differ from the inspector's compiler counts. Neither is used here to infer occupancy or per-role register allocation. Separate role branches do not establish that loader waves receive a smaller physical register allocation.

## Source provenance and checks

Each search directory retains its native/tuner or orchestrator source snapshots. The initial semaphore source constructed role metadata in separate branches. The final solution uses shared metadata construction and selects either protocol. The common-barrier prototype is archived as text in its search directory rather than retained as a second runnable lesson implementation. All finalists were rechecked and confirmed using the combined factory before held-out measurement.

The current native factory and all seven primary/repeat verification reports share SHA-256 **`97353a7926ca7d56fa28d42aa5939d4d86954ad81d0fbd1a87f3e0d9dc5e8536`**. Full-file hashes can differ after host default/checker changes; factory hashes isolate the actual native builder. The [audit](search-audit.json) checks this agreement. Prefetch-control reports retain the original generic harness environment and explicit `candidate_factory_sha256` / `candidate_source_sha256` fields identifying the actual stage-10 candidate implementation.

[The full course run](20261106-evidence/course-check.log) passes **all 32 native solutions** plus the extra mapping/composition/coalesce/sliced-load checks. Lesson 11 exercises all nine shape/split combinations. A temporary completed practice has the same AST as the solution and passes [all nine checks](20261106-evidence/completed-practice-all.log) and [its ordinary benchmark CLI](20261106-evidence/completed-practice-cli.log). The [solution CLI](20261106-evidence/solution-cli.log) also passes; the repository's [unfinished starter](20261106-evidence/unfinished-practice.log) reports its intended missing compute-thread expression. All measured graphs validate node counts, mutated inputs, NaN output replacement, sentinels, and workspace reset.

## Repeat the measurements

Run from the repository root and choose a fresh output path:

```bash
# Verify the locked M=32 choice against Torch and both prefetch controls.
pixi run python experiments/wave-specialization/tune.py \
  --verify --shape 32 1024 8192 --timing graph-host \
  --seeds 2026112001 2026112002 2026112003 \
  --output /tmp/wave-specialization-graph.json

# Check ordinary dispatch with the same locked choices.
pixi run python experiments/wave-specialization/tune.py \
  --verify --shape 32 1024 8192 --timing direct-host \
  --output /tmp/wave-specialization-direct.json

# Search the current default protocol, then its local refinement.
pixi run python experiments/wave-specialization/tune.py \
  --sweep --shape 32 1024 8192 --output /tmp/wave-coarse.json
pixi run python experiments/wave-specialization/tune.py \
  --sweep --shape 32 1024 8192 --refine /tmp/wave-coarse.json \
  --output /tmp/wave-refine.json

pixi run python experiments/wave-specialization/inspect_kernel.py \
  --shape 32 1024 8192 --output /tmp/wave-inspection
pixi run python lessons/01-gpu-programming/13-matmul/09-split-k/profile.py \
  --module experiments/wave-specialization/solution.py \
  --shape 32 1024 8192 --pairs 8 --output /tmp/wave-profile
```

`--shape 16 1024 8192` or `--shape 16 4096 8192` selects the other locked choices. `--config` and `--prefetch-config` take explicit JSON objects; verification otherwise loads the retuned control from `selection.json`. `--configs` supplies a JSON list for an explicit search, including `protocol="semaphore"` where desired. The current default coarse generator follows the final barrier configuration and includes slots 1/2/4; its output is not a claim to reproduce the historical 216-tuple barrier coarse set byte-for-byte.

To replay a historical native implementation, pass `--module` with its archived source text path, such as `results/20261106-search/solution-source-snapshot.txt` (relative to the lesson directory). Exact candidate rows and historical orchestrators are retained alongside it. Compare the resulting source/factory hashes before associating any new timing with an old report. Reusing the same seeds reproduces an existing verification protocol; it does not create a fresh held-out experiment.
