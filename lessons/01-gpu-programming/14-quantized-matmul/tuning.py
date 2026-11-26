"""Use a staged, route-aware search for fused quantized matmul."""

import json
import runpy
from dataclasses import asdict, replace
from functools import partial
from pathlib import Path
from statistics import median

import torch

_benchmark = runpy.run_path(str(Path(__file__).with_name("benchmark.py")))
capture, measure, wins_each_round = (
    _benchmark[name] for name in ("capture", "measure", "wins_each_round")
)
VERIFY_SEEDS = (5101, 5202, 5303)
SMALL_N_SHAPES = ((16, 1, 4096), (16, 7, 4097), (128, 16, 4096))


def small_n_configs(config_type, shape, kernel, *, allow_direct_a):
    """Use tested Stage 16 geometries as seeds, with no timing reused."""
    archive_path = (
        Path(__file__).resolve().parents[1]
        / "13-matmul/16-right-register-staging/results/gfx1151-small-n.json"
    )
    archive = json.loads(archive_path.read_text())
    row = next(
        case
        for case in archive["cases"]
        if case["kernel"] == kernel and tuple(case["shape_MNK"]) == shape
    )
    configs = [
        config_type(**{key: value for key, value in cfg.items() if key != "lds_bytes"})
        for cfg in row["configs"].values()
    ]
    if allow_direct_a:
        configs.extend(
            replace(
                config_type(
                    **{
                        key: value
                        for key, value in row["configs"][label].items()
                        if key != "lds_bytes"
                    }
                ),
                left_in_registers=False,
            )
            for label in row["finalists"].values()
        )
    return tuple(dict.fromkeys(configs))


def geometry_seeds(shape):
    m, n, k = shape
    if n <= 32:
        n_tile = 16 if n <= 16 else 32
        return (
            (16, n_tile, 1, 1),
            (32, n_tile, 1, 1),
            (32, n_tile, 2, 1),
            (16, 32, 1, 2),
        )
    if k <= 96:
        return ((16, 16, 1, 1), (16, 32, 1, 1), (16, 64, 1, 2), (32, 64, 1, 2))
    if m < 128:
        return ((16, 16, 1, 1), (16, 64, 1, 2), (32, 128, 1, 4), (32, 64, 2, 1))
    return ((32, 32, 1, 1), (64, 64, 2, 2), (64, 128, 2, 2), (128, 128, 2, 2))


