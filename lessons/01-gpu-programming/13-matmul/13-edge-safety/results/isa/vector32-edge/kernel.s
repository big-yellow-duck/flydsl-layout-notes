	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	_matmul_bf16_0
	.p2align	8
	.type	_matmul_bf16_0,@function
_matmul_bf16_0:
	s_clause 0x1
	s_load_b128 s[12:15], s[0:1], 0x0
	s_load_b32 s3, s[0:1], 0x10
	s_ashr_i32 s4, s2, 31
	v_lshlrev_b32_e32 v9, 3, v0
	s_lshr_b32 s4, s4, 30
	v_lshrrev_b32_e32 v27, 2, v0
	s_add_i32 s4, s2, s4
	s_delay_alu instid0(SALU_CYCLE_1)
	s_ashr_i32 s8, s4, 2
	s_and_b32 s4, s4, -4
	v_and_b32_e32 v25, 24, v9
	v_mul_u32_u24_e32 v26, 0x2008, v27
	v_cmp_eq_u32_e32 vcc_lo, 0, v27
	s_waitcnt lgkmcnt(0)
	s_add_i32 s5, s14, -1
	s_and_b32 s13, s13, 0xffff
	s_mul_i32 s3, s3, s5
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_i32 s3, s15, s3
	s_lshl_b32 s14, s3, 1
	s_cmp_lg_u32 s2, s4
	s_cselect_b32 s3, -1, 0
	s_cmp_lt_i32 s2, 0
	s_cselect_b32 s5, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(SALU_CYCLE_1)
	s_and_b32 s3, s5, s3
	s_subb_u32 s5, s8, 0
	s_sub_i32 s21, s2, s4
	s_mul_hi_i32 s3, s5, 0x78787879
	s_lshr_b32 s6, s3, 31
	s_ashr_i32 s3, s3, 3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_i32 s3, s3, s6
	s_mul_i32 s6, s3, 17
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(SALU_CYCLE_1)
	s_cmp_lg_u32 s5, s6
	s_cselect_b32 s4, -1, 0
	s_cmp_lt_i32 s5, 0
	s_cselect_b32 s7, -1, 0
	s_and_b32 s4, s7, s4
	s_subb_u32 s3, s3, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_sub_i32 s4, 1, s3
	s_min_i32 s7, s4, 1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_abs_i32 s10, s7
	s_cvt_f32_u32 s4, s10
	s_delay_alu instid0(SALU_CYCLE_3) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_rcp_f32_e32 v1, s4
	v_readfirstlane_b32 s4, v1
	s_mul_f32 s4, s4, 0x4f7ffffe
	s_delay_alu instid0(SALU_CYCLE_3) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)
	s_cvt_u32_f32 s9, s4
	s_sub_i32 s4, 0, s10
	s_mul_i32 s11, s4, s9
	s_sub_i32 s4, s5, s6
	s_mul_hi_u32 s5, s9, s11
	s_abs_i32 s6, s4
	s_add_i32 s9, s9, s5
	s_delay_alu instid0(SALU_CYCLE_1)
	s_mul_hi_u32 s5, s6, s9
	s_xor_b32 s9, s4, s7
	s_mul_i32 s11, s5, s10
	s_ashr_i32 s9, s9, 31
	s_sub_i32 s6, s6, s11
	s_add_i32 s11, s5, 1
	s_sub_i32 s15, s6, s10
	s_cmp_ge_u32 s6, s10
	s_cselect_b32 s5, s11, s5
	s_cselect_b32 s6, s15, s6
	s_add_i32 s11, s5, 1
	s_cmp_ge_u32 s6, s10
	s_mul_i32 s10, s21, 0x820
	s_cselect_b32 s5, s11, s5
	v_add3_u32 v1, v25, v26, s10
	s_xor_b32 s6, s5, s9
	s_mov_b32 s11, -1
	s_sub_i32 s5, s6, s9
	s_mov_b32 s15, 0x31027000
	s_mul_i32 s7, s5, s7
	v_lshlrev_b32_e32 v10, 1, v1
	s_sub_i32 s23, s4, s7
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_i32 s23, s23, s3
	s_cmp_lt_i32 s23, 0
	s_cselect_b32 s10, -1, 0
	s_cmp_gt_i32 s23, -1
	s_cbranch_scc0 .LBB0_10
	buffer_load_b128 v[5:8], v10, s[12:15], 0 offen
	v_dual_mov_b32 v2, 0 :: v_dual_add_nc_u32 v11, 0x40000, v10
	v_mov_b32_e32 v1, 0
	s_and_saveexec_b32 s11, vcc_lo
	s_cbranch_execz .LBB0_3
	buffer_load_b32 v1, v11, s[12:15], 0 offen offset:256
.LBB0_3:
	s_or_b32 exec_lo, exec_lo, s11
	s_and_saveexec_b32 s11, vcc_lo
	s_cbranch_execz .LBB0_5
	buffer_load_b32 v2, v11, s[12:15], 0 offen offset:260
.LBB0_5:
	s_or_b32 exec_lo, exec_lo, s11
	v_dual_mov_b32 v4, 0 :: v_dual_mov_b32 v3, 0
	s_and_saveexec_b32 s11, vcc_lo
	s_cbranch_execz .LBB0_7
	buffer_load_b32 v3, v11, s[12:15], 0 offen offset:264
.LBB0_7:
	s_or_b32 exec_lo, exec_lo, s11
	s_and_saveexec_b32 s11, vcc_lo
	s_cbranch_execz .LBB0_9
	buffer_load_b32 v4, v11, s[12:15], 0 offen offset:268
.LBB0_9:
	s_or_b32 exec_lo, exec_lo, s11
	s_mov_b32 s11, 0
.LBB0_10:
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 vcc_lo, exec_lo, s11
	s_cbranch_vccz .LBB0_12
	s_waitcnt vmcnt(0)
	v_add_nc_u32_e32 v1, 0x40000, v10
	s_clause 0x1
	buffer_load_b128 v[5:8], v10, s[12:15], 0 offen
	buffer_load_b128 v[1:4], v1, s[12:15], 0 offen offset:256
.LBB0_12:
	s_clause 0x1
	s_load_b128 s[16:19], s[0:1], 0x18
	s_load_b32 s11, s[0:1], 0x28
	v_lshrrev_b32_e32 v28, 3, v0
	v_and_b32_e32 v30, 56, v9
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_4) | instid1(SALU_CYCLE_1)
	v_mad_u32_u24 v9, 0x408, v28, v30
	s_waitcnt lgkmcnt(0)
	s_add_i32 s18, s18, -1
	s_and_b32 s17, s17, 0xffff
	s_mul_i32 s11, s11, s18
	s_add_i32 s11, s19, s11
	s_mov_b32 s19, 0x31027000
	s_lshl_b32 s18, s11, 1
	s_cmp_lg_u32 s4, s7
	s_cselect_b32 s7, -1, 0
	s_cmp_lt_i32 s4, 0
	s_cselect_b32 s4, -1, 0
	s_cmp_gt_i32 s3, 1
	s_cselect_b32 s3, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s3, s4, s3
	s_and_b32 s3, s3, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 s4, s3, exec_lo
	s_cselect_b32 s24, -1, 0
	s_cmp_lg_u32 s3, 0
	s_mul_i32 s4, s21, 0x20c100
	s_subb_u32 s22, s5, 0
	s_mov_b32 s3, -1
	s_lshl_b32 s11, s22, 6
	s_cmp_lt_i32 s22, 16
	v_or_b32_e32 v29, s11, v30
	v_add3_u32 v35, s4, s11, v9
	s_cselect_b32 s20, -1, 0
	s_cmp_gt_i32 s22, 15
	s_delay_alu instid0(VALU_DEP_2)
	v_or_b32_e32 v34, 2, v29
	s_cbranch_scc0 .LBB0_46
	v_or_b32_e32 v31, 2, v29
	v_dual_mov_b32 v10, 0 :: v_dual_mov_b32 v9, 0
	s_delay_alu instid0(VALU_DEP_2)
	v_cmp_gt_i32_e32 vcc_lo, 0x409, v31
	s_and_saveexec_b32 s3, vcc_lo
	s_cbranch_execz .LBB0_15
	v_lshlrev_b32_e32 v9, 1, v35
	buffer_load_b32 v9, v9, s[16:19], 0 offen slc
.LBB0_15:
	s_or_b32 exec_lo, exec_lo, s3
	v_or_b32_e32 v33, 4, v29
	s_delay_alu instid0(VALU_DEP_1)
	v_cmp_gt_i32_e64 s3, 0x409, v33
	s_and_saveexec_b32 s4, s3
	s_cbranch_execz .LBB0_17
	v_lshlrev_b32_e32 v10, 1, v35
	buffer_load_b32 v10, v10, s[16:19], 0 offen offset:4 slc
.LBB0_17:
	s_or_b32 exec_lo, exec_lo, s4
	v_or_b32_e32 v32, 6, v29
	v_dual_mov_b32 v12, 0 :: v_dual_mov_b32 v11, 0
	s_delay_alu instid0(VALU_DEP_2)
	v_cmp_gt_i32_e64 s4, 0x409, v32
	s_and_saveexec_b32 s5, s4
	s_cbranch_execz .LBB0_19
	v_lshlrev_b32_e32 v11, 1, v35
	buffer_load_b32 v11, v11, s[16:19], 0 offen offset:8 slc
.LBB0_19:
	s_or_b32 exec_lo, exec_lo, s5
	v_cmp_gt_i32_e64 s5, 0x401, v29
	s_and_saveexec_b32 s7, s5
	s_cbranch_execz .LBB0_21
	v_lshlrev_b32_e32 v12, 1, v35
	buffer_load_b32 v12, v12, s[16:19], 0 offen offset:12 slc
.LBB0_21:
	s_or_b32 exec_lo, exec_lo, s7
	v_dual_mov_b32 v14, 0 :: v_dual_mov_b32 v13, 0
	v_lshl_add_u32 v17, v35, 1, 0x4000
	s_and_saveexec_b32 s7, vcc_lo
	s_cbranch_execz .LBB0_23
	buffer_load_b32 v13, v17, s[16:19], 0 offen offset:128 slc
.LBB0_23:
	s_or_b32 exec_lo, exec_lo, s7
	s_and_saveexec_b32 s7, s3
	s_cbranch_execz .LBB0_25
	buffer_load_b32 v14, v17, s[16:19], 0 offen offset:132 slc
.LBB0_25:
	s_or_b32 exec_lo, exec_lo, s7
	v_dual_mov_b32 v16, 0 :: v_dual_mov_b32 v15, 0
	s_and_saveexec_b32 s7, s4
	s_cbranch_execz .LBB0_27
	buffer_load_b32 v15, v17, s[16:19], 0 offen offset:136 slc
