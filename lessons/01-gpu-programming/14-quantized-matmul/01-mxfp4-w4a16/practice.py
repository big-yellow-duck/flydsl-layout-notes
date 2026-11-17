"""14.1: unpack OCP MXFP4 weights, then use the lesson-12 W4A16 path."""

import argparse
import runpy
from dataclasses import replace
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch

BLOCK_THREADS = 256
SHAPES = ((16, 1024, 8192), (32, 1024, 8192), (16, 4096, 8192))
_OPERAND_PATHS = runpy.run_path(
    str(
        Path(__file__).resolve().parents[2]
        / "13-matmul"
        / "12-operand-paths"
        / "solution.py"
    )
)
Config = _OPERAND_PATHS["Config"]
BASE_CONFIGS_BY_SHAPE = dict(_OPERAND_PATHS["CONFIGS_BY_SHAPE"])
CONFIGS_BY_SHAPE = dict(BASE_CONFIGS_BY_SHAPE)
# Selected by tune.py on gfx1152; the search starts from BASE_CONFIGS_BY_SHAPE.
CONFIGS_BY_SHAPE[(16, 1024, 8192)] = replace(
    CONFIGS_BY_SHAPE[(16, 1024, 8192)], split_k=1
)


@flyc.kernel
def _matmul_mxfp4_w4a16(
    packed_weights: fx.Tensor,
    scales: fx.Tensor,
    dense_weights: fx.Tensor,
    K: fx.Constexpr,
    N: fx.Constexpr,
):
    """Expand each packed pair to BF16; one OCP block contains 32 K values."""
    element_count = K * N
    packed_count = element_count // 2
    packed_view = fx.make_view(
        fx.get_iter(packed_weights), fx.make_layout(packed_count, 1)
    )
    scale_view = fx.make_view(
        fx.get_iter(scales), fx.make_layout((K // 32) * N, 1)
    )
    dense_view = fx.make_view(
        fx.get_iter(dense_weights), fx.make_layout(element_count, 1)
    )

    pair_coordinates = fx.make_view(
        fx.make_int_tuple(0), fx.make_layout(packed_count, 1)
    )
    pair_tiles = fx.logical_divide(pair_coordinates, fx.make_layout(256, 1))
    block_pairs = fx.slice(pair_tiles, (None, fx.block_idx.x))
    pair_id = fx.get_scalar(block_pairs[fx.thread_idx.x])
    packed_byte = fx.get_scalar(packed_view[pair_id]).to(fx.Int32)

    low_code = packed_byte & 15  # noqa: F841 -- consumed by TODO 1
    high_code = packed_byte >> 4  # noqa: F841 -- consumed by TODO 1
    low_index = pair_id * 2
    high_index = low_index + 1

    low_row = low_index // N
    low_col = low_index % N
    high_row = high_index // N
    high_col = high_index % N
    low_scale_id = (low_row // 32) * N + low_col
    high_scale_id = (high_row // 32) * N + high_col
    low_scale_byte = fx.get_scalar(scale_view[low_scale_id]).to(fx.Int32)  # noqa: F841 -- consumed by TODO 2
    high_scale_byte = fx.get_scalar(scale_view[high_scale_id]).to(fx.Int32)  # noqa: F841 -- consumed by TODO 2

    # TODO 1: Decode both E2M1 nibbles, including the subnormal case.
    low_decoded = None
    if low_decoded is None:
        raise NotImplementedError("Decode the low E2M1 value.")
    high_decoded = None
    if high_decoded is None:
        raise NotImplementedError("Decode the high E2M1 value.")
    # TODO 2: Apply the E8M0 block scale, whose exponent bias is 127.
    low_value = None
    if low_value is None:
        raise NotImplementedError("Apply the low value's E8M0 scale.")
    high_value = None
    if high_value is None:
        raise NotImplementedError("Apply the high value's E8M0 scale.")
    dense_view[low_index] = low_value.to(fx.BFloat16)
    dense_view[high_index] = high_value.to(fx.BFloat16)


@flyc.jit
def _launch_matmul_mxfp4_w4a16(
    packed_weights: fx.Tensor,
    scales: fx.Tensor,
    dense_weights: fx.Tensor,
    K: fx.Constexpr,
    N: fx.Constexpr,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
):
    _matmul_mxfp4_w4a16(packed_weights, scales, dense_weights, K, N).launch(
        grid=((K * N // 2) // BLOCK_THREADS, 1, 1),
        block=(BLOCK_THREADS, 1, 1),
        stream=stream,
    )


def _decode_e2m1(code):
    sign = (code & 8) != 0
    exponent = (code >> 1) & 3
    mantissa = code & 1
    subnormal = mantissa.to(fx.Float32) * 0.5
    normal = (1.0 + mantissa.to(fx.Float32) * 0.5) * fx.exp2(
        exponent.to(fx.Float32) - 1.0
    )
    magnitude = (exponent == 0).select(subnormal, normal)
    return sign.select(-magnitude, magnitude)


def matmul_mxfp4_w4a16(
    activations, packed_weights, scales, *, out=None, config=None, stream=None
):
    """BF16 A times packed OCP MXFP4 B via software unpack and lesson 12 WMMA."""
    for name, tensor in (
        ("activations", activations),
        ("packed_weights", packed_weights),
        ("scales", scales),
    ):
        if type(tensor) not in (torch.Tensor, torch.nn.Parameter):
            raise TypeError(f"{name} must be a torch.Tensor")
    if activations.dtype != torch.bfloat16 or not activations.is_cuda:
        raise TypeError("activations must be a BF16 ROCm GPU tensor")
    if packed_weights.dtype != torch.uint8 or scales.dtype != torch.uint8:
        raise TypeError("packed_weights and scales must use torch.uint8")
    if any(t.device != activations.device for t in (packed_weights, scales)):
        raise ValueError("all tensors must be on the same device")
    for name, tensor in (
        ("activations", activations),
        ("packed_weights", packed_weights),
        ("scales", scales),
    ):
        if not tensor.is_cuda or tensor.layout != torch.strided or not tensor.is_contiguous():
            raise ValueError(f"{name} must be contiguous on a ROCm GPU")
        if tensor.is_neg():
            raise ValueError(f"{name} must not be a negative view")
        if torch.is_grad_enabled() and tensor.requires_grad:
            raise RuntimeError("matmul_mxfp4_w4a16 does not support autograd")
    if activations.ndim != 2:
        raise ValueError("activations must be a 2-D row-major matrix")
    m, k = activations.shape
    if k % 32:
        raise ValueError("K must be divisible by the MXFP4 block size 32")
    if packed_weights.ndim != 1 or scales.ndim != 2:
        raise ValueError("packed weights must be flat and scales must be 2-D")
    n = scales.shape[1]
    if packed_weights.numel() != (k * n) // 2 or scales.shape != (k // 32, n):
        raise ValueError("packed weights or scale shape does not match K and N")
    if n % 64 or (k * n) % 512:
        raise ValueError("N and K*N must satisfy this lesson's complete-tile layout")
    if any(not t.is_contiguous() for t in (packed_weights, scales)):
        raise ValueError("packed weights and scales must be contiguous")
    shape = (m, n, k)
    if config is None:
        config = CONFIGS_BY_SHAPE.get(shape)
        if config is None:
            raise ValueError(f"Supply a lesson-12 Config for shape M,N,K={shape}")
    _OPERAND_PATHS["validate_config"](config, shape)
    if out is not None:
        if type(out) not in (torch.Tensor, torch.nn.Parameter):
            raise TypeError("out must be a torch.Tensor")
        if out.dtype != torch.bfloat16 or out.shape != (m, n):
            raise ValueError("out must be a BF16 matrix with shape (M,N)")
        if out.device != activations.device or not out.is_contiguous():
            raise ValueError("out must be contiguous on the input device")
        if torch.is_grad_enabled() and out.requires_grad:
            raise RuntimeError("matmul_mxfp4_w4a16 does not support autograd")
        output_start = out.data_ptr()
        output_stop = output_start + out.numel() * out.element_size()
        for name, tensor in (
            ("activations", activations),
            ("packed_weights", packed_weights),
            ("scales", scales),
        ):
            input_start = tensor.data_ptr()
            input_stop = input_start + tensor.numel() * tensor.element_size()
            if output_start < input_stop and input_start < output_stop:
                raise ValueError(f"out must not overlap {name}")
    if stream is not None and stream.device != activations.device:
        raise ValueError("stream and inputs must use the same device")
    if torch.version.hip is None:
        raise RuntimeError("This lesson requires ROCm")
    arch = torch.cuda.get_device_properties(activations.device).gcnArchName.split(":")[0]
    if arch not in ("gfx1151", "gfx1152"):
        raise RuntimeError(f"This software-dequantized lesson requires gfx1151/gfx1152; detected {arch}")

    with torch.cuda.device(activations.device), torch.cuda.stream(stream):
        current_stream = torch.cuda.current_stream(activations.device)
        if out is None:
            out = torch.empty((m, n), dtype=torch.bfloat16, device=activations.device)
        dense_weights = torch.empty((k * n,), dtype=torch.bfloat16, device=activations.device)
        _launch_matmul_mxfp4_w4a16(
            packed_weights,
            scales,
            dense_weights,
            k,
            n,
            stream=fx.Stream(current_stream),
        )
        _OPERAND_PATHS["matmul_bf16"](
            activations,
            dense_weights.view(k, n),
            out=out,
            config=config,
            stream=current_stream,
        )
    return out


def quantize_mxfp4(weight_bf16):
    """Offline OCP MXFP4 reference encoder for B[K,N], block-scales along K."""
    k, n = weight_bf16.shape
    if k % 32 or n % 2:
        raise ValueError("MXFP4 weights need K divisible by 32 and even N")
    blocks = weight_bf16.float().reshape(k // 32, 32, n)
    maxima = blocks.abs().amax(dim=1)
    exponents = torch.floor(torch.log2(maxima.clamp_min(2.0**-127))) - 2
    exponents = exponents.clamp(-127, 127).to(torch.int16)
    scale = torch.exp2(exponents.float())
    normalized = (blocks / scale[:, None, :]).clamp(-6.0, 6.0)
    levels = torch.tensor(
        [0.0, 0.5, 1.0, 1.5, 2.0, 3.0, 4.0, 6.0], dtype=torch.float32
    )
    distances = (normalized.abs()[..., None] - levels).abs()
    minima = distances.amin(dim=-1, keepdim=True)
    candidate_ids = torch.arange(8).view(1, 1, 1, 8).expand_as(distances)
    tied_even_ids = torch.where(
        (distances == minima) & (candidate_ids % 2 == 0), candidate_ids, 8
    )
    magnitude_codes = tied_even_ids.amin(dim=-1).to(torch.uint8)
    codes = magnitude_codes | (normalized.signbit().to(torch.uint8) << 3)
    codes = codes.reshape(k, n).contiguous()
    packed = (codes[:, 0::2] | (codes[:, 1::2] << 4)).reshape(-1).contiguous()
    scale_bytes = (exponents + 127).to(torch.uint8).contiguous()
    dense = torch.empty((k, n), dtype=torch.float32)
    decoded_levels = levels[codes.to(torch.int64) & 7]
    decoded = torch.where((codes & 8) != 0, -decoded_levels, decoded_levels)
    decoded *= torch.exp2(exponents.float())[:, None, :].expand(-1, 32, -1).reshape(k, n)
    dense.copy_(decoded)
    return packed, scale_bytes, dense.to(torch.bfloat16)


def torch_dequantize_mxfp4(packed_weights, scales, shape):
    """Torch GPU implementation of the same MXFP4 decoding for comparisons."""
    k, n = shape
    index = torch.arange(k * n, device=packed_weights.device)
    byte = packed_weights[index // 2].to(torch.int32)
    code = torch.where((index & 1) == 0, byte & 15, byte >> 4)
    exponent = (code >> 1) & 3
    mantissa = (code & 1).float()
    magnitude = torch.where(
        exponent == 0,
        mantissa * 0.5,
        (1.0 + mantissa * 0.5) * torch.exp2(exponent.float() - 1.0),
    )
    value = torch.where((code & 8) != 0, -magnitude, magnitude)
    row, col = index // n, index % n
    scale_index = (row // 32) * n + col
    scale = torch.exp2(scales.reshape(-1)[scale_index].float() - 127.0)
    return (value * scale).to(torch.bfloat16).view(k, n)


def solve(shape=(32, 1024, 8192), seed=13):
    m, n, k = shape
    generator = torch.Generator().manual_seed(seed)
    a_cpu = torch.randn((m, k), generator=generator).to(torch.bfloat16)
    b_cpu = torch.randn((k, n), generator=generator).to(torch.bfloat16)
    packed_cpu, scales_cpu, dense_cpu = quantize_mxfp4(b_cpu)
    a = a_cpu.cuda()
    packed = packed_cpu.cuda()
    scales = scales_cpu.cuda()
    dense_gpu = torch_dequantize_mxfp4(packed, scales, (k, n))
    torch.testing.assert_close(dense_gpu.cpu(), dense_cpu, rtol=0, atol=0)
    config = CONFIGS_BY_SHAPE[shape]
    storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
    out = storage[:-16].view(m, n)
    matmul_mxfp4_w4a16(a, packed, scales, out=out, config=config)
    torch.cuda.synchronize()
    expected = a_cpu.float() @ dense_cpu.float()
    torch.testing.assert_close(out.cpu(), expected.to(torch.bfloat16), rtol=0.016, atol=0.03125)
    assert torch.all(storage[-16:] == -99).item(), "Output sentinel changed"
    return {
        "shape_MNK": shape,
        "config": config.name,
        "first_four": out[0, :4].cpu().tolist(),
        "packed_bytes": packed.numel(),
        "scale_bytes": scales.numel(),
        "dense_weight_bytes": dense_cpu.numel() * dense_cpu.element_size(),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, default=SHAPES[1])
    parser.add_argument("--check-only", action="store_true")
    args = parser.parse_args()
    shape = tuple(args.shape)
    if shape not in SHAPES:
        parser.error(f"Choose one of {SHAPES}")
    print("Exercise passed:", solve(shape), flush=True)


if __name__ == "__main__":
    try:
        main()
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None
