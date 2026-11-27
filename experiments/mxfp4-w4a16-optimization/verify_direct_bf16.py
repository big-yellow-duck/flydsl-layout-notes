"""Check the fused MXFP4 decoder across the full BF16 range on gfx1151/gfx1152."""

import argparse
import runpy
from dataclasses import asdict, replace
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch

LESSON = (
    Path(__file__).resolve().parents[2]
    / "lessons/01-gpu-programming/14-quantized-matmul/01-mxfp4-w4a16"
    / "03-fused-staging/solution.py"
)
lesson = runpy.run_path(str(LESSON))
scale_weight = lesson["_scale_b_e2m1"]
matmul = lesson["matmul_mxfp4_w4a16"]

THREADS = 256
PAIR_COUNT = 16 * 256


@flyc.kernel
def _decode_all_pairs(direct: fx.Tensor):
    index = fx.block_idx.x * THREADS + fx.thread_idx.x
    code = (index % 16).to(fx.Uint32)
    scale = (index // 16).to(fx.Int32)
    direct[index] = scale_weight(code, scale)


@flyc.jit
def _launch_decode_all_pairs(direct: fx.Tensor):
    _decode_all_pairs(direct).launch(
        grid=(PAIR_COUNT // THREADS, 1, 1), block=(THREADS, 1, 1)
    )


def assert_same_bits(actual, expected):
    # NaN payloads are immaterial. Compare every other value, including signed zero.
    actual_nan = actual.isnan()
    expected_nan = expected.isnan()
    assert torch.equal(actual_nan, expected_nan), "NaN positions differ"
    torch.testing.assert_close(
        actual.view(torch.int16)[~actual_nan],
        expected.view(torch.int16)[~expected_nan],
        rtol=0,
        atol=0,
    )


def check_full_range(config, baseline):
    codes = torch.arange(16).repeat(256)
    scales = torch.arange(256).repeat_interleave(16)
    levels = torch.tensor([0, 0.5, 1, 1.5, 2, 3, 4, 6], dtype=torch.float64)
    values = torch.where(codes < 8, levels[codes & 7], -levels[codes & 7])
    expected = torch.ldexp(values, scales - 127).to(torch.bfloat16)
    expected[scales == 255] = float("nan")

    direct = torch.empty_like(expected, device="cuda")
    _launch_decode_all_pairs(direct)
    assert_same_bits(direct.cpu(), expected)
    print(f"Decoder: {PAIR_COUNT} pairs match the CPU oracle.")

    # One K value per column isolates each pair through fused LDS/WMMA. Add
    # one extra column to exercise the odd-N packed and scale buffer tails.
    codes = torch.cat((codes, codes[:1])).to(torch.uint8)
    scales = torch.cat((scales, scales[:1])).to(torch.uint8)
    packed = codes[::2].clone()
    packed[: codes.numel() // 2] |= codes[1::2] << 4
    a = torch.ones((1, 1), dtype=torch.bfloat16, device="cuda")
    for right_in_registers in (False, True):
        output = check_matmul(
            a,
            packed,
            scales[None, :],
            replace(config, right_in_registers=right_in_registers),
            baseline,
        )
        output = output.cpu().flatten()[:PAIR_COUNT]
        subnormal = (expected.abs() > 0) & (
            expected.abs() < torch.finfo(torch.bfloat16).tiny
        )
        torch.testing.assert_close(
            output[~subnormal], expected[~subnormal], rtol=0, atol=0, equal_nan=True
        )
        flushed = (output[subnormal] == 0).sum().item()
        torch.testing.assert_close(
            output[subnormal & (output != 0)],
            expected[subnormal & (output != 0)],
            rtol=0,
            atol=0,
        )
        print(
            f"WMMA right_in_registers={right_in_registers}: "
            f"{flushed}/{subnormal.sum().item()} BF16 subnormal results flush to zero."
        )
    print(f"Fused WMMA: verified all {PAIR_COUNT} pairs on both B paths.")


def check_matmul(a, packed, scales, config, baseline):
    # Poison physical backing beyond logical inputs to expose tail-load mistakes.
    if a.device.type == "cpu":
        a = lesson["_gpu_input"](a, float("nan"))
    packed = lesson["_gpu_input"](packed, 255)
    scales = lesson["_gpu_input"](scales, 255)
    direct = matmul(a, packed, scales, config=config)
    if baseline is not None:
        reference = baseline["matmul_mxfp4_w4a16"](
            a, packed, scales, config=baseline["Config"](**asdict(config))
        )
        assert_same_bits(direct, reference)
    return direct


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--baseline", type=Path, help="Optional snapshot of a reference fused solution"
    )
    args = parser.parse_args()
    baseline = runpy.run_path(str(args.baseline)) if args.baseline else None
    config = lesson["Config"](
        group_tile_n=32, stage_k=32, waves_per_group_n=1, split_k=1, k_unroll=2
    )
    check_full_range(config, baseline)

    generator = torch.Generator().manual_seed(13)
    cases = ((16, 1024, 256), (17, 77, 46), (17, 1, 48))
    for m, n, k in cases:
        a = torch.randn((m, k), generator=generator).to(torch.bfloat16)
        weights = torch.randn((k, n), generator=generator).to(torch.bfloat16)
        packed, scales, dense = lesson["quantize_mxfp4"](weights)
        expected = (a.float() @ dense.float()).to(torch.bfloat16)
        for left in (False, True):
            for right in (False, True):
                output = check_matmul(
                    a,
                    packed,
                    scales,
                    replace(
                        config,
                        split_k=4,
                        left_in_registers=left,
                        right_in_registers=right,
                    ),
                    baseline,
                )
                torch.testing.assert_close(
                    output.cpu(), expected, rtol=0.016, atol=0.03125
                )
        print(f"Fused WMMA {(m, n, k)}: all four A/B paths pass with split-K=4.")
    if baseline is not None:
        print(
            "Every tested matmul also matches the supplied baseline bit-for-bit (NaNs by position)."
        )


if __name__ == "__main__":
    main()
