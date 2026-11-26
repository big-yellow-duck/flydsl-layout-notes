"""Collect matched traversal_group_m=1/grouped cache profiles from benchmark_group_m.py.

Instrumented counter timings are separate from the uninstrumented benchmark.
"""

import argparse
import hashlib
import json
import subprocess
import sys
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--benchmark-report", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--layouts", nargs="+", default=["2x1", "2x2"])
    parser.add_argument("--pairs", type=int, default=8)
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output directory")
    args.output.mkdir(parents=True)
    args.output = args.output.resolve()
    course = (
        Path(__file__).resolve().parents[1] / "lessons/01-gpu-programming/13-matmul"
    )
    worker = course / "09-split-k/profile.py"
    module = course / "12-operand-paths/solution.py"
    benchmark = json.loads(args.benchmark_report.read_text())
    summary = {
        "benchmark_report": str(args.benchmark_report),
        "benchmark_sha256": hashlib.sha256(
            args.benchmark_report.read_bytes()
        ).hexdigest(),
        "collector_sha256": hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        "shape_MNK": benchmark["shape_MNK"],
        "scope": (
            "Hold the tuned grouped geometry fixed; change only traversal_group_m. "
            "Separate rocprofv3 trace, L1, L2 and external-read passes, alternating "
            "native/Torch dispatches after 20 warmups. Full CPU-reference validation "
            "and sentinel/workspace checks before/after every pass. Aggregate cache "
            "counters include all kernel traffic, not operand-specific B hits."
        ),
        "profiles": {},
    }
    for layout in args.layouts:
        choices = benchmark["selections"][layout]
        if "tuned_grouped" not in choices:
            raise ValueError(f"{layout} has only one physical M row")
        for label in ("grouped_geometry_gm1", "tuned_grouped"):
            config = choices[label]
            name = f"{layout}-{label}"
            output = args.output / name
            command = [
                sys.executable,
                str(worker),
                "--collect",
                "--module",
                str(module),
                "--shape",
                *map(str, benchmark["shape_MNK"]),
                "--config-json",
                json.dumps(config),
                "--pairs",
                str(args.pairs),
                "--output",
                str(output),
                "--group",
                "l1-traffic",
                "--group",
                "l2",
                "--group",
                "external-reads",
            ]
            result = subprocess.run(
                command, capture_output=True, text=True, check=False
            )
            (args.output / f"{name}-stdout.txt").write_text(result.stdout)
            (args.output / f"{name}-stderr.txt").write_text(result.stderr)
            if result.returncode:
                raise RuntimeError(f"{name} failed: {result.stderr[-2000:]}")
            report = json.loads((output / "summary.json").read_text())
            counters = {
                key: value
                for group in report["profiles"].values()
                for key, value in group.get("median_counters", {})
                .get("native", {})
                .items()
            }
            hits, misses = counters["GL2C_HIT_sum"], counters["GL2C_MISS_sum"]
            dispatch = report["profiles"]["trace"]["samples"]["native"][0]
            summary["profiles"][name] = {
                "config": config,
                "command": command,
                "counters": counters,
                "resources": {
                    key: dispatch[key]
                    for key in (
                        "lds_bytes",
                        "vgprs",
                        "scratch_bytes",
                        "workgroup_threads",
                        "grid_threads",
                    )
                },
                "L2_lookup_hit_fraction_from_median_counts": hits / (hits + misses),
                "trace_median_us_instrumented": report["trace_median_us"],
            }
            (args.output / "summary.json").write_text(
                json.dumps(summary, indent=2) + "\n"
            )
            print(name, summary["profiles"][name], flush=True)


if __name__ == "__main__":
    main()
