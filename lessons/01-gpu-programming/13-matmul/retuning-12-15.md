# Retune the BF16 workloads in stages 12–15

The sweep covers 59 stage-and-shape pairs from the lesson selectors, benchmark suites, and published square, small-M, traversal, and edge studies. Configuration validation excludes 19 of 2,857 proposals. The other 2,838 pass compilation, the CPU reference, and changed-input graph replay before timing. Each stage uses its own native kernel and contiguous BF16 inputs.

The search seeds each shape with its existing configuration or a published historical configuration for supplemental shapes. It varies tiles, waves, and the A path, then refines K depth, split-K, unroll, traversal, and cache policy. Seed 17 screens candidates and seed 37 reranks the finalists. A config becomes the default if its paired median is faster than the incumbent in each of the three held-out rounds on seeds 5101, 5202, and 5303. Those rounds use 32 GEMMs per replay, seven shuffled batches, and ten replays per batch.

Results are for Radeon 8060S `gfx1151` with FlyDSL 0.4.1 and PyTorch 2.13.0+rocm10.1.0. Times are medians of the three synchronized graph-replay round medians. Throughput uses the logical work `2 * M * N * K`. The search is bounded by the tested options.

| Stage | Workloads | Faster defaults | Best time reduction | Faster than Torch in all three rounds |
| --- | ---: | ---: | ---: | ---: |
| 12 | 17 | 9 | 36.2% | 17 |
| 13 | 13 | 12 | 78.4% | 11 |
| 14 | 14 | 9 | 43.4% | 14 |
| 15 | 15 | 12 | 36.9% | 15 |

## 12 · Operand paths

| M × N × K | Incumbent ms | Selected ms | Selected TFLOP/s | Torch ms | Torch TFLOP/s | Time saved |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 16 × 1024 × 8192 | 0.020321 | 0.020321 | 13.210 | 0.036842 | 7.286 | 0.00% |
| 32 × 1024 × 8192 | 0.022677 | 0.022677 | 23.675 | 0.058774 | 9.135 | 0.00% |
| 16 × 4096 × 8192 | 0.273220 | 0.273220 | 3.930 | 0.289944 | 3.703 | 0.00% |
| 1024 × 1024 × 1024 | 0.068871 | 0.061736 | 34.785 | 0.071141 | 30.186 | 10.36% |
| 2048 × 2048 × 2048 | 0.423006 | 0.423006 | 40.614 | 0.529714 | 32.432 | 0.00% |
| 1 × 1024 × 1024 | 0.004830 | 0.004830 | 0.434 | 0.007525 | 0.279 | 0.00% |
| 2 × 1024 × 1024 | 0.004900 | 0.004900 | 0.856 | 0.007431 | 0.564 | 0.00% |
| 4 × 1024 × 1024 | 0.004822 | 0.004822 | 1.740 | 0.007458 | 1.125 | 0.00% |
| 8 × 1024 × 1024 | 0.004876 | 0.004817 | 3.483 | 0.007558 | 2.220 | 1.20% |
| 1 × 2048 × 2048 | 0.011492 | 0.011477 | 0.731 | 0.017844 | 0.470 | 0.13% |
| 2 × 2048 × 2048 | 0.011710 | 0.011661 | 1.439 | 0.018715 | 0.896 | 0.42% |
| 4 × 2048 × 2048 | 0.011748 | 0.011719 | 2.863 | 0.019191 | 1.748 | 0.24% |
| 8 × 2048 × 2048 | 0.011718 | 0.011718 | 5.727 | 0.019304 | 3.477 | 0.00% |
| 2048 × 512 × 1024 | 0.102637 | 0.077158 | 27.832 | 0.089045 | 24.117 | 24.82% |
| 256 × 4096 × 8192 | 0.733054 | 0.526453 | 32.633 | 0.680024 | 25.264 | 28.18% |
| 4096 × 4096 × 4096 | 5.267966 | 3.362072 | 40.879 | 3.785929 | 36.303 | 36.18% |
| 512 × 2048 × 1024 | 0.086690 | 0.061357 | 35.000 | 0.101009 | 21.260 | 29.22% |

[Stage 12 lesson](12-operand-paths/README.md) · [Stage 12 configurations and raw measurements](12-operand-paths/results/retuned-workloads.json)

## 13 · Edge safety

| M × N × K | Incumbent ms | Selected ms | Selected TFLOP/s | Torch ms | Torch TFLOP/s | Time saved |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 17 × 65 × 33 | 0.007886 | 0.004906 | 0.015 | 0.003874 | 0.019 | 37.78% |
| 7 × 1032 × 8200 | 0.027197 | 0.027197 | 4.356 | 0.033615 | 3.524 | 0.00% |
| 17 × 1032 × 8200 | 0.035081 | 0.032019 | 8.986 | 0.054917 | 5.239 | 8.73% |
| 31 × 1048 × 8184 | 0.032480 | 0.032313 | 16.457 | 0.055104 | 9.650 | 0.52% |
| 16 × 1024 × 8192 | 0.021928 | 0.020579 | 13.044 | 0.034417 | 7.800 | 6.15% |
| 17 × 1024 × 8192 | 0.039455 | 0.027552 | 10.352 | 0.058320 | 4.890 | 30.17% |
| 16 × 1032 × 8192 | 0.029777 | 0.028539 | 9.479 | 0.033294 | 8.126 | 4.16% |
| 16 × 1024 × 8200 | 0.036224 | 0.023581 | 11.395 | 0.035062 | 7.664 | 34.90% |
| 16 × 64 × 24 | 0.002187 | 0.002166 | 0.023 | 0.003739 | 0.013 | 0.97% |
| 65 × 1032 × 8200 | 0.125437 | 0.073720 | 14.923 | 0.087072 | 12.635 | 41.23% |
| 31 × 1025 × 8193 | 0.255623 | 0.234139 | 2.224 | 0.055477 | 9.385 | 8.40% |
| 31 × 1034 × 8202 | 0.071508 | 0.041911 | 12.546 | 0.055144 | 9.535 | 41.39% |
| 31 × 1036 × 8204 | 0.170685 | 0.036889 | 14.285 | 0.055186 | 9.549 | 78.39% |

