"""Compare native scalar-width and vector-width copy atoms; timings are observations."""

import argparse
import statistics

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def exercise_kernel(source: fx.Tensor, out: fx.Tensor, width: fx.Constexpr):
    block_id = fx.block_idx.x
    thread_id = fx.thread_idx.x
    source_tile = fx.slice(
        fx.logical_divide(source, fx.make_layout(256, 1)), (None, block_id)
    )
    destination_tile = fx.slice(
        fx.logical_divide(out, fx.make_layout(256, 1)), (None, block_id)
    )
    thread_layout = fx.make_layout((1, 64), (64, 1))
    value_layout = fx.make_layout((4, 1), (1, 4))
    tile_shape, ownership = fx.make_layout_tv(thread_layout, value_layout)
    # TODO: width is in bits; each float32 is 32 bits.
    atom = fx.make_copy_atom(fx.UniversalCopy(width), fx.Float32)
    plan = fx.make_tiled_copy(atom, ownership, tile_shape)
    thread_copy = plan.get_slice(thread_id)
    layout = fx.make_layout((4, 64), (1, 4))
    src = thread_copy.partition_S(fx.make_view(fx.get_iter(source_tile), layout))
    dst = thread_copy.partition_D(fx.make_view(fx.get_iter(destination_tile), layout))
    fx.copy(atom, src, dst)


@flyc.jit
def run(source: fx.Tensor, out: fx.Tensor, width: fx.Constexpr, count: fx.Constexpr):
    exercise_kernel(source, out, width).launch(
        grid=(count // 256, 1, 1), block=(64, 1, 1)
    )


def measure(source, out, width, count):
    # Compile and warm up before starting any event measurements.
    for _ in range(3):
        run(source, out, width, count)
    torch.cuda.synchronize()
    samples = []
    for _ in range(5):
        start, end = (
            torch.cuda.Event(enable_timing=True),
            torch.cuda.Event(enable_timing=True),
        )
        start.record()
        for _ in range(20):
            run(source, out, width, count)
        end.record()
        end.synchronize()
        samples.append(start.elapsed_time(end) / 20)
    return statistics.median(samples)


def solve(widths=(32, 128)):
    count = 2**20  # Divisible by 256; 16-byte aligned PyTorch base and block offsets.
    source = torch.arange(count, dtype=torch.float32, device="cuda")
    out = torch.empty_like(source)
    results = []
    for width in widths:
        out.fill_(-1)
        run(source, out, width, count)
        torch.cuda.synchronize()
        torch.testing.assert_close(out, source)
        milliseconds = measure(source, out, width, count)
        # Effective read+write traffic, not a measurement of DRAM transactions.
        bandwidth = 2 * count * source.element_size() / (milliseconds * 1e6)
        results.append(
            {
                "atom_bits": width,
                "ms": round(milliseconds, 4),
                "effective_GB_s": round(bandwidth, 2),
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