.LBB0_27:
	s_or_b32 exec_lo, exec_lo, s7
	s_and_saveexec_b32 s7, s5
	s_cbranch_execz .LBB0_29
	buffer_load_b32 v16, v17, s[16:19], 0 offen offset:140 slc
.LBB0_29:
	s_or_b32 exec_lo, exec_lo, s7
	v_dual_mov_b32 v18, 0 :: v_dual_mov_b32 v17, 0
	v_lshl_add_u32 v21, v35, 1, 0x8000
	s_and_saveexec_b32 s7, vcc_lo
	s_cbranch_execz .LBB0_31
	buffer_load_b32 v17, v21, s[16:19], 0 offen offset:256 slc
.LBB0_31:
	s_or_b32 exec_lo, exec_lo, s7
	s_and_saveexec_b32 s7, s3
	s_cbranch_execz .LBB0_33
	buffer_load_b32 v18, v21, s[16:19], 0 offen offset:260 slc
.LBB0_33:
	s_or_b32 exec_lo, exec_lo, s7
	v_dual_mov_b32 v20, 0 :: v_dual_mov_b32 v19, 0
	s_and_saveexec_b32 s7, s4
	s_cbranch_execz .LBB0_35
	buffer_load_b32 v19, v21, s[16:19], 0 offen offset:264 slc
.LBB0_35:
	s_or_b32 exec_lo, exec_lo, s7
	s_and_saveexec_b32 s7, s5
	s_cbranch_execz .LBB0_37
	buffer_load_b32 v20, v21, s[16:19], 0 offen offset:268 slc
.LBB0_37:
	s_or_b32 exec_lo, exec_lo, s7
	v_dual_mov_b32 v22, 0 :: v_dual_mov_b32 v21, 0
	v_lshl_add_u32 v36, v35, 1, 0xc000
	s_and_saveexec_b32 s7, vcc_lo
	s_cbranch_execz .LBB0_39
	buffer_load_b32 v21, v36, s[16:19], 0 offen offset:384 slc
.LBB0_39:
	s_or_b32 exec_lo, exec_lo, s7
	s_and_saveexec_b32 s7, s3
	s_cbranch_execz .LBB0_41
	buffer_load_b32 v22, v36, s[16:19], 0 offen offset:388 slc
.LBB0_41:
	s_or_b32 exec_lo, exec_lo, s7
	v_dual_mov_b32 v24, 0 :: v_dual_mov_b32 v23, 0
	s_and_saveexec_b32 s3, s4
	s_cbranch_execz .LBB0_43
	buffer_load_b32 v23, v36, s[16:19], 0 offen offset:392 slc
.LBB0_43:
	s_or_b32 exec_lo, exec_lo, s3
	s_and_saveexec_b32 s3, s5
	s_cbranch_execz .LBB0_45
	buffer_load_b32 v24, v36, s[16:19], 0 offen offset:396 slc
.LBB0_45:
	s_or_b32 exec_lo, exec_lo, s3
	s_mov_b32 s3, 0
	s_branch .LBB0_47
.LBB0_46:
.LBB0_47:
	v_mul_u32_u24_e32 v36, 0x408, v28
	s_and_b32 vcc_lo, exec_lo, s3
	s_cbranch_vccz .LBB0_49
	s_waitcnt vmcnt(0)
	v_lshlrev_b32_e32 v9, 1, v35
	v_or_b32_e32 v33, 4, v29
	v_or_b32_e32 v32, 6, v29
	v_mov_b32_e32 v31, v34
	s_delay_alu instid0(VALU_DEP_4)
	v_add_nc_u32_e32 v13, 0x4000, v9
	v_add_nc_u32_e32 v17, 0x8000, v9
	v_add_nc_u32_e32 v21, 0xc000, v9
	s_clause 0x3
	buffer_load_b128 v[9:12], v9, s[16:19], 0 offen slc
	buffer_load_b128 v[13:16], v13, s[16:19], 0 offen offset:128 slc
	buffer_load_b128 v[17:20], v17, s[16:19], 0 offen offset:256 slc
	buffer_load_b128 v[21:24], v21, s[16:19], 0 offen offset:384 slc
.LBB0_49:
	v_lshl_or_b32 v34, v25, 1, 0x1000
	v_lshlrev_b32_e32 v58, 1, v30
	v_lshlrev_b32_e32 v59, 7, v28
	v_and_b32_e32 v67, 15, v0
	s_add_i32 s6, s6, s24
	v_mad_u32_u24 v30, 0x50, v27, v34
	s_mul_i32 s24, s2, 0x1040
	v_or_b32_e32 v37, v58, v59
	s_mul_i32 s25, s8, 0x4100
	s_mul_i32 s5, s2, 0x418200
	s_waitcnt vmcnt(0)
	ds_store_b128 v30, v[5:8]
	ds_store_b128 v30, v[1:4] offset:1280
	ds_store_b128 v37, v[9:12]
	ds_store_b128 v37, v[13:16] offset:1024
	v_mul_u32_u24_e32 v1, 0x50, v67
	s_lshl_b32 s6, s6, 7
	v_lshrrev_b32_e32 v38, 1, v0
	s_add_i32 s5, s5, s6
	s_lshl_b32 s9, s9, 7
	v_or_b32_e32 v57, 0x1000, v1
	v_and_b32_e32 v1, 3, v0
	v_mul_u32_u24_e32 v35, 0x50, v27
	ds_store_b128 v37, v[17:20] offset:2048
	ds_store_b128 v37, v[21:24] offset:3072
	v_cmp_eq_u32_e64 s7, 0, v27
	v_cmp_gt_i32_e64 s3, 0x409, v31
	v_lshl_or_b32 v1, v1, 4, s24
	s_mul_i32 s24, s8, 0x2080
	v_cmp_gt_i32_e64 s4, 0x409, v33
	v_cmp_gt_i32_e64 s6, 0x401, v29
	v_subrev_nc_u32_e32 v62, s24, v28
	v_lshl_add_u32 v1, v26, 1, v1
	v_subrev_nc_u32_e32 v63, s24, v25
	s_mov_b32 s24, 0
	s_mul_i32 s26, s8, 0xffffdf80
	s_waitcnt lgkmcnt(0)
	v_subrev_nc_u32_e32 v3, s25, v1
	v_dual_mov_b32 v1, 0 :: v_dual_and_b32 v2, 7, v0
	v_and_b32_e32 v68, 16, v38
	v_add_nc_u32_e32 v66, v34, v35
	s_delay_alu instid0(VALU_DEP_3)
	v_dual_mov_b32 v9, v1 :: v_dual_add_nc_u32 v64, 0x4018c, v3
	v_mov_b32_e32 v7, v1
	v_lshl_or_b32 v2, v2, 4, s5
	v_mov_b32_e32 v4, v1
	v_dual_mov_b32 v5, v1 :: v_dual_lshlrev_b32 v60, 1, v67
	v_cmp_gt_i32_e64 s5, 0x409, v32
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_4)
	v_lshl_add_u32 v2, v36, 1, v2
	v_mov_b32_e32 v3, v1
	v_lshl_or_b32 v61, v68, 1, v60
	v_mov_b32_e32 v6, v1
	v_mov_b32_e32 v8, v1
	v_subrev_nc_u32_e32 v2, s9, v2
	s_mul_i32 s9, s8, 0x1060800
	v_mov_b32_e32 v10, v1
	v_mov_b32_e32 v11, v1
	v_mov_b32_e32 v12, v1
	v_subrev_nc_u32_e32 v65, s9, v2
	v_mov_b32_e32 v2, v1
	v_mov_b32_e32 v13, v1
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
	s_mul_i32 s25, s2, 0x820
	s_barrier
	s_branch .LBB0_51
.LBB0_50:
	ds_load_b128 v[71:74], v57
	ds_load_b128 v[75:78], v57 offset:16
	ds_load_b128 v[79:82], v57 offset:32
	ds_load_b128 v[83:86], v57 offset:48
	ds_load_b128 v[87:90], v57 offset:1280
	ds_load_b128 v[91:94], v57 offset:1296
	ds_load_u16_d16 v95, v61
	ds_load_u16_d16_hi v95, v61 offset:128
	ds_load_u16_d16 v96, v61 offset:256
	ds_load_u16_d16_hi v96, v61 offset:384
	ds_load_u16_d16_hi v104, v61 offset:448
	ds_load_u16_d16 v104, v61 offset:320
	ds_load_u16_d16_hi v103, v61 offset:192
	ds_load_u16_d16 v103, v61 offset:64
	ds_load_u16_d16 v97, v61 offset:512
	ds_load_u16_d16_hi v97, v61 offset:640
	ds_load_u16_d16 v98, v61 offset:768
	ds_load_u16_d16_hi v98, v61 offset:896
	ds_load_u16_d16_hi v106, v61 offset:960
	ds_load_u16_d16 v106, v61 offset:832
	ds_load_u16_d16_hi v105, v61 offset:704
	ds_load_u16_d16 v105, v61 offset:576
	ds_load_u16_d16 v99, v61 offset:1024
	ds_load_u16_d16_hi v99, v61 offset:1152
	ds_load_u16_d16 v100, v61 offset:1280
	ds_load_u16_d16_hi v100, v61 offset:1408
	ds_load_u16_d16_hi v108, v61 offset:1472
	ds_load_u16_d16 v108, v61 offset:1344
	ds_load_u16_d16_hi v107, v61 offset:1216
	ds_load_u16_d16 v107, v61 offset:1088
	ds_load_u16_d16 v101, v61 offset:1536
	ds_load_u16_d16_hi v101, v61 offset:1664
	ds_load_u16_d16 v102, v61 offset:1792
	ds_load_u16_d16_hi v102, v61 offset:1920
	ds_load_u16_d16_hi v110, v61 offset:1984
	ds_load_u16_d16 v110, v61 offset:1856
	ds_load_u16_d16_hi v109, v61 offset:1728
	ds_load_u16_d16 v109, v61 offset:1600
	ds_load_u16_d16 v111, v61 offset:2048
	ds_load_u16_d16_hi v111, v61 offset:2176
	ds_load_u16_d16 v112, v61 offset:2304
	ds_load_u16_d16_hi v112, v61 offset:2432
	ds_load_u16_d16_hi v120, v61 offset:2496
	ds_load_u16_d16 v120, v61 offset:2368
	ds_load_u16_d16_hi v119, v61 offset:2240
	ds_load_u16_d16 v119, v61 offset:2112
	ds_load_u16_d16 v113, v61 offset:2560
	ds_load_u16_d16_hi v113, v61 offset:2688
	ds_load_u16_d16 v114, v61 offset:2816
	ds_load_u16_d16_hi v114, v61 offset:2944
	ds_load_u16_d16_hi v122, v61 offset:3008
	ds_load_u16_d16 v122, v61 offset:2880
	ds_load_u16_d16_hi v121, v61 offset:2752
	ds_load_u16_d16 v121, v61 offset:2624
	ds_load_u16_d16 v115, v61 offset:3072
	ds_load_u16_d16_hi v115, v61 offset:3200
	ds_load_u16_d16 v116, v61 offset:3328
	ds_load_u16_d16_hi v116, v61 offset:3456
	ds_load_u16_d16_hi v124, v61 offset:3520
	ds_load_u16_d16 v124, v61 offset:3392
	ds_load_u16_d16_hi v123, v61 offset:3264
	ds_load_u16_d16 v123, v61 offset:3136
	ds_load_u16_d16 v117, v61 offset:3584
	ds_load_u16_d16_hi v117, v61 offset:3712
	ds_load_u16_d16 v118, v61 offset:3840
	ds_load_u16_d16_hi v118, v61 offset:3968
	ds_load_u16_d16_hi v126, v61 offset:4032
	ds_load_u16_d16 v126, v61 offset:3904
	ds_load_u16_d16_hi v125, v61 offset:3776
	ds_load_u16_d16 v125, v61 offset:3648
	ds_load_b128 v[127:130], v57 offset:1312
	ds_load_b128 v[131:134], v57 offset:1328
	s_waitcnt lgkmcnt(38)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[71:78], v[95:102], v[1:8]
	s_waitcnt lgkmcnt(34)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[71:78], v[103:110], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[87:94], v[95:102], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[87:94], v[103:110], v[25:32]
	v_add_nc_u32_e32 v62, 64, v62
	v_add_nc_u32_e32 v63, 64, v63
	v_add_nc_u32_e32 v64, 0x80, v64
	s_add_i32 s24, s24, 0x20400
	s_add_i32 s26, s26, 64
	s_cmp_lg_u32 s24, 0x408000
	s_waitcnt lgkmcnt(6)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[79:86], v[111:118], v[1:8]
	s_waitcnt lgkmcnt(2)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[79:86], v[119:126], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[127:134], v[111:118], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[127:134], v[119:126], v[25:32]
	s_barrier
	s_waitcnt vmcnt(0)
	ds_store_b128 v66, v[33:36]
	ds_store_b128 v66, v[37:40] offset:1280
	ds_store_b128 v70, v[41:44]
	ds_store_b128 v70, v[45:48] offset:1024
	ds_store_b128 v70, v[49:52] offset:2048
	ds_store_b128 v70, v[53:56] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_cbranch_scc0 .LBB0_163
