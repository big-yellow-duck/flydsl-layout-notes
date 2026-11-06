"""Check the full wave-local specialization's barrier lowering and resources."""

import argparse
import hashlib
import json
import os
import re
import runpy
import subprocess
import sys
from dataclasses import replace
from pathlib import Path

HERE = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--split-k", type=int, choices=(1, 2, 4), default=1)
    args = parser.parse_args()
    output = args.output.resolve()
    if output.exists():
        parser.error("Use a fresh output directory")
    output.mkdir(parents=True)
    command = [
        sys.executable,
        str(HERE / "solution.py"),
        "--check-only",
        "--split-k",
        str(args.split_k),
    ]
    result = subprocess.run(
        command,
        env={
            **os.environ,
            "FLYDSL_DUMP_IR": "1",
            "FLYDSL_DUMP_DIR": str(output / "ir"),
        },
        text=True,
        capture_output=True,
        check=False,
    )
    (output / "stdout.txt").write_text(result.stdout)
    (output / "stderr.txt").write_text(result.stderr)
    if result.returncode:
        raise RuntimeError(f"Kernel check failed: {output / 'stderr.txt'}")
    files = list((output / "ir").rglob("*final_isa.s"))
    if len(files) != 1:
        raise RuntimeError(f"Expected one ISA dump, found {len(files)}")
    isa_path = files[0]
    isa = isa_path.read_text()
    llvm_path = isa_path.with_name("21_llvm_ir.ll")
    llvm = llvm_path.read_text()
    config = runpy.run_path(str(HERE / "solution.py"))["CONFIGS_BY_SHAPE"][
        (16, 4096, 8192)
    ]
    config = replace(config, split_k=args.split_k)
    resources = {}
    for field in (
        "group_segment_fixed_size",
        "private_segment_fixed_size",
        "vgpr_count",
        "sgpr_count",
    ):
        match = re.search(r"\." + field + r":\s*(\d+)", isa)
        if match is None:
            raise RuntimeError(f"Missing resource metadata: {field}")
        resources[field] = int(match[1])
    assert resources["group_segment_fixed_size"] == config.lds_bytes
    assert resources["private_segment_fixed_size"] == 0
    assert "v_wmma_f32_16x16x16_bf16" in isa
    if args.split_k == 1:
        assert "buffer_gl0_inv" not in isa, "Unexpected global-cache invalidation"
    else:
        assert 'syncscope("agent") acq_rel' in llvm
        assert 'syncscope("agent") release' in llvm
        assert re.search(r"(?:global|flat)_atomic_add", isa)
    assert not re.search(r"\bs_barrier\b", isa), "Unexpected workgroup rendezvous"
    assert 'syncscope("wavefront")' in llvm and "!mmra" in llvm
    assert '"amdgpu-synchronize-as", !"local"' in llvm
    report = {
        "config": config.name,
        "resources": resources,
        "source_sha256": hashlib.sha256(
            (HERE / "solution.py").read_bytes()
        ).hexdigest(),
        "command": command,
        "isa_path": str(isa_path),
        "llvm_path": str(llvm_path),
        "checks": "BF16 WMMA, wavefront fences restricted to LDS, no workgroup rendezvous, zero scratch, full-output correctness; no global invalidation for split_k=1, agent AcqRel arrival and release reset for split_k>1",
        "scope": "wide specialization at the recorded split count",
    }
    (output / "summary.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
