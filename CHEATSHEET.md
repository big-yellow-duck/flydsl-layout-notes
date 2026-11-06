# Layout algebra: quick revision

| Concept | Remember | Tiny example |
| --- | --- | --- |
| Shape | Valid coordinate extents | `(3,4)` has 12 positions |
| Stride | Offset increment per axis, in elements | `(4,1)` means row +4, col +1 |
| Layout | Coordinate → offset | `(3,4):(4,1)` maps `(2,1)` to 9 |
| Scalar coordinate | Expand by shape, first mode fastest | For shape `(2,4)`, 5 means `(1,2)` |
| Nested mode | Keep hierarchy in the blueprint | `((2,2),3)` has rank 2, size 12 |
| Tensor view | Base pointer + layout | Same storage can have several views |
| Composition | B picks logical positions in A | `R(c) = A(B(c))` |
| Coverage | Application choice, not required for composition | B can select a subset of A |
| Coalesce | Preserve scalar-coordinate offset sequence | `(2,4):(1,2)` → `8:1` |
| Logical divide | Expose within-tile and tile-number modes | `16:1 / 4:1` → `(4,4):(1,4)` |
| Partial 1-D tile | Divide rounds up; predicate guards data accesses | `19:1 / 8:1` → `(8,3):(1,8)`; valid if index < 19 |
| Slice | Fix a coordinate; keep `None` modes | `(None,2)` selects tile 2 |

## Three calculations to remember

```text
offset = sum(coordinate_leaf * stride_leaf)
composition(A,B)(c) = A(B(c))
contiguous 1-D tiling: original_index = within + tile_size*tile_number
```

## Two-dimensional divide grouping

For original `(M,N)` tiled by `(TM,TN)`; `RM=M/TM`, `RN=N/TN` here:

| Divide | Result shape |
| --- | --- |
| Logical | `((TM,RM),(TN,RN))` |
| Zipped | `((TM,TN),(RM,RN))` |
| Tiled | `((TM,TN),RM,RN)` |
| Flat | `(TM,TN,RM,RN)` |

## Common confusions

- Shape says how many positions, not how storage is ordered.
- A scalar logical coordinate is not generally a memory offset.
- Coalescing preserves an ordered mapping, not just an offset set.
- Neither composition nor division physically copies values.
- Logical divide's nested pairs are not four top-level modes.
- A layout tiler and a tuple of per-mode tilers have different semantics.
- Valid layout arithmetic does not automatically guarantee bounds-safe GPU memory access.

For a refresh, recompute composition at `(2,1)` in [lesson 03](lessons/00-layout-algebra/03-composition/README.md), then the selected tile offset in [lesson 05](lessons/00-layout-algebra/05-logical-divide/README.md).

## Native API reminders

Inside a FlyDSL kernel, construct with `fx.make_layout(shape, stride)` and map with `fx.crd2idx(coord, layout)`. Use `fx.size(layout)` and `fx.cosize(layout)` for count and span, and `fx.get_scalar(...)` to store a scalar integer-tuple result.

To assign threads in first-mode-fastest order for a flat 2-D shape, use `fx.idx2crd(q, fx.make_ordered_layout(shape, (0,1)))`. `idx2crd` uses the supplied layout's strides; it is not a shape-only expansion when passed the data layout. Nested shapes need a matching nested order, as in lesson 02.

Run `pixi run lessons-check` for the lesson solutions and focused divide tutorials or `pixi run gpu-check` for additional mapping and sliced-view checks.

A thread layout maps coordinates to thread IDs; invert it with `fx.idx2crd(thread_id, thread_layout)`, then map that coordinate through the data layout. The launch can remain one-dimensional. With `make_ordered_layout`, order entries are speed ranks per axis (0 fastest), not explicit strides or an axis permutation list. Lesson 05 uses `(1,0,3,2)` for axes `(local_row,local_column,tile_row,tile_column)`.

## BF16 matmul reminders

