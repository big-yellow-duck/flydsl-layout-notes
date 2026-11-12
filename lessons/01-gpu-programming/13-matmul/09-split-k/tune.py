"""Search on training inputs, then verify a locked configuration on held-out inputs.

Run: pixi run python lessons/01-gpu-programming/13-matmul/09-split-k/tune.py \
    --sweep --timing direct-host --output /tmp/flydsl-split-k-search.json
Run: pixi run python lessons/01-gpu-programming/13-matmul/09-split-k/tune.py \
    --verify --timing direct-host --output /tmp/flydsl-split-k-verification.json
"""

import argparse
import ctypes
import hashlib
import inspect
import json
import platform
import runpy
import socket
import statistics
import time
from collections import Counter
from dataclasses import asdict
from datetime import UTC, datetime
from functools import lru_cache, partial
from importlib.metadata import version
from itertools import product
from pathlib import Path

import torch

torch.set_num_threads(1)  # Keep CPU reference checks from occupying APU cores.

HERE = Path(__file__).resolve().parent
MODULE = runpy.run_path(str(HERE / "solution.py"))
Config = MODULE["Config"]
BUILD = MODULE["_matmul_bf16"]._original_func
SHAPE = (16, 1024, 8192)
MATCH_LIMIT = 1.05
WIN_LIMIT = 0.95


def environment():
    return {
        "hostname": socket.gethostname(),
        "timestamp_utc": datetime.now(UTC).isoformat(),
        "gpu": torch.cuda.get_device_name(),
        "architecture": torch.cuda.get_device_properties(0).gcnArchName,
        "flydsl": version("flydsl"),
        "torch": torch.__version__,
        "hip": torch.version.hip,
        "kernel": platform.release(),
        "shape_MNK": SHAPE,
        "inputs": "row-major BF16 A/B; no packing; FP32 accumulation; BF16 output",
        "output": "same preallocated GPU output and trailing sentinels for both implementations",
        "timing": "synchronized host clock; graph replay or direct launch recorded per measurement; not device-only",
        "cpu_reference_threads": torch.get_num_threads(),
        "kernel_build_sha256": hashlib.sha256(
            inspect.getsource(inspect.unwrap(BUILD)).encode()
        ).hexdigest(),
        "source_sha256": {
            name: hashlib.sha256((HERE / name).read_bytes()).hexdigest()
            for name in ("solution.py", "tune.py")
        },
    }


def inputs(seed, trace=False):
    m, n, k = SHAPE
    if trace:
        a_cpu = ((torch.arange(m * k).reshape(m, k) % 5) - 2).to(torch.bfloat16)
        b_cpu = ((torch.arange(k * n).reshape(k, n) % 7) - 3).to(torch.bfloat16)
    else:
        generator = torch.Generator().manual_seed(seed)
        a_cpu = torch.randn(m, k, generator=generator).to(torch.bfloat16)
        b_cpu = torch.randn(k, n, generator=generator).to(torch.bfloat16)
    expected = (a_cpu.float() @ b_cpu.float()).to(torch.bfloat16)
    storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
    return a_cpu.cuda(), b_cpu.cuda(), storage, expected


def _workspace_for_launch(launch, data, stream=None, capture_id=None):
    """Inspect the launcher-owned scratch for validation, never dispatch GEMM."""
    callee = getattr(launch, "func", launch)
    if callee.__name__ != "matmul_bf16":
        return None
    namespace = callee.__globals__
    config = getattr(launch, "keywords", {}).get("config")
    config = config or namespace["CONFIGS_BY_SHAPE"][SHAPE]
    if config.split_k == 1:
        return None
    device = data[0].device
    stream = stream or torch.cuda.current_stream(device)
    workspace = namespace["_workspace_for"](config, SHAPE, device, stream, capture_id)
    return namespace["check_workspace"], workspace


def check_launch_workspace(launch, data):
    inspection = _workspace_for_launch(launch, data)
    if inspection is not None:
        check, workspace = inspection
        check(workspace)


def validate(launch, data, trace=False):
    a, b, storage, expected = data
    out = storage[:-16].view(SHAPE[0], SHAPE[1])
    out.fill_(float("nan"))
    launch(a, b, out=out)
    torch.cuda.synchronize()
    torch.testing.assert_close(
        out.cpu(),
        expected,
        rtol=0 if trace else 0.016,
        atol=0.001 if trace else 0.03125,
    )
    assert torch.all(storage[-16:] == -99).item(), "Output sentinel changed"
    check_launch_workspace(launch, data)


