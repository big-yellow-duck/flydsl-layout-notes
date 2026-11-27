"""Compare FlyDSL and vLLM on AMD Quark Qwen3.8-27B MXFP4 linears."""

import argparse
import hashlib
import json
import os
import runpy
import statistics
from dataclasses import asdict, replace
from functools import partial
from importlib.metadata import version
from pathlib import Path

import torch
import torch.nn.functional as F

ROOT = Path(__file__).resolve().parents[2]
QUANTIZED = ROOT / "lessons/01-gpu-programming/14-quantized-matmul"
LESSON = QUANTIZED / "01-mxfp4-w4a16/04-lut-decode/solution.py"
PROJECTIONS = {
    "mlp_gate_up": (34816, 5120),
    "mlp_down": (5120, 17408),
    "gdn_qkvz": (16384, 5120),
    "gdn_ba": (96, 5120),
    "attention_qkv": (14336, 5120),
    "attention_out": (5120, 6144),
}
LAYER_NAMES = {
    "mlp_gate_up": "0.mlp.gate_up_proj",
    "mlp_down": "0.mlp.down_proj",
    "gdn_qkvz": "0.linear_attn.in_proj_qkvz",
    "gdn_ba": "0.linear_attn.in_proj_ba",
    "attention_qkv": "3.self_attn.qkv_proj",
    "attention_out": "3.self_attn.o_proj",
}
PACKED_MODULES = {
    "gate_up_proj": ["gate_proj", "up_proj"],
    "in_proj_qkvz": ["in_proj_qkv", "in_proj_z"],
    "in_proj_ba": ["in_proj_b", "in_proj_a"],
    "qkv_proj": ["q_proj", "k_proj", "v_proj"],
}
TOKEN_ROWS = (1, 8, 32, 128, 512)
SEEDS = (301, 302, 303)


