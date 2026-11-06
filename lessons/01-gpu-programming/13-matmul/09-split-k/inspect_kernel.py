"""Dump the full skinny specialization's ISA, resources, and atomic ordering."""

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
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    output = args.output.resolve()
    if output.exists():
        parser.error("Use a fresh output directory")
    output.mkdir(parents=True)
    command = [sys.executable, str(HERE / "solution.py"), "--check-only"]
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
        raise RuntimeError(f"Kernel check failed; inspect {output / 'stderr.txt'}")
    files = list((output / "ir").rglob("*final_isa.s"))
    if len(files) != 1:
        raise RuntimeError(f"Expected one ISA dump, found {len(files)}")
    text = files[0].read_text()
    config = runpy.run_path(str(HERE / "solution.py"))["CONFIGS_BY_SHAPE"][
        (16, 1024, 8192)
    ]
    resources = {}
    for field in (
        "group_segment_fixed_size",
        "private_segment_fixed_size",
        "vgpr_count",
        "sgpr_count",
    ):
        match = re.search(r"\." + field + r":\s*(\d+)", text)
        if match is None:
            raise RuntimeError(f"Missing resource metadata: {field}")
        resources[field] = int(match[1])
    assert resources["group_segment_fixed_size"] == config.lds_bytes
    assert "v_wmma_f32_16x16x16_bf16" in text, "Missing BF16 WMMA"
    assert re.search(r"(?:global|flat)_atomic_add", text), "Missing arrival atomic"
    mlir = "\n".join(path.read_text() for path in files[0].parent.glob("*.mlir"))
    assert "acq_rel" in mlir and 'syncscope("agent")' in mlir, "Missing atomic ordering"
    report = {
        "config": config.name,
        "resources": resources,
        "source_sha256": hashlib.sha256(
            (HERE / "solution.py").read_bytes()
        ).hexdigest(),
        "isa_path": str(files[0]),
        "command": command,
        "checks": "BF16 WMMA, arrival atomic, agent acquire/release, LDS size, full-output correctness",
        "scope": "static instructions/resources, not a timing or occupancy measurement",
    }
    (output / "summary.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
