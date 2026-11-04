"""Render stage 08's logical kernel strategy as a seekable video.

Run: python3 tools/animate_matmul_tuning.py
Requires Pillow and FFmpeg with libx264. Writes strategy.mp4 with chapters,
plus an SVG/PNG poster beside the lesson's diagrams.
The animation illustrates dataflow and ownership, not measured GPU timing.
"""

import argparse
import math
import shutil
import subprocess
import tempfile
from dataclasses import dataclass
from functools import lru_cache
from html import escape
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
DEST = ROOT / "assets/01-gpu-programming/13-matmul/08-parameter-tuning"
WIDTH, HEIGHT = 1440, 1040
INK, MUTED, BORDER = "#14253d", "#52647c", "#b6c4d4"
BG, BLUE, TEAL, GOLD, PURPLE = "#f8fafc", "#dcecff", "#ccefe6", "#ffedbe", "#e5dcff"
WAVES = (BLUE, TEAL, GOLD, PURPLE)
ACTIVE, GREEN = "#d16b12", "#b5e4ca"


@lru_cache(None)
def font(size):
    paths = (
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        "/usr/share/fonts/google-noto/NotoSans-Regular.ttf",
        "/usr/share/fonts/liberation-sans-fonts/LiberationSans-Regular.ttf",
    )
    return ImageFont.truetype(next(p for p in paths if Path(p).exists()), size)


class Canvas:
    def __init__(self):
        self.image = Image.new("RGB", (WIDTH, HEIGHT), BG)
        self.draw = ImageDraw.Draw(self.image)
        self.svg = [
            f'<svg xmlns="http://www.w3.org/2000/svg" width="{WIDTH}" height="{HEIGHT}" viewBox="0 0 {WIDTH} {HEIGHT}" role="img" aria-labelledby="title desc">',
            '<title id="title">Matmul strategy: K reduction, operand reuse, and grouped blocks</title>',
            '<desc id="desc">A whole-output grid, separate staging and LDS buffers, and four-wave accumulator ownership show distinct levels of the parameter-tuned matmul.</desc>',
            f'<rect width="100%" height="100%" fill="{BG}"/>',
        ]

    def text(self, x, y, value, size=21, fill=INK):
        value = str(value)
        assert x + self.draw.textlength(value, font=font(size)) <= WIDTH - 20, value
        self.draw.text((x, y), value, font=font(size), fill=fill, anchor="lt")
        self.svg.append(
            f'<text x="{x}" y="{y}" dominant-baseline="text-before-edge" font-family="DejaVu Sans, sans-serif" font-size="{size}" fill="{fill}">{escape(value)}</text>'
        )

    def box(self, x, y, w, h, fill="white", outline=BORDER, width=1, radius=8):
        self.draw.rounded_rectangle(
            (x, y, x + w, y + h), radius=radius, fill=fill, outline=outline, width=width
        )
        self.svg.append(
            f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{radius}" fill="{fill}" stroke="{outline}" stroke-width="{width}"/>'
        )

    def arrow(self, x1, y1, x2, y2, fill=INK):
        angle = math.atan2(y2 - y1, x2 - x1)
        points = [
            (x1, y1),
            (x2, y2),
            (x2 - 11 * math.cos(angle - 0.45), y2 - 11 * math.sin(angle - 0.45)),
            (x2, y2),
            (x2 - 11 * math.cos(angle + 0.45), y2 - 11 * math.sin(angle + 0.45)),
        ]
        self.draw.line(points, fill=fill, width=3)
        coords = " ".join(f"{x:.1f},{y:.1f}" for x, y in points)
        self.svg.append(
            f'<polyline points="{coords}" fill="none" stroke="{fill}" stroke-width="3"/>'
        )


@dataclass(frozen=True)
class State:
    phase: str
    caption: str
    detail: str
    duration: int = 1200
    lds: int | None = None
    staging: int | None = None
    rk: int | None = None
    update: int | None = None
    covered: int = 0
    pid: int = 0
    stored: bool = False


