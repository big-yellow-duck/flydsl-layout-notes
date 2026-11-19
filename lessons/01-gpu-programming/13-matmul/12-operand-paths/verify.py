"""Verify locked configurations, native paths, practice fidelity, and the course."""

import argparse
import ast
import hashlib
import inspect
import json
import re
import runpy
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]


def complete_practice(source=None, solution=None):
    source = (HERE / "practice.py").read_text() if source is None else source
    solution = (HERE / "solution.py").read_text() if solution is None else solution
    expressions = {
        "left_direct_plan": "fx.make_tiled_copy_A(left_direct_atom, mma).get_slice(compute_thread_id)",
        "left_current": "fx.slice(left_full_tiled, (None, None, None, 0, 0, inner_k))",
    }
    # Retained benchmark snapshots still contain the original practice TODOs.
    if "raise NotImplementedError" in source:
        for name, expression in expressions.items():
            pattern = rf'(?m)^([ ]*){name} = None\n\1if {name} is None:\n\1    raise NotImplementedError\("Fill in {name}\."\)'
            source, count = re.subn(
                pattern,
                lambda match, name=name, expression=expression: (
                    match[1] + name + " = " + expression
                ),
                source,
            )
            assert count == 1, name
    assert "raise NotImplementedError" not in source

    def normalized(text):
        tree = ast.parse(text)
        tree.body = tree.body[1:]
        return ast.dump(tree, include_attributes=False)

    assert normalized(source) == normalized(solution)
    return source


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--selection",
        type=Path,
        default=HERE / "results/prefetch-comparison-selection.json",
    )
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument(
        "--seeds", type=int, nargs="+", default=(2026112801, 2026112802, 2026112803)
    )
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output directory")
    args.output.mkdir(parents=True)
    selected = json.loads(args.selection.read_text())
    (args.output / "selection-source.json").write_text(
        json.dumps(selected, indent=2) + "\n"
    )
    native = runpy.run_path(str(HERE / "solution.py"))
    factory_hash = hashlib.sha256(
        inspect.getsource(native["_matmul_bf16"]._original_func).encode()
    ).hexdigest()
    print("Current kernel SHA256:", factory_hash, flush=True)
    historical_hash = runpy.run_path(str(HERE / "audit.py"))["factory_hash"](
        HERE / "results/prefetch-comparison/solution-source.txt"
    )
    for key, choice in selected["shapes"].items():
        # The locked choices retain the source hash of the original selection.
        assert choice["native_factory_sha256"] == historical_hash
        shape = tuple(map(int, key.split("x")))
        assert native["CONFIGS_BY_SHAPE"][shape] == native["Config"](**choice["config"])
    for name in (
        "solution",
        "practice",
        "tune",
        "prefetch-control",
        "ownership",
        "inspect_kernel",
        "verify",
    ):
        source = HERE / (
            "results/prefetch-control.json"
            if name == "prefetch-control"
            else f"{name}.py"
        )
        (args.output / f"{name}-source.txt").write_text(source.read_text())
    completed = complete_practice()
    (args.output / "completed-practice-source.txt").write_text(completed)

    def execute(label, command):
        print("START", label, flush=True)
        with (args.output / f"{label}.log").open("w") as log:
            result = subprocess.run(
                command, cwd=ROOT, stdout=log, stderr=subprocess.STDOUT, check=False
            )
        if result.returncode:
            raise RuntimeError(f"{label} failed: {args.output / (label + '.log')}")
        print("DONE", label, result.returncode, flush=True)

    for key, choice in selected["shapes"].items():
        for timing in ("graph-host", "direct-host"):
            execute(
                key + "-" + timing,
                [
                    sys.executable,
                    str(HERE / "tune.py"),
                    "--verify",
                    "--shape",
                    *key.split("x"),
                    "--config",
                    json.dumps(choice["config"]),
                    "--timing",
                    timing,
                    "--seeds",
                    *map(str, args.seeds),
                    "--output",
                    str(args.output / f"{key}-{timing}.json"),
                ],
            )
        execute(
            "inspect-" + key,
            [
                sys.executable,
                str(HERE / "inspect_kernel.py"),
                "--shape",
                *key.split("x"),
                "--config",
                json.dumps(choice["config"]),
                "--output",
                str(args.output / f"inspection-{key}"),
            ],
        )
    execute("ownership", [sys.executable, str(HERE / "ownership.py")])
    execute("ordinary-solution", [sys.executable, str(HERE / "solution.py")])
    practice_path = str(HERE / "practice.py")
    execute(
        "completed-practice-all",
        [
            sys.executable,
            "-c",
            f'import runpy; runpy.run_path({practice_path!r}, run_name="__main__", init_globals={{"_COURSE_CHECK_ONLY":True}})',
        ],
    )
    execute("completed-practice-cli", [sys.executable, practice_path])
    execute("course-check", ["pixi", "run", "gpu-check"])
    (args.output / "validation.json").write_text(
        json.dumps(
            {
                "current_kernel_sha256": factory_hash,
                "selection_factory_sha256": historical_hash,
                "selection": str(args.selection.resolve()),
                "seeds": args.seeds,
                "comparison": "operand_paths_vs_prefetch",
                "locked_selection_matches_retained_factory": True,
                "practice_AST_matches_solution": True,
                "native_and_completed_practice_shape_split_cases_each": 9,
                "all_commands_passed": True,
            },
            indent=2,
        )
        + "\n"
    )


if __name__ == "__main__":
    main()
