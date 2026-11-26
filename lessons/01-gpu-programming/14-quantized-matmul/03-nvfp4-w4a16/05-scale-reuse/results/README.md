# NVFP4 decoded-scale reuse results

Radeon 8060S `gfx1151` used FlyDSL 0.4.1, PyTorch 2.13.0+rocm10.1.0, and HIP 7.16.26385. Both kernels used B through LDS and identical geometry within each shape. The archived hashes identify the source measured before B register staging was added. The group tile was `16×64×32` with one wave. The small trace used one K split, and the remaining shapes used four. Each round captured 24 matmuls and timed seven shuffled batches of eight replays. The table reports the median of the three round medians. [Raw timings and source hashes](gfx1151-graphs.json)

| M × N × K | Step 04 µs | Step 05 µs | Latency reduction | Rounds faster |
| --- | ---: | ---: | ---: | ---: |
| 2 × 9 × 17 | 2.791 | 2.758 | 1.2% | 3/3 |
| 16 × 1024 × 8192 | 81.720 | 81.619 | 0.1% | 2/3 |
| 31 × 1025 × 8193 | 225.230 | 132.171 | 41.3% | 3/3 |
| 512 × 512 × 512 | 43.404 | 41.797 | 3.7% | 3/3 |

The long odd workload had the largest gain. The aligned skinny workload varied by round, so its overall median difference is inconclusive. Both paths include decode and matmul from the same packed input. The checker validates the full output, checks its trailing sentinel, and changes packed signs before replay.

## Inspect the generated kernels

Compile each solution at the measured geometry with `FLYDSL_DUMP_IR=1` and inspect its `22_final_isa.s`. These counts describe static instruction sites. The register counts come from AMDGPU kernel metadata. [ISA summary](gfx1151-isa.json)

| M × N × K | `v_ldexp_f32` sites, 04 → 05 | VGPRs, 04 → 05 | Scratch bytes |
| --- | ---: | ---: | ---: |
| 16 × 1024 × 8192 | 64 → 64 | 193 → 193 | 0 |
| 31 × 1025 × 8193 | 144 → 48 | 136 → 168 | 0 |

The aligned case is consistent with the compiler already sharing the E4M3 decodes. The odd case emits fewer scale conversions and uses more VGPRs, while still using zero private scratch. Both cases retain the same number of static BF16 WMMA and byte permutation sites within each matched pair.

[Back · Reuse decoded scales](../README.md)
