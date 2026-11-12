"""Compare per-thread and per-CTA split-K counters in the completed practice.

Run from the repository root:
    pixi run python lessons/01-gpu-programming/13-matmul/09-split-k/benchmark_counters.py \
        --output /tmp/split-k-counters.json
"""

import argparse
import hashlib
import inspect
import json
import platform
import runpy
import socket
import statistics
from dataclasses import asdict, replace
from datetime import UTC, datetime
from functools import partial
from importlib.metadata import version
from pathlib import Path

import torch

HERE = Path(__file__).resolve().parent
PRACTICE = runpy.run_path(str(HERE / "practice.py"))
TIMING = runpy.run_path(str(HERE / "tune.py"))
Config = PRACTICE["Config"]


def check_all():
    """Check both modes, boundary partials, full products, and workspace reuse."""
    rows = []
    for shape, base in PRACTICE["CONFIGS_BY_SHAPE"].items():
        for split_k in (1, 2, 4):
            for scope in ("thread", "cta"):
                config = replace(base, split_k=split_k, counter_scope=scope)
                result = PRACTICE["solve"](config, shape)
                rows.append(result)
                print("CHECK", config.name, shape, "passed", flush=True)
    # Exercise cross-wave publication and election on 32/64/128/256 threads,
    # with several M/N tiles and nontrivial grouped traversal.
    for base in (
        Config(16, 32, 64, 1, 1, group_m=2),
        Config(16, 64, 64, 1, 2, group_m=2),
        Config(16, 128, 64, 1, 4, group_m=2),
        Config(32, 128, 64, 2, 4, group_m=2),
    ):
        for scope in ("thread", "cta"):
            config = replace(base, counter_scope=scope)
            shape = (64, 256, 768)
            rows.append(PRACTICE["solve"](config, shape))
            print("CHECK", config.threads, "threads", scope, "passed", flush=True)
    return rows


def stress_reuse(config, shape, count):
    """Alternate input signs and poison output on every same-workspace launch."""
    launch = partial(PRACTICE["matmul_bf16"], config=config)
    m, n, k = shape
    generator = torch.Generator().manual_seed(97)
    a_cpu = torch.randn(m, k, generator=generator).to(torch.bfloat16)
    b_cpu = torch.randn(k, n, generator=generator).to(torch.bfloat16)
    expected = (a_cpu.float() @ b_cpu.float()).to(torch.bfloat16)
    a, b = a_cpu.cuda(), b_cpu.cuda()
    storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
    out = storage[:-16].view(m, n)
    for iteration in range(count):
        sign = 1 if iteration % 2 == 0 else -1
        a.copy_(a_cpu * sign)
        out.fill_(float("nan"))
        launch(a, b, out=out)
        torch.cuda.synchronize()
        torch.testing.assert_close(out.cpu(), expected * sign, rtol=0.016, atol=0.03125)
        assert torch.all(storage[-16:] == -99).item(), "Output sentinel changed"
        PRACTICE["check_workspace"](
            PRACTICE["_workspace_for"](
                config, shape, a.device, torch.cuda.current_stream(a.device), 0
            )
        )
    return {"config": asdict(config), "launches_checked": count}