def timed_batch(launch, repeats):
    torch.cuda.synchronize()
    start = time.perf_counter()
    for _ in range(repeats):
        launch()
    torch.cuda.synchronize()
    return (time.perf_counter() - start) * 1000 / repeats


@lru_cache(None)
def hip_runtime():
    runtime = ctypes.CDLL("libamdhip64.so")
    runtime.hipGraphGetNodes.argtypes = [
        ctypes.c_void_p,
        ctypes.POINTER(ctypes.c_void_p),
        ctypes.POINTER(ctypes.c_size_t),
    ]
    runtime.hipGraphNodeGetType.argtypes = [
        ctypes.c_void_p,
        ctypes.POINTER(ctypes.c_int),
    ]
    return runtime


def graph_nodes(graph):
    runtime = hip_runtime()
    count = ctypes.c_size_t()
    handle = ctypes.c_void_p(graph.raw_cuda_graph())
    status = runtime.hipGraphGetNodes(handle, None, ctypes.byref(count))
    if status:
        raise RuntimeError(f"hipGraphGetNodes failed: {status}")
    nodes = (ctypes.c_void_p * count.value)()
    status = runtime.hipGraphGetNodes(handle, nodes, ctypes.byref(count))
    if status:
        raise RuntimeError(f"hipGraphGetNodes failed: {status}")
    types = []
    for node in nodes:
        kind = ctypes.c_int()
        status = runtime.hipGraphNodeGetType(node, ctypes.byref(kind))
        if status:
            raise RuntimeError(f"hipGraphNodeGetType failed: {status}")
        types.append(kind.value)
    return {"nodes": count.value, "kernel_nodes": types.count(0)}


def capture(launch, data, operations=32):
    a, b, storage, expected = data
    out = storage[:-16].view(SHAPE[0], SHAPE[1])
    stream = torch.cuda.Stream()
    with torch.cuda.stream(stream):
        for _ in range(3):
            launch(a, b, out=out, stream=stream)
    torch.cuda.synchronize()
    graph = torch.cuda.CUDAGraph(keep_graph=True)
    with torch.cuda.graph(graph, stream=stream):
        for _ in range(operations):
            launch(a, b, out=out, stream=stream)
        callee = getattr(launch, "func", launch)
        capture_id = (
            callee.__globals__["_capture_id"](stream)
            if callee.__name__ == "matmul_bf16"
            else None
        )
        inspection = _workspace_for_launch(launch, data, stream, capture_id)
    metadata = graph_nodes(graph)
    callee = getattr(launch, "func", launch)
    if callee.__name__ == "matmul_bf16":
        config = getattr(launch, "keywords", {}).get("config")
        config = config or callee.__globals__["CONFIGS_BY_SHAPE"][SHAPE]
        # Each graph owns scratch. Its one-time counter/guard initialization is
        # captured once before the GEMMs and is included in graph replay timing.
        metadata["workspace_initialization_nodes"] = 3 if config.split_k > 1 else 0
    if metadata["kernel_nodes"] < operations:
        raise RuntimeError(f"Incomplete graph capture: {metadata}")
    graph.instantiate()
    # Prove replay consumes changed inputs, rather than captured values or an empty graph.
    a.mul_(-1)
    out.fill_(float("nan"))
    torch.cuda.synchronize()
    graph.replay()
    torch.cuda.synchronize()
    torch.testing.assert_close(out.cpu(), -expected, rtol=0.016, atol=0.03125)
    assert torch.all(storage[-16:] == -99).item(), "Graph sentinel changed"
    a.mul_(-1)
    out.fill_(float("nan"))
    torch.cuda.synchronize()
    graph.replay()
    torch.cuda.synchronize()
    torch.testing.assert_close(out.cpu(), expected, rtol=0.016, atol=0.03125)
    assert torch.all(storage[-16:] == -99).item(), "Graph sentinel changed"
    if inspection is not None:
        check, workspace = inspection
        check(workspace)
    return graph, {
        **metadata,
        "matmuls_per_replay": operations,
        "mutated_input_replay": "passed",
        "nan_output_and_sentinels": "passed",
    }


