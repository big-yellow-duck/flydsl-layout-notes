"""Plot matched group_m effects after M wave packing using Matplotlib.

Run in an environment with matplotlib; the benchmark environment is unchanged.
"""

import argparse
import json
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--comparisons", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    rows = json.loads(args.comparisons.read_text())
    shapes = sorted({tuple(r["shape_MNK"]) for r in rows})
    fig, axes = plt.subplots(1, 2, figsize=(13, 6.8), sharey=True, layout="constrained")
    colors = {"2x1": "#156b9a", "2x2": "#c25818"}
    for axis, metric, title in zip(
        axes,
        ("matched_grouped_geometry", "retuned"),
        ("Change only group_m", "Tune each traversal branch separately"),
        strict=True,
    ):
        for index, shape in enumerate(shapes):
            for layout, offset in (("2x1", -0.18), ("2x2", 0.18)):
                row = next(
                    r
                    for r in rows
                    if (
                        tuple(r["shape_MNK"]) == shape
                        and r["layout"] == layout
                        and r["timing"] == "graph-host"
                    )
                )
                y = index + offset
                if metric not in row:
                    axis.text(
                        0.5,
                        y,
                        "one physical M row",
                        va="center",
                        fontsize=8,
                        color="#626c76",
                    )
                    continue
                measured = row[metric]
                value = measured["time_reduction_percent"]
                lo, hi = measured["seed_time_reduction_range_percent"]
                axis.barh(
                    y,
                    value,
                    height=0.30,
                    color=colors[layout],
                    label=layout if index == 3 else None,
                )
                axis.errorbar(
                    value,
                    y,
                    xerr=[[max(0, value - lo)], [max(0, hi - value)]],
                    fmt="none",
                    color="#222222",
                    capsize=2,
                    linewidth=1,
                )
                axis.annotate(
                    f"{value:+.1f}%",
                    (max(value, hi) if value >= 0 else min(value, lo), y),
                    xytext=(5 if value >= 0 else -5, 0),
                    textcoords="offset points",
                    ha="left" if value >= 0 else "right",
                    va="center",
                    fontsize=8,
                )
        axis.axvline(0, color="#64748b", linewidth=0.8)
        axis.set_title(title, fontsize=12, pad=14)
        axis.set_xlabel("Graph time reduction from grouped traversal (%)")
        axis.grid(axis="x", alpha=0.18)
        axis.set_axisbelow(True)
        axis.margins(x=0.20)
        axis.set_ylim(len(shapes) - 0.5, -0.5)
        axis.spines[["top", "right", "left"]].set_visible(False)
    axes[0].set_yticks(
        range(len(shapes)), [" × ".join(map(str, shape)) for shape in shapes]
    )
    axes[0].set_ylabel("M × N × K")
    # Explicit legend handles also cover plots of a subset of shapes.
    handles = [plt.Rectangle((0, 0), 1, 1, color=colors[k]) for k in colors]
    axes[1].legend(
        handles,
        ["wave_groups = (2,1)", "wave_groups = (2,2)"],
        loc="upper right",
        fontsize=9,
    )
    fig.suptitle(
        "M wave packing can leave useful locality between physical blocks", fontsize=15
    )
    fig.supxlabel(
        "Radeon 8060S · BF16 · seeds 29/47/71 · whiskers: seed range, not confidence intervals",
        fontsize=9,
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    metadata = {
        "Title": "M grouping after M wave packing",
        "Description": (
            "Graph time reductions for wave packings (2,1) and (2,2). "
            "Left: fixed geometry with only group_m changed. Right: independently "
            "tuned traversal branches. Whiskers show the range across three seeds."
        ),
    }
    fig.savefig(args.output.with_suffix(".svg"), metadata=metadata)
    fig.savefig(args.output.with_suffix(".png"), dpi=160, metadata=metadata)
    plt.close(fig)


if __name__ == "__main__":
    main()
