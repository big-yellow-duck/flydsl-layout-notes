# Wave-local tile validation, 2026-11-13

The lesson-12 wide selector benefits from packing two independent wave tiles into a physical block on Radeon 8060S (`gfx1151`). The narrow selectors benefit more from two cooperating waves per tile. The selected configurations remain unchanged.

Graph replay timings, in microseconds per GEMM (median of three run medians):

| Shape M,N,K | One wave per block | Two independent waves per block | Two cooperating waves per tile |
| --- | ---: | ---: | ---: |
| 16,1024,8192 | 21.34 | 20.09 | 19.19 |
| 32,1024,8192 | 32.72 | 27.25 | 22.59 |
| 16,4096,8192 | 286.60 | 275.54 | Invalid with locked staging geometry |

Compared with single-wave blocks, packing reduces graph replay time by 5.9%, 16.7%, and 3.8%, respectively (median paired ratios). It wins 21/21, 21/21, and 20/21 shuffled batch comparisons. For the narrow shapes, cooperating waves beat packed independent waves in all 21 batches. These comparisons hold each shape's output tile, K chunk, split count, operand route, cache policies and unroll fixed; they do not independently retune each strategy.

This tests the current implementation's complete wave arrangement. Changing from one wave per block to packed waves also selects subgroup rather than workgroup LDS barriers. It therefore does not isolate packing from synchronization scope. Lesson 10's earlier full-workgroup-barrier experiment actually lost to single-wave blocks; see the [focused sequence measurements](../../10c-k-unrolling/results/README.md). The wide cooperating control is excluded because its 64 staging threads cannot evenly distribute the locked 16×16 A tile in eight-BF16 chunks.

Ordinary Python dispatch gives wide medians of 281.82 µs packed versus 291.20 µs single-wave, about 3% less time. Narrow dispatch is around 108–113 µs with small differences; the graph throughput advantage should not be presented as the same improvement for individual Python calls.

Three input/order seeds (13, 29, 47) each use seven shuffled batches of twenty repeats. Graph replay contains 32 GEMMs; host elapsed time is synchronized and divided by 32. Selected configurations are also measured under a duplicate label as a repeatability check. Every unique configuration passes the lesson's full structured/random, workspace-reuse, sentinel and tagged K-boundary checker; each seed receives another full-output validation. Graph capture uses the existing changed-input replay checks. These are same-session observations, not independent sessions or measurements on gfx1152.

Raw reports retain configuration dictionaries, source hashes, environment, samples, shuffled orders and graph metadata: [graph replay](20261113-wave-tiles-graph.json), [ordinary dispatch](20261113-wave-tiles-direct.json).

## Fresh comparison with Torch

An additional same-session run includes GPU `torch.matmul` on the same BF16 buffers with preallocated output, using the same three seeds and shuffled measurements. Numbers below are medians of run medians, in microseconds per GEMM. Native uses the selected lesson-12 configuration for each shape.

| Shape M,N,K | Native graph | Torch graph | Torch / native | Native ordinary dispatch | Torch ordinary dispatch |
| --- | ---: | ---: | ---: | ---: | ---: |
| 16,1024,8192 | 19.18 | 34.40 | 1.79× | 108.60 | 37.94 |
| 32,1024,8192 | 22.50 | 64.98 | 2.89× | 110.89 | 60.73 |
| 16,4096,8192 | 274.01 | 289.80 | 1.06× | 282.88 | 294.19 |

Native wins graph replay throughput on all three shapes. Torch wins ordinary dispatch on the narrow shapes; the native Python wrapper's host overhead outweighs the faster graph throughput there. Native retains about a 4% ordinary-dispatch time advantage on the wide shape. These fresh samples are separate from the historical course measurements and should be compared within this run.

Raw reports: [Torch graph comparison](20261113-wave-tiles-torch-graph.json), [Torch ordinary dispatch comparison](20261113-wave-tiles-torch-direct.json). Add `--include-torch` to either reproduction command below to include this baseline. All launches pass the same full-output checks before timing.

Reproduce from the repository root with fresh output paths:

```bash
pixi run python tools/measure_operand_wave_tiles.py --output /tmp/operand-wave-graph.json
pixi run python tools/measure_operand_wave_tiles.py --timing direct-host --output /tmp/operand-wave-direct.json
```
