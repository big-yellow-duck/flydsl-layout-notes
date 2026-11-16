# Square BF16 GEMM tuning

The lesson-12 kernel also supports square `(1024,1024,1024)` and `(2048,2048,2048)` GEMMs through explicit configurations. A bounded search of 50 candidates per shape finds a clear win over GPU Torch at 2048³. At 1024³, graph replay is close to parity and Torch wins ordinary Python dispatch. The three original skinny selectors remain unchanged.

Measurements ran on Radeon 8060S (`gfx1151`) with the pinned environment recorded in the [raw report](20261113-square-tuning/report.json). Both implementations use contiguous row-major BF16 inputs, FP32 accumulation and preallocated BF16 output; there is no input packing. Times are microseconds per GEMM, reported as medians of three held-out run medians.

| M=N=K | Native graph | Torch graph | Torch / native | Native ordinary call | Torch ordinary call |
| --- | ---: | ---: | ---: | ---: | ---: |
| 1024 | 72.41 | 73.10 | 1.01× | 79.44 | 70.16 |
| 2048 | 425.76 | 534.20 | 1.25× | 433.92 | 560.87 |

For 2048³, native reduces graph replay time by about 20% and ordinary-call time by about 23%. All three held-out graph paired ratios are 0.795–0.799; ordinary-call ratios are 0.771–0.777. For 1024³, graph ratios are 0.984–0.994, a small difference that does not meet the course's 5% win threshold. Ordinary-call ratios are 1.126–1.146, favoring Torch.

## Selected configurations

| M=N=K | Output tile | K chunk | Cooperating waves | Independent groups | Split K | M grouping | Unroll | A/B cache policies | A route |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1024 | 128×128 | 32 | 2×2 | 1 | 1 | 4 | 2 | 0/0 | Registers |
| 2048 | 64×64 | 64 | 1×2 | 1 | 1 | 4 | 2 | 0/1 | Registers |

Both selections use cooperating waves. Independent wave-local tiles were included in the search and did not win. The result extends the shape-specific conclusion from the [wave-local tile comparison](wave-tiles.md); it does not establish a universal preference for one wave arrangement.

The coarse search covers eight tile/wave arrangements with output tiles from 32×64 through 128×128, K chunks 32/64, and both register and LDS routes for A. The two fastest coarse configurations are refined over unroll 1/4/8, M grouping 1/8, B cache policies 0/1, and split counts 2/4, alongside their original settings. Training uses seed 13, three shuffled batches and three replays per batch. This is a bounded search, not an exhaustive optimum; combinations of all refinement settings are not exhaustively crossed.

Each candidate passes full-output random validation before timing. After selection is locked, the lesson's complete structured/random, signed workspace reuse, sentinel and tagged K-boundary checker passes. Verification then uses fresh seeds 29, 47 and 71, seven shuffled batches and ten repeats per batch for each timing mode. Captured graphs contain 32 GEMMs and verify changed-input replay using the existing capture helper. Graph replay timings measure synchronized host throughput divided by 32; ordinary calls include the native Python wrapper. Allocation and CPU reference computation are outside timing. These are same-session observations on gfx1151, not validation on gfx1152.

## Reproduction

Run the search and verification from the repository root with a fresh directory:

```bash
pixi run python tools/tune_operand_square.py --output /tmp/operand-square-tuning
```

The saved [configurations.json](20261113-square-tuning/configurations.json) can be passed to the comparison tool without tuning again:

```bash
pixi run python tools/measure_operand_wave_tiles.py \
  --configurations lessons/01-gpu-programming/13-matmul/12-operand-paths/results/20261113-square-tuning/configurations.json \
  --selected-only --include-torch --seeds 101 \
  --output /tmp/operand-square-confirmation.json
```

Add `--timing direct-host` for ordinary calls. The [additional seed-101 confirmation](20261113-square-tuning/confirmation.json) exercises this reload path. The public `matmul_bf16` launcher accepts these settings as `config=Config(**settings)`; the teaching CLI's default selectors remain the three skinny workloads.
