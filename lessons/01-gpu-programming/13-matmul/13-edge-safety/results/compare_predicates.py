"""Compare always-predicated copies with a uniform full-tile fast path."""

import argparse
import hashlib
import json
import random
import runpy
import statistics
import tempfile
from dataclasses import asdict, replace
from functools import partial
from itertools import product
from pathlib import Path

HERE = Path(__file__).resolve().parents[1]
STUDY_SOURCE = Path(__file__).with_name("predicate-study-source.py.txt")
TUNE = runpy.run_path(str(HERE / "tune.py"))
MODULE = runpy.run_path(str(STUDY_SOURCE))
COMMON = TUNE["COMMON"]
CONTEXT = COMMON["inputs"].__globals__
SHAPES = (
    (16, 1024, 8192),
    (7, 1032, 8200),
    (17, 1032, 8200),
    (31, 1048, 8184),
    (65, 1032, 8200),
    (31, 1025, 8193),
)


def compare(shape, seed, batches=9, repeats=10, buffer_copy_bits=128):
    CONTEXT["SHAPE"] = shape
    data = COMMON["inputs"](seed)
    config = replace(MODULE["default_config"](shape), buffer_copy_bits=buffer_copy_bits)
    launches = {
        "always": partial(
            MODULE["matmul_bf16"], config=replace(config, predicate_edges_only=False)
        ),
        "edge_only": partial(
            MODULE["matmul_bf16"], config=replace(config, predicate_edges_only=True)
        ),
        "torch": COMMON["torch_launch"],
    }
    graphs, metadata = {}, {}
    for name, launch in launches.items():
        COMMON["validate"](launch, data)
        graphs[name], metadata[name] = COMMON["capture"](launch, data)
    for graph in graphs.values():
        for _ in range(5):
            graph.replay()
    samples = {name: [] for name in launches}
    orders = []
    generator = random.Random(seed)
    for _ in range(batches):
        order = list(launches)
        generator.shuffle(order)
        orders.append(order)
        for name in order:
            samples[name].append(
                COMMON["timed_batch"](graphs[name].replay, repeats) / 32
            )
    pairs = {
        name: [a / b for a, b in zip(samples[num], samples[den], strict=True)]
        for name, num, den in (
            ("edge_over_always", "edge_only", "always"),
            ("always_over_torch", "always", "torch"),
            ("edge_over_torch", "edge_only", "torch"),
        )
    }
    return {
        "shape_MNK": shape,
        "seed": seed,
        "config": asdict(config),
        "median_ms": {
            name: statistics.median(values) for name, values in samples.items()
        },
        "median_ratios": {
            name: statistics.median(values) for name, values in pairs.items()
        },
        "paired_ratios": pairs,
        "samples_ms": samples,
        "orders": orders,
        "batches": batches,
        "repeats": repeats,
        "graph_metadata": metadata,
    }


def main():
    global MODULE

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3)
    parser.add_argument(
        "--combined-bounds",
        action="store_true",
        help="Use one full_m & full_n & full_k guard for both operand loads",
    )
    parser.add_argument(
        "--buffer-copy-bits",
        type=int,
        nargs="+",
        choices=(16, 32, 64, 128),
        default=(128,),
    )
    parser.add_argument("--seeds", type=int, nargs="+", default=(707, 808, 909))
    parser.add_argument("--batches", type=int, default=9)
    parser.add_argument("--repeats", type=int, default=10)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output path")
    native_source = STUDY_SOURCE.read_text()
    with tempfile.TemporaryDirectory(prefix="edge-predicate-comparison-") as temporary:
        if args.combined_bounds:
            native_source = (
                native_source.replace(
                    "full_m & (tile_k * STAGE_K + STAGE_K <= k)",
                    "full_m & full_n & (tile_k * STAGE_K + STAGE_K <= k)",
                )
                .replace(
                    "full_n & (tile_k * STAGE_K + STAGE_K <= k)",
                    "full_m & full_n & (tile_k * STAGE_K + STAGE_K <= k)",
                )
                .replace("full_m & full_m & full_n", "full_m & full_n")
            )
            variant = Path(temporary) / "solution.py"
            variant.write_text(native_source)
            MODULE = runpy.run_path(str(variant))
        rows = []
        for shape in (tuple(args.shape),) if args.shape else SHAPES:
            for bits, seed in product(args.buffer_copy_bits, args.seeds):
                row = compare(shape, seed, args.batches, args.repeats, bits)
                rows.append(row)
                print(
                    json.dumps(
                        {
                            "shape_MNK": shape,
                            "seed": seed,
                            "buffer_copy_bits": bits,
                            **row["median_ratios"],
                        }
                    ),
                    flush=True,
                )
        report = {
            "combined_bounds": args.combined_bounds,
            "timing": "graph-host",
            "matmuls_per_replay": 32,
            "scope": "warm BF16 GPU inputs, preallocated output, same geometry; shuffled paired measurements; captured scratch initialization included",
            "gpu": COMMON["torch"].cuda.get_device_name(),
            "architecture": COMMON["torch"].cuda.get_device_properties(0).gcnArchName,
            "source_sha256": {
                name: hashlib.sha256(
                    (
                        Path(__file__)
                        if name == "compare_predicates.py"
                        else HERE / name
                    ).read_bytes()
                ).hexdigest()
                for name in ("solution.py", "tune.py", "compare_predicates.py")
            },
            "rounds": rows,
        }
        report["source_sha256"]["solution.py"] = hashlib.sha256(
            native_source.encode()
        ).hexdigest()
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(json.dumps(report, indent=2) + "\n")

        args.output.with_suffix(".source.py.txt").write_text(native_source)


if __name__ == "__main__":
    main()
