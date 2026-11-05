# LDS layout measurements

Measured on 2026-11-05. This example compares packed, swizzled, and padded A storage for the current **64×64×64 block tile**, 128 threads, four waves, and four inline K=16 steps. The problem is 1024³ with row-major BF16 inputs/output and FP32 accumulation. Every mode passed full trace/random comparisons and output sentinels before sampling.

Reproduce from the repository root with a fresh destination:

```bash
pixi run python lessons/01-gpu-programming/13-matmul/06-lds-swizzle/profile.py \
  --collect --output /tmp/flydsl-lds-64-fresh --timing host --repeats 20
```

The environment is Radeon 8060S Graphics (`gfx1151`), FlyDSL 0.4.1, PyTorch 2.13.0+rocm10.0.0, reported HIP 7.15.26333. The profiler is ROCprofiler-SDK 1.3.5 from ROCm SDK 10.0.0. Each mode collects ten dispatches: two correctness checks, three warm-ups, and five samples. The final five counter samples are summarized; values were identical within each mode.

| Mode | Conflict ratio | LDS instructions | VGPRs | LDS bytes | Host median ms |
| --- | ---: | ---: | ---: | ---: | ---: |
| packed | 66.666667% | 2,490,368 | 176 | 16384 | 0.2398 |
| swizzle | 28.571429% | 4,096,000 | 192 | 16384 | 0.1394 |
| padded | 0.000000% | 2,490,368 | 200 | 17408 | 0.1124 |

All modes reported zero scratch. The packed, swizzled, and padded conflict numerators were 7,340,032, 1,835,008, and 0; their indexed-LDS denominators were 11,010,048, 6,422,528, and 3,670,016. These are emulated/C1 profiler events, not conflicting-lane counts or percentages of wall time. Zero is a result for this metric and workload, not a general guarantee of conflict freedom.

All variants retain eight global-load and eight LDS-store 128-bit instruction sites, plus sixteen WMMA sites. Packed and padded have sixteen `ds_load_b128` sites; swizzle has two and more scalar BF16 load sites. Static instruction sites differ from dynamic counter totals. Padding uses more LDS and more VGPRs here, yet had the lowest native host median in this capture. Reduced conflict ratio alone does not establish the cause of a speedup.

Timing ran separately after profiler subprocesses exited: three warm-ups, five batches of twenty launches, synchronized host timing, preallocated outputs. GPU `torch.matmul` measured 0.0782 ms in the same comparison. Host timing includes dispatch and synchronization; one capture does not establish a stable performance ranking. No gfx1152 or GPU-event performance claim is made.

## Reproduce and inspect

Run the command above to generate raw counters, assembly, logs, and `summary.json` in the selected output directory. Open the summary for resource counts and timing metadata, then compare the final ISA under each mode's `assembly/` directory. Keep generated captures outside the lesson directory.

## Earlier, smaller tile

The 2026-11-03 experiment used 32×32×32 tiles and loaded the full K extent into registers. Its packed/swizzled/padded conflict ratios were 46.153846% / 30.769231% / 6.666667%, with 56 / 88 / 56 VGPRs. These values describe a different kernel and should not be compared as a controlled before/after experiment. Repository revision `6c64c7b` retains that implementation and its original capture.

[Back to the lesson](README.md)
