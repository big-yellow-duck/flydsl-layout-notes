"""Tune the contiguous 31×1025×8193 mixed-width GEMM and verify against Torch."""

import argparse
import hashlib
import json
import runpy
import statistics
from dataclasses import asdict, replace
from functools import partial
from importlib.metadata import version
from itertools import product
from pathlib import Path

import torch
from flydsl.compiler.diagnostics import DSLCompileError
from flydsl.compiler.external_llvm import ExternalLLVMError

HERE = Path(__file__).resolve().parent
TUNE = runpy.run_path(str(HERE / "tune.py"))
MODULE = TUNE["MODULE"]
COMMON = TUNE["COMMON"]
MEASURE = TUNE["BENCHMARK"]["measure"]
SHAPE = (31, 1025, 8193)
SEARCH_SEED = 13
FINALIST_SEED = 29
VERIFY_SEEDS = (4141, 4242, 4343, 4444, 4545)
CONFIG = MODULE["Config"]
CONTROL = CONFIG(block_k=32, waves_n=1, split_k=4, k_unroll=2)


def candidates():
    # M/N tile, cooperating waves, and independent wave groups.
    geometries = (
        (16, 32, 1, 1, 1, 1),
        (16, 64, 1, 1, 1, 1),
        (16, 128, 1, 1, 1, 1),
        (32, 32, 1, 1, 1, 1),
        (32, 64, 1, 1, 1, 1),
        (32, 128, 1, 1, 1, 1),
        (16, 64, 1, 2, 1, 1),
        (16, 128, 1, 2, 1, 1),
        (32, 64, 1, 2, 1, 1),
        (32, 128, 1, 2, 1, 1),
        (32, 32, 2, 1, 1, 1),
        (32, 64, 2, 1, 1, 1),
        (32, 128, 2, 2, 1, 1),
        (64, 64, 2, 2, 1, 1),
        (16, 32, 1, 1, 2, 1),
        (16, 64, 1, 1, 2, 1),
        (16, 64, 1, 1, 1, 2),
        (16, 64, 1, 1, 2, 2),
    )
    for (bm, bn, wm, wn, gm, gn), bk, split, registers in product(
        geometries, (16, 32, 64), (1, 2, 4), (True, False)
    ):
        yield replace(
            CONTROL,
            block_m=bm,
            block_n=bn,
            block_k=bk,
            waves_m=wm,
            waves_n=wn,
            wave_groups_m=gm,
            wave_groups_n=gn,
            split_k=split,
            left_in_registers=registers,
        )


def launch(config):
    return partial(MODULE["matmul_bf16"], config=config)


def search():
    data = COMMON["inputs"](SEARCH_SEED)
    original_left = data[0].clone()
    trials = {}

    def evaluate(config, phase):
        if config in trials:
            return
        row = {"config": asdict(config), "phase": phase}
        trials[config] = row
        try:
            MODULE["validate_config"](config, SHAPE)
        except ValueError as error:
            row["excluded"] = str(error)
            return
        candidate = launch(config)
        try:
            COMMON["validate"](candidate, data)
            row.update(
                MEASURE(
                    {"candidate": candidate},
                    data,
                    SHAPE,
                    "graph-host",
                    SEARCH_SEED,
                    batches=3,
                    repeats=5,
                    graph_gemms=8,
                )
            )
        except (AssertionError, DSLCompileError, ExternalLLVMError) as error:
            # Capture may have stopped between negating and restoring A.
            data[0].copy_(original_left)
            row["rejected"] = str(error).strip()[:2000]
            print(f"Rejected {config.name}\n{row['rejected']}", flush=True)
            return
        print(
            f"{phase} {len(trials):3} {config.name} {row['median_ms']['candidate']:.6f} ms",
            flush=True,
        )

    def ranked():
        return sorted(
            (cfg for cfg, row in trials.items() if "median_ms" in row),
            key=lambda cfg: trials[cfg]["median_ms"]["candidate"],
        )

    evaluate(CONTROL, "geometry")
    for config in candidates():
        evaluate(config, "geometry")
    for finalist in ranked()[:8]:
        for field, values in (
            ("group_m", (1, 2)),
            ("k_unroll", (1, 2, 4, 8)),
            ("right_cache_modifier", (0, 1, 2)),
            ("left_cache_modifier", (0, 1, 2)),
        ):
            for value in values:
                evaluate(replace(finalist, **{field: value}), "refinement")
    for finalist in ranked()[:3]:
        for unroll, b_cache in product((1, 2, 4, 8), (0, 1, 2)):
            evaluate(
                replace(finalist, k_unroll=unroll, right_cache_modifier=b_cache),
                "cross-check",
            )
    return list(trials.values()), ranked()[:12]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output path")

    torch.set_num_threads(1)
    COMMON["inputs"].__globals__["SHAPE"] = SHAPE
    trials, finalists = search()
    if not finalists:
        raise RuntimeError("No candidate passed validation and timing")
    rerank = MEASURE(
        {cfg.name: launch(cfg) for cfg in finalists},
        COMMON["inputs"](FINALIST_SEED),
        SHAPE,
        "graph-host",
        FINALIST_SEED,
        batches=7,
        repeats=10,
        graph_gemms=16,
    )
    selected = min(finalists, key=lambda cfg: rerank["median_ms"][cfg.name])
    print(f"Selected {selected.name}", flush=True)
    correctness = MODULE["solve"](selected, SHAPE)
    verification = []
    for seed in VERIFY_SEEDS:
        launches = {
            "tuned": launch(selected),
            "untuned": launch(CONTROL),
            "torch": COMMON["torch_launch"],
        }
        data = COMMON["inputs"](seed)
        for candidate in launches.values():
            COMMON["validate"](candidate, data)
        row = MEASURE(launches, data, SHAPE, "graph-host", seed, batches=9, repeats=10)
        samples = row["samples_ms"]
        row["tuned_over_torch"] = statistics.median(
            local / torch_ms
            for local, torch_ms in zip(samples["tuned"], samples["torch"], strict=True)
        )
        verification.append(row)
        print(
            f"Verify {seed}: {row['median_ms']} (tuned/Torch {row['tuned_over_torch']:.4f})",
            flush=True,
        )

    report = {
        "shape_MNK": SHAPE,
        "gpu": torch.cuda.get_device_name(),
        "architecture": torch.cuda.get_device_properties(0).gcnArchName,
        "flydsl": version("flydsl"),
        "torch": torch.__version__,
        "hip": torch.version.hip,
        "source_sha256": {
            path.name: hashlib.sha256(path.read_bytes()).hexdigest()
            for path in (HERE / "solution.py", Path(__file__))
        },
        "untuned_config": asdict(CONTROL),
        "selected_config": asdict(selected),
        "trials": trials,
        "finalist_ranking": rerank,
        "correctness": correctness,
        "verification": verification,
        "wins_every_verification_round": all(
            row["tuned_over_torch"] < 1 for row in verification
        ),
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("x") as output:
        json.dump(report, output, indent=2)
        output.write("\n")


if __name__ == "__main__":
    main()
