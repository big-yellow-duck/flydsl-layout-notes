# gfx1151 tuning results under shared GPU load

The direct-host search selected `Config(128,64,32,2,2,"prefetch",buffers=1)`. Both held-out direct-launch captures passed the predeclared win criterion in every round: 18 rounds over six unused seeds, with a worst paired ratio of 0.8983. The independently checked graph capture also passed all nine rounds. The tuple stayed fixed across these captures.

| Capture | Native median ms | PyTorch median ms | Worst round paired ratio | Criterion |
| --- | ---: | ---: | ---: | --- |
| [Direct held-out](selected-direct-heldout.json) | 0.2152 | 0.3734 | 0.8571 | win |
| [Direct confirmation](selected-direct-confirmation.json) | 0.2613 | 0.3142 | 0.8983 | win |
| [Graph held-out](selected-graph-heldout.json) | 0.2630 | 0.3702 | 0.7458 | win |

These are synchronized-host measurements of GPU work, including dispatch/synchronization. Each direct round uses seven paired batches of 50 launches; graphs use seven paired batches of 20 replays, with 32 actual matmuls per replay. Order alternates within each paired round. The summary times are medians of nine round medians; classification uses each round's paired ratios. All three captures record full changed-input/reference/sentinel validation as applicable, source hashes, configuration, seeds, order, and every sample. Each graph contains 32 actual kernel nodes for both implementations.

## Conditions and reproducibility

Measurements used remote host `gmk`, Radeon 8060S (`gfx1151`), FlyDSL 0.4.1, PyTorch 2.13.0+rocm10.0.0, and the locked ROCm SDK 10.0.0 Pixi environment. CPU reference work used one thread outside timing. All paths use the same row-major 1024³ BF16 inputs, preallocated BF16 GPU output, FP32 accumulation contract, and no input packing.

A separate model service stayed running and every pre-measurement idle probe reported 100% GPU activity. The service was never paused or stopped. These captures support wins in this shared-load condition; they do not establish exclusive-GPU latency or a universal speedup. Times changed materially between captures, making both the raw records and the scope important.

Run from the repository root with fresh output names:

```bash
pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/tune.py \
  --sweep --timing direct-host --output /tmp/new-direct-search.json
pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/tune.py \
  --verify --timing direct-host --config 128,64,32,2,2 --buffers 1 \
  --seeds 20261216 20261217 20261218 --output /tmp/reproduce-direct-confirmation.json
```

The second command reproduces the recorded confirmation inputs. For new held-out evidence after a retune, choose three seeds that were never used to select the new configuration. The selected solution's constant changed after the training search; the native `build` function hash is identical in the search, both selected direct captures, the selected graph capture, and the current solution. The confirmation/graph full-file hashes and `resources.json` match the delivered source.

## Retained exploratory results

- `candidate-correctness.json`: all 71 tile/wave/buffer variants passed complete trace/random output checks.
- `shared-search-71.json`: the earlier graph training search selected 64×64×32.
- `shared-graph-heldout.json` and `shared-graph-confirmation.json`: that tuple passed graph verification.
- `shared-direct-heldout.json`: that tuple failed the direct-launch parity criterion, with worst ratio 1.0883.
- `direct-search-71.json`: a separate direct-launch training search selected 128×64×32 before the three final captures.
- `failed-graph-heldout.json`: an earlier 128×128×32 graph verification failed. The initial original-host search/failure remain under `../initial-contended-host/`.

No failed capture was discarded or relabeled. Graph and direct objectives are separate experiments; changing the objective required a new training selection and unused held-out seeds.

## Static resources and correctness

`selected.s`, `selected-origin.mlir`, and `resources.json` describe the selected full 1024³ kernel: 14336 LDS bytes, 165 compiler VGPRs, 10 SGPRs, zero private scratch, and native BF16 WMMA. These are static compiler metadata, not measured occupancy or overlapped cycles.

`gpu-check.log` records all 26 course solutions and extra native mapping/view checks passing. `practice-check.log` records temporary completed practice for both buffer counts, exact one-/two-/three-K-tile handoffs, the starter's expected unfinished message, and the native 8192-position selected C-ownership check. `lesson-cli.log` records the solution's ordinary GPU PyTorch comparison. The repository practice retains both TODOs.
