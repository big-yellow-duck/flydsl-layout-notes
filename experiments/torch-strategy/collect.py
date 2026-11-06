"""Collect fresh Torch/native counter profiles and separate BLAS-selection logs."""

import argparse
import os
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
COURSE = ROOT / "lessons/01-gpu-programming/13-matmul"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    output = args.output.resolve()
    if output.exists():
        parser.error("Use a fresh output directory")
    output.mkdir(parents=True)
    for shape in ((16, 1024, 8192), (32, 1024, 8192), (16, 4096, 8192)):
        key = "x".join(map(str, shape))
        command = [
            sys.executable,
            str(HERE / "torch_call.py"),
            "--shape",
            *map(str, shape),
            "--output",
            str(output / f"torch-call-{key}.json"),
        ]
        print("START BLAS LOG", key, flush=True)
        with (output / f"torch-call-{key}-stdout.log").open("w") as log:
            subprocess.run(
                command,
                stdout=log,
                stderr=subprocess.STDOUT,
                check=True,
                env={
                    **os.environ,
                    "HIPBLASLT_LOG_MASK": "42",
                    "HIPBLASLT_LOG_FILE": str(output / f"hipblaslt-{key}.log"),
                },
            )
        print("START PROFILE", key, flush=True)
        command = [
            sys.executable,
            str(COURSE / "09-split-k/profile.py"),
            "--collect",
            "--module",
            str(ROOT / "experiments/wave-specialization/solution.py"),
            "--shape",
            *map(str, shape),
            "--pairs",
            "8",
            "--output",
            str(output / f"profile-{key}"),
        ]
        with (output / f"profile-{key}.log").open("w") as log:
            subprocess.run(command, stdout=log, stderr=subprocess.STDOUT, check=True)
        print("DONE", key, flush=True)


if __name__ == "__main__":
    main()
