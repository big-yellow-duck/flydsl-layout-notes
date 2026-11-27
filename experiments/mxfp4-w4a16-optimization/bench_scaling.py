"""Validate and time MXFP4 scaling strategies in the same fused-staging kernel."""

import argparse
import inspect
import json
import runpy
import tempfile
from functools import partial
from pathlib import Path

import flydsl.compiler as flyc  # noqa: F401 -- FlyDSL initializes LLVM before Torch
import flydsl.expr as fx
import torch
from flydsl._mlir.dialects import llvm

QUANTIZED = (
    Path(__file__).resolve().parents[2]
    / "lessons/01-gpu-programming/14-quantized-matmul"
)
SOURCE = QUANTIZED / "01-mxfp4-w4a16/03-fused-staging/solution.py"
BENCHMARK = runpy.run_path(str(QUANTIZED / "benchmark.py"))
PAIR_COUNT = 16 * 256


def _fp32_ldexp(code, scale_byte):
    # The FP32 arithmetic decoder previously used by the lesson.
    sign = (code & 8) != 0
    exponent = (code >> 1) & 3
    mantissa = code & 1
    subnormal = mantissa.to(fx.Float32) * 0.5
    normal = (1.0 + mantissa.to(fx.Float32) * 0.5) * fx.exp2(
        exponent.to(fx.Float32) - 1.0
    )
    value = (exponent == 0).select(subnormal, normal)
    value = sign.select(-value, value)
    power = scale_byte - 127
    scaled = fx.Float32(
        llvm.intr_ldexp(fx.Float32.ir_type, value.ir_value(), power.ir_value())
    )
    return (scale_byte == 255).select(fx.Float32(float("nan")), scaled).to(fx.BFloat16)


def _unscaled_fp32(code):
    magnitude_code = code & 7
    # Normal E2M1 codes 2..7 are consecutive on this coarser FP32 bit grid.
    magnitude = (magnitude_code << 22) + 0x3F000000
    magnitude = (magnitude_code == 1).select(fx.Uint32(0x3F000000), magnitude)
    magnitude = (magnitude_code == 0).select(fx.Uint32(0), magnitude)
    return (magnitude | ((code & 8) << 28)).bitcast(fx.Float32)


def _power_of_two_fp32(scale_byte):
    exponent = scale_byte.to(fx.Uint32) << 23
    # E8M0 byte 0 is 2^-127, and byte 255 is NaN. Both need a fraction bit.
    has_fraction = (scale_byte == 0) | (scale_byte == 255)
    bits = exponent | has_fraction.select(fx.Uint32(0x00400000), fx.Uint32(0))
    return bits.bitcast(fx.Float32)


def _fp32_decode_bits_ldexp(code, scale_byte):
    value = _unscaled_fp32(code)
    power = scale_byte - 127
    scaled = fx.Float32(
        llvm.intr_ldexp(fx.Float32.ir_type, value.ir_value(), power.ir_value())
    )
    return (scale_byte == 255).select(fx.Float32(float("nan")), scaled).to(fx.BFloat16)


def _fp32_result_bits(code, scale_byte):
    # Build the scaled FP32 word, then let the compiler lower the BF16 conversion.
    e2m1_exponent = ((code >> 1) & 3).to(fx.Int32)
    exponent = scale_byte + e2m1_exponent - 1
    fraction = (e2m1_exponent == 0).select(fx.Uint32(0), (code & 1) << 22)
    subnormal = exponent <= 0
    shift = subnormal.select(1 - exponent, 0).to(fx.Uint32)
    magnitude = subnormal.select(
        (0x00800000 | fraction) >> shift, (exponent.to(fx.Uint32) << 23) | fraction
    )
    magnitude = (exponent >= 255).select(fx.Uint32(0x7F800000), magnitude)
    magnitude = ((code & 7) == 0).select(fx.Uint32(0), magnitude)
    bits = (scale_byte == 255).select(
        fx.Uint32(0x7FC00000), magnitude | ((code & 8) << 28)
    )
    return bits.bitcast(fx.Float32).to(fx.BFloat16)


