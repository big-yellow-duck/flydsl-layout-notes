# Interleaved-load measurements

Measured on 2026-11-05 with the **64×64×64 tile and padded A view from stage 06**. Serial and prefetch share row-major global BF16 inputs/output, FP32 accumulation, four wave32 groups, 128 threads, A LDS stride 72, packed B stride 64, and the inline four-step K=16 loop. Only the scheduling of next-tile global loads changes.

## What changed

| Property | Serial | Prefetch |
| --- | ---: | ---: |
| LDS bytes | 17408 | 17408 |
| VGPRs | 200 | 208 |
| Scratch bytes | 0 | 0 |
| Conflict metric | 0% | 0% |
| Conflict numerator | 0 | 0 |
| Indexed LDS denominator | 3,670,016 | 3,670,016 |
| Dynamic LDS instructions | 2,490,368 | 2,490,368 |
| Host median ms | 0.1166 | 0.1040 |

All five sampled dispatches per schedule agreed on the counters. The events carry emulated/C1 definitions; zero describes this metric for this workload, not a universal conflict-free guarantee. The serial resource and counter values also match stage 06's padded specialization.

Host timing ran separately after profiler processes exited: three warm-ups and five batches of twenty launches, preallocated outputs, warm repeated buffers. GPU `torch.matmul` measured 0.0803 ms in the same comparison. Prefetch had 10.8% lower host-observed time in this capture, with more registers. This does not establish a stable timing advantage or isolate the number of cycles overlapped.

## Read the generated schedule

In serial, the global loads appear at assembly lines 94–103, their waits and LDS stores at 104–118, and WMMA at 267–289. In prefetch, next-tile loads appear at 132–150, current LDS reads at 151–294, WMMA at 296–319, the global-memory wait at 320, and next-tile LDS stores at 323–330. These line numbers describe this capture; regenerated assembly may differ.

The following excerpt selects representative instructions; intervening loads, address arithmetic, and WMMA operations are omitted:

```asm
132: global_load_b128 v[65:68], v[35:36], off
150: global_load_b128 v[93:96], v[41:42], off
151: ds_load_b128 v[41:44], v106
296: v_wmma_f32_16x16x16_bf16 v[25:32], v[41:48], v[57:64], v[25:32]
319: v_wmma_f32_16x16x16_bf16 v[1:8], v[196:203], v[188:195], v[1:8]
320: s_waitcnt vmcnt(0)
321: s_barrier
323: ds_store_b128 v107, v[65:68]
330: ds_store_b128 v33, v[93:96] offset:15360
332: s_barrier
```

The collector checked eight global-load and sixteen WMMA instruction sites in the main loop, with all global loads preceding WMMA and the first VMEM wait following all WMMA operations. This permits independent current-tile work before waiting for future inputs. It does not prove that memory requests remain outstanding throughout compute or that latency is completely hidden.

Prefetch's full ISA contains a separate prologue and drain, increasing static instruction-site totals. Dynamic LDS instruction counts remain equal between schedules.

## Reproduce and inspect

Run from the repository root, using a fresh output directory:

```bash
pixi run python lessons/01-gpu-programming/13-matmul/07-interleaved-loads/profile.py \
  --collect --output /tmp/flydsl-interleaved-64-fresh --timing host --repeats 20
```

Each worker checks one-, two-, and three-tile boundaries, then the full 1024³ trace/random problem and output sentinels. It records three small and ten full-workload dispatches; only the last five full dispatches supply counter samples. The driver verifies full-workload IR shapes and main-loop instruction order, and writes `summary.json`, counters, logs, and assembly to the selected directory. Keep generated captures outside the lesson folder.

Environment: AMD Radeon 8060S Graphics (`gfx1151`), FlyDSL 0.4.1, PyTorch 2.13.0+rocm10.0.0, reported HIP 7.15.26333, ROCprofiler-SDK 1.3.5 from ROCm SDK 10.0.0. No gfx1152 performance claim is made.

## Earlier, smaller tile

The 2026-11-03 experiment used 32×32×32 tiles with 4608 LDS bytes. Its conflict ratio was 6.666667% for both schedules, with 56/64 VGPRs and host medians 0.3106/0.2849 ms. Those values describe a different kernel. Repository revision `6c64c7b` retains that experiment and its raw capture.

[Back to the lesson](README.md)
