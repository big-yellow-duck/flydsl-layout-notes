	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	_matmul_bf16_0
	.p2align	8
	.type	_matmul_bf16_0,@function
_matmul_bf16_0:
	s_clause 0x1
	s_load_b128 s[4:7], s[0:1], 0x0
	s_load_b32 s3, s[0:1], 0x10
	v_dual_mov_b32 v10, 0 :: v_dual_lshlrev_b32 v1, 3, v0
	s_ashr_i32 s8, s2, 31
	v_lshrrev_b32_e32 v27, 2, v0
	s_lshr_b32 s8, s8, 30
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_dual_mov_b32 v7, 0 :: v_dual_and_b32 v26, 24, v1
	s_add_i32 s8, s2, s8
	v_cmp_eq_u32_e32 vcc_lo, 0, v27
	s_and_b32 s9, s8, -4
	s_delay_alu instid0(VALU_DEP_2)
	v_mad_u32_u24 v2, 0x2008, v27, v26
	s_sub_i32 s13, s2, s9
	v_dual_mov_b32 v6, 0 :: v_dual_mov_b32 v9, 0
	s_mul_i32 s9, s13, 0x820
	v_mov_b32_e32 v8, 0
	v_add_lshl_u32 v11, v2, s9, 1
	s_ashr_i32 s18, s8, 2
	s_waitcnt lgkmcnt(0)
	s_add_i32 s6, s6, -1
	s_and_b32 s5, s5, 0xffff
	s_mul_i32 s3, s3, s6
	s_delay_alu instid0(SALU_CYCLE_1)
	s_add_i32 s3, s7, s3
	s_mov_b32 s7, 0x31027000
	s_lshl_b32 s6, s3, 1
	buffer_load_b128 v[2:5], v11, s[4:7], 0 offen
	s_and_saveexec_b32 s3, vcc_lo
	s_cbranch_execz .LBB0_2
	v_add_nc_u32_e32 v6, 0x40000, v11
	buffer_load_b128 v[6:9], v6, s[4:7], 0 offen offset:256
.LBB0_2:
	s_or_b32 exec_lo, exec_lo, s3
	s_clause 0x1
	s_load_b128 s[8:11], s[0:1], 0x18
	s_load_b32 s3, s[0:1], 0x28
	s_lshl_b32 s12, s18, 2
	v_lshrrev_b32_e32 v28, 3, v0
	v_dual_mov_b32 v12, 0 :: v_dual_and_b32 v29, 56, v1
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_4) | instid1(SALU_CYCLE_1)
	v_mad_u32_u24 v1, 0x408, v28, v29
	s_waitcnt lgkmcnt(0)
	s_add_i32 s10, s10, -1
	s_and_b32 s9, s9, 0xffff
	s_mul_i32 s3, s3, s10
	s_add_i32 s3, s11, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_4) | instid1(SALU_CYCLE_1)
	s_lshl_b32 s10, s3, 1
	s_cmp_lg_u32 s2, s12
	s_cselect_b32 s3, -1, 0
	s_cmp_lt_i32 s2, 0
	s_cselect_b32 s11, -1, 0
	s_and_b32 s3, s11, s3
	s_subb_u32 s3, s18, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_hi_i32 s11, s3, 0x78787879
	s_lshr_b32 s12, s11, 31
	s_ashr_i32 s11, s11, 3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_i32 s11, s11, s12
	s_mul_i32 s12, s11, 17
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(SALU_CYCLE_1)
	s_cmp_lg_u32 s3, s12
	s_cselect_b32 s14, -1, 0
	s_cmp_lt_i32 s3, 0
	s_cselect_b32 s15, -1, 0
	s_and_b32 s14, s15, s14
	s_subb_u32 s15, s11, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_sub_i32 s11, 1, s15
	s_min_i32 s11, s11, 1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_abs_i32 s14, s11
	s_cvt_f32_u32 s16, s14
	s_delay_alu instid0(SALU_CYCLE_3) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_rcp_f32_e32 v11, s16
	v_readfirstlane_b32 s16, v11
	v_mov_b32_e32 v11, 0
	s_mul_f32 s16, s16, 0x4f7ffffe
	s_delay_alu instid0(SALU_CYCLE_3) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)
	s_cvt_u32_f32 s17, s16
	s_sub_i32 s16, 0, s14
	s_mul_i32 s19, s16, s17
	s_sub_i32 s16, s3, s12
	s_mul_hi_u32 s3, s17, s19
	s_abs_i32 s12, s16
	s_add_i32 s17, s17, s3
	s_delay_alu instid0(SALU_CYCLE_1)
	s_mul_hi_u32 s3, s12, s17
	s_xor_b32 s17, s16, s11
	s_mul_i32 s20, s3, s14
	s_ashr_i32 s19, s17, 31
	s_sub_i32 s12, s12, s20
	s_add_i32 s17, s3, 1
	s_sub_i32 s20, s12, s14
	s_cmp_ge_u32 s12, s14
	s_cselect_b32 s3, s17, s3
	s_cselect_b32 s12, s20, s12
	s_add_i32 s17, s3, 1
	s_cmp_ge_u32 s12, s14
	s_cselect_b32 s3, s17, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s20, s3, s19
	s_sub_i32 s17, s20, s19
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_i32 s17, s17, s11
	s_cmp_lg_u32 s16, s17
	s_cselect_b32 s3, -1, 0
	s_cmp_lt_i32 s16, 0
	s_cselect_b32 s11, -1, 0
	s_cmp_gt_i32 s15, 1
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s11, s11, s12
	s_and_b32 s3, s11, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_4) | instid1(SALU_CYCLE_1)
	s_and_b32 s11, s3, exec_lo
	s_cselect_b32 s21, -1, 0
	s_cmp_lg_u32 s3, 0
	s_mul_i32 s3, s13, 0x20c100
	s_subb_u32 s14, s20, s19
	s_lshl_b32 s12, s14, 6
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_or_b32_e32 v13, s12, v29
	v_add3_u32 v32, s3, s12, v1
	v_cmp_gt_i32_e64 s3, 0x401, v13
	v_mov_b32_e32 v13, 0
	s_and_saveexec_b32 s22, s3
	s_cbranch_execz .LBB0_4
	v_lshlrev_b32_e32 v1, 1, v32
	s_mov_b32 s11, s7
	buffer_load_b128 v[10:13], v1, s[8:11], 0 offen slc
.LBB0_4:
	s_or_b32 exec_lo, exec_lo, s22
	v_dual_mov_b32 v14, 0 :: v_dual_mov_b32 v19, 0
	v_dual_mov_b32 v18, 0 :: v_dual_mov_b32 v21, 0
	v_mov_b32_e32 v20, 0
	s_and_saveexec_b32 s22, s3
	s_cbranch_execz .LBB0_6
	v_lshl_add_u32 v1, v32, 1, 0x4000
	s_mov_b32 s11, s7
	buffer_load_b128 v[18:21], v1, s[8:11], 0 offen offset:128 slc
.LBB0_6:
	s_or_b32 exec_lo, exec_lo, s22
	v_dual_mov_b32 v15, 0 :: v_dual_mov_b32 v16, 0
	v_mov_b32_e32 v17, 0
	s_and_saveexec_b32 s22, s3
	s_cbranch_execz .LBB0_8
	v_lshl_add_u32 v1, v32, 1, 0x8000
	s_mov_b32 s11, s7
	buffer_load_b128 v[14:17], v1, s[8:11], 0 offen offset:256 slc
