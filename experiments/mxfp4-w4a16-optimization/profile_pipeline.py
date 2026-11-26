"""Profile MXFP4 unpack and W4A16 matmul with ROCTx-selected rocprofv3 passes.

Example:
  pixi run python experiments/mxfp4-w4a16-optimization/profile_pipeline.py \
      --collect --shape 16 1024 8192 --output \
      experiments/mxfp4-w4a16-optimization/results/20261117-baseline-16x1024
"""

import argparse
import csv
import ctypes
import json
import math
import os
import runpy
import shutil
import statistics
import subprocess
import sys
from pathlib import Path

import flydsl  # noqa: F401 -- initialize FlyDSL LLVM before PyTorch
import torch

ROOT = Path(__file__).resolve().parents[2]
LESSON = (
    ROOT
    / "lessons/01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16/solution.py"
)
TUNING = (
    ROOT
    / "lessons/01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16/results/"
    "gfx1152-20261117-register-unpack/tuning.json"
)
FUSED_TUNING = Path(__file__).resolve().parent / "results/20261117-fused-tuning.json"
PROFILE_GROUPS = {
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
    "l1-traffic": (
        "GL1C_REQ_READ_sum",
        "GL1C_REQ_MISS_sum",
        "TCP_REQ_READ_sum",
        "TCP_REQ_MISS_sum",
    ),
    "external-reads": (
        "GL2C_EA_RDREQ_32B_sum",
        "GL2C_EA_RDREQ_64B_sum",
        "GL2C_EA_RDREQ_96B_sum",
        "GL2C_EA_RDREQ_128B_sum",
    ),
}


config_from_archive = runpy.run_path(
    str(ROOT / "tools/matmul_config_archive.py")
)["config_from_archive"]


def _profiling_control(enabled):
    library = ctypes.CDLL("librocprofiler-sdk-roctx.so")
    function = getattr(
        library, "roctxProfilerResume" if enabled else "roctxProfilerPause"
    )
    function.argtypes = [ctypes.c_uint64]
    function.restype = ctypes.c_int
    status = function(0)
    if status:
        raise RuntimeError(f"ROCTx profiler control failed: {status}")


def _inputs(module, shape, seed=20261117):
    m, n, k = shape
    generator = torch.Generator().manual_seed(seed)
    a_cpu = torch.randn((m, k), generator=generator).to(torch.bfloat16)
    b_cpu = torch.randn((k, n), generator=generator).to(torch.bfloat16)
    packed_cpu, scales_cpu, dense_cpu = module["quantize_mxfp4"](b_cpu)
    return (
        a_cpu.cuda(),
        packed_cpu.cuda(),
        scales_cpu.cuda(),
        dense_cpu.cuda(),
        a_cpu.float() @ dense_cpu.float(),
    )


def _callbacks(module, shape, config, data):
    m, n, k = shape
    a, packed, scales, dense, expected = data
    output = torch.empty((m, n), dtype=torch.bfloat16, device=a.device)
    stream = torch.cuda.current_stream(a.device)
    operand_paths = runpy.run_path(
        str(LESSON.parents[2] / "13-matmul/12-operand-paths/solution.py")
    )
    dense_config = operand_paths["Config"](**config.__dict__)

    def unpack():
        module["_launch_matmul_mxfp4_w4a16"](
            packed.view(torch.int32),
            scales.view(torch.int64),
            dense,
            k,
            n,
            True,
            stream=module["fx"].Stream(stream),
        )

    def gemm():
        operand_paths["matmul_bf16"](
            a, dense.view(k, n), out=output, config=dense_config, stream=stream
        )

    return {"unpack": unpack, "gemm": gemm, "pipeline": lambda: (unpack(), gemm())}, output, expected


def worker(args):
    _profiling_control(False)
    torch.set_grad_enabled(False)
    torch.set_num_threads(1)
    module = runpy.run_path(str(LESSON))
    shape = tuple(args.shape)
    data = _inputs(module, shape)
    if args.component == "fused" and FUSED_TUNING.exists():
        report = json.loads(FUSED_TUNING.read_text())
        selected = next(
            row for row in report["shapes"] if tuple(row["shape_MNK"]) == shape
        )
        config_values = selected["selected_config"]
    else:
        report = json.loads(TUNING.read_text())
        selected = next(
            row for row in report["shapes"] if tuple(row["shape_MNK"]) == shape
        )
        config_values = selected["final_comparison"]["config"]
    config = config_from_archive(module["Config"], config_values)
    callbacks, output, expected = _callbacks(module, shape, config, data)
    if args.component == "fused":
        fused_module = runpy.run_path(
            str(Path(__file__).resolve().with_name("fused_matmul.py"))
        )
        fused_config = fused_module["Config"].from_dict(config.__dict__)

        def callback():
            fused_module["matmul_mxfp4_fused"](
                data[0], data[1], data[2], out=output, config=fused_config
            )

    else:
        callback = callbacks[args.component]

    for _ in range(args.warmups):
        callback()
    torch.cuda.synchronize()
    torch.testing.assert_close(
        output.float(), expected.cuda(), rtol=0.016, atol=0.03125
    )

    sequence = []
    _profiling_control(True)
    for _ in range(args.pairs):
        if args.component == "pipeline":
            callbacks["unpack"]()
            torch.cuda.synchronize()
            sequence.append("unpack")
            callbacks["gemm"]()
            torch.cuda.synchronize()
            sequence.append("gemm")
        else:
            callback()
            torch.cuda.synchronize()
            sequence.append(args.component)
    _profiling_control(False)
    torch.testing.assert_close(
        output.float(), expected.cuda(), rtol=0.016, atol=0.03125
    )
    args.output.write_text(
        json.dumps(
            {
                "device": torch.cuda.get_device_name(0),
                "arch": torch.cuda.get_device_properties(0).gcnArchName,
                "torch": torch.__version__,
                "hip": torch.version.hip,
                "shape_MNK": shape,
                "component": args.component,
                "config": config.__dict__,
                "pairs": args.pairs,
                "warmups": args.warmups,
                "sequence": sequence,
                "correctness": "full CPU reference passed before and after selected profiling region",
            },
            indent=2,
        )
        + "\n"
    )


