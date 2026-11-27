"""Validation, independent reference, and fixtures for the BF16 MoE lessons."""

import flydsl.expr as fx
import torch


def output_coordinates(rows, columns, threads):
    coordinates = fx.make_view(
        fx.make_int_tuple((0, 0)), fx.make_identity_layout((rows, columns))
    )
    coordinate_tiles = fx.flat_divide(coordinates, (1, threads))
    block_coordinates = fx.slice(
        coordinate_tiles, (0, None, fx.block_idx.y, fx.block_idx.x)
    )
    coordinate = block_coordinates[fx.thread_idx.x]
    return fx.get_scalar(coordinate[0]), fx.get_scalar(coordinate[1])


def prepare(x, w_gate_up, w_down, topk_ids, topk_weights, out, workspace):
    operands = (
        ("x", x, torch.bfloat16, 2),
        ("w_gate_up", w_gate_up, torch.bfloat16, 3),
        ("w_down", w_down, torch.bfloat16, 3),
        ("topk_ids", topk_ids, torch.int32, 2),
        ("topk_weights", topk_weights, torch.float32, 2),
    )
    buffers = {}
    for name, tensor, dtype, ndim in operands:
        if not isinstance(tensor, torch.Tensor) or tensor.dtype != dtype:
            raise TypeError(f"{name} must be a {dtype} tensor")
        if tensor.ndim != ndim:
            raise ValueError(f"{name} must have {ndim} dimensions")
        check_storage(name, tensor, x.device)
        buffers[name] = tensor

    tokens, hidden = x.shape
    experts, intermediate, down_hidden = w_down.shape
    top_k = topk_ids.shape[1]
    if min(hidden, experts, intermediate, top_k) <= 0 or top_k > experts:
        raise ValueError("Widths and top-k must be positive, with top-k <= experts")
    if down_hidden != hidden or w_gate_up.shape != (experts, hidden, 2 * intermediate):
        raise ValueError("Expert weights must have shapes [E,H,2I] and [E,I,H]")
    if topk_ids.shape != (tokens, top_k) or topk_weights.shape != topk_ids.shape:
        raise ValueError("Routing tensors must share shape [T,top_k]")
    if not torch.version.hip or torch.is_autocast_enabled("cuda"):
        raise RuntimeError("BF16 MoE requires ROCm with autocast disabled")

    if out is None:
        out = torch.empty_like(x)
    if workspace is None:
        workspace = {}
    if not isinstance(workspace, dict):
        raise TypeError("workspace must be a dictionary of preallocated tensors")
    check_buffer("out", out, x.shape, x.dtype, x.device, buffers)
    buffers["out"] = out
    return out, (tokens, hidden, experts, intermediate, top_k), workspace, buffers


def check_storage(name, tensor, device):
    if (
        not tensor.is_cuda
        or tensor.device != device
        or tensor.layout != torch.strided
        or not tensor.is_contiguous()
        or tensor.is_neg()
    ):
        raise ValueError(f"{name} must be contiguous on the same ROCm device as x")
    if torch.is_grad_enabled() and tensor.requires_grad:
        raise RuntimeError(f"{name} requires gradients, but MoE is inference-only")


def check_buffer(name, tensor, shape, dtype, device, buffers):
    if not isinstance(tensor, torch.Tensor) or tensor.dtype != dtype:
        raise TypeError(f"{name} must be a {dtype} tensor")
    if tensor.shape != shape:
        raise ValueError(f"{name} must have shape {tuple(shape)}")
    check_storage(name, tensor, device)
    start, size = tensor.data_ptr(), tensor.numel() * tensor.element_size()
    for other_name, other in buffers.items():
        other_start = other.data_ptr()
        other_size = other.numel() * other.element_size()
        if (
            size
            and other_size
            and start < other_start + other_size
            and other_start < start + size
        ):
            raise ValueError(f"{name} must not overlap {other_name}")


def scratch(spec, device, workspace, buffers):
    result = []
    for name, shape, dtype in spec:
        if name in workspace:
            tensor = workspace[name]
            check_buffer(name, tensor, shape, dtype, device, buffers)
        else:
            tensor = torch.empty(shape, dtype=dtype, device=device)
        result.append(tensor)
        buffers[name] = tensor
    return tuple(result)


