"""Native GPU lesson: 08-tiled-copy. See README.md for the exercise."""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def exercise_kernel(source: fx.Tensor, out: fx.Tensor):
    thread_id = fx.thread_idx.x
    thread_layout = fx.make_layout((1, 4), (4, 1))
    value_layout = fx.make_layout((2, 1), (1, 2))
    tile_shape, thread_value_layout = fx.make_layout_tv(thread_layout, value_layout)
    atom = fx.make_copy_atom(fx.UniversalCopy32b(), fx.Float32)
    # TODO: Build the shared plan and select this thread's part of it.
    plan = fx.make_tiled_copy(atom, thread_value_layout, tile_shape)
    thread_copy = plan.get_slice(thread_id)
    # The tile is (value position, thread position), with contiguous value pairs.
    tile_layout = fx.make_layout((2, 4), (1, 2))
    source_tile = fx.make_view(fx.get_iter(source), tile_layout)
    destination_tile = fx.make_view(fx.get_iter(out), tile_layout)
    source_part = thread_copy.partition_S(source_tile)
    destination_part = thread_copy.partition_D(destination_tile)
    # Partitioning describes views; this operation actually moves values.
    fx.copy(atom, source_part, destination_part)


@flyc.jit
def run(source: fx.Tensor, out: fx.Tensor):
    exercise_kernel(source, out).launch(grid=(1, 1, 1), block=(4, 1, 1))


def solve():
    source = torch.arange(8, dtype=torch.float32, device="cuda") * 3 + 7
    out = torch.full_like(source, -1)
    run(source, out)
    torch.cuda.synchronize()
    torch.testing.assert_close(out, source)
    return out.cpu().tolist()


if __name__ == "__main__":
    try:
        print("Exercise passed:", solve())
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None
