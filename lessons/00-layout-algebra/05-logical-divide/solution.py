"""Solution: Divide a matrix into tiles.

Run from the repository root:
    pixi run python lessons/00-layout-algebra/05-logical-divide/solution.py
Layout algebra is traced by FlyDSL; thread-dependent mappings run on the GPU.
"""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def _divide_offsets(out: fx.Tensor):
    thread_id = fx.thread_idx.x
    original = fx.make_layout((4, 8), (8, 1))
    # Axes: (local row, local column, tile row, tile column).
    # Speed ranks: local_col first, then local_row, tile_col, and tile_row last.
    thread_layout = fx.make_ordered_layout((2, 4, 2, 2), (1, 0, 3, 2))
    coordinate = fx.idx2crd(thread_id, thread_layout)
    local_row, local_col, tile_row, tile_col = coordinate.unpack()
    # TASK: Split each original mode using the tuple tiler (2, 4).
    divided = fx.flat_divide(original, (2, 4))
    memory_offset = fx.crd2idx(coordinate, divided)
    out[thread_id * 5] = fx.get_scalar(memory_offset)
    # The other groupings must agree at CORRESPONDING explicit coordinates.
    logical = fx.logical_divide(original, (2, 4))
    zipped = fx.zipped_divide(original, (2, 4))
    tiled = fx.tiled_divide(original, (2, 4))
    out[thread_id * 5 + 1] = fx.get_scalar(
        fx.crd2idx(fx.make_coord((local_row, tile_row), (local_col, tile_col)), logical)
    )
    out[thread_id * 5 + 2] = fx.get_scalar(
        fx.crd2idx(fx.make_coord((local_row, local_col), (tile_row, tile_col)), zipped)
    )
    out[thread_id * 5 + 3] = fx.get_scalar(
        fx.crd2idx(fx.make_coord((local_row, local_col), tile_row, tile_col), tiled)
    )
    out[thread_id * 5 + 4] = fx.get_scalar(
        fx.crd2idx(
            fx.make_coord(local_row + 2 * tile_row, local_col + 4 * tile_col), original
        )
    )


@flyc.jit
def _launch_divide_offsets(
    out: fx.Tensor,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
):
    _divide_offsets(out).launch(grid=(1, 1, 1), block=(32, 1, 1), stream=stream)


def divide_offsets(*, out=None, device="cuda", stream=None):
    """Evaluate this lesson's complete coordinate domain on the GPU."""
    if out is not None:
        if not isinstance(out, torch.Tensor):
            raise TypeError("out must be a torch.Tensor")
        device = out.device
    device = torch.device(device)
    if device.type != "cuda":
        raise ValueError("device must be a ROCm GPU")
    if torch.version.hip is None:
        raise RuntimeError("This lesson requires ROCm")
    supplied_out = out is not None
    with torch.cuda.device(device), torch.cuda.stream(stream):
        if out is None:
            out = torch.empty((160,), dtype=torch.int32, device=device)
        if (
            out.dtype != torch.int32
            or tuple(out.shape) != (160,)
            or not out.is_contiguous()
        ):
            raise ValueError("out must be a contiguous int32 tensor of shape (160,)")
        _launch_divide_offsets(out, stream=fx.Stream(torch.cuda.current_stream(device)))
    if supplied_out:
        torch.autograd.graph.increment_version(out)
    return out


def solve():
    """Launch the exercise, check every GPU result, and return the lesson checkpoint."""
    out = torch.full((160,), -1, dtype=torch.int32, device="cuda")
    divide_offsets(out=out)
    torch.cuda.synchronize()
    rows = out.cpu().reshape(32, 5).tolist()
    # Host code only checks and formats results; it does not implement layouts.
    expected_offsets = [
        0,
        1,
        2,
        3,
        8,
        9,
        10,
        11,
        4,
        5,
        6,
        7,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        24,
        25,
        26,
        27,
        20,
        21,
        22,
        23,
        28,
        29,
        30,
        31,
    ]
    assert rows == [[offset] * 5 for offset in expected_offsets], rows
    assert sorted(row[0] for row in rows) == list(range(32)), rows
    return [row[0] for row in rows[24:32]]  # Tile (1, 1), row-major locally.


if __name__ == "__main__":
    try:
        actual = solve()
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error} See README.md.") from None
    expected = [20, 21, 22, 23, 28, 29, 30, 31]
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
