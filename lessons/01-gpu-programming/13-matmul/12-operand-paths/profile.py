"""Profile the locked M=32 kernel with A in registers or LDS."""

import argparse
import json
import runpy
import subprocess
import sys
from dataclasses import asdict, replace
from pathlib import Path

HERE = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--left-path", choices=("registers", "lds"), default="registers"
    )
    parser.add_argument("--pairs", type=int, default=8)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    native = runpy.run_path(str(HERE / "solution.py"))
    config = replace(
        native["CONFIGS_BY_SHAPE"][(32, 1024, 8192)],
        left_in_registers=args.left_path == "registers",
    )
    subprocess.run(
        [
            sys.executable,
            str(HERE.parent / "09-split-k/profile.py"),
            "--collect",
            "--module",
            str(HERE / "solution.py"),
            "--shape",
            "32",
            "1024",
            "8192",
            "--config-json",
            json.dumps(asdict(config)),
            "--pairs",
            str(args.pairs),
            "--output",
            str(args.output),
        ],
        check=True,
    )


if __name__ == "__main__":
    main()
