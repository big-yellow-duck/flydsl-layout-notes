"""Capture the selected specialization's full-workload ISA and static resources."""

import argparse
import hashlib
import json
import os
import re
import runpy
import shutil
import subprocess
import sys
from pathlib import Path

import flydsl  # noqa: F401

HERE = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    output = args.output.resolve()
    if output.exists():
        parser.error("Use a fresh output directory")
    output.mkdir(parents=True)
    environment = {
        **os.environ,
        "FLYDSL_DUMP_IR": "1",
        "FLYDSL_DUMP_DIR": str(output / "ir"),
    }
    command = [sys.executable, str(HERE / "solution.py"), "--check-only"]
    completed = subprocess.run(
        command, env=environment, text=True, capture_output=True, check=False
    )
    (output / "stdout.txt").write_text(completed.stdout)
    (output / "stderr.txt").write_text(completed.stderr)
    if completed.returncode:
        raise RuntimeError(f"Kernel check failed; inspect {output / 'stderr.txt'}")
    files = list((output / "ir").rglob("*final_isa.s"))
    if len(files) != 1:
        raise RuntimeError(f"Expected one selected-kernel ISA path; got {len(files)}")
    isa = files[0]
    origin = isa.parent / "00_origin.mlir"
    if "(1024,1024):(1024,1)" not in origin.read_text():
        raise RuntimeError("A boundary specialization overwrote the full-workload dump")
    text = isa.read_text()
    fields = {}
    for field in (
        "group_segment_fixed_size",
        "private_segment_fixed_size",
        "vgpr_count",
        "sgpr_count",
    ):
        match = re.search(r"\." + field + r":\s*(\d+)", text)
        if match is None:
            raise RuntimeError(f"Missing resource metadata: {field}")
        fields[field] = int(match[1])
    module = runpy.run_path(str(HERE / "solution.py"))
    config = module["SELECTED_CONFIG"]
    if fields["group_segment_fixed_size"] != config.lds_bytes:
        raise RuntimeError("LDS allocation does not match the selected configuration")
    if "v_wmma_f32_16x16x16_bf16" not in text:
        raise RuntimeError(
            "Selected kernel does not contain the intended WMMA instruction"
        )
    report = {
        "config": config.name,
        "resources": fields,
        "source_sha256": hashlib.sha256(
            (HERE / "solution.py").read_bytes()
        ).hexdigest(),
        "command": command,
        "correctness": "trace/random, sentinels, and pipeline boundaries passed",
        "scope": "static compiler resources; no occupancy or cycle-overlap claim",
    }
    shutil.copyfile(isa, output / "selected.s")
    shutil.copyfile(origin, output / "selected-origin.mlir")
    (output / "resources.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
