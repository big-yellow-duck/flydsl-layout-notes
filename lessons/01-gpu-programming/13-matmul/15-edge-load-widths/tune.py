"""Compare wide-and-narrow loads, lesson 14 single widths, and GPU Torch."""

import argparse
import hashlib
import json
import runpy
import statistics
from dataclasses import asdict
from functools import partial
from pathlib import Path

import torch

HERE = Path(__file__).resolve().parent
TARGETED = HERE.parent / "14-targeted-guards"
MODULE = runpy.run_path(str(HERE / "solution.py"))
BENCHMARK = runpy.run_path(str(TARGETED / "tune.py"))
SINGLE_WIDTH = BENCHMARK["TARGETED"]
COMMON = BENCHMARK["COMMON"]
SHAPES = (
    (1024, 1024, 1024),
    (1032, 1048, 1016),
    (17, 1024, 8214),
    (17, 1046, 8192),
    (17, 1046, 8214),
    (1030, 1046, 1022),
    (1025, 1025, 1025),
    (31, 1025, 8193),
)


def compare(
    config, shape, timing="graph-host", *, matmul=None, seed=3111, batches=7, repeats=10
):
    shape = tuple(shape)
    MODULE["validate_config"](config, shape)
    COMMON["inputs"].__globals__["SHAPE"] = shape
    data = COMMON["inputs"](seed)
    launches = {
        "mixed_width": partial(matmul or MODULE["matmul_bf16"], config=config),
        "single_width": partial(
            SINGLE_WIDTH["matmul_bf16"], config=SINGLE_WIDTH["Config"](**asdict(config))
        ),
        "torch": COMMON["torch_launch"],
    }
    for launch in launches.values():
        COMMON["validate"](launch, data)
    report = BENCHMARK["measure"](launches, data, shape, timing, seed, batches, repeats)
    samples = report["samples_ms"]
    return {
        "config": asdict(config),
        **report,
        **{
            f"mixed_over_{name}": statistics.median(
                mixed / baseline
                for mixed, baseline in zip(
                    samples["mixed_width"], samples[name], strict=True
                )
            )
            for name in ("single_width", "torch")
        },
    }


def print_comparison(report):
    m, n, k = report["shape_MNK"]
    print(f"Median GPU matmul (M={m}, N={n}, K={k}, {report['timing']})", flush=True)
    for name, label in (
        ("mixed_width", "FlyDSL mixed-width"),
        ("single_width", "FlyDSL lesson 14"),
        ("torch", "Torch"),
    ):
        ms = report["median_ms"][name]
        tflops = report["effective_tflops"][name]
        print(f"  {label:19} {ms:.6f} ms  {tflops:.4g} effective TFLOP/s", flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, metavar=("M", "N", "K"))
    parser.add_argument(
        "--timing", choices=("graph-host", "direct-host", "both"), default="graph-host"
    )
    parser.add_argument("--seeds", type=int, nargs="+", default=(3111, 3222, 3333))
    parser.add_argument("--batches", type=int, default=7)
    parser.add_argument("--repeats", type=int, default=10)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.batches < 1 or args.repeats < 1:
        parser.error("--batches and --repeats must be positive")
    if args.output.exists():
        parser.error("Use a fresh output path")

    torch.set_num_threads(1)
    timings = ("graph-host", "direct-host") if args.timing == "both" else (args.timing,)
    rows = []
    for shape in (tuple(args.shape),) if args.shape else SHAPES:
        config = MODULE["default_config"](shape)
        for seed in args.seeds:
            for timing in timings:
                row = compare(
                    config,
                    shape,
                    timing,
                    seed=seed,
                    batches=args.batches,
                    repeats=args.repeats,
                )
                rows.append(row)
                print_comparison(row)
    report = {
        "gpu": torch.cuda.get_device_name(),
        "architecture": torch.cuda.get_device_properties(0).gcnArchName,
        "torch": torch.__version__,
        "hip": torch.version.hip,
        "source_sha256": {
            label: hashlib.sha256(path.read_bytes()).hexdigest()
            for label, path in (
                ("mixed_width", HERE / "solution.py"),
                ("single_width", TARGETED / "solution.py"),
                ("timing_harness", TARGETED / "tune.py"),
                ("benchmark", Path(__file__)),
            )
        },
        "batches": args.batches,
        "repeats_per_batch": args.repeats,
        "verification": rows,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("x") as output:
        json.dump(report, output, indent=2)
        output.write("\n")


if __name__ == "__main__":
    main()
