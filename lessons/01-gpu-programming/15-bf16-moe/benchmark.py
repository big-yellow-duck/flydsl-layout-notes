"""Compare BF16 MoE with fixed inputs, preallocated FlyDSL scratch, and paired timings."""

import argparse
import importlib.metadata
import json
import random
import runpy
import statistics
import time
from pathlib import Path

import torch

ROOT = Path(__file__).resolve().parent
COMMON = runpy.run_path(str(ROOT / "common.py"))
LESSONS = {
    name: runpy.run_path(str(ROOT / path / "solution.py"))
    for name, path in (
        ("naive", "00-naive"),
        ("grouped", "01-grouped-wmma"),
        ("fused", "02-fused"),
    )
}
DEFAULT_CASES = [
    (1, 512, 32, 384, 2, "balanced"),
    (8, 512, 32, 384, 2, "balanced"),
    (64, 512, 32, 384, 2, "balanced"),
    (256, 512, 32, 384, 2, "balanced"),
    (256, 512, 32, 384, 2, "skewed"),
]


def parse_case(spec):
    fields = spec.split(",")
    if len(fields) != 6 or fields[-1] not in ("balanced", "skewed"):
        raise argparse.ArgumentTypeError("case must be T,H,E,I,top_k,balanced|skewed")
    try:
        shape = tuple(map(int, fields[:5]))
    except ValueError as error:
        raise argparse.ArgumentTypeError("case dimensions must be integers") from error
    if min(shape) <= 0 or shape[-1] > shape[2]:
        raise argparse.ArgumentTypeError("dimensions must be positive and top_k <= E")
    return (*shape, fields[-1])


