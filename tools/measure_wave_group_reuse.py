"""Compare independent wave tiles with cooperative N/K tiles using lesson 10a."""

import argparse
import hashlib
import json
import runpy
from dataclasses import asdict, replace
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--seeds", type=int, nargs="+", default=[13, 29, 47])
    parser.add_argument("--sync-only", action="store_true")
    parser.add_argument(
        "--timing", choices=["graph-host", "direct-host"], default="graph-host"
    )
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output path")
    course = (
        Path(__file__).resolve().parents[1] / "lessons/01-gpu-programming/13-matmul"
    )
    lesson = course / "10a-synchronization-scope"
    measurement = course / "10-wave-local-tiles/measure.py"
    module = runpy.run_path(str(lesson / "solution.py"))
    helper = runpy.run_path(str(measurement))
    module["torch"].set_num_threads(1)
    shape = (16, 4096, 8192)
    packed = module["Config"](16, 64, 16, 1, 1, split_k=1, wave_groups_n=2)
    configs = {
        "single_n64_k16": replace(packed, wave_groups_n=1),
        "packed_n64_k16": packed,
        "cooperative_n64_k32": replace(packed, wave_groups_n=1, waves_n=2, block_k=32),
        "cooperative_n128_k32": replace(
            packed, wave_groups_n=1, waves_n=2, block_n=128, block_k=32
        ),
        "packed_n64_k32": replace(packed, block_k=32),
        "packed_n64_k16_workgroup": replace(packed, sync_mode="workgroup"),
    }
    if args.sync_only:
        configs = {
            "packed_n64_k16": packed,
            "packed_n64_k16_workgroup": replace(packed, sync_mode="workgroup"),
            "packed_n64_k16_lds_workgroup": replace(packed, sync_mode="lds-workgroup"),
        }
    report = {
        "shape_MNK": shape,
        "source_sha256": {
            "solution.py": hashlib.sha256(
                (lesson / "solution.py").read_bytes()
            ).hexdigest(),
            "measure.py": hashlib.sha256(measurement.read_bytes()).hexdigest(),
        },
        "scope": "Same lesson-10a kernel, ordinary cache policy, rolled prefetched K loop, split_k=1. Intended LDS subgroup synchronization for independent waves, LDS workgroup synchronization for cooperating waves; explicit default-workgroup control. Vary ownership, N extent and K staging extent.",
        "excluded": {},
        "resources": {},
        "validation": {},
        "runs": [],
    }
    if args.sync_only:
        report["scope"] = (
            "Fixed packed N64/K16 geometry, ordinary cache policy, rolled K loop, "
            "split_k=1; change only synchronization mode."
        )
    for n in (64, 128):
        config = replace(packed, wave_groups_n=1, waves_n=2, block_n=n)
        try:
            module["validate_config"](config, shape)
        except ValueError as error:
            report["excluded"][f"cooperative_n{n}_k16"] = str(error)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    for name, config in configs.items():
        module["validate_config"](config, shape)
        blocks = (
            shape[0]
            // config.block_m
            * (shape[1] // config.block_n)
            // config.wave_groups
        )
        report["resources"][name] = {
            "configuration": asdict(config),
            "threads_per_block": config.threads,
            "physical_blocks": blocks,
            "lds_bytes_per_block": config.lds_bytes,
            "logical_A_staging_BF16_per_thread": config.block_m
            * config.block_k
            // config.compute_threads,
            "logical_B_staging_BF16_per_thread": config.block_k
            * config.block_n
            // config.compute_threads,
            "accumulator_FP32_per_thread": config.accumulator_values,
        }
        report["validation"][name] = module["solve"](config, shape)
        print(f"Validated {name}", flush=True)
    compare = helper["compare"]
    compare.__globals__["variants"] = lambda *_: {
        name: config for name, config in configs.items() if name != "packed_n64_k16"
    }
    for seed in args.seeds:
        measured = compare(
            module, packed, shape, "10a", args.timing, seed=seed, batches=7, repeats=20
        )
        report["runs"].append(measured)
        args.output.write_text(json.dumps(report, indent=2) + "\n")
        print(
            json.dumps({"seed": seed, "timing": args.timing, **measured["median_ms"]}),
            flush=True,
        )


if __name__ == "__main__":
    main()
