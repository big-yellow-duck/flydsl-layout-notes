"""Tune each fused NVFP4 lesson against its current shape defaults."""

import argparse
import hashlib
import inspect
import json
import runpy
from importlib.metadata import version
from pathlib import Path

import torch

HERE = Path(__file__).resolve().parent
STAGES = {
    "arithmetic": HERE / "03-fused-staging/solution.py",
    "lut": HERE / "04-lut-decode/solution.py",
    "scale-reuse": HERE / "05-scale-reuse/solution.py",
}
SHAPES = ((2, 9, 17), (16, 1024, 8192), (31, 1025, 8193), (512, 512, 512))
TUNING = runpy.run_path(str(HERE.parent / "tuning.py"))


def tune_stage(lesson, shape, beam, seeds=()):
    def make_case(seed):
        inputs = lesson["_random_inputs"](shape, seed)
        a, b_packed, b_scales, b_tensor_scale = inputs
        b = lesson["_reference_b"](b_packed, b_scales, b_tensor_scale, shape[2])
        expected = (a.float() @ b.float()).bfloat16()
        return TUNING["cuda_case"](
            inputs,
            expected,
            lesson["matmul_nvfp4_w4a16"],
            flip_operand=1,
            sign_mask=0x88,
        )

    return TUNING["tune"](
        shape,
        lesson["default_config"](shape),
        lesson["validate_config"],
        make_case,
        allow_direct_a=True,
        beam=beam,
        seeds=seeds,
    )


def transferred_configs(lesson, report):
    # The variants share tiling and staging. Transfer the leading geometries
    # from all A/B routes, then select afresh with this decoder and fresh inputs.
    candidates = [row for row in report["trials"] if "median_ms" in row]
    finalists = report["verified_median_ms"]
    picked = [row for row in candidates if row["name"] in finalists]
    for a_reg in (False, True):
        for b_reg in (False, True):
            route = [
                row
                for row in candidates
                if row["config"]["left_in_registers"] == a_reg
                and row["config"]["right_in_registers"] == b_reg
            ]
            if route:
                picked.append(min(route, key=lambda row: row["median_ms"]))
    return tuple(dict.fromkeys(lesson["Config"](**row["config"]) for row in picked))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", nargs=3, type=int, action="append")
    parser.add_argument("--stage", choices=STAGES, action="append")
    parser.add_argument(
        "--beam", type=int, default=1, help="Seeds per B route per refinement"
    )
    parser.add_argument(
        "--small-n", action="store_true", help="Include the Stage 16 small-N shapes"
    )
    parser.add_argument("--output", type=Path)
    parser.add_argument(
        "--independent",
        action="store_true",
        help="Run the full search for every selected decoder",
    )
    args = parser.parse_args()
    if args.beam < 1:
        parser.error("--beam must be positive")
    shapes = list(map(tuple, args.shape)) if args.shape else list(SHAPES)
    if args.small_n:
        shapes = list(dict.fromkeys([*shapes, *TUNING["SMALL_N_SHAPES"]]))
    if any(min(shape) < 1 for shape in shapes):
        parser.error("M, N and K must be positive")

    torch.set_num_threads(1)
    names = args.stage or ("scale-reuse", "lut", "arithmetic")
    stages = {name: runpy.run_path(str(STAGES[name])) for name in names}
    report = {
        "device": torch.cuda.get_device_name(0),
        "arch": torch.cuda.get_device_properties(0).gcnArchName,
        "flydsl": version("flydsl"),
        "torch": torch.__version__,
        "hip": torch.version.hip,
        "beam": args.beam,
        "independent": args.independent,
        "timing": "GPU event time per GEMM across shuffled graph replay batches",
        "native_kernel_sha256": {
            name: hashlib.sha256(
                inspect.getsource(lesson["_matmul_nvfp4_w4a16"]._original_func).encode()
            ).hexdigest()
            for name, lesson in stages.items()
        },
        "cases": [],
    }
    for shape in shapes:
        primary = None
        for name, lesson in stages.items():
            print("Tuning", name, shape, flush=True)
            seeds = ()
            if not args.independent:
                if primary is not None:
                    seeds = transferred_configs(lesson, primary)
                elif shape in TUNING["SMALL_N_SHAPES"] and len(stages) > 1:
                    stage_name = "reuse" if name == "scale-reuse" else name
                    seeds = TUNING["small_n_configs"](
                        lesson["Config"],
                        shape,
                        f"nvfp4-{stage_name}",
                        allow_direct_a=True,
                    )
            row = tune_stage(lesson, shape, args.beam, seeds)
            if primary is None:
                primary = row
                if seeds:
                    row["search"] = "Stage 16 small-N candidates with A-route controls"
            report["cases"].append({"stage": name, **row})
            print(
                name,
                shape,
                row["selected_config_name"],
                row["verified_median_ms"],
                flush=True,
            )
            if args.output:
                args.output.parent.mkdir(parents=True, exist_ok=True)
                temporary = args.output.with_suffix(".tmp")
                temporary.write_text(json.dumps(report, indent=2) + "\n")
                temporary.replace(args.output)


if __name__ == "__main__":
    main()
