
/tmp/torch-strategy-extraction/gfx1151.hsaco:	file format elf64-amdgpu
	.amdgcn_target "amdgpu-amd-amdhsa-unknown-gfx1151"

Disassembly of section .text:

<label_ASM_Start>:
	s_load_b32 s20, s[0:1], null                               // 0000006C9000: F4000500 F8000000
	s_load_b32 s22, s[0:1], 0x4                                // 0000006C9008: F4000580 F8000004
	s_load_b32 s11, s[0:1], 0x8                                // 0000006C9010: F40002C0 F8000008
	s_load_b32 s23, s[0:1], 0xc                                // 0000006C9018: F40005C0 F800000C
	s_waitcnt lgkmcnt(0)                                       // 0000006C9020: BF89FC07
	s_lshr_b32 s21, s20, 30                                    // 0000006C9024: 85159E14
	s_and_b32 s20, 0x3fffffff, s20                             // 0000006C9028: 8B1414FF 3FFFFFFF
	s_cmp_eq_u32 s21, 3                                        // 0000006C9030: BF068315
	s_cbranch_scc1 label_Bypass_ArgType3_to_ArgType0_Instance1 // 0000006C9034: BFA20002
	s_cmp_eq_u32 s21, 0                                        // 0000006C9038: BF068015
	s_cbranch_scc0 label_HBMArgs                               // 0000006C903C: BFA10009

<label_Bypass_ArgType3_to_ArgType0_Instance1>:
	s_add_u32 s0, s0, 16                                       // 0000006C9040: 80009000
	s_addc_u32 s1, s1, 0                                       // 0000006C9044: 82018001
	s_load_b512 s[24:39], s[0:1], null                         // 0000006C9048: F4100600 F8000000
	s_load_b128 s[40:43], s[0:1], 0x40                         // 0000006C9050: F4080A00 F8000040
	s_load_b64 s[44:45], s[0:1], 0x50                          // 0000006C9058: F4040B00 F8000050
	s_branch label_LoadArgsEnd                                 // 0000006C9060: BFA00003

<label_HBMArgs>:
	s_load_b64 s[0:1], s[0:1], 0x10                            // 0000006C9064: F4040000 F8000010
	s_waitcnt lgkmcnt(0)                                       // 0000006C906C: BF89FC07

<label_LoadArgsEnd>:
	s_and_b32 s10, s22, 0xffff0000                             // 0000006C9070: 8B0AFF16 FFFF0000
	s_lshr_b32 s10, s10, 16                                    // 0000006C9078: 850A900A
	s_and_b32 s46, s22, 0xffff                                 // 0000006C907C: 8B2EFF16 0000FFFF
	s_mov_b32 s5, s21                                          // 0000006C9084: BE850015
	s_mov_b32 m0, 0xe90                                        // 0000006C9088: BEFD00FF 00000E90
	v_mov_b32_e32 v72, v0                                      // 0000006C9090: 7E900300
	s_mov_b32 vcc_hi, 0                                        // 0000006C9094: BEEB0080
	s_lshr_b32 s52, s11, 16                                    // 0000006C9098: 8534900B
	s_ctz_i32_b32 s52, s52                                     // 0000006C909C: BEB40834
	s_lshr_b32 s53, s11, 22                                    // 0000006C90A0: 8535960B
	s_cmp_gt_i32 s52, 0                                        // 0000006C90A4: BF028034
	s_cbranch_scc0 label_skip_WGMXCC                           // 0000006C90A8: BFA1003D
	s_lshr_b32 s49, s23, s52                                   // 0000006C90AC: 85313417
	s_lshl_b32 s49, s49, s52                                   // 0000006C90B0: 84313431
	s_cmp_ge_u32 s2, s49                                       // 0000006C90B4: BF093102
	s_cbranch_scc1 label_skip_WGMXCC                           // 0000006C90B8: BFA20039
	s_cmp_eq_u32 s53, 0                                        // 0000006C90BC: BF068035
	s_cbranch_scc0 label_XCCG_nonzero                          // 0000006C90C0: BFA10007
	s_lshr_b32 s49, s2, s52                                    // 0000006C90C4: 85313402
	s_bfm_b32 s50, s52, 0                                      // 0000006C90C8: 95328034
	s_and_b32 s50, s2, s50                                     // 0000006C90CC: 8B323202
	s_lshr_b32 s51, s23, s52                                   // 0000006C90D0: 85333417
	s_mul_i32 s50, s50, s51                                    // 0000006C90D4: 96323332
	s_add_u32 s2, s49, s50                                     // 0000006C90D8: 80023231
	s_branch label_skip_WGMXCC                                 // 0000006C90DC: BFA00030

<label_XCCG_nonzero>:
	v_cvt_f64_u32_e32 v[16:17], s53                            // 0000006C90E0: 7E202C35
	v_rcp_f64_e32 v[16:17], v[16:17]                           // 0000006C90E4: 7E205F10
	v_cvt_f64_u32_e32 v[18:19], s2                             // 0000006C90E8: 7E242C02
	v_mul_f64 v[16:17], v[16:17], v[18:19]                     // 0000006C90EC: D7280010 02022510
	v_cvt_u32_f64_e32 v16, v[16:17]                            // 0000006C90F4: 7E202B10
	v_mul_lo_u32 v17, v16, s53                                 // 0000006C90F8: D72C0011 02006B10
	v_sub_nc_u32_e32 v18, s2, v17                              // 0000006C9100: 4C242202
	v_cmp_ge_u32_e64 vcc_lo, v18, s53                          // 0000006C9104: D44E006A 02006B12
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C910C: BEFE006A
	v_add_nc_u32_e64 v16, v16, 1                               // 0000006C9110: D5250010 02010310
	s_mov_b32 exec_lo, -1                                      // 0000006C9118: BEFE00C1
	v_mul_lo_u32 v17, v16, s53                                 // 0000006C911C: D72C0011 02006B10
	v_sub_nc_u32_e32 v18, s2, v17                              // 0000006C9124: 4C242202
	v_readfirstlane_b32 s49, v16                               // 0000006C9128: 7E620510
	v_readfirstlane_b32 s50, v18                               // 0000006C912C: 7E640512
	s_mul_i32 s49, s49, s53                                    // 0000006C9130: 96313531
	s_lshr_b32 s50, s50, s52                                   // 0000006C9134: 85323432
	s_add_u32 s49, s49, s50                                    // 0000006C9138: 80313231
	v_cvt_f64_u32_e32 v[16:17], s53                            // 0000006C913C: 7E202C35
	v_rcp_f64_e32 v[16:17], v[16:17]                           // 0000006C9140: 7E205F10
	v_cvt_f64_u32_e32 v[18:19], s23                            // 0000006C9144: 7E242C17
	v_mul_f64 v[16:17], v[16:17], v[18:19]                     // 0000006C9148: D7280010 02022510
	v_cvt_u32_f64_e32 v16, v[16:17]                            // 0000006C9150: 7E202B10
	v_mul_lo_u32 v17, v16, s53                                 // 0000006C9154: D72C0011 02006B10
	v_sub_nc_u32_e32 v18, s23, v17                             // 0000006C915C: 4C242217
	v_cmp_ge_u32_e64 vcc_lo, v18, s53                          // 0000006C9160: D44E006A 02006B12
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C9168: BEFE006A
	v_add_nc_u32_e64 v16, v16, 1                               // 0000006C916C: D5250010 02010310
	s_mov_b32 exec_lo, -1                                      // 0000006C9174: BEFE00C1
	v_readfirstlane_b32 s50, v16                               // 0000006C9178: 7E640510
	s_mul_i32 s50, s50, s53                                    // 0000006C917C: 96323532
	s_sub_u32 s51, s23, s50                                    // 0000006C9180: 80B33217
	s_cmp_gt_u32 s2, s50                                       // 0000006C9184: BF083202
	s_cselect_b32 s50, s51, s53                                // 0000006C9188: 98323533
	s_lshr_b32 s50, s50, s52                                   // 0000006C918C: 85323432
	s_bfm_b32 s51, s52, 0                                      // 0000006C9190: 95338034
	s_and_b32 s51, s2, s51                                     // 0000006C9194: 8B333302
	s_mul_i32 s50, s50, s51                                    // 0000006C9198: 96323332
	s_add_u32 s2, s49, s50                                     // 0000006C919C: 80023231

<label_skip_WGMXCC>:
	s_cmp_eq_u32 s21, 3                                        // 0000006C91A0: BF068315
	s_cbranch_scc1 label_ArgType3_Routed_To_ArgType0           // 0000006C91A4: BFA20002
	s_cmp_eq_u32 s21, 0                                        // 0000006C91A8: BF068015
	s_cbranch_scc0 label_MultiGemm                             // 0000006C91AC: BFA1008A

<label_ArgType3_Routed_To_ArgType0>:
	v_and_b32_e32 v1, 31, v72                                  // 0000006C91B0: 3602909F
	v_and_b32_e32 v0, 15, v1                                   // 0000006C91B4: 3600028F
	v_lshrrev_b32_e32 v4, 5, v72                               // 0000006C91B8: 32089085
	v_and_b32_e32 v4, 1, v4                                    // 0000006C91BC: 36080881
	v_lshl_add_u32 v0, v4, 4, v0                               // 0000006C91C0: D6460000 04010904
	v_and_b32_e32 v2, 31, v72                                  // 0000006C91C8: 3604909F
	v_and_b32_e32 v1, 15, v2                                   // 0000006C91CC: 3602048F
	v_lshrrev_b32_e32 v2, 5, v72                               // 0000006C91D0: 32049085
	v_lshrrev_b32_e32 v2, 1, v2                                // 0000006C91D4: 32040481
	s_mov_b32 s16, 0x200                                       // 0000006C91D8: BE9000FF 00000200
	v_mul_lo_u32 v2, s16, v2                                   // 0000006C91E0: D72C0002 02020410
	v_add_nc_u32_e32 v12, v2, v0                               // 0000006C91E8: 4A180102
	v_lshlrev_b32_e32 v12, 1, v12                              // 0000006C91EC: 30181881
	v_lshrrev_b32_e32 v3, 10, v12                              // 0000006C91F0: 3206188A
	v_lshl_add_u32 v12, v3, 4, v12                             // 0000006C91F4: D646000C 04310903
	v_lshrrev_b32_e32 v0, 5, v72                               // 0000006C91FC: 32009085
	v_lshrrev_b32_e32 v0, 1, v0                                // 0000006C9200: 32000081
	s_mov_b32 s16, 0x100                                       // 0000006C9204: BE9000FF 00000100
	v_mul_lo_u32 v0, s16, v0                                   // 0000006C920C: D72C0000 02020010
	v_add_nc_u32_e32 v13, v0, v1                               // 0000006C9214: 4A1A0300
	v_lshlrev_b32_e32 v13, 1, v13                              // 0000006C9218: 301A1A81
	v_lshrrev_b32_e32 v2, 9, v13                               // 0000006C921C: 32041A89
	v_lshl_add_u32 v13, v2, 4, v13                             // 0000006C9220: D646000D 04350902
	v_add_co_u32 v13, vcc_lo, 0x480, v13                       // 0000006C9228: D7006A0D 02021AFF 00000480
	v_lshrrev_b32_e32 v1, 2, v72                               // 0000006C9234: 32029082
	v_and_b32_e32 v0, 3, v72                                   // 0000006C9238: 36009083
	v_lshlrev_b32_e32 v0, 3, v0                                // 0000006C923C: 30000083
	v_mov_b32_e32 v4, v1                                       // 0000006C9240: 7E080301
	v_lshrrev_b32_e32 v2, 2, v72                               // 0000006C9244: 32049082
	v_and_b32_e32 v3, 3, v72                                   // 0000006C9248: 36069083
	v_lshlrev_b32_e32 v3, 2, v3                                // 0000006C924C: 30060682
	v_mov_b32_e32 v5, v3                                       // 0000006C9250: 7E0A0303
	v_mul_u32_u24_e32 v10, 32, v4                              // 0000006C9254: 161408A0
	v_add_nc_u32_e32 v10, v0, v10                              // 0000006C9258: 4A141500
	v_lshlrev_b32_e32 v10, 1, v10                              // 0000006C925C: 30141481
	v_lshrrev_b32_e32 v6, 10, v10                              // 0000006C9260: 320C148A
	v_lshl_add_u32 v10, v6, 4, v10                             // 0000006C9264: D646000A 04290906
	v_mul_u32_u24_e32 v11, 16, v5                              // 0000006C926C: 16160A90
	v_add_nc_u32_e32 v11, v2, v11                              // 0000006C9270: 4A161702
	v_lshlrev_b32_e32 v11, 1, v11                              // 0000006C9274: 30161681
	v_lshrrev_b32_e32 v6, 9, v11                               // 0000006C9278: 320C1689
	v_lshl_add_u32 v11, v6, 4, v11                             // 0000006C927C: D646000B 042D0906
	v_add_co_u32 v11, vcc_lo, 0x480, v11                       // 0000006C9284: D7006A0B 020216FF 00000480
	s_waitcnt lgkmcnt(0)                                       // 0000006C9290: BF89FC07
	v_mov_b32_e32 v18, 32                                      // 0000006C9294: 7E2402A0
	v_mov_b32_e32 v17, s24                                     // 0000006C9298: 7E220218
	v_cvt_f32_u32_e32 v16, v18                                 // 0000006C929C: 7E200D12
	v_rcp_iflag_f32_e32 v16, v16                               // 0000006C92A0: 7E205710
	v_cvt_f32_u32_e32 v19, v17                                 // 0000006C92A4: 7E260D11
	v_mul_f32_e32 v16, v16, v19                                // 0000006C92A8: 10202710
	v_cvt_u32_f32_e32 v16, v16                                 // 0000006C92AC: 7E200F10
	v_mul_u32_u24_e32 v19, v16, v18                            // 0000006C92B0: 16262510
	v_sub_nc_u32_e32 v19, v17, v19                             // 0000006C92B4: 4C262711
	v_cmp_ne_u32_e64 vcc_lo, v19, 0                            // 0000006C92B8: D44D006A 02010113
	v_add_co_ci_u32_e64 v16, vcc_lo, v16, 0, vcc_lo            // 0000006C92C0: D5206A10 01A90110
	v_mov_b32_e32 v18, 16                                      // 0000006C92C8: 7E240290
	v_mov_b32_e32 v17, s25                                     // 0000006C92CC: 7E220219
	v_readfirstlane_b32 s14, v16                               // 0000006C92D0: 7E1C0510
	v_cvt_f32_u32_e32 v16, v18                                 // 0000006C92D4: 7E200D12
	v_rcp_iflag_f32_e32 v16, v16                               // 0000006C92D8: 7E205710
	v_cvt_f32_u32_e32 v19, v17                                 // 0000006C92DC: 7E260D11
	v_mul_f32_e32 v16, v16, v19                                // 0000006C92E0: 10202710
	v_cvt_u32_f32_e32 v16, v16                                 // 0000006C92E4: 7E200F10
	v_mul_u32_u24_e32 v19, v16, v18                            // 0000006C92E8: 16262510
	v_sub_nc_u32_e32 v19, v17, v19                             // 0000006C92EC: 4C262711
	v_cmp_ne_u32_e64 vcc_lo, v19, 0                            // 0000006C92F0: D44D006A 02010113
	v_add_co_ci_u32_e64 v16, vcc_lo, v16, 0, vcc_lo            // 0000006C92F8: D5206A10 01A90110
	v_readfirstlane_b32 s15, v16                               // 0000006C9300: 7E1E0510
	s_mul_i32 s16, s14, s15                                    // 0000006C9304: 96100F0E
	s_and_b32 s17, s46, 0x3fff                                 // 0000006C9308: 8B11FF2E 00003FFF
	s_mul_i32 s16, s16, s17                                    // 0000006C9310: 96101110
	v_cvt_f32_u32_e32 v6, s16                                  // 0000006C9314: 7E0C0C10
	v_rcp_iflag_f32_e32 v6, v6                                 // 0000006C9318: 7E0C5706
	v_cvt_f32_u32_e32 v7, s2                                   // 0000006C931C: 7E0E0C02
	v_mul_f32_e32 v6, v6, v7                                   // 0000006C9320: 100C0F06
	v_cvt_u32_f32_e32 v6, v6                                   // 0000006C9324: 7E0C0F06
	v_mul_u32_u24_e64 v7, v6, s16                              // 0000006C9328: D50B0007 02002106
	v_sub_nc_u32_e32 v7, s2, v7                                // 0000006C9330: 4C0E0E02
	v_cmp_eq_u32_e64 vcc_lo, v7, s16                           // 0000006C9334: D44A006A 02002107
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C933C: BEFE006A
	v_add_nc_u32_e32 v6, 1, v6                                 // 0000006C9340: 4A0C0C81
	s_mov_b32 exec_lo, -1                                      // 0000006C9344: BEFE00C1
	v_cmp_gt_u32_e64 vcc_lo, v7, s16                           // 0000006C9348: D44C006A 02002107
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C9350: BEFE006A
	v_sub_nc_u32_e64 v6, v6, 1                                 // 0000006C9354: D5260006 02010306
	s_mov_b32 exec_lo, -1                                      // 0000006C935C: BEFE00C1
	v_readfirstlane_b32 s16, v6                                // 0000006C9360: 7E200506
	s_mov_b32 s4, s16                                          // 0000006C9364: BE840010
	s_mul_i32 s16, s15, s14                                    // 0000006C9368: 96100E0F
	s_mul_i32 s16, s16, s4                                     // 0000006C936C: 96100410
	s_mul_i32 s16, s16, s17                                    // 0000006C9370: 96101110
	s_sub_u32 s2, s2, s16                                      // 0000006C9374: 80821002
	v_cvt_f32_u32_e32 v6, s14                                  // 0000006C9378: 7E0C0C0E
	v_rcp_iflag_f32_e32 v6, v6                                 // 0000006C937C: 7E0C5706
	v_cvt_f32_u32_e32 v7, s2                                   // 0000006C9380: 7E0E0C02
	v_mul_f32_e32 v6, v6, v7                                   // 0000006C9384: 100C0F06
	v_cvt_u32_f32_e32 v6, v6                                   // 0000006C9388: 7E0C0F06
	v_mul_u32_u24_e64 v7, v6, s14                              // 0000006C938C: D50B0007 02001D06
	v_sub_nc_u32_e32 v7, s2, v7                                // 0000006C9394: 4C0E0E02
	v_cmp_eq_u32_e64 vcc_lo, v7, s14                           // 0000006C9398: D44A006A 02001D07
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C93A0: BEFE006A
	v_add_nc_u32_e32 v6, 1, v6                                 // 0000006C93A4: 4A0C0C81
	s_mov_b32 exec_lo, -1                                      // 0000006C93A8: BEFE00C1
	v_cmp_gt_u32_e64 vcc_lo, v7, s14                           // 0000006C93AC: D44C006A 02001D07
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C93B4: BEFE006A
	v_sub_nc_u32_e64 v6, v6, 1                                 // 0000006C93B8: D5260006 02010306
	s_mov_b32 exec_lo, -1                                      // 0000006C93C0: BEFE00C1
	v_readfirstlane_b32 s16, v6                                // 0000006C93C4: 7E200506
	s_mov_b32 s3, s16                                          // 0000006C93C8: BE830010
	s_mul_i32 s16, s3, s14                                     // 0000006C93CC: 96100E03
	s_sub_u32 s2, s2, s16                                      // 0000006C93D0: 80821002
	s_branch label_MultiGemmEnd                                // 0000006C93D4: BFA000DC

<label_MultiGemm>:
	s_cmp_eq_u32 s5, 2                                         // 0000006C93D8: BF068205
	s_cbranch_scc1 label_IsExternalValid                       // 0000006C93DC: BFA20005
	s_mov_b32 s15, 0x7c                                        // 0000006C93E0: BE8F00FF 0000007C
	s_mul_i32 s54, s20, 4                                      // 0000006C93E8: 96368414
	s_mov_b64 s[48:49], s[0:1]                                 // 0000006C93EC: BEB00100
	s_branch label_IsExternalValidEnd                          // 0000006C93F0: BFA00004

<label_IsExternalValid>:
	s_mov_b32 s15, 0xc4                                        // 0000006C93F4: BE8F00FF 000000C4
	s_mov_b32 s54, 0                                           // 0000006C93FC: BEB60080
	s_mov_b64 s[48:49], s[0:1]                                 // 0000006C9400: BEB00100

<label_IsExternalValidEnd>:
	s_mov_b32 s14, 1                                           // 0000006C9404: BE8E0081
	s_mov_b32 s55, 0                                           // 0000006C9408: BEB70080
	s_load_b128 s[24:27], s[48:49], s54                        // 0000006C940C: F4080618 6C000000
	s_cmpk_eq_u32 s20, 0x1                                     // 0000006C9414: B4940001
	s_cbranch_scc1 label_wgTable_noLoadLoop                    // 0000006C9418: BFA20015

<label_Loop_GemmCount>:
	s_waitcnt lgkmcnt(0)                                       // 0000006C941C: BF89FC07
	s_lshr_b32 s52, s24, 5                                     // 0000006C9420: 85348518
	s_and_b32 s50, 31, s24                                     // 0000006C9424: 8B32189F
	s_addc_u32 s52, s52, 0                                     // 0000006C9428: 82348034
	s_lshr_b32 s53, s25, 4                                     // 0000006C942C: 85358419
	s_and_b32 s50, 15, s25                                     // 0000006C9430: 8B32198F
	s_addc_u32 s53, s53, 0                                     // 0000006C9434: 82358035
	s_mul_i32 s52, s52, s53                                    // 0000006C9438: 96343534
	s_mul_i32 s52, s52, s26                                    // 0000006C943C: 96341A34
	s_and_b32 s53, s46, 0x3fff                                 // 0000006C9440: 8B35FF2E 00003FFF
	s_mul_i32 s52, s52, s53                                    // 0000006C9448: 96343534
	s_add_u32 s55, s55, s52                                    // 0000006C944C: 80373437
	s_cmp_lt_u32 s2, s55                                       // 0000006C9450: BF0A3702
	s_cbranch_scc1 label_FOUND                                 // 0000006C9454: BFA20013
	s_add_u32 s54, s54, s15                                    // 0000006C9458: 80360F36
	s_load_b128 s[24:27], s[48:49], s54                        // 0000006C945C: F4080618 6C000000
	s_add_u32 s14, s14, 1                                      // 0000006C9464: 800E810E
	s_cmp_lt_u32 s14, s20                                      // 0000006C9468: BF0A140E
	s_cbranch_scc1 label_Loop_GemmCount                        // 0000006C946C: BFA2FFEB

<label_wgTable_noLoadLoop>:
	s_waitcnt lgkmcnt(0)                                       // 0000006C9470: BF89FC07
	s_lshr_b32 s52, s24, 5                                     // 0000006C9474: 85348518
	s_and_b32 s50, 31, s24                                     // 0000006C9478: 8B32189F
	s_addc_u32 s52, s52, 0                                     // 0000006C947C: 82348034
	s_lshr_b32 s53, s25, 4                                     // 0000006C9480: 85358419
	s_and_b32 s50, 15, s25                                     // 0000006C9484: 8B32198F
	s_addc_u32 s53, s53, 0                                     // 0000006C9488: 82358035
	s_mul_i32 s52, s52, s53                                    // 0000006C948C: 96343534
	s_mul_i32 s52, s52, s26                                    // 0000006C9490: 96341A34
	s_and_b32 s48, s46, 0x3fff                                 // 0000006C9494: 8B30FF2E 00003FFF
	s_mul_i32 s52, s52, s48                                    // 0000006C949C: 96343034
	s_add_u32 s55, s55, s52                                    // 0000006C94A0: 80373437

<label_FOUND>:
	s_sub_u32 s49, s14, 1                                      // 0000006C94A4: 80B1810E
	s_sub_u32 s48, s55, s52                                    // 0000006C94A8: 80B03437
	s_sub_u32 s2, s2, s48                                      // 0000006C94AC: 80823002
	s_cmp_eq_u32 s5, 2                                         // 0000006C94B0: BF068205
	s_cbranch_scc1 label_LoadExternalStruct                    // 0000006C94B4: BFA2000B
	s_lshl2_add_u32 s0, s20, s0                                // 0000006C94B8: 87800014
	s_addc_u32 s1, s1, 0                                       // 0000006C94BC: 82018001
	s_mul_i32 s49, s49, 0x7c                                   // 0000006C94C0: 9631FF31 0000007C
	s_add_u32 s0, s0, s49                                      // 0000006C94C8: 80003100
	s_addc_u32 s1, s1, 0                                       // 0000006C94CC: 82018001
	s_load_b512 s[28:43], s[0:1], 0x10                         // 0000006C94D0: F4100700 F8000010
	s_load_b64 s[44:45], s[0:1], 0x50                          // 0000006C94D8: F4040B00 F8000050
	s_branch label_LoadExternalStructEnd                       // 0000006C94E0: BFA0000A

<label_LoadExternalStruct>:
	s_mul_i32 s49, s49, 0xc4                                   // 0000006C94E4: 9631FF31 000000C4
	s_add_u32 s0, s0, s49                                      // 0000006C94EC: 80003100
	s_addc_u32 s1, s1, 0                                       // 0000006C94F0: 82018001
	s_load_b512 s[28:43], s[0:1], 0x10                         // 0000006C94F4: F4100700 F8000010
	s_load_b32 s44, s[0:1], 0x50                               // 0000006C94FC: F4000B00 F8000050
	s_load_b32 s45, s[0:1], 0x60                               // 0000006C9504: F4000B40 F8000060

<label_LoadExternalStructEnd>:
	v_and_b32_e32 v1, 31, v72                                  // 0000006C950C: 3602909F
	v_and_b32_e32 v0, 15, v1                                   // 0000006C9510: 3600028F
	v_lshrrev_b32_e32 v4, 5, v72                               // 0000006C9514: 32089085
	v_and_b32_e32 v4, 1, v4                                    // 0000006C9518: 36080881
	v_lshl_add_u32 v0, v4, 4, v0                               // 0000006C951C: D6460000 04010904
	v_and_b32_e32 v2, 31, v72                                  // 0000006C9524: 3604909F
	v_and_b32_e32 v1, 15, v2                                   // 0000006C9528: 3602048F
	v_lshrrev_b32_e32 v2, 5, v72                               // 0000006C952C: 32049085
	v_lshrrev_b32_e32 v2, 1, v2                                // 0000006C9530: 32040481
	s_mov_b32 s16, 0x200                                       // 0000006C9534: BE9000FF 00000200
	v_mul_lo_u32 v2, s16, v2                                   // 0000006C953C: D72C0002 02020410
	v_add_nc_u32_e32 v12, v2, v0                               // 0000006C9544: 4A180102
	v_lshlrev_b32_e32 v12, 1, v12                              // 0000006C9548: 30181881
	v_lshrrev_b32_e32 v3, 10, v12                              // 0000006C954C: 3206188A
	v_lshl_add_u32 v12, v3, 4, v12                             // 0000006C9550: D646000C 04310903
	v_lshrrev_b32_e32 v0, 5, v72                               // 0000006C9558: 32009085
	v_lshrrev_b32_e32 v0, 1, v0                                // 0000006C955C: 32000081
	s_mov_b32 s16, 0x100                                       // 0000006C9560: BE9000FF 00000100
	v_mul_lo_u32 v0, s16, v0                                   // 0000006C9568: D72C0000 02020010
	v_add_nc_u32_e32 v13, v0, v1                               // 0000006C9570: 4A1A0300
	v_lshlrev_b32_e32 v13, 1, v13                              // 0000006C9574: 301A1A81
	v_lshrrev_b32_e32 v2, 9, v13                               // 0000006C9578: 32041A89
	v_lshl_add_u32 v13, v2, 4, v13                             // 0000006C957C: D646000D 04350902
	v_add_co_u32 v13, vcc_lo, 0x480, v13                       // 0000006C9584: D7006A0D 02021AFF 00000480
	v_lshrrev_b32_e32 v1, 2, v72                               // 0000006C9590: 32029082
	v_and_b32_e32 v0, 3, v72                                   // 0000006C9594: 36009083
	v_lshlrev_b32_e32 v0, 3, v0                                // 0000006C9598: 30000083
	v_mov_b32_e32 v4, v1                                       // 0000006C959C: 7E080301
	v_lshrrev_b32_e32 v2, 2, v72                               // 0000006C95A0: 32049082
	v_and_b32_e32 v3, 3, v72                                   // 0000006C95A4: 36069083
	v_lshlrev_b32_e32 v3, 2, v3                                // 0000006C95A8: 30060682
	v_mov_b32_e32 v5, v3                                       // 0000006C95AC: 7E0A0303
	v_mul_u32_u24_e32 v10, 32, v4                              // 0000006C95B0: 161408A0
	v_add_nc_u32_e32 v10, v0, v10                              // 0000006C95B4: 4A141500
	v_lshlrev_b32_e32 v10, 1, v10                              // 0000006C95B8: 30141481
	v_lshrrev_b32_e32 v6, 10, v10                              // 0000006C95BC: 320C148A
	v_lshl_add_u32 v10, v6, 4, v10                             // 0000006C95C0: D646000A 04290906
	v_mul_u32_u24_e32 v11, 16, v5                              // 0000006C95C8: 16160A90
	v_add_nc_u32_e32 v11, v2, v11                              // 0000006C95CC: 4A161702
	v_lshlrev_b32_e32 v11, 1, v11                              // 0000006C95D0: 30161681
	v_lshrrev_b32_e32 v6, 9, v11                               // 0000006C95D4: 320C1689
	v_lshl_add_u32 v11, v6, 4, v11                             // 0000006C95D8: D646000B 042D0906
	v_add_co_u32 v11, vcc_lo, 0x480, v11                       // 0000006C95E0: D7006A0B 020216FF 00000480
	s_waitcnt lgkmcnt(0)                                       // 0000006C95EC: BF89FC07
	v_mov_b32_e32 v18, 32                                      // 0000006C95F0: 7E2402A0
	v_mov_b32_e32 v17, s24                                     // 0000006C95F4: 7E220218
	v_cvt_f32_u32_e32 v16, v18                                 // 0000006C95F8: 7E200D12
	v_rcp_iflag_f32_e32 v16, v16                               // 0000006C95FC: 7E205710
	v_cvt_f32_u32_e32 v19, v17                                 // 0000006C9600: 7E260D11
	v_mul_f32_e32 v16, v16, v19                                // 0000006C9604: 10202710
	v_cvt_u32_f32_e32 v16, v16                                 // 0000006C9608: 7E200F10
	v_mul_u32_u24_e32 v19, v16, v18                            // 0000006C960C: 16262510
	v_sub_nc_u32_e32 v19, v17, v19                             // 0000006C9610: 4C262711
	v_cmp_ne_u32_e64 vcc_lo, v19, 0                            // 0000006C9614: D44D006A 02010113
	v_add_co_ci_u32_e64 v16, vcc_lo, v16, 0, vcc_lo            // 0000006C961C: D5206A10 01A90110
	v_mov_b32_e32 v18, 16                                      // 0000006C9624: 7E240290
	v_mov_b32_e32 v17, s25                                     // 0000006C9628: 7E220219
	v_readfirstlane_b32 s14, v16                               // 0000006C962C: 7E1C0510
	v_cvt_f32_u32_e32 v16, v18                                 // 0000006C9630: 7E200D12
	v_rcp_iflag_f32_e32 v16, v16                               // 0000006C9634: 7E205710
	v_cvt_f32_u32_e32 v19, v17                                 // 0000006C9638: 7E260D11
	v_mul_f32_e32 v16, v16, v19                                // 0000006C963C: 10202710
	v_cvt_u32_f32_e32 v16, v16                                 // 0000006C9640: 7E200F10
	v_mul_u32_u24_e32 v19, v16, v18                            // 0000006C9644: 16262510
	v_sub_nc_u32_e32 v19, v17, v19                             // 0000006C9648: 4C262711
	v_cmp_ne_u32_e64 vcc_lo, v19, 0                            // 0000006C964C: D44D006A 02010113
	v_add_co_ci_u32_e64 v16, vcc_lo, v16, 0, vcc_lo            // 0000006C9654: D5206A10 01A90110
	v_readfirstlane_b32 s15, v16                               // 0000006C965C: 7E1E0510
	s_cmp_eq_u32 s25, 0                                        // 0000006C9660: BF068019
	s_cbranch_scc0 label_NoEarlyStop_N0                        // 0000006C9664: BFA10001

<label_EarlyStop_if_N_is_0>:
	s_endpgm                                                   // 0000006C9668: BFB00000

<label_NoEarlyStop_N0>:
	s_mul_i32 s16, s14, s15                                    // 0000006C966C: 96100F0E
	s_and_b32 s17, s46, 0x3fff                                 // 0000006C9670: 8B11FF2E 00003FFF
	s_mul_i32 s16, s16, s17                                    // 0000006C9678: 96101110
	v_cvt_f32_u32_e32 v6, s16                                  // 0000006C967C: 7E0C0C10
	v_rcp_iflag_f32_e32 v6, v6                                 // 0000006C9680: 7E0C5706
	v_cvt_f32_u32_e32 v7, s2                                   // 0000006C9684: 7E0E0C02
	v_mul_f32_e32 v6, v6, v7                                   // 0000006C9688: 100C0F06
	v_cvt_u32_f32_e32 v6, v6                                   // 0000006C968C: 7E0C0F06
	v_mul_u32_u24_e64 v7, v6, s16                              // 0000006C9690: D50B0007 02002106
	v_sub_nc_u32_e32 v7, s2, v7                                // 0000006C9698: 4C0E0E02
	v_cmp_eq_u32_e64 vcc_lo, v7, s16                           // 0000006C969C: D44A006A 02002107
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C96A4: BEFE006A
	v_add_nc_u32_e32 v6, 1, v6                                 // 0000006C96A8: 4A0C0C81
	s_mov_b32 exec_lo, -1                                      // 0000006C96AC: BEFE00C1
	v_cmp_gt_u32_e64 vcc_lo, v7, s16                           // 0000006C96B0: D44C006A 02002107
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C96B8: BEFE006A
	v_sub_nc_u32_e64 v6, v6, 1                                 // 0000006C96BC: D5260006 02010306
	s_mov_b32 exec_lo, -1                                      // 0000006C96C4: BEFE00C1
	v_readfirstlane_b32 s16, v6                                // 0000006C96C8: 7E200506
	s_mov_b32 s4, s16                                          // 0000006C96CC: BE840010
	s_mul_i32 s16, s15, s14                                    // 0000006C96D0: 96100E0F
	s_mul_i32 s16, s16, s4                                     // 0000006C96D4: 96100410
	s_mul_i32 s16, s16, s17                                    // 0000006C96D8: 96101110
	s_sub_u32 s2, s2, s16                                      // 0000006C96DC: 80821002
	v_cvt_f32_u32_e32 v6, s14                                  // 0000006C96E0: 7E0C0C0E
	v_rcp_iflag_f32_e32 v6, v6                                 // 0000006C96E4: 7E0C5706
	v_cvt_f32_u32_e32 v7, s2                                   // 0000006C96E8: 7E0E0C02
	v_mul_f32_e32 v6, v6, v7                                   // 0000006C96EC: 100C0F06
	v_cvt_u32_f32_e32 v6, v6                                   // 0000006C96F0: 7E0C0F06
	v_mul_u32_u24_e64 v7, v6, s14                              // 0000006C96F4: D50B0007 02001D06
	v_sub_nc_u32_e32 v7, s2, v7                                // 0000006C96FC: 4C0E0E02
	v_cmp_eq_u32_e64 vcc_lo, v7, s14                           // 0000006C9700: D44A006A 02001D07
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C9708: BEFE006A
	v_add_nc_u32_e32 v6, 1, v6                                 // 0000006C970C: 4A0C0C81
	s_mov_b32 exec_lo, -1                                      // 0000006C9710: BEFE00C1
	v_cmp_gt_u32_e64 vcc_lo, v7, s14                           // 0000006C9714: D44C006A 02001D07
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C971C: BEFE006A
	v_sub_nc_u32_e64 v6, v6, 1                                 // 0000006C9720: D5260006 02010306
	s_mov_b32 exec_lo, -1                                      // 0000006C9728: BEFE00C1
	v_readfirstlane_b32 s16, v6                                // 0000006C972C: 7E200506
	s_mov_b32 s3, s16                                          // 0000006C9730: BE830010
	s_mul_i32 s16, s3, s14                                     // 0000006C9734: 96100E03
	s_sub_u32 s2, s2, s16                                      // 0000006C9738: 80821002
	s_cmp_ge_u32 s4, s26                                       // 0000006C973C: BF091A04
	s_cbranch_scc0 label_MultiGemmEnd                          // 0000006C9740: BFA10001

<label_EarlyStop_if_wg_exceed>:
	s_endpgm                                                   // 0000006C9744: BFB00000

<label_NoEarlyStop_wgExceed>:
	s_cmp_eq_u32 s5, 3                                         // 0000006C9748: BF068305
	s_cbranch_scc1 label_Skip_Address_Prepad_For_Pointer_Array // 0000006C974C: BFA20004
	s_sub_u32 s32, s32, 16                                     // 0000006C9750: 80A09020
	s_subb_u32 s33, s33, 0                                     // 0000006C9754: 82A18021
	s_sub_u32 s34, s34, 8                                      // 0000006C9758: 80A28822
	s_subb_u32 s35, s35, 0                                     // 0000006C975C: 82A38023

