"""Check bounded M-tail stores, original selectors and completed practice fidelity."""

import argparse
import ast
import json
import runpy
from dataclasses import replace
from pathlib import Path

import torch


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output path")
    torch.set_num_threads(1)
    lesson = (
        Path(__file__).resolve().parents[1]
        / "lessons/01-gpu-programming/13-matmul/12-operand-paths"
    )
    module = runpy.run_path(str(lesson / "solution.py"))
    record = {"tails": [], "original_selectors": []}
    for m in (1, 2, 4, 8, 17, 31):
        for registers, gm, gn, split in (
            (True, 1, 1, 1),
            (True, 1, 2, 4),
            (True, 2, 1, 2),
            (True, 2, 2, 4),
            (False, 1, 1, 4),
            (False, 1, 2, 1),
            (False, 2, 1, 4),
            (False, 2, 2, 2),
        ):
            config = module["Config"](
                stage_k=32,
                waves_per_group_n=1,
                wave_groups_m=gm,
                wave_groups_n=gn,
                split_k=split,
                k_unroll=2,
                left_in_registers=registers,
            )
            n, k = 128, 256
            padded_m = ((m + 15) // 16) * 16
            # Backing allocations extend beyond logical A/C; retain poisoned rows.
            a_storage = torch.full(
                ((padded_m + 16) * k,), 77, dtype=torch.bfloat16, device="cuda"
            )
            a = a_storage[: m * k].view(m, k)
            a.copy_(torch.arange(1, m + 1, device="cuda")[:, None].expand(m, k))
            b = torch.ones((k, n), dtype=torch.bfloat16, device="cuda")
            c_storage = torch.full(
                ((padded_m + 16) * n,), -99, dtype=torch.bfloat16, device="cuda"
            )
            c = c_storage[: m * n].view(m, n)
            expected = (torch.arange(1, m + 1)[:, None].expand(m, n) * k).to(
                torch.bfloat16
            )
            for sign in (1, -1, 1):
                b.fill_(sign)
                c.fill_(float("nan"))
                module["matmul_bf16"](a, b, out=c, config=config)
                torch.cuda.synchronize()
                torch.testing.assert_close(c.cpu(), expected * sign, rtol=0, atol=0)
                assert torch.all(c_storage[m * n :] == -99).item()
                assert torch.all(a_storage[m * k :] == 77).item()
            record["tails"].append({"m": m, "config": config.name, "reuses": 3})
    for shape, config in module["CONFIGS_BY_SHAPE"].items():
        for split in (1, 2, 4):
            record["original_selectors"].append(
                module["solve"](replace(config, split_k=split), shape)
            )
    practice = (lesson / "practice.py").read_text()
    practice = practice.replace(
        'left_direct_plan = None\n    if left_direct_plan is None:\n        raise NotImplementedError("Fill in left_direct_plan.")',
        "left_direct_plan = fx.make_tiled_copy_A(left_direct_atom, mma).get_slice(thread_id_in_wave_group)",
    ).replace(
        'left_current = None\n            if left_current is None:\n                raise NotImplementedError("Fill in left_current.")',
        "left_current = fx.slice(left_full_tiled, (None, None, None, 0, 0, inner_k))",
    )
    completed, solution = (
        ast.parse(practice),
        ast.parse((lesson / "solution.py").read_text()),
    )
    completed.body.pop(0)
    solution.body.pop(0)
    assert ast.dump(completed) == ast.dump(solution)
    record["completed_practice_ast_matches_solution"] = True
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(record, indent=2) + "\n")
    print(
        "Passed:",
        len(record["tails"]),
        "tail cases and",
        len(record["original_selectors"]),
        "original shape/split cases",
    )


if __name__ == "__main__":
    main()
