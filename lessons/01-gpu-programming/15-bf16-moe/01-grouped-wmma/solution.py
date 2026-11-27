"""Run both BF16 expert projections with a GPU worklist and wave32 WMMA."""

import runpy
from dataclasses import dataclass
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch

ROOT = Path(__file__).resolve().parents[1]
COMMON = runpy.run_path(str(ROOT / "common.py"))
ROUTING = runpy.run_path(str(ROOT / "routing.py"))
NAIVE = runpy.run_path(str(ROOT / "00-naive/solution.py"))
_silu = NAIVE["_silu"]
_output_coordinates = COMMON["output_coordinates"]
THREADS = 128
MMA = 16


@dataclass(frozen=True)
class Config:
    block_m: int = 16
    block_n: int = 32
    stage_k: int = 32
    prefetch: bool = False
    group_m: int = 1


def _validate_config(config):
    if not isinstance(config, Config):
        raise TypeError("config must be a MoE Config")
    if config.block_m not in (16, 32) or config.block_n not in (16, 32, 64):
        raise ValueError("block_m must be 16 or 32, block_n must be 16, 32 or 64")
    if config.stage_k not in (16, 32, 64):
        raise ValueError("stage_k must be 16, 32 or 64")
    if not isinstance(config.prefetch, bool) or config.group_m not in (1, 2, 4):
        raise ValueError("prefetch must be a bool and group_m must be 1, 2 or 4")


def _copy_atom(width):
    if width == 8:
        op = fx.UniversalCopy128b()
    elif width == 4:
        op = fx.UniversalCopy64b()
    elif width == 2:
        op = fx.UniversalCopy32b()
    else:
        op = fx.UniversalCopy16b()
    return fx.make_copy_atom(op, fx.BFloat16)


def _copy_width(extent, address):
    for width in (8, 4, 2):
        if extent % width == 0 and address % (2 * width) == 0:
            return width
    return 1


def _coordinates(shape):
    """Attach an identity layout to coordinate tuples."""
    return fx.make_view(fx.make_int_tuple((0, 0)), fx.make_identity_layout(shape))