.LBB0_8:
	s_or_b32 exec_lo, exec_lo, s22
	v_mul_u32_u24_e32 v30, 0x2008, v27
	v_mul_u32_u24_e32 v31, 0x408, v28
	v_dual_mov_b32 v1, 0 :: v_dual_mov_b32 v22, 0
	v_dual_mov_b32 v23, 0 :: v_dual_mov_b32 v24, 0
	v_mov_b32_e32 v25, 0
	s_and_saveexec_b32 s22, s3
	s_cbranch_execz .LBB0_10
	v_lshl_add_u32 v22, v32, 1, 0xc000
	s_mov_b32 s11, s7
	buffer_load_b128 v[22:25], v22, s[8:11], 0 offen offset:384 slc
.LBB0_10:
	s_or_b32 exec_lo, exec_lo, s22
	v_lshl_or_b32 v32, v26, 1, 0x1000
	v_lshlrev_b32_e32 v58, 1, v29
	v_lshlrev_b32_e32 v59, 7, v28
	s_add_i32 s20, s20, s21
	v_and_b32_e32 v93, 15, v0
	v_mad_u32_u24 v29, 0x50, v27, v32
	s_mul_i32 s22, s2, 0x418200
	v_or_b32_e32 v33, v58, v59
	s_lshl_b32 s20, s20, 7
	s_mul_i32 s11, s2, 0x820
	s_waitcnt vmcnt(0)
	ds_store_b128 v29, v[2:5]
	ds_store_b128 v29, v[6:9] offset:1280
	ds_store_b128 v33, v[10:13]
	ds_store_b128 v33, v[18:21] offset:1024
	v_dual_mov_b32 v6, v1 :: v_dual_and_b32 v3, 3, v0
	v_dual_mov_b32 v9, v1 :: v_dual_and_b32 v4, 7, v0
	s_mulk_i32 s2, 0x1040
	s_add_i32 s22, s22, s20
	v_mul_u32_u24_e32 v2, 0x50, v93
	v_lshl_or_b32 v3, v3, 4, s2
	v_lshl_or_b32 v4, v4, 4, s22
	v_or_b32_e32 v5, s11, v28
	s_mul_i32 s2, s18, 0x2080
	v_lshrrev_b32_e32 v34, 1, v0
	v_or_b32_e32 v57, 0x1000, v2
	v_lshl_add_u32 v2, v30, 1, v3
	v_lshl_add_u32 v3, v31, 1, v4
	v_subrev_nc_u32_e32 v4, s2, v5
	s_mul_i32 s20, s18, 0x4100
	s_lshl_b32 s19, s19, 7
	v_mul_u32_u24_e32 v27, 0x50, v27
	v_dual_mov_b32 v5, v1 :: v_dual_and_b32 v94, 16, v34
	v_subrev_nc_u32_e32 v2, s20, v2
	v_subrev_nc_u32_e32 v3, s19, v3
	v_dual_mov_b32 v8, v1 :: v_dual_add_nc_u32 v63, 64, v4
	v_mov_b32_e32 v4, v1
	v_dual_mov_b32 v7, v1 :: v_dual_lshlrev_b32 v60, 1, v93
	s_mul_i32 s18, s18, 0x1060800
	ds_store_b128 v33, v[14:17] offset:2048
	ds_store_b128 v33, v[22:25] offset:3072
	v_sub_nc_u32_e32 v61, 0x2001, v26
	v_lshl_or_b32 v62, v94, 1, v60
	v_dual_mov_b32 v11, v1 :: v_dual_add_nc_u32 v64, 0x40180, v2
	v_subrev_nc_u32_e32 v65, s18, v3
	v_dual_mov_b32 v13, v1 :: v_dual_add_nc_u32 v66, v32, v27
	v_mov_b32_e32 v2, v1
	v_mov_b32_e32 v3, v1
	v_mov_b32_e32 v10, v1
	v_mov_b32_e32 v12, v1
	v_mov_b32_e32 v14, v1
	v_mov_b32_e32 v15, v1
	v_mov_b32_e32 v16, v1
	v_mov_b32_e32 v17, v1
	v_mov_b32_e32 v18, v1
	v_mov_b32_e32 v19, v1
	v_mov_b32_e32 v20, v1
	v_mov_b32_e32 v21, v1
	v_mov_b32_e32 v22, v1
	v_mov_b32_e32 v23, v1
	v_mov_b32_e32 v24, v1
	v_mov_b32_e32 v25, v1
	v_mov_b32_e32 v26, v1
	v_mov_b32_e32 v27, v1
	v_mov_b32_e32 v28, v1
	v_mov_b32_e32 v29, v1
	v_mov_b32_e32 v30, v1
	v_mov_b32_e32 v31, v1
	v_mov_b32_e32 v32, v1
	s_sub_i32 s2, s11, s2
	s_mov_b32 s19, 0
	s_add_i32 s18, s2, 32
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_branch .LBB0_12
.LBB0_11:
	s_or_b32 exec_lo, exec_lo, s2
	ds_load_b128 v[68:71], v57
	ds_load_b128 v[72:75], v57 offset:16
	ds_load_b128 v[76:79], v57 offset:32
	ds_load_b128 v[80:83], v57 offset:48
	ds_load_b128 v[84:87], v57 offset:1280
	ds_load_b128 v[88:91], v57 offset:1296
	ds_load_u16_d16 v95, v62
	ds_load_u16_d16_hi v95, v62 offset:128
	ds_load_u16_d16 v96, v62 offset:256
	ds_load_u16_d16_hi v96, v62 offset:384
	ds_load_u16_d16_hi v104, v62 offset:448
	ds_load_u16_d16 v104, v62 offset:320
	ds_load_u16_d16_hi v103, v62 offset:192
	ds_load_u16_d16 v103, v62 offset:64
	ds_load_u16_d16 v97, v62 offset:512
	ds_load_u16_d16_hi v97, v62 offset:640
	ds_load_u16_d16 v98, v62 offset:768
	ds_load_u16_d16_hi v98, v62 offset:896
	ds_load_u16_d16_hi v106, v62 offset:960
	ds_load_u16_d16 v106, v62 offset:832
	ds_load_u16_d16_hi v105, v62 offset:704
	ds_load_u16_d16 v105, v62 offset:576
	ds_load_u16_d16 v99, v62 offset:1024
	ds_load_u16_d16_hi v99, v62 offset:1152
	ds_load_u16_d16 v100, v62 offset:1280
	ds_load_u16_d16_hi v100, v62 offset:1408
	ds_load_u16_d16_hi v108, v62 offset:1472
	ds_load_u16_d16 v108, v62 offset:1344
	ds_load_u16_d16_hi v107, v62 offset:1216
	ds_load_u16_d16 v107, v62 offset:1088
	ds_load_u16_d16 v101, v62 offset:1536
	ds_load_u16_d16_hi v101, v62 offset:1664
	ds_load_u16_d16 v102, v62 offset:1792
	ds_load_u16_d16_hi v102, v62 offset:1920
	ds_load_u16_d16_hi v110, v62 offset:1984
	ds_load_u16_d16 v110, v62 offset:1856
	ds_load_u16_d16_hi v109, v62 offset:1728
	ds_load_u16_d16 v109, v62 offset:1600
	ds_load_u16_d16 v111, v62 offset:2048
	ds_load_u16_d16_hi v111, v62 offset:2176
	ds_load_u16_d16 v112, v62 offset:2304
	ds_load_u16_d16_hi v112, v62 offset:2432
	ds_load_u16_d16_hi v120, v62 offset:2496
	ds_load_u16_d16 v120, v62 offset:2368
	ds_load_u16_d16_hi v119, v62 offset:2240
	ds_load_u16_d16 v119, v62 offset:2112
	ds_load_u16_d16 v113, v62 offset:2560
	ds_load_u16_d16_hi v113, v62 offset:2688
	ds_load_u16_d16 v114, v62 offset:2816
	ds_load_u16_d16_hi v114, v62 offset:2944
	ds_load_u16_d16_hi v122, v62 offset:3008
	ds_load_u16_d16 v122, v62 offset:2880
	ds_load_u16_d16_hi v121, v62 offset:2752
	ds_load_u16_d16 v121, v62 offset:2624
	ds_load_u16_d16 v115, v62 offset:3072
	ds_load_u16_d16_hi v115, v62 offset:3200
	ds_load_u16_d16 v116, v62 offset:3328
	ds_load_u16_d16_hi v116, v62 offset:3456
	ds_load_u16_d16_hi v124, v62 offset:3520
	ds_load_u16_d16 v124, v62 offset:3392
	ds_load_u16_d16_hi v123, v62 offset:3264
	ds_load_u16_d16 v123, v62 offset:3136
	ds_load_u16_d16 v117, v62 offset:3584
	ds_load_u16_d16_hi v117, v62 offset:3712
	ds_load_u16_d16 v118, v62 offset:3840
	ds_load_u16_d16_hi v118, v62 offset:3968
	ds_load_u16_d16_hi v126, v62 offset:4032
	ds_load_u16_d16 v126, v62 offset:3904
	ds_load_u16_d16_hi v125, v62 offset:3776
	ds_load_u16_d16 v125, v62 offset:3648
	ds_load_b128 v[127:130], v57 offset:1312
	ds_load_b128 v[131:134], v57 offset:1328
	s_waitcnt lgkmcnt(38)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[68:75], v[95:102], v[1:8]
	s_waitcnt lgkmcnt(34)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[68:75], v[103:110], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[84:91], v[95:102], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[84:91], v[103:110], v[25:32]
	v_add_nc_u32_e32 v63, 64, v63
	v_add_nc_u32_e32 v64, 0x80, v64
	s_add_i32 s19, s19, 0x20400
	s_add_i32 s18, s18, 64
	s_cmp_lg_u32 s19, 0x408000
	s_waitcnt lgkmcnt(6)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[76:83], v[111:118], v[1:8]
	s_waitcnt lgkmcnt(2)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[76:83], v[119:126], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[127:134], v[111:118], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[127:134], v[119:126], v[25:32]
	s_barrier
	s_waitcnt vmcnt(0)
	ds_store_b128 v66, v[37:40]
	ds_store_b128 v66, v[33:36] offset:1280
	ds_store_b128 v67, v[45:48]
	ds_store_b128 v67, v[41:44] offset:1024
	ds_store_b128 v67, v[53:56] offset:2048
	ds_store_b128 v67, v[49:52] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_cbranch_scc0 .LBB0_36