<label_Skip_Address_Prepad_For_Pointer_Array>:
	v_cmp_eq_f32_e64 vcc_lo, s44, 0                            // 0000006C9760: D412006A 0201002C
	s_cbranch_vccz label_AlphaNonZero                          // 0000006C9768: BFA30001
	s_mov_b32 s27, 0                                           // 0000006C976C: BE9B0080

<label_AlphaNonZero>:
	s_and_b32 s16, s46, 0x3fff                                 // 0000006C9770: 8B10FF2E 00003FFF
	s_cmp_eq_u32 s16, 1                                        // 0000006C9778: BF068110
	s_cbranch_scc1 label_GSU                                   // 0000006C977C: BFA2003B
	s_and_b32 s16, s46, 0x4000                                 // 0000006C9780: 8B10FF2E 00004000
	s_cbranch_scc1 label_GSUWGMRR                              // 0000006C9788: BFA2001C
	s_and_b32 s16, s46, 0x3fff                                 // 0000006C978C: 8B10FF2E 00003FFF
	v_cvt_f32_u32_e32 v6, s16                                  // 0000006C9794: 7E0C0C10
	v_rcp_iflag_f32_e32 v6, v6                                 // 0000006C9798: 7E0C5706
	v_cvt_f32_u32_e32 v7, s3                                   // 0000006C979C: 7E0E0C03
	v_mul_f32_e32 v6, v6, v7                                   // 0000006C97A0: 100C0F06
	v_cvt_u32_f32_e32 v6, v6                                   // 0000006C97A4: 7E0C0F06
	v_mul_u32_u24_e64 v7, v6, s16                              // 0000006C97A8: D50B0007 02002106
	v_sub_nc_u32_e32 v7, s3, v7                                // 0000006C97B0: 4C0E0E03
	v_cmp_eq_u32_e64 vcc_lo, v7, s16                           // 0000006C97B4: D44A006A 02002107
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C97BC: BEFE006A
	v_add_nc_u32_e32 v6, 1, v6                                 // 0000006C97C0: 4A0C0C81
	v_mov_b32_e32 v7, 0                                        // 0000006C97C4: 7E0E0280
	s_mov_b32 exec_lo, -1                                      // 0000006C97C8: BEFE00C1
	v_cmp_gt_u32_e64 vcc_lo, v7, s16                           // 0000006C97CC: D44C006A 02002107
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C97D4: BEFE006A
	v_sub_nc_u32_e64 v6, v6, 1                                 // 0000006C97D8: D5260006 02010306
	v_mul_u32_u24_e64 v7, v6, s16                              // 0000006C97E0: D50B0007 02002106
	v_sub_nc_u32_e32 v7, s3, v7                                // 0000006C97E8: 4C0E0E03
	s_mov_b32 exec_lo, -1                                      // 0000006C97EC: BEFE00C1
	v_readfirstlane_b32 s3, v6                                 // 0000006C97F0: 7E060506
	v_readfirstlane_b32 s6, v7                                 // 0000006C97F4: 7E0C0507
	s_branch label_GSUWGMRR_End                                // 0000006C97F8: BFA00019

<label_GSUWGMRR>:
	v_cvt_f32_u32_e32 v6, s15                                  // 0000006C97FC: 7E0C0C0F
	v_rcp_iflag_f32_e32 v6, v6                                 // 0000006C9800: 7E0C5706
	v_cvt_f32_u32_e32 v7, s3                                   // 0000006C9804: 7E0E0C03
	v_mul_f32_e32 v6, v6, v7                                   // 0000006C9808: 100C0F06
	v_cvt_u32_f32_e32 v6, v6                                   // 0000006C980C: 7E0C0F06
	v_mul_u32_u24_e64 v7, v6, s15                              // 0000006C9810: D50B0007 02001F06
	v_sub_nc_u32_e32 v7, s3, v7                                // 0000006C9818: 4C0E0E03
	v_cmp_eq_u32_e64 vcc_lo, v7, s15                           // 0000006C981C: D44A006A 02001F07
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C9824: BEFE006A
	v_add_nc_u32_e32 v6, 1, v6                                 // 0000006C9828: 4A0C0C81
	v_mov_b32_e32 v7, 0                                        // 0000006C982C: 7E0E0280
	s_mov_b32 exec_lo, -1                                      // 0000006C9830: BEFE00C1
	v_cmp_gt_u32_e64 vcc_lo, v7, s15                           // 0000006C9834: D44C006A 02001F07
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C983C: BEFE006A
	v_sub_nc_u32_e64 v6, v6, 1                                 // 0000006C9840: D5260006 02010306
	v_mul_u32_u24_e64 v7, v6, s15                              // 0000006C9848: D50B0007 02001F06
	v_sub_nc_u32_e32 v7, s3, v7                                // 0000006C9850: 4C0E0E03
	s_mov_b32 exec_lo, -1                                      // 0000006C9854: BEFE00C1
	v_readfirstlane_b32 s6, v6                                 // 0000006C9858: 7E0C0506
	v_readfirstlane_b32 s3, v7                                 // 0000006C985C: 7E060507

<label_GSUWGMRR_End>:
	s_mov_b32 s8, 1                                            // 0000006C9860: BE880081
	s_mov_b32 s9, 2                                            // 0000006C9864: BE890082
	s_branch label_GSU_End                                     // 0000006C9868: BFA00003

<label_GSU>:
	s_mov_b64 s[6:7], 0                                        // 0000006C986C: BE860180
	s_mov_b32 s8, 1                                            // 0000006C9870: BE880081
	s_mov_b32 s9, 1                                            // 0000006C9874: BE890081

<label_GSU_End>:
	s_mov_b32 s16, s11                                         // 0000006C9878: BE90000B
	s_sext_i32_i16 s16, s16                                    // 0000006C987C: BE900F10
	s_cmp_gt_i32 s16, 1                                        // 0000006C9880: BF028110
	s_cbranch_scc1 label_WGMPositive                           // 0000006C9884: BFA20046
	s_cmp_ge_i32 s16, 0                                        // 0000006C9888: BF038010
	s_cbranch_scc1 label_WGM                                   // 0000006C988C: BFA20087
	s_abs_i32 s16, s16                                         // 0000006C9890: BE901510
	v_cvt_f64_u32_e32 v[16:17], s16                            // 0000006C9894: 7E202C10
	v_rcp_f64_e32 v[16:17], v[16:17]                           // 0000006C9898: 7E205F10
	v_cvt_f64_u32_e32 v[18:19], s2                             // 0000006C989C: 7E242C02
	v_mul_f64 v[16:17], v[16:17], v[18:19]                     // 0000006C98A0: D7280010 02022510
	v_cvt_u32_f64_e32 v16, v[16:17]                            // 0000006C98A8: 7E202B10
	v_mul_lo_u32 v17, v16, s16                                 // 0000006C98AC: D72C0011 02002110
	v_sub_nc_u32_e32 v18, s2, v17                              // 0000006C98B4: 4C242202
	v_cmp_ge_u32_e64 vcc_lo, v18, s16                          // 0000006C98B8: D44E006A 02002112
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C98C0: BEFE006A
	v_add_nc_u32_e64 v16, v16, 1                               // 0000006C98C4: D5250010 02010310
	s_mov_b32 exec_lo, -1                                      // 0000006C98CC: BEFE00C1
	v_readfirstlane_b32 s17, v16                               // 0000006C98D0: 7E220510
	s_mul_i32 s20, s17, s16                                    // 0000006C98D4: 96141011
	s_sub_u32 s20, s2, s20                                     // 0000006C98D8: 80941402
	s_mul_i32 s20, s20, s15                                    // 0000006C98DC: 96140F14
	s_add_u32 s20, s20, s3                                     // 0000006C98E0: 80140314
	v_cvt_f64_u32_e32 v[16:17], s16                            // 0000006C98E4: 7E202C10
	v_rcp_f64_e32 v[16:17], v[16:17]                           // 0000006C98E8: 7E205F10
	v_cvt_f64_u32_e32 v[18:19], s14                            // 0000006C98EC: 7E242C0E
	v_mul_f64 v[16:17], v[16:17], v[18:19]                     // 0000006C98F0: D7280010 02022510
	v_cvt_u32_f64_e32 v16, v[16:17]                            // 0000006C98F8: 7E202B10
	v_mul_lo_u32 v17, v16, s16                                 // 0000006C98FC: D72C0011 02002110
	v_sub_nc_u32_e32 v18, s14, v17                             // 0000006C9904: 4C24220E
	v_cmp_ge_u32_e64 vcc_lo, v18, s16                          // 0000006C9908: D44E006A 02002112
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C9910: BEFE006A
	v_add_nc_u32_e64 v16, v16, 1                               // 0000006C9914: D5250010 02010310
	s_mov_b32 exec_lo, -1                                      // 0000006C991C: BEFE00C1
	v_readfirstlane_b32 s18, v16                               // 0000006C9920: 7E240510
	s_mul_i32 s19, s16, s18                                    // 0000006C9924: 96131210
	s_sub_u32 s19, s14, s19                                    // 0000006C9928: 8093130E
	s_cmp_eq_u32 s19, 0                                        // 0000006C992C: BF068013
	s_cmov_b32 s19, s16                                        // 0000006C9930: BE930210
	s_cmp_ge_u32 s17, s18                                      // 0000006C9934: BF091211
	s_cselect_b32 s18, s19, s16                                // 0000006C9938: 98121013
	v_cvt_f64_u32_e32 v[16:17], s18                            // 0000006C993C: 7E202C12
	v_rcp_f64_e32 v[16:17], v[16:17]                           // 0000006C9940: 7E205F10
	v_cvt_f64_u32_e32 v[18:19], s20                            // 0000006C9944: 7E242C14
	v_mul_f64 v[16:17], v[16:17], v[18:19]                     // 0000006C9948: D7280010 02022510
	v_cvt_u32_f64_e32 v16, v[16:17]                            // 0000006C9950: 7E202B10
	v_mul_lo_u32 v17, v16, s18                                 // 0000006C9954: D72C0011 02002510
	v_sub_nc_u32_e32 v18, s20, v17                             // 0000006C995C: 4C242214
	v_cmp_ge_u32_e64 vcc_lo, v18, s18                          // 0000006C9960: D44E006A 02002512
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C9968: BEFE006A
	v_add_nc_u32_e64 v16, v16, 1                               // 0000006C996C: D5250010 02010310
	s_mov_b32 exec_lo, -1                                      // 0000006C9974: BEFE00C1
	v_mul_lo_u32 v17, v16, s18                                 // 0000006C9978: D72C0011 02002510
	v_sub_nc_u32_e32 v18, s20, v17                             // 0000006C9980: 4C242214
	v_readfirstlane_b32 s3, v16                                // 0000006C9984: 7E060510
	v_readfirstlane_b32 s2, v18                                // 0000006C9988: 7E040512
	s_mul_i32 s2, s3, s18                                      // 0000006C998C: 96021203
	s_sub_u32 s2, s20, s2                                      // 0000006C9990: 80820214
	s_mul_i32 s17, s17, s16                                    // 0000006C9994: 96111011
	s_add_u32 s2, s2, s17                                      // 0000006C9998: 80021102
	s_branch label_WGM                                         // 0000006C999C: BFA00043

<label_WGMPositive>:
	s_mov_b32 s16, s16                                         // 0000006C99A0: BE900010
	v_cvt_f64_u32_e32 v[16:17], s16                            // 0000006C99A4: 7E202C10
	v_rcp_f64_e32 v[16:17], v[16:17]                           // 0000006C99A8: 7E205F10
	v_cvt_f64_u32_e32 v[18:19], s3                             // 0000006C99AC: 7E242C03
	v_mul_f64 v[16:17], v[16:17], v[18:19]                     // 0000006C99B0: D7280010 02022510
	v_cvt_u32_f64_e32 v16, v[16:17]                            // 0000006C99B8: 7E202B10
	v_mul_lo_u32 v17, v16, s16                                 // 0000006C99BC: D72C0011 02002110
	v_sub_nc_u32_e32 v18, s3, v17                              // 0000006C99C4: 4C242203
	v_cmp_ge_u32_e64 vcc_lo, v18, s16                          // 0000006C99C8: D44E006A 02002112
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C99D0: BEFE006A
	v_add_nc_u32_e64 v16, v16, 1                               // 0000006C99D4: D5250010 02010310
	s_mov_b32 exec_lo, -1                                      // 0000006C99DC: BEFE00C1
	v_readfirstlane_b32 s17, v16                               // 0000006C99E0: 7E220510
	s_mul_i32 s20, s17, s16                                    // 0000006C99E4: 96141011
	s_sub_u32 s20, s3, s20                                     // 0000006C99E8: 80941403
	s_mul_i32 s20, s20, s14                                    // 0000006C99EC: 96140E14
	s_add_u32 s20, s20, s2                                     // 0000006C99F0: 80140214
	v_cvt_f64_u32_e32 v[16:17], s16                            // 0000006C99F4: 7E202C10
	v_rcp_f64_e32 v[16:17], v[16:17]                           // 0000006C99F8: 7E205F10
	v_cvt_f64_u32_e32 v[18:19], s15                            // 0000006C99FC: 7E242C0F
	v_mul_f64 v[16:17], v[16:17], v[18:19]                     // 0000006C9A00: D7280010 02022510
	v_cvt_u32_f64_e32 v16, v[16:17]                            // 0000006C9A08: 7E202B10
	v_mul_lo_u32 v17, v16, s16                                 // 0000006C9A0C: D72C0011 02002110
	v_sub_nc_u32_e32 v18, s15, v17                             // 0000006C9A14: 4C24220F
	v_cmp_ge_u32_e64 vcc_lo, v18, s16                          // 0000006C9A18: D44E006A 02002112
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C9A20: BEFE006A
	v_add_nc_u32_e64 v16, v16, 1                               // 0000006C9A24: D5250010 02010310
	s_mov_b32 exec_lo, -1                                      // 0000006C9A2C: BEFE00C1
	v_readfirstlane_b32 s18, v16                               // 0000006C9A30: 7E240510
	s_mul_i32 s19, s16, s18                                    // 0000006C9A34: 96131210
	s_sub_u32 s19, s15, s19                                    // 0000006C9A38: 8093130F
	s_cmp_eq_u32 s19, 0                                        // 0000006C9A3C: BF068013
	s_cmov_b32 s19, s16                                        // 0000006C9A40: BE930210
	s_cmp_ge_u32 s17, s18                                      // 0000006C9A44: BF091211
	s_cselect_b32 s18, s19, s16                                // 0000006C9A48: 98121013
	v_cvt_f64_u32_e32 v[16:17], s18                            // 0000006C9A4C: 7E202C12
	v_rcp_f64_e32 v[16:17], v[16:17]                           // 0000006C9A50: 7E205F10
	v_cvt_f64_u32_e32 v[18:19], s20                            // 0000006C9A54: 7E242C14
	v_mul_f64 v[16:17], v[16:17], v[18:19]                     // 0000006C9A58: D7280010 02022510
	v_cvt_u32_f64_e32 v16, v[16:17]                            // 0000006C9A60: 7E202B10
	v_mul_lo_u32 v17, v16, s18                                 // 0000006C9A64: D72C0011 02002510
	v_sub_nc_u32_e32 v18, s20, v17                             // 0000006C9A6C: 4C242214
	v_cmp_ge_u32_e64 vcc_lo, v18, s18                          // 0000006C9A70: D44E006A 02002512
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C9A78: BEFE006A
	v_add_nc_u32_e64 v16, v16, 1                               // 0000006C9A7C: D5250010 02010310
	s_mov_b32 exec_lo, -1                                      // 0000006C9A84: BEFE00C1
	v_mul_lo_u32 v17, v16, s18                                 // 0000006C9A88: D72C0011 02002510
	v_sub_nc_u32_e32 v18, s20, v17                             // 0000006C9A90: 4C242214
	v_readfirstlane_b32 s2, v16                                // 0000006C9A94: 7E040510
	v_readfirstlane_b32 s3, v18                                // 0000006C9A98: 7E060512
	s_mul_i32 s3, s2, s18                                      // 0000006C9A9C: 96031202
	s_sub_u32 s3, s20, s3                                      // 0000006C9AA0: 80830314
	s_mul_i32 s17, s17, s16                                    // 0000006C9AA4: 96111011
	s_add_u32 s3, s3, s17                                      // 0000006C9AA8: 80031103

<label_WGM>:
	v_mov_b32_e32 v6, v0                                       // 0000006C9AAC: 7E0C0300
	v_mov_b32_e32 v7, v2                                       // 0000006C9AB0: 7E0E0302
	v_mov_b32_e32 v16, v1                                      // 0000006C9AB4: 7E200301
	v_mov_b32_e32 v17, v3                                      // 0000006C9AB8: 7E220303
	s_mul_i32 s16, s2, 32                                      // 0000006C9ABC: 9610A002
	s_sub_u32 s16, s24, s16                                    // 0000006C9AC0: 80901018
	s_sub_u32 s16, s16, 8                                      // 0000006C9AC4: 80908810
	v_mov_b32_e32 v18, s16                                     // 0000006C9AC8: 7E240210
	v_min_i32_e32 v6, v18, v6                                  // 0000006C9ACC: 220C0D12
	s_mul_hi_u32 s19, s2, 32                                   // 0000006C9AD0: 9693A002
	s_mul_i32 s18, s2, 32                                      // 0000006C9AD4: 9612A002
	s_and_b32 s16, s46, 0x8000                                 // 0000006C9AD8: 8B10FF2E 00008000
	s_cbranch_scc1 label_GSUC_A                                // 0000006C9AE0: BFA20003
	s_mul_hi_u32 s17, 16, s6                                   // 0000006C9AE4: 96910690
	s_mul_i32 s16, 16, s6                                      // 0000006C9AE8: 96100690
	s_branch label_GSUC_A_End                                  // 0000006C9AEC: BFA00024

<label_GSUC_A>:
	s_lshr_b32 s12, s27, 4                                     // 0000006C9AF0: 850C841B
	s_and_b32 s7, s46, 0x3fff                                  // 0000006C9AF4: 8B07FF2E 00003FFF
	v_cvt_f32_u32_e32 v18, s7                                  // 0000006C9AFC: 7E240C07
	v_rcp_iflag_f32_e32 v18, v18                               // 0000006C9B00: 7E245712
	v_cvt_f32_u32_e32 v19, s12                                 // 0000006C9B04: 7E260C0C
	v_mul_f32_e32 v18, v18, v19                                // 0000006C9B08: 10242712
	v_cvt_u32_f32_e32 v18, v18                                 // 0000006C9B0C: 7E240F12
	v_mul_u32_u24_e64 v19, v18, s7                             // 0000006C9B10: D50B0013 02000F12
	v_sub_nc_u32_e32 v19, s12, v19                             // 0000006C9B18: 4C26260C
	v_cmp_eq_u32_e64 vcc_lo, v19, s7                           // 0000006C9B1C: D44A006A 02000F13
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C9B24: BEFE006A
	v_add_nc_u32_e32 v18, 1, v18                               // 0000006C9B28: 4A242481
	v_mov_b32_e32 v19, 0                                       // 0000006C9B2C: 7E260280
	s_mov_b32 exec_lo, -1                                      // 0000006C9B30: BEFE00C1
	v_cmp_gt_u32_e64 vcc_lo, v19, s7                           // 0000006C9B34: D44C006A 02000F13
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C9B3C: BEFE006A
	v_sub_nc_u32_e64 v18, v18, 1                               // 0000006C9B40: D5260012 02010312
	v_mul_u32_u24_e64 v19, v18, s7                             // 0000006C9B48: D50B0013 02000F12
	v_sub_nc_u32_e32 v19, s12, v19                             // 0000006C9B50: 4C26260C
	s_mov_b32 exec_lo, -1                                      // 0000006C9B54: BEFE00C1
	v_readfirstlane_b32 s12, v18                               // 0000006C9B58: 7E180512
	v_readfirstlane_b32 s7, v19                                // 0000006C9B5C: 7E0E0513
	s_mul_i32 s17, s12, s6                                     // 0000006C9B60: 9611060C
	s_add_u32 s16, 1, s12                                      // 0000006C9B64: 80100C81
	s_add_u32 s17, s17, s7                                     // 0000006C9B68: 80110711
	s_mul_i32 s16, s16, s6                                     // 0000006C9B6C: 96100610
	s_cmp_lt_u32 s6, s7                                        // 0000006C9B70: BF0A0706
	s_cselect_b32 s16, s16, s17                                // 0000006C9B74: 98101110
	s_mul_hi_u32 s17, s16, 16                                  // 0000006C9B78: 96919010
	s_mul_i32 s16, s16, 16                                     // 0000006C9B7C: 96109010

<label_GSUC_A_End>:
	s_mul_hi_u32 s17, s16, s40                                 // 0000006C9B80: 96912810
	s_mul_i32 s16, s16, s40                                    // 0000006C9B84: 96102810
	s_add_u32 s18, s18, s16                                    // 0000006C9B88: 80121012
	s_addc_u32 s19, s19, s17                                   // 0000006C9B8C: 82131113
	s_mov_b64 s[56:57], 1                                      // 0000006C9B90: BEB80181
	s_sub_u32 s16, s24, 1                                      // 0000006C9B94: 80908118
	s_mul_hi_u32 s17, 1, s16                                   // 0000006C9B98: 96911081
	s_mul_i32 s16, 1, s16                                      // 0000006C9B9C: 96101081
	s_add_u32 s56, s56, s16                                    // 0000006C9BA0: 80381038
	s_addc_u32 s57, s57, s17                                   // 0000006C9BA4: 82391139
	s_sub_u32 s16, s27, 1                                      // 0000006C9BA8: 8090811B
	s_mul_hi_u32 s17, s40, s16                                 // 0000006C9BAC: 96911028
	s_mul_i32 s16, s40, s16                                    // 0000006C9BB0: 96101028
	s_add_u32 s56, s56, s16                                    // 0000006C9BB4: 80381038
	s_addc_u32 s57, s57, s17                                   // 0000006C9BB8: 82391139
	s_sub_u32 s56, s56, s18                                    // 0000006C9BBC: 80B81238
	s_subb_u32 s57, s57, s19                                   // 0000006C9BC0: 82B91339
	s_lshl_b64 s[56:57], s[56:57], 1                           // 0000006C9BC4: 84B88138
	s_add_u32 s56, s56, 16                                     // 0000006C9BC8: 80389038
	s_addc_u32 s57, s57, 0                                     // 0000006C9BCC: 82398039
	s_cmp_eq_u32 s57, 0                                        // 0000006C9BD0: BF068039
	s_cselect_b32 s50, s56, -1                                 // 0000006C9BD4: 9832C138
	s_cmp_eq_u32 s5, 3                                         // 0000006C9BD8: BF068305
	s_cbranch_scc0 label_StridedBatchedGemmLoadA               // 0000006C9BDC: BFA1000E
	s_mul_i32 s16, 8, s4                                       // 0000006C9BE0: 96100488
	s_cmp_eq_u32 s27, 0                                        // 0000006C9BE4: BF06801B
	s_cbranch_scc1 label_StridedBatchedGemmLoadA_End           // 0000006C9BE8: BFA20012
	s_add_u32 s16, s16, s32                                    // 0000006C9BEC: 80102010
	s_addc_u32 s17, s33, 0                                     // 0000006C9BF0: 82118021
	s_load_b64 s[48:49], s[16:17], null                        // 0000006C9BF4: F4040C08 F8000000
	s_waitcnt lgkmcnt(0)                                       // 0000006C9BFC: BF89FC07
	s_sub_u32 s48, s48, 16                                     // 0000006C9C00: 80B09030
	s_subb_u32 s49, s49, 0                                     // 0000006C9C04: 82B18031
	s_lshl_b64 s[18:19], s[18:19], 1                           // 0000006C9C08: 84928112
	s_add_u32 s48, s18, s48                                    // 0000006C9C0C: 80303012
	s_addc_u32 s49, s19, s49                                   // 0000006C9C10: 82313113
	s_branch label_StridedBatchedGemmLoadA_End                 // 0000006C9C14: BFA00007

<label_StridedBatchedGemmLoadA>:
	s_mul_hi_u32 s17, s41, s4                                  // 0000006C9C18: 96910429
	s_mul_i32 s16, s41, s4                                     // 0000006C9C1C: 96100429
	s_add_u32 s18, s18, s16                                    // 0000006C9C20: 80121012
	s_addc_u32 s19, s19, s17                                   // 0000006C9C24: 82131113
	s_lshl_b64 s[18:19], s[18:19], 1                           // 0000006C9C28: 84928112
	s_add_u32 s48, s32, s18                                    // 0000006C9C2C: 80301220
	s_addc_u32 s49, s33, s19                                   // 0000006C9C30: 82311321

<label_StridedBatchedGemmLoadA_End>:
	s_mov_b32 s51, 0x31004000                                  // 0000006C9C34: BEB300FF 31004000
	s_mul_hi_u32 s19, s3, 16                                   // 0000006C9C3C: 96939003
	s_mul_i32 s18, s3, 16                                      // 0000006C9C40: 96129003
	s_mul_hi_u32 s19, s18, s42                                 // 0000006C9C44: 96932A12
	s_mul_i32 s18, s18, s42                                    // 0000006C9C48: 96122A12
	s_and_b32 s16, s46, 0x8000                                 // 0000006C9C4C: 8B10FF2E 00008000
	s_cbranch_scc1 label_GSUC_B                                // 0000006C9C54: BFA20003
	s_mul_hi_u32 s17, 16, s6                                   // 0000006C9C58: 96910690
	s_mul_i32 s16, 16, s6                                      // 0000006C9C5C: 96100690
	s_branch label_GSUC_B_End                                  // 0000006C9C60: BFA00024

<label_GSUC_B>:
	s_lshr_b32 s12, s27, 4                                     // 0000006C9C64: 850C841B
	s_and_b32 s7, s46, 0x3fff                                  // 0000006C9C68: 8B07FF2E 00003FFF
	v_cvt_f32_u32_e32 v18, s7                                  // 0000006C9C70: 7E240C07
	v_rcp_iflag_f32_e32 v18, v18                               // 0000006C9C74: 7E245712
	v_cvt_f32_u32_e32 v19, s12                                 // 0000006C9C78: 7E260C0C
	v_mul_f32_e32 v18, v18, v19                                // 0000006C9C7C: 10242712
	v_cvt_u32_f32_e32 v18, v18                                 // 0000006C9C80: 7E240F12
	v_mul_u32_u24_e64 v19, v18, s7                             // 0000006C9C84: D50B0013 02000F12
	v_sub_nc_u32_e32 v19, s12, v19                             // 0000006C9C8C: 4C26260C
	v_cmp_eq_u32_e64 vcc_lo, v19, s7                           // 0000006C9C90: D44A006A 02000F13
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C9C98: BEFE006A
	v_add_nc_u32_e32 v18, 1, v18                               // 0000006C9C9C: 4A242481
	v_mov_b32_e32 v19, 0                                       // 0000006C9CA0: 7E260280
	s_mov_b32 exec_lo, -1                                      // 0000006C9CA4: BEFE00C1
	v_cmp_gt_u32_e64 vcc_lo, v19, s7                           // 0000006C9CA8: D44C006A 02000F13
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C9CB0: BEFE006A
	v_sub_nc_u32_e64 v18, v18, 1                               // 0000006C9CB4: D5260012 02010312
	v_mul_u32_u24_e64 v19, v18, s7                             // 0000006C9CBC: D50B0013 02000F12
	v_sub_nc_u32_e32 v19, s12, v19                             // 0000006C9CC4: 4C26260C
	s_mov_b32 exec_lo, -1                                      // 0000006C9CC8: BEFE00C1
	v_readfirstlane_b32 s12, v18                               // 0000006C9CCC: 7E180512
	v_readfirstlane_b32 s7, v19                                // 0000006C9CD0: 7E0E0513
	s_mul_i32 s17, s12, s6                                     // 0000006C9CD4: 9611060C
	s_add_u32 s16, 1, s12                                      // 0000006C9CD8: 80100C81
	s_add_u32 s17, s17, s7                                     // 0000006C9CDC: 80110711
	s_mul_i32 s16, s16, s6                                     // 0000006C9CE0: 96100610
	s_cmp_lt_u32 s6, s7                                        // 0000006C9CE4: BF0A0706
	s_cselect_b32 s16, s16, s17                                // 0000006C9CE8: 98101110
	s_mul_hi_u32 s17, s16, 16                                  // 0000006C9CEC: 96919010
	s_mul_i32 s16, s16, 16                                     // 0000006C9CF0: 96109010

<label_GSUC_B_End>:
	s_add_u32 s18, s18, s16                                    // 0000006C9CF4: 80121012
	s_addc_u32 s19, s19, s17                                   // 0000006C9CF8: 82131113
	s_mov_b64 s[58:59], 1                                      // 0000006C9CFC: BEBA0181
	s_sub_u32 s16, s27, 1                                      // 0000006C9D00: 8090811B
	s_mul_hi_u32 s17, 1, s16                                   // 0000006C9D04: 96911081
	s_mul_i32 s16, 1, s16                                      // 0000006C9D08: 96101081
	s_add_u32 s58, s58, s16                                    // 0000006C9D0C: 803A103A
	s_addc_u32 s59, s59, s17                                   // 0000006C9D10: 823B113B
	s_sub_u32 s16, s25, 1                                      // 0000006C9D14: 80908119
	s_mul_hi_u32 s17, s42, s16                                 // 0000006C9D18: 9691102A
	s_mul_i32 s16, s42, s16                                    // 0000006C9D1C: 9610102A
	s_add_u32 s58, s58, s16                                    // 0000006C9D20: 803A103A
	s_addc_u32 s59, s59, s17                                   // 0000006C9D24: 823B113B
	s_sub_u32 s58, s58, s18                                    // 0000006C9D28: 80BA123A
	s_subb_u32 s59, s59, s19                                   // 0000006C9D2C: 82BB133B
	s_lshl_b64 s[58:59], s[58:59], 1                           // 0000006C9D30: 84BA813A
	s_add_u32 s58, s58, 8                                      // 0000006C9D34: 803A883A
	s_addc_u32 s59, s59, 0                                     // 0000006C9D38: 823B803B
	s_cmp_eq_u32 s59, 0                                        // 0000006C9D3C: BF06803B
	s_cselect_b32 s54, s58, -1                                 // 0000006C9D40: 9836C13A
	s_cmp_eq_u32 s5, 3                                         // 0000006C9D44: BF068305
	s_cbranch_scc0 label_StridedBatchedGemmLoadB               // 0000006C9D48: BFA1000E
	s_mul_i32 s16, 8, s4                                       // 0000006C9D4C: 96100488
	s_cmp_eq_u32 s27, 0                                        // 0000006C9D50: BF06801B
	s_cbranch_scc1 label_StridedBatchedGemmLoadB_End           // 0000006C9D54: BFA20012
	s_add_u32 s16, s16, s34                                    // 0000006C9D58: 80102210
	s_addc_u32 s17, s35, 0                                     // 0000006C9D5C: 82118023
	s_load_b64 s[52:53], s[16:17], null                        // 0000006C9D60: F4040D08 F8000000
	s_waitcnt lgkmcnt(0)                                       // 0000006C9D68: BF89FC07
	s_sub_u32 s52, s52, 8                                      // 0000006C9D6C: 80B48834
	s_subb_u32 s53, s53, 0                                     // 0000006C9D70: 82B58035
	s_lshl_b64 s[18:19], s[18:19], 1                           // 0000006C9D74: 84928112
	s_add_u32 s52, s18, s52                                    // 0000006C9D78: 80343412
	s_addc_u32 s53, s19, s53                                   // 0000006C9D7C: 82353513
	s_branch label_StridedBatchedGemmLoadB_End                 // 0000006C9D80: BFA00007

<label_StridedBatchedGemmLoadB>:
	s_mul_hi_u32 s17, s43, s4                                  // 0000006C9D84: 9691042B
	s_mul_i32 s16, s43, s4                                     // 0000006C9D88: 9610042B
	s_add_u32 s18, s18, s16                                    // 0000006C9D8C: 80121012
	s_addc_u32 s19, s19, s17                                   // 0000006C9D90: 82131113
	s_lshl_b64 s[18:19], s[18:19], 1                           // 0000006C9D94: 84928112
	s_add_u32 s52, s34, s18                                    // 0000006C9D98: 80341222
	s_addc_u32 s53, s35, s19                                   // 0000006C9D9C: 82351323

<label_StridedBatchedGemmLoadB_End>:
	s_mov_b32 s55, 0x31004000                                  // 0000006C9DA0: BEB700FF 31004000
	v_mul_lo_u32 v18, s40, v16                                 // 0000006C9DA8: D72C0012 02022028
	v_add_co_u32 v8, vcc_lo, v6, v18                           // 0000006C9DB0: D7006A08 02022506
	v_add_nc_u32_e32 v8, 8, v8                                 // 0000006C9DB8: 4A101088
	v_lshlrev_b32_e32 v8, 1, v8                                // 0000006C9DBC: 30101081
	v_mul_lo_u32 v18, s42, v7                                  // 0000006C9DC0: D72C0012 02020E2A
	v_add_co_u32 v9, vcc_lo, v17, v18                          // 0000006C9DC8: D7006A09 02022511
	v_add_nc_u32_e32 v9, 4, v9                                 // 0000006C9DD0: 4A121284
	v_lshlrev_b32_e32 v9, 1, v9                                // 0000006C9DD4: 30121281
	s_and_b32 s17, s46, 0x3fff                                 // 0000006C9DD8: 8B11FF2E 00003FFF
	s_mov_b32 s64, 32                                          // 0000006C9DE0: BEC000A0
	s_mul_i32 s17, s17, s64                                    // 0000006C9DE4: 96114011
	s_and_b32 s16, s46, 0x8000                                 // 0000006C9DE8: 8B10FF2E 00008000
	s_cmov_b32 s17, 32                                         // 0000006C9DF0: BE9102A0
	s_mul_i32 s64, s17, s40                                    // 0000006C9DF4: 96402811
	s_and_b32 s17, s46, 0x3fff                                 // 0000006C9DF8: 8B11FF2E 00003FFF
	s_mov_b32 s65, 32                                          // 0000006C9E00: BEC100A0
	s_mul_i32 s17, s17, s65                                    // 0000006C9E04: 96114111
	s_and_b32 s16, s46, 0x8000                                 // 0000006C9E08: 8B10FF2E 00008000
	s_cselect_b32 s65, s65, s17                                // 0000006C9E10: 98411141
	s_lshr_b32 s12, s27, 4                                     // 0000006C9E14: 850C841B
	s_and_b32 s16, s46, 0x3fff                                 // 0000006C9E18: 8B10FF2E 00003FFF
	s_cmp_eq_u32 s16, 1                                        // 0000006C9E20: BF068110
	s_cbranch_scc1 label_GSU_1                                 // 0000006C9E24: BFA2001E
	s_and_b32 s7, s46, 0x3fff                                  // 0000006C9E28: 8B07FF2E 00003FFF
	v_cvt_f32_u32_e32 v0, s7                                   // 0000006C9E30: 7E000C07
	v_rcp_iflag_f32_e32 v0, v0                                 // 0000006C9E34: 7E005700
	v_cvt_f32_u32_e32 v1, s12                                  // 0000006C9E38: 7E020C0C
	v_mul_f32_e32 v0, v0, v1                                   // 0000006C9E3C: 10000300
	v_cvt_u32_f32_e32 v0, v0                                   // 0000006C9E40: 7E000F00
	v_mul_u32_u24_e64 v1, v0, s7                               // 0000006C9E44: D50B0001 02000F00
	v_sub_nc_u32_e32 v1, s12, v1                               // 0000006C9E4C: 4C02020C
	v_cmp_eq_u32_e64 vcc_lo, v1, s7                            // 0000006C9E50: D44A006A 02000F01
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C9E58: BEFE006A
	v_add_nc_u32_e32 v0, 1, v0                                 // 0000006C9E5C: 4A000081
	v_mov_b32_e32 v1, 0                                        // 0000006C9E60: 7E020280
	s_mov_b32 exec_lo, -1                                      // 0000006C9E64: BEFE00C1
	v_cmp_gt_u32_e64 vcc_lo, v1, s7                            // 0000006C9E68: D44C006A 02000F01
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006C9E70: BEFE006A
	v_sub_nc_u32_e64 v0, v0, 1                                 // 0000006C9E74: D5260000 02010300
	v_mul_u32_u24_e64 v1, v0, s7                               // 0000006C9E7C: D50B0001 02000F00
	v_sub_nc_u32_e32 v1, s12, v1                               // 0000006C9E84: 4C02020C
	s_mov_b32 exec_lo, -1                                      // 0000006C9E88: BEFE00C1
	v_readfirstlane_b32 s12, v0                                // 0000006C9E8C: 7E180500
	v_readfirstlane_b32 s7, v1                                 // 0000006C9E90: 7E0E0501
	s_add_u32 s16, 1, s12                                      // 0000006C9E94: 80100C81
	s_cmp_lt_u32 s6, s7                                        // 0000006C9E98: BF0A0706
	s_cmov_b32 s12, s16                                        // 0000006C9E9C: BE8C0210

<label_GSU_1>:
	s_mov_b32 s13, s12                                         // 0000006C9EA0: BE8D000C
	s_and_b32 s18, s10, 0x1f00                                 // 0000006C9EA4: 8B12FF0A 00001F00
	s_lshr_b32 s18, s18, 8                                     // 0000006C9EAC: 85128812
	s_and_b32 s19, s10, 0xe000                                 // 0000006C9EB0: 8B13FF0A 0000E000
	s_and_b32 s10, s10, 0xff                                   // 0000006C9EB8: 8B0AFF0A 000000FF
	s_mov_b32 s16, s10                                         // 0000006C9EC0: BE90000A