.LBB0_51:
	s_add_i32 s27, s25, s26
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_i32 s2, s27, 32
	s_cmpk_lt_i32 s2, 0x2008
	s_cselect_b32 s28, -1, 0
	s_cmpk_lt_i32 s2, 0x1fe9
	s_cselect_b32 s29, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s2, s10, s29
	s_and_b32 s2, s2, exec_lo
	s_cselect_b32 s2, 1, 0
	s_delay_alu instid0(SALU_CYCLE_1)
	s_cmp_lg_u32 s2, 1
	s_mov_b32 s2, -1
	s_cbranch_scc0 .LBB0_69
	v_add3_u32 v37, s25, v63, 32
	v_dual_mov_b32 v34, 0 :: v_dual_mov_b32 v33, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_cmp_gt_i32_e32 vcc_lo, 0x2007, v37
	s_and_b32 s8, s28, vcc_lo
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_54
	v_add_nc_u32_e32 v33, 0xfffbfeb4, v64
	buffer_load_b32 v33, v33, s[12:15], 0 offen
.LBB0_54:
	s_or_b32 exec_lo, exec_lo, s2
	v_cmp_gt_i32_e64 s9, 0x2005, v37
	s_and_b32 s8, s28, s9
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_56
	v_add_nc_u32_e32 v34, 0xfffbfeb8, v64
	buffer_load_b32 v34, v34, s[12:15], 0 offen
.LBB0_56:
	s_or_b32 exec_lo, exec_lo, s2
	v_cmp_gt_i32_e64 s2, 0x2003, v37
	v_dual_mov_b32 v36, 0 :: v_dual_mov_b32 v35, 0
	s_and_b32 s30, s28, s2
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s8, s30
	s_cbranch_execz .LBB0_58
	v_add_nc_u32_e32 v35, 0xfffbfebc, v64
	buffer_load_b32 v35, v35, s[12:15], 0 offen
.LBB0_58:
	s_or_b32 exec_lo, exec_lo, s8
	v_cmp_gt_i32_e64 s8, 0x2001, v37
	s_and_b32 s31, s28, s8
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s30, s31
	s_cbranch_execz .LBB0_60
	v_add_nc_u32_e32 v36, 0xfffbfec0, v64
	buffer_load_b32 v36, v36, s[12:15], 0 offen
.LBB0_60:
	s_or_b32 exec_lo, exec_lo, s30
	v_dual_mov_b32 v38, 0 :: v_dual_mov_b32 v37, 0
	s_and_b32 s30, s7, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s31, s28, s30
	s_and_saveexec_b32 s30, s31
	s_cbranch_execz .LBB0_62
	v_add_nc_u32_e32 v37, 0xffffffb4, v64
	buffer_load_b32 v37, v37, s[12:15], 0 offen
.LBB0_62:
	s_or_b32 exec_lo, exec_lo, s30
	s_and_b32 s9, s7, s9
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s30, s28, s9
	s_and_saveexec_b32 s9, s30
	s_cbranch_execz .LBB0_64
	v_add_nc_u32_e32 v38, 0xffffffb8, v64
	buffer_load_b32 v38, v38, s[12:15], 0 offen
.LBB0_64:
	s_or_b32 exec_lo, exec_lo, s9
	v_dual_mov_b32 v40, 0 :: v_dual_mov_b32 v39, 0
	s_and_b32 s2, s7, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s9, s28, s2
	s_and_saveexec_b32 s2, s9
	s_cbranch_execz .LBB0_66
	v_add_nc_u32_e32 v39, 0xffffffbc, v64
	buffer_load_b32 v39, v39, s[12:15], 0 offen
.LBB0_66:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s7, s8
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s28, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_68
	v_subrev_nc_u32_e32 v40, 64, v64
	buffer_load_b32 v40, v40, s[12:15], 0 offen
.LBB0_68:
	s_or_b32 exec_lo, exec_lo, s2
	s_mov_b32 s2, 0
.LBB0_69:
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 vcc_lo, exec_lo, s2
	s_cbranch_vccz .LBB0_71
	s_waitcnt vmcnt(0)
	v_add_nc_u32_e32 v33, 0xfffbfeb4, v64
	v_add_nc_u32_e32 v34, 0xfffbfeb8, v64
	v_add_nc_u32_e32 v35, 0xfffbfebc, v64
	v_add_nc_u32_e32 v36, 0xfffbfec0, v64
	v_add_nc_u32_e32 v37, 0xffffffb4, v64
	v_add_nc_u32_e32 v38, 0xffffffb8, v64
	v_add_nc_u32_e32 v39, 0xffffffbc, v64
	v_subrev_nc_u32_e32 v40, 64, v64
	s_clause 0x7
	buffer_load_b32 v33, v33, s[12:15], 0 offen
	buffer_load_b32 v34, v34, s[12:15], 0 offen
	buffer_load_b32 v35, v35, s[12:15], 0 offen
	buffer_load_b32 v36, v36, s[12:15], 0 offen
	buffer_load_b32 v37, v37, s[12:15], 0 offen
	buffer_load_b32 v38, v38, s[12:15], 0 offen
	buffer_load_b32 v39, v39, s[12:15], 0 offen
	buffer_load_b32 v40, v40, s[12:15], 0 offen
.LBB0_71:
	s_and_b32 s2, s20, s29
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_and_b32 s2, s2, exec_lo
	s_cselect_b32 s2, 1, 0
	s_cmp_lg_u32 s2, 1
	s_mov_b32 s2, -1
	s_cbranch_scc0 .LBB0_105
	v_add3_u32 v53, s25, v62, 32
	v_dual_mov_b32 v42, 0 :: v_dual_mov_b32 v41, 0
	v_add3_u32 v45, v65, s24, 0x10000
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_cmp_gt_i32_e32 vcc_lo, 0x2008, v53
	s_and_b32 s2, s3, vcc_lo
	s_and_b32 s8, s28, s2
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_74
	buffer_load_b32 v41, v45, s[16:19], 0 offen offset:512 slc
.LBB0_74:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s4, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s28, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_76
	buffer_load_b32 v42, v45, s[16:19], 0 offen offset:516 slc
.LBB0_76:
	s_or_b32 exec_lo, exec_lo, s2
	v_dual_mov_b32 v44, 0 :: v_dual_mov_b32 v43, 0
	s_and_b32 s2, s5, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s28, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_78
	buffer_load_b32 v43, v45, s[16:19], 0 offen offset:520 slc
.LBB0_78:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s6, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s28, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_80
	buffer_load_b32 v44, v45, s[16:19], 0 offen offset:524 slc
.LBB0_80:
	s_or_b32 exec_lo, exec_lo, s2
	v_cmp_gt_i32_e32 vcc_lo, 0x2000, v53
	v_dual_mov_b32 v46, 0 :: v_dual_mov_b32 v45, 0
	v_add3_u32 v49, v65, s24, 0x14000
	s_and_b32 s2, s3, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s28, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_82
	buffer_load_b32 v45, v49, s[16:19], 0 offen offset:640 slc
.LBB0_82:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s4, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s28, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_84
	buffer_load_b32 v46, v49, s[16:19], 0 offen offset:644 slc
.LBB0_84:
	s_or_b32 exec_lo, exec_lo, s2
	v_dual_mov_b32 v48, 0 :: v_dual_mov_b32 v47, 0
	s_and_b32 s2, s5, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s28, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_86
	buffer_load_b32 v47, v49, s[16:19], 0 offen offset:648 slc
.LBB0_86:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s6, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s28, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_88
	buffer_load_b32 v48, v49, s[16:19], 0 offen offset:652 slc
.LBB0_88:
	s_or_b32 exec_lo, exec_lo, s2
	v_cmp_gt_i32_e32 vcc_lo, 0x1ff8, v53
	v_dual_mov_b32 v50, 0 :: v_dual_mov_b32 v49, 0
	v_add3_u32 v54, v65, s24, 0x18000
	s_and_b32 s2, s3, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s28, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_90
	buffer_load_b32 v49, v54, s[16:19], 0 offen offset:768 slc
.LBB0_90:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s4, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s28, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_92
	buffer_load_b32 v50, v54, s[16:19], 0 offen offset:772 slc
.LBB0_92:
	s_or_b32 exec_lo, exec_lo, s2
	v_dual_mov_b32 v52, 0 :: v_dual_mov_b32 v51, 0
	s_and_b32 s2, s5, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s28, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_94
	buffer_load_b32 v51, v54, s[16:19], 0 offen offset:776 slc
