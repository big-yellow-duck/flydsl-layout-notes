import ctypes
import runpy
import statistics
import time
from pathlib import Path

import flydsl.expr as fx
import torch

ns = runpy.run_path(str(Path(__file__).resolve().parents[1] / "solution.py"))
hip = ctypes.CDLL("libamdhip64.so")
hip.hipGraphGetNodes.argtypes = [
    ctypes.c_void_p,
    ctypes.POINTER(ctypes.c_void_p),
    ctypes.POINTER(ctypes.c_size_t),
]
C = ns["Config"]
configs = [
    C(32, 32, 32),
    C(128, 64, 64),
    C(128, 128, 32),
    C(64, 128, 32, 1, 4),
    C(128, 128, 64),
]
generator = torch.Generator().manual_seed(91)
a_cpu = torch.randn(1024, 1024, generator=generator).to(torch.bfloat16)
b_cpu = torch.randn(1024, 1024, generator=generator).to(torch.bfloat16)
a = a_cpu.cuda()
b = b_cpu.cuda()
out = torch.empty_like(a)
stream = torch.cuda.Stream()
graphs = {}
launches = {"torch": lambda: torch.matmul(a, b, out=out)}
for c in configs:
    run = ns["build"](c)
    launches[c.name] = lambda run=run: run(
        a, b, out, 1024, 1024, 1024, fx.Stream(stream)
    )
for name, launch in launches.items():
    with torch.cuda.stream(stream):
        for _ in range(3):
            launch()
    torch.cuda.synchronize()
    graph = torch.cuda.CUDAGraph(keep_graph=True)
    with torch.cuda.graph(graph, stream=stream):
        for _ in range(32):
            launch()
    count = ctypes.c_size_t()
    status = hip.hipGraphGetNodes(
        ctypes.c_void_p(graph.raw_cuda_graph()), None, ctypes.byref(count)
    )
    assert status == 0, (name, status)
    assert count.value == 32, (name, count.value)
    graph.instantiate()
    graphs[name] = graph
    print("CAPTURED", name, count.value, flush=True)
# Replay must use new input contents and write a freshly cleared output.
a_cpu = torch.randn(1024, 1024, generator=generator).to(torch.bfloat16)
b_cpu = torch.randn(1024, 1024, generator=generator).to(torch.bfloat16)
a.copy_(a_cpu)
b.copy_(b_cpu)
ref = (a_cpu.float() @ b_cpu.float()).to(torch.bfloat16)
torch.cuda.synchronize()
for name, graph in graphs.items():
    out.fill_(float("nan"))
    torch.cuda.synchronize()
    graph.replay()
    torch.cuda.synchronize()
    torch.testing.assert_close(out.cpu(), ref, rtol=0.016, atol=0.03125)
    print("REPLAY CHECKED", name, flush=True)
for round in range(3):
    samples = {name: [] for name in graphs}
    for batch in range(7):
        names = list(graphs)
        if (batch + round) % 2:
            names.reverse()
        for name in names:
            torch.cuda.synchronize()
            t = time.perf_counter()
            for _ in range(10):
                graphs[name].replay()
            torch.cuda.synchronize()
            samples[name].append((time.perf_counter() - t) * 1000 / 320)
    print(
        "ROUND",
        round,
        {
            name: roundval
            for name, roundval in [
                (name, statistics.median(s)) for name, s in samples.items()
            ]
        },
        flush=True,
    )
