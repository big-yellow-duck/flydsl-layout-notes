"""Tune published BF16 workloads in matmul stages 12–15 on the local GPU."""

import argparse
import hashlib
import json
import runpy
import statistics
from dataclasses import asdict, replace
from functools import partial
from importlib.metadata import version
from pathlib import Path
from tempfile import NamedTemporaryFile

import torch
from flydsl.compiler.diagnostics import DSLCompileError
from flydsl.compiler.external_llvm import ExternalLLVMError

ROOT = Path(__file__).resolve().parents[1] / "lessons/01-gpu-programming/13-matmul"
STAGES = {
    12: "12-operand-paths",
    13: "13-edge-safety",
    14: "14-targeted-guards",
    15: "15-edge-load-widths",
}
TRAIN = 17
RERANK = 37
VERIFY = (5101, 5202, 5303)


def read(path):
    return json.loads(path.read_text())


def key(shape):
    return "x".join(map(str, shape))


def load_workloads():
    suites = {}
    for stage, directory in STAGES.items():
        folder = ROOT / directory
        solution = runpy.run_path(str(folder / "solution.py"))
        tune = runpy.run_path(str(folder / "tune.py"))
        slots = tuple(
            dict.fromkeys(
                (
                    *solution["SHAPES"],
                    *solution["CONFIGS_BY_SHAPE"],
                    *tune.get("SHAPES", ()),
                    *tune.get("SQUARE_SHAPES", ()),
                )
            )
        )
        suites[stage] = slots, solution, tune

    return suites


def geometries(shape, config):
    m = shape[0]
    if max(shape) <= 128:
        layouts = (
            (16, 32, 1, 1, 1, 1),
            (16, 64, 1, 1, 1, 1),
            (32, 64, 1, 2, 1, 1),
            (16, 32, 1, 1, 2, 1),
        )
    elif m <= 128:
        layouts = (
            (16, 32, 1, 1, 1, 1),
            (16, 64, 1, 1, 1, 1),
            (16, 128, 1, 1, 1, 1),
            (32, 32, 1, 1, 1, 1),
            (32, 64, 1, 1, 1, 1),
            (32, 128, 1, 1, 1, 1),
            (16, 64, 1, 2, 1, 1),
            (32, 64, 1, 2, 1, 1),
            (32, 128, 1, 2, 1, 1),
            (32, 64, 2, 1, 1, 1),
            (16, 64, 1, 1, 1, 2),
            (16, 64, 1, 1, 2, 2),
        )
    else:
        layouts = (
            (32, 64, 1, 1, 1, 1),
            (64, 64, 1, 2, 1, 1),
            (64, 64, 2, 2, 1, 1),
            (64, 128, 2, 2, 1, 1),
            (128, 64, 2, 2, 1, 1),
            (128, 128, 2, 2, 1, 1),
            (128, 128, 1, 4, 1, 1),
            (32, 64, 1, 1, 2, 2),
        )
    for bm, bn, wm, wn, gm, gn in layouts:
        for registers in (True, False):
            # Include both operand routes and seed nearby geometry with known K depth.
            yield replace(
                config,
                group_tile_m=bm,
                group_tile_n=bn,
                waves_per_group_m=wm,
                waves_per_group_n=wn,
                wave_groups_m=gm,
                wave_groups_n=gn,
                left_in_registers=registers,
                stage_k=min(64, max(16, config.stage_k)),
                k_unroll=2,
            )


