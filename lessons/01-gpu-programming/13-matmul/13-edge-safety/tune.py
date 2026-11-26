"""Validate and compare edge-safe GEMMs with GPU Torch using matched timing.

Run: pixi run python lessons/01-gpu-programming/13-matmul/13-edge-safety/tune.py \
    --shape 17 1032 8200 --output /tmp/edge-timing.json
"""

import argparse
import hashlib
import json
import runpy
from dataclasses import asdict
from functools import partial
from pathlib import Path

HERE = Path(__file__).resolve().parent
MODULE = runpy.run_path(str(HERE / "solution.py"))
COMMON = runpy.run_path(str(HERE.parent / "09-split-k/tune.py"))
CONTEXT = COMMON["inputs"].__globals__


def compare(
    config, shape, timing="graph-host", *, matmul=None, seed=101, batches=7, repeats=10
):
    """Independent CPU reference; alternating paired batches and changed-input replay."""
    shape = tuple(shape)
    MODULE["validate_config"](config, shape)
    CONTEXT["SHAPE"] = shape
    data = COMMON["inputs"](seed)
    kernel = partial(matmul or MODULE["matmul_bf16"], config=config)
    baseline = COMMON["torch_launch"]
    for launch in (kernel, baseline):
        COMMON["validate"](launch, data)
    report = COMMON["paired_measure"](
        kernel, baseline, data, batches, repeats, seed, timing
    )
    m, n, k = shape
    # Use the logical GEMM size for both implementations, including edge tiles.
    flops = 2 * m * n * k
    report["kernel_tflops"] = flops / (report["kernel_ms"] * 1e9)
    report["torch_tflops"] = flops / (report["torch_ms"] * 1e9)
    return {"shape_MNK": shape, "seed": seed, "config": asdict(config), **report}


def print_comparison(report):
    m, n, k = report["shape_MNK"]
    print(
        f"Median GPU matmul (M={m}, N={n}, K={k}, {report['timing']})\n"
        f"  FlyDSL  {report['kernel_ms']:.6f} ms  "
        f"{report['kernel_tflops']:.4g} effective TFLOP/s\n"
        f"  Torch   {report['torch_ms']:.6f} ms  "
        f"{report['torch_tflops']:.4g} effective TFLOP/s",
        flush=True,
    )


def candidates():
    Config = MODULE["Config"]
    # Bounded training search; verification uses fresh seeds with locked configs.
    for bm, bn, bk, wn, groups_n in (
        (16, 32, 16, 1, 1),
        (16, 64, 16, 1, 1),
        (16, 64, 32, 1, 1),
        (16, 64, 32, 2, 1),
        (32, 64, 32, 2, 1),
        (16, 64, 16, 1, 2),
    ):
        for registers in (True, False):
            for split in (1, 4):
                yield Config(
                    group_tile_m=bm,
                    group_tile_n=bn,
                    stage_k=bk,
                    waves_per_group_n=wn,
                    wave_groups_n=groups_n,
                    split_k=split,
                    k_unroll=2,
                    left_in_registers=registers,
                )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, default=(17, 1032, 8200))
    parser.add_argument(
        "--timing", choices=("graph-host", "direct-host"), default="graph-host"
    )
    parser.add_argument("--sweep", action="store_true")
    parser.add_argument("--seeds", type=int, nargs="+", default=(101, 202, 303))
    parser.add_argument("--batches", type=int, default=7)
    parser.add_argument("--repeats", type=int, default=10)
    parser.add_argument("--config", help="Explicit JSON config object")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output path")
    shape = tuple(args.shape)
    config = (
        MODULE["Config"](**json.loads(args.config))
        if args.config
        else MODULE["default_config"](shape)
    )
    training = []
    if args.sweep:
        for candidate in candidates():
            try:
                MODULE["validate_config"](candidate, shape)
            except ValueError:
                continue
            row = compare(candidate, shape, args.timing, seed=13, batches=3, repeats=3)
            training.append(row)
            print(
                json.dumps({"training": candidate.name, "ratio": row["paired_ratio"]}),
                flush=True,
            )
        config = MODULE["Config"](
            **min(training, key=lambda row: row["kernel_ms"])["config"]
        )
    rows = [
        compare(
            config,
            shape,
            args.timing,
            seed=seed,
            batches=args.batches,
            repeats=args.repeats,
        )
        for seed in args.seeds
    ]
    report = {
        "environment": {
            "gpu": COMMON["torch"].cuda.get_device_name(),
            "architecture": COMMON["torch"].cuda.get_device_properties(0).gcnArchName,
            "torch": COMMON["torch"].__version__,
            "hip": COMMON["torch"].version.hip,
            "flydsl": "0.4.1",
            "timing": args.timing,
            "scope": "warm row-major BF16 GPU inputs, preallocated output, cached scratch; synchronized host clock; graph replay includes captured scratch initialization",
            "source_sha256": {
                name: hashlib.sha256((HERE / name).read_bytes()).hexdigest()
                for name in ("solution.py", "tune.py")
            },
        },
        "training": training,
        "locked_config": asdict(config),
        "verification": rows,
        "parity_limit": 1.05,
        "all_rounds_at_or_below_parity": all(
            row["paired_ratio"] <= 1.05 for row in rows
        ),
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2) + "\n")
    for row in rows:
        print(json.dumps(row), flush=True)


if __name__ == "__main__":
    main()
