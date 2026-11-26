"""Decode one NVFP4 weight per thread, then reuse stage 15 BF16 matmul."""

import argparse
import runpy
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch

NV_BLOCK_K = 16
BLOCK_THREADS = 64


def _decode_e4m3_scale(b_scale_byte):
    """Decode an E4M3FN byte in FP32, including zero, subnormals, and NaN."""
    exponent = (b_scale_byte >> 3) & 15
    mantissa = (b_scale_byte & 7).to(fx.Float32)
    subnormal = mantissa * (2.0**-9)
    normal = (1.0 + mantissa * 0.125) * fx.exp2(exponent.to(fx.Float32) - 7.0)
    magnitude = (exponent == 0).select(subnormal, normal)
    signed = ((b_scale_byte & 128) != 0).select(-magnitude, magnitude)
    return ((b_scale_byte & 127) == 127).select(fx.Float32(float("nan")), signed)


@flyc.kernel
def _dequantize_nvfp4(
    b_packed: fx.Tensor,
    b_scales: fx.Tensor,
    b_tensor_scale: fx.Tensor,
    b: fx.Tensor,
    k: fx.Constexpr,
    n: fx.Constexpr,
    block_threads: fx.Constexpr,
):
    # One thread owns one logical element of dense B.
    flat_index = fx.block_idx.x * block_threads + fx.thread_idx.x
    if flat_index < k * n:
        row = flat_index // n
        column = flat_index % n

        # The byte index and shift use the flat index, even across row boundaries.
        b_packed_byte = fx.Uint8(b_packed[flat_index // 2]).to(fx.Int32)
        nibble = (b_packed_byte >> (4 * (flat_index % 2))) & 0xF

        # E2M1 uses one sign bit, two exponent bits and one mantissa bit.
        exponent = (nibble >> 1) & 3
        half = (nibble & 1).to(fx.Float32) * 0.5
        normal = (1.0 + half) * fx.exp2(exponent.to(fx.Float32) - 1.0)
        magnitude = (exponent == 0).select(half, normal)
        value = ((nibble & 8) != 0).select(-magnitude, magnitude)

        # Apply the block scale and then the per-tensor multiplier.
        # TODO 1. Fill in b_scale_row.
        b_scale_row = None
        if b_scale_row is None:
            raise NotImplementedError("Fill in b_scale_row.")
        b_scale_byte = fx.Uint8(b_scales[b_scale_row, column]).to(fx.Int32)
        b_block_scale = _decode_e4m3_scale(b_scale_byte)
        # TODO 2. Fill in tensor_scale.
        tensor_scale = None
        if tensor_scale is None:
            raise NotImplementedError("Fill in tensor_scale.")
        scaled = (value * b_block_scale) * tensor_scale
        b[row, column] = scaled.to(fx.BFloat16)


@flyc.jit
def _launch_dequantize_nvfp4(
    b_packed: fx.Tensor,
    b_scales: fx.Tensor,
    b_tensor_scale: fx.Tensor,
    b: fx.Tensor,
    k: fx.Constexpr,
    n: fx.Constexpr,
    block_threads: fx.Constexpr,
    stream: fx.Stream,
):
    _dequantize_nvfp4(
        b_packed, b_scales, b_tensor_scale, b, k, n, block_threads
    ).launch(
        grid=((k * n + block_threads - 1) // block_threads, 1, 1),
        block=(block_threads, 1, 1),
        stream=stream,
    )


def dequantize_nvfp4(
    b_packed, b_scales, b_tensor_scale, k, *, out=None, block_threads=BLOCK_THREADS
):
    """Expand flat uint8 nibbles and (ceil(K/16), N) scales into BF16 B."""
    b = out
    if type(k) is not int or k <= 0:
        raise ValueError("k must be a positive integer")
    for name, tensor, ndim, dtype in (
        ("packed_weights", b_packed, 1, torch.uint8),
        ("scales", b_scales, 2, torch.uint8),
        ("out", b, 2, torch.bfloat16),
    ):
        if name == "out" and tensor is None:
            continue
        if (
            type(tensor) not in (torch.Tensor, torch.nn.Parameter)
            or tensor.dtype != dtype
        ):
            raise TypeError(f"{name} must be a {dtype} tensor")
        if (
            not tensor.is_cuda
            or tensor.ndim != ndim
            or tensor.layout != torch.strided
            or not tensor.is_contiguous()
            or tensor.is_neg()
        ):
            raise ValueError(f"{name} must be a contiguous {ndim}-D ROCm GPU tensor")
        if tensor.device != b_packed.device:
            raise ValueError(f"{name} must be on the packed_weights device")
    n = b_scales.shape[1]
    if type(block_threads) is not int or block_threads not in (32, 64, 128, 256, 512):
        raise ValueError("block_threads must be 32, 64, 128, 256, or 512")
    if n <= 0 or b_scales.shape[0] != (k + NV_BLOCK_K - 1) // NV_BLOCK_K:
        raise ValueError("scales must have shape (ceil(K/16), N) with positive N")
    if b_packed.numel() != (k * n + 1) // 2:
        raise ValueError("packed_weights must contain ceil(K*N/2) bytes")
    if torch.version.hip is None:
        raise RuntimeError("This lesson requires ROCm")

    if not isinstance(b_tensor_scale, torch.Tensor) or (
        b_tensor_scale.dtype != torch.float32
        or b_tensor_scale.shape != (1,)
        or b_tensor_scale.device != b_packed.device
        or b_tensor_scale.layout != torch.strided
        or b_tensor_scale.is_neg()
    ):
        raise ValueError(
            "b_tensor_scale must be a one-element FP32 tensor on the input GPU"
        )
    if torch.is_grad_enabled() and b_tensor_scale.requires_grad:
        raise RuntimeError("NVFP4 dequantization does not support autograd")

    supplied_out = b is not None
    if supplied_out:
        if b.shape != (k, n):
            raise ValueError("out must have shape (K, N)")
        if torch.is_grad_enabled() and b.requires_grad:
            raise RuntimeError("dequantize_nvfp4 does not support autograd")
        start = b.data_ptr()
        stop = start + b.numel() * b.element_size()
        for source in (b_packed, b_scales, b_tensor_scale):
            if (
                start < source.data_ptr() + source.numel() * source.element_size()
                and source.data_ptr() < stop
            ):
                raise ValueError("out must not overlap an input")

    with torch.cuda.device(b_packed.device):
        if b is None:
            b = torch.empty((k, n), dtype=torch.bfloat16, device=b_packed.device)
        _launch_dequantize_nvfp4(
            b_packed,
            b_scales,
            b_tensor_scale,
            b,
            k,
            n,
            block_threads,
            fx.Stream(torch.cuda.current_stream()),
        )
        if supplied_out:
            torch.autograd.graph.increment_version(b)
    return b


def _reference_b(b_packed, b_scales, b_tensor_scale, k):
    n = b_scales.shape[1]
    codes = torch.stack((b_packed & 15, b_packed >> 4), dim=1).flatten()
    codes = codes[: k * n].reshape(k, n)
    levels = torch.tensor([0.0, 0.5, 1.0, 1.5, 2.0, 3.0, 4.0, 6.0])
    magnitude = levels[(codes & 7).long()]
    values = torch.where((codes & 8) != 0, -magnitude, magnitude)
    block_scales = b_scales.view(torch.float8_e4m3fn).float()
    row_scales = block_scales.repeat_interleave(NV_BLOCK_K, dim=0)[:k]
    return (values * row_scales * b_tensor_scale).bfloat16()


def _trace_inputs():
    # Rows 15 and 16 straddle a scale boundary. The last byte's spare
    # high nibble holds 0xf so accessing it cannot silently produce zero.
    codes = torch.zeros((17, 9), dtype=torch.uint8)
    codes[15:] = torch.tensor([9, 2, 3, 4, 5, 6, 7, 15, 1], dtype=torch.uint8)
    flat = torch.cat((codes.flatten(), torch.tensor([15], dtype=torch.uint8)))
    b_packed = flat[0::2] | (flat[1::2] << 4)
    b_scales = torch.tensor([[0x38] * 9, [0x3C] * 8 + [0x01]], dtype=torch.uint8)
    b_tensor_scale = torch.tensor([0.5], dtype=torch.float32)
    a = torch.zeros((2, 17), dtype=torch.bfloat16)
    a[0, 16] = 1
    a[1, 15:] = 1
    return a, b_packed, b_scales, b_tensor_scale


def solve(*, right_in_registers=False):
    a, b_packed, b_scales, b_tensor_scale = _trace_inputs()
    k = a.shape[1]
    matmul_lesson = (
        Path(__file__).resolve().parents[3]
        / "13-matmul/16-right-register-staging/solution.py"
    )
    dense_matmul = runpy.run_path(str(matmul_lesson))

    b = dequantize_nvfp4(b_packed.cuda(), b_scales.cuda(), b_tensor_scale.cuda(), k)
    config = dense_matmul["Config"](
        group_tile_n=16, stage_k=16, waves_per_group_n=1, split_k=1,
        k_unroll=1, right_in_registers=right_in_registers,
    )
    c = dense_matmul["matmul_bf16"](a.cuda(), b, config=config)
    expected_b = _reference_b(b_packed, b_scales, b_tensor_scale, k)
    torch.testing.assert_close(b.cpu(), expected_b, rtol=0, atol=0)
    torch.testing.assert_close(
        c.cpu(), (a.float() @ expected_b.float()).bfloat16(), rtol=0, atol=0
    )

    # All 16 nibble codes against all 256 E4M3FN scale bytes.
    codes = torch.arange(16, dtype=torch.uint8).repeat(256)
    packed = codes[0::2] | (codes[1::2] << 4)
    scales = torch.arange(256, dtype=torch.uint8).repeat_interleave(16).reshape(1, -1)
    actual = dequantize_nvfp4(
        packed.cuda(), scales.cuda(), b_tensor_scale.cuda(), 1
    ).cpu()
    expected = _reference_b(packed, scales, b_tensor_scale, 1)
    torch.testing.assert_close(actual, expected, atol=0, rtol=0, equal_nan=True)
    comparable = ~expected.isnan()
    assert torch.equal(
        actual.view(torch.int16)[comparable], expected.view(torch.int16)[comparable]
    )
    return f"B[16, 1] = {b[16, 1].item()}, C[1, 1] = {c[1, 1].item()}"


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--right-in-registers", action="store_true")
    args = parser.parse_args([] if globals().get("_COURSE_CHECK_ONLY", False) else None)
    try:
        print("Exercise passed:", solve(right_in_registers=args.right_in_registers))
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None
