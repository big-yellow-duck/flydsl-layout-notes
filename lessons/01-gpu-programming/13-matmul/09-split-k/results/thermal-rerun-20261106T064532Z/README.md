# Verification after reported cooling repair

Repeated on 2026-11-06 after the owner reported fixing the hardware thermal issue. Kernel code, locked configurations, verification seeds, and timing methods are unchanged. The original reports remain in the parent directory; this repeat does not select new configurations or introduce new held-out seeds.

| Shape (M,N,K) | Mode | Native µs | GPU Torch µs | Worst paired native/Torch ratio | Result |
| --- | --- | ---: | ---: | ---: | --- |
| 16,1024,8192 | graph-host | 22.74 | 34.40 | 0.6696 | [win](verification-16x1024x8192-graph-host.json) |
| 16,1024,8192 | direct-host | 52.72 | 35.70 | 1.7274 | [slower](verification-16x1024x8192-direct-host.json) |
| 32,1024,8192 | graph-host | 29.16 | 64.98 | 0.4664 | [win](verification-32x1024x8192-graph-host.json) |
| 32,1024,8192 | direct-host | 54.10 | 59.29 | 1.0425 | [match](verification-32x1024x8192-direct-host.json) |
| 16,4096,8192 | graph-host | 302.02 | 290.84 | 1.0410 | [match](verification-16x4096x8192-graph-host.json) |
| 16,4096,8192 | direct-host | 302.13 | 291.38 | 1.0440 | [match](verification-16x4096x8192-direct-host.json) |

Each result contains nine rounds: three seeds, three rounds per seed, seven alternating native/Torch batches per round. Graph batches repeat a 32-GEMM capture 20 times; direct batches make 50 ordinary calls. The win criterion requires every round ratio below 0.95; parity requires every round at or below 1.05. Graph medians give about 1.51× and 2.23× throughput for the two split-K cases. The wide no-split fallback is approximately 4% slower than Torch and remains within the declared parity band.

Correctness, boundary partials, sentinels, changed-input workspace reuse, counter reset, and mutated-input graph replay passed. Every native graph capture still has exactly 32 kernel nodes for 32 GEMMs, with no clear or reduction launch. Allocation and one-time workspace initialization remain outside timing.

[Telemetry](telemetry.json) sampled GPU temperature, clocks, power, and utilization once per second (52 samples). The GPU edge sensor ranged from 43 to 72 °C. [Comparison metadata](comparison-metadata.json) confirms identical source hashes, configurations, and seeds against the original reports.

| Shape | Original graph native µs | Rerun graph native µs | Original graph Torch µs | Rerun graph Torch µs |
| --- | ---: | ---: | ---: | ---: |
| 16,1024,8192 | 78.76 | 22.74 | 126.64 | 34.40 |
| 32,1024,8192 | 124.25 | 29.16 | 260.27 | 64.98 |
| 16,4096,8192 | 923.24 | 302.02 | 933.61 | 290.84 |

These are synchronized host-batch measurements under the recorded timing mode. Compare native and Torch within each mode; these results do not establish direct-call wins for the split configurations. The earlier thermally affected training and verification records are historical measurements.

[Lesson summary](../../README.md#locked-verification-on-gfx1151) · [All records](../README.md)
