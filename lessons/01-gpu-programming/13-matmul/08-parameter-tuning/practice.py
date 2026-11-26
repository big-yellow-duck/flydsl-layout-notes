"""Tune native BF16 WMMA block tiles without changing global input layouts."""

import argparse
import json
import runpy
from dataclasses import dataclass
from functools import lru_cache, partial
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch

WAVE_SIZE = 32
MMA_M, MMA_N, MMA_K = 16, 16, 16


@dataclass(frozen=True)
class Config:
    group_tile_m: int = 64
    group_tile_n: int = 64
    stage_k: int = 32
    waves_per_group_m: int = 2
    waves_per_group_n: int = 2
    traversal_group_m: int = 8

    @property
    def name(self):
        return (
            f"08_tile{self.group_tile_m}x{self.group_tile_n}_stagek{self.stage_k}"
            f"_waves{self.waves_per_group_m}x{self.waves_per_group_n}_groups1x1"
            f"_traversalm{self.traversal_group_m}"
        )

    @property
    def threads(self):
        return 32 * self.waves_per_group_m * self.waves_per_group_n

    @property
    def accumulator_values(self):
        return (
            8
            * (self.group_tile_m // (16 * self.waves_per_group_m))
            * (self.group_tile_n // (16 * self.waves_per_group_n))
        )

    @property
    def lds_bytes(self):
        return 2 * (
            self.group_tile_m * (self.stage_k + 8) + self.stage_k * self.group_tile_n
        )


def validate_config(config, shape=(1024, 1024, 1024)):
    bm, bn, bk = config.group_tile_m, config.group_tile_n, config.stage_k
    if any(value <= 0 for value in (bm, bn, bk)):
        raise ValueError("Block dimensions must be positive")
    if len(shape) != 3 or any(value <= 0 for value in shape):
        raise ValueError("Shape must contain positive M,N,K")
    if any(size % tile for size, tile in zip(shape, (bm, bn, bk), strict=True)):
        raise ValueError("Shape must contain complete block tiles")
    if (
        config.waves_per_group_m < 1
        or config.waves_per_group_n < 1
        or config.threads not in (64, 128, 256)
    ):
        raise ValueError("Use two, four, or eight wave32 groups")
    if (
        bm % (16 * config.waves_per_group_m)
        or bn % (16 * config.waves_per_group_n)
        or bk % 16
    ):
        raise ValueError("Block tile must contain whole WMMA groups and K fragments")
    for rows, columns in ((bm, bk), (bk, bn)):
        chunks = columns // 8
        if columns % 8 or chunks > config.threads or config.threads % chunks:
            raise ValueError("Copy geometry must distribute aligned eight-BF16 chunks")
        if rows % (config.threads // chunks):
            raise ValueError(
                "Every cooperative staging thread must own complete chunks"
            )
    if config.traversal_group_m < 1:
        raise ValueError("traversal_group_m must be positive")
    tile_rows = shape[0] // bm
    if tile_rows % min(config.traversal_group_m, tile_rows):
        raise ValueError("traversal_group_m must form complete output tile row groups")
    if config.lds_bytes > 65536:
        raise ValueError("LDS allocation exceeds this lesson's 64 KiB limit")
    return config


@lru_cache(None)
def _shared_storage_type(BLOCK_M, BLOCK_N, BLOCK_K):
    @fx.struct
    class SharedStorage:
        # Retain stage 06's measured padded A layout and packed B layout.
        a: fx.Array[fx.BFloat16, BLOCK_M * (BLOCK_K + 8), 16]
        b: fx.Array[fx.BFloat16, BLOCK_K * BLOCK_N, 16]

    return SharedStorage


@flyc.kernel
def _matmul_bf16(
    a: fx.Tensor,
    b: fx.Tensor,
    c: fx.Tensor,
    m: fx.Constexpr,
    n: fx.Constexpr,
    k: fx.Constexpr,
    *,
    BLOCK_M: fx.Constexpr,
    BLOCK_N: fx.Constexpr,
    BLOCK_K: fx.Constexpr,
    WAVES_M: fx.Constexpr,
    WAVES_N: fx.Constexpr,
    GROUP_M: fx.Constexpr,
):
    THREADS_PER_BLOCK = WAVE_SIZE * WAVES_M * WAVES_N
    SharedStorage = _shared_storage_type(BLOCK_M, BLOCK_N, BLOCK_K)
    a_buffer = fx.rocdl.make_buffer_tensor(a)
    b_buffer = fx.rocdl.make_buffer_tensor(b)
    c_buffer = fx.rocdl.make_buffer_tensor(c)

    a_global_view = fx.make_view(
        fx.get_iter(a_buffer), fx.make_layout((m, k), (k, 1))
    )
    b_global_view = fx.make_view(
        fx.get_iter(b_buffer), fx.make_layout((k, n), (n, 1))
    )
    c_global_view = fx.make_view(
        fx.get_iter(c_buffer), fx.make_layout((m, n), (n, 1))
    )
    tiles_m = m // BLOCK_M
    tiles_n = n // BLOCK_N
    flat_block_id = fx.block_idx.x

    # For case (1024,1024,1024)
    # group width = 8
    # block tile order = (8, 8, 1): (8, 1, 64)
    # for case (1024, 4096, 2048)
    # group width = 2
    # block tile order = (2,32,4): (32,1,64)
    group_width = min(GROUP_M, tiles_m)
    block_tile_order = fx.make_layout(
        (group_width, tiles_n, tiles_m // group_width),
        (tiles_n, 1, group_width * tiles_n),
    )

    # map each block to the traversal_group_m output tile layout
    output_tile_offset = fx.crd2idx(flat_block_id, block_tile_order)
    output_tile_layout = fx.make_layout((tiles_m, tiles_n), (tiles_n, 1))
    output_tile_coords = fx.idx2crd(output_tile_offset, output_tile_layout)
    block_row = fx.get_scalar(output_tile_coords[0])
    block_col = fx.get_scalar(output_tile_coords[1])

    # group neighouting blocks
    a_tiled_view = fx.flat_divide(a_global_view, (BLOCK_M, BLOCK_K))
    b_tiled_view = fx.flat_divide(b_global_view, (BLOCK_K, BLOCK_N))
    c_tiled_view = fx.flat_divide(c_global_view, (BLOCK_M, BLOCK_N))
    c_block_view = fx.slice(c_tiled_view, (None, None, block_row, block_col))

    # allocate shared mem
    lds = fx.SharedAllocator().allocate(SharedStorage).peek()
    a_lds_view = lds.a.view(fx.make_layout((BLOCK_M, BLOCK_K), (BLOCK_K + 8, 1)))
    b_lds_view = lds.b.view(fx.make_layout((BLOCK_K, BLOCK_N), (BLOCK_N, 1)))

    # setup copies from gmem to registers to lds
    copy_128b = fx.make_copy_atom(fx.UniversalCopy128b(), fx.BFloat16)
    a_staging_thread_layout = fx.make_ordered_layout(
        (THREADS_PER_BLOCK // (BLOCK_K // 8), (BLOCK_K // 8)), (1, 0)
    )
    # TODO 1: Derive B's staging thread layout for eight-BF16 chunks.
    b_staging_thread_layout = None
    if b_staging_thread_layout is None:
        raise NotImplementedError("Fill in b_staging_thread_layout.")
    staging_value_layout = fx.make_ordered_layout((1, 8), (1, 0))
    a_staging_copy_tile, a_staging_copy_tv = fx.make_layout_tv(
        a_staging_thread_layout, staging_value_layout
    )
    b_staging_copy_tile, b_staging_copy_tv = fx.make_layout_tv(
        b_staging_thread_layout, staging_value_layout
    )

    a_staging_copy_plan = fx.make_tiled_copy(
        copy_128b, a_staging_copy_tv, a_staging_copy_tile
    )
    b_staging_copy_plan = fx.make_tiled_copy(
        copy_128b, b_staging_copy_tv, b_staging_copy_tile
    )

    a_thread_staging_copy = a_staging_copy_plan.get_slice(fx.thread_idx.x)
    b_thread_staging_copy = b_staging_copy_plan.get_slice(fx.thread_idx.x)

    a_lds_destination = a_thread_staging_copy.partition_D(a_lds_view)
    b_lds_destination = b_thread_staging_copy.partition_D(b_lds_view)
    a_staging_fragment = fx.make_fragment_like(a_lds_destination)
    b_staging_fragment = fx.make_fragment_like(b_lds_destination)

    ## setup copies for mma
    buffer_copy_128b = fx.make_copy_atom(fx.rocdl.BufferCopy128b(), fx.BFloat16)
    a_lds_tiled = fx.flat_divide(a_lds_view, (BLOCK_M, MMA_K))
    b_lds_transposed_view = fx.make_view(
        fx.get_iter(b_lds_view),
        fx.make_layout((BLOCK_N, BLOCK_K), (1, BLOCK_N)),
    )
    b_lds_transposed_tiled = fx.flat_divide(
        b_lds_transposed_view, (BLOCK_N, MMA_K)
    )
    a_lds_initial_view = fx.slice(a_lds_tiled, (None, None, 0, 0))
    b_lds_transposed_initial_view = fx.slice(
        b_lds_transposed_tiled, (None, None, 0, 0)
    )

    # setup mma
    mma_atom = fx.make_mma_atom(
        fx.rocdl.WMMA(MMA_M, MMA_N, MMA_K, fx.BFloat16, fx.Float32)
    )
    mma = fx.make_tiled_mma(
        mma_atom, fx.make_layout((WAVES_M, WAVES_N, 1), (1, WAVES_M, 0))
    )
    thread_mma = mma.thr_slice(fx.thread_idx.x)
    c_accum = thread_mma.make_fragment_C(c_block_view)
    c_accum.fill(0)

    # lds to register copies for mma
    copy_16b = fx.make_copy_atom(fx.UniversalCopy16b(), fx.BFloat16)
    a_lds2reg_copy_plan = fx.make_tiled_copy_A(copy_16b, mma)
    b_lds2reg_copy_plan = fx.make_tiled_copy_B(copy_16b, mma)
    a_lds2reg_thread_copy = a_lds2reg_copy_plan.get_slice(fx.thread_idx.x)
    b_lds2reg_thread_copy = b_lds2reg_copy_plan.get_slice(fx.thread_idx.x)

    a_r_tile = thread_mma.make_fragment_A(a_lds_initial_view)
    b_r_tile = thread_mma.make_fragment_B(b_lds_transposed_initial_view)

    a_r_destination = a_lds2reg_thread_copy.retile(a_r_tile)
    b_r_destination = b_lds2reg_thread_copy.retile(b_r_tile)

    def create_gmem2reg_sources(a_block_view, b_block_view):
        return (
            a_thread_staging_copy.partition_S(a_block_view),
            b_thread_staging_copy.partition_S(b_block_view),
        )

    def gmem2reg_load_tile(tile_k):
        a_block_view = fx.slice(a_tiled_view, (None, None, block_row, tile_k))
        b_block_view = fx.slice(b_tiled_view, (None, None, tile_k, block_col))
        a_global_source, b_global_source = create_gmem2reg_sources(
            a_block_view, b_block_view
        )
        fx.copy(buffer_copy_128b, a_global_source, a_staging_fragment)
        fx.copy(buffer_copy_128b, b_global_source, b_staging_fragment)

    def reg2lds_copy_tile():
        fx.copy(copy_128b, a_staging_fragment, a_lds_destination)
        fx.copy(copy_128b, b_staging_fragment, b_lds_destination)
        fx.barrier()

    def compute_lds():
        for inner_k in fx.range_constexpr(BLOCK_K // MMA_K):
            a_mma_view = fx.slice(a_lds_tiled, (None, None, 0, inner_k))
            b_mma_view = fx.slice(
                b_lds_transposed_tiled, (None, None, 0, inner_k)
            )
            a_r_source = a_lds2reg_thread_copy.partition_S(a_mma_view)
            b_r_source = b_lds2reg_thread_copy.partition_S(b_mma_view)
            fx.copy(copy_16b, a_r_source, a_r_destination)
            fx.copy(copy_16b, b_r_source, b_r_destination)
            fx.gemm(mma_atom, c_accum, a_r_tile, b_r_tile, c_accum)

    # compute
    initial_tile_k = 0
    gmem2reg_load_tile(initial_tile_k)
    reg2lds_copy_tile()

    for tile_k in range(k // BLOCK_K - 1):
        next_tile_k = tile_k + 1
        gmem2reg_load_tile(next_tile_k)
        compute_lds()
        fx.barrier()
        reg2lds_copy_tile()
    compute_lds()
    fx.barrier()

    c_registers = fx.make_rmem_tensor(c_accum.layout, fx.BFloat16)
    print(c_accum.layout)
    # TODO 2: Derive the value count from accumulator.shape.
    ACCUMULATOR_VALUES = None
    if ACCUMULATOR_VALUES is None:
        raise NotImplementedError("Fill in ACCUMULATOR_VALUES.")
    print(ACCUMULATOR_VALUES)

    for slot in fx.range_constexpr(ACCUMULATOR_VALUES):
        c_registers[slot] = c_accum[slot].to(fx.BFloat16)
    buffer_copy_16b = fx.make_copy_atom(fx.rocdl.BufferCopy16b(), fx.BFloat16)
    reg2gmem_copy_plan = fx.make_tiled_copy_C(buffer_copy_16b, mma)
    reg2gmem_thread_copy = reg2gmem_copy_plan.get_slice(fx.thread_idx.x)
    reg2gmem_source = reg2gmem_thread_copy.retile(c_registers)
    reg2gmem_dest = reg2gmem_thread_copy.partition_D(c_block_view)
    fx.copy(buffer_copy_16b, reg2gmem_source, reg2gmem_dest)


@flyc.jit
def _launch_matmul_bf16(
    a: fx.Tensor,
    b: fx.Tensor,
    c: fx.Tensor,
    m: fx.Constexpr,
    n: fx.Constexpr,
    k: fx.Constexpr,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
    *,
    BLOCK_M: fx.Constexpr,
    BLOCK_N: fx.Constexpr,
    BLOCK_K: fx.Constexpr,
    WAVES_M: fx.Constexpr,
    WAVES_N: fx.Constexpr,
    GROUP_M: fx.Constexpr,
):
    THREADS_PER_BLOCK = WAVE_SIZE * WAVES_M * WAVES_N
    _matmul_bf16(
        a,
        b,
        c,
        m,
        n,
        k,
        BLOCK_M=BLOCK_M,
        BLOCK_N=BLOCK_N,
        BLOCK_K=BLOCK_K,
        WAVES_M=WAVES_M,
        WAVES_N=WAVES_N,
        GROUP_M=GROUP_M,
    ).launch(
        grid=(m // BLOCK_M * (n // BLOCK_N), 1, 1),
        block=(THREADS_PER_BLOCK, 1, 1),
        stream=stream,
    )


SELECTED_CONFIG = Config(128, 128, 32, 1, 4, traversal_group_m=8)
CONFIGS_BY_SHAPE = {
    (1024, 1024, 1024): SELECTED_CONFIG,
    (1024, 4096, 2048): Config(128, 128, 32, 1, 4, traversal_group_m=2),
}


def matmul_bf16(input, other, *, out=None, config=None, stream=None):
    """Launch contiguous 2-D BF16 matmul on gfx1151/gfx1152.

    Unsupported calls raise an error. Supply config for compatible shapes
    outside CONFIGS_BY_SHAPE. Split-K scratch is cached per device/stream/capture
    and allocated only for split_k > 1. Warm up before graph capture.
    """
    a = input
    b = other
    c = out
    tensors = [("input", a), ("other", b)]
    if c is not None:
        tensors.append(("out", c))
    for name, tensor in tensors:
        if type(tensor) not in (torch.Tensor, torch.nn.Parameter):
            raise TypeError(
                f"{name} must be a torch.Tensor; custom tensor subclasses are unsupported"
            )
    if torch._C._are_functorch_transforms_active():
        raise RuntimeError("matmul_bf16 does not support vmap or tensor transforms")
    if torch.autograd.forward_ad._current_level >= 0:
        raise RuntimeError("matmul_bf16 does not support forward-mode autograd")
    if torch.is_autocast_enabled("cuda"):
        raise RuntimeError(
            "matmul_bf16 requires explicit BF16 inputs; disable autocast"
        )
    for name, tensor in tensors:
        if tensor.dtype != torch.bfloat16:
            raise TypeError(
                f"{name} must have dtype torch.bfloat16; got {tensor.dtype}"
            )
        if not tensor.is_cuda:
            raise ValueError(f"{name} must be on a ROCm GPU")
        if tensor.device != a.device:
            raise ValueError(f"{name} must be on the same device as input")
        if tensor.layout != torch.strided or not tensor.is_contiguous():
            raise ValueError(f"{name} must be contiguous and row-major")
        if tensor.is_neg():
            raise ValueError(
                f"{name} must not be a negative view; call resolve_neg() first"
            )
        if torch.is_grad_enabled() and tensor.requires_grad:
            raise RuntimeError(
                f"{name} requires gradients; matmul_bf16 has no autograd support, use torch.no_grad()"
            )
    if a.ndim != 2 or b.ndim != 2:
        raise ValueError("input and other must be two-dimensional matrices")
    if a.shape[1] != b.shape[0]:
        raise ValueError(
            f"K dimensions must match; got {a.shape[1]} and {b.shape[0]}"
        )
    if a.data_ptr() % 16 or b.data_ptr() % 16:
        raise ValueError("input and other must have 16-byte aligned data pointers")
    if torch.version.hip is None:
        raise RuntimeError("matmul_bf16 requires ROCm")
    arch = torch.cuda.get_device_properties(a.device).gcnArchName.split(":")[0]
    if arch not in ("gfx1151", "gfx1152"):
        raise RuntimeError(f"matmul_bf16 requires gfx1151/gfx1152; detected {arch}")
    shape = (a.shape[0], b.shape[1], a.shape[1])
    if config is None:
        config = CONFIGS_BY_SHAPE.get(shape)
        if config is None:
            raise ValueError(
                f"No default config for M,N,K={shape}; supply config=Config(...)"
            )
    if not isinstance(config, Config):
        raise TypeError("config must be a Config")
    validate_config(config, shape)
    if c is not None:
        if c.shape != (shape[0], shape[1]):
            raise ValueError(
                f"out must have shape {(shape[0], shape[1])}; got {tuple(c.shape)}"
            )
        start = c.data_ptr()
        stop = start + c.numel() * c.element_size()
        for name, tensor in tensors[:2]:
            if (
                start < tensor.data_ptr() + tensor.numel() * tensor.element_size()
                and tensor.data_ptr() < stop
            ):
                raise ValueError(f"out must not overlap {name}")
    if stream is not None and stream.device != a.device:
        raise ValueError("Stream and inputs must use the same device")
    supplied_out = c is not None
    with torch.cuda.device(a.device), torch.cuda.stream(stream):
        current_stream = torch.cuda.current_stream(a.device)
        if c is None:
            c = torch.empty(
                (shape[0], shape[1]), dtype=a.dtype, device=a.device
            )
        _launch_matmul_bf16(
            a,
            b,
            c,
            *shape,
            fx.Stream(current_stream),
            BLOCK_M=config.group_tile_m,
            BLOCK_N=config.group_tile_n,
            BLOCK_K=config.stage_k,
            WAVES_M=config.waves_per_group_m,
            WAVES_N=config.waves_per_group_n,
            GROUP_M=config.traversal_group_m,
        )
        if supplied_out:
            torch.autograd.graph.increment_version(c)
    return c


def check_boundaries(config):

    checked = []
    for tiles in (1, 2, 3):
        m, n, k = config.group_tile_m, config.group_tile_n, config.stage_k * tiles
        tags = (2 ** (torch.arange(k, dtype=torch.int32) // config.stage_k)).to(
            torch.bfloat16
        )
        a = tags.expand(m, k).contiguous().cuda()
        b = torch.ones((k, n), dtype=torch.bfloat16, device="cuda")
        storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
        c = storage[: m * n].view(m, n)
        c.fill_(float("nan"))
        matmul_bf16(a, b, out=c, config=config)
        torch.cuda.synchronize()
        expected = config.stage_k * (2**tiles - 1)
        torch.testing.assert_close(
            c.cpu(),
            torch.full((m, n), expected, dtype=torch.bfloat16),
            rtol=0,
            atol=0,
        )
        assert torch.all(storage[m * n :] == -99).item(), "Boundary sentinel changed"
        checked.append({"K_tiles": tiles, "expected": expected})
    return checked


def solve(config=None, shape=(1024, 1024, 1024)):
    shape = tuple(shape)
    if config is None:
        config = CONFIGS_BY_SHAPE[shape]
    validate_config(config, shape)
    architecture = torch.cuda.get_device_properties(0).gcnArchName.split(":")[0]
    if architecture not in ("gfx1151", "gfx1152"):
        raise RuntimeError(
            f"This lesson supports gfx1151/gfx1152; detected {architecture}"
        )

    boundaries = check_boundaries(config)
    generator = torch.Generator().manual_seed(13)
    checkpoint = None
    m, n, k = shape
    for pattern in ("trace", "random"):
        if pattern == "trace":
            a_cpu = ((torch.arange(m * k).reshape(m, k) % 5) - 2).to(torch.bfloat16)
            b_cpu = ((torch.arange(k * n).reshape(k, n) % 7) - 3).to(torch.bfloat16)
        else:
            a_cpu = torch.randn(m, k, generator=generator).to(torch.bfloat16)
            b_cpu = torch.randn(k, n, generator=generator).to(torch.bfloat16)
        a, b = a_cpu.cuda(), b_cpu.cuda()
        storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
        c = storage[: m * n].view(m, n)
        c.fill_(float("nan"))
        matmul_bf16(a, b, out=c, config=config)
        torch.cuda.synchronize()
        expected = (a_cpu.float() @ b_cpu.float()).to(torch.bfloat16)
        torch.testing.assert_close(
            c.cpu(),
            expected,
            rtol=0 if pattern == "trace" else 0.016,
            atol=0.001 if pattern == "trace" else 0.03125,
        )
        assert torch.all(storage[m * n :] == -99).item(), "Output sentinel changed"
        if pattern == "trace":
            checkpoint = c[0, :4].cpu().tolist()
    return {
        "shapes_MNK": [shape],
        "patterns": 2,
        "first_four": checkpoint,
        "config": config.name,
        "accumulator_values": config.accumulator_values,
        "lds_bytes": config.lds_bytes,
        "pipeline_boundaries": boundaries,
    }


def main():
    torch.set_num_threads(1)
    if globals().get("_COURSE_CHECK_ONLY", False):
        for shape in CONFIGS_BY_SHAPE:
            print("Exercise passed:", solve(shape=shape), flush=True)
        return
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--shape",
        type=int,
        nargs=3,
        default=(1024, 1024, 1024),
        metavar=("M", "N", "K"),
    )
    parser.add_argument("--check-only", action="store_true")
    parser.add_argument(
        "--timing", choices=("auto", "host", "gpu-event"), default="auto"
    )
    parser.add_argument("--repeats", type=int, default=20)
    args = parser.parse_args()
    shape = tuple(args.shape)
    if shape not in CONFIGS_BY_SHAPE:
        parser.error(
            "No locked config for this shape; use tune.py --shape M N K --sweep first"
        )
    if args.repeats < 1:
        parser.error("repeats must be positive")
    try:
        print("Exercise passed:", solve(shape=shape), flush=True)
        if args.check_only:
            return
        benchmark = runpy.run_path(
            str(Path(__file__).resolve().parents[4] / "examples/matmul_benchmark.py")
        )
        config = CONFIGS_BY_SHAPE[shape]
        metadata, rows = benchmark["comparison"](
            {config.name: partial(matmul_bf16, config=config)},
            args.timing,
            args.repeats,
            shape=shape,
        )
        print(json.dumps(metadata))
        for row in rows:
            print(json.dumps(row))
    except NotImplementedError as error:
        raise SystemExit(f"Practice not finished: {error}") from None


if __name__ == "__main__":
    main()
