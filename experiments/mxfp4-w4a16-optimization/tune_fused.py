"""Small fused-kernel configuration sweep kept outside the lesson."""

import argparse
import json
import random
import runpy
import statistics
from dataclasses import asdict, replace
from pathlib import Path

import flydsl  # noqa: F401 -- initialize FlyDSL LLVM before PyTorch
import torch

ROOT = Path(__file__).resolve().parents[2]
LESSON = ROOT / "lessons/01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16"
RESULTS = LESSON / "results/gfx1152-20261117-register-unpack/tuning.json"
FUSED = Path(__file__).resolve().with_name("fused_matmul.py")


def _measure(callback, *, batches, replays, graph_gemms, seed):
    for _ in range(3):
        callback()
    torch.cuda.synchronize()
    graph = torch.cuda.CUDAGraph()
    with torch.cuda.graph(graph):
        for _ in range(graph_gemms):
            callback()
    graph.replay()
    torch.cuda.synchronize()
    samples = []
    order = list(range(batches))
    random.Random(seed).shuffle(order)
    for _ in order:
        start = torch.cuda.Event(enable_timing=True)
        end = torch.cuda.Event(enable_timing=True)
        torch.cuda.synchronize()
        start.record()
        for _ in range(replays):
            graph.replay()
        end.record()
        end.synchronize()
        samples.append(start.elapsed_time(end) / (replays * graph_gemms))
    return statistics.median(samples), samples


def _configs(module, shape, base):
    candidates = [
        base,
        replace(base, k_unroll=4 if base.k_unroll != 4 else 2),
        replace(base, block_k=16 if base.block_k != 16 else 32),
        replace(base, split_k=1 if base.split_k != 1 else 2),
        replace(base, left_in_registers=not base.left_in_registers),
        replace(base, block_n=128),
    ]
    valid = []
    seen = set()
    for config in candidates:
        try:
            module["validate_config"](config, shape)
        except ValueError:
            continue
        key = tuple(sorted(asdict(config).items()))
        if key not in seen:
            seen.add(key)
            valid.append(config)
    return valid


def tune_shape(shape, *, batches, replays, graph_gemms):
    lesson = runpy.run_path(str(LESSON / "04-lut-decode/solution.py"))
    fused = runpy.run_path(str(FUSED))
    m, n, k = shape
    generator = torch.Generator().manual_seed(13)
    a_cpu = torch.randn((m, k), generator=generator).to(torch.bfloat16)
    b_cpu = torch.randn((k, n), generator=generator).to(torch.bfloat16)
    b_packed_cpu, b_scales_cpu, b_bf16_cpu = lesson["quantize_mxfp4"](b_cpu)
    a, b_packed, b_scales = a_cpu.cuda(), b_packed_cpu.cuda(), b_scales_cpu.cuda()
    expected = a_cpu.float() @ b_bf16_cpu.float()
    output = torch.empty((m, n), dtype=torch.bfloat16, device="cuda")
    old = json.loads(RESULTS.read_text())
    row = next(item for item in old["shapes"] if tuple(item["shape_MNK"]) == shape)
    base = fused["Config"].from_dict(row["final_comparison"]["config"])

    measurements = []
    for index, config in enumerate(_configs(fused, shape, base)):
        def callback(candidate=config):
            fused["matmul_mxfp4_fused"](
                a,
                b_packed,
                b_scales,
                out=output,
                config=fused["Config"](**candidate.__dict__),
            )

        callback()
        torch.cuda.synchronize()
        torch.testing.assert_close(
            output.float(), expected.cuda(), rtol=0.016, atol=0.03125
        )
        median, samples = _measure(
            callback,
            batches=batches,
            replays=replays,
            graph_gemms=graph_gemms,
            seed=131 + index,
        )
        measurements.append(
            {
                "config": asdict(config),
                "config_name": config.name,
                "median_ms": median,
                "samples_ms": samples,
                "correctness": "passed",
            }
        )
        print(shape, config.name, f"{median:.6f} ms", flush=True)
    selected = min(measurements, key=lambda row: row["median_ms"])
    return {
        "shape_MNK": shape,
        "candidate_count": len(measurements),
        "selected_config": selected["config"],
        "selected_config_name": selected["config_name"],
        "selected_median_ms": selected["median_ms"],
        "measurements": measurements,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, action="append")
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--batches", type=int, default=3)
    parser.add_argument("--replays", type=int, default=5)
    parser.add_argument("--graph-gemms", type=int, default=4)
    args = parser.parse_args()
    shapes = args.shape or [(16, 1024, 8192), (32, 1024, 8192), (16, 4096, 8192)]
    report = {
        "device": torch.cuda.get_device_name(0),
        "arch": torch.cuda.get_device_properties(0).gcnArchName,
        "torch": torch.__version__,
        "hip": torch.version.hip,
        "batches": args.batches,
        "graph_replays_per_batch": args.replays,
        "gemms_per_graph": args.graph_gemms,
        "shapes": [
            tune_shape(
                tuple(shape),
                batches=args.batches,
                replays=args.replays,
                graph_gemms=args.graph_gemms,
            )
            for shape in shapes
        ],
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
