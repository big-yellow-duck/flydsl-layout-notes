# 15 · BF16 mixture of experts

Run a routed SwiGLU feed-forward layer on one gfx11 GPU. Start with scalar dot products, use BF16 WMMA to process routes that share an expert, then move activation and routing weights into the projection epilogues. The lesson takes expert IDs and weights from an upstream router.

| Stage | What to trace |
| --- | --- |
| [00 · Naive MoE](00-naive/README.md) | Decode a route ID into its token and top-k slot, run its expert, and reduce the token's contributions. |
| [01 · Grouped WMMA](01-grouped-wmma/README.md) | Build an expert worklist on the GPU and select the A rows and expert B tile for a workgroup. |
| [02 · Fused MoE](02-fused/README.md) | Apply SwiGLU and route weights to the FP32 accumulators. Compare slot reduction, atomic accumulation, and direct GEMV for sparse decode. |

Every stage exposes `moe_bf16(x, w_gate_up, w_down, topk_ids, topk_weights, *, out=None, workspace=None)`. Use contiguous tensors on one ROCm device.

| Argument | Shape | Dtype |
| --- | --- | --- |
| `x` | `[T, H]` | BF16 |
| `w_gate_up` | `[E, H, 2I]`, with gate followed by up | BF16 |
| `w_down` | `[E, I, H]` | BF16 |
| `topk_ids` | `[T, top_k]` | int32 |
| `topk_weights` | `[T, top_k]` | FP32 |
| `out` | `[T, H]` | BF16 |

The two projections accumulate in FP32. Each route rounds its SwiGLU activation to BF16 before down projection. The token sum applies routing weights in FP32 and rounds once to BF16. IDs outside `[0,E)` contribute zero. A zero-token input returns an empty output. Use the current GPU stream. For repeated or captured launches, supply dedicated scratch buffers for each concurrent stream or graph, as in the benchmark.

The grouped and fused stages accept `config=Config(block_m, block_n, stage_k, prefetch, group_m)`. Pass a separate `down_config` to tune the down projection. Both configs share `block_m` because the two projections consume the same worklist.

Run the default decode and prefill cases from the repository root.

```bash
pixi run python lessons/01-gpu-programming/15-bf16-moe/benchmark.py
```

Add `--tune` for tile, traversal, prefetch, and GEMV K-lane candidates. Add `--trace /tmp/moe-traces` for per-kernel GPU traces. See the [gfx1151 results](results/README.md) for timing scope and comparisons.

[Previous · Quantized matmul](../14-quantized-matmul/README.md) · [GPU programming](../README.md)
