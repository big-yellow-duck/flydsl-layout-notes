"""Run the lessons and additional native FlyDSL examples on a ROCm GPU."""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch
from layout_walkthrough import main as run_lessons


@flyc.kernel
def extra_kernel(out: fx.Tensor, source: fx.Tensor):
    tid = fx.thread_idx.x
    # Each column cycles through its complete logical domain on 32 threads.
    q = tid % 12
    row = fx.make_layout((3, 4), (4, 1))
    col = fx.make_layout((3, 4), (1, 3))
    out[tid * 12] = fx.get_scalar(fx.crd2idx(q, row))
    out[tid * 12 + 1] = fx.get_scalar(fx.crd2idx(q, col))
    alias = fx.make_layout((2, 3), (0, 1))
    out[tid * 12 + 2] = fx.get_scalar(fx.crd2idx(tid % 6, alias))

    a = fx.make_layout((2, 4), (4, 1))
    subset = fx.composition(a, fx.make_layout(2, 2))
    out[tid * 12 + 3] = fx.get_scalar(fx.crd2idx(tid % 2, subset))
    nested = fx.make_layout(((2, 2), 3), ((1, 4), 8))
    composed = fx.composition(nested, fx.make_layout((2, 3), (2, 4)))
    out[tid * 12 + 4] = fx.get_scalar(fx.crd2idx(tid % 6, composed))

    contiguous = fx.coalesce(fx.make_layout((2, 4), (1, 2)))
    strided = fx.coalesce(fx.make_layout((2, 3), (2, 4)))
    singleton = fx.coalesce(fx.make_layout(((2, 1), 4), ((1, 99), 2)))
    gapped = fx.coalesce(nested)
    unmergeable = fx.coalesce(a)
    out[tid * 12 + 5] = fx.get_scalar(fx.crd2idx(tid % 8, contiguous))
    out[tid * 12 + 6] = fx.get_scalar(fx.crd2idx(tid % 6, strided))
    out[tid * 12 + 7] = fx.get_scalar(fx.crd2idx(tid % 8, singleton))
    out[tid * 12 + 8] = fx.get_scalar(fx.crd2idx(q, gapped))
    out[tid * 12 + 9] = fx.get_scalar(fx.crd2idx(tid % 8, unmergeable))

    # Actual loads through sliced tensor views test pointer/base propagation.
    vector = fx.make_view(fx.get_iter(source), fx.make_layout(16, 1))
    divided = fx.logical_divide(vector, fx.make_layout(4, 1))
    tile_2 = fx.slice(divided, (None, 2))
    out[tid * 12 + 10] = tile_2[tid % 4]
    matrix = fx.make_view(fx.get_iter(source), fx.make_layout((4, 8), (8, 1)))
    zipped = fx.zipped_divide(matrix, (2, 4))
    tile = fx.slice(zipped, (None, (1, 1)))
    out[tid * 12 + 11] = tile[fx.make_coord((tid % 8) // 4, tid % 4)]


@flyc.jit
def run(out: fx.Tensor, source: fx.Tensor, stream: fx.Stream = fx.Stream(None)):  # noqa: B008 -- FlyDSL stream default
    extra_kernel(out, source).launch(grid=(1, 1, 1), block=(32, 1, 1), stream=stream)


def main():
    run_lessons()
    # Values differ from offsets: a correct load must read source[offset].
    source = torch.arange(32, dtype=torch.int32, device="cuda") + 100
    out = torch.full((32 * 12,), -1, dtype=torch.int32, device="cuda")
    run(out, source)
    torch.cuda.synchronize()
    rows = out.cpu().reshape(32, 12).tolist()
    expected_columns = [
        [0, 4, 8, 1, 5, 9, 2, 6, 10, 3, 7, 11],
        list(range(12)),
        [0, 0, 1, 1, 2, 2],
        [0, 1],
        [0, 4, 8, 12, 16, 20],
        list(range(8)),
        [0, 2, 4, 6, 8, 10],
        list(range(8)),
        [0, 1, 4, 5, 8, 9, 12, 13, 16, 17, 20, 21],
        [0, 4, 1, 5, 2, 6, 3, 7],
        [108, 109, 110, 111],
        [120, 121, 122, 123, 128, 129, 130, 131],
    ]
    for tid, row in enumerate(rows):
        expected = [column[tid % len(column)] for column in expected_columns]
        assert row == expected, (tid, row, expected)
    print("PASS: extra mappings, native composition/coalesce, and sliced GPU loads")


if __name__ == "__main__":
    main()
