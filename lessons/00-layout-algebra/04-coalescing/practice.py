# ruff: noqa: F841 -- Inputs become used when TODOs are filled.
"""Practice: Coalesce a layout.

Run from the repository root:
    pixi run python lessons/00-layout-algebra/04-coalescing/practice.py
Layout algebra is traced by FlyDSL; thread-dependent mappings run on the GPU.
"""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def _coalesce_offsets(out: fx.Tensor):
    thread_id = fx.thread_idx.x
    original = fx.make_layout((2, 3), (3, 6))
    # First-mode-fastest ownership makes thread_id the original scalar logical index.
    thread_layout = fx.make_ordered_layout(fx.get_shape(original), (0, 1))
    coordinate = fx.idx2crd(thread_id, thread_layout)
    # Compute: Map the original tuple and the same scalar index after coalescing.
    # The coalesced layout may have a different shape; do not reuse the tuple.
    # TODO 1: Fill in simplified; see README.md.
    simplified = None
    if simplified is None:
        raise NotImplementedError("Fill in simplified.")
    # TODO 2: Fill in original_offset; see README.md.
    original_offset = None
    if original_offset is None:
        raise NotImplementedError("Fill in original_offset.")
    # TODO 3: Fill in simplified_offset; see README.md.
    simplified_offset = None
    if simplified_offset is None:
        raise NotImplementedError("Fill in simplified_offset.")
    out[thread_id * 4] = fx.get_scalar(original_offset)
    out[thread_id * 4 + 1] = fx.get_scalar(simplified_offset)
    out[thread_id * 4 + 2] = fx.get_scalar(fx.size(simplified))
    out[thread_id * 4 + 3] = fx.get_scalar(fx.cosize(simplified))


@flyc.jit
def _launch_coalesce_offsets(
    out: fx.Tensor,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
):
    _coalesce_offsets(out).launch(grid=(1, 1, 1), block=(6, 1, 1), stream=stream)


def coalesce_offsets(*, out=None, device="cuda", stream=None):
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
            out = torch.empty((24,), dtype=torch.int32, device=device)
        if (
            out.dtype != torch.int32
            or tuple(out.shape) != (24,)
            or not out.is_contiguous()
        ):
            raise ValueError("out must be a contiguous int32 tensor of shape (24,)")
        _launch_coalesce_offsets(
            out, stream=fx.Stream(torch.cuda.current_stream(device))
        )
    if supplied_out:
        torch.autograd.graph.increment_version(out)
    return out


def solve():
    """Launch the exercise, check every GPU result, and return the lesson checkpoint."""
    out = torch.full((24,), -1, dtype=torch.int32, device="cuda")
    coalesce_offsets(out=out)
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
