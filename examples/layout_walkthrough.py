"""Compile and run all six worked lessons on the GPU.

Run: pixi run python examples/layout_walkthrough.py
"""

import runpy
from pathlib import Path

import torch


def main():
    lessons = Path(__file__).resolve().parents[1] / "lessons"
    for solution in sorted(lessons.glob("*/solution.py")):
        print(f"{solution.parent.name}:", flush=True)
        runpy.run_path(str(solution), run_name="__main__")
    print(f"All six native FlyDSL lessons passed on {torch.cuda.get_device_name()}.")


if __name__ == "__main__":
    main()
