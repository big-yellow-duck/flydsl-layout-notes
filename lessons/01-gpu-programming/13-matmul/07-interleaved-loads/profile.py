"""Reproduce instruction order, LDS counters, and separate timing for stage 07.

Run from the repository root:
    pixi run python lessons/01-gpu-programming/13-matmul/07-interleaved-loads/profile.py \
        --collect --output /tmp/flydsl-interleaved-profile
"""

import argparse
import csv
import hashlib
import json
import os
import platform
import re
import runpy
import shutil
import statistics
import subprocess
import sys
from collections import Counter
from functools import partial
from importlib.metadata import version
from pathlib import Path

# Import the compiler before torch's LLVM libraries.
import flydsl  # noqa: F401
import torch

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
MODES = ("serial", "prefetch")
COUNTERS = (
    "LDSBankConflict",
    "SQC_LDS_BANK_CONFLICT_sum",
    "SQC_LDS_IDX_ACTIVE_sum",
    "SQ_INSTS_LDS_sum",
)


def worker(mode, implementation="solution.py"):
    """Three small boundary checks, two full checks, three warm-ups, five samples."""
    module = runpy.run_path(str(HERE / implementation))
    checkpoint = module["solve"](mode)
    generator = torch.Generator().manual_seed(13)
    a_cpu = torch.randn(1024, 1024, generator=generator).to(torch.bfloat16)
    b_cpu = torch.randn(1024, 1024, generator=generator).to(torch.bfloat16)
    a, b = a_cpu.cuda(), b_cpu.cuda()
    output = torch.empty_like(a)
    for _ in range(8):
        module["matmul_bf16"](a, b, out=output, schedule=mode)
    torch.cuda.synchronize()
    torch.testing.assert_close(
        output.cpu(),
        (a_cpu.float() @ b_cpu.float()).to(torch.bfloat16),
        rtol=0.016,
        atol=0.03125,
    )
    print(json.dumps({"schedule": mode, "correctness": "passed", **checkpoint}))


def summarize(path):
    """Validate a complete dispatch collection before reporting the final five."""
    with path.open() as stream:
        rows = list(csv.DictReader(stream))
    dispatches = {}
    boundary_dispatches = set()
    for row in rows:
        if not row["Kernel_Name"].startswith("_matmul_bf16"):
            continue
        if int(row["Grid_Size"]) != 32768:
            boundary_dispatches.add(int(row["Dispatch_Id"]))
            continue
        dispatches.setdefault(int(row["Dispatch_Id"]), []).append(row)
    if len(boundary_dispatches) != 3:
        raise RuntimeError(
            f"Expected three boundary-check dispatches; got {len(boundary_dispatches)}"
        )
    if len(dispatches) != 10:
        raise RuntimeError(
            f"Expected ten matmul dispatches in {path}; got {len(dispatches)}"
        )
    samples = [dispatches[key] for key in sorted(dispatches)[-5:]]
    metrics = {}
    for counter in COUNTERS:
        values = []
        for dispatch in samples:
            matching = [
                float(r["Counter_Value"])
                for r in dispatch
                if r["Counter_Name"] == counter
            ]
            if len(matching) != 1:
                raise RuntimeError(f"Expected one reduced {counter} value per dispatch")
            values.append(matching[0])
        metrics[counter] = {"median": statistics.median(values), "samples": values}
    if metrics["SQC_LDS_IDX_ACTIVE_sum"]["median"] <= 0:
        raise RuntimeError(
            "No indexed LDS activity: bank-conflict ratio is not evidence"
        )
    expected_ratio = (
        100
        * metrics["SQC_LDS_BANK_CONFLICT_sum"]["median"]
        / metrics["SQC_LDS_IDX_ACTIVE_sum"]["median"]
    )
    if abs(expected_ratio - metrics["LDSBankConflict"]["median"]) > 0.001:
        raise RuntimeError(
            "Bank-conflict metric does not match its raw numerator/denominator"
        )
    first = samples[0][0]
    timestamps_valid = all(
        int(row["End_Timestamp"]) > int(row["Start_Timestamp"])
        for dispatch in samples
        for row in dispatch
    )
    return {
        "full_workload_dispatches": len(dispatches),
        "boundary_dispatches": len(boundary_dispatches),
        "dispatches_summarized": 5,
        "lds_bytes": int(first["LDS_Block_Size"]),
        "vgprs": int(first["VGPR_Count"]),
        "scratch_bytes": int(first["Scratch_Size"]),
        "workgroup_threads": int(first["Workgroup_Size"]),
        "grid_threads": int(first["Grid_Size"]),
        "profiler_timestamps_valid": timestamps_valid,
        "counters": metrics,
    }


