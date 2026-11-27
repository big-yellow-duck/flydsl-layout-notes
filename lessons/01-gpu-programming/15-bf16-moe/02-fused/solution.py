"""Fuse BF16 MoE activation and routing weights into projection epilogues."""

import runpy
from functools import partial
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch

ROOT = Path(__file__).resolve().parents[1]
COMMON = runpy.run_path(str(ROOT / "common.py"))
GROUPED = runpy.run_path(str(ROOT / "01-grouped-wmma/solution.py"))
DECODE = runpy.run_path(str(ROOT / "decode.py"))
Config = GROUPED["Config"]
THREADS = 128
_output_coordinates = COMMON["output_coordinates"]


@flyc.kernel
def _moe_bf16(
    contributions: fx.Tensor,
    ids: fx.Tensor,
    out: fx.Tensor,
    T: fx.Constexpr,
    H: fx.Constexpr,
    E: fx.Constexpr,
    TOP_K: fx.Constexpr,
    ATOMIC: fx.Constexpr,
):
    token, channel = _output_coordinates(T, H, THREADS)
    if channel < H:
        if fx.const_expr(ATOMIC):
            total = contributions[token, channel]
        else:
            total = fx.Float32(0)
            for slot in fx.range_constexpr(TOP_K):
                route = token * TOP_K + slot
                expert = ids[route]
                if (expert >= 0) & (expert < E):
                    value = contributions[route, channel]
                    total = total + value
        out[token, channel] = total.to(fx.BFloat16)


@flyc.jit
def _launch_moe_bf16(
    contributions: fx.Tensor,
    ids: fx.Tensor,
    out: fx.Tensor,
    T: fx.Constexpr,
    H: fx.Constexpr,
    E: fx.Constexpr,
    TOP_K: fx.Constexpr,
    ATOMIC: fx.Constexpr,
    stream: fx.Stream,
):
    _moe_bf16(contributions, ids, out, T, H, E, TOP_K, ATOMIC).launch(
        grid=((H + THREADS - 1) // THREADS, T, 1),
        block=(THREADS, 1, 1),
        stream=stream,
    )


def _dispatch(shape, dispatch):
    if dispatch == "auto":
        tokens, hidden, experts, intermediate, top_k = shape
        if tokens * top_k <= experts // 2:
            return "gemv" if max(hidden, intermediate) <= 512 else "direct-wmma"
        return "grouped"
    if dispatch not in ("gemv", "direct-wmma", "grouped"):
        raise ValueError("dispatch must be auto, gemv, direct-wmma, or grouped")
    return dispatch


def _workspace_spec(shape, block_m, *, dispatch="auto", atomic=False):
    return GROUPED["_workspace_spec"](
        shape,
        block_m,
        direct=_dispatch(shape, dispatch) != "grouped",
        fused=True,
        atomic=atomic,
    )


def _run_gemv(
    x,
    w_gate_up,
    w_down,
    topk_ids,
    topk_weights,
    shape,
    workspace,
    buffers,
    finish,
    atomic,
    k_lanes,
):
    tokens, hidden, experts, intermediate, top_k = shape
    routes = tokens * top_k
    spec = _workspace_spec(shape, 16, dispatch="gemv", atomic=atomic)
    activated, contributions = COMMON["scratch"](spec, x.device, workspace, buffers)
    ids, weights = topk_ids.view(-1), topk_weights.view(-1)
    with torch.cuda.device(x.device):
        stream = fx.Stream(torch.cuda.current_stream(x.device))
        if atomic:
            contributions.zero_()
        DECODE["project"](
            x,
            w_gate_up,
            ids,
            weights,
            activated,
            routes,
            hidden,
            intermediate,
            experts,
            top_k,
            True,
            False,
            k_lanes,
            stream,
        )
        DECODE["project"](
            activated,
            w_down,
            ids,
            weights,
            contributions,
            routes,
            intermediate,
            hidden,
            experts,
            top_k,
            False,
            atomic,
            k_lanes,
            stream,
        )
        finish(contributions, stream)


def moe_bf16(
    x,
    w_gate_up,
    w_down,
    topk_ids,
    topk_weights,
    *,
    out=None,
    workspace=None,
    config=None,
    down_config=None,
    dispatch="auto",
    atomic=False,
    k_lanes=None,
):
    """Run fused projection epilogues and optionally accumulate with FP32 atomics."""
    if not isinstance(x, torch.Tensor):
        raise TypeError("x must be a tensor")
    if not isinstance(atomic, bool) or k_lanes not in (None, 2, 4, 8):
        raise ValueError("atomic must be a bool and k_lanes must be None, 2, 4 or 8")
    config = Config() if config is None else config
    down_config = config if down_config is None else down_config
    GROUPED["_validate_config"](config)
    GROUPED["_validate_config"](down_config)
    if config.block_m != down_config.block_m:
        raise ValueError("Both projections must share worklist block_m")
    supplied_out = out is not None
    out, shape, workspace, buffers = COMMON["prepare"](
        x, w_gate_up, w_down, topk_ids, topk_weights, out, workspace
    )
    tokens, hidden, experts, _, top_k = shape
    dispatch = _dispatch(shape, dispatch)
    if not tokens:
        return out

    def finish(contributions, stream):
        _launch_moe_bf16(
            contributions,
            topk_ids.view(-1),
            out,
            tokens,
            hidden,
            experts,
            top_k,
            atomic,
            stream,
        )

    if dispatch == "gemv":
        if k_lanes is None:
            k_lanes = 8 if tokens * top_k <= 4 else 2
        _run_gemv(
            x,
            w_gate_up,
            w_down,
            topk_ids,
            topk_weights,
            shape,
            workspace,
            buffers,
            finish,
            atomic,
            k_lanes,
        )
    else:
        GROUPED["_pipeline"](
            x,
            w_gate_up,
            w_down,
            topk_ids,
            topk_weights,
            out,
            shape,
            workspace,
            buffers,
            config,
            down_config,
            direct=dispatch == "direct-wmma",
            fused=True,
            atomic=atomic,
            finish=finish,
        )
    if supplied_out:
        torch.autograd.graph.increment_version(out)
    return out


def solve():
    checkpoint = COMMON["check"](moe_bf16)
    for dispatch, atomic in (
        ("grouped", True),
        ("gemv", False),
        ("gemv", True),
        ("direct-wmma", False),
    ):
        COMMON["check"](partial(moe_bf16, dispatch=dispatch, atomic=atomic))
    return checkpoint


if __name__ == "__main__":
    COMMON["report"](solve)
