"""Validate lesson layout mappings with FlyDSL on a ROCm GPU.

Run in an activated FlyDSL/PyTorch environment: python examples/gpu_layout_check.py
"""
import torch
import flydsl.compiler as flyc
import flydsl.expr as fx


@flyc.kernel
def layout_kernel(out: fx.Tensor):
    row = fx.make_layout((3, 4), (5, 1))
    scalar = fx.make_layout((2, 4), (4, 1))
    nested = fx.make_layout(((2, 2), 3), ((1, 4), 8))
    b = fx.make_layout((4, 2), (2, 1))
    composed = fx.composition(scalar, b)
    simple = fx.coalesce(fx.make_layout((2, 3), (3, 6)))
    tiled = fx.flat_divide(fx.make_layout((4, 8), (8, 1)), (2, 4))
    out[0] = fx.get_scalar(fx.crd2idx(fx.make_coord(2, 3), row))
    out[1] = fx.get_scalar(fx.crd2idx(3, scalar))
    out[2] = fx.get_scalar(fx.crd2idx(fx.make_coord((1, 1), 2), nested))
    out[3] = fx.get_scalar(fx.crd2idx(fx.make_coord(3, 0), composed))
    out[4] = fx.get_scalar(fx.crd2idx(5, simple))
    out[5] = fx.get_scalar(fx.crd2idx(fx.make_coord(1, 2, 1, 1), tiled))


@flyc.kernel
def tile_kernel(out: fx.Tensor):
    tid = fx.thread_idx.x
    m = tid % 2
    n = (tid // 2) % 4
    p = (tid // 8) % 2
    q = tid // 16
    tiled = fx.flat_divide(fx.make_layout((4, 8), (8, 1)), (2, 4))
    out[tid] = fx.get_scalar(fx.crd2idx(fx.make_coord(m, n, p, q), tiled))


@flyc.jit
def run(out: fx.Tensor, stream: fx.Stream = fx.Stream(None)):
    layout_kernel(out).launch(grid=(1, 1, 1), block=(1, 1, 1), stream=stream)


@flyc.jit
def run_tiles(out: fx.Tensor, stream: fx.Stream = fx.Stream(None)):
    tile_kernel(out).launch(grid=(1, 1, 1), block=(32, 1, 1), stream=stream)


def main():
    out = torch.full((6,), -1, dtype=torch.int32, device='cuda')
    run(out)
    torch.cuda.synchronize()
    actual = out.cpu().tolist()
    expected = [13, 5, 21, 3, 15, 30]
    assert actual == expected, (actual, expected)
    tiles = torch.full((32,), -1, dtype=torch.int32, device='cuda')
    run_tiles(tiles)
    torch.cuda.synchronize()
    expected_tiles = [(i % 2 + 2 * ((i // 8) % 2)) * 8
                      + (i // 2) % 4 + 4 * (i // 16) for i in range(32)]
    assert tiles.cpu().tolist() == expected_tiles
    assert sorted(expected_tiles) == list(range(32))
    print(f'PASS {torch.cuda.get_device_name()}: {actual}; all 32 tile coordinates')


if __name__ == '__main__':
    main()