def _bf16_scale_multiply(code, scale_byte):
    magnitude_code = (code & 7).to(fx.Uint16)
    magnitude = (magnitude_code << 6) + 0x3F00
    magnitude = (magnitude_code == 1).select(fx.Uint16(0x3F00), magnitude)
    magnitude = (magnitude_code == 0).select(fx.Uint16(0), magnitude)
    bits = magnitude | ((code & 8) << 12)
    value = bits.to(fx.Uint16).bitcast(fx.BFloat16)
    has_fraction = (scale_byte == 0) | (scale_byte == 255)
    scale_bits = (scale_byte.to(fx.Uint16) << 7) | has_fraction.select(
        fx.Uint16(0x0040), fx.Uint16(0)
    )
    return value * scale_bits.to(fx.Uint16).bitcast(fx.BFloat16)


def _fp16_scale_multiply(code, scale_byte):
    value = _unscaled_fp32(code).to(fx.Float16)
    scale = _power_of_two_fp32(scale_byte).to(fx.Float16)
    return (value * scale).to(fx.BFloat16)


def _direct_bf16_bits(code, scale_byte):
    # E2M1's only nonzero subnormal, 0.5, has exponent -1 and no fraction.
    e2m1_exponent = ((code >> 1) & 3).to(fx.Int32)
    exponent_delta = (e2m1_exponent == 0).select(-1, e2m1_exponent - 1)
    exponent = scale_byte + exponent_delta
    fraction = (e2m1_exponent == 0).select(fx.Uint32(0), (code & 1) << 6)
    sign = (code & 8) << 12

    # At the low end, shift the implicit leading bit into BF16's fraction.
    # The smallest possible exponent field is -1, so these shifts are exact.
    subnormal = exponent <= 0
    shift = subnormal.select(1 - exponent, 0).to(fx.Uint32)
    subnormal_bits = (128 | fraction) >> shift
    normal_bits = (exponent.to(fx.Uint32) << 7) | fraction
    magnitude = subnormal.select(subnormal_bits, normal_bits)
    magnitude = (exponent >= 255).select(fx.Uint32(0x7F80), magnitude)
    magnitude = ((code & 7) == 0).select(fx.Uint32(0), magnitude)
    bits = (scale_byte == 255).select(fx.Uint32(0x7FC0), sign | magnitude)
    return bits.to(fx.Uint16).bitcast(fx.BFloat16)


def _direct_compact(code, scale_byte):
    # Exponent -1 is possible only for 0 or 0.5. Exponent 0 shifts the
    # significand once, so the entire subnormal case needs no variable shift.
    e2m1_exponent = ((code >> 1) & 3).to(fx.Int32)
    exponent = scale_byte + e2m1_exponent - 1
    fraction = (e2m1_exponent == 0).select(fx.Uint32(0), (code & 1) << 6)
    tiny = (exponent < 0).select(fx.Uint32(32), 64 | (fraction >> 1))
    normal = (exponent.to(fx.Uint32) << 7) | fraction
    magnitude = (exponent >= 255).select(fx.Uint32(0x7F80), normal)
    magnitude = (exponent <= 0).select(tiny, magnitude)
    magnitude = ((code & 7) == 0).select(fx.Uint32(0), magnitude)
    bits = (scale_byte == 255).select(fx.Uint32(0x7FC0), magnitude | ((code & 8) << 12))
    return bits.to(fx.Uint16).bitcast(fx.BFloat16)