.LBB0_12:
	v_cmp_lt_i32_e64 s2, s18, v61
	s_cmpk_lt_i32 s18, 0x2008
	v_dual_mov_b32 v33, 0 :: v_dual_mov_b32 v38, 0
	v_dual_mov_b32 v37, 0 :: v_dual_mov_b32 v40, 0
	v_mov_b32_e32 v39, 0
	s_cselect_b32 s20, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s20, s2
	s_and_saveexec_b32 s11, s21
	s_cbranch_execz .LBB0_14
	v_add_nc_u32_e32 v34, 0xfffbfec0, v64
	buffer_load_b128 v[37:40], v34, s[4:7], 0 offen
.LBB0_14:
	s_or_b32 exec_lo, exec_lo, s11
	v_dual_mov_b32 v34, 0 :: v_dual_mov_b32 v35, 0
	v_mov_b32_e32 v36, 0
	s_and_b32 s2, vcc_lo, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s11, s20, s2
	s_and_saveexec_b32 s2, s11
	s_cbranch_execz .LBB0_16
	v_subrev_nc_u32_e32 v33, 64, v64
	buffer_load_b128 v[33:36], v33, s[4:7], 0 offen
.LBB0_16:
	s_or_b32 exec_lo, exec_lo, s2
	v_subrev_nc_u32_e32 v50, 32, v63
	v_dual_mov_b32 v41, 0 :: v_dual_mov_b32 v46, 0
	v_dual_mov_b32 v45, 0 :: v_dual_mov_b32 v48, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	v_cmp_gt_i32_e64 s2, 0x2008, v50
	v_mov_b32_e32 v47, 0
	s_and_b32 s2, s3, s2
	s_and_b32 s11, s20, s2
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s2, s11
	s_cbranch_execz .LBB0_18
	v_add3_u32 v42, v65, s19, 0x10000
	s_mov_b32 s11, s7
	buffer_load_b128 v[45:48], v42, s[8:11], 0 offen offset:512 slc
.LBB0_18:
	s_or_b32 exec_lo, exec_lo, s2
	v_cmp_gt_i32_e64 s2, 0x2000, v50
	v_dual_mov_b32 v42, 0 :: v_dual_mov_b32 v43, 0
	v_mov_b32_e32 v44, 0
	s_and_b32 s2, s3, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s11, s20, s2
	s_and_saveexec_b32 s2, s11
	s_cbranch_execz .LBB0_20
	v_add3_u32 v41, v65, s19, 0x14000
	s_mov_b32 s11, s7
	buffer_load_b128 v[41:44], v41, s[8:11], 0 offen offset:640 slc
.LBB0_20:
	s_or_b32 exec_lo, exec_lo, s2
	v_cmp_gt_i32_e64 s2, 0x1ff8, v50
	v_dual_mov_b32 v49, 0 :: v_dual_mov_b32 v54, 0
	v_dual_mov_b32 v53, 0 :: v_dual_mov_b32 v56, 0
	v_mov_b32_e32 v55, 0
	s_and_b32 s2, s3, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s11, s20, s2
	s_and_saveexec_b32 s2, s11
	s_cbranch_execz .LBB0_22
	v_add3_u32 v51, v65, s19, 0x18000
	s_mov_b32 s11, s7
	buffer_load_b128 v[53:56], v51, s[8:11], 0 offen offset:768 slc
.LBB0_22:
	s_or_b32 exec_lo, exec_lo, s2
	v_cmp_gt_i32_e64 s2, 0x1ff0, v50
	v_dual_mov_b32 v50, 0 :: v_dual_mov_b32 v51, 0
	v_mov_b32_e32 v52, 0
	s_and_b32 s2, s3, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s11, s20, s2
	s_and_saveexec_b32 s2, s11
	s_cbranch_execz .LBB0_24
	v_add3_u32 v49, v65, s19, 0x1c000
	s_mov_b32 s11, s7
	buffer_load_b128 v[49:52], v49, s[8:11], 0 offen offset:896 slc