<label_beginStaggerUIter>:
	s_lshl_b32 s17, s16, s18                                   // 0000006C9EC4: 84111210
	s_cmp_ge_u32 s13, s17                                      // 0000006C9EC8: BF09110D
	s_cbranch_scc1 label_endStaggerUIter                       // 0000006C9ECC: BFA20002
	s_lshr_b32 s16, s16, 1                                     // 0000006C9ED0: 85108110
	s_branch label_beginStaggerUIter                           // 0000006C9ED4: BFA0FFFB

<label_endStaggerUIter>:
	s_sub_u32 s17, s16, 1                                      // 0000006C9ED8: 80918110
	s_cmp_ge_u32 s16, 1                                        // 0000006C9EDC: BF098110
	s_cselect_b32 s47, s17, 0                                  // 0000006C9EE0: 982F8011
	s_cmp_eq_u32 s19, 0                                        // 0000006C9EE4: BF068013
	s_cbranch_scc0 label_StaggerUMapping                       // 0000006C9EE8: BFA10002
	s_mov_b32 s16, s2                                          // 0000006C9EEC: BE900002
	s_branch label_staggerInputEnd                             // 0000006C9EF0: BFA00016

<label_StaggerUMapping>:
	s_cmp_eq_u32 s19, 0x2000                                   // 0000006C9EF4: BF06FF13 00002000
	s_cbranch_scc0 label_StaggerUMapping_1                     // 0000006C9EFC: BFA10002
	s_mov_b32 s16, s3                                          // 0000006C9F00: BE900003
	s_branch label_staggerInputEnd                             // 0000006C9F04: BFA00011

<label_StaggerUMapping_1>:
	s_cmp_eq_u32 s19, 0x4000                                   // 0000006C9F08: BF06FF13 00004000
	s_cbranch_scc0 label_StaggerUMapping_2                     // 0000006C9F10: BFA10002
	s_mov_b32 s16, -1                                          // 0000006C9F14: BE9000C1
	s_branch label_staggerInputEnd                             // 0000006C9F18: BFA0000C

<label_StaggerUMapping_2>:
	s_cmp_eq_u32 s19, 0x6000                                   // 0000006C9F1C: BF06FF13 00006000
	s_cbranch_scc0 label_StaggerUMapping_3                     // 0000006C9F24: BFA10004
	s_mul_i32 s17, s14, s3                                     // 0000006C9F28: 9611030E
	s_add_u32 s16, s16, s17                                    // 0000006C9F2C: 80101110
	s_add_u32 s16, s16, s2                                     // 0000006C9F30: 80100210
	s_branch label_staggerInputEnd                             // 0000006C9F34: BFA00005

<label_StaggerUMapping_3>:
	s_cmp_eq_u32 s19, 0x8000                                   // 0000006C9F38: BF06FF13 00008000
	s_cbranch_scc0 label_staggerInputEnd                       // 0000006C9F40: BFA10002
	s_mov_b32 s16, -1                                          // 0000006C9F44: BE9000C1
	s_branch label_staggerInputEnd                             // 0000006C9F48: BFA00000

<label_staggerInputEnd>:
	s_and_b32 s47, s47, s16                                    // 0000006C9F4C: 8B2F102F
	s_lshl_b32 s47, s47, s18                                   // 0000006C9F50: 842F122F
	s_mul_hi_i32 s17, s47, s64                                 // 0000006C9F54: 9711402F
	s_mul_i32 s16, s47, s64                                    // 0000006C9F58: 9610402F
	s_mul_hi_i32 s61, s12, s64                                 // 0000006C9F5C: 973D400C
	s_mul_i32 s60, s12, s64                                    // 0000006C9F60: 963C400C
	s_sub_u32 s60, s64, s60                                    // 0000006C9F64: 80BC3C40
	s_subb_u32 s61, 0, s61                                     // 0000006C9F68: 82BD3D80
	s_add_u32 s48, s48, s16                                    // 0000006C9F6C: 80301030
	s_addc_u32 s49, s49, s17                                   // 0000006C9F70: 82311131
	s_sub_u32 s56, s56, s16                                    // 0000006C9F74: 80B81038
	s_subb_u32 s57, s57, s17                                   // 0000006C9F78: 82B91139
	s_cmp_eq_u32 s57, 0                                        // 0000006C9F7C: BF068039
	s_cselect_b32 s50, s56, -1                                 // 0000006C9F80: 9832C138
	s_mul_hi_i32 s17, s47, s65                                 // 0000006C9F84: 9711412F
	s_mul_i32 s16, s47, s65                                    // 0000006C9F88: 9610412F
	s_mul_hi_i32 s63, s12, s65                                 // 0000006C9F8C: 973F410C
	s_mul_i32 s62, s12, s65                                    // 0000006C9F90: 963E410C
	s_sub_u32 s62, s65, s62                                    // 0000006C9F94: 80BE3E41
	s_subb_u32 s63, 0, s63                                     // 0000006C9F98: 82BF3F80
	s_add_u32 s52, s52, s16                                    // 0000006C9F9C: 80341034
	s_addc_u32 s53, s53, s17                                   // 0000006C9FA0: 82351135
	s_sub_u32 s58, s58, s16                                    // 0000006C9FA4: 80BA103A
	s_subb_u32 s59, s59, s17                                   // 0000006C9FA8: 82BB113B
	s_cmp_eq_u32 s59, 0                                        // 0000006C9FAC: BF06803B
	s_cselect_b32 s54, s58, -1                                 // 0000006C9FB0: 9836C13A
	s_add_u32 s47, s47, 2                                      // 0000006C9FB4: 802F822F
	s_cmp_eq_u32 s12, 0                                        // 0000006C9FB8: BF06800C
	s_cbranch_scc1 label_ShadowInitStart                       // 0000006C9FBC: BFA20018
	buffer_load_b128 v[66:69], v8, s[48:51], 0 offen           // 0000006C9FC0: E05C0000 804C4208
	buffer_load_b64 v[70:71], v9, s[52:55], 0 offen            // 0000006C9FC8: E0540000 804D4609
	s_add_u32 s18, s12, 1                                      // 0000006C9FD0: 8012810C
	s_cmp_eq_u32 s47, s18                                      // 0000006C9FD4: BF06122F
	s_cselect_b32 s16, s60, s64                                // 0000006C9FD8: 9810403C
	s_cselect_b32 s17, s61, 0                                  // 0000006C9FDC: 9811803D
	s_add_u32 s48, s48, s16                                    // 0000006C9FE0: 80301030
	s_addc_u32 s49, s49, s17                                   // 0000006C9FE4: 82311131
	s_sub_u32 s56, s56, s16                                    // 0000006C9FE8: 80B81038
	s_subb_u32 s57, s57, s17                                   // 0000006C9FEC: 82B91139
	s_cmp_eq_u32 s57, 0                                        // 0000006C9FF0: BF068039
	s_cselect_b32 s50, s56, -1                                 // 0000006C9FF4: 9832C138
	s_add_u32 s18, s12, 1                                      // 0000006C9FF8: 8012810C
	s_cmp_eq_u32 s47, s18                                      // 0000006C9FFC: BF06122F
	s_cselect_b32 s16, s62, s65                                // 0000006CA000: 9810413E
	s_cselect_b32 s17, s63, 0                                  // 0000006CA004: 9811803F
	s_add_u32 s52, s52, s16                                    // 0000006CA008: 80341034
	s_addc_u32 s53, s53, s17                                   // 0000006CA00C: 82351135
	s_sub_u32 s58, s58, s16                                    // 0000006CA010: 80BA103A
	s_subb_u32 s59, s59, s17                                   // 0000006CA014: 82BB113B
	s_cmp_eq_u32 s59, 0                                        // 0000006CA018: BF06803B
	s_cselect_b32 s54, s58, -1                                 // 0000006CA01C: 9836C13A

<label_ShadowInitStart>:
	s_and_b32 s66, s46, 0x3fff                                 // 0000006CA020: 8B42FF2E 00003FFF
	s_cmp_eq_u32 s66, 1                                        // 0000006CA028: BF068142
	s_cbranch_scc1 label_ArgTypeCheckD                         // 0000006CA02C: BFA20002
	s_mov_b64 s[16:17], s[28:29]                               // 0000006CA030: BE90011C
	s_branch label_GeneralBatchedGemmSrdInitiationD_End        // 0000006CA034: BFA00006

<label_ArgTypeCheckD>:
	s_cmp_eq_u32 s5, 3                                         // 0000006CA038: BF068305
	s_cbranch_scc0 label_RegularSrdInitializationD             // 0000006CA03C: BFA10001
	s_branch label_GeneralBatchedGemmSrdInitiationD            // 0000006CA040: BFA00002

<label_RegularSrdInitializationD>:
	s_mov_b64 s[16:17], s[28:29]                               // 0000006CA044: BE90011C
	s_branch label_GeneralBatchedGemmSrdInitiationD_End        // 0000006CA048: BFA00001

<label_GeneralBatchedGemmSrdInitiationD>:
	s_mov_b64 s[16:17], 0                                      // 0000006CA04C: BE900180

<label_GeneralBatchedGemmSrdInitiationD_End>:
	s_mov_b32 s18, 0xfffff000                                  // 0000006CA050: BE9200FF FFFFF000
	s_mov_b32 s19, 0x31004000                                  // 0000006CA058: BE9300FF 31004000
	s_and_b32 s66, s46, 0x3fff                                 // 0000006CA060: 8B42FF2E 00003FFF
	s_cmp_eq_u32 s66, 1                                        // 0000006CA068: BF068142
	s_cbranch_scc1 label_ArgTypeCheckC                         // 0000006CA06C: BFA20002
	s_mov_b64 s[20:21], s[30:31]                               // 0000006CA070: BE94011E
	s_branch label_GeneralBatchedGemmSrdInitiationC_End        // 0000006CA074: BFA00006

<label_ArgTypeCheckC>:
	s_cmp_eq_u32 s5, 3                                         // 0000006CA078: BF068305
	s_cbranch_scc0 label_RegularSrdInitializationC             // 0000006CA07C: BFA10001
	s_branch label_GeneralBatchedGemmSrdInitiationC            // 0000006CA080: BFA00002

<label_RegularSrdInitializationC>:
	s_mov_b64 s[20:21], s[30:31]                               // 0000006CA084: BE94011E
	s_branch label_GeneralBatchedGemmSrdInitiationC_End        // 0000006CA088: BFA00001

<label_GeneralBatchedGemmSrdInitiationC>:
	s_mov_b64 s[20:21], 0                                      // 0000006CA08C: BE940180

<label_GeneralBatchedGemmSrdInitiationC_End>:
	s_mov_b32 s22, 0xfffff000                                  // 0000006CA090: BE9600FF FFFFF000
	s_mov_b32 s23, 0x31004000                                  // 0000006CA098: BE9700FF 31004000
	s_mul_i32 s68, 16, s3                                      // 0000006CA0A0: 96440390
	s_and_b32 s67, s46, 0x3fff                                 // 0000006CA0A4: 8B43FF2E 00003FFF
	s_mul_hi_u32 s67, s68, s38                                 // 0000006CA0AC: 96C32644
	s_mul_i32 s66, s68, s38                                    // 0000006CA0B0: 96422644
	s_lshl_b64 s[66:67], s[66:67], s8                          // 0000006CA0B4: 84C20842
	s_add_u32 s20, s20, s66                                    // 0000006CA0B8: 80144214
	s_addc_u32 s21, s21, s67                                   // 0000006CA0BC: 82154315
	s_and_b32 s67, s46, 0x3fff                                 // 0000006CA0C0: 8B43FF2E 00003FFF
	s_mul_hi_u32 s67, s68, s36                                 // 0000006CA0C8: 96C32444
	s_mul_i32 s66, s68, s36                                    // 0000006CA0CC: 96422444
	s_lshl_b64 s[66:67], s[66:67], s9                          // 0000006CA0D0: 84C20942
	s_add_u32 s16, s16, s66                                    // 0000006CA0D4: 80104210
	s_addc_u32 s17, s17, s67                                   // 0000006CA0D8: 82114311
	s_and_b32 s67, s46, 0x3fff                                 // 0000006CA0DC: 8B43FF2E 00003FFF
	s_cmp_eq_u32 s67, 1                                        // 0000006CA0E4: BF068143
	s_cbranch_scc0 label_StridedBatchedGemmLoadC               // 0000006CA0E8: BFA10002
	s_cmp_eq_u32 s5, 3                                         // 0000006CA0EC: BF068305
	s_cbranch_scc1 label_GeneralBatchedGemmLoadC               // 0000006CA0F0: BFA20006

<label_StridedBatchedGemmLoadC>:
	s_mul_hi_u32 s67, s4, s39                                  // 0000006CA0F4: 96C32704
	s_mul_i32 s66, s4, s39                                     // 0000006CA0F8: 96422704
	s_lshl_b64 s[66:67], s[66:67], s8                          // 0000006CA0FC: 84C20842
	s_add_u32 s20, s20, s66                                    // 0000006CA100: 80144214
	s_addc_u32 s21, s21, s67                                   // 0000006CA104: 82154315
	s_branch label_GeneralBatchedGemmLoadC_End                 // 0000006CA108: BFA00008

<label_GeneralBatchedGemmLoadC>:
	s_mul_i32 s66, 8, s4                                       // 0000006CA10C: 96420488
	s_add_u32 s66, s66, s30                                    // 0000006CA110: 80421E42
	s_addc_u32 s67, s31, 0                                     // 0000006CA114: 8243801F
	s_load_b64 s[66:67], s[66:67], null                        // 0000006CA118: F40410A1 F8000000
	s_waitcnt lgkmcnt(0)                                       // 0000006CA120: BF89FC07
	s_add_u32 s20, s20, s66                                    // 0000006CA124: 80144214
	s_addc_u32 s21, s21, s67                                   // 0000006CA128: 82154315

<label_GeneralBatchedGemmLoadC_End>:
	s_and_b32 s67, s46, 0x3fff                                 // 0000006CA12C: 8B43FF2E 00003FFF
	s_cmp_eq_u32 s67, 1                                        // 0000006CA134: BF068143
	s_cbranch_scc0 label_StridedBatchedGemmLoadD               // 0000006CA138: BFA10002
	s_cmp_eq_u32 s5, 3                                         // 0000006CA13C: BF068305
	s_cbranch_scc1 label_GeneralBatchedGemmLoadD               // 0000006CA140: BFA20006

<label_StridedBatchedGemmLoadD>:
	s_mul_hi_u32 s67, s4, s37                                  // 0000006CA144: 96C32504
	s_mul_i32 s66, s4, s37                                     // 0000006CA148: 96422504
	s_lshl_b64 s[66:67], s[66:67], s9                          // 0000006CA14C: 84C20942
	s_add_u32 s16, s16, s66                                    // 0000006CA150: 80104210
	s_addc_u32 s17, s17, s67                                   // 0000006CA154: 82114311
	s_branch label_GeneralBatchedGemmLoadD_End                 // 0000006CA158: BFA00008

<label_GeneralBatchedGemmLoadD>:
	s_mul_i32 s66, 8, s4                                       // 0000006CA15C: 96420488
	s_add_u32 s66, s66, s28                                    // 0000006CA160: 80421C42
	s_addc_u32 s67, s29, 0                                     // 0000006CA164: 8243801D
	s_load_b64 s[66:67], s[66:67], null                        // 0000006CA168: F40410A1 F8000000
	s_waitcnt lgkmcnt(0)                                       // 0000006CA170: BF89FC07
	s_add_u32 s16, s16, s66                                    // 0000006CA174: 80104210
	s_addc_u32 s17, s17, s67                                   // 0000006CA178: 82114311

<label_GeneralBatchedGemmLoadD_End>:
	s_and_b32 s66, s46, 0x3fff                                 // 0000006CA17C: 8B42FF2E 00003FFF
	s_cmp_eq_u32 s66, 1                                        // 0000006CA184: BF068142
	s_cbranch_scc1 label_GSU_2                                 // 0000006CA188: BFA20011
	s_mul_hi_u32 s67, s24, s6                                  // 0000006CA18C: 96C30618
	s_mul_i32 s66, s24, s6                                     // 0000006CA190: 96420618
	s_sub_u32 s68, s25, 1                                      // 0000006CA194: 80C48119
	s_mul_i32 s68, s68, s6                                     // 0000006CA198: 96440644
	s_mul_hi_u32 s69, s68, s38                                 // 0000006CA19C: 96C52644
	s_mul_i32 s68, s68, s38                                    // 0000006CA1A0: 96442644
	s_add_u32 s66, s66, s68                                    // 0000006CA1A4: 80424442
	s_addc_u32 s67, s67, s69                                   // 0000006CA1A8: 82434543
	s_sub_u32 s68, s26, 1                                      // 0000006CA1AC: 80C4811A
	s_mul_i32 s68, s68, s6                                     // 0000006CA1B0: 96440644
	s_mul_hi_u32 s69, s68, s39                                 // 0000006CA1B4: 96C52744
	s_mul_i32 s68, s68, s39                                    // 0000006CA1B8: 96442744
	s_add_u32 s66, s66, s68                                    // 0000006CA1BC: 80424442
	s_addc_u32 s67, s67, s69                                   // 0000006CA1C0: 82434543
	s_lshl_b64 s[66:67], s[66:67], 2                           // 0000006CA1C4: 84C28242
	s_add_u32 s16, s16, s66                                    // 0000006CA1C8: 80104210
	s_addc_u32 s17, s17, s67                                   // 0000006CA1CC: 82114311

<label_GSU_2>:
	v_mov_b32_e32 v0, 0                                        // 0000006CA1D0: 7E000280
	v_mov_b32_e32 v1, 0                                        // 0000006CA1D4: 7E020280
	v_mov_b32_e32 v2, 0                                        // 0000006CA1D8: 7E040280
	v_mov_b32_e32 v3, 0                                        // 0000006CA1DC: 7E060280
	v_mov_b32_e32 v4, 0                                        // 0000006CA1E0: 7E080280
	v_mov_b32_e32 v5, 0                                        // 0000006CA1E4: 7E0A0280
	v_mov_b32_e32 v6, 0                                        // 0000006CA1E8: 7E0C0280
	v_mov_b32_e32 v7, 0                                        // 0000006CA1EC: 7E0E0280
	s_cmp_eq_u32 s12, 0                                        // 0000006CA1F0: BF06800C
	s_cbranch_scc0 label_NoBranch_A281O4UWTOSDRQ5U             // 0000006CA1F4: BFA10006
	s_getpc_b64 s[66:67]                                       // 0000006CA1F8: BEC24700
	s_add_i32 s68, 0xbbc, 4                                    // 0000006CA1FC: 814484FF 00000BBC
	s_add_u32 s66, s66, s68                                    // 0000006CA204: 80424442
	s_addc_u32 s67, s67, 0                                     // 0000006CA208: 82438043
	s_setpc_b64 s[66:67]                                       // 0000006CA20C: BE804842

<label_NoBranch_A281O4UWTOSDRQ5U>:
	s_waitcnt vmcnt(0)                                         // 0000006CA210: BF8903F7
	ds_store_b128 v10, v[66:69]                                // 0000006CA214: DB7C0000 0000420A
	ds_store_b16 v11, v70                                      // 0000006CA21C: D87C0000 0000460B
	ds_store_b16_d16_hi v11, v70 offset:32                     // 0000006CA224: DA840020 0000460B
	ds_store_b16 v11, v71 offset:64                            // 0000006CA22C: D87C0040 0000470B
	ds_store_b16_d16_hi v11, v71 offset:96                     // 0000006CA234: DA840060 0000470B
	v_xor_b32_e32 v10, 0x800, v10                              // 0000006CA23C: 3A1414FF 00000800
	v_xor_b32_e32 v11, 0x800, v11                              // 0000006CA244: 3A1616FF 00000800
	s_cmp_eq_u32 s12, 1                                        // 0000006CA24C: BF06810C
	s_cbranch_scc1 label_openLoopL                             // 0000006CA250: BFA20005
	buffer_load_b128 v[66:69], v8, s[48:51], 0 offen           // 0000006CA254: E05C0000 804C4208
	buffer_load_b64 v[70:71], v9, s[52:55], 0 offen            // 0000006CA25C: E0540000 804D4609
	s_branch label_openLoopL                                   // 0000006CA264: BFA00000

<label_skipPGR2_2>:
	s_cmp_eq_u32 s12, 1                                        // 0000006CA268: BF06810C
	s_cbranch_scc1 label_toPGR1                                // 0000006CA26C: BFA200E3
	s_cmp_le_u32 s12, 2                                        // 0000006CA270: BF0B820C
	s_cbranch_scc1 label_LoopEndL                              // 0000006CA274: BFA20075
	s_nop 0                                                    // 0000006CA278: BF800000
	s_nop 0                                                    // 0000006CA27C: BF800000

<label_LoopBeginL>:
	s_waitcnt lgkmcnt(0)                                       // 0000006CA280: BF89FC07
	s_waitcnt lgkmcnt(0)                                       // 0000006CA284: BF89FC07
	s_barrier                                                  // 0000006CA288: BFBD0000
	ds_load_u16 v16, v12                                       // 0000006CA28C: D8F00000 1000000C
	ds_load_u16_d16_hi v16, v12 offset:64                      // 0000006CA294: DA9C0040 1000000C
	ds_load_u16 v17, v12 offset:128                            // 0000006CA29C: D8F00080 1100000C
	ds_load_u16_d16_hi v17, v12 offset:192                     // 0000006CA2A4: DA9C00C0 1100000C
	ds_load_u16 v18, v12 offset:256                            // 0000006CA2AC: D8F00100 1200000C
	ds_load_u16_d16_hi v18, v12 offset:320                     // 0000006CA2B4: DA9C0140 1200000C
	ds_load_u16 v19, v12 offset:384                            // 0000006CA2BC: D8F00180 1300000C
	ds_load_u16_d16_hi v19, v12 offset:448                     // 0000006CA2C4: DA9C01C0 1300000C
	ds_load_u16 v20, v12 offset:512                            // 0000006CA2CC: D8F00200 1400000C
	ds_load_u16_d16_hi v20, v12 offset:576                     // 0000006CA2D4: DA9C0240 1400000C
	ds_load_u16 v21, v12 offset:640                            // 0000006CA2DC: D8F00280 1500000C
	ds_load_u16_d16_hi v21, v12 offset:704                     // 0000006CA2E4: DA9C02C0 1500000C
	ds_load_u16 v22, v12 offset:768                            // 0000006CA2EC: D8F00300 1600000C
	ds_load_u16_d16_hi v22, v12 offset:832                     // 0000006CA2F4: DA9C0340 1600000C
	ds_load_u16 v23, v12 offset:896                            // 0000006CA2FC: D8F00380 1700000C
	ds_load_u16_d16_hi v23, v12 offset:960                     // 0000006CA304: DA9C03C0 1700000C
	ds_load_u16 v41, v13                                       // 0000006CA30C: D8F00000 2900000D
	ds_load_u16_d16_hi v41, v13 offset:32                      // 0000006CA314: DA9C0020 2900000D
	ds_load_u16 v42, v13 offset:64                             // 0000006CA31C: D8F00040 2A00000D
	ds_load_u16_d16_hi v42, v13 offset:96                      // 0000006CA324: DA9C0060 2A00000D
	ds_load_u16 v43, v13 offset:128                            // 0000006CA32C: D8F00080 2B00000D
	ds_load_u16_d16_hi v43, v13 offset:160                     // 0000006CA334: DA9C00A0 2B00000D
	ds_load_u16 v44, v13 offset:192                            // 0000006CA33C: D8F000C0 2C00000D
	ds_load_u16_d16_hi v44, v13 offset:224                     // 0000006CA344: DA9C00E0 2C00000D
	ds_load_u16 v45, v13 offset:256                            // 0000006CA34C: D8F00100 2D00000D
	ds_load_u16_d16_hi v45, v13 offset:288                     // 0000006CA354: DA9C0120 2D00000D
	ds_load_u16 v46, v13 offset:320                            // 0000006CA35C: D8F00140 2E00000D
	ds_load_u16_d16_hi v46, v13 offset:352                     // 0000006CA364: DA9C0160 2E00000D
	ds_load_u16 v47, v13 offset:384                            // 0000006CA36C: D8F00180 2F00000D
	ds_load_u16_d16_hi v47, v13 offset:416                     // 0000006CA374: DA9C01A0 2F00000D
	ds_load_u16 v48, v13 offset:448                            // 0000006CA37C: D8F001C0 3000000D
	ds_load_u16_d16_hi v48, v13 offset:480                     // 0000006CA384: DA9C01E0 3000000D
	s_cmp_eq_u32 s12, s47                                      // 0000006CA38C: BF062F0C
	s_cselect_b32 s66, s60, s64                                // 0000006CA390: 9842403C
	s_cselect_b32 s67, s61, 0                                  // 0000006CA394: 9843803D
	s_add_u32 s48, s48, s66                                    // 0000006CA398: 80304230
	s_addc_u32 s49, s49, s67                                   // 0000006CA39C: 82314331
	s_sub_u32 s56, s56, s66                                    // 0000006CA3A0: 80B84238
	s_subb_u32 s57, s57, s67                                   // 0000006CA3A4: 82B94339
	s_cmp_eq_u32 s57, 0                                        // 0000006CA3A8: BF068039
	s_cselect_b32 s50, s56, -1                                 // 0000006CA3AC: 9832C138
	s_cmp_eq_u32 s12, s47                                      // 0000006CA3B0: BF062F0C
	s_cselect_b32 s66, s62, s65                                // 0000006CA3B4: 9842413E
	s_cselect_b32 s67, s63, 0                                  // 0000006CA3B8: 9843803F
	s_add_u32 s52, s52, s66                                    // 0000006CA3BC: 80344234
	s_addc_u32 s53, s53, s67                                   // 0000006CA3C0: 82354335
	s_sub_u32 s58, s58, s66                                    // 0000006CA3C4: 80BA423A
	s_subb_u32 s59, s59, s67                                   // 0000006CA3C8: 82BB433B
	s_cmp_eq_u32 s59, 0                                        // 0000006CA3CC: BF06803B
	s_cselect_b32 s54, s58, -1                                 // 0000006CA3D0: 9836C13A
	s_waitcnt vmcnt(1)                                         // 0000006CA3D4: BF8907F7
	ds_store_b128 v10, v[66:69]                                // 0000006CA3D8: DB7C0000 0000420A
	buffer_load_b128 v[66:69], v8, s[48:51], 0 offen           // 0000006CA3E0: E05C0000 804C4208
	s_waitcnt vmcnt(1)                                         // 0000006CA3E8: BF8907F7
	ds_store_b16 v11, v70                                      // 0000006CA3EC: D87C0000 0000460B
	ds_store_b16_d16_hi v11, v70 offset:32                     // 0000006CA3F4: DA840020 0000460B
	ds_store_b16 v11, v71 offset:64                            // 0000006CA3FC: D87C0040 0000470B
	ds_store_b16_d16_hi v11, v71 offset:96                     // 0000006CA404: DA840060 0000470B
	buffer_load_b64 v[70:71], v9, s[52:55], 0 offen            // 0000006CA40C: E0540000 804D4609
	v_xor_b32_e32 v10, 0x800, v10                              // 0000006CA414: 3A1414FF 00000800
	v_xor_b32_e32 v11, 0x800, v11                              // 0000006CA41C: 3A1616FF 00000800
	v_xor_b32_e32 v12, 0x800, v12                              // 0000006CA424: 3A1818FF 00000800
	v_xor_b32_e32 v13, 0x800, v13                              // 0000006CA42C: 3A1A1AFF 00000800
	s_waitcnt lgkmcnt(5)                                       // 0000006CA434: BF89FC57
	v_wmma_f32_16x16x16_bf16 v[0:7], v[41:48], v[16:23], v[0:7]// 0000006CA438: CC414000 1C022129
	s_sub_u32 s12, s12, 1                                      // 0000006CA440: 808C810C
	s_cmp_eq_i32 s12, 2                                        // 0000006CA444: BF00820C
	s_cbranch_scc0 label_LoopBeginL                            // 0000006CA448: BFA1FF8D

<label_LoopEndL>:
	s_waitcnt lgkmcnt(0)                                       // 0000006CA44C: BF89FC07
	s_waitcnt lgkmcnt(0)                                       // 0000006CA450: BF89FC07
	s_barrier                                                  // 0000006CA454: BFBD0000
	ds_load_u16 v16, v12                                       // 0000006CA458: D8F00000 1000000C
	ds_load_u16_d16_hi v16, v12 offset:64                      // 0000006CA460: DA9C0040 1000000C
	ds_load_u16 v17, v12 offset:128                            // 0000006CA468: D8F00080 1100000C
	ds_load_u16_d16_hi v17, v12 offset:192                     // 0000006CA470: DA9C00C0 1100000C
	ds_load_u16 v18, v12 offset:256                            // 0000006CA478: D8F00100 1200000C
	ds_load_u16_d16_hi v18, v12 offset:320                     // 0000006CA480: DA9C0140 1200000C
	ds_load_u16 v19, v12 offset:384                            // 0000006CA488: D8F00180 1300000C
	ds_load_u16_d16_hi v19, v12 offset:448                     // 0000006CA490: DA9C01C0 1300000C
	ds_load_u16 v20, v12 offset:512                            // 0000006CA498: D8F00200 1400000C
	ds_load_u16_d16_hi v20, v12 offset:576                     // 0000006CA4A0: DA9C0240 1400000C
	ds_load_u16 v21, v12 offset:640                            // 0000006CA4A8: D8F00280 1500000C
	ds_load_u16_d16_hi v21, v12 offset:704                     // 0000006CA4B0: DA9C02C0 1500000C
	ds_load_u16 v22, v12 offset:768                            // 0000006CA4B8: D8F00300 1600000C
	ds_load_u16_d16_hi v22, v12 offset:832                     // 0000006CA4C0: DA9C0340 1600000C
	ds_load_u16 v23, v12 offset:896                            // 0000006CA4C8: D8F00380 1700000C
	ds_load_u16_d16_hi v23, v12 offset:960                     // 0000006CA4D0: DA9C03C0 1700000C
	ds_load_u16 v41, v13                                       // 0000006CA4D8: D8F00000 2900000D
	ds_load_u16_d16_hi v41, v13 offset:32                      // 0000006CA4E0: DA9C0020 2900000D
	ds_load_u16 v42, v13 offset:64                             // 0000006CA4E8: D8F00040 2A00000D
	ds_load_u16_d16_hi v42, v13 offset:96                      // 0000006CA4F0: DA9C0060 2A00000D
	ds_load_u16 v43, v13 offset:128                            // 0000006CA4F8: D8F00080 2B00000D
	ds_load_u16_d16_hi v43, v13 offset:160                     // 0000006CA500: DA9C00A0 2B00000D
	ds_load_u16 v44, v13 offset:192                            // 0000006CA508: D8F000C0 2C00000D
	ds_load_u16_d16_hi v44, v13 offset:224                     // 0000006CA510: DA9C00E0 2C00000D
	ds_load_u16 v45, v13 offset:256                            // 0000006CA518: D8F00100 2D00000D
	ds_load_u16_d16_hi v45, v13 offset:288                     // 0000006CA520: DA9C0120 2D00000D
	ds_load_u16 v46, v13 offset:320                            // 0000006CA528: D8F00140 2E00000D
	ds_load_u16_d16_hi v46, v13 offset:352                     // 0000006CA530: DA9C0160 2E00000D
	ds_load_u16 v47, v13 offset:384                            // 0000006CA538: D8F00180 2F00000D
	ds_load_u16_d16_hi v47, v13 offset:416                     // 0000006CA540: DA9C01A0 2F00000D
	ds_load_u16 v48, v13 offset:448                            // 0000006CA548: D8F001C0 3000000D
	ds_load_u16_d16_hi v48, v13 offset:480                     // 0000006CA550: DA9C01E0 3000000D
	s_cmp_eq_u32 s12, s47                                      // 0000006CA558: BF062F0C
	s_cselect_b32 s66, s60, s64                                // 0000006CA55C: 9842403C
	s_cselect_b32 s67, s61, 0                                  // 0000006CA560: 9843803D
	s_add_u32 s48, s48, s66                                    // 0000006CA564: 80304230
	s_addc_u32 s49, s49, s67                                   // 0000006CA568: 82314331
	s_sub_u32 s56, s56, s66                                    // 0000006CA56C: 80B84238
	s_subb_u32 s57, s57, s67                                   // 0000006CA570: 82B94339
	s_cmp_eq_u32 s57, 0                                        // 0000006CA574: BF068039
	s_cselect_b32 s50, s56, -1                                 // 0000006CA578: 9832C138
	s_cmp_eq_u32 s12, s47                                      // 0000006CA57C: BF062F0C
	s_cselect_b32 s66, s62, s65                                // 0000006CA580: 9842413E
	s_cselect_b32 s67, s63, 0                                  // 0000006CA584: 9843803F
	s_add_u32 s52, s52, s66                                    // 0000006CA588: 80344234
	s_addc_u32 s53, s53, s67                                   // 0000006CA58C: 82354335
	s_sub_u32 s58, s58, s66                                    // 0000006CA590: 80BA423A
	s_subb_u32 s59, s59, s67                                   // 0000006CA594: 82BB433B
	s_cmp_eq_u32 s59, 0                                        // 0000006CA598: BF06803B
	s_cselect_b32 s54, s58, -1                                 // 0000006CA59C: 9836C13A
	s_waitcnt vmcnt(1)                                         // 0000006CA5A0: BF8907F7
	ds_store_b128 v10, v[66:69]                                // 0000006CA5A4: DB7C0000 0000420A
	s_waitcnt vmcnt(0)                                         // 0000006CA5AC: BF8903F7
	ds_store_b16 v11, v70                                      // 0000006CA5B0: D87C0000 0000460B
	ds_store_b16_d16_hi v11, v70 offset:32                     // 0000006CA5B8: DA840020 0000460B
	ds_store_b16 v11, v71 offset:64                            // 0000006CA5C0: D87C0040 0000470B
	ds_store_b16_d16_hi v11, v71 offset:96                     // 0000006CA5C8: DA840060 0000470B
	v_xor_b32_e32 v10, 0x800, v10                              // 0000006CA5D0: 3A1414FF 00000800
	v_xor_b32_e32 v11, 0x800, v11                              // 0000006CA5D8: 3A1616FF 00000800
	v_xor_b32_e32 v12, 0x800, v12                              // 0000006CA5E0: 3A1818FF 00000800
	v_xor_b32_e32 v13, 0x800, v13                              // 0000006CA5E8: 3A1A1AFF 00000800
	s_waitcnt lgkmcnt(5)                                       // 0000006CA5F0: BF89FC57
	v_wmma_f32_16x16x16_bf16 v[0:7], v[41:48], v[16:23], v[0:7]// 0000006CA5F4: CC414000 1C022129

