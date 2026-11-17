"""Tune lesson 12 and test physical M grouping against independent wave packing.

Run with a fresh output directory. Training and held-out measurements are
separate; --verify-from repeats locked comparisons without selecting again.
"""

import argparse
import hashlib
import json
import math
import runpy
import statistics
from dataclasses import asdict, replace
from functools import partial
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LESSON = ROOT / "lessons/01-gpu-programming/13-matmul/12-operand-paths"
SHAPES = (
    (16, 1024, 8192),
    (32, 1024, 8192),
    (16, 4096, 8192),
    (1024, 1024, 1024),
    (2048, 2048, 2048),
    (4096, 4096, 4096),
    (512, 2048, 1024),
    (2048, 512, 1024),
    (256, 4096, 8192),
)
WAVE_SHAPES = ((1, 1), (1, 2), (2, 1), (2, 2))


def geometry(config, shape):
    m, n, k = shape
    pm = math.ceil(m / (config.block_m * config.wave_groups_m))
    pn = n // (config.block_n * config.wave_groups_n)
    gm = min(config.group_m, pm)
    return {
        "physical_tile_MN": [
            config.block_m * config.wave_groups_m,
            config.block_n * config.wave_groups_n,
        ],
        "physical_rows": pm,
        "physical_columns": pn,
        "effective_group_m": gm,
        "physical_blocks": pm * pn * config.split_k,
        "M_span_per_traversal_group": config.block_m * config.wave_groups_m * gm,
        "unique_B_bytes_per_column_and_split": (
            2 * (k // config.split_k) * config.block_n * config.wave_groups_n
        ),
        "B_matrix_bytes": 2 * k * n,
        "lds_bytes_per_block": config.lds_bytes,
        "threads_per_block": config.threads,
        "first_blocks_row_split_column": [
            [
                pid % gm + (pid // (gm * config.split_k * pn)) * gm,
                (pid // gm) % config.split_k,
                (pid // (gm * config.split_k)) % pn,
            ]
            for pid in range(min(16, pm * pn * config.split_k))
        ],
    }


def group_choices(config, shape):
    rows = geometry(config, shape)["physical_rows"]
    # Canonicalize groups that clamp to the same physical row count.
    return sorted({min(value, rows) for value in (1, 2, 4, 8)})


def templates(module, shape, wm, wn):
    Config = module["Config"]
    if shape in module["CONFIGS_BY_SHAPE"]:
        base = replace(
            module["CONFIGS_BY_SHAPE"][shape],
            block_m=16,
            waves_m=1,
            waves_n=1,
            wave_groups_m=wm,
            wave_groups_n=wn,
        )
        yield base
        for bk in (16, 32, 64):
            for registers in (False, True):
                yield replace(base, block_k=bk, left_in_registers=registers)
    else:
        # A bounded search shared by all four independent-wave arrangements.
        for bm, bn, bk, unroll in (
            (16, 64, 16, 4),
            (16, 64, 32, 4),
            (32, 64, 32, 2),
            (32, 64, 64, 2),
            (32, 128, 32, 2),
        ):
            for policy in (0, 2):
                yield Config(
                    block_m=bm,
                    block_n=bn,
                    block_k=bk,
                    waves_m=1,
                    waves_n=1,
                    wave_groups_m=wm,
                    wave_groups_n=wn,
                    group_m=1,
                    split_k=1,
                    k_unroll=unroll,
                    right_cache_modifier=policy,
                    left_in_registers=True,
                )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--shape", type=int, nargs=3, action="append")
    parser.add_argument("--verify-from", type=Path)
    parser.add_argument("--seeds", type=int, nargs="+", default=[29, 47, 71])
    parser.add_argument(
        "--timing",
        nargs="+",
        choices=("graph-host", "direct-host"),
        default=["graph-host", "direct-host"],
    )
    parser.add_argument("--batches", type=int, default=7)
    parser.add_argument("--repeats", type=int, default=10)
    parser.add_argument("--train-only", action="store_true")
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output directory")
    if min(args.batches, args.repeats) < 1:
        parser.error("batches and repeats must be positive")
    args.output.mkdir(parents=True)
    tune = runpy.run_path(str(LESSON / "tune.py"))
    module, common = tune["MODULE"], tune["COMMON"]
    common["torch"].set_num_threads(1)
    sources = (
        Path(__file__).resolve(),
        LESSON / "solution.py",
        LESSON / "tune.py",
        LESSON.parent / "09-split-k/tune.py",
    )
    snapshot = args.output / "sources"
    snapshot.mkdir()
    hashes = {}
    for index, path in enumerate(sources):
        name = f"{index}-{path.name}.txt"
        (snapshot / name).write_bytes(path.read_bytes())
        hashes[str(path.relative_to(ROOT))] = hashlib.sha256(
            path.read_bytes()
        ).hexdigest()
    for shape in map(tuple, args.shape or SHAPES):
        key = "x".join(map(str, shape))
        path = args.output / f"{key}.json"
        tune["configure"](shape)
        device = common["torch"].cuda.get_device_properties(0)
        report = {
            "shape_MNK": shape,
            "environment": common["environment"](),
            "L2_bytes_reported_by_HIP": device.L2_cache_size,
            "source_sha256": hashes,
            "scope": (
                "Same unmodified lesson-12 kernel. Tune independent-wave geometry "
                "on seed 13, with matched group_m sweeps for every wave-group layout. "
                "Lock selections before held-out seeds. Warm reused input buffers; "
                "synchronized host timing, allocations/compilation/reference excluded. "
                "No claim of exhaustive tuning or measured cache hits from timing."
            ),
            "training": [],
            "excluded": [],
            "selections": {},
            "verification": [],
        }

        def save(path=path, report=report):
            path.write_text(json.dumps(report, indent=2) + "\n")

        def launch(config):
            return partial(module["matmul_bf16"], config=config)

        if args.verify_from:
            previous = json.loads((args.verify_from / path.name).read_text())
            if previous["source_sha256"] != hashes:
                raise RuntimeError(
                    "Source changed since tuning; cannot verify locked choices"
                )
            report["selections"] = previous["selections"]
            report["selection_source"] = str(args.verify_from / path.name)
        else:
            data = common["inputs"](13)
            seen = {}

            def evaluate(
                config,
                shape=shape,
                seen=seen,
                report=report,
                data=data,
                save=save,
                key=key,
            ):
                # Different group_m values become identical after clamping.
                config = replace(
                    config, group_m=geometry(config, shape)["effective_group_m"]
                )
                if config in seen:
                    return seen[config]
                try:
                    module["validate_config"](config, shape)
                except ValueError as error:
                    report["excluded"].append(
                        {"config": asdict(config), "reason": str(error)}
                    )
                    return None
                fn = launch(config)
                common["validate"](fn, data)
                measured = tune["measure"](
                    {"operand_paths": fn},
                    data,
                    batches=3,
                    repeats=3,
                    order_seed=13,
                )
                row = {
                    "config": asdict(config),
                    "geometry": geometry(config, shape),
                    **measured,
                }
                report["training"].append(row)
                seen[config] = row
                save()
                print(
                    "TRAIN",
                    key,
                    len(seen),
                    config.name,
                    measured["median_ms"],
                    flush=True,
                )
                return row

            for wm, wn in WAVE_SHAPES:
                initial = []
                for base in templates(module, shape, wm, wn):
                    groups = group_choices(base, shape)
                    for gm in sorted({1, min(4, max(groups))}):
                        row = evaluate(replace(base, group_m=gm))
                        if row is not None:
                            initial.append(row)
                # Refine each branch independently, so gm=1 gets equal tuning opportunity.
                for grouped in (False, True):
                    branch = [
                        r for r in initial if (r["config"]["group_m"] > 1) == grouped
                    ]
                    if not branch:
                        continue
                    base = module["Config"].from_dict(
                        min(branch, key=lambda r: r["median_ms"]["operand_paths"])[
                            "config"
                        ]
                    )
                    for unroll in (1, 2, 4, 8):
                        evaluate(replace(base, k_unroll=unroll))
                    for split in (1, 2, 4):
                        evaluate(replace(base, split_k=split))
                    evaluate(
                        replace(base, left_in_registers=not base.left_in_registers)
                    )
                rows = [
                    r
                    for r in seen.values()
                    if (r["config"]["wave_groups_m"], r["config"]["wave_groups_n"])
                    == (wm, wn)
                ]
                # Sweep every group size on both branch winners, holding all else fixed.
                for grouped in (False, True):
                    branch = [
                        r for r in rows if (r["config"]["group_m"] > 1) == grouped
                    ]
                    if branch:
                        base = module["Config"].from_dict(
                            min(branch, key=lambda r: r["median_ms"]["operand_paths"])[
                                "config"
                            ]
                        )
                        for gm in group_choices(base, shape):
                            evaluate(replace(base, group_m=gm))
                rows = [
                    r
                    for r in seen.values()
                    if (r["config"]["wave_groups_m"], r["config"]["wave_groups_n"])
                    == (wm, wn)
                ]
                ungrouped = min(
                    (r for r in rows if r["config"]["group_m"] == 1),
                    key=lambda r: r["median_ms"]["operand_paths"],
                )
                grouped = [r for r in rows if r["config"]["group_m"] > 1]
                choices = {"tuned_gm1": ungrouped["config"]}
                if grouped:
                    best = min(grouped, key=lambda r: r["median_ms"]["operand_paths"])
                    choices["tuned_grouped"] = best["config"]
                    choices["grouped_geometry_gm1"] = {**best["config"], "group_m": 1}
                    choices["gm1_geometry_grouped"] = {
                        **ungrouped["config"],
                        "group_m": best["config"]["group_m"],
                    }
                    for values in choices.values():
                        evaluate(module["Config"].from_dict(values))
                report["selections"][f"{wm}x{wn}"] = choices
                save()
            if shape in module["CONFIGS_BY_SHAPE"]:
                control = module["CONFIGS_BY_SHAPE"][shape]
                report["selections"]["lesson_default"] = {"tuned_gm1": asdict(control)}
            square = LESSON / "results/20261113-square-tuning/configurations.json"
            controls = json.loads(square.read_text())
            if key in controls:
                control = module["Config"].from_dict(controls[key])
                report["selections"]["cooperative_control"] = {
                    "tuned_gm1": asdict(replace(control, group_m=1)),
                    "tuned_grouped": asdict(control),
                }
            save()
        if args.train_only:
            continue
        # Deduplicate identical configs while retaining their descriptive labels.
        configurations, aliases = {}, {}
        for layout, choices in report["selections"].items():
            for name, values in choices.items():
                config = module["Config"].from_dict(values)
                aliases[f"{layout}/{name}"] = config.name
                configurations[config.name] = config
        report["aliases"] = aliases
        report["validation"] = {}
        for name, config in configurations.items():
            report["validation"][name] = module["solve"](config, shape)
            print("CHECKED", key, name, flush=True)
            save()
        launches = {name: launch(config) for name, config in configurations.items()}
        launches["torch"] = common["torch_launch"]
        # measure() expects this label when calculating paired ratios.
        anchor = next(iter(configurations))
        launches["operand_paths"] = launches.pop(anchor)
        report["measurement_anchor"] = anchor
        for seed in args.seeds:
            data = common["inputs"](seed)
            for fn in launches.values():
                common["validate"](fn, data)
            for timing in args.timing:
                measured = tune["measure"](
                    launches,
                    data,
                    batches=args.batches,
                    repeats=args.repeats,
                    order_seed=seed,
                    timing=timing,
                )
                report["verification"].append({"seed": seed, **measured})
                save()
                print("VERIFY", key, seed, timing, measured["median_ms"], flush=True)
        report["median_ms"] = {
            timing: {
                name: statistics.median(
                    r["median_ms"][name]
                    for r in report["verification"]
                    if r["timing"] == timing
                )
                for name in launches
            }
            for timing in args.timing
        }
        save()


if __name__ == "__main__":
    main()