def stages():
    yield State(
        "select",
        "Select one 128 x 128 output block; initialize its accumulators to zero.",
        "Four waves own this block. Every block still reduces over all 1024 K values.",
        6000,
    )
    yield State(
        "load",
        "Prologue: load A and B for K=0..31 into staging registers.",
        "Copy plans assign eight-BF16 chunks; BufferCopy128b performs each global load.",
        5000,
        staging=0,
    )
    yield State(
        "publish",
        "Publish tile 0 into the single LDS buffer for each operand.",
        "A uses a padded row stride of 40; B remains packed with row stride 128.",
        4000,
        lds=0,
        staging=0,
    )
    yield State(
        "ready",
        "Ready barrier: tile 0 is visible to every wave.",
        "The LDS tile is ready before any wave copies its MMA operands.",
        4000,
        lds=0,
    )
    yield State(
        "prefetch",
        "Issue the next global loads for tile 1, K=32..63.",
        "Current tile 0 stays in LDS; future tile 1 occupies separate staging registers.",
        5000,
        lds=0,
        staging=1,
    )
    for rk in range(2):
        for update in range(16):
            rm, rn = divmod(update, 2)
            yield State(
                "compute",
                f"K={16 * rk}..{16 * rk + 15}: M repeat {rm}, N repeat {rn}; one WMMA per wave.",
                f"Wave 0: reuse A row tile {rm} across columns 0 and 4; B column tiles serve all 8 row tiles.",
                2000,
                lds=0,
                staging=1,
                rk=rk,
                update=update,
                covered=16 * rk,
            )
        yield State(
            "half",
            f"All M/N repetitions for K={16 * rk}..{16 * rk + 15} are accumulated.",
            "The same C accumulators survive; operand registers are reused for the next 16 K values.",
            4000,
            lds=0,
            staging=1,
            rk=rk,
            covered=16 * (rk + 1),
        )
    yield State(
        "readers",
        "Reader barrier: finish consuming tile 0 before overwriting LDS.",
        "The 128 FP32 values per thread remain in accumulators; tile 1 is waiting in staging.",
        4000,
        lds=0,
        staging=1,
        covered=32,
    )
    yield State(
        "publish",
        "Publish prefetched tile 1, then wait at the ready barrier.",
        "Reuse the same LDS storage. The outer loop advances along K by 32.",
        4000,
        lds=1,
        staging=1,
        covered=32,
    )
    for tile in range(1, 31):
        for rk in range(2):
            begin = tile * 32 + rk * 16
            yield State(
                "repeat",
                f"Stage {tile}: prefetch tile {tile + 1}; accumulate K={begin}..{begin + 15}."
                if rk == 0
                else f"Stage {tile}: reuse operand registers; accumulate K={begin}..{begin + 15}.",
                "Compressed: all 16 M/N repetitions per wave are shown together for this K fragment.",
                1500,
                lds=tile,
                staging=tile + 1,
                rk=rk,
                covered=begin + 16,
            )
        yield State(
            "handoff",
            f"Stage {tile} complete: reader barrier, publish tile {tile + 1}, ready barrier.",
            "K advances; each block's M/N output coordinates stay fixed throughout its reduction.",
            1000,
            lds=tile + 1,
            covered=(tile + 1) * 32,
        )
    yield State(
        "drain",
        "Drain: tile 31 is already in LDS, covering K=992..1023.",
        "The final stage has no future global tile to prefetch.",
        5000,
        lds=31,
        covered=992,
    )
    for rk in range(2):
        begin = 992 + rk * 16
        yield State(
            "drain_compute",
            f"Final WMMA updates: accumulate K={begin}..{begin + 15}.",
            "All M/N repetitions update the same output accumulators one last time.",
            4000,
            lds=31,
            rk=rk,
            covered=begin + 16,
        )
    yield State(
        "store",
        "Convert the 128 FP32 accumulators per thread to BF16 and store C.",
        "The MMA-derived C copy plan stores all 16384 values of this output block.",
        6000,
        lds=31,
        covered=1024,
        stored=True,
    )
    for pid in range(1, 9):
        row, col = pid % 8, pid // 8
        yield State(
            "map",
            f"Block mapping: logical block {pid} owns output tile (row={row}, col={col}).",
            "Blocks 0..7 share a B column band; each block independently runs its own K loop.",
            2500,
            pid=pid,
            stored=True,
        )
    yield State(
        "summary",
        "K reduces the product. M/N repetitions reuse operands across output tiles.",
        "Grouped block mapping encourages B cache reuse between independently scheduled workgroups.",
        7000,
        pid=8,
        stored=True,
    )


def span(tile):
    return "empty" if tile is None else f"tile {tile}: K={tile * 32}..{tile * 32 + 31}"