[Stage 13 lesson](13-edge-safety/README.md) · [Stage 13 configurations and raw measurements](13-edge-safety/results/retuned-workloads.json)

## 14 · Targeted guards

| M × N × K | Incumbent ms | Selected ms | Selected TFLOP/s | Torch ms | Torch TFLOP/s | Time saved |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 17 × 65 × 33 | 0.003466 | 0.002432 | 0.030 | 0.003889 | 0.019 | 29.84% |
| 7 × 1032 × 8200 | 0.025343 | 0.024155 | 4.905 | 0.033641 | 3.522 | 4.69% |
| 17 × 1032 × 8200 | 0.030620 | 0.027514 | 10.457 | 0.054930 | 5.238 | 10.15% |
| 31 × 1048 × 8184 | 0.030199 | 0.029351 | 18.117 | 0.055033 | 9.663 | 2.81% |
| 512 × 512 × 512 | 0.012157 | 0.012157 | 22.081 | 0.017820 | 15.063 | 0.00% |
| 1024 × 1024 × 1024 | 0.062076 | 0.062076 | 34.594 | 0.069813 | 30.761 | 0.00% |
| 2048 × 2048 × 2048 | 0.424961 | 0.424961 | 40.427 | 0.531969 | 32.295 | 0.00% |
| 1032 × 1048 × 1016 | 0.072459 | 0.072459 | 30.330 | 0.091970 | 23.896 | 0.00% |
| 1025 × 1025 × 1025 | 0.086704 | 0.086704 | 24.841 | 0.092558 | 23.269 | 0.00% |
| 16 × 1024 × 8192 | 0.021770 | 0.019265 | 13.934 | 0.034395 | 7.804 | 11.51% |
| 17 × 1024 × 8192 | 0.034506 | 0.026587 | 10.728 | 0.058275 | 4.894 | 22.95% |
| 16 × 1032 × 8192 | 0.026083 | 0.022878 | 11.825 | 0.033274 | 8.130 | 12.29% |
| 16 × 1024 × 8200 | 0.028521 | 0.022392 | 12.000 | 0.035044 | 7.667 | 21.49% |
| 31 × 1025 × 8193 | 0.088900 | 0.050327 | 10.346 | 0.055266 | 9.421 | 43.39% |

[Stage 14 lesson](14-targeted-guards/README.md) · [Stage 14 configurations and raw measurements](14-targeted-guards/results/retuned-workloads.json)

## 15 · Mixed-width edge loads

| M × N × K | Incumbent ms | Selected ms | Selected TFLOP/s | Torch ms | Torch TFLOP/s | Time saved |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 17 × 78 × 46 | 0.003641 | 0.002503 | 0.049 | 0.003930 | 0.031 | 31.27% |
| 17 × 1024 × 8214 | 0.029841 | 0.024933 | 11.470 | 0.058576 | 4.882 | 16.45% |
| 17 × 1046 × 8192 | 0.031293 | 0.027057 | 10.767 | 0.054349 | 5.361 | 13.54% |
| 17 × 1046 × 8214 | 0.031290 | 0.030837 | 9.473 | 0.055034 | 5.308 | 1.44% |
| 1030 × 1046 × 1022 | 0.092065 | 0.075859 | 29.030 | 0.091614 | 24.037 | 17.60% |
| 1025 × 1025 × 1025 | 0.080749 | 0.080749 | 26.673 | 0.092233 | 23.352 | 0.00% |
| 31 × 1025 × 8193 | 0.033411 | 0.033411 | 15.584 | 0.055236 | 9.426 | 0.00% |
| 17 × 65 × 33 | 0.004180 | 0.002636 | 0.028 | 0.003886 | 0.019 | 36.94% |
| 7 × 1032 × 8200 | 0.025304 | 0.023840 | 4.970 | 0.033630 | 3.523 | 5.79% |
| 17 × 1032 × 8200 | 0.030593 | 0.026963 | 10.671 | 0.054799 | 5.251 | 11.87% |
| 31 × 1048 × 8184 | 0.029871 | 0.027897 | 19.061 | 0.055084 | 9.654 | 6.61% |
| 512 × 512 × 512 | 0.012154 | 0.012148 | 22.097 | 0.017838 | 15.048 | 0.05% |
| 1024 × 1024 × 1024 | 0.062102 | 0.061713 | 34.798 | 0.070561 | 30.434 | 0.63% |
| 2048 × 2048 × 2048 | 0.411587 | 0.411587 | 41.741 | 0.530220 | 32.401 | 0.00% |
| 1032 × 1048 × 1016 | 0.072510 | 0.067748 | 32.439 | 0.091438 | 24.035 | 6.57% |

[Stage 15 lesson](15-edge-load-widths/README.md) · [Stage 15 configurations and raw measurements](15-edge-load-widths/results/retuned-workloads.json)

## Reproduce the search

```bash
pixi run python tools/retune_matmul_lessons.py --output /tmp/matmul-retune
```

Use `--stages 12 13` or `--shape M N K` to select part of the workload list. Completed workloads can be resumed from the same output directory. Published default timings are compared with the defaults present when a fresh run starts.