.LBB0_24:
	s_or_b32 exec_lo, exec_lo, s2
	ds_load_b128 v[67:70], v57
	ds_load_b128 v[71:74], v57 offset:16
	ds_load_b128 v[75:78], v57 offset:32
	ds_load_b128 v[79:82], v57 offset:48
	ds_load_b128 v[83:86], v57 offset:1280
	ds_load_b128 v[87:90], v57 offset:1296
	ds_load_u16_d16 v95, v62
	ds_load_u16_d16_hi v95, v62 offset:128
	ds_load_u16_d16 v96, v62 offset:256
	ds_load_u16_d16_hi v96, v62 offset:384
	ds_load_u16_d16_hi v104, v62 offset:448
	ds_load_u16_d16 v104, v62 offset:320
	ds_load_u16_d16_hi v103, v62 offset:192
	ds_load_u16_d16 v103, v62 offset:64
	ds_load_u16_d16 v97, v62 offset:512
	ds_load_u16_d16_hi v97, v62 offset:640
	ds_load_u16_d16 v98, v62 offset:768
	ds_load_u16_d16_hi v98, v62 offset:896
	ds_load_u16_d16_hi v106, v62 offset:960
	ds_load_u16_d16 v106, v62 offset:832
	ds_load_u16_d16_hi v105, v62 offset:704
	ds_load_u16_d16 v105, v62 offset:576
	ds_load_u16_d16 v99, v62 offset:1024
	ds_load_u16_d16_hi v99, v62 offset:1152
	ds_load_u16_d16 v100, v62 offset:1280
	ds_load_u16_d16_hi v100, v62 offset:1408
	ds_load_u16_d16_hi v108, v62 offset:1472
	ds_load_u16_d16 v108, v62 offset:1344
	ds_load_u16_d16_hi v107, v62 offset:1216
	ds_load_u16_d16 v107, v62 offset:1088
	ds_load_u16_d16 v101, v62 offset:1536
	ds_load_u16_d16_hi v101, v62 offset:1664
	ds_load_u16_d16 v102, v62 offset:1792
	ds_load_u16_d16_hi v102, v62 offset:1920
	ds_load_u16_d16_hi v110, v62 offset:1984
	ds_load_u16_d16 v110, v62 offset:1856
	ds_load_u16_d16_hi v109, v62 offset:1728
	ds_load_u16_d16 v109, v62 offset:1600
	ds_load_u16_d16 v111, v62 offset:2048
	ds_load_u16_d16_hi v111, v62 offset:2176
	ds_load_u16_d16 v112, v62 offset:2304
	ds_load_u16_d16_hi v112, v62 offset:2432
	ds_load_u16_d16_hi v120, v62 offset:2496
	ds_load_u16_d16 v120, v62 offset:2368
	ds_load_u16_d16_hi v119, v62 offset:2240
	ds_load_u16_d16 v119, v62 offset:2112
	ds_load_u16_d16 v113, v62 offset:2560
	ds_load_u16_d16_hi v113, v62 offset:2688
	ds_load_u16_d16 v114, v62 offset:2816
	ds_load_u16_d16_hi v114, v62 offset:2944
	ds_load_u16_d16_hi v122, v62 offset:3008
	ds_load_u16_d16 v122, v62 offset:2880
	ds_load_u16_d16_hi v121, v62 offset:2752
	ds_load_u16_d16 v121, v62 offset:2624
	ds_load_u16_d16 v115, v62 offset:3072
	ds_load_u16_d16_hi v115, v62 offset:3200
	ds_load_u16_d16 v116, v62 offset:3328
	ds_load_u16_d16_hi v116, v62 offset:3456
	ds_load_u16_d16_hi v124, v62 offset:3520
	ds_load_u16_d16 v124, v62 offset:3392
	ds_load_u16_d16_hi v123, v62 offset:3264
	ds_load_u16_d16 v123, v62 offset:3136
	ds_load_u16_d16 v117, v62 offset:3584
	ds_load_u16_d16_hi v117, v62 offset:3712
	ds_load_u16_d16 v118, v62 offset:3840
	ds_load_u16_d16_hi v118, v62 offset:3968
	ds_load_u16_d16_hi v126, v62 offset:4032
	ds_load_u16_d16 v126, v62 offset:3904
	ds_load_u16_d16_hi v125, v62 offset:3776
	ds_load_u16_d16 v125, v62 offset:3648
	ds_load_b128 v[127:130], v57 offset:1312
	ds_load_b128 v[131:134], v57 offset:1328
	s_waitcnt lgkmcnt(38)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[67:74], v[95:102], v[1:8]
	s_waitcnt lgkmcnt(34)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[67:74], v[103:110], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[83:90], v[95:102], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[83:90], v[103:110], v[25:32]
	s_add_i32 s2, s18, 32
	v_add_nc_u32_e32 v67, v58, v59
	s_cmpk_lt_i32 s2, 0x2008
	v_cmp_lt_i32_e64 s2, s2, v61
	s_cselect_b32 s20, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 s21, s20, s2
	s_waitcnt lgkmcnt(6)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[75:82], v[111:118], v[1:8]
	s_waitcnt lgkmcnt(2)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[75:82], v[119:126], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[127:134], v[111:118], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[127:134], v[119:126], v[25:32]
	s_barrier
	s_waitcnt vmcnt(0)
	ds_store_b128 v66, v[37:40]
	ds_store_b128 v66, v[33:36] offset:1280
	ds_store_b128 v67, v[45:48]
	ds_store_b128 v67, v[41:44] offset:1024
	ds_store_b128 v67, v[53:56] offset:2048
	ds_store_b128 v67, v[49:52] offset:3072
	v_dual_mov_b32 v33, 0 :: v_dual_mov_b32 v40, 0
	v_dual_mov_b32 v37, 0 :: v_dual_mov_b32 v38, 0
	v_mov_b32_e32 v39, 0
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_and_saveexec_b32 s11, s21
	s_cbranch_execz .LBB0_26
	v_add_nc_u32_e32 v34, 0xfffbff00, v64
	buffer_load_b128 v[37:40], v34, s[4:7], 0 offen
.LBB0_26:
	s_or_b32 exec_lo, exec_lo, s11
	v_dual_mov_b32 v34, 0 :: v_dual_mov_b32 v35, 0
	v_mov_b32_e32 v36, 0
	s_and_b32 s2, vcc_lo, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s11, s20, s2
	s_and_saveexec_b32 s2, s11
	s_cbranch_execz .LBB0_28
	buffer_load_b128 v[33:36], v64, s[4:7], 0 offen
.LBB0_28:
	s_or_b32 exec_lo, exec_lo, s2
	v_cmp_gt_i32_e64 s2, 0x2008, v63
	v_dual_mov_b32 v41, 0 :: v_dual_mov_b32 v46, 0
	v_dual_mov_b32 v45, 0 :: v_dual_mov_b32 v48, 0
	v_mov_b32_e32 v47, 0
	s_and_b32 s2, s3, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s11, s20, s2
	s_and_saveexec_b32 s2, s11
	s_cbranch_execz .LBB0_30
	v_add3_u32 v42, v65, s19, 0x20000
	s_mov_b32 s11, s7
	buffer_load_b128 v[45:48], v42, s[8:11], 0 offen offset:1024 slc