<label_toPGR1>:
	s_and_b32 s8, s46, 0x3fff                                  // 0000006CA5FC: 8B08FF2E 00003FFF
	s_cmp_eq_u32 s8, 1                                         // 0000006CA604: BF068108
	s_cbranch_scc0 label_GSU_3                                 // 0000006CA608: BFA101A6
	s_cmpk_eq_u32 s45, 0x0                                     // 0000006CA60C: B4AD0000
	s_cbranch_scc0 label_GSU_3                                 // 0000006CA610: BFA101A4
	s_cmp_eq_u32 s44, 1.0                                      // 0000006CA614: BF06F22C
	s_cbranch_scc0 label_GSU_3                                 // 0000006CA618: BFA101A2
	s_and_b32 s66, 31, s24                                     // 0000006CA61C: 8B42189F
	s_add_u32 s67, -1, s14                                     // 0000006CA620: 80430EC1
	s_cmp_ge_u32 s2, s67                                       // 0000006CA624: BF094302
	s_cselect_b32 s66, s66, 0                                  // 0000006CA628: 98428042
	s_cmpk_gt_u32 s66, 0x0                                     // 0000006CA62C: B5C20000
	s_cbranch_scc1 label_GSU_3                                 // 0000006CA630: BFA2019C
	s_and_b32 s66, 15, s25                                     // 0000006CA634: 8B42198F
	s_add_u32 s67, -1, s15                                     // 0000006CA638: 80430FC1
	s_cmp_ge_u32 s3, s67                                       // 0000006CA63C: BF094303
	s_cselect_b32 s66, s66, 0                                  // 0000006CA640: 98428042
	s_cmpk_gt_u32 s66, 0x0                                     // 0000006CA644: B5C20000
	s_cbranch_scc1 label_GSU_3                                 // 0000006CA648: BFA20196
	s_and_b32 s67, 15, s27                                     // 0000006CA64C: 8B431B8F
	s_cmp_eq_u32 s67, 0                                        // 0000006CA650: BF068043
	s_cbranch_scc0 label_GSU_3                                 // 0000006CA654: BFA10193
	s_waitcnt lgkmcnt(0)                                       // 0000006CA658: BF89FC07
	s_waitcnt lgkmcnt(0)                                       // 0000006CA65C: BF89FC07
	s_barrier                                                  // 0000006CA660: BFBD0000
	ds_load_u16 v16, v12                                       // 0000006CA664: D8F00000 1000000C
	ds_load_u16_d16_hi v16, v12 offset:64                      // 0000006CA66C: DA9C0040 1000000C
	ds_load_u16 v17, v12 offset:128                            // 0000006CA674: D8F00080 1100000C
	ds_load_u16_d16_hi v17, v12 offset:192                     // 0000006CA67C: DA9C00C0 1100000C
	ds_load_u16 v18, v12 offset:256                            // 0000006CA684: D8F00100 1200000C
	ds_load_u16_d16_hi v18, v12 offset:320                     // 0000006CA68C: DA9C0140 1200000C
	ds_load_u16 v19, v12 offset:384                            // 0000006CA694: D8F00180 1300000C
	ds_load_u16_d16_hi v19, v12 offset:448                     // 0000006CA69C: DA9C01C0 1300000C
	ds_load_u16 v20, v12 offset:512                            // 0000006CA6A4: D8F00200 1400000C
	ds_load_u16_d16_hi v20, v12 offset:576                     // 0000006CA6AC: DA9C0240 1400000C
	ds_load_u16 v21, v12 offset:640                            // 0000006CA6B4: D8F00280 1500000C
	ds_load_u16_d16_hi v21, v12 offset:704                     // 0000006CA6BC: DA9C02C0 1500000C
	ds_load_u16 v22, v12 offset:768                            // 0000006CA6C4: D8F00300 1600000C
	ds_load_u16_d16_hi v22, v12 offset:832                     // 0000006CA6CC: DA9C0340 1600000C
	ds_load_u16 v23, v12 offset:896                            // 0000006CA6D4: D8F00380 1700000C
	ds_load_u16_d16_hi v23, v12 offset:960                     // 0000006CA6DC: DA9C03C0 1700000C
	ds_load_u16 v41, v13                                       // 0000006CA6E4: D8F00000 2900000D
	ds_load_u16_d16_hi v41, v13 offset:32                      // 0000006CA6EC: DA9C0020 2900000D
	ds_load_u16 v42, v13 offset:64                             // 0000006CA6F4: D8F00040 2A00000D
	ds_load_u16_d16_hi v42, v13 offset:96                      // 0000006CA6FC: DA9C0060 2A00000D
	ds_load_u16 v43, v13 offset:128                            // 0000006CA704: D8F00080 2B00000D
	ds_load_u16_d16_hi v43, v13 offset:160                     // 0000006CA70C: DA9C00A0 2B00000D
	ds_load_u16 v44, v13 offset:192                            // 0000006CA714: D8F000C0 2C00000D
	ds_load_u16_d16_hi v44, v13 offset:224                     // 0000006CA71C: DA9C00E0 2C00000D
	ds_load_u16 v45, v13 offset:256                            // 0000006CA724: D8F00100 2D00000D
	ds_load_u16_d16_hi v45, v13 offset:288                     // 0000006CA72C: DA9C0120 2D00000D
	ds_load_u16 v46, v13 offset:320                            // 0000006CA734: D8F00140 2E00000D
	ds_load_u16_d16_hi v46, v13 offset:352                     // 0000006CA73C: DA9C0160 2E00000D
	ds_load_u16 v47, v13 offset:384                            // 0000006CA744: D8F00180 2F00000D
	ds_load_u16_d16_hi v47, v13 offset:416                     // 0000006CA74C: DA9C01A0 2F00000D
	ds_load_u16 v48, v13 offset:448                            // 0000006CA754: D8F001C0 3000000D
	ds_load_u16_d16_hi v48, v13 offset:480                     // 0000006CA75C: DA9C01E0 3000000D
	s_waitcnt lgkmcnt(0)                                       // 0000006CA764: BF89FC07
	v_wmma_f32_16x16x16_bf16 v[0:7], v[41:48], v[16:23], v[0:7]// 0000006CA768: CC414000 1C022129

<label_toPGR1end_OptNLL>:
	s_cmp_eq_u32 s5, 2                                         // 0000006CA770: BF068205
	s_cbranch_scc1 label_LoadExternalEpilogueStruct            // 0000006CA774: BFA20005
	s_load_b256 s[48:55], s[0:1], 0x58                         // 0000006CA778: F40C0C00 F8000058
	s_load_b32 s56, s[0:1], 0x78                               // 0000006CA780: F4000E00 F8000078
	s_branch label_LoadExternalEpilogueStructEnd               // 0000006CA788: BFA00008

<label_LoadExternalEpilogueStruct>:
	s_load_b128 s[48:51], s[0:1], 0x90                         // 0000006CA78C: F4080C00 F8000090
	s_load_b64 s[52:53], s[0:1], 0xa0                          // 0000006CA794: F4040D00 F80000A0
	s_load_b64 s[54:55], s[0:1], 0xb8                          // 0000006CA79C: F4040D80 F80000B8
	s_load_b32 s56, s[0:1], 0xc0                               // 0000006CA7A4: F4000E00 F80000C0

<label_LoadExternalEpilogueStructEnd>:
	v_lshrrev_b32_e32 v12, 5, v72                              // 0000006CA7AC: 32189085
	v_lshrrev_b32_e32 v13, 1, v12                              // 0000006CA7B0: 321A1881
	v_mul_lo_u32 v13, 16, v13                                  // 0000006CA7B4: D72C000D 02021A90
	v_and_b32_e32 v9, 31, v72                                  // 0000006CA7BC: 3612909F
	v_lshrrev_b32_e32 v9, 4, v9                                // 0000006CA7C0: 32121284
	v_add_lshl_u32 v9, v13, v9, 0                              // 0000006CA7C4: D6470009 0202130D
	v_mul_lo_u32 v10, v9, s38                                  // 0000006CA7CC: D72C000A 02004D09
	v_mul_lo_u32 v11, v9, s36                                  // 0000006CA7D4: D72C000B 02004909
	v_and_b32_e32 v8, 1, v12                                   // 0000006CA7DC: 36101881
	v_mul_lo_u32 v8, 16, v8                                    // 0000006CA7E0: D72C0008 02021090
	v_and_b32_e32 v13, 15, v72                                 // 0000006CA7E8: 361A908F
	v_add_lshl_u32 v8, v13, v8, 0                              // 0000006CA7EC: D6470008 0202110D
	s_mul_i32 s8, 32, s2                                       // 0000006CA7F4: 960802A0
	v_add_nc_u32_e32 v8, s8, v8                                // 0000006CA7F8: 4A101008
	s_mul_i32 s8, 16, s3                                       // 0000006CA7FC: 96080390
	v_add_nc_u32_e32 v9, s8, v9                                // 0000006CA800: 4A121208
	s_waitcnt lgkmcnt(0)                                       // 0000006CA804: BF89FC07
	s_mov_b64 s[32:33], s[48:49]                               // 0000006CA808: BEA00130
	s_mov_b32 s35, 0x31004000                                  // 0000006CA80C: BEA300FF 31004000
	s_cmp_eq_u64 s[48:49], 0                                   // 0000006CA814: BF108030
	s_cbranch_scc0 label_ScaleAlphaVecAddrValid                // 0000006CA818: BFA10002
	s_mov_b32 s34, 0                                           // 0000006CA81C: BEA20080
	s_branch label_ScaleAlphaVecAddrValid_End                  // 0000006CA820: BFA00001

<label_ScaleAlphaVecAddrValid>:
	s_mov_b32 s34, s24                                         // 0000006CA824: BEA20018

<label_ScaleAlphaVecAddrValid_End>:
	s_mul_i32 s34, 4, s34                                      // 0000006CA828: 96222284
	s_add_u32 s8, s4, 1                                        // 0000006CA82C: 80088104
	s_mul_i32 s8, s53, s8                                      // 0000006CA830: 96080835
	s_cmp_eq_u32 s8, 0                                         // 0000006CA834: BF068008
	s_cselect_b32 s8, s24, s8                                  // 0000006CA838: 98080818
	s_mov_b64 s[40:41], s[50:51]                               // 0000006CA83C: BEA80132
	s_mov_b32 s43, 0x31004000                                  // 0000006CA840: BEAB00FF 31004000
	s_cmp_eq_u64 s[50:51], 0                                   // 0000006CA848: BF108032
	s_cbranch_scc0 label_BiasAddrValid                         // 0000006CA84C: BFA10002
	s_mov_b32 s42, 0                                           // 0000006CA850: BEAA0080
	s_branch label_BiasAddrValid_End                           // 0000006CA854: BFA00001

<label_BiasAddrValid>:
	s_mov_b32 s42, s8                                          // 0000006CA858: BEAA0008

<label_Load_Biasf32_0>:
	s_cmpk_lg_u32 s52, 0x0                                     // 0000006CA85C: B5340000
	s_cbranch_scc1 label_Load_Biasbf16_0                       // 0000006CA860: BFA2001A
	s_mul_i32 s8, 32, s2                                       // 0000006CA864: 960802A0
	v_add_nc_u32_e32 v16, s8, v72                              // 0000006CA868: 4A209008
	s_mul_i32 s42, 4, s42                                      // 0000006CA86C: 962A2A84
	s_mul_i32 s8, s53, s4                                      // 0000006CA870: 96080435
	v_add_nc_u32_e32 v14, s8, v16                              // 0000006CA874: 4A1C2008
	v_lshlrev_b32_e32 v14, 2, v14                              // 0000006CA878: 301C1C82
	v_lshlrev_b32_e32 v15, 2, v16                              // 0000006CA87C: 301E2082
	s_mul_i32 s8, 16, s3                                       // 0000006CA880: 96080390
	v_add_nc_u32_e32 v16, s8, v72                              // 0000006CA884: 4A209008
	buffer_load_b32 v12, v14, s[40:43], 0 offen                // 0000006CA888: E0500000 804A0C0E
	buffer_load_b32 v13, v15, s[32:35], 0 offen                // 0000006CA890: E0500000 80480D0F
	v_lshlrev_b32_e32 v16, 2, v72                              // 0000006CA898: 30209082
	s_barrier                                                  // 0000006CA89C: BFBD0000
	s_waitcnt vmcnt(1)                                         // 0000006CA8A0: BF8907F7
	ds_store_b32 v16, v12                                      // 0000006CA8A4: D8340000 00000C10
	v_cmp_gt_u32_e64 s48, s34, 0                               // 0000006CA8AC: D44C0030 02010022
	s_waitcnt vmcnt(0)                                         // 0000006CA8B4: BF8903F7
	v_cndmask_b32_e64 v13, 1.0, v13, s48                       // 0000006CA8B8: D501000D 00C21AF2
	ds_store_b32 v16, v13 offset:256                           // 0000006CA8C0: D8340100 00000D10
	s_branch label_Load_Bias_End                               // 0000006CA8C8: BFA0001D

<label_Load_Biasbf16_0>:
	s_cmpk_lg_u32 s52, 0x7                                     // 0000006CA8CC: B5340007
	s_cbranch_scc1 label_Load_Bias_End                         // 0000006CA8D0: BFA2001B
	s_mul_i32 s8, 32, s2                                       // 0000006CA8D4: 960802A0
	v_add_nc_u32_e32 v16, s8, v72                              // 0000006CA8D8: 4A209008
	s_mul_i32 s42, 2, s42                                      // 0000006CA8DC: 962A2A82
	s_mul_i32 s8, s53, s4                                      // 0000006CA8E0: 96080435
	v_add_nc_u32_e32 v14, s8, v16                              // 0000006CA8E4: 4A1C2008
	v_lshlrev_b32_e32 v14, 1, v14                              // 0000006CA8E8: 301C1C81
	v_lshlrev_b32_e32 v15, 2, v16                              // 0000006CA8EC: 301E2082
	s_mul_i32 s8, 16, s3                                       // 0000006CA8F0: 96080390
	v_add_nc_u32_e32 v16, s8, v72                              // 0000006CA8F4: 4A209008
	buffer_load_d16_b16 v12, v14, s[40:43], 0 offen            // 0000006CA8F8: E0800000 804A0C0E
	buffer_load_b32 v13, v15, s[32:35], 0 offen                // 0000006CA900: E0500000 80480D0F
	v_lshlrev_b32_e32 v16, 2, v72                              // 0000006CA908: 30209082
	s_barrier                                                  // 0000006CA90C: BFBD0000
	s_waitcnt vmcnt(1)                                         // 0000006CA910: BF8907F7
	v_lshlrev_b32_e32 v12, 16, v12                             // 0000006CA914: 30181890
	ds_store_b32 v16, v12                                      // 0000006CA918: D8340000 00000C10
	v_cmp_gt_u32_e64 s48, s34, 0                               // 0000006CA920: D44C0030 02010022
	s_waitcnt vmcnt(0)                                         // 0000006CA928: BF8903F7
	v_cndmask_b32_e64 v13, 1.0, v13, s48                       // 0000006CA92C: D501000D 00C21AF2
	ds_store_b32 v16, v13 offset:256                           // 0000006CA934: D8340100 00000D10
	s_branch label_Load_Bias_End                               // 0000006CA93C: BFA00000

<label_Load_Bias_End>:
	s_cmpk_eq_u32 s56, 0x3                                     // 0000006CA940: B4B80003
	s_cbranch_scc1 label_To_Activation_Gelu_VW1                // 0000006CA944: BFA2000E
	s_cmpk_eq_u32 s56, 0x5                                     // 0000006CA948: B4B80005
	s_cbranch_scc1 label_To_Activation_Relu_VW1                // 0000006CA94C: BFA20012
	s_cmpk_eq_u32 s56, 0x6                                     // 0000006CA950: B4B80006
	s_cbranch_scc1 label_To_Activation_Sigmoid_VW1             // 0000006CA954: BFA20016
	s_cmpk_eq_u32 s56, 0xb                                     // 0000006CA958: B4B8000B
	s_cbranch_scc1 label_To_Activation_Silu_VW1                // 0000006CA95C: BFA2001A
	s_cmpk_eq_u32 s56, 0xd                                     // 0000006CA960: B4B8000D
	s_cbranch_scc1 label_To_Activation_Clamp_VW1               // 0000006CA964: BFA2001E

<label_To_Activation_None_VW1>:
	s_getpc_b64 s[12:13]                                       // 0000006CA968: BE8C4700
	s_add_i32 s8, 0x2868, 4                                    // 0000006CA96C: 810884FF 00002868
	s_add_u32 s12, s12, s8                                     // 0000006CA974: 800C080C
	s_addc_u32 s13, s13, 0                                     // 0000006CA978: 820D800D
	s_branch label_ActivationSetPCAddrEnd                      // 0000006CA97C: BFA0001E

<label_To_Activation_Gelu_VW1>:
	s_getpc_b64 s[12:13]                                       // 0000006CA980: BE8C4700
	s_add_i32 s8, 0x2854, 4                                    // 0000006CA984: 810884FF 00002854
	s_add_u32 s12, s12, s8                                     // 0000006CA98C: 800C080C
	s_addc_u32 s13, s13, 0                                     // 0000006CA990: 820D800D
	s_branch label_ActivationSetPCAddrEnd                      // 0000006CA994: BFA00018

<label_To_Activation_Relu_VW1>:
	s_getpc_b64 s[12:13]                                       // 0000006CA998: BE8C4700
	s_add_i32 s8, 0x2878, 4                                    // 0000006CA99C: 810884FF 00002878
	s_add_u32 s12, s12, s8                                     // 0000006CA9A4: 800C080C
	s_addc_u32 s13, s13, 0                                     // 0000006CA9A8: 820D800D
	s_branch label_ActivationSetPCAddrEnd                      // 0000006CA9AC: BFA00012

<label_To_Activation_Sigmoid_VW1>:
	s_getpc_b64 s[12:13]                                       // 0000006CA9B0: BE8C4700
	s_add_i32 s8, 0x286c, 4                                    // 0000006CA9B4: 810884FF 0000286C
	s_add_u32 s12, s12, s8                                     // 0000006CA9BC: 800C080C
	s_addc_u32 s13, s13, 0                                     // 0000006CA9C0: 820D800D
	s_branch label_ActivationSetPCAddrEnd                      // 0000006CA9C4: BFA0000C

<label_To_Activation_Silu_VW1>:
	s_getpc_b64 s[12:13]                                       // 0000006CA9C8: BE8C4700
	s_add_i32 s8, 0x286c, 4                                    // 0000006CA9CC: 810884FF 0000286C
	s_add_u32 s12, s12, s8                                     // 0000006CA9D4: 800C080C
	s_addc_u32 s13, s13, 0                                     // 0000006CA9D8: 820D800D
	s_branch label_ActivationSetPCAddrEnd                      // 0000006CA9DC: BFA00006

<label_To_Activation_Clamp_VW1>:
	s_getpc_b64 s[12:13]                                       // 0000006CA9E0: BE8C4700
	s_add_i32 s8, 0x2870, 4                                    // 0000006CA9E4: 810884FF 00002870
	s_add_u32 s12, s12, s8                                     // 0000006CA9EC: 800C080C
	s_addc_u32 s13, s13, 0                                     // 0000006CA9F0: 820D800D
	s_branch label_ActivationSetPCAddrEnd                      // 0000006CA9F4: BFA00000

<label_GW_B0_OptNLL_MB>:
	s_mul_i32 s8, 32, s2                                       // 0000006CA9F8: 960802A0
	v_sub_nc_u32_e64 v21, v8, s8                               // 0000006CA9FC: D5260015 02001108
	v_lshlrev_b32_e32 v21, 2, v21                              // 0000006CAA04: 302A2A82
	s_waitcnt lgkmcnt(0)                                       // 0000006CAA08: BF89FC07
	s_barrier                                                  // 0000006CAA0C: BFBD0000
	ds_load_b32 v30, v21                                       // 0000006CAA10: D8D80000 1E000015
	ds_load_b32 v31, v21 offset:256                            // 0000006CAA18: D8D80100 1F000015
	v_add_lshl_u32 v19, v11, v8, 1                             // 0000006CAA20: D6470013 0206110B
	v_mov_b32_e32 v22, v0                                      // 0000006CAA28: 7E2C0300
	v_mov_b32_e32 v23, v1                                      // 0000006CAA2C: 7E2E0301
	v_mov_b32_e32 v24, v2                                      // 0000006CAA30: 7E300302
	v_mov_b32_e32 v25, v3                                      // 0000006CAA34: 7E320303
	v_mov_b32_e32 v26, v4                                      // 0000006CAA38: 7E340304
	v_mov_b32_e32 v27, v5                                      // 0000006CAA3C: 7E360305
	v_mov_b32_e32 v28, v6                                      // 0000006CAA40: 7E380306
	v_mov_b32_e32 v29, v7                                      // 0000006CAA44: 7E3A0307
	v_mov_b32_e32 v16, 0xffff0000                              // 0000006CAA48: 7E2002FF FFFF0000
	v_mov_b32_e32 v17, 0x7fff0000                              // 0000006CAA50: 7E2202FF 7FFF0000
	v_mov_b32_e32 v18, 0x7fff                                  // 0000006CAA58: 7E2402FF 00007FFF
	s_waitcnt lgkmcnt(0)                                       // 0000006CAA60: BF89FC07
	v_mul_f32_e32 v22, v31, v22                                // 0000006CAA64: 102C2D1F
	v_add_f32_e32 v12, v30, v22                                // 0000006CAA68: 06182D1E
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CAA6C: BE9E490C
	v_mov_b32_e32 v22, v12                                     // 0000006CAA70: 7E2C030C
	v_cmp_u_f32_e64 s8, v22, v22                               // 0000006CAA74: D4180008 02022D16
	v_bfe_u32 v15, v22, 16, 1                                  // 0000006CAA7C: D610000F 02052116
	v_add3_u32 v15, v22, v15, v18                              // 0000006CAA84: D655000F 044A1F16
	v_cndmask_b32_e64 v22, v15, v17, s8                        // 0000006CAA8C: D5010016 0022230F
	v_lshrrev_b32_e32 v22, 16, v22                             // 0000006CAA94: 322C2C90
	buffer_store_b16 v22, v19, s[16:19], 0 offen               // 0000006CAA98: E0640000 80441613
	v_mul_f32_e32 v23, v31, v23                                // 0000006CAAA0: 102E2F1F
	v_add_f32_e32 v12, v30, v23                                // 0000006CAAA4: 06182F1E
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CAAA8: BE9E490C
	v_mov_b32_e32 v23, v12                                     // 0000006CAAAC: 7E2E030C
	v_cmp_u_f32_e64 s8, v23, v23                               // 0000006CAAB0: D4180008 02022F17
	v_bfe_u32 v15, v23, 16, 1                                  // 0000006CAAB8: D610000F 02052117
	v_add3_u32 v15, v23, v15, v18                              // 0000006CAAC0: D655000F 044A1F17
	v_cndmask_b32_e64 v23, v15, v17, s8                        // 0000006CAAC8: D5010017 0022230F
	v_lshrrev_b32_e32 v23, 16, v23                             // 0000006CAAD0: 322E2E90
	s_mul_i32 s8, s36, 4                                       // 0000006CAAD4: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CAAD8: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CAADC: 82118011
	buffer_store_b16 v23, v19, s[16:19], 0 offen               // 0000006CAAE0: E0640000 80441713
	v_mul_f32_e32 v24, v31, v24                                // 0000006CAAE8: 1030311F
	v_add_f32_e32 v12, v30, v24                                // 0000006CAAEC: 0618311E
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CAAF0: BE9E490C
	v_mov_b32_e32 v24, v12                                     // 0000006CAAF4: 7E30030C
	v_cmp_u_f32_e64 s8, v24, v24                               // 0000006CAAF8: D4180008 02023118
	v_bfe_u32 v15, v24, 16, 1                                  // 0000006CAB00: D610000F 02052118
	v_add3_u32 v15, v24, v15, v18                              // 0000006CAB08: D655000F 044A1F18
	v_cndmask_b32_e64 v24, v15, v17, s8                        // 0000006CAB10: D5010018 0022230F
	v_lshrrev_b32_e32 v24, 16, v24                             // 0000006CAB18: 32303090
	s_mul_i32 s8, s36, 4                                       // 0000006CAB1C: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CAB20: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CAB24: 82118011
	buffer_store_b16 v24, v19, s[16:19], 0 offen               // 0000006CAB28: E0640000 80441813
	v_mul_f32_e32 v25, v31, v25                                // 0000006CAB30: 1032331F
	v_add_f32_e32 v12, v30, v25                                // 0000006CAB34: 0618331E
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CAB38: BE9E490C
	v_mov_b32_e32 v25, v12                                     // 0000006CAB3C: 7E32030C
	v_cmp_u_f32_e64 s8, v25, v25                               // 0000006CAB40: D4180008 02023319
	v_bfe_u32 v15, v25, 16, 1                                  // 0000006CAB48: D610000F 02052119
	v_add3_u32 v15, v25, v15, v18                              // 0000006CAB50: D655000F 044A1F19
	v_cndmask_b32_e64 v25, v15, v17, s8                        // 0000006CAB58: D5010019 0022230F
	v_lshrrev_b32_e32 v25, 16, v25                             // 0000006CAB60: 32323290
	s_mul_i32 s8, s36, 4                                       // 0000006CAB64: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CAB68: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CAB6C: 82118011
	buffer_store_b16 v25, v19, s[16:19], 0 offen               // 0000006CAB70: E0640000 80441913
	v_mul_f32_e32 v26, v31, v26                                // 0000006CAB78: 1034351F
	v_add_f32_e32 v12, v30, v26                                // 0000006CAB7C: 0618351E
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CAB80: BE9E490C
	v_mov_b32_e32 v26, v12                                     // 0000006CAB84: 7E34030C
	v_cmp_u_f32_e64 s8, v26, v26                               // 0000006CAB88: D4180008 0202351A
	v_bfe_u32 v15, v26, 16, 1                                  // 0000006CAB90: D610000F 0205211A
	v_add3_u32 v15, v26, v15, v18                              // 0000006CAB98: D655000F 044A1F1A
	v_cndmask_b32_e64 v26, v15, v17, s8                        // 0000006CABA0: D501001A 0022230F
	v_lshrrev_b32_e32 v26, 16, v26                             // 0000006CABA8: 32343490
	s_mul_i32 s8, s36, 4                                       // 0000006CABAC: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CABB0: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CABB4: 82118011
	buffer_store_b16 v26, v19, s[16:19], 0 offen               // 0000006CABB8: E0640000 80441A13
	v_mul_f32_e32 v27, v31, v27                                // 0000006CABC0: 1036371F
	v_add_f32_e32 v12, v30, v27                                // 0000006CABC4: 0618371E
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CABC8: BE9E490C
	v_mov_b32_e32 v27, v12                                     // 0000006CABCC: 7E36030C
	v_cmp_u_f32_e64 s8, v27, v27                               // 0000006CABD0: D4180008 0202371B
	v_bfe_u32 v15, v27, 16, 1                                  // 0000006CABD8: D610000F 0205211B
	v_add3_u32 v15, v27, v15, v18                              // 0000006CABE0: D655000F 044A1F1B
	v_cndmask_b32_e64 v27, v15, v17, s8                        // 0000006CABE8: D501001B 0022230F
	v_lshrrev_b32_e32 v27, 16, v27                             // 0000006CABF0: 32363690
	s_mul_i32 s8, s36, 4                                       // 0000006CABF4: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CABF8: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CABFC: 82118011
	buffer_store_b16 v27, v19, s[16:19], 0 offen               // 0000006CAC00: E0640000 80441B13
	v_mul_f32_e32 v28, v31, v28                                // 0000006CAC08: 1038391F
	v_add_f32_e32 v12, v30, v28                                // 0000006CAC0C: 0618391E
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CAC10: BE9E490C
	v_mov_b32_e32 v28, v12                                     // 0000006CAC14: 7E38030C
	v_cmp_u_f32_e64 s8, v28, v28                               // 0000006CAC18: D4180008 0202391C
	v_bfe_u32 v15, v28, 16, 1                                  // 0000006CAC20: D610000F 0205211C
	v_add3_u32 v15, v28, v15, v18                              // 0000006CAC28: D655000F 044A1F1C
	v_cndmask_b32_e64 v28, v15, v17, s8                        // 0000006CAC30: D501001C 0022230F
	v_lshrrev_b32_e32 v28, 16, v28                             // 0000006CAC38: 32383890
	s_mul_i32 s8, s36, 4                                       // 0000006CAC3C: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CAC40: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CAC44: 82118011
	buffer_store_b16 v28, v19, s[16:19], 0 offen               // 0000006CAC48: E0640000 80441C13
	v_mul_f32_e32 v29, v31, v29                                // 0000006CAC50: 103A3B1F
	v_add_f32_e32 v12, v30, v29                                // 0000006CAC54: 06183B1E
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CAC58: BE9E490C
	v_mov_b32_e32 v29, v12                                     // 0000006CAC5C: 7E3A030C
	v_cmp_u_f32_e64 s8, v29, v29                               // 0000006CAC60: D4180008 02023B1D
	v_bfe_u32 v15, v29, 16, 1                                  // 0000006CAC68: D610000F 0205211D
	v_add3_u32 v15, v29, v15, v18                              // 0000006CAC70: D655000F 044A1F1D
	v_cndmask_b32_e64 v29, v15, v17, s8                        // 0000006CAC78: D501001D 0022230F
	v_lshrrev_b32_e32 v29, 16, v29                             // 0000006CAC80: 323A3A90
	s_mul_i32 s8, s36, 4                                       // 0000006CAC84: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CAC88: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CAC8C: 82118011
	buffer_store_b16 v29, v19, s[16:19], 0 offen               // 0000006CAC90: E0640000 80441D13
	s_nop 0                                                    // 0000006CAC98: BF800000
	s_branch label_GW_End                                      // 0000006CAC9C: BFA00000

<label_GW_End>:
	s_endpgm                                                   // 0000006CACA0: BFB00000

<label_OptNLL_End>:
	s_waitcnt lgkmcnt(0)                                       // 0000006CACA4: BF89FC07
	s_waitcnt lgkmcnt(0)                                       // 0000006CACA8: BF89FC07
	s_barrier                                                  // 0000006CACAC: BFBD0000
	ds_load_u16 v16, v12                                       // 0000006CACB0: D8F00000 1000000C
	ds_load_u16_d16_hi v16, v12 offset:64                      // 0000006CACB8: DA9C0040 1000000C
	ds_load_u16 v17, v12 offset:128                            // 0000006CACC0: D8F00080 1100000C
	ds_load_u16_d16_hi v17, v12 offset:192                     // 0000006CACC8: DA9C00C0 1100000C
	ds_load_u16 v18, v12 offset:256                            // 0000006CACD0: D8F00100 1200000C
	ds_load_u16_d16_hi v18, v12 offset:320                     // 0000006CACD8: DA9C0140 1200000C
	ds_load_u16 v19, v12 offset:384                            // 0000006CACE0: D8F00180 1300000C
	ds_load_u16_d16_hi v19, v12 offset:448                     // 0000006CACE8: DA9C01C0 1300000C
	ds_load_u16 v20, v12 offset:512                            // 0000006CACF0: D8F00200 1400000C
	ds_load_u16_d16_hi v20, v12 offset:576                     // 0000006CACF8: DA9C0240 1400000C
	ds_load_u16 v21, v12 offset:640                            // 0000006CAD00: D8F00280 1500000C
	ds_load_u16_d16_hi v21, v12 offset:704                     // 0000006CAD08: DA9C02C0 1500000C
	ds_load_u16 v22, v12 offset:768                            // 0000006CAD10: D8F00300 1600000C
	ds_load_u16_d16_hi v22, v12 offset:832                     // 0000006CAD18: DA9C0340 1600000C
	ds_load_u16 v23, v12 offset:896                            // 0000006CAD20: D8F00380 1700000C
	ds_load_u16_d16_hi v23, v12 offset:960                     // 0000006CAD28: DA9C03C0 1700000C
	ds_load_u16 v41, v13                                       // 0000006CAD30: D8F00000 2900000D
	ds_load_u16_d16_hi v41, v13 offset:32                      // 0000006CAD38: DA9C0020 2900000D
	ds_load_u16 v42, v13 offset:64                             // 0000006CAD40: D8F00040 2A00000D
	ds_load_u16_d16_hi v42, v13 offset:96                      // 0000006CAD48: DA9C0060 2A00000D
	ds_load_u16 v43, v13 offset:128                            // 0000006CAD50: D8F00080 2B00000D
	ds_load_u16_d16_hi v43, v13 offset:160                     // 0000006CAD58: DA9C00A0 2B00000D
	ds_load_u16 v44, v13 offset:192                            // 0000006CAD60: D8F000C0 2C00000D
	ds_load_u16_d16_hi v44, v13 offset:224                     // 0000006CAD68: DA9C00E0 2C00000D
	ds_load_u16 v45, v13 offset:256                            // 0000006CAD70: D8F00100 2D00000D
	ds_load_u16_d16_hi v45, v13 offset:288                     // 0000006CAD78: DA9C0120 2D00000D
	ds_load_u16 v46, v13 offset:320                            // 0000006CAD80: D8F00140 2E00000D
	ds_load_u16_d16_hi v46, v13 offset:352                     // 0000006CAD88: DA9C0160 2E00000D
	ds_load_u16 v47, v13 offset:384                            // 0000006CAD90: D8F00180 2F00000D
	ds_load_u16_d16_hi v47, v13 offset:416                     // 0000006CAD98: DA9C01A0 2F00000D
	ds_load_u16 v48, v13 offset:448                            // 0000006CADA0: D8F001C0 3000000D
	ds_load_u16_d16_hi v48, v13 offset:480                     // 0000006CADA8: DA9C01E0 3000000D
	s_waitcnt lgkmcnt(0)                                       // 0000006CADB0: BF89FC07
	v_wmma_f32_16x16x16_bf16 v[0:7], v[41:48], v[16:23], v[0:7]// 0000006CADB4: CC414000 1C022129

<label_toPGR1end_OrdNLL>:
	v_and_b32_e32 v10, 0xf007ff, v10                           // 0000006CADBC: 361414FF 00F007FF
	v_and_b32_e32 v11, 0xf007ff, v11                           // 0000006CADC4: 361616FF 00F007FF
	s_and_b32 s12, 15, s27                                     // 0000006CADCC: 8B0C1B8F
	s_and_b32 s66, s46, 0x8000                                 // 0000006CADD0: 8B42FF2E 00008000
	s_cbranch_scc1 label_GSUC_TL                               // 0000006CADD8: BFA20003
	s_cmp_lg_u32 s6, s7                                        // 0000006CADDC: BF070706
	s_cmov_b32 s12, 0                                          // 0000006CADE0: BE8C0280
	s_branch label_GSUC_TL_End                                 // 0000006CADE4: BFA00021

<label_GSUC_TL>:
	s_lshr_b32 s67, s27, 4                                     // 0000006CADE8: 8543841B
	s_and_b32 s68, s46, 0x3fff                                 // 0000006CADEC: 8B44FF2E 00003FFF
	v_cvt_f32_u32_e32 v22, s68                                 // 0000006CADF4: 7E2C0C44
	v_rcp_iflag_f32_e32 v22, v22                               // 0000006CADF8: 7E2C5716
	v_cvt_f32_u32_e32 v23, s67                                 // 0000006CADFC: 7E2E0C43
	v_mul_f32_e32 v22, v22, v23                                // 0000006CAE00: 102C2F16
	v_cvt_u32_f32_e32 v22, v22                                 // 0000006CAE04: 7E2C0F16
	v_mul_u32_u24_e64 v23, v22, s68                            // 0000006CAE08: D50B0017 02008916
	v_sub_nc_u32_e32 v23, s67, v23                             // 0000006CAE10: 4C2E2E43
	v_cmp_eq_u32_e64 vcc_lo, v23, s68                          // 0000006CAE14: D44A006A 02008917
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006CAE1C: BEFE006A
	v_add_nc_u32_e32 v22, 1, v22                               // 0000006CAE20: 4A2C2C81
	v_mov_b32_e32 v23, 0                                       // 0000006CAE24: 7E2E0280
	s_mov_b32 exec_lo, -1                                      // 0000006CAE28: BEFE00C1
	v_cmp_gt_u32_e64 vcc_lo, v23, s68                          // 0000006CAE2C: D44C006A 02008917
	s_mov_b32 exec_lo, vcc_lo                                  // 0000006CAE34: BEFE006A
	v_sub_nc_u32_e64 v22, v22, 1                               // 0000006CAE38: D5260016 02010316
	v_mul_u32_u24_e64 v23, v22, s68                            // 0000006CAE40: D50B0017 02008916
	v_sub_nc_u32_e32 v23, s67, v23                             // 0000006CAE48: 4C2E2E43
	s_mov_b32 exec_lo, -1                                      // 0000006CAE4C: BEFE00C1
	v_readfirstlane_b32 s66, v22                               // 0000006CAE50: 7E840516
	v_readfirstlane_b32 s7, v23                                // 0000006CAE54: 7E0E0517
	s_sub_u32 s67, s68, 1                                      // 0000006CAE58: 80C38144
	s_cmp_eq_u32 s66, 0                                        // 0000006CAE5C: BF068042
	s_cselect_b32 s66, s7, s67                                 // 0000006CAE60: 98424307
	s_cmp_lg_u32 s6, s66                                       // 0000006CAE64: BF074206
	s_cmov_b32 s12, 0                                          // 0000006CAE68: BE8C0280

<label_GSUC_TL_End>:
	s_cmp_eq_u32 s12, 0                                        // 0000006CAE6C: BF06800C
	s_mov_b32 s13, 0                                           // 0000006CAE70: BE8D0080
	s_cbranch_scc1 label_SkipTailLoopL                         // 0000006CAE74: BFA20101
	s_sub_i32 s66, 3, s47                                      // 0000006CAE78: 81C22F83
	s_cmp_ge_i32 s66, 0                                        // 0000006CAE7C: BF038042
	s_cbranch_scc0 label_Negative_LPM0ZMMYGK1YGXY9             // 0000006CAE80: BFA10003
	s_mul_hi_u32 s67, s66, s64                                 // 0000006CAE84: 96C34042
	s_mul_i32 s66, s66, s64                                    // 0000006CAE88: 96424042
	s_branch label_MultiplyDone_79CGQQNDYWFJFW4R               // 0000006CAE8C: BFA00007

<label_Negative_LPM0ZMMYGK1YGXY9>:
	s_abs_i32 s66, s66                                         // 0000006CAE90: BEC21542
	s_mul_hi_u32 s67, s66, s64                                 // 0000006CAE94: 96C34042
	s_mul_i32 s66, s66, s64                                    // 0000006CAE98: 96424042
	s_xor_b32 s66, s66, -1                                     // 0000006CAE9C: 8D42C142
	s_xor_b32 s67, s67, -1                                     // 0000006CAEA0: 8D43C143
	s_add_u32 s66, s66, 1                                      // 0000006CAEA4: 80428142
	s_addc_u32 s67, s67, 0                                     // 0000006CAEA8: 82438043

<label_MultiplyDone_79CGQQNDYWFJFW4R>:
	s_sub_u32 s66, s66, s60                                    // 0000006CAEAC: 80C23C42
	s_subb_u32 s67, s67, s61                                   // 0000006CAEB0: 82C33D43
	s_add_u32 s48, s48, s66                                    // 0000006CAEB4: 80304230
	s_addc_u32 s49, s49, s67                                   // 0000006CAEB8: 82314331
	s_sub_u32 s56, s56, s66                                    // 0000006CAEBC: 80B84238
	s_subb_u32 s57, s57, s67                                   // 0000006CAEC0: 82B94339
	s_cmp_eq_u32 s57, 0                                        // 0000006CAEC4: BF068039
	s_cselect_b32 s50, s56, -1                                 // 0000006CAEC8: 9832C138
	s_sub_i32 s66, 3, s47                                      // 0000006CAECC: 81C22F83
	s_cmp_ge_i32 s66, 0                                        // 0000006CAED0: BF038042
	s_cbranch_scc0 label_Negative_SHXHT960ZD45084D             // 0000006CAED4: BFA10003
	s_mul_hi_u32 s67, s66, s65                                 // 0000006CAED8: 96C34142
	s_mul_i32 s66, s66, s65                                    // 0000006CAEDC: 96424142
	s_branch label_MultiplyDone_7703ND6R0R1LEV2W               // 0000006CAEE0: BFA00007

