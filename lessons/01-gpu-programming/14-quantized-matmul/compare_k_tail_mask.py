"""Compare K-tail masking against a Git revision at fixed launch settings."""

import argparse
import hashlib
import json
import runpy
import statistics
import subprocess
from dataclasses import asdict
from functools import partial
from importlib.metadata import version
from pathlib import Path
from tempfile import TemporaryDirectory

import torch
from benchmark import capture, measure

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
FORMATS = {"mxfp4": "01-mxfp4-w4a16", "nvfp4": "03-nvfp4-w4a16"}
STAGES = ("02-scalar-dequant", "03-fused-staging", "04-lut-decode", "05-scale-reuse")
SHAPES = (
    (2, 9, 17),
    (17, 77, 46),
    (16, 1024, 8192),
    (17, 1046, 8214),
    (31, 1025, 8193),
    (1030, 1046, 1022),
    (1024, 1024, 1024),
    (1024, 1024, 1025),
    (4096, 256, 1024),
    (4096, 256, 1025),
)
SEEDS = (5101, 5202, 5303)
GRAPH_GEMMS = 16
BATCHES = 7
REPLAYS = 12


def load_stages(format_name, revision, work_dir):
    stages = {}
    stage_paths = STAGES if format_name == "nvfp4" else STAGES[:-1]
    for stage in stage_paths:
        source = HERE / FORMATS[format_name] / stage / "solution.py"
        previous = work_dir / source.relative_to(HERE)
        previous.parent.mkdir(parents=True)
        previous.write_bytes(
            subprocess.check_output(
                ["git", "show", f"{revision}:{source.relative_to(ROOT)}"], cwd=ROOT
            )
        )
        stages[stage] = {
            name: runpy.run_path(str(path))
            for name, path in (("before", previous), ("after", source))
        }
    return stages


def padded_gpu(tensor, fill):
    storage = torch.full(
        (tensor.numel() + 16,), fill, dtype=tensor.dtype, device="cuda"
    )
    view = storage[:-16].view_as(tensor)
    view.copy_(tensor)
    return view


def inputs(format_name, reference, shape, seed):
    m, n, k = shape
    if format_name == "mxfp4":
        generator = torch.Generator().manual_seed(seed)
        a = torch.randn((m, k), generator=generator).bfloat16()
        weights = torch.randn((k, n), generator=generator).bfloat16()
        packed, scales, dense_b = reference["quantize_mxfp4"](weights)
        tensor_scale = ()
    else:
        a, packed, scales, multiplier = reference["_random_inputs"](shape, seed)
        dense_b = reference["_reference_b"](packed, scales, multiplier, k)
        tensor_scale = (multiplier.cuda(),)
    expected = (a.float() @ dense_b.float()).bfloat16().cuda()
    return (
        padded_gpu(a, float("nan")),
        padded_gpu(packed, 255),
        padded_gpu(scales, 255),
        tensor_scale,
        expected,
    )