def loop_evidence(path):
    """Record one actual backedge region; instruction order is not a cycle timeline."""
    lines = path.read_text().splitlines()
    labels = {
        line.split(":")[0]: index
        for index, line in enumerate(lines)
        if re.match(r"^\.LBB\d+_\d+:", line)
    }
    loops = []
    for end, line in enumerate(lines):
        match = re.search(r"s_cbranch_\w+\s+(\.LBB\d+_\d+)", line)
        if match and match[1] in labels and labels[match[1]] < end:
            begin = labels[match[1]]
            region = lines[begin : end + 1]
            if any("global_load_b128" in item for item in region) and any(
                "v_wmma_" in item for item in region
            ):
                loops.append((begin, end))
    if len(loops) != 1:
        raise RuntimeError(f"Expected one main loop in {path}; got {len(loops)}")
    begin, end = loops[0]
    global_loads = [
        i + 1 for i in range(begin, end + 1) if "global_load_b128" in lines[i]
    ]
    wmma = [i + 1 for i in range(begin, end + 1) if "v_wmma_" in lines[i]]
    vmem_waits = [
        i + 1
        for i in range(begin, end + 1)
        if re.search(r"s_waitcnt.*vmcnt\(", lines[i])
    ]
    stores = [i + 1 for i in range(begin, end + 1) if "ds_store_b128" in lines[i]]
    selected = [
        f"{i + 1}: {lines[i].strip()}"
        for i in range(begin, end + 1)
        if re.search(
            r"global_load_b128|ds_store_b128|ds_load_b128|v_wmma_|s_barrier|s_waitcnt.*vmcnt\(",
            lines[i],
        )
    ]
    opportunity = (
        len(global_loads) == 8
        and len(wmma) == 16
        and bool(vmem_waits)
        and max(global_loads) < min(wmma)
        and min(vmem_waits) > max(wmma)
        and max(vmem_waits) < min(stores)
    )
    return {
        "loop_start_line": begin + 1,
        "loop_end_line": end + 1,
        "global_load_lines": global_loads,
        "wmma_lines": wmma,
        "vmem_wait_lines": vmem_waits,
        "lds_store_lines": stores,
        "vmem_wait_after_wmma": opportunity,
        "excerpt": "\n".join(selected) + "\n",
    }