def _staging_plan(atom, thread, rows, columns, width, threads):
    """Give each lane one contiguous width-value chunk before repeating."""
    copy_threads = min(threads, rows * columns // width)
    thread_columns = min(columns // width, copy_threads)
    thread_layout = fx.make_ordered_layout(
        (copy_threads // thread_columns, thread_columns), (1, 0)
    )
    value_layout = fx.make_ordered_layout((1, width), (1, 0))
    copy_tile, copy_tv = fx.make_layout_tv(thread_layout, value_layout)
    copy = fx.make_tiled_copy(atom, copy_tv, copy_tile)
    return copy.get_slice(thread % copy_threads), thread < copy_threads


@flyc.kernel
def _moe_bf16(
    a: fx.Tensor,
    b: fx.Tensor,
    ids: fx.Tensor,
    weights: fx.Tensor,
    sorted_ids: fx.Tensor,
    tiles: fx.Tensor,
    tile_count: fx.Tensor,
    c: fx.Tensor,
    A_ROWS: fx.Constexpr,
    K: fx.Constexpr,
    N: fx.Constexpr,
    E: fx.Constexpr,
    TOP_K: fx.Constexpr,
    BM: fx.Constexpr,
    BN: fx.Constexpr,
    BK: fx.Constexpr,
    MODE: fx.Constexpr,
    DIRECT: fx.Constexpr,
    A_WIDTH: fx.Constexpr,
    B_WIDTH: fx.Constexpr,
    PREFETCH: fx.Constexpr,
    GROUP_M: fx.Constexpr,
):
    PAIR = MODE in ("pair", "silu")
    A_STRIDE = BK + 8
    B_STRIDE = BN + 8
    THREADS_PER_BLOCK = BN // MMA * 32

    @fx.struct
    class SharedStorage:
        a: fx.Array[fx.BFloat16, BM * A_STRIDE, 16]
        b: fx.Array[fx.BFloat16, BK * B_STRIDE, 16]

    allocator = fx.SharedAllocator()
    lds = allocator.allocate(SharedStorage).peek()
    a_lds = lds.a.view(fx.make_layout((BM, BK), (A_STRIDE, 1)))
    b_lds = lds.b.view(fx.make_layout((BK, BN), (B_STRIDE, 1)))
    if fx.const_expr(PAIR):
        b_up_lds = (
            allocator.allocate(fx.Array[fx.BFloat16, BK * B_STRIDE, 16])
            .peek()
            .view(fx.make_layout((BK, BN), (B_STRIDE, 1)))
        )

    tile = fx.block_idx.y
    column_tile = fx.block_idx.x
    thread = fx.thread_idx.x

    if fx.const_expr(DIRECT):
        expert = ids[tile]
        start = tile
        rows = fx.Int32(1)
        active = (expert >= 0) & (expert < E)
    else:
        if fx.const_expr(GROUP_M > 1):
            flat = fx.block_idx.x
            N_TILES = (N + BN - 1) // BN
            tile = flat // N_TILES
        active = tile < tile_count[0]
        expert = fx.Int32(0)
        start = fx.Int32(0)
        rows = fx.Int32(0)
        if active:
            if fx.const_expr(GROUP_M > 1):
                # A contiguous run of tile IDs belongs to this expert. Swizzle
                # only within that run, using its actual final group height.
                first = tiles[tile, 3]
                count = tiles[tile, 4]
                local = flat - first * N_TILES
                group_base = local // (GROUP_M * N_TILES) * GROUP_M
                height = fx.min(GROUP_M, count - group_base)
                in_group = local - group_base * N_TILES
                group_layout = fx.make_ordered_layout((height, N_TILES), (0, 1))
                group_coordinate = fx.idx2crd(in_group, group_layout)
                tile = first + group_base + fx.get_scalar(group_coordinate[0])
                column_tile = fx.get_scalar(group_coordinate[1])
            expert = tiles[tile, 0]
            start = tiles[tile, 1]
            rows = tiles[tile, 2]

    if active:
        col_base = column_tile * BN
        a_global_view = fx.make_view(
            fx.get_iter(a), fx.make_layout((A_ROWS, K), (K, 1))
        )
        PACKED_N = 2 * N if PAIR else N
        b_experts = fx.make_view(
            fx.get_iter(b),
            fx.make_layout((E, K, PACKED_N), (K * PACKED_N, PACKED_N, 1)),
        )
        expert_weights = fx.slice(b_experts, (expert, None, None))
        b_projections = fx.flat_divide(expert_weights, (K, N))
        b_global_view = fx.slice(b_projections, (None, None, 0, 0))
        b_global_tiles = fx.flat_divide(b_global_view, (BK, BN))
        if fx.const_expr(PAIR):
            up_global_view = fx.slice(b_projections, (None, None, 0, 1))
            up_global_tiles = fx.flat_divide(up_global_view, (BK, BN))

        mma_atom = fx.make_mma_atom(
            fx.rocdl.WMMA(MMA, MMA, MMA, fx.BFloat16, fx.Float32)
        )
        mma = fx.make_tiled_mma(mma_atom, fx.make_layout((1, BN // MMA, 1), (1, 1, 0)))
        thread_mma = mma.thr_slice(thread)
        c_coordinates = _coordinates((BM, BN))
        # The tile model supplies shape to WMMA. Global stores follow the route mapping.
        c_tile_model = fx.make_view(fx.get_iter(c), fx.make_layout((BM, BN), (BN, 1)))
        c_accum = thread_mma.make_fragment_C(c_tile_model)
        c_accum.fill(0)
        if fx.const_expr(PAIR):
            up_accum = fx.make_fragment_like(c_accum)
            up_accum.fill(0)

        a_k_tiles = fx.flat_divide(a_lds, (BM, MMA))
        b_k_tiles = fx.flat_divide(
            fx.make_view(fx.get_iter(b_lds), fx.make_layout((BN, BK), (1, B_STRIDE))),
            (BN, MMA),
        )
        if fx.const_expr(PAIR):
            up_k_tiles = fx.flat_divide(
                fx.make_view(
                    fx.get_iter(b_up_lds), fx.make_layout((BN, BK), (1, B_STRIDE))
                ),
                (BN, MMA),
            )
        a_r = thread_mma.make_fragment_A(fx.slice(a_k_tiles, (None, None, 0, 0)))
        b_r = thread_mma.make_fragment_B(fx.slice(b_k_tiles, (None, None, 0, 0)))
        scalar_copy = fx.make_copy_atom(fx.UniversalCopy16b(), fx.BFloat16)
        a_copy = fx.make_tiled_copy_A(scalar_copy, mma).get_slice(thread)
        b_copy = fx.make_tiled_copy_B(scalar_copy, mma).get_slice(thread)
        a_compute = a_copy.retile(a_r)
        b_compute = b_copy.retile(b_r)

        # Apply the same native copy plan to data and identity coordinates.
        a_atom = _copy_atom(A_WIDTH)
        b_atom = _copy_atom(B_WIDTH)
        a_staging_copy, a_staging_lane = _staging_plan(
            a_atom, thread, BM, BK, A_WIDTH, THREADS_PER_BLOCK
        )
        b_staging_copy, b_staging_lane = _staging_plan(
            b_atom, thread, BK, BN, B_WIDTH, THREADS_PER_BLOCK
        )
        a_lds_destination = a_staging_copy.partition_D(a_lds)
        b_lds_destination = b_staging_copy.partition_D(b_lds)
        a_coordinates = a_staging_copy.partition_D(_coordinates((BM, BK)))
        b_coordinates = b_staging_copy.partition_D(_coordinates((BK, BN)))
        a_staging_fragment = fx.make_fragment_like(a_lds_destination)
        b_staging_fragment = fx.make_fragment_like(b_lds_destination)
        if fx.const_expr(PAIR):
            up_lds_destination = b_staging_copy.partition_D(b_up_lds)
            up_staging_fragment = fx.make_fragment_like(up_lds_destination)
        else:
            up_staging_fragment = b_staging_fragment

        A_ROW_TILES = fx.size(a_coordinates.shape[1]).to_py_value()
        A_K_TILES = fx.size(a_coordinates.shape[2]).to_py_value()
        B_K_TILES = fx.size(b_coordinates.shape[1]).to_py_value()
        B_N_TILES = fx.size(b_coordinates.shape[2]).to_py_value()
        b_predicate = fx.make_rmem_tensor(
            fx.make_layout(((1, 1), B_K_TILES, B_N_TILES), ((0, 1), 1, B_K_TILES)),
            fx.Boolean,
        )
        # Keep wrappers in tuples when they are used inside K-loop callbacks.
        staging_copies = (a_staging_copy, b_staging_copy)

        def load_stage(stage, a_fragment, b_fragment, up_fragment, b_mask):
            k_base = stage * BK
            if a_staging_lane:
                a_fragment.fill(0)
                for k_tile in fx.range_constexpr(A_K_TILES):
                    for row_tile in fx.range_constexpr(A_ROW_TILES):
                        coordinate = a_coordinates[0, row_tile, k_tile]
                        row = fx.get_scalar(coordinate[0])
                        inner = k_base + fx.get_scalar(coordinate[1])
                        if (row < rows) & (inner + A_WIDTH <= K):
                            source_row = start + row
                            if fx.const_expr(PAIR):
                                if fx.const_expr(DIRECT):
                                    source_row = tile // TOP_K
                                else:
                                    source_row = sorted_ids[source_row] // TOP_K
                            a_row = fx.slice(a_global_view, (source_row, None))
                            a_row_chunks = fx.flat_divide(a_row, (A_WIDTH,))
                            source = fx.slice(a_row_chunks, (None, inner // A_WIDTH))
                            target = fx.slice(a_fragment, (None, row_tile, k_tile))
                            fx.copy(a_atom, source, target)

            if b_staging_lane:
                b_block = fx.slice(b_global_tiles, (None, None, stage, column_tile))
                b_source = staging_copies[1].partition_S(b_block)
                if fx.const_expr(PAIR):
                    up_block = fx.slice(
                        up_global_tiles, (None, None, stage, column_tile)
                    )
                    up_source = staging_copies[1].partition_S(up_block)
                if fx.const_expr(K % BK == 0 and N % BN == 0):
                    fx.copy(b_atom, b_source, b_fragment)
                    if fx.const_expr(PAIR):
                        fx.copy(b_atom, up_source, up_fragment)
                else:
                    b_fragment.fill(0)
                    if fx.const_expr(PAIR):
                        up_fragment.fill(0)
                    for n_tile in fx.range_constexpr(B_N_TILES):
                        for k_tile in fx.range_constexpr(B_K_TILES):
                            coordinate = b_coordinates[0, k_tile, n_tile]
                            inner = k_base + fx.get_scalar(coordinate[0])
                            column = col_base + fx.get_scalar(coordinate[1])
                            b_mask[0, k_tile, n_tile] = (inner < K) & (
                                column + B_WIDTH <= N
                            )
                    fx.copy(b_atom, b_source, b_fragment, pred=b_mask)
                    if fx.const_expr(PAIR):
                        fx.copy(b_atom, up_source, up_fragment, pred=b_mask)

        def publish_stage():
            if a_staging_lane:
                fx.copy(a_atom, a_staging_fragment, a_lds_destination)
            if b_staging_lane:
                fx.copy(b_atom, b_staging_fragment, b_lds_destination)
                if fx.const_expr(PAIR):
                    fx.copy(b_atom, up_staging_fragment, up_lds_destination)
            fx.barrier()

        def compute_stage():
            for stage in fx.range_constexpr(BK // MMA):
                a_source = fx.slice(a_k_tiles, (None, None, 0, stage))
                b_source = fx.slice(b_k_tiles, (None, None, 0, stage))
                fx.copy(scalar_copy, a_copy.partition_S(a_source), a_compute)
                fx.copy(scalar_copy, b_copy.partition_S(b_source), b_compute)
                fx.gemm(mma_atom, c_accum, a_r, b_r, c_accum)
                if fx.const_expr(PAIR):
                    up_source = fx.slice(up_k_tiles, (None, None, 0, stage))
                    fx.copy(scalar_copy, b_copy.partition_S(up_source), b_compute)
                    fx.gemm(mma_atom, up_accum, a_r, b_r, up_accum)
            fx.barrier()

        K_STAGES = (K + BK - 1) // BK
        if fx.const_expr(PREFETCH):
            load_stage(
                0,
                a_staging_fragment,
                b_staging_fragment,
                up_staging_fragment,
                b_predicate,
            )
            publish_stage()
            for stage in range(1, K_STAGES):
                load_stage(
                    stage,
                    a_staging_fragment,
                    b_staging_fragment,
                    up_staging_fragment,
                    b_predicate,
                )
                compute_stage()
                publish_stage()
            compute_stage()
        else:
            for stage in range(K_STAGES):
                load_stage(
                    stage,
                    a_staging_fragment,
                    b_staging_fragment,
                    up_staging_fragment,
                    b_predicate,
                )
                publish_stage()
                compute_stage()

        c_copy_atom = fx.make_copy_atom(fx.UniversalCopy32b(), fx.Float32)
        c_copy = fx.make_tiled_copy_C(c_copy_atom, mma).get_slice(thread)
        local_coordinates = c_copy.partition_D(c_coordinates)
        gate_or_down = c_copy.retile(c_accum)
        if fx.const_expr(PAIR):
            up_values = c_copy.retile(up_accum)
        VALUES = fx.size(local_coordinates.layout).to_py_value()
        for slot in fx.range_constexpr(VALUES):
            coordinate = local_coordinates[slot]
            row = fx.get_scalar(coordinate[0])
            channel = col_base + fx.get_scalar(coordinate[1])
            if (row < rows) & (channel < N):
                value = gate_or_down[slot]
                if fx.const_expr(MODE == "pair"):
                    c[start + row, channel] = value
                    c[start + row, N + channel] = up_values[slot]
                elif fx.const_expr(MODE == "silu"):
                    c[start + row, channel] = (_silu(value) * up_values[slot]).to(
                        fx.BFloat16
                    )
                else:
                    if fx.const_expr(DIRECT):
                        route = tile
                    else:
                        route = sorted_ids[start + row]
                    if fx.const_expr(MODE == "weighted_down" or MODE == "atomic_down"):
                        value = value * weights[route]
                    if fx.const_expr(MODE == "atomic_down"):
                        token = route // TOP_K
                        token_output = fx.slice(c, (token, None))
                        fx.atomic_add(
                            fx.get_iter(token_output) + channel,
                            value,
                            syncscope=fx.rocdl.SyncScope.Agent,
                        )
                    else:
                        c[route, channel] = value


@flyc.jit
def _launch_moe_bf16(
    a: fx.Tensor,
    b: fx.Tensor,
    ids: fx.Tensor,
    weights: fx.Tensor,
    sorted_ids: fx.Tensor,
    tiles: fx.Tensor,
    tile_count: fx.Tensor,
    c: fx.Tensor,
    A_ROWS: fx.Constexpr,
    K: fx.Constexpr,
    N: fx.Constexpr,
    E: fx.Constexpr,
    TOP_K: fx.Constexpr,
    BM: fx.Constexpr,
    BN: fx.Constexpr,
    BK: fx.Constexpr,
    CAPACITY: fx.Constexpr,
    MODE: fx.Constexpr,
    DIRECT: fx.Constexpr,
    A_WIDTH: fx.Constexpr,
    B_WIDTH: fx.Constexpr,
    PREFETCH: fx.Constexpr,
    GROUP_M: fx.Constexpr,
    stream: fx.Stream,
):
    n_tiles = (N + BN - 1) // BN
    grid = (
        (n_tiles * CAPACITY, 1, 1)
        if GROUP_M > 1 and not DIRECT
        else (n_tiles, CAPACITY, 1)
    )
    _moe_bf16(
        a,
        b,
        ids,
        weights,
        sorted_ids,
        tiles,
        tile_count,
        c,
        A_ROWS,
        K,
        N,
        E,
        TOP_K,
        BM,
        BN,
        BK,
        MODE,
        DIRECT,
        A_WIDTH,
        B_WIDTH,
        PREFETCH,
        GROUP_M,
    ).launch(grid=grid, block=(BN // MMA * 32, 1, 1), stream=stream)


@flyc.kernel
def _activate_impl(
    pair: fx.Tensor,
    activated: fx.Tensor,
    tile_count: fx.Tensor,
    R: fx.Constexpr,
    I: fx.Constexpr,
):
    row, channel = _output_coordinates(R, I, THREADS)
    if (row < tile_count[1]) & (channel < I):
        gate = pair[row, channel]
        up = pair[row, I + channel]
        activated[row, channel] = (_silu(gate) * up).to(fx.BFloat16)


@flyc.jit
def _launch_activate_impl(
    pair: fx.Tensor,
    activated: fx.Tensor,
    tile_count: fx.Tensor,
    R: fx.Constexpr,
    I: fx.Constexpr,
    stream: fx.Stream,
):
    _activate_impl(pair, activated, tile_count, R, I).launch(
        grid=((I + THREADS - 1) // THREADS, R, 1), block=(THREADS, 1, 1), stream=stream
    )


def _workspace_spec(shape, block_m, *, direct=False, fused=False, atomic=False):
    tokens, hidden, experts, intermediate, top_k = shape
    routes = tokens * top_k
    spec = [
        ("activated", (routes, intermediate), torch.bfloat16),
        ("contributions", (tokens if atomic else routes, hidden), torch.float32),
    ]
    if not fused:
        spec.append(("pair", (routes, 2 * intermediate), torch.float32))
    if not direct:
        spec.extend(ROUTING["workspace_spec"](routes, experts, block_m))
    return spec


def _pipeline(
    x,
    w_gate_up,
    w_down,
    topk_ids,
    topk_weights,
    out,
    shape,
    workspace,
    buffers,
    gate_config,
    down_config,
    *,
    direct,
    fused,
    atomic,
    finish=None,
):
    tokens, hidden, experts, intermediate, top_k = shape
    routes = tokens * top_k
    spec = _workspace_spec(
        shape, gate_config.block_m, direct=direct, fused=fused, atomic=atomic
    )
    storage = dict(
        zip(
            (name for name, _, _ in spec),
            COMMON["scratch"](spec, x.device, workspace, buffers),
        )
    )
    activated = storage["activated"]
    contributions = storage["contributions"]
    ids, weights = topk_ids.view(-1), topk_weights.view(-1)
    with torch.cuda.device(x.device):
        stream = fx.Stream(torch.cuda.current_stream(x.device))
        if direct:
            # These parameters are eliminated in the direct specialization.
            sorted_ids, tiles, tile_count = ids, topk_ids, ids
            capacity = routes
        else:
            sorted_ids, tiles, tile_count = (
                storage[name] for name in ("sorted_ids", "tiles", "tile_count")
            )
            capacity = tiles.shape[0]
            ROUTING["build_worklist"](
                ids,
                storage["counts"],
                storage["offsets"],
                storage["cursors"],
                sorted_ids,
                tiles,
                tile_count,
                routes,
                experts,
                gate_config.block_m,
                stream,
            )
        if atomic:
            contributions.zero_()

        def project(a, b, c, k, n, config, mode):
            _launch_moe_bf16(
                a,
                b,
                ids,
                weights,
                sorted_ids,
                tiles,
                tile_count,
                c,
                a.shape[0],
                k,
                n,
                experts,
                top_k,
                config.block_m,
                config.block_n,
                config.stage_k,
                capacity,
                mode,
                direct,
                _copy_width(k, a.data_ptr()),
                _copy_width(n, b.data_ptr()),
                config.prefetch,
                config.group_m,
                stream,
            )

        if fused:
            project(x, w_gate_up, activated, hidden, intermediate, gate_config, "silu")
        else:
            pair = storage["pair"]
            project(x, w_gate_up, pair, hidden, intermediate, gate_config, "pair")
            _launch_activate_impl(
                pair, activated, tile_count, routes, intermediate, stream
            )

        down_mode = "atomic_down" if atomic else "weighted_down" if fused else "down"
        project(
            activated,
            w_down,
            contributions,
            intermediate,
            hidden,
            down_config,
            down_mode,
        )
        if finish is not None:
            finish(contributions, stream)
        else:
            NAIVE["_launch_combine_impl"](
                contributions,
                ids,
                weights,
                out,
                tokens,
                hidden,
                experts,
                top_k,
                fused,
                stream,
            )


def moe_bf16(
    x,
    w_gate_up,
    w_down,
    topk_ids,
    topk_weights,
    *,
    out=None,
    workspace=None,
    config=None,
    down_config=None,
):
    """Group routes and run two BF16 WMMA projections with separate epilogues."""
    if not isinstance(x, torch.Tensor):
        raise TypeError("x must be a tensor")
    config = Config() if config is None else config
    down_config = config if down_config is None else down_config
    _validate_config(config)
    _validate_config(down_config)
    if config.block_m != down_config.block_m:
        raise ValueError("Both projections must share worklist block_m")
    supplied_out = out is not None
    out, shape, workspace, buffers = COMMON["prepare"](
        x, w_gate_up, w_down, topk_ids, topk_weights, out, workspace
    )
    if shape[0]:
        _pipeline(
            x,
            w_gate_up,
            w_down,
            topk_ids,
            topk_weights,
            out,
            shape,
            workspace,
            buffers,
            config,
            down_config,
            direct=False,
            fused=False,
            atomic=False,
        )
        if supplied_out:
            torch.autograd.graph.increment_version(out)
    return out


def solve():
    checkpoint = COMMON["check"](moe_bf16)
    config = Config(16, 32, 32, True, 4)
    inputs = COMMON["make_inputs"](111, 48, 5, 40, 3, routing="skewed")
    gpu = tuple(t.cuda() for t in inputs)
    spec = _workspace_spec((111, 48, 5, 40, 3), config.block_m)
    workspace = {
        name: torch.empty(dims, dtype=dtype, device="cuda")
        for name, dims, dtype in spec
    }
    result = moe_bf16(*gpu, config=config, workspace=workspace)
    torch.testing.assert_close(
        result.cpu(), COMMON["reference"](*inputs), atol=0.008, rtol=0.018
    )
    counts = torch.bincount(inputs[3].view(-1).long(), minlength=5)
    torch.testing.assert_close(workspace["counts"].cpu(), counts.int())
    tile_count, valid_routes = workspace["tile_count"].tolist()
    tiles = workspace["tiles"][:tile_count].tolist()
    sorted_ids = workspace["sorted_ids"][:valid_routes].cpu().long()
    torch.testing.assert_close(
        sorted_ids.sort().values, torch.arange(inputs[3].numel())
    )
    for expert, start, rows, _, _ in tiles:
        assert 0 < rows <= config.block_m
        assert (inputs[3].flatten()[sorted_ids[start : start + rows]] == expert).all()
    return checkpoint


if __name__ == "__main__":
    COMMON["report"](solve)