.LBB0_94:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s6, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s28, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_96
	buffer_load_b32 v52, v54, s[16:19], 0 offen offset:780 slc
.LBB0_96:
	s_or_b32 exec_lo, exec_lo, s2
	v_cmp_gt_i32_e32 vcc_lo, 0x1ff0, v53
	v_dual_mov_b32 v54, 0 :: v_dual_mov_b32 v53, 0
	v_add3_u32 v69, v65, s24, 0x1c000
	s_and_b32 s2, s3, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s28, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_98
	buffer_load_b32 v53, v69, s[16:19], 0 offen offset:896 slc
.LBB0_98:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s4, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s28, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_100
	buffer_load_b32 v54, v69, s[16:19], 0 offen offset:900 slc
.LBB0_100:
	s_or_b32 exec_lo, exec_lo, s2
	v_dual_mov_b32 v56, 0 :: v_dual_mov_b32 v55, 0
	s_and_b32 s2, s5, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s28, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_102
	buffer_load_b32 v55, v69, s[16:19], 0 offen offset:904 slc
.LBB0_102:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s6, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s28, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_104
	buffer_load_b32 v56, v69, s[16:19], 0 offen offset:908 slc
.LBB0_104:
	s_or_b32 exec_lo, exec_lo, s2
	s_mov_b32 s2, 0
