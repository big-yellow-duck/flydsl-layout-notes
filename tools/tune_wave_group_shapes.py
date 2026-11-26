"""Validate and tune every 1..2 by 1..2 independent-wave arrangement in 10–12."""

import argparse
import hashlib
import json
import runpy
import statistics
from dataclasses import asdict, replace
from pathlib import Path

from matmul_config_archive import config_from_archive

LESSONS = (
    "10-wave-local-tiles",
    "10a-synchronization-scope",
    "10b-cache-policy",
    "10c-k-unrolling",
    "12-operand-paths",
)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--seeds", type=int, nargs="+", default=[13, 29, 47])
    parser.add_argument(
        "--verify-from",
        type=Path,
        help="Verify promoted selections from an earlier sweep on new seeds",
    )
    parser.add_argument("--lessons", nargs="+", choices=LESSONS, default=LESSONS)
    parser.add_argument(
        "--timing", choices=["graph-host", "direct-host"], default="graph-host"
    )
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output directory")
    args.output.mkdir(parents=True)
    course = (
        Path(__file__).resolve().parents[1] / "lessons/01-gpu-programming/13-matmul"
    )
    helper = runpy.run_path(str(course / "10-wave-local-tiles/measure.py"))
    helper["COMMON"]["torch"].set_num_threads(1)
    for name in args.lessons:
        (args.output / f"{name}-source.txt").write_text(
            (course / name / "solution.py").read_text()
        )
        module = runpy.run_path(str(course / name / "solution.py"))
        for shape, original in module["CONFIGS_BY_SHAPE"].items():
            prior = None
            if args.verify_from:
                prior = json.loads(
                    (
                        args.verify_from / f"{name}-{'x'.join(map(str, shape))}.json"
                    ).read_text()
                )
                if prior["selected_configuration"] == prior["configurations"]["stage"]:
                    continue
                original = config_from_archive(
                    module["Config"], prior["configurations"]["stage"]
                )
            configs, excluded = {}, {}
            base = replace(
                original, group_tile_m=16, waves_per_group_m=1, waves_per_group_n=1
            )
            for gm in (1, 2):
                for gn in (1, 2):
                    key = f"groups_{gm}x{gn}"
                    config = replace(base, wave_groups_m=gm, wave_groups_n=gn)
                    try:
                        module["validate_config"](config, shape)
                    except ValueError as error:
                        excluded[key] = str(error)
                    else:
                        configs[key] = config
            if prior:
                configs = {
                    "promoted": config_from_archive(
                        module["Config"], prior["selected_configuration"]
                    )
                }
                excluded = {}
            validations = {
                key: module["solve"](config, shape)
                for key, config in {"stage": original, **configs}.items()
            }
            report = {
                "lesson": name,
                "shape_MNK": shape,
                "scope": "Sweep all four 2D wave-group shapes using a common independent 16-row tile and one wave per tile; retain the existing K chunk, split-K, cache policy and unroll. Include original selected configuration as stage. Invalid physical tile shapes are recorded, never remapped across K splits.",
                "source_sha256": hashlib.sha256(
                    (course / name / "solution.py").read_bytes()
                ).hexdigest(),
                "configurations": {
                    key: asdict(config)
                    for key, config in {"stage": original, **configs}.items()
                },
                "excluded": excluded,
                "validation": validations,
                "runs": [],
            }
            if prior:
                report["scope"] = (
                    "Held-out comparison of promoted configuration versus the previous stage configuration; all other configuration choices are locked."
                )
            compare = helper["compare"]
            compare.__globals__["variants"] = lambda *_, choices=configs: choices
            output = args.output / f"{name}-{'x'.join(map(str, shape))}.json"
            for seed in args.seeds:
                result = compare(
                    module,
                    original,
                    shape,
                    name.split("-", 1)[0],
                    args.timing,
                    seed=seed,
                    batches=7,
                    repeats=10,
                )
                report["runs"].append(result)
                output.write_text(json.dumps(report, indent=2) + "\n")
                print(name, shape, seed, result["median_ms"], flush=True)
            report["median_ms"] = {
                key: statistics.median(row["median_ms"][key] for row in report["runs"])
                for key in report["runs"][0]["median_ms"]
            }
            winner = min(report["configurations"], key=report["median_ms"].__getitem__)
            report["winner"] = winner
            selected = (
                winner
                if report["median_ms"][winner] < report["median_ms"]["stage"] * 0.99
                else "stage"
            )
            report["selection_policy"] = (
                "Retain the original configuration unless a candidate reduces median time by at least 1%; verify promoted selections on held-out seeds."
            )
            report["selected_key"] = selected
            report["selected_configuration"] = report["configurations"][selected]
            output.write_text(json.dumps(report, indent=2) + "\n")


if __name__ == "__main__":
    main()
