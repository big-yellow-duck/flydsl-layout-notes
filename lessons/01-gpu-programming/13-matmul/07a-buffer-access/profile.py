"""Compare buffer access with universal loads on identical prefetch kernels.

Run: pixi run python lessons/01-gpu-programming/13-matmul/07a-buffer-access/profile.py
Generated comparison source and raw timings are saved under --output.
"""

import argparse
import hashlib
import json
import runpy
import statistics
import time
from functools import partial
from importlib.metadata import version
from pathlib import Path

import flydsl  # noqa: F401 -- load compiler LLVM before torch
import torch

HERE = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output", type=Path, default=Path(".profiling-results/buffer-access")
    )
    parser.add_argument("--repeats", type=int, default=100)
    parser.add_argument("--rounds", type=int, default=9)
    parser.add_argument(
        "--timing", choices=("auto", "gpu-event", "host"), default="auto"
    )
    args = parser.parse_args()
    if args.repeats < 1 or args.rounds < 3:
        parser.error("repeats must be positive and rounds must be at least three")
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    torch.set_num_threads(1)
    source = (HERE / "solution.py").read_text()
    # Change only A/B resource construction and the global load atom. Keep the
    # buffer output store, staging, LDS, WMMA, and schedule identical to 07a.
    universal = source
    for operand in ("left", "right"):
        old = f"{operand}_buffer = fx.rocdl.make_buffer_tensor({operand})"
        assert universal.count(old) == 1
        universal = universal.replace(old, f"{operand}_buffer = {operand}")
    old = "fx.rocdl.BufferCopy128b()"
    assert universal.count(old) == 1
    universal = universal.replace(old, "fx.UniversalCopy128b()")
    generated = output / "universal_load_buffer_store.py"
    generated.write_text(universal)
    paths = {
        "universal_load_store": HERE.parent / "07-interleaved-loads/solution.py",
        "universal_load_buffer_store": generated,
        "buffer_load_store": HERE / "solution.py",
    }
    modules = {name: runpy.run_path(str(path)) for name, path in paths.items()}
    checks = {}
    for name, module in modules.items():
        checks[name] = module["solve"]()
        print(f"{name}: correctness passed", flush=True)
    gen = torch.Generator().manual_seed(13)
    a_cpu = torch.randn(1024, 1024, generator=gen).to(torch.bfloat16)
    b_cpu = torch.randn(1024, 1024, generator=gen).to(torch.bfloat16)
    a, b = a_cpu.cuda(), b_cpu.cuda()
    out = torch.empty_like(a)
    expected = (a_cpu.float() @ b_cpu.float()).to(torch.bfloat16)
    launches = {
        name: partial(module["run"], a, b, out, 1024, 1024, 1024)
        for name, module in modules.items()
    }
    for launch in launches.values():
        out.fill_(float("nan"))
        for _ in range(10):
            launch()
        torch.cuda.synchronize()
        torch.testing.assert_close(out.cpu(), expected, rtol=0.016, atol=0.03125)

    def batch(launch, method):
        torch.cuda.synchronize()
        if method == "gpu-event":
            start = torch.cuda.Event(enable_timing=True)
            end = torch.cuda.Event(enable_timing=True)
            start.record()
            for _ in range(args.repeats):
                launch()
            end.record()
            end.synchronize()
            return start.elapsed_time(end) / args.repeats
        start = time.perf_counter()
        for _ in range(args.repeats):
            launch()
        torch.cuda.synchronize()
        return (time.perf_counter() - start) * 1000 / args.repeats

    method = "gpu-event" if args.timing == "auto" else args.timing
    fallback = None
    if method == "gpu-event" and any(
        batch(fn, method) <= 0 for fn in launches.values()
    ):
        if args.timing == "gpu-event":
            raise RuntimeError("GPU events returned zero durations; use --timing host")
        method = "host"
        fallback = "GPU events returned zero durations; all variants use host timing"
        print(fallback, flush=True)
    samples = {name: [] for name in launches}
    names = list(launches)
    for round_index in range(args.rounds):
        # Rotate the order to distribute thermal/clock drift across variants.
        order = names[round_index % len(names) :] + names[: round_index % len(names)]
        for name in order:
            samples[name].append(batch(launches[name], method))
    if any(value <= 0 for values in samples.values() for value in values):
        raise RuntimeError("Nonpositive timing sample")
    rows = {
        name: {
            "median_us": statistics.median(values) * 1000,
            "min_us": min(values) * 1000,
            "max_us": max(values) * 1000,
            "samples_us": [value * 1000 for value in values],
            "effective_TFLOP_s": 2 * 1024**3 / (statistics.median(values) * 1e9),
        }
        for name, values in samples.items()
    }
    buffer_us = rows["buffer_load_store"]["median_us"]
    comparisons = {
        name: {
            "buffer_speedup": row["median_us"] / buffer_us,
            "buffer_time_reduction_percent": 100 * (1 - buffer_us / row["median_us"]),
        }
        for name, row in rows.items()
        if name != "buffer_load_store"
    }
    report = {
        "gpu": torch.cuda.get_device_name(),
        "arch": torch.cuda.get_device_properties(0).gcnArchName,
        "torch": torch.__version__,
        "hip": torch.version.hip,
        "flydsl": version("flydsl"),
        "shape_MNK": [1024] * 3,
        "schedule": "prefetch",
        "timing": method,
        "fallback": fallback,
        "scope": "warm shared inputs, preallocated output; rotating order; no profiler instrumentation",
        "timing_note": "host includes Python dispatch and synchronization"
        if method == "host"
        else "GPU event batches include any gaps between host launches",
        "repeats": args.repeats,
        "rounds": args.rounds,
        "source_sha256": {
            name: hashlib.sha256(path.read_bytes()).hexdigest()
            for name, path in paths.items()
        },
        "correctness": checks,
        "timings": rows,
        "comparisons": comparisons,
    }
    (output / "summary.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))
    print(f"Report: {output / 'summary.json'}")


if __name__ == "__main__":
    main()
