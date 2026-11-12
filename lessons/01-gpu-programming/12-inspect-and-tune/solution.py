"""Compare native scalar-width and vector-width copy atoms; timings are observations."""

import argparse
import statistics

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def _copy_tiles(source: fx.Tensor, out: fx.Tensor, width: fx.Constexpr):
    # 1. Reuse the incoming contiguous 1-D views.
    window_layout = fx.make_layout(256, 1)
    source_windows = fx.logical_divide(source, window_layout)
    destination_windows = fx.logical_divide(out, window_layout)
    # 2. Select this block's 256-element windows.
    block_id = fx.block_idx.x
    source_window = fx.slice(source_windows, (None, block_id))
    destination_window = fx.slice(destination_windows, (None, block_id))
    # Describe each selected window as four values by 64 thread positions.
    tile_layout = fx.make_layout((4, 64), (1, 4))
    source_tile = fx.make_view(fx.get_iter(source_window), tile_layout)
    destination_tile = fx.make_view(fx.get_iter(destination_window), tile_layout)

    # 3. Build a copy plan: same ownership, different atom width.
    thread_layout = fx.make_layout((1, 64), (64, 1))
    value_layout = fx.make_layout((4, 1), (1, 4))
    tile_shape, ownership = fx.make_layout_tv(thread_layout, value_layout)
    atom = fx.make_copy_atom(fx.UniversalCopy(width), fx.Float32)
    plan = fx.make_tiled_copy(atom, ownership, tile_shape)
    thread_id = fx.thread_idx.x
    thread_copy = plan.get_slice(thread_id)
    source_part = thread_copy.partition_S(source_tile)
    destination_part = thread_copy.partition_D(destination_tile)

    # 4. Copy this thread's values.
    fx.copy(atom, source_part, destination_part)


@flyc.jit
def _launch_copy_tiles(
    source: fx.Tensor,
    out: fx.Tensor,
    width: fx.Constexpr,
    count: fx.Constexpr,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
):
    _copy_tiles(source, out, width).launch(
        grid=(count // 256, 1, 1), block=(64, 1, 1), stream=stream
    )


def copy_tiles(source, *, out=None, width=128, stream=None):
    """Validate inputs, allocate output if needed, and launch this lesson's kernel."""
    for name, tensor in (("source", source),):
        if not isinstance(tensor, torch.Tensor) or tensor.dtype != torch.float32:
            raise TypeError(f"{name} must be a torch.float32 tensor")
        if not tensor.is_cuda or tensor.ndim != 1 or not tensor.is_contiguous():
            raise ValueError(f"{name} must be a contiguous 1-D tensor on a ROCm GPU")
        if tensor.device != source.device:
            raise ValueError("Inputs must use the same device")
        if tensor.is_neg() or (torch.is_grad_enabled() and tensor.requires_grad):
            raise ValueError(f"{name} must be materialized and used without autograd")
    if source.numel() == 0:
        raise ValueError("Input must not be empty")
    if width not in (32, 128) or source.numel() % 256:
        raise ValueError("Use width 32 or 128 with complete 256-element tiles")
    if out is not None:
        if not isinstance(out, torch.Tensor) or out.dtype != torch.float32:
            raise TypeError("out has the wrong tensor type or dtype")
        if (
            out.device != source.device
            or out.shape != source.shape
            or not out.is_contiguous()
        ):
            raise ValueError(
                "out must be contiguous with the expected shape on the input device"
            )
        if out.is_neg() or (torch.is_grad_enabled() and out.requires_grad):
            raise ValueError("out must be materialized and used without autograd")
    if source.data_ptr() % 16 or (out is not None and out.data_ptr() % 16):
        raise ValueError("Source and output pointers must be 16-byte aligned")
    if torch.version.hip is None:
        raise RuntimeError("This lesson requires ROCm")
    supplied_out = out is not None
    with torch.cuda.device(source.device), torch.cuda.stream(stream):
        if out is None:
            out = torch.empty(source.shape, dtype=source.dtype, device=source.device)
        _launch_copy_tiles(
            source,
            out,
            width,
            source.numel(),
            stream=fx.Stream(torch.cuda.current_stream(source.device)),
        )
    if supplied_out:
        torch.autograd.graph.increment_version(out)
    return out


def measure(source, out, width, count):
    # Compile and warm up before starting any event measurements.
    for _ in range(3):
        copy_tiles(source, out=out, width=width)
    torch.cuda.synchronize()
    samples = []
    for _ in range(5):
        start, end = (
            torch.cuda.Event(enable_timing=True),
            torch.cuda.Event(enable_timing=True),
        )
        start.record()
        for _ in range(20):
            copy_tiles(source, out=out, width=width)
        end.record()
        end.synchronize()
        samples.append(start.elapsed_time(end) / 20)
    # Some GPU/driver combinations report zero even for completed work.
    # Keep correctness checks useful without inventing a bandwidth result.
    milliseconds = statistics.median(samples)
    return milliseconds if milliseconds > 0 else None


def solve(widths=(32, 128)):
    count = 2**20  # Divisible by 256; 16-byte aligned PyTorch base and block offsets.
    source = torch.arange(count, dtype=torch.float32, device="cuda")
    out = torch.empty_like(source)
    results = []
    for width in widths:
        out.fill_(-1)
        copy_tiles(source, out=out, width=width)
        torch.cuda.synchronize()
        torch.testing.assert_close(out, source)
        milliseconds = measure(source, out, width, count)
        # Effective read+write traffic, not a measurement of DRAM transactions.
        bandwidth = (
            2 * count * source.element_size() / (milliseconds * 1e6)
            if milliseconds is not None
            else None
        )
        results.append(
            {
                "atom_bits": width,
                "ms": round(milliseconds, 4) if milliseconds is not None else None,
                "effective_GB_s": round(bandwidth, 2)
                if bandwidth is not None
                else None,
                "timing_status": "ok"
                if milliseconds is not None
                else "GPU event timing unavailable",
            }
        )
    return results


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--width", type=int, choices=(32, 128))
    args = parser.parse_args()
    try:
        print("Exercise passed:", solve((args.width,) if args.width else (32, 128)))
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None