def render(s):
    c = Canvas()
    c.text(32, 25, "08  |  The complete parameter-tuned matmul strategy", 34)
    c.text(
        32,
        78,
        "1024 x 1024 x 1024  |  block 128 x 128 x 32  |  1 x 4 waves  |  one LDS buffer per operand",
        22,
    )
    phase_index = (
        0
        if s.phase == "select"
        else 4
        if s.phase in ("store", "map", "summary")
        else 3
        if s.phase in ("repeat", "handoff", "drain", "drain_compute")
        else 2
        if s.phase in ("compute", "half")
        else 1
    )
    for i, label in enumerate(
        (
            "1  Select output",
            "2  Stage / prefetch",
            "3  Reuse operands",
            "4  Reduce all K",
            "5  Store / map blocks",
        )
    ):
        c.box(30 + i * 281, 125, 271, 45, BLUE if i == phase_index else "#eaf0f6")
        c.text(42 + i * 281, 138, label, 20)
    for x, w in ((30, 310), (360, 635), (1015, 395)):
        c.box(x, 190, w, 570)
    c.text(48, 210, "Whole C: 1024 x 1024", 23)
    c.text(48, 248, "Each cell = 128 x 128 outputs", 17)
    row, col = s.pid % 8, s.pid // 8
    for r in range(8):
        c.text(44, 293 + r * 30, r, 17)
        for n in range(8):
            if r == 0:
                c.text(75 + n * 30, 266, n, 17)
            fill = TEAL if n == col else "#f1f5f9"
            if s.stored and r == 0 and n == 0:
                fill = GREEN
            c.box(67 + n * 30, 290 + r * 30, 28, 28, fill, radius=2)
            c.text(72 + n * 30, 297 + r * 30, r + 8 * n, 13)
    c.box(
        66 + col * 30,
        289 + row * 30,
        30,
        30,
        GREEN if s.stored and s.pid == 0 else BLUE,
        INK,
        3,
        2,
    )
    c.text(71 + col * 30, 296 + row * 30, s.pid, 15)
    c.text(48, 550, "M: rows down; N: columns right", 17)
    c.text(48, 584, f"pid {s.pid} -> tile ({row},{col})", 22)
    c.text(48, 620, f"C rows {row * 128}..{row * 128 + 127}", 19)
    c.text(48, 650, f"C cols {col * 128}..{col * 128 + 127}", 19)
    c.text(48, 704, "Cell numbers are logical block IDs.", 16)
    c.text(378, 210, "Inside one block: the reduction loop is K", 25)
    c.box(
        390,
        260,
        575,
        81,
        BLUE
        if s.phase in ("load", "prefetch") or (s.phase == "repeat" and s.rk == 0)
        else "#f1f5f9",
    )
    c.text(406, 273, "Global A[row band, K] and B[K, column band]", 22)
    c.text(406, 310, "Copy plans + BufferCopy128b: eight BF16 values / chunk", 18)
    c.arrow(
        514,
        345,
        514,
        372,
        ACTIVE
        if s.phase in ("load", "prefetch") or (s.phase == "repeat" and s.rk == 0)
        else MUTED,
    )
    c.box(390, 380, 260, 105, PURPLE if s.staging is not None else "#f1f5f9")
    c.text(406, 395, "Staging registers", 23)
    c.text(
        406, 436, span(s.staging) if s.staging is not None else "no pending tile", 18
    )
    c.box(710, 380, 255, 105, TEAL if s.lds is not None else "#f1f5f9")
    c.text(726, 395, "Current LDS tile", 23)
    c.text(726, 436, span(s.lds), 18)
    c.arrow(655, 430, 703, 430, ACTIVE if s.phase in ("publish", "handoff") else MUTED)
    barrier = (
        "ready barrier"
        if s.phase in ("publish", "ready", "handoff")
        else "reader barrier"
        if s.phase == "readers"
        else "publish"
    )
    c.text(638, 499, barrier, 17, ACTIVE if "barrier" in barrier else MUTED)
    c.arrow(835, 490, 835, 531, ACTIVE if s.rk is not None else MUTED)
    c.box(
        390,
        540,
        575,
        114,
        GREEN if s.phase == "store" else GOLD if s.rk is not None else "#f1f5f9",
    )
    begin = s.lds * 32 + s.rk * 16 if s.lds is not None and s.rk is not None else None
    if s.phase == "store":
        c.text(406, 555, "FP32 accumulators -> BF16 output", 23)
        c.text(406, 595, "BufferCopy16b + MMA-derived C copy plan", 21)
        c.text(406, 625, "Store all 16384 values of this block into global C.", 18)
        c.arrow(1040, 587, 970, 587, ACTIVE)
        c.arrow(382, 587, 346, 587, ACTIVE)
    else:
        c.text(406, 555, "MMA operands: 16 K values at a time", 23)
        if begin is None:
            c.text(406, 595, "A: 128 x 16  |  B: 16 x 128 (logical subviews)", 19)
            c.text(
                406, 625, "Operand registers are separate from staging registers.", 17
            )
        else:
            c.text(406, 592, f"rk={s.rk}: K={begin}..{begin + 15}", 21)
            if s.update is not None:
                rm, rn = divmod(s.update, 2)
                c.text(
                    406,
                    625,
                    f"Wave 0: A rows {rm * 16}..{rm * 16 + 15}; B cols {rn * 64}..{rn * 64 + 15}",
                    18,
                )
            else:
                c.text(406, 625, "Each wave covers 8 M repeats x 2 N repeats.", 19)
        c.arrow(970, 587, 1040, 587, ACTIVE if s.rk is not None else MUTED)
    c.text(390, 691, "Same single-buffer handoff as stage 07:", 20)
    c.text(390, 723, "prefetch -> compute -> reader barrier -> publish -> ready", 18)
    c.text(1033, 210, "Local C: 128 x 128", 25)
    c.text(1033, 250, "Each cell = 16 x 16 outputs", 19)
    for r in range(8):
        c.text(1042, 308 + r * 36, r, 17)
        for n in range(8):
            if r == 0:
                c.text(1080 + n * 36, 277, n, 17)
            active = s.phase in ("repeat", "drain_compute", "half") or (
                s.update is not None and r == s.update // 2 and n // 4 == s.update % 2
            )
            fill = GREEN if s.covered == 1024 else WAVES[n % 4]
            c.box(
                1068 + n * 36,
                300 + r * 36,
                34,
                34,
                fill,
                ACTIVE if active else BORDER,
                3 if active else 1,
                2,
            )
            c.text(1071 + n * 36, 310 + r * 36, f"W{n % 4}", 16)
    c.text(1033, 614, "W0..W3 = four wave owners", 19)
    c.text(1033, 650, "128 FP32 values / thread", 21)
    c.text(1033, 688, f"Covered K: {s.covered} / 1024", 22)
    c.text(1033, 726, "Orange = active operation", 17, ACTIVE)
    c.text(
        32,
        789,
        "Outer K loop: 32 stages of 32 values. Each stage has two 16-wide fragment steps.",
        22,
    )
    for tile in range(32):
        x = 50 + tile * 42
        fill = (
            GREEN
            if s.covered >= (tile + 1) * 32
            else TEAL
            if s.lds == tile
            else "#eaf0f6"
        )
        c.box(
            x,
            835,
            38,
            33,
            fill,
            INK if s.lds == tile else BORDER,
            2 if s.lds == tile else 1,
            3,
        )
        c.text(x + (12 if tile < 10 else 6), 844, tile, 17)
        if s.staging == tile:
            c.box(x + 7, 875, 24, 5, PURPLE, PURPLE, radius=1)
    c.text(50, 889, "Stage 0: K=0..31", 17)
    c.text(570, 889, "Green: accumulated  |  Teal: LDS  |  Purple mark: staging", 17)
    c.box(30, 924, 1380, 76, "#eaf0f6")
    c.text(46, 936, s.caption, 23)
    c.text(46, 972, s.detail, 19)
    c.text(
        32,
        1015,
        "Logical dataflow, not GPU clock timing. Each workgroup independently performs its own K reduction.",
        17,
        MUTED,
    )
    return c


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--ffmpeg",
        default=shutil.which("ffmpeg"),
        help="FFmpeg executable with the libx264 encoder",
    )
    args = parser.parse_args()
    if args.ffmpeg is None:
        parser.error("FFmpeg with libx264 is required")
    encoders = subprocess.check_output(
        [args.ffmpeg, "-hide_banner", "-encoders"], text=True, stderr=subprocess.DEVNULL
    )
    if "libx264" not in encoders:
        parser.error(
            "This FFmpeg build lacks libx264; choose a full build with --ffmpeg PATH"
        )
    story = list(stages())
    # Check the illustrated full reduction and the grouped block mapping.
    fragments = [
        (s.lds * 32 + s.rk * 16, s.covered)
        for s in story
        if s.phase in ("half", "repeat", "drain_compute")
    ]
    assert fragments == [(k, k + 16) for k in range(0, 1024, 16)]
    assert all(s.staging is None or s.staging < 32 for s in story)
    assert all(
        s.staging != s.lds
        for s in story
        if s.phase in ("prefetch", "compute", "half", "repeat", "readers")
    )
    poster = render(
        next(s for s in story if s.phase == "compute" and s.rk == 0 and s.update == 1)
    )
    DEST.mkdir(parents=True, exist_ok=True)
    poster.image.save(DEST / "strategy.png")
    (DEST / "strategy.svg").write_text("\n".join(poster.svg + ["</svg>"]) + "\n")
    encode_video(story, args.ffmpeg)


