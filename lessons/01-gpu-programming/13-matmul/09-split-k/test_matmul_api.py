"""GPU correctness and lifetime checks for the practice matmul launcher API.

Run: pixi run pytest lessons/01-gpu-programming/13-matmul/09-split-k/test_matmul_api.py -q
"""

import importlib.util
from dataclasses import replace
from pathlib import Path
from unittest.mock import patch

import pytest
import torch

SPEC = importlib.util.spec_from_file_location(
    "split_k_practice_api", Path(__file__).with_name("practice.py")
)
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)
torch.set_num_threads(1)
GPU = torch.cuda.is_available() and torch.version.hip is not None
if GPU:
    GPU = torch.cuda.get_device_properties(0).gcnArchName.split(":")[0] in (
        "gfx1151",
        "gfx1152",
    )
pytestmark = pytest.mark.skipif(
    not GPU, reason="Requires the pinned ROCm GPU environment"
)


def inputs(shape):
    m, n, k = shape
    generator = torch.Generator().manual_seed(73)
    a = torch.randn(m, k, generator=generator).to(torch.bfloat16)
    b = torch.randn(k, n, generator=generator).to(torch.bfloat16)
    expected = (a.float() @ b.float()).to(torch.bfloat16)
    return a.cuda(), b.cuda(), expected


def assert_result(actual, expected):
    torch.testing.assert_close(actual.cpu(), expected, rtol=0.016, atol=0.03125)


def workspace(config, shape, device=None, stream=None):
    device = device or torch.device("cuda", torch.cuda.current_device())
    stream = stream or torch.cuda.current_stream(device)
    return MODULE._workspace_for(config, shape, device, stream, 0)


def test_unsplit_allocates_no_scratch():
    shape = MODULE.SHAPES[0]
    config = replace(MODULE.CONFIGS_BY_SHAPE[shape], split_k=1)
    a, b, expected = inputs(shape)
    c = MODULE.matmul_bf16(a, b, config=config)
    with (
        patch.object(
            torch, "empty", side_effect=AssertionError("Unexpected allocation")
        ),
        patch.object(
            torch, "zeros", side_effect=AssertionError("Unexpected allocation")
        ),
        patch.object(
            MODULE, "_workspace_for", side_effect=AssertionError("Unexpected workspace")
        ),
    ):
        assert MODULE.matmul_bf16(a, b, out=c, config=config) is c
    assert_result(c, expected)
    assert workspace(config, shape, a.device) is None


@pytest.mark.parametrize(
    "changes", ({"split_k": 3}, {"group_tile_m": 0}, {"traversal_group_m": 0})
)
def test_config_is_validated_before_allocation(changes):
    a, b, _ = inputs(MODULE.SHAPES[0])
    config = replace(MODULE.Config(), **changes)
    with (
        patch.object(
            torch, "empty", side_effect=AssertionError("Unexpected output allocation")
        ),
        patch.object(
            MODULE, "_workspace_for", side_effect=AssertionError("Unexpected workspace")
        ),
        pytest.raises(ValueError),
    ):
        MODULE.matmul_bf16(a, b, config=config)


def test_supported_calls_can_replace_torch_matmul():
    a, b, expected = inputs(MODULE.SHAPES[0])
    with patch.object(torch, "matmul", MODULE.matmul_bf16):
        assert_result(torch.matmul(a, b), expected)


@pytest.mark.parametrize("shape", MODULE.SHAPES)
def test_result_out_identity_and_reuse(shape):
    a, b, expected = inputs(shape)
    # A successful call must run the FlyDSL kernel, without delegating to Torch.
    with patch.object(
        torch, "matmul", side_effect=AssertionError("Unexpected fallback")
    ):
        result = MODULE.matmul_bf16(input=a, other=b)
        assert_result(result, expected)
        c = torch.full_like(result, float("nan"))
        version = c._version
        assert MODULE.matmul_bf16(a, b, out=c) is c
        assert c._version == version + 1
        assert_result(c, expected)
        a.neg_()
        c.fill_(float("nan"))
        assert MODULE.matmul_bf16(a, b, out=c) is c
        assert_result(c, -expected)
    config = MODULE.CONFIGS_BY_SHAPE[shape]
    scratch = workspace(config, shape, a.device)
    assert workspace(config, shape, a.device) is scratch
    if config.split_k == 1:
        assert scratch is None
    MODULE.check_workspace(scratch)


