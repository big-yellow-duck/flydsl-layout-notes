"""Native GPU lesson: 07-thread-value-layouts. See README.md for the exercise."""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def exercise_kernel(out: fx.Tensor):
    thread_id = fx.thread_idx.x
    # A coordinate is (thread_id, value_id); each of four threads owns two values.
    # TODO: Build adjacent and interleaved ownership layouts.
    # TODO 1: Fill in adjacent; see README.md.
    adjacent = None
    if adjacent is None:
        raise NotImplementedError("Fill in adjacent.")
    # TODO 2: Fill in interleaved; see README.md.
    interleaved = None
    if interleaved is None:
        raise NotImplementedError("Fill in interleaved.")
    for value_id in range(2):
        coordinate = fx.make_coord(thread_id, value_id)
        out[thread_id * 4 + value_id] = fx.get_scalar(fx.crd2idx(coordinate, adjacent))
        out[thread_id * 4 + 2 + value_id] = fx.get_scalar(
            fx.crd2idx(coordinate, interleaved)
        )


@flyc.jit
def run(out: fx.Tensor):
    exercise_kernel(out).launch(grid=(1, 1, 1), block=(4, 1, 1))


def solve():
    out = torch.full((16,), -1, dtype=torch.int32, device="cuda")
    run(out)
    torch.cuda.synchronize()
    rows = out.cpu().reshape(4, 4).tolist()
    assert rows == [[0, 1, 0, 4], [2, 3, 1, 5], [4, 5, 2, 6], [6, 7, 3, 7]], rows
    return rows


if __name__ == "__main__":
    try:
        print("Exercise passed:", solve())
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None
