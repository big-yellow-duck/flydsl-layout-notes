# Small-M BF16 GEMM tuning

The lesson-12 kernel supports M=1,2,4,8 with explicit configurations at N=K=1024 and 2048. Tuned graph replay throughput beats GPU Torch on all eight shapes on Radeon 8060S (`gfx1151`). Torch remains faster for ordinary Python calls, where the native wrapper dominates these short computations.

Times below are microseconds per GEMM, reported as medians of three held-out run medians. Native and Torch use the same contiguous row-major BF16 inputs and preallocated BF16 output. Native accumulates in FP32. No input packing, padding allocation or auxiliary padding kernel is used.

| M | N=K | Native graph | Torch graph | Torch / native | Native ordinary call | Torch ordinary call |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| 1 | 1024 | 4.82 | 7.44 | 1.54× | 87.67 | 11.73 |
| 2 | 1024 | 4.88 | 7.51 | 1.54× | 89.88 | 11.24 |
| 4 | 1024 | 4.86 | 7.43 | 1.53× | 88.90 | 12.05 |
| 8 | 1024 | 4.85 | 7.43 | 1.53× | 89.44 | 11.70 |
| 1 | 2048 | 10.83 | 17.23 | 1.59× | 90.23 | 21.36 |
| 2 | 2048 | 10.81 | 17.16 | 1.59× | 88.59 | 20.86 |
| 4 | 2048 | 10.82 | 17.18 | 1.59× | 89.54 | 21.45 |
| 8 | 2048 | 10.84 | 17.26 | 1.59× | 89.55 | 21.50 |

## Native M-tail support

WMMA still computes a 16-row tile. Logical A/C views round M up to the block height, while their buffer descriptors bound accesses to the actual `M*K*2` and `M*N*2` bytes. Missing A rows read zero and C stores beyond M are discarded by the buffer instructions. This avoids allocating padded matrices. N/K must still contain complete tiles. Launch grid, grouped traversal and split-K workspace sizing count M tiles with ceiling division. Complete M tiles preserve the earlier unbounded descriptor path.

The practice scaffold and solution contain the same tail support; the practice retains its two operand-path TODOs. The three original default selectors are unchanged. New shapes use the public launcher's explicit `config=` argument or the benchmark tool's configuration file.

## Search and selections

Each shape tests 31–32 unique configurations. The coarse search covers four wave arrangements: 16×32 single-wave tiles, 16×64 independent packed wave tiles, and 16×64/16×128 tiles with two cooperating waves. It crosses K chunks 32/64 with split counts 1/4, initially using direct A, unroll 2 and B cache policy 2. The two fastest candidates are refined over unroll 1/4/8, B policies 0/1, split count 2, the A-through-LDS control and K chunk 16. Duplicate settings are evaluated once. This bounded search does not exhaustively cross all refinement settings.

All eight winners use a **16×64 output tile, K chunk 32, two cooperating waves, split-K=4, direct A registers and A/B cache policies 0/2**. M grouping is 1. Unroll is 2 for M=1,4 at N=K=1024; 1 for M=2,8 at N=K=1024; and 4 for all N=K=2048 cases. Small timing differences between unroll choices should not be treated as a general rule based on M. The full 16-row WMMA still executes for every M below 16, which helps explain their similar native times.

Training uses seed 13 and three shuffled batches of three graph replays each. Every candidate passes full-output random validation before timing. Selection is locked before fresh seeds 29,47,71 are measured with seven shuffled batches and ten repeats per batch for both graph and ordinary dispatch. Each captured graph performs 32 GEMMs and the capture helper checks changed-input replay, output sentinels and workspace state. The selected configurations also pass the lesson's structured/random, signed workspace reuse and tagged K-boundary checker. This is one session on gfx1151; gfx1152 remains untested.

The [raw report](20261113-small-m-tuning/report.json) records all candidates, held-out samples, orders, graph metadata, configuration dictionaries, environment and source hash. [Selected configurations](20261113-small-m-tuning/configurations.json) can be reloaded without tuning. The [tail-validation record](20261113-small-m-tuning/tail-validation.json) checks full sentinel regions beyond logical A/C rows for M=1,2,4,8,17,31, both A routes, independent and single-wave groups, and split-K reuse. It also checks all nine original shape/split combinations and completed-practice AST equivalence with the solution.

## Reproduction

From the repository root, using fresh output paths:

```bash
pixi run python tools/tune_operand_square.py --small-m --output /tmp/operand-small-m
pixi run python tools/check_operand_m_tails.py --output /tmp/operand-tail-validation.json
pixi run python tools/measure_operand_wave_tiles.py \
  --configurations lessons/01-gpu-programming/13-matmul/12-operand-paths/results/20261113-small-m-tuning/configurations.json \
  --selected-only --include-torch --seeds 101 \
  --output /tmp/operand-small-m-confirmation.json
```

Add `--timing direct-host` to the comparison command for ordinary dispatch. Graph timings are synchronized host throughput per GEMM; ordinary calls include the public Python launcher. Allocation and CPU reference computation are outside timing. Compare paired results within the same report, rather than combining absolute times from different sessions.