def tune(
    shape,
    initial,
    validate,
    make_case,
    *,
    allow_direct_a,
    beam=1,
    seeds=(),
    warm_start=(),
):
    """Search both B routes and remeasure finalists on three fresh inputs.

    make_case(seed) returns a launcher, sign flip, output, sentinel, and reference.
    The launcher accepts a config and writes the supplied output in place.
    """
    trials = {}
    screen_data = make_case(17)

    def timing(configs, data, seed, *, graph_gemms, batches, replays):
        launch, flip, c, sentinel, expected = data
        graphs = {}

        for name, cfg in configs.items():
            graphs[name] = capture(
                partial(launch, cfg), flip, c, sentinel, expected, graph_gemms
            )
        medians, samples, orders = measure(graphs, graph_gemms, batches, replays, seed)
        return {
            "seed": seed,
            "median_ms": medians,
            "samples_ms": samples,
            "batch_orders": orders,
        }

    def screen(cfg):
        if cfg in trials:
            return
        row = trials[cfg] = {"config": asdict(cfg), "name": cfg.name}
        try:
            validate(cfg, shape)
        except ValueError as error:
            row["excluded"] = str(error)
            return
        result = timing(
            {cfg.name: cfg}, screen_data, 17, graph_gemms=4, batches=3, replays=4
        )
        row["median_ms"] = result["median_ms"][cfg.name]
        row["samples_ms"] = result["samples_ms"][cfg.name]

    def ranked(direct_b):
        return sorted(
            (
                cfg
                for cfg, row in trials.items()
                if cfg.right_in_registers == direct_b and "median_ms" in row
            ),
            key=lambda cfg: trials[cfg]["median_ms"],
        )

    # Start by separating the operand routes from geometry so each gets a finalist.
    screen(initial)
    for cfg in warm_start:
        screen(cfg)
    if seeds:
        for cfg in seeds:
            screen(cfg)
        # Remeasure geometry transferred from a related decoder against the
        # current default. Compare both cache policies on each route as well.
        for direct_b in (False, True):
            best = ranked(direct_b)[0]
            for cache in (0, 2):
                screen(replace(best, right_cache_modifier=cache))
    else:
        for direct_b in (False, True):
            for direct_a in (False, True) if allow_direct_a else (False,):
                route = replace(
                    initial, left_in_registers=direct_a, right_in_registers=direct_b
                )
                screen(route)
                for bm, bn, wm, wn in geometry_seeds(shape):
                    screen(
                        replace(
                            route,
                            group_tile_m=bm,
                            group_tile_n=bn,
                            waves_per_group_m=wm,
                            waves_per_group_n=wn,
                            wave_groups_m=1,
                            wave_groups_n=1,
                            traversal_group_m=1,
                            stage_k=32,
                            k_unroll=2,
                        )
                    )

        m, n, k = shape
        for direct_b in (False, True):
            for cfg in ranked(direct_b)[:beam]:
                for depth in (16, 32, 64):
                    for splits in (1, 2, 4):
                        if k <= 64 and depth * splits > 64:
                            continue
                        screen(replace(cfg, stage_k=depth, split_k=splits))
            for cfg in ranked(direct_b)[:beam]:
                for unroll in (1, 2, 4, 8, 16):
                    if beam == 1 and cfg.stage_k * unroll > 512:
                        break
                    if (k + cfg.stage_k * cfg.split_k - 1) // (
                        cfg.stage_k * cfg.split_k
                    ) <= unroll:
                        # Equal fully unrolled variants have the same schedule on this shape.
                        screen(replace(cfg, k_unroll=unroll))
                        break
                    screen(replace(cfg, k_unroll=unroll))
                for ac, bc in ((0, 0), (0, 1), (0, 2), (1, 2), (2, 0), (2, 2), (2, 3)):
                    screen(
                        replace(cfg, left_cache_modifier=ac, right_cache_modifier=bc)
                    )

            best = ranked(direct_b)[0]
            if m > best.group_tile_m:
                for traversal in (2, 4, 8):
                    if (
                        m > (traversal // 2) * best.group_tile_m
                        and n > best.group_tile_n
                    ):
                        screen(replace(best, traversal_group_m=traversal))
            one_wave = next(
                (cfg for cfg in ranked(direct_b) if cfg.compute_threads == 32),
                None,
            )
            if one_wave is not None:
                for gm, gn in ((2, 1), (1, 2), (2, 2)):
                    if (gm == 1 or m > one_wave.group_tile_m) and (
                        gn == 1 or n > one_wave.group_tile_n
                    ):
                        screen(replace(one_wave, wave_groups_m=gm, wave_groups_n=gn))

    shortlist = dict.fromkeys([initial, *ranked(False)[:3], *ranked(True)[:3]])
    finalists = {cfg.name: cfg for cfg in shortlist}
    rounds = [
        timing(finalists, make_case(seed), seed, graph_gemms=16, batches=7, replays=7)
        for seed in VERIFY_SEEDS
    ]
    medians = {
        name: median(row["median_ms"][name] for row in rounds) for name in finalists
    }
    winner = initial
    for name in sorted(medians, key=medians.__getitem__):
        if name == initial.name:
            break
        if wins_each_round(rounds, name, initial.name):
            winner = finalists[name]
            break
    # A register winner must also beat the fastest verified LDS finalist in each round.
    best_lds = min(
        (cfg for cfg in shortlist if not cfg.right_in_registers),
        key=lambda cfg: medians[cfg.name],
    )
    if winner.right_in_registers and not wins_each_round(
        rounds, winner.name, best_lds.name
    ):
        winner = (
            best_lds
            if initial.right_in_registers
            or wins_each_round(rounds, best_lds.name, initial.name)
            else initial
        )
    return {
        "shape_MNK": shape,
        "search": "shared candidates" if seeds else "full staged search",
        "initial_config": asdict(initial),
        "initial_config_name": initial.name,
        "selected_config": asdict(winner),
        "selected_config_name": winner.name,
        "verified_median_ms": medians,
        "trials": list(trials.values()),
        "verification": rounds,
    }


def cuda_case(tensors, expected, launch, *, flip_operand, sign_mask):
    m, n = expected.shape
    inputs = tuple(tensor.cuda() for tensor in tensors)
    storage = torch.full((m * n + 16,), -99, device="cuda", dtype=torch.bfloat16)
    c = storage[:-16].view(m, n)

    def run(config):
        launch(*inputs, out=c, config=config)

    def flip():
        inputs[flip_operand].bitwise_xor_(sign_mask)

    return run, flip, c, storage[-16:], expected.cuda()
