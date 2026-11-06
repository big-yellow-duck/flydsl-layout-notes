"""Reproduce the focused 10–10c SVG/PNG figures (requires Pillow)."""

from draw_lesson_visuals import BLUE, GOLD, GRAY, TEAL, Diagram
from draw_wave_tiles import describe, down_arrow, wave_tiles

BASE = "01-gpu-programming/13-matmul"


def synchronization():
    d = Diagram(760, "10a - Order LDS for the threads that share it")
    describe(
        d,
        "Independent single-wave groups use disjoint LDS regions and subgroup execution scope. Two waves sharing a tile need workgroup execution scope. Both handoffs order LDS memory; global split-K atomics keep agent scope.",
    )
    d.text(
        32,
        74,
        "Memory address space: LDS. Execution scope: threads exchanging that data.",
        21,
    )
    d.text(32, 125, "Wide tile: independent wave groups", 23)
    for group, color in enumerate((TEAL, GOLD)):
        x = 32 + group * 460
        d.card(
            x,
            174,
            430,
            f"Wave {group}: 32 threads",
            f"Only wave {group} writes and reads its tile",
            color,
        )
        down_arrow(d, x + 210, 275, 313)
        d.card(
            x,
            330,
            430,
            f"Private group {group} LDS region",
            "Subgroup rendezvous + LDS ordering",
            color,
        )
    d.text(32, 448, "Narrow tile: two cooperating waves share one A/B tile", 23)
    d.card(32, 496, 300, "Wave 0 + wave 1", "64 participating threads", BLUE)
    d.arrow(344, 540, 398, 540)
    d.card(
        414,
        496,
        511,
        "Shared A/B LDS tile",
        "Workgroup rendezvous + LDS ordering",
        BLUE,
    )
    d.text(
        32,
        617,
        "Reader handoff: finish old reads. Publication handoff: expose the new tile.",
        21,
    )
    d.card(
        32,
        665,
        893,
        "Split-K workspace is global memory, shared across blocks",
        "Its arrival counter retains agent-scope acquire/release atomics.",
        GRAY,
    )
    d.save(f"{BASE}/10a-synchronization-scope/synchronization-scope")


def cache_policy():
    d = Diagram(790, "10b - Change B's load policy while keeping its addresses")
    describe(
        d,
        "Modifier zero and modifier two both read eight adjacent BF16 values per 128-bit instruction. Policy two emits SLC on gfx11. A one-wave 16 by 64 B tile with K sixteen gives each thread thirty-two BF16 staging values, or four complete vectors. Hardware caches remain distinct from allocated LDS.",
    )
    d.text(
        32,
        72,
        "Wide case: B tile 16 x 64; 32 staging threads; 32 BF16 values per thread.",
        21,
    )
    d.text(32, 123, "Thread 3's first vector: B row 0, columns 24..31", 23)
    offsets = list(range(24, 32))
    for i, offset in enumerate(offsets):
        d.cell(32 + i * 112, 174, offset, GOLD, 106)
        d.text(43 + i * 112, 233, str(offset % 7 - 3), 23)
    d.text(
        32, 278, "Top: global element offsets. Below: actual values B[i]=(i%7)-3.", 20
    )
    for y, modifier, color in ((331, 0, BLUE), (440, 2, TEAL)):
        d.card(
            32, y, 335, f"BufferCopy128b({modifier})", "8 BF16 values = 128 bits", color
        )
        d.arrow(379, y + 44, 425, y + 44)
        d.card(
            441,
            y,
            484,
            "Same source and staging ownership",
            "Ordinary policy" if modifier == 0 else "gfx11 SLC policy bit set",
            color,
        )
    d.text(
        32, 568, "Four complete vectors fill the same 32-value B staging fragment.", 21
    )
    d.card(
        32,
        617,
        428,
        "Hardware-managed caches",
        "The hint influences global reads.",
        BLUE,
    )
    d.card(
        494,
        617,
        431,
        "Application-managed LDS",
        "The tile and its barriers stay the same.",
        TEAL,
    )
    d.text(
        32,
        739,
        "Measure policy 0 versus 2 with tile geometry and the rolled K loop fixed.",
        20,
    )
    d.save(f"{BASE}/10b-cache-policy/cache-policy")


def unrolling():
    d = Diagram(790, "10c - Group steady K steps without adding tile buffers")
    describe(
        d,
        "For six tiles and unroll four, the prologue prepares tile zero, four expanded steps consume tiles zero through three, one tail step consumes tile four, and the drain consumes tile five. B staging remains thirty-two BF16 values per thread; physical VGPR use is measured independently.",
    )
    d.text(
        32, 72, "Small trace: K=96; BLOCK_K=16; one split; six tiles; k_unroll=4.", 22
    )
    d.card(
        32,
        124,
        893,
        "Prologue prepares tile 0",
        "Five steady steps remain: one full group of four + one tail step.",
        BLUE,
    )
    for step in range(6):
        x = 32 + step * 151
        color = TEAL if step < 4 else GOLD
        d.box(x, 247, 137, 156, color)
        d.text(x + 11, 261, f"Step {step}" if step < 5 else "Drain", 22)
        d.text(x + 11, 305, f"Use tile {step}", 19)
        d.text(x + 11, 351, f"Fetch {step + 1}" if step < 5 else "No fetch", 19)
    d.text(32, 425, "Full unrolled group: steps 0..3", 22)
    d.text(637, 425, "Tail: 4", 22)
    d.text(787, 425, "Drain: 5", 22)
    d.text(32, 478, "A tile tags [1,2,4,8,16,32], B=1: output = 16*63 = 1008.", 21)
    d.card(
        32,
        531,
        428,
        "Current tile: one LDS stage",
        "Next tile: one staging fragment",
        BLUE,
    )
    d.card(
        494,
        531,
        431,
        "32 BF16 B values per thread",
        "Same logical fragment for U=1,2,4,8",
        TEAL,
    )
    d.card(
        32,
        651,
        893,
        "Unrolling exposes a longer instruction region to the compiler",
        "Measure physical VGPR use; it is not eight BF16 values times the unroll factor.",
        GOLD,
    )
    d.save(f"{BASE}/10c-k-unrolling/k-unrolling")


def main():
    wave_tiles()
    synchronization()
    cache_policy()
    unrolling()


if __name__ == "__main__":
    main()
