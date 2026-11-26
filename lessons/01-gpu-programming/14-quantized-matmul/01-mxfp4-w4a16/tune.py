"""Tune the fused MXFP4 WMMA pipeline and compare matched GPU graphs."""

import argparse
import hashlib
import inspect
import json
import runpy
import statistics
from dataclasses import asdict, replace
from functools import lru_cache
from importlib.metadata import version
from math import prod
from pathlib import Path
from types import SimpleNamespace

import torch
from flydsl.compiler.diagnostics import DSLCompileError
from flydsl.compiler.external_llvm import ExternalLLVMError

_LUT_SOLUTION = Path(__file__).with_name("04-lut-decode") / "solution.py"
lesson = SimpleNamespace(**runpy.run_path(str(_LUT_SOLUTION)))
arithmetic_lesson = SimpleNamespace(
    **runpy.run_path(str(Path(__file__).with_name("03-fused-staging") / "solution.py"))
)

_BENCHMARK = runpy.run_path(str(Path(__file__).resolve().parents[1] / "benchmark.py"))
capture = _BENCHMARK["capture"]
measure = _BENCHMARK["measure"]
wins_each_round = _BENCHMARK["wins_each_round"]
VERIFY_SEEDS = (5101, 5202, 5303)
TORCH_EMULATION = "TorchInductor MXFP4 decode to BF16, followed by torch.matmul"
torch_decode = torch.compile(
    lesson.torch_dequantize_mxfp4, fullgraph=True, dynamic=False
)


@lru_cache(maxsize=1)
def _dense_baseline():
    """Load the dense BF16 lesson for comparison runs."""
    return runpy.run_path(
        str(
            Path(__file__).resolve().parents[2]
            / "13-matmul/15-edge-load-widths/solution.py"
        )
    )


def inputs(shape, seed):
    m, n, k = shape
    generator = torch.Generator().manual_seed(seed)
    a = torch.randn((m, k), generator=generator).bfloat16()
    b = torch.randn((k, n), generator=generator).bfloat16()
    b_packed, b_scales, dense = lesson.quantize_mxfp4(b)
    expected = (a.float() @ dense.float()).bfloat16()
    storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
    return (
        a.cuda(),
        b_packed.cuda(),
        b_scales.cuda(),
        dense.cuda(),
        storage,
        expected.cuda(),
    )


def load_legacy(source):
    """Load a prior solution snapshot using the lesson's relative imports."""
    if source is None:
        return None
    module = {
        "__file__": str(Path(__file__).with_name("solution.py")),
        "__name__": "legacy_fused",
    }
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
    use_lut=True,
):
    m, n, k = shape
    a, b_packed, b_scales, dense, storage, expected = data
    output = storage[:-16].view(m, n)

    def flip_weights():
        # Both E2M1 nibbles have a sign bit. Replay must decode the new bytes.
        b_packed.bitwise_xor_(0x88)
        dense.neg_()

    def native(config):
        module = lesson if use_lut else arithmetic_lesson
        return lambda: module.matmul_mxfp4_w4a16(
            a, b_packed, b_scales, out=output, config=config
        )

    callbacks = {name: native(config) for name, config in configs.items()}
    if controls:
        callbacks["torch_mxfp4_emulation"] = lambda: torch.matmul(
            a, torch_decode(b_packed, b_scales, (k, n)), out=output
        )
        callbacks["lesson_15_bf16"] = lambda: _dense_baseline()["matmul_bf16"](
            a, dense, out=output
        )
    if legacy is not None and shape in lesson.ALIGNED_SHAPES:
        legacy_config = legacy["CONFIGS_BY_SHAPE"][shape]
        callbacks["legacy_fused"] = lambda: legacy["matmul_mxfp4_w4a16"](
            a, b_packed, b_scales, out=output, config=legacy_config
        )

    if include_scalar and shape in lesson.ALIGNED_SHAPES:
        decoded = torch.empty_like(dense)

        def separate(register_unpack):
            stream = torch.cuda.current_stream(a.device)
            lesson._launch_matmul_mxfp4_w4a16(
                b_packed.view(torch.int32),
                b_scales.view(torch.int64),
                decoded,
                k,
                n,
                register_unpack,
                stream=lesson.fx.Stream(stream),
            )
            _dense_baseline()["matmul_bf16"](a, decoded, out=output, stream=stream)

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
    use_lut=True,
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
            use_lut=use_lut,
        ),
    }