<label_Negative_SHXHT960ZD45084D>:
	s_abs_i32 s66, s66                                         // 0000006CAEE4: BEC21542
	s_mul_hi_u32 s67, s66, s65                                 // 0000006CAEE8: 96C34142
	s_mul_i32 s66, s66, s65                                    // 0000006CAEEC: 96424142
	s_xor_b32 s66, s66, -1                                     // 0000006CAEF0: 8D42C142
	s_xor_b32 s67, s67, -1                                     // 0000006CAEF4: 8D43C143
	s_add_u32 s66, s66, 1                                      // 0000006CAEF8: 80428142
	s_addc_u32 s67, s67, 0                                     // 0000006CAEFC: 82438043

<label_MultiplyDone_7703ND6R0R1LEV2W>:
	s_sub_u32 s66, s66, s62                                    // 0000006CAF00: 80C23E42
	s_subb_u32 s67, s67, s63                                   // 0000006CAF04: 82C33F43
	s_add_u32 s52, s52, s66                                    // 0000006CAF08: 80344234
	s_addc_u32 s53, s53, s67                                   // 0000006CAF0C: 82354335
	s_sub_u32 s58, s58, s66                                    // 0000006CAF10: 80BA423A
	s_subb_u32 s59, s59, s67                                   // 0000006CAF14: 82BB433B
	s_cmp_eq_u32 s59, 0                                        // 0000006CAF18: BF06803B
	s_cselect_b32 s54, s58, -1                                 // 0000006CAF1C: 9836C13A
	buffer_load_d16_b16 v16, v8, s[48:51], 0 offen             // 0000006CAF20: E0800000 804C1008
	buffer_load_d16_hi_b16 v16, v8, s[48:51], 0 offen offset:2 // 0000006CAF28: E08C0002 804C1008
	buffer_load_d16_b16 v17, v8, s[48:51], 0 offen offset:4    // 0000006CAF30: E0800004 804C1108
	buffer_load_d16_hi_b16 v17, v8, s[48:51], 0 offen offset:6 // 0000006CAF38: E08C0006 804C1108
	buffer_load_d16_b16 v18, v8, s[48:51], 0 offen offset:8    // 0000006CAF40: E0800008 804C1208
	buffer_load_d16_hi_b16 v18, v8, s[48:51], 0 offen offset:10// 0000006CAF48: E08C000A 804C1208
	buffer_load_d16_b16 v19, v8, s[48:51], 0 offen offset:12   // 0000006CAF50: E080000C 804C1308
	buffer_load_d16_hi_b16 v19, v8, s[48:51], 0 offen offset:14// 0000006CAF58: E08C000E 804C1308
	buffer_load_d16_b16 v20, v9, s[52:55], 0 offen             // 0000006CAF60: E0800000 804D1409
	buffer_load_d16_hi_b16 v20, v9, s[52:55], 0 offen offset:2 // 0000006CAF68: E08C0002 804D1409
	buffer_load_d16_b16 v21, v9, s[52:55], 0 offen offset:4    // 0000006CAF70: E0800004 804D1509
	buffer_load_d16_hi_b16 v21, v9, s[52:55], 0 offen offset:6 // 0000006CAF78: E08C0006 804D1509
	s_waitcnt vmcnt(0)                                         // 0000006CAF80: BF8903F7
	s_waitcnt lgkmcnt(0)                                       // 0000006CAF84: BF89FC07
	s_barrier                                                  // 0000006CAF88: BFBD0000
	ds_store_b128 v10, v[16:19]                                // 0000006CAF8C: DB7C0000 0000100A
	ds_store_b16 v11, v20                                      // 0000006CAF94: D87C0000 0000140B
	ds_store_b16_d16_hi v11, v20 offset:32                     // 0000006CAF9C: DA840020 0000140B
	ds_store_b16 v11, v21 offset:64                            // 0000006CAFA4: D87C0040 0000150B
	ds_store_b16_d16_hi v11, v21 offset:96                     // 0000006CAFAC: DA840060 0000150B
	s_waitcnt lgkmcnt(0)                                       // 0000006CAFB4: BF89FC07
	s_waitcnt lgkmcnt(0)                                       // 0000006CAFB8: BF89FC07
	s_barrier                                                  // 0000006CAFBC: BFBD0000
	v_and_b32_e32 v12, 0x7ff, v12                              // 0000006CAFC0: 361818FF 000007FF
	v_and_b32_e32 v13, 0x7ff, v13                              // 0000006CAFC8: 361A1AFF 000007FF

<label_TailLoopBeginL>:
	ds_load_u16 v16, v12                                       // 0000006CAFD0: D8F00000 1000000C
	ds_load_u16_d16_hi v16, v12 offset:64                      // 0000006CAFD8: DA9C0040 1000000C
	ds_load_u16 v17, v12 offset:128                            // 0000006CAFE0: D8F00080 1100000C
	ds_load_u16_d16_hi v17, v12 offset:192                     // 0000006CAFE8: DA9C00C0 1100000C
	ds_load_u16 v18, v12 offset:256                            // 0000006CAFF0: D8F00100 1200000C
	ds_load_u16_d16_hi v18, v12 offset:320                     // 0000006CAFF8: DA9C0140 1200000C
	ds_load_u16 v19, v12 offset:384                            // 0000006CB000: D8F00180 1300000C
	ds_load_u16_d16_hi v19, v12 offset:448                     // 0000006CB008: DA9C01C0 1300000C
	ds_load_u16 v20, v12 offset:512                            // 0000006CB010: D8F00200 1400000C
	ds_load_u16_d16_hi v20, v12 offset:576                     // 0000006CB018: DA9C0240 1400000C
	ds_load_u16 v21, v12 offset:640                            // 0000006CB020: D8F00280 1500000C
	ds_load_u16_d16_hi v21, v12 offset:704                     // 0000006CB028: DA9C02C0 1500000C
	ds_load_u16 v22, v12 offset:768                            // 0000006CB030: D8F00300 1600000C
	ds_load_u16_d16_hi v22, v12 offset:832                     // 0000006CB038: DA9C0340 1600000C
	ds_load_u16 v23, v12 offset:896                            // 0000006CB040: D8F00380 1700000C
	ds_load_u16_d16_hi v23, v12 offset:960                     // 0000006CB048: DA9C03C0 1700000C
	ds_load_u16 v40, v13                                       // 0000006CB050: D8F00000 2800000D
	ds_load_u16_d16_hi v40, v13 offset:32                      // 0000006CB058: DA9C0020 2800000D
	ds_load_u16 v41, v13 offset:64                             // 0000006CB060: D8F00040 2900000D
	ds_load_u16_d16_hi v41, v13 offset:96                      // 0000006CB068: DA9C0060 2900000D
	ds_load_u16 v42, v13 offset:128                            // 0000006CB070: D8F00080 2A00000D
	ds_load_u16_d16_hi v42, v13 offset:160                     // 0000006CB078: DA9C00A0 2A00000D
	ds_load_u16 v43, v13 offset:192                            // 0000006CB080: D8F000C0 2B00000D
	ds_load_u16_d16_hi v43, v13 offset:224                     // 0000006CB088: DA9C00E0 2B00000D
	ds_load_u16 v44, v13 offset:256                            // 0000006CB090: D8F00100 2C00000D
	ds_load_u16_d16_hi v44, v13 offset:288                     // 0000006CB098: DA9C0120 2C00000D
	ds_load_u16 v45, v13 offset:320                            // 0000006CB0A0: D8F00140 2D00000D
	ds_load_u16_d16_hi v45, v13 offset:352                     // 0000006CB0A8: DA9C0160 2D00000D
	ds_load_u16 v46, v13 offset:384                            // 0000006CB0B0: D8F00180 2E00000D
	ds_load_u16_d16_hi v46, v13 offset:416                     // 0000006CB0B8: DA9C01A0 2E00000D
	ds_load_u16 v47, v13 offset:448                            // 0000006CB0C0: D8F001C0 2F00000D
	ds_load_u16_d16_hi v47, v13 offset:480                     // 0000006CB0C8: DA9C01E0 2F00000D
	s_mov_b32 s8, 0x410                                        // 0000006CB0D0: BE8800FF 00000410
	v_add_co_u32 v12, vcc_lo, s8, v12                          // 0000006CB0D8: D7006A0C 02021808
	s_mov_b32 s8, 0x210                                        // 0000006CB0E0: BE8800FF 00000210
	v_add_co_u32 v13, vcc_lo, s8, v13                          // 0000006CB0E8: D7006A0D 02021A08
	s_waitcnt lgkmcnt(0)                                       // 0000006CB0F0: BF89FC07
	s_sub_i32 s66, s12, 1                                      // 0000006CB0F4: 81C2810C
	s_lshr_b32 s67, s66, 2                                     // 0000006CB0F8: 85438242
	s_and_b32 s66, s66, 3                                      // 0000006CB0FC: 8B428342
	s_sub_i32 s66, 3, s66                                      // 0000006CB100: 81C24283
	s_lshl_b32 s66, s66, 4                                     // 0000006CB104: 84428442
	v_cmp_eq_i32_e64 s68, s67, 0                               // 0000006CB108: D4420044 02010043
	v_lshlrev_b64 v[64:65], s66, v[16:17]                      // 0000006CB110: D73C0040 02022042
	v_cndmask_b32_e64 v16, v16, v64, s68                       // 0000006CB118: D5010010 01128110
	v_cndmask_b32_e64 v17, v17, v65, s68                       // 0000006CB120: D5010011 01128311
	v_lshlrev_b64 v[64:65], s66, v[40:41]                      // 0000006CB128: D73C0040 02025042
	v_cndmask_b32_e64 v40, v40, v64, s68                       // 0000006CB130: D5010028 01128128
	v_cndmask_b32_e64 v41, v41, v65, s68                       // 0000006CB138: D5010029 01128329
	v_cmp_eq_i32_e64 s68, s67, 1                               // 0000006CB140: D4420044 02010243
	v_lshlrev_b64 v[64:65], s66, v[18:19]                      // 0000006CB148: D73C0040 02022442
	v_cndmask_b32_e64 v18, v18, v64, s68                       // 0000006CB150: D5010012 01128112
	v_cndmask_b32_e64 v19, v19, v65, s68                       // 0000006CB158: D5010013 01128313
	v_lshlrev_b64 v[64:65], s66, v[42:43]                      // 0000006CB160: D73C0040 02025442
	v_cndmask_b32_e64 v42, v42, v64, s68                       // 0000006CB168: D501002A 0112812A
	v_cndmask_b32_e64 v43, v43, v65, s68                       // 0000006CB170: D501002B 0112832B
	v_cmp_lt_i32_e64 s68, s67, 1                               // 0000006CB178: D4410044 02010243
	v_cndmask_b32_e64 v18, v18, 0, s68                         // 0000006CB180: D5010012 01110112
	v_cndmask_b32_e64 v19, v19, 0, s68                         // 0000006CB188: D5010013 01110113
	v_cndmask_b32_e64 v42, v42, 0, s68                         // 0000006CB190: D501002A 0111012A
	v_cndmask_b32_e64 v43, v43, 0, s68                         // 0000006CB198: D501002B 0111012B
	v_cmp_eq_i32_e64 s68, s67, 2                               // 0000006CB1A0: D4420044 02010443
	v_lshlrev_b64 v[64:65], s66, v[20:21]                      // 0000006CB1A8: D73C0040 02022842
	v_cndmask_b32_e64 v20, v20, v64, s68                       // 0000006CB1B0: D5010014 01128114
	v_cndmask_b32_e64 v21, v21, v65, s68                       // 0000006CB1B8: D5010015 01128315
	v_lshlrev_b64 v[64:65], s66, v[44:45]                      // 0000006CB1C0: D73C0040 02025842
	v_cndmask_b32_e64 v44, v44, v64, s68                       // 0000006CB1C8: D501002C 0112812C
	v_cndmask_b32_e64 v45, v45, v65, s68                       // 0000006CB1D0: D501002D 0112832D
	v_cmp_lt_i32_e64 s68, s67, 2                               // 0000006CB1D8: D4410044 02010443
	v_cndmask_b32_e64 v20, v20, 0, s68                         // 0000006CB1E0: D5010014 01110114
	v_cndmask_b32_e64 v21, v21, 0, s68                         // 0000006CB1E8: D5010015 01110115
	v_cndmask_b32_e64 v44, v44, 0, s68                         // 0000006CB1F0: D501002C 0111012C
	v_cndmask_b32_e64 v45, v45, 0, s68                         // 0000006CB1F8: D501002D 0111012D
	v_cmp_eq_i32_e64 s68, s67, 3                               // 0000006CB200: D4420044 02010643
	v_lshlrev_b64 v[64:65], s66, v[22:23]                      // 0000006CB208: D73C0040 02022C42
	v_cndmask_b32_e64 v22, v22, v64, s68                       // 0000006CB210: D5010016 01128116
	v_cndmask_b32_e64 v23, v23, v65, s68                       // 0000006CB218: D5010017 01128317
	v_lshlrev_b64 v[64:65], s66, v[46:47]                      // 0000006CB220: D73C0040 02025C42
	v_cndmask_b32_e64 v46, v46, v64, s68                       // 0000006CB228: D501002E 0112812E
	v_cndmask_b32_e64 v47, v47, v65, s68                       // 0000006CB230: D501002F 0112832F
	v_cmp_lt_i32_e64 s68, s67, 3                               // 0000006CB238: D4410044 02010643
	v_cndmask_b32_e64 v22, v22, 0, s68                         // 0000006CB240: D5010016 01110116
	v_cndmask_b32_e64 v23, v23, 0, s68                         // 0000006CB248: D5010017 01110117
	v_cndmask_b32_e64 v46, v46, 0, s68                         // 0000006CB250: D501002E 0111012E
	v_cndmask_b32_e64 v47, v47, 0, s68                         // 0000006CB258: D501002F 0111012F
	s_nop 1                                                    // 0000006CB260: BF800001
	v_wmma_f32_16x16x16_bf16 v[0:7], v[40:47], v[16:23], v[0:7]// 0000006CB264: CC414000 1C022128
	s_sub_i32 s12, s12, 16                                     // 0000006CB26C: 818C900C
	s_add_u32 s13, s13, 16                                     // 0000006CB270: 800D900D
	s_cmp_le_i32 s12, 0                                        // 0000006CB274: BF05800C
	s_cbranch_scc0 label_TailLoopBeginL                        // 0000006CB278: BFA1FF55

<label_TailLoopEndL>:
	s_and_b32 s8, s46, 0x3fff                                  // 0000006CB27C: 8B08FF2E 00003FFF
	s_cmp_eq_u32 s8, 1                                         // 0000006CB284: BF068108
	s_cbranch_scc0 label_GSU_4                                 // 0000006CB288: BFA1000F
	s_cmp_eq_u32 s5, 2                                         // 0000006CB28C: BF068205
	s_cbranch_scc1 label_LoadExternalEpilogueStruct_1          // 0000006CB290: BFA20005
	s_load_b256 s[48:55], s[0:1], 0x58                         // 0000006CB294: F40C0C00 F8000058
	s_load_b32 s56, s[0:1], 0x78                               // 0000006CB29C: F4000E00 F8000078
	s_branch label_GSU_4                                       // 0000006CB2A4: BFA00008

<label_LoadExternalEpilogueStruct_1>:
	s_load_b128 s[48:51], s[0:1], 0x90                         // 0000006CB2A8: F4080C00 F8000090
	s_load_b64 s[52:53], s[0:1], 0xa0                          // 0000006CB2B0: F4040D00 F80000A0
	s_load_b64 s[54:55], s[0:1], 0xb8                          // 0000006CB2B8: F4040D80 F80000B8
	s_load_b32 s56, s[0:1], 0xc0                               // 0000006CB2C0: F4000E00 F80000C0

<label_LoadExternalEpilogueStructEnd_1>:
	v_mov_b32_e32 v11, s2                                      // 0000006CB2C8: 7E160202
	v_mul_i32_i24_e32 v11, 0xffffffe0, v11                     // 0000006CB2CC: 121616FF FFFFFFE0
	v_add_co_u32 v11, vcc_lo, s24, v11                         // 0000006CB2D4: D7006A0B 02021618
	v_mov_b32_e32 v12, 32                                      // 0000006CB2DC: 7E1802A0
	v_cmp_lt_u32_e64 s8, v11, v12                              // 0000006CB2E0: D4490008 0202190B
	v_cndmask_b32_e64 v11, v12, v11, s8                        // 0000006CB2E8: D501000B 0022170C
	v_lshrrev_b32_e32 v13, 5, v72                              // 0000006CB2F0: 321A9085
	v_and_b32_e32 v13, 1, v13                                  // 0000006CB2F4: 361A1A81
	v_lshrrev_b32_e32 v14, 4, v11                              // 0000006CB2F8: 321C1684
	v_and_b32_e32 v14, 1, v14                                  // 0000006CB2FC: 361C1C81
	v_cmp_eq_u32_e64 s8, v14, v13                              // 0000006CB300: D44A0008 02021B0E
	v_cndmask_b32_e64 v11, v12, v11, s8                        // 0000006CB308: D501000B 0022170C
	v_lshrrev_b32_e32 v12, 4, v11                              // 0000006CB310: 32181684
	v_lshlrev_b32_e32 v14, 0, v13                              // 0000006CB314: 301C1A80
	v_sub_nc_u32_e32 v12, v12, v14                             // 0000006CB318: 4C181D0C
	v_lshrrev_b32_e32 v14, 3, v11                              // 0000006CB31C: 321C1683
	v_lshrrev_b32_e32 v15, 0, v72                              // 0000006CB320: 321E9080
	v_and_b32_e32 v15, 15, v15                                 // 0000006CB324: 361E1E8F
	v_lshrrev_b32_e32 v15, 3, v15                              // 0000006CB328: 321E1E83
	v_lshlrev_b32_e32 v13, 1, v13                              // 0000006CB32C: 301A1A81
	v_add_co_u32 v15, vcc_lo, v13, v15                         // 0000006CB330: D7006A0F 02021F0D
	v_sub_nc_u32_e32 v14, v14, v15                             // 0000006CB338: 4C1C1F0E
	v_and_b32_e32 v13, 0, v11                                  // 0000006CB33C: 361A1680
	v_lshrrev_b32_e32 v13, 3, v13                              // 0000006CB340: 321A1A83
	v_and_b32_e32 v15, 7, v11                                  // 0000006CB344: 361E1687
	v_cmp_eq_u32_e64 vcc_lo, v15, 1                            // 0000006CB348: D44A006A 0201030F
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW1         // 0000006CB350: BFA40013
	v_cmp_eq_u32_e64 vcc_lo, v15, 2                            // 0000006CB354: D44A006A 0201050F
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW2         // 0000006CB35C: BFA40013
	v_cmp_eq_u32_e64 vcc_lo, v15, 3                            // 0000006CB360: D44A006A 0201070F
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW3         // 0000006CB368: BFA40013
	v_cmp_eq_u32_e64 vcc_lo, v15, 4                            // 0000006CB36C: D44A006A 0201090F
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW4         // 0000006CB374: BFA40013
	v_cmp_eq_u32_e64 vcc_lo, v15, 5                            // 0000006CB378: D44A006A 02010B0F
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW5         // 0000006CB380: BFA40013
	v_cmp_eq_u32_e64 vcc_lo, v15, 6                            // 0000006CB384: D44A006A 02010D0F
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW6         // 0000006CB38C: BFA40013
	v_cmp_eq_u32_e64 vcc_lo, v15, 7                            // 0000006CB390: D44A006A 02010F0F
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW7         // 0000006CB398: BFA40013
	s_branch label_ShiftVectorComponents0_GLVW0                // 0000006CB39C: BFA001B9

<label_ShiftVectorComponents0_GLVW1>:
	v_cmp_eq_u32_e64 vcc_lo, v12, 0                            // 0000006CB3A0: D44A006A 0201010C
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW1_BM0     // 0000006CB3A8: BFA40012

<label_ShiftVectorComponents0_GLVW2>:
	v_cmp_eq_u32_e64 vcc_lo, v12, 0                            // 0000006CB3AC: D44A006A 0201010C
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW2_BM0     // 0000006CB3B4: BFA40012

<label_ShiftVectorComponents0_GLVW3>:
	v_cmp_eq_u32_e64 vcc_lo, v12, 0                            // 0000006CB3B8: D44A006A 0201010C
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW3_BM0     // 0000006CB3C0: BFA40012

<label_ShiftVectorComponents0_GLVW4>:
	v_cmp_eq_u32_e64 vcc_lo, v12, 0                            // 0000006CB3C4: D44A006A 0201010C
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW4_BM0     // 0000006CB3CC: BFA40012

<label_ShiftVectorComponents0_GLVW5>:
	v_cmp_eq_u32_e64 vcc_lo, v12, 0                            // 0000006CB3D0: D44A006A 0201010C
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW5_BM0     // 0000006CB3D8: BFA40012

<label_ShiftVectorComponents0_GLVW6>:
	v_cmp_eq_u32_e64 vcc_lo, v12, 0                            // 0000006CB3DC: D44A006A 0201010C
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW6_BM0     // 0000006CB3E4: BFA40012

<label_ShiftVectorComponents0_GLVW7>:
	v_cmp_eq_u32_e64 vcc_lo, v12, 0                            // 0000006CB3E8: D44A006A 0201010C
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW7_BM0     // 0000006CB3F0: BFA40012

<label_ShiftVectorComponents0_GLVW1_BM0>:
	v_cmp_eq_u32_e64 vcc_lo, v13, 0                            // 0000006CB3F4: D44A006A 0201010D
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW1_BM0_VW0 // 0000006CB3FC: BFA40012

<label_ShiftVectorComponents0_GLVW2_BM0>:
	v_cmp_eq_u32_e64 vcc_lo, v13, 0                            // 0000006CB400: D44A006A 0201010D
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW2_BM0_VW0 // 0000006CB408: BFA40048

<label_ShiftVectorComponents0_GLVW3_BM0>:
	v_cmp_eq_u32_e64 vcc_lo, v13, 0                            // 0000006CB40C: D44A006A 0201010D
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW3_BM0_VW0 // 0000006CB414: BFA4007E

<label_ShiftVectorComponents0_GLVW4_BM0>:
	v_cmp_eq_u32_e64 vcc_lo, v13, 0                            // 0000006CB418: D44A006A 0201010D
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW4_BM0_VW0 // 0000006CB420: BFA400B4

<label_ShiftVectorComponents0_GLVW5_BM0>:
	v_cmp_eq_u32_e64 vcc_lo, v13, 0                            // 0000006CB424: D44A006A 0201010D
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW5_BM0_VW0 // 0000006CB42C: BFA400EA

<label_ShiftVectorComponents0_GLVW6_BM0>:
	v_cmp_eq_u32_e64 vcc_lo, v13, 0                            // 0000006CB430: D44A006A 0201010D
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW6_BM0_VW0 // 0000006CB438: BFA40120

<label_ShiftVectorComponents0_GLVW7_BM0>:
	v_cmp_eq_u32_e64 vcc_lo, v13, 0                            // 0000006CB43C: D44A006A 0201010D
	s_cbranch_vccnz label_ShiftVectorComponents0_GLVW7_BM0_VW0 // 0000006CB444: BFA40156

<label_ShiftVectorComponents0_GLVW1_BM0_VW0>:
	s_mov_b32 s8, 0                                            // 0000006CB448: BE880080
	v_cmp_eq_u32_e64 s8, v14, s8                               // 0000006CB44C: D44A0008 0200110E
	s_mov_b32 exec_lo, s8                                      // 0000006CB454: BEFE0008
	v_and_b32_e32 v8, 31, v72                                  // 0000006CB458: 3610909F
	v_lshlrev_b32_e32 v8, 2, v8                                // 0000006CB45C: 30101082
	v_mov_b32_e32 v15, v0                                      // 0000006CB460: 7E1E0300
	ds_bpermute_b32 v15, v8, v15 offset:28                     // 0000006CB464: DACC001C 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB46C: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB470: BC7C0000
	v_mov_b32_e32 v0, v15                                      // 0000006CB474: 7E00030F
	v_mov_b32_e32 v15, v1                                      // 0000006CB478: 7E1E0301
	ds_bpermute_b32 v15, v8, v15 offset:28                     // 0000006CB47C: DACC001C 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB484: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB488: BC7C0000
	v_mov_b32_e32 v1, v15                                      // 0000006CB48C: 7E02030F
	v_mov_b32_e32 v15, v2                                      // 0000006CB490: 7E1E0302
	ds_bpermute_b32 v15, v8, v15 offset:28                     // 0000006CB494: DACC001C 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB49C: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB4A0: BC7C0000
	v_mov_b32_e32 v2, v15                                      // 0000006CB4A4: 7E04030F
	v_mov_b32_e32 v15, v3                                      // 0000006CB4A8: 7E1E0303
	ds_bpermute_b32 v15, v8, v15 offset:28                     // 0000006CB4AC: DACC001C 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB4B4: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB4B8: BC7C0000
	v_mov_b32_e32 v3, v15                                      // 0000006CB4BC: 7E06030F
	v_mov_b32_e32 v15, v4                                      // 0000006CB4C0: 7E1E0304
	ds_bpermute_b32 v15, v8, v15 offset:28                     // 0000006CB4C4: DACC001C 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB4CC: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB4D0: BC7C0000
	v_mov_b32_e32 v4, v15                                      // 0000006CB4D4: 7E08030F
	v_mov_b32_e32 v15, v5                                      // 0000006CB4D8: 7E1E0305
	ds_bpermute_b32 v15, v8, v15 offset:28                     // 0000006CB4DC: DACC001C 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB4E4: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB4E8: BC7C0000
	v_mov_b32_e32 v5, v15                                      // 0000006CB4EC: 7E0A030F
	v_mov_b32_e32 v15, v6                                      // 0000006CB4F0: 7E1E0306
	ds_bpermute_b32 v15, v8, v15 offset:28                     // 0000006CB4F4: DACC001C 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB4FC: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB500: BC7C0000
	v_mov_b32_e32 v6, v15                                      // 0000006CB504: 7E0C030F
	v_mov_b32_e32 v15, v7                                      // 0000006CB508: 7E1E0307
	ds_bpermute_b32 v15, v8, v15 offset:28                     // 0000006CB50C: DACC001C 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB514: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB518: BC7C0000
	v_mov_b32_e32 v7, v15                                      // 0000006CB51C: 7E0E030F
	s_mov_b32 s8, -1                                           // 0000006CB520: BE8800C1
	s_or_saveexec_b32 vcc_lo, s8                               // 0000006CB524: BEEA2208
	s_branch label_ShiftVectorComponents0_GLVW0                // 0000006CB528: BFA00156

<label_ShiftVectorComponents0_GLVW2_BM0_VW0>:
	s_mov_b32 s8, 0                                            // 0000006CB52C: BE880080
	v_cmp_eq_u32_e64 s8, v14, s8                               // 0000006CB530: D44A0008 0200110E
	s_mov_b32 exec_lo, s8                                      // 0000006CB538: BEFE0008
	v_and_b32_e32 v8, 31, v72                                  // 0000006CB53C: 3610909F
	v_lshlrev_b32_e32 v8, 2, v8                                // 0000006CB540: 30101082
	v_mov_b32_e32 v15, v0                                      // 0000006CB544: 7E1E0300
	ds_bpermute_b32 v15, v8, v15 offset:24                     // 0000006CB548: DACC0018 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB550: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB554: BC7C0000
	v_mov_b32_e32 v0, v15                                      // 0000006CB558: 7E00030F
	v_mov_b32_e32 v15, v1                                      // 0000006CB55C: 7E1E0301
	ds_bpermute_b32 v15, v8, v15 offset:24                     // 0000006CB560: DACC0018 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB568: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB56C: BC7C0000
	v_mov_b32_e32 v1, v15                                      // 0000006CB570: 7E02030F
	v_mov_b32_e32 v15, v2                                      // 0000006CB574: 7E1E0302
	ds_bpermute_b32 v15, v8, v15 offset:24                     // 0000006CB578: DACC0018 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB580: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB584: BC7C0000
	v_mov_b32_e32 v2, v15                                      // 0000006CB588: 7E04030F
	v_mov_b32_e32 v15, v3                                      // 0000006CB58C: 7E1E0303
	ds_bpermute_b32 v15, v8, v15 offset:24                     // 0000006CB590: DACC0018 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB598: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB59C: BC7C0000
	v_mov_b32_e32 v3, v15                                      // 0000006CB5A0: 7E06030F
	v_mov_b32_e32 v15, v4                                      // 0000006CB5A4: 7E1E0304
	ds_bpermute_b32 v15, v8, v15 offset:24                     // 0000006CB5A8: DACC0018 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB5B0: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB5B4: BC7C0000
	v_mov_b32_e32 v4, v15                                      // 0000006CB5B8: 7E08030F
	v_mov_b32_e32 v15, v5                                      // 0000006CB5BC: 7E1E0305
	ds_bpermute_b32 v15, v8, v15 offset:24                     // 0000006CB5C0: DACC0018 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB5C8: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB5CC: BC7C0000
	v_mov_b32_e32 v5, v15                                      // 0000006CB5D0: 7E0A030F
	v_mov_b32_e32 v15, v6                                      // 0000006CB5D4: 7E1E0306
	ds_bpermute_b32 v15, v8, v15 offset:24                     // 0000006CB5D8: DACC0018 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB5E0: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB5E4: BC7C0000
	v_mov_b32_e32 v6, v15                                      // 0000006CB5E8: 7E0C030F
	v_mov_b32_e32 v15, v7                                      // 0000006CB5EC: 7E1E0307
	ds_bpermute_b32 v15, v8, v15 offset:24                     // 0000006CB5F0: DACC0018 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB5F8: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB5FC: BC7C0000
	v_mov_b32_e32 v7, v15                                      // 0000006CB600: 7E0E030F
	s_mov_b32 s8, -1                                           // 0000006CB604: BE8800C1
	s_or_saveexec_b32 vcc_lo, s8                               // 0000006CB608: BEEA2208
	s_branch label_ShiftVectorComponents0_GLVW0                // 0000006CB60C: BFA0011D

<label_ShiftVectorComponents0_GLVW3_BM0_VW0>:
	s_mov_b32 s8, 0                                            // 0000006CB610: BE880080
	v_cmp_eq_u32_e64 s8, v14, s8                               // 0000006CB614: D44A0008 0200110E
	s_mov_b32 exec_lo, s8                                      // 0000006CB61C: BEFE0008
	v_and_b32_e32 v8, 31, v72                                  // 0000006CB620: 3610909F
	v_lshlrev_b32_e32 v8, 2, v8                                // 0000006CB624: 30101082
	v_mov_b32_e32 v15, v0                                      // 0000006CB628: 7E1E0300
	ds_bpermute_b32 v15, v8, v15 offset:20                     // 0000006CB62C: DACC0014 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB634: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB638: BC7C0000
	v_mov_b32_e32 v0, v15                                      // 0000006CB63C: 7E00030F
	v_mov_b32_e32 v15, v1                                      // 0000006CB640: 7E1E0301
	ds_bpermute_b32 v15, v8, v15 offset:20                     // 0000006CB644: DACC0014 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB64C: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB650: BC7C0000
	v_mov_b32_e32 v1, v15                                      // 0000006CB654: 7E02030F
	v_mov_b32_e32 v15, v2                                      // 0000006CB658: 7E1E0302
	ds_bpermute_b32 v15, v8, v15 offset:20                     // 0000006CB65C: DACC0014 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB664: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB668: BC7C0000
	v_mov_b32_e32 v2, v15                                      // 0000006CB66C: 7E04030F
	v_mov_b32_e32 v15, v3                                      // 0000006CB670: 7E1E0303
	ds_bpermute_b32 v15, v8, v15 offset:20                     // 0000006CB674: DACC0014 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB67C: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB680: BC7C0000
	v_mov_b32_e32 v3, v15                                      // 0000006CB684: 7E06030F
	v_mov_b32_e32 v15, v4                                      // 0000006CB688: 7E1E0304
	ds_bpermute_b32 v15, v8, v15 offset:20                     // 0000006CB68C: DACC0014 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB694: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB698: BC7C0000
	v_mov_b32_e32 v4, v15                                      // 0000006CB69C: 7E08030F
	v_mov_b32_e32 v15, v5                                      // 0000006CB6A0: 7E1E0305
	ds_bpermute_b32 v15, v8, v15 offset:20                     // 0000006CB6A4: DACC0014 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB6AC: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB6B0: BC7C0000
	v_mov_b32_e32 v5, v15                                      // 0000006CB6B4: 7E0A030F
	v_mov_b32_e32 v15, v6                                      // 0000006CB6B8: 7E1E0306
	ds_bpermute_b32 v15, v8, v15 offset:20                     // 0000006CB6BC: DACC0014 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB6C4: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB6C8: BC7C0000
	v_mov_b32_e32 v6, v15                                      // 0000006CB6CC: 7E0C030F
	v_mov_b32_e32 v15, v7                                      // 0000006CB6D0: 7E1E0307
	ds_bpermute_b32 v15, v8, v15 offset:20                     // 0000006CB6D4: DACC0014 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB6DC: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB6E0: BC7C0000
	v_mov_b32_e32 v7, v15                                      // 0000006CB6E4: 7E0E030F
	s_mov_b32 s8, -1                                           // 0000006CB6E8: BE8800C1
	s_or_saveexec_b32 vcc_lo, s8                               // 0000006CB6EC: BEEA2208
	s_branch label_ShiftVectorComponents0_GLVW0                // 0000006CB6F0: BFA000E4

<label_ShiftVectorComponents0_GLVW4_BM0_VW0>:
	s_mov_b32 s8, 0                                            // 0000006CB6F4: BE880080
	v_cmp_eq_u32_e64 s8, v14, s8                               // 0000006CB6F8: D44A0008 0200110E
	s_mov_b32 exec_lo, s8                                      // 0000006CB700: BEFE0008
	v_and_b32_e32 v8, 31, v72                                  // 0000006CB704: 3610909F
	v_lshlrev_b32_e32 v8, 2, v8                                // 0000006CB708: 30101082
	v_mov_b32_e32 v15, v0                                      // 0000006CB70C: 7E1E0300
	ds_bpermute_b32 v15, v8, v15 offset:16                     // 0000006CB710: DACC0010 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB718: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB71C: BC7C0000
	v_mov_b32_e32 v0, v15                                      // 0000006CB720: 7E00030F
	v_mov_b32_e32 v15, v1                                      // 0000006CB724: 7E1E0301
	ds_bpermute_b32 v15, v8, v15 offset:16                     // 0000006CB728: DACC0010 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB730: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB734: BC7C0000
	v_mov_b32_e32 v1, v15                                      // 0000006CB738: 7E02030F
	v_mov_b32_e32 v15, v2                                      // 0000006CB73C: 7E1E0302
	ds_bpermute_b32 v15, v8, v15 offset:16                     // 0000006CB740: DACC0010 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB748: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB74C: BC7C0000
	v_mov_b32_e32 v2, v15                                      // 0000006CB750: 7E04030F
	v_mov_b32_e32 v15, v3                                      // 0000006CB754: 7E1E0303
	ds_bpermute_b32 v15, v8, v15 offset:16                     // 0000006CB758: DACC0010 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB760: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB764: BC7C0000
	v_mov_b32_e32 v3, v15                                      // 0000006CB768: 7E06030F
	v_mov_b32_e32 v15, v4                                      // 0000006CB76C: 7E1E0304
	ds_bpermute_b32 v15, v8, v15 offset:16                     // 0000006CB770: DACC0010 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB778: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB77C: BC7C0000
	v_mov_b32_e32 v4, v15                                      // 0000006CB780: 7E08030F
	v_mov_b32_e32 v15, v5                                      // 0000006CB784: 7E1E0305
	ds_bpermute_b32 v15, v8, v15 offset:16                     // 0000006CB788: DACC0010 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB790: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB794: BC7C0000
	v_mov_b32_e32 v5, v15                                      // 0000006CB798: 7E0A030F
	v_mov_b32_e32 v15, v6                                      // 0000006CB79C: 7E1E0306
	ds_bpermute_b32 v15, v8, v15 offset:16                     // 0000006CB7A0: DACC0010 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB7A8: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB7AC: BC7C0000
	v_mov_b32_e32 v6, v15                                      // 0000006CB7B0: 7E0C030F
	v_mov_b32_e32 v15, v7                                      // 0000006CB7B4: 7E1E0307
	ds_bpermute_b32 v15, v8, v15 offset:16                     // 0000006CB7B8: DACC0010 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB7C0: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB7C4: BC7C0000
	v_mov_b32_e32 v7, v15                                      // 0000006CB7C8: 7E0E030F
	s_mov_b32 s8, -1                                           // 0000006CB7CC: BE8800C1
	s_or_saveexec_b32 vcc_lo, s8                               // 0000006CB7D0: BEEA2208
	s_branch label_ShiftVectorComponents0_GLVW0                // 0000006CB7D4: BFA000AB

