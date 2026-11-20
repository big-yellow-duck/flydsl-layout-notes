"""Shared GPU graph capture and timing for the quantized matmul lessons."""

import random
import statistics

import torch


def capture(callback, flip_inputs, output, sentinel, expected, graph_gemms):
    def check(reference):
        torch.testing.assert_close(output, reference, rtol=0.016, atol=0.03125)
        assert torch.all(sentinel == -99).item(), "Output sentinel changed"

    output.fill_(float("nan"))
    callback()
    torch.cuda.synchronize()
    check(expected)
    graph = torch.cuda.CUDAGraph()
    with torch.cuda.graph(graph):
        for _ in range(graph_gemms):
            callback()
    # Replay must read the modified input and overwrite the poisoned output.
    flip_inputs()
    try:
        output.fill_(float("nan"))
        graph.replay()
        torch.cuda.synchronize()
        check(-expected)
    finally:
        flip_inputs()
    output.fill_(float("nan"))
    graph.replay()
    torch.cuda.synchronize()
    check(expected)
    return graph


def measure(graphs, graph_gemms, batches, replays, seed):
    samples = {name: [] for name in graphs}
    orders = []
    rng = random.Random(seed)
    for _ in range(batches):
        order = list(graphs)
        rng.shuffle(order)
        orders.append(order)
        for name in order:
            start = torch.cuda.Event(enable_timing=True)
            end = torch.cuda.Event(enable_timing=True)
            start.record()
            for _ in range(replays):
                graphs[name].replay()
            end.record()
            end.synchronize()
            samples[name].append(start.elapsed_time(end) / (replays * graph_gemms))
    return (
        {name: statistics.median(values) for name, values in samples.items()},
        samples,
        orders,
    )


def wins_each_round(rounds, candidate, control):
    return all(
        statistics.median(
            measured / baseline
            for measured, baseline in zip(
                row["samples_ms"][candidate], row["samples_ms"][control], strict=True
            )
        )
        < 1
        for row in rounds
    )
