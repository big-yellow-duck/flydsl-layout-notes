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
    a: fx.Array[fx.BFloat16, BLOCK_M * BLOCK_K, 16]
    b: fx.Array[fx.BFloat16, BLOCK_K * BLOCK_N, 16]


@flyc.kernel
def _matmul_bf16(
    a: fx.Tensor,
    b: fx.Tensor,
    c: fx.Tensor,
    m: fx.Constexpr,
    n: fx.Constexpr,
    k: fx.Constexpr,
):
    # 1. Describe the global row-major matrices.
    a_global_view = fx.make_view(fx.get_iter(a), fx.make_layout((m, k), (k, 1)))
    b_global_view = fx.make_view(fx.get_iter(b), fx.make_layout((k, n), (n, 1)))
    c_global_view = fx.make_view(fx.get_iter(c), fx.make_layout((m, n), (n, 1)))
    block_row = fx.block_idx.y
    block_col = fx.block_idx.x

    # 2. Select block tiles, retaining the global row strides.
    a_tiled_view = fx.flat_divide(a_global_view, (BLOCK_M, BLOCK_K))
    b_tiled_view = fx.flat_divide(b_global_view, (BLOCK_K, BLOCK_N))
    c_tiled_view = fx.flat_divide(c_global_view, (BLOCK_M, BLOCK_N))
    c_block_view = fx.slice(c_tiled_view, (None, None, block_row, block_col))

    # 3. Allocate 16-byte-aligned LDS buffers and attach row-major views.
    lds = fx.SharedAllocator().allocate(SharedStorage).peek()
    a_lds_view = lds.a.view(fx.make_layout((BLOCK_M, BLOCK_K), (BLOCK_K, 1)))
    b_lds_view = lds.b.view(fx.make_layout((BLOCK_K, BLOCK_N), (BLOCK_N, 1)))

    # 4. Stage eight contiguous BF16 values per 128-bit copy.
    # Thread layout: (32,8); value layout: (1,8).
    copy_128b = fx.make_copy_atom(fx.UniversalCopy128b(), fx.BFloat16)
    staging_thread_layout = fx.make_ordered_layout((32, 8), (1, 0))
    staging_value_layout = fx.make_ordered_layout((1, 8), (1, 0))
    # The plan covers (32,64); partitioning (64,64) adds two row repetitions.
    staging_copy_tile, staging_copy_tv = fx.make_layout_tv(
        staging_thread_layout, staging_value_layout
    )
    staging_copy_plan = fx.make_tiled_copy(
        copy_128b, staging_copy_tv, staging_copy_tile
    )
    # Staging uses the full physical thread ID, 0..255.
    thread_staging_copy = staging_copy_plan.get_slice(fx.thread_idx.x)

    # Partition matching LDS destinations before allocating staging fragments.
    a_lds_destination = thread_staging_copy.partition_D(a_lds_view)
    b_lds_destination = thread_staging_copy.partition_D(b_lds_view)
    # Separate private fragments hold global loads before the LDS stores.
    a_staging_fragment = fx.make_fragment_like(a_lds_destination)
    b_staging_fragment = fx.make_fragment_like(b_lds_destination)

    # 5. Define 16 logical LDS-to-register slots for each operand.
    # A: each slot selects four strided rows at one K position.
    copy_16b = fx.make_copy_atom(fx.UniversalCopy16b(), fx.BFloat16)
    a_lds2reg_thread_layout = fx.make_ordered_layout((16, 1), (1, 0))
    a_lds2reg_value_layout = fx.make_ordered_layout((4, 1), (1, 0))
    a_lds2reg_copy_tile, a_lds2reg_copy_tv = fx.make_layout_tv(
        a_lds2reg_thread_layout, a_lds2reg_value_layout
    )
    a_lds2reg_copy_plan = fx.make_tiled_copy(
        copy_16b, a_lds2reg_copy_tv, a_lds2reg_copy_tile
    )

    # B: each slot selects four contiguous columns at one K position.
    copy_64b = fx.make_copy_atom(fx.UniversalCopy64b(), fx.BFloat16)
    b_lds2reg_thread_layout = fx.make_ordered_layout((1, 16), (1, 0))
    b_lds2reg_value_layout = fx.make_ordered_layout((1, 4), (1, 0))
    b_lds2reg_copy_tile, b_lds2reg_copy_tv = fx.make_layout_tv(
        b_lds2reg_thread_layout, b_lds2reg_value_layout
    )
    b_lds2reg_copy_plan = fx.make_tiled_copy(
        copy_64b, b_lds2reg_copy_tv, b_lds2reg_copy_tile
    )

    # Columns vary fastest: thread 17 has (row, column) = (1,1).
    compute_thread_layout = fx.make_ordered_layout((16, 16), (1, 0))
    thread_coord = fx.idx2crd(fx.thread_idx.x, compute_thread_layout)

    # A slots repeat across thread columns; B slots repeat across thread rows.
    # Every physical thread loads into its own private operand registers.
    a_lds2reg_thread_copy = a_lds2reg_copy_plan.get_slice(thread_coord[0])
    b_lds2reg_thread_copy = b_lds2reg_copy_plan.get_slice(thread_coord[1])

    # Expose a (64,1) A column and a (1,64) B row for each inner_k.
    a_lds_tiled_view = fx.flat_divide(a_lds_view, (64, 1))
    b_lds_tiled_view = fx.flat_divide(b_lds_view, (1, 64))

    a_lds_initial_slice = fx.slice(a_lds_tiled_view, (None, None, 0, 0))
    b_lds_initial_slice = fx.slice(b_lds_tiled_view, (None, None, 0, 0))

    a_r_initial_source = a_lds2reg_thread_copy.partition_S(a_lds_initial_slice)
    b_r_initial_source = b_lds2reg_thread_copy.partition_S(
        b_lds_initial_slice
    )

    # Allocate storage for four BF16 values per operand; this does not load them.
    a_r_tile = fx.make_fragment_like(a_r_initial_source, fx.BFloat16)
    b_r_tile = fx.make_fragment_like(b_r_initial_source, fx.BFloat16)

    # Keep 4x4 FP32 output sums across every K stage.
    c_accum = fx.make_rmem_tensor(fx.make_layout((4, 4), (4, 1)), fx.Float32)
    c_accum.fill(0)

    # Tracing-time helpers keep copy wrappers outside runtime loop state.
    def create_gmem2reg_sources(a_block_view, b_block_view):
        return (
            thread_staging_copy.partition_S(a_block_view),
            thread_staging_copy.partition_S(b_block_view),
        )

    def create_lds2reg_sources(a_source, b_source):
        return (
            a_lds2reg_thread_copy.partition_S(a_source),
            b_lds2reg_thread_copy.partition_S(b_source),
        )

    # 6. Stage, synchronize, consume, then synchronize before reusing LDS.
    for tile_k in range(k // BLOCK_K):
        a_block_view = fx.slice(a_tiled_view, (None, None, block_row, tile_k))
        b_block_view = fx.slice(b_tiled_view, (None, None, tile_k, block_col))
        a_global_source, b_global_source = create_gmem2reg_sources(
            a_block_view, b_block_view
        )

        fx.copy(copy_128b, a_global_source, a_staging_fragment)
        fx.copy(copy_128b, b_global_source, b_staging_fragment)
        fx.copy(copy_128b, a_staging_fragment, a_lds_destination)
        fx.copy(copy_128b, b_staging_fragment, b_lds_destination)
        fx.barrier()

        # Select one K position, then load operands for the outer product.
        for inner_k in range(BLOCK_K):
            a_lds_innerk_view = fx.slice(
                a_lds_tiled_view, (None, None, 0, inner_k)
            )
            b_lds_innerk_view = fx.slice(
                b_lds_tiled_view, (None, None, inner_k, 0)
            )
            a_r_source, b_r_source = create_lds2reg_sources(
                a_lds_innerk_view, b_lds_innerk_view
            )
            fx.copy(copy_16b, a_r_source, a_r_tile)
            fx.copy(copy_64b, b_r_source, b_r_tile)

            for row in range(4):
                for col in range(4):
                    coord = fx.make_coord(row, col)
                    c_accum[coord] += fx.Float32(a_r_tile[row]) * fx.Float32(
                        b_r_tile[col]
                    )
        fx.barrier()

    # 7. Select this thread's output tile, convert to BF16, and copy to global.
    c_thread_tiles = fx.flat_divide(c_block_view, (4, 4))
    c_thread_view = fx.slice(
        c_thread_tiles, (None, None, thread_coord[0], thread_coord[1])
    )
    # Convert in registers before copying BF16 values to global memory.
    c_registers = fx.make_rmem_tensor(fx.make_layout((4, 4), (4, 1)), fx.BFloat16)
    for row in fx.range_constexpr(4):
        for col in fx.range_constexpr(4):
            coord = fx.make_coord(row, col)
            c_registers[coord] = c_accum[coord].to(fx.BFloat16)

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
    reg2gmem_source = reg2gmem_thread_copy.partition_S(c_registers)
    reg2gmem_dest = reg2gmem_thread_copy.partition_D(c_thread_view)
    fx.copy(copy_64b, reg2gmem_source, reg2gmem_dest)


@flyc.jit
def _launch_matmul_bf16(
    a: fx.Tensor,
    b: fx.Tensor,
    c: fx.Tensor,
    m: fx.Constexpr,
    n: fx.Constexpr,
    k: fx.Constexpr,
    stream: fx.Stream = fx.Stream(None),  # noqa: B008 -- native stream default
):
    _matmul_bf16(a, b, c, m, n, k).launch(
        grid=(n // BLOCK_N, m // BLOCK_M, 1),
        block=(THREADS_PER_BLOCK, 1, 1),
        stream=stream,
    )


def matmul_bf16(input, other, *, out=None, stream=None):
    """Multiply complete BF16 matrix tiles with this lesson's kernel."""
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
    shape = (a.shape[0], b.shape[1], a.shape[1])
    if (
        min(shape) <= 0
        or shape[0] % BLOCK_M
        or shape[1] % BLOCK_N
        or shape[2] % BLOCK_K
    ):
        raise ValueError("M,N,K must contain complete positive block tiles")
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
        if c is None:
            c = torch.empty(
                (shape[0], shape[1]), dtype=a.dtype, device=a.device
            )
        _launch_matmul_bf16(
            a,
            b,
            c,
            *shape,
            stream=fx.Stream(torch.cuda.current_stream(a.device)),
        )
        if supplied_out:
            torch.autograd.graph.increment_version(c)
    return c


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
            a, b = a_cpu.cuda(), b_cpu.cuda()
            storage = torch.full(
                (m * n + 16,), -99, dtype=torch.bfloat16, device="cuda"
            )
            c = storage[: m * n].view(m, n)
            c.fill_(float("nan"))
            matmul_bf16(a, b, out=c)
            torch.cuda.synchronize()
            # CPU FP32 arithmetic on the actual quantized BF16 inputs is independent
            # of the GPU kernel. Round the reference to the same output dtype.
            expected = (a_cpu.float() @ b_cpu.float()).to(torch.bfloat16)
            torch.testing.assert_close(
                c.cpu(),
                expected,
                rtol=0 if pattern == "trace" else 0.016,
                atol=0.001 if pattern == "trace" else 0.03125,
            )
            assert torch.all(storage[m * n :] == -99).item(), "Output sentinel changed"
            if (m, n, k) == (1024, 1024, 1024) and pattern == "trace":
                checkpoint = c[0, :4].cpu().tolist()
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
