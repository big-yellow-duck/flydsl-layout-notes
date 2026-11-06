# Profile the actual Torch skinny GEMM

Torch dispatches these products to **hipBLASLt 1.4.1**. Logging, the installed library's decoded solution records, and the profiler's kernel symbols agree on the selected solutions. All three use BF16 `v_wmma_f32_16x16x16_bf16`, ordinary global/register/LDS prefetch, and **no global split-K, local split-K, or Stream-K**. Their metadata disables direct-to-register and direct-to-LDS operand paths. These are observations of the installed binaries, rather than conclusions from the library's available algorithms.

Tests ran on 2026-11-06 with Radeon 8060S (`gfx1151`), FlyDSL 0.4.1, Torch 2.13.0+rocm10.0.0, reported HIP 7.15.26333, and ROCprofiler SDK 1.3.5. Inputs and output are contiguous row-major BF16, with FP32 accumulation. Torch receives a preallocated output, alpha=1 and beta=0, with no bias or activation. The generic kernel names mention optional features that are inactive in these calls.

## Identify the strategy before interpreting counters

| Logical shape M,N,K | hipBLASLt solution | Logical output tile M,N | K chunk | Wave32 groups | Global prefetch | Static LDS bytes | VGPR / SGPR |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 16,1024,8192 | 753 | 16,64 | 128 | 4 | 1 | 53504 | 256 / 70 |
| 32,1024,8192 | 754 | 16,32 | 64 | 2 | 2 | 14528 | 128 / 70 |
| 16,4096,8192 | 761 | 16,32 | 16 | 2 | 2 | 3728 | 80 / 70 |

Each binary has zero private scratch. Static ELF LDS sizes differ from the profiler's rounded runtime allocations (53760, 14848, and 4096 bytes). Resource counts alone do not measure occupancy. The `PrefetchGlobalRead` field describes the library's schedule, rather than a measurement of concurrent memory operations.

Torch presents row-major `C=A@B` to the column-major BLAS interface as `Cᵀ=Bᵀ@Aᵀ`. Consequently library M is our N, and library N is our M. Swap the library's macro-tile axes before comparing output ownership. The matrix instruction field is `[16,16,16,1]`; the name's `MI16x16x1` does not mean K=1.

The [decoded records and actual disassemblies](results/20261106/torch-isa/summary.json) retain source/binary hashes, kernel metadata, address ranges, and disassembly commands. `inspect_library.py` matches each logged solution index to the actual profiled symbol. It unbundles the compressed installed code object with the installed LLVM tool, rather than substituting a similar upstream kernel.

## What limits the current kernels?

Eight alternating pairs per shape were collected separately for each counter group. The native control is lesson 11's selected kernel. Values below are per-dispatch medians; collection passes and instrumented durations are separate from ordinary throughput timing.

| Shape M,N,K | Native / Torch LDS instructions | Native / Torch LDS bank-conflict metric | Native / Torch 128-byte L1→L2 read requests | Native / Torch memory-unit busy |
| --- | --- | --- | --- | --- |
| 16,1024,8192 | 598016 / 1147136 | 0 / 5.00% | 137768 / 145457 | 77.17 / 49.89% |
| 32,1024,8192 | 638976 / 2425344 | 0 / 9.09% | 144692 / 473026 | 72.90 / 83.34% |
| 16,4096,8192 | 3854555 / 4850688 | 1.38 / 23.07% | 533050 / 1230042 | 97.60 / 99.86% |

The wide Torch kernel issues about **2.3 times** as many 128-byte L1→L2 reads as the current native kernel. Its larger L2 hit count accompanies extra requests; that count alone is not an optimization objective. External 128-byte read requests are much closer: 526338 versus 542028. These are GPU cache-interface counters on an APU; they are not a direct DRAM bandwidth measurement.

For M=32, Torch splits the output's M dimension into two tiles. The native 32-row tile reuses each B tile across more output rows. Torch also has substantially more LDS instructions and LDS stalls. In our own ISA, A already uses vector LDS reads, while B requires many 16-bit LDS reads. The profiles suggest reducing unnecessary operand movement and preserving coalesced B accesses. They do not establish a single cause for elapsed-time differences.

[torch-study.json](results/20261106/torch-study.json) condenses all counter groups and resources. Raw dispatches, metric definitions, commands, version metadata, correctness checks and hashes are retained in the three `profile-*` directories. The exact definitions of the bank-conflict and memory-busy metrics are recorded there; they should not be interpreted as fractions of wall time.

## Reproduce the Torch investigation

Run from the repository root, using fresh output directories:

```bash
pixi run python experiments/torch-strategy/collect.py --output /tmp/torch-study
uv run --with msgpack --with pyelftools python \
  experiments/torch-strategy/inspect_library.py \
  --profiles /tmp/torch-study --output /tmp/torch-study/torch-isa
python experiments/torch-strategy/summarize.py \
  --input /tmp/torch-study --output /tmp/torch-study/torch-study.json
```

`collect.py` logs backend selection with `HIPBLASLT_LOG_MASK=42` in a separate process, then invokes the course's ROCprofiler collector. Logging is outside timing. `torch_call.py` independently checks the full result against CPU FP32 arithmetic on the actual BF16 inputs, signed input changes, NaN output replacement and sentinels. The collector does the same checks around profiling. The library inspector is specific to the pinned gfx1151 package paths and needs msgpack/pyelftools only for offline extraction.

