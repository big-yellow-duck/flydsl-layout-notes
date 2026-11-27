"""Implement BF16 MoE in route order with scalar dot products."""

import runpy
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch

COMMON = runpy.run_path(str(Path(__file__).resolve().parents[1] / "common.py"))
THREADS = 128
_output_coordinates = COMMON["output_coordinates"]


def _silu(gate):
    return gate / (1.0 + fx.exp2(gate * -1.4426950408889634))


@flyc.kernel
def _moe_bf16(
    x: fx.Tensor,
    w_gate_up: fx.Tensor,
    ids: fx.Tensor,
    activated: fx.Tensor,
    R: fx.Constexpr,
    H: fx.Constexpr,
    I: fx.Constexpr,
    E: fx.Constexpr,
    TOP_K: fx.Constexpr,
):
    route, channel = _output_coordinates(R, I, THREADS)
    if channel < I:
        token = route // TOP_K
        expert = ids[route]
        if (expert >= 0) & (expert < E):
            x_row = fx.slice(x, (token, None))
            expert_weights = fx.slice(w_gate_up, (expert, None, None))
            gate = fx.Float32(0)
            up = fx.Float32(0)
            for k in range(H):
                value = x_row[k].to(fx.Float32)
                gate = gate + value * expert_weights[k, channel].to(fx.Float32)
                up = up + value * expert_weights[k, I + channel].to(fx.Float32)
            activated[route, channel] = (_silu(gate) * up).to(fx.BFloat16)


@flyc.kernel
def _down_impl(
    activated: fx.Tensor,
    w_down: fx.Tensor,
    ids: fx.Tensor,
    contributions: fx.Tensor,
    R: fx.Constexpr,
    H: fx.Constexpr,
    I: fx.Constexpr,
    E: fx.Constexpr,
):
    route, channel = _output_coordinates(R, H, THREADS)
    if channel < H:
        expert = ids[route]
        if (expert >= 0) & (expert < E):
            a_row = fx.slice(activated, (route, None))
            b_column = fx.slice(w_down, (expert, None, channel))
            total = fx.Float32(0)
            for k in range(I):
                total = total + a_row[k].to(fx.Float32) * b_column[k].to(fx.Float32)
            contributions[route, channel] = total


@flyc.kernel
def _combine_impl(
    contributions: fx.Tensor,
    ids: fx.Tensor,
    weights: fx.Tensor,
    out: fx.Tensor,
    T: fx.Constexpr,
    H: fx.Constexpr,
    E: fx.Constexpr,
    TOP_K: fx.Constexpr,
    WEIGHTED: fx.Constexpr,
):
    token, channel = _output_coordinates(T, H, THREADS)
    if channel < H:
        total = fx.Float32(0)
        for slot in fx.range_constexpr(TOP_K):
            route = token * TOP_K + slot
            expert = ids[route]
            if (expert >= 0) & (expert < E):
                value = contributions[route, channel]
                if fx.const_expr(WEIGHTED):
                    total = total + value
                else:
                    total = total + value * weights[route]
        out[token, channel] = total.to(fx.BFloat16)


@flyc.jit
def _launch_moe_bf16(
    x: fx.Tensor,
    w_gate_up: fx.Tensor,
    ids: fx.Tensor,
    activated: fx.Tensor,
    R: fx.Constexpr,
    H: fx.Constexpr,
    I: fx.Constexpr,
    E: fx.Constexpr,
    TOP_K: fx.Constexpr,
    stream: fx.Stream,
):
    _moe_bf16(x, w_gate_up, ids, activated, R, H, I, E, TOP_K).launch(
        grid=((I + THREADS - 1) // THREADS, R, 1),
        block=(THREADS, 1, 1),
        stream=stream,
    )


@flyc.jit
def _launch_down_impl(
    activated: fx.Tensor,
    w_down: fx.Tensor,
    ids: fx.Tensor,
    contributions: fx.Tensor,
    R: fx.Constexpr,
    H: fx.Constexpr,
    I: fx.Constexpr,
    E: fx.Constexpr,
    stream: fx.Stream,
):
    _down_impl(activated, w_down, ids, contributions, R, H, I, E).launch(
        grid=((H + THREADS - 1) // THREADS, R, 1),
        block=(THREADS, 1, 1),
        stream=stream,
    )


@flyc.jit
def _launch_combine_impl(
    contributions: fx.Tensor,
    ids: fx.Tensor,
    weights: fx.Tensor,
    out: fx.Tensor,
    T: fx.Constexpr,
    H: fx.Constexpr,
    E: fx.Constexpr,
    TOP_K: fx.Constexpr,
    WEIGHTED: fx.Constexpr,
    stream: fx.Stream,
):
    _combine_impl(contributions, ids, weights, out, T, H, E, TOP_K, WEIGHTED).launch(
        grid=((H + THREADS - 1) // THREADS, T, 1),
        block=(THREADS, 1, 1),
        stream=stream,
    )


def _workspace_spec(shape):
    tokens, hidden, _, intermediate, top_k = shape
    routes = tokens * top_k
    return [
        ("activated", (routes, intermediate), torch.bfloat16),
        ("contributions", (routes, hidden), torch.float32),
    ]


def moe_bf16(x, w_gate_up, w_down, topk_ids, topk_weights, *, out=None, workspace=None):
    """Run three kernels on the current stream; route IDs outside [0,E) are skipped."""
    if not isinstance(x, torch.Tensor):
        raise TypeError("x must be a tensor")
    supplied_out = out is not None
    out, shape, workspace, buffers = COMMON["prepare"](
        x, w_gate_up, w_down, topk_ids, topk_weights, out, workspace
    )
    tokens, hidden, experts, intermediate, top_k = shape
    if not tokens:
        return out
    routes = tokens * top_k
    activated, contributions = COMMON["scratch"](
        _workspace_spec(shape), x.device, workspace, buffers
    )
    ids, weights = topk_ids.view(-1), topk_weights.view(-1)
    with torch.cuda.device(x.device):
        stream = fx.Stream(torch.cuda.current_stream(x.device))
        _launch_moe_bf16(
            x,
            w_gate_up,
            ids,
            activated,
            routes,
            hidden,
            intermediate,
            experts,
            top_k,
            stream,
        )
        _launch_down_impl(
            activated,
            w_down,
            ids,
            contributions,
            routes,
            hidden,
            intermediate,
            experts,
            stream,
        )
        _launch_combine_impl(
            contributions,
            ids,
            weights,
            out,
            tokens,
            hidden,
            experts,
            top_k,
            False,
            stream,
        )
    if supplied_out:
        torch.autograd.graph.increment_version(out)
    return out


def solve():
    return COMMON["check"](moe_bf16)


if __name__ == "__main__":
    COMMON["report"](solve)
