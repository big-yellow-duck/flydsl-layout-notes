"""Tune the existing lesson-12 kernel on square BF16 GEMMs, then verify vs Torch."""

import argparse
import hashlib
import json
import runpy
from dataclasses import asdict, replace
from functools import partial
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument(
        "--small-m", action="store_true", help="Tune M=1,2,4,8 with N=K=1024,2048"
    )
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output directory")
    args.output.mkdir(parents=True)
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
        "shapes": {},
    }

    def save():
        (args.output / "report.json").write_text(json.dumps(report, indent=2) + "\n")
        selections = {
            "x".join(map(str, row["shape_MNK"])): row["selected_config"]
            for row in report["shapes"].values()
            if "selected_config" in row
        }
        (args.output / "configurations.json").write_text(
            json.dumps(selections, indent=2) + "\n"
        )

    shapes = (
        [(m, size, size) for size in (1024, 2048) for m in (1, 2, 4, 8)]
        if args.small_m
        else [(size, size, size) for size in (1024, 2048)]
    )
    for shape in shapes:
        size = "x".join(map(str, shape))
        tune["configure"](shape)
        data = common["inputs"](13)
        rows, seen = [], set()
        report["shapes"][str(size)] = {"shape_MNK": shape, "candidates": rows}

        def evaluate(config, seen=seen, shape=shape, rows=rows, data=data, size=size):
            if config in seen:
                return
            seen.add(config)
            row = {"config": asdict(config)}
            try:
                module["validate_config"](config, shape)
            except ValueError as error:
                row["excluded"] = str(error)
                rows.append(row)
                return
            # Compile and check the entire product before timing this candidate.
            launch = partial(module["matmul_bf16"], config=config)
            common["validate"](launch, data)
            measured = tune["measure"](
                {"operand_paths": launch},
                data,
                batches=3,
                repeats=3,
                order_seed=13,
            )
            row.update(measured)
            rows.append(row)
            save()
            print(size, len(rows), config.name, measured["median_ms"], flush=True)

        # Cover cooperation, independent waves, tile reuse and both A routes.
        arrangements = (
            (
                (16, 32, 1, 1, 1),
                (16, 64, 1, 1, 2),
                (16, 64, 1, 2, 1),
                (16, 128, 1, 2, 1),
            )
            if args.small_m
            else (
                (32, 64, 1, 1, 1),
                (32, 64, 1, 1, 2),
                (32, 64, 1, 2, 1),
                (64, 64, 2, 2, 1),
                (64, 128, 2, 2, 1),
                (128, 64, 2, 2, 1),
                (128, 128, 2, 2, 1),
                (64, 64, 1, 2, 1),
            )
        )
        for bm, bn, wm, wn, _ in arrangements:
            for gm, gn in (
                ((1, 1), (1, 2), (2, 1), (2, 2)) if wm * wn == 1 else ((1, 1),)
            ):
                for bk in (32, 64):
                    choices = (
                        ((True, 1), (True, 4))
                        if args.small_m
                        else ((True, 1), (False, 1))
                    )
                    for registers, split in choices:
                        evaluate(
                            module["Config"](
                                group_tile_m=bm,
                                group_tile_n=bn,
                                stage_k=bk,
                                waves_per_group_m=wm,
                                waves_per_group_n=wn,
                                wave_groups_m=gm,
                                wave_groups_n=gn,
                                traversal_group_m=1 if args.small_m else 4,
                                split_k=split,
                                k_unroll=2,
                                left_in_registers=registers,
                            )
                        )
        best = sorted(
            (r for r in rows if "median_ms" in r),
            key=lambda r: r["median_ms"]["operand_paths"],
        )[:2]
        for row in best:
            base = module["Config"](**row["config"])
            for unroll in (1, 4, 8):
                evaluate(replace(base, k_unroll=unroll))
            for traversal_group_m in () if args.small_m else (1, 8):
                evaluate(replace(base, traversal_group_m=traversal_group_m))
            for policy in (0, 1):
                evaluate(replace(base, right_cache_modifier=policy))
            for split in (2, 4):
                evaluate(replace(base, split_k=split))
            if args.small_m:
                evaluate(replace(base, left_in_registers=False))
                evaluate(replace(base, stage_k=16))
        winner = min(
            (r for r in rows if "median_ms" in r),
            key=lambda r: r["median_ms"]["operand_paths"],
        )
        config = module["Config"](**winner["config"])
        result = report["shapes"][str(size)]
        result["selected_config"] = asdict(config)
        result["correctness"] = module["solve"](config, shape)
        launches = {
            "operand_paths": partial(module["matmul_bf16"], config=config),
            "torch": common["torch_launch"],
        }
        result["verification"] = []
        # Lock selection before measuring fresh inputs and shuffled orders.
        for seed in (29, 47, 71):
            fresh = common["inputs"](seed)
            for launch in launches.values():
                common["validate"](launch, fresh)
            for timing in ("graph-host", "direct-host"):
                measured = tune["measure"](
                    launches,
                    fresh,
                    batches=7,
                    repeats=10,
                    order_seed=seed,
                    timing=timing,
                )
                result["verification"].append({"seed": seed, **measured})
                save()
                print("VERIFY", size, seed, timing, measured["median_ms"], flush=True)
        save()


if __name__ == "__main__":
    main()
