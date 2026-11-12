"""Shared host measurements for the four focused skinny-prefetch lessons."""

import argparse
import gc
import hashlib
import inspect
import json
import random
import runpy
import statistics
from dataclasses import asdict, replace
from functools import partial
from pathlib import Path

COURSE = Path(__file__).resolve().parent.parent
COMMON = runpy.run_path(str(COURSE / "09-split-k/tune.py"))


def variants(module, config, stage):
    if stage == "10":
        if config.wave_groups == 1:
            return {}
        return {"single_wave_blocks": replace(config, wave_groups=1)}
    if stage == "10a":
        return {
            mode: replace(config, sync_mode=mode)
            for mode in ("workgroup", "lds-workgroup", "lds-subgroup")
            if mode != config.sync_mode
        }
    if stage == "10b":
        return {
            f"B_cache_{policy}": replace(config, right_cache_modifier=policy)
            for policy in (0, 2)
            if policy != config.right_cache_modifier
        }
    return {
        f"unroll_{unroll}": replace(config, k_unroll=unroll)
        for unroll in (1, 2, 4, 8)
        if unroll != config.k_unroll
    }


def capture(launch, data):
    gc.collect()
    enabled = gc.isenabled()
    gc.disable()
    try:
        graph, metadata = COMMON["capture"](launch, data)
    finally:
        if enabled:
            gc.enable()
    assert metadata["nodes"] == 32 + metadata.get("workspace_initialization_nodes", 0)
    assert 32 <= metadata["kernel_nodes"] <= metadata["nodes"]
    return graph, metadata


def compare(
    module,
    config,
    shape,
    stage,
    timing="graph-host",
    matmul=None,
    seed=13,
    batches=5,
    repeats=8,
):
    shape = tuple(shape)
    COMMON["inputs"].__globals__.update(
        MODULE=module, BUILD=module["_matmul_bf16"]._original_func, SHAPE=shape
    )
    data = COMMON["inputs"](seed)
    trace = COMMON["inputs"](0, True)
    launcher = matmul or module["matmul_bf16"]
    configs = {"stage": config, **variants(module, config, stage)}
    launches = {
        name: partial(launcher, config=choice) for name, choice in configs.items()
    }
    launches["torch"] = COMMON["torch_launch"]
    for launch in launches.values():
        COMMON["validate"](launch, trace, True)
        COMMON["validate"](launch, data)
    graphs, metadata = {}, {}
    if timing == "graph-host":
        for name, launch in launches.items():
            graphs[name], metadata[name] = capture(launch, data)
        callbacks = {name: graph.replay for name, graph in graphs.items()}
        operations = 32
    else:
        a, b, storage, _ = data
        out = storage[:-16].view(shape[:2])
        callbacks = {
            name: (lambda fn=fn: fn(a, b, out=out)) for name, fn in launches.items()
        }
        operations = 1
    for callback in callbacks.values():
        for _ in range(3):
            callback()
    samples = {name: [] for name in callbacks}
    orders = []
    rng = random.Random(seed)
    for _ in range(batches):
        order = list(callbacks)
        rng.shuffle(order)
        orders.append(order)
        for name in order:
            samples[name].append(
                COMMON["timed_batch"](callbacks[name], repeats) / operations
            )
    for launch in launches.values():
        if timing != "graph-host":
            COMMON["check_launch_workspace"](launch, data)
    medians = {name: statistics.median(values) for name, values in samples.items()}
    ratios = {
        name: statistics.median(
            a / b for a, b in zip(samples["stage"], values, strict=True)
        )
        for name, values in samples.items()
        if name != "stage"
    }
    return {
        "lesson": stage,
        "shape_MNK": shape,
        "configurations": {name: asdict(choice) for name, choice in configs.items()},
        "environment": {
            **COMMON["environment"](),
            "native_factory_sha256": hashlib.sha256(
                inspect.getsource(module["_matmul_bf16"]._original_func).encode()
            ).hexdigest(),
        },
        "kernel_ms": medians["stage"],
        "torch_ms": medians["torch"],
        "paired_ratio": ratios["torch"],
        "median_ms": medians,
        "paired_ratios": ratios,
        "samples_ms": samples,
        "orders": orders,
        "timing": timing,
        "graph_metadata": metadata,
        "batches": batches,
        "repeats": repeats,
        "seed": seed,
        "right_staging_BF16_values_per_thread": config.block_k
        * config.block_n
        // config.compute_threads,
        "lds_bytes": config.lds_bytes,
        "scope": "Warm matched buffers, synchronized host clock, allocations excluded; performance is an observation.",
    }


def main(module, here, stage):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, default=(16, 4096, 8192))
    parser.add_argument(
        "--timing", choices=("graph-host", "direct-host"), default="graph-host"
    )
    parser.add_argument("--seed", type=int, default=13)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output path")
    shape = tuple(args.shape)
    config = module["CONFIGS_BY_SHAPE"][shape]
    report = compare(module, config, shape, stage, args.timing, seed=args.seed)
    report["source_sha256"] = hashlib.sha256(
        (here / "solution.py").read_bytes()
    ).hexdigest()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report["median_ms"]))
