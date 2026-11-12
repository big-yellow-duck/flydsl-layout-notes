"""Compare operand paths directly with tuned prefetch and GPU Torch."""

import argparse
import gc
import hashlib
import inspect
import json
import random
import runpy
import statistics
from dataclasses import asdict
from functools import partial
from pathlib import Path

HERE = Path(__file__).resolve().parent
MODULE = runpy.run_path(str(HERE / "solution.py"))
COMMON = runpy.run_path(str(HERE.parent / "09-split-k/tune.py"))
PREFETCH = runpy.run_path(str(HERE.parent / "10c-k-unrolling/solution.py"))
PREFETCH_SELECTION = json.loads((HERE / "results/prefetch-control.json").read_text())
CONTEXT = COMMON["inputs"].__globals__
CONTEXT.update(MODULE=MODULE, BUILD=MODULE["_matmul_bf16"]._original_func)


def configure(shape):
    CONTEXT["SHAPE"] = tuple(shape)


def capture(launch, data):
    gc.collect()
    enabled = gc.isenabled()
    gc.disable()
    try:
        graph, metadata = COMMON["capture"](launch, data)
    finally:
        if enabled:
            gc.enable()
    if (
        metadata["nodes"] != 32 + metadata.get("workspace_initialization_nodes", 0)
        or not 32 <= metadata["kernel_nodes"] <= metadata["nodes"]
    ):
        raise RuntimeError(f"Expected one kernel per GEMM: {metadata}")
    return graph, metadata


def measure(launches, data, batches=7, repeats=20, order_seed=0, timing="graph-host"):
    """Shuffle paired measurements of the operand path and prefetch controls."""
    metadata, graphs = {}, {}
    if timing == "graph-host":
        for name, launch in launches.items():
            graphs[name], metadata[name] = capture(launch, data)
        callbacks = {name: graph.replay for name, graph in graphs.items()}
        operations = 32
    else:
        a, b, storage, _ = data
        m, n, _ = CONTEXT["SHAPE"]
        out = storage[:-16].view(m, n)
        callbacks = {
            name: (lambda launch=launch: launch(a, b, out=out))
            for name, launch in launches.items()
        }
        operations = 1
    for callback in callbacks.values():
        for _ in range(3):
            callback()
    samples = {name: [] for name in callbacks}
    orders = []
    generator = random.Random(order_seed)
    for _ in range(batches):
        order = list(callbacks)
        generator.shuffle(order)
        orders.append(order)
        for name in order:
            samples[name].append(
                COMMON["timed_batch"](callbacks[name], repeats) / operations
            )
    ratios = {
        name: [
            a / b for a, b in zip(samples["operand_paths"], samples[name], strict=True)
        ]
        for name in launches
        if name != "operand_paths"
    }
    for launch in launches.values():
        if timing != "graph-host":
            COMMON["check_launch_workspace"](launch, data)
    return {
        "median_ms": {
            name: statistics.median(values) for name, values in samples.items()
        },
        "paired_ratios": ratios,
        **{
            f"ratio_to_{name}": statistics.median(values)
            for name, values in ratios.items()
        },
        "samples_ms": samples,
        "orders": orders,
        "batches": batches,
        "repeats": repeats,
        "warmups_per_implementation": 3,
        "timing": timing,
        "graph_metadata": metadata,
    }


def controls(shape, config):
    key = "x".join(map(str, shape))
    tuned = PREFETCH["Config"](**PREFETCH_SELECTION["shapes"][key])
    launches = {
        "prefetch": partial(PREFETCH["matmul_bf16"], config=tuned),
        "torch": COMMON["torch_launch"],
    }
    compatible = {
        name: value
        for name, value in asdict(config).items()
        if name in PREFETCH["Config"].__dataclass_fields__
    }
    try:
        matched = PREFETCH["Config"](**compatible)
        PREFETCH["validate_config"](matched, shape)
    except ValueError:
        pass
    else:
        launches["matched_prefetch"] = partial(PREFETCH["matmul_bf16"], config=matched)
    return launches


