"""Record native operand-copy offsets for the lesson's 32x64x64 walkthrough."""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def offsets_kernel(a_offsets: fx.Tensor, b_stage: fx.Tensor, b_operand: fx.Tensor):
    thread = fx.thread_idx.x
    atom = fx.make_mma_atom(fx.rocdl.WMMA(16, 16, 16, fx.BFloat16, fx.Float32))
    mma = fx.make_tiled_mma(atom, fx.make_layout((1, 2, 1), (1, 1, 0)))
    copy_128 = fx.make_copy_atom(fx.UniversalCopy128b(), fx.BFloat16)
    copy_16 = fx.make_copy_atom(fx.UniversalCopy16b(), fx.BFloat16)
    # Index-only views have no memory allocation and perform no input loads.
    a_indices = fx.make_view(fx.make_int_tuple(0), fx.make_layout((32, 64), (8192, 1)))
    a_copy = fx.make_tiled_copy_A(copy_128, mma).get_slice(thread)
    a_source = a_copy.partition_S(a_indices)
    for slot in fx.range_constexpr(128):
        a_offsets[thread * 128 + slot] = fx.get_scalar(a_source[slot])

    b_indices = fx.make_view(fx.make_int_tuple(0), fx.make_layout((64, 64), (1024, 1)))
    threads = fx.make_ordered_layout((8, 8), (1, 0))
    values = fx.make_ordered_layout((1, 8), (1, 0))
    tile, tv = fx.make_layout_tv(threads, values)
    stage_copy = fx.make_tiled_copy(copy_128, tv, tile).get_slice(thread)
    b_source = stage_copy.partition_S(b_indices)
    for slot in fx.range_constexpr(64):
        b_stage[thread * 64 + slot] = fx.get_scalar(b_source[slot])

    b_lds_indices = fx.make_view(
        fx.make_int_tuple(16 * 64), fx.make_layout((64, 16), (1, 64))
    )
    operand_copy = fx.make_tiled_copy_B(copy_16, mma).get_slice(thread)
    operand_source = operand_copy.partition_S(b_lds_indices)
    for slot in fx.range_constexpr(32):
        b_operand[thread * 32 + slot] = fx.get_scalar(operand_source[slot])


@flyc.jit
def run(a_offsets: fx.Tensor, b_stage: fx.Tensor, b_operand: fx.Tensor):
    offsets_kernel(a_offsets, b_stage, b_operand).launch(
        grid=(1, 1, 1), block=(64, 1, 1)
    )


def solve():
    outputs = [
        torch.full((64 * width,), -1, dtype=torch.int32, device="cuda")
        for width in (128, 64, 32)
    ]
    run(*outputs)
    torch.cuda.synchronize()
    a, stage, operand = [out.cpu().view(64, -1) for out in outputs]
    tid = torch.arange(64)[:, None]
    slot = torch.arange(128)[None, :]
    a_expected = (
        ((tid % 16) + 16 * ((slot // 16) % 2)) * 8192 + 16 * (slot // 32) + slot % 16
    )
    torch.testing.assert_close(a, a_expected.to(torch.int32), rtol=0, atol=0)
    slot = torch.arange(64)[None, :]
    stage_expected = (tid // 8 + 8 * (slot // 8)) * 1024 + (tid % 8) * 8 + slot % 8
    torch.testing.assert_close(stage, stage_expected.to(torch.int32), rtol=0, atol=0)
    slot = torch.arange(32)[None, :]
    operand_expected = (
        (16 + slot % 16) * 64 + tid % 16 + (tid // 32) * 16 + (slot // 16) * 32
    )
    torch.testing.assert_close(
        operand, operand_expected.to(torch.int32), rtol=0, atol=0
    )
    return {
        "all_native_offsets_checked": 64 * (128 + 64 + 32),
        "thread3_A_K16_global_elements": a[3, 32:40].tolist(),
        "thread3_B_staging_global_elements": stage[3, :8].tolist(),
        "thread3_B_K16_LDS_elements": operand[3, :8].tolist(),
        "A_duplicate_lanes_3_19_35_51": all(
            torch.equal(a[3], a[t]) for t in (19, 35, 51)
        ),
    }


if __name__ == "__main__":
    print("Ownership passed:", solve())