def search(module, common, measure, shape, base, seeds):
    data = common["inputs"](TRAIN)
    original_a = data[0].clone()
    trials = {}

    def run(config):
        return partial(module["matmul_bf16"], config=config)

    def evaluate(cfg, phase):
        if cfg in trials:
            return
        row = {"config": asdict(cfg), "phase": phase}
        trials[cfg] = row
        try:
            module["validate_config"](cfg, shape)
        except ValueError as error:
            row["excluded"] = str(error)
            return
        launch = run(cfg)
        try:
            common["validate"](launch, data)
            row.update(
                measure(
                    {"native": launch},
                    data,
                    shape,
                    "graph-host",
                    TRAIN,
                    batches=2,
                    repeats=3,
                    graph_gemms=4,
                )
            )
        except (AssertionError, DSLCompileError, ExternalLLVMError) as error:
            data[0].copy_(original_a)
            row["rejected"] = str(error).strip()[:1000]

    def rank():
        return sorted(
            (cfg for cfg in trials if "median_ms" in trials[cfg]),
            key=lambda cfg: trials[cfg]["median_ms"]["native"],
        )

    evaluate(base, "incumbent")
    for cfg in seeds:
        evaluate(cfg, "historical and cross-stage seeds")
    for cfg in geometries(shape, base):
        evaluate(cfg, "geometry")
    for cfg in rank()[:2]:
        for bk in (16, 32, 64):
            for split in (1, 2, 4):
                evaluate(replace(cfg, stage_k=bk, split_k=split), "K and split")
    strongest = rank()[0]
    for field, values in (
        ("k_unroll", (1, 2, 4, 8)),
        ("right_cache_modifier", (0, 1, 2)),
        ("left_cache_modifier", (0, 1, 2)),
        ("traversal_group_m", (1, 2, 4, 8)),
        ("left_in_registers", (True, False)),
    ):
        for value in values:
            evaluate(replace(strongest, **{field: value}), "schedule and cache")

    # Rerank on new data and always keep the incumbent for matched verification.
    finalist_cfgs = list(dict.fromkeys([base, *rank()[:5]]))
    finalists = {cfg.name: run(cfg) for cfg in finalist_cfgs}
    ranking = measure(
        finalists,
        common["inputs"](RERANK),
        shape,
        "graph-host",
        RERANK,
        batches=5,
        repeats=7,
        graph_gemms=16,
    )
    winner = min(finalist_cfgs, key=lambda cfg: ranking["median_ms"][cfg.name])

    measurements = []
    for seed in VERIFY:
        verify = common["inputs"](seed)
        launches = {"incumbent": run(base), "torch": common["torch_launch"]}
        if winner != base:
            launches["challenger"] = run(winner)
        for launch in launches.values():
            common["validate"](launch, verify)
        row = measure(
            launches, verify, shape, "graph-host", seed, batches=7, repeats=10
        )
        if "challenger" in launches:
            row["challenger_over_incumbent"] = statistics.median(
                a / b
                for a, b in zip(
                    row["samples_ms"]["challenger"],
                    row["samples_ms"]["incumbent"],
                    strict=True,
                )
            )
        measurements.append(row)

    improved = winner != base and all(
        row["challenger_over_incumbent"] < 1 for row in measurements
    )
    selected = winner if improved else base
    return {
        "baseline_config": asdict(base),
        "challenger_config": asdict(winner),
        "selected_config": asdict(selected),
        "selected_lane": "challenger" if improved else "incumbent",
        "trials": list(trials.values()),
        "finalist_ranking": ranking,
        "verification": measurements,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--stages", type=int, nargs="+", choices=STAGES, default=tuple(STAGES)
    )
    parser.add_argument("--shape", type=int, nargs=3)
    parser.add_argument("--list", action="store_true")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    torch.set_num_threads(1)
    suites = load_workloads()
    jobs = [
        (stage, shape)
        for stage in dict.fromkeys(args.stages)
        for shape in suites[stage][0]
        if not args.shape or shape == tuple(args.shape)
    ]
    if not jobs:
        parser.error("No published workload matches the selection")
    if args.list:
        for stage, shape in jobs:
            print(stage, key(shape))
        return

    _, _, harness = suites[14]
    common, measure = harness["COMMON"], harness["measure"]
    args.output.mkdir(parents=True, exist_ok=True)
    for number, (stage, shape) in enumerate(jobs, 1):
        _, module, _ = suites[stage]
        path = args.output / f"{stage}-{key(shape)}.json"
        if path.exists():
            record = read(path)
            if record["stage"] != stage or tuple(record["shape_MNK"]) != shape:
                raise ValueError(f"Checkpoint does not match its workload: {path}")
            print(f"Reuse {number}/{len(jobs)} stage {stage} {key(shape)}", flush=True)
            continue
        print(f"Start {number}/{len(jobs)} stage {stage} {key(shape)}", flush=True)
        Config = module["Config"]
        base = module["CONFIGS_BY_SHAPE"].get(shape)
        if base is None:
            base = module["default_config"](shape)
        proposals = []
        for other, (_, owner, _) in suites.items():
            if other != stage:
                control = owner["CONFIGS_BY_SHAPE"].get(shape)
                if control:
                    proposals.append(asdict(control))
                previous = args.output / f"{other}-{key(shape)}.json"
                if previous.exists():
                    proposals.append(read(previous)["selected_config"])
        common["inputs"].__globals__["SHAPE"] = shape
        result = search(
            module,
            common,
            measure,
            shape,
            base,
            [Config(**row) for row in proposals],
        )
        result.update(
            stage=stage,
            shape_MNK=shape,
            gpu=torch.cuda.get_device_name(),
            architecture=torch.cuda.get_device_properties(0).gcnArchName,
            flydsl=version("flydsl"),
            torch=torch.__version__,
            hip=torch.version.hip,
            solution_sha256=hashlib.sha256(
                (ROOT / STAGES[stage] / "solution.py").read_bytes()
            ).hexdigest(),
        )
        with NamedTemporaryFile("w", dir=args.output, delete=False) as output:
            temporary = Path(output.name)
            try:
                json.dump(result, output, indent=2)
                output.write("\n")
                output.flush()
                path.hardlink_to(temporary)
            finally:
                temporary.unlink()
        lane = result["selected_lane"]
        rates = {
            name: statistics.median(
                row["median_ms"][name] for row in result["verification"]
            )
            for name in ("incumbent", lane, "torch")
        }
        print(
            f"Done {number}/{len(jobs)} stage {stage} {key(shape)} {rates}", flush=True
        )
        module["_workspace_for"].cache_clear()


if __name__ == "__main__":
    main()