.LBB0_30:
	s_or_b32 exec_lo, exec_lo, s2
	v_cmp_gt_i32_e64 s2, 0x2000, v63
	v_dual_mov_b32 v42, 0 :: v_dual_mov_b32 v43, 0
	v_mov_b32_e32 v44, 0
	s_and_b32 s2, s3, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s11, s20, s2
	s_and_saveexec_b32 s2, s11
	s_cbranch_execz .LBB0_32
	v_add3_u32 v41, v65, s19, 0x24000
	s_mov_b32 s11, s7
	buffer_load_b128 v[41:44], v41, s[8:11], 0 offen offset:1152 slc
.LBB0_32:
	s_or_b32 exec_lo, exec_lo, s2
	v_cmp_gt_i32_e64 s2, 0x1ff8, v63
	v_dual_mov_b32 v49, 0 :: v_dual_mov_b32 v54, 0
	v_dual_mov_b32 v53, 0 :: v_dual_mov_b32 v56, 0
	v_mov_b32_e32 v55, 0
	s_and_b32 s2, s3, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s11, s20, s2
	s_and_saveexec_b32 s2, s11
	s_cbranch_execz .LBB0_34
	v_add3_u32 v50, v65, s19, 0x28000
	s_mov_b32 s11, s7
	buffer_load_b128 v[53:56], v50, s[8:11], 0 offen offset:1280 slc
.LBB0_34:
	s_or_b32 exec_lo, exec_lo, s2
	v_cmp_gt_i32_e64 s2, 0x1ff0, v63
	v_dual_mov_b32 v50, 0 :: v_dual_mov_b32 v51, 0
	v_mov_b32_e32 v52, 0
	s_and_b32 s2, s3, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s11, s20, s2
	s_and_saveexec_b32 s2, s11
	s_cbranch_execz .LBB0_11
	v_add3_u32 v49, v65, s19, 0x2c000
	s_mov_b32 s11, s7
	buffer_load_b128 v[49:52], v49, s[8:11], 0 offen offset:1408 slc
	s_branch .LBB0_11
