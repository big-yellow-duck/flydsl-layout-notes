"""Tune and time fused MXFP8 against Torch MXFP8 emulation."""

import argparse
import hashlib
import inspect
import json
import runpy
from dataclasses import asdict
from importlib.metadata import version
from math import prod
from pathlib import Path

import solution as lesson
import torch

_BENCHMARK = runpy.run_path(str(Path(__file__).resolve().parents[1] / "benchmark.py"))
capture = _BENCHMARK["capture"]
measure = _BENCHMARK["measure"]
_TUNING = runpy.run_path(str(Path(__file__).resolve().parents[1] / "tuning.py"))
VERIFY_SEEDS = (5101, 5202, 5303)
TORCH_EMULATION = (
    "TorchInductor MXFP8 decode of A and B to BF16, followed by torch.matmul"
)


@torch.compile(fullgraph=True, dynamic=False)
def torch_decode(a, b, a_scales, b_scales):
    decoded_a = lesson.torch_dequantize_mxfp8(a.T, a_scales.T).T.contiguous()
    decoded_b = lesson.torch_dequantize_mxfp8(b, b_scales)
    return decoded_a, decoded_b


def inputs(shape, seed):
    m, n, _ = shape
    quantized, a, b, expected = lesson.make_inputs(shape, seed)
    gpu_inputs = tuple(tensor.cuda() for tensor in quantized)
    storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
    return gpu_inputs, a.cuda(), b.cuda(), storage, expected.cuda()


def verify(
    shape, configs, data, *, seed, graph_gemms, batches, replays, controls=False
):
    m, n, _ = shape
    quantized, a, b, storage, expected = data
    output = storage[:-16].view(m, n)

    # Flip A and B on alternating seeds to verify both decoded operands.
    operand = 0 if seed % 2 else 1

    def flip_operand():
        quantized[operand].bitwise_xor_(128)
        (a, b)[operand].neg_()

    def fused(config):
        return lambda: lesson.matmul_mxfp8(*quantized, out=output, config=config)

    callbacks = {name: fused(config) for name, config in configs.items()}
    if controls:
        callbacks["torch_mxfp8_emulation"] = lambda: torch.matmul(
            *torch_decode(*quantized), out=output
        )
        stage_15 = (
            Path(__file__).resolve().parents[2]
            / "13-matmul/15-edge-load-widths/solution.py"
        )
        bf16 = runpy.run_path(str(stage_15))["matmul_bf16"]
        callbacks["lesson_15_bf16"] = lambda: bf16(a, b, out=output)

    graphs = {
        name: capture(
            callback, flip_operand, output, storage[-16:], expected, graph_gemms
        )
        for name, callback in callbacks.items()
    }
    median_ms, samples, orders = measure(graphs, graph_gemms, batches, replays, seed)
    return {
        "seed": seed,
        "replay_modified_operand": ("A", "B")[operand],
        "gemms_per_graph": graph_gemms,
        "graph_replays_per_batch": replays,
        "batches": batches,
        "median_ms": median_ms,
        "effective_tflops": {
            name: 2 * prod(shape) / (ms * 1e9) for name, ms in median_ms.items()
        },
        "samples_ms": samples,
        "batch_orders": orders,
    }


def compare(shape, config=None):
    seed = 13
    if config is None:
        config = lesson.default_config(shape)
    return {
        "shape_MNK": shape,
        "config": asdict(config),
        "timing": "GPU event time per GEMM in a graph replay",
        "torch_emulation": TORCH_EMULATION,
        **verify(
            shape,
            {"fused_mxfp8": config},
            inputs(shape, seed),
            seed=seed,
            graph_gemms=32,
            batches=7,
            replays=10,
            controls=True,
        ),
    }


def verify_rounds(shape, configs):
    return [
        verify(
            shape,
            configs,
            inputs(shape, seed),
            seed=seed,
            graph_gemms=32,
            batches=7,
            replays=10,
            controls=True,
        )
        for seed in VERIFY_SEEDS
    ]


def make_tuning_case(shape, seed):
    quantized, _, _, expected = lesson.make_inputs(shape, seed)
    return _TUNING["cuda_case"](
        quantized, expected, lesson.matmul_mxfp8, flip_operand=seed % 2, sign_mask=128
    )


def tune_shape(shape, beam=1):
    warm_start = (
        _TUNING["small_n_configs"](lesson.Config, shape, "mxfp8", allow_direct_a=False)
        if shape in _TUNING["SMALL_N_SHAPES"]
        else ()
    )
    return _TUNING["tune"](
        shape,
        lesson.default_config(shape),
        lesson.validate_config,
        lambda seed: make_tuning_case(shape, seed),
        allow_direct_a=False,
        beam=beam,
        warm_start=warm_start,
    )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, action="append")
    parser.add_argument("--output", type=Path)
    parser.add_argument(
        "--beam", type=int, default=1, help="Seeds per B route per refinement"
    )
    parser.add_argument(
        "--small-n", action="store_true", help="Include the Stage 16 small-N shapes"
    )
    parser.add_argument(
        "--verify-only", action="store_true", help="Time the installed shape defaults"
    )
    args = parser.parse_args()
    if args.beam < 1:
        parser.error("--beam must be positive")
    torch.set_num_threads(1)
    shapes = [tuple(shape) for shape in args.shape] if args.shape else lesson.SHAPES
    if args.small_n:
        shapes = list(dict.fromkeys([*shapes, *_TUNING["SMALL_N_SHAPES"]]))
    result = {
        "device": torch.cuda.get_device_name(0),
        "arch": torch.cuda.get_device_properties(0).gcnArchName,
        "flydsl": version("flydsl"),
        "torch": torch.__version__,
        "hip": torch.version.hip,
        "timing": "GPU event time per GEMM across shuffled graph replay batches",
        "torch_emulation": TORCH_EMULATION,
        "beam": args.beam,
        "native_kernel_sha256": hashlib.sha256(
            inspect.getsource(lesson._matmul_mxfp8._original_func).encode()
        ).hexdigest(),
        "shapes": [],
    }
    for shape in shapes:
        if min(shape) <= 0:
            parser.error("M, N and K must be positive")
        if args.verify_only:
            print(f"Verifying {shape}", flush=True)
            config = lesson.default_config(shape)
            report = {
                "shape_MNK": shape,
                "selected_config": asdict(config),
                "selected_config_name": config.name,
                "selected_lane": "fused_mxfp8",
                "verification": verify_rounds(shape, {"fused_mxfp8": config}),
            }
        else:
            print(f"Tuning {shape}", flush=True)
            report = tune_shape(shape, args.beam)
        result["shapes"].append(report)
        print(f"{shape} {report['selected_config_name']}", flush=True)
        for row in report["verification"]:
            print(json.dumps(row["median_ms"]), flush=True)
        if args.output:
            args.output.parent.mkdir(parents=True, exist_ok=True)
            temporary = args.output.with_suffix(".tmp")
            temporary.write_text(json.dumps(result, indent=2) + "\n")
            temporary.replace(args.output)


if __name__ == "__main__":
    main()