<label_ShiftVectorComponents0_GLVW5_BM0_VW0>:
	s_mov_b32 s8, 0                                            // 0000006CB7D8: BE880080
	v_cmp_eq_u32_e64 s8, v14, s8                               // 0000006CB7DC: D44A0008 0200110E
	s_mov_b32 exec_lo, s8                                      // 0000006CB7E4: BEFE0008
	v_and_b32_e32 v8, 31, v72                                  // 0000006CB7E8: 3610909F
	v_lshlrev_b32_e32 v8, 2, v8                                // 0000006CB7EC: 30101082
	v_mov_b32_e32 v15, v0                                      // 0000006CB7F0: 7E1E0300
	ds_bpermute_b32 v15, v8, v15 offset:12                     // 0000006CB7F4: DACC000C 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB7FC: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB800: BC7C0000
	v_mov_b32_e32 v0, v15                                      // 0000006CB804: 7E00030F
	v_mov_b32_e32 v15, v1                                      // 0000006CB808: 7E1E0301
	ds_bpermute_b32 v15, v8, v15 offset:12                     // 0000006CB80C: DACC000C 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB814: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB818: BC7C0000
	v_mov_b32_e32 v1, v15                                      // 0000006CB81C: 7E02030F
	v_mov_b32_e32 v15, v2                                      // 0000006CB820: 7E1E0302
	ds_bpermute_b32 v15, v8, v15 offset:12                     // 0000006CB824: DACC000C 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB82C: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB830: BC7C0000
	v_mov_b32_e32 v2, v15                                      // 0000006CB834: 7E04030F
	v_mov_b32_e32 v15, v3                                      // 0000006CB838: 7E1E0303
	ds_bpermute_b32 v15, v8, v15 offset:12                     // 0000006CB83C: DACC000C 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB844: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB848: BC7C0000
	v_mov_b32_e32 v3, v15                                      // 0000006CB84C: 7E06030F
	v_mov_b32_e32 v15, v4                                      // 0000006CB850: 7E1E0304
	ds_bpermute_b32 v15, v8, v15 offset:12                     // 0000006CB854: DACC000C 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB85C: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB860: BC7C0000
	v_mov_b32_e32 v4, v15                                      // 0000006CB864: 7E08030F
	v_mov_b32_e32 v15, v5                                      // 0000006CB868: 7E1E0305
	ds_bpermute_b32 v15, v8, v15 offset:12                     // 0000006CB86C: DACC000C 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB874: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB878: BC7C0000
	v_mov_b32_e32 v5, v15                                      // 0000006CB87C: 7E0A030F
	v_mov_b32_e32 v15, v6                                      // 0000006CB880: 7E1E0306
	ds_bpermute_b32 v15, v8, v15 offset:12                     // 0000006CB884: DACC000C 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB88C: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB890: BC7C0000
	v_mov_b32_e32 v6, v15                                      // 0000006CB894: 7E0C030F
	v_mov_b32_e32 v15, v7                                      // 0000006CB898: 7E1E0307
	ds_bpermute_b32 v15, v8, v15 offset:12                     // 0000006CB89C: DACC000C 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB8A4: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB8A8: BC7C0000
	v_mov_b32_e32 v7, v15                                      // 0000006CB8AC: 7E0E030F
	s_mov_b32 s8, -1                                           // 0000006CB8B0: BE8800C1
	s_or_saveexec_b32 vcc_lo, s8                               // 0000006CB8B4: BEEA2208
	s_branch label_ShiftVectorComponents0_GLVW0                // 0000006CB8B8: BFA00072

<label_ShiftVectorComponents0_GLVW6_BM0_VW0>:
	s_mov_b32 s8, 0                                            // 0000006CB8BC: BE880080
	v_cmp_eq_u32_e64 s8, v14, s8                               // 0000006CB8C0: D44A0008 0200110E
	s_mov_b32 exec_lo, s8                                      // 0000006CB8C8: BEFE0008
	v_and_b32_e32 v8, 31, v72                                  // 0000006CB8CC: 3610909F
	v_lshlrev_b32_e32 v8, 2, v8                                // 0000006CB8D0: 30101082
	v_mov_b32_e32 v15, v0                                      // 0000006CB8D4: 7E1E0300
	ds_bpermute_b32 v15, v8, v15 offset:8                      // 0000006CB8D8: DACC0008 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB8E0: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB8E4: BC7C0000
	v_mov_b32_e32 v0, v15                                      // 0000006CB8E8: 7E00030F
	v_mov_b32_e32 v15, v1                                      // 0000006CB8EC: 7E1E0301
	ds_bpermute_b32 v15, v8, v15 offset:8                      // 0000006CB8F0: DACC0008 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB8F8: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB8FC: BC7C0000
	v_mov_b32_e32 v1, v15                                      // 0000006CB900: 7E02030F
	v_mov_b32_e32 v15, v2                                      // 0000006CB904: 7E1E0302
	ds_bpermute_b32 v15, v8, v15 offset:8                      // 0000006CB908: DACC0008 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB910: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB914: BC7C0000
	v_mov_b32_e32 v2, v15                                      // 0000006CB918: 7E04030F
	v_mov_b32_e32 v15, v3                                      // 0000006CB91C: 7E1E0303
	ds_bpermute_b32 v15, v8, v15 offset:8                      // 0000006CB920: DACC0008 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB928: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB92C: BC7C0000
	v_mov_b32_e32 v3, v15                                      // 0000006CB930: 7E06030F
	v_mov_b32_e32 v15, v4                                      // 0000006CB934: 7E1E0304
	ds_bpermute_b32 v15, v8, v15 offset:8                      // 0000006CB938: DACC0008 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB940: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB944: BC7C0000
	v_mov_b32_e32 v4, v15                                      // 0000006CB948: 7E08030F
	v_mov_b32_e32 v15, v5                                      // 0000006CB94C: 7E1E0305
	ds_bpermute_b32 v15, v8, v15 offset:8                      // 0000006CB950: DACC0008 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB958: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB95C: BC7C0000
	v_mov_b32_e32 v5, v15                                      // 0000006CB960: 7E0A030F
	v_mov_b32_e32 v15, v6                                      // 0000006CB964: 7E1E0306
	ds_bpermute_b32 v15, v8, v15 offset:8                      // 0000006CB968: DACC0008 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB970: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB974: BC7C0000
	v_mov_b32_e32 v6, v15                                      // 0000006CB978: 7E0C030F
	v_mov_b32_e32 v15, v7                                      // 0000006CB97C: 7E1E0307
	ds_bpermute_b32 v15, v8, v15 offset:8                      // 0000006CB980: DACC0008 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB988: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB98C: BC7C0000
	v_mov_b32_e32 v7, v15                                      // 0000006CB990: 7E0E030F
	s_mov_b32 s8, -1                                           // 0000006CB994: BE8800C1
	s_or_saveexec_b32 vcc_lo, s8                               // 0000006CB998: BEEA2208
	s_branch label_ShiftVectorComponents0_GLVW0                // 0000006CB99C: BFA00039

<label_ShiftVectorComponents0_GLVW7_BM0_VW0>:
	s_mov_b32 s8, 0                                            // 0000006CB9A0: BE880080
	v_cmp_eq_u32_e64 s8, v14, s8                               // 0000006CB9A4: D44A0008 0200110E
	s_mov_b32 exec_lo, s8                                      // 0000006CB9AC: BEFE0008
	v_and_b32_e32 v8, 31, v72                                  // 0000006CB9B0: 3610909F
	v_lshlrev_b32_e32 v8, 2, v8                                // 0000006CB9B4: 30101082
	v_mov_b32_e32 v15, v0                                      // 0000006CB9B8: 7E1E0300
	ds_bpermute_b32 v15, v8, v15 offset:4                      // 0000006CB9BC: DACC0004 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB9C4: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB9C8: BC7C0000
	v_mov_b32_e32 v0, v15                                      // 0000006CB9CC: 7E00030F
	v_mov_b32_e32 v15, v1                                      // 0000006CB9D0: 7E1E0301
	ds_bpermute_b32 v15, v8, v15 offset:4                      // 0000006CB9D4: DACC0004 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB9DC: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB9E0: BC7C0000
	v_mov_b32_e32 v1, v15                                      // 0000006CB9E4: 7E02030F
	v_mov_b32_e32 v15, v2                                      // 0000006CB9E8: 7E1E0302
	ds_bpermute_b32 v15, v8, v15 offset:4                      // 0000006CB9EC: DACC0004 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CB9F4: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CB9F8: BC7C0000
	v_mov_b32_e32 v2, v15                                      // 0000006CB9FC: 7E04030F
	v_mov_b32_e32 v15, v3                                      // 0000006CBA00: 7E1E0303
	ds_bpermute_b32 v15, v8, v15 offset:4                      // 0000006CBA04: DACC0004 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CBA0C: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CBA10: BC7C0000
	v_mov_b32_e32 v3, v15                                      // 0000006CBA14: 7E06030F
	v_mov_b32_e32 v15, v4                                      // 0000006CBA18: 7E1E0304
	ds_bpermute_b32 v15, v8, v15 offset:4                      // 0000006CBA1C: DACC0004 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CBA24: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CBA28: BC7C0000
	v_mov_b32_e32 v4, v15                                      // 0000006CBA2C: 7E08030F
	v_mov_b32_e32 v15, v5                                      // 0000006CBA30: 7E1E0305
	ds_bpermute_b32 v15, v8, v15 offset:4                      // 0000006CBA34: DACC0004 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CBA3C: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CBA40: BC7C0000
	v_mov_b32_e32 v5, v15                                      // 0000006CBA44: 7E0A030F
	v_mov_b32_e32 v15, v6                                      // 0000006CBA48: 7E1E0306
	ds_bpermute_b32 v15, v8, v15 offset:4                      // 0000006CBA4C: DACC0004 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CBA54: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CBA58: BC7C0000
	v_mov_b32_e32 v6, v15                                      // 0000006CBA5C: 7E0C030F
	v_mov_b32_e32 v15, v7                                      // 0000006CBA60: 7E1E0307
	ds_bpermute_b32 v15, v8, v15 offset:4                      // 0000006CBA64: DACC0004 0F000F08
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CBA6C: BF890000
	s_waitcnt_vscnt null, 0x0                                  // 0000006CBA70: BC7C0000
	v_mov_b32_e32 v7, v15                                      // 0000006CBA74: 7E0E030F
	s_mov_b32 s8, -1                                           // 0000006CBA78: BE8800C1
	s_or_saveexec_b32 vcc_lo, s8                               // 0000006CBA7C: BEEA2208
	s_branch label_ShiftVectorComponents0_GLVW0                // 0000006CBA80: BFA00000

<label_ShiftVectorComponents0_GLVW0>:
	v_lshrrev_b32_e32 v12, 5, v72                              // 0000006CBA84: 32189085
	v_lshrrev_b32_e32 v13, 1, v12                              // 0000006CBA88: 321A1881
	v_mul_lo_u32 v13, 16, v13                                  // 0000006CBA8C: D72C000D 02021A90
	v_and_b32_e32 v9, 31, v72                                  // 0000006CBA94: 3612909F
	v_lshrrev_b32_e32 v9, 4, v9                                // 0000006CBA98: 32121284
	v_add_lshl_u32 v9, v13, v9, 0                              // 0000006CBA9C: D6470009 0202130D
	v_mul_lo_u32 v10, v9, s38                                  // 0000006CBAA4: D72C000A 02004D09
	v_mul_lo_u32 v11, v9, s36                                  // 0000006CBAAC: D72C000B 02004909
	v_and_b32_e32 v8, 1, v12                                   // 0000006CBAB4: 36101881
	v_mul_lo_u32 v8, 16, v8                                    // 0000006CBAB8: D72C0008 02021090
	v_and_b32_e32 v13, 15, v72                                 // 0000006CBAC0: 361A908F
	v_add_lshl_u32 v8, v13, v8, 0                              // 0000006CBAC4: D6470008 0202110D
	s_mul_i32 s8, 32, s2                                       // 0000006CBACC: 960802A0
	v_add_nc_u32_e32 v8, s8, v8                                // 0000006CBAD0: 4A101008
	s_mul_i32 s8, 16, s3                                       // 0000006CBAD4: 96080390
	v_add_nc_u32_e32 v9, s8, v9                                // 0000006CBAD8: 4A121208
	s_waitcnt lgkmcnt(0)                                       // 0000006CBADC: BF89FC07
	s_and_b32 s8, s46, 0x3fff                                  // 0000006CBAE0: 8B08FF2E 00003FFF
	s_cmp_eq_u32 s8, 1                                         // 0000006CBAE8: BF068108
	s_cbranch_scc1 label_GSU_5                                 // 0000006CBAEC: BFA200DF

<label_GW_B0_MB>:
	s_and_b32 s30, 31, s24                                     // 0000006CBAF0: 8B1E189F
	s_add_u32 s31, -1, s14                                     // 0000006CBAF4: 801F0EC1
	s_cmp_ge_u32 s2, s31                                       // 0000006CBAF8: BF091F02
	s_cselect_b32 s30, s30, 0                                  // 0000006CBAFC: 981E801E
	s_cmpk_gt_u32 s30, 0x0                                     // 0000006CBB00: B59E0000
	s_cbranch_scc1 label_GW_B0_FD0_VW1_MB_Else                 // 0000006CBB04: BFA20037
	s_and_b32 s30, 15, s25                                     // 0000006CBB08: 8B1E198F
	s_add_u32 s31, -1, s15                                     // 0000006CBB0C: 801F0FC1
	s_cmp_ge_u32 s3, s31                                       // 0000006CBB10: BF091F03
	s_cselect_b32 s30, s30, 0                                  // 0000006CBB14: 981E801E
	s_cmpk_gt_u32 s30, 0x0                                     // 0000006CBB18: B59E0000
	s_cbranch_scc1 label_GW_B0_FD0_VW1_MB_Else                 // 0000006CBB1C: BFA20031

<label_GW_B0_FD0_VW1_MB_NonEdge>:
	v_add_lshl_u32 v19, v11, v8, 2                             // 0000006CBB20: D6470013 020A110B
	v_mov_b32_e32 v21, v0                                      // 0000006CBB28: 7E2A0300
	v_mov_b32_e32 v22, v1                                      // 0000006CBB2C: 7E2C0301
	v_mov_b32_e32 v23, v2                                      // 0000006CBB30: 7E2E0302
	v_mov_b32_e32 v24, v3                                      // 0000006CBB34: 7E300303
	v_mov_b32_e32 v25, v4                                      // 0000006CBB38: 7E320304
	v_mov_b32_e32 v26, v5                                      // 0000006CBB3C: 7E340305
	v_mov_b32_e32 v27, v6                                      // 0000006CBB40: 7E360306
	v_mov_b32_e32 v28, v7                                      // 0000006CBB44: 7E380307
	buffer_store_b32 v21, v19, s[16:19], 0 offen               // 0000006CBB48: E0680000 80441513
	s_mul_i32 s8, s36, 8                                       // 0000006CBB50: 96088824
	s_add_u32 s16, s16, s8                                     // 0000006CBB54: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CBB58: 82118011
	buffer_store_b32 v22, v19, s[16:19], 0 offen               // 0000006CBB5C: E0680000 80441613
	s_mul_i32 s8, s36, 8                                       // 0000006CBB64: 96088824
	s_add_u32 s16, s16, s8                                     // 0000006CBB68: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CBB6C: 82118011
	buffer_store_b32 v23, v19, s[16:19], 0 offen               // 0000006CBB70: E0680000 80441713
	s_mul_i32 s8, s36, 8                                       // 0000006CBB78: 96088824
	s_add_u32 s16, s16, s8                                     // 0000006CBB7C: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CBB80: 82118011
	buffer_store_b32 v24, v19, s[16:19], 0 offen               // 0000006CBB84: E0680000 80441813
	s_mul_i32 s8, s36, 8                                       // 0000006CBB8C: 96088824
	s_add_u32 s16, s16, s8                                     // 0000006CBB90: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CBB94: 82118011
	buffer_store_b32 v25, v19, s[16:19], 0 offen               // 0000006CBB98: E0680000 80441913
	s_mul_i32 s8, s36, 8                                       // 0000006CBBA0: 96088824
	s_add_u32 s16, s16, s8                                     // 0000006CBBA4: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CBBA8: 82118011
	buffer_store_b32 v26, v19, s[16:19], 0 offen               // 0000006CBBAC: E0680000 80441A13
	s_mul_i32 s8, s36, 8                                       // 0000006CBBB4: 96088824
	s_add_u32 s16, s16, s8                                     // 0000006CBBB8: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CBBBC: 82118011
	buffer_store_b32 v27, v19, s[16:19], 0 offen               // 0000006CBBC0: E0680000 80441B13
	s_mul_i32 s8, s36, 8                                       // 0000006CBBC8: 96088824
	s_add_u32 s16, s16, s8                                     // 0000006CBBCC: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CBBD0: 82118011
	buffer_store_b32 v28, v19, s[16:19], 0 offen               // 0000006CBBD4: E0680000 80441C13
	s_nop 0                                                    // 0000006CBBDC: BF800000
	s_branch label_GW_End_1                                    // 0000006CBBE0: BFA0009C

<label_GW_B0_FD0_VW1_MB_Then>:
	v_mov_b32_e32 v14, 0xfffff000                              // 0000006CBBE4: 7E1C02FF FFFFF000
	v_cmp_lt_u32_e64 s30, v8, s24                              // 0000006CBBEC: D449001E 02003108
	v_cmp_lt_u32_e64 s32, v9, s25                              // 0000006CBBF4: D4490020 02003309
	s_and_b32 s32, s30, s32                                    // 0000006CBBFC: 8B20201E
	v_add_lshl_u32 v27, v11, v8, 2                             // 0000006CBC00: D647001B 020A110B
	v_cndmask_b32_e64 v27, v14, v27, s32                       // 0000006CBC08: D501001B 0082370E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CBC10: D7006A09 02010509
	s_mul_i32 s30, s38, 2                                      // 0000006CBC18: 961E8226
	v_add_nc_i32 v10, v10, s30                                 // 0000006CBC1C: D726000A 02003D0A
	s_mul_i32 s30, s36, 2                                      // 0000006CBC24: 961E8224
	v_add_nc_i32 v11, v11, s30                                 // 0000006CBC28: D726000B 02003D0B
	v_cmp_lt_u32_e64 s30, v8, s24                              // 0000006CBC30: D449001E 02003108
	v_cmp_lt_u32_e64 s32, v9, s25                              // 0000006CBC38: D4490020 02003309
	s_and_b32 s32, s30, s32                                    // 0000006CBC40: 8B20201E
	v_add_lshl_u32 v28, v11, v8, 2                             // 0000006CBC44: D647001C 020A110B
	v_cndmask_b32_e64 v28, v14, v28, s32                       // 0000006CBC4C: D501001C 0082390E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CBC54: D7006A09 02010509
	s_mul_i32 s30, s38, 2                                      // 0000006CBC5C: 961E8226
	v_add_nc_i32 v10, v10, s30                                 // 0000006CBC60: D726000A 02003D0A
	s_mul_i32 s30, s36, 2                                      // 0000006CBC68: 961E8224
	v_add_nc_i32 v11, v11, s30                                 // 0000006CBC6C: D726000B 02003D0B
	v_cmp_lt_u32_e64 s30, v8, s24                              // 0000006CBC74: D449001E 02003108
	v_cmp_lt_u32_e64 s32, v9, s25                              // 0000006CBC7C: D4490020 02003309
	s_and_b32 s32, s30, s32                                    // 0000006CBC84: 8B20201E
	v_add_lshl_u32 v29, v11, v8, 2                             // 0000006CBC88: D647001D 020A110B
	v_cndmask_b32_e64 v29, v14, v29, s32                       // 0000006CBC90: D501001D 00823B0E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CBC98: D7006A09 02010509
	s_mul_i32 s30, s38, 2                                      // 0000006CBCA0: 961E8226
	v_add_nc_i32 v10, v10, s30                                 // 0000006CBCA4: D726000A 02003D0A
	s_mul_i32 s30, s36, 2                                      // 0000006CBCAC: 961E8224
	v_add_nc_i32 v11, v11, s30                                 // 0000006CBCB0: D726000B 02003D0B
	v_cmp_lt_u32_e64 s30, v8, s24                              // 0000006CBCB8: D449001E 02003108
	v_cmp_lt_u32_e64 s32, v9, s25                              // 0000006CBCC0: D4490020 02003309
	s_and_b32 s32, s30, s32                                    // 0000006CBCC8: 8B20201E
	v_add_lshl_u32 v30, v11, v8, 2                             // 0000006CBCCC: D647001E 020A110B
	v_cndmask_b32_e64 v30, v14, v30, s32                       // 0000006CBCD4: D501001E 00823D0E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CBCDC: D7006A09 02010509
	s_mul_i32 s30, s38, 2                                      // 0000006CBCE4: 961E8226
	v_add_nc_i32 v10, v10, s30                                 // 0000006CBCE8: D726000A 02003D0A
	s_mul_i32 s30, s36, 2                                      // 0000006CBCF0: 961E8224
	v_add_nc_i32 v11, v11, s30                                 // 0000006CBCF4: D726000B 02003D0B
	v_cmp_lt_u32_e64 s30, v8, s24                              // 0000006CBCFC: D449001E 02003108
	v_cmp_lt_u32_e64 s32, v9, s25                              // 0000006CBD04: D4490020 02003309
	s_and_b32 s32, s30, s32                                    // 0000006CBD0C: 8B20201E
	v_add_lshl_u32 v31, v11, v8, 2                             // 0000006CBD10: D647001F 020A110B
	v_cndmask_b32_e64 v31, v14, v31, s32                       // 0000006CBD18: D501001F 00823F0E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CBD20: D7006A09 02010509
	s_mul_i32 s30, s38, 2                                      // 0000006CBD28: 961E8226
	v_add_nc_i32 v10, v10, s30                                 // 0000006CBD2C: D726000A 02003D0A
	s_mul_i32 s30, s36, 2                                      // 0000006CBD34: 961E8224
	v_add_nc_i32 v11, v11, s30                                 // 0000006CBD38: D726000B 02003D0B
	v_cmp_lt_u32_e64 s30, v8, s24                              // 0000006CBD40: D449001E 02003108
	v_cmp_lt_u32_e64 s32, v9, s25                              // 0000006CBD48: D4490020 02003309
	s_and_b32 s32, s30, s32                                    // 0000006CBD50: 8B20201E
	v_add_lshl_u32 v32, v11, v8, 2                             // 0000006CBD54: D6470020 020A110B
	v_cndmask_b32_e64 v32, v14, v32, s32                       // 0000006CBD5C: D5010020 0082410E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CBD64: D7006A09 02010509
	s_mul_i32 s30, s38, 2                                      // 0000006CBD6C: 961E8226
	v_add_nc_i32 v10, v10, s30                                 // 0000006CBD70: D726000A 02003D0A
	s_mul_i32 s30, s36, 2                                      // 0000006CBD78: 961E8224
	v_add_nc_i32 v11, v11, s30                                 // 0000006CBD7C: D726000B 02003D0B
	v_cmp_lt_u32_e64 s30, v8, s24                              // 0000006CBD84: D449001E 02003108
	v_cmp_lt_u32_e64 s32, v9, s25                              // 0000006CBD8C: D4490020 02003309
	s_and_b32 s32, s30, s32                                    // 0000006CBD94: 8B20201E
	v_add_lshl_u32 v33, v11, v8, 2                             // 0000006CBD98: D6470021 020A110B
	v_cndmask_b32_e64 v33, v14, v33, s32                       // 0000006CBDA0: D5010021 0082430E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CBDA8: D7006A09 02010509
	s_mul_i32 s30, s38, 2                                      // 0000006CBDB0: 961E8226
	v_add_nc_i32 v10, v10, s30                                 // 0000006CBDB4: D726000A 02003D0A
	s_mul_i32 s30, s36, 2                                      // 0000006CBDBC: 961E8224
	v_add_nc_i32 v11, v11, s30                                 // 0000006CBDC0: D726000B 02003D0B
	v_cmp_lt_u32_e64 s30, v8, s24                              // 0000006CBDC8: D449001E 02003108
	v_cmp_lt_u32_e64 s32, v9, s25                              // 0000006CBDD0: D4490020 02003309
	s_and_b32 s32, s30, s32                                    // 0000006CBDD8: 8B20201E
	v_add_lshl_u32 v34, v11, v8, 2                             // 0000006CBDDC: D6470022 020A110B
	v_cndmask_b32_e64 v34, v14, v34, s32                       // 0000006CBDE4: D5010022 0082450E
	v_mov_b32_e32 v19, v0                                      // 0000006CBDEC: 7E260300
	v_mov_b32_e32 v20, v1                                      // 0000006CBDF0: 7E280301
	v_mov_b32_e32 v21, v2                                      // 0000006CBDF4: 7E2A0302
	v_mov_b32_e32 v22, v3                                      // 0000006CBDF8: 7E2C0303
	v_mov_b32_e32 v23, v4                                      // 0000006CBDFC: 7E2E0304
	v_mov_b32_e32 v24, v5                                      // 0000006CBE00: 7E300305
	v_mov_b32_e32 v25, v6                                      // 0000006CBE04: 7E320306
	v_mov_b32_e32 v26, v7                                      // 0000006CBE08: 7E340307
	buffer_store_b32 v19, v27, s[16:19], 0 offen               // 0000006CBE0C: E0680000 8044131B
	buffer_store_b32 v20, v28, s[16:19], 0 offen               // 0000006CBE14: E0680000 8044141C
	buffer_store_b32 v21, v29, s[16:19], 0 offen               // 0000006CBE1C: E0680000 8044151D
	buffer_store_b32 v22, v30, s[16:19], 0 offen               // 0000006CBE24: E0680000 8044161E
	buffer_store_b32 v23, v31, s[16:19], 0 offen               // 0000006CBE2C: E0680000 8044171F
	buffer_store_b32 v24, v32, s[16:19], 0 offen               // 0000006CBE34: E0680000 80441820
	buffer_store_b32 v25, v33, s[16:19], 0 offen               // 0000006CBE3C: E0680000 80441921
	buffer_store_b32 v26, v34, s[16:19], 0 offen               // 0000006CBE44: E0680000 80441A22
	s_nop 0                                                    // 0000006CBE4C: BF800000
	s_branch label_GW_End_1                                    // 0000006CBE50: BFA00000

<label_GW_End_1>:
	s_getpc_b64 s[30:31]                                       // 0000006CBE54: BE9E4700
	s_add_i32 s32, 0x1378, 4                                   // 0000006CBE58: 812084FF 00001378
	s_add_u32 s30, s30, s32                                    // 0000006CBE60: 801E201E
	s_addc_u32 s31, s31, 0                                     // 0000006CBE64: 821F801F
	s_setpc_b64 s[30:31]                                       // 0000006CBE68: BE80481E

<label_GSU_5>:
	s_mov_b64 s[32:33], s[48:49]                               // 0000006CBE6C: BEA00130
	s_mov_b32 s35, 0x31004000                                  // 0000006CBE70: BEA300FF 31004000
	s_cmp_eq_u64 s[48:49], 0                                   // 0000006CBE78: BF108030
	s_cbranch_scc0 label_ScaleAlphaVec_1AddrValid              // 0000006CBE7C: BFA10002
	s_mov_b32 s34, 0                                           // 0000006CBE80: BEA20080
	s_branch label_ScaleAlphaVec_1AddrValid_End                // 0000006CBE84: BFA00001

<label_ScaleAlphaVec_1AddrValid>:
	s_mov_b32 s34, s24                                         // 0000006CBE88: BEA20018

<label_ScaleAlphaVec_1AddrValid_End>:
	s_mul_i32 s34, 4, s34                                      // 0000006CBE8C: 96222284
	s_add_u32 s8, s4, 1                                        // 0000006CBE90: 80088104
	s_mul_i32 s8, s53, s8                                      // 0000006CBE94: 96080835
	s_cmp_eq_u32 s8, 0                                         // 0000006CBE98: BF068008
	s_cselect_b32 s8, s24, s8                                  // 0000006CBE9C: 98080818
	s_mov_b64 s[40:41], s[50:51]                               // 0000006CBEA0: BEA80132
	s_mov_b32 s43, 0x31004000                                  // 0000006CBEA4: BEAB00FF 31004000
	s_cmp_eq_u64 s[50:51], 0                                   // 0000006CBEAC: BF108032
	s_cbranch_scc0 label_Bias_1AddrValid                       // 0000006CBEB0: BFA10002
	s_mov_b32 s42, 0                                           // 0000006CBEB4: BEAA0080
	s_branch label_Bias_1AddrValid_End                         // 0000006CBEB8: BFA00001

<label_Bias_1AddrValid>:
	s_mov_b32 s42, s8                                          // 0000006CBEBC: BEAA0008

<label_Load_Biasf32_0_1>:
	s_cmpk_lg_u32 s52, 0x0                                     // 0000006CBEC0: B5340000
	s_cbranch_scc1 label_Load_Biasbf16_0_1                     // 0000006CBEC4: BFA2001A
	s_mul_i32 s8, 32, s2                                       // 0000006CBEC8: 960802A0
	v_add_nc_u32_e32 v16, s8, v72                              // 0000006CBECC: 4A209008
	s_mul_i32 s42, 4, s42                                      // 0000006CBED0: 962A2A84
	s_mul_i32 s8, s53, s4                                      // 0000006CBED4: 96080435
	v_add_nc_u32_e32 v14, s8, v16                              // 0000006CBED8: 4A1C2008
	v_lshlrev_b32_e32 v14, 2, v14                              // 0000006CBEDC: 301C1C82
	v_lshlrev_b32_e32 v15, 2, v16                              // 0000006CBEE0: 301E2082
	s_mul_i32 s8, 16, s3                                       // 0000006CBEE4: 96080390
	v_add_nc_u32_e32 v16, s8, v72                              // 0000006CBEE8: 4A209008
	buffer_load_b32 v12, v14, s[40:43], 0 offen                // 0000006CBEEC: E0500000 804A0C0E
	buffer_load_b32 v13, v15, s[32:35], 0 offen                // 0000006CBEF4: E0500000 80480D0F
	v_lshlrev_b32_e32 v16, 2, v72                              // 0000006CBEFC: 30209082
	s_barrier                                                  // 0000006CBF00: BFBD0000
	s_waitcnt vmcnt(1)                                         // 0000006CBF04: BF8907F7
	ds_store_b32 v16, v12                                      // 0000006CBF08: D8340000 00000C10
	v_cmp_gt_u32_e64 s48, s34, 0                               // 0000006CBF10: D44C0030 02010022
	s_waitcnt vmcnt(0)                                         // 0000006CBF18: BF8903F7
	v_cndmask_b32_e64 v13, 1.0, v13, s48                       // 0000006CBF1C: D501000D 00C21AF2
	ds_store_b32 v16, v13 offset:256                           // 0000006CBF24: D8340100 00000D10
	s_branch label_Load_Bias_End_1                             // 0000006CBF2C: BFA0001D

<label_Load_Biasbf16_0_1>:
	s_cmpk_lg_u32 s52, 0x7                                     // 0000006CBF30: B5340007
	s_cbranch_scc1 label_Load_Bias_End_1                       // 0000006CBF34: BFA2001B
	s_mul_i32 s8, 32, s2                                       // 0000006CBF38: 960802A0
	v_add_nc_u32_e32 v16, s8, v72                              // 0000006CBF3C: 4A209008
	s_mul_i32 s42, 2, s42                                      // 0000006CBF40: 962A2A82
	s_mul_i32 s8, s53, s4                                      // 0000006CBF44: 96080435
	v_add_nc_u32_e32 v14, s8, v16                              // 0000006CBF48: 4A1C2008
	v_lshlrev_b32_e32 v14, 1, v14                              // 0000006CBF4C: 301C1C81
	v_lshlrev_b32_e32 v15, 2, v16                              // 0000006CBF50: 301E2082
	s_mul_i32 s8, 16, s3                                       // 0000006CBF54: 96080390
	v_add_nc_u32_e32 v16, s8, v72                              // 0000006CBF58: 4A209008
	buffer_load_d16_b16 v12, v14, s[40:43], 0 offen            // 0000006CBF5C: E0800000 804A0C0E
	buffer_load_b32 v13, v15, s[32:35], 0 offen                // 0000006CBF64: E0500000 80480D0F
	v_lshlrev_b32_e32 v16, 2, v72                              // 0000006CBF6C: 30209082
	s_barrier                                                  // 0000006CBF70: BFBD0000
	s_waitcnt vmcnt(1)                                         // 0000006CBF74: BF8907F7
	v_lshlrev_b32_e32 v12, 16, v12                             // 0000006CBF78: 30181890
	ds_store_b32 v16, v12                                      // 0000006CBF7C: D8340000 00000C10
	v_cmp_gt_u32_e64 s48, s34, 0                               // 0000006CBF84: D44C0030 02010022
	s_waitcnt vmcnt(0)                                         // 0000006CBF8C: BF8903F7
	v_cndmask_b32_e64 v13, 1.0, v13, s48                       // 0000006CBF90: D501000D 00C21AF2
	ds_store_b32 v16, v13 offset:256                           // 0000006CBF98: D8340100 00000D10
	s_branch label_Load_Bias_End_1                             // 0000006CBFA0: BFA00000

<label_Load_Bias_End_1>:
	s_cmpk_eq_u32 s56, 0x3                                     // 0000006CBFA4: B4B80003
	s_cbranch_scc1 label_To_Activation_Gelu_VW1_1              // 0000006CBFA8: BFA2000E
	s_cmpk_eq_u32 s56, 0x5                                     // 0000006CBFAC: B4B80005
	s_cbranch_scc1 label_To_Activation_Relu_VW1_1              // 0000006CBFB0: BFA20012
	s_cmpk_eq_u32 s56, 0x6                                     // 0000006CBFB4: B4B80006
	s_cbranch_scc1 label_To_Activation_Sigmoid_VW1_1           // 0000006CBFB8: BFA20016
	s_cmpk_eq_u32 s56, 0xb                                     // 0000006CBFBC: B4B8000B
	s_cbranch_scc1 label_To_Activation_Silu_VW1_1              // 0000006CBFC0: BFA2001A
	s_cmpk_eq_u32 s56, 0xd                                     // 0000006CBFC4: B4B8000D
	s_cbranch_scc1 label_To_Activation_Clamp_VW1_1             // 0000006CBFC8: BFA2001E

<label_To_Activation_None_VW1_1>:
	s_getpc_b64 s[12:13]                                       // 0000006CBFCC: BE8C4700
	s_add_i32 s8, 0x1204, 4                                    // 0000006CBFD0: 810884FF 00001204
	s_add_u32 s12, s12, s8                                     // 0000006CBFD8: 800C080C
	s_addc_u32 s13, s13, 0                                     // 0000006CBFDC: 820D800D
	s_branch label_ActivationSetPCAddrEnd_1                    // 0000006CBFE0: BFA0001E

<label_To_Activation_Gelu_VW1_1>:
	s_getpc_b64 s[12:13]                                       // 0000006CBFE4: BE8C4700
	s_add_i32 s8, 0x11f0, 4                                    // 0000006CBFE8: 810884FF 000011F0
	s_add_u32 s12, s12, s8                                     // 0000006CBFF0: 800C080C
	s_addc_u32 s13, s13, 0                                     // 0000006CBFF4: 820D800D
	s_branch label_ActivationSetPCAddrEnd_1                    // 0000006CBFF8: BFA00018

<label_To_Activation_Relu_VW1_1>:
	s_getpc_b64 s[12:13]                                       // 0000006CBFFC: BE8C4700
	s_add_i32 s8, 0x1214, 4                                    // 0000006CC000: 810884FF 00001214
	s_add_u32 s12, s12, s8                                     // 0000006CC008: 800C080C
	s_addc_u32 s13, s13, 0                                     // 0000006CC00C: 820D800D
	s_branch label_ActivationSetPCAddrEnd_1                    // 0000006CC010: BFA00012

<label_To_Activation_Sigmoid_VW1_1>:
	s_getpc_b64 s[12:13]                                       // 0000006CC014: BE8C4700
	s_add_i32 s8, 0x1208, 4                                    // 0000006CC018: 810884FF 00001208
	s_add_u32 s12, s12, s8                                     // 0000006CC020: 800C080C
	s_addc_u32 s13, s13, 0                                     // 0000006CC024: 820D800D
	s_branch label_ActivationSetPCAddrEnd_1                    // 0000006CC028: BFA0000C

<label_To_Activation_Silu_VW1_1>:
	s_getpc_b64 s[12:13]                                       // 0000006CC02C: BE8C4700
	s_add_i32 s8, 0x1208, 4                                    // 0000006CC030: 810884FF 00001208
	s_add_u32 s12, s12, s8                                     // 0000006CC038: 800C080C
	s_addc_u32 s13, s13, 0                                     // 0000006CC03C: 820D800D
	s_branch label_ActivationSetPCAddrEnd_1                    // 0000006CC040: BFA00006

<label_To_Activation_Clamp_VW1_1>:
	s_getpc_b64 s[12:13]                                       // 0000006CC044: BE8C4700
	s_add_i32 s8, 0x120c, 4                                    // 0000006CC048: 810884FF 0000120C
	s_add_u32 s12, s12, s8                                     // 0000006CC050: 800C080C
	s_addc_u32 s13, s13, 0                                     // 0000006CC054: 820D800D
	s_branch label_ActivationSetPCAddrEnd_1                    // 0000006CC058: BFA00000

