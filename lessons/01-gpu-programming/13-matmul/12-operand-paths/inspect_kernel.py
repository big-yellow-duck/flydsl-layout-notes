"""Inspect selected operand paths, LDS allocation, WMMA, and split-K ordering."""

import argparse
import hashlib
import json
import os
import re
import runpy
import subprocess
import sys
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, default=(32, 1024, 8192))
    parser.add_argument("--config", help="Explicit JSON configuration object")
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--worker", action="store_true", help=argparse.SUPPRESS)
    args = parser.parse_args()
    module = runpy.run_path(str(HERE / "solution.py"))
    shape = tuple(args.shape)
    config = (
        module["Config"](**json.loads(args.config))
        if args.config
        else module["CONFIGS_BY_SHAPE"][shape]
    )
    if args.worker:
        import torch

        torch.set_num_threads(1)
        print("Exercise passed:", module["solve"](config, shape), flush=True)
        return
    output = args.output.resolve()
    if output.exists():
        parser.error("Use a fresh output directory")
    output.mkdir(parents=True)
    command = [
        sys.executable,
        str(Path(__file__).resolve()),
        "--worker",
        "--shape",
        *map(str, shape),
        "--config",
        json.dumps(config.__dict__),
        "--output",
        str(output),
    ]
    result = subprocess.run(
        command,
        env={
            **os.environ,
            "FLYDSL_DUMP_IR": "1",
            "FLYDSL_DUMP_DIR": str(output / "ir"),
        },
        capture_output=True,
        text=True,
        check=False,
    )
    (output / "stdout.txt").write_text(result.stdout)
    (output / "stderr.txt").write_text(result.stderr)
    if result.returncode:
        raise RuntimeError(f"Native inspection failed: {output / 'stderr.txt'}")
    paths = list((output / "ir").rglob("22_final_isa.s"))
    if len(paths) != 1:
        raise RuntimeError(f"Expected one full-shape native dump, found {len(paths)}")
    isa_path = paths[0]
    llvm_path = isa_path.with_name("21_llvm_ir.ll")
    isa, llvm = isa_path.read_text(), llvm_path.read_text()
    resources = {}
    for field in (
        "group_segment_fixed_size",
        "private_segment_fixed_size",
        "vgpr_count",
        "sgpr_count",
    ):
        match = re.search(r"\." + field + r":\s*(\d+)", isa)
        if match is None:
            raise RuntimeError(f"Missing native resource {field}")
        resources[field] = int(match[1])
    assert resources["group_segment_fixed_size"] == config.lds_bytes
    assert resources["private_segment_fixed_size"] == 0, (
        "Selected kernel spills to scratch"
    )
    assert "v_wmma_f32_16x16x16_bf16" in isa
    assert "buffer_load_b128" in isa
    assert ".amdhsa_wavefront_size32 1" in isa
    assert ".amdhsa_workgroup_processor_mode 1" in isa
    if config.split_k > 1:
        assert 'syncscope("agent") acq_rel' in llvm
        assert 'syncscope("agent") release' in llvm
        assert re.search(r"(?:global|flat)_atomic_add", isa)
    instructions = Counter()
    for line in isa.splitlines():
        match = re.match(r"\s+([a-z][a-z0-9_.]+)\s", line)
        if match:
            instructions[match[1]] += 1
    report = {
        "shape_MNK": shape,
        "config": config.__dict__,
        "resources": resources,
        "left_in_registers": config.left_in_registers,
        "native_source_sha256": hashlib.sha256(
            (HERE / "solution.py").read_bytes()
        ).hexdigest(),
        "command": command,
        "instruction_counts_static": dict(instructions),
        "isa_path": str(isa_path),
        "llvm_path": str(llvm_path),
        "checks": "Full native CPU-reference and boundary checks; exact LDS allocation, zero scratch, BF16 WMMA, vector global loads, wave32 WGP mode, agent split-K ordering.",
        "scope": "Static instruction sites and compiler resources, not runtime instruction totals or measured occupancy.",
    }
    for path in (output / "ir").rglob("*"):
        if path.is_file() and path not in (isa_path, llvm_path):
            path.unlink()
    (output / "summary.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
