"""Compare decoded-scale reuse with step 04 at fixed geometry."""

import argparse
import hashlib
import json
import runpy
from dataclasses import asdict
from functools import partial
from importlib.metadata import version
from pathlib import Path

import torch

HERE = Path(__file__).resolve().parent
STAGES = {
    "lut": HERE.parent / "04-lut-decode/solution.py",
    "scale_reuse": HERE / "solution.py",
}
SHAPES = ((2, 9, 17), (16, 1024, 8192), (31, 1025, 8193), (512, 512, 512))
SEEDS = (5101, 5202, 5303)


def compare(shape, modules, shared):
    m, n, k = shape
    baseline = modules["lut"]
    config = asdict(
        baseline["Config"](
            group_tile_n=64,
            stage_k=32,
            waves_per_group_n=1,
            split_k=4 if k >= 128 else 1,
            k_unroll=2,
        )
    )
    configs = {name: module["Config"](**config) for name, module in modules.items()}
    rounds = []
    for seed in SEEDS:
        if shape == baseline["TRACE_SHAPE"]:
            inputs = baseline["_trace_inputs"]()
        else:
            inputs = baseline["_random_inputs"](shape, seed)
        a_cpu, b_packed_cpu, b_scales_cpu, b_tensor_scale_cpu = inputs
        b = baseline["_reference_b"](b_packed_cpu, b_scales_cpu, b_tensor_scale_cpu, k)
        expected = (a_cpu.float() @ b.float()).bfloat16().cuda()
        a, b_packed, b_scales, b_tensor_scale = (tensor.cuda() for tensor in inputs)
        storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device=a.device)
        c = storage[:-16].view(m, n)

        flip_weights = partial(b_packed.bitwise_xor_, 0x88)
        graphs = {}
        for name, module in modules.items():
            launch = partial(
                module["matmul_nvfp4_w4a16"],
                a,
                b_packed,
                b_scales,
                b_tensor_scale,
                out=c,
                config=configs[name],
            )
            graphs[name] = shared["capture"](
                launch, flip_weights, c, storage[-16:], expected, 24
            )
        medians, samples, orders = shared["measure"](graphs, 24, 7, 8, seed)
        rounds.append(
            {
                "seed": seed,
                "median_ms": medians,
                "samples_ms": samples,
                "batch_orders": orders,
            }
        )
    return {"shape_MNK": shape, "config": config, "rounds": rounds}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, action="append")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    torch.set_num_threads(1)
    modules = {name: runpy.run_path(str(path)) for name, path in STAGES.items()}
    shared = runpy.run_path(str(HERE.parents[1] / "benchmark.py"))
    report = {
        "device": torch.cuda.get_device_name(0),
        "arch": torch.cuda.get_device_properties(0).gcnArchName,
        "flydsl": version("flydsl"),
        "torch": torch.__version__,
        "hip": torch.version.hip,
        "source_sha256": {
            name: hashlib.sha256(path.read_bytes()).hexdigest()
            for name, path in STAGES.items()
        },
        "matmuls_per_graph": 24,
        "batches_per_round": 7,
        "replays_per_batch": 8,
        "shapes": [],
    }
    for shape in map(tuple, args.shape or SHAPES):
        if min(shape) <= 0:
            parser.error("M, N, and K must be positive")
        row = compare(shape, modules, shared)
        report["shapes"].append(row)
        print(shape, [r["median_ms"] for r in row["rounds"]], flush=True)
        if args.output:
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(json.dumps(report, indent=2) + "\n")


if __name__ == "__main__":
    main()
