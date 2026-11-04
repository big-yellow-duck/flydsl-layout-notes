"""Profile the locked native kernel and GPU PyTorch on identical BF16 buffers.

Run from the repository root:
    pixi run python lessons/01-gpu-programming/13-matmul/08-parameter-tuning/profile.py \
        --collect --output /tmp/flydsl-tuning-profile

Trace durations and hardware counters are collected in separate processes.
The uninstrumented held-out timings remain the performance selection evidence.
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
from pathlib import Path

import flydsl  # noqa: F401 -- load the compiler's LLVM before torch
import torch

HERE = Path(__file__).resolve().parent
PAIRS = 20
COUNTERS = (
    "LDSBankConflict",
    "SQC_LDS_BANK_CONFLICT_sum",
    "SQC_LDS_IDX_ACTIVE_sum",
    "SQ_INSTS_LDS_sum",
    "SQ_WAVES_sum",
)


def roctx():
    library = ctypes.CDLL("librocprofiler-sdk-roctx.so")
    for name in ("roctxProfilerPause", "roctxProfilerResume"):
        function = getattr(library, name)
        function.argtypes = [ctypes.c_uint64]
        function.restype = ctypes.c_int
    return library


def set_profiling(library, enabled):
    function = library.roctxProfilerResume if enabled else library.roctxProfilerPause
    status = function(0)
    if status != 0:
        raise RuntimeError(f"ROCTx profiler control failed: {status}")


def worker(output):
    marker = roctx()
    set_profiling(marker, False)
    tune = runpy.run_path(str(HERE / "tune.py"))
    data = tune["inputs"](2026110413)
    config = tune["MODULE"]["SELECTED_CONFIG"]
    implementations = {
        "native": tune["launch_for"](config),
        "torch": tune["torch_launch"],
    }
    for launch in implementations.values():
        tune["validate"](launch, data)
    a, b, storage, _ = data
    out = storage[:-16].view(1024, 1024)
    for _ in range(20):
        for launch in implementations.values():
            launch(a, b, out)
    torch.cuda.synchronize()
    sequence = []
    set_profiling(marker, True)
    for pair in range(PAIRS):
        order = ("native", "torch") if pair % 2 == 0 else ("torch", "native")
        for name in order:
            implementations[name](a, b, out)
            torch.cuda.synchronize()
            sequence.append(name)
    set_profiling(marker, False)
    for launch in implementations.values():
        tune["validate"](launch, data)
    report = {
        "environment": tune["environment"](),
        "config": config.name,
        "seed": 2026110413,
        "pairs": PAIRS,
        "warmups_per_implementation": 20,
        "dispatch_sequence": sequence,
        "correctness": "full CPU-reference and sentinel checks passed before and after profiling",
        "scope": "selected ROCTx region; one synchronized matmul per dispatch; alternating paired order",
    }
    output.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report), flush=True)


def extent(row, prefix):
    if prefix in row:
        return int(row[prefix])
    return math.prod(int(row[f"{prefix}_{axis}"]) for axis in "XYZ")


def dispatches(path, sequence, counters=False):
    with path.open() as stream:
        rows = list(csv.DictReader(stream))
    grouped = {}
    for row in rows:
        grouped.setdefault(int(row["Dispatch_Id"]), []).append(row)
    if len(grouped) != len(sequence):
        raise RuntimeError(
            f"Expected {len(sequence)} matmul dispatches; found {len(grouped)} in {path}"
        )
    samples = {"native": [], "torch": []}
    for name, key in zip(sequence, sorted(grouped), strict=True):
        group = grouped[key]
        first = group[0]
        if first["Kernel_Name"].startswith("exercise_kernel") != (name == "native"):
            raise RuntimeError(
                f"Unexpected dispatch order: {name}, {first['Kernel_Name']}"
            )
        entry = {
            "dispatch_id": key,
            "kernel": first["Kernel_Name"],
            "lds_bytes": int(first["LDS_Block_Size"]),
            "vgprs": int(first["VGPR_Count"]),
            "scratch_bytes": int(first["Scratch_Size"]),
            "workgroup_threads": extent(first, "Workgroup_Size"),
            "grid_threads": extent(first, "Grid_Size"),
            "start_ns": int(first["Start_Timestamp"]),
            "end_ns": int(first["End_Timestamp"]),
        }
        if counters:
            entry["counters"] = {}
            for counter in COUNTERS:
                values = [
                    float(r["Counter_Value"])
                    for r in group
                    if r["Counter_Name"] == counter
                ]
                if len(values) != 1:
                    raise RuntimeError(f"Expected one reduced {counter} per dispatch")
                entry["counters"][counter] = values[0]
            c = entry["counters"]
            assert c["SQC_LDS_IDX_ACTIVE_sum"] > 0
            assert (
                abs(
                    c["LDSBankConflict"]
                    - 100 * c["SQC_LDS_BANK_CONFLICT_sum"] / c["SQC_LDS_IDX_ACTIVE_sum"]
                )
                < 0.001
            )
        elif len(group) != 1:
            raise RuntimeError("Expected one kernel trace row per matmul")
        samples[name].append(entry)
    return samples


def collect(output):
    profiler = shutil.which("rocprofv3")
    if profiler is None:
        raise SystemExit("rocprofv3 is required; use the pinned Pixi environment")
    if output.exists():
        raise SystemExit("Use a fresh output directory to preserve earlier profiles")
    output.mkdir(parents=True)
    profiler_version = subprocess.check_output([profiler, "--version"], text=True)
    (output / "profiler-version.txt").write_text(profiler_version)
    available = subprocess.check_output([profiler, "--list-avail"], text=True)
    (output / "available-counters.txt").write_text(available)
    for counter in COUNTERS:
        if counter not in available:
            raise RuntimeError(f"Unavailable counter: {counter}")
    reports = {}
    commands = {}
    for mode in ("trace", "counters"):
        destination = output / mode
        worker_report = output / f"{mode}-worker.json"
        command = [
            profiler,
            "--selected-regions",
            "-d",
            str(destination),
            "-o",
            mode,
            "--output-format",
            "csv",
        ]
        if mode == "trace":
            command += ["--kernel-trace"]
        else:
            command += ["--pmc", *COUNTERS]
        command += [
            "--",
            sys.executable,
            str(Path(__file__).resolve()),
            "--worker",
            "--output",
            str(worker_report),
        ]
        commands[mode] = command
        completed = subprocess.run(
            command, capture_output=True, text=True, check=False, env=os.environ.copy()
        )
        (output / f"{mode}-stdout.txt").write_text(completed.stdout)
        (output / f"{mode}-stderr.txt").write_text(completed.stderr)
        if completed.returncode:
            raise RuntimeError(
                f"{mode} collection failed; inspect {output / f'{mode}-stderr.txt'}"
            )
        metadata = json.loads(worker_report.read_text())
        suffix = "kernel_trace" if mode == "trace" else "counter_collection"
        reports[mode] = {
            "worker": metadata,
            "samples": dispatches(
                destination / f"{mode}_{suffix}.csv",
                metadata["dispatch_sequence"],
                mode == "counters",
            ),
        }
    trace = reports["trace"]["samples"]
    durations = {
        name: [(row["end_ns"] - row["start_ns"]) / 1e6 for row in rows]
        for name, rows in trace.items()
    }
    timestamps_valid = all(
        value > 0 for values in durations.values() for value in values
    )
    summary = {
        "source_sha256": {
            name: hashlib.sha256((HERE / name).read_bytes()).hexdigest()
            for name in ("solution.py", "profile.py")
        },
        "profiler_version": profiler_version,
        "commands": commands,
        "profiles": reports,
        "trace_timestamps_valid": timestamps_valid,
        "trace_median_ms": {
            name: statistics.median(values) if timestamps_valid else None
            for name, values in durations.items()
        },
        "note": "Instrumented kernel-dispatch durations, separate from uninstrumented paired throughput. Invalid timestamps never prove a win.",
    }
    if timestamps_valid:
        ratios = [
            a / b for a, b in zip(durations["native"], durations["torch"], strict=True)
        ]
        summary["trace_paired_ratios"] = ratios
        summary["trace_median_paired_ratio"] = statistics.median(ratios)
    for name, rows in reports["counters"]["samples"].items():
        reports["counters"].setdefault("median_counters", {})[name] = {
            counter: statistics.median(row["counters"][counter] for row in rows)
            for counter in COUNTERS
        }
    (output / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
    print(
        json.dumps(
            {
                key: value
                for key, value in summary.items()
                if key not in ("profiles", "commands")
            },
            indent=2,
        )
    )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    action = parser.add_mutually_exclusive_group(required=True)
    action.add_argument("--collect", action="store_true")
    action.add_argument("--worker", action="store_true", help=argparse.SUPPRESS)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.worker:
        worker(args.output.resolve())
    else:
        collect(args.output.resolve())


if __name__ == "__main__":
    main()