def collect(output, timing, repeats, implementation="solution.py"):
    profiler = shutil.which("rocprofv3")
    if profiler is None:
        raise SystemExit(
            "rocprofv3 is required; run through the pinned Pixi environment"
        )
    output.mkdir(parents=True, exist_ok=True)
    profiler_version = subprocess.check_output([profiler, "--version"], text=True)
    (output / "profiler-version.txt").write_text(profiler_version)
    available = subprocess.check_output([profiler, "--list-avail"], text=True)
    (output / "available-counters.txt").write_text(available)
    for counter in COUNTERS:
        if counter not in available:
            raise SystemExit(f"Counter unavailable on this GPU: {counter}")
    results = {}
    commands = {}
    for mode in MODES:
        destination = output / mode
        if destination.exists():
            raise SystemExit(
                f"Use a fresh output directory; {destination} already exists"
            )
        command = [
            profiler,
            "--pmc",
            *COUNTERS,
            "--kernel-include-regex",
            "_matmul_bf16",
            "-d",
            str(destination),
            "-o",
            mode,
            "--output-format",
            "csv",
            "--",
            sys.executable,
            str(Path(__file__).resolve()),
            "--worker",
            mode,
            "--implementation",
            implementation,
        ]
        commands[mode] = command
        # Dump each compiled variant's ISA separately for instruction inspection.
        environment = {
            **os.environ,
            "FLYDSL_DUMP_IR": "1",
            "FLYDSL_DUMP_DIR": str(destination / "assembly"),
        }
        completed = subprocess.run(
            command, check=False, env=environment, capture_output=True, text=True
        )
        (output / f"{mode}-stdout.txt").write_text(completed.stdout)
        (output / f"{mode}-stderr.txt").write_text(completed.stderr)
        if completed.returncode:
            raise RuntimeError(
                f"Profiling {mode} failed; inspect {output / f'{mode}-stderr.txt'}"
            )
        results[mode] = summarize(destination / f"{mode}_counter_collection.csv")
        assembly = list((destination / "assembly").rglob("*final_isa.s"))
        if len(assembly) != 1:
            raise RuntimeError(
                f"Expected one final ISA file for {mode}; got {len(assembly)}"
            )
        origin = assembly[0].parent / "00_origin.mlir"
        if "(1024,1024):(1024,1)" not in origin.read_text():
            raise RuntimeError("ISA dump was overwritten by a boundary specialization")
        instructions = Counter(
            re.findall(
                r"\b(?:ds_(?:load|store)\w*|global_load_b128|v_wmma\w*)\b",
                assembly[0].read_text(),
            )
        )
        results[mode]["isa_instruction_counts"] = dict(sorted(instructions.items()))
        evidence = loop_evidence(assembly[0])
        results[mode]["loop_order"] = evidence
        (destination / "loop-order.txt").write_text(evidence["excerpt"])
        if mode == "prefetch" and not evidence["vmem_wait_after_wmma"]:
            raise RuntimeError(
                "Prefetch VMEM waits before WMMA on this compiler; inspect ISA"
            )
        print(mode, json.dumps(results[mode]), flush=True)
    # These launches run after profiler subprocesses exit, without counter instrumentation.
    module = runpy.run_path(str(HERE / implementation))
    benchmark = runpy.run_path(str(ROOT / "examples/matmul_benchmark.py"))
    kernels = {mode: partial(module["matmul_bf16"], schedule=mode) for mode in MODES}
    metadata, timings = benchmark["comparison"](kernels, timing, repeats)
    report = {
        "source_sha256": {
            name: hashlib.sha256((HERE / name).read_bytes()).hexdigest()
            for name in (implementation, "profile.py")
        },
        "gpu": torch.cuda.get_device_name(),
        "architecture": torch.cuda.get_device_properties(0).gcnArchName,
        "flydsl": version("flydsl"),
        "torch": torch.__version__,
        "rocm": torch.version.hip,
        "kernel": platform.release(),
        "profiler_version": profiler_version,
        "implementation": implementation,
        "shape_MNK": [1024, 1024, 1024],
        "block_tile_MNK": [module["BLOCK_M"], module["BLOCK_N"], module["BLOCK_K"]],
        "mma_K": module["MMA_K"],
        "threads_per_block": module["THREADS_PER_BLOCK"],
        "method": "last five of ten full-workload dispatches: two checks, three warm-ups, five samples; three smaller boundary checks excluded",
        "commands": commands,
        "profiles": results,
        "timing_metadata": metadata,
        "timings": timings,
    }
    (output / "summary.json").write_text(json.dumps(report, indent=2) + "\n")
    print(f"Profile summary: {output / 'summary.json'}")
    print(json.dumps({"timing_metadata": metadata, "timings": timings}, indent=2))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    action = parser.add_mutually_exclusive_group(required=True)
    action.add_argument("--collect", action="store_true")
    action.add_argument("--worker", choices=MODES, help=argparse.SUPPRESS)
    parser.add_argument(
        "--output", type=Path, default=Path("/tmp/flydsl-interleaved-profile")
    )
    parser.add_argument(
        "--timing", choices=("auto", "host", "gpu-event"), default="auto"
    )
    parser.add_argument("--repeats", type=int, default=20)
    parser.add_argument(
        "--implementation",
        choices=("solution.py", "practice.py"),
        default="solution.py",
        help="profile the worked solution or the current completed practice",
    )
    args = parser.parse_args()
    if args.repeats < 1:
        parser.error("--repeats must be positive")
    if args.worker:
        worker(args.worker, args.implementation)
    else:
        collect(args.output.resolve(), args.timing, args.repeats, args.implementation)


if __name__ == "__main__":
    main()