def capture_round(format_name, stage, modules, dense_matmul, data, shape, seed):
    m, n, k = shape
    a, packed, scales, tensor_scale, expected = data
    storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
    output = storage[:-16].view(m, n)
    sentinel = storage[-16:]
    flip = partial(packed.bitwise_xor_, 0x88)
    graphs = {}

    if stage == STAGES[0]:
        config = dense_matmul["default_config"](shape)
        decoded = torch.empty((k, n), dtype=torch.bfloat16, device="cuda")
        threads = (
            modules["after"]
            .get("BLOCK_THREADS_BY_SHAPE", {})
            .get((k, n), modules["after"]["BLOCK_THREADS"])
        )

        def launch(decode):
            decode(packed, scales, *tensor_scale, k, out=decoded, block_threads=threads)
            dense_matmul["matmul_bf16"](a, decoded, config=config, out=output)

        settings = {"decode_threads": threads, "matmul": asdict(config)}
        callbacks = {
            name: partial(launch, module[f"dequantize_{format_name}"])
            for name, module in modules.items()
        }
    else:
        settings = asdict(modules["after"]["default_config"](shape))
        callbacks = {
            name: partial(
                module[f"matmul_{format_name}_w4a16"],
                a,
                packed,
                scales,
                *tensor_scale,
                config=module["Config"](**settings),
                out=output,
            )
            for name, module in modules.items()
        }

    for name, callback in callbacks.items():
        graph = capture(callback, flip, output, sentinel, expected, GRAPH_GEMMS)
        # Doubling the scale checks that replay sees the current scale tensor.
        if tensor_scale:
            scale = tensor_scale[0]
            scale.mul_(2)
        else:
            scale = scales
            scale.add_(1)
        try:
            output.fill_(float("nan"))
            graph.replay()
            torch.cuda.synchronize()
            torch.testing.assert_close(output, expected * 2, rtol=0.016, atol=0.03125)
            assert torch.all(sentinel == -99).item(), "Output sentinel changed"
        finally:
            if tensor_scale:
                scale.mul_(0.5)
            else:
                scale.sub_(1)
        graphs[name] = graph

    medians, samples, orders = measure(graphs, GRAPH_GEMMS, BATCHES, REPLAYS, seed)
    ratio = statistics.median(
        after / before
        for before, after in zip(samples["before"], samples["after"], strict=True)
    )
    return settings, {
        "seed": seed,
        "median_us": {name: value * 1000 for name, value in medians.items()},
        "paired_after_over_before": ratio,
        "samples_us": {
            name: [value * 1000 for value in times] for name, times in samples.items()
        },
        "batch_orders": orders,
    }


def compare_shape(format_name, stages, dense_matmul, shape):
    results = {stage: {"stage": stage, "rounds": []} for stage in stages}
    for seed in SEEDS:
        data = inputs(format_name, stages[STAGES[2]]["before"], shape, seed)
        for stage, pair in stages.items():
            settings, timings = capture_round(
                format_name, stage, pair, dense_matmul, data, shape, seed
            )
            results[stage]["settings"] = settings
            results[stage]["rounds"].append(timings)
    return {"shape_mnk": shape, "stages": list(results.values())}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--baseline", required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--format", choices=FORMATS, action="append")
    parser.add_argument("--shape", type=int, nargs=3, action="append")
    args = parser.parse_args()
    if any(min(shape) <= 0 for shape in args.shape or []):
        parser.error("all dimensions must be positive")
    revision = subprocess.check_output(
        ["git", "rev-parse", "--verify", f"{args.baseline}^{{commit}}"],
        cwd=ROOT,
        text=True,
    ).strip()
    torch.set_num_threads(1)
    dense_matmul = runpy.run_path(
        str(HERE.parent / "13-matmul/16-right-register-staging/solution.py")
    )
    report = {
        "baseline_commit": revision,
        "device": torch.cuda.get_device_name(0),
        "arch": torch.cuda.get_device_properties(0).gcnArchName,
        "flydsl": version("flydsl"),
        "rocm": version("rocm"),
        "torch": str(torch.__version__),
        "hip": torch.version.hip,
        "matmuls_per_graph": GRAPH_GEMMS,
        "batches_per_round": BATCHES,
        "replays_per_batch": REPLAYS,
        "formats": {},
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with TemporaryDirectory() as temp_dir:
        for format_name in dict.fromkeys(args.format or FORMATS):
            stages = load_stages(format_name, revision, Path(temp_dir))
            report["formats"][format_name] = {
                "source_sha256": {
                    stage: {
                        name: hashlib.sha256(
                            Path(module["__file__"]).read_bytes()
                        ).hexdigest()
                        for name, module in pair.items()
                    }
                    for stage, pair in stages.items()
                },
                "shapes": [],
            }
            for shape in map(tuple, args.shape or SHAPES):
                row = compare_shape(format_name, stages, dense_matmul, shape)
                report["formats"][format_name]["shapes"].append(row)
                args.output.write_text(json.dumps(report, indent=2) + "\n")
                for result in row["stages"]:
                    times = tuple(
                        round(
                            statistics.median(
                                r["median_us"][name] for r in result["rounds"]
                            ),
                            3,
                        )
                        for name in ("before", "after")
                    )
                    print(format_name, shape, result["stage"], *times, flush=True)


if __name__ == "__main__":
    main()
