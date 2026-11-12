"""Collect separate rocprofv3 traces and counter groups for a skinny GEMM.

Run: pixi run python lessons/01-gpu-programming/13-matmul/09-split-k/profile.py \
    --collect --output /tmp/skinny-profile
Use --module PATH to compare another lesson exposing matmul_bf16.
"""

import argparse
import csv
import ctypes
import hashlib
import json
import math
import os
import runpy
import shutil
import statistics
import subprocess
import sys
from functools import partial
from pathlib import Path

import flydsl  # noqa: F401 -- initialize compiler LLVM before torch
import torch

HERE = Path(__file__).resolve().parent
GROUPS = {
    "instructions-memory": (
        "SQ_WAVES_sum",
        "SQ_INSTS_LDS_sum",
        "SQ_INSTS_TEX_LOAD_sum",
        "SQ_INSTS_TEX_STORE_sum",
    ),
    "instructions-alu": (
        "SQ_WAVES_sum",
        "SQ_INSTS_VALU_sum",
        "SQ_INSTS_SALU_sum",
        "SQ_WAIT_INST_LDS_sum",
    ),
    "lds": (
        "LDSBankConflict",
        "SQC_LDS_BANK_CONFLICT_sum",
        "SQC_LDS_IDX_ACTIVE_sum",
        "ALUStalledByLDS",
    ),
    "l1-traffic": (
        "GL1C_REQ_READ_sum",
        "GL1C_REQ_MISS_sum",
        "TCP_REQ_READ_sum",
        "TCP_REQ_MISS_sum",
    ),
    "l1-read-sizes": (
        "GL1C_GL2_REQ_READ_128B_sum",
        "GL1C_GL2_REQ_READ_64B_sum",
        "GL1C_GL2_REQ_READ_32B_sum",
        "MemUnitBusy",
    ),
    "l2": (
        "GL2C_HIT_sum",
        "GL2C_MISS_sum",
        "GL2C_EA_RDREQ_128B_sum",
        "GL2C_EA_RDREQ_64B_sum",
    ),
    "external-reads": (
        "GL2C_EA_RDREQ_32B_sum",
        "GL2C_EA_RDREQ_96B_sum",
        "GL2C_EA_RDREQ_DRAM_sum",
        "GL2C_MC_RDREQ_sum",
    ),
}


def profiling_control(enabled):
    library = ctypes.CDLL("librocprofiler-sdk-roctx.so")
    function = getattr(
        library, "roctxProfilerResume" if enabled else "roctxProfilerPause"
    )
    function.argtypes = [ctypes.c_uint64]
    function.restype = ctypes.c_int
    status = function(0)
    if status:
        raise RuntimeError(f"ROCTx profiler control failed: {status}")


