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

## What was checked

- All worked offsets, both composition examples, subset composition, and coalescing equivalences are exhaustively checked over their small logical domains by `examples/layout_walkthrough.py`.
- All 32 elements of the 2-D tiling example agree across the four divide variants at corresponding tuple coordinates.
- The ownership exercise covers each block exactly once; a CPU vector-add simulation checks the partial-tile predicate for several sizes.
- `fx.*` snippets were checked as API patterns against source, but were **not compiled or run with FlyDSL**. There is no GPU benchmark or ISA validation in this repository yet.

## Deliberate limits

The arithmetic model covers static, positive shapes and nonnegative integer strides. The lessons use regular, evenly dividing tiles. Swizzles, basis-valued strides, dynamic shape constraints, general complement construction, and the full composition divisibility algorithm are later topics.

The Python model evaluates composition as a function; it does not implement FlyDSL's symbolic layout simplification or prove compiler support for arbitrary inputs.
