"""Compare targeted guards, lesson 13 predicates, and GPU Torch at fixed geometry."""

import argparse
import hashlib
import json
import random
import runpy
import statistics
from dataclasses import asdict, replace
from functools import partial
from importlib.metadata import version
from math import prod
from pathlib import Path

import torch

HERE = Path(__file__).resolve().parent
EDGE_SAFETY = HERE.parent / "13-edge-safety"
TARGETED = runpy.run_path(str(HERE / "solution.py"))
BASELINE = runpy.run_path(str(EDGE_SAFETY / "tune.py"))
PREDICATED = BASELINE["MODULE"]
COMMON = BASELINE["COMMON"]
SHAPES = (
    (16, 1024, 8192),
    (17, 1024, 8192),
    (16, 1032, 8192),
    (16, 1024, 8200),
    (7, 1032, 8200),
    (17, 1032, 8200),
    (31, 1048, 8184),
    (31, 1025, 8193),
)
SQUARE_SHAPES = (
    (512, 512, 512),
    (1024, 1024, 1024),
    (2048, 2048, 2048),
    (1032, 1048, 1016),
    (1025, 1025, 1025),
)
TRAINING_SEED = 13


def measure(launches, data, shape, timing, seed, batches, repeats, graph_gemms=32):
    graphs, metadata = {}, {}
    if timing == "graph-host":
        for name, launch in launches.items():
            graphs[name], metadata[name] = COMMON["capture"](
                launch, data, operations=graph_gemms
            )
        replay = {name: graph.replay for name, graph in graphs.items()}
        operations = {
            name: info["matmuls_per_replay"] for name, info in metadata.items()
        }
    else:
        a, b, storage, _ = data
        out = storage[:-16].view(shape[0], shape[1])
        replay = {
            name: partial(launch, a, b, out=out) for name, launch in launches.items()
        }
        operations = dict.fromkeys(launches, 1)
    for launch in replay.values():
        for _ in range(5):
            launch()
    torch.cuda.synchronize()

    samples = {name: [] for name in launches}
    orders = []
    rng = random.Random(seed)
    for _ in range(batches):
        order = list(launches)
        rng.shuffle(order)
        orders.append(order)
        for name in order:
            samples[name].append(
                COMMON["timed_batch"](replay[name], repeats) / operations[name]
            )
    median_ms = {name: statistics.median(values) for name, values in samples.items()}
    return {
        "shape_MNK": shape,
        "seed": seed,
        "timing": timing,
        "median_ms": median_ms,
        "effective_tflops": {
            name: 2 * prod(shape) / (ms * 1e9) for name, ms in median_ms.items()
        },
        "samples_ms": samples,
        "batch_orders": orders,
        "graph_metadata": metadata,
    }


def compare(
    config, shape, timing="graph-host", *, matmul=None, seed=1919, batches=7, repeats=10
):
    shape = tuple(shape)
    TARGETED["validate_config"](config, shape)
    COMMON["inputs"].__globals__["SHAPE"] = shape
    data = COMMON["inputs"](seed)
    launches = {
        "targeted": partial(matmul or TARGETED["matmul_bf16"], config=config),
        "predicated": partial(
            PREDICATED["matmul_bf16"], config=PREDICATED["Config"](**asdict(config))
        ),
        "torch": COMMON["torch_launch"],
    }
    for launch in launches.values():
        COMMON["validate"](launch, data)
    result = measure(launches, data, shape, timing, seed, batches, repeats)
    samples = result["samples_ms"]
    return {
        "config": asdict(config),
        **result,
        **{
            f"targeted_over_{baseline}": statistics.median(
                a / b
                for a, b in zip(samples["targeted"], samples[baseline], strict=True)
            )
            for baseline in ("predicated", "torch")
        },
    }


def square_candidates():
    Config = TARGETED["Config"]
    # Two winners from the earlier square study serve as seed configurations.
    for bm, bn, bk, wm, wn, b_cache in ((128, 128, 32, 2, 2, 0), (64, 64, 64, 1, 2, 1)):
        yield Config(
            bm,
            bn,
            bk,
            wm,
            wn,
            group_m=4,
            split_k=1,
            k_unroll=2,
            right_cache_modifier=b_cache,
        )
    # Include cooperating waves and independently staged wave groups.
    for bm, bn, wm, wn, gm, gn in (
        (32, 64, 1, 1, 1, 1),
        (32, 64, 1, 1, 2, 2),
        (32, 128, 1, 2, 1, 1),
        (64, 64, 1, 2, 1, 1),
        (64, 64, 2, 2, 1, 1),
        (64, 128, 2, 2, 1, 1),
        (128, 64, 2, 2, 1, 1),
        (128, 128, 2, 2, 1, 1),
        (128, 128, 1, 4, 1, 1),
    ):
        for bk in (32, 64):
            for registers in (True, False):
                yield Config(
                    bm,
                    bn,
                    bk,
                    wm,
                    wn,
                    group_m=4,
                    split_k=1,
                    k_unroll=2,
                    wave_groups_m=gm,
                    wave_groups_n=gn,
                    left_in_registers=registers,
                )


