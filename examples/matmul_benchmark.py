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


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--timing", choices=("gpu-event", "host"), default="gpu-event")
    parser.add_argument("--repeats", type=int, default=20)
    args = parser.parse_args()
    shapes = [(1024, 1024, 1024)]
    if args.repeats < 1:
        parser.error("repeats must be positive")
    architecture = torch.cuda.get_device_properties(0).gcnArchName.split(":")[0]
    if architecture not in ("gfx1151", "gfx1152"):
        parser.error(
            f"this course's WMMA benchmark supports gfx1151/gfx1152; detected {architecture}"
        )
    kernels = {
        stage: runpy.run_path(
            str(ROOT / "lessons/01-gpu-programming/13-matmul" / stage / "solution.py")
        )["run"]
        for stage in STAGES
    }
    print(
        json.dumps(
            {
                "gpu": torch.cuda.get_device_name(),
                "arch": architecture,
                "torch": torch.__version__,
                "hip": torch.version.hip,
                "flydsl": "0.4.1 (repository pin)",
                "timing": args.timing,
                "scope": "warm repeated buffers; preallocated output; median of five batches",
                "timing_note": "host includes dispatch and synchronization"
                if args.timing == "host"
                else "zero event durations are unavailable, not infinite throughput",
                "baseline": "torch.matmul; underlying BLAS backend not identified; not a hipBLAS win claim",
            }
        )
    )
    generator = torch.Generator().manual_seed(13)
    for m, n, k in shapes:
        a_cpu = torch.randn(m, k, generator=generator).to(torch.bfloat16)
        b_cpu = torch.randn(k, n, generator=generator).to(torch.bfloat16)
        left, right = a_cpu.cuda(), b_cpu.cuda()
        out = torch.empty((m, n), dtype=torch.bfloat16, device="cuda")
        expected = (a_cpu.float() @ b_cpu.float()).to(torch.bfloat16)
        launches = {
            stage: partial(kernel, left, right, out, m, n, k)
            for stage, kernel in kernels.items()
        }
        launches["torch.matmul (backend unverified)"] = partial(
            torch.matmul, left, right, out=out
        )
        for name, launch in launches.items():
            out.fill_(float("nan"))
            launch()
            torch.cuda.synchronize()
            torch.testing.assert_close(out.cpu(), expected, rtol=0.016, atol=0.03125)
            milliseconds = measure(launch, args.timing, args.repeats)
            print(
                json.dumps(
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
                ),
                flush=True,
            )


if __name__ == "__main__":
    main()
