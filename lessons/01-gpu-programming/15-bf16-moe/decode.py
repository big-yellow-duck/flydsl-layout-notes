"""Direct per-assignment BF16 GEMV for sparse decode."""

import runpy
from pathlib import Path

import flydsl.compiler as flyc
import flydsl.expr as fx

_silu = runpy.run_path(str(Path(__file__).with_name("00-naive") / "solution.py"))[
    "_silu"
]
THREADS = 128
WAVE = 32


@flyc.kernel
def _project(
    a: fx.Tensor,
    b: fx.Tensor,
    ids: fx.Tensor,
    weights: fx.Tensor,
    c: fx.Tensor,
    R: fx.Constexpr,
    K: fx.Constexpr,
    N: fx.Constexpr,
    E: fx.Constexpr,
    TOP_K: fx.Constexpr,
    GATE_UP: fx.Constexpr,
    ATOMIC: fx.Constexpr,
    K_LANES: fx.Constexpr,
):
    WAVES = THREADS // WAVE
    COLUMNS = WAVE // K_LANES
    thread_layout = fx.make_ordered_layout((WAVES, K_LANES, COLUMNS), (2, 1, 0))
    thread_coordinate = fx.idx2crd(fx.thread_idx.x, thread_layout)
    wave = fx.get_scalar(thread_coordinate[0])
    k_lane = fx.get_scalar(thread_coordinate[1])
    wave_column = fx.get_scalar(thread_coordinate[2])
    column_layout = fx.make_ordered_layout((WAVES, COLUMNS), (1, 0))
    local_column = fx.get_scalar(fx.crd2idx((wave, wave_column), column_layout))
    route = fx.block_idx.y
    channel = fx.block_idx.x * WAVES * COLUMNS + local_column
    expert = ids[route]

    if (expert >= 0) & (expert < E):
        if fx.const_expr(GATE_UP):
            row = route // TOP_K
        else:
            row = route
        A_ROWS = R // TOP_K if GATE_UP else R
        B_COLUMNS = 2 * N if GATE_UP else N
        a_global_view = fx.make_view(
            fx.get_iter(a), fx.make_layout((A_ROWS, K), (K, 1))
        )
        a_row = fx.slice(a_global_view, (row, None))
        a_k_tiles = fx.flat_divide(a_row, (K_LANES,))
        b_global_view = fx.make_view(
            fx.get_iter(b),
            fx.make_layout((E, K, B_COLUMNS), (K * B_COLUMNS, B_COLUMNS, 1)),
        )
        expert_weights = fx.slice(b_global_view, (expert, None, None))
        b_k_tiles = fx.flat_divide(expert_weights, (K_LANES, B_COLUMNS))
        total = fx.Float32(0)
        up = fx.Float32(0)
        if channel < N:
            for step in range((K + K_LANES - 1) // K_LANES):
                k = step * K_LANES + k_lane
                if k < K:
                    value = a_k_tiles[k_lane, step].to(fx.Float32)
                    total = total + value * b_k_tiles[k_lane, channel, step, 0].to(
                        fx.Float32
                    )
                    if fx.const_expr(GATE_UP):
                        up = up + value * b_k_tiles[k_lane, N + channel, step, 0].to(
                            fx.Float32
                        )

        # All lanes in the wave participate, including lanes at the N tail.
        for step in fx.range_constexpr(3):
            if fx.const_expr((1 << step) < K_LANES):
                distance = COLUMNS << step
                total = total + fx.shuffle_xor(total, distance, WAVE)
                if fx.const_expr(GATE_UP):
                    up = up + fx.shuffle_xor(up, distance, WAVE)
        if (channel < N) & (k_lane == 0):
            if fx.const_expr(GATE_UP):
                c[route, channel] = (_silu(total) * up).to(fx.BFloat16)
            else:
                value = total * weights[route]
                if fx.const_expr(ATOMIC):
                    token_output = fx.slice(c, (route // TOP_K, None))
                    fx.atomic_add(
                        fx.get_iter(token_output) + channel,
                        value,
                        syncscope=fx.rocdl.SyncScope.Agent,
                    )
                else:
                    c[route, channel] = value


@flyc.jit
def project(
    a: fx.Tensor,
    b: fx.Tensor,
    ids: fx.Tensor,
    weights: fx.Tensor,
    c: fx.Tensor,
    R: fx.Constexpr,
    K: fx.Constexpr,
    N: fx.Constexpr,
    E: fx.Constexpr,
    TOP_K: fx.Constexpr,
    GATE_UP: fx.Constexpr,
    ATOMIC: fx.Constexpr,
    K_LANES: fx.Constexpr,
    stream: fx.Stream,
):
    columns = THREADS // K_LANES
    _project(a, b, ids, weights, c, R, K, N, E, TOP_K, GATE_UP, ATOMIC, K_LANES).launch(
        grid=((N + columns - 1) // columns, R, 1),
        block=(THREADS, 1, 1),
        stream=stream,
    )
