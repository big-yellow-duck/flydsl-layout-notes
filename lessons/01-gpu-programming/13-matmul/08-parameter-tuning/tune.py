"""Search on training inputs, then verify a locked configuration on held-out inputs.

Run: pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/tune.py \
    --sweep --timing direct-host --output /tmp/flydsl-tile-search.json
Run: pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/tune.py \
    --verify --timing direct-host --output /tmp/flydsl-tile-verification.json
"""

import argparse
import ctypes
import hashlib
import inspect
import json
import platform
import random
import runpy
import socket
import statistics
import time
from dataclasses import asdict, replace
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
SHAPE = (1024, 1024, 1024)
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
            inspect.getsource(BUILD).encode()
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
    metadata = graph_nodes(graph)
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


def candidates(group_m=8, extended=False):
    if extended:
        configs = []
        for (bm, bn), bk, (wm, wn) in product(
            ((64, 256), (128, 256), (256, 64), (256, 128), (128, 128)),
            (32, 64),
            ((2, 4), (4, 2)),
        ):
            config = Config(bm, bn, bk, wm, wn, group_m=group_m)
            try:
                MODULE["validate_config"](config, SHAPE)
            except ValueError:
                continue
            configs.append(config)
        return configs
    configs = [Config(32, 32, 32, 2, 2, group_m=group_m)]
    for (bm, bn), bk, (wm, wn) in product(
        ((64, 64), (64, 128), (128, 64), (128, 128)),
        (16, 32, 64, 128),
        ((2, 2), (4, 1), (1, 4), (1, 2), (2, 1)),
    ):
        config = Config(bm, bn, bk, wm, wn, group_m=group_m)
        try:
            MODULE["validate_config"](config, SHAPE)
        except ValueError:
            continue
        configs.append(config)
    return configs


def prepare(group_m=8, extended=False):
    trace_data, training_data = inputs(0, True), inputs(13)
    validate(torch_launch, trace_data, True)
    validate(torch_launch, training_data)
    accepted, failures = [], []
    # Compile and check every candidate before recording any search timings.
    for config in candidates(group_m, extended):
        try:
            launch = partial(MODULE["matmul_bf16"], config=config)
            validate(launch, trace_data, True)
            validate(launch, training_data)
            accepted.append((config, launch))
            print("CHECKED", config.name, flush=True)
        except (RuntimeError, AssertionError, ValueError) as error:
            failures.append(
                {
                    "config": asdict(config),
                    "name": config.name,
                    "error": type(error).__name__ + ": " + str(error),
                }
            )
            print("REJECTED", config.name, str(error)[:200], flush=True)
    return accepted, failures, training_data


def sweep(timing, group_m=8, extended=False):
    accepted, failures, training_data = prepare(group_m, extended)
    random.Random(41).shuffle(accepted)
    rows = []
    for index, (config, launch) in enumerate(accepted):
        measure = paired_measure(
            launch, torch_launch, training_data, 5, 20, index, timing
        )
        row = {
            "config": asdict(config),
            "name": config.name,
            "lds_bytes": config.lds_bytes,
            "accumulator_values": config.accumulator_values,
            "correctness": "full trace/random passed",
            **measure,
        }
        rows.append(row)
        print("MEASURED", config.name, round(measure["paired_ratio"], 4), flush=True)
    if not rows:
        raise RuntimeError("No correct candidate")
    rows.sort(key=lambda row: row["paired_ratio"])
    return {
        "kind": "training_search",
        "environment": environment(),
        "training_seed": 13,
        "trace_check": True,
        "candidate_count": len(candidates(group_m, extended)),
        "extended": extended,
        "group_m": group_m,
        "selection": "minimum median paired kernel/torch ratio on training inputs",
        "winner": rows[0],
        "ranking": rows,
        "rejected": failures,
        "note": "Search results select a candidate; they are not held-out proof of parity",
    }


def idle_probe():
    torch.cuda.synchronize()
    files = sorted(Path("/sys/class/drm").glob("card*/device/gpu_busy_percent"))
    samples = []
    for _ in range(5):
        time.sleep(0.2)
        samples.append({str(path): int(path.read_text()) for path in files})
    return {
        "samples_percent": samples,
        "scope": "no benchmark dispatches during this one-second probe",
    }


