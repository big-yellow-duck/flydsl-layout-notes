"""Confirm training finalists and lock four-wave choices before verification."""

import argparse
import json
import random
import runpy
import statistics
from dataclasses import asdict, replace
from pathlib import Path

HERE = Path(__file__).resolve().parent


def confirm_rounds(bench, native, configs, shape, data, report, label, references):
    key = "x".join(map(str, shape))
    results = {config: [] for config in configs}
    checks = {config: native["solve"](config, shape) for config in configs}
    for repetition in range(3):
        order = sorted(configs, key=lambda config: config.name)
        random.Random(13 + repetition).shuffle(order)
        for index, config in enumerate(order):
            result = bench["measure"](
                config, shape, data, references, 7, 10, repetition * 100 + index
            )
            results[config].append({"round": repetition, **result})
            print(
                "CONFIRM",
                key,
                label,
                repetition,
                config.name,
                round(result["ratio_to_prefetch"], 4),
                flush=True,
            )
    for config, samples in results.items():
        names = ("prefetch", "tuned_bulk") if label == "four_wave" else ("prefetch",)
        report[label].append(
            {
                "config": asdict(config),
                "correctness": checks[config],
                "rounds": samples,
                "worst_training_ratio": max(
                    sample["ratio_to_" + name] for sample in samples for name in names
                ),
                "median_training_ratio": statistics.median(
                    sample["ratio_to_prefetch"] for sample in samples
                ),
            }
        )
    report[label].sort(
        key=lambda row: (
            row["worst_training_ratio"],
            row["median_training_ratio"],
        )
    )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--search", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output directory")
    args.output.mkdir(parents=True)
    bench = runpy.run_path(str(HERE / "benchmark.py"))
    state = bench["measure"].__globals__
    native, common = bench["NATIVE"], bench["COMMON"]
    config_type = native["Config"]
    selections = {
        "training_seed": 13,
        "criterion": "minimize worst training-round ratio to both independently tuned controls",
        "shapes": {},
    }

    def bulk(config):
        return replace(
            config,
            schedule="bulk",
            compiler_fence=False,
            issue_group=1,
            global_issue="front",
        )

    for shape in native["SHAPES"]:
        key = "x".join(map(str, shape))
        bench["configure"](shape)
        rows = []
        for phase in ("coarse", "refine", "front"):
            rows += json.loads((args.search / f"{phase}-{key}.json").read_text())[
                "ranking"
            ]
        ordered = sorted(rows, key=lambda row: row["ratio_to_prefetch"])
        four = [row for row in ordered if config_type(**row["config"]).threads == 128]
        finalists = {config_type(**row["config"]) for row in four[:3]}
        # Explicitly retain the best candidate from each global-issue mode.
        for mode in ("front", "spread"):
            candidate = next(
                (
                    config_type(**row["config"])
                    for row in four
                    if row["config"].get("global_issue", "spread") == mode
                ),
                None,
            )
            if candidate is not None:
                finalists.add(candidate)
        by_bulk = sorted(
            rows,
            key=lambda row: statistics.median(
                a / b
                for a, b in zip(
                    row["samples_ms"]["bulk"],
                    row["samples_ms"]["prefetch"],
                    strict=True,
                )
            ),
        )
        bulk_finalists = []
        for row in by_bulk:
            candidate = bulk(config_type(**row["config"]))
            if candidate not in bulk_finalists:
                bulk_finalists.append(candidate)
            if len(bulk_finalists) == 3:
                break
        original_control = bulk(
            config_type(**bench["SELECTION"]["prefetch_control"][key]["config"])
        )
        if original_control not in bulk_finalists:
            bulk_finalists.append(original_control)
        data = common["inputs"](13)
        report = {"shape_MNK": shape, "training_seed": 13, "bulk": [], "four_wave": []}

        state["TUNED_BULK"] = None
        confirm_rounds(
            bench,
            native,
            bulk_finalists,
            shape,
            data,
            report,
            "bulk",
            bench["controls"](shape),
        )
        state["TUNED_BULK"] = config_type(**report["bulk"][0]["config"])
        confirm_rounds(
            bench,
            native,
            finalists,
            shape,
            data,
            report,
            "four_wave",
            bench["controls"](shape),
        )
        report["environment"] = bench["environment"](shape)
        (args.output / f"{key}.json").write_text(json.dumps(report, indent=2) + "\n")
        selections["shapes"][key] = {
            "config": report["four_wave"][0]["config"],
            "bulk_control": report["bulk"][0]["config"],
            "worst_training_ratio": report["four_wave"][0]["worst_training_ratio"],
        }
        (args.output / "selection.json").write_text(
            json.dumps(selections, indent=2) + "\n"
        )
        print("SELECTED", key, selections["shapes"][key], flush=True)


if __name__ == "__main__":
    main()
