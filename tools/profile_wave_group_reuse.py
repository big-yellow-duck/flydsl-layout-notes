"""Profile the wave-group reuse experiment with separate rocprofv3 passes."""

import argparse
import hashlib
import json
import runpy
import shutil
import statistics
import subprocess
import sys
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--benchmark-report", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--pairs", type=int, default=8)
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output directory")
    args.output = args.output.resolve()
    args.output.mkdir(parents=True)
    course = (
        Path(__file__).resolve().parents[1] / "lessons/01-gpu-programming/13-matmul"
    )
    worker = course / "09-split-k/profile.py"
    module = course / "10a-synchronization-scope/solution.py"
    helper = runpy.run_path(str(worker))
    profiler = shutil.which("rocprofv3")
    if not profiler:
        raise RuntimeError("rocprofv3 is required")
    benchmark = json.loads(args.benchmark_report.read_text())
    configs = {
        name: row["configuration"] for name, row in benchmark["resources"].items()
    }
    configs["packed_n64_k16_lds_workgroup"] = {
        **configs["packed_n64_k16"],
        "sync_mode": "lds-workgroup",
    }
    metrics = args.output / "extra-counters.yaml"
    metrics.write_text(
        "rocprofiler-sdk:\n  counters-schema-version: 1\n  counters:\n"
        + "".join(
            f"  - name: {name}\n    description: Sum across hardware instances of {raw}\n"
            "    properties: []\n    definitions:\n"
            f"      - architectures: [gfx1151, gfx1152]\n        expression: reduce({raw},sum)\n"
            for name, raw in {
                "WaveReuseBarrierWait": "SQ_WAIT_BARRIER",
                "WaveReuseLGKMWait": "SQ_WAIT_CNT_LGKM",
                "WaveReuseVMWait": "SQ_WAIT_CNT_VMVS",
            }.items()
        )
    )
    base = [profiler, "--extra-counters", str(metrics)]
    available = subprocess.check_output([*base, "--list-avail"], text=True)
    (args.output / "available-counters.txt").write_text(available)
    (args.output / "profiler-version.txt").write_text(
        subprocess.check_output([profiler, "--version"], text=True)
    )
    groups = {
        "trace": (),
        "waits": (
            "WaveReuseBarrierWait",
            "WaveReuseLGKMWait",
            "WaveReuseVMWait",
            "SQ_WAVE_CYCLES_sum",
        ),
        "occupancy": ("SQ_WAVES_sum", "MeanOccupancyPerActiveCU", "OccupancyPercent"),
        "instructions": (
            "SQ_WAVES_sum",
            "SQ_INSTS_SALU_sum",
            "SQ_INSTS_LDS_sum",
            "SQ_INSTS_TEX_LOAD_sum",
        ),
        "lds": helper["GROUPS"]["lds"],
    }
    summary = {
        "benchmark_report": str(args.benchmark_report),
        "benchmark_report_sha256": hashlib.sha256(
            args.benchmark_report.read_bytes()
        ).hexdigest(),
        "collector_sha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        "scope": "Separate rocprofv3 trace/counter passes, 20 warmups, alternating native/Torch dispatches, CPU-reference validation before/after each pass. Counter and trace timing is instrumented; use separate host benchmarks for performance. Barrier counter units are unspecified by the installed SDK; report raw reduced values without converting to elapsed time.",
        "configurations": configs,
        "profiles": {},
    }
    for name, config in configs.items():
        directory = args.output / name
        directory.mkdir()
        reports = {}
        for group, counters in groups.items():
            if any(counter not in available for counter in counters):
                raise RuntimeError(f"Unavailable counter in {group}")
            worker_report = directory / f"{group}-worker.json"
            command = [
                *base,
                "--selected-regions",
                "-d",
                str(directory / group),
                "-o",
                group,
                "--output-format",
                "csv",
            ]
            command += ["--pmc", *counters] if counters else ["--kernel-trace"]
            command += [
                "--",
                sys.executable,
                str(worker),
                "--worker",
                "--module",
                str(module),
                "--shape",
                *map(str, benchmark["shape_MNK"]),
                "--config-json",
                json.dumps(config),
                "--pairs",
                str(args.pairs),
                "--output",
                str(worker_report),
            ]
            result = subprocess.run(
                command, capture_output=True, text=True, check=False
            )
            (directory / f"{group}-stdout.txt").write_text(result.stdout)
            (directory / f"{group}-stderr.txt").write_text(result.stderr)
            if result.returncode:
                raise RuntimeError(f"{name}/{group} failed: {result.stderr[-2000:]}")
            metadata = json.loads(worker_report.read_text())
            suffix = "counter_collection" if counters else "kernel_trace"
            samples = helper["parse_dispatches"](
                directory / group / f"{group}_{suffix}.csv",
                metadata["dispatch_sequence"],
                counters,
            )
            reports[group] = {
                "command": command,
                "worker": metadata,
                "samples": samples,
            }
            if counters:
                reports[group]["median_counters"] = {
                    label: {
                        counter: statistics.median(
                            row["counters"][counter]
                            for row in rows
                            if row["counters"][counter] is not None
                        )
                        if any(row["counters"][counter] is not None for row in rows)
                        else None
                        for counter in counters
                    }
                    for label, rows in samples.items()
                }
            else:
                reports[group]["median_us"] = {
                    label: statistics.median(row["duration_ns"] for row in rows) / 1000
                    if all(row["duration_ns"] > 0 for row in rows)
                    else None
                    for label, rows in samples.items()
                }
            summary["profiles"][name] = reports
            (args.output / "summary.json").write_text(
                json.dumps(summary, indent=2, allow_nan=False) + "\n"
            )
            print(
                name,
                group,
                reports[group].get("median_counters", reports[group].get("median_us")),
                flush=True,
            )


if __name__ == "__main__":
    main()