.LBB0_36:
	v_lshl_add_u32 v33, v94, 1, v60
	ds_load_b128 v[34:37], v57
	ds_load_b128 v[38:41], v57 offset:16
	ds_load_b128 v[42:45], v57 offset:32
	ds_load_b128 v[46:49], v57 offset:48
	ds_load_b128 v[58:61], v57 offset:1280
	ds_load_b128 v[62:65], v57 offset:1296
	ds_load_u16_d16 v66, v33
	ds_load_u16_d16_hi v66, v33 offset:128
	ds_load_u16_d16 v67, v33 offset:256
	ds_load_u16_d16_hi v67, v33 offset:384
	ds_load_u16_d16_hi v75, v33 offset:448
	ds_load_u16_d16 v75, v33 offset:320
	ds_load_u16_d16_hi v74, v33 offset:192
	ds_load_u16_d16 v74, v33 offset:64
	ds_load_u16_d16 v68, v33 offset:512
	ds_load_u16_d16_hi v68, v33 offset:640
	ds_load_u16_d16 v69, v33 offset:768
	ds_load_u16_d16_hi v69, v33 offset:896
	ds_load_u16_d16_hi v77, v33 offset:960
	ds_load_u16_d16 v77, v33 offset:832
	ds_load_u16_d16_hi v76, v33 offset:704
	ds_load_u16_d16 v76, v33 offset:576
	ds_load_u16_d16 v70, v33 offset:1024
	ds_load_u16_d16_hi v70, v33 offset:1152
	ds_load_u16_d16 v71, v33 offset:1280
	ds_load_u16_d16_hi v71, v33 offset:1408
	ds_load_u16_d16_hi v79, v33 offset:1472
	ds_load_u16_d16 v79, v33 offset:1344
	ds_load_u16_d16_hi v78, v33 offset:1216
	ds_load_u16_d16 v78, v33 offset:1088
	ds_load_u16_d16 v72, v33 offset:1536
	ds_load_u16_d16_hi v72, v33 offset:1664
	ds_load_u16_d16 v73, v33 offset:1792
	ds_load_u16_d16_hi v73, v33 offset:1920
	ds_load_u16_d16_hi v81, v33 offset:1984
	ds_load_u16_d16 v81, v33 offset:1856
	ds_load_u16_d16_hi v80, v33 offset:1728
	ds_load_u16_d16 v80, v33 offset:1600
	ds_load_u16_d16 v82, v33 offset:2048
	ds_load_u16_d16_hi v82, v33 offset:2176
	ds_load_u16_d16 v83, v33 offset:2304
	ds_load_u16_d16_hi v83, v33 offset:2432
	ds_load_u16_d16_hi v96, v33 offset:2496
	ds_load_u16_d16 v96, v33 offset:2368
	ds_load_u16_d16_hi v95, v33 offset:2240
	ds_load_u16_d16 v95, v33 offset:2112
	ds_load_u16_d16 v84, v33 offset:2560
	ds_load_u16_d16_hi v84, v33 offset:2688
	ds_load_u16_d16 v85, v33 offset:2816
	ds_load_u16_d16_hi v85, v33 offset:2944
	ds_load_u16_d16_hi v98, v33 offset:3008
	ds_load_u16_d16 v98, v33 offset:2880
	ds_load_u16_d16_hi v97, v33 offset:2752
	ds_load_u16_d16 v97, v33 offset:2624
	ds_load_u16_d16 v86, v33 offset:3072
	ds_load_u16_d16_hi v86, v33 offset:3200
	ds_load_u16_d16 v87, v33 offset:3328
	ds_load_u16_d16_hi v87, v33 offset:3456
	ds_load_u16_d16_hi v100, v33 offset:3520
	ds_load_u16_d16 v100, v33 offset:3392
	ds_load_u16_d16_hi v99, v33 offset:3264
	ds_load_u16_d16 v99, v33 offset:3136
	ds_load_u16_d16 v88, v33 offset:3584
	ds_load_u16_d16_hi v88, v33 offset:3712
	ds_load_u16_d16 v89, v33 offset:3840
	ds_load_u16_d16_hi v89, v33 offset:3968
	ds_load_u16_d16_hi v102, v33 offset:4032
	ds_load_u16_d16 v102, v33 offset:3904
	ds_load_u16_d16_hi v101, v33 offset:3776
	ds_load_u16_d16 v101, v33 offset:3648
	ds_load_b128 v[50:53], v57 offset:1312
	ds_load_b128 v[54:57], v57 offset:1328
	s_sub_i32 s4, s16, s17
	v_lshlrev_b32_e32 v33, 5, v0
	s_add_i32 s4, s4, s15
	s_clause 0x1
	s_load_b64 s[2:3], s[0:1], 0x48
	s_load_b64 s[6:7], s[0:1], 0x58
	s_mul_i32 s4, s4, 17
	s_lshl_b32 s5, s13, 11
	s_add_i32 s14, s14, s4
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[34:41], v[66:73], v[1:8]
	s_lshl_b32 s4, s14, 13
	v_wmma_f32_16x16x16_bf16 v[9:16], v[34:41], v[74:81], v[9:16]
	s_add_i32 s5, s4, s5
	v_lshl_or_b32 v34, s14, 6, v0
	v_or_b32_e32 v90, s5, v33
	v_wmma_f32_16x16x16_bf16 v[17:24], v[58:65], v[66:73], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[58:65], v[74:81], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[42:49], v[82:89], v[1:8]
	v_ashrrev_i32_e32 v35, 31, v34
	v_ashrrev_i32_e32 v91, 31, v90
	v_wmma_f32_16x16x16_bf16 v[9:16], v[42:49], v[95:102], v[9:16]
	v_mov_b32_e32 v103, 1
	v_wmma_f32_16x16x16_bf16 v[17:24], v[50:57], v[82:89], v[17:24]
	v_lshlrev_b64 v[34:35], 2, v[34:35]
	v_lshlrev_b64 v[36:37], 2, v[90:91]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[50:57], v[95:102], v[25:32]
	s_mov_b32 s5, exec_lo
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v36, vcc_lo, s2, v36
	v_add_co_ci_u32_e64 v37, null, s3, v37, vcc_lo
	v_add_co_u32 v91, vcc_lo, s6, v34
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v92, null, s7, v35, vcc_lo
	s_barrier
	s_clause 0x7
	global_store_b128 v[36:37], v[5:8], off offset:16
	global_store_b128 v[36:37], v[1:4], off
	global_store_b128 v[36:37], v[21:24], off offset:80
	global_store_b128 v[36:37], v[17:20], off offset:64
	global_store_b128 v[36:37], v[13:16], off offset:48
	global_store_b128 v[36:37], v[9:12], off offset:32
	global_store_b128 v[36:37], v[29:32], off offset:112
	global_store_b128 v[36:37], v[25:28], off offset:96
	s_waitcnt_vscnt null, 0x0
	global_atomic_add_u32 v1, v[91:92], v103, off glc
	s_waitcnt vmcnt(0)
	buffer_gl1_inv
	buffer_gl0_inv
	v_cmpx_eq_u32_e32 3, v1
	s_cbranch_execz .LBB0_74
	v_or_b32_e32 v1, s4, v33
	s_clause 0x1
	s_load_b128 s[4:7], s[0:1], 0x30
	s_load_b32 s0, s[0:1], 0x40
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v2, 31, v1
	v_lshlrev_b64 v[1:2], 2, v[1:2]
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v22, vcc_lo, s2, v1
	v_add_co_ci_u32_e64 v23, null, s3, v2, vcc_lo
	s_waitcnt lgkmcnt(0)
	s_add_i32 s1, s6, -1
	s_and_b32 s5, s5, 0xffff
	s_mul_i32 s0, s0, s1
	s_clause 0x5
	global_load_b128 v[6:9], v[22:23], off offset:48
	global_load_b128 v[30:33], v[22:23], off offset:32
	global_load_b128 v[51:54], v[22:23], off offset:16
	global_load_b128 v[75:78], v[22:23], off
	global_load_b128 v[1:4], v[22:23], off offset:96
	global_load_b128 v[46:49], v[22:23], off offset:64
	s_waitcnt vmcnt(1)
	v_add_co_u32 v2, vcc_lo, 0x2000, v22
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v3, null, 0, v23, vcc_lo
	v_add_co_u32 v4, vcc_lo, 0x2040, v22
	v_add_co_ci_u32_e64 v5, null, 0, v23, vcc_lo
	s_clause 0x5
	global_load_b128 v[10:13], v[2:3], off offset:48
	global_load_b128 v[34:37], v[2:3], off offset:32
	global_load_b128 v[79:82], v[2:3], off
	global_load_b128 v[59:62], v[2:3], off offset:16
	global_load_b128 v[47:50], v[2:3], off offset:64
	global_load_b128 v[2:5], v[4:5], off offset:32
	s_waitcnt vmcnt(0)
	v_add_co_u32 v3, vcc_lo, 0x4000, v22
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v4, null, 0, v23, vcc_lo
	v_add_co_u32 v14, vcc_lo, 0x4040, v22
	v_add_co_ci_u32_e64 v15, null, 0, v23, vcc_lo
	s_clause 0x5
	global_load_b128 v[18:21], v[3:4], off offset:48
	global_load_b128 v[38:41], v[3:4], off offset:32
	global_load_b128 v[83:86], v[3:4], off
	global_load_b128 v[67:70], v[3:4], off offset:16
	global_load_b128 v[55:58], v[3:4], off offset:64
	global_load_b128 v[14:17], v[14:15], off offset:32
	v_add_co_u32 v3, vcc_lo, 0x6000, v22
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v4, null, 0, v23, vcc_lo
	s_waitcnt vmcnt(0)
	v_add_co_u32 v15, vcc_lo, 0x6040, v22
	v_add_co_ci_u32_e64 v16, null, 0, v23, vcc_lo
	s_clause 0x5
	global_load_b128 v[26:29], v[3:4], off offset:48
	global_load_b128 v[42:45], v[3:4], off offset:32
	global_load_b128 v[87:90], v[3:4], off
	global_load_b128 v[71:74], v[3:4], off offset:16
	global_load_b128 v[63:66], v[3:4], off offset:64
	global_load_b128 v[22:25], v[15:16], off offset:32
	v_bfe_u32 v48, v0, 4, 1
	s_waitcnt vmcnt(0)
	v_or3_b32 v24, v93, s12, v94
	v_or3_b32 v25, v94, v93, s12
	s_add_i32 s1, s7, s0
	s_mov_b32 s7, 0x31027000
	s_lshl_b32 s6, s1, 1
	v_mad_u32_u24 v23, 0x408, v48, v24
	v_cmp_gt_i32_e64 s0, 0x408, v25
	s_delay_alu instid0(VALU_DEP_2)
	v_lshlrev_b32_e32 v0, 1, v23
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_39
	v_add_f32_e32 v3, 0, v75
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v3, v3, v79
	v_add_f32_e32 v3, v3, v83
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v3, v3, v87
	v_bfe_u32 v4, v3, 16, 1
	v_or_b32_e32 v5, 0x400000, v3
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v4, v4, v3, 0x7fff
	v_cndmask_b32_e32 v3, v4, v5, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v3, 16, v3
	buffer_store_b16 v3, v0, s[4:7], 0 offen
.LBB0_39:
	s_or_b32 exec_lo, exec_lo, s1
	v_lshl_add_u32 v3, v23, 1, 0x1000
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_41
	v_add_f32_e32 v4, 0, v76
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v4, v4, v80
	v_add_f32_e32 v4, v4, v84
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v4, v4, v88
	v_bfe_u32 v5, v4, 16, 1
	v_or_b32_e32 v15, 0x400000, v4
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v5, v5, v4, 0x7fff
	v_cndmask_b32_e32 v4, v5, v15, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v4, 16, v4
	buffer_store_b16 v4, v3, s[4:7], 0 offen offset:32
.LBB0_41:
	s_or_b32 exec_lo, exec_lo, s1
	v_lshl_add_u32 v4, v23, 1, 0x2000
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_43
	v_add_f32_e32 v5, 0, v77
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v5, v5, v81
	v_add_f32_e32 v5, v5, v85
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v5, v5, v89
	v_bfe_u32 v15, v5, 16, 1
	v_or_b32_e32 v16, 0x400000, v5
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v15, v15, v5, 0x7fff
	v_cndmask_b32_e32 v5, v15, v16, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v5, 16, v5
	buffer_store_b16 v5, v4, s[4:7], 0 offen offset:64