@pytest.mark.parametrize("split_k", (1, 2, 4))
@pytest.mark.parametrize("scope", ("thread", "cta"))
def test_low_level_solver(split_k, scope):
    config = MODULE.Config(split_k=split_k, counter_scope=scope)
    MODULE.solve(config, MODULE.SHAPES[0])


@pytest.mark.parametrize(
    "case, error, message",
    (
        ("cpu", ValueError, "input must be on a ROCm GPU"),
        ("batched", ValueError, "two-dimensional"),
        ("shape", ValueError, "No default config"),
        ("dtype", TypeError, "input must have dtype torch.bfloat16"),
        ("stride", ValueError, "other must be contiguous"),
        ("unaligned", ValueError, "16-byte aligned"),
        ("negative", ValueError, "input must not be a negative view"),
        ("inner", ValueError, "K dimensions must match"),
        ("type", TypeError, "input must be a torch.Tensor"),
    ),
)
def test_unsupported_input_reports_reason(case, error, message):
    if case == "cpu":
        a = torch.ones(3, 5, dtype=torch.bfloat16)
        b = torch.ones(5, 7, dtype=torch.bfloat16)
    elif case == "batched":
        a = torch.ones(2, 3, 5, dtype=torch.bfloat16, device="cuda")
        b = torch.ones(2, 5, 7, dtype=torch.bfloat16, device="cuda")
    elif case == "shape":
        a = torch.ones(16, 64, dtype=torch.bfloat16, device="cuda")
        b = torch.ones(64, 32, dtype=torch.bfloat16, device="cuda")
    else:
        a, b, _ = inputs(MODULE.SHAPES[0])
        if case == "dtype":
            a, b = a.float(), b.float()
        elif case == "stride":
            b = b.T.contiguous().T
        elif case == "unaligned":
            storage = torch.empty(
                a.numel() + 1, dtype=a.dtype, device=a.device
            )
            a = storage[1:].view_as(a).copy_(a)
        elif case == "negative":
            a = torch._neg_view(a)
        elif case == "inner":
            b = torch.empty(
                b.shape[0] + 16,
                b.shape[1],
                dtype=b.dtype,
                device=b.device,
            )
        else:
            a = [1, 2, 3]
    with (
        patch.object(
            torch, "matmul", side_effect=AssertionError("Unexpected fallback")
        ),
        pytest.raises(error, match=message),
    ):
        MODULE.matmul_bf16(a, b)


def test_unsupported_gpu_reports_architecture():
    from types import SimpleNamespace

    a, b, _ = inputs(MODULE.SHAPES[0])
    with (
        patch.object(
            torch.cuda,
            "get_device_properties",
            return_value=SimpleNamespace(gcnArchName="gfx942"),
        ),
        pytest.raises(RuntimeError, match="detected gfx942"),
    ):
        MODULE.matmul_bf16(a, b)


def test_autograd_requires_no_grad():
    a, b, expected = inputs(MODULE.SHAPES[0])
    a.requires_grad_()
    with pytest.raises(RuntimeError, match="no autograd support"):
        MODULE.matmul_bf16(a, b)
    with torch.no_grad():
        result = MODULE.matmul_bf16(a, b)
        assert not result.requires_grad
        assert_result(result, expected)


def test_autocast_reports_reason():
    a, b, _ = inputs(MODULE.SHAPES[0])
    with (
        torch.autocast("cuda", dtype=torch.float16),
        pytest.raises(RuntimeError, match="disable autocast"),
    ):
        MODULE.matmul_bf16(a, b)


def test_forward_autograd_reports_reason():
    a, b, _ = inputs(MODULE.SHAPES[0])
    with torch.autograd.forward_ad.dual_level():
        dual = torch.autograd.forward_ad.make_dual(a, torch.ones_like(a))
        with pytest.raises(RuntimeError, match="forward-mode autograd"):
            MODULE.matmul_bf16(dual, b)


def test_vmap_reports_reason():
    a, b, _ = inputs(MODULE.SHAPES[0])
    batch = torch.stack((a, -a))
    with pytest.raises(RuntimeError, match="vmap or tensor transforms"):
        torch.vmap(lambda value: MODULE.matmul_bf16(value, b))(batch)