def measure(base, shape, seeds, batches, repeats, timings):
    # Reuse the lesson's validated capture, node counting, and paired host clock.
    # Its legacy labels "kernel"/"torch" denote CTA/thread in this comparison.
    paired = TIMING["paired_measure"]
    paired.__globals__["SHAPE"] = shape
    launches = {
        scope: partial(
            PRACTICE["matmul_bf16"], config=replace(base, counter_scope=scope)
        )
        for scope in ("thread", "cta")
    }
    rows = []
    for timing in timings:
        for seed in seeds:
            data = TIMING["inputs"](seed)
            for launch in launches.values():
                TIMING["validate"](launch, data)
            raw = paired(
                launches["cta"],
                launches["thread"],
                data,
                batches,
                repeats,
                seed,
                timing,
            )
            for scope in launches:
                config = replace(base, counter_scope=scope)
                PRACTICE["check_workspace"](
                    PRACTICE["_workspace_for"](
                        config,
                        shape,
                        data[0].device,
                        torch.cuda.current_stream(data[0].device),
                        0,
                    )
                )
            row = {
                "timing": timing,
                "seed": seed,
                "thread_ms": raw["torch_ms"],
                "cta_ms": raw["kernel_ms"],
                "paired_cta_over_thread": raw["paired_ratio"],
                "paired_ratios": raw["paired_ratios"],
                "samples_ms": {
                    "thread": raw["samples_ms"]["torch"],
                    "cta": raw["samples_ms"]["kernel"],
                },
                "orders": [
                    ["cta" if name == "kernel" else "thread" for name in order]
                    for order in raw["orders"]
                ],
                "graph_metadata": {
                    "cta" if name == "kernel" else "thread": metadata
                    for name, metadata in raw["graph_metadata"].items()
                },
            }
            if timing == "graph-host":
                for metadata in row["graph_metadata"].values():
                    expected_nodes = 32 + metadata.get(
                        "workspace_initialization_nodes", 0
                    )
                    assert metadata["nodes"] == expected_nodes
                    assert 32 <= metadata["kernel_nodes"] <= expected_nodes
            rows.append(row)
            print("MEASURE", shape, timing, seed, json.dumps(row), flush=True)
    threads = base.threads
    return {
        "shape_MNK": shape,
        "config": asdict(base),
        "counters_per_output_tile": {"thread": threads, "cta": 1},
        "atomic_increments_per_output_tile": {
            "thread": threads * base.split_k,
            "cta": base.split_k,
        },
        "partial_read_write_bytes_per_output_tile": (
            2 * base.block_m * base.block_n * base.split_k * 4
        ),
        "rounds": rows,
        "summary": {
            timing: {
                "thread_median_ms": statistics.median(
                    row["thread_ms"] for row in rows if row["timing"] == timing
                ),
                "cta_median_ms": statistics.median(
                    row["cta_ms"] for row in rows if row["timing"] == timing
                ),
                "median_paired_cta_over_thread": statistics.median(
                    ratio
                    for row in rows
                    if row["timing"] == timing
                    for ratio in row["paired_ratios"]
                ),
            }
            for timing in timings
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--seeds", type=int, nargs="+", default=(13, 29, 47))
    parser.add_argument("--batches", type=int, default=9)
    parser.add_argument("--repeats", type=int, default=50)
    parser.add_argument("--stress-reuses", type=int, default=100)
    parser.add_argument(
        "--timings",
        nargs="+",
        choices=("graph-host", "direct-host"),
        default=("graph-host", "direct-host"),
    )
    args = parser.parse_args()
    if min(args.batches, args.repeats, args.stress_reuses) <= 0:
        parser.error("batches, repeats, and stress-reuses must be positive")
    torch.set_num_threads(1)
    report = {
        "timestamp_utc": datetime.now(UTC).isoformat(),
        "environment": {
            "hostname": socket.gethostname(),
            "gpu": torch.cuda.get_device_name(),
            "architecture": torch.cuda.get_device_properties(0).gcnArchName,
            "flydsl": version("flydsl"),
            "torch": torch.__version__,
            "hip": torch.version.hip,
            "kernel": platform.release(),
        },
        "source_sha256": {
            name: hashlib.sha256((HERE / name).read_bytes()).hexdigest()
            for name in ("practice.py", "benchmark_counters.py", "tune.py")
        },
        "kernel_sha256": hashlib.sha256(
            inspect.getsource(PRACTICE["_matmul_bf16"]._original_func).encode()
        ).hexdigest(),
        "method": {
            "batches": args.batches,
            "repeats": args.repeats,
            "warmups": 5,
            "seeds": args.seeds,
            "scope": "synchronized host clock; warm inputs; preallocated output; cached workspace; graph workspace initialization included",
            "graph_operations_per_replay": 32,
            "paired_order": "alternating CTA/thread and thread/CTA",
            "ratio": "CTA time / per-thread time; below 1 favors CTA",
        },
        "correctness": check_all(),
        "reuse_stress": [],
        "comparisons": [],
    }
    # Keep the illustrated 16x64/64-thread tile fixed across all three workloads,
    # including the wide workload whose normal selected config uses split_k=1.
    for shape in PRACTICE["SHAPES"]:
        base = Config(block_m=shape[0])
        for scope in ("thread", "cta"):
            config = replace(base, counter_scope=scope)
            report["reuse_stress"].append(
                stress_reuse(config, shape, args.stress_reuses)
            )
            print("STRESS", shape, scope, args.stress_reuses, "passed", flush=True)
        report["comparisons"].append(
            measure(base, shape, args.seeds, args.batches, args.repeats, args.timings)
        )
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(json.dumps(report, indent=2) + "\n")
    for comparison in report["comparisons"]:
        print("SUMMARY", comparison["shape_MNK"], comparison["summary"], flush=True)


if __name__ == "__main__":
    main()
