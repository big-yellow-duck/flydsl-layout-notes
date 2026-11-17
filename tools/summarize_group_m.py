"""Summarize locked held-out group_m comparisons without selecting on test data."""

import argparse
import json
import statistics
from pathlib import Path


def summarize(report):
    anchor = report["measurement_anchor"]

    def label(alias):
        name = report["aliases"][alias]
        return "operand_paths" if name == anchor else name

    rows = []
    for layout, choices in report["selections"].items():
        for timing in report["median_ms"]:
            runs = [r for r in report["verification"] if r["timing"] == timing]
            ungrouped = label(f"{layout}/tuned_gm1")
            row = {
                "shape_MNK": report["shape_MNK"],
                "layout": layout,
                "timing": timing,
                "gm1_config": choices["tuned_gm1"],
                "gm1_us": 1000 * report["median_ms"][timing][ungrouped],
                "torch_us": 1000 * report["median_ms"][timing]["torch"],
                "seeds": [r["seed"] for r in runs],
            }
            if "tuned_grouped" in choices:
                grouped = label(f"{layout}/tuned_grouped")
                row["grouped_config"] = choices["tuned_grouped"]
                row["grouped_us"] = 1000 * report["median_ms"][timing][grouped]
                pairs = {"retuned": (ungrouped, grouped)}
                if "grouped_geometry_gm1" in choices:
                    pairs["matched_grouped_geometry"] = (
                        label(f"{layout}/grouped_geometry_gm1"),
                        grouped,
                    )
                    pairs["matched_gm1_geometry"] = (
                        ungrouped,
                        label(f"{layout}/gm1_geometry_grouped"),
                    )
                for name, (first, second) in pairs.items():
                    seed_ratios = [
                        statistics.median(
                            b / a
                            for a, b in zip(
                                r["samples_ms"][first],
                                r["samples_ms"][second],
                                strict=True,
                            )
                        )
                        for r in runs
                    ]
                    row[name] = {
                        "grouped_over_gm1_per_seed": seed_ratios,
                        "median_grouped_over_gm1": statistics.median(seed_ratios),
                        "time_reduction_percent": 100
                        * (1 - statistics.median(seed_ratios)),
                        "seed_time_reduction_range_percent": [
                            100 * (1 - max(seed_ratios)),
                            100 * (1 - min(seed_ratios)),
                        ],
                    }
            rows.append(row)
    return rows


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--benchmark-directory", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output directory")
    reports = []
    for path in sorted(args.benchmark_directory.glob("*.json")):
        report = json.loads(path.read_text())
        if "median_ms" not in report:
            raise ValueError(f"Incomplete verification: {path}")
        reports.append(report)
    if not reports:
        raise ValueError("No benchmark reports found")
    args.output.mkdir(parents=True)
    rows = [row for report in reports for row in summarize(report)]
    (args.output / "comparisons.json").write_text(json.dumps(rows, indent=2) + "\n")
    (args.output / "locked-configurations.json").write_text(
        json.dumps(
            {"x".join(map(str, r["shape_MNK"])): r["selections"] for r in reports},
            indent=2,
        )
        + "\n"
    )
    lines = []
    for timing in ("graph-host", "direct-host"):
        lines += [
            f"## {timing}",
            "",
            "Positive reduction means grouped traversal is faster. All times are µs.",
            "",
            "| M,N,K | Wave packing | Selected group_m | Tuned gm1 | Tuned grouped | Retuned reduction | Matched reduction | Matched seed range |",
            "| --- | --- | ---: | ---: | ---: | ---: | ---: | --- |",
        ]
        for row in rows:
            if row["timing"] != timing:
                continue
            shape = ",".join(map(str, row["shape_MNK"]))
            prefix = f"| {shape} | {row['layout']} |"
            if "grouped_us" not in row:
                lines.append(
                    f"{prefix} 1 (one physical row) | {row['gm1_us']:.2f} | — | — | — | — |"
                )
                continue
            matched = row.get("matched_grouped_geometry", row["retuned"])
            lo, hi = matched["seed_time_reduction_range_percent"]
            lines.append(
                f"{prefix} {row['grouped_config']['group_m']} | {row['gm1_us']:.2f} | "
                f"{row['grouped_us']:.2f} | {row['retuned']['time_reduction_percent']:+.1f}% | "
                f"{matched['time_reduction_percent']:+.1f}% | {lo:+.1f} to {hi:+.1f}% |"
            )
        lines.append("")
    (args.output / "tables.md").write_text("\n".join(lines))
    print("\n".join(lines))


if __name__ == "__main__":
    main()
