"""Bounds-safe native FlyDSL indexing with coordinate views."""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch
from flydsl._mlir import ir
from flydsl._mlir.dialects import scf


@flyc.kernel
def exercise_kernel(
    left: fx.Tensor, right: fx.Tensor, out: fx.Tensor, count: fx.Constexpr
):
    padded_count = ((count + 7) // 8) * 8
    # 1. Reuse left/right/out as memory views. Build a separate index-only view.
    coordinate_layout = fx.make_layout(padded_count, 1)
    index_origin = fx.make_int_tuple(0)
    coordinates = fx.make_view(index_origin, coordinate_layout)
    # 2. Expose coordinate windows and select this block's window.
    block_id = fx.block_idx.x
    coordinate_tiles = fx.logical_divide(coordinates, fx.make_layout(8, 1))
    block_coordinates = fx.slice(coordinate_tiles, (None, block_id))
    # 3. Assign two local positions to each thread.
    thread_id = fx.thread_idx.x
    ownership = fx.make_layout((4, 2), (2, 1))
    for value_id in range(2):
        local_index = fx.crd2idx(fx.make_coord(thread_id, value_id), ownership)
        global_index = fx.get_scalar(block_coordinates[local_index])
        # 4. Check bounds before touching either input or the output.
        valid = global_index < count
        # Python if cannot branch on a runtime GPU value in this tracing API.
        branch = scf.IfOp(valid.ir_value(), [], has_else=False)
        with ir.InsertionPoint(branch.then_block):
            # 5. Load, compute, and store only this valid position.
            result = left[global_index] + right[global_index]
            out[global_index] = result
            scf.yield_([])


@flyc.jit
def run(left: fx.Tensor, right: fx.Tensor, out: fx.Tensor, count: fx.Constexpr):
    exercise_kernel(left, right, out, count).launch(
        grid=((count + 7) // 8, 1, 1), block=(4, 1, 1)
    )


def solve():
    for count in [19]:
        left = torch.arange(count, dtype=torch.float32, device="cuda") * 0.25
        right = torch.arange(count, dtype=torch.float32, device="cuda") * -0.5 + 3
        # Inputs are exact-sized. Extra output storage checks for stray writes.
        out = torch.full((count + 8,), -999.0, dtype=torch.float32, device="cuda")
        run(left, right, out, count)
        torch.cuda.synchronize()
        torch.testing.assert_close(out[:count], left + right)
        assert torch.all(out[count:] == -999).item(), "Wrote beyond the logical output"
    return "passed sizes " + str([19])


if __name__ == "__main__":
    try:
        print("Exercise passed:", solve())
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None
