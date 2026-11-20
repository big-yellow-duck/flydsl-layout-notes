"""Tune the fused MXFP4 WMMA pipeline and compare matched GPU graphs."""

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
from flydsl.compiler.diagnostics import DSLCompileError
from flydsl.compiler.external_llvm import ExternalLLVMError

_BENCHMARK = runpy.run_path(str(Path(__file__).resolve().parents[1] / "benchmark.py"))
capture = _BENCHMARK["capture"]
measure = _BENCHMARK["measure"]
wins_each_round = _BENCHMARK["wins_each_round"]
VERIFY_SEEDS = (5101, 5202, 5303)
TORCH_EMULATION = "TorchInductor MXFP4 decode to BF16, followed by torch.matmul"
torch_decode = torch.compile(
    lesson.torch_dequantize_mxfp4, fullgraph=True, dynamic=False
)


def inputs(shape, seed):
    m, n, k = shape
    generator = torch.Generator().manual_seed(seed)
    a = torch.randn((m, k), generator=generator).bfloat16()
    b = torch.randn((k, n), generator=generator).bfloat16()
    packed, scales, dense = lesson.quantize_mxfp4(b)
    expected = (a.float() @ dense.float()).bfloat16()
    storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
    return (
        a.cuda(),
        packed.cuda(),
        scales.cuda(),
        dense.cuda(),
        storage,
        expected.cuda(),
    )


def load_legacy(source):
    """Load a prior solution snapshot using the lesson's relative imports."""
    if source is None:
        return None
    module = {"__file__": lesson.__file__, "__name__": "legacy_fused"}
    exec(compile(source.read_text(), str(source), "exec"), module)  # noqa: S102 -- explicit local benchmark source
    return module


def verify(
    shape,
    configs,
    data,
    *,
    batches,
    replays,
    graph_gemms,
    seed,
    controls=False,
    include_scalar=False,
    legacy=None,
):
    m, n, k = shape
    a, packed, scales, dense, storage, expected = data
    output = storage[:-16].view(m, n)

    def flip_weights():
        # Both E2M1 nibbles have a sign bit. Replay must decode the new bytes.
        packed.bitwise_xor_(0x88)
        dense.neg_()

    def native(config):
        return lambda: lesson.matmul_mxfp4_w4a16(
            a, packed, scales, out=output, config=config
        )

    callbacks = {name: native(config) for name, config in configs.items()}
    if controls:
        callbacks["torch_mxfp4_emulation"] = lambda: torch.matmul(
            a, torch_decode(packed, scales, (k, n)), out=output
        )
        callbacks["lesson_15_bf16"] = lambda: lesson._EDGE_LOADS["matmul_bf16"](
            a, dense, out=output
        )
    if legacy is not None and shape in lesson.ALIGNED_SHAPES:
        legacy_config = legacy["CONFIGS_BY_SHAPE"][shape]
        callbacks["legacy_fused"] = lambda: legacy["matmul_mxfp4_w4a16"](
            a, packed, scales, out=output, config=legacy_config
        )

    if include_scalar and shape in lesson.ALIGNED_SHAPES:
        decoded = torch.empty_like(dense)

        def separate(register_unpack):
            stream = torch.cuda.current_stream(a.device)
            lesson._launch_matmul_mxfp4_w4a16(
                packed.view(torch.int32),
                scales.view(torch.int64),
                decoded,
                k,
                n,
                register_unpack,
                stream=lesson.fx.Stream(stream),
            )
            lesson._EDGE_LOADS["matmul_bf16"](a, decoded, out=output, stream=stream)

        callbacks["register_unpack_plus_matmul"] = lambda: separate(True)
        callbacks["scalar_unpack_plus_matmul"] = lambda: separate(False)

    graphs = {
        name: capture(
            callback, flip_weights, output, storage[-16:], expected, graph_gemms
        )
        for name, callback in callbacks.items()
    }
    median_ms, samples, orders = measure(graphs, graph_gemms, batches, replays, seed)
    return {
        "seed": seed,
        "median_ms": median_ms,
        "effective_tflops": {
            name: 2 * prod(shape) / (ms * 1e9) for name, ms in median_ms.items()
        },
        "samples_ms": samples,
        "batch_orders": orders,
        "batches": batches,
        "graph_replays_per_batch": replays,
        "gemms_per_graph": graph_gemms,
    }


def compare(
    shape,
    config,
    *,
    batches=7,
    replays=10,
    graph_gemms=32,
    include_scalar=False,
    seed=13,
):
    return {
        "shape_MNK": shape,
        "config": asdict(config),
        "timing": "GPU event time per GEMM in a graph replay",
        "torch_emulation": TORCH_EMULATION,
        **verify(
            shape,
            {"fused_mxfp4_w4a16": config},
            inputs(shape, seed),
            batches=batches,
            replays=replays,
            graph_gemms=graph_gemms,
            seed=seed,
            controls=True,
            include_scalar=include_scalar,
        ),
    }


def verify_rounds(shape, configs, legacy):
    return [
        verify(
            shape,
            configs,
            inputs(shape, seed),
            batches=7,
            replays=10,
            graph_gemms=32,
            seed=seed,
            controls=True,
            legacy=legacy,
            include_scalar=True,
        )
        for seed in VERIFY_SEEDS
    ]


