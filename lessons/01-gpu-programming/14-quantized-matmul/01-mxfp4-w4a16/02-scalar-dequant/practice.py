"""Decode one MXFP4 weight per thread, then reuse stage 15 BF16 matmul."""

import argparse
import runpy
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch
from flydsl._mlir.dialects import llvm

MX_BLOCK_K = 32
BLOCK_THREADS = 64
# Tuned decoder launch sizes on gfx1151, indexed by (K, N).
BLOCK_THREADS_BY_SHAPE = {
    (8192, 1024): 32,
    (8192, 4096): 32,
    (46, 77): 32,
    (8214, 1046): 32,
    (8193, 1025): 32,
    (1022, 1046): 32,
}


@flyc.kernel
def _dequantize_mxfp4(
    b_packed: fx.Tensor,
    b_scales: fx.Tensor,
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
        # TODO 1. Fill in nibble.
        nibble = None
        nibble = (b_packed_byte >> (4 * (flat_index % 2))) & 0xF
        if nibble is None:
            raise NotImplementedError("Fill in nibble.")

        # E2M1 uses one sign bit, two exponent bits and one mantissa bit.
        exponent = (nibble >> 1) & 3
        half = (nibble & 1).to(fx.Float32) * 0.5
        normal = (1.0 + half) * fx.exp2(exponent.to(fx.Float32) - 1.0)
        magnitude = (exponent == 0).select(half, normal)
        value = ((nibble & 8) != 0).select(-magnitude, magnitude)

        # One E8M0 scale per column and per 32 rows of B.
        b_scale_row = row // MX_BLOCK_K
        b_scale_byte = fx.Uint8(b_scales[b_scale_row, column]).to(fx.Int32)
        # TODO 3. Fill in power.
        power = None
        power = b_scale_byte - 127
        if power is None:
            raise NotImplementedError("Fill in power.")
        # ldexp computes value * 2**power as one operation.
        scaled = fx.Float32(
            llvm.intr_ldexp(fx.Float32.ir_type, value.ir_value(), power.ir_value())
        )
        scaled = (b_scale_byte == 255).select(fx.Float32(float("nan")), scaled)
        b[row, column] = scaled.to(fx.BFloat16)


@flyc.jit
def _launch_dequantize_mxfp4(
    b_packed: fx.Tensor,
    b_scales: fx.Tensor,
    b: fx.Tensor,
    k: fx.Constexpr,
    n: fx.Constexpr,
    block_threads: fx.Constexpr,
    stream: fx.Stream,
):
    _dequantize_mxfp4(b_packed, b_scales, b, k, n, block_threads).launch(
        grid=((k * n + block_threads - 1) // block_threads, 1, 1),
        block=(block_threads, 1, 1),
        stream=stream,
    )


def dequantize_mxfp4(
    packed_weights, scales, k, *, out=None, block_threads=BLOCK_THREADS
):
    """Expand flat uint8 nibbles and (ceil(K/32), N) scales into BF16 B."""
    b_packed = packed_weights
    b_scales = scales
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
    if block_threads is None:
        block_threads = BLOCK_THREADS_BY_SHAPE.get((k, n), BLOCK_THREADS)
    if type(block_threads) is not int or block_threads not in (32, 64, 128, 256, 512):
        raise ValueError("block_threads must be 32, 64, 128, 256, or 512")
    if n <= 0 or b_scales.shape[0] != (k + MX_BLOCK_K - 1) // MX_BLOCK_K:
        raise ValueError("scales must have shape (ceil(K/32), N) with positive N")
    if b_packed.numel() != (k * n + 1) // 2:
        raise ValueError("packed_weights must contain ceil(K*N/2) bytes")
    if torch.version.hip is None:
        raise RuntimeError("This lesson requires ROCm")

    supplied_out = b is not None
    if supplied_out:
        if b.shape != (k, n):
            raise ValueError("out must have shape (K, N)")
        if torch.is_grad_enabled() and b.requires_grad:
            raise RuntimeError("dequantize_mxfp4 does not support autograd")
        start = b.data_ptr()
        stop = start + b.numel() * b.element_size()
        for source in (b_packed, b_scales):
            if start < source.data_ptr() + source.numel() and source.data_ptr() < stop:
                raise ValueError("out must not overlap packed weights or scales")

    with torch.cuda.device(b_packed.device):
        if b is None:
            b = torch.empty(
                (k, n), dtype=torch.bfloat16, device=b_packed.device
            )
        _launch_dequantize_mxfp4(
            b_packed,
            b_scales,
            b,
            k,
            n,
            block_threads,
            fx.Stream(torch.cuda.current_stream()),
        )
        if supplied_out:
            torch.autograd.graph.increment_version(b)
    return b


def solve(*, right_in_registers=False):
    """Check scalar decode and feed its output directly to the BF16 matmul."""
    lesson = Path(__file__).resolve().parent
    reference_decode = runpy.run_path(str(lesson.parent / "04-lut-decode/solution.py"))[
        "torch_dequantize_mxfp4"
    ]
    matmul_lesson = lesson.parents[2] / "13-matmul/16-right-register-staging/solution.py"
    dense_matmul = runpy.run_path(str(matmul_lesson))

    k, n = 33, 3
    # Flat indices 0–98 cycle through the sixteen codes. The unused high
    # nibble of the last byte is deliberately nonzero.
    codes = torch.arange(k * n + 1, dtype=torch.uint8) % 16
    b_packed = codes[0::2] | (codes[1::2] << 4)
    b_scales = torch.tensor([[128, 127, 126], [129, 126, 125]], dtype=torch.uint8)
    a = torch.zeros((2, k), dtype=torch.bfloat16)
    a[0, 32] = 1
    a[1, 31:33] = 1

    b_bf16 = dequantize_mxfp4(b_packed.cuda(), b_scales.cuda(), k)
    config = dense_matmul["Config"](
        group_tile_n=16, stage_k=16, waves_per_group_n=1, split_k=1,
        k_unroll=1, right_in_registers=right_in_registers,
    )
    c = dense_matmul["matmul_bf16"](a.cuda(), b_bf16, config=config)
    torch.cuda.synchronize()
    expected_b = reference_decode(b_packed, b_scales, (k, n))
    torch.testing.assert_close(b_bf16.cpu(), expected_b, rtol=0, atol=0)
    torch.testing.assert_close(
        c.cpu(), (a.float() @ expected_b.float()).bfloat16(), rtol=0, atol=0
    )

    # One column per (code, scale) pair, covering signed zero and extreme scales.
    columns = 16 * 256
    codes = torch.arange(16, dtype=torch.uint8).repeat(256)
    b_packed = codes[0::2] | (codes[1::2] << 4)
    b_scales = (
        torch.arange(256, dtype=torch.uint8).repeat_interleave(16).reshape(1, columns)
    )
    actual = dequantize_mxfp4(b_packed.cuda(), b_scales.cuda(), 1).cpu()
    expected = reference_decode(b_packed, b_scales, (1, columns))
    torch.testing.assert_close(actual, expected, rtol=0, atol=0, equal_nan=True)
    finite_scale = ~expected.isnan()
    assert torch.equal(
        actual.view(torch.int16)[finite_scale], expected.view(torch.int16)[finite_scale]
    ), "Decoded BF16 bits differ from the reference"

    return f"B[32, 1] = {b_bf16[32, 1].item()}, C = {c.tolist()}"


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--right-in-registers", action="store_true")
    args = parser.parse_args([] if globals().get("_COURSE_CHECK_ONLY", False) else None)
    try:
        print("Exercise passed:", solve(right_in_registers=args.right_in_registers))
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None