def paired_measure(kernel, baseline, data, batches, repeats, order_seed, timing):
    a, b, storage, _ = data
    out = storage[:-16].view(SHAPE[0], SHAPE[1])
    graph_metadata = {}
    graphs = []
    if timing == "graph-host":
        launches = {}
        for name, launch in (("kernel", kernel), ("torch", baseline)):
            graph, metadata = capture(launch, data)
            expected_nodes = 32 + metadata.get("workspace_initialization_nodes", 0)
            if name == "kernel" and (
                metadata["nodes"] != expected_nodes
                or not 32 <= metadata["kernel_nodes"] <= expected_nodes
            ):
                raise RuntimeError(
                    f"Expected one kernel per GEMM plus declared workspace initialization: {metadata}"
                )
            graphs.append(graph)
            launches[name] = graph.replay
            graph_metadata[name] = metadata
        operations = 32
    else:
        launches = {
            "kernel": lambda: kernel(a, b, out=out),
            "torch": lambda: baseline(a, b, out=out),
        }
        operations = 1
    for launch in launches.values():
        for _ in range(5):
            launch()
    torch.cuda.synchronize()
    samples = {"kernel": [], "torch": []}
    orders = []
    for batch in range(batches):
        order = (
            ["kernel", "torch"]
            if (batch + order_seed) % 2 == 0
            else ["torch", "kernel"]
        )
        orders.append(order)
        for name in order:
            samples[name].append(timed_batch(launches[name], repeats) / operations)
    ratios = [a / b for a, b in zip(samples["kernel"], samples["torch"], strict=True)]
    return {
        "kernel_ms": statistics.median(samples["kernel"]),
        "torch_ms": statistics.median(samples["torch"]),
        "paired_ratio": statistics.median(ratios),
        "samples_ms": samples,
        "paired_ratios": ratios,
        "orders": orders,
        "batches": batches,
        "repeats": repeats,
        "warmups": 5,
        "timing": timing,
        "graph_metadata": graph_metadata,
    }


def torch_launch(a, b, out, stream=None):
    torch.matmul(a, b, out=out)


def raw_candidates(exhaustive=False):
    if exhaustive:
        m, n, k = SHAPE
        block_rows = [tile for tile in range(16, m + 1, 16) if m % tile == 0]
        block_columns = [tile for tile in range(16, n + 1, 16) if n % tile == 0]
        block_reductions = [tile for tile in range(16, k + 1, 16) if k % tile == 0]
        for bm in block_rows:
            wave_arrangements = [
                (wm, wn)
                for wm, wn in product((1, 2, 4, 8), repeat=2)
                if wm <= bm // 16 and wm * wn in (1, 2, 4, 8)
            ]
            for bn, bk, (wm, wn), split_k in product(
                block_columns, block_reductions, wave_arrangements, (1, 2, 4)
            ):
                yield Config(bm, bn, bk, wm, wn, group_m=1, split_k=split_k)
        return
    block_rows = (16, 32) if SHAPE[0] == 32 else (16,)
    for bm, (bn, wm, wn), bk, split_k in product(
        block_rows,
        (
            (16, 1, 1),
            (32, 1, 1),
            (64, 1, 1),
            (128, 1, 1),
            (256, 1, 1),
            (32, 1, 2),
            (64, 1, 2),
            (128, 1, 2),
            (64, 1, 4),
            (128, 1, 4),
            (256, 1, 4),
            (512, 1, 2),
        ),
        (16, 32, 64, 128),
        (1, 2, 4),
    ):
        yield Config(bm, bn, bk, wm, wn, group_m=1, split_k=split_k)


def candidate_space(exhaustive=False):
    configs, pruning = [], Counter()
    raw = list(raw_candidates(exhaustive))
    for config in raw:
        try:
            MODULE["validate_config"](config, SHAPE)
        except ValueError as error:
            pruning[str(error)] += 1
        else:
            configs.append(config)
    return configs, {
        "raw_candidate_count": len(raw),
        "pruned_by_validation": dict(pruning),
        "exhaustive": exhaustive,
        "fixed_group_m": 1,
        "dimensions": "all complete BM/BN/BK tiles and 1/2/4/8-wave arrangements; split_k in 1/2/4"
        if exhaustive
        else "bounded teaching sweep",
    }


def candidates(exhaustive=False):
    return candidate_space(exhaustive)[0]


def sweep(timing, exhaustive=False):
    trace_data, training_data = inputs(0, True), inputs(13)
    validate(torch_launch, trace_data, True)
    validate(torch_launch, training_data)
    configs, space = candidate_space(exhaustive)
    print(
        "SEARCH",
        len(configs),
        "valid of",
        space["raw_candidate_count"],
        "combinations",
        flush=True,
    )
    rows, rejected = [], []
    for config in configs:
        try:
            launch = partial(MODULE["matmul_bf16"], config=config)
            validate(launch, trace_data, True)
            validate(launch, training_data)
            result = paired_measure(
                launch, torch_launch, training_data, 3, 5, 0, timing
            )
            check_launch_workspace(launch, training_data)
            row = {"config": asdict(config), "name": config.name, **result}
            rows.append(row)
            print("TRAIN", config.name, round(result["paired_ratio"], 4), flush=True)
        except (RuntimeError, AssertionError) as error:
            rejected.append({"config": asdict(config), "error": str(error)})
            print("REJECTED", config.name, str(error), flush=True)
    rows.sort(key=lambda row: row["paired_ratio"])
    return {
        "kind": "training_search",
        "environment": environment(),
        "training_seed": 13,
        "ranking": rows,
        "rejected": rejected,
        "candidate_count": len(configs),
        "search_space": space,
        "selection": "minimum paired native/torch ratio on seed-13 training data",
        "note": "Select here, then lock a configuration before held-out verification",
    }


