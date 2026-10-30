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

Static algebra may be evaluated during compilation. These checks establish the tested mappings and view accesses, not a general performance guarantee. The vector-add lesson covers counts 1, 7, 8, 9, 19, 32, 257, and 4099. Lesson 12 provides event timings and generated-code inspection; bandwidth is workload-specific.

## Deliberate limits

The lessons use static positive shapes, nonnegative integer strides, and regular evenly dividing tiles. Swizzles, basis-valued strides, dynamic shape constraints, general complement construction, and the full composition divisibility algorithm are later topics. Passing these examples does not establish support for arbitrary layouts or tilers.
