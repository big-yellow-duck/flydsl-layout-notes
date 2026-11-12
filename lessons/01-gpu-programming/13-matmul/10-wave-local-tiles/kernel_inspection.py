"""Shared native inspector for the focused skinny-prefetch sequence."""

import argparse
import hashlib
import inspect
import json
import os
import re
import runpy
import subprocess
import sys
from collections import Counter
from pathlib import Path


def main(here):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, default=(16, 4096, 8192))
    parser.add_argument("--config", help="Explicit JSON configuration")
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--worker", action="store_true", help=argparse.SUPPRESS)
    args = parser.parse_args()
    native = runpy.run_path(str(here / "solution.py"))
    shape = tuple(args.shape)
    config = (
        native["Config"](**json.loads(args.config))
        if args.config
        else native["CONFIGS_BY_SHAPE"][shape]
    )
    if args.worker:
        import torch

        torch.set_num_threads(1)
        print("Exercise passed:", native["solve"](config, shape), flush=True)
        return
    output = args.output.resolve()
    if output.exists():
        parser.error("Use a fresh output directory")
    output.mkdir(parents=True)
    command = [
        sys.executable,
        str(here / "inspect_kernel.py"),
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
        raise RuntimeError(f"Inspection failed: {output / 'stderr.txt'}")
    paths = list((output / "ir").rglob("22_final_isa.s"))
    assert len(paths) == 1, paths
    isa_path = paths[0]
    llvm_path = isa_path.with_name("21_llvm_ir.ll")
    isa, llvm = isa_path.read_text(), llvm_path.read_text()
    resources = {}
    for name in (
        "group_segment_fixed_size",
        "private_segment_fixed_size",
        "vgpr_count",
        "sgpr_count",
    ):
        match = re.search(r"\." + name + r":\s*(\d+)", isa)
        assert match is not None, name
        resources[name] = int(match[1])
    assert resources["group_segment_fixed_size"] == config.lds_bytes
    assert resources["private_segment_fixed_size"] == 0
    assert "v_wmma_f32_16x16x16_bf16" in isa and "buffer_load_b128" in isa
    assert ".amdhsa_wavefront_size32 1" in isa
    assert ".amdhsa_workgroup_processor_mode 1" in isa
    counts = Counter()
    for line in isa.splitlines():
        match = re.match(r"\s+([a-z][a-z0-9_.]+)\s", line)
        if match:
            counts[match[1]] += 1
    slc_loads = sum(
        "buffer_load_b128" in line and " slc" in line for line in isa.splitlines()
    )
    if hasattr(config, "right_cache_modifier"):
        assert bool(slc_loads) == (config.right_cache_modifier == 2)
    if config.split_k > 1:
        assert 'syncscope("agent") acq_rel' in llvm
        assert 'syncscope("agent") release' in llvm
    report = {
        "lesson": here.name,
        "shape_MNK": shape,
        "config": config.__dict__,
        "resources": resources,
        "instruction_sites_static": dict(counts),
        "workgroup_barrier_sites": len(re.findall(r"\bs_barrier\b", isa)),
        "wavefront_scope_present": 'syncscope("wavefront")' in llvm,
        "LDS_only_metadata_present": '"amdgpu-synchronize-as", !"local"' in llvm,
        "B_SLC_load_sites": slc_loads,
        "right_staging_BF16_values_per_thread": config.block_k
        * config.block_n
        // config.compute_threads,
        "native_factory_sha256": hashlib.sha256(
            inspect.getsource(native["_matmul_bf16"]._original_func).encode()
        ).hexdigest(),
        "command": command,
        "scope": "Static code/resources and native correctness, not occupancy or overlapped cycles.",
    }
    for path in (output / "ir").rglob("*"):
        if path.is_file() and path not in (isa_path, llvm_path):
            path.unlink()
    (output / "summary.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))