def environment(shape):
    configure(shape)
    factory_hash = hashlib.sha256(
        inspect.getsource(MODULE["_matmul_bf16"]._original_func).encode()
    ).hexdigest()
    return {
        **COMMON["environment"](),
        "kernel_build_sha256": factory_hash,
        "native_factory_sha256": factory_hash,
        "comparison": "operand_paths_vs_prefetch",
        "candidate": "operand_paths",
        "source_sha256": {
            name: hashlib.sha256((HERE / name).read_bytes()).hexdigest()
            for name in ("solution.py", "tune.py")
        },
        "controls": {
            "prefetch": PREFETCH_SELECTION["shapes"]["x".join(map(str, shape))],
        },
        "prefetch_selection_sha256": hashlib.sha256(
            (HERE / "results/prefetch-control.json").read_bytes()
        ).hexdigest(),
        "helper_sha256": {
            str(path.relative_to(HERE.parents[3])): hashlib.sha256(
                path.read_bytes()
            ).hexdigest()
            for path in (
                HERE.parent / "09-split-k/tune.py",
                HERE.parent / "10c-k-unrolling/solution.py",
            )
        },
    }


def compare(config, shape, timing="graph-host", *, matmul=None):
    shape = tuple(shape)
    configure(shape)
    launcher = matmul or MODULE["matmul_bf16"]
    data = COMMON["inputs"](13)
    launches = {
        "operand_paths": partial(launcher, config=config),
        **controls(shape, config),
    }
    for launch in launches.values():
        COMMON["validate"](launch, data)
    result = measure(launches, data, 7, 10, timing=timing)
    return {
        **result,
        "kernel_ms": result["median_ms"]["operand_paths"],
        "torch_ms": result["median_ms"]["torch"],
        "paired_ratio": result["ratio_to_torch"],
    }


def verify(config, shape, seeds, timing):
    configure(shape)
    result = {
        "kind": "held_out_verification",
        "comparison": "operand_paths_vs_prefetch",
        "config": asdict(config),
        "environment": environment(shape),
        "seeds": seeds,
        "timing": timing,
        "rounds": [],
    }
    launches = {
        "operand_paths": partial(MODULE["matmul_bf16"], config=config),
        **controls(shape, config),
    }
    for seed in seeds:
        data = COMMON["inputs"](seed)
        for launch in launches.values():
            COMMON["validate"](launch, data)
        for repetition in range(3):
            measured = measure(launches, data, 7, 20, seed + repetition, timing=timing)
            result["rounds"].append(
                {"seed": seed, "repetition": repetition, **measured}
            )
            print("VERIFY", seed, repetition, measured["median_ms"], flush=True)
    result["median_ms"] = {
        name: statistics.median(row["median_ms"][name] for row in result["rounds"])
        for name in launches
    }
    result["comparisons"] = {
        name: {
            "median_paired_ratio": statistics.median(
                row["ratio_to_" + name] for row in result["rounds"]
            ),
            "worst_round_ratio": max(
                row["ratio_to_" + name] for row in result["rounds"]
            ),
            "win_rounds": sum(
                row["ratio_to_" + name] < 0.95 for row in result["rounds"]
            ),
            "rounds": len(result["rounds"]),
        }
        for name in launches
        if name != "operand_paths"
    }
    result["criterion"] = (
        "Win: every round's median paired ratio <0.95; parity: every round <=1.05."
    )
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, default=(32, 1024, 8192))
    parser.add_argument("--config", help="Explicit JSON configuration object")
    parser.add_argument(
        "--timing", choices=("graph-host", "direct-host"), default="graph-host"
    )
    parser.add_argument(
        "--seeds", type=int, nargs="+", default=(2026112801, 2026112802, 2026112803)
    )
    parser.add_argument("--verify", action="store_true")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output path")
    shape = tuple(args.shape)
    config = (
        MODULE["Config"](**json.loads(args.config))
        if args.config
        else MODULE["CONFIGS_BY_SHAPE"][shape]
    )
    MODULE["validate_config"](config, shape)
    report = (
        verify(config, shape, args.seeds, args.timing)
        if args.verify
        else compare(config, shape, args.timing)
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2) + "\n")


if __name__ == "__main__":
    main()