def test_inference_mode():
    a, b, expected = inputs(MODULE.SHAPES[0])
    with torch.inference_mode():
        c = torch.empty_like(expected, device=a.device)
        assert MODULE.matmul_bf16(a, b, out=c) is c
        assert_result(c, expected)


def test_parameter_in_no_grad():
    a, b, expected = inputs(MODULE.SHAPES[0])
    b = torch.nn.Parameter(b)
    with torch.no_grad():
        assert_result(MODULE.matmul_bf16(a, b), expected)


@pytest.mark.parametrize(
    "case, error, message",
    (
        ("shape", ValueError, "out must have shape"),
        ("alias", ValueError, "out must not overlap input"),
        ("dtype", TypeError, "out must have dtype torch.bfloat16"),
        ("stride", ValueError, "out must be contiguous"),
        ("cpu", ValueError, "out must be on a ROCm GPU"),
        ("type", TypeError, "out must be a torch.Tensor"),
    ),
)
def test_unsupported_out_reports_reason(case, error, message):
    a, b, expected = inputs(MODULE.SHAPES[0])
    if case == "shape":
        c = torch.empty(0, dtype=a.dtype, device=a.device)
    elif case == "alias":
        c = a.flatten()[: expected.numel()].view_as(expected)
    elif case == "dtype":
        c = torch.empty_like(expected, dtype=torch.float32, device=a.device)
    elif case == "stride":
        c = torch.empty(
            expected.shape[1], expected.shape[0], dtype=a.dtype, device=a.device
        ).T
    elif case == "cpu":
        c = torch.empty_like(expected)
    else:
        c = []
    with (
        patch.object(
            torch, "matmul", side_effect=AssertionError("Unexpected fallback")
        ),
        pytest.raises(error, match=message),
    ):
        MODULE.matmul_bf16(a, b, out=c)


def test_separate_stream_workspaces():
    shape = MODULE.SHAPES[0]
    config = MODULE.CONFIGS_BY_SHAPE[shape]
    a, b, expected = inputs(shape)
    streams = (torch.cuda.Stream(), torch.cuda.Stream())
    values = (a, a * 2)
    results, workspaces = [], []
    for value, stream in zip(values, streams, strict=True):
        stream.wait_stream(torch.cuda.current_stream())
        results.append(MODULE.matmul_bf16(value, b, stream=stream))
        workspaces.append(workspace(config, shape, a.device, stream))
    torch.cuda.synchronize()
    for index, result in enumerate(results):
        assert_result(result, expected * (index + 1))
    assert workspaces[0][0].data_ptr() != workspaces[1][0].data_ptr()
    for scratch in workspaces:
        MODULE.check_workspace(scratch)


def test_graphs_have_private_scratch_and_survive_cache_eviction():
    a, b, expected = inputs(MODULE.SHAPES[0])
    other_left = -a
    capture_stream = torch.cuda.Stream()
    capture_stream.wait_stream(torch.cuda.current_stream())
    with torch.cuda.stream(capture_stream):
        MODULE.matmul_bf16(a, b)  # Warm the specialization before capture.
    torch.cuda.synchronize()
    graphs, outputs = [], []
    before = MODULE._workspace_for.cache_info().misses
    for value in (a, other_left):
        graph = torch.cuda.CUDAGraph()
        with torch.cuda.graph(graph, stream=capture_stream):
            outputs.append(MODULE.matmul_bf16(value, b))
        graphs.append(graph)
    assert MODULE._workspace_for.cache_info().misses == before + 2
    # Drop all Python workspace references. Graph pools must retain captured scratch.
    MODULE._workspace_for.cache_clear()
    torch.cuda.empty_cache()
    replay_streams = (torch.cuda.Stream(), torch.cuda.Stream())
    for _ in range(10):
        for graph, stream in zip(graphs, replay_streams, strict=True):
            with torch.cuda.stream(stream):
                graph.replay()
    torch.cuda.synchronize()
    assert_result(outputs[0], expected)
    assert_result(outputs[1], -expected)
    # Replay must read changed values at the original input addresses.
    a.neg_()
    torch.cuda.synchronize()
    for graph in graphs:
        graph.replay()
    torch.cuda.synchronize()
    assert_result(outputs[0], -expected)
    assert_result(outputs[1], -expected)
