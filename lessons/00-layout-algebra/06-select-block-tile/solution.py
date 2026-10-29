"""Native GPU lesson: 06-select-block-tile. See README.md for the exercise."""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def exercise_kernel(source: fx.Tensor, out: fx.Tensor):
    thread_id = fx.thread_idx.x
    block_id = fx.block_idx.x
    thread_layout = fx.make_ordered_layout(8, 0)
    local_index = fx.idx2crd(thread_id, thread_layout)
    # TODO: Expose 8-element windows and select this block's window.
    divided = fx.logical_divide(source, fx.make_layout(8, 1))
    block_tile = fx.slice(divided, (None, block_id))
    out[block_id * 8 + thread_id] = block_tile[local_index]


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
