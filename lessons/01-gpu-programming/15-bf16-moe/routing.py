"""Build an expert-grouped worklist entirely on the current GPU stream."""

import flydsl.compiler as flyc
import flydsl.expr as fx
import torch

THREADS = 128


@flyc.kernel
def _clear(counts: fx.Tensor, E: fx.Constexpr):
    expert = fx.block_idx.x * THREADS + fx.thread_idx.x
    if expert < E:
        counts[expert] = fx.Int32(0)


@flyc.kernel
def _count(ids: fx.Tensor, counts: fx.Tensor, R: fx.Constexpr, E: fx.Constexpr):
    route = fx.block_idx.x * THREADS + fx.thread_idx.x
    if route < R:
        expert = ids[route]
        if (expert >= 0) & (expert < E):
            fx.atomic_add(
                fx.get_iter(counts) + expert, 1, syncscope=fx.rocdl.SyncScope.Agent
            )


@flyc.kernel
def _index(
    counts: fx.Tensor,
    offsets: fx.Tensor,
    cursors: fx.Tensor,
    tiles: fx.Tensor,
    tile_count: fx.Tensor,
    E: fx.Constexpr,
    BM: fx.Constexpr,
):
    expert = fx.block_idx.x * THREADS + fx.thread_idx.x
    if expert < E:
        start = fx.Int32(0)
        first_tile = fx.Int32(0)
        for previous in range(expert):
            rows = counts[previous]
            start = start + rows
            first_tile = first_tile + (rows + BM - 1) // BM

        size = counts[expert]
        num_tiles = (size + BM - 1) // BM
        offsets[expert] = start
        cursors[expert] = fx.Int32(0)
        for tile in range(num_tiles):
            local_start = tile * BM
            tiles[first_tile + tile, 0] = expert
            tiles[first_tile + tile, 1] = start + local_start
            tiles[first_tile + tile, 2] = fx.min(size - local_start, BM)
            tiles[first_tile + tile, 3] = first_tile
            tiles[first_tile + tile, 4] = num_tiles
        if expert == E - 1:
            tile_count[0] = first_tile + num_tiles
            tile_count[1] = start + size


@flyc.kernel
def _scatter(
    ids: fx.Tensor,
    offsets: fx.Tensor,
    cursors: fx.Tensor,
    sorted_ids: fx.Tensor,
    R: fx.Constexpr,
    E: fx.Constexpr,
):
    route = fx.block_idx.x * THREADS + fx.thread_idx.x
    if route < R:
        expert = ids[route]
        if (expert >= 0) & (expert < E):
            ordinal = fx.atomic_add(
                fx.get_iter(cursors) + expert, 1, syncscope=fx.rocdl.SyncScope.Agent
            )
            sorted_ids[offsets[expert] + ordinal] = route


@flyc.jit
def build_worklist(
    ids: fx.Tensor,
    counts: fx.Tensor,
    offsets: fx.Tensor,
    cursors: fx.Tensor,
    sorted_ids: fx.Tensor,
    tiles: fx.Tensor,
    tile_count: fx.Tensor,
    R: fx.Constexpr,
    E: fx.Constexpr,
    BM: fx.Constexpr,
    stream: fx.Stream,
):
    expert_grid = ((E + THREADS - 1) // THREADS, 1, 1)
    route_grid = ((R + THREADS - 1) // THREADS, 1, 1)
    block = (THREADS, 1, 1)
    _clear(counts, E).launch(grid=expert_grid, block=block, stream=stream)
    _count(ids, counts, R, E).launch(grid=route_grid, block=block, stream=stream)
    _index(counts, offsets, cursors, tiles, tile_count, E, BM).launch(
        grid=expert_grid, block=block, stream=stream
    )
    _scatter(ids, offsets, cursors, sorted_ids, R, E).launch(
        grid=route_grid, block=block, stream=stream
    )


def tile_capacity(routes, experts, block_m):
    # sum(ceil(M_e/BM)) <= ceil(sum(M_e)/BM) + active_experts - 1.
    return max(
        0, min(routes, (routes + block_m - 1) // block_m + min(experts, routes) - 1)
    )


def workspace_spec(routes, experts, block_m):
    capacity = tile_capacity(routes, experts, block_m)
    return [
        ("counts", (experts,), torch.int32),
        ("offsets", (experts,), torch.int32),
        ("cursors", (experts,), torch.int32),
        ("sorted_ids", (routes,), torch.int32),
        ("tiles", (capacity, 5), torch.int32),
        ("tile_count", (2,), torch.int32),
    ]