def inputs(weights, projection, n, k):
    def read(kind, columns):
        path = weights / f"{projection}.{kind}.u8"
        assert path.stat().st_size == n * columns
        return torch.from_file(str(path), size=n * columns, dtype=torch.uint8).view(
            n, columns
        )

    packed = read("weight", k // 2)
    scales = read("weight_scale", k // 32)
    assert torch.all(scales != 255), "Checkpoint scale bytes must be finite"
    interleaved = torch.stack((packed & 15, packed >> 4), dim=2).reshape(n, k)
    levels = torch.tensor([0, 0.5, 1, 1.5, 2, 3, 4, 6], dtype=torch.bfloat16)
    # The E2M1 levels and powers-of-two E8M0 scales give BF16 weights.
    dense = torch.empty((n, k), dtype=torch.bfloat16)
    for start in range(0, n, 512):
        codes = interleaved[start : start + 512]
        magnitude = levels[(codes & 7).long()]
        scale = (scales[start : start + 512].float() - 127).exp2().bfloat16()
        dense[start : start + 512] = (
            torch.where(codes & 8 != 0, -magnitude, magnitude).view(-1, k // 32, 32)
            * scale.unsqueeze(-1)
        ).view(-1, k)
    # vLLM packs along K. The FlyDSL lesson interleaves adjacent N values.
    k_major = interleaved.T.contiguous()
    packed_fly = (k_major[:, ::2] | (k_major[:, 1::2] << 4)).contiguous().view(-1)
    return (
        packed.cuda(),
        scales.cuda(),
        packed_fly.cuda(),
        scales.T.contiguous().cuda(),
        dense,
    )


def activation(m, k, seed):
    rng = torch.Generator().manual_seed(seed)
    return (torch.randn((m, k), generator=rng) * (k**-0.5)).bfloat16()


def reference_for(dense_float):
    dense_gpu = None

    def expected(a):
        nonlocal dense_gpu
        if a.shape[0] <= 32:
            return F.linear(a.float().cpu(), dense_float).bfloat16().cuda()
        if dense_gpu is None:
            dense_gpu = dense_float.cuda()
        a = a.float().cuda()
        output = F.linear(a, dense_gpu)
        # Check the FP32 GPU reference against independent CPU dot products
        # sampled from the same activation and decoded weight tensors.
        rows = torch.linspace(0, a.shape[0] - 1, 4).long()
        columns = torch.linspace(0, dense_float.shape[0] - 1, 16).long()
        sampled = F.linear(a[rows.cuda()].cpu(), dense_float[columns])
        torch.testing.assert_close(
            output[rows.cuda()[:, None], columns.cuda()].cpu(),
            sampled,
            rtol=0.002,
            atol=0.002,
        )
        return output.bfloat16()

    return expected


def capture(launch, flip, expected, gemms):
    def check(actual, reference):
        torch.testing.assert_close(actual, reference, rtol=0.016, atol=0.03125)

    check(launch(), expected)
    torch.cuda.synchronize()
    graph = torch.cuda.CUDAGraph()
    with torch.cuda.graph(graph):
        for _ in range(gemms):
            result = launch()
    try:
        flip()
        graph.replay()
        check(result, -expected)
    finally:
        flip()
    graph.replay()
    check(result, expected)
    return graph


def quark_linear(manifest, projection, packed, scales):
    from vllm.model_executor.kernels.linear import init_mxfp4_linear_kernel
    from vllm.model_executor.layers.linear import LinearBase
    from vllm.model_executor.layers.quantization.quark.quark import QuarkConfig
    from vllm.model_executor.layers.quantization.utils.quant_utils import kMxfp4Dynamic

    n, k = PROJECTIONS[projection]
    shards = manifest["projections"][projection]
    assert all(width * 2 == k for _, width in shards)
    assert sum(rows for rows, _ in shards) == n
    config = QuarkConfig.from_config(manifest["quantization_config"])
    config.packed_modules_mapping = PACKED_MODULES
    layer = LinearBase(
        k,
        n,
        params_dtype=torch.bfloat16,
        quant_config=config,
        prefix=f"model.language_model.layers.{LAYER_NAMES[projection]}",
        disable_tp=True,
    )
    method = layer.quant_method
    # The representative tensors are already merged and packed. Use the same
    # registry call as QuarkOCP_MX.create_weights without TP loader parameters.
    layer.scheme.ocp_mx_linear = init_mxfp4_linear_kernel(
        activation_quant_key=layer.scheme.activation_quant_key
    )
    layer.weight = torch.nn.Parameter(packed, requires_grad=False)
    layer.weight_scale = torch.nn.Parameter(scales, requires_grad=False)
    method.process_weights_after_loading(layer)
    kernel = layer.scheme.ocp_mx_linear
    assert kernel.config.activation_quant_key == kMxfp4Dynamic
    assert layer.weight.dtype == torch.uint8
    print(
        projection,
        type(method).__name__,
        type(layer.scheme).__name__,
        type(kernel).__name__,
        flush=True,
    )
    return (
        partial(method.apply, layer),
        kernel.quant_dequant_func,
        {
            "method": type(method).__name__,
            "scheme": type(layer.scheme).__name__,
            "kernel": type(kernel).__name__,
        },
    )


def full_search(lesson, shape, evaluate, rank):
    base = lesson["default_config"](shape)
    evaluate(base)
    layouts = (
        (
            (16, 16, 1, 1),
            (16, 32, 1, 1),
            (16, 64, 1, 1),
            (16, 64, 1, 2),
            (16, 128, 1, 2),
            (16, 128, 1, 4),
            (16, 256, 1, 4),
        )
        if shape[0] <= 16
        else (
            (16, 64, 1, 1),
            (32, 64, 1, 2),
            (32, 128, 1, 4),
            (64, 64, 2, 2),
            (64, 128, 2, 2),
            (128, 128, 2, 2),
        )
    )
    for bm, bn, wm, wn in layouts:
        for a_reg, b_reg in (
            (True, False),
            (False, False),
            (True, True),
            (False, True),
        ):
            evaluate(
                replace(
                    base,
                    group_tile_m=bm,
                    group_tile_n=bn,
                    waves_per_group_m=wm,
                    waves_per_group_n=wn,
                    stage_k=32,
                    split_k=1 if shape[0] >= 128 else 4,
                    k_unroll=2,
                    left_in_registers=a_reg,
                    right_in_registers=b_reg,
                )
            )
    for config in rank()[:2]:
        for stage_k in (16, 32, 64, 128):
            for split_k in (1, 2, 4):
                evaluate(replace(config, stage_k=stage_k, split_k=split_k))
    for config in rank()[:2]:
        for unroll in (1, 2, 4, 8):
            evaluate(replace(config, k_unroll=unroll))
        for left, right in ((0, 0), (0, 2), (2, 0), (2, 2), (0, 1)):
            evaluate(
                replace(config, left_cache_modifier=left, right_cache_modifier=right)
            )
        if config.compute_threads == 32:
            for gm, gn in ((1, 2), (2, 1), (2, 2)):
                evaluate(replace(config, wave_groups_m=gm, wave_groups_n=gn))
        if shape[0] > config.group_tile_m:
            for group in (2, 4):
                evaluate(replace(config, traversal_group_m=group))


def staged_search(lesson, shape, evaluate, rank, transferred):
    base = lesson["default_config"](shape)
    evaluate(base)
    for config in transferred:
        evaluate(config)

    if shape[0] <= 8:
        layouts = ((16, 16, 1, 1), (16, 32, 1, 1), (16, 128, 1, 2))
    elif shape[0] <= 32:
        layouts = ((16, 32, 1, 1), (32, 64, 1, 2), (32, 128, 1, 4))
    else:
        layouts = ((32, 64, 1, 2), (64, 128, 2, 2), (128, 128, 2, 2))
    for bm, bn, wm, wn in layouts:
        evaluate(
            replace(
                base,
                group_tile_m=bm,
                group_tile_n=bn,
                waves_per_group_m=wm,
                waves_per_group_n=wn,
                left_in_registers=True,
                split_k=1 if shape[0] >= 128 else 4,
            )
        )
    best = rank()[0]
    for left, right in ((False, False), (True, True), (False, True)):
        evaluate(replace(best, left_in_registers=left, right_in_registers=right))
    best = rank()[0]
    for changes in (
        {"stage_k": 16},
        {"stage_k": 64},
        {"split_k": 1},
        {"split_k": 2},
        {"split_k": 4},
        {"k_unroll": 4},
        {"right_cache_modifier": 0},
        {"left_cache_modifier": 2},
    ):
        evaluate(replace(best, **changes))
    best = rank()[0]
    if best.compute_threads == 32:
        evaluate(replace(best, wave_groups_n=2))
    if shape[0] > best.group_tile_m:
        evaluate(replace(best, traversal_group_m=4))


def transfer_search(lesson, shape, evaluate, rank, transferred):
    if not transferred:
        staged_search(lesson, shape, evaluate, rank, transferred)
        return

    base = lesson["default_config"](shape)
    evaluate(base)
    for config in transferred:
        evaluate(config)
    best = rank()[0]
    for changes in (
        {"split_k": 1},
        {"split_k": 2},
        {"split_k": 4},
        {"right_cache_modifier": 0 if best.right_cache_modifier else 2},
    ):
        evaluate(replace(best, **changes))
    if shape[0] <= 32:
        evaluate(replace(best, right_in_registers=not best.right_in_registers))
    elif shape[0] >= 512:
        evaluate(replace(best, traversal_group_m=4))
    if best == base and shape[0] < 512:
        staged_search(lesson, shape, evaluate, rank, transferred)


def flydsl_trials(lesson, measure, shape, tensors, reference, qdq, search, transferred):
    from flydsl.compiler.diagnostics import DSLCompileError
    from flydsl.compiler.external_llvm import ExternalLLVMError

    m, _, k = shape
    packed, scales = tensors
    a = qdq(activation(m, k, 289).cuda())
    expected = reference(a)
    trials = {}

    def evaluate(config):
        if config in trials:
            return
        row = trials[config] = {"config": asdict(config)}
        if len(trials) % 4 == 0:
            print(f"  {shape}: {len(trials) - 1} candidates screened", flush=True)
        try:
            lesson["validate_config"](config, shape)
            graph = capture(
                lambda: lesson["matmul_mxfp4_w4a16"](a, packed, scales, config=config),
                lambda: packed.bitwise_xor_(0x88),
                expected,
                3,
            )
            _, samples, _ = measure({"candidate": graph}, 3, 3, 4, 289)
            row["median_us"] = statistics.median(samples["candidate"]) * 1000
        except (
            ValueError,
            AssertionError,
            DSLCompileError,
            ExternalLLVMError,
        ) as error:
            row["rejected"] = str(error).strip()[:500]

    def rank():
        return sorted(
            (config for config, row in trials.items() if "median_us" in row),
            key=lambda config: trials[config]["median_us"],
        )

    if search == "full":
        full_search(lesson, shape, evaluate, rank)
    elif search == "transfer":
        transfer_search(lesson, shape, evaluate, rank, transferred)
    else:
        staged_search(lesson, shape, evaluate, rank, transferred)
    base = lesson["default_config"](shape)
    configs = {"default": base}
    configs.update(
        {
            f"candidate_{i}": config
            for i, config in enumerate(rank()[:5])
            if config != base
        }
    )
    return configs, list(trials.values())


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--weights", required=True, type=Path)
    parser.add_argument("--out", required=True, type=Path)
    parser.add_argument("--rows", nargs="+", type=int, default=TOKEN_ROWS)
    parser.add_argument("--projection", choices=PROJECTIONS, action="append")
    parser.add_argument(
        "--search", choices=("staged", "full", "transfer"), default="staged"
    )
    parser.add_argument("--configs-from", type=Path)
    args = parser.parse_args()
    rows = tuple(dict.fromkeys(args.rows))
    if min(rows) <= 0:
        parser.error("--rows must be positive")

    torch.set_num_threads(8)
    os.environ["VLLM_MXFP4_EMULATION_DEQUANT_AT_LOAD"] = "0"
    manifest = json.loads((args.weights / "manifest.json").read_text())
    measure = runpy.run_path(str(QUANTIZED / "benchmark.py"))["measure"]
    lesson = runpy.run_path(str(LESSON))
    report = {
        "model": manifest["model"],
        "model_revision": manifest["revision"],
        "gpu": torch.cuda.get_device_name(0) or "AMD Radeon 8060S Graphics",
        "arch": torch.cuda.get_device_properties(0).gcnArchName,
        "torch": torch.__version__,
        "hip": torch.version.hip,
        "flydsl": version("flydsl"),
        "flydsl_source_sha256": hashlib.sha256(LESSON.read_bytes()).hexdigest(),
        "vllm_revision": os.environ.get("BENCHMARK_VLLM_REVISION"),
        "cases": [],
    }
    if args.out.exists():
        previous = json.loads(args.out.read_text())
        if any(
            previous.get(key) != value
            for key, value in report.items()
            if key != "cases"
        ):
            raise ValueError("Existing output uses a different benchmark environment")
        report = previous
    previous_configs = {}
    if args.configs_from:
        source = json.loads(args.configs_from.read_text())
        previous_configs = {
            tuple(row["shape"]): row["configs"][row["selected"]]
            for row in source["cases"]
            if row["selected"] is not None
        }
    completed = {tuple(row["shape"]) for row in report["cases"]}
    for projection in args.projection or PROJECTIONS:
        n, k = PROJECTIONS[projection]
        remaining = [m for m in rows if (m, n, k) not in completed]
        if not remaining:
            continue
        packed_v, scale_v, packed_f, scale_f, dense = inputs(
            args.weights, projection, n, k
        )
        reference = reference_for(dense.float())
        vllm, qdq, dispatch = quark_linear(manifest, projection, packed_v, scale_v)

        for m in remaining:
            shape = m, n, k
            print(f"Starting {projection} {shape}", flush=True)
            trials = []
            if shape in previous_configs:
                configs = {"tuned": lesson["Config"](**previous_configs[shape])}
            else:
                transfers = [
                    lesson["Config"](**row["configs"][row["selected"]])
                    for row in report["cases"]
                    if row["shape"][0] == m and row["selected"]
                ][-2:]
                configs, trials = flydsl_trials(
                    lesson,
                    measure,
                    shape,
                    (packed_f, scale_f),
                    reference,
                    qdq,
                    args.search,
                    transfers,
                )

            measurements = []
            for seed in SEEDS:
                a = activation(m, k, seed).cuda()
                qdq_a = qdq(a)
                expected = reference(qdq_a)
                gemms = 4 if m <= 128 else 2
                graphs = {
                    "vllm": capture(
                        partial(vllm, a),
                        partial(packed_v.bitwise_xor_, 0x88),
                        expected,
                        gemms,
                    )
                }
                for name, config in configs.items():
                    linear = partial(
                        lesson["matmul_mxfp4_w4a16"],
                        packed_weights=packed_f,
                        scales=scale_f,
                        config=config,
                    )
                    flip = partial(packed_f.bitwise_xor_, 0x88)
                    graphs[name] = capture(
                        lambda linear=linear, a=a, qdq=qdq: linear(qdq(a)),
                        flip,
                        expected,
                        gemms,
                    )
                    if shape in previous_configs:
                        graphs["flydsl_core"] = capture(
                            partial(linear, qdq_a), flip, expected, gemms
                        )
                _, samples, _ = measure(graphs, gemms, 7, 10, seed)
                measurements.append(samples)
                del graphs

            medians = {
                name: 1000
                * statistics.median(
                    value for row in measurements for value in row[name]
                )
                for name in measurements[0]
            }
            if shape in previous_configs:
                selected = "tuned"
            else:
                stable = [
                    name
                    for name in configs
                    if name == "default"
                    or all(
                        statistics.median(
                            new / old
                            for new, old in zip(row[name], row["default"], strict=True)
                        )
                        < 1
                        for row in measurements
                    )
                ]
                selected = min(stable, key=medians.__getitem__)
            report["cases"].append(
                {
                    "projection": projection,
                    "shape": shape,
                    "reference": "cpu-fp32" if m <= 32 else "gpu-fp32-and-cpu-samples",
                    "vllm_dispatch": dispatch,
                    "median_us": medians,
                    "selected": selected,
                    "search": "replay" if shape in previous_configs else args.search,
                    "configs": {name: asdict(cfg) for name, cfg in configs.items()},
                    "trials": trials,
                    "samples_ms": measurements,
                }
            )
            args.out.parent.mkdir(parents=True, exist_ok=True)
            temporary = args.out.with_suffix(".tmp")
            temporary.write_text(json.dumps(report, indent=2) + "\n")
            temporary.replace(args.out)
            print(projection, shape, selected, len(trials), medians, flush=True)


if __name__ == "__main__":
    main()
