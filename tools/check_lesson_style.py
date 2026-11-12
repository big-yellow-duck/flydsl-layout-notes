"""Check lesson structure, public GPU APIs, and temporary practice completions.

Run: pixi run python tools/check_lesson_style.py --gpu --practices \
    --output /tmp/lesson-style-check
"""

import argparse
import ast
import contextlib
import json
import runpy
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LESSONS = ROOT / "lessons"


def kernels(tree):
    return [
        node
        for node in ast.walk(tree)
        if isinstance(node, ast.FunctionDef)
        and any(
            ast.unparse(decorator) == "flyc.kernel" for decorator in node.decorator_list
        )
    ]


def unfinished(source):
    """Find actual guarded TODO assignments, excluding overwritten learner values."""
    found = []
    for kernel in kernels(ast.parse(source)):
        for parent in ast.walk(kernel):
            for _, statements in ast.iter_fields(parent):
                if not isinstance(statements, list):
                    continue
                for index, node in enumerate(statements[:-1]):
                    if (
                        isinstance(node, ast.Assign)
                        and isinstance(node.value, ast.Constant)
                        and node.value.value is None
                        and isinstance(statements[index + 1], ast.If)
                        and "NotImplementedError" in ast.unparse(statements[index + 1])
                    ):
                        found.append(node)
    return sorted(found, key=lambda node: node.lineno)


def complete_practice(source, solution):
    """Fill only guarded expressions in a temporary copy; keep learner code intact."""
    assignments = {}
    for kernel in kernels(ast.parse(solution)):
        for node in sorted(
            (node for node in ast.walk(kernel) if isinstance(node, ast.Assign)),
            key=lambda node: node.lineno,
        ):
            assignments.setdefault(ast.unparse(node.targets[0]), []).append(node.value)
    offsets = [0]
    for line in source.splitlines(keepends=True):
        offsets.append(offsets[-1] + len(line))
    counts, edits = {}, []
    for node in unfinished(source):
        name = ast.unparse(node.targets[0])
        index = counts.get(name, 0)
        counts[name] = index + 1
        expression = assignments[name][index]
        edits.append(
            (
                offsets[node.value.lineno - 1] + node.value.col_offset,
                offsets[node.value.end_lineno - 1] + node.value.end_col_offset,
                ast.unparse(expression),
            )
        )
    for start, stop, value in sorted(edits, reverse=True):
        source = source[:start] + value + source[stop:]
    return source


def structure():
    paths = sorted(
        path
        for path in LESSONS.rglob("*.py")
        if path.name in ("solution.py", "practice.py", "practice-4x4.py")
        and "results" not in path.parts
    )
    rows = []
    for path in paths:
        tree = ast.parse(path.read_text())
        kernel_nodes = kernels(tree)
        assert kernel_nodes and all(node in tree.body for node in kernel_nodes), path
        assert all(node.name.startswith("_") for node in kernel_nodes), path
        functions = {
            node.name: node for node in tree.body if isinstance(node, ast.FunctionDef)
        }
        assert (
            not {"run", "build", "launch_for", "make_workspace"} & functions.keys()
        ), path
        for kernel in kernel_nodes:
            operation = kernel.name[1:]
            assert operation in functions and "_launch_" + operation in functions, path
            assert not functions[operation].decorator_list, path
            bridge = functions["_launch_" + operation]
            assert any(ast.unparse(d) == "flyc.jit" for d in bridge.decorator_list), (
                path
            )
            assert any(
                isinstance(n, ast.Raise) for n in ast.walk(functions[operation])
            ), path
        rows.append(
            {
                "file": str(path.relative_to(ROOT)),
                "kernels": [n.name for n in kernel_nodes],
            }
        )
    print(f"Structure passed: {len(rows)} lesson programs", flush=True)
    return rows