def worker(args):
    profiling_control(False)
    torch.set_num_threads(1)
    shape = tuple(args.shape)
    module = runpy.run_path(str(args.module))
    tune = runpy.run_path(str(HERE / "tune.py"))
    kernel_source = module["_matmul_bf16"]._original_func
    tune["inputs"].__globals__.update(SHAPE=shape, MODULE=module, BUILD=kernel_source)
    config = module["CONFIGS_BY_SHAPE"][shape]
    if args.config_json:
        config = module["Config"](**json.loads(args.config_json))
    elif args.config:
        values = list(map(int, args.config.split(",")))
        config = module["Config"](*values[:5], group_m=1, split_k=values[5])
    data = tune["inputs"](2026111201)
    launches = {
        "native": partial(module["matmul_bf16"], config=config),
        "torch": tune["torch_launch"],
    }
    for launch in launches.values():
        tune["validate"](launch, data)
    if "matmul_bf16" in module:
        module["check_workspace"](
            module["_workspace_for"](
                config,
                shape,
                data[0].device,
                torch.cuda.current_stream(data[0].device),
                0,
            )
        )
    a, b, storage, _ = data
    out = storage[:-16].view(shape[0], shape[1])
    for _ in range(20):
        for launch in launches.values():
            launch(a, b, out=out)
    torch.cuda.synchronize()
    sequence = []
    profiling_control(True)
    for pair in range(args.pairs):
        order = ("native", "torch") if pair % 2 == 0 else ("torch", "native")
        for name in order:
            launches[name](a, b, out=out)
            torch.cuda.synchronize()
            sequence.append(name)
    profiling_control(False)
    for launch in launches.values():
        tune["validate"](launch, data)
    if "matmul_bf16" in module:
        module["check_workspace"](
            module["_workspace_for"](
                config,
                shape,
                data[0].device,
                torch.cuda.current_stream(data[0].device),
                0,
            )
        )
    environment = tune["environment"]()
    environment["source_sha256"] = {
        str(path): hashlib.sha256(path.read_bytes()).hexdigest()
        for path in (args.module, HERE / "tune.py", Path(__file__).resolve())
    }
    report = {
        "environment": environment,
        "shape_MNK": shape,
        "module": str(args.module),
        "module_sha256": hashlib.sha256(args.module.read_bytes()).hexdigest(),
        "config": config.__dict__,
        "name": config.name,
        "dispatch_sequence": sequence,
        "pairs": args.pairs,
        "warmups_per_implementation": 20,
        "correctness": "full CPU reference, output sentinels, workspace reset before/after collection passed",
        "scope": "ROCTx-selected synchronized matmuls; instrumented profiles are separate from performance verification",
    }
    args.output.write_text(json.dumps(report, indent=2) + "\n")


def extent(row, name):
    return (
        int(row[name])
        if name in row
        else math.prod(int(row[f"{name}_{axis}"]) for axis in "XYZ")
    )


def parse_dispatches(path, sequence, counters=()):
    with path.open() as stream:
        rows = list(csv.DictReader(stream))
    grouped = {}
    for row in rows:
        grouped.setdefault(int(row["Dispatch_Id"]), []).append(row)
    if len(grouped) != len(sequence):
        raise RuntimeError(
            f"Expected {len(sequence)} dispatches, found {len(grouped)} in {path}"
        )
    samples = {"native": [], "torch": []}
    for name, key in zip(sequence, sorted(grouped), strict=True):
        group = grouped[key]
        first = group[0]
        if first["Kernel_Name"].startswith(("_matmul_bf16", "_matmul_bf16")) != (
            name == "native"
        ):
            raise RuntimeError(
                f"Unexpected dispatch for {name}: {first['Kernel_Name']}"
            )
        sample = {
            "dispatch_id": key,
            "kernel": first["Kernel_Name"],
            "lds_bytes": int(first["LDS_Block_Size"]),
            "vgprs": int(first["VGPR_Count"]),
            "scratch_bytes": int(first["Scratch_Size"]),
            "workgroup_threads": extent(first, "Workgroup_Size"),
            "grid_threads": extent(first, "Grid_Size"),
            "duration_ns": int(first["End_Timestamp"]) - int(first["Start_Timestamp"]),
        }
        if counters:
            sample["counters"] = {}
            for counter in counters:
                values = [
                    float(row["Counter_Value"])
                    for row in group
                    if row["Counter_Name"] == counter
                ]
                if len(values) != 1:
                    raise RuntimeError(
                        f"Expected one reduced {counter} value per dispatch"
                    )
                sample["counters"][counter] = (
                    values[0] if math.isfinite(values[0]) else None
                )
        samples[name].append(sample)
    return samples


