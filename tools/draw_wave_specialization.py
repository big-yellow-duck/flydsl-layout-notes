"""Regenerate the archived wave-specialization research figures."""

import runpy
from pathlib import Path

if __name__ == "__main__":
    runpy.run_path(
        str(
            Path(__file__).resolve().parents[1]
            / "experiments/wave-specialization/draw_figures.py"
        ),
        run_name="__main__",
    )