def verify(config, seeds, timing):
    print("LOCKED", config.name, flush=True)
    correctness = MODULE["solve"](config, SHAPE)
    launch = partial(MODULE["matmul_bf16"], config=config)
    rounds = []
    for seed in seeds:
        data = inputs(seed)
        validate(launch, data)
        validate(torch_launch, data)
        for repetition in range(3):
            row = {
                "seed": seed,
                "round": repetition,
                **paired_measure(
                    launch,
                    torch_launch,
                    data,
                    7,
                    20 if timing == "graph-host" else 50,
                    seed + repetition,
                    timing,
                ),
            }
            check_launch_workspace(launch, data)
            rounds.append(row)
            print(
                "HELDOUT", seed, repetition, round(row["paired_ratio"], 4), flush=True
            )
    worst = max(row["paired_ratio"] for row in rounds)
    return {
        "kind": "locked_heldout_verification",
        "environment": environment(),
        "config": asdict(config),
        "name": config.name,
        "correctness": correctness,
        "selection": "config locked before these held-out inputs and timings",
        "seeds": seeds,
        "rounds": rounds,
        "worst_round_paired_ratio": worst,
        "thresholds": {
            "win": "every round ratio < 0.95",
            "match": "every round ratio <= 1.05",
        },
        "performance_status": "win"
        if worst < WIN_LIMIT
        else "match"
        if worst <= MATCH_LIMIT
        else "slower",
        "median_kernel_ms": statistics.median(row["kernel_ms"] for row in rounds),
        "median_torch_ms": statistics.median(row["torch_ms"] for row in rounds),
        "note": "Warm, preallocated buffers and persistent workspace; synchronized host batches; timing mode recorded",
    }


def compare(config, shape, timing="graph-host", *, matmul=None):
    global SHAPE
    SHAPE = tuple(shape)
    launch = partial(matmul or MODULE["matmul_bf16"], config=config)
    data = inputs(13)
    validate(launch, data)
    validate(torch_launch, data)
    return paired_measure(launch, torch_launch, data, 7, 10, 0, timing)


def main():
    global SHAPE
    parser = argparse.ArgumentParser(description=__doc__)
    action = parser.add_mutually_exclusive_group(required=True)
    action.add_argument("--sweep", action="store_true")
    action.add_argument("--verify", action="store_true")
    parser.add_argument(
        "--shape", type=int, nargs=3, default=SHAPE, metavar=("M", "N", "K")
    )
    parser.add_argument(
        "--config", help="BM,BN,BK,WM,WN,SPLIT_K; defaults to the locked shape config"
    )
    parser.add_argument(
        "--timing", choices=("graph-host", "direct-host"), default="graph-host"
    )
    parser.add_argument(
        "--seeds", type=int, nargs="+", default=(2026110701, 2026110702, 2026110703)
    )
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument(
        "--exhaustive",
        action="store_true",
        help="sweep every legal complete tile/wave/split configuration with group_m=1",
    )
    args = parser.parse_args()
    if args.exhaustive and not args.sweep:
        parser.error("--exhaustive requires --sweep")
    if args.output.exists():
        parser.error("Use a fresh output path to preserve previous measurements")
    SHAPE = tuple(args.shape)
    if SHAPE not in MODULE["SHAPES"]:
        parser.error("Choose a supported skinny shape")
    config = MODULE["CONFIGS_BY_SHAPE"][SHAPE]
    if args.config:
        values = tuple(map(int, args.config.split(",")))
        if len(values) != 6:
            parser.error("--config requires BM,BN,BK,WM,WN,SPLIT_K")
        config = Config(*values[:5], group_m=1, split_k=values[5])
    MODULE["validate_config"](config, SHAPE)
    report = (
        sweep(args.timing, args.exhaustive)
        if args.sweep
        else verify(config, args.seeds, args.timing)
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2) + "\n")
    print("SAVED", args.output, flush=True)
    if args.verify:
        print("STATUS", report["performance_status"], flush=True)


if __name__ == "__main__":
    main()