def collect(args):
    profiler = shutil.which("rocprofv3")
    if profiler is None:
        raise RuntimeError("rocprofv3 is required in the pinned environment")
    if args.output.exists():
        raise RuntimeError("Use a fresh output directory")
    args.output.mkdir(parents=True)
    available = subprocess.check_output([profiler, "--list-avail"], text=True)
    (args.output / "available-counters.txt").write_text(available)
    version = subprocess.check_output([profiler, "--version"], text=True)
    (args.output / "profiler-version.txt").write_text(version)
    groups = GROUPS if not args.group else {key: GROUPS[key] for key in args.group}
    commands, reports = {}, {}
    for mode, counters in (("trace", ()), *groups.items()):
        if any(counter not in available for counter in counters):
            raise RuntimeError(f"Unavailable counter in {mode}: {counters}")
        worker_report = args.output / f"{mode}-worker.json"
        command = [
            profiler,
            "--selected-regions",
            "-d",
            str(args.output / mode),
            "-o",
            mode,
            "--output-format",
            "csv",
        ]
        command += ["--pmc", *counters] if counters else ["--kernel-trace"]
        command += [
            "--",
            sys.executable,
            str(Path(__file__).resolve()),
            "--worker",
            "--module",
            str(args.module),
            "--shape",
            *map(str, args.shape),
            "--pairs",
            str(args.pairs),
            "--output",
            str(worker_report),
        ]
        if args.config:
            command += ["--config", args.config]
        if args.config_json:
            command += ["--config-json", args.config_json]
        commands[mode] = command
        result = subprocess.run(
            command, capture_output=True, text=True, check=False, env=os.environ.copy()
        )
        (args.output / f"{mode}-stdout.txt").write_text(result.stdout)
        (args.output / f"{mode}-stderr.txt").write_text(result.stderr)
        if result.returncode:
            raise RuntimeError(f"{mode} failed: {args.output / (mode + '-stderr.txt')}")
        metadata = json.loads(worker_report.read_text())
        suffix = "counter_collection" if counters else "kernel_trace"
        samples = parse_dispatches(
            args.output / mode / f"{mode}_{suffix}.csv",
            metadata["dispatch_sequence"],
            counters,
        )
        report = {"worker": metadata, "samples": samples}
        if counters:
            report["median_counters"] = {
                name: {
                    counter: statistics.median(
                        row["counters"][counter]
                        for row in samples[name]
                        if row["counters"][counter] is not None
                    )
                    if any(
                        row["counters"][counter] is not None for row in samples[name]
                    )
                    else None
                    for counter in counters
                }
                for name in samples
            }
        reports[mode] = report
        print("COLLECTED", mode, report.get("median_counters", {}), flush=True)
    trace = reports["trace"]["samples"]
    valid = all(row["duration_ns"] > 0 for rows in trace.values() for row in rows)
    summary = {
        "profiler_version": version,
        "commands": commands,
        "profiles": reports,
        "trace_timestamps_valid": valid,
        "trace_median_us": {
            name: statistics.median(row["duration_ns"] for row in rows) / 1000
            if valid
            else None
            for name, rows in trace.items()
        },
        "note": "Raw counters collected in separate processes; trace durations and counter-pass durations are not uninstrumented throughput.",
    }
    (args.output / "summary.json").write_text(
        json.dumps(summary, indent=2, allow_nan=False) + "\n"
    )
    print("SUMMARY", summary["trace_median_us"], flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    action = parser.add_mutually_exclusive_group(required=True)
    action.add_argument("--collect", action="store_true")
    action.add_argument("--worker", action="store_true", help=argparse.SUPPRESS)
    parser.add_argument("--module", type=Path, default=HERE / "solution.py")
    parser.add_argument("--shape", type=int, nargs=3, default=(16, 4096, 8192))
    parser.add_argument("--config", help="BM,BN,BK,WM,WN,SPLIT_K")
    parser.add_argument(
        "--config-json", help="JSON object for the selected module's Config"
    )
    parser.add_argument("--pairs", type=int, default=8)
    parser.add_argument("--group", action="append", choices=GROUPS)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.pairs < 1:
        parser.error("--pairs must be positive")
    if args.config and args.config_json:
        parser.error("Choose --config or --config-json")
    args.output = args.output.resolve()
    args.module = args.module.resolve()
    worker(args) if args.worker else collect(args)


if __name__ == "__main__":
    main()