<label_ActivationSetPCAddrEnd_1>:
	s_cmpk_eq_u32 s45, 0x0                                     // 0000006CC05C: B4AD0000
	s_cbranch_scc0 label_GW_B1_FD0_GSU1                        // 0000006CC060: BFA101E7

<label_GW_B0_GSU1>:
	s_and_b32 s32, 31, s24                                     // 0000006CC064: 8B20189F
	s_add_u32 s33, -1, s14                                     // 0000006CC068: 80210EC1
	s_cmp_ge_u32 s2, s33                                       // 0000006CC06C: BF092102
	s_cselect_b32 s32, s32, 0                                  // 0000006CC070: 98208020
	s_cmpk_gt_u32 s32, 0x0                                     // 0000006CC074: B5A00000
	s_cbranch_scc1 label_GW_B0_FD0_VW1_GSU1_Else               // 0000006CC078: BFA200B0
	s_and_b32 s32, 15, s25                                     // 0000006CC07C: 8B20198F
	s_add_u32 s33, -1, s15                                     // 0000006CC080: 80210FC1
	s_cmp_ge_u32 s3, s33                                       // 0000006CC084: BF092103
	s_cselect_b32 s32, s32, 0                                  // 0000006CC088: 98208020
	s_cmpk_gt_u32 s32, 0x0                                     // 0000006CC08C: B5A00000
	s_cbranch_scc1 label_GW_B0_FD0_VW1_GSU1_Else               // 0000006CC090: BFA200AA

<label_GW_B0_FD0_VW1_GSU1_NonEdge>:
	s_mul_i32 s8, 32, s2                                       // 0000006CC094: 960802A0
	v_sub_nc_u32_e64 v21, v8, s8                               // 0000006CC098: D5260015 02001108
	v_lshlrev_b32_e32 v21, 2, v21                              // 0000006CC0A0: 302A2A82
	s_waitcnt lgkmcnt(0)                                       // 0000006CC0A4: BF89FC07
	s_barrier                                                  // 0000006CC0A8: BFBD0000
	ds_load_b32 v30, v21                                       // 0000006CC0AC: D8D80000 1E000015
	ds_load_b32 v31, v21 offset:256                            // 0000006CC0B4: D8D80100 1F000015
	v_add_lshl_u32 v19, v11, v8, 1                             // 0000006CC0BC: D6470013 0206110B
	v_mul_f32_e32 v22, s44, v0                                 // 0000006CC0C4: 102C002C
	v_mul_f32_e32 v23, s44, v1                                 // 0000006CC0C8: 102E022C
	v_mul_f32_e32 v24, s44, v2                                 // 0000006CC0CC: 1030042C
	v_mul_f32_e32 v25, s44, v3                                 // 0000006CC0D0: 1032062C
	v_mul_f32_e32 v26, s44, v4                                 // 0000006CC0D4: 1034082C
	v_mul_f32_e32 v27, s44, v5                                 // 0000006CC0D8: 10360A2C
	v_mul_f32_e32 v28, s44, v6                                 // 0000006CC0DC: 10380C2C
	v_mul_f32_e32 v29, s44, v7                                 // 0000006CC0E0: 103A0E2C
	v_mov_b32_e32 v16, 0xffff0000                              // 0000006CC0E4: 7E2002FF FFFF0000
	v_mov_b32_e32 v17, 0x7fff0000                              // 0000006CC0EC: 7E2202FF 7FFF0000
	v_mov_b32_e32 v18, 0x7fff                                  // 0000006CC0F4: 7E2402FF 00007FFF
	s_waitcnt lgkmcnt(0)                                       // 0000006CC0FC: BF89FC07
	v_mul_f32_e32 v22, v31, v22                                // 0000006CC100: 102C2D1F
	v_add_f32_e32 v12, v30, v22                                // 0000006CC104: 06182D1E
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CC108: BE9E490C
	v_mov_b32_e32 v22, v12                                     // 0000006CC10C: 7E2C030C
	v_cmp_u_f32_e64 s8, v22, v22                               // 0000006CC110: D4180008 02022D16
	v_bfe_u32 v15, v22, 16, 1                                  // 0000006CC118: D610000F 02052116
	v_add3_u32 v15, v22, v15, v18                              // 0000006CC120: D655000F 044A1F16
	v_cndmask_b32_e64 v22, v15, v17, s8                        // 0000006CC128: D5010016 0022230F
	v_lshrrev_b32_e32 v22, 16, v22                             // 0000006CC130: 322C2C90
	buffer_store_b16 v22, v19, s[16:19], 0 offen               // 0000006CC134: E0640000 80441613
	v_mul_f32_e32 v23, v31, v23                                // 0000006CC13C: 102E2F1F
	v_add_f32_e32 v12, v30, v23                                // 0000006CC140: 06182F1E
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CC144: BE9E490C
	v_mov_b32_e32 v23, v12                                     // 0000006CC148: 7E2E030C
	v_cmp_u_f32_e64 s8, v23, v23                               // 0000006CC14C: D4180008 02022F17
	v_bfe_u32 v15, v23, 16, 1                                  // 0000006CC154: D610000F 02052117
	v_add3_u32 v15, v23, v15, v18                              // 0000006CC15C: D655000F 044A1F17
	v_cndmask_b32_e64 v23, v15, v17, s8                        // 0000006CC164: D5010017 0022230F
	v_lshrrev_b32_e32 v23, 16, v23                             // 0000006CC16C: 322E2E90
	s_mul_i32 s8, s36, 4                                       // 0000006CC170: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CC174: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CC178: 82118011
	buffer_store_b16 v23, v19, s[16:19], 0 offen               // 0000006CC17C: E0640000 80441713
	v_mul_f32_e32 v24, v31, v24                                // 0000006CC184: 1030311F
	v_add_f32_e32 v12, v30, v24                                // 0000006CC188: 0618311E
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CC18C: BE9E490C
	v_mov_b32_e32 v24, v12                                     // 0000006CC190: 7E30030C
	v_cmp_u_f32_e64 s8, v24, v24                               // 0000006CC194: D4180008 02023118
	v_bfe_u32 v15, v24, 16, 1                                  // 0000006CC19C: D610000F 02052118
	v_add3_u32 v15, v24, v15, v18                              // 0000006CC1A4: D655000F 044A1F18
	v_cndmask_b32_e64 v24, v15, v17, s8                        // 0000006CC1AC: D5010018 0022230F
	v_lshrrev_b32_e32 v24, 16, v24                             // 0000006CC1B4: 32303090
	s_mul_i32 s8, s36, 4                                       // 0000006CC1B8: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CC1BC: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CC1C0: 82118011
	buffer_store_b16 v24, v19, s[16:19], 0 offen               // 0000006CC1C4: E0640000 80441813
	v_mul_f32_e32 v25, v31, v25                                // 0000006CC1CC: 1032331F
	v_add_f32_e32 v12, v30, v25                                // 0000006CC1D0: 0618331E
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CC1D4: BE9E490C
	v_mov_b32_e32 v25, v12                                     // 0000006CC1D8: 7E32030C
	v_cmp_u_f32_e64 s8, v25, v25                               // 0000006CC1DC: D4180008 02023319
	v_bfe_u32 v15, v25, 16, 1                                  // 0000006CC1E4: D610000F 02052119
	v_add3_u32 v15, v25, v15, v18                              // 0000006CC1EC: D655000F 044A1F19
	v_cndmask_b32_e64 v25, v15, v17, s8                        // 0000006CC1F4: D5010019 0022230F
	v_lshrrev_b32_e32 v25, 16, v25                             // 0000006CC1FC: 32323290
	s_mul_i32 s8, s36, 4                                       // 0000006CC200: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CC204: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CC208: 82118011
	buffer_store_b16 v25, v19, s[16:19], 0 offen               // 0000006CC20C: E0640000 80441913
	v_mul_f32_e32 v26, v31, v26                                // 0000006CC214: 1034351F
	v_add_f32_e32 v12, v30, v26                                // 0000006CC218: 0618351E
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CC21C: BE9E490C
	v_mov_b32_e32 v26, v12                                     // 0000006CC220: 7E34030C
	v_cmp_u_f32_e64 s8, v26, v26                               // 0000006CC224: D4180008 0202351A
	v_bfe_u32 v15, v26, 16, 1                                  // 0000006CC22C: D610000F 0205211A
	v_add3_u32 v15, v26, v15, v18                              // 0000006CC234: D655000F 044A1F1A
	v_cndmask_b32_e64 v26, v15, v17, s8                        // 0000006CC23C: D501001A 0022230F
	v_lshrrev_b32_e32 v26, 16, v26                             // 0000006CC244: 32343490
	s_mul_i32 s8, s36, 4                                       // 0000006CC248: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CC24C: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CC250: 82118011
	buffer_store_b16 v26, v19, s[16:19], 0 offen               // 0000006CC254: E0640000 80441A13
	v_mul_f32_e32 v27, v31, v27                                // 0000006CC25C: 1036371F
	v_add_f32_e32 v12, v30, v27                                // 0000006CC260: 0618371E
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CC264: BE9E490C
	v_mov_b32_e32 v27, v12                                     // 0000006CC268: 7E36030C
	v_cmp_u_f32_e64 s8, v27, v27                               // 0000006CC26C: D4180008 0202371B
	v_bfe_u32 v15, v27, 16, 1                                  // 0000006CC274: D610000F 0205211B
	v_add3_u32 v15, v27, v15, v18                              // 0000006CC27C: D655000F 044A1F1B
	v_cndmask_b32_e64 v27, v15, v17, s8                        // 0000006CC284: D501001B 0022230F
	v_lshrrev_b32_e32 v27, 16, v27                             // 0000006CC28C: 32363690
	s_mul_i32 s8, s36, 4                                       // 0000006CC290: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CC294: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CC298: 82118011
	buffer_store_b16 v27, v19, s[16:19], 0 offen               // 0000006CC29C: E0640000 80441B13
	v_mul_f32_e32 v28, v31, v28                                // 0000006CC2A4: 1038391F
	v_add_f32_e32 v12, v30, v28                                // 0000006CC2A8: 0618391E
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CC2AC: BE9E490C
	v_mov_b32_e32 v28, v12                                     // 0000006CC2B0: 7E38030C
	v_cmp_u_f32_e64 s8, v28, v28                               // 0000006CC2B4: D4180008 0202391C
	v_bfe_u32 v15, v28, 16, 1                                  // 0000006CC2BC: D610000F 0205211C
	v_add3_u32 v15, v28, v15, v18                              // 0000006CC2C4: D655000F 044A1F1C
	v_cndmask_b32_e64 v28, v15, v17, s8                        // 0000006CC2CC: D501001C 0022230F
	v_lshrrev_b32_e32 v28, 16, v28                             // 0000006CC2D4: 32383890
	s_mul_i32 s8, s36, 4                                       // 0000006CC2D8: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CC2DC: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CC2E0: 82118011
	buffer_store_b16 v28, v19, s[16:19], 0 offen               // 0000006CC2E4: E0640000 80441C13
	v_mul_f32_e32 v29, v31, v29                                // 0000006CC2EC: 103A3B1F
	v_add_f32_e32 v12, v30, v29                                // 0000006CC2F0: 06183B1E
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CC2F4: BE9E490C
	v_mov_b32_e32 v29, v12                                     // 0000006CC2F8: 7E3A030C
	v_cmp_u_f32_e64 s8, v29, v29                               // 0000006CC2FC: D4180008 02023B1D
	v_bfe_u32 v15, v29, 16, 1                                  // 0000006CC304: D610000F 0205211D
	v_add3_u32 v15, v29, v15, v18                              // 0000006CC30C: D655000F 044A1F1D
	v_cndmask_b32_e64 v29, v15, v17, s8                        // 0000006CC314: D501001D 0022230F
	v_lshrrev_b32_e32 v29, 16, v29                             // 0000006CC31C: 323A3A90
	s_mul_i32 s8, s36, 4                                       // 0000006CC320: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CC324: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CC328: 82118011
	buffer_store_b16 v29, v19, s[16:19], 0 offen               // 0000006CC32C: E0640000 80441D13
	s_nop 0                                                    // 0000006CC334: BF800000
	s_branch label_GW_End_2                                    // 0000006CC338: BFA003A6

<label_GW_B0_FD0_VW1_GSU1_Then>:
	v_mov_b32_e32 v14, 0xfffff000                              // 0000006CC33C: 7E1C02FF FFFFF000
	v_cmp_lt_u32_e64 s32, v8, s24                              // 0000006CC344: D4490020 02003108
	v_cmp_lt_u32_e64 s34, v9, s25                              // 0000006CC34C: D4490022 02003309
	s_and_b32 s34, s32, s34                                    // 0000006CC354: 8B222220
	s_mul_i32 s32, 32, s2                                      // 0000006CC358: 962002A0
	v_sub_nc_u32_e64 v30, v8, s32                              // 0000006CC35C: D526001E 02004108
	v_lshlrev_b32_e32 v30, 2, v30                              // 0000006CC364: 303C3C82
	s_waitcnt lgkmcnt(0)                                       // 0000006CC368: BF89FC07
	s_barrier                                                  // 0000006CC36C: BFBD0000
	ds_load_b32 v27, v30                                       // 0000006CC370: D8D80000 1B00001E
	ds_load_b32 v28, v30 offset:256                            // 0000006CC378: D8D80100 1C00001E
	v_add_lshl_u32 v29, v11, v8, 1                             // 0000006CC380: D647001D 0206110B
	v_cndmask_b32_e64 v29, v14, v29, s34                       // 0000006CC388: D501001D 008A3B0E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CC390: D7006A09 02010509
	s_mul_i32 s32, s38, 2                                      // 0000006CC398: 96208226
	v_add_nc_i32 v10, v10, s32                                 // 0000006CC39C: D726000A 0200410A
	s_mul_i32 s32, s36, 2                                      // 0000006CC3A4: 96208224
	v_add_nc_i32 v11, v11, s32                                 // 0000006CC3A8: D726000B 0200410B
	v_cmp_lt_u32_e64 s32, v8, s24                              // 0000006CC3B0: D4490020 02003108
	v_cmp_lt_u32_e64 s34, v9, s25                              // 0000006CC3B8: D4490022 02003309
	s_and_b32 s34, s32, s34                                    // 0000006CC3C0: 8B222220
	s_mul_i32 s32, 32, s2                                      // 0000006CC3C4: 962002A0
	v_sub_nc_u32_e64 v32, v8, s32                              // 0000006CC3C8: D5260020 02004108
	v_lshlrev_b32_e32 v32, 2, v32                              // 0000006CC3D0: 30404082
	v_add_lshl_u32 v31, v11, v8, 1                             // 0000006CC3D4: D647001F 0206110B
	v_cndmask_b32_e64 v31, v14, v31, s34                       // 0000006CC3DC: D501001F 008A3F0E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CC3E4: D7006A09 02010509
	s_mul_i32 s32, s38, 2                                      // 0000006CC3EC: 96208226
	v_add_nc_i32 v10, v10, s32                                 // 0000006CC3F0: D726000A 0200410A
	s_mul_i32 s32, s36, 2                                      // 0000006CC3F8: 96208224
	v_add_nc_i32 v11, v11, s32                                 // 0000006CC3FC: D726000B 0200410B
	v_cmp_lt_u32_e64 s32, v8, s24                              // 0000006CC404: D4490020 02003108
	v_cmp_lt_u32_e64 s34, v9, s25                              // 0000006CC40C: D4490022 02003309
	s_and_b32 s34, s32, s34                                    // 0000006CC414: 8B222220
	s_mul_i32 s32, 32, s2                                      // 0000006CC418: 962002A0
	v_sub_nc_u32_e64 v34, v8, s32                              // 0000006CC41C: D5260022 02004108
	v_lshlrev_b32_e32 v34, 2, v34                              // 0000006CC424: 30444482
	v_add_lshl_u32 v33, v11, v8, 1                             // 0000006CC428: D6470021 0206110B
	v_cndmask_b32_e64 v33, v14, v33, s34                       // 0000006CC430: D5010021 008A430E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CC438: D7006A09 02010509
	s_mul_i32 s32, s38, 2                                      // 0000006CC440: 96208226
	v_add_nc_i32 v10, v10, s32                                 // 0000006CC444: D726000A 0200410A
	s_mul_i32 s32, s36, 2                                      // 0000006CC44C: 96208224
	v_add_nc_i32 v11, v11, s32                                 // 0000006CC450: D726000B 0200410B
	v_cmp_lt_u32_e64 s32, v8, s24                              // 0000006CC458: D4490020 02003108
	v_cmp_lt_u32_e64 s34, v9, s25                              // 0000006CC460: D4490022 02003309
	s_and_b32 s34, s32, s34                                    // 0000006CC468: 8B222220
	s_mul_i32 s32, 32, s2                                      // 0000006CC46C: 962002A0
	v_sub_nc_u32_e64 v36, v8, s32                              // 0000006CC470: D5260024 02004108
	v_lshlrev_b32_e32 v36, 2, v36                              // 0000006CC478: 30484882
	v_add_lshl_u32 v35, v11, v8, 1                             // 0000006CC47C: D6470023 0206110B
	v_cndmask_b32_e64 v35, v14, v35, s34                       // 0000006CC484: D5010023 008A470E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CC48C: D7006A09 02010509
	s_mul_i32 s32, s38, 2                                      // 0000006CC494: 96208226
	v_add_nc_i32 v10, v10, s32                                 // 0000006CC498: D726000A 0200410A
	s_mul_i32 s32, s36, 2                                      // 0000006CC4A0: 96208224
	v_add_nc_i32 v11, v11, s32                                 // 0000006CC4A4: D726000B 0200410B
	v_cmp_lt_u32_e64 s32, v8, s24                              // 0000006CC4AC: D4490020 02003108
	v_cmp_lt_u32_e64 s34, v9, s25                              // 0000006CC4B4: D4490022 02003309
	s_and_b32 s34, s32, s34                                    // 0000006CC4BC: 8B222220
	s_mul_i32 s32, 32, s2                                      // 0000006CC4C0: 962002A0
	v_sub_nc_u32_e64 v38, v8, s32                              // 0000006CC4C4: D5260026 02004108
	v_lshlrev_b32_e32 v38, 2, v38                              // 0000006CC4CC: 304C4C82
	v_add_lshl_u32 v37, v11, v8, 1                             // 0000006CC4D0: D6470025 0206110B
	v_cndmask_b32_e64 v37, v14, v37, s34                       // 0000006CC4D8: D5010025 008A4B0E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CC4E0: D7006A09 02010509
	s_mul_i32 s32, s38, 2                                      // 0000006CC4E8: 96208226
	v_add_nc_i32 v10, v10, s32                                 // 0000006CC4EC: D726000A 0200410A
	s_mul_i32 s32, s36, 2                                      // 0000006CC4F4: 96208224
	v_add_nc_i32 v11, v11, s32                                 // 0000006CC4F8: D726000B 0200410B
	v_cmp_lt_u32_e64 s32, v8, s24                              // 0000006CC500: D4490020 02003108
	v_cmp_lt_u32_e64 s34, v9, s25                              // 0000006CC508: D4490022 02003309
	s_and_b32 s34, s32, s34                                    // 0000006CC510: 8B222220
	s_mul_i32 s32, 32, s2                                      // 0000006CC514: 962002A0
	v_sub_nc_u32_e64 v40, v8, s32                              // 0000006CC518: D5260028 02004108
	v_lshlrev_b32_e32 v40, 2, v40                              // 0000006CC520: 30505082
	v_add_lshl_u32 v39, v11, v8, 1                             // 0000006CC524: D6470027 0206110B
	v_cndmask_b32_e64 v39, v14, v39, s34                       // 0000006CC52C: D5010027 008A4F0E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CC534: D7006A09 02010509
	s_mul_i32 s32, s38, 2                                      // 0000006CC53C: 96208226
	v_add_nc_i32 v10, v10, s32                                 // 0000006CC540: D726000A 0200410A
	s_mul_i32 s32, s36, 2                                      // 0000006CC548: 96208224
	v_add_nc_i32 v11, v11, s32                                 // 0000006CC54C: D726000B 0200410B
	v_cmp_lt_u32_e64 s32, v8, s24                              // 0000006CC554: D4490020 02003108
	v_cmp_lt_u32_e64 s34, v9, s25                              // 0000006CC55C: D4490022 02003309
	s_and_b32 s34, s32, s34                                    // 0000006CC564: 8B222220
	s_mul_i32 s32, 32, s2                                      // 0000006CC568: 962002A0
	v_sub_nc_u32_e64 v42, v8, s32                              // 0000006CC56C: D526002A 02004108
	v_lshlrev_b32_e32 v42, 2, v42                              // 0000006CC574: 30545482
	v_add_lshl_u32 v41, v11, v8, 1                             // 0000006CC578: D6470029 0206110B
	v_cndmask_b32_e64 v41, v14, v41, s34                       // 0000006CC580: D5010029 008A530E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CC588: D7006A09 02010509
	s_mul_i32 s32, s38, 2                                      // 0000006CC590: 96208226
	v_add_nc_i32 v10, v10, s32                                 // 0000006CC594: D726000A 0200410A
	s_mul_i32 s32, s36, 2                                      // 0000006CC59C: 96208224
	v_add_nc_i32 v11, v11, s32                                 // 0000006CC5A0: D726000B 0200410B
	v_cmp_lt_u32_e64 s32, v8, s24                              // 0000006CC5A8: D4490020 02003108
	v_cmp_lt_u32_e64 s34, v9, s25                              // 0000006CC5B0: D4490022 02003309
	s_and_b32 s34, s32, s34                                    // 0000006CC5B8: 8B222220
	s_mul_i32 s32, 32, s2                                      // 0000006CC5BC: 962002A0
	v_sub_nc_u32_e64 v44, v8, s32                              // 0000006CC5C0: D526002C 02004108
	v_lshlrev_b32_e32 v44, 2, v44                              // 0000006CC5C8: 30585882
	v_add_lshl_u32 v43, v11, v8, 1                             // 0000006CC5CC: D647002B 0206110B
	v_cndmask_b32_e64 v43, v14, v43, s34                       // 0000006CC5D4: D501002B 008A570E
	v_mul_f32_e32 v19, s44, v0                                 // 0000006CC5DC: 1026002C
	v_mul_f32_e32 v20, s44, v1                                 // 0000006CC5E0: 1028022C
	v_mul_f32_e32 v21, s44, v2                                 // 0000006CC5E4: 102A042C
	v_mul_f32_e32 v22, s44, v3                                 // 0000006CC5E8: 102C062C
	v_mul_f32_e32 v23, s44, v4                                 // 0000006CC5EC: 102E082C
	v_mul_f32_e32 v24, s44, v5                                 // 0000006CC5F0: 10300A2C
	v_mul_f32_e32 v25, s44, v6                                 // 0000006CC5F4: 10320C2C
	v_mul_f32_e32 v26, s44, v7                                 // 0000006CC5F8: 10340E2C
	s_waitcnt lgkmcnt(0)                                       // 0000006CC5FC: BF89FC07
	v_mov_b32_e32 v16, 0xffff0000                              // 0000006CC600: 7E2002FF FFFF0000
	v_mov_b32_e32 v17, 0x7fff0000                              // 0000006CC608: 7E2202FF 7FFF0000
	v_mov_b32_e32 v18, 0x7fff                                  // 0000006CC610: 7E2402FF 00007FFF
	v_mul_f32_e32 v19, v28, v19                                // 0000006CC618: 1026271C
	v_add_f32_e32 v12, v27, v19                                // 0000006CC61C: 0618271B
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CC620: BE9E490C
	v_mov_b32_e32 v19, v12                                     // 0000006CC624: 7E26030C
	v_cmp_u_f32_e64 s32, v19, v19                              // 0000006CC628: D4180020 02022713
	v_bfe_u32 v15, v19, 16, 1                                  // 0000006CC630: D610000F 02052113
	v_add3_u32 v15, v19, v15, v18                              // 0000006CC638: D655000F 044A1F13
	v_cndmask_b32_e64 v19, v15, v17, s32                       // 0000006CC640: D5010013 0082230F
	v_lshrrev_b32_e32 v19, 16, v19                             // 0000006CC648: 32262690
	buffer_store_b16 v19, v29, s[16:19], 0 offen               // 0000006CC64C: E0640000 8044131D
	v_mul_f32_e32 v20, v28, v20                                // 0000006CC654: 1028291C
	v_add_f32_e32 v12, v27, v20                                // 0000006CC658: 0618291B
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CC65C: BE9E490C
	v_mov_b32_e32 v20, v12                                     // 0000006CC660: 7E28030C
	v_cmp_u_f32_e64 s32, v20, v20                              // 0000006CC664: D4180020 02022914
	v_bfe_u32 v15, v20, 16, 1                                  // 0000006CC66C: D610000F 02052114
	v_add3_u32 v15, v20, v15, v18                              // 0000006CC674: D655000F 044A1F14
	v_cndmask_b32_e64 v20, v15, v17, s32                       // 0000006CC67C: D5010014 0082230F
	v_lshrrev_b32_e32 v20, 16, v20                             // 0000006CC684: 32282890
	buffer_store_b16 v20, v31, s[16:19], 0 offen               // 0000006CC688: E0640000 8044141F
	v_mul_f32_e32 v21, v28, v21                                // 0000006CC690: 102A2B1C
	v_add_f32_e32 v12, v27, v21                                // 0000006CC694: 06182B1B
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CC698: BE9E490C
	v_mov_b32_e32 v21, v12                                     // 0000006CC69C: 7E2A030C
	v_cmp_u_f32_e64 s32, v21, v21                              // 0000006CC6A0: D4180020 02022B15
	v_bfe_u32 v15, v21, 16, 1                                  // 0000006CC6A8: D610000F 02052115
	v_add3_u32 v15, v21, v15, v18                              // 0000006CC6B0: D655000F 044A1F15
	v_cndmask_b32_e64 v21, v15, v17, s32                       // 0000006CC6B8: D5010015 0082230F
	v_lshrrev_b32_e32 v21, 16, v21                             // 0000006CC6C0: 322A2A90
	buffer_store_b16 v21, v33, s[16:19], 0 offen               // 0000006CC6C4: E0640000 80441521
	v_mul_f32_e32 v22, v28, v22                                // 0000006CC6CC: 102C2D1C
	v_add_f32_e32 v12, v27, v22                                // 0000006CC6D0: 06182D1B
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CC6D4: BE9E490C
	v_mov_b32_e32 v22, v12                                     // 0000006CC6D8: 7E2C030C
	v_cmp_u_f32_e64 s32, v22, v22                              // 0000006CC6DC: D4180020 02022D16
	v_bfe_u32 v15, v22, 16, 1                                  // 0000006CC6E4: D610000F 02052116
	v_add3_u32 v15, v22, v15, v18                              // 0000006CC6EC: D655000F 044A1F16
	v_cndmask_b32_e64 v22, v15, v17, s32                       // 0000006CC6F4: D5010016 0082230F
	v_lshrrev_b32_e32 v22, 16, v22                             // 0000006CC6FC: 322C2C90
	buffer_store_b16 v22, v35, s[16:19], 0 offen               // 0000006CC700: E0640000 80441623
	v_mul_f32_e32 v23, v28, v23                                // 0000006CC708: 102E2F1C
	v_add_f32_e32 v12, v27, v23                                // 0000006CC70C: 06182F1B
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CC710: BE9E490C
	v_mov_b32_e32 v23, v12                                     // 0000006CC714: 7E2E030C
	v_cmp_u_f32_e64 s32, v23, v23                              // 0000006CC718: D4180020 02022F17
	v_bfe_u32 v15, v23, 16, 1                                  // 0000006CC720: D610000F 02052117
	v_add3_u32 v15, v23, v15, v18                              // 0000006CC728: D655000F 044A1F17
	v_cndmask_b32_e64 v23, v15, v17, s32                       // 0000006CC730: D5010017 0082230F
	v_lshrrev_b32_e32 v23, 16, v23                             // 0000006CC738: 322E2E90
	buffer_store_b16 v23, v37, s[16:19], 0 offen               // 0000006CC73C: E0640000 80441725
	v_mul_f32_e32 v24, v28, v24                                // 0000006CC744: 1030311C
	v_add_f32_e32 v12, v27, v24                                // 0000006CC748: 0618311B
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CC74C: BE9E490C
	v_mov_b32_e32 v24, v12                                     // 0000006CC750: 7E30030C
	v_cmp_u_f32_e64 s32, v24, v24                              // 0000006CC754: D4180020 02023118
	v_bfe_u32 v15, v24, 16, 1                                  // 0000006CC75C: D610000F 02052118
	v_add3_u32 v15, v24, v15, v18                              // 0000006CC764: D655000F 044A1F18
	v_cndmask_b32_e64 v24, v15, v17, s32                       // 0000006CC76C: D5010018 0082230F
	v_lshrrev_b32_e32 v24, 16, v24                             // 0000006CC774: 32303090
	buffer_store_b16 v24, v39, s[16:19], 0 offen               // 0000006CC778: E0640000 80441827
	v_mul_f32_e32 v25, v28, v25                                // 0000006CC780: 1032331C
	v_add_f32_e32 v12, v27, v25                                // 0000006CC784: 0618331B
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CC788: BE9E490C
	v_mov_b32_e32 v25, v12                                     // 0000006CC78C: 7E32030C
	v_cmp_u_f32_e64 s32, v25, v25                              // 0000006CC790: D4180020 02023319
	v_bfe_u32 v15, v25, 16, 1                                  // 0000006CC798: D610000F 02052119
	v_add3_u32 v15, v25, v15, v18                              // 0000006CC7A0: D655000F 044A1F19
	v_cndmask_b32_e64 v25, v15, v17, s32                       // 0000006CC7A8: D5010019 0082230F
	v_lshrrev_b32_e32 v25, 16, v25                             // 0000006CC7B0: 32323290
	buffer_store_b16 v25, v41, s[16:19], 0 offen               // 0000006CC7B4: E0640000 80441929
	v_mul_f32_e32 v26, v28, v26                                // 0000006CC7BC: 1034351C
	v_add_f32_e32 v12, v27, v26                                // 0000006CC7C0: 0618351B
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CC7C4: BE9E490C
	v_mov_b32_e32 v26, v12                                     // 0000006CC7C8: 7E34030C
	v_cmp_u_f32_e64 s32, v26, v26                              // 0000006CC7CC: D4180020 0202351A
	v_bfe_u32 v15, v26, 16, 1                                  // 0000006CC7D4: D610000F 0205211A
	v_add3_u32 v15, v26, v15, v18                              // 0000006CC7DC: D655000F 044A1F1A
	v_cndmask_b32_e64 v26, v15, v17, s32                       // 0000006CC7E4: D501001A 0082230F
	v_lshrrev_b32_e32 v26, 16, v26                             // 0000006CC7EC: 32343490
	buffer_store_b16 v26, v43, s[16:19], 0 offen               // 0000006CC7F0: E0640000 80441A2B
	s_nop 0                                                    // 0000006CC7F8: BF800000
	s_branch label_GW_End_2                                    // 0000006CC7FC: BFA00275

<label_GW_B1_GSU1>:
	s_and_b32 s32, 31, s24                                     // 0000006CC800: 8B20189F
	s_add_u32 s33, -1, s14                                     // 0000006CC804: 80210EC1
	s_cmp_ge_u32 s2, s33                                       // 0000006CC808: BF092102
	s_cselect_b32 s32, s32, 0                                  // 0000006CC80C: 98208020
	s_cmpk_gt_u32 s32, 0x0                                     // 0000006CC810: B5A00000
	s_cbranch_scc1 label_GW_B1_FD0_VW1_GSU1_Else               // 0000006CC814: BFA200F6
	s_and_b32 s32, 15, s25                                     // 0000006CC818: 8B20198F
	s_add_u32 s33, -1, s15                                     // 0000006CC81C: 80210FC1
	s_cmp_ge_u32 s3, s33                                       // 0000006CC820: BF092103
	s_cselect_b32 s32, s32, 0                                  // 0000006CC824: 98208020
	s_cmpk_gt_u32 s32, 0x0                                     // 0000006CC828: B5A00000
	s_cbranch_scc1 label_GW_B1_FD0_VW1_GSU1_Else               // 0000006CC82C: BFA200F0

