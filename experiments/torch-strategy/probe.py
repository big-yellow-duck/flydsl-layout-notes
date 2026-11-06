"""Validate and measure explicit experimental configurations against locked controls."""

import argparse
import hashlib
import inspect
import json
import runpy
from dataclasses import asdict, replace
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
COURSE = ROOT / "lessons/01-gpu-programming/13-matmul"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--module", type=Path, default=COURSE / "12-operand-paths/solution.py"
    )
    parser.add_argument("--shape", type=int, nargs=3, required=True)
    parser.add_argument("--configs", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--batches", type=int, default=5)
    parser.add_argument("--repeats", type=int, default=8)
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output path")
    args.output.parent.mkdir(parents=True, exist_ok=True)
    native = runpy.run_path(str(args.module))
    harness = runpy.run_path(str(ROOT / "experiments/wave-specialization/tune.py"))
    common, prefetch, current = (
        harness["COMMON"],
        harness["PREFETCH"],
        harness["MODULE"],
    )
    shape = tuple(args.shape)
    common["inputs"].__globals__["SHAPE"] = shape
    selection = json.loads(
        (ROOT / "experiments/wave-specialization/results/selection.json").read_text()
    )
    key = "x".join(map(str, shape))
    prefetch_config = prefetch["Config"](**selection["prefetch_control"][key]["config"])
    references = {
        "prefetch": prefetch["launch_for"](prefetch_config, shape),
        "wave_specialized": current["launch_for"](
            current["CONFIGS_BY_SHAPE"][shape], shape
        ),
        "torch": common["torch_launch"],
    }
    data, trace = common["inputs"](13), common["inputs"](0, True)
    configs = [native["Config"](**row) for row in json.loads(args.configs.read_text())]
    report = {
        "kind": "training_probe",
        "training_seed": 13,
        "shape_MNK": shape,
        "candidate_count": len(configs),
        "module": str(args.module.resolve()),
        "native_factory_sha256": hashlib.sha256(
            inspect.getsource(native["build"].__wrapped__).encode()
        ).hexdigest(),
        "native_source_sha256": hashlib.sha256(args.module.read_bytes()).hexdigest(),
        "prefetch_config": asdict(prefetch_config),
        "wave_specialized_config": asdict(current["CONFIGS_BY_SHAPE"][shape]),
        "ranking": [],
        "pruned": [],
        "rejected": [],
    }
    for index, config in enumerate(configs):
        try:
            native["validate_config"](config, shape)
        except ValueError as error:
            report["pruned"].append({"config": asdict(config), "error": str(error)})
        else:
            try:
                candidate = native["launch_for"](config, shape)
                matched = {}
                compatible = {
                    key: value
                    for key, value in asdict(config).items()
                    if key in prefetch["Config"].__dataclass_fields__
                }
                try:
                    geometry = prefetch["Config"](**compatible)
                    prefetch["validate_config"](geometry, shape)
                    matched["matched_prefetch"] = prefetch["launch_for"](
                        geometry, shape
                    )
                except ValueError:
                    pass
                if hasattr(config, "right_lds_layout"):
                    packed_config = replace(
                        config, right_lds_layout="packed", right_lds_padding=0
                    )
                    if hasattr(packed_config, "right_operand_bits"):
                        packed_config = replace(packed_config, right_operand_bits=16)
                    matched["packed"] = native["launch_for"](packed_config, shape)
                for launch in (candidate, *matched.values()):
                    common["validate"](launch, trace, True)
                    common["validate"](launch, data)
                result = harness["measure"](
                    {"specialized": candidate, **references, **matched},
                    data,
                    args.batches,
                    args.repeats,
                    index,
                )
                report["ranking"].append(
                    {"config": asdict(config), "name": config.name, **result}
                )
                report["ranking"].sort(key=lambda row: row["ratio_to_wave_specialized"])
                print(
                    "PROBE",
                    index + 1,
                    config.name,
                    {
                        name: round(value * 1000, 3)
                        for name, value in result["median_ms"].items()
                    },
                    "vs-current",
                    round(result["ratio_to_wave_specialized"], 4),
                    flush=True,
                )
            except (RuntimeError, AssertionError) as error:
                report["rejected"].append(
                    {"config": asdict(config), "error": str(error)}
                )
                print("REJECTED", config.name, str(error)[:240], flush=True)
        args.output.write_text(json.dumps(report, indent=2) + "\n")


if __name__ == "__main__":
    main()