.LBB0_43:
	s_or_b32 exec_lo, exec_lo, s1
	v_lshl_add_u32 v5, v23, 1, 0x3000
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_45
	v_add_f32_e32 v15, 0, v78
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v15, v15, v82
	v_add_f32_e32 v15, v15, v86
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v15, v15, v90
	v_bfe_u32 v16, v15, 16, 1
	v_or_b32_e32 v17, 0x400000, v15
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v16, v16, v15, 0x7fff
	v_cndmask_b32_e32 v15, v16, v17, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v15, 16, v15
	buffer_store_b16 v15, v5, s[4:7], 0 offen offset:96
.LBB0_45:
	s_or_b32 exec_lo, exec_lo, s1
	v_lshl_add_u32 v15, v23, 1, 0x4000
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_47
	v_add_f32_e32 v16, 0, v51
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v16, v16, v59
	v_add_f32_e32 v16, v16, v67
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v16, v16, v71
	v_bfe_u32 v17, v16, 16, 1
	v_or_b32_e32 v49, 0x400000, v16
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v17, v17, v16, 0x7fff
	v_cndmask_b32_e32 v16, v17, v49, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v16, 16, v16
	buffer_store_b16 v16, v15, s[4:7], 0 offen offset:128
.LBB0_47:
	s_or_b32 exec_lo, exec_lo, s1
	v_lshl_add_u32 v16, v23, 1, 0x5000
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_49
	v_add_f32_e32 v17, 0, v52
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v17, v17, v60
	v_add_f32_e32 v17, v17, v68
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v17, v17, v72
	v_bfe_u32 v49, v17, 16, 1
	v_or_b32_e32 v50, 0x400000, v17
	v_cmp_u_f32_e32 vcc_lo, v17, v17
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v49, v49, v17, 0x7fff
	v_cndmask_b32_e32 v17, v49, v50, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v17, 16, v17
	buffer_store_b16 v17, v16, s[4:7], 0 offen offset:160
.LBB0_49:
	s_or_b32 exec_lo, exec_lo, s1
	v_lshl_add_u32 v17, v23, 1, 0x6000
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_51
	v_add_f32_e32 v49, 0, v53
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v49, v49, v61
	v_add_f32_e32 v49, v49, v69
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v49, v49, v73
	v_bfe_u32 v50, v49, 16, 1
	v_or_b32_e32 v51, 0x400000, v49
	v_cmp_u_f32_e32 vcc_lo, v49, v49
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v50, v50, v49, 0x7fff
	v_cndmask_b32_e32 v49, v50, v51, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v49, 16, v49
	buffer_store_b16 v49, v17, s[4:7], 0 offen offset:192
.LBB0_51:
	s_or_b32 exec_lo, exec_lo, s1
	v_lshl_add_u32 v23, v23, 1, 0x7000
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_53
	v_add_f32_e32 v49, 0, v54
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v49, v49, v62
	v_add_f32_e32 v49, v49, v70
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v49, v49, v74
	v_bfe_u32 v50, v49, 16, 1
	v_or_b32_e32 v51, 0x400000, v49
	v_cmp_u_f32_e32 vcc_lo, v49, v49
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v50, v50, v49, 0x7fff
	v_cndmask_b32_e32 v49, v50, v51, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v49, 16, v49
	buffer_store_b16 v49, v23, s[4:7], 0 offen offset:224
.LBB0_53:
	s_or_b32 exec_lo, exec_lo, s1
	v_cmp_eq_u32_e32 vcc_lo, 0, v48
	v_lshl_add_u32 v24, v24, 1, 0x8000
	s_and_b32 s0, vcc_lo, s0
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_55
	v_add_f32_e32 v46, 0, v46
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v46, v46, v47
	v_add_f32_e32 v46, v46, v55
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v46, v46, v63
	v_bfe_u32 v47, v46, 16, 1
	v_or_b32_e32 v48, 0x400000, v46
	v_cmp_u_f32_e64 s0, v46, v46
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v47, v47, v46, 0x7fff
	v_cndmask_b32_e64 v46, v47, v48, s0
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v46, 16, v46
	buffer_store_b16 v46, v24, s[4:7], 0 offen offset:256
.LBB0_55:
	s_or_b32 exec_lo, exec_lo, s1
	v_cmp_gt_i32_e64 s0, 0x3e8, v25
	s_and_saveexec_b32 s2, s0
	s_cbranch_execz .LBB0_57
	v_add_f32_e32 v25, 0, v30
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v25, v25, v34
	v_add_f32_e32 v25, v25, v38
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v25, v25, v42
	v_bfe_u32 v30, v25, 16, 1
	v_or_b32_e32 v34, 0x400000, v25
	v_cmp_u_f32_e64 s1, v25, v25
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v30, v30, v25, 0x7fff
	v_cndmask_b32_e64 v25, v30, v34, s1
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v25, 16, v25
	buffer_store_b16 v25, v0, s[4:7], 0 offen offset:64
.LBB0_57:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_saveexec_b32 s2, s0
	s_cbranch_execz .LBB0_59
	v_add_f32_e32 v0, 0, v31
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v0, v0, v35
	v_add_f32_e32 v0, v0, v39
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v0, v0, v43
	v_bfe_u32 v25, v0, 16, 1
	v_or_b32_e32 v30, 0x400000, v0
	v_cmp_u_f32_e64 s1, v0, v0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v25, v25, v0, 0x7fff
	v_cndmask_b32_e64 v0, v25, v30, s1
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v0, 16, v0
	buffer_store_b16 v0, v3, s[4:7], 0 offen offset:96
.LBB0_59:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_saveexec_b32 s2, s0
	s_cbranch_execz .LBB0_61
	v_add_f32_e32 v0, 0, v32
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v0, v0, v36
	v_add_f32_e32 v0, v0, v40
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v0, v0, v44
	v_bfe_u32 v3, v0, 16, 1
	v_or_b32_e32 v25, 0x400000, v0
	v_cmp_u_f32_e64 s1, v0, v0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v3, v3, v0, 0x7fff
	v_cndmask_b32_e64 v0, v3, v25, s1
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v0, 16, v0
	buffer_store_b16 v0, v4, s[4:7], 0 offen offset:128
.LBB0_61:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_saveexec_b32 s2, s0
	s_cbranch_execz .LBB0_63
	v_add_f32_e32 v0, 0, v33
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v0, v0, v37
	v_add_f32_e32 v0, v0, v41
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v0, v0, v45
	v_bfe_u32 v3, v0, 16, 1
	v_or_b32_e32 v4, 0x400000, v0
	v_cmp_u_f32_e64 s1, v0, v0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v3, v3, v0, 0x7fff
	v_cndmask_b32_e64 v0, v3, v4, s1
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v0, 16, v0
	buffer_store_b16 v0, v5, s[4:7], 0 offen offset:160