def tune_square(shape):
    """Rank only full-output-validated candidates using the training seed."""
    COMMON["inputs"].__globals__["SHAPE"] = shape
    data = COMMON["inputs"](TRAINING_SEED)
    trials = {}

    def evaluate(config):
        if config in trials:
            return
        try:
            TARGETED["validate_config"](config, shape)
        except ValueError as error:
            trials[config] = {"config": asdict(config), "excluded": str(error)}
            return
        launch = partial(TARGETED["matmul_bf16"], config=config)
        COMMON["validate"](launch, data)
        result = measure(
            {"targeted": launch},
            data,
            shape,
            "graph-host",
            TRAINING_SEED,
            batches=3,
            repeats=5,
            graph_gemms=8,
        )
        trials[config] = {"config": asdict(config), **result}
        print(
            f"Training {shape} {config.name} {result['median_ms']['targeted']:.6f} ms",
            flush=True,
        )

    def ranked():
        return sorted(
            (config for config, row in trials.items() if "median_ms" in row),
            key=lambda config: trials[config]["median_ms"]["targeted"],
        )

    # Keep the search starting point fixed after publishing the tuned defaults.
    baseline = PREDICATED["default_config"](shape)
    evaluate(TARGETED["Config"].from_dict(asdict(baseline)))
    for config in square_candidates():
        evaluate(config)
    for finalist in ranked()[:2]:
        for field, values in (
            ("group_m", (1, 2, 8)),
            ("right_cache_modifier", (0, 1, 2)),
            ("k_unroll", (1, 4)),
            ("split_k", (2, 4)),
        ):
            for value in values:
                evaluate(replace(finalist, **{field: value}))

    winner = ranked()[0]
    print(f"Selected {shape} {winner.name}", flush=True)
    return winner, {
        "shape_MNK": shape,
        "selected_config": asdict(winner),
        "candidates": list(trials.values()),
        "correctness": TARGETED["solve"](winner, shape, seed=TRAINING_SEED),
    }


def print_comparison(report):
    m, n, k = report["shape_MNK"]
    print(f"Median GPU matmul (M={m}, N={n}, K={k}, {report['timing']})", flush=True)
    for name, label in (
        ("targeted", "FlyDSL targeted"),
        ("predicated", "FlyDSL lesson 13"),
        ("torch", "Torch"),
    ):
        ms = report["median_ms"][name]
        tflops = report["effective_tflops"][name]
        print(f"  {label:17} {ms:.6f} ms  {tflops:.4g} effective TFLOP/s", flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, metavar=("M", "N", "K"))
    parser.add_argument("--suite", choices=("edges", "square"), default="edges")
    parser.add_argument(
        "--sweep",
        action="store_true",
        help="Tune each selected shape before verification",
    )
    parser.add_argument(
        "--timing", choices=("graph-host", "direct-host", "both"), default="graph-host"
    )
    parser.add_argument("--seeds", type=int, nargs="+", default=(1919, 2020, 2121))
    parser.add_argument("--batches", type=int, default=7)
    parser.add_argument("--repeats", type=int, default=10)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.batches < 1 or args.repeats < 1:
        parser.error("--batches and --repeats must be positive")
    if args.shape and any(size < 1 for size in args.shape):
        parser.error("--shape requires positive M N K")
    if args.sweep and TRAINING_SEED in args.seeds:
        parser.error("Use verification seeds other than the training seed 13")
    if args.output.exists():
        parser.error("Use a fresh output path")

    torch.set_num_threads(1)
    training, rows = [], []
    shapes = SQUARE_SHAPES if args.suite == "square" else SHAPES
    timings = ("graph-host", "direct-host") if args.timing == "both" else (args.timing,)
    for shape in (tuple(args.shape),) if args.shape else shapes:
        if args.sweep:
            config, search = tune_square(shape)
            training.append(search)
        else:
            config = TARGETED["default_config"](shape)
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
        "environment": {
            "gpu": torch.cuda.get_device_name(),
            "architecture": torch.cuda.get_device_properties(0).gcnArchName,
            "flydsl": version("flydsl"),
            "torch": torch.__version__,
            "hip": torch.version.hip,
        },
        "source_sha256": {
            label: hashlib.sha256(path.read_bytes()).hexdigest()
            for label, path in (
                ("targeted", HERE / "solution.py"),
                ("predicated", EDGE_SAFETY / "solution.py"),
                ("benchmark", Path(__file__)),
            )
        },
        "batches": args.batches,
        "repeats_per_batch": args.repeats,
        "training": training,
        "verification": rows,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("x") as output:
        json.dump(report, output, indent=2)
        output.write("\n")


if __name__ == "__main__":
    main()
