"""Extract the profiled hipBLASLt solutions and disassemble their actual binaries.

Requires msgpack and pyelftools; clang-offload-bundler decompresses the code object.
"""

import argparse
import hashlib
import json
import re
import subprocess
import zlib
from collections import Counter
from pathlib import Path

import msgpack
from elftools.elf.elffile import ELFFile

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SDK = ROOT / ".pixi/envs/default/lib/python3.12/site-packages/_rocm_sdk_devel"
LIBRARY = SDK / "lib/hipblaslt/library/gfx1151"
STEM = "TensileLibrary_BB_BB_HA_Bias_SAV_UA_Type_BB_HPA_Contraction_l_Ailk_Bljk_Cijk_Dijk_gfx1151"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--profiles", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument(
        "--scratch", type=Path, default=Path("/tmp/torch-strategy-extraction")
    )
    args = parser.parse_args()
    if args.output.exists():
        parser.error("Use a fresh output directory")
    args.output.mkdir(parents=True)
    args.scratch.mkdir(parents=True, exist_ok=True)
    packed = LIBRARY / (STEM + ".dat.zlib")
    library = msgpack.unpackb(
        zlib.decompress(packed.read_bytes()), raw=False, strict_map_key=False
    )
    code_object = LIBRARY / (STEM + ".co")
    elf_path = args.scratch / "gfx1151.hsaco"
    bundler = SDK / "lib/llvm/bin/clang-offload-bundler"
    objdump = next((ROOT / ".pixi/envs/default/lib/rustlib").glob("*/bin/llvm-objdump"))
    command = [
        str(bundler),
        "--unbundle",
        "--type=o",
        "--targets=hipv4-amdgcn-amd-amdhsa--gfx1151",
        "--input=" + str(code_object),
        "--output=" + str(elf_path),
    ]
    subprocess.run(command, check=True, capture_output=True, text=True)
    kernels = {}
    with elf_path.open("rb") as stream:
        elf = ELFFile(stream)
        symbols = {
            s.name: s.entry for s in elf.get_section_by_name(".symtab").iter_symbols()
        }
        text_section = elf.get_section_by_name(".text")
        text_end = text_section["sh_addr"] + text_section["sh_size"]
        functions = sorted(
            {
                s["st_value"]
                for s in symbols.values()
                if s["st_info"]["type"] == "STT_FUNC"
            }
        )
        for section in elf.iter_sections():
            if section["sh_type"] != "SHT_NOTE":
                continue
            for note in section.iter_notes():
                if note["n_name"] == "AMDGPU" and isinstance(note["n_desc"], bytes):
                    metadata = msgpack.unpackb(
                        note["n_desc"], raw=False, strict_map_key=False
                    )
                    kernels.update(
                        {
                            item[".name"]: item
                            for item in metadata.get("amdhsa.kernels", [])
                        }
                    )
    report = {
        "metadata_file": str(packed.resolve()),
        "code_object": str(code_object.resolve()),
        "metadata_sha256": hashlib.sha256(packed.read_bytes()).hexdigest(),
        "code_object_sha256": hashlib.sha256(code_object.read_bytes()).hexdigest(),
        "extracted_sha256": hashlib.sha256(elf_path.read_bytes()).hexdigest(),
        "unbundle_command": command,
        "solutions": {},
    }
    for shape in ((16, 1024, 8192), (32, 1024, 8192), (16, 4096, 8192)):
        key = "x".join(map(str, shape))
        log = (args.profiles / f"hipblaslt-{key}.log").read_text()
        indices = set(map(int, re.findall(r"sol-idx = (\d+)", log)))
        assert len(indices) == 1, indices
        index = indices.pop()
        solution = next(x for x in library["solutions"] if x["index"] == index)
        symbol = solution["kernelName"]
        profile = json.loads(
            (args.profiles / f"profile-{key}/summary.json").read_text()
        )
        observed = {
            row["kernel"] for row in profile["profiles"]["trace"]["samples"]["torch"]
        }
        assert observed == {symbol}, (observed, symbol)
        start = symbols[symbol]["st_value"]
        stop = next((address for address in functions if address > start), text_end)
        disassemble = [
            str(objdump),
            "--disassemble",
            "--mcpu=gfx1151",
            "--no-leading-addr",
            f"--start-address={start}",
            f"--stop-address={stop}",
            str(elf_path),
        ]
        result = subprocess.run(disassemble, check=True, capture_output=True, text=True)
        (args.output / f"{key}.s").write_text(result.stdout)
        instructions = Counter()
        for line in result.stdout.splitlines():
            match = re.match(r"\s+([a-z][a-z0-9_.]+)\s", line)
            if match:
                instructions[match[1]] += 1
        assert instructions["v_wmma_f32_16x16x16_bf16"] > 0
        assert (
            sum(count for name, count in instructions.items() if "atomic" in name) == 0
        )
        selected = {
            "shape_MNK": shape,
            "solution_index": index,
            "solution": solution,
            "kernel_metadata": kernels[symbol],
            "instruction_counts_static": dict(instructions),
            "disassembly_command": disassemble,
            "logical_output_tile_MN": [
                solution["sizeMapping"]["macroTile"][1],
                solution["sizeMapping"]["macroTile"][0],
            ],
            "explanation": "Torch's row-major C=A@B is submitted as column-major C^T=B^T@A^T; library free0 is logical N, free1 is logical M.",
            "scope": "Static disassembly includes prologue/epilogue and conditional paths; instruction counts are not per-GEMM runtime totals.",
        }
        (args.output / f"{key}.json").write_text(json.dumps(selected, indent=2) + "\n")
        report["solutions"][key] = {
            "index": index,
            "symbol": symbol,
            "address_range": [start, stop],
            "wmma_instruction": "v_wmma_f32_16x16x16_bf16",
            "global_split_u": solution["sizeMapping"]["globalSplitU"],
            "stream_k": solution["sizeMapping"]["streamK"],
        }
        print(
            key,
            index,
            selected["logical_output_tile_MN"],
            solution["sizeMapping"]["depthU"],
            kernels[symbol].get(".vgpr_count"),
            flush=True,
        )
    (args.output / "summary.json").write_text(json.dumps(report, indent=2) + "\n")


if __name__ == "__main__":
    main()