def chapter_name(state):
    if state.phase == "select":
        return "Choose an output block"
    if state.phase in ("load", "ready") or (
        state.phase == "publish" and state.lds == 0
    ):
        return "Prologue: publish tile 0 to LDS"
    if state.phase == "prefetch":
        return "Prefetch the next global tile"
    if state.phase in ("compute", "half"):
        return "First K stage: M/N operand reuse"
    if state.phase in ("readers", "publish"):
        return "Reader barrier and LDS handoff"
    if state.phase in ("repeat", "handoff"):
        return "Reduce the remaining K stages"
    if state.phase in ("drain", "drain_compute"):
        return "Drain the final K stage"
    if state.phase == "store":
        return "Convert and store BF16 output"
    if state.phase == "map":
        return "Group output blocks along M"
    return "K reduction and M/N reuse recap"


def encode_video(story, ffmpeg):
    chapters = []
    elapsed = 0
    for state in story:
        name = chapter_name(state)
        if not chapters or chapters[-1]["title"] != name:
            chapters.append({"title": name, "start": elapsed, "end": elapsed})
        elapsed += state.duration
        chapters[-1]["end"] = elapsed
    path = DEST / "strategy.mp4"
    with tempfile.TemporaryDirectory(prefix="matmul-strategy-video-") as directory:
        work = Path(directory)
        manifest = []
        for index, state in enumerate(story):
            name = f"frame{index:03}.png"
            render(state).image.save(work / name)
            manifest += [f"file '{name}'", f"duration {state.duration / 1000:.3f}"]
        manifest.append(f"file 'frame{len(story) - 1:03}.png'")
        (work / "frames.txt").write_text("\n".join(manifest) + "\n")
        metadata = [
            ";FFMETADATA1",
            "title=FlyDSL matmul: the full parameter-tuning strategy",
        ]
        for chapter in chapters:
            metadata += [
                "[CHAPTER]",
                "TIMEBASE=1/1000",
                f"START={chapter['start']}",
                f"END={chapter['end']}",
                f"title={chapter['title']}",
            ]
        (work / "chapters.txt").write_text("\n".join(metadata) + "\n")
        print(
            f"Encoding {len(story)} steps / {elapsed / 1000:.1f}s with an independent keyframe at every visual step...",
            flush=True,
        )
        subprocess.run(
            [
                ffmpeg,
                "-hide_banner",
                "-loglevel",
                "error",
                "-y",
                "-f",
                "concat",
                "-safe",
                "0",
                "-i",
                "frames.txt",
                "-f",
                "ffmetadata",
                "-i",
                "chapters.txt",
                "-map",
                "0:v:0",
                "-map_metadata",
                "1",
                "-map_chapters",
                "1",
                "-fps_mode",
                "vfr",
                "-c:v",
                "libx264",
                "-preset",
                "fast",
                "-crf",
                "23",
                "-pix_fmt",
                "yuv420p",
                "-g",
                "1",
                "-bf",
                "0",
                "-sc_threshold",
                "0",
                "-threads",
                "2",
                "-movflags",
                "+faststart",
                str(path),
            ],
            cwd=work,
            check=True,
        )
    print(f"Wrote {path.relative_to(ROOT)}: {path.stat().st_size / 1024:.0f} KiB")
    for chapter in chapters:
        seconds = chapter["start"] // 1000
        print(f"{seconds // 60:02}:{seconds % 60:02}  {chapter['title']}")


if __name__ == "__main__":
    main()
