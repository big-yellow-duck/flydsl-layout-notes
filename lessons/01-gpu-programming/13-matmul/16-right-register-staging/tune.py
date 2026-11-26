"""Tune B LDS and B registers on identical small-N inputs."""

import argparse
import hashlib
import json
import runpy
import statistics
from dataclasses import asdict
from functools import partial
from importlib.metadata import version
from pathlib import Path

import torch

HERE = Path(__file__).resolve().parent
QUANTIZED = HERE.parents[1] / "14-quantized-matmul"
KERNELS = {
    "bf16": HERE / "solution.py",
    "mxfp4-scalar": QUANTIZED / "01-mxfp4-w4a16/02-scalar-dequant/solution.py",
    "mxfp4-arithmetic": QUANTIZED / "01-mxfp4-w4a16/03-fused-staging/solution.py",
    "mxfp4-lut": QUANTIZED / "01-mxfp4-w4a16/04-lut-decode/solution.py",
    "mxfp8": QUANTIZED / "02-mxfp8-blockscale/solution.py",
    "nvfp4-scalar": QUANTIZED / "03-nvfp4-w4a16/02-scalar-dequant/solution.py",
    "nvfp4-arithmetic": QUANTIZED / "03-nvfp4-w4a16/03-fused-staging/solution.py",
    "nvfp4-lut": QUANTIZED / "03-nvfp4-w4a16/04-lut-decode/solution.py",
    "nvfp4-reuse": QUANTIZED / "03-nvfp4-w4a16/05-scale-reuse/solution.py",
}
SHAPES = ((16, 1, 4096), (16, 7, 4097), (128, 16, 4096))
GRAPH_GEMMS = 16
VERIFY_SEEDS = (4101, 4202, 4303)
ROUTES = ("lds", "registers")


def make_case(name, modules, shape):
    m, n, k = shape
    generator = torch.Generator().manual_seed(4404)
    if name == "mxfp8":
        inputs, dense_a, dense_b, _ = modules[name]["make_inputs"](shape, 4404)
        flip_mask = 0x80
    elif name.startswith("nvfp4"):
        source = modules["nvfp4-reuse"]
        inputs = source["_random_inputs"](shape, 4404)
        dense_a, packed, scales, tensor_scale = inputs
        dense_b = source["_reference_b"](packed, scales, tensor_scale, k)
        flip_mask = 0x88
    else:
        dense_a = torch.randn((m, k), generator=generator).bfloat16()
        dense_b = torch.randn((k, n), generator=generator).bfloat16()
        if name == "bf16":
            inputs = (dense_a, dense_b)
            flip_mask = None
        else:
            packed, scales, dense_b = modules["mxfp4-lut"]["quantize_mxfp4"](dense_b)
            inputs = (dense_a, packed, scales)
            flip_mask = 0x88
    expected = (dense_a.float() @ dense_b.float()).bfloat16().cuda()
    tensors = tuple(tensor.cuda() for tensor in inputs)
    flip = tensors[1].neg_ if flip_mask is None else partial(tensors[1].bitwise_xor_, flip_mask)
    return tensors, expected, flip


def launch_for(name, modules, tensors, shape, output):
    module = modules[name]
    if name == "bf16":
        return partial(module["matmul_bf16"], *tensors, out=output), module
    if name == "mxfp8":
        return partial(module["matmul_mxfp8"], *tensors, out=output), module

    format_name = name.split("-")[0]
    if not name.endswith("-scalar"):
        kernel = module[f"matmul_{format_name}_w4a16"]
        return partial(kernel, *tensors, out=output), module

    a, *compressed_b = tensors
    _, n, k = shape
    b = torch.empty((k, n), device=a.device, dtype=torch.bfloat16)
    dequantize = module[f"dequantize_{format_name}"]
    dense = modules["bf16"]

    def launch(config):
        dequantize(*compressed_b, k, out=b)
        return dense["matmul_bf16"](a, b, out=output, config=config)

    return launch, dense


