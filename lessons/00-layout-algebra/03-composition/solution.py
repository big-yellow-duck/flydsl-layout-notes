"""Solution: Compose two layouts.

Run from the repository root:
    pixi run python lessons/00-layout-algebra/03-composition/solution.py
Layout algebra is traced by FlyDSL; thread-dependent mappings run on the GPU.
"""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def _compose_offsets(out: fx.Tensor):
    thread_id = fx.thread_idx.x
    a = fx.make_layout((2, 4), (4, 1))
    b = fx.make_layout((4, 2), (2, 1))
    # Assign threads to B's coordinate domain, first mode fastest.
    thread_layout = fx.make_ordered_layout(fx.get_shape(b), (0, 1))
    coordinate = fx.idx2crd(thread_id, thread_layout)
    # Compute: Build the compiler's composed layout; B runs first.
    composed = fx.composition(a, b)
    intermediate = fx.crd2idx(coordinate, b)
    final_offset = fx.crd2idx(coordinate, composed)
    out[thread_id * 3] = fx.get_scalar(intermediate)
    out[thread_id * 3 + 1] = fx.get_scalar(final_offset)
    # Compare native composition with explicit two-stage native evaluation.
    out[thread_id * 3 + 2] = fx.get_scalar(fx.crd2idx(intermediate, a))


@flyc.jit
def _launch_compose_offsets(
    out: fx.Tensor,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
):
    _compose_offsets(out).launch(grid=(1, 1, 1), block=(8, 1, 1), stream=stream)


def compose_offsets(*, out=None, device="cuda", stream=None):
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
        _launch_compose_offsets(
            out, stream=fx.Stream(torch.cuda.current_stream(device))
        )
    if supplied_out:
        torch.autograd.graph.increment_version(out)
    return out


def solve():
    """Launch the exercise, check every GPU result, and return the lesson checkpoint."""
    out = torch.full((24,), -1, dtype=torch.int32, device="cuda")
    compose_offsets(out=out)
    torch.cuda.synchronize()
    rows = out.cpu().reshape(8, 3).tolist()
    # Host code only checks and formats results; it does not implement layouts.
    intermediates = [0, 2, 4, 6, 1, 3, 5, 7]
    assert rows == [
        [value, thread_id, thread_id] for thread_id, value in enumerate(intermediates)
    ], rows
    return [row[1] for row in rows]


if __name__ == "__main__":
    try:
        actual = solve()
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error} See README.md.") from None
    expected = list(range(8))
    assert actual == expected, f"Expected {expected!r}, got {actual!r}"
    print("Exercise passed:", actual)