.LBB0_105:
	v_add_nc_u32_e32 v69, s24, v65
	s_and_b32 vcc_lo, exec_lo, s2
	s_cbranch_vccz .LBB0_107
	s_waitcnt vmcnt(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_add_nc_u32_e32 v41, 0x10000, v69
	v_add_nc_u32_e32 v45, 0x14000, v69
	v_add_nc_u32_e32 v49, 0x18000, v69
	v_add_nc_u32_e32 v53, 0x1c000, v69
	s_clause 0x3
	buffer_load_b128 v[41:44], v41, s[16:19], 0 offen offset:512 slc
	buffer_load_b128 v[45:48], v45, s[16:19], 0 offen offset:640 slc
	buffer_load_b128 v[49:52], v49, s[16:19], 0 offen offset:768 slc
	buffer_load_b128 v[53:56], v53, s[16:19], 0 offen offset:896 slc
.LBB0_107:
	ds_load_b128 v[70:73], v57
	ds_load_b128 v[74:77], v57 offset:16
	ds_load_b128 v[78:81], v57 offset:32
	ds_load_b128 v[82:85], v57 offset:48
	ds_load_b128 v[86:89], v57 offset:1280
	ds_load_b128 v[90:93], v57 offset:1296
	ds_load_u16_d16 v94, v61
	ds_load_u16_d16_hi v94, v61 offset:128
	ds_load_u16_d16 v95, v61 offset:256
	ds_load_u16_d16_hi v95, v61 offset:384
	ds_load_u16_d16_hi v103, v61 offset:448
	ds_load_u16_d16 v103, v61 offset:320
	ds_load_u16_d16_hi v102, v61 offset:192
	ds_load_u16_d16 v102, v61 offset:64
	ds_load_u16_d16 v96, v61 offset:512
	ds_load_u16_d16_hi v96, v61 offset:640
	ds_load_u16_d16 v97, v61 offset:768
	ds_load_u16_d16_hi v97, v61 offset:896
	ds_load_u16_d16_hi v105, v61 offset:960
	ds_load_u16_d16 v105, v61 offset:832
	ds_load_u16_d16_hi v104, v61 offset:704
	ds_load_u16_d16 v104, v61 offset:576
	ds_load_u16_d16 v98, v61 offset:1024
	ds_load_u16_d16_hi v98, v61 offset:1152
	ds_load_u16_d16 v99, v61 offset:1280
	ds_load_u16_d16_hi v99, v61 offset:1408
	ds_load_u16_d16_hi v107, v61 offset:1472
	ds_load_u16_d16 v107, v61 offset:1344
	ds_load_u16_d16_hi v106, v61 offset:1216
	ds_load_u16_d16 v106, v61 offset:1088
	ds_load_u16_d16 v100, v61 offset:1536
	ds_load_u16_d16_hi v100, v61 offset:1664
	ds_load_u16_d16 v101, v61 offset:1792
	ds_load_u16_d16_hi v101, v61 offset:1920
	ds_load_u16_d16_hi v109, v61 offset:1984
	ds_load_u16_d16 v109, v61 offset:1856
	ds_load_u16_d16_hi v108, v61 offset:1728
	ds_load_u16_d16 v108, v61 offset:1600
	ds_load_u16_d16 v110, v61 offset:2048
	ds_load_u16_d16_hi v110, v61 offset:2176
	ds_load_u16_d16 v111, v61 offset:2304
	ds_load_u16_d16_hi v111, v61 offset:2432
	ds_load_u16_d16_hi v119, v61 offset:2496
	ds_load_u16_d16 v119, v61 offset:2368
	ds_load_u16_d16_hi v118, v61 offset:2240
	ds_load_u16_d16 v118, v61 offset:2112
	ds_load_u16_d16 v112, v61 offset:2560
	ds_load_u16_d16_hi v112, v61 offset:2688
	ds_load_u16_d16 v113, v61 offset:2816
	ds_load_u16_d16_hi v113, v61 offset:2944
	ds_load_u16_d16_hi v121, v61 offset:3008
	ds_load_u16_d16 v121, v61 offset:2880
	ds_load_u16_d16_hi v120, v61 offset:2752
	ds_load_u16_d16 v120, v61 offset:2624
	ds_load_u16_d16 v114, v61 offset:3072
	ds_load_u16_d16_hi v114, v61 offset:3200
	ds_load_u16_d16 v115, v61 offset:3328
	ds_load_u16_d16_hi v115, v61 offset:3456
	ds_load_u16_d16_hi v123, v61 offset:3520
	ds_load_u16_d16 v123, v61 offset:3392
	ds_load_u16_d16_hi v122, v61 offset:3264
	ds_load_u16_d16 v122, v61 offset:3136
	ds_load_u16_d16 v116, v61 offset:3584
	ds_load_u16_d16_hi v116, v61 offset:3712
	ds_load_u16_d16 v117, v61 offset:3840
	ds_load_u16_d16_hi v117, v61 offset:3968
	ds_load_u16_d16_hi v125, v61 offset:4032
	ds_load_u16_d16 v125, v61 offset:3904
	ds_load_u16_d16_hi v124, v61 offset:3776
	ds_load_u16_d16 v124, v61 offset:3648
	ds_load_b128 v[126:129], v57 offset:1312
	ds_load_b128 v[130:133], v57 offset:1328
	s_add_i32 s2, s27, 64
	s_waitcnt lgkmcnt(38)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[70:77], v[94:101], v[1:8]
	s_cmpk_lt_i32 s2, 0x2008
	s_waitcnt lgkmcnt(34)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[70:77], v[102:109], v[9:16]
	s_cselect_b32 s27, -1, 0
	s_cmpk_lt_i32 s2, 0x1fe9
	v_wmma_f32_16x16x16_bf16 v[17:24], v[86:93], v[94:101], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[86:93], v[102:109], v[25:32]
	s_cselect_b32 s28, -1, 0
	v_add_nc_u32_e32 v70, v58, v59
	s_and_b32 s2, s10, s28
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(SALU_CYCLE_1)
	s_and_b32 s2, s2, exec_lo
	s_waitcnt lgkmcnt(6)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[78:85], v[110:117], v[1:8]
	s_cselect_b32 s2, 1, 0
	s_cmp_lg_u32 s2, 1
	s_waitcnt lgkmcnt(2)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[78:85], v[118:125], v[9:16]
	s_mov_b32 s2, -1
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[126:133], v[110:117], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[126:133], v[118:125], v[25:32]
	s_barrier
	s_waitcnt vmcnt(0)
	ds_store_b128 v66, v[33:36]
	ds_store_b128 v66, v[37:40] offset:1280
	ds_store_b128 v70, v[41:44]
	ds_store_b128 v70, v[45:48] offset:1024
	ds_store_b128 v70, v[49:52] offset:2048
	ds_store_b128 v70, v[53:56] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_cbranch_scc0 .LBB0_125
	v_add3_u32 v37, s25, v63, 64
	v_dual_mov_b32 v34, 0 :: v_dual_mov_b32 v33, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_cmp_gt_i32_e32 vcc_lo, 0x2007, v37
	s_and_b32 s8, s27, vcc_lo
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_110
	v_add_nc_u32_e32 v33, 0xfffbfef4, v64
	buffer_load_b32 v33, v33, s[12:15], 0 offen
.LBB0_110:
	s_or_b32 exec_lo, exec_lo, s2
	v_cmp_gt_i32_e64 s9, 0x2005, v37
	s_and_b32 s8, s27, s9
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_112
	v_add_nc_u32_e32 v34, 0xfffbfef8, v64
	buffer_load_b32 v34, v34, s[12:15], 0 offen
.LBB0_112:
	s_or_b32 exec_lo, exec_lo, s2
	v_cmp_gt_i32_e64 s2, 0x2003, v37
	v_dual_mov_b32 v36, 0 :: v_dual_mov_b32 v35, 0
	s_and_b32 s29, s27, s2
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s8, s29
	s_cbranch_execz .LBB0_114
	v_add_nc_u32_e32 v35, 0xfffbfefc, v64
	buffer_load_b32 v35, v35, s[12:15], 0 offen
.LBB0_114:
	s_or_b32 exec_lo, exec_lo, s8
	v_cmp_gt_i32_e64 s8, 0x2001, v37
	s_and_b32 s30, s27, s8
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s29, s30
	s_cbranch_execz .LBB0_116
	v_add_nc_u32_e32 v36, 0xfffbff00, v64
	buffer_load_b32 v36, v36, s[12:15], 0 offen
.LBB0_116:
	s_or_b32 exec_lo, exec_lo, s29
	v_dual_mov_b32 v38, 0 :: v_dual_mov_b32 v37, 0
	s_and_b32 s29, s7, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s30, s27, s29
	s_and_saveexec_b32 s29, s30
	s_cbranch_execz .LBB0_118
	v_add_nc_u32_e32 v37, -12, v64
	buffer_load_b32 v37, v37, s[12:15], 0 offen
.LBB0_118:
	s_or_b32 exec_lo, exec_lo, s29
	s_and_b32 s9, s7, s9
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s29, s27, s9
	s_and_saveexec_b32 s9, s29
	s_cbranch_execz .LBB0_120
	v_add_nc_u32_e32 v38, -8, v64
	buffer_load_b32 v38, v38, s[12:15], 0 offen
.LBB0_120:
	s_or_b32 exec_lo, exec_lo, s9
	v_dual_mov_b32 v40, 0 :: v_dual_mov_b32 v39, 0
	s_and_b32 s2, s7, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s9, s27, s2
	s_and_saveexec_b32 s2, s9
	s_cbranch_execz .LBB0_122
	v_add_nc_u32_e32 v39, -4, v64
	buffer_load_b32 v39, v39, s[12:15], 0 offen
.LBB0_122:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s7, s8
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s27, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_124
	buffer_load_b32 v40, v64, s[12:15], 0 offen
.LBB0_124:
	s_or_b32 exec_lo, exec_lo, s2
	s_mov_b32 s2, 0
.LBB0_125:
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 vcc_lo, exec_lo, s2
	s_cbranch_vccz .LBB0_127
	s_waitcnt vmcnt(0)
	v_add_nc_u32_e32 v33, 0xfffbfef4, v64
	v_add_nc_u32_e32 v34, 0xfffbfef8, v64
	v_add_nc_u32_e32 v35, 0xfffbfefc, v64
	v_add_nc_u32_e32 v36, 0xfffbff00, v64
	v_add_nc_u32_e32 v37, -12, v64
	v_add_nc_u32_e32 v38, -8, v64
	v_add_nc_u32_e32 v39, -4, v64
	s_clause 0x7
	buffer_load_b32 v33, v33, s[12:15], 0 offen
	buffer_load_b32 v34, v34, s[12:15], 0 offen
	buffer_load_b32 v35, v35, s[12:15], 0 offen
	buffer_load_b32 v36, v36, s[12:15], 0 offen
	buffer_load_b32 v37, v37, s[12:15], 0 offen
	buffer_load_b32 v38, v38, s[12:15], 0 offen
	buffer_load_b32 v39, v39, s[12:15], 0 offen
	buffer_load_b32 v40, v64, s[12:15], 0 offen
.LBB0_127:
	s_and_b32 s2, s20, s28
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_and_b32 s2, s2, exec_lo
	s_cselect_b32 s2, 1, 0
	s_cmp_lg_u32 s2, 1
	s_mov_b32 s2, -1
	s_cbranch_scc0 .LBB0_161
	v_add3_u32 v53, s25, v62, 64
	v_dual_mov_b32 v42, 0 :: v_dual_mov_b32 v41, 0
	v_add3_u32 v45, v65, s24, 0x20000
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_cmp_gt_i32_e32 vcc_lo, 0x2008, v53
	s_and_b32 s2, s3, vcc_lo
	s_and_b32 s8, s27, s2
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_130
	buffer_load_b32 v41, v45, s[16:19], 0 offen offset:1024 slc
.LBB0_130:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s4, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s27, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_132
	buffer_load_b32 v42, v45, s[16:19], 0 offen offset:1028 slc
.LBB0_132:
	s_or_b32 exec_lo, exec_lo, s2
	v_dual_mov_b32 v44, 0 :: v_dual_mov_b32 v43, 0
	s_and_b32 s2, s5, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s27, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_134
	buffer_load_b32 v43, v45, s[16:19], 0 offen offset:1032 slc
.LBB0_134:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s6, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s27, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_136
	buffer_load_b32 v44, v45, s[16:19], 0 offen offset:1036 slc
.LBB0_136:
	s_or_b32 exec_lo, exec_lo, s2
	v_cmp_gt_i32_e32 vcc_lo, 0x2000, v53
	v_dual_mov_b32 v46, 0 :: v_dual_mov_b32 v45, 0
	v_add3_u32 v49, v65, s24, 0x24000
	s_and_b32 s2, s3, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s27, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_138
	buffer_load_b32 v45, v49, s[16:19], 0 offen offset:1152 slc
.LBB0_138:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s4, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s27, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_140
	buffer_load_b32 v46, v49, s[16:19], 0 offen offset:1156 slc
.LBB0_140:
	s_or_b32 exec_lo, exec_lo, s2
	v_dual_mov_b32 v48, 0 :: v_dual_mov_b32 v47, 0
	s_and_b32 s2, s5, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s27, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_142
	buffer_load_b32 v47, v49, s[16:19], 0 offen offset:1160 slc
.LBB0_142:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s6, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s27, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_144
	buffer_load_b32 v48, v49, s[16:19], 0 offen offset:1164 slc
.LBB0_144:
	s_or_b32 exec_lo, exec_lo, s2
	v_cmp_gt_i32_e32 vcc_lo, 0x1ff8, v53
	v_dual_mov_b32 v50, 0 :: v_dual_mov_b32 v49, 0
	v_add3_u32 v54, v65, s24, 0x28000
	s_and_b32 s2, s3, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s27, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_146
	buffer_load_b32 v49, v54, s[16:19], 0 offen offset:1280 slc
.LBB0_146:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s4, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s27, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_148
	buffer_load_b32 v50, v54, s[16:19], 0 offen offset:1284 slc
.LBB0_148:
	s_or_b32 exec_lo, exec_lo, s2
	v_dual_mov_b32 v52, 0 :: v_dual_mov_b32 v51, 0
	s_and_b32 s2, s5, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s27, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_150
	buffer_load_b32 v51, v54, s[16:19], 0 offen offset:1288 slc
.LBB0_150:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s6, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s27, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_152
	buffer_load_b32 v52, v54, s[16:19], 0 offen offset:1292 slc
.LBB0_152:
	s_or_b32 exec_lo, exec_lo, s2
	v_cmp_gt_i32_e32 vcc_lo, 0x1ff0, v53
	v_dual_mov_b32 v54, 0 :: v_dual_mov_b32 v53, 0
	v_add3_u32 v71, v65, s24, 0x2c000
	s_and_b32 s2, s3, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s27, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_154
	buffer_load_b32 v53, v71, s[16:19], 0 offen offset:1408 slc
.LBB0_154:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s4, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s27, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_156
	buffer_load_b32 v54, v71, s[16:19], 0 offen offset:1412 slc
.LBB0_156:
	s_or_b32 exec_lo, exec_lo, s2
	v_dual_mov_b32 v56, 0 :: v_dual_mov_b32 v55, 0
	s_and_b32 s2, s5, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s27, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_158
	buffer_load_b32 v55, v71, s[16:19], 0 offen offset:1416 slc
.LBB0_158:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s6, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s27, s2
	s_and_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_160
	buffer_load_b32 v56, v71, s[16:19], 0 offen offset:1420 slc
.LBB0_160:
	s_or_b32 exec_lo, exec_lo, s2
	s_mov_b32 s2, 0
.LBB0_161:
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 vcc_lo, exec_lo, s2
	s_cbranch_vccz .LBB0_50
	s_waitcnt vmcnt(0)
	v_add_nc_u32_e32 v41, 0x20000, v69
	v_add_nc_u32_e32 v45, 0x24000, v69
	v_add_nc_u32_e32 v49, 0x28000, v69
	v_add_nc_u32_e32 v53, 0x2c000, v69
	s_clause 0x3
	buffer_load_b128 v[41:44], v41, s[16:19], 0 offen offset:1024 slc
	buffer_load_b128 v[45:48], v45, s[16:19], 0 offen offset:1152 slc
	buffer_load_b128 v[49:52], v49, s[16:19], 0 offen offset:1280 slc
	buffer_load_b128 v[53:56], v53, s[16:19], 0 offen offset:1408 slc
	s_branch .LBB0_50
.LBB0_163:
	v_lshl_add_u32 v33, v68, 1, v60
	ds_load_b128 v[34:37], v57
	ds_load_b128 v[38:41], v57 offset:16
	ds_load_b128 v[42:45], v57 offset:32
	ds_load_b128 v[46:49], v57 offset:48
	ds_load_b128 v[58:61], v57 offset:1280
	ds_load_b128 v[62:65], v57 offset:1296
	ds_load_u16_d16 v69, v33
	ds_load_u16_d16_hi v69, v33 offset:128
	ds_load_u16_d16 v70, v33 offset:256
	ds_load_u16_d16_hi v70, v33 offset:384
	ds_load_u16_d16_hi v78, v33 offset:448
	ds_load_u16_d16 v78, v33 offset:320
	ds_load_u16_d16_hi v77, v33 offset:192
	ds_load_u16_d16 v77, v33 offset:64
	ds_load_u16_d16 v71, v33 offset:512
	ds_load_u16_d16_hi v71, v33 offset:640
	ds_load_u16_d16 v72, v33 offset:768
	ds_load_u16_d16_hi v72, v33 offset:896
	ds_load_u16_d16_hi v80, v33 offset:960
	ds_load_u16_d16 v80, v33 offset:832
	ds_load_u16_d16_hi v79, v33 offset:704
	ds_load_u16_d16 v79, v33 offset:576
	ds_load_u16_d16 v73, v33 offset:1024
	ds_load_u16_d16_hi v73, v33 offset:1152
	ds_load_u16_d16 v74, v33 offset:1280
	ds_load_u16_d16_hi v74, v33 offset:1408
	ds_load_u16_d16_hi v82, v33 offset:1472
	ds_load_u16_d16 v82, v33 offset:1344
	ds_load_u16_d16_hi v81, v33 offset:1216
	ds_load_u16_d16 v81, v33 offset:1088
	ds_load_u16_d16 v75, v33 offset:1536
	ds_load_u16_d16_hi v75, v33 offset:1664
	ds_load_u16_d16 v76, v33 offset:1792
	ds_load_u16_d16_hi v76, v33 offset:1920
	ds_load_u16_d16_hi v84, v33 offset:1984
	ds_load_u16_d16 v84, v33 offset:1856
	ds_load_u16_d16_hi v83, v33 offset:1728
	ds_load_u16_d16 v83, v33 offset:1600
	ds_load_u16_d16 v85, v33 offset:2048
	ds_load_u16_d16_hi v85, v33 offset:2176
	ds_load_u16_d16 v86, v33 offset:2304
	ds_load_u16_d16_hi v86, v33 offset:2432
	ds_load_u16_d16_hi v94, v33 offset:2496
	ds_load_u16_d16 v94, v33 offset:2368
	ds_load_u16_d16_hi v93, v33 offset:2240
	ds_load_u16_d16 v93, v33 offset:2112
	ds_load_u16_d16 v87, v33 offset:2560
	ds_load_u16_d16_hi v87, v33 offset:2688
	ds_load_u16_d16 v88, v33 offset:2816
	ds_load_u16_d16_hi v88, v33 offset:2944
	ds_load_u16_d16_hi v96, v33 offset:3008
	ds_load_u16_d16 v96, v33 offset:2880
	ds_load_u16_d16_hi v95, v33 offset:2752
	ds_load_u16_d16 v95, v33 offset:2624
	ds_load_u16_d16 v89, v33 offset:3072
	ds_load_u16_d16_hi v89, v33 offset:3200
	ds_load_u16_d16 v90, v33 offset:3328
	ds_load_u16_d16_hi v90, v33 offset:3456
	ds_load_u16_d16_hi v98, v33 offset:3520
	ds_load_u16_d16 v98, v33 offset:3392
	ds_load_u16_d16_hi v97, v33 offset:3264
	ds_load_u16_d16 v97, v33 offset:3136
	ds_load_u16_d16 v91, v33 offset:3584
	ds_load_u16_d16_hi v91, v33 offset:3712
	ds_load_u16_d16 v92, v33 offset:3840
	ds_load_u16_d16_hi v92, v33 offset:3968
	ds_load_u16_d16_hi v100, v33 offset:4032
	ds_load_u16_d16 v100, v33 offset:3904
	ds_load_u16_d16_hi v99, v33 offset:3776
	ds_load_u16_d16 v99, v33 offset:3648
	ds_load_b128 v[50:53], v57 offset:1312
	ds_load_b128 v[54:57], v57 offset:1328
	s_mul_i32 s23, s23, 17
	v_lshlrev_b32_e32 v33, 5, v0
	s_add_i32 s22, s22, s23
	s_clause 0x1
	s_load_b64 s[2:3], s[0:1], 0x48
	s_load_b64 s[6:7], s[0:1], 0x58
	s_lshl_b32 s4, s22, 13
	s_lshl_b32 s5, s21, 11
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[34:41], v[69:76], v[1:8]
	s_add_i32 s5, s4, s5
	v_wmma_f32_16x16x16_bf16 v[9:16], v[34:41], v[77:84], v[9:16]
	v_or_b32_e32 v101, s5, v33
	v_lshl_or_b32 v34, s22, 6, v0
	v_wmma_f32_16x16x16_bf16 v[17:24], v[58:65], v[69:76], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[58:65], v[77:84], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[42:49], v[85:92], v[1:8]
	v_ashrrev_i32_e32 v102, 31, v101
	v_ashrrev_i32_e32 v35, 31, v34
	v_wmma_f32_16x16x16_bf16 v[9:16], v[42:49], v[93:100], v[9:16]
	v_mov_b32_e32 v103, 1
	v_wmma_f32_16x16x16_bf16 v[17:24], v[50:57], v[85:92], v[17:24]
	v_lshlrev_b64 v[36:37], 2, v[101:102]
	v_lshlrev_b64 v[34:35], 2, v[34:35]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[50:57], v[93:100], v[25:32]
	s_mov_b32 s5, exec_lo
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v36, vcc_lo, s2, v36
	v_add_co_ci_u32_e64 v37, null, s3, v37, vcc_lo
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v65, vcc_lo, s6, v34
	v_add_co_ci_u32_e64 v66, null, s7, v35, vcc_lo
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
	global_atomic_add_u32 v1, v[65:66], v103, off glc
	s_waitcnt vmcnt(0)
	buffer_gl1_inv
	buffer_gl0_inv
	v_cmpx_eq_u32_e32 3, v1
	s_cbranch_execz .LBB0_205
	v_or_b32_e32 v1, s4, v33
	s_clause 0x1
	s_load_b128 s[4:7], s[0:1], 0x30
	s_load_b32 s0, s[0:1], 0x40
	v_bfe_u32 v80, v0, 4, 1
	v_or3_b32 v79, v67, s11, v68
	v_ashrrev_i32_e32 v2, 31, v1
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_mad_u32_u24 v0, 0x408, v80, v79
	v_lshlrev_b64 v[1:2], 2, v[1:2]
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v17, vcc_lo, s2, v1
	v_add_co_ci_u32_e64 v18, null, s3, v2, vcc_lo
	s_waitcnt lgkmcnt(0)
	s_add_i32 s1, s6, -1
	s_delay_alu instid0(VALU_DEP_2)
	v_add_co_u32 v9, vcc_lo, 0x2000, v17
	s_clause 0x4
	global_load_b128 v[69:72], v[17:18], off
	global_load_b128 v[73:76], v[17:18], off offset:16
	global_load_b128 v[1:4], v[17:18], off offset:64
	global_load_b128 v[81:84], v[17:18], off offset:48
	global_load_b128 v[85:88], v[17:18], off offset:32
	v_add_co_ci_u32_e64 v10, null, 0, v18, vcc_lo
	v_add_co_u32 v19, vcc_lo, 0x2040, v17
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v20, null, 0, v18, vcc_lo
	v_add_co_u32 v13, vcc_lo, 0x4000, v17
	s_clause 0x5
	global_load_b128 v[21:24], v[17:18], off offset:96
	global_load_b128 v[89:92], v[9:10], off
	global_load_b128 v[93:96], v[9:10], off offset:16
	global_load_b128 v[5:8], v[9:10], off offset:64
	global_load_b128 v[97:100], v[9:10], off offset:48
	global_load_b128 v[101:104], v[9:10], off offset:32
	v_add_co_ci_u32_e64 v14, null, 0, v18, vcc_lo
	v_add_co_u32 v25, vcc_lo, 0x4040, v17
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v26, null, 0, v18, vcc_lo
	v_add_co_u32 v27, vcc_lo, 0x6000, v17
	s_clause 0x5
	global_load_b128 v[37:40], v[19:20], off offset:32
	global_load_b128 v[105:108], v[13:14], off
	global_load_b128 v[109:112], v[13:14], off offset:16
	global_load_b128 v[9:12], v[13:14], off offset:64
	global_load_b128 v[113:116], v[13:14], off offset:48
	global_load_b128 v[117:120], v[13:14], off offset:32
	v_add_co_ci_u32_e64 v28, null, 0, v18, vcc_lo
	s_clause 0x4
	global_load_b128 v[45:48], v[25:26], off offset:32
	global_load_b128 v[121:124], v[27:28], off
	global_load_b128 v[125:128], v[27:28], off offset:16
	global_load_b128 v[129:132], v[27:28], off offset:32
	global_load_b128 v[13:16], v[27:28], off offset:64
	v_add_co_u32 v77, vcc_lo, 0x6040, v17
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v78, null, 0, v18, vcc_lo
	s_clause 0x9
	global_load_b128 v[133:136], v[27:28], off offset:48
	global_load_b128 v[41:44], v[77:78], off offset:32
	global_load_b128 v[61:64], v[17:18], off offset:112
	global_load_b128 v[33:36], v[17:18], off offset:80
	global_load_b128 v[57:60], v[19:20], off offset:48
	global_load_b128 v[53:56], v[25:26], off offset:48
	global_load_b128 v[49:52], v[77:78], off offset:48
	global_load_b128 v[29:32], v[19:20], off offset:16
	global_load_b128 v[25:28], v[25:26], off offset:16
	global_load_b128 v[17:20], v[77:78], off offset:16
	s_mul_i32 s0, s0, s1
	s_and_b32 s2, s10, s20
	s_add_i32 s0, s7, s0
	s_and_b32 s5, s5, 0xffff
	s_lshl_b32 s6, s0, 1
	s_and_b32 s0, s2, exec_lo
	s_cselect_b32 s1, 1, 0
	s_mov_b32 s0, -1
	s_cmp_lg_u32 s1, 1
	s_mov_b32 s7, 0x31027000
	s_waitcnt vmcnt(31)
	v_dual_add_f32 v69, 0, v69 :: v_dual_add_f32 v70, 0, v70
	v_dual_add_f32 v71, 0, v71 :: v_dual_add_f32 v72, 0, v72
	s_waitcnt vmcnt(30)
	v_dual_add_f32 v73, 0, v73 :: v_dual_add_f32 v74, 0, v74
	v_dual_add_f32 v75, 0, v75 :: v_dual_add_f32 v76, 0, v76
	s_waitcnt vmcnt(27)
	v_dual_add_f32 v1, 0, v1 :: v_dual_add_f32 v78, 0, v86
	v_dual_add_f32 v77, 0, v85 :: v_dual_add_f32 v86, 0, v88
	v_dual_add_f32 v85, 0, v87 :: v_dual_add_f32 v82, 0, v82
	v_dual_add_f32 v81, 0, v81 :: v_dual_add_f32 v84, 0, v84
	s_waitcnt vmcnt(25)
	v_dual_add_f32 v83, 0, v83 :: v_dual_add_f32 v70, v70, v90
	v_dual_add_f32 v21, 0, v21 :: v_dual_add_f32 v72, v72, v92
	s_waitcnt vmcnt(24)
	v_dual_add_f32 v69, v69, v89 :: v_dual_add_f32 v74, v74, v94
	v_dual_add_f32 v71, v71, v91 :: v_dual_add_f32 v76, v76, v96
	s_waitcnt vmcnt(22)
	v_dual_add_f32 v73, v73, v93 :: v_dual_add_f32 v82, v82, v98
	v_dual_add_f32 v75, v75, v95 :: v_dual_add_f32 v84, v84, v100
	v_add_f32_e32 v1, v1, v5
	s_waitcnt vmcnt(21)
	v_add_f32_e32 v5, v77, v101
	v_dual_add_f32 v77, v78, v102 :: v_dual_add_f32 v78, v85, v103
	v_add_f32_e32 v81, v81, v97
	v_add_f32_e32 v83, v83, v99
	v_add_f32_e32 v85, v86, v104
	s_waitcnt vmcnt(20)
	v_add_f32_e32 v21, v21, v37
	s_waitcnt vmcnt(19)
	v_add_f32_e32 v37, v69, v105
	v_dual_add_f32 v69, v70, v106 :: v_dual_add_f32 v70, v71, v107
	s_waitcnt vmcnt(18)
	v_dual_add_f32 v71, v72, v108 :: v_dual_add_f32 v72, v73, v109
	v_dual_add_f32 v73, v74, v110 :: v_dual_add_f32 v74, v75, v111
	s_waitcnt vmcnt(15)
	v_dual_add_f32 v75, v76, v112 :: v_dual_add_f32 v76, v78, v119
	v_dual_add_f32 v78, v81, v113 :: v_dual_add_f32 v81, v82, v114
	v_dual_add_f32 v82, v83, v115 :: v_dual_add_f32 v1, v1, v9
	s_waitcnt vmcnt(14)
	v_add_f32_e32 v21, v21, v45
	s_waitcnt vmcnt(13)
	v_add_f32_e32 v45, v69, v122
	v_dual_add_f32 v69, v70, v123 :: v_dual_add_f32 v70, v71, v124
	s_waitcnt vmcnt(12)
	v_add_f32_e32 v71, v72, v125
	s_waitcnt vmcnt(10)
	v_add_f32_e32 v1, v1, v13
	s_waitcnt vmcnt(9)
	v_dual_add_f32 v13, v76, v131 :: v_dual_add_f32 v76, v78, v133
	v_dual_add_f32 v78, v82, v135 :: v_dual_add_f32 v37, v37, v121
	v_bfe_u32 v89, v71, 16, 1
	s_waitcnt vmcnt(8)
	v_add_f32_e32 v21, v21, v41
	v_or_b32_e32 v90, 0x400000, v71
	v_bfe_u32 v111, v78, 16, 1
	v_bfe_u32 v41, v37, 16, 1
	v_or_b32_e32 v112, 0x400000, v78
	v_add3_u32 v89, v89, v71, 0x7fff
	v_add_f32_e32 v83, v84, v116
	v_add3_u32 v111, v111, v78, 0x7fff
	v_add_f32_e32 v9, v77, v118
	v_add_f32_e32 v77, v85, v120
	v_dual_add_f32 v72, v73, v126 :: v_dual_add_f32 v73, v74, v127
	v_add_f32_e32 v74, v75, v128
	v_or_b32_e32 v82, 0x400000, v37
	s_delay_alu instid0(VALU_DEP_4)
	v_add_f32_e32 v75, v77, v132
	v_add_f32_e32 v77, v81, v134
	v_add_f32_e32 v81, v83, v136
	v_bfe_u32 v83, v45, 16, 1
	v_add3_u32 v41, v41, v37, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v37, v37
	v_or_b32_e32 v84, 0x400000, v45
	v_bfe_u32 v85, v69, 16, 1
	v_add3_u32 v83, v83, v45, 0x7fff
	v_or_b32_e32 v86, 0x400000, v69
	v_cndmask_b32_e32 v37, v41, v82, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v45, v45
	v_bfe_u32 v87, v70, 16, 1
	v_add3_u32 v85, v85, v69, 0x7fff
	v_or_b32_e32 v88, 0x400000, v70
	v_bfe_u32 v91, v72, 16, 1
	v_cndmask_b32_e32 v41, v83, v84, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v69, v69
	v_add3_u32 v87, v87, v70, 0x7fff
	v_or_b32_e32 v92, 0x400000, v72
	v_bfe_u32 v93, v73, 16, 1
	v_bfe_u32 v107, v76, 16, 1
	v_cndmask_b32_e32 v45, v85, v86, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v70, v70
	v_add3_u32 v91, v91, v72, 0x7fff
	v_or_b32_e32 v94, 0x400000, v73
	v_bfe_u32 v95, v74, 16, 1
	v_or_b32_e32 v108, 0x400000, v76
	v_cndmask_b32_e32 v69, v87, v88, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v71, v71
	v_add3_u32 v93, v93, v73, 0x7fff
	v_add3_u32 v107, v107, v76, 0x7fff
	v_add_f32_e32 v5, v5, v117
	v_or_b32_e32 v96, 0x400000, v74
	v_cndmask_b32_e32 v70, v89, v90, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v72, v72
	v_bfe_u32 v97, v1, 16, 1
	v_add_f32_e32 v5, v5, v129
	v_add3_u32 v95, v95, v74, 0x7fff
	v_add_f32_e32 v9, v9, v130
	v_cndmask_b32_e32 v71, v91, v92, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v73, v73
	v_or_b32_e32 v98, 0x400000, v1
	v_bfe_u32 v99, v5, 16, 1
	v_add3_u32 v97, v97, v1, 0x7fff
	v_or_b32_e32 v100, 0x400000, v5
	v_cndmask_b32_e32 v72, v93, v94, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v74, v74
	v_bfe_u32 v101, v9, 16, 1
	v_add3_u32 v99, v99, v5, 0x7fff
	v_or_b32_e32 v102, 0x400000, v9
	v_bfe_u32 v103, v13, 16, 1
	v_cndmask_b32_e32 v82, v95, v96, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	v_add3_u32 v101, v101, v9, 0x7fff
	v_or_b32_e32 v104, 0x400000, v13
	v_bfe_u32 v105, v75, 16, 1
	v_add3_u32 v103, v103, v13, 0x7fff
	v_cndmask_b32_e32 v1, v97, v98, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_or_b32_e32 v106, 0x400000, v75
	v_add3_u32 v105, v105, v75, 0x7fff
	v_bfe_u32 v109, v77, 16, 1
	v_or_b32_e32 v110, 0x400000, v77
	v_cndmask_b32_e32 v5, v99, v100, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_bfe_u32 v113, v81, 16, 1
	v_add3_u32 v109, v109, v77, 0x7fff
	v_or_b32_e32 v114, 0x400000, v81
	v_bfe_u32 v115, v21, 16, 1
	v_cndmask_b32_e32 v9, v101, v102, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_add3_u32 v113, v113, v81, 0x7fff
	v_or_b32_e32 v116, 0x400000, v21
	v_add3_u32 v115, v115, v21, 0x7fff
	v_lshrrev_b32_e32 v74, 16, v41
	v_cndmask_b32_e32 v13, v103, v104, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v75, v75
	v_lshrrev_b32_e32 v75, 16, v45
	v_lshrrev_b32_e32 v73, 16, v71
	v_lshrrev_b32_e32 v71, 16, v82
	v_lshrrev_b32_e32 v45, 16, v9
	v_cndmask_b32_e32 v83, v105, v106, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v76, v76
	v_lshrrev_b32_e32 v76, 16, v69
	v_lshrrev_b32_e32 v69, 16, v5
	v_lshrrev_b32_e32 v41, 16, v13
	v_cndmask_b32_e32 v84, v107, v108, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v77, v77
	v_lshrrev_b32_e32 v77, 16, v70
	v_lshrrev_b32_e32 v70, 16, v72
	v_lshrrev_b32_e32 v72, 16, v1
	v_cndmask_b32_e32 v85, v109, v110, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v78, v78
	v_lshrrev_b32_e32 v78, 16, v37
	v_lshrrev_b32_e32 v37, 16, v83
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	v_lshrrev_b32_e32 v13, 16, v85
	v_cndmask_b32_e32 v86, v111, v112, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v81, v81
	v_lshrrev_b32_e32 v9, 16, v86
	v_cndmask_b32_e32 v81, v113, v114, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v21, v21
	v_lshrrev_b32_e32 v21, 16, v84
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_lshrrev_b32_e32 v5, 16, v81
	v_cndmask_b32_e32 v87, v115, v116, vcc_lo
	v_lshrrev_b32_e32 v1, 16, v87
	s_cbranch_scc0 .LBB0_202
	v_or3_b32 v86, v68, v67, s11
	s_delay_alu instid0(VALU_DEP_1)
	v_cmp_gt_i32_e64 s0, 0x408, v86
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_167
	v_lshlrev_b32_e32 v67, 1, v0
	buffer_store_b16 v78, v67, s[4:7], 0 offen
.LBB0_167:
	s_or_b32 exec_lo, exec_lo, s1
	v_lshl_add_u32 v67, v0, 1, 0x1000
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_169
	buffer_store_b16 v74, v67, s[4:7], 0 offen offset:32
.LBB0_169:
	s_or_b32 exec_lo, exec_lo, s1
	v_lshl_add_u32 v68, v0, 1, 0x2000
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_171
	buffer_store_b16 v75, v68, s[4:7], 0 offen offset:64
.LBB0_171:
	s_or_b32 exec_lo, exec_lo, s1
	v_lshl_add_u32 v81, v0, 1, 0x3000
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_173
	buffer_store_b16 v76, v81, s[4:7], 0 offen offset:96
.LBB0_173:
	s_or_b32 exec_lo, exec_lo, s1
	v_lshl_add_u32 v82, v0, 1, 0x4000
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_175
	buffer_store_b16 v77, v82, s[4:7], 0 offen offset:128
.LBB0_175:
	s_or_b32 exec_lo, exec_lo, s1
	v_lshl_add_u32 v83, v0, 1, 0x5000
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_177
	buffer_store_b16 v73, v83, s[4:7], 0 offen offset:160
.LBB0_177:
	s_or_b32 exec_lo, exec_lo, s1
	v_lshl_add_u32 v84, v0, 1, 0x6000
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_179
	buffer_store_b16 v70, v84, s[4:7], 0 offen offset:192
.LBB0_179:
	s_or_b32 exec_lo, exec_lo, s1
	v_lshl_add_u32 v85, v0, 1, 0x7000
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_181
	buffer_store_b16 v71, v85, s[4:7], 0 offen offset:224
.LBB0_181:
	s_or_b32 exec_lo, exec_lo, s1
	v_cmp_eq_u32_e32 vcc_lo, 0, v80
	v_lshl_add_u32 v79, v79, 1, 0x8000
	s_and_b32 s1, vcc_lo, s0
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s0, s1
	s_cbranch_execz .LBB0_183
	buffer_store_b16 v72, v79, s[4:7], 0 offen offset:256
.LBB0_183:
	s_or_b32 exec_lo, exec_lo, s0
	v_cmp_gt_i32_e64 s0, 0x3e8, v86
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_185
	v_lshlrev_b32_e32 v80, 1, v0
	buffer_store_b16 v69, v80, s[4:7], 0 offen offset:64
.LBB0_185:
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_187
	buffer_store_b16 v45, v67, s[4:7], 0 offen offset:96
.LBB0_187:
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_189
	buffer_store_b16 v41, v68, s[4:7], 0 offen offset:128
.LBB0_189:
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_191
	buffer_store_b16 v37, v81, s[4:7], 0 offen offset:160
.LBB0_191:
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_193
	buffer_store_b16 v21, v82, s[4:7], 0 offen offset:192
.LBB0_193:
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_195
	buffer_store_b16 v13, v83, s[4:7], 0 offen offset:224
.LBB0_195:
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_197
	buffer_store_b16 v9, v84, s[4:7], 0 offen offset:256
.LBB0_197:
	s_or_b32 exec_lo, exec_lo, s1
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_199
	buffer_store_b16 v5, v85, s[4:7], 0 offen offset:288
.LBB0_199:
	s_or_b32 exec_lo, exec_lo, s1
	s_and_b32 s1, vcc_lo, s0
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s0, s1
	s_cbranch_execz .LBB0_201
	buffer_store_b16 v1, v79, s[4:7], 0 offen offset:320
.LBB0_201:
	s_or_b32 exec_lo, exec_lo, s0
	s_mov_b32 s0, 0
.LBB0_202:
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 vcc_lo, exec_lo, s0
	s_cbranch_vccz .LBB0_204
	s_waitcnt vmcnt(6)
	v_dual_add_f32 v36, 0, v36 :: v_dual_add_f32 v3, 0, v3
	v_dual_add_f32 v64, 0, v64 :: v_dual_add_f32 v63, 0, v63
	v_lshlrev_b32_e32 v0, 1, v0
	s_waitcnt vmcnt(2)
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_3) | instid1(VALU_DEP_3)
	v_dual_add_f32 v32, v36, v32 :: v_dual_add_f32 v3, v3, v7
	v_dual_add_f32 v62, 0, v62 :: v_dual_add_f32 v61, 0, v61
	v_dual_add_f32 v60, v64, v60 :: v_dual_add_f32 v59, v63, v59
	s_waitcnt vmcnt(1)
	v_add_f32_e32 v28, v32, v28
	v_dual_add_f32 v32, 0, v34 :: v_dual_add_f32 v3, v3, v11
	v_dual_add_f32 v24, 0, v24 :: v_dual_add_f32 v23, 0, v23
	v_dual_add_f32 v58, v62, v58 :: v_dual_add_f32 v57, v61, v57
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_add_f32_e32 v30, v32, v30
	v_dual_add_f32 v56, v60, v56 :: v_dual_add_f32 v23, v23, v39
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_dual_add_f32 v54, v58, v54 :: v_dual_add_f32 v53, v57, v53
	v_add_f32_e32 v26, v30, v26
	v_add_f32_e32 v24, v24, v40
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_dual_add_f32 v52, v56, v52 :: v_dual_add_f32 v23, v23, v47
	s_waitcnt vmcnt(0)
	v_dual_add_f32 v49, v53, v49 :: v_dual_add_f32 v18, v26, v18
	v_add_f32_e32 v26, 0, v33
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_dual_add_f32 v24, v24, v48 :: v_dual_add_f32 v23, v23, v43
	v_dual_add_f32 v48, v54, v50 :: v_dual_add_f32 v35, 0, v35
	v_add_f32_e32 v26, v26, v29
	v_add_f32_e32 v40, v59, v55
	v_bfe_u32 v50, v52, 16, 1
	v_add_f32_e32 v2, 0, v2
	v_cmp_u_f32_e32 vcc_lo, v52, v52
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_dual_add_f32 v25, v26, v25 :: v_dual_add_f32 v40, v40, v51
	v_or_b32_e32 v51, 0x400000, v52
	v_add3_u32 v50, v50, v52, 0x7fff
	v_dual_add_f32 v20, v28, v20 :: v_dual_add_f32 v3, v3, v15
	v_bfe_u32 v53, v40, 16, 1
	v_add_f32_e32 v2, v2, v6
	v_bfe_u32 v54, v48, 16, 1
	v_or_b32_e32 v55, 0x400000, v40
	v_dual_cndmask_b32 v50, v50, v51 :: v_dual_add_f32 v17, v25, v17
	v_add3_u32 v53, v53, v40, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v40, v40
	v_add_f32_e32 v2, v2, v10
	v_bfe_u32 v11, v3, 16, 1
	v_or_b32_e32 v56, 0x400000, v48
	v_add3_u32 v54, v54, v48, 0x7fff
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_dual_add_f32 v31, v35, v31 :: v_dual_add_f32 v2, v2, v14
	v_add3_u32 v11, v11, v3, 0x7fff
	v_or_b32_e32 v14, 0x400000, v3
	v_cndmask_b32_e32 v40, v53, v55, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v48, v48
	v_dual_add_f32 v24, v24, v44 :: v_dual_add_f32 v27, v31, v27
	v_bfe_u32 v51, v49, 16, 1
	v_add_f32_e32 v22, 0, v22
	v_cndmask_b32_e32 v48, v54, v56, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v49, v49
	v_add_f32_e32 v19, v27, v19
	v_add3_u32 v44, v51, v49, 0x7fff
	v_add_f32_e32 v22, v22, v38
	v_lshrrev_b32_e32 v39, 16, v48
	v_or_b32_e32 v48, 0x400000, v49
	v_bfe_u32 v32, v19, 16, 1
	v_bfe_u32 v47, v24, 16, 1
	v_dual_add_f32 v22, v22, v46 :: v_dual_add_nc_u32 v25, 0xa000, v0
	v_add_f32_e32 v4, 0, v4
	s_delay_alu instid0(VALU_DEP_4)
	v_add3_u32 v30, v32, v19, 0x7fff
	v_cndmask_b32_e32 v44, v44, v48, vcc_lo
	v_add3_u32 v43, v47, v24, 0x7fff
	v_or_b32_e32 v47, 0x400000, v24
	v_cmp_u_f32_e32 vcc_lo, v24, v24
	v_add_f32_e32 v22, v22, v42
	v_lshrrev_b32_e32 v38, 16, v44
	v_bfe_u32 v44, v23, 16, 1
	v_add_f32_e32 v4, v4, v8
	v_cndmask_b32_e32 v24, v43, v47, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v23, v23
	v_bfe_u32 v31, v22, 16, 1
	v_add3_u32 v43, v44, v23, 0x7fff
	v_or_b32_e32 v44, 0x400000, v23
	v_or_b32_e32 v28, 0x400000, v22
	v_add_f32_e32 v4, v4, v12
	v_add3_u32 v27, v31, v22, 0x7fff
	v_bfe_u32 v31, v20, 16, 1
	v_cndmask_b32_e32 v23, v43, v44, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v22, v22
	v_bfe_u32 v6, v17, 16, 1
	v_add_f32_e32 v4, v4, v16
	v_or_b32_e32 v8, 0x400000, v17
	v_or_b32_e32 v15, 0x400000, v2
	v_cndmask_b32_e32 v22, v27, v28, vcc_lo
	v_add3_u32 v27, v31, v20, 0x7fff
	v_or_b32_e32 v28, 0x400000, v20
	v_cmp_u_f32_e32 vcc_lo, v20, v20
	v_or_b32_e32 v31, 0x400000, v19
	v_add3_u32 v6, v6, v17, 0x7fff
	v_bfe_u32 v10, v4, 16, 1
	v_or_b32_e32 v12, 0x400000, v4
	v_cndmask_b32_e32 v20, v27, v28, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v19, v19
	v_bfe_u32 v27, v18, 16, 1
	v_add3_u32 v10, v10, v4, 0x7fff
	v_add_nc_u32_e32 v16, 0x7000, v0
	buffer_store_b16 v78, v0, s[4:7], 0 offen
	v_cndmask_b32_e32 v19, v30, v31, vcc_lo
	v_add3_u32 v26, v27, v18, 0x7fff
	v_or_b32_e32 v27, 0x400000, v18
	v_cmp_u_f32_e32 vcc_lo, v18, v18
	v_add_nc_u32_e32 v18, 0x9000, v0
	v_lshrrev_b32_e32 v19, 16, v19
	v_lshrrev_b32_e32 v20, 16, v20
	v_dual_cndmask_b32 v7, v26, v27 :: v_dual_add_nc_u32 v28, 0xf000, v0
	v_cmp_u_f32_e32 vcc_lo, v17, v17
	v_add_nc_u32_e32 v17, 0x8000, v0
	v_add_nc_u32_e32 v26, 0xd000, v0
	v_add_nc_u32_e32 v27, 0xe000, v0
	v_lshrrev_b32_e32 v7, 16, v7
	v_cndmask_b32_e32 v6, v6, v8, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_bfe_u32 v8, v2, 16, 1
	v_lshrrev_b32_e32 v50, 16, v50
	v_lshrrev_b32_e32 v23, 16, v23
	v_lshrrev_b32_e32 v6, 16, v6
	v_cndmask_b32_e32 v4, v10, v12, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_add3_u32 v8, v8, v2, 0x7fff
	v_add_nc_u32_e32 v10, 0x2000, v0
	v_add_nc_u32_e32 v12, 0x4000, v0
	v_lshrrev_b32_e32 v4, 16, v4
	v_cndmask_b32_e32 v3, v11, v14, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_add_nc_u32_e32 v11, 0x3000, v0
	v_add_nc_u32_e32 v14, 0x5000, v0
	v_lshrrev_b32_e32 v40, 16, v40
	v_lshrrev_b32_e32 v3, 16, v3
	v_cndmask_b32_e32 v2, v8, v15, vcc_lo
	v_add_nc_u32_e32 v8, 0x1000, v0
	v_add_nc_u32_e32 v15, 0x6000, v0
	s_clause 0x4
	buffer_store_b16 v74, v8, s[4:7], 0 offen offset:32
	buffer_store_b16 v75, v10, s[4:7], 0 offen offset:64
	buffer_store_b16 v76, v11, s[4:7], 0 offen offset:96
	buffer_store_b16 v77, v12, s[4:7], 0 offen offset:128
	buffer_store_b16 v73, v14, s[4:7], 0 offen offset:160
	v_lshrrev_b32_e32 v2, 16, v2
	s_clause 0x4
	buffer_store_b16 v70, v15, s[4:7], 0 offen offset:192
	buffer_store_b16 v71, v16, s[4:7], 0 offen offset:224
	buffer_store_b16 v72, v17, s[4:7], 0 offen offset:256
	buffer_store_b16 v2, v18, s[4:7], 0 offen offset:288
	buffer_store_b16 v3, v25, s[4:7], 0 offen offset:320
	v_add_nc_u32_e32 v2, 0xb000, v0
	v_add_nc_u32_e32 v3, 0xc000, v0
	v_lshrrev_b32_e32 v24, 16, v24
	v_lshrrev_b32_e32 v22, 16, v22
	s_clause 0x14
	buffer_store_b16 v4, v2, s[4:7], 0 offen offset:352
	buffer_store_b16 v6, v3, s[4:7], 0 offen offset:384
	buffer_store_b16 v7, v26, s[4:7], 0 offen offset:416
	buffer_store_b16 v19, v27, s[4:7], 0 offen offset:448
	buffer_store_b16 v20, v28, s[4:7], 0 offen offset:480
	buffer_store_b16 v69, v0, s[4:7], 0 offen offset:64
	buffer_store_b16 v45, v8, s[4:7], 0 offen offset:96
	buffer_store_b16 v41, v10, s[4:7], 0 offen offset:128
	buffer_store_b16 v37, v11, s[4:7], 0 offen offset:160
	buffer_store_b16 v21, v12, s[4:7], 0 offen offset:192
	buffer_store_b16 v13, v14, s[4:7], 0 offen offset:224
	buffer_store_b16 v9, v15, s[4:7], 0 offen offset:256
	buffer_store_b16 v5, v16, s[4:7], 0 offen offset:288
	buffer_store_b16 v1, v17, s[4:7], 0 offen offset:320
	buffer_store_b16 v22, v18, s[4:7], 0 offen offset:352
	buffer_store_b16 v23, v25, s[4:7], 0 offen offset:384
	buffer_store_b16 v24, v2, s[4:7], 0 offen offset:416
	buffer_store_b16 v38, v3, s[4:7], 0 offen offset:448
	buffer_store_b16 v39, v26, s[4:7], 0 offen offset:480
	buffer_store_b16 v40, v27, s[4:7], 0 offen offset:512
	buffer_store_b16 v50, v28, s[4:7], 0 offen offset:544
.LBB0_204:
	v_mov_b32_e32 v0, 0
	s_waitcnt vmcnt(0)
	s_waitcnt_vscnt null, 0x0
	global_store_b32 v[65:66], v0, off
.LBB0_205:
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
		.amdhsa_next_free_vgpr 137
		.amdhsa_next_free_sgpr 32
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

	.set .L_matmul_bf16_0.num_vgpr, 137
	.set .L_matmul_bf16_0.num_agpr, 0
	.set .L_matmul_bf16_0.numbered_sgpr, 32
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
    .sgpr_count:     34
    .sgpr_spill_count: 0
    .symbol:         _matmul_bf16_0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     137
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