def candidates(shape, *, left_in_registers):
    _, n, k = shape
    tile_n = 16 if n <= 16 else 32
    split = 4 if k >= 1024 else 1
    secondary_split = 2 if split == 4 else 4
    # The first is the matched pair. Each row tests the same settings for both routes.
    geometry = (
        (16, tile_n, 32, split, 2),
        (16, tile_n, 16, split, 2),
        (16, tile_n, 64, split, 1),
        (16, tile_n, 32, secondary_split, 2),
        (32, tile_n, 32, split, 2),
    )
    for tile_m, tile_n, stage_k, split_k, unroll in geometry:
        yield {
            "group_tile_m": tile_m,
            "group_tile_n": tile_n,
            "waves_per_group_n": 1,
            "stage_k": stage_k,
            "split_k": split_k,
            "k_unroll": unroll,
            "left_in_registers": left_in_registers,
        }


def compare(name, modules, shared, shape):
    m, n, _ = shape
    inputs, expected, flip = make_case(name, modules, shape)
    storage = torch.full((m * n + 16,), -99, device="cuda", dtype=torch.bfloat16)
    c = storage[:-16].view(m, n)
    launch, config_module = launch_for(name, modules, inputs, shape, c)
    graphs, configs = {}, {}
    for index, geometry in enumerate(candidates(shape, left_in_registers=name != "mxfp8")):
        for route in ROUTES:
            config = config_module["Config"](**geometry, right_in_registers=route == "registers")
            config_module["validate_config"](config, shape)
            label = f"{route}-{index}"
            graphs[label] = shared["capture"](
                partial(launch, config=config), flip, c, storage[-16:], expected, GRAPH_GEMMS
            )
            configs[label] = {**asdict(config), "lds_bytes": config.lds_bytes}

    prelim, _, _ = shared["measure"](graphs, GRAPH_GEMMS, 5, 5, 4404)
    matched = {route: f"{route}-0" for route in ROUTES}
    finalists = {
        route: min((label for label in graphs if label.startswith(f"{route}-")), key=prelim.get)
        for route in ROUTES
    }
    verification_graphs = {label: graphs[label] for label in dict.fromkeys((*matched.values(), *finalists.values()))}
    rounds = []
    for seed in VERIFY_SEEDS:
        medians, samples, orders = shared["measure"](verification_graphs, GRAPH_GEMMS, 7, 8, seed)
        rounds.append({"seed": seed, "median_ms": medians, "samples_ms": samples, "batch_orders": orders})
    verified = {
        label: statistics.median(row["median_ms"][label] for row in rounds)
        for label in verification_graphs
    }
    return {
        "kernel": name,
        "shape_MNK": shape,
        "configs": configs,
        "screen_median_ms": prelim,
        "matched": matched,
        "finalists": finalists,
        "verified_median_ms": verified,
        "verification_rounds": rounds,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", nargs=3, type=int, action="append")
    parser.add_argument("--kernel", action="append", choices=KERNELS)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    shapes = tuple(map(tuple, args.shape)) if args.shape else SHAPES
    if any(min(shape) <= 0 for shape in shapes):
        parser.error("M, N, and K must be positive")

    torch.set_num_threads(1)
    modules = {name: runpy.run_path(str(path)) for name, path in KERNELS.items()}
    shared = runpy.run_path(str(QUANTIZED / "benchmark.py"))
    report = {
        "device": torch.cuda.get_device_name(0),
        "arch": torch.cuda.get_device_properties(0).gcnArchName,
        "flydsl": version("flydsl"),
        "torch": torch.__version__,
        "hip": torch.version.hip,
        "graph_gemms": GRAPH_GEMMS,
        "source_sha256": {
            name: hashlib.sha256(path.read_bytes()).hexdigest() for name, path in KERNELS.items()
        },
        "cases": [],
    }
    for shape in shapes:
        for name in args.kernel or KERNELS:
            result = compare(name, modules, shared, shape)
            report["cases"].append(result)
            us = {label: round(ms * 1000, 3) for label, ms in result["verified_median_ms"].items()}
            print(name, shape, us, result["finalists"], flush=True)
            if args.output:
                args.output.parent.mkdir(parents=True, exist_ok=True)
                args.output.write_text(json.dumps(report, indent=2) + "\n")


if __name__ == "__main__":
    main()
