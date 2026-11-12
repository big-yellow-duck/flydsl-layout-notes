"""BF16 matmul: 04-vectorized-copy. See README.md for the exercise."""

import runpy
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch

BLOCK_M = 64
BLOCK_N = 64
BLOCK_K = 64
THREADS_PER_BLOCK = 256


@fx.struct
class SharedStorage:
    left: fx.Array[fx.BFloat16, BLOCK_M * BLOCK_K, 16]
    right: fx.Array[fx.BFloat16, BLOCK_K * BLOCK_N, 16]


@flyc.kernel
def _matmul_bf16(
    left: fx.Tensor,
    right: fx.Tensor,
    out: fx.Tensor,
    m: fx.Constexpr,
    n: fx.Constexpr,
    k: fx.Constexpr,
):
    # 1. get global view
    left_global_view = fx.make_view(fx.get_iter(left), fx.make_layout((m, k), (k, 1)))
    right_global_view = fx.make_view(fx.get_iter(right), fx.make_layout((k, n), (n, 1)))
    out_global_view = fx.make_view(fx.get_iter(out), fx.make_layout((m, n), (n, 1)))
    block_row = fx.block_idx.y
    block_col = fx.block_idx.x

    # 2. get tiled views
    left_tiled_view = fx.flat_divide(left_global_view, (BLOCK_M, BLOCK_K))
    right_tiled_view = fx.flat_divide(right_global_view, (BLOCK_K, BLOCK_N))
    out_tiled_view = fx.flat_divide(out_global_view, (BLOCK_M, BLOCK_N))
    out_block_view = fx.slice(out_tiled_view, (None, None, block_row, block_col))

    # 3. allocate lds for loading
    lds = fx.SharedAllocator().allocate(SharedStorage).peek()
    left_lds_view = lds.left.view(fx.make_layout((BLOCK_M, BLOCK_K), (BLOCK_K, 1)))
    right_lds_view = lds.right.view(fx.make_layout((BLOCK_K, BLOCK_N), (BLOCK_N, 1)))

    print(left_lds_view)

    # 4. prepare gmem to lds copy
    # thread layout: (32,8) val_layout: (1,8)
    copy_128b = fx.make_copy_atom(fx.UniversalCopy128b(), fx.BFloat16)
    staging_thread_layout = fx.make_ordered_layout((32, 8), (1, 0))
    staging_value_layout = fx.make_ordered_layout((1, 8), (1, 0))
    # logical elements shape covered = (32,64)
    staging_copy_tile, staging_copy_tv = fx.make_layout_tv(
        staging_thread_layout, staging_value_layout
    )
    staging_copy_plan = fx.make_tiled_copy(
        copy_128b, staging_copy_tv, staging_copy_tile
    )
    # get per thread copy plan
    thread_staging_copy = staging_copy_plan.get_slice(fx.thread_idx.x)

    # setup directions
    left_lds_destination = thread_staging_copy.partition_D(left_lds_view)
    right_lds_destination = thread_staging_copy.partition_D(right_lds_view)
    # create intermediate registers to hold copy destinations
    left_staging_fragment = fx.make_fragment_like(left_lds_destination)
    right_staging_fragment = fx.make_fragment_like(right_lds_destination)

    # 5. prepare lds to regsiter copy for left and right
    copy_16b = fx.make_copy_atom(fx.UniversalCopy16b(), fx.BFloat16)
    left_lds2reg_thread_layout = fx.make_ordered_layout((16, 1), (1, 0))
    left_lds2reg_value_layout = fx.make_ordered_layout((4, 1), (1, 0))
    left_lds2reg_copy_tile, left_lds2reg_copy_tv = fx.make_layout_tv(
        left_lds2reg_thread_layout, left_lds2reg_value_layout
    )
    left_lds2reg_copy_plan = fx.make_tiled_copy(
        copy_16b, left_lds2reg_copy_tv, left_lds2reg_copy_tile
    )

    copy_64b = fx.make_copy_atom(fx.UniversalCopy64b(), fx.BFloat16)
    right_lds2reg_thread_layout = fx.make_ordered_layout((1, 16), (1, 0))
    right_lds2reg_value_layout = fx.make_ordered_layout((1, 4), (1, 0))
    right_lds2reg_copy_tile, right_lds2reg_copy_tv = fx.make_layout_tv(
        right_lds2reg_thread_layout, right_lds2reg_value_layout
    )
    right_lds2reg_copy_plan = fx.make_tiled_copy(
        copy_64b, right_lds2reg_copy_tv, right_lds2reg_copy_tile
    )

    compute_thread_layout = fx.make_ordered_layout((16, 16), (1, 0))
    thread_coord = fx.idx2crd(fx.thread_idx.x, compute_thread_layout)

    left_lds2reg_thread_copy = left_lds2reg_copy_plan.get_slice(thread_coord[0])
    right_lds2reg_thread_copy = right_lds2reg_copy_plan.get_slice(thread_coord[1])

    left_lds_tiled_view = fx.flat_divide(left_lds_view, (64, 1))
    right_lds_tiled_view = fx.flat_divide(right_lds_view, (1, 64))

    left_lds_initial_slice = fx.slice(left_lds_tiled_view, (None, None, 0, 0))
    right_lds_initial_slice = fx.slice(right_lds_tiled_view, (None, None, 0, 0))

    left_r_initial_source = left_lds2reg_thread_copy.partition_S(left_lds_initial_slice)
    right_r_initial_source = right_lds2reg_thread_copy.partition_S(
        right_lds_initial_slice
    )

    # allocatte regsiter tiles
    left_r_tile = fx.make_fragment_like(left_r_initial_source, fx.BFloat16)
    right_r_tile = fx.make_fragment_like(right_r_initial_source, fx.BFloat16)

    # allocate 4x4 accumulator
    accumulator = fx.make_rmem_tensor(fx.make_layout((4, 4), (4, 1)), fx.Float32)
    accumulator.fill(0)

    # create helper to partition
    def create_gmem2reg_sources(left_block_view, right_block_view):
        return (
            thread_staging_copy.partition_S(left_block_view),
            thread_staging_copy.partition_S(right_block_view),
        )

    def create_lds2reg_sources(left_source, right_source):
        return (
            left_lds2reg_thread_copy.partition_S(left_source),
            right_lds2reg_thread_copy.partition_S(right_source),
        )

    # K loop
    for tile_k in range(k // BLOCK_K):
        left_block_view = fx.slice(left_tiled_view, (None, None, block_row, tile_k))
        right_block_view = fx.slice(right_tiled_view, (None, None, tile_k, block_col))
        left_global_source, right_global_source = create_gmem2reg_sources(
            left_block_view, right_block_view
        )

        fx.copy(copy_128b, left_global_source, left_staging_fragment)
        fx.copy(copy_128b, right_global_source, right_staging_fragment)
        fx.copy(copy_128b, left_staging_fragment, left_lds_destination)
        fx.copy(copy_128b, right_staging_fragment, right_lds_destination)
        fx.barrier()

        # loop within lds block
        for inner_k in range(BLOCK_K):
            left_lds_innerk_view = fx.slice(
                left_lds_tiled_view, (None, None, 0, inner_k)
            )
            right_lds_innerk_view = fx.slice(
                right_lds_tiled_view, (None, None, inner_k, 0)
            )
            left_r_source, right_r_source = create_lds2reg_sources(
                left_lds_innerk_view, right_lds_innerk_view
            )
            fx.copy(copy_16b, left_r_source, left_r_tile)
            fx.copy(copy_64b, right_r_source, right_r_tile)

            for row in range(4):
                for col in range(4):
                    coord = fx.make_coord(row, col)
                    accumulator[coord] += fx.Float32(left_r_tile[row]) * fx.Float32(
                        right_r_tile[col]
                    )
        fx.barrier()

    # compute done copy accumulator to output
    out_thread_tiles = fx.flat_divide(out_block_view, (4, 4))
    out_thread_view = fx.slice(
        out_thread_tiles, (None, None, thread_coord[0], thread_coord[1])
    )
    # Direct stores, retained for comparison:
    # for row in fx.range_constexpr(4):
    #     for col in fx.range_constexpr(4):
    #         coord = fx.make_coord(row, col)
    #         out_thread_view[coord] = accumulator[coord].to(fx.BFloat16)

    # Convert in registers before copying BF16 values to global memory.
    out_registers = fx.make_rmem_tensor(fx.make_layout((4, 4), (4, 1)), fx.BFloat16)
    for row in fx.range_constexpr(4):
        for col in fx.range_constexpr(4):
            coord = fx.make_coord(row, col)
            out_registers[coord] = accumulator[coord].to(fx.BFloat16)

    # The output window already selects this physical thread's 4x4 tile.
    # Use one logical copy thread; each row is one 64-bit BF16 store.
    reg2gmem_thread_layout = fx.make_layout((1, 1), (1, 1))
    reg2gmem_val_layout = fx.make_ordered_layout((4, 4), (1, 0))
    reg2gmem_tilemn, reg2gmem_tv_layout = fx.make_layout_tv(
        reg2gmem_thread_layout, reg2gmem_val_layout
    )
    reg2gmem_copy_plan = fx.make_tiled_copy(
        copy_64b, reg2gmem_tv_layout, reg2gmem_tilemn
    )
    reg2gmem_thread_copy = reg2gmem_copy_plan.get_slice(0)
    reg2gmem_source = reg2gmem_thread_copy.partition_S(out_registers)
    reg2gmem_dest = reg2gmem_thread_copy.partition_D(out_thread_view)
    fx.copy(copy_64b, reg2gmem_source, reg2gmem_dest)


@flyc.jit
def _launch_matmul_bf16(
    left: fx.Tensor,
    right: fx.Tensor,
    out: fx.Tensor,
    m: fx.Constexpr,
    n: fx.Constexpr,
    k: fx.Constexpr,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
):
    _matmul_bf16(left, right, out, m, n, k).launch(
        grid=(n // BLOCK_N, m // BLOCK_M, 1),
        block=(THREADS_PER_BLOCK, 1, 1),
        stream=stream,
    )


def matmul_bf16(input, other, *, out=None, stream=None):
    """Multiply complete BF16 matrix tiles with this lesson's kernel."""
    tensors = [("input", input), ("other", other)]
    if out is not None:
        tensors.append(("out", out))
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
        if tensor.device != input.device:
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
    if input.ndim != 2 or other.ndim != 2:
        raise ValueError("input and other must be two-dimensional matrices")
    if input.shape[1] != other.shape[0]:
        raise ValueError(
            f"K dimensions must match; got {input.shape[1]} and {other.shape[0]}"
        )
    if input.data_ptr() % 16 or other.data_ptr() % 16:
        raise ValueError("input and other must have 16-byte aligned data pointers")
    if torch.version.hip is None:
        raise RuntimeError("matmul_bf16 requires ROCm")
    shape = (input.shape[0], other.shape[1], input.shape[1])
    if (
        min(shape) <= 0
        or shape[0] % BLOCK_M
        or shape[1] % BLOCK_N
        or shape[2] % BLOCK_K
    ):
        raise ValueError("M,N,K must contain complete positive block tiles")
    if out is not None:
        if out.shape != (shape[0], shape[1]):
            raise ValueError(
                f"out must have shape {(shape[0], shape[1])}; got {tuple(out.shape)}"
            )
        start = out.data_ptr()
        stop = start + out.numel() * out.element_size()
        for name, tensor in tensors[:2]:
            if (
                start < tensor.data_ptr() + tensor.numel() * tensor.element_size()
                and tensor.data_ptr() < stop
            ):
                raise ValueError(f"out must not overlap {name}")
    if stream is not None and stream.device != input.device:
        raise ValueError("Stream and inputs must use the same device")
    supplied_out = out is not None
    with torch.cuda.device(input.device), torch.cuda.stream(stream):
        if out is None:
            out = torch.empty(
                (shape[0], shape[1]), dtype=input.dtype, device=input.device
            )
        _launch_matmul_bf16(
            input,
            other,
            out,
            *shape,
            stream=fx.Stream(torch.cuda.current_stream(input.device)),
        )
        if supplied_out:
            torch.autograd.graph.increment_version(out)
    return out


def solve():
    # Fixed comparison workload: 16 x 16 output tiles, each with 16 K tiles.
    shapes = [(1024, 1024, 1024)]
    generator = torch.Generator().manual_seed(13)
    checkpoint = None
    for m, n, k in shapes:
        for pattern in ("trace", "random"):
            if pattern == "trace":
                a_cpu = ((torch.arange(m * k).reshape(m, k) % 5) - 2).to(torch.bfloat16)
                b_cpu = ((torch.arange(k * n).reshape(k, n) % 7) - 3).to(torch.bfloat16)
            else:
                a_cpu = torch.randn(m, k, generator=generator).to(torch.bfloat16)
                b_cpu = torch.randn(k, n, generator=generator).to(torch.bfloat16)
            left, right = a_cpu.cuda(), b_cpu.cuda()
            storage = torch.full(
                (m * n + 16,), -99, dtype=torch.bfloat16, device="cuda"
            )
            out = storage[: m * n].view(m, n)
            out.fill_(float("nan"))
            matmul_bf16(left, right, out=out)
            torch.cuda.synchronize()
            # CPU FP32 arithmetic on the actual quantized BF16 inputs is independent
            # of the GPU kernel. Round the reference to the same output dtype.
            expected = (a_cpu.float() @ b_cpu.float()).to(torch.bfloat16)
            torch.testing.assert_close(
                out.cpu(),
                expected,
                rtol=0 if pattern == "trace" else 0.016,
                atol=0.001 if pattern == "trace" else 0.03125,
            )
            assert torch.all(storage[m * n :] == -99).item(), "Output sentinel changed"
            if (m, n, k) == (1024, 1024, 1024) and pattern == "trace":
                checkpoint = out[0, :4].cpu().tolist()
    return {"shapes_MNK": shapes, "patterns": 2, "first_four": checkpoint}


if __name__ == "__main__":
    benchmark = runpy.run_path(
        str(Path(__file__).resolve().parents[4] / "examples/matmul_benchmark.py")
    )
    benchmark["lesson_main"](
        matmul_bf16,
        solve,
        Path(__file__).parent.name,
        check_only=globals().get("_COURSE_CHECK_ONLY", False),
    )
