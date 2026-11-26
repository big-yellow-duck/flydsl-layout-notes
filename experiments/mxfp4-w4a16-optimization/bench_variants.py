"""Compare the baseline and direct-bit MXFP4 decoders with the same W4A16 GEMM."""

import argparse
import json
import random
import runpy
import statistics
from pathlib import Path

import flydsl  # noqa: F401 -- initialize FlyDSL LLVM before PyTorch
import torch
from variants import launch_direct_unpack

ROOT = Path(__file__).resolve().parents[2]
LESSON = ROOT / "lessons/01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16"
RESULTS = LESSON / "results/gfx1152-20261117-register-unpack/tuning.json"
FUSED_TUNING = Path(__file__).resolve().parent / "results/20261117-fused-tuning.json"


config_from_archive = runpy.run_path(
    str(ROOT / "tools/matmul_config_archive.py")
)["config_from_archive"]


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


def run(shape, *, batches=7, replays=20, graph_gemms=8):
    module = runpy.run_path(str(LESSON / "04-lut-decode/solution.py"))
    fused = runpy.run_path(
        str(Path(__file__).resolve().with_name("fused_matmul.py"))
    )
    operand_paths = runpy.run_path(
        str(LESSON.parents[1] / "13-matmul/12-operand-paths/solution.py")
    )
    m, n, k = shape
    seed = 13
    generator = torch.Generator().manual_seed(seed)
    a_cpu = torch.randn((m, k), generator=generator).to(torch.bfloat16)
    b_cpu = torch.randn((k, n), generator=generator).to(torch.bfloat16)
    b_packed_cpu, b_scales_cpu, b_bf16_cpu = module["quantize_mxfp4"](b_cpu)
    a = a_cpu.cuda()
    b_packed = b_packed_cpu.cuda()
    b_scales = b_scales_cpu.cuda()
    expected_dense = b_bf16_cpu.cuda()
    dense_baseline = torch.empty_like(expected_dense)
    dense_direct = torch.empty_like(expected_dense)
    output = torch.empty((m, n), dtype=torch.bfloat16, device="cuda")
    expected = a_cpu.float() @ b_bf16_cpu.float()

    if FUSED_TUNING.exists():
        records = json.loads(FUSED_TUNING.read_text())["shapes"]
        record = next(row for row in records if tuple(row["shape_MNK"]) == shape)
        config_values = record["selected_config"]
        config_source = "fused-specific configuration sweep"
    else:
        records = json.loads(RESULTS.read_text())["shapes"]
        record = next(row for row in records if tuple(row["shape_MNK"]) == shape)
        config_values = record["final_comparison"]["config"]
        config_source = "lesson register-unpack tuning"
    config = config_from_archive(operand_paths["Config"], config_values)

    def baseline_unpack():
        module["_launch_matmul_mxfp4_w4a16"](
            b_packed.view(torch.int32),
            b_scales.view(torch.int64),
            dense_baseline,
            k,
            n,
            True,
            stream=module["fx"].Stream(torch.cuda.current_stream()),
        )

    def direct_unpack():
        launch_direct_unpack(
            b_packed.view(torch.int32),
            b_scales.view(torch.int64),
            dense_direct,
            k,
            n,
            stream=module["fx"].Stream(torch.cuda.current_stream()),
        )

    def matmul(b):
        operand_paths["matmul_bf16"](
            a,
            b.view(k, n),
            out=output,
            config=config,
            stream=torch.cuda.current_stream(),
        )

    def baseline_pipeline():
        baseline_unpack()
        matmul(dense_baseline)

    def direct_pipeline():
        direct_unpack()
        matmul(dense_direct)

    def torch_dense():
        torch.matmul(a, expected_dense.view(k, n), out=output)

    def fused_pipeline():
        fused["matmul_mxfp4_fused"](
            a, b_packed, b_scales, out=output, config=fused["Config"].from_dict(config.__dict__)
        )

    baseline_unpack()
    direct_unpack()
    torch.cuda.synchronize()
    torch.testing.assert_close(dense_baseline, expected_dense, rtol=0, atol=0)
    torch.testing.assert_close(dense_direct, expected_dense, rtol=0, atol=0)

    callbacks = {
        "baseline_register_unpack_plus_matmul": baseline_pipeline,
        "direct_bits_unpack_plus_matmul": direct_pipeline,
        "fused_unpack_and_matmul": fused_pipeline,
        "torch_dense_bf16_matmul": torch_dense,
    }
    comparisons = {}
    for index, (name, callback) in enumerate(callbacks.items()):
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
            seed=seed + index,
        )
        comparisons[name] = {"median_ms": median, "samples_ms": samples}
    baseline = comparisons["baseline_register_unpack_plus_matmul"]["median_ms"]
    direct = comparisons["direct_bits_unpack_plus_matmul"]["median_ms"]
    fused_time = comparisons["fused_unpack_and_matmul"]["median_ms"]
    torch_time = comparisons["torch_dense_bf16_matmul"]["median_ms"]
    return {
        "device": torch.cuda.get_device_name(0),
        "arch": torch.cuda.get_device_properties(0).gcnArchName,
        "shape_MNK": shape,
        "config": config.__dict__,
        "config_source": config_source,
        "batches": batches,
        "graph_replays_per_batch": replays,
        "gemms_per_graph": graph_gemms,
        "correctness": "baseline and direct decoder outputs are bitwise equal to the offline BF16 reference; baseline, direct, and fused GEMM output checks passed",
        "comparisons": comparisons,
        "direct_vs_baseline_speedup": baseline / direct,
        "fused_vs_baseline_speedup": baseline / fused_time,
        "fused_over_torch_ratio": fused_time / torch_time,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, action="append")
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--batches", type=int, default=7)
    parser.add_argument("--replays", type=int, default=20)
    args = parser.parse_args()
    shapes = args.shape or [(16, 1024, 8192), (32, 1024, 8192), (16, 4096, 8192)]
    reports = [
        run(tuple(shape), batches=args.batches, replays=args.replays)
        for shape in shapes
    ]
    result = {"torch": torch.__version__, "hip": torch.version.hip, "shapes": reports}
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
