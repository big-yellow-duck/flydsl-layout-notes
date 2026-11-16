# Independent wave tiles versus cooperative tiles

Follow-up: [synchronization profiling and fixed-geometry scope control](profile/README.md)
confirm a substantial workgroup rendezvous cost for the independent tiles.

Measured 2026-11-16 on Radeon 8060S, gfx1151, FlyDSL 0.4.1,
Torch 2.13.0+rocm10.1.0, HIP 7.16.26385. Shape: `(16,4096,8192)`.

The independent two-wave implementation wins this comparison. Two cooperating
waves with twice the K staging extent use slightly less LDS per block, but take
17.7% longer in graph replay. Combining the two output tiles into one cooperative
16×128 tile also loses here, despite reducing repeated A loads.

## Controls and measurements

All variants use the current lesson-10a kernel: BF16 row-major inputs/output,
FP32 accumulation, split_k=1, group_m=1, ordinary cache policy, rolled K loop,
register prefetch, and one LDS stage. The selected synchronization mode is
`lds-subgroup`: independent groups use LDS-only subgroup synchronization;
cooperating waves use LDS-only workgroup synchronization. The compiler removes
workgroup barriers for the single-wave block. An explicit ordinary workgroup
barrier control is included for the packed case.

All cooperative cases have two waves along N and wave_groups=1. Packed cases
have two independent one-wave groups. The single-wave control has 32 threads;
all other cases have 64 threads per physical block.

Times below are the median of three seed-level medians (seeds 13, 29, 47).
Each seed has seven shuffled measurement batches and twenty repetitions per
batch. Graph replay captures 32 GEMMs per graph; synchronized host elapsed time
is divided by the GEMM count. Direct timing measures ordinary launch plus
execution with synchronized host timing. Allocations, compilation, validation,
and CPU reference work are excluded.

| Configuration | C region/block | K chunk | Blocks | LDS bytes/block | VGPRs/thread | Graph µs | Direct µs |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Single wave | 16×64 | 16 | 64 | 2816 | 102 | 293.62 | 298.08 |
| Two independent waves, subgroup sync | 2 × (16×64) | 16 | 32 | 5632 | 103 | **288.04** | **292.77** |
| Two cooperative waves | 16×64 | 32 | 64 | 5376 | 94 | 339.14 | 342.57 |
| Two cooperative waves, wider output | 16×128 | 32 | 32 | 9472 | 159 | 396.18 | 397.18 |
| Two independent waves, larger K | 2 × (16×64) | 32 | 32 | 10752 | 163 | 324.11 | 328.25 |
| Two independent waves, ordinary workgroup sync | 2 × (16×64) | 16 | 32 | 5632 | 103 | 353.71 | 358.39 |

The proposed cooperative 16×64/K32 case is 17.7% slower than the intended
independent-wave implementation. The wider cooperative case is 37.5% slower.
Doubling K while retaining independent waves is 12.5% slower. These are observed
elapsed-time ratios, not predictions for other shapes or GPUs.

## What reuse changes

Increasing BLOCK_K alone does not increase the mathematical operand reuse for
fixed output dimensions: work is proportional to M_tile*N_tile*K_tile, and
operand elements to (M_tile+N_tile)*K_tile. K_tile cancels from their ratio.
Doubling it halves the number of outer pipeline iterations, but increases the
amount staged each iteration.

For packed N64/K16 versus cooperative N64/K32, each thread has the same logical
prefetch payload: 8 A BF16 values and 32 B BF16 values. The cooperative tile has
16 FP32 accumulator values per thread versus 32 for each independent wave.
It distributes a smaller output region over the same 64 physical threads and
requires cross-wave handoffs.

The cooperative N128/K32 case matches the packed block's total output region.
It shares A across the two waves instead of staging A separately for each N64
tile. Across the whole GEMM, the algorithmic global-load payload changes from
16 MiB A + 64 MiB B to 8 MiB A + 64 MiB B. These are requested operand bytes,
not measured DRAM traffic; cache reuse can change the latter substantially.
Its logical B prefetch payload per thread rises from 32 to 64 BF16 values.

Generated metadata confirms the LDS allocations in the table, zero scratch in
every case, wave32 WMMA, and 128-bit buffer loads. Independent subgroup cases
have zero static workgroup barrier sites; cooperative cases and the explicit
workgroup control have four. These observations identify resource and
synchronization differences, but do not measure occupancy or prove which factor
causes the timing difference.

Cooperative N64/K16 and N128/K16 are excluded: the current 128-bit A copy layout
cannot give all 64 staging threads complete chunks for M16/K16. This is a
constraint of this implementation, not a general hardware limitation.

## Validation and reproduction

All six configurations pass the native checker: exact structured output, random
output versus CPU FP32 reference rounded to BF16, sign-changing input reuse,
NaN output replacement, output sentinels, and tagged one/two/three-chunk pipeline
boundaries. Each seed/timing comparison separately validates structured/random
inputs before timing. Native instruction capture repeats correctness checking.

Raw timing reports: [graph.json](graph.json), [direct.json](direct.json).
The `stage` timing key means `packed_n64_k16`; configurations and hashes are
recorded in each report. Every `isa-*` directory contains its configuration,
generated LLVM IR/ISA, resources, and checker output.

Run from the repository root with fresh output paths:

```bash
pixi run python tools/measure_wave_group_reuse.py --output /tmp/wave-reuse-graph.json
pixi run python tools/measure_wave_group_reuse.py --timing direct-host --output /tmp/wave-reuse-direct.json
```

For native resources, pass a configuration from `resources` in either report to
`10a-synchronization-scope/inspect_kernel.py --config '<JSON>' --output <fresh-directory>`.
Existing tutorial kernels and configurations were not changed for this comparison.