def _geometries(shape, base):
    if max(shape) <= 128:
        layouts = ((16, 32, 1, 1), (16, 64, 1, 1), (32, 64, 1, 2))
    elif shape[0] < 128:
        layouts = (
            (16, 32, 1, 1),
            (16, 64, 1, 1),
            (16, 64, 1, 2),
            (16, 128, 1, 1),
            (16, 128, 1, 2),
            (16, 128, 1, 4),
            (32, 64, 1, 1),
            (32, 64, 2, 1),
            (32, 128, 1, 2),
            (32, 128, 1, 4),
            (32, 256, 1, 2),
            (32, 256, 1, 4),
        )
    else:
        layouts = (
            (32, 64, 1, 1),
            (64, 64, 1, 2),
            (64, 64, 2, 2),
            (64, 128, 2, 2),
            (128, 64, 2, 2),
            (128, 128, 2, 2),
            (128, 128, 1, 4),
            (128, 256, 2, 2),
        )
    for bm, bn, wm, wn in layouts:
        for a_in_registers in (True, False):
            yield replace(
                base,
                block_m=bm,
                block_n=bn,
                block_k=32,
                waves_m=wm,
                waves_n=wn,
                wave_groups_m=1,
                wave_groups_n=1,
                left_in_registers=a_in_registers,
                k_unroll=2,
            )


def tune_shape(shape, *, tuning_batches=3, tuning_replays=5, legacy=None):
    base = lesson.default_config(shape)
    data = inputs(shape, 17)
    trials = {}

    def evaluate(cfg):
        if cfg in trials:
            return
        trial = trials[cfg] = {"config": asdict(cfg), "name": cfg.name}
        try:
            lesson.validate_config(cfg, shape)
        except ValueError as error:
            trial["excluded"] = str(error)
            return
        try:
            row = verify(
                shape,
                {"fused": cfg},
                data,
                batches=tuning_batches,
                replays=tuning_replays,
                graph_gemms=4,
                seed=17,
            )
            trial.update(
                ms=row["median_ms"]["fused"], samples_ms=row["samples_ms"]["fused"]
            )
        except (AssertionError, DSLCompileError, ExternalLLVMError) as error:
            trial["rejected"] = str(error).strip()[:1000]

    def ranked():
        return sorted(
            (cfg for cfg in trials if "ms" in trials[cfg]),
            key=lambda cfg: trials[cfg]["ms"],
        )

    evaluate(base)
    evaluate(lesson._EDGE_LOADS["default_config"](shape))
    if legacy is not None and shape in lesson.ALIGNED_SHAPES:
        evaluate(lesson.Config.from_dict(asdict(legacy["CONFIGS_BY_SHAPE"][shape])))
    for cfg in _geometries(shape, base):
        evaluate(cfg)
    for cfg in ranked()[:2]:
        for depth in (16, 32, 64):
            for splits in (1, 2, 4):
                evaluate(replace(cfg, block_k=depth, split_k=splits))
    strongest = ranked()[0]
    for field, values in (
        ("k_unroll", (1, 2, 4, 8)),
        ("group_m", (1, 2, 4)),
        ("left_cache_modifier", (0, 1, 2)),
        ("right_cache_modifier", (0, 1, 2)),
    ):
        for value in values:
            evaluate(replace(strongest, **{field: value}))
    if strongest.compute_threads == 32:
        for groups_m, groups_n in ((1, 2), (2, 1), (2, 2)):
            evaluate(replace(strongest, wave_groups_m=groups_m, wave_groups_n=groups_n))

    finalists = {cfg.name: cfg for cfg in dict.fromkeys([base, *ranked()[:5]])}
    rerank = verify(
        shape,
        finalists,
        inputs(shape, 37),
        batches=5,
        replays=7,
        graph_gemms=16,
        seed=37,
    )
    winner_name = min(finalists, key=rerank["median_ms"].__getitem__)
    winner = finalists[winner_name]
    callbacks = {"fused_mxfp4_w4a16": winner}
    if base != winner:
        callbacks["untuned_mixed_width"] = base
    rounds = verify_rounds(shape, callbacks, legacy)
    chosen = "fused_mxfp4_w4a16"
    if winner != base and not wins_each_round(
        rounds, "fused_mxfp4_w4a16", "untuned_mixed_width"
    ):
        chosen = "untuned_mixed_width"
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
    parser.add_argument("--legacy-source", type=Path)
    parser.add_argument(
        "--verify-only", action="store_true", help="Time the installed shape defaults"
    )
    parser.add_argument("--tuning-batches", type=int, default=3)
    parser.add_argument("--tuning-replays", type=int, default=5)
    args = parser.parse_args()
    torch.set_num_threads(1)
    legacy = load_legacy(args.legacy_source)
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
            inspect.getsource(
                lesson._matmul_mxfp4_w4a16_fused_impl._original_func
            ).encode()
        ).hexdigest(),
        "legacy_source_sha256": hashlib.sha256(
            args.legacy_source.read_bytes()
        ).hexdigest()
        if args.legacy_source
        else None,
        "shapes": [],
    }
    for shape in shapes:
        if min(shape) <= 0:
            parser.error("M, N, and K must be positive")
        if args.verify_only:
            print(f"Verifying {shape}", flush=True)
            config = lesson.default_config(shape)
            report = {
                "shape_MNK": shape,
                "selected_config": asdict(config),
                "selected_config_name": config.name,
                "selected_lane": "fused_mxfp4_w4a16",
                "verification": verify_rounds(
                    shape, {"fused_mxfp4_w4a16": config}, legacy
                ),
            }
        else:
            print(f"Tuning {shape}", flush=True)
            report = tune_shape(
                shape,
                legacy=legacy,
                tuning_batches=args.tuning_batches,
                tuning_replays=args.tuning_replays,
            )
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
