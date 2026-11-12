"""Check actual split-K launch order, GEMM results, and workspace reuse on GPU.

Run: pixi run python tools/check_split_k_grouping.py
Temporary copies record each kernel's own block mapping after its final tile-ID
assignment. The production mapping is exercised without duplicating its layout.
"""

import ast
import runpy
import tempfile
from dataclasses import fields
from pathlib import Path

import torch

ROOT = Path(__file__).resolve().parents[1]
LESSONS = (
    "09-split-k",
    "10-wave-local-tiles",
    "10a-synchronization-scope",
    "10b-cache-policy",
    "10c-k-unrolling",
    "12-operand-paths",
)


def instrument(source, independent_waves):
    tree = ast.parse(source)
    kernel = next(
        node
        for node in ast.walk(tree)
        if isinstance(node, ast.FunctionDef) and node.name == "_matmul_bf16"
    )
    assignment = next(
        node
        for node in kernel.body
        if isinstance(node, ast.Assign)
        and any(
            isinstance(target, ast.Name) and target.id == "flat_block_id"
            for target in node.targets
        )
    )
    logical_id = "logical_block_id" if independent_waves else "fx.block_idx.x"
    local_thread = "compute_thread_id" if independent_waves else "fx.thread_idx.x"
    recording = f"""
    # Extra test-only storage follows the production partial workspace.
    record_base = tiles_m * tiles_n * SPLIT_K * BLOCK_M * BLOCK_N + {logical_id} * 4
    if {local_thread} == 0:
        partials[record_base] = fx.Float32(block_row)
        partials[record_base + 1] = fx.Float32(block_col)
        partials[record_base + 2] = fx.Float32(split_id)
        partials[record_base + 3] = fx.Float32(flat_block_id)
"""
    lines = source.splitlines(keepends=True)
    lines.insert(assignment.end_lineno, recording)
    return "".join(lines)


def check(module, config):
    m, n, k = 4 * config.block_m, 2 * config.block_n, 384
    shape = (m, n, k)
    module["validate_config"](config, shape)
    # Test-only recording storage is passed to the private JIT bridge so even
    # unsplit probes can record IDs without adding production workspace.
    run = module["_launch_matmul_bf16"]
    fields_by_parameter = {
        "BLOCK_M": "block_m",
        "BLOCK_N": "block_n",
        "BLOCK_K": "block_k",
        "WAVES_M": "waves_m",
        "WAVES_N": "waves_n",
        "GROUP_M": "group_m",
        "SPLIT_K": "split_k",
        "WAVE_GROUPS": "wave_groups",
        "SYNC_MODE": "sync_mode",
        "K_UNROLL": "k_unroll",
        "RIGHT_CACHE_MODIFIER": "right_cache_modifier",
        "LEFT_CACHE_MODIFIER": "left_cache_modifier",
        "LEFT_IN_REGISTERS": "left_in_registers",
    }
    tuning = {
        name: getattr(config, field)
        for name, field in fields_by_parameter.items()
        if name in run.func.__annotations__
    }
    tiles_m, tiles_n = m // config.block_m, n // config.block_n
    logical_blocks = tiles_m * tiles_n * config.split_k
    partial_count = logical_blocks * config.block_m * config.block_n
    counter_count = (
        tiles_m * tiles_n * getattr(config, "compute_threads", config.threads)
    )
    storage = torch.full(
        (partial_count + logical_blocks * 4 + 16,),
        -777,
        dtype=torch.float32,
        device="cuda",
    )
    partials = storage[:-16]
    counters = torch.zeros(counter_count + 16, dtype=torch.int32, device="cuda")
    counters[-16:] = -123
    output = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
    out = output[:-16].view(m, n)
    generator = torch.Generator().manual_seed(20261112)
    a_cpu = torch.randn(m, k, generator=generator).to(torch.bfloat16)
    b_cpu = torch.randn(k, n, generator=generator).to(torch.bfloat16)
    a, b = a_cpu.cuda(), b_cpu.cuda()
    reference = (a_cpu.float() @ b_cpu.float()).to(torch.bfloat16)
    width = min(config.group_m, tiles_m)
    # Independent specification: rows sharing B's K slice are consecutive.
    expected = torch.tensor(
        [
            (row, col, split, row * tiles_n + col)
            for first_row in range(0, tiles_m, width)
            for col in range(tiles_n)
            for split in range(config.split_k)
            for row in range(first_row, first_row + width)
        ],
        dtype=torch.float32,
    )
    assert len(set(map(tuple, expected[:, :3].tolist()))) == logical_blocks
    for sign in (1, -1, 1):
        a.copy_(a_cpu * sign)
        out.fill_(float("nan"))
        run(a, b, out, partials, counters[:-16], *shape, **tuning)
        torch.cuda.synchronize()
        torch.testing.assert_close(
            out.cpu(), reference * sign, rtol=0.016, atol=0.03125
        )
        actual = partials[partial_count:].view(logical_blocks, 4).cpu()
        torch.testing.assert_close(actual, expected, rtol=0, atol=0)
        assert torch.all(output[-16:] == -99).item(), "Output sentinel changed"
        assert torch.all(storage[-16:] == -777).item(), "Partial sentinel changed"
        assert torch.all(counters[:-16] == 0).item(), "Counters not reset"
        assert torch.all(counters[-16:] == -123).item(), "Counter sentinel changed"


def main():
    torch.set_num_threads(1)
    total = 0
    for name in LESSONS:
        folder = ROOT / "lessons/01-gpu-programming/13-matmul" / name
        with tempfile.NamedTemporaryFile(
            mode="w", prefix="_grouping_probe_", suffix=".py", dir=folder
        ) as temp:
            temp.write(
                instrument((folder / "solution.py").read_text(), name != "09-split-k")
            )
            temp.flush()
            module = runpy.run_path(temp.name)
            supported = {field.name for field in fields(module["Config"])}
            for group_m, split_k, wave_groups in (
                (1, 2, 1),
                (2, 1, 1),
                (2, 2, 1),
                (2, 4, 2),
                (8, 2, 2),
            ):
                kwargs = {
                    "block_m": 16,
                    "block_n": 64,
                    "block_k": 32,
                    "waves_m": 1,
                    "waves_n": 1,
                    "group_m": group_m,
                    "split_k": split_k,
                }
                if "wave_groups" in supported:
                    kwargs["wave_groups"] = wave_groups
                if "k_unroll" in supported:
                    kwargs["k_unroll"] = 2
                modes = (False, True) if "left_in_registers" in supported else (None,)
                for mode in modes:
                    if mode is not None:
                        kwargs["left_in_registers"] = mode
                    config = module["Config"](**kwargs)
                    check(module, config)
                    total += 1
            print(
                "Grouped launch order, GEMM, and workspace checks passed:",
                name,
                flush=True,
            )
    print(f"All {total} grouped split-K cases passed.")


if __name__ == "__main__":
    main()
