"""flat_divide: view a matrix, divide it, select a tile, and read it."""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def exercise_kernel(source: fx.Tensor, out: fx.Tensor):
    # 1. Describe the matrix indexing. This layout contains no data.
    matrix_layout = fx.make_layout((4, 8), (8, 1))
    # 2. Apply that indexing to source's existing GPU storage. No copy occurs.
    matrix = fx.make_view(fx.get_iter(source), matrix_layout)
    # 3. Expose 2-row by 4-column windows.
    windows = fx.flat_divide(matrix, (2, 4))
    # 4. Select tile row 1, tile column 1.
    tile = fx.slice(windows, (None, None, 1, 1))

    # Read the selected tile: eight threads, one local position each.
    thread_id = fx.thread_idx.x
    thread_layout = fx.make_ordered_layout((2, 4), (1, 0))
    local_coordinate = fx.idx2crd(thread_id, thread_layout)
    out[thread_id] = tile[local_coordinate]


@flyc.jit
def run(source: fx.Tensor, out: fx.Tensor):
    exercise_kernel(source, out).launch(grid=(1, 1, 1), block=(8, 1, 1))


def solve():
    source = torch.arange(32, dtype=torch.int32, device="cuda") + 100
    out = torch.full((8,), -1, dtype=torch.int32, device="cuda")
    run(source, out)
    torch.cuda.synchronize()
    actual = out.cpu().tolist()
    expected = [120, 121, 122, 123, 128, 129, 130, 131]
    assert actual == expected, (actual, expected)
    return actual


if __name__ == "__main__":
    try:
        print("Exercise passed:", solve())
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None
