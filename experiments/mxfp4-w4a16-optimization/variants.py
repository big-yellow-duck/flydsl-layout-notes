"""Experimental alternatives to the lesson's standalone MXFP4 unpack kernel."""

import flydsl.compiler as flyc
import flydsl.expr as fx
from flydsl.expr.typing import Vector as Vec

BLOCK_THREADS = 256


@flyc.kernel
def _unpack_direct_bits(
    packed_weights: fx.Tensor,
    scales: fx.Tensor,
    dense_weights: fx.Tensor,
    K: fx.Constexpr,
    N: fx.Constexpr,
):
    """Unpack E2M1 nibbles and build scaled BF16 bits without an FP8 mapping."""
    element_count = K * N
    packed_count = element_count // 2
    packed_words = fx.make_view(
        fx.recast_iter(fx.Uint32, fx.get_iter(packed_weights)),
        fx.make_layout(packed_count // 4, 1),
    )
    packed_words = fx.rocdl.make_buffer_tensor(
        packed_words, num_records_bytes=packed_count
    )
    scale_words = fx.make_view(
        fx.recast_iter(fx.Uint64, fx.get_iter(scales)),
        fx.make_layout((K // 32) * (N // 8), 1),
    )
    scale_words = fx.rocdl.make_buffer_tensor(
        scale_words, num_records_bytes=(K // 32) * N
    )

    word_id = fx.block_idx.x * BLOCK_THREADS + fx.thread_idx.x
    packed_word = fx.Uint32(fx.get_scalar(packed_words[word_id]))
    even_nibbles = packed_word & 0x0F0F0F0F
    odd_nibbles = packed_word.shrui(fx.Uint32(4)) & 0x0F0F0F0F
    code_words = Vec.from_elements(
        [
            fx.Uint32(
                fx.rocdl.perm_b32(
                    odd_nibbles, even_nibbles, fx.Uint32(0x05010400)
                )
            ),
            fx.Uint32(
                fx.rocdl.perm_b32(
                    odd_nibbles, even_nibbles, fx.Uint32(0x07030602)
                )
            ),
        ],
        fx.Uint32,
    )
    codes = fx.make_rmem_tensor(8, fx.Uint8)
    codes.store(code_words.bitcast(fx.Uint8))

    first_index = word_id * 8
    row = first_index // N
    col = first_index % N
    scale_id = (row // 32) * (N // 8) + col // 8
    scale_word = fx.Uint64(fx.get_scalar(scale_words[scale_id]))
    output = fx.make_rmem_tensor(8, fx.BFloat16)
    for value_id in fx.range_constexpr(8):
        code = fx.Uint32(codes[value_id])
        magnitude = code & 7
        scale_byte = (
            (scale_word >> fx.Uint64(value_id * 8)) & fx.Uint64(255)
        ).to(fx.Int32)

        # E2M1 exponents relative to its normalized significand are -1,0,1,2.
        exponent = scale_byte + (magnitude >> 1).to(fx.Int32) - 1
        is_zero = magnitude == 0
        is_subnormal = exponent <= 0
        is_overflow = exponent >= 255
        sign = ((code >> 3) & 1) << 15
        fraction = ((magnitude & 1) << 6).to(fx.Uint32)
        fraction = (magnitude == 1).select(0, fraction)
        significand = fx.Uint32(128) + fraction
        subnormal_shift = (1 - exponent).to(fx.Uint32)
        subnormal_fraction = significand >> subnormal_shift
        fraction = is_subnormal.select(subnormal_fraction, fraction)
        fraction = is_overflow.select(0, fraction)
        fraction = is_zero.select(0, fraction)

        exponent_bits = is_subnormal.select(0, exponent).to(fx.Uint32)
        exponent_bits = is_overflow.select(255, exponent_bits)
        exponent_bits = is_zero.select(0, exponent_bits)
        bf16_bits = (sign | (exponent_bits << 7) | fraction).to(fx.Uint16)
        output[value_id] = bf16_bits.bitcast(fx.BFloat16)

    output_view = fx.make_view(
        fx.get_iter(dense_weights) + first_index, fx.make_layout(8, 1)
    )
    fx.copy(
        fx.make_copy_atom(fx.UniversalCopy128b(), fx.BFloat16), output, output_view
    )


@flyc.jit
def launch_direct_unpack(
    packed_weights: fx.Tensor,
    scales: fx.Tensor,
    dense_weights: fx.Tensor,
    K: fx.Constexpr,
    N: fx.Constexpr,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
):
    _unpack_direct_bits(packed_weights, scales, dense_weights, K, N).launch(
        grid=((K * N // 8) // BLOCK_THREADS, 1, 1),
        block=(BLOCK_THREADS, 1, 1),
        stream=stream,
    )
