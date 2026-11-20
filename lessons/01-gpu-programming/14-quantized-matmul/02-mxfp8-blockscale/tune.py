"""Tune and time fused MXFP8 against Torch MXFP8 emulation."""

import argparse
import hashlib
import inspect
import json
import runpy
from dataclasses import asdict, replace
from importlib.metadata import version
from math import prod
from pathlib import Path

import solution as lesson
import torch

_BENCHMARK = runpy.run_path(str(Path(__file__).resolve().parents[1] / "benchmark.py"))
capture = _BENCHMARK["capture"]
measure = _BENCHMARK["measure"]
wins_each_round = _BENCHMARK["wins_each_round"]
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
        bf16 = lesson._MXFP4["_EDGE_LOADS"]["matmul_bf16"]
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


def tune_shape(shape):
    base = lesson.default_config(shape)
    data = inputs(shape, 17)
    trials = {}

    def evaluate(cfg):
        if cfg in trials:
            return
        row = trials[cfg] = {"config": asdict(cfg), "name": cfg.name}
        try:
            lesson.validate_config(cfg, shape)
        except ValueError as error:
            row["excluded"] = str(error)
            return
        timing = verify(
            shape,
            {"fused_mxfp8": cfg},
            data,
            seed=17,
            graph_gemms=4,
            batches=3,
            replays=5,
        )
        row["ms"] = timing["median_ms"]["fused_mxfp8"]
        row["samples_ms"] = timing["samples_ms"]["fused_mxfp8"]

    def ranked():
        return sorted(
            (cfg for cfg in trials if "ms" in trials[cfg]),
            key=lambda cfg: trials[cfg]["ms"],
        )

    evaluate(base)
    # A and B are both cooperatively decoded, so tune the work per lane.
    geometries = (
        (
            (16, 32, 1, 1),
            (16, 64, 1, 1),
            (16, 64, 1, 2),
            (16, 128, 1, 2),
            (32, 64, 1, 2),
            (32, 128, 1, 2),
            (32, 128, 1, 4),
        )
        if shape[0] < 128
        else (
            (32, 64, 1, 1),
            (32, 64, 1, 2),
            (64, 64, 1, 2),
            (64, 64, 2, 2),
            (64, 128, 1, 2),
            (64, 128, 2, 2),
            (128, 128, 2, 2),
            (128, 128, 1, 4),
        )
    )
    for bm, bn, wm, wn in geometries:
        evaluate(
            replace(
                base,
                block_m=bm,
                block_n=bn,
                block_k=32,
                waves_m=wm,
                waves_n=wn,
                k_unroll=2,
                wave_groups_m=1,
                wave_groups_n=1,
            )
        )
    for cfg in ranked()[:2]:
        for depth in (16, 32, 64):
            for splits in (1, 2, 4):
                evaluate(replace(cfg, block_k=depth, split_k=splits))
    best = ranked()[0]
    for unroll in (1, 2, 4):
        evaluate(replace(best, k_unroll=unroll))
    for cache in (0, 1, 2):
        evaluate(replace(best, right_cache_modifier=cache))

    finalists = {cfg.name: cfg for cfg in dict.fromkeys([base, *ranked()[:4]])}
    rerank = verify(
        shape,
        finalists,
        inputs(shape, 37),
        seed=37,
        graph_gemms=16,
        batches=5,
        replays=7,
    )
    winner = finalists[min(finalists, key=rerank["median_ms"].__getitem__)]
    candidates = {"fused_mxfp8": winner}
    if winner != base:
        candidates["initial_config"] = base
    rounds = verify_rounds(shape, candidates)
    chosen = "fused_mxfp8"
    if winner != base and not wins_each_round(rounds, "fused_mxfp8", "initial_config"):
        chosen = "initial_config"
        winner = base
    return {
        "shape_MNK": shape,
        "selected_config": asdict(winner),
        "selected_config_name": winner.name,
        "selected_lane": chosen,
        "trials": list(trials.values()),
        "finalist_ranking": rerank,
        "verification": rounds,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, action="append")
    parser.add_argument("--output", type=Path)
    parser.add_argument(
        "--verify-only", action="store_true", help="Time the installed shape defaults"
    )
    args = parser.parse_args()
    torch.set_num_threads(1)
    shapes = [tuple(shape) for shape in args.shape] if args.shape else lesson.SHAPES
    result = {
        "device": torch.cuda.get_device_name(0),
        "arch": torch.cuda.get_device_properties(0).gcnArchName,
        "flydsl": version("flydsl"),
        "torch": torch.__version__,
        "hip": torch.version.hip,
        "timing": "GPU event time per GEMM across shuffled graph replay batches",
        "torch_emulation": TORCH_EMULATION,
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
            report = tune_shape(shape)
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
