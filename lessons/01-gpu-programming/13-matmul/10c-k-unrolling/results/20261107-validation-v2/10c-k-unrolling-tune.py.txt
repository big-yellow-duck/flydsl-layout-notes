"""Compare the single feature taught in lesson 10c."""

import runpy
from pathlib import Path

HERE = Path(__file__).resolve().parent
MODULE = runpy.run_path(str(HERE / "solution.py"))
HELPER = runpy.run_path(str(HERE.parent / "10-wave-local-tiles/measure.py"))


def compare(config, shape, timing="graph-host", launch_factory=None):
    return HELPER["compare"](MODULE, config, shape, "10c", timing, launch_factory)


if __name__ == "__main__":
    HELPER["main"](MODULE, HERE, "10c")
