# Skinny split-K measurements

The [2026-11-12 CTA-counter experiment](cta-counters-20261112/README.md) compares one counter per CTA with the completed practice's per-thread counters using identical compute, partial layout, and FP32 traffic. All correctness and reuse checks passed; paired timing differences were below 1%, so it does not establish a useful performance gain.

The latest three-shape locked verification is the [repeat after the reported cooling repair](thermal-rerun-20261106T064532Z/README.md). It uses identical source code, configurations, seeds, and timing methods, records GPU telemetry, and supersedes the absolute timings below. Graph replay measured **1.51×** and **2.23×** throughput on the two split-K shapes; the wide fallback stayed within the 5% parity band. Direct verification classified the three cases as slower, parity, and parity respectively.

The [expanded wide-case search](wide-exhaustive-20261106T065525Z/README.md) subsequently enumerated all 1080 complete tile/wave/split combinations in the current kernel family. All 132 legal configurations passed correctness; the training-selected candidate and existing default both remained about 4% slower than Torch on fresh seeds. The defaults are unchanged.

## Original run before the reported repair

Measured on 2026-11-06 using Radeon 8060S Graphics (`gfx1151`), FlyDSL 0.4.1, PyTorch 2.13.0+rocm10.0.0, and reported HIP 7.15.26333. Inputs are contiguous row-major BF16; native accumulation and workspace partials are FP32; output is BF16. All operations execute on the GPU. CPU FP32 arithmetic is the untimed correctness reference.

| Shape (M,N,K) | Training samples | Locked graph verification | Locked direct verification |
| --- | --- | --- | --- |
| 16,1024,8192 | [102 candidates](training-16x1024x8192.json) | [Win, all 9 rounds](verification-16x1024x8192-graph-host.json) | [No all-round win](verification-16x1024x8192-direct-host.json) |
| 32,1024,8192 | [225 candidates](training-32x1024x8192.json) | [Win, all 9 rounds](verification-32x1024x8192-graph-host.json) | [No all-round win](verification-32x1024x8192-direct-host.json) |
| 16,4096,8192 | [102 candidates](training-16x4096x8192.json) | [Parity, split K disabled](verification-16x4096x8192-graph-host.json) | [Parity](verification-16x4096x8192-direct-host.json) |

The [wide-case training confirmation](training-wide-confirmation.json) rotates four candidates through three longer rounds using seed 13. An apparent split-K win in a short sweep did not survive that training confirmation; the no-split fallback was locked before held-out verification. The narrow configurations retain the illustrated staging geometry and were selected from near the leading training candidates.

Training used seed 13, with a separate trace input. Graph verification used fresh seeds 2026110801–2026110803; direct verification used 2026110811–2026110813. Every seed has three rounds, each containing seven alternating native/Torch batches. Graph batches repeat a 32-operation capture 20 times; direct batches make 50 ordinary calls. Five warm-up batches precede measurement. Samples, pairing orders, and source/configuration metadata are retained rather than only the best result.

Graph captures have exactly 32 kernel nodes for 32 GEMMs, with no clear, memset, or separate reduction node. Captures are checked by negating A, poisoning output with NaNs, replaying, checking the full product and sentinels, restoring A, and replaying again. Counter reset and workspace sentinels are checked as well. One-time workspace allocation/initialization is outside timing, and workspace is reused serially on the same stream.

Times are synchronized host-clock measurements. Graph replay amortizes Python dispatch; direct measurements retain it. Neither is an isolated instruction-duration measurement. The strict win criterion requires **every round** to have a median paired native/Torch ratio below 0.95; parity requires every round to stay at or below 1.05. A favorable median alone does not establish an all-round win. Absolute times varied during the sustained sweeps; compare each native sample with its paired Torch sample under the same mode.

[inspection.json](inspection.json) records the default kernel's static LDS/register resources and confirms BF16 WMMA plus the agent-scope acquire/release arrival atomic. Reproduce the raw ISA/LLVM dump using `inspect_kernel.py --output /tmp/skinny-instructions`. The raw dump path in the report identifies the local capture; the reproducible inspector is checked in.

Training reports were captured before locking the final shape-selection table. Their whole-file source hashes can differ from the selected solution's hash; their `kernel_build_sha256` identifies the unchanged kernel factory. The verification and instruction reports record the selected source. These observations concern the declared warmed-buffer workloads on gfx1151; gfx1152 and other shapes need separate validation.

See [the lesson](../README.md#locked-verification-on-gfx1151) for the selected configurations, summary table, and reproduction commands.
