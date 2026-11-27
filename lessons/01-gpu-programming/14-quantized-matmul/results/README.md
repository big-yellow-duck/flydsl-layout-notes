# Quantized matmul results

## Masking the quantized K tail

The fused MXFP4 LDS path selects BF16 zero for padded K rows after decoding each weight. The fused NVFP4 LDS path selects FP32 zero after applying both scales, then casts to BF16 for LDS. The scalar decoders produce exact-size dense B matrices and serve as the timing control.

The comparison ran on Radeon 8060S (`gfx1151`) with FlyDSL 0.4.1, ROCm 10.1, and PyTorch 2.13.0+rocm10.1.0. Each pair used the same packed input, output buffer, and launch settings. NVFP4 uses its fallback geometry at `17×1046×8214` and its tuned defaults at `31×1025×8193`. The NVFP4 LUT and scale-reuse defaults use B registers at `2×9×17`. The exact-square and tall outputs each use the fused launcher fallback for both `K=1024` and `K=1025`.

Each of three seeds used seven shuffled timing batches, with twelve graph replays of sixteen matmuls per batch. The tables report the median of the three paired latency changes. Negative values mean lower latency. The wider raw spread in some scalar medians reflects timing drift shared by the paired runs. [Raw samples and configurations](k-tail-mask-gfx1151.json)

### MXFP4

| M × N × K | 02 · Scalar + BF16 matmul | 03 · Fused arithmetic | 04 · Fused LUT |
| --- | ---: | ---: | ---: |
| 2 × 9 × 17 | −0.1% | −2.0% | −0.4% |
| 17 × 77 × 46 | 0.0% | −1.8% | −0.4% |
| 16 × 1024 × 8192 | 0.0% | 0.0% | +0.9% |
| 17 × 1046 × 8214 | 0.0% | −10.1% | −0.2% |
| 31 × 1025 × 8193 | 0.0% | −19.5% | −6.5% |
| 1030 × 1046 × 1022 | +0.1% | +0.5% | +0.1% |
| 1024 × 1024 × 1024 | +0.1% | −0.1% | −0.1% |
| 1024 × 1024 × 1025 | 0.0% | −14.9% | −9.8% |
| 4096 × 256 × 1024 | −0.1% | 0.0% | 0.0% |
| 4096 × 256 × 1025 | −0.1% | −14.4% | −9.6% |

At `31×1025×8193`, the arithmetic kernel's median latency went from 101.67 to 81.56 µs and the LUT kernel's went from 64.18 to 61.10 µs. Both improved in all three paired rounds.

### NVFP4

| M × N × K | 02 · Scalar + BF16 matmul | 03 · Fused arithmetic | 04 · Fused LUT | 05 · Fused scale reuse |
| --- | ---: | ---: | ---: | ---: |
| 2 × 9 × 17 | 0.0% | −0.1% | 0.0% | 0.0% |
| 17 × 77 × 46 | −0.1% | −1.7% | −2.4% | −0.9% |
| 16 × 1024 × 8192 | −0.1% | −0.1% | −0.1% | 0.0% |
| 17 × 1046 × 8214 | 0.0% | −56.1% | −29.9% | −0.5% |
| 31 × 1025 × 8193 | −0.1% | −15.4% | −5.0% | +1.4% |
| 1030 × 1046 × 1022 | 0.0% | −0.8% | −0.7% | +0.2% |
| 1024 × 1024 × 1024 | −0.1% | −0.1% | −0.1% | −0.1% |
| 1024 × 1024 × 1025 | −0.1% | −28.3% | −23.9% | −1.0% |
| 4096 × 256 × 1024 | 0.0% | 0.0% | −0.1% | +0.1% |
| 4096 × 256 × 1025 | +0.1% | −28.1% | −28.1% | −0.8% |

At `17×1046×8214`, median latency went from 424.15 to 185.65 µs for fused arithmetic and from 172.73 to 121.91 µs for fused lookup. Removing the early packed-code mask in step 05 had a smaller, mixed effect. Its median latency at `31×1025×8193` went from 90.85 to 92.22 µs.

### Generated kernels

Shapes with a partial K tile include the row mask in the staging loop. The new placement reduces conditional selects on the shapes below. These are static instruction sites in the final ISA.

| Lesson and shape | `v_cndmask_b32` sites | VGPRs |
| --- | ---: | ---: |
| MXFP4 03 at 31 × 1025 × 8193 | 500 → 442 | 216 → 216 |
| NVFP4 03 at 17 × 1046 × 8214 | 1,089 → 751 | 166 → 138 |
| NVFP4 04 at 17 × 1046 × 8214 | 566 → 326 | 165 → 135 |

Run the [paired comparison](../compare_k_tail_mask.py) from the repository root. The benchmark checks a CPU reference, poisons input padding and the output, and replays each graph after changing the weight signs and the scales.

```bash
pixi run python lessons/01-gpu-programming/14-quantized-matmul/compare_k_tail_mask.py \
  --baseline 093b114 --output /tmp/k-tail-mask.json
```