def reference(x, w_gate_up, w_down, topk_ids, topk_weights):
    """Independent per-expert Torch reference using the actual BF16 inputs."""
    tokens, hidden = x.shape
    experts = w_down.shape[0]
    routes = torch.zeros(
        (*topk_ids.shape, hidden), dtype=torch.float32, device=x.device
    )
    for expert in range(experts):
        token, slot = torch.where(topk_ids == expert)
        gate, up = (x[token].float() @ w_gate_up[expert].float()).chunk(2, dim=-1)
        activated = (torch.nn.functional.silu(gate) * up).bfloat16()
        routes[token, slot] = (
            activated.float() @ w_down[expert].float()
        ) * topk_weights[token, slot, None]
    return routes.sum(dim=1).bfloat16().view(tokens, hidden)


def trace_inputs():
    x = torch.tensor([[1], [2], [3]], dtype=torch.bfloat16)
    # Zero gate for experts 1–3 makes the trace depend only on expert 0.
    gate_up = torch.tensor([[[1, 2]], [[0, 3]], [[0, 4]], [[0, 5]]], dtype=x.dtype)
    down = torch.tensor([[[1]], [[2]], [[3]], [[4]]], dtype=x.dtype)
    ids = torch.tensor([[0, 1], [1, 0], [0, 2]], dtype=torch.int32)
    weights = torch.tensor([[0.5, 0.5], [0.25, 0.75], [0.25, 0.75]])
    return x, gate_up, down, ids, weights


def make_inputs(
    tokens, hidden, experts, intermediate, top_k, *, routing="balanced", seed=15
):
    gen = torch.Generator().manual_seed(seed)
    x = torch.randn(tokens, hidden, generator=gen).bfloat16()
    gate_up = (
        torch.randn(experts, hidden, 2 * intermediate, generator=gen) / hidden**0.5
    ).bfloat16()
    down = (
        torch.randn(experts, intermediate, hidden, generator=gen) / intermediate**0.5
    ).bfloat16()
    row = torch.arange(tokens)[:, None]
    slot = torch.arange(top_k)[None, :]
    if routing == "balanced":
        ids = (row * top_k + slot) % experts
    elif routing == "skewed":
        ids = (row * (row % 5 == 0) + slot) % experts
    else:
        raise ValueError(f"Unknown routing distribution {routing}")
    weights = torch.softmax(torch.randn(tokens, top_k, generator=gen), dim=1)
    return x, gate_up, down, ids.int(), weights


def check(launch):
    cases = [
        trace_inputs(),
        make_inputs(0, 19, 4, 23, 2),
        make_inputs(1, 19, 4, 23, 1),
        make_inputs(17, 31, 5, 37, 3, routing="skewed"),
        make_inputs(41, 28, 4, 34, 2),
        make_inputs(64, 64, 8, 96, 2),
        make_inputs(79, 127, 7, 65, 4, routing="skewed"),
    ]
    invalid = list(make_inputs(9, 18, 5, 27, 2))
    invalid[3][0] = torch.tensor([-1, 5], dtype=torch.int32)
    cases.append(invalid)
    for inputs in cases:
        expected = reference(*inputs)
        gpu = tuple(t.cuda() for t in inputs)
        output_storage = torch.full(
            (gpu[0].numel() + 16,), float("nan"), device="cuda", dtype=gpu[0].dtype
        )
        out = output_storage[: gpu[0].numel()].view_as(gpu[0])
        assert launch(*gpu, out=out) is out
        torch.testing.assert_close(out.cpu(), expected, atol=0.008, rtol=0.018)
        assert torch.isnan(output_storage[-16:]).all()
    result = launch(*(t.cuda() for t in cases[0])).cpu().view(-1)
    return result.tolist()


def report(solve):
    try:
        checkpoint = solve()
    except NotImplementedError as error:
        print(f"Practice not finished: {error}")
        raise SystemExit(1) from None
    print(f"Exercise passed: output column = {checkpoint}")
