"""Inspect fine WMMA interleaving, compiler scheduling fences, and resources."""

import argparse
import hashlib
import json
import os
import re
import runpy
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--module", type=Path, default=HERE / "kernel.py")
    parser.add_argument("--shape", type=int, nargs=3, default=(32, 1024, 8192))
    parser.add_argument("--config", help="JSON configuration object")
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--worker", action="store_true", help=argparse.SUPPRESS)
    args = parser.parse_args()
    module = runpy.run_path(str(args.module))
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
        "--module",
        str(args.module.resolve()),
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
        raise RuntimeError(f"Inspection worker failed: {output / 'stderr.txt'}")
    paths = list((output / "ir").rglob("22_final_isa.s"))
    if len(paths) != 1:
        raise RuntimeError(f"Expected one full kernel dump, found {len(paths)}")
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
        found = re.search(r"\." + field + r":\s*(\d+)", isa)
        if found is None:
            raise RuntimeError(f"Missing resource metadata {field}")
        resources[field] = int(found[1])
    assert resources["group_segment_fixed_size"] == config.lds_bytes
    assert "v_wmma_f32_16x16x16_bf16" in isa
    assert "buffer_load" in isa
    if config.schedule == "interleave" and config.compiler_fence:
        assert "llvm.amdgcn.sched.barrier" in llvm
    else:
        assert "llvm.amdgcn.sched.barrier" not in llvm
    assert ".amdhsa_workgroup_processor_mode 1" in isa
    assert ".amdhsa_wavefront_size32 1" in isa
    if config.split_k > 1:
        assert 'syncscope("agent") acq_rel' in llvm
        assert 'syncscope("agent") release' in llvm
        assert re.search(r"(?:global|flat)_atomic_add", isa)
    else:
        assert "buffer_gl0_inv" not in isa
    # Retain basic-block locations for reviewing the role branch, rather than
    # inferring producer/consumer concurrency from an instruction count.
    blocks, label = {}, "entry"
    for line in llvm.splitlines():
        match = re.match(r"^([A-Za-z0-9_.$-]+):", line)
        if match:
            label = match[1]
        if "call" in line and "buffer.load" in line:
            blocks.setdefault(label, {"buffer_loads": 0, "wmma": 0})[
                "buffer_loads"
            ] += 1
        if "call" in line and "wmma" in line:
            blocks.setdefault(label, {"buffer_loads": 0, "wmma": 0})["wmma"] += 1
    assert any(row["buffer_loads"] for row in blocks.values())
    assert any(row["wmma"] for row in blocks.values())
    report = {
        "config": config.__dict__,
        "schedule": config.schedule,
        "compiler_scheduling_fences": llvm.count(
            "call void @llvm.amdgcn.sched.barrier"
        ),
        "wave32_wgp_mode": True,
        "shape_MNK": shape,
        "module": str(args.module.resolve()),
        "source_sha256": hashlib.sha256(args.module.read_bytes()).hexdigest(),
        "resources": resources,
        "workgroup_barrier_sites": len(re.findall(r"\bs_barrier\b", isa)),
        "input_load_and_wmma_blocks": blocks,
        "isa_path": str(isa_path),
        "llvm_path": str(llvm_path),
        "command": command,
        "checks": "BF16 WMMA, global loads, static scheduler fences, wave32 WGP mode, LDS allocation, complete CPU reference and split-K boundaries/ordering",
        "scope": "Static control flow/resources and correctness, not a cycle-level overlap or occupancy measurement",
    }
    # Keep final evidence; intermediate lowering passes can be regenerated.
    for path in (output / "ir").rglob("*"):
        if path.is_file() and path not in (isa_path, llvm_path):
            path.unlink()
    (output / "summary.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