def public_api_checks():
    import torch

    torch.set_num_threads(1)
    rows = []
    source_cases = {
        "01-logical": (32, torch.int32),
        "02-zipped": (32, torch.int32),
        "03-tiled": (32, torch.int32),
        "04-flat": (32, torch.int32),
        "06-select-block-tile": (32, torch.float32),
        "08-tiled-copy": (8, torch.float32),
        "09-register-fragments": (8, torch.float32),
        "10-predicates-and-tails": (19, torch.float32),
        "11-vector-addition": (19, torch.float32),
        "12-inspect-and-tune": (256, torch.float32),
    }
    for path in sorted(LESSONS.rglob("solution.py")):
        module = runpy.run_path(str(path))
        kernel = kernels(ast.parse(path.read_text()))[0]
        operation = kernel.name[1:]
        launch = module[operation]
        kwargs = {}
        if operation == "matmul_bf16":
            config = next(iter(module.get("CONFIGS_BY_SHAPE", {}).values()), None)
            m = config.block_m if config else module.get("BLOCK_M", 16)
            n = (
                config.block_n * getattr(config, "wave_groups", 1)
                if config
                else module.get("BLOCK_N", 16)
            )
            k = (
                config.block_k * getattr(config, "split_k", 1)
                if config
                else module.get("BLOCK_K", 16)
            )
            if config:
                kwargs["config"] = config
            a_cpu = ((torch.arange(m * k).reshape(m, k) % 5) - 2).bfloat16()
            b_cpu = ((torch.arange(k * n).reshape(k, n) % 7) - 3).bfloat16()
            a, b = a_cpu.cuda(), b_cpu.cuda()
            if module.get("RIGHT_LAYOUT") == "column-major":
                b = b.T.contiguous().T
            args = (a, b)
            reference = (a_cpu.float() @ b_cpu.float()).bfloat16()
        elif path.parent.name in source_cases:
            count, dtype = source_cases[path.parent.name]
            source = torch.arange(count, dtype=dtype, device="cuda")
            if operation in ("add_fragments", "vector_add"):
                args = (source, source * 2)
            else:
                args = (source,)
            reference = None
        else:
            args, reference = (), None
        result = launch(*args, **kwargs)
        out = torch.full_like(result, -99)
        assert launch(*args, out=out, **kwargs) is out, path
        torch.cuda.synchronize()
        torch.testing.assert_close(result, out, rtol=0, atol=0)
        if reference is not None:
            torch.testing.assert_close(result.cpu(), reference, rtol=0, atol=0.001)
        wrong = torch.empty_like(out, dtype=torch.float64)
        try:
            launch(*args, out=wrong, **kwargs)
        except (TypeError, ValueError):
            pass
        else:
            raise AssertionError(f"Invalid output dtype accepted: {path}")
        rows.append(
            {
                "file": str(path.relative_to(ROOT)),
                "operation": operation,
                "shape": list(result.shape),
            }
        )
        print("API passed:", path.parent.relative_to(LESSONS), flush=True)
    return rows


def practice_checks(output):
    rows = []
    for path in sorted(LESSONS.rglob("practice*.py")):
        if "results" in path.parts:
            continue
        source = path.read_text()
        holes = unfinished(source)
        runs = [("practice", source, bool(holes))]
        if holes:
            solution = path.with_name("solution.py").read_text()
            runs.append(("completed", complete_practice(source, solution), False))
        for kind, text, expects_unfinished in runs:
            relative = path.relative_to(ROOT)
            label = "-".join(relative.parts[1:]).replace(".py", "") + "-" + kind
            log = output / (label + ".log")
            with tempfile.NamedTemporaryFile(
                "w", prefix="_style_check_", suffix=".py", dir=path.parent
            ) as temp:
                temp.write(text)
                temp.flush()
                if expects_unfinished:
                    command = [sys.executable, temp.name]
                    if "13-matmul" in path.parts:
                        command.append("--check-only")
                else:
                    command = [
                        sys.executable,
                        "-c",
                        f'import runpy;runpy.run_path({temp.name!r},run_name="__main__",init_globals={{"_COURSE_CHECK_ONLY":True}})',
                    ]
                with log.open("w") as stream:
                    result = subprocess.run(
                        command,
                        cwd=ROOT,
                        stdout=stream,
                        stderr=subprocess.STDOUT,
                        timeout=180,
                        check=False,
                    )
            passed = (
                (result.returncode != 0 and "Practice not finished:" in log.read_text())
                if expects_unfinished
                else result.returncode == 0
            )
            rows.append(
                {
                    "file": str(relative),
                    "mode": kind,
                    "unfinished_expected": expects_unfinished,
                    "passed": passed,
                    "exit_code": result.returncode,
                    "log": log.name,
                }
            )
            print(
                "Practice passed:" if passed else "Practice FAILED:",
                relative,
                kind,
                flush=True,
            )
    assert all(row["passed"] for row in rows), "Inspect the practice logs"
    return rows


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--gpu", action="store_true", help="Check each public solution API on GPU"
    )
    parser.add_argument(
        "--practices",
        action="store_true",
        help="Check starters and temporary completions",
    )
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    with contextlib.ExitStack() as stack:
        output = args.output or Path(
            stack.enter_context(tempfile.TemporaryDirectory(prefix="lesson-style-"))
        )
        output.mkdir(parents=True, exist_ok=True)
        report = {"structure": structure()}
        if args.gpu:
            report["public_api"] = public_api_checks()
        if args.practices:
            report["practices"] = practice_checks(output)
        (output / "validation.json").write_text(json.dumps(report, indent=2) + "\n")
        print("Lesson style checks passed.", flush=True)


if __name__ == "__main__":
    main()
