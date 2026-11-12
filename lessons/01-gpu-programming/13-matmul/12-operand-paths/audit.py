"""Audit retained source hashes, search totals, verification and profile controls."""

import argparse
import ast
import hashlib
import json
import runpy
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
RESEARCH = ROOT / "experiments/torch-strategy"


def read(path):
    return json.loads(path.read_text())


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def factory_hash(path):
    source = path.read_text()
    function = next(
        node
        for node in ast.parse(source).body
        if isinstance(node, ast.FunctionDef) and node.name == "build"
    )
    start = min(
        [function.lineno] + [decorator.lineno for decorator in function.decorator_list]
    )
    return hashlib.sha256(
        "".join(
            source.splitlines(keepends=True)[start - 1 : function.end_lineno]
        ).encode()
    ).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output", type=Path, default=HERE / "results/prefetch-comparison/audit.json"
    )
    parser.add_argument(
        "--verification", type=Path, default=HERE / "results/prefetch-comparison"
    )
    args = parser.parse_args()
    verification = args.verification
    # Historical timings and profiler reports belong to their retained sources.
    factory = factory_hash(verification / "solution-source.txt")
    assert read(verification / "validation.json")["all_commands_passed"]
    complete_practice = runpy.run_path(str(HERE / "verify.py"))["complete_practice"]
    completed = complete_practice(
        (verification / "practice-source.txt").read_text(),
        (verification / "solution-source.txt").read_text(),
    )
    complete_practice()  # Independently verify the current public-API exercises.
    assert completed == (verification / "completed-practice-source.txt").read_text()
    manifest = read(RESEARCH / "results/native-sources/manifest.json")
    for entry in manifest.values():
        source = RESEARCH / entry["archive"]
        assert digest(source) == entry["source_sha256"]
        assert factory_hash(source) == entry["native_factory_sha256"]
    prototype_reports = 0
    for path in (RESEARCH / "results/20261106").glob("*.json"):
        report = read(path)
        if not isinstance(report, dict) or "native_factory_sha256" not in report:
            continue
        original_name = Path(report["module"]).name
        if original_name in manifest:
            assert (
                report["native_factory_sha256"]
                == manifest[original_name]["native_factory_sha256"]
            )
            assert (
                report["native_source_sha256"]
                == manifest[original_name]["source_sha256"]
            )
            prototype_reports += 1
    keys = ("16x1024x8192", "32x1024x8192", "16x4096x8192")
    totals = {}
    for phase in ("coarse", "refine", "further"):
        counts = {name: 0 for name in ("proposed", "measured", "pruned", "rejected")}
        for key in keys:
            data = read(RESEARCH / f"results/20261106/operand-{phase}-{key}.json")
            assert data["candidate_count"] == sum(
                len(data[field]) for field in ("ranking", "pruned", "rejected")
            )
            if phase != "coarse":
                assert data["native_factory_sha256"] == factory
            counts["proposed"] += data["candidate_count"]
            for field, target in (
                ("ranking", "measured"),
                ("pruned", "pruned"),
                ("rejected", "rejected"),
            ):
                counts[target] += len(data[field])
        totals[phase] = counts
    assert sum(row["measured"] for row in totals.values()) == 441
    assert sum(row["pruned"] for row in totals.values()) == 71
    assert sum(row["rejected"] for row in totals.values()) == 0
    choices = read(HERE / "results/prefetch-comparison-selection.json")["shapes"]
    control_path = HERE / "results/prefetch-control.json"
    controls = read(control_path)["shapes"]
    assert digest(control_path) == digest(verification / "prefetch-control-source.txt")
    assert (
        "11-wave-specialization" not in (verification / "tune-source.txt").read_text()
    )
    assert "wave_specialized" not in (verification / "tune-source.txt").read_text()
    graph_wins, direct_wins = 0, 0
    prefetch_comparisons = {}
    for key in keys:
        assert choices[key]["native_factory_sha256"] == factory
        for timing in ("graph-host", "direct-host"):
            report = read(verification / f"{key}-{timing}.json")
            assert report["config"] == choices[key]["config"]
            assert report["comparison"] == "operand_paths_vs_prefetch"
            assert report["environment"]["prefetch_selection_sha256"] == digest(
                control_path
            )
            assert report["environment"]["controls"]["prefetch"] == controls[key]
            assert set(report["median_ms"]) == {
                "operand_paths",
                "prefetch",
                "matched_prefetch",
                "torch",
            }
            assert report["environment"]["native_factory_sha256"] == factory
            assert len(report["rounds"]) == 9
            if timing == "graph-host":
                prefetch_comparisons[key] = {
                    name: report["comparisons"][name]
                    for name in ("prefetch", "matched_prefetch")
                }
                graph_wins += report["comparisons"]["torch"]["win_rounds"]
                for sample in report["rounds"]:
                    for graph in sample["graph_metadata"].values():
                        assert graph["nodes"] == graph["kernel_nodes"] == 32
                        assert graph["mutated_input_replay"] == "passed"
            else:
                direct_wins += report["comparisons"]["torch"]["win_rounds"]
        assert (
            read(verification / f"inspection-{key}/summary.json")["resources"][
                "private_segment_fixed_size"
            ]
            == 0
        )
    profiles = {}
    for label in ("registers", "lds"):
        profiles[label] = read(HERE / f"results/profile-A-{label}/summary.json")
    configs = [
        profiles[label]["profiles"]["trace"]["worker"]["config"]
        for label in ("registers", "lds")
    ]
    assert configs[0]["left_in_registers"] and not configs[1]["left_in_registers"]
    assert {k: v for k, v in configs[0].items() if k != "left_in_registers"} == {
        k: v for k, v in configs[1].items() if k != "left_in_registers"
    }
    original_torch = read(RESEARCH / "results/20261106/torch-isa/32x1024x8192.json")[
        "solution"
    ]["kernelName"]
    for report in profiles.values():
        assert {
            sample["kernel"]
            for sample in report["profiles"]["trace"]["samples"]["torch"]
        } == {original_torch}
    result = {
        "native_factory_sha256": factory,
        "historical_reports_audited_against_retained_sources": True,
        "current_completed_practice_AST_matches_solution": True,
        "completed_practice_AST_and_snapshot_match": True,
        "prototype_sources_verified": len(manifest),
        "prototype_report_hashes_verified": prototype_reports,
        "search_totals": totals,
        "graph_strict_Torch_win_rounds": graph_wins,
        "direct_strict_Torch_win_rounds": direct_wins,
        "no_wave_specialization_in_active_benchmark": True,
        "prefetch_comparisons": prefetch_comparisons,
        "same_geometry_A_path_profile_ablation": True,
        "Torch_profiled_symbol_matches_extracted_library_solution": True,
    }
    args.output.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
