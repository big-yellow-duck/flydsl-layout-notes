"""Check all 4096 native A coordinate mappings against the stated formulas."""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def layout_kernel(output: fx.Tensor):
    q = fx.block_idx.x * 128 + fx.thread_idx.x
    coord = fx.make_coord(q // 64, q % 64)
    packed = fx.make_layout((64, 64), (64, 1))
    swizzle = fx.static(fx.SwizzleType.get(3, 3, 3))
    swizzled = fx.make_composed_layout(swizzle, 0, packed)
    padded = fx.make_layout((64, 64), (72, 1))
    output[q * 3] = fx.get_scalar(fx.crd2idx(coord, packed))
    output[q * 3 + 1] = fx.get_scalar(fx.crd2idx(coord, swizzled))
    output[q * 3 + 2] = fx.get_scalar(fx.crd2idx(coord, padded))


@flyc.jit
def run(output: fx.Tensor):
    layout_kernel(output).launch(grid=(32, 1, 1), block=(128, 1, 1))


def main():
    output = torch.empty(4096 * 3, dtype=torch.int32, device="cuda")
    run(output)
    torch.cuda.synchronize()
    actual = output.cpu().reshape(4096, 3)
    q = torch.arange(4096, dtype=torch.int32)
    expected = torch.stack((q, q ^ ((q & 0x1C0) >> 3), q // 64 * 72 + q % 64), dim=1)
    torch.testing.assert_close(actual, expected, rtol=0, atol=0)
    # Confirm a permutation within the allocation and unchanged eight-value chunks.
    assert torch.equal(actual[:, 1].sort().values, q)
    chunks = actual[:, 1].reshape(512, 8)
    assert torch.all(chunks[:, 0] % 8 == 0).item()
    assert torch.all(chunks[:, 1:] - chunks[:, :-1] == 1).item()
    print("Layout check passed: 4096 coordinates; row 2, k=2:", actual[130].tolist())


if __name__ == "__main__":
    main()
