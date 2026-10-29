"""Solution: Coalesce a layout.

Run from the repository root:
    pixi run python lessons/00-layout-algebra/04-coalescing/solution.py
Layout algebra is traced by FlyDSL; thread-dependent mappings run on the GPU.
"""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def exercise_kernel(out: fx.Tensor):
    thread_id = fx.thread_idx.x
    original = fx.make_layout((2, 3), (3, 6))
    # First-mode-fastest ownership makes thread_id the original scalar logical index.
    thread_layout = fx.make_ordered_layout(fx.get_shape(original), (0, 1))
    coordinate = fx.idx2crd(thread_id, thread_layout)
    # Compute: Map the original tuple and the same scalar index after coalescing.
    # The coalesced layout may have a different shape; do not reuse the tuple.
    simplified = fx.coalesce(original)
    original_offset = fx.crd2idx(coordinate, original)
    simplified_offset = fx.crd2idx(thread_id, simplified)
    out[thread_id * 4] = fx.get_scalar(original_offset)
    out[thread_id * 4 + 1] = fx.get_scalar(simplified_offset)
    out[thread_id * 4 + 2] = fx.get_scalar(fx.size(simplified))
    out[thread_id * 4 + 3] = fx.get_scalar(fx.cosize(simplified))


@flyc.jit
def run(out: fx.Tensor, stream: fx.Stream = fx.Stream(None)):  # noqa: B008 -- FlyDSL stream default
    # Exactly 6 threads: every thread owns one output row; no tail mask needed.
    exercise_kernel(out).launch(grid=(1, 1, 1), block=(6, 1, 1), stream=stream)


def solve():
    """Launch the exercise, check every GPU result, and return the lesson checkpoint."""
    out = torch.full((24,), -1, dtype=torch.int32, device="cuda")
    run(out)
    torch.cuda.synchronize()
    rows = out.cpu().reshape(6, 4).tolist()
    # Host code only checks and formats results; it does not implement layouts.
    expected_offsets = [0, 3, 6, 9, 12, 15]
    assert rows == [[offset, offset, 6, 16] for offset in expected_offsets], rows
    return [row[0] for row in rows], [row[1] for row in rows]


if __name__ == "__main__":
    try:
        actual = solve()
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error} See README.md.") from None
    expected = ([0, 3, 6, 9, 12, 15], [0, 3, 6, 9, 12, 15])
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
