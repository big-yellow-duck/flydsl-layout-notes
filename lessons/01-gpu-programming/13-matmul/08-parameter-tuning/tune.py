"""Search on training inputs, then verify a locked configuration on held-out inputs.

Run: pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/tune.py \
    --sweep --output /tmp/flydsl-tile-search.json
Run: pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/tune.py \
    --verify --output /tmp/flydsl-tile-verification.json
"""

import argparse
import hashlib
import inspect
import json
import platform
import random
import runpy
import statistics
import time
from dataclasses import asdict
from importlib.metadata import version
from itertools import product
from pathlib import Path

import flydsl  # noqa: F401 -- load the compiler's LLVM before torch
import torch

HERE = Path(__file__).resolve().parent
MODULE = runpy.run_path(str(HERE / "solution.py"))
Config = MODULE["Config"]
BUILD = MODULE["build"]
SHAPE = (1024, 1024, 1024)
MATCH_LIMIT = 1.05
WIN_LIMIT = 0.95


def environment():
    return {
        "gpu": torch.cuda.get_device_name(),
        "architecture": torch.cuda.get_device_properties(0).gcnArchName,
        "flydsl": version("flydsl"),
        "torch": torch.__version__,
        "hip": torch.version.hip,
        "kernel": platform.release(),
        "shape_MNK": SHAPE,
        "inputs": "row-major BF16 A/B; no packing; FP32 accumulation; BF16 output",
        "output": "same preallocated GPU output and trailing sentinels for both implementations",
        "timing": "synchronized host clock; includes dispatch; not device-only",
        "kernel_build_sha256": hashlib.sha256(
            inspect.getsource(BUILD.__wrapped__).encode()
        ).hexdigest(),
        "source_sha256": {
            name: hashlib.sha256((HERE / name).read_bytes()).hexdigest()
            for name in ("solution.py", "tune.py")
        },
    }


def inputs(seed, trace=False):
    if trace:
        a_cpu = ((torch.arange(1024 * 1024).reshape(1024, 1024) % 5) - 2).to(
            torch.bfloat16
        )
        b_cpu = ((torch.arange(1024 * 1024).reshape(1024, 1024) % 7) - 3).to(
            torch.bfloat16
        )
    else:
        generator = torch.Generator().manual_seed(seed)
        a_cpu = torch.randn(1024, 1024, generator=generator).to(torch.bfloat16)
        b_cpu = torch.randn(1024, 1024, generator=generator).to(torch.bfloat16)
    expected = (a_cpu.float() @ b_cpu.float()).to(torch.bfloat16)
    storage = torch.full((1024 * 1024 + 16,), -99, dtype=torch.bfloat16, device="cuda")
    return a_cpu.cuda(), b_cpu.cuda(), storage, expected


def validate(launch, data, trace=False):
    a, b, storage, expected = data
    out = storage[:-16].view(1024, 1024)
    out.fill_(float("nan"))
    launch(a, b, out)
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


def paired_measure(kernel, baseline, data, batches, repeats, order_seed):
    a, b, storage, _ = data
    out = storage[:-16].view(1024, 1024)
    launches = {
        "kernel": lambda: kernel(a, b, out),
        "torch": lambda: baseline(a, b, out),
    }
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
            samples[name].append(timed_batch(launches[name], repeats))
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
    }


def torch_launch(a, b, out):
    torch.matmul(a, b, out=out)


def launch_for(config):
    run = BUILD(config)
    return lambda a, b, out: run(a, b, out, *SHAPE)


def candidates():
    configs = [Config(32, 32, 32, 2, 2)]
    for (bm, bn), bk, (wm, wn) in product(
        ((64, 64), (64, 128), (128, 64), (128, 128)),
        (16, 32, 64),
        ((2, 2), (4, 1), (1, 4)),
    ):
        config = Config(bm, bn, bk, wm, wn)
        try:
            MODULE["validate_config"](config)
        except ValueError:
            continue
        configs.append(config)
    return configs


def sweep():
    trace_data, training_data = inputs(0, True), inputs(13)
    validate(torch_launch, trace_data, True)
    validate(torch_launch, training_data)
    accepted, failures = [], []
    # Compile and check every candidate before recording any search timings.
    for config in candidates():
        try:
            launch = launch_for(config)
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
    random.Random(41).shuffle(accepted)
    rows = []
    for index, (config, launch) in enumerate(accepted):
        measure = paired_measure(launch, torch_launch, training_data, 5, 20, index)
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
        "candidate_count": len(candidates()),
        "selection": "minimum median paired kernel/torch ratio on training inputs",
        "winner": rows[0],
        "ranking": rows,
        "rejected": failures,
        "note": "Search results select a candidate; they are not held-out proof of parity",
    }


def verify(config, seeds):
    print("LOCKED", config.name, flush=True)
    checkpoint = MODULE["solve"](config)
    kernel = launch_for(config)
    rounds = []
    for seed in seeds:
        data = inputs(seed)
        validate(kernel, data)
        validate(torch_launch, data)
        for repetition in range(3):
            row = {
                "seed": seed,
                "round": repetition,
                **paired_measure(kernel, torch_launch, data, 7, 50, seed + repetition),
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
        "rounds": rounds,
        "worst_round_paired_ratio": worst,
        "thresholds": {
            "win": "every round ratio < 0.95",
            "match": "every round ratio <= 1.05",
        },
        "performance_status": status,
        "median_kernel_ms": statistics.median(row["kernel_ms"] for row in rounds),
        "median_torch_ms": statistics.median(row["torch_ms"] for row in rounds),
        "note": "Host API throughput only; GPU events are unavailable on the recorded system",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    action = parser.add_mutually_exclusive_group(required=True)
    action.add_argument("--sweep", action="store_true")
    action.add_argument("--verify", action="store_true")
    parser.add_argument(
        "--config",
        default=None,
        help="locked BM,BN,BK,WM,WN; defaults to selected config",
    )
    parser.add_argument(
        "--seeds", type=int, nargs="+", default=[20261104, 20261105, 20261106]
    )
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output file to retain prior measurements")
    config = (
        MODULE["SELECTED_CONFIG"]
        if args.config is None
        else Config(*map(int, args.config.split(",")))
    )
    MODULE["validate_config"](config)
    report = sweep() if args.sweep else verify(config, args.seeds)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2) + "\n")
    print("SAVED", args.output, flush=True)
    if args.verify:
        print("STATUS", report["performance_status"], flush=True)


if __name__ == "__main__":
    main()