<label_GW_B1_FD0_VW1_GSU1_NonEdge>:
	v_add_lshl_u32 v20, v10, v8, 1                             // 0000006CC830: D6470014 0206110A
	buffer_load_d16_b16 v30, v20, s[20:23], 0 offen            // 0000006CC838: E0800000 80451E14
	s_mul_i32 s8, 32, s2                                       // 0000006CC840: 960802A0
	v_sub_nc_u32_e64 v21, v8, s8                               // 0000006CC844: D5260015 02001108
	v_lshlrev_b32_e32 v21, 2, v21                              // 0000006CC84C: 302A2A82
	s_waitcnt lgkmcnt(0)                                       // 0000006CC850: BF89FC07
	s_barrier                                                  // 0000006CC854: BFBD0000
	ds_load_b32 v31, v21                                       // 0000006CC858: D8D80000 1F000015
	ds_load_b32 v32, v21 offset:256                            // 0000006CC860: D8D80100 20000015
	s_mul_i32 s8, s38, 4                                       // 0000006CC868: 96088426
	s_add_u32 s20, s20, s8                                     // 0000006CC86C: 80140814
	s_addc_u32 s21, s21, 0                                     // 0000006CC870: 82158015
	buffer_load_d16_b16 v33, v20, s[20:23], 0 offen            // 0000006CC874: E0800000 80452114
	s_mul_i32 s8, s38, 4                                       // 0000006CC87C: 96088426
	s_add_u32 s20, s20, s8                                     // 0000006CC880: 80140814
	s_addc_u32 s21, s21, 0                                     // 0000006CC884: 82158015
	buffer_load_d16_b16 v34, v20, s[20:23], 0 offen            // 0000006CC888: E0800000 80452214
	s_mul_i32 s8, s38, 4                                       // 0000006CC890: 96088426
	s_add_u32 s20, s20, s8                                     // 0000006CC894: 80140814
	s_addc_u32 s21, s21, 0                                     // 0000006CC898: 82158015
	buffer_load_d16_b16 v35, v20, s[20:23], 0 offen            // 0000006CC89C: E0800000 80452314
	s_mul_i32 s8, s38, 4                                       // 0000006CC8A4: 96088426
	s_add_u32 s20, s20, s8                                     // 0000006CC8A8: 80140814
	s_addc_u32 s21, s21, 0                                     // 0000006CC8AC: 82158015
	buffer_load_d16_b16 v36, v20, s[20:23], 0 offen            // 0000006CC8B0: E0800000 80452414
	s_mul_i32 s8, s38, 4                                       // 0000006CC8B8: 96088426
	s_add_u32 s20, s20, s8                                     // 0000006CC8BC: 80140814
	s_addc_u32 s21, s21, 0                                     // 0000006CC8C0: 82158015
	buffer_load_d16_b16 v37, v20, s[20:23], 0 offen            // 0000006CC8C4: E0800000 80452514
	s_mul_i32 s8, s38, 4                                       // 0000006CC8CC: 96088426
	s_add_u32 s20, s20, s8                                     // 0000006CC8D0: 80140814
	s_addc_u32 s21, s21, 0                                     // 0000006CC8D4: 82158015
	buffer_load_d16_b16 v38, v20, s[20:23], 0 offen            // 0000006CC8D8: E0800000 80452614
	s_mul_i32 s8, s38, 4                                       // 0000006CC8E0: 96088426
	s_add_u32 s20, s20, s8                                     // 0000006CC8E4: 80140814
	s_addc_u32 s21, s21, 0                                     // 0000006CC8E8: 82158015
	buffer_load_d16_b16 v39, v20, s[20:23], 0 offen            // 0000006CC8EC: E0800000 80452714
	v_add_lshl_u32 v19, v11, v8, 1                             // 0000006CC8F4: D6470013 0206110B
	v_mul_f32_e32 v22, s44, v0                                 // 0000006CC8FC: 102C002C
	v_mul_f32_e32 v23, s44, v1                                 // 0000006CC900: 102E022C
	v_mul_f32_e32 v24, s44, v2                                 // 0000006CC904: 1030042C
	v_mul_f32_e32 v25, s44, v3                                 // 0000006CC908: 1032062C
	v_mul_f32_e32 v26, s44, v4                                 // 0000006CC90C: 1034082C
	v_mul_f32_e32 v27, s44, v5                                 // 0000006CC910: 10360A2C
	v_mul_f32_e32 v28, s44, v6                                 // 0000006CC914: 10380C2C
	v_mul_f32_e32 v29, s44, v7                                 // 0000006CC918: 103A0E2C
	v_mov_b32_e32 v16, 0xffff0000                              // 0000006CC91C: 7E2002FF FFFF0000
	v_mov_b32_e32 v17, 0x7fff0000                              // 0000006CC924: 7E2202FF 7FFF0000
	v_mov_b32_e32 v18, 0x7fff                                  // 0000006CC92C: 7E2402FF 00007FFF
	s_waitcnt vmcnt(7) lgkmcnt(0)                              // 0000006CC934: BF891C07
	v_mul_f32_e32 v22, v32, v22                                // 0000006CC938: 102C2D20
	v_lshlrev_b32_e32 v12, 16, v30                             // 0000006CC93C: 30183C90
	v_fmac_f32_e64 v22, v12, s45                               // 0000006CC940: D52B0016 02005B0C
	v_add_f32_e32 v12, v31, v22                                // 0000006CC948: 06182D1F
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CC94C: BE9E490C
	v_mov_b32_e32 v22, v12                                     // 0000006CC950: 7E2C030C
	v_cmp_u_f32_e64 s8, v22, v22                               // 0000006CC954: D4180008 02022D16
	v_bfe_u32 v15, v22, 16, 1                                  // 0000006CC95C: D610000F 02052116
	v_add3_u32 v15, v22, v15, v18                              // 0000006CC964: D655000F 044A1F16
	v_cndmask_b32_e64 v22, v15, v17, s8                        // 0000006CC96C: D5010016 0022230F
	v_lshrrev_b32_e32 v22, 16, v22                             // 0000006CC974: 322C2C90
	buffer_store_b16 v22, v19, s[16:19], 0 offen               // 0000006CC978: E0640000 80441613
	s_waitcnt vmcnt(6)                                         // 0000006CC980: BF891BF7
	v_mul_f32_e32 v23, v32, v23                                // 0000006CC984: 102E2F20
	v_lshlrev_b32_e32 v12, 16, v33                             // 0000006CC988: 30184290
	v_fmac_f32_e64 v23, v12, s45                               // 0000006CC98C: D52B0017 02005B0C
	v_add_f32_e32 v12, v31, v23                                // 0000006CC994: 06182F1F
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CC998: BE9E490C
	v_mov_b32_e32 v23, v12                                     // 0000006CC99C: 7E2E030C
	v_cmp_u_f32_e64 s8, v23, v23                               // 0000006CC9A0: D4180008 02022F17
	v_bfe_u32 v15, v23, 16, 1                                  // 0000006CC9A8: D610000F 02052117
	v_add3_u32 v15, v23, v15, v18                              // 0000006CC9B0: D655000F 044A1F17
	v_cndmask_b32_e64 v23, v15, v17, s8                        // 0000006CC9B8: D5010017 0022230F
	v_lshrrev_b32_e32 v23, 16, v23                             // 0000006CC9C0: 322E2E90
	s_mul_i32 s8, s36, 4                                       // 0000006CC9C4: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CC9C8: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CC9CC: 82118011
	buffer_store_b16 v23, v19, s[16:19], 0 offen               // 0000006CC9D0: E0640000 80441713
	s_waitcnt vmcnt(5)                                         // 0000006CC9D8: BF8917F7
	v_mul_f32_e32 v24, v32, v24                                // 0000006CC9DC: 10303120
	v_lshlrev_b32_e32 v12, 16, v34                             // 0000006CC9E0: 30184490
	v_fmac_f32_e64 v24, v12, s45                               // 0000006CC9E4: D52B0018 02005B0C
	v_add_f32_e32 v12, v31, v24                                // 0000006CC9EC: 0618311F
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CC9F0: BE9E490C
	v_mov_b32_e32 v24, v12                                     // 0000006CC9F4: 7E30030C
	v_cmp_u_f32_e64 s8, v24, v24                               // 0000006CC9F8: D4180008 02023118
	v_bfe_u32 v15, v24, 16, 1                                  // 0000006CCA00: D610000F 02052118
	v_add3_u32 v15, v24, v15, v18                              // 0000006CCA08: D655000F 044A1F18
	v_cndmask_b32_e64 v24, v15, v17, s8                        // 0000006CCA10: D5010018 0022230F
	v_lshrrev_b32_e32 v24, 16, v24                             // 0000006CCA18: 32303090
	s_mul_i32 s8, s36, 4                                       // 0000006CCA1C: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CCA20: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CCA24: 82118011
	buffer_store_b16 v24, v19, s[16:19], 0 offen               // 0000006CCA28: E0640000 80441813
	s_waitcnt vmcnt(4)                                         // 0000006CCA30: BF8913F7
	v_mul_f32_e32 v25, v32, v25                                // 0000006CCA34: 10323320
	v_lshlrev_b32_e32 v12, 16, v35                             // 0000006CCA38: 30184690
	v_fmac_f32_e64 v25, v12, s45                               // 0000006CCA3C: D52B0019 02005B0C
	v_add_f32_e32 v12, v31, v25                                // 0000006CCA44: 0618331F
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CCA48: BE9E490C
	v_mov_b32_e32 v25, v12                                     // 0000006CCA4C: 7E32030C
	v_cmp_u_f32_e64 s8, v25, v25                               // 0000006CCA50: D4180008 02023319
	v_bfe_u32 v15, v25, 16, 1                                  // 0000006CCA58: D610000F 02052119
	v_add3_u32 v15, v25, v15, v18                              // 0000006CCA60: D655000F 044A1F19
	v_cndmask_b32_e64 v25, v15, v17, s8                        // 0000006CCA68: D5010019 0022230F
	v_lshrrev_b32_e32 v25, 16, v25                             // 0000006CCA70: 32323290
	s_mul_i32 s8, s36, 4                                       // 0000006CCA74: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CCA78: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CCA7C: 82118011
	buffer_store_b16 v25, v19, s[16:19], 0 offen               // 0000006CCA80: E0640000 80441913
	s_waitcnt vmcnt(3)                                         // 0000006CCA88: BF890FF7
	v_mul_f32_e32 v26, v32, v26                                // 0000006CCA8C: 10343520
	v_lshlrev_b32_e32 v12, 16, v36                             // 0000006CCA90: 30184890
	v_fmac_f32_e64 v26, v12, s45                               // 0000006CCA94: D52B001A 02005B0C
	v_add_f32_e32 v12, v31, v26                                // 0000006CCA9C: 0618351F
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CCAA0: BE9E490C
	v_mov_b32_e32 v26, v12                                     // 0000006CCAA4: 7E34030C
	v_cmp_u_f32_e64 s8, v26, v26                               // 0000006CCAA8: D4180008 0202351A
	v_bfe_u32 v15, v26, 16, 1                                  // 0000006CCAB0: D610000F 0205211A
	v_add3_u32 v15, v26, v15, v18                              // 0000006CCAB8: D655000F 044A1F1A
	v_cndmask_b32_e64 v26, v15, v17, s8                        // 0000006CCAC0: D501001A 0022230F
	v_lshrrev_b32_e32 v26, 16, v26                             // 0000006CCAC8: 32343490
	s_mul_i32 s8, s36, 4                                       // 0000006CCACC: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CCAD0: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CCAD4: 82118011
	buffer_store_b16 v26, v19, s[16:19], 0 offen               // 0000006CCAD8: E0640000 80441A13
	s_waitcnt vmcnt(2)                                         // 0000006CCAE0: BF890BF7
	v_mul_f32_e32 v27, v32, v27                                // 0000006CCAE4: 10363720
	v_lshlrev_b32_e32 v12, 16, v37                             // 0000006CCAE8: 30184A90
	v_fmac_f32_e64 v27, v12, s45                               // 0000006CCAEC: D52B001B 02005B0C
	v_add_f32_e32 v12, v31, v27                                // 0000006CCAF4: 0618371F
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CCAF8: BE9E490C
	v_mov_b32_e32 v27, v12                                     // 0000006CCAFC: 7E36030C
	v_cmp_u_f32_e64 s8, v27, v27                               // 0000006CCB00: D4180008 0202371B
	v_bfe_u32 v15, v27, 16, 1                                  // 0000006CCB08: D610000F 0205211B
	v_add3_u32 v15, v27, v15, v18                              // 0000006CCB10: D655000F 044A1F1B
	v_cndmask_b32_e64 v27, v15, v17, s8                        // 0000006CCB18: D501001B 0022230F
	v_lshrrev_b32_e32 v27, 16, v27                             // 0000006CCB20: 32363690
	s_mul_i32 s8, s36, 4                                       // 0000006CCB24: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CCB28: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CCB2C: 82118011
	buffer_store_b16 v27, v19, s[16:19], 0 offen               // 0000006CCB30: E0640000 80441B13
	s_waitcnt vmcnt(1)                                         // 0000006CCB38: BF8907F7
	v_mul_f32_e32 v28, v32, v28                                // 0000006CCB3C: 10383920
	v_lshlrev_b32_e32 v12, 16, v38                             // 0000006CCB40: 30184C90
	v_fmac_f32_e64 v28, v12, s45                               // 0000006CCB44: D52B001C 02005B0C
	v_add_f32_e32 v12, v31, v28                                // 0000006CCB4C: 0618391F
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CCB50: BE9E490C
	v_mov_b32_e32 v28, v12                                     // 0000006CCB54: 7E38030C
	v_cmp_u_f32_e64 s8, v28, v28                               // 0000006CCB58: D4180008 0202391C
	v_bfe_u32 v15, v28, 16, 1                                  // 0000006CCB60: D610000F 0205211C
	v_add3_u32 v15, v28, v15, v18                              // 0000006CCB68: D655000F 044A1F1C
	v_cndmask_b32_e64 v28, v15, v17, s8                        // 0000006CCB70: D501001C 0022230F
	v_lshrrev_b32_e32 v28, 16, v28                             // 0000006CCB78: 32383890
	s_mul_i32 s8, s36, 4                                       // 0000006CCB7C: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CCB80: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CCB84: 82118011
	buffer_store_b16 v28, v19, s[16:19], 0 offen               // 0000006CCB88: E0640000 80441C13
	s_waitcnt vmcnt(0)                                         // 0000006CCB90: BF8903F7
	v_mul_f32_e32 v29, v32, v29                                // 0000006CCB94: 103A3B20
	v_lshlrev_b32_e32 v12, 16, v39                             // 0000006CCB98: 30184E90
	v_fmac_f32_e64 v29, v12, s45                               // 0000006CCB9C: D52B001D 02005B0C
	v_add_f32_e32 v12, v31, v29                                // 0000006CCBA4: 06183B1F
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CCBA8: BE9E490C
	v_mov_b32_e32 v29, v12                                     // 0000006CCBAC: 7E3A030C
	v_cmp_u_f32_e64 s8, v29, v29                               // 0000006CCBB0: D4180008 02023B1D
	v_bfe_u32 v15, v29, 16, 1                                  // 0000006CCBB8: D610000F 0205211D
	v_add3_u32 v15, v29, v15, v18                              // 0000006CCBC0: D655000F 044A1F1D
	v_cndmask_b32_e64 v29, v15, v17, s8                        // 0000006CCBC8: D501001D 0022230F
	v_lshrrev_b32_e32 v29, 16, v29                             // 0000006CCBD0: 323A3A90
	s_mul_i32 s8, s36, 4                                       // 0000006CCBD4: 96088424
	s_add_u32 s16, s16, s8                                     // 0000006CCBD8: 80100810
	s_addc_u32 s17, s17, 0                                     // 0000006CCBDC: 82118011
	buffer_store_b16 v29, v19, s[16:19], 0 offen               // 0000006CCBE0: E0640000 80441D13
	s_nop 0                                                    // 0000006CCBE8: BF800000
	s_branch label_GW_End_2                                    // 0000006CCBEC: BFA00179

<label_GW_B1_FD0_VW1_GSU1_Then>:
	v_mov_b32_e32 v14, 0xfffff000                              // 0000006CCBF0: 7E1C02FF FFFFF000
	v_cmp_lt_u32_e64 s32, v8, s24                              // 0000006CCBF8: D4490020 02003108
	v_cmp_lt_u32_e64 s34, v9, s25                              // 0000006CCC00: D4490022 02003309
	s_and_b32 s34, s32, s34                                    // 0000006CCC08: 8B222220
	v_add_lshl_u32 v30, v10, v8, 1                             // 0000006CCC0C: D647001E 0206110A
	v_cndmask_b32_e64 v30, v14, v30, s34                       // 0000006CCC14: D501001E 008A3D0E
	buffer_load_d16_b16 v27, v30, s[20:23], 0 offen            // 0000006CCC1C: E0800000 80451B1E
	s_mul_i32 s32, 32, s2                                      // 0000006CCC24: 962002A0
	v_sub_nc_u32_e64 v31, v8, s32                              // 0000006CCC28: D526001F 02004108
	v_lshlrev_b32_e32 v31, 2, v31                              // 0000006CCC30: 303E3E82
	s_waitcnt lgkmcnt(0)                                       // 0000006CCC34: BF89FC07
	s_barrier                                                  // 0000006CCC38: BFBD0000
	ds_load_b32 v28, v31                                       // 0000006CCC3C: D8D80000 1C00001F
	ds_load_b32 v29, v31 offset:256                            // 0000006CCC44: D8D80100 1D00001F
	v_add_lshl_u32 v30, v11, v8, 1                             // 0000006CCC4C: D647001E 0206110B
	v_cndmask_b32_e64 v30, v14, v30, s34                       // 0000006CCC54: D501001E 008A3D0E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CCC5C: D7006A09 02010509
	s_mul_i32 s32, s38, 2                                      // 0000006CCC64: 96208226
	v_add_nc_i32 v10, v10, s32                                 // 0000006CCC68: D726000A 0200410A
	s_mul_i32 s32, s36, 2                                      // 0000006CCC70: 96208224
	v_add_nc_i32 v11, v11, s32                                 // 0000006CCC74: D726000B 0200410B
	v_cmp_lt_u32_e64 s32, v8, s24                              // 0000006CCC7C: D4490020 02003108
	v_cmp_lt_u32_e64 s34, v9, s25                              // 0000006CCC84: D4490022 02003309
	s_and_b32 s34, s32, s34                                    // 0000006CCC8C: 8B222220
	v_add_lshl_u32 v33, v10, v8, 1                             // 0000006CCC90: D6470021 0206110A
	v_cndmask_b32_e64 v33, v14, v33, s34                       // 0000006CCC98: D5010021 008A430E
	buffer_load_d16_b16 v32, v33, s[20:23], 0 offen            // 0000006CCCA0: E0800000 80452021
	s_mul_i32 s32, 32, s2                                      // 0000006CCCA8: 962002A0
	v_sub_nc_u32_e64 v34, v8, s32                              // 0000006CCCAC: D5260022 02004108
	v_lshlrev_b32_e32 v34, 2, v34                              // 0000006CCCB4: 30444482
	v_add_lshl_u32 v33, v11, v8, 1                             // 0000006CCCB8: D6470021 0206110B
	v_cndmask_b32_e64 v33, v14, v33, s34                       // 0000006CCCC0: D5010021 008A430E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CCCC8: D7006A09 02010509
	s_mul_i32 s32, s38, 2                                      // 0000006CCCD0: 96208226
	v_add_nc_i32 v10, v10, s32                                 // 0000006CCCD4: D726000A 0200410A
	s_mul_i32 s32, s36, 2                                      // 0000006CCCDC: 96208224
	v_add_nc_i32 v11, v11, s32                                 // 0000006CCCE0: D726000B 0200410B
	v_cmp_lt_u32_e64 s32, v8, s24                              // 0000006CCCE8: D4490020 02003108
	v_cmp_lt_u32_e64 s34, v9, s25                              // 0000006CCCF0: D4490022 02003309
	s_and_b32 s34, s32, s34                                    // 0000006CCCF8: 8B222220
	v_add_lshl_u32 v36, v10, v8, 1                             // 0000006CCCFC: D6470024 0206110A
	v_cndmask_b32_e64 v36, v14, v36, s34                       // 0000006CCD04: D5010024 008A490E
	buffer_load_d16_b16 v35, v36, s[20:23], 0 offen            // 0000006CCD0C: E0800000 80452324
	s_mul_i32 s32, 32, s2                                      // 0000006CCD14: 962002A0
	v_sub_nc_u32_e64 v37, v8, s32                              // 0000006CCD18: D5260025 02004108
	v_lshlrev_b32_e32 v37, 2, v37                              // 0000006CCD20: 304A4A82
	v_add_lshl_u32 v36, v11, v8, 1                             // 0000006CCD24: D6470024 0206110B
	v_cndmask_b32_e64 v36, v14, v36, s34                       // 0000006CCD2C: D5010024 008A490E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CCD34: D7006A09 02010509
	s_mul_i32 s32, s38, 2                                      // 0000006CCD3C: 96208226
	v_add_nc_i32 v10, v10, s32                                 // 0000006CCD40: D726000A 0200410A
	s_mul_i32 s32, s36, 2                                      // 0000006CCD48: 96208224
	v_add_nc_i32 v11, v11, s32                                 // 0000006CCD4C: D726000B 0200410B
	v_cmp_lt_u32_e64 s32, v8, s24                              // 0000006CCD54: D4490020 02003108
	v_cmp_lt_u32_e64 s34, v9, s25                              // 0000006CCD5C: D4490022 02003309
	s_and_b32 s34, s32, s34                                    // 0000006CCD64: 8B222220
	v_add_lshl_u32 v39, v10, v8, 1                             // 0000006CCD68: D6470027 0206110A
	v_cndmask_b32_e64 v39, v14, v39, s34                       // 0000006CCD70: D5010027 008A4F0E
	buffer_load_d16_b16 v38, v39, s[20:23], 0 offen            // 0000006CCD78: E0800000 80452627
	s_mul_i32 s32, 32, s2                                      // 0000006CCD80: 962002A0
	v_sub_nc_u32_e64 v40, v8, s32                              // 0000006CCD84: D5260028 02004108
	v_lshlrev_b32_e32 v40, 2, v40                              // 0000006CCD8C: 30505082
	v_add_lshl_u32 v39, v11, v8, 1                             // 0000006CCD90: D6470027 0206110B
	v_cndmask_b32_e64 v39, v14, v39, s34                       // 0000006CCD98: D5010027 008A4F0E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CCDA0: D7006A09 02010509
	s_mul_i32 s32, s38, 2                                      // 0000006CCDA8: 96208226
	v_add_nc_i32 v10, v10, s32                                 // 0000006CCDAC: D726000A 0200410A
	s_mul_i32 s32, s36, 2                                      // 0000006CCDB4: 96208224
	v_add_nc_i32 v11, v11, s32                                 // 0000006CCDB8: D726000B 0200410B
	v_cmp_lt_u32_e64 s32, v8, s24                              // 0000006CCDC0: D4490020 02003108
	v_cmp_lt_u32_e64 s34, v9, s25                              // 0000006CCDC8: D4490022 02003309
	s_and_b32 s34, s32, s34                                    // 0000006CCDD0: 8B222220
	v_add_lshl_u32 v42, v10, v8, 1                             // 0000006CCDD4: D647002A 0206110A
	v_cndmask_b32_e64 v42, v14, v42, s34                       // 0000006CCDDC: D501002A 008A550E
	buffer_load_d16_b16 v41, v42, s[20:23], 0 offen            // 0000006CCDE4: E0800000 8045292A
	s_mul_i32 s32, 32, s2                                      // 0000006CCDEC: 962002A0
	v_sub_nc_u32_e64 v43, v8, s32                              // 0000006CCDF0: D526002B 02004108
	v_lshlrev_b32_e32 v43, 2, v43                              // 0000006CCDF8: 30565682
	v_add_lshl_u32 v42, v11, v8, 1                             // 0000006CCDFC: D647002A 0206110B
	v_cndmask_b32_e64 v42, v14, v42, s34                       // 0000006CCE04: D501002A 008A550E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CCE0C: D7006A09 02010509
	s_mul_i32 s32, s38, 2                                      // 0000006CCE14: 96208226
	v_add_nc_i32 v10, v10, s32                                 // 0000006CCE18: D726000A 0200410A
	s_mul_i32 s32, s36, 2                                      // 0000006CCE20: 96208224
	v_add_nc_i32 v11, v11, s32                                 // 0000006CCE24: D726000B 0200410B
	v_cmp_lt_u32_e64 s32, v8, s24                              // 0000006CCE2C: D4490020 02003108
	v_cmp_lt_u32_e64 s34, v9, s25                              // 0000006CCE34: D4490022 02003309
	s_and_b32 s34, s32, s34                                    // 0000006CCE3C: 8B222220
	v_add_lshl_u32 v45, v10, v8, 1                             // 0000006CCE40: D647002D 0206110A
	v_cndmask_b32_e64 v45, v14, v45, s34                       // 0000006CCE48: D501002D 008A5B0E
	buffer_load_d16_b16 v44, v45, s[20:23], 0 offen            // 0000006CCE50: E0800000 80452C2D
	s_mul_i32 s32, 32, s2                                      // 0000006CCE58: 962002A0
	v_sub_nc_u32_e64 v46, v8, s32                              // 0000006CCE5C: D526002E 02004108
	v_lshlrev_b32_e32 v46, 2, v46                              // 0000006CCE64: 305C5C82
	v_add_lshl_u32 v45, v11, v8, 1                             // 0000006CCE68: D647002D 0206110B
	v_cndmask_b32_e64 v45, v14, v45, s34                       // 0000006CCE70: D501002D 008A5B0E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CCE78: D7006A09 02010509
	s_mul_i32 s32, s38, 2                                      // 0000006CCE80: 96208226
	v_add_nc_i32 v10, v10, s32                                 // 0000006CCE84: D726000A 0200410A
	s_mul_i32 s32, s36, 2                                      // 0000006CCE8C: 96208224
	v_add_nc_i32 v11, v11, s32                                 // 0000006CCE90: D726000B 0200410B
	v_cmp_lt_u32_e64 s32, v8, s24                              // 0000006CCE98: D4490020 02003108
	v_cmp_lt_u32_e64 s34, v9, s25                              // 0000006CCEA0: D4490022 02003309
	s_and_b32 s34, s32, s34                                    // 0000006CCEA8: 8B222220
	v_add_lshl_u32 v48, v10, v8, 1                             // 0000006CCEAC: D6470030 0206110A
	v_cndmask_b32_e64 v48, v14, v48, s34                       // 0000006CCEB4: D5010030 008A610E
	buffer_load_d16_b16 v47, v48, s[20:23], 0 offen            // 0000006CCEBC: E0800000 80452F30
	s_mul_i32 s32, 32, s2                                      // 0000006CCEC4: 962002A0
	v_sub_nc_u32_e64 v49, v8, s32                              // 0000006CCEC8: D5260031 02004108
	v_lshlrev_b32_e32 v49, 2, v49                              // 0000006CCED0: 30626282
	v_add_lshl_u32 v48, v11, v8, 1                             // 0000006CCED4: D6470030 0206110B
	v_cndmask_b32_e64 v48, v14, v48, s34                       // 0000006CCEDC: D5010030 008A610E
	v_add_co_u32 v9, vcc_lo, v9, 2                             // 0000006CCEE4: D7006A09 02010509
	s_mul_i32 s32, s38, 2                                      // 0000006CCEEC: 96208226
	v_add_nc_i32 v10, v10, s32                                 // 0000006CCEF0: D726000A 0200410A
	s_mul_i32 s32, s36, 2                                      // 0000006CCEF8: 96208224
	v_add_nc_i32 v11, v11, s32                                 // 0000006CCEFC: D726000B 0200410B
	v_cmp_lt_u32_e64 s32, v8, s24                              // 0000006CCF04: D4490020 02003108
	v_cmp_lt_u32_e64 s34, v9, s25                              // 0000006CCF0C: D4490022 02003309
	s_and_b32 s34, s32, s34                                    // 0000006CCF14: 8B222220
	v_add_lshl_u32 v51, v10, v8, 1                             // 0000006CCF18: D6470033 0206110A
	v_cndmask_b32_e64 v51, v14, v51, s34                       // 0000006CCF20: D5010033 008A670E
	buffer_load_d16_b16 v50, v51, s[20:23], 0 offen            // 0000006CCF28: E0800000 80453233
	s_mul_i32 s32, 32, s2                                      // 0000006CCF30: 962002A0
	v_sub_nc_u32_e64 v52, v8, s32                              // 0000006CCF34: D5260034 02004108
	v_lshlrev_b32_e32 v52, 2, v52                              // 0000006CCF3C: 30686882
	v_add_lshl_u32 v51, v11, v8, 1                             // 0000006CCF40: D6470033 0206110B
	v_cndmask_b32_e64 v51, v14, v51, s34                       // 0000006CCF48: D5010033 008A670E
	v_mul_f32_e32 v19, s44, v0                                 // 0000006CCF50: 1026002C
	v_mul_f32_e32 v20, s44, v1                                 // 0000006CCF54: 1028022C
	v_mul_f32_e32 v21, s44, v2                                 // 0000006CCF58: 102A042C
	v_mul_f32_e32 v22, s44, v3                                 // 0000006CCF5C: 102C062C
	v_mul_f32_e32 v23, s44, v4                                 // 0000006CCF60: 102E082C
	v_mul_f32_e32 v24, s44, v5                                 // 0000006CCF64: 10300A2C
	v_mul_f32_e32 v25, s44, v6                                 // 0000006CCF68: 10320C2C
	v_mul_f32_e32 v26, s44, v7                                 // 0000006CCF6C: 10340E2C
	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)                    // 0000006CCF70: BF890000
	v_mov_b32_e32 v16, 0xffff0000                              // 0000006CCF74: 7E2002FF FFFF0000
	v_mov_b32_e32 v17, 0x7fff0000                              // 0000006CCF7C: 7E2202FF 7FFF0000
	v_mov_b32_e32 v18, 0x7fff                                  // 0000006CCF84: 7E2402FF 00007FFF
	v_mul_f32_e32 v19, v29, v19                                // 0000006CCF8C: 1026271D
	v_lshlrev_b32_e32 v12, 16, v27                             // 0000006CCF90: 30183690
	v_fmac_f32_e64 v19, v12, s45                               // 0000006CCF94: D52B0013 02005B0C
	v_add_f32_e32 v12, v28, v19                                // 0000006CCF9C: 0618271C
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CCFA0: BE9E490C
	v_mov_b32_e32 v19, v12                                     // 0000006CCFA4: 7E26030C
	v_cmp_u_f32_e64 s32, v19, v19                              // 0000006CCFA8: D4180020 02022713
	v_bfe_u32 v15, v19, 16, 1                                  // 0000006CCFB0: D610000F 02052113
	v_add3_u32 v15, v19, v15, v18                              // 0000006CCFB8: D655000F 044A1F13
	v_cndmask_b32_e64 v19, v15, v17, s32                       // 0000006CCFC0: D5010013 0082230F
	v_lshrrev_b32_e32 v19, 16, v19                             // 0000006CCFC8: 32262690
	buffer_store_b16 v19, v30, s[16:19], 0 offen               // 0000006CCFCC: E0640000 8044131E
	v_mul_f32_e32 v20, v29, v20                                // 0000006CCFD4: 1028291D
	v_lshlrev_b32_e32 v12, 16, v32                             // 0000006CCFD8: 30184090
	v_fmac_f32_e64 v20, v12, s45                               // 0000006CCFDC: D52B0014 02005B0C
	v_add_f32_e32 v12, v28, v20                                // 0000006CCFE4: 0618291C
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CCFE8: BE9E490C
	v_mov_b32_e32 v20, v12                                     // 0000006CCFEC: 7E28030C
	v_cmp_u_f32_e64 s32, v20, v20                              // 0000006CCFF0: D4180020 02022914
	v_bfe_u32 v15, v20, 16, 1                                  // 0000006CCFF8: D610000F 02052114
	v_add3_u32 v15, v20, v15, v18                              // 0000006CD000: D655000F 044A1F14
	v_cndmask_b32_e64 v20, v15, v17, s32                       // 0000006CD008: D5010014 0082230F
	v_lshrrev_b32_e32 v20, 16, v20                             // 0000006CD010: 32282890
	buffer_store_b16 v20, v33, s[16:19], 0 offen               // 0000006CD014: E0640000 80441421
	v_mul_f32_e32 v21, v29, v21                                // 0000006CD01C: 102A2B1D
	v_lshlrev_b32_e32 v12, 16, v35                             // 0000006CD020: 30184690
	v_fmac_f32_e64 v21, v12, s45                               // 0000006CD024: D52B0015 02005B0C
	v_add_f32_e32 v12, v28, v21                                // 0000006CD02C: 06182B1C
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CD030: BE9E490C
	v_mov_b32_e32 v21, v12                                     // 0000006CD034: 7E2A030C
	v_cmp_u_f32_e64 s32, v21, v21                              // 0000006CD038: D4180020 02022B15
	v_bfe_u32 v15, v21, 16, 1                                  // 0000006CD040: D610000F 02052115
	v_add3_u32 v15, v21, v15, v18                              // 0000006CD048: D655000F 044A1F15
	v_cndmask_b32_e64 v21, v15, v17, s32                       // 0000006CD050: D5010015 0082230F
	v_lshrrev_b32_e32 v21, 16, v21                             // 0000006CD058: 322A2A90
	buffer_store_b16 v21, v36, s[16:19], 0 offen               // 0000006CD05C: E0640000 80441524
	v_mul_f32_e32 v22, v29, v22                                // 0000006CD064: 102C2D1D
	v_lshlrev_b32_e32 v12, 16, v38                             // 0000006CD068: 30184C90
	v_fmac_f32_e64 v22, v12, s45                               // 0000006CD06C: D52B0016 02005B0C
	v_add_f32_e32 v12, v28, v22                                // 0000006CD074: 06182D1C
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CD078: BE9E490C
	v_mov_b32_e32 v22, v12                                     // 0000006CD07C: 7E2C030C
	v_cmp_u_f32_e64 s32, v22, v22                              // 0000006CD080: D4180020 02022D16
	v_bfe_u32 v15, v22, 16, 1                                  // 0000006CD088: D610000F 02052116
	v_add3_u32 v15, v22, v15, v18                              // 0000006CD090: D655000F 044A1F16
	v_cndmask_b32_e64 v22, v15, v17, s32                       // 0000006CD098: D5010016 0082230F
	v_lshrrev_b32_e32 v22, 16, v22                             // 0000006CD0A0: 322C2C90
	buffer_store_b16 v22, v39, s[16:19], 0 offen               // 0000006CD0A4: E0640000 80441627
	v_mul_f32_e32 v23, v29, v23                                // 0000006CD0AC: 102E2F1D
	v_lshlrev_b32_e32 v12, 16, v41                             // 0000006CD0B0: 30185290
	v_fmac_f32_e64 v23, v12, s45                               // 0000006CD0B4: D52B0017 02005B0C
	v_add_f32_e32 v12, v28, v23                                // 0000006CD0BC: 06182F1C
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CD0C0: BE9E490C
	v_mov_b32_e32 v23, v12                                     // 0000006CD0C4: 7E2E030C
	v_cmp_u_f32_e64 s32, v23, v23                              // 0000006CD0C8: D4180020 02022F17
	v_bfe_u32 v15, v23, 16, 1                                  // 0000006CD0D0: D610000F 02052117
	v_add3_u32 v15, v23, v15, v18                              // 0000006CD0D8: D655000F 044A1F17
	v_cndmask_b32_e64 v23, v15, v17, s32                       // 0000006CD0E0: D5010017 0082230F
	v_lshrrev_b32_e32 v23, 16, v23                             // 0000006CD0E8: 322E2E90
	buffer_store_b16 v23, v42, s[16:19], 0 offen               // 0000006CD0EC: E0640000 8044172A
	v_mul_f32_e32 v24, v29, v24                                // 0000006CD0F4: 1030311D
	v_lshlrev_b32_e32 v12, 16, v44                             // 0000006CD0F8: 30185890
	v_fmac_f32_e64 v24, v12, s45                               // 0000006CD0FC: D52B0018 02005B0C
	v_add_f32_e32 v12, v28, v24                                // 0000006CD104: 0618311C
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CD108: BE9E490C
	v_mov_b32_e32 v24, v12                                     // 0000006CD10C: 7E30030C
	v_cmp_u_f32_e64 s32, v24, v24                              // 0000006CD110: D4180020 02023118
	v_bfe_u32 v15, v24, 16, 1                                  // 0000006CD118: D610000F 02052118
	v_add3_u32 v15, v24, v15, v18                              // 0000006CD120: D655000F 044A1F18
	v_cndmask_b32_e64 v24, v15, v17, s32                       // 0000006CD128: D5010018 0082230F
	v_lshrrev_b32_e32 v24, 16, v24                             // 0000006CD130: 32303090
	buffer_store_b16 v24, v45, s[16:19], 0 offen               // 0000006CD134: E0640000 8044182D
	v_mul_f32_e32 v25, v29, v25                                // 0000006CD13C: 1032331D
	v_lshlrev_b32_e32 v12, 16, v47                             // 0000006CD140: 30185E90
	v_fmac_f32_e64 v25, v12, s45                               // 0000006CD144: D52B0019 02005B0C
	v_add_f32_e32 v12, v28, v25                                // 0000006CD14C: 0618331C
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CD150: BE9E490C
	v_mov_b32_e32 v25, v12                                     // 0000006CD154: 7E32030C
	v_cmp_u_f32_e64 s32, v25, v25                              // 0000006CD158: D4180020 02023319
	v_bfe_u32 v15, v25, 16, 1                                  // 0000006CD160: D610000F 02052119
	v_add3_u32 v15, v25, v15, v18                              // 0000006CD168: D655000F 044A1F19
	v_cndmask_b32_e64 v25, v15, v17, s32                       // 0000006CD170: D5010019 0082230F
	v_lshrrev_b32_e32 v25, 16, v25                             // 0000006CD178: 32323290
	buffer_store_b16 v25, v48, s[16:19], 0 offen               // 0000006CD17C: E0640000 80441930
	v_mul_f32_e32 v26, v29, v26                                // 0000006CD184: 1034351D
	v_lshlrev_b32_e32 v12, 16, v50                             // 0000006CD188: 30186490
	v_fmac_f32_e64 v26, v12, s45                               // 0000006CD18C: D52B001A 02005B0C
	v_add_f32_e32 v12, v28, v26                                // 0000006CD194: 0618351C
	s_swappc_b64 s[30:31], s[12:13]                            // 0000006CD198: BE9E490C
	v_mov_b32_e32 v26, v12                                     // 0000006CD19C: 7E34030C
	v_cmp_u_f32_e64 s32, v26, v26                              // 0000006CD1A0: D4180020 0202351A
	v_bfe_u32 v15, v26, 16, 1                                  // 0000006CD1A8: D610000F 0205211A
	v_add3_u32 v15, v26, v15, v18                              // 0000006CD1B0: D655000F 044A1F1A
	v_cndmask_b32_e64 v26, v15, v17, s32                       // 0000006CD1B8: D501001A 0082230F
	v_lshrrev_b32_e32 v26, 16, v26                             // 0000006CD1C0: 32343490
	buffer_store_b16 v26, v51, s[16:19], 0 offen               // 0000006CD1C4: E0640000 80441A33
	s_nop 0                                                    // 0000006CD1CC: BF800000
	s_branch label_GW_End_2                                    // 0000006CD1D0: BFA00000

<label_KernelEnd>:
	s_endpgm                                                   // 0000006CD1D4: BFB00000

<label_Activation_None_VW1>:
	s_setpc_b64 s[30:31]                                       // 0000006CD1D8: BE80481E

<label_Activation_Gelu_VW1>:
	v_mul_f32_e32 v13, 0x3d372713, v12                         // 0000006CD1DC: 101A18FF 3D372713
	v_fma_f32 v13, v12, v13, 1.0                               // 0000006CD1E4: D613000D 03CA1B0C
	v_mul_f32_e32 v13, v12, v13                                // 0000006CD1EC: 101A1B0C
	v_mul_f32_e32 v13, 0x40135761, v13                         // 0000006CD1F0: 101A1AFF 40135761
	v_exp_f32_e32 v13, v13                                     // 0000006CD1F8: 7E1A4B0D
	v_add_f32_e32 v13, 1.0, v13                                // 0000006CD1FC: 061A1AF2
	v_rcp_f32_e32 v13, v13                                     // 0000006CD200: 7E1A550D
	v_fma_f32 v13, -2.0, v13, 2.0                              // 0000006CD204: D613000D 03D21AF5
	v_mul_f32_e32 v13, v12, v13                                // 0000006CD20C: 101A1B0C
	v_mul_f32_e32 v12, 0.5, v13                                // 0000006CD210: 10181AF0
	s_setpc_b64 s[30:31]                                       // 0000006CD214: BE80481E

<label_Activation_Relu_VW1>:
	v_max_f32_e64 v12, v12, 0                                  // 0000006CD218: D510000C 0201010C
	s_setpc_b64 s[30:31]                                       // 0000006CD220: BE80481E

<label_Activation_Sigmoid_VW1>:
	v_mul_f32_e32 v12, 0xbfb8aa3b, v12                         // 0000006CD224: 101818FF BFB8AA3B
	v_exp_f32_e32 v12, v12                                     // 0000006CD22C: 7E184B0C
	v_add_f32_e32 v12, 1.0, v12                                // 0000006CD230: 061818F2
	v_rcp_f32_e32 v12, v12                                     // 0000006CD234: 7E18550C
	s_setpc_b64 s[30:31]                                       // 0000006CD238: BE80481E

<label_Activation_Silu_VW1>:
	v_mul_f32_e32 v13, 0xbfb8aa3b, v12                         // 0000006CD23C: 101A18FF BFB8AA3B
	v_exp_f32_e32 v13, v13                                     // 0000006CD244: 7E1A4B0D
	v_add_f32_e32 v13, 1.0, v13                                // 0000006CD248: 061A1AF2
	v_rcp_f32_e32 v13, v13                                     // 0000006CD24C: 7E1A550D
	v_mul_f32_e32 v12, v12, v13                                // 0000006CD250: 10181B0C
	s_setpc_b64 s[30:31]                                       // 0000006CD254: BE80481E

<label_Activation_Clamp_VW1>:
	v_min_f32_e32 v12, s55, v12                                // 0000006CD258: 1E181837
	v_max_f32_e32 v12, s54, v12                                // 0000006CD25C: 20181836
	s_setpc_b64 s[30:31]                                       // 0000006CD260: BE80481E
	s_endpgm                                                   // 0000006CD264: BFB00000
