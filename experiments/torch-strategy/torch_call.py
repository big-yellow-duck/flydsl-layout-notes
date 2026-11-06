"""Record Torch's actual BLAS calls and validate preallocated BF16 outputs."""

import argparse
import hashlib
import json
from pathlib import Path

import flydsl  # noqa: F401 -- keep LLVM initialization order consistent with profiling
import torch


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--shape", type=int, nargs=3, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    torch.set_num_threads(1)
    m, n, k = args.shape
    generator = torch.Generator().manual_seed(13)
    a_cpu = torch.randn(m, k, generator=generator).to(torch.bfloat16)
    b_cpu = torch.randn(k, n, generator=generator).to(torch.bfloat16)
    expected = (a_cpu.float() @ b_cpu.float()).to(torch.bfloat16)
    a, b = a_cpu.cuda(), b_cpu.cuda()
    storage = torch.full((m * n + 16,), -99, dtype=torch.bfloat16, device="cuda")
    out = storage[:-16].view(m, n)
    for sign in (1, -1, 1):
        a.copy_(a_cpu * sign)
        out.fill_(float("nan"))
        torch.matmul(a, b, out=out)
        torch.cuda.synchronize()
        torch.testing.assert_close(out.cpu(), expected * sign, rtol=0.016, atol=0.03125)
        assert torch.all(storage[-16:] == -99).item()
    libraries = sorted(
        {
            row.split()[-1]
            for row in Path("/proc/self/maps").read_text().splitlines()
            if "/" in row and any(name in row for name in ("libhipblas", "librocblas"))
        }
    )
    args.output.write_text(
        json.dumps(
            {
                "shape_MNK": args.shape,
                "torch": torch.__version__,
                "hip": torch.version.hip,
                "gpu": torch.cuda.get_device_name(),
                "architecture": torch.cuda.get_device_properties(0).gcnArchName,
                "blas_preference": str(torch.backends.cuda.preferred_blas_library()),
                "tunable_enabled": torch.cuda.tunable.is_enabled(),
                "tuning_enabled": torch.cuda.tunable.tuning_is_enabled(),
                "input_strides": [a.stride(), b.stride()],
                "output_stride": out.stride(),
                "loaded_blas_libraries": libraries,
                "source_sha256": hashlib.sha256(
                    Path(__file__).read_bytes()
                ).hexdigest(),
                "correctness": "complete CPU BF16-quantized reference, signed-input reuse, NaN output and sentinels passed",
                "scope": "BLAS logging only; not performance timing",
            },
            indent=2,
        )
        + "\n"
    )


if __name__ == "__main__":
    main()
