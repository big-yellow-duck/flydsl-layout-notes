"""Condense actual BLAS selection, binary resources, and profiled counters."""

import argparse
import json
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output path")
    report = {}
    for key in ("16x1024x8192", "32x1024x8192", "16x4096x8192"):
        binary = json.loads((args.input / f"torch-isa/{key}.json").read_text())
        profile = json.loads((args.input / f"profile-{key}/summary.json").read_text())
        mapping = binary["solution"]["sizeMapping"]
        metadata = binary["kernel_metadata"]
        report[key] = {
            "solution_index": binary["solution_index"],
            "logical_output_tile_MN": binary["logical_output_tile_MN"],
            "block_K": mapping["depthU"],
            "wave32_count_per_block": mapping["waveNum"],
            "prefetch_global": mapping["PrefetchGlobalRead"],
            "global_split_k": mapping["globalSplitU"],
            "local_split_k": mapping["LocalSplitU"],
            "stream_k": mapping["streamK"],
            "direct_to_register_A_B_library_axes": [
                mapping["DirectToVgprA"],
                mapping["DirectToVgprB"],
            ],
            "static_resources": {
                field: metadata["." + field]
                for field in (
                    "group_segment_fixed_size",
                    "private_segment_fixed_size",
                    "vgpr_count",
                    "sgpr_count",
                )
            },
            "instrumented_trace_median_us": profile["trace_median_us"],
            "median_counters": {
                name: row["median_counters"]
                for name, row in profile["profiles"].items()
                if "median_counters" in row
            },
            "scope": "Counters and instrumented durations describe separate collection passes, not uninstrumented performance verification.",
        }
    args.output.write_text(json.dumps(report, indent=2) + "\n")


if __name__ == "__main__":
    main()
