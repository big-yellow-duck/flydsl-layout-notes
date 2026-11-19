"""Compare lesson 13 with a copy path that relies entirely on buffer bounds."""

import argparse
import hashlib
import json
import random
import runpy
import statistics
import tempfile
from dataclasses import asdict, replace
from functools import partial
from importlib.metadata import version
from math import prod
from pathlib import Path

import torch

LESSON = Path(__file__).resolve().parents[1]
SOLUTION = LESSON / "solution.py"
SHAPES = (
    (16, 1024, 8192),  # Complete tiles
    (17, 1024, 8192),  # M tail only
    (16, 1032, 8192),  # N tail only
    (16, 1024, 8200),  # K tail only
    (16, 64, 24),  # K tail and empty splits
    (17, 65, 33),
    (7, 1032, 8200),
    (17, 1032, 8200),
    (31, 1048, 8184),
)


def descriptor_only_source(source):
    """Apply the ablation to the live lesson while keeping its bounded resources."""
    loads = (
        "        fx.copy(gmem_left_load, left_global_source, left_global_destination)\n"
        "        fx.copy(gmem_right_load, right_global_source, right_global_destination)\n\n"
    )
    edits = (
        ("def _predicated_copy(", "def _create_staging_views(", ""),
        (
            "    # Index-only views carry",
            "    # A vector must fit",
            "",
        ),
        ("        left_coordinate_block = ", "    def publish_stage():", loads),
        (
            "        coordinate_block = fx.slice(",
            "    if SPLIT_K == 1:",
            "        fx.copy(gmem_store_16b, reg2gmem_source, reg2gmem_dest)\n\n",
        ),
    )
    for start, end, replacement in edits:
        first = source.index(start)
        last = source.index(end, first + len(start))
        source = source[:first] + replacement + source[last:]
    assert source.count("max_size=False") == 3
    assert "_predicated_copy" not in source
    return source


def measure(common, data, launches, seed, batches, repeats):
    graphs, metadata = {}, {}
    for name, launch in launches.items():
        graphs[name], metadata[name] = common["capture"](launch, data)
        for _ in range(5):
            graphs[name].replay()
    samples = {name: [] for name in graphs}
    orders = []
    rng = random.Random(seed)
    for _ in range(batches):
        order = list(graphs)
        rng.shuffle(order)
        orders.append(order)
        for name in order:
            replay_ms = common["timed_batch"](graphs[name].replay, repeats)
            samples[name].append(replay_ms / metadata[name]["matmuls_per_replay"])
    return {
        "seed": seed,
        "samples_ms": samples,
        "batch_orders": orders,
        "graph_metadata": metadata,
    }


def compare(shape, native, descriptor_only, common, seeds, batches, repeats):
    config = native["default_config"](shape)
    if shape == (16, 64, 24):
        config = replace(config, split_k=4)
    native["solve"](config, shape)
    launches = {
        "predicated": partial(native["matmul_bf16"], config=config),
        "torch": common["torch_launch"],
    }
    descriptor_config = descriptor_only["Config"](**asdict(config))
    try:
        descriptor_only["solve"](descriptor_config, shape)
    except AssertionError as error:
        correctness = {"passed": False, "detail": str(error).strip()}
    else:
        correctness = {"passed": True}
        launches["descriptor_only"] = partial(
            descriptor_only["matmul_bf16"], config=descriptor_config
        )

    common["inputs"].__globals__["SHAPE"] = shape
    rounds = []
    for seed in seeds:
        data = common["inputs"](seed)
        for launch in launches.values():
            common["validate"](launch, data)
        rounds.append(measure(common, data, launches, seed, batches, repeats))

    median_ms = {
        name: statistics.median(
            statistics.median(row["samples_ms"][name]) for row in rounds
        )
        for name in launches
    }
    return {
        "shape_MNK": shape,
        "config": asdict(config),
        "descriptor_only_correctness": correctness,
        "median_ms": median_ms,
        "effective_tflops": {
            name: 2 * prod(shape) / (ms * 1e9) for name, ms in median_ms.items()
        },
        "rounds": rounds,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, metavar=("M", "N", "K"))
    parser.add_argument("--seeds", type=int, nargs="+", default=(1616, 1717, 1818))
    parser.add_argument("--batches", type=int, default=9)
    parser.add_argument("--repeats", type=int, default=10)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.batches < 1 or args.repeats < 1:
        parser.error("--batches and --repeats must be positive")
    if args.output.exists():
        parser.error("Use a fresh output path")

    torch.set_num_threads(1)
    tune = runpy.run_path(str(LESSON / "tune.py"))
    source = SOLUTION.read_text()
    ablation = descriptor_only_source(source)
    with tempfile.TemporaryDirectory(prefix="flydsl-descriptor-only-") as root:
        path = Path(root) / "descriptor_only.py"
        path.write_text(ablation)
        variant = runpy.run_path(str(path))
        rows = []
        for shape in (tuple(args.shape),) if args.shape else SHAPES:
            row = compare(
                shape,
                tune["MODULE"],
                variant,
                tune["COMMON"],
                args.seeds,
                args.batches,
                args.repeats,
            )
            rows.append(row)
            passed = row["descriptor_only_correctness"]["passed"]
            print(
                f"M,N,K={shape}  descriptor-only correctness {'passed' if passed else 'failed'}",
                flush=True,
            )
            for name, ms in row["median_ms"].items():
                tflops = row["effective_tflops"][name]
                print(
                    f"  {name:16} {ms:.6f} ms  {tflops:.4g} effective TFLOP/s",
                    flush=True,
                )
    report = {
        "environment": {
            "gpu": torch.cuda.get_device_name(),
            "architecture": torch.cuda.get_device_properties(0).gcnArchName,
            "flydsl": version("flydsl"),
            "torch": torch.__version__,
            "hip": torch.version.hip,
        },
        "solution_sha256": hashlib.sha256(source.encode()).hexdigest(),
        "descriptor_only_sha256": hashlib.sha256(ablation.encode()).hexdigest(),
        "timing": "graph-host median per GEMM, including captured workspace initialization",
        "batches": args.batches,
        "repeats_per_batch": args.repeats,
        "rows": rows,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("x") as output:
        json.dump(report, output, indent=2)
        output.write("\n")


if __name__ == "__main__":
    main()