The [hipBLASLt logging reference](https://rocm.docs.amd.com/projects/hipBLASLt/en/develop/reference/env-variables.html) explains the trace/info/benchmark mask. AMD's [TensileLite inspection walkthrough](https://rocm.blogs.amd.com/artificial-intelligence/reverse-hipblaslt-tensilelite/README.html) explains the library metadata and naming conventions. Cache-policy bit meanings are documented by [LLVM](https://clang.llvm.org/docs/AMDGPUBuiltinReference.html) and the [RDNA3.5 ISA reference](https://docs.amd.com/api/khub/documents/UVVZM22UN7tMUeiW_4ShTQ/content).

## Experiments motivated by the profile

The promising route is now [lesson 12 · Operand paths](../../lessons/01-gpu-programming/13-matmul/12-operand-paths/README.md). A direct WMMA-compatible A path improves the narrow workloads while preserving B's coalesced staging. The wide workload selects the existing A/B staging path. The matrix instruction and single-kernel FP32 split-K finalization stay the same.

| Tested idea | Observation on training inputs |
| --- | --- |
| Physically transpose B in LDS, with padding | Correct vector-friendly operand layout, but scalar staging stores made the selected M=32 geometry slower; best padding pilot about 28.5 µs |
| Swizzle the transposed B layout | Wider operand reads alone did not repay staging cost; tested valid variants remained slower |
| Wave-shuffle 8×8 and 4×8 B patches before vector LDS stores | Native checks passed, but shuffle, staging and access-pattern costs outweighed the read savings |
| Direct global WMMA reads for both operands | Wide pilots took roughly 0.83–1.20 ms versus about 0.27 ms for the controls; B's narrow strided reads were costly |
| Stagger K starts between blocks | Whole-partition cyclic traversal was correct, but all nonzero wide pilots lost to the zero-stagger control |
| Direct A reads, coalesced B staging | Worth refining; the final lesson selects it for the two narrow shapes |
| Cache policy bits 0–7 | Target-specific effects mattered. For example, policies 4–7 substantially slowed the M=32 direct-A pilot. The selected policies remain A=0, B=2 |

These observations describe the tested adaptations, not a claim that those ideas cannot work on other GPUs or geometries. The [native-source archive and manifest](results/native-sources/manifest.json) preserve every prototype verbatim. Their factory hashes match all recorded prototype probe reports. The stored reports' `module` paths are their original locations; use the manifest's archive path to replay them.

The initial swizzle pilot rejected three cases because its **packed control** incorrectly retained the candidate's 128-bit strided operand atom. That harness error was corrected and the complete six-case pilot rerun as `swizzle-pilot-v2-*`; the valid rerun has zero numerical rejections. Those exploratory pilots are separate from the final lesson's search totals.

The main mixed-path search has three phases:

| Phase | Proposed measurements | Measured | Pruned | Numerical rejections |
| --- | --- | --- | --- | --- |
| Coarse tile/wave/split grid | 216 | 192 | 24 | 0 |
| One-coordinate refinement, including A-path ablations | 252 | 205 | 47 | 0 |
| Focused combinations around new leaders | 44 | 44 | 0 | 0 |
| Total | **512** | **441** | **71** | **0** |

Counts include repeated settings measured in different phases. Coarse bounds are BM=16/32 as legal, BN=32/64/128, BK=16/32/64, one/two/four compute waves, split counts 2/4 for narrow N or 1/4 for wide N, and unroll 4. Refinement adds BN through 256, BK through 128, independent groups 1/2/4/8, split 1/2/4, unroll 1/2/4/8/16, M-wave alternatives, A/B policies 0/2, and direct/staged A. Focused combinations revisit K=32/64 and unroll 4/8/16. Full tiles, complete copy domains and the LDS bound are enforced before launch.

Every measured configuration passes full trace/random CPU-reference checks, workspace guards, and changed-input graph replay. Each capture has exactly one kernel per GEMM. Baselines are separately retuned prefetch and wave specialization, GPU Torch, and same-geometry prefetch where valid. Three finalists per shape receive full tagged boundary checks and three longer shuffled confirmation rounds on training seed 13. Selection then locks before held-out inputs; see the [lesson's complete verification](../../lessons/01-gpu-programming/13-matmul/12-operand-paths/results/README.md).

Replay an archived pilot or the final search with explicit stored configuration lists:

```bash
pixi run python experiments/torch-strategy/probe.py \
  --module experiments/torch-strategy/results/native-sources/transpose_b-source.txt \
  --shape 32 1024 8192 \
  --configs experiments/torch-strategy/results/20261106/transpose-pilot-configs-32x1024x8192.json \
  --output /tmp/transpose-replay.json
pixi run python experiments/torch-strategy/probe.py \
  --shape 32 1024 8192 \
  --configs experiments/torch-strategy/results/20261106/operand-refine-configs-32x1024x8192.json \
  --output /tmp/operand-refine-replay.json
pixi run python experiments/torch-strategy/confirm.py \
  --search experiments/torch-strategy/results/20261106 \
  --output /tmp/operand-confirmation
```

`probe.py` uses seed 13 and records all configurations, samples, shuffled orders, reference configurations and native source/factory hashes. Its `specialized` result key means the candidate under test; `wave_specialized` is the dedicated-wave control. Reusing a seed repeats that experiment rather than creating new held-out evidence.

The current [lesson-12 benchmark](../../lessons/01-gpu-programming/13-matmul/12-operand-paths/results/README.md) compares operand paths directly with prefetch. Its native kernel and locked configurations remain unchanged; wave specialization is excluded from its active harness. The original confirmation helper is archived as [confirm-source.txt](../../lessons/01-gpu-programming/13-matmul/12-operand-paths/results/confirmation/confirm-source.txt); the current `confirm.py` ranks finalists against prefetch.
