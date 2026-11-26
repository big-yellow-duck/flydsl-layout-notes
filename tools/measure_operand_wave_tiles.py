"""Controlled lesson-12 wave ownership comparison using its existing checker/timer."""

import argparse
import hashlib
import json
import runpy
from dataclasses import asdict, replace
from functools import partial
from pathlib import Path

from matmul_config_archive import config_from_archive


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--seeds", type=int, nargs="+", default=[13, 29, 47])
    parser.add_argument("--include-torch", action="store_true")
    parser.add_argument(
        "--configurations",
        type=Path,
        help="JSON mapping MxNxK to explicit configs; defaults to lesson selectors",
    )
    parser.add_argument("--selected-only", action="store_true")
    parser.add_argument(
        "--timing", choices=["graph-host", "direct-host"], default="graph-host"
    )
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output path")
    lesson = (
        Path(__file__).resolve().parents[1]
        / "lessons/01-gpu-programming/13-matmul/12-operand-paths"
    )
    tune = runpy.run_path(str(lesson / "tune.py"))
    module, common = tune["MODULE"], tune["COMMON"]
    common["torch"].set_num_threads(1)
    report = {
        "environment": common["environment"](),
        "solution_sha256": hashlib.sha256(
            (lesson / "solution.py").read_bytes()
        ).hexdigest(),
        "scope": "Locked lesson-12 tiles, split-K, operand route, cache and unroll; vary wave ownership only. Packing also changes barrier scope in the current kernel.",
        "runs": [],
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    selections = module["CONFIGS_BY_SHAPE"]
    if args.configurations:
        selections = {
            tuple(map(int, shape.split("x"))): config_from_archive(
                module["Config"], config
            )
            for shape, config in json.loads(args.configurations.read_text()).items()
        }
    for shape, selected in selections.items():
        tune["configure"](shape)
        configs = {
            "operand_paths": selected,
            "single_wave": replace(
                selected,
                waves_per_group_m=1,
                waves_per_group_n=1,
                wave_groups_m=1,
                wave_groups_n=1,
            ),
            "packed_waves": replace(
                selected,
                waves_per_group_m=1,
                waves_per_group_n=1,
                wave_groups_m=1,
                wave_groups_n=2,
            ),
            "packed_rows": replace(
                selected,
                waves_per_group_m=1,
                waves_per_group_n=1,
                wave_groups_m=2,
                wave_groups_n=1,
            ),
            "packed_grid": replace(
                selected,
                waves_per_group_m=1,
                waves_per_group_n=1,
                wave_groups_m=2,
                wave_groups_n=2,
            ),
            "cooperating_waves": replace(
                selected,
                waves_per_group_m=1,
                waves_per_group_n=2,
                wave_groups_m=1,
                wave_groups_n=1,
            ),
        }
        if args.selected_only:
            configs = {"operand_paths": selected}
        excluded = {}
        for name, config in list(configs.items()):
            try:
                module["validate_config"](config, shape)
            except ValueError as error:
                excluded[name] = str(error)
                del configs[name]
        for config in set(configs.values()):
            module["solve"](config, shape)
        launches = {
            name: partial(module["matmul_bf16"], config=config)
            for name, config in configs.items()
        }
        if args.include_torch:
            launches["torch"] = common["torch_launch"]
        for seed in args.seeds:
            data = common["inputs"](seed)
            for launch in launches.values():
                common["validate"](launch, data)
            measured = tune["measure"](
                launches,
                data,
                batches=7,
                repeats=20,
                order_seed=seed,
                timing=args.timing,
            )
            row = {
                "shape_MNK": shape,
                "seed": seed,
                "excluded_configurations": excluded,
                "configurations": {name: asdict(c) for name, c in configs.items()},
                **measured,
            }
            report["runs"].append(row)
            args.output.write_text(json.dumps(report, indent=2) + "\n")
            print(
                json.dumps({"shape": shape, "seed": seed, **measured["median_ms"]}),
                flush=True,
            )


if __name__ == "__main__":
    main()
