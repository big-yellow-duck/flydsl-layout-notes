"""Profile MXFP8, matched BF16, and Torch emulation with separate rocprofv3 passes."""

import argparse
import hashlib
import json
import runpy
import shutil
import subprocess
import sys
from dataclasses import asdict
from pathlib import Path

import solution as lesson
import torch
from tune import inputs, torch_decode

PATH = Path(__file__).resolve()
ROOT = PATH.parents[4]
_PROFILER = runpy.run_path(
    str(ROOT / "experiments/mxfp4-w4a16-optimization/profile_pipeline.py")
)
GROUPS = {
    "trace": (),
    "alu": ("SQ_WAVES_sum", "SQ_INSTS_VALU_sum", "SQ_INSTS_SALU_sum"),
    "memory": ("SQ_INSTS_LDS_sum", "SQ_INSTS_TEX_LOAD_sum", "SQ_INSTS_TEX_STORE_sum"),
    "waits": ("SQ_WAIT_INST_LDS_sum", "MeanOccupancyPerActiveCU", "OccupancyPercent"),
    "reads": _PROFILER["PROFILE_GROUPS"]["external-reads"],
}


def profile_worker(args):
    select = _PROFILER["_profiling_control"]
    select(False)
    torch.set_num_threads(1)
    shape = tuple(args.shape)
    quantized, a, b, storage, expected = inputs(shape, 5101)
    output = storage[:-16].view(*shape[:2])
    config = lesson.default_config(shape)
    matmul_bf16 = lesson._MXFP4["_EDGE_LOADS"]["matmul_bf16"]
    callbacks = (
        lambda: lesson.matmul_mxfp8(*quantized, out=output, config=config),
        lambda: matmul_bf16(a, b, out=output, config=config),
        lambda: torch.matmul(*torch_decode(*quantized), out=output),
    )

    def check(callback):
        output.fill_(float("nan"))
        callback()
        torch.cuda.synchronize()
        torch.testing.assert_close(output, expected, rtol=0.016, atol=0.03125)
        assert torch.all(storage[-16:] == -99).item()

    for callback in callbacks:
        for _ in range(10):
            callback()
        check(callback)

    select(True)
    for _ in range(args.samples):
        for callback in callbacks:
            callback()
            torch.cuda.synchronize()
    select(False)
    for callback in callbacks:
        check(callback)
    args.output.write_text(
        json.dumps(
            {
                "shape_MNK": shape,
                "config": asdict(config),
                "device": torch.cuda.get_device_name(),
                "architecture": torch.cuda.get_device_properties(0).gcnArchName,
                "torch": torch.__version__,
                "hip": torch.version.hip,
                "selected_calls_per_path": args.samples,
                "ordered_paths": [
                    "fused_mxfp8",
                    "matched_bf16",
                    "torch_mxfp8_emulation",
                ],
                "correctness": "CPU output and output guard passed before and after profiling",
            },
            indent=2,
        )
        + "\n"
    )


def collect(args):
    rocprof = shutil.which("rocprofv3")
    if not rocprof:
        raise RuntimeError("rocprofv3 is required in the pinned Pixi environment")
    args.output.mkdir(parents=True)
    available = subprocess.check_output([rocprof, "--list-avail"], text=True)
    summary = {
        "profiler": subprocess.check_output([rocprof, "--version"], text=True).strip(),
        "kernel_source_sha256": hashlib.sha256(
            PATH.with_name("solution.py").read_bytes()
        ).hexdigest(),
        "scope": "Per-dispatch instrumented traces and counters. GPU event graph timing is measured separately.",
        "profiles": {},
    }
    for label, counters in GROUPS.items():
        missing = [counter for counter in counters if counter not in available]
        if missing:
            raise RuntimeError(f"Unavailable profiler counters: {missing}")
        folder = args.output / label
        worker = args.output / f"{label}-worker.json"
        command = [
            rocprof,
            "--selected-regions",
            "-d",
            str(folder),
            "-o",
            label,
            "--output-format",
            "csv",
        ]
        command += ["--pmc", *counters] if counters else ["--kernel-trace"]
        command += [
            "--",
            sys.executable,
            str(PATH),
            "--worker",
            "--shape",
            *map(str, args.shape),
            "--samples",
            str(args.samples),
            "--output",
            str(worker),
        ]
        result = subprocess.run(command, capture_output=True, text=True, check=False)
        (args.output / f"{label}-stdout.txt").write_text(result.stdout)
        (args.output / f"{label}-stderr.txt").write_text(result.stderr)
        if result.returncode:
            raise RuntimeError(f"rocprofv3 {label} failed: {result.stderr[-3000:]}")
        summary["worker"] = json.loads(worker.read_text())
        if counters:
            csv = folder / f"{label}_counter_collection.csv"
            summary["profiles"][label] = _PROFILER["_summarize_counters"](csv, counters)
        else:
            csv = folder / f"{label}_kernel_trace.csv"
            trace = _PROFILER["_summarize_trace"](csv)
            dispatches = {
                int(row["Dispatch_Id"]): row for row in _PROFILER["_read_csv"](csv)
            }
            for kernel in trace.values():
                for sample in kernel["samples"]:
                    row = dispatches[sample["dispatch_id"]]
                    for prefix in ("Grid", "Workgroup"):
                        sample[f"{prefix.lower()}_size"] = [
                            int(row[f"{prefix}_Size_{axis}"]) for axis in "XYZ"
                        ]
                    sample["scratch_bytes"] = int(row["Scratch_Size"])
            summary["profiles"][label] = trace
        (args.output / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
        print(f"{label}: {len(summary['profiles'][label])} kernels", flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, default=(512, 512, 512))
    parser.add_argument("--samples", type=int, default=8)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--worker", action="store_true", help=argparse.SUPPRESS)
    args = parser.parse_args()
    if min(*args.shape, args.samples) <= 0:
        parser.error("Shape dimensions and sample count must be positive")
    args.output = args.output.resolve()
    if args.worker:
        profile_worker(args)
    else:
        collect(args)


if __name__ == "__main__":
    main()