def verify(config, seeds, timing):
    print("LOCKED", config.name, flush=True)
    checkpoint = MODULE["solve"](config, shape=SHAPE)
    kernel = partial(MODULE["matmul_bf16"], config=config)
    rounds = []
    idle_samples = []
    for seed in seeds:
        data = inputs(seed)
        validate(kernel, data)
        validate(torch_launch, data)
        idle_samples.append({"seed": seed, **idle_probe()})
        for repetition in range(3):
            row = {
                "seed": seed,
                "round": repetition,
                **paired_measure(
                    kernel,
                    torch_launch,
                    data,
                    7,
                    20 if timing == "graph-host" else 50,
                    seed + repetition,
                    timing,
                ),
            }
            rounds.append(row)
            print(
                "HELDOUT", seed, repetition, round(row["paired_ratio"], 4), flush=True
            )
    worst = max(row["paired_ratio"] for row in rounds)
    status = (
        "win" if worst < WIN_LIMIT else "match" if worst <= MATCH_LIMIT else "slower"
    )
    return {
        "kind": "locked_heldout_verification",
        "environment": environment(),
        "config": asdict(config),
        "name": config.name,
        "correctness": checkpoint,
        "selection": "configuration locked before these held-out inputs and timings",
        "seeds": seeds,
        "pre_measurement_idle_probes": idle_samples,
        "rounds": rounds,
        "worst_round_paired_ratio": worst,
        "thresholds": {
            "win": "every round ratio < 0.95",
            "match": "every round ratio <= 1.05",
        },
        "performance_status": status,
        "median_kernel_ms": statistics.median(row["kernel_ms"] for row in rounds),
        "median_torch_ms": statistics.median(row["torch_ms"] for row in rounds),
        "note": "Paired graph replay throughput or direct-launch host throughput as selected; not device-event timing",
    }


def main():
    global SHAPE
    parser = argparse.ArgumentParser(description=__doc__)
    action = parser.add_mutually_exclusive_group(required=True)
    action.add_argument("--sweep", action="store_true")
    action.add_argument("--verify", action="store_true")
    action.add_argument("--check-candidates", action="store_true")
    parser.add_argument(
        "--config",
        default=None,
        help="locked BM,BN,BK,WM,WN; defaults to selected config",
    )
    parser.add_argument(
        "--seeds", type=int, nargs="+", default=[20261104, 20261105, 20261106]
    )
    parser.add_argument(
        "--shape", type=int, nargs=3, default=SHAPE, metavar=("M", "N", "K")
    )
    parser.add_argument(
        "--extended",
        action="store_true",
        help="search wider tiles with eight-wave blocks",
    )
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument(
        "--timing", choices=("graph-host", "direct-host"), default="direct-host"
    )
    parser.add_argument(
        "--group-m",
        type=int,
        default=None,
        help="output tile rows per group; defaults to Config.group_m",
    )
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output file to retain prior measurements")
    SHAPE = tuple(args.shape)
    if any(size <= 0 for size in SHAPE):
        parser.error("shape dimensions must be positive")
    config = (
        MODULE["CONFIGS_BY_SHAPE"].get(SHAPE, MODULE["SELECTED_CONFIG"])
        if args.config is None
        else Config(*map(int, args.config.split(",")))
    )
    if args.group_m is not None:
        config = replace(config, group_m=args.group_m)
    group_m = config.group_m
    extended = args.extended
    MODULE["validate_config"](config, SHAPE)
    if args.check_candidates:
        accepted, rejected, _ = prepare(group_m, extended)
        report = {
            "kind": "candidate_correctness_only",
            "environment": environment(),
            "checked": [asdict(config) for config, _ in accepted],
            "rejected": rejected,
            "candidate_count": len(candidates(group_m, extended)),
            "note": "No performance measurements or parity claim",
        }
    elif args.sweep:
        report = sweep(args.timing, group_m, extended)
    else:
        report = verify(config, args.seeds, args.timing)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2) + "\n")
    print("SAVED", args.output, flush=True)
    if args.verify:
        print("STATUS", report["performance_status"], flush=True)


if __name__ == "__main__":
    main()
