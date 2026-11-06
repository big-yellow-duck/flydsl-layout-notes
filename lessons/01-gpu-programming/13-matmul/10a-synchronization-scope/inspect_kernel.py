"""Inspect this lesson's generated instructions and resource use."""

import runpy
from pathlib import Path

HERE = Path(__file__).resolve().parent
if __name__ == "__main__":
    runpy.run_path(str(HERE.parent / "10-wave-local-tiles/kernel_inspection.py"))[
        "main"
    ](HERE)