def torch_control(cpu_ids, gpu, out):
    """Use BF16 GEMMs with FP32 output and fixed expert assignments."""
    x, gate_up, down, _, weights = gpu
    route_count = cpu_ids.numel()
    top_k = cpu_ids.shape[1]
    h = x.shape[1]
    plan = []
    for expert in range(down.shape[0]):
        slots = torch.where(cpu_ids.view(-1) == expert)[0]
        if slots.numel():
            plan.append((expert, slots.cuda(), (slots // top_k).cuda()))
    contributions = torch.empty((route_count, h), dtype=torch.float32, device=x.device)

    def launch():
        for expert, slots, tokens in plan:
            pair = torch.mm(
                x.index_select(0, tokens), gate_up[expert], out_dtype=torch.float32
            )
            gate, up = pair.chunk(2, dim=1)
            activated = (torch.nn.functional.silu(gate) * up).bfloat16()
            value = torch.mm(activated, down[expert], out_dtype=torch.float32)
            contributions.index_copy_(0, slots, value)
        out.copy_(
            (contributions.view(*weights.shape, h) * weights[..., None]).sum(dim=1)
        )

    return launch


def configs(module, name):
    config = module["Config"]
    candidates = {
        "wide": (config(16, 64, 32), config(16, 64, 32)),
        "prefetch": (config(16, 64, 32, True), config(16, 64, 32, True)),
        "narrow": (config(16, 16, 32, True), config(16, 32, 32, True)),
        "m32": (config(32, 64, 32, True), config(32, 64, 32, True)),
        "k64": (config(16, 64, 64, True), config(16, 64, 64, True)),
        "mixed": (config(16, 64, 32, True), config(16, 64, 64, True)),
        "group-m": (config(16, 32, 32, group_m=4), config(16, 32, 32, group_m=4)),
    }
    return candidates[name]


def callbacks(shape, gpu, cpu_ids, out, tune, vllm):
    naive = LESSONS["naive"]
    grouped = LESSONS["grouped"]
    fused = LESSONS["fused"]
    result = {"torch-expert": (torch_control(cpu_ids, gpu, out), False)}

    def add(name, module, *, options=None):
        options = {} if options is None else options
        config = options.get("config")
        bm = config.block_m if config else 16
        if module is fused:
            spec = module["_workspace_spec"](
                shape,
                bm,
                dispatch=options.get("dispatch", "auto"),
                atomic=options.get("atomic", False),
            )
        elif module is grouped:
            spec = module["_workspace_spec"](shape, bm)
        else:
            spec = module["_workspace_spec"](shape)
        workspace = {
            key: torch.empty(dims, dtype=dtype, device=out.device)
            for key, dims, dtype in spec
        }

        def launch():
            module["moe_bf16"](*gpu, out=out, workspace=workspace, **options)

        result[name] = (launch, True)

    add("naive", naive)
    add("grouped", grouped)
    add("fused-grouped", fused, options={"dispatch": "grouped"})
    add("fused-atomic", fused, options={"dispatch": "grouped", "atomic": True})
    add("fused-auto", fused)
    add("direct-wmma", fused, options={"dispatch": "direct-wmma"})
    add("gemv-4", fused, options={"dispatch": "gemv", "k_lanes": 4})
    if tune:
        for name in ("wide", "prefetch", "narrow", "m32", "k64", "mixed", "group-m"):
            gate, down = configs(fused, name)
            add(
                f"fused-{name}",
                fused,
                options={
                    "dispatch": "grouped",
                    "config": gate,
                    "down_config": down,
                },
            )
        for k_lanes in (2, 8):
            add(
                f"gemv-{k_lanes}",
                fused,
                options={"dispatch": "gemv", "k_lanes": k_lanes},
            )
    if vllm:
        from vllm.model_executor.layers.fused_moe.fused_moe import fused_experts

        x, gate_up, down, ids, weights = gpu
        gate_up = gate_up.transpose(1, 2).contiguous()
        down = down.transpose(1, 2).contiguous()

        def launch_vllm():
            out.copy_(fused_experts(x, gate_up, down, weights, ids))

        result["vllm-triton"] = (launch_vllm, False)
    return result


def check(output, expected, name):
    # vLLM rounds the stage-1 projection before its separate activation.
    rtol, atol = (0.025, 0.025) if name == "vllm-triton" else (0.018, 0.008)
    torch.testing.assert_close(output, expected, rtol=rtol, atol=atol)


def prepare_graphs(
    launches, output, expected, ids, changed_ids, changed_expected, nodes
):
    graphs = {}
    for name, (launch, dynamic) in launches.items():
        output.fill_(float("nan"))
        launch()
        torch.cuda.synchronize()
        check(output, expected, name)

        graph = torch.cuda.CUDAGraph()
        with torch.cuda.graph(graph):
            for _ in range(nodes):
                launch()
        if dynamic:
            backup = ids.clone()
            try:
                ids.copy_(changed_ids)
                output.fill_(float("nan"))
                graph.replay()
                check(output, changed_expected, name)
            finally:
                ids.copy_(backup)
        output.fill_(float("nan"))
        graph.replay()
        check(output, expected, name)
        graphs[name] = graph
    return graphs


def timings(launches, iterations, work_per_call, rounds, seed):
    rng = random.Random(seed)
    samples = {name: [] for name in launches}
    host = {name: [] for name in launches}
    for _ in range(rounds):
        order = list(launches)
        rng.shuffle(order)
        for name in order:
            launch = launches[name]
            start = torch.cuda.Event(enable_timing=True)
            stop = torch.cuda.Event(enable_timing=True)
            torch.cuda.synchronize()
            before = time.perf_counter_ns()
            start.record()
            for _ in range(iterations):
                launch()
            stop.record()
            stop.synchronize()
            denominator = iterations * work_per_call
            host[name].append((time.perf_counter_ns() - before) / 1000 / denominator)
            samples[name].append(start.elapsed_time(stop) * 1000 / denominator)
    if any(value <= 0 for values in samples.values() for value in values):
        return "synchronized-host", host
    return "gpu-event", samples


def route_stats(ids, experts, block_m):
    counts = torch.bincount(ids.long().view(-1), minlength=experts)
    active = counts[counts > 0]
    tiles = ((active + block_m - 1) // block_m).sum().item()
    padded = tiles * block_m
    return {
        "active_experts": active.numel(),
        "mean_rows_per_active_expert": ids.numel() / active.numel(),
        "max_rows_per_expert": active.max().item(),
        "padding_fraction": (padded - ids.numel()) / padded,
    }


def run_case(case, args):
    shape, routing = case[:-1], case[-1]
    inputs = COMMON["make_inputs"](*shape, routing=routing, seed=args.seed)
    experts = torch.randperm(
        shape[2], generator=torch.Generator().manual_seed(args.seed)
    )
    inputs[3].copy_(experts[inputs[3].long()])
    gpu = tuple(value.cuda() for value in inputs)
    # Exercise both worklist and clear/reset logic with substantially different loads.
    changed = gpu[3].clone()
    changed[::2] = -1
    changed[1::2] = torch.arange(shape[-1], dtype=changed.dtype, device=changed.device)
    changed_expected = COMMON["reference"](*inputs[:3], changed.cpu(), inputs[4]).cuda()
    expected = COMMON["reference"](*inputs).cuda()
    output = torch.empty_like(gpu[0])
    launches = callbacks(shape, gpu, inputs[3], output, args.tune, args.vllm)
    if args.only:
        launches = {name: launches[name] for name in args.only}
    graphs = prepare_graphs(
        launches, output, expected, gpu[3], changed, changed_expected, args.nodes
    )
    methods = {}
    all_samples = {}
    for mode, launchers, work_per_call in (
        ("graph", {name: graph.replay for name, graph in graphs.items()}, args.nodes),
        ("direct", {name: pair[0] for name, pair in launches.items()}, 1),
    ):
        method, samples = timings(
            launchers, args.iterations, work_per_call, args.rounds, 15
        )
        methods[mode] = method
        all_samples[mode] = samples
    medians = {
        mode: {
            name: round(statistics.median(times), 3) for name, times in samples.items()
        }
        for mode, samples in all_samples.items()
    }
    print(case, medians, flush=True)
    if args.trace:
        trace = Path(args.trace)
        trace.mkdir(parents=True, exist_ok=True)
        for name in launches:
            if name == "torch-expert":
                continue
            # Repeated direct launches provide one kernel sample per phase per invocation.
            activities = [
                torch.profiler.ProfilerActivity.CPU,
                torch.profiler.ProfilerActivity.CUDA,
            ]
            with torch.profiler.profile(activities=activities) as profiler:
                for _ in range(args.iterations):
                    launches[name][0]()
                torch.cuda.synchronize()
            label = "-".join(map(str, case))
            profiler.export_chrome_trace(str(trace / f"{label}-{name}.json"))
    return {
        "shape": list(shape),
        "routing": routing,
        "route_stats": route_stats(inputs[3], shape[2], 16),
        "timing_method": methods,
        "median_us": medians,
        "samples_us": all_samples,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--case", type=parse_case, action="append", dest="cases")
    parser.add_argument("--tune", action="store_true")
    parser.add_argument(
        "--vllm", action="store_true", help="Include installed vLLM Triton BF16 experts"
    )
    parser.add_argument("--seed", type=int, default=15)
    parser.add_argument("--only", nargs="+", help="Select named implementations")
    parser.add_argument("--nodes", type=int, default=6)
    parser.add_argument("--rounds", type=int, default=5)
    parser.add_argument("--iterations", type=int, default=12)
    parser.add_argument("--output", type=Path)
    parser.add_argument(
        "--trace", type=Path, help="Write per-kernel Chrome traces for direct launches"
    )
    args = parser.parse_args()
    if min(args.nodes, args.rounds, args.iterations) < 1:
        parser.error("nodes, rounds, and iterations must be positive")
    torch.set_num_threads(4)
    torch.cuda.init()
    details = {
        "gpu": torch.cuda.get_device_properties(0).gcnArchName,
        "torch": torch.__version__,
        "hip": torch.version.hip,
        "flydsl": importlib.metadata.version("flydsl"),
        "vllm": importlib.metadata.version("vllm") if args.vllm else None,
        "seed": args.seed,
        "graph_invocations_per_capture": args.nodes,
        "iterations": args.iterations,
        "rounds": args.rounds,
        "cases": [run_case(case, args) for case in (args.cases or DEFAULT_CASES)],
    }
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(json.dumps(details, indent=2) + "\n")


if __name__ == "__main__":
    main()
