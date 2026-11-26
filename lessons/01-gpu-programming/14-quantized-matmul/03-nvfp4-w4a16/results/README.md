# NVFP4 shape tuning with B registers

Measured on AMD Radeon 8060S Graphics (`gfx1151`) with FlyDSL 0.4.1,
PyTorch 2.13.0+rocm10.1.0, and HIP 7.16.26385. This sweep timed 409 configurations.
The scale-reuse variant runs the staged search. For small N it also uses the
Stage 16 candidate geometry and adds LDS-A controls. Arithmetic and LUT independently
screen leading geometries from the A/B route combinations. Pass `--independent` to
run the staged search for every variant and shape.
The tuner screens both B routes with the same packed inputs and preallocated output.
It searches tile and wave geometry, 16/32/64-row K stages, split-K, unroll, cache policy,
and eligible wave groups and traversal. NVFP4 also screens both A routes. Each trial
checks the full output, output sentinels, and replay after a packed sign flip.
The finalists include both B routes and the previous default. Their medians combine
three fresh seeds with seven shuffled batches of seven replays, at 16 GEMMs per graph.
A register default has to beat the best LDS finalist in every verification round.

The largest selected gain is **88.1% lower latency** at `16×7×4097` arithmetic.
B registers were selected for 4 of 21 measured cases. The route
columns show the lowest verified median within each route. A small difference in medians
can leave the installed default unchanged when it fails the round-by-round comparison.
[Full configurations and samples](gfx1151-route-tuning.json)

| M × N × K | Decode | Previous µs | Selected µs | Selected B | Best LDS finalist µs | Best register finalist µs |
| --- | --- | ---: | ---: | --- | ---: | ---: |
| 2 × 9 × 17 | scale-reuse | 2.838 | 2.152 | Registers | 2.297 | 2.152 |
| 2 × 9 × 17 | lut | 2.842 | 2.161 | Registers | 2.277 | 2.161 |
| 2 × 9 × 17 | arithmetic | 3.006 | 2.319 | LDS | 2.319 | 2.371 |
| 16 × 1024 × 8192 | scale-reuse | 83.454 | 51.966 | LDS | 51.966 | 96.940 |
| 16 × 1024 × 8192 | lut | 82.535 | 53.656 | LDS | 53.656 | 97.077 |
| 16 × 1024 × 8192 | arithmetic | 111.333 | 62.821 | LDS | 62.821 | 114.386 |
| 31 × 1025 × 8193 | scale-reuse | 132.616 | 88.102 | LDS | 88.102 | 179.566 |
| 31 × 1025 × 8193 | lut | 225.169 | 98.519 | LDS | 98.519 | 178.788 |
| 31 × 1025 × 8193 | arithmetic | 374.465 | 114.152 | LDS | 114.152 | 220.801 |
| 512 × 512 × 512 | scale-reuse | 42.293 | 28.135 | LDS | 28.135 | 38.166 |
| 512 × 512 × 512 | lut | 42.664 | 28.297 | LDS | 28.297 | 38.399 |
| 512 × 512 × 512 | arithmetic | 61.248 | 35.043 | LDS | 35.043 | 48.621 |
| 16 × 1 × 4096 | scale-reuse | 50.583 | 16.841 | Registers | 17.296 | 16.841 |
| 16 × 1 × 4096 | lut | 50.928 | 17.273 | Registers | 17.724 | 17.273 |
| 16 × 1 × 4096 | arithmetic | 62.375 | 18.771 | LDS | 18.771 | 24.526 |
| 16 × 7 × 4097 | scale-reuse | 56.479 | 22.968 | LDS | 22.968 | 34.045 |
| 16 × 7 × 4097 | lut | 145.942 | 23.938 | LDS | 23.938 | 34.183 |
| 16 × 7 × 4097 | arithmetic | 226.409 | 26.842 | LDS | 26.842 | 37.552 |
| 128 × 16 × 4096 | scale-reuse | 31.194 | 12.439 | LDS | 12.439 | 20.235 |
| 128 × 16 × 4096 | lut | 28.706 | 12.717 | LDS | 12.717 | 20.245 |
| 128 × 16 × 4096 | arithmetic | 43.109 | 13.556 | LDS | 13.556 | 26.062 |

[Back · NVFP4 W4A16](../README.md)
