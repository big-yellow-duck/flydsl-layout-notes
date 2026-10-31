# Sources and scope

These are personal revision notes, reconstructed from our FlyDSL learning discussion and checked against upstream documentation and API source. The numerical examples and diagrams were made for these notes. They are not an official FlyDSL tutorial or a transcript.

## Reference snapshot

Reviewed on 2026-10-16 against ROCm/FlyDSL commit `0653ff888bad3787c759eabeeeefbfa1aa2df50b`.

| Source | What it supports |
| --- | --- |
| [FlyDSL layout system guide](https://github.com/ROCm/FlyDSL/blob/0653ff888bad3787c759eabeeeefbfa1aa2df50b/docs/layout_system_guide.md) | Shape/stride construction, layout mappings, algebra, view and copy vocabulary |
| [FlyDSL Python primitives](https://github.com/ROCm/FlyDSL/blob/0653ff888bad3787c759eabeeeefbfa1aa2df50b/python/flydsl/expr/primitive.py) | Actual Python signatures; layout versus tuple tilers; slicing wildcards |
| [FlyDSL CuTe algebra reference](https://github.com/ROCm/FlyDSL/blob/0653ff888bad3787c759eabeeeefbfa1aa2df50b/docs/cute_layout_algebra_guide.md) | Relationship to CuTe layout semantics |
| [NVIDIA CuTe layout introduction](https://docs.nvidia.com/cutlass/latest/media/docs/cpp/cute/01_layout.html) | Scalar-coordinate enumeration and hierarchical layouts |
| [NVIDIA CuTe layout algebra](https://docs.nvidia.com/cutlass/latest/media/docs/cpp/cute/02_layout_algebra.html) | Composition, coalescing, complement, and divide grouping |

Pinned FlyDSL links preserve the reference snapshot. NVIDIA's `latest` pages may evolve.

## Native execution validation

Migrated and validated on 2026-10-29 using the installed **FlyDSL 0.4.1** source and `pixi.lock`, with ROCm 10, PyTorch 2.13.0+rocm10.0.0, and AMD Radeon 860M Graphics (`gfx1152`). The earlier upstream reference snapshot above is background; executable API signatures were checked against the pinned installed package.

- `pixi run lessons-check` compiles and executes all thirteen lesson solutions and four focused divide tutorials. The layout lessons use thread-dependent coordinates and check their full small domains. Later lessons verify copies, fragments, exact-sized inputs with guarded tails, and both benchmark variants.
- `pixi run gpu-check` also checks row/column layouts, aliasing, subset and nested composition, coalescing examples, and actual loads from sliced 1-D and 2-D tensor views.
- Lesson 05 checks every original matrix element across native logical, zipped, tiled, and flat divide at corresponding explicit coordinates, including exact coverage.
- Host code allocates buffers and compares GPU outputs with expected tables. No CPU layout interpreter or manually constructed substitute for composition/coalescing/divide remains.

The visual lesson expansion was rechecked on 2026-10-30 with `pixi run gpu-check`: all 17 solutions and the additional mapping/view checks passed with FlyDSL 0.4.1 on AMD Radeon 860M Graphics (`gfx1152`). Diagram sources are kept in `tools/`, with SVGs embedded in lessons and PNG previews alongside them.

Lesson 10's tail handling was simplified and revalidated on 2026-10-30 against the [FlyDSL divide operations guide](https://rocm.docs.amd.com/projects/FlyDSL/en/latest/layout_system_guide.html#divide-operations), [native arithmetic guide](https://rocm.docs.amd.com/projects/FlyDSL/en/latest/kernel_authoring_guide.html#arithmetic-and-numeric-types), and installed FlyDSL 0.4.1. Native `logical_divide` maps the contiguous `19:1` coordinate layout to `(8,3):(1,8)` with an `8:1` tiler, so no manual coordinate padding is needed. `fx.ceildiv(19, 8)` sets the three-block launch. The solution and a completed temporary practice copy checked all 19 sums and eight untouched output sentinels; the temporary copy also asserted the divided shape and strides. The unfinished starter reported its intended message. The full `pixi run gpu-check`, targeted Ruff, documentation/local link checks, and diagram preview inspection passed.

Static algebra may be evaluated during compilation. These checks establish the tested mappings and view accesses, not a general performance guarantee. The vector-add lesson covers counts 1, 7, 8, 9, 19, 32, 257, and 4099. Lesson 12 provides event timings and generated-code inspection; bandwidth is workload-specific.

## BF16 matmul series validation (2026-10-31)

[Lesson 13](lessons/01-gpu-programming/13-matmul/README.md) adds five stages: naive, coalesced access, register tiling, LDS staging, and matrix instructions. Every exercise and timed comparison uses **M=N=K=1024**, row-major BF16 inputs/output, and FP32 accumulation. Diagrams show tiles and fragments within that workload.

Implementation references were read from FlyDSL tag `v0.4.1`, commit `888d7d80528f0cf2abab8a86610d5ccca47f205d`, and checked against the installed FlyDSL 0.4.1 wheel:

- [Kernel authoring guide](https://github.com/ROCm/FlyDSL/blob/888d7d80528f0cf2abab8a86610d5ccca47f205d/docs/kernel_authoring_guide.md): typed arithmetic, runtime and unrolled loops, LDS allocation, and synchronization.
- [gfx11 WMMA device tests](https://github.com/ROCm/FlyDSL/blob/888d7d80528f0cf2abab8a86610d5ccca47f205d/tests/kernels/test_rdna3_wmma_atom.py): replicated BF16 A/B fragments, interleaved FP32 output rows, instruction-compatible copies, and small numerical residue in gfx11 WMMA.
- [gfx11 MMA atom implementation](https://github.com/ROCm/FlyDSL/blob/888d7d80528f0cf2abab8a86610d5ccca47f205d/lib/Dialect/FlyROCDL/GFX11/MmaAtom.cpp): target-specific matrix operation and fragment layouts.

Executed on AMD Radeon 8060S Graphics (`gfx1151`) using Pixi 0.67.2, FlyDSL 0.4.1, ROCm SDK 10.0.0, and PyTorch 2.13.0+rocm10.0.0 (`torch.version.hip` reports 7.15.26333). New matmul execution on gfx1152 remains unverified.

- `pixi run gpu-check`: all **22** native solutions plus the additional mappings and sliced loads passed. Each matmul checks all 1,048,576 outputs for trace and seeded random BF16 inputs, using an independent untimed CPU FP32 product rounded to BF16. Trace tolerance is `rtol=0, atol=0.001`; random tolerance is `rtol=0.016, atol=0.03125`. Trace output row 0 begins `[3,-6,-1,-3]`. Sixteen output sentinels remained unchanged.
- All five unfinished practices reported their intended `Practice not finished` message. All five temporary practice copies filled with the intended expressions passed the same 1024³ checkers; repository starters remain unfinished.
- `pixi run matmul-bench` and `pixi run matmul-bench --timing host` both completed all six GPU implementations, including `torch.matmul` on BF16 GPU tensors with a preallocated GPU output. Event medians were zero and reported unavailable. Explicit host timing measures synchronized GPU execution including Python dispatch and batch synchronization.
- The 1024³ WMMA specialization's final ISA contains `v_wmma_f32_16x16x16_bf16`, LDS loads/stores, and the staging loop. This verifies instruction selection, not library-beating performance.
- Five SVG/PNG pairs were regenerated and visually inspected. Local documentation links, targeted Ruff, lock consistency, and `git diff --check` passed.

One illustrative host-clock run (median of five batches of 20, three warm-ups, warm repeated buffers) produced the following milliseconds per multiplication. These are observations for this machine and run, with host overhead included; rerun the benchmark to compare performance.

| GPU implementation | Host-observed ms |
| --- | ---: |
| Naive | 2.837 |
| Coalesced access | 2.561 |
| Register tiling | 1.338 |
| LDS staging | 1.145 |
| WMMA | 0.649 |
| GPU `torch.matmul` | 0.097 |

The PyTorch BLAS backend was not identified, so these results are not labeled a hipBLAS/hipBLASLt comparison. Pipelining, further tuning, and the named-library challenge remain planned. Performance has no pass/fail threshold.

## Deliberate limits

The lessons use static positive shapes, nonnegative integer strides, and regular tiles. Most layout examples divide evenly; lesson 10 also checks native division of a contiguous 19-element coordinate layout into eight-position windows. Swizzles, basis-valued strides, dynamic shape constraints, general complement construction, and the full composition divisibility algorithm are later topics. Passing these examples does not establish support for arbitrary layouts or tilers.
