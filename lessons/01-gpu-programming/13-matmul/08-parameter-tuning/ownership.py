"""Verify the enlarged MMA's real C ownership with a native tiled-copy kernel."""

import runpy
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch


@flyc.kernel
def owner_kernel(
    output: fx.Tensor,
    m: fx.Constexpr,
    n: fx.Constexpr,
    waves_m: fx.Constexpr,
    waves_n: fx.Constexpr,
):
    view = fx.make_view(fx.get_iter(output), fx.make_layout((m, n), (n, 1)))
    mma_atom = fx.make_mma_atom(fx.rocdl.WMMA(16, 16, 16, fx.BFloat16, fx.Float32))
    mma = fx.make_tiled_mma(
        mma_atom, fx.make_layout((waves_m, waves_n, 1), (1, waves_m, 0))
    )
    fragment = mma.thr_slice(fx.thread_idx.x).make_fragment_C(view)
    fragment.fill(fx.Float32(fx.thread_idx.x))
    copy = fx.make_copy_atom(fx.UniversalCopy32b(), fx.Float32)
    thread_copy = fx.make_tiled_copy_C(copy, mma).get_slice(fx.thread_idx.x)
    fx.copy(copy, thread_copy.retile(fragment), thread_copy.partition_D(view))


@flyc.jit
def run(
    output: fx.Tensor,
    m: fx.Constexpr,
    n: fx.Constexpr,
    waves_m: fx.Constexpr,
    waves_n: fx.Constexpr,
):
    owner_kernel(output, m, n, waves_m, waves_n).launch(
        grid=(1, 1, 1), block=(32 * waves_m * waves_n, 1, 1)
    )


def check(m, n, waves_m, waves_n):
    output = torch.full((m, n), float("nan"), dtype=torch.float32, device="cuda")
    run(output, m, n, waves_m, waves_n)
    torch.cuda.synchronize()
    actual = output.cpu()
    rows, cols = torch.meshgrid(torch.arange(m), torch.arange(n), indexing="ij")
    wave_m, wave_n = (rows // 16) % waves_m, (cols // 16) % waves_n
    expected = cols % 16 + 16 * (rows % 2) + 32 * (wave_m + waves_m * wave_n)
    torch.testing.assert_close(actual, expected.float(), rtol=0, atol=0)
    owners, counts = torch.unique(actual, return_counts=True)
    assert torch.equal(
        owners, torch.arange(32 * waves_m * waves_n, dtype=torch.float32)
    )
    assert torch.all(counts == m * n // (32 * waves_m * waves_n)).item()
    positions = torch.nonzero(actual == 17).tolist()
    return {
        "tile": [m, n],
        "values_per_thread": int(counts[0]),
        "thread17_first_positions": positions[:8],
        "all_positions_checked": m * n,
    }


def main():
    module = runpy.run_path(str(Path(__file__).with_name("solution.py")))
    config = module["SELECTED_CONFIG"]
    results = [
        check(32, 32, 2, 2),
        check(config.block_m, config.block_n, config.waves_m, config.waves_n),
    ]
    print("Ownership passed:", results)
    return results


if __name__ == "__main__":
    main()
