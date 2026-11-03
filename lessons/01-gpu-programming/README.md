# GPU data movement and execution

A layout describes positions; a kernel uses those positions to access values. This section follows the path from a source view through thread ownership, memory transfers, arithmetic, and output validation. Complete the [layout algebra section](../00-layout-algebra/README.md) first, especially block selection and thread/value ownership.

Follow the lessons in order. Start with a full tile so the copy operation is easy to trace, then introduce partial tiles and measurement.

| Lesson | Follow the example to learn how to… |
| --- | --- |
| [08 · Tiled copy](08-tiled-copy/README.md) | Combine ownership with a copy atom, partition each thread's views, and transfer values. |
| [09 · Register fragments](09-register-fragments/README.md) | Load temporary per-thread storage, add matching values, and store the result. |
| [10 · Predicates and tails](10-predicates-and-tails/README.md) | Derive candidate indices and guard every memory access in a partial tile. |
| [11 · Vector addition](11-vector-addition/README.md) | Assemble a complete launch that handles full tiles and a partial final tile. |
| [12 · Inspect and measure](12-inspect-and-tune/README.md) | Compare copy widths using correctness checks, generated instructions, and GPU event timings. |
| [13 · BF16 matmul](13-matmul/README.md) | Optimize a fixed 1024³ GPU multiplication from naive dot products through gfx11 matrix instructions, LDS layout measurement, and interleaved loads with compute in eight practice stages. |

For each diagram, identify whether its cells contain offsets, candidate indices, or data values. Follow one thread through the example before tracing the full block. Complete `practice.py`, run the supplied checker, then compare the commented `solution.py`. Run commands from the repository root in the [configured GPU environment](../../README.md#set-up-and-start).

The copy and fragment lessons use complete tiles. The tail and vector-add lessons introduce per-value bounds checks. The measurement lesson returns to evenly divisible inputs so it can study copy width under a fixed ownership plan.

The matmul series keeps M=N=K=1024, BF16 inputs/output, and FP32 accumulation across naive, coalesced, register-tiled, LDS, and WMMA kernels. Compare them with GPU `torch.matmul` using `pixi run matmul-bench`; timing stays separate from correctness. Pipelining and library tuning remain planned.

[Course overview](../../README.md) · [Roadmap](../../ROADMAP.md)
