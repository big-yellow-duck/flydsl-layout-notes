"""Run locked held-out comparisons, boundary checks, and native inspection."""

import argparse
import hashlib
import inspect
import json
import runpy
import subprocess
import sys
from dataclasses import replace
from pathlib import Path

HERE = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--confirmation", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument(
        "--seeds", type=int, nargs="+", default=(2026112201, 2026112202, 2026112203)
    )
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output directory")
    args.output.mkdir(parents=True)
    selected = json.loads((args.confirmation / "selection.json").read_text())
    native = runpy.run_path(str(HERE / "kernel.py"))
    factory_hash = hashlib.sha256(
        inspect.getsource(native["build"].__wrapped__).encode()
    ).hexdigest()
    for key in selected["shapes"]:
        trained = json.loads((args.confirmation / f"{key}.json").read_text())
        assert trained["environment"]["kernel_build_sha256"] == factory_hash
    for name in (
        "kernel.py",
        "benchmark.py",
        "confirm.py",
        "inspect_kernel.py",
        "verify.py",
    ):
        (args.output / (name.replace(".py", "") + "-source.txt")).write_text(
            (HERE / name).read_text()
        )

    def execute(label, command):
        print("START", label, flush=True)
        with (args.output / (label + ".log")).open("w") as log:
            result = subprocess.run(
                command, stdout=log, stderr=subprocess.STDOUT, check=False
            )
        print("DONE", label, result.returncode, flush=True)
        if result.returncode:
            raise RuntimeError(f"{label} failed; see its log")

    for key, choice in selected["shapes"].items():
        shape = tuple(map(int, key.split("x")))
        config = native["Config"](**choice["config"])
        for timing in ("graph-host", "direct-host"):
            execute(
                key + "-" + timing,
                [
                    sys.executable,
                    str(HERE / "benchmark.py"),
                    "--verify",
                    "--shape",
                    *map(str, shape),
                    "--config",
                    json.dumps(choice["config"]),
                    "--bulk-config",
                    json.dumps(choice["bulk_control"]),
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
                *map(str, shape),
                "--config",
                json.dumps(choice["config"]),
                "--output",
                str(args.output / f"inspection-{key}"),
            ],
        )
        if shape[1] == 1024:
            bulk = replace(config, schedule="bulk", compiler_fence=False, issue_group=1)
            execute(
                "inspect-bulk-" + key,
                [
                    sys.executable,
                    str(HERE / "inspect_kernel.py"),
                    "--shape",
                    *map(str, shape),
                    "--config",
                    json.dumps(bulk.__dict__),
                    "--output",
                    str(args.output / f"inspection-bulk-{key}"),
                ],
            )
    execute(
        "all-shape-split-checks",
        [
            sys.executable,
            "-c",
            f'import runpy; runpy.run_path({str(HERE / "kernel.py")!r}, run_name="__main__", init_globals={{"_COURSE_CHECK_ONLY":True}})',
        ],
    )
    execute("ordinary-cli", [sys.executable, str(HERE / "kernel.py")])


if __name__ == "__main__":
    main()