def _direct_compact_u16(code, scale_byte):
    code = code.to(fx.Uint16)
    zero = fx.Uint16(0)
    one = fx.Uint16(1)
    e2m1_exponent = (code >> one) & fx.Uint16(3)
    exponent = scale_byte.to(fx.Int16) + e2m1_exponent.to(fx.Int16) - fx.Int16(1)
    fraction = (e2m1_exponent == zero).select(zero, (code & one) << fx.Uint16(6))
    tiny = (exponent < fx.Int16(0)).select(
        fx.Uint16(32), fx.Uint16(64) | (fraction >> one)
    )
    normal = (exponent.to(fx.Uint16) << fx.Uint16(7)) | fraction
    magnitude = (exponent >= fx.Int16(255)).select(fx.Uint16(0x7F80), normal)
    magnitude = (exponent <= fx.Int16(0)).select(tiny, magnitude)
    magnitude = ((code & fx.Uint16(7)) == zero).select(zero, magnitude)
    sign = (code & fx.Uint16(8)) << fx.Uint16(12)
    bits = (scale_byte == 255).select(fx.Uint16(0x7FC0), magnitude | sign)
    return bits.to(fx.Uint16).bitcast(fx.BFloat16)


def _decode_all_pairs(out: fx.Tensor):
    index = fx.block_idx.x * 256 + fx.thread_idx.x
    code = (index % 16).to(fx.Uint32)
    scale = (index // 16).to(fx.Int32)
    out[index] = _scale_b_e2m1(code, scale)  # noqa: F821 -- injected lesson helper


def _launch_decode_all_pairs(out: fx.Tensor):
    _decode_all_pairs(out).launch(grid=(16, 1, 1), block=(256, 1, 1))


DECODERS = {
    "bf16_direct": (_direct_bf16_bits,),
    "fp32_ldexp": (_fp32_ldexp,),
    "fp32_bits_ldexp": (_unscaled_fp32, _fp32_decode_bits_ldexp),
    "fp32_result_bits": (_fp32_result_bits,),
    "fp32_scale_mul": (),  # Use the lesson implementation for this case.
    "bf16_scale_mul": (_bf16_scale_multiply,),
    "fp16_scale_mul": (_unscaled_fp32, _power_of_two_fp32, _fp16_scale_multiply),
    "bf16_direct_u32_compact": (_direct_compact,),
    "bf16_direct_u16_compact": (_direct_compact_u16,),
}


def build_variant(name, directory):
    source = SOURCE.read_text()
    helpers = DECODERS[name]
    if helpers:
        start = source.index("def _decode_e2m1_as_fp32(")
        end = source.index("\n\n@flyc.kernel", start)
        decoder = "\n\n".join(inspect.getsource(helper) for helper in helpers)
        decoder = decoder.replace(f"def {helpers[-1].__name__}(", "def _scale_b_e2m1(")
        source = source[:start] + decoder + source[end:]
    source = source.replace(
        "import argparse", "import argparse\nfrom flydsl._mlir.dialects import llvm"
    )
    source += "\n\n@flyc.kernel\n" + inspect.getsource(_decode_all_pairs)
    source += "\n\n@flyc.jit\n" + inspect.getsource(_launch_decode_all_pairs)
    # Distinct symbols keep compiled ISA dumps separate within a process.
    source = source.replace("_matmul_mxfp4_w4a16", f"_matmul_{name}")
    source = source.replace("_decode_all_pairs", f"_decode_{name}")
    path = directory / f"{name}.py"
    path.write_text(source)
    return runpy.run_path(str(path))


def reference_pairs():
    codes = torch.arange(16).repeat(256)
    scales = torch.arange(256).repeat_interleave(16)
    levels = torch.tensor([0, 0.5, 1, 1.5, 2, 3, 4, 6], dtype=torch.float64)
    values = torch.where(codes < 8, levels[codes & 7], -levels[codes & 7])
    expected = torch.ldexp(values, scales - 127).to(torch.bfloat16)
    expected[scales == 255] = float("nan")
    return codes, scales, expected


def match_bits(actual, expected):
    equal = actual.view(torch.int16) == expected.view(torch.int16)
    return equal | (actual.isnan() & expected.isnan())


def verify(modules):
    codes, scales, expected = reference_pairs()
    out = torch.empty_like(expected, device="cuda")
    checks = {}
    for name, module in modules.items():
        module[f"_launch_decode_{name}"](out)
        matches = match_bits(out.cpu(), expected)
        bad = (~matches).nonzero().flatten()
        checks[name] = {"decoder_mismatches": bad.numel()}
        if bad.numel():
            first = bad[0].item()
            checks[name]["first_mismatch"] = [codes[first].item(), scales[first].item()]

    # One K row lets each scale/code pair reach WMMA independently. The odd
    # extra N column also exercises packed byte and scale tails.
    codes = torch.cat((codes, codes[:1])).to(torch.uint8)
    scales = torch.cat((scales, scales[:1])).to(torch.uint8)
    packed = codes[::2].clone()
    packed[: codes.numel() // 2] |= codes[1::2] << 4
    lesson = modules["bf16_direct"]
    a = torch.ones((1, 1), dtype=torch.bfloat16, device="cuda")
    packed = lesson["_gpu_input"](packed, 255)
    scales = lesson["_gpu_input"](scales[None, :], 255)
    for right in (False, True):
        baseline_config = lesson["Config"](split_k=1, right_in_registers=right)
        baseline = lesson["matmul_mxfp4_w4a16"](
            a, packed, scales, config=baseline_config
        )
        for name, module in modules.items():
            if checks[name]["decoder_mismatches"]:
                continue
            config = module["Config"](split_k=1, right_in_registers=right)
            result = module["matmul_mxfp4_w4a16"](a, packed, scales, config=config)
            checks[name][f"wmma_{'registers' if right else 'lds'}_mismatches"] = (
                (~match_bits(result, baseline)).sum().item()
            )
    return checks


def time_shape(modules, shape, batches, replays, graph_gemms):
    lesson = modules["bf16_direct"]
    m, n, k = shape
    generator = torch.Generator().manual_seed(13)
    a = torch.randn((m, k), generator=generator).to(torch.bfloat16)
    weights = torch.randn((k, n), generator=generator).to(torch.bfloat16)
    packed, scales, dense = lesson["quantize_mxfp4"](weights)
    expected = (a.float() @ dense.float()).to(torch.bfloat16).cuda()
    a, packed, scales = a.cuda(), packed.cuda(), scales.cuda()
    storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
    output = storage[:-16].view(m, n)

    def flip():
        packed.bitwise_xor_(0x88)

    graphs = {}
    reference = None
    for name, module in modules.items():
        config = module["default_config"](shape)

        launch = partial(
            module["matmul_mxfp4_w4a16"], a, packed, scales, out=output, config=config
        )

        graphs[name] = BENCHMARK["capture"](
            launch, flip, output, storage[-16:], expected, graph_gemms
        )
        if reference is None:
            reference = output.clone()
        else:
            assert match_bits(output, reference).all().item(), (shape, name)
    median, samples, orders = BENCHMARK["measure"](
        graphs, graph_gemms, batches, replays, 8783
    )
    return {
        "shape": shape,
        "median_ms": median,
        "samples_ms": samples,
        "orders": orders,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, action="append")
    parser.add_argument("--batches", type=int, default=11)
    parser.add_argument("--replays", type=int, default=40)
    parser.add_argument("--graph-gemms", type=int, default=16)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    with tempfile.TemporaryDirectory() as scratch:
        modules = {name: build_variant(name, Path(scratch)) for name in DECODERS}
        checks = verify(modules)
        print(json.dumps(checks, indent=2), flush=True)
        valid = {
            name: module
            for name, module in modules.items()
            if all(
                checks[name].get(key) == 0
                for key in (
                    "decoder_mismatches",
                    "wmma_lds_mismatches",
                    "wmma_registers_mismatches",
                )
            )
        }
        shapes = args.shape or (*valid["bf16_direct"]["ALIGNED_SHAPES"], (17, 77, 46))
        timings = []
        for shape in shapes:
            row = time_shape(
                valid, tuple(shape), args.batches, args.replays, args.graph_gemms
            )
            print(
                shape,
                {name: round(ms * 1000, 3) for name, ms in row["median_ms"].items()},
                flush=True,
            )
            timings.append(row)
    if args.output:
        args.output.write_text(
            json.dumps({"checks": checks, "timings": timings}, indent=2) + "\n"
        )


if __name__ == "__main__":
    main()
