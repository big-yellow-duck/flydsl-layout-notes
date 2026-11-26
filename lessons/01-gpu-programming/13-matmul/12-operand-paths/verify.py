"""Verify the tutorial defaults, native paths, and completed practice."""

import argparse
import ast
import hashlib
import inspect
import json
import re
import runpy
import subprocess
import sys
from dataclasses import asdict
from pathlib import Path
from tempfile import NamedTemporaryFile

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]


def complete_practice(source=None, solution=None):
    source = (HERE / "practice.py").read_text() if source is None else source
    solution = (HERE / "solution.py").read_text() if solution is None else solution
    checker = runpy.run_path(str(ROOT / "tools/check_lesson_style.py"))
    source = checker["complete_practice"](source, solution)

    # Drop the guards for the AST comparison with the worked solution.
    source = re.sub(
        r'(?m)^([ ]*)if (\w+) is None:\n\1    raise NotImplementedError\("Fill in \2\."\)\n',
        "",
        source,
    )

    def normalized(text):
        tree = ast.parse(text)
        tree.body = tree.body[1:]
        return ast.dump(tree, include_attributes=False)

    assert normalized(source) == normalized(solution)
    return source


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument(
        "--seeds", type=int, nargs="+", default=(2026112801, 2026112802, 2026112803)
    )
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output directory")
    args.output.mkdir(parents=True)
    native = runpy.run_path(str(HERE / "solution.py"))
    factory_hash = hashlib.sha256(
        inspect.getsource(native["_matmul_bf16"]._original_func).encode()
    ).hexdigest()
    print("Current kernel SHA256:", factory_hash, flush=True)
    defaults = {shape: native["CONFIGS_BY_SHAPE"][shape] for shape in native["SHAPES"]}
    for shape, config in defaults.items():
        native["validate_config"](config, shape)
    for name in (
        "solution",
        "practice",
        "tune",
        "ownership",
        "inspect_kernel",
        "verify",
    ):
        (args.output / f"{name}-source.txt").write_text(
            (HERE / f"{name}.py").read_text()
        )
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

    for shape, config in defaults.items():
        dimensions = list(map(str, shape))
        key = "x".join(dimensions)
        for timing in ("graph-host", "direct-host"):
            execute(
                key + "-" + timing,
                [
                    sys.executable,
                    str(HERE / "tune.py"),
                    "--verify",
                    "--shape",
                    *dimensions,
                    "--config",
                    json.dumps(asdict(config)),
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
                *dimensions,
                "--config",
                json.dumps(asdict(config)),
                "--output",
                str(args.output / f"inspection-{key}"),
            ],
        )
    execute("ownership", [sys.executable, str(HERE / "ownership.py")])
    execute("ordinary-solution", [sys.executable, str(HERE / "solution.py")])
    with NamedTemporaryFile("w", suffix=".py", dir=HERE) as practice:
        practice.write(completed)
        practice.flush()
        execute(
            "completed-practice-all",
            [
                sys.executable,
                "-c",
                f'import runpy; runpy.run_path({practice.name!r}, run_name="__main__", init_globals={{"_COURSE_CHECK_ONLY":True}})',
            ],
        )
        execute(
            "completed-practice-cli", [sys.executable, practice.name, "--check-only"]
        )
    execute("course-check", ["pixi", "run", "gpu-check"])
    (args.output / "validation.json").write_text(
        json.dumps(
            {
                "current_kernel_sha256": factory_hash,
                "seeds": args.seeds,
                "comparison": "operand_paths_vs_prefetch",
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
