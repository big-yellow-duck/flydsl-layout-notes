"""Compare the BF16 teaching kernels with PyTorch; performance is never a test.

Run: pixi run matmul-bench --timing host
Host measurements include Python dispatch and batch synchronization overhead.
"""

import argparse
import json
import runpy
import statistics
import time
from functools import partial
from pathlib import Path

# Import FlyDSL before torch so the compiler's LLVM libraries are loaded first.
import flydsl  # noqa: F401
import torch

ROOT = Path(__file__).resolve().parents[1]
STAGES = (
    "00-naive",
    "01-coalesced-access",
    "02-register-tiling",
    "03-shared-memory",
    "04-matrix-instructions",
)


def measure(launch, timing, repeats):
    for _ in range(3):
        launch()
    torch.cuda.synchronize()
    samples = []
    for _ in range(5):
        if timing == "gpu-event":
            start = torch.cuda.Event(enable_timing=True)
            end = torch.cuda.Event(enable_timing=True)
            start.record()
            for _ in range(repeats):
                launch()
            end.record()
            end.synchronize()
            milliseconds = start.elapsed_time(end) / repeats
        else:
            torch.cuda.synchronize()
            start_time = time.perf_counter()
            for _ in range(repeats):
                launch()
            torch.cuda.synchronize()
            milliseconds = (time.perf_counter() - start_time) * 1000 / repeats
        samples.append(milliseconds)
    median = statistics.median(samples)
    return median if median > 0 else None


def comparison(kernel_map, timing="auto", repeats=20):
    """Validate and time GPU launches on shared inputs and a preallocated output."""
    m = n = k = 1024
    generator = torch.Generator().manual_seed(13)
    a_cpu = torch.randn(m, k, generator=generator).to(torch.bfloat16)
    b_cpu = torch.randn(k, n, generator=generator).to(torch.bfloat16)
    left, right = a_cpu.cuda(), b_cpu.cuda()
    out = torch.empty((m, n), dtype=torch.bfloat16, device="cuda")
    expected = (a_cpu.float() @ b_cpu.float()).to(torch.bfloat16)
    launches = {
        name: partial(kernel, left, right, out, m, n, k)
        for name, kernel in kernel_map.items()
    }
    launches["torch.matmul"] = partial(torch.matmul, left, right, out=out)
    for launch in launches.values():
        out.fill_(float("nan"))
        launch()
        torch.cuda.synchronize()
        torch.testing.assert_close(out.cpu(), expected, rtol=0.016, atol=0.03125)
    method = "gpu-event" if timing == "auto" else timing
    times = {
        name: measure(launch, method, repeats) for name, launch in launches.items()
    }
    fallback = timing == "auto" and any(value is None for value in times.values())
    if fallback:
        # Retime EVERY implementation so a comparison never mixes clock methods.
        method = "host"
        times = {
            name: measure(launch, method, repeats) for name, launch in launches.items()
        }
    metadata = {
        "gpu": torch.cuda.get_device_name(),
        "arch": torch.cuda.get_device_properties(0).gcnArchName,
        "torch": torch.__version__,
        "hip": torch.version.hip,
        "flydsl": "0.4.1 (repository pin)",
        "requested_timing": timing,
        "timing": method,
        "fallback": "GPU event timing unavailable; all implementations retimed with host clock"
        if fallback
        else None,
        "scope": "warm repeated buffers; preallocated output; median of five batches",
        "warmups": 3,
        "repeats": repeats,
        "shape_MNK": [m, n, k],
        "timing_note": "host includes dispatch and synchronization"
        if method == "host"
        else "zero event durations are unavailable, not infinite throughput",
        "baseline": "GPU torch.matmul; underlying BLAS backend not identified",
    }
    rows = [
        {
            "kernel": name,
            "shape_MNK": [m, n, k],
            "ms": milliseconds,
            "effective_TFLOP_s": 2 * m * n * k / (milliseconds * 1e9)
            if milliseconds is not None
            else None,
            "status": "ok"
            if milliseconds is not None
            else "GPU event timing unavailable",
        }
        for name, milliseconds in times.items()
    ]
    return metadata, rows


def arguments():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--timing", choices=("auto", "gpu-event", "host"), default="auto"
    )
    parser.add_argument("--repeats", type=int, default=20)
    parser.add_argument(
        "--check-only", action="store_true", help="run correctness without timing"
    )
    args = parser.parse_args()
    if args.repeats < 1:
        parser.error("repeats must be positive")
    return args


def lesson_main(kernel, solve, name, *, check_only=False):
    """Shared CLI for each matmul solution and completed practice."""
    args = None if check_only else arguments()
    try:
        print("Exercise passed:", solve(), flush=True)
        if check_only or args.check_only:
            return
        metadata, rows = comparison({name: kernel}, args.timing, args.repeats)
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None
    print(
        f"GPU: {metadata['gpu']} | BF16 inputs/output, FP32 accumulation | M=N=K=1024"
    )
    if metadata["fallback"]:
        print(metadata["fallback"])
    print(f"Timing: {metadata['timing']} ({metadata['timing_note']})")
    print(f"Median of five batches, {args.repeats} launches per batch; three warm-ups.")
    print(f"{'GPU implementation':<28} {'ms':>12} {'TFLOP/s':>12}")
    for row in rows:
        ms = f"{row['ms']:.4f}" if row["ms"] is not None else "unavailable"
        tflops = (
            f"{row['effective_TFLOP_s']:.3f}"
            if row["effective_TFLOP_s"] is not None
            else "unavailable"
        )
        print(f"{row['kernel']:<28} {ms:>12} {tflops:>12}")


def main():
    args = arguments()
    architecture = torch.cuda.get_device_properties(0).gcnArchName.split(":")[0]
    if architecture not in ("gfx1151", "gfx1152"):
        raise SystemExit(
            f"this course's WMMA benchmark supports gfx1151/gfx1152; detected {architecture}"
        )
    modules = {
        stage: runpy.run_path(
            str(ROOT / "lessons/01-gpu-programming/13-matmul" / stage / "solution.py")
        )
        for stage in STAGES
    }
    if args.check_only:
        for stage, module in modules.items():
            print(stage, module["solve"]())
        return
    metadata, rows = comparison(
        {stage: module["run"] for stage, module in modules.items()},
        args.timing,
        args.repeats,
    )
    print(json.dumps(metadata))
    for row in rows:
        print(json.dumps(row), flush=True)


if __name__ == "__main__":
    main()
