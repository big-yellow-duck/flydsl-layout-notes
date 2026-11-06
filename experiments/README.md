# Skinny GEMM research

These experiments preserve the profiling, parameter searches, unsuccessful variants, and source snapshots behind the skinny lessons. The main course follows **09 → 10 → 10a → 10b → 10c → 12** in the [matmul index](../lessons/01-gpu-programming/13-matmul/README.md).

| Experiment | Preserved evidence |
| --- | --- |
| [Combined wave-local prefetch](wave-local-prefetch/README.md) | Original lesson-10 kernel, practice, counters, cache/unroll tuning, and verification; its native builder is retained in 10c |
| [Wave specialization](wave-specialization/README.md) | Former lesson 11; dedicated loaders, LDS ring, hardware barriers, semaphore protocols, searches and raw verification |
| [HipKittens four-wave pattern](hipkittens-four-wave/README.md) | All-wave fine instruction interleaving and its controlled ablations |
| [Torch strategy](torch-strategy/README.md) | Actual hipBLASLt selections, profiler counters, operand-path prototypes and tuning |

[Lesson 12 explains why prefetch remains the course strategy](../lessons/01-gpu-programming/13-matmul/12-operand-paths/README.md#why-the-course-keeps-prefetch). Wave specialization gave limited gains across the declared workloads; the retained A operand path is stronger for M=32. These measurements apply to gfx1151 and the tested shapes.

[course-restructure.json](course-restructure.json) records the original native source hashes and archive locations. Raw result records and source snapshots retain their original producer paths, dates, and hashes. Native archived solutions and practices are preserved; host utility paths and Markdown links follow the archive locations.

From the repository root, reproduce archived default correctness and figures with:

```bash
pixi run python experiments/wave-local-prefetch/solution.py --check-only
pixi run python experiments/wave-specialization/solution.py --check-only
python3 experiments/wave-local-prefetch/draw_figures.py
python3 experiments/wave-specialization/draw_figures.py
```

Archives live outside `lessons/`, so course discovery does not treat research kernels as additional practice stages. Archived script docstrings and captured command records may name the original lesson paths.
