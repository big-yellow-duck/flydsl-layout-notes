"""Fetch only the Quark checkpoint tensors used by the TP=1 linear benchmark."""

import argparse
import json
import shutil
import struct
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from urllib.request import Request, urlopen

MODEL = "amd/Qwen3.8-27B-Quark-AWQ-MXFP4"
REVISION = "93245f7c00f1a8964b66a97c6e02e2fd09080be4"
BASE = f"https://huggingface.co/{MODEL}/resolve/{REVISION}"
LANGUAGE = "model.language_model.layers"
PROJECTION_TENSORS = {
    "mlp_gate_up": ("0.mlp.gate_proj", "0.mlp.up_proj"),
    "mlp_down": ("0.mlp.down_proj",),
    "gdn_qkvz": ("0.linear_attn.in_proj_qkv", "0.linear_attn.in_proj_z"),
    "gdn_ba": ("0.linear_attn.in_proj_b", "0.linear_attn.in_proj_a"),
    "attention_qkv": ("3.self_attn.q_proj", "3.self_attn.k_proj", "3.self_attn.v_proj"),
    "attention_out": ("3.self_attn.o_proj",),
}


def open_range(start, stop):
    request = Request(
        f"{BASE}/model.safetensors",
        headers={"Range": f"bytes={start}-{stop - 1}", "Accept-Encoding": "identity"},
    )
    response = urlopen(request, timeout=90)
    if response.status != 206 or not response.headers.get(
        "Content-Range", ""
    ).startswith(f"bytes {start}-{stop - 1}/"):
        response.close()
        raise RuntimeError(f"Server did not honor byte range {start}:{stop}")
    return response


def fetch(args, header, payload, projection, shards, kind):
    path = args.output / f"{projection}.{kind}.u8"
    items = [header[f"{LANGUAGE}.{name}.{kind}"] for name in shards]
    size = sum(item["data_offsets"][1] - item["data_offsets"][0] for item in items)
    if path.exists() and path.stat().st_size == size:
        return
    tmp = path.with_suffix(".partial")
    with tmp.open("wb") as dest:
        for item in items:
            assert item["dtype"] == "U8"
            start, stop = item["data_offsets"]
            with open_range(payload + start, payload + stop) as response:
                shutil.copyfileobj(response, dest, 1024 * 1024)
    if tmp.stat().st_size != size:
        raise RuntimeError(f"Incomplete download for {projection} {kind}")
    tmp.replace(path)
    print(f"{projection} {kind} {size:,} bytes", flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    with urlopen(f"{BASE}/config.json", timeout=30) as response:
        config = json.load(response)
    with open_range(0, 8) as response:
        payload = 8 + struct.unpack("<Q", response.read())[0]
    with open_range(8, payload) as response:
        header = json.load(response)
    with ThreadPoolExecutor(max_workers=6) as executor:
        futures = [
            executor.submit(fetch, args, header, payload, projection, shards, kind)
            for projection, shards in PROJECTION_TENSORS.items()
            for kind in ("weight", "weight_scale")
        ]
        for future in futures:
            future.result()
    manifest = {
        "model": MODEL,
        "revision": REVISION,
        "quantization_config": config["quantization_config"],
        "projections": {
            projection: [
                header[f"{LANGUAGE}.{name}.weight"]["shape"] for name in shards
            ]
            for projection, shards in PROJECTION_TENSORS.items()
        },
    }
    (args.output / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")


if __name__ == "__main__":
    main()