def _read_csv(path):
    with path.open() as stream:
        return list(csv.DictReader(stream))


def _summarize_trace(path):
    grouped = {}
    for row in _read_csv(path):
        grouped.setdefault(int(row["Dispatch_Id"]), []).append(row)
    samples = {}
    for dispatch_id, rows in sorted(grouped.items()):
        row = rows[0]
        name = row["Kernel_Name"]
        elapsed = int(row["End_Timestamp"]) - int(row["Start_Timestamp"])
        samples.setdefault(name, []).append(
            {
                "dispatch_id": dispatch_id,
                "duration_us": elapsed / 1000,
                "grid_size": row.get("Grid_Size"),
                "workgroup_size": row.get("Workgroup_Size"),
                "vgprs": row.get("VGPR_Count"),
                "lds_bytes": row.get("LDS_Block_Size"),
            }
        )
    return {
        name: {
            "dispatches": len(rows),
            "median_us": statistics.median(row["duration_us"] for row in rows),
            "samples": rows,
        }
        for name, rows in samples.items()
    }


def _summarize_counters(path, counters):
    grouped = {}
    for row in _read_csv(path):
        grouped.setdefault(int(row["Dispatch_Id"]), []).append(row)
    by_kernel = {}
    for rows in grouped.values():
        name = rows[0]["Kernel_Name"]
        values = {row["Counter_Name"]: float(row["Counter_Value"]) for row in rows}
        by_kernel.setdefault(name, []).append(values)
    summary = {}
    for name, rows in by_kernel.items():
        summary[name] = {
            counter: statistics.median(
                row[counter] for row in rows if counter in row and math.isfinite(row[counter])
            )
            if any(counter in row and math.isfinite(row[counter]) for row in rows)
            else None
            for counter in counters
        }
    return summary


def collect(args):
    profiler = shutil.which("rocprofv3")
    if not profiler:
        raise RuntimeError("rocprofv3 is required in the pinned Pixi environment")
    if args.output.exists():
        raise RuntimeError("Use a fresh results directory")
    args.output.mkdir(parents=True)
    version = subprocess.check_output([profiler, "--version"], text=True).strip()
    available = subprocess.check_output([profiler, "--list-avail"], text=True)
    (args.output / "profiler-version.txt").write_text(version + "\n")
    (args.output / "available-counters.txt").write_text(available)
    modes = {"trace": ()}
    if args.counters:
        modes.update(PROFILE_GROUPS)
    summary = {
        "version": version,
        "shape_MNK": args.shape,
        "component": args.component,
        "profiles": {},
        "scope": "ROCTx-selected kernel dispatches only. Instrumented traces/counters diagnose the kernels; use the existing CUDA-graph measurements for throughput.",
    }
    for mode, counters in modes.items():
        missing = [counter for counter in counters if counter not in available]
        if missing:
            raise RuntimeError(f"Profiler counters unavailable in {mode}: {missing}")
        output_dir = args.output / mode
        worker_json = args.output / f"{mode}-worker.json"
        command = [
            profiler,
            "--selected-regions",
            "-d",
            str(output_dir),
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
            "--shape",
            *map(str, args.shape),
            "--component",
            args.component,
            "--pairs",
            str(args.pairs),
            "--warmups",
            str(args.warmups),
            "--output",
            str(worker_json),
        ]
        result = subprocess.run(command, capture_output=True, text=True, check=False, env=os.environ.copy())
        (args.output / f"{mode}-stdout.txt").write_text(result.stdout)
        (args.output / f"{mode}-stderr.txt").write_text(result.stderr)
        if result.returncode:
            raise RuntimeError(f"rocprofv3 {mode} failed: {result.stderr[-3000:]}")
        worker_report = json.loads(worker_json.read_text())
        suffix = "counter_collection" if counters else "kernel_trace"
        csv_path = output_dir / f"{mode}_{suffix}.csv"
        if counters:
            report = _summarize_counters(csv_path, counters)
        else:
            report = _summarize_trace(csv_path)
        summary["profiles"][mode] = report
        summary["worker"] = worker_report
        (args.output / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
        print(mode, json.dumps(report, sort_keys=True), flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    action = parser.add_mutually_exclusive_group(required=True)
    action.add_argument("--collect", action="store_true")
    action.add_argument("--worker", action="store_true", help=argparse.SUPPRESS)
    parser.add_argument("--shape", type=int, nargs=3, default=(16, 1024, 8192))
    parser.add_argument(
        "--component", choices=("pipeline", "unpack", "gemm", "fused"), default="pipeline"
    )
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--pairs", type=int, default=8)
    parser.add_argument("--warmups", type=int, default=10)
    parser.add_argument("--counters", action="store_true")
    args = parser.parse_args()
    args.output = args.output.resolve()
    args.shape = tuple(args.shape)
    worker(args) if args.worker else collect(args)


if __name__ == "__main__":
    main()