For the [1024³ matmul series](lessons/01-gpu-programming/13-matmul/README.md), flat row-major element offsets are `A: row*K+inner`, `B: inner*N+column`, `C: row*N+column`. Widen BF16 loads before scalar FP32 arithmetic; round once when storing BF16 output.

`fx.make_rmem_tensor(layout, fx.Float32)` allocates private accumulator slots; initialize them with `fill(0)`. Declare named `fx.Array` fields in an `@fx.struct` storage type, then use `lds = fx.SharedAllocator().allocate(SharedStorage).peek()` inside the kernel and `lds.left.view(layout)` to create a workgroup LDS view (see [matmul lesson 03](lessons/01-gpu-programming/13-matmul/03-shared-memory/README.md#2-declare-shared-storage-and-create-row-major-lds-views)). Use `fx.gpu.barrier()` both after cooperative staging and before overwriting a tile still in use.

On the series' gfx11 wave32 targets, `fx.rocdl.WMMA(16,16,16,fx.BFloat16,fx.Float32)` describes one matrix operation; `fx.make_mma_atom`, `fx.make_tiled_mma`, and `fx.make_tiled_copy_A/B/C` derive its fragments and copies. MMA B uses logical `(N,K)`: row-major physical `(K,N)` storage has operand strides `(1,N)`. This is a view, not a transpose allocation. See [stage 05](lessons/01-gpu-programming/13-matmul/05-matrix-instructions/README.md) for the target-specific lane convention. Its A/B/C plans use full block thread IDs (wave group plus lane), `partition_S` for operand LDS views, `retile` for MMA register fragments, and `partition_D` for the output block view; generic `make_tiled_copy` still handles global-to-LDS staging.

Native matmul windows follow `*_global_view -> *_tiled_view -> *_block_view -> *_thread_view`. With `flat_divide`, two-dimensional tiles expose `(local_row,local_col,tile_row,tile_col)`. A `(4,1)` tiler over the `(16,16)` output block yields shape `(4,1,4,16)`; slicing the last two modes selects four output rows for one thread. The resulting `(4,1)` view has row stride 1024 and a canonical singleton-column stride of 0. Stages 00–02 use full-K input windows; stages 03–04 tile K by 16 before staging into LDS.

Stage 01 packs B as `b_gpu.t().contiguous().t()` before launching, preserving logical shape `(K,N)` and values with physical strides `(1,K)`. Its native B global view must use those same strides. Both a row of row-major A and a column of column-major B then have K stride 1. This per-thread property does not establish coalescing across lanes; the per-layout GPU PyTorch baselines use identical packed inputs and exclude packing time. Stages 00/02/03/04 continue to expect row-major B.

### Vectorized BF16 matmul staging

[Matmul stage 04](lessons/01-gpu-programming/13-matmul/04-vectorized-copy/README.md) combines `make_copy_atom(fx.UniversalCopy128b(), fx.BFloat16)` with a thread/value copy plan. Eight adjacent BF16 elements occupy 128 bits. Use `get_slice(tid)`, `partition_S(global_block_view)`, and `partition_D(lds_view)`, then copy through `make_fragment_like` storage. Keep aligned chunk boundaries and a barrier before shared reads and before LDS reuse. Copy ownership is separate from the 4×4 compute ownership.

Stage 04 keeps both operands row-major in LDS and uses 128-bit global loads and LDS staging stores. Compute fragments reuse four A rows and four B columns: A has strided reads; B's contiguous four-BF16 group uses `UniversalCopy64b`. Bank conflicts depend on the wave's instruction access pattern; instruction width and count also matter.

Stage 05 uses `make_layout((2,2,1), (1,2,0))` for four wave32 groups and a natural MMA footprint of 32×32×16. With `BLOCK_M = BLOCK_N = BLOCK_K = 64` and 128 threads, an explicit inner loop processes four 16-wide K slices per LDS stage. The staged K extent and the MMA atom K extent are separate.

### Measured LDS layouts

[Stage 06](lessons/01-gpu-programming/13-matmul/06-lds-swizzle/README.md) composes `fx.static(fx.SwizzleType.get(3,3,3))` with a packed layout using `fx.make_composed_layout(swizzle, 0, base)`. It maps element offsets as `e ^ ((e & 0x1c0) >> 3)`, preserving aligned eight-BF16 chunks. Stage with the composed LDS destination and retain it for MMA source partitioning. Compare padded `(64,64):(72,1)` A storage as a separate variant with an enlarged allocation. Collect raw LDS conflict counters and inspect load widths: the tested swizzle reduced conflicts but scalarized A loads; aligned padding preserved vector loads and gave the better host-timed result. A conflict reduction is not automatically a speedup.

### Interleaved global loads and WMMA

[Stage 07](lessons/01-gpu-programming/13-matmul/07-interleaved-loads/README.md) stages tile 0, then prefetches global tile `t+1` into private staging registers while MMA uses LDS tile `t`. Finish current readers with a block barrier before overwriting LDS, and barrier again after publishing future values. Drain the final tile without fetching a nonexistent successor. The 16-stage workload uses 15 steady-state iterations; a one-stage workload uses zero. Inspect generated global loads, WMMA, VMEM waits, and LDS stores before claiming a useful schedule. The captured gfx1151 VMEM wait follows all sixteen main-loop WMMA instructions; LDS stays at 17408 bytes while profiler-reported VGPR use rises from 200 to 208. Instruction order permits overlap but does not measure overlapped cycles.

### Block and register reuse tuning

[Stage 07a](lessons/01-gpu-programming/13-matmul/07a-buffer-access/README.md) keeps the 64×64×64 prefetch tile and shared staging plan while introducing `fx.rocdl.make_buffer_tensor`, `BufferCopy128b` for global loads, and `BufferCopy16b` for output. Ordinary LDS pointers retain universal-copy atoms.

[Stage 07b](lessons/01-gpu-programming/13-matmul/07b-operand-staging/README.md) then derives A's staging thread shape from `(threads//(BK//8), BK//8)` and B's from `(threads//(BN//8), BN//8)`, each with `(1,8)` values. Both are `(16,8)` at BK=BN=64. These are separate ownership plans, not a different execution schedule for A and B. Buffer resources, staging ownership, and LDS physical layouts serve separate roles.

[Stage 08](lessons/01-gpu-programming/13-matmul/08-parameter-tuning/README.md) derives `32*WM*WN` threads and `8*(BM//(16*WM))*(BN//(16*WN))` FP32 accumulators per thread. Enlarging M/N repeats the instruction's ownership across a bigger output view; the WMMA atom stays 16×16×16. Derive A and B staging plans from their distinct contiguous extents K and N. Keep one LDS tile per operand, with a reader barrier before overwriting it and a ready barrier after publication. Stage 32 K values in LDS but consume 16-wide operand fragments to control their live storage. Use `fx.rocdl.make_buffer_tensor` with `BufferCopy128b` for native global loads and `BufferCopy16b` for BF16 output; keep LDS copies on ordinary pointers. Group nearby output blocks along M to reuse B bands. The selected 128×128×32, 1×4-wave tile passed all 18 fresh direct-launch rounds against GPU PyTorch and met graph parity on gfx1151. Select parameters on training inputs, lock them, and retain every held-out paired result, including failures.

[Stage 07c](lessons/01-gpu-programming/13-matmul/07c-grouped-traversal/README.md) launches `(tiles_m*tiles_n,1,1)` and uses `flat_block_id=fx.block_idx.x` for grouped block selection with a native layout. Set `g=min(2,tiles_m)` and `block_tile_order=fx.make_layout((g,tiles_n,tiles_m//g),(tiles_n,1,g*tiles_n))`. Then `fx.crd2idx(flat_block_id,block_tile_order)` gives a row-major output-tile offset, and `fx.idx2crd` with `(tiles_m,tiles_n):(tiles_n,1)` recovers the tile row/column. IDs 0 and 1 read the same B band. Each block retains its own LDS, K reduction, and prefetch pipeline. Complete two-row groups or a one-row grid are supported; larger odd row counts need additional handling.

Stage 08 selects locked configurations with `CONFIGS_BY_SHAPE[(M,N,K)]`: the 1024³ workload uses `group_m=8`; `(1024,4096,2048)` uses `group_m=2`. Both use 128×128×32 tiles and 1×4 waves. Run its solution with `--shape 1024 4096 2048`, or pass the same shape to `tune.py` for a separate search/verification. The standard series benchmark stays 1024³.


[Stage 09](lessons/01-gpu-programming/13-matmul/09-split-k/README.md) adds `Config.split_k` in `(1,2,4)`. A 1D grid has `tiles_m*tiles_n*split_k` blocks; native layout algebra decodes an output tile ID and split ID. Each block computes `K/split_k` values using the same single-stage prefetch pipeline. For split counts above one, each thread stores disjoint FP32 partials, then uses `fx.atomic_add(..., ordering=fx.AtomicOrdering.AcqRel, syncscope=fx.rocdl.SyncScope.Agent)`. The peer receiving `split_k-1` reduces its corresponding fragments and writes BF16 output, then resets the counter. One kernel includes the reduction and reset. Initialize workspace once and serialize its reuse on one stream; overlapping calls need separate workspaces.


[Stage 10](lessons/01-gpu-programming/13-matmul/10-wave-local-tiles/README.md) groups independent wave32 tiles with `logical_block_id = fx.block_idx.x * WAVE_GROUPS + wave_group`. Copy/MMA plans use local `compute_thread_id`; each group offsets A/B LDS views into disjoint storage. Conservative workgroup handoffs keep the first comparison focused on ownership.

[Stage 10a](lessons/01-gpu-programming/13-matmul/10a-synchronization-scope/README.md) uses `fx.barrier(address_spaces=ir.ArrayAttr.get([ir.Attribute.parse("#gpu.address_space<workgroup>")]), scope=barrier_scope)`. The address space selects LDS ordering; execution scope selects participating threads. Independent single-wave groups can use `gpu.BarrierScope.Subgroup`; cooperating multiwave tiles keep workgroup scope. Global split-K publication retains agent-scope acquire/release atomics.

[Stage 10b](lessons/01-gpu-programming/13-matmul/10b-cache-policy/README.md) constructs `fx.make_copy_atom(fx.rocdl.BufferCopy128b(RIGHT_CACHE_MODIFIER), fx.BFloat16)`. Policies 0 and 2 retain identical addresses and ownership; 2 emits SLC on the measured gfx11 target. Hardware manages cache contents; LDS remains explicitly allocated shared storage. One 128-bit transfer is eight BF16 values, while the wide tile's B staging fragment contains 32 BF16 values per thread.

[Stage 10c](lessons/01-gpu-programming/13-matmul/10c-k-unrolling/README.md) groups `tiles_per_split-1` steady steps into a rolled full-group loop containing `fx.range_constexpr(K_UNROLL)`, then handles the remainder and drains once. It reuses one logical next-tile fragment. Physical VGPR allocation can change with compiler scheduling; multiplying copy width by unroll does not predict it.

[Stage 12](lessons/01-gpu-programming/13-matmul/12-operand-paths/README.md) can bypass A LDS staging with `fx.make_tiled_copy_A(fx.make_copy_atom(fx.rocdl.BufferCopy128b(cache), fx.BFloat16), mma).get_slice(compute_thread_id)`. Partition the selected global A view with `partition_S`, and retile its destination WMMA fragment. Keep current and next A fragments private; select K=16 register slices for computation. B can retain a different cooperative global/LDS copy plan. Compare `left_in_registers=True/False` per shape: avoiding LDS can increase repeated global requests and register pressure. L0/L1/L2 remain hardware managed; the cache modifier supplies an instruction policy hint.

[Wave specialization and semaphore handoffs](experiments/wave-specialization/README.md) remain archived research. The main path retains all-wave prefetch; [12 explains the measured choice](lessons/01-gpu-programming/13-matmul/12-operand-paths/README.md#why-the-course-keeps-prefetch).
