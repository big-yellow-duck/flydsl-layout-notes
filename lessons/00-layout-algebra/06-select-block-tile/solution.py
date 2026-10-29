"""Native GPU lesson: 06-select-block-tile. See README.md for the exercise."""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def exercise_kernel(source: fx.Tensor, out: fx.Tensor):
    # 1. Reuse the incoming 1-D tensor views: they already have the right layout.
    block_id = fx.block_idx.x
    tile_layout = fx.make_layout(8, 1)
    # 2. Expose source and destination windows, then select this block's tiles.
    source_windows = fx.logical_divide(source, tile_layout)
    destination_windows = fx.logical_divide(out, tile_layout)
    source_tile = fx.slice(source_windows, (None, block_id))
    destination_tile = fx.slice(destination_windows, (None, block_id))

    # 3. Assign the eight local positions to eight threads.
    thread_id = fx.thread_idx.x
    thread_layout = fx.make_ordered_layout(8, 0)
    local_coordinate = fx.idx2crd(thread_id, thread_layout)
    # 4. Load and store through the selected views; their bases are already set.
    destination_tile[local_coordinate] = source_tile[local_coordinate]


@flyc.jit
def run(source: fx.Tensor, out: fx.Tensor):
    exercise_kernel(source, out).launch(grid=(4, 1, 1), block=(8, 1, 1))


def solve():
    source = torch.arange(32, dtype=torch.float32, device="cuda") + 100
    out = torch.full_like(source, -1)
    run(source, out)
    torch.cuda.synchronize()
    torch.testing.assert_close(out, source)
    return out[16:24].cpu().tolist()


if __name__ == "__main__":
    try:
        print("Exercise passed:", solve())
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None
