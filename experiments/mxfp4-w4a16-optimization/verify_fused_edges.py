"""Check every E2M1 nibble across the normal BF16 range of E8M0 scales."""

import runpy
from pathlib import Path

import flydsl  # noqa: F401 -- initialize FlyDSL LLVM before PyTorch
import torch

FUSED = Path(__file__).resolve().with_name("fused_matmul.py")


def main():
    module = runpy.run_path(str(FUSED))
    m, n, k = 16, 256, 32
    a = torch.eye(m, k, dtype=torch.bfloat16, device="cuda")
    codes = (torch.arange(k, device="cuda") % 16).to(torch.uint8)[:, None]
    codes = codes.expand(k, n).contiguous()
    b_packed = (codes[:, 0::2] | (codes[:, 1::2] << 4)).reshape(-1).contiguous()
    b_scales = (
        (torch.arange(n, dtype=torch.int32, device="cuda") % 243) + 10
    ).to(torch.uint8).view(1, n)
    config = module["Config"](
        block_m=16,
        block_n=64,
        block_k=16,
        waves_m=1,
        waves_n=2,
        split_k=1,
        wave_groups_m=1,
        wave_groups_n=1,
        k_unroll=1,
    )
    output = module["matmul_mxfp4_fused"](
        a, b_packed, b_scales, config=config
    )

    code = torch.arange(16, device="cuda", dtype=torch.int32)
    magnitude = code & 7
    levels = torch.tensor(
        [0.0, 0.5, 1.0, 1.5, 2.0, 3.0, 4.0, 6.0], device="cuda"
    )
    values = levels[magnitude] * torch.where(code >= 8, -1.0, 1.0)
    scale = torch.exp2(b_scales[0].float() - 127.0)
    expected = (values[:, None] * scale[None, :]).to(torch.bfloat16)
    torch.testing.assert_close(output, expected, rtol=0, atol=0)
    print(
        "Fused edge check passed:",
        "16 E2M1 codes x 243 E8M0 scales, all with normal BF16 results.",
    )


if __name__ == "__main__":
    main()
