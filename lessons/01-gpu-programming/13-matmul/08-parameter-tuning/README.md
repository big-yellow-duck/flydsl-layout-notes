# 08 · Parameter tuning — work in progress

This lesson continues stage 07 with a configurable native WMMA kernel. **Matching or beating GPU PyTorch has not yet been verified.** The code and measurements are preserved here so work can continue on the remote machine.

Completed exploration:

- `solution.py` builds specializations for block M/N/K and wave M/N arrangement. It retains row-major BF16 global A/B/C, FP32 accumulation, padded A LDS, packed B LDS, and the one-tile prefetch schedule. A/B staging plans are derived separately, and output conversion covers every accumulator rather than eight fixed slots.
- `tune.py --sweep` checked all 37 candidates against full 1024³ trace/random references. No candidate failed correctness. Short paired host measurements selected 128×128×32 with a 2×2 wave arrangement.
- `tune.py --verify` locked that configuration and measured nine held-out rounds on seeds 20261104–20261106. It failed the predeclared parity criterion. Preserve [the failed verification](results/initial-contended-host/failed-heldout.json); [the search](results/initial-contended-host/search.json) is not proof of a win.
- The original host showed 100% graphics activity while benchmarking was stopped. Its contended measurements are exploratory, not an isolated performance claim.
- `experiments/graph_probe.py` successfully captured 32 actual kernel nodes for both implementations using an explicit FlyDSL stream. Replaying after changing inputs and clearing output passed full-output checks. Its noisy scouting timings are not a verified result. Graph timing is not yet integrated into `tune.py`.
- `ownership.py` is an additional native C-ownership checker; it still needs to be run and reviewed.

Resume from the repository root:

```bash
pixi install --locked
pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/solution.py --check-only
pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/ownership.py
pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/experiments/graph_probe.py
```

Next work: verify that the new GPU has a quiet measurement window; integrate matched graph replay and telemetry into the bounded search; lock the selected configuration before a fresh held-out comparison; inspect ISA/resources; add the practice scaffold and diagram; integrate navigation/counts; run the complete GPU suite. Keep every failed measurement and distinguish host/graph throughput from device-event timing. The main comparison stays 1024³ with preallocated output and no B prepacking.

The checked-in selection is provisional. Do not mark this lesson complete until its correctness, reproducibility, teaching artifacts, and parity claim have all been verified on the actual target.
