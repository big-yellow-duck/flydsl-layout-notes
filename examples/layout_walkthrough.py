"""Compile and run all worked lessons and focused divide tutorials on the GPU.

Run: pixi run python examples/layout_walkthrough.py
"""

import runpy
from pathlib import Path

import torch


def main():
    lessons = Path(__file__).resolve().parents[1] / "lessons"
    solutions = sorted(lessons.rglob("solution.py"))
    for solution in solutions:
        print(f"{solution.parent.relative_to(lessons)}:", flush=True)
        # Matmul CLIs benchmark by default; the course suite requests correctness only.
        runpy.run_path(
            str(solution),
            run_name="__main__",
            init_globals={"_COURSE_CHECK_ONLY": True},
        )
    print(
        f"All {len(solutions)} native FlyDSL solutions passed on {torch.cuda.get_device_name()}."
    )


if __name__ == "__main__":
    main()
