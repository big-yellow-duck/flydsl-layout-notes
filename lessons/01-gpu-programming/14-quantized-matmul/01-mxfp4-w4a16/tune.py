"""Tune fused MXFP4 W4A16 configurations and compare them with Torch."""

import argparse
import json
import random
import statistics
from dataclasses import asdict, replace
from pathlib import Path

import solution as lesson
import torch


def _inputs(shape, seed=13):
    m, n, k = shape
    generator = torch.Generator().manual_seed(seed)
    a_cpu = torch.randn((m, k), generator=generator).to(torch.bfloat16)
    b_cpu = torch.randn((k, n), generator=generator).to(torch.bfloat16)
    packed_cpu, scales_cpu, dense_cpu = lesson.quantize_mxfp4(b_cpu)
    a = a_cpu.cuda()
    packed = packed_cpu.cuda()
    scales = scales_cpu.cuda()
    dense = dense_cpu.cuda()
    expected = a_cpu.float() @ dense_cpu.float()
    return a, packed, scales, dense, expected


def _capture(callback, graph_gemms=8):
    for _ in range(3):
        callback()
    torch.cuda.synchronize()
    graph = torch.cuda.CUDAGraph()
    with torch.cuda.graph(graph):
        for _ in range(graph_gemms):
            callback()
    graph.replay()
    torch.cuda.synchronize()
    return graph


def _measure(graph, graph_gemms, batches, replays, seed):
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


def _configs(shape):
    base = lesson.CONFIGS_BY_SHAPE[shape]
    k_unroll_alternative = 2 if base.k_unroll != 2 else 4
    candidates = [
        base,
        replace(base, k_unroll=k_unroll_alternative),
        replace(base, k_unroll=8),
        replace(base, split_k=1 if base.split_k > 1 else 2),
        replace(base, left_in_registers=not base.left_in_registers),
        lesson.BASE_CONFIGS_BY_SHAPE[shape],
    ]
    valid = []
    seen = set()
    for config in candidates:
        try:
            lesson._OPERAND_PATHS["validate_config"](config, shape)
        except ValueError:
            continue
        key = tuple(sorted(asdict(config).items()))
        if key not in seen:
            seen.add(key)
            valid.append(config)
    return valid


def compare(
    shape, config, *, batches=7, replays=20, graph_gemms=8, include_scalar=False
):
    m, n, _ = shape
    a, packed, scales, dense, expected = _inputs(shape)
    output = torch.empty((m, n), dtype=torch.bfloat16, device="cuda")
    decoded_dense = torch.empty_like(dense) if include_scalar else None

    def fused_mxfp4_w4a16():
        lesson.matmul_mxfp4_w4a16(
            a, packed, scales, out=output, config=config
        )

    def torch_dense():
        torch.matmul(a, dense, out=output)

    def unpack_then_matmul(register_unpack):
        stream = torch.cuda.current_stream(a.device)
        lesson._launch_matmul_mxfp4_w4a16(
            packed.view(torch.int32),
            scales.view(torch.int64),
            decoded_dense,
            shape[2],
            shape[1],
            register_unpack,
            stream=lesson.fx.Stream(stream),
        )
        lesson._OPERAND_PATHS["matmul_bf16"](
            a,
            decoded_dense.view(shape[2], shape[1]),
            out=output,
            config=config,
            stream=stream,
        )

    def register_unpack():
        unpack_then_matmul(True)

    def scalar_unpack():
        unpack_then_matmul(False)

    callbacks = {
        "fused_mxfp4_w4a16": fused_mxfp4_w4a16,
        "torch_dense_bf16_matmul": torch_dense,
    }
    if include_scalar:
        callbacks["register_unpack_plus_matmul"] = register_unpack
        callbacks["scalar_unpack_plus_matmul"] = scalar_unpack
    graphs, metadata = {}, {}
    for name, callback in callbacks.items():
        graph = _capture(callback, graph_gemms)
        torch.testing.assert_close(
            output.float(), expected.cuda(), rtol=0.016, atol=0.03125
        )
        graphs[name] = graph
        metadata[name] = {"captured_gemms": graph_gemms}
    measured = {
        name: _measure(graph, graph_gemms, batches, replays, 13 + i)
        for i, (name, graph) in enumerate(graphs.items())
    }
    median_ms = {name: values[0] for name, values in measured.items()}
    return {
        "shape_MNK": shape,
        "config": asdict(config),
        "config_name": config.name,
        "timing": "GPU event elapsed time across CUDA graph replays, milliseconds per GEMM",
        "batches": batches,
        "graph_replays_per_batch": replays,
        "gemms_per_graph": graph_gemms,
        "median_ms": median_ms,
        "samples_ms": {name: values[1] for name, values in measured.items()},
        "fused_over_torch_dense_ratio": (
            median_ms["fused_mxfp4_w4a16"] / median_ms["torch_dense_bf16_matmul"]
        ),
        "fused_over_register_unpack_ratio": (
            median_ms["fused_mxfp4_w4a16"]
            / median_ms["register_unpack_plus_matmul"]
            if include_scalar
            else None
        ),
        "fused_over_scalar_unpack_ratio": (
            median_ms["fused_mxfp4_w4a16"]
            / median_ms["scalar_unpack_plus_matmul"]
            if include_scalar
            else None
        ),
        "torch_comparison_scope": (
            "GPU torch.matmul on the BF16 weights produced by the same offline MXFP4 encoder; "
            "Torch receives the pre-dequantized matrix because this gfx1152 target has no native MXFP4 GEMM."
        ),
        "graph_metadata": metadata,
    }


def tune_shape(shape, *, tuning_batches=3, tuning_replays=5):
    measurements = []
    for config in _configs(shape):
        report = compare(
            shape,
            config,
            batches=tuning_batches,
            replays=tuning_replays,
            graph_gemms=4,
        )
        measurements.append(report)
    selected = min(
        measurements,
        key=lambda report: report["median_ms"]["fused_mxfp4_w4a16"],
    )
    final = compare(
        shape, lesson.Config(**selected["config"]), include_scalar=True
    )
    return {
        "shape_MNK": shape,
        "candidate_count": len(measurements),
        "selected_config": selected["config"],
        "selected_config_name": selected["config_name"],
        "tuning_measurements": measurements,
        "final_comparison": final,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, action="append")
    parser.add_argument("--output", type=Path)
    parser.add_argument("--tuning-batches", type=int, default=3)
    parser.add_argument("--tuning-replays", type=int, default=5)
    args = parser.parse_args()
    shapes = [tuple(shape) for shape in args.shape] if args.shape else lesson.SHAPES
    reports = []
    for shape in shapes:
        if shape not in lesson.SHAPES:
            parser.error(f"Choose one of {lesson.SHAPES}")
        report = tune_shape(
            shape,
            tuning_batches=args.tuning_batches,
            tuning_replays=args.tuning_replays,
        )
        reports.append(report)
        print(json.dumps(report, indent=2), flush=True)
    result = {
        "device": torch.cuda.get_device_name(0),
        "arch": torch.cuda.get_device_properties(0).gcnArchName,
        "torch": torch.__version__,
        "hip": torch.version.hip,
        "shapes": reports,
    }
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(json.dumps(result, indent=2) + "\n")


if __name__ == "__main__":
    main()