def verify_rounds(shape, configs, legacy, *, controls=True):
    return [
        verify(
            shape,
            configs,
            inputs(shape, seed),
            batches=7,
            replays=10,
            graph_gemms=32,
            seed=seed,
            controls=controls,
            legacy=legacy,
            include_scalar=controls,
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
                group_tile_m=bm,
                group_tile_n=bn,
                stage_k=32,
                waves_per_group_m=wm,
                waves_per_group_n=wn,
                wave_groups_m=1,
                wave_groups_n=1,
                left_in_registers=a_in_registers,
                k_unroll=2,
            )


def tune_shape(
    shape, *, tuning_batches=3, tuning_replays=5, legacy=None, lut_only=False
):
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
    if not lut_only:
        evaluate(lesson.Config(**asdict(_dense_baseline()["default_config"](shape))))
    for cfg in _geometries(shape, base):
        evaluate(cfg)
    for cfg in ranked()[:2]:
        for depth in (16, 32, 64):
            for splits in (1, 2, 4):
                evaluate(replace(cfg, stage_k=depth, split_k=splits))
    strongest = ranked()[0]
    for field, values in (
        ("k_unroll", (1, 2, 4, 8)),
        ("traversal_group_m", (1, 2, 4)),
        ("left_cache_modifier", (0, 1, 2)),
        ("right_cache_modifier", (0, 1, 2)),
    ):
        for value in values:
            evaluate(replace(strongest, **{field: value}))
    if strongest.compute_threads == 32:
        for groups_m, groups_n in ((1, 2), (2, 1), (2, 2)):
            evaluate(replace(strongest, wave_groups_m=groups_m, wave_groups_n=groups_n))

    if lut_only:
        # Refine two geometries after changing tile sizes and staging routes.
        for cfg in ranked()[:2]:
            if shape[2] >= 4096:
                for depth in (32, 64):
                    evaluate(replace(cfg, stage_k=depth, split_k=8))
            for unroll in (1, 2, 4):
                for cache in (0, 2):
                    evaluate(replace(cfg, k_unroll=unroll, right_cache_modifier=cache))

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
    baseline = "incumbent_lut" if lut_only else "untuned_mixed_width"
    if base != winner:
        callbacks[baseline] = base
    rounds = verify_rounds(shape, callbacks, legacy, controls=not lut_only)
    chosen = "fused_mxfp4_w4a16"
    if winner != base and not wins_each_round(rounds, "fused_mxfp4_w4a16", baseline):
        chosen = baseline
        winner = base
    return {
        "shape_MNK": shape,
        "incumbent_config": asdict(base),
        "selected_config": asdict(winner),
        "selected_config_name": winner.name,
        "selected_lane": chosen,
        "trials": list(trials.values()),
        "finalist_ranking": rerank,
        "verification": rounds,
    }


def tune_lessons(shape, *, tuning_batches=3, tuning_replays=5):
    """Search each teaching path, then time the winners in the same replay batches."""
    dequantize = runpy.run_path(
        str(Path(__file__).with_name("02-scalar-dequant") / "solution.py")
    )["dequantize_mxfp4"]
    dense_lesson = _dense_baseline()
    matmul = dense_lesson["matmul_bf16"]
    m, n, k = shape
    dense_default = lesson.Config(**asdict(dense_lesson["default_config"](shape)))
    arithmetic_default = lesson.Config(
        **asdict(arithmetic_lesson.default_config(shape))
    )
    # A candidate is (path, matmul config, scalar block size).
    bases = {
        "separate": ("separate", dense_default, 64),
        "arithmetic": ("arithmetic", arithmetic_default, None),
        "lut": ("lut", lesson.default_config(shape), None),
    }

    def timer(data):
        a, b_packed, b_scales, dense, storage, expected = data
        c = storage[:-16].view(m, n)
        decoded = torch.empty_like(dense)

        def flip():
            b_packed.bitwise_xor_(0x88)

        def graph(candidate, gemms):
            path, cfg, threads = candidate
            if path == "separate":
                cfg = dense_lesson["Config"](**asdict(cfg))

            def launch():
                if path == "separate":
                    dequantize(b_packed, b_scales, k, out=decoded, block_threads=threads)
                    matmul(a, decoded, out=c, config=cfg)
                else:
                    module = lesson if path == "lut" else arithmetic_lesson
                    module.matmul_mxfp4_w4a16(a, b_packed, b_scales, out=c, config=cfg)

            return capture(launch, flip, c, storage[-16:], expected, gemms)

        return graph

    def describe(candidate):
        path, cfg, threads = candidate
        return {"path": path, "config": asdict(cfg), "block_threads": threads}

    search_graph = timer(inputs(shape, 17))
    trials = {}

    def evaluate(candidate):
        if candidate not in trials:
            row = trials[candidate] = describe(candidate)
            try:
                lesson.validate_config(candidate[1], shape)
                graphs = {"trial": search_graph(candidate, 6)}
                _, samples, _ = measure(graphs, 6, tuning_batches, tuning_replays, 17)
                row["samples_ms"] = samples["trial"]
            except (
                ValueError,
                AssertionError,
                DSLCompileError,
                ExternalLLVMError,
            ) as error:
                row["rejected"] = str(error).strip()[:1000]
        return statistics.median(trials[candidate].get("samples_ms", [float("inf")]))

    search_winners = {}
    finalists = {}
    for path, base in bases.items():
        _, original, threads = base
        peer = lesson.default_config(shape) if path == "separate" else dense_default
        geometry = [original, peer]
        # Try adjacent depths, wave grouping, and A routes at the incumbent geometry.
        for field, values in (
            ("stage_k", (16, 32, 64)),
            ("split_k", (1, 2, 4)),
            ("left_in_registers", (False, True)),
        ):
            geometry.extend(replace(original, **{field: value}) for value in values)
        if original.compute_threads == 32 and original.wave_groups_m == 1:
            geometry.append(replace(original, wave_groups_n=2))
        if path == "separate":
            threads = min(
                (32, 64, 128, 256, 512),
                key=lambda size: evaluate((path, original, size)),
            )
        best = min(((path, cfg, threads) for cfg in geometry), key=evaluate)
        _, best_cfg, _ = best
        for field, values in (
            ("k_unroll", (1, 2, 4, 8)),
            ("traversal_group_m", (1, 2, 4)),
            ("left_cache_modifier", (0, 1, 2)),
            ("right_cache_modifier", (0, 1, 2)),
        ):
            for value in values:
                evaluate((path, replace(best_cfg, **{field: value}), threads))
        if path == "separate":
            best = min(
                (candidate for candidate in trials if candidate[0] == path),
                key=evaluate,
            )
            for size in (32, 64, 128, 256, 512):
                evaluate((path, best[1], size))
        ranked = sorted(
            (
                candidate
                for candidate, row in trials.items()
                if candidate[0] == path and "samples_ms" in row
            ),
            key=evaluate,
        )
        finalists.update(
            {
                f"{path}_{index}": candidate
                for index, candidate in enumerate(dict.fromkeys([base, *ranked[:4]]))
            }
        )
        print(f"{shape} {path}: {len(ranked)} valid search candidates", flush=True)

    rerank_graph = timer(inputs(shape, 37))
    graphs = {name: rerank_graph(cfg, 16) for name, cfg in finalists.items()}
    rerank, rerank_samples, _ = measure(graphs, 16, 5, 7, 37)
    del graphs
    for path in bases:
        winner = min(
            (name for name in finalists if name.startswith(path + "_")),
            key=rerank.__getitem__,
        )
        search_winners[path] = finalists[winner]

    contenders = dict(search_winners)
    for path, base in bases.items():
        if contenders[path] != base:
            contenders[path + "_baseline"] = base
    # Compare the decode implementations at the LUT winner's exact geometry.
    matched = ("arithmetic", search_winners["lut"][1], None)
    contenders["arithmetic_at_lut_config"] = matched
    contenders["arithmetic_at_lut_baseline_config"] = (
        "arithmetic",
        bases["lut"][1],
        None,
    )
    rounds = []
    for seed in VERIFY_SEEDS:
        graph = timer(inputs(shape, seed))
        graphs = {name: graph(cfg, 24) for name, cfg in contenders.items()}
        medians, samples, orders = measure(graphs, 24, 7, 10, seed)
        rounds.append(
            {
                "seed": seed,
                "median_ms": medians,
                "samples_ms": samples,
                "batch_orders": orders,
            }
        )
        del graphs

    selected = dict(search_winners)
    for path, base in bases.items():
        baseline = path + "_baseline"
        if baseline in contenders and not wins_each_round(rounds, path, baseline):
            selected[path] = base
    return {
        "shape_MNK": shape,
        "selected": {path: describe(cfg) for path, cfg in selected.items()},
        "verification_candidates": {
            name: describe(cfg) for name, cfg in contenders.items()
        },
        "trials": list(trials.values()),
        "finalists": {name: describe(cfg) for name, cfg in finalists.items()},
        "finalist_samples_ms": rerank_samples,
        "verification": rounds,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, action="append")
    parser.add_argument("--output", type=Path)
    parser.add_argument("--legacy-source", type=Path)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument(
        "--lesson-sweep", action="store_true", help="Tune the three MXFP4 lesson paths"
    )
    mode.add_argument(
        "--lut-sweep",
        action="store_true",
        help="Search LUT schedules against the current defaults",
    )
    mode.add_argument(
        "--verify-only", action="store_true", help="Time the installed shape defaults"
    )
    parser.add_argument("--tuning-batches", type=int, default=3)
    parser.add_argument("--tuning-replays", type=int, default=5)
    args = parser.parse_args()
    torch.set_num_threads(1)
    legacy = None if args.lut_sweep else load_legacy(args.legacy_source)
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
    if args.lut_sweep:
        result.pop("torch_emulation")
        result.pop("legacy_source_sha256")
        result["mode"] = "lut-sweep"
    for shape in shapes:
        if min(shape) <= 0:
            parser.error("M, N, and K must be positive")
        if args.lesson_sweep:
            print(f"Tuning MXFP4 lesson paths for {shape}", flush=True)
            report = tune_lessons(
                shape,
                tuning_batches=args.tuning_batches,
                tuning_replays=args.tuning_replays,
            )
        elif args.verify_only:
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
                lut_only=args.lut_sweep,
                tuning_batches=args.tuning_batches,
                tuning_replays=args.tuning_replays,
            )
        result["shapes"].append(report)
        if args.lesson_sweep:
            print(json.dumps(report["selected"]), flush=True)
        else:
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
