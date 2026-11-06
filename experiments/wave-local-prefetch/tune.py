"""Measure independent wave tiles with stage 09's matched benchmark protocol."""

import argparse
import gc
import hashlib
import json
import random
import runpy
from dataclasses import asdict, replace
from itertools import product
from pathlib import Path

HERE = Path(__file__).resolve().parent
HELPERS = HERE.parents[1] / "lessons/01-gpu-programming/13-matmul/09-split-k/tune.py"
MODULE = runpy.run_path(str(HERE / "solution.py"))
COMMON = runpy.run_path(str(HELPERS))
CONTEXT = COMMON["compare"].__globals__
CONTEXT.update(
    HERE=HERE,
    MODULE=MODULE,
    Config=MODULE["Config"],
    BUILD=MODULE["build"],
    SHAPE=(16, 4096, 8192),
)


def compare(config, shape, timing="graph-host", launch_factory=None):
    return COMMON["compare"](config, shape, timing, launch_factory)


def sweep(shape, timing, split_k):
    trace, data = COMMON["inputs"](0, True), COMMON["inputs"](13)
    rows, rejected = [], []
    # Keep native module destruction outside graph capture when GC runs.
    for bn, groups, unroll, cache in product(
        (16, 32, 64), (1, 2, 4, 8), (1, 4, 8, 16), (0, 2)
    ):
        config = MODULE["Config"](
            shape[0],
            bn,
            16,
            1,
            1,
            split_k=split_k,
            wave_groups=groups,
            k_unroll=unroll,
            right_cache_modifier=cache,
        )
        try:
            MODULE["validate_config"](config, shape)
            launch = MODULE["launch_for"](config, shape)
            COMMON["validate"](launch, trace, True)
            COMMON["validate"](launch, data)
            gc.collect()
            gc.disable()
            try:
                measured = COMMON["paired_measure"](
                    launch, COMMON["torch_launch"], data, 3, 5, 0, timing
                )
            finally:
                gc.enable()
            rows.append({"config": asdict(config), **measured})
            print("TRAIN", config.name, measured["paired_ratio"], flush=True)
        except (ValueError, RuntimeError, AssertionError) as error:
            rejected.append({"config": asdict(config), "error": str(error)})
    return {
        "kind": "training_search",
        "environment": COMMON["environment"](),
        "training_seed": 13,
        "candidate_count": 96,
        "ranking": sorted(rows, key=lambda row: row["paired_ratio"]),
        "rejected": rejected,
        "search_space": "BM=M, BK=16, one compute wave per group, BN=16/32/64, wave_groups=1/2/4/8, k_unroll=1/4/8/16, B cache=0/2; split_k fixed by CLI",
    }


def ablate(timing):
    """Hold inputs fixed and add the selected changes one at a time."""
    baseline = runpy.run_path(
        str(
            HERE.parents[1]
            / "lessons/01-gpu-programming/13-matmul/09-split-k/solution.py"
        )
    )
    config = MODULE["Config"](16, 32, 16, 1, 1, split_k=1)
    cases = [
        ("09-original", baseline, baseline["CONFIGS_BY_SHAPE"][(16, 4096, 8192)]),
        ("lds-only-fences", MODULE, config),
        ("64-column-wave", MODULE, replace(config, block_n=64)),
        ("two-independent-waves", MODULE, replace(config, block_n=64, wave_groups=2)),
        (
            "streaming-B-hint",
            MODULE,
            replace(config, block_n=64, wave_groups=2, right_cache_modifier=2),
        ),
        ("unroll-four", MODULE, MODULE["CONFIGS_BY_SHAPE"][(16, 4096, 8192)]),
    ]
    trace, data = COMMON["inputs"](0, True), COMMON["inputs"](13)
    launches = {}
    for label, module, case_config in cases:
        launch = module["launch_for"](case_config, (16, 4096, 8192))
        COMMON["validate"](launch, trace, True)
        COMMON["validate"](launch, data)
        launches[label] = launch
    rows = []
    for repetition in range(3):
        order = list(range(len(cases)))
        random.Random(13 + repetition).shuffle(order)
        for index in order:
            label, _, case_config = cases[index]
            gc.collect()
            gc.disable()
            try:
                measured = COMMON["paired_measure"](
                    launches[label],
                    COMMON["torch_launch"],
                    data,
                    5,
                    10,
                    repetition,
                    timing,
                )
            finally:
                gc.enable()
            rows.append(
                {
                    "label": label,
                    "round": repetition,
                    "config": asdict(case_config),
                    **measured,
                }
            )
            print("ABLATE", label, repetition, measured["paired_ratio"], flush=True)
    return {
        "kind": "training_ablation",
        "training_seed": 13,
        "environment": COMMON["environment"](),
        "baseline_source_sha256": hashlib.sha256(
            (
                HERE.parents[1]
                / "lessons/01-gpu-programming/13-matmul/09-split-k/solution.py"
            ).read_bytes()
        ).hexdigest(),
        "rounds": rows,
        "note": "Cumulative changes, shuffled order per round; selection uses training inputs only",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    action = parser.add_mutually_exclusive_group(required=True)
    action.add_argument("--sweep", action="store_true")
    action.add_argument("--verify", action="store_true")
    action.add_argument("--ablate", action="store_true")
    parser.add_argument("--shape", type=int, nargs=3, default=(16, 4096, 8192))
    parser.add_argument("--wave-groups", type=int)
    parser.add_argument("--k-unroll", type=int)
    parser.add_argument("--right-cache-modifier", type=int)
    parser.add_argument("--split-k", type=int, choices=(1, 2, 4))
    parser.add_argument(
        "--timing", choices=("graph-host", "direct-host"), default="graph-host"
    )
    parser.add_argument(
        "--seeds", type=int, nargs="+", default=(2026111201, 2026111202, 2026111203)
    )
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    shape = tuple(args.shape)
    if args.ablate and shape != (16, 4096, 8192):
        parser.error("The ablation fixes the wide skinny workload")
    if shape not in MODULE["SHAPES"]:
        parser.error("Choose a supported skinny shape")
    if args.output.exists():
        parser.error("Use a fresh output path")
    CONTEXT["SHAPE"] = shape
    changes = {
        name: getattr(args, name)
        for name in ("wave_groups", "k_unroll", "right_cache_modifier", "split_k")
        if getattr(args, name) is not None
    }
    config = replace(MODULE["CONFIGS_BY_SHAPE"][shape], **changes)
    MODULE["validate_config"](config, shape)
    report = (
        ablate(args.timing)
        if args.ablate
        else sweep(shape, args.timing, config.split_k)
        if args.sweep
        else COMMON["verify"](config, args.seeds, args.timing)
    )
    report["benchmark_helpers_sha256"] = hashlib.sha256(
        HELPERS.read_bytes()
    ).hexdigest()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2) + "\n")
    print("SAVED", args.output, flush=True)
    if args.verify:
        print("STATUS", report["performance_status"], flush=True)


if __name__ == "__main__":
    main()
