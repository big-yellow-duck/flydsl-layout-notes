"""Reproduce correctness, practice, controlled timing and ISA checks for 10–10c."""

import argparse
import ast
import json
import runpy
import subprocess
import sys
import tempfile
from dataclasses import replace
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COURSE = ROOT / "lessons/01-gpu-programming/13-matmul"
FOLDERS = (
    "10-wave-local-tiles",
    "10a-synchronization-scope",
    "10b-cache-policy",
    "10c-k-unrolling",
    "12-operand-paths",
)


def completed_practice(folder):
    source = (folder / "practice.py").read_text()
    for item in json.loads((folder / "practice-expressions.json").read_text()):
        if item["unfinished"] in source:
            assert source.count(item["unfinished"]) == 1, folder
            source = source.replace(item["unfinished"], item["completed"], 1)
        else:
            # Learners may already have completed some or all expressions.
            assert source.count(item["completed"]) == 1, folder

    def normalized(text):
        tree = ast.parse(text)
        tree.body = tree.body[1:]
        return ast.dump(tree, include_attributes=False)

    assert normalized(source) == normalized((folder / "solution.py").read_text())
    return source


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output directory")
    args.output.mkdir(parents=True)
    checks = {}
    for helper in (
        Path(__file__),
        COURSE / "10-wave-local-tiles/measure.py",
        COURSE / "10-wave-local-tiles/kernel_inspection.py",
    ):
        (args.output / (helper.stem + "-source.txt")).write_text(helper.read_text())

    def execute(label, command, unfinished=False):
        print("START", label, flush=True)
        with (args.output / f"{label}.log").open("w") as log:
            result = subprocess.run(
                command, cwd=ROOT, stdout=log, stderr=subprocess.STDOUT, check=False
            )
        text = (args.output / f"{label}.log").read_text()
        if unfinished:
            assert (
                result.returncode != 0 and "Practice not finished: Fill in" in text
            ) or (result.returncode == 0 and "Exercise passed:" in text)
        elif result.returncode:
            raise RuntimeError(f"Failed {label}: {args.output / (label + '.log')}")
        checks[label] = "passed"
        print("DONE", label, flush=True)

    for name in FOLDERS:
        folder = COURSE / name
        for file in (
            "solution.py",
            "practice.py",
            "tune.py",
            "practice-expressions.json",
        ):
            (args.output / f"{name}-{file}.txt").write_text((folder / file).read_text())
        source = completed_practice(folder)
        (args.output / f"{name}-completed-practice.txt").write_text(source)
        execute(name + "-solution", [sys.executable, str(folder / "solution.py")])
        execute(
            name + "-starter",
            [sys.executable, str(folder / "practice.py"), "--check-only"],
            unfinished=True,
        )
        with tempfile.NamedTemporaryFile(
            mode="w", suffix=".py", prefix="_completed_practice_", dir=folder
        ) as temp:
            temp.write(source)
            temp.flush()
            execute(
                name + "-completed-all",
                [
                    sys.executable,
                    "-c",
                    f'import runpy;runpy.run_path({temp.name!r},run_name="__main__",init_globals={{"_COURSE_CHECK_ONLY":True}})',
                ],
            )
            execute(name + "-completed-cli", [sys.executable, temp.name])
        execute(
            name + "-benchmark",
            [
                sys.executable,
                str(folder / "tune.py"),
                "--output",
                str(args.output / f"{name}-comparison.json"),
            ],
        )
        # Verify every wide control at prologue, steady-state and drain boundaries.
        module = runpy.run_path(str(folder / "solution.py"))
        helper = runpy.run_path(str(COURSE / "10-wave-local-tiles/measure.py"))
        configs = {
            "selected": module["CONFIGS_BY_SHAPE"][(16, 4096, 8192)],
            **helper["variants"](
                module,
                module["CONFIGS_BY_SHAPE"][(16, 4096, 8192)],
                name.split("-", 1)[0],
            ),
        }
        configs["groups_2x2"] = replace(
            module["CONFIGS_BY_SHAPE"][(16, 4096, 8192)],
            block_m=16,
            waves_m=1,
            waves_n=1,
            wave_groups_m=2,
            wave_groups_n=2,
            group_m=2,
            split_k=4,
        )
        for label, config in configs.items():
            execute(
                name + "-inspect-" + label,
                [
                    sys.executable,
                    str(folder / "inspect_kernel.py"),
                    "--shape",
                    *map(
                        str,
                        (64, 256, 384) if label == "groups_2x2" else (16, 4096, 8192),
                    ),
                    "--config",
                    json.dumps(config.__dict__),
                    "--output",
                    str(args.output / (name + "-isa-" + label)),
                ],
            )
    execute("course-check", ["pixi", "run", "gpu-check"])

    execute(
        "grouped-2d-mapping",
        [sys.executable, str(ROOT / "tools/check_split_k_grouping.py")],
    )
    execute(
        "operand-m-tails",
        [
            sys.executable,
            str(ROOT / "tools/check_operand_m_tails.py"),
            "--output",
            str(args.output / "operand-m-tails.json"),
        ],
    )
    (args.output / "validation.json").write_text(
        json.dumps(
            {
                "checks": checks,
                "practice_AST_equivalent": True,
                "selected_shape_split_cases_per_lesson": 9,
                "explicit_block_then_group_operand_and_output_views": True,
                "active_solution_count": len(
                    list((ROOT / "lessons").rglob("solution.py"))
                ),
            },
            indent=2,
        )
        + "\n"
    )


if __name__ == "__main__":
    main()