.LBB0_63:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_saveexec_b32 s2, s0
	s_cbranch_execz .LBB0_65
	v_add_f32_e32 v0, 0, v6
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v0, v0, v10
	v_add_f32_e32 v0, v0, v18
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v0, v0, v26
	v_bfe_u32 v3, v0, 16, 1
	v_or_b32_e32 v4, 0x400000, v0
	v_cmp_u_f32_e64 s1, v0, v0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v3, v3, v0, 0x7fff
	v_cndmask_b32_e64 v0, v3, v4, s1
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v0, 16, v0
	buffer_store_b16 v0, v15, s[4:7], 0 offen offset:192
.LBB0_65:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_saveexec_b32 s2, s0
	s_cbranch_execz .LBB0_67
	v_add_f32_e32 v0, 0, v7
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v0, v0, v11
	v_add_f32_e32 v0, v0, v19
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v0, v0, v27
	v_bfe_u32 v3, v0, 16, 1
	v_or_b32_e32 v4, 0x400000, v0
	v_cmp_u_f32_e64 s1, v0, v0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v3, v3, v0, 0x7fff
	v_cndmask_b32_e64 v0, v3, v4, s1
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v0, 16, v0
	buffer_store_b16 v0, v16, s[4:7], 0 offen offset:224
.LBB0_67:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_saveexec_b32 s2, s0
	s_cbranch_execz .LBB0_69
	v_add_f32_e32 v0, 0, v8
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v0, v0, v12
	v_add_f32_e32 v0, v0, v20
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v0, v0, v28
	v_bfe_u32 v3, v0, 16, 1
	v_or_b32_e32 v4, 0x400000, v0
	v_cmp_u_f32_e64 s1, v0, v0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v3, v3, v0, 0x7fff
	v_cndmask_b32_e64 v0, v3, v4, s1
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v0, 16, v0
	buffer_store_b16 v0, v17, s[4:7], 0 offen offset:256
.LBB0_69:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_saveexec_b32 s2, s0
	s_cbranch_execz .LBB0_71
	v_add_f32_e32 v0, 0, v9
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v0, v0, v13
	v_add_f32_e32 v0, v0, v21
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v0, v0, v29
	v_bfe_u32 v3, v0, 16, 1
	v_or_b32_e32 v4, 0x400000, v0
	v_cmp_u_f32_e64 s1, v0, v0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v3, v3, v0, 0x7fff
	v_cndmask_b32_e64 v0, v3, v4, s1
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v0, 16, v0
	buffer_store_b16 v0, v23, s[4:7], 0 offen offset:288
.LBB0_71:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s1, vcc_lo, s0
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s0, s1
	s_cbranch_execz .LBB0_73
	v_add_f32_e32 v0, 0, v1
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v0, v0, v2
	v_add_f32_e32 v0, v0, v14
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v0, v0, v22
	v_bfe_u32 v1, v0, 16, 1
	v_or_b32_e32 v2, 0x400000, v0
	v_cmp_u_f32_e32 vcc_lo, v0, v0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v1, v1, v0, 0x7fff
	v_cndmask_b32_e32 v0, v1, v2, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v0, 16, v0
	buffer_store_b16 v0, v24, s[4:7], 0 offen offset:320
.LBB0_73:
	s_or_b32 exec_lo, exec_lo, s0
	v_mov_b32_e32 v0, 0
	s_waitcnt_vscnt null, 0x0
	global_store_b32 v[91:92], v0, off
.LBB0_74:
	s_nop 0
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
	s_endpgm
.Lfunc_end0:
	.size	_matmul_bf16_0, .Lfunc_end0-_matmul_bf16_0
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _matmul_bf16_0
		.amdhsa_group_segment_fixed_size 6656
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 100
		.amdhsa_user_sgpr_count 2
		.amdhsa_user_sgpr_dispatch_ptr 0
		.amdhsa_user_sgpr_queue_ptr 0
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_dispatch_id 0
		.amdhsa_user_sgpr_private_segment_size 0
		.amdhsa_wavefront_size32 1
		.amdhsa_uses_dynamic_stack 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 0
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 135
		.amdhsa_next_free_sgpr 23
		.amdhsa_reserve_vcc 1
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_dx10_clamp 1
		.amdhsa_ieee_mode 1
		.amdhsa_fp16_overflow 0
		.amdhsa_workgroup_processor_mode 1
		.amdhsa_memory_ordered 1
		.amdhsa_forward_progress 1
		.amdhsa_shared_vgpr_count 0
		.amdhsa_inst_pref_size ((instprefsize(.Lfunc_end0-_matmul_bf16_0)<<4)&1008)>>4
		.amdhsa_exception_fp_ieee_invalid_op 0
		.amdhsa_exception_fp_denorm_src 0
		.amdhsa_exception_fp_ieee_div_zero 0
		.amdhsa_exception_fp_ieee_overflow 0
		.amdhsa_exception_fp_ieee_underflow 0
		.amdhsa_exception_fp_ieee_inexact 0
		.amdhsa_exception_int_div_zero 0
	.end_amdhsa_kernel
	.text

	.set .L_matmul_bf16_0.num_vgpr, 135
	.set .L_matmul_bf16_0.num_agpr, 0
	.set .L_matmul_bf16_0.numbered_sgpr, 23
	.set .L_matmul_bf16_0.num_named_barrier, 0
	.set .L_matmul_bf16_0.private_seg_size, 0
	.set .L_matmul_bf16_0.uses_vcc, 1
	.set .L_matmul_bf16_0.uses_flat_scratch, 0
	.set .L_matmul_bf16_0.has_dyn_sized_stack, 0
	.set .L_matmul_bf16_0.has_recursion, 0
	.set .L_matmul_bf16_0.has_indirect_call, 0
	.p2alignl 7, 3214868480
	.fill 96, 4, 3214868480
	.section	.AMDGPU.gpr_maximums,"",@progbits
	.set amdgpu.max_num_vgpr, 0
	.set amdgpu.max_num_agpr, 0
	.set amdgpu.max_num_sgpr, 0
	.set amdgpu.max_num_named_barrier, 0
	.text
	.section	".note.GNU-stack","",@progbits
	.amdgpu_metadata
---
amdhsa.kernels:
  - .args:
      - .address_space:  global
        .offset:         0
        .size:           8
        .value_kind:     global_buffer
      - .offset:         8
        .size:           16
        .value_kind:     by_value
      - .address_space:  global
        .offset:         24
        .size:           8
        .value_kind:     global_buffer
      - .offset:         32
        .size:           16
        .value_kind:     by_value
      - .address_space:  global
        .offset:         48
        .size:           8
        .value_kind:     global_buffer
      - .offset:         56
        .size:           16
        .value_kind:     by_value
      - .address_space:  global
        .offset:         72
        .size:           8
        .value_kind:     global_buffer
      - .offset:         80
        .size:           4
        .value_kind:     by_value
      - .address_space:  global
        .offset:         88
        .size:           8
        .value_kind:     global_buffer
      - .offset:         96
        .size:           4
        .value_kind:     by_value
    .group_segment_fixed_size: 6656
    .kernarg_segment_align: 8
    .kernarg_segment_size: 100
    .max_flat_workgroup_size: 64
    .name:           _matmul_bf16_0
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 64
      - 1
      - 1
    .sgpr_count:     25
    .sgpr_spill_count: 0
    .symbol:         _matmul_bf16_0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     135
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
