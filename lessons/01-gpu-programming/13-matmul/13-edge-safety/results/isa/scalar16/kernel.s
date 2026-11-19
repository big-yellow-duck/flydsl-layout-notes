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
	s_ashr_i32 s8, s2, 31
	v_and_b32_e32 v131, 15, v0
	s_lshr_b32 s8, s8, 30
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_i32 s8, s2, s8
	s_ashr_i32 s9, s8, 2
	s_and_b32 s8, s8, -4
	s_waitcnt lgkmcnt(0)
	s_add_i32 s6, s6, -1
	s_and_b32 s5, s5, 0xffff
	s_mul_i32 s3, s3, s6
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_add_i32 s3, s7, s3
	s_lshl_b32 s6, s3, 1
	s_cmp_lg_u32 s2, s8
	s_cselect_b32 s3, -1, 0
	s_cmp_lt_i32 s2, 0
	s_cselect_b32 s7, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(SALU_CYCLE_1)
	s_and_b32 s3, s7, s3
	s_subb_u32 s3, s9, 0
	s_sub_i32 s18, s2, s8
	s_lshr_b32 s7, s3, 31
	s_add_i32 s7, s3, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_b32 s8, s7, -2
	s_ashr_i32 s2, s7, 1
	s_cmp_lg_u32 s3, s8
	s_cselect_b32 s7, -1, 0
	s_cmp_lt_i32 s3, 0
	s_cselect_b32 s9, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(SALU_CYCLE_1)
	s_and_b32 s7, s9, s7
	s_subb_u32 s2, s2, 0
	s_sub_i32 s3, s3, s8
	s_sub_i32 s7, 2, s2
	s_min_i32 s7, s7, 1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_abs_i32 s9, s7
	s_cvt_f32_u32 s10, s9
	s_sub_i32 s11, 0, s9
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(NEXT) | instid1(TRANS32_DEP_1)
	v_rcp_f32_e32 v1, s10
	v_readfirstlane_b32 s10, v1
	v_mov_b16_e32 v1.h, 0
	s_mul_f32 s10, s10, 0x4f7ffffe
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(SALU_CYCLE_2)
	v_mov_b16_e32 v1.l, v1.h
	s_cvt_u32_f32 s10, s10
	s_delay_alu instid0(SALU_CYCLE_3) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_mul_i32 s11, s11, s10
	s_mul_hi_u32 s8, s10, s11
	s_abs_i32 s11, s3
	s_add_i32 s10, s10, s8
	s_delay_alu instid0(SALU_CYCLE_1)
	s_mul_hi_u32 s8, s11, s10
	s_xor_b32 s10, s3, s7
	s_mul_i32 s12, s8, s9
	s_ashr_i32 s10, s10, 31
	s_sub_i32 s11, s11, s12
	s_add_i32 s12, s8, 1
	s_sub_i32 s13, s11, s9
	s_cmp_ge_u32 s11, s9
	s_cselect_b32 s8, s12, s8
	s_cselect_b32 s11, s13, s11
	s_add_i32 s12, s8, 1
	s_cmp_ge_u32 s11, s9
	s_cselect_b32 s8, s12, s8
	s_lshl_b32 s9, s18, 5
	s_xor_b32 s8, s8, s10
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_sub_i32 s8, s8, s10
	s_mul_i32 s11, s8, s7
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_sub_i32 s17, s3, s11
	s_add_i32 s17, s17, s2
	s_delay_alu instid0(SALU_CYCLE_1)
	s_lshl_b32 s16, s17, 4
	s_mul_i32 s7, s17, 0x210
	v_or_b32_e32 v2, s16, v131
	s_add_i32 s7, s7, s9
	s_cmp_lt_i32 s18, 2
	v_mad_u32_u24 v3, v131, 33, s7
	s_cselect_b32 s10, -1, 0
	s_or_b32 s7, s9, 1
	v_cmp_gt_i32_e32 vcc_lo, 17, v2
	s_cmp_lt_i32 s7, 34
	v_lshlrev_b32_e32 v17, 1, v3
	s_cselect_b32 s7, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_2) | instid1(SALU_CYCLE_1)
	s_and_b32 s12, s7, vcc_lo
	s_mov_b32 s7, 0x31027000
	s_and_b32 s13, s10, s12
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_2
	buffer_load_u16 v2, v17, s[4:7], 0 offen
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v1.l, v2.l
.LBB0_2:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_and_b32 s12, s12, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s13, s10, s12
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_4
	buffer_load_u16 v2, v17, s[4:7], 0 offen offset:2
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v1.h, v2.l
.LBB0_4:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 3
	v_mov_b16_e32 v2.h, 0
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_mov_b16_e32 v2.l, v2.h
	s_and_b32 s12, s12, vcc_lo
	s_and_b32 s13, s10, s12
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_6
	buffer_load_u16 v3, v17, s[4:7], 0 offen offset:4
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v2.l, v3.l
.LBB0_6:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 4
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_and_b32 s12, s12, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s13, s10, s12
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_8
	buffer_load_u16 v3, v17, s[4:7], 0 offen offset:6
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v2.h, v3.l
.LBB0_8:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 5
	v_mov_b16_e32 v3.h, 0
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_mov_b16_e32 v3.l, v3.h
	s_and_b32 s12, s12, vcc_lo
	s_and_b32 s13, s10, s12
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_10
	buffer_load_u16 v4, v17, s[4:7], 0 offen offset:8
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v3.l, v4.l
.LBB0_10:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 6
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_and_b32 s12, s12, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s13, s10, s12
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_12
	buffer_load_u16 v4, v17, s[4:7], 0 offen offset:10
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v3.h, v4.l
.LBB0_12:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 7
	v_mov_b16_e32 v4.h, 0
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_mov_b16_e32 v4.l, v4.h
	s_and_b32 s12, s12, vcc_lo
	s_and_b32 s13, s10, s12
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_14
	buffer_load_u16 v5, v17, s[4:7], 0 offen offset:12
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v4.l, v5.l
.LBB0_14:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 8
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_and_b32 s12, s12, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s13, s10, s12
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_16
	buffer_load_u16 v5, v17, s[4:7], 0 offen offset:14
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v4.h, v5.l
.LBB0_16:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 9
	v_mov_b16_e32 v5.h, 0
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_mov_b16_e32 v5.l, v5.h
	s_and_b32 s12, s12, vcc_lo
	s_and_b32 s13, s10, s12
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_18
	buffer_load_u16 v6, v17, s[4:7], 0 offen offset:16
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v5.l, v6.l
.LBB0_18:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 10
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_and_b32 s12, s12, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s13, s10, s12
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_20
	buffer_load_u16 v6, v17, s[4:7], 0 offen offset:18
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v5.h, v6.l
.LBB0_20:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 11
	v_mov_b16_e32 v6.h, 0
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_mov_b16_e32 v6.l, v6.h
	s_and_b32 s12, s12, vcc_lo
	s_and_b32 s13, s10, s12
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_22
	buffer_load_u16 v7, v17, s[4:7], 0 offen offset:20
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v6.l, v7.l
.LBB0_22:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 12
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_and_b32 s12, s12, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s13, s10, s12
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_24
	buffer_load_u16 v7, v17, s[4:7], 0 offen offset:22
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v6.h, v7.l
.LBB0_24:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 13
	v_mov_b16_e32 v7.h, 0
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_mov_b16_e32 v7.l, v7.h
	s_and_b32 s12, s12, vcc_lo
	s_and_b32 s13, s10, s12
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_26
	buffer_load_u16 v8, v17, s[4:7], 0 offen offset:24
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v7.l, v8.l
.LBB0_26:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 14
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_and_b32 s12, s12, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s13, s10, s12
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_28
	buffer_load_u16 v8, v17, s[4:7], 0 offen offset:26
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v7.h, v8.l
.LBB0_28:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 15
	v_mov_b16_e32 v8.h, 0
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_mov_b16_e32 v8.l, v8.h
	s_and_b32 s12, s12, vcc_lo
	s_and_b32 s13, s10, s12
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_30
	buffer_load_u16 v9, v17, s[4:7], 0 offen offset:28
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v8.l, v9.l
.LBB0_30:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 16
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_and_b32 s12, s12, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s13, s10, s12
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_32
	buffer_load_u16 v9, v17, s[4:7], 0 offen offset:30
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v8.h, v9.l
.LBB0_32:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 17
	v_mov_b16_e32 v9.h, 0
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_mov_b16_e32 v9.l, v9.h
	s_and_b32 s12, s12, vcc_lo
	s_and_b32 s13, s10, s12
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_34
	buffer_load_u16 v10, v17, s[4:7], 0 offen offset:32
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v9.l, v10.l
.LBB0_34:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 18
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_and_b32 s12, s12, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s13, s10, s12
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_36
	buffer_load_u16 v10, v17, s[4:7], 0 offen offset:34
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v9.h, v10.l
.LBB0_36:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 19
	v_mov_b16_e32 v10.h, 0
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_mov_b16_e32 v10.l, v10.h
	s_and_b32 s12, s12, vcc_lo
	s_and_b32 s13, s10, s12
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_38
	buffer_load_u16 v11, v17, s[4:7], 0 offen offset:36
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v10.l, v11.l
.LBB0_38:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 20
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_and_b32 s12, s12, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s13, s10, s12
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_40
	buffer_load_u16 v11, v17, s[4:7], 0 offen offset:38
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v10.h, v11.l
.LBB0_40:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 21
	v_mov_b16_e32 v11.h, 0
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_mov_b16_e32 v11.l, v11.h
	s_and_b32 s12, s12, vcc_lo
	s_and_b32 s13, s10, s12
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_42
	buffer_load_u16 v12, v17, s[4:7], 0 offen offset:40
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v11.l, v12.l
.LBB0_42:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 22
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_and_b32 s12, s12, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s13, s10, s12
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_44
	buffer_load_u16 v12, v17, s[4:7], 0 offen offset:42
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v11.h, v12.l
.LBB0_44:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 23
	v_mov_b16_e32 v12.h, 0
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_mov_b16_e32 v12.l, v12.h
	s_and_b32 s12, s12, vcc_lo
	s_and_b32 s13, s10, s12
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_46
	buffer_load_u16 v13, v17, s[4:7], 0 offen offset:44
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v12.l, v13.l
.LBB0_46:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 24
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_and_b32 s12, s12, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s13, s10, s12
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_48
	buffer_load_u16 v13, v17, s[4:7], 0 offen offset:46
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v12.h, v13.l
.LBB0_48:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 25
	v_mov_b16_e32 v13.h, 0
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_mov_b16_e32 v13.l, v13.h
	s_and_b32 s12, s12, vcc_lo
	s_and_b32 s13, s10, s12
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_50
	buffer_load_u16 v14, v17, s[4:7], 0 offen offset:48
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v13.l, v14.l
.LBB0_50:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 26
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_and_b32 s12, s12, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s13, s10, s12
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_52
	buffer_load_u16 v14, v17, s[4:7], 0 offen offset:50
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v13.h, v14.l
.LBB0_52:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 27
	v_mov_b16_e32 v14.h, 0
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_mov_b16_e32 v14.l, v14.h
	s_and_b32 s12, s12, vcc_lo
	s_and_b32 s13, s10, s12
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_54
	buffer_load_u16 v15, v17, s[4:7], 0 offen offset:52
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v14.l, v15.l
.LBB0_54:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 28
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_and_b32 s12, s12, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s13, s10, s12
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_56
	buffer_load_u16 v15, v17, s[4:7], 0 offen offset:54
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v14.h, v15.l
.LBB0_56:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 29
	v_mov_b16_e32 v15.h, 0
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_mov_b16_e32 v15.l, v15.h
	s_and_b32 s12, s12, vcc_lo
	s_and_b32 s13, s10, s12
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_58
	buffer_load_u16 v16, v17, s[4:7], 0 offen offset:56
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v15.l, v16.l
.LBB0_58:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 30
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_and_b32 s12, s12, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s13, s10, s12
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_60
	buffer_load_u16 v16, v17, s[4:7], 0 offen offset:58
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v15.h, v16.l
.LBB0_60:
	s_or_b32 exec_lo, exec_lo, s12
	s_or_b32 s12, s9, 31
	v_mov_b16_e32 v16.h, 0
	s_cmp_lt_i32 s12, 34
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_mov_b16_e32 v16.l, v16.h
	s_and_b32 s12, s12, vcc_lo
	s_and_b32 s13, s10, s12
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_62
	buffer_load_u16 v18, v17, s[4:7], 0 offen offset:60
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v16.l, v18.l
.LBB0_62:
	s_or_b32 exec_lo, exec_lo, s12
	s_cmp_lt_i32 s18, 1
	s_cselect_b32 s12, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s13, s12, vcc_lo
	s_and_saveexec_b32 s12, s13
	s_cbranch_execz .LBB0_64
	buffer_load_u16 v17, v17, s[4:7], 0 offen offset:62
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v16.h, v17.l
.LBB0_64:
	s_or_b32 exec_lo, exec_lo, s12
	s_clause 0x1
	s_load_b128 s[12:15], s[0:1], 0x18
	s_load_b32 s4, s[0:1], 0x28
	v_lshlrev_b32_e32 v17, 3, v0
	v_lshrrev_b32_e32 v50, 3, v0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_and_b32_e32 v49, 56, v17
	v_mul_u32_u24_e32 v17, 0x41, v50
	v_or_b32_e32 v45, s9, v50
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_4) | instid1(SALU_CYCLE_1)
	v_cmp_gt_i32_e64 s9, 33, v45
	s_waitcnt lgkmcnt(0)
	s_add_i32 s5, s14, -1
	s_and_b32 s13, s13, 0xffff
	s_mul_i32 s4, s4, s5
	s_add_i32 s4, s15, s4
	s_mov_b32 s15, 0x31027000
	s_lshl_b32 s14, s4, 1
	s_cmp_lg_u32 s3, s11
	s_cselect_b32 s4, -1, 0
	s_cmp_lt_i32 s3, 0
	s_cselect_b32 s3, -1, 0
	s_cmp_gt_i32 s2, 2
	s_cselect_b32 s2, -1, 0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_xor_b32 s2, s3, s2
	s_and_b32 s2, s2, s4
	s_subb_u32 s11, s8, 0
	s_mul_i32 s2, s18, 0x820
	s_lshl_b32 s19, s11, 6
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_or_b32_e32 v21, s19, v49
	s_add_i32 s2, s19, s2
	v_add3_u32 v19, s2, v17, v49
	v_mov_b16_e32 v17.h, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_or_b32_e32 v18, 1, v21
	v_lshlrev_b32_e32 v51, 1, v19
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_mov_b16_e32 v17.l, v17.h
	v_cmp_gt_i32_e32 vcc_lo, 0x42, v18
	s_and_b32 s2, s9, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s3, s10, s2
	s_and_saveexec_b32 s2, s3
	s_cbranch_execz .LBB0_66
	buffer_load_u16 v18, v51, s[12:15], 0 offen slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v17.l, v18.l
.LBB0_66:
	s_or_b32 exec_lo, exec_lo, s2
	v_or_b32_e32 v18, 2, v21
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_cmp_gt_i32_e64 s2, 0x42, v18
	s_and_b32 s3, s9, s2
	s_and_b32 s4, s10, s3
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s3, s4
	s_cbranch_execz .LBB0_68
	buffer_load_u16 v18, v51, s[12:15], 0 offen offset:2 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v17.h, v18.l
.LBB0_68:
	s_or_b32 exec_lo, exec_lo, s3
	v_or_b32_e32 v19, 3, v21
	v_mov_b16_e32 v18.h, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_i32_e64 s3, 0x42, v19
	v_mov_b16_e32 v18.l, v18.h
	s_and_b32 s4, s9, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s5, s10, s4
	s_and_saveexec_b32 s4, s5
	s_cbranch_execz .LBB0_70
	buffer_load_u16 v19, v51, s[12:15], 0 offen offset:4 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v18.l, v19.l
.LBB0_70:
	s_or_b32 exec_lo, exec_lo, s4
	v_or_b32_e32 v19, 4, v21
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_cmp_gt_i32_e64 s4, 0x42, v19
	s_and_b32 s5, s9, s4
	s_and_b32 s6, s10, s5
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s5, s6
	s_cbranch_execz .LBB0_72
	buffer_load_u16 v19, v51, s[12:15], 0 offen offset:6 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v18.h, v19.l
.LBB0_72:
	s_or_b32 exec_lo, exec_lo, s5
	v_or_b32_e32 v20, 5, v21
	v_mov_b16_e32 v19.h, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_i32_e64 s5, 0x42, v20
	v_mov_b16_e32 v19.l, v19.h
	s_and_b32 s6, s9, s5
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s7, s10, s6
	s_and_saveexec_b32 s6, s7
	s_cbranch_execz .LBB0_74
	buffer_load_u16 v20, v51, s[12:15], 0 offen offset:8 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v19.l, v20.l
.LBB0_74:
	s_or_b32 exec_lo, exec_lo, s6
	v_or_b32_e32 v20, 6, v21
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_cmp_gt_i32_e64 s6, 0x42, v20
	s_and_b32 s7, s9, s6
	s_and_b32 s8, s10, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s7, s8
	s_cbranch_execz .LBB0_76
	buffer_load_u16 v20, v51, s[12:15], 0 offen offset:10 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v19.h, v20.l
.LBB0_76:
	s_or_b32 exec_lo, exec_lo, s7
	v_or_b32_e32 v22, 7, v21
	v_mov_b16_e32 v20.h, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_i32_e64 s7, 0x42, v22
	v_mov_b16_e32 v20.l, v20.h
	s_and_b32 s8, s9, s7
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s20, s10, s8
	s_and_saveexec_b32 s8, s20
	s_cbranch_execz .LBB0_78
	buffer_load_u16 v22, v51, s[12:15], 0 offen offset:12 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v20.l, v22.l
.LBB0_78:
	s_or_b32 exec_lo, exec_lo, s8
	v_cmp_gt_i32_e64 s8, 58, v21
	s_and_b32 s9, s9, s8
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s20, s10, s9
	s_and_saveexec_b32 s9, s20
	s_cbranch_execz .LBB0_80
	buffer_load_u16 v21, v51, s[12:15], 0 offen offset:14 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v20.h, v21.l
.LBB0_80:
	s_or_b32 exec_lo, exec_lo, s9
	v_or_b32_e32 v22, 4, v45
	v_mov_b16_e32 v21.h, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_i32_e64 s9, 33, v22
	v_mov_b16_e32 v21.l, v21.h
	s_and_b32 s20, s9, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_82
	buffer_load_u16 v22, v51, s[12:15], 0 offen offset:520 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v21.l, v22.l
.LBB0_82:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s20, s9, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_84
	buffer_load_u16 v22, v51, s[12:15], 0 offen offset:522 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v21.h, v22.l
.LBB0_84:
	s_or_b32 exec_lo, exec_lo, s20
	v_mov_b16_e32 v22.h, 0
	s_and_b32 s20, s9, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s21, s10, s20
	v_mov_b16_e32 v22.l, v22.h
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_86
	buffer_load_u16 v23, v51, s[12:15], 0 offen offset:524 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v22.l, v23.l
.LBB0_86:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s20, s9, s4
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_88
	buffer_load_u16 v23, v51, s[12:15], 0 offen offset:526 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v22.h, v23.l
.LBB0_88:
	s_or_b32 exec_lo, exec_lo, s20
	v_mov_b16_e32 v23.h, 0
	s_and_b32 s20, s9, s5
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s21, s10, s20
	v_mov_b16_e32 v23.l, v23.h
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_90
	buffer_load_u16 v24, v51, s[12:15], 0 offen offset:528 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v23.l, v24.l
.LBB0_90:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s20, s9, s6
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_92
	buffer_load_u16 v24, v51, s[12:15], 0 offen offset:530 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v23.h, v24.l
.LBB0_92:
	s_or_b32 exec_lo, exec_lo, s20
	v_mov_b16_e32 v24.h, 0
	s_and_b32 s20, s9, s7
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s21, s10, s20
	v_mov_b16_e32 v24.l, v24.h
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_94
	buffer_load_u16 v25, v51, s[12:15], 0 offen offset:532 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v24.l, v25.l
.LBB0_94:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s9, s9, s8
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s20, s10, s9
	s_and_saveexec_b32 s9, s20
	s_cbranch_execz .LBB0_96
	buffer_load_u16 v25, v51, s[12:15], 0 offen offset:534 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v24.h, v25.l
.LBB0_96:
	s_or_b32 exec_lo, exec_lo, s9
	v_or_b32_e32 v26, 8, v45
	v_mov_b16_e32 v25.h, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_i32_e64 s9, 33, v26
	v_mov_b16_e32 v25.l, v25.h
	s_and_b32 s20, s9, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_98
	buffer_load_u16 v26, v51, s[12:15], 0 offen offset:1040 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v25.l, v26.l
.LBB0_98:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s20, s9, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_100
	buffer_load_u16 v26, v51, s[12:15], 0 offen offset:1042 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v25.h, v26.l
.LBB0_100:
	s_or_b32 exec_lo, exec_lo, s20
	v_mov_b16_e32 v26.h, 0
	s_and_b32 s20, s9, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s21, s10, s20
	v_mov_b16_e32 v26.l, v26.h
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_102
	buffer_load_u16 v27, v51, s[12:15], 0 offen offset:1044 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v26.l, v27.l
.LBB0_102:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s20, s9, s4
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_104
	buffer_load_u16 v27, v51, s[12:15], 0 offen offset:1046 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v26.h, v27.l
.LBB0_104:
	s_or_b32 exec_lo, exec_lo, s20
	v_mov_b16_e32 v27.h, 0
	s_and_b32 s20, s9, s5
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s21, s10, s20
	v_mov_b16_e32 v27.l, v27.h
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_106
	buffer_load_u16 v28, v51, s[12:15], 0 offen offset:1048 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v27.l, v28.l
.LBB0_106:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s20, s9, s6
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_108
	buffer_load_u16 v28, v51, s[12:15], 0 offen offset:1050 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v27.h, v28.l
.LBB0_108:
	s_or_b32 exec_lo, exec_lo, s20
	v_mov_b16_e32 v28.h, 0
	s_and_b32 s20, s9, s7
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s21, s10, s20
	v_mov_b16_e32 v28.l, v28.h
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_110
	buffer_load_u16 v29, v51, s[12:15], 0 offen offset:1052 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v28.l, v29.l
.LBB0_110:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s9, s9, s8
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s20, s10, s9
	s_and_saveexec_b32 s9, s20
	s_cbranch_execz .LBB0_112
	buffer_load_u16 v29, v51, s[12:15], 0 offen offset:1054 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v28.h, v29.l
.LBB0_112:
	s_or_b32 exec_lo, exec_lo, s9
	v_or_b32_e32 v30, 12, v45
	v_mov_b16_e32 v29.h, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_i32_e64 s9, 33, v30
	v_mov_b16_e32 v29.l, v29.h
	s_and_b32 s20, s9, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_114
	buffer_load_u16 v30, v51, s[12:15], 0 offen offset:1560 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v29.l, v30.l
.LBB0_114:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s20, s9, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_116
	buffer_load_u16 v30, v51, s[12:15], 0 offen offset:1562 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v29.h, v30.l
.LBB0_116:
	s_or_b32 exec_lo, exec_lo, s20
	v_mov_b16_e32 v30.h, 0
	s_and_b32 s20, s9, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s21, s10, s20
	v_mov_b16_e32 v30.l, v30.h
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_118
	buffer_load_u16 v31, v51, s[12:15], 0 offen offset:1564 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v30.l, v31.l
.LBB0_118:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s20, s9, s4
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_120
	buffer_load_u16 v31, v51, s[12:15], 0 offen offset:1566 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v30.h, v31.l
.LBB0_120:
	s_or_b32 exec_lo, exec_lo, s20
	v_mov_b16_e32 v31.h, 0
	s_and_b32 s20, s9, s5
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s21, s10, s20
	v_mov_b16_e32 v31.l, v31.h
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_122
	buffer_load_u16 v32, v51, s[12:15], 0 offen offset:1568 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v31.l, v32.l
.LBB0_122:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s20, s9, s6
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_124
	buffer_load_u16 v32, v51, s[12:15], 0 offen offset:1570 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v31.h, v32.l
.LBB0_124:
	s_or_b32 exec_lo, exec_lo, s20
	v_mov_b16_e32 v32.h, 0
	s_and_b32 s20, s9, s7
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s21, s10, s20
	v_mov_b16_e32 v32.l, v32.h
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_126
	buffer_load_u16 v33, v51, s[12:15], 0 offen offset:1572 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v32.l, v33.l
.LBB0_126:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s9, s9, s8
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s20, s10, s9
	s_and_saveexec_b32 s9, s20
	s_cbranch_execz .LBB0_128
	buffer_load_u16 v33, v51, s[12:15], 0 offen offset:1574 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v32.h, v33.l
.LBB0_128:
	s_or_b32 exec_lo, exec_lo, s9
	v_or_b32_e32 v34, 16, v45
	v_mov_b16_e32 v33.h, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_i32_e64 s9, 33, v34
	v_mov_b16_e32 v33.l, v33.h
	s_and_b32 s20, s9, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_130
	buffer_load_u16 v34, v51, s[12:15], 0 offen offset:2080 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v33.l, v34.l
.LBB0_130:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s20, s9, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_132
	buffer_load_u16 v34, v51, s[12:15], 0 offen offset:2082 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v33.h, v34.l
.LBB0_132:
	s_or_b32 exec_lo, exec_lo, s20
	v_mov_b16_e32 v34.h, 0
	s_and_b32 s20, s9, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s21, s10, s20
	v_mov_b16_e32 v34.l, v34.h
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_134
	buffer_load_u16 v35, v51, s[12:15], 0 offen offset:2084 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v34.l, v35.l
.LBB0_134:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s20, s9, s4
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_136
	buffer_load_u16 v35, v51, s[12:15], 0 offen offset:2086 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v34.h, v35.l
.LBB0_136:
	s_or_b32 exec_lo, exec_lo, s20
	v_mov_b16_e32 v35.h, 0
	s_and_b32 s20, s9, s5
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s21, s10, s20
	v_mov_b16_e32 v35.l, v35.h
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_138
	buffer_load_u16 v36, v51, s[12:15], 0 offen offset:2088 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v35.l, v36.l
.LBB0_138:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s20, s9, s6
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_140
	buffer_load_u16 v36, v51, s[12:15], 0 offen offset:2090 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v35.h, v36.l
.LBB0_140:
	s_or_b32 exec_lo, exec_lo, s20
	v_mov_b16_e32 v36.h, 0
	s_and_b32 s20, s9, s7
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s21, s10, s20
	v_mov_b16_e32 v36.l, v36.h
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_142
	buffer_load_u16 v37, v51, s[12:15], 0 offen offset:2092 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v36.l, v37.l
.LBB0_142:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s9, s9, s8
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s20, s10, s9
	s_and_saveexec_b32 s9, s20
	s_cbranch_execz .LBB0_144
	buffer_load_u16 v37, v51, s[12:15], 0 offen offset:2094 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v36.h, v37.l
.LBB0_144:
	s_or_b32 exec_lo, exec_lo, s9
	v_or_b32_e32 v38, 20, v45
	v_mov_b16_e32 v37.h, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_i32_e64 s9, 33, v38
	v_mov_b16_e32 v37.l, v37.h
	s_and_b32 s20, s9, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_146
	buffer_load_u16 v38, v51, s[12:15], 0 offen offset:2600 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v37.l, v38.l
.LBB0_146:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s20, s9, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_148
	buffer_load_u16 v38, v51, s[12:15], 0 offen offset:2602 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v37.h, v38.l
.LBB0_148:
	s_or_b32 exec_lo, exec_lo, s20
	v_mov_b16_e32 v38.h, 0
	s_and_b32 s20, s9, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s21, s10, s20
	v_mov_b16_e32 v38.l, v38.h
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_150
	buffer_load_u16 v39, v51, s[12:15], 0 offen offset:2604 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v38.l, v39.l
.LBB0_150:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s20, s9, s4
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_152
	buffer_load_u16 v39, v51, s[12:15], 0 offen offset:2606 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v38.h, v39.l
.LBB0_152:
	s_or_b32 exec_lo, exec_lo, s20
	v_mov_b16_e32 v39.h, 0
	s_and_b32 s20, s9, s5
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s21, s10, s20
	v_mov_b16_e32 v39.l, v39.h
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_154
	buffer_load_u16 v40, v51, s[12:15], 0 offen offset:2608 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v39.l, v40.l
.LBB0_154:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s20, s9, s6
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_156
	buffer_load_u16 v40, v51, s[12:15], 0 offen offset:2610 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v39.h, v40.l
.LBB0_156:
	s_or_b32 exec_lo, exec_lo, s20
	v_mov_b16_e32 v40.h, 0
	s_and_b32 s20, s9, s7
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s21, s10, s20
	v_mov_b16_e32 v40.l, v40.h
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_158
	buffer_load_u16 v41, v51, s[12:15], 0 offen offset:2612 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v40.l, v41.l
.LBB0_158:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s9, s9, s8
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s20, s10, s9
	s_and_saveexec_b32 s9, s20
	s_cbranch_execz .LBB0_160
	buffer_load_u16 v41, v51, s[12:15], 0 offen offset:2614 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v40.h, v41.l
.LBB0_160:
	s_or_b32 exec_lo, exec_lo, s9
	v_or_b32_e32 v42, 24, v45
	v_mov_b16_e32 v41.h, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_i32_e64 s9, 33, v42
	v_mov_b16_e32 v41.l, v41.h
	s_and_b32 s20, s9, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_162
	buffer_load_u16 v42, v51, s[12:15], 0 offen offset:3120 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v41.l, v42.l
.LBB0_162:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s20, s9, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_164
	buffer_load_u16 v42, v51, s[12:15], 0 offen offset:3122 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v41.h, v42.l
.LBB0_164:
	s_or_b32 exec_lo, exec_lo, s20
	v_mov_b16_e32 v42.h, 0
	s_and_b32 s20, s9, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s21, s10, s20
	v_mov_b16_e32 v42.l, v42.h
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_166
	buffer_load_u16 v43, v51, s[12:15], 0 offen offset:3124 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v42.l, v43.l
.LBB0_166:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s20, s9, s4
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_168
	buffer_load_u16 v43, v51, s[12:15], 0 offen offset:3126 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v42.h, v43.l
.LBB0_168:
	s_or_b32 exec_lo, exec_lo, s20
	v_mov_b16_e32 v43.h, 0
	s_and_b32 s20, s9, s5
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s21, s10, s20
	v_mov_b16_e32 v43.l, v43.h
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_170
	buffer_load_u16 v44, v51, s[12:15], 0 offen offset:3128 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v43.l, v44.l
.LBB0_170:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s20, s9, s6
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_172
	buffer_load_u16 v44, v51, s[12:15], 0 offen offset:3130 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v43.h, v44.l
.LBB0_172:
	s_or_b32 exec_lo, exec_lo, s20
	v_mov_b16_e32 v44.h, 0
	s_and_b32 s20, s9, s7
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s21, s10, s20
	v_mov_b16_e32 v44.l, v44.h
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_174
	buffer_load_u16 v46, v51, s[12:15], 0 offen offset:3132 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v44.l, v46.l
.LBB0_174:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s9, s9, s8
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s20, s10, s9
	s_and_saveexec_b32 s9, s20
	s_cbranch_execz .LBB0_176
	buffer_load_u16 v46, v51, s[12:15], 0 offen offset:3134 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v44.h, v46.l
.LBB0_176:
	s_or_b32 exec_lo, exec_lo, s9
	v_or_b32_e32 v46, 28, v45
	v_mov_b16_e32 v45.h, 0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_i32_e64 s9, 33, v46
	v_mov_b16_e32 v45.l, v45.h
	s_and_b32 s20, s9, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s21, s10, s20
	s_and_saveexec_b32 s20, s21
	s_cbranch_execz .LBB0_178
	buffer_load_u16 v46, v51, s[12:15], 0 offen offset:3640 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v45.l, v46.l
.LBB0_178:
	s_or_b32 exec_lo, exec_lo, s20
	s_and_b32 s2, s9, s2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s20, s10, s2
	s_and_saveexec_b32 s2, s20
	s_cbranch_execz .LBB0_180
	buffer_load_u16 v46, v51, s[12:15], 0 offen offset:3642 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v45.h, v46.l
.LBB0_180:
	s_or_b32 exec_lo, exec_lo, s2
	v_mov_b16_e32 v46.h, 0
	s_and_b32 s2, s9, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s3, s10, s2
	v_mov_b16_e32 v46.l, v46.h
	s_and_saveexec_b32 s2, s3
	s_cbranch_execz .LBB0_182
	buffer_load_u16 v47, v51, s[12:15], 0 offen offset:3644 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v46.l, v47.l
.LBB0_182:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s9, s4
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s3, s10, s2
	s_and_saveexec_b32 s2, s3
	s_cbranch_execz .LBB0_184
	buffer_load_u16 v47, v51, s[12:15], 0 offen offset:3646 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v46.h, v47.l
.LBB0_184:
	s_or_b32 exec_lo, exec_lo, s2
	v_mov_b16_e32 v47.h, 0
	s_and_b32 s2, s9, s5
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s3, s10, s2
	v_mov_b16_e32 v47.l, v47.h
	s_and_saveexec_b32 s2, s3
	s_cbranch_execz .LBB0_186
	buffer_load_u16 v48, v51, s[12:15], 0 offen offset:3648 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v47.l, v48.l
.LBB0_186:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s9, s6
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s3, s10, s2
	s_and_saveexec_b32 s2, s3
	s_cbranch_execz .LBB0_188
	buffer_load_u16 v48, v51, s[12:15], 0 offen offset:3650 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v47.h, v48.l
.LBB0_188:
	s_or_b32 exec_lo, exec_lo, s2
	v_mov_b16_e32 v48.h, 0
	s_and_b32 s2, s9, s7
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	s_and_b32 s3, s10, s2
	v_mov_b16_e32 v48.l, v48.h
	s_and_saveexec_b32 s2, s3
	s_cbranch_execz .LBB0_190
	buffer_load_u16 v52, v51, s[12:15], 0 offen offset:3652 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v48.l, v52.l
.LBB0_190:
	s_or_b32 exec_lo, exec_lo, s2
	s_and_b32 s2, s9, s8
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s3, s10, s2
	s_and_saveexec_b32 s2, s3
	s_cbranch_execz .LBB0_192
	buffer_load_u16 v51, v51, s[12:15], 0 offen offset:3654 slc
	s_waitcnt vmcnt(0)
	v_mov_b16_e32 v48.h, v51.l
.LBB0_192:
	s_or_b32 exec_lo, exec_lo, s2
	s_clause 0x1
	s_load_b64 s[2:3], s[0:1], 0x48
	s_load_b64 s[12:13], s[0:1], 0x58
	s_mov_b32 s4, 0
	s_lshl1_add_u32 s14, s17, s11
	s_mov_b32 s5, s4
	s_mov_b32 s6, s4
	s_mov_b32 s7, s4
	s_mov_b32 s8, s4
	s_mov_b32 s9, s4
	s_mov_b32 s10, s4
	s_mov_b32 s11, s4
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(VALU_DEP_2)
	v_dual_mov_b32 v97, s11 :: v_dual_lshlrev_b32 v50, 7, v50
	v_mov_b32_e32 v100, 1
	s_lshl_b32 s15, s14, 12
	s_lshl_b32 s18, s18, 10
	v_lshl_or_b32 v50, v49, 1, v50
	v_lshlrev_b32_e32 v49, 1, v131
	ds_store_b128 v50, v[17:20]
	ds_store_b128 v50, v[21:24] offset:512
	ds_store_b128 v50, v[25:28] offset:1024
	ds_store_b128 v50, v[29:32] offset:1536
	ds_store_b128 v50, v[33:36] offset:2048
	ds_store_b128 v50, v[37:40] offset:2560
	ds_store_b128 v50, v[41:44] offset:3072
	ds_store_b128 v50, v[45:48] offset:3584
	s_waitcnt lgkmcnt(0)
	ds_load_u16_d16 v20, v49 offset:608
	ds_load_u16_d16 v19, v49 offset:352
	ds_load_u16_d16 v28, v49 offset:576
	ds_load_u16_d16 v29, v49 offset:832
	ds_load_u16_d16 v36, v49 offset:512
	ds_load_u16_d16 v51, v49 offset:288
	ds_load_u16_d16 v68, v49 offset:2624
	ds_load_u16_d16 v69, v49 offset:2880
	v_dual_mov_b32 v96, s10 :: v_dual_lshlrev_b32 v17, 5, v0
	v_dual_mov_b32 v95, s9 :: v_dual_mov_b32 v94, s8
	v_dual_mov_b32 v93, s7 :: v_dual_mov_b32 v92, s6
	v_dual_mov_b32 v91, s5 :: v_dual_mov_b32 v90, s4
	s_add_i32 s4, s15, s18
	ds_load_u16_d16 v30, v49 offset:1088
	ds_load_u16_d16 v31, v49 offset:1344
	ds_load_u16_d16 v32, v49 offset:1600
	ds_load_u16_d16 v33, v49 offset:1856
	s_waitcnt lgkmcnt(10)
	ds_load_u16_d16_hi v19, v49 offset:480
	ds_load_u16_d16 v37, v49 offset:768
	s_waitcnt lgkmcnt(11)
	ds_load_u16_d16_hi v28, v49 offset:704
	ds_load_u16_d16 v52, v49 offset:544
	ds_load_u16_d16 v35, v49 offset:256
	ds_load_u16_d16 v27, v49 offset:320
	ds_load_u16_d16 v34, v49
	ds_load_u16_d16 v50, v49 offset:32
	ds_load_u16_d16 v26, v49 offset:64
	ds_load_u16_d16 v18, v49 offset:96
	ds_load_u16_d16 v38, v49 offset:1024
	ds_load_u16_d16 v53, v49 offset:800
	s_waitcnt lgkmcnt(20)
	ds_load_u16_d16_hi v29, v49 offset:960
	ds_load_u16_d16 v21, v49 offset:864
	ds_load_u16_d16 v39, v49 offset:1280
	ds_load_u16_d16 v54, v49 offset:1056
	v_or_b32_e32 v98, s4, v17
	s_mov_b32 s4, exec_lo
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v30, v49 offset:1216
	ds_load_u16_d16 v22, v49 offset:1120
	ds_load_u16_d16 v40, v49 offset:1536
	ds_load_u16_d16 v55, v49 offset:1312
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v31, v49 offset:1472
	ds_load_u16_d16 v23, v49 offset:1376
	ds_load_u16_d16 v41, v49 offset:1792
	ds_load_u16_d16 v56, v49 offset:1568
	s_waitcnt lgkmcnt(25)
	ds_load_u16_d16_hi v32, v49 offset:1728
	ds_load_u16_d16 v24, v49 offset:1632
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v34, v49 offset:128
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v50, v49 offset:160
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v26, v49 offset:192
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v18, v49 offset:224
	ds_load_u16_d16 v57, v49 offset:1824
	ds_load_u16_d16_hi v33, v49 offset:1984
	ds_load_u16_d16 v58, v49 offset:2048
	ds_load_u16_d16 v66, v49 offset:2112
	ds_load_u16_d16 v25, v49 offset:1888
	ds_load_u16_d16_hi v36, v49 offset:640
	ds_load_u16_d16_hi v35, v49 offset:384
	ds_load_u16_d16_hi v51, v49 offset:416
	ds_load_u16_d16_hi v27, v49 offset:448
	ds_load_u16_d16_hi v37, v49 offset:896
	ds_load_u16_d16_hi v52, v49 offset:672
	ds_load_u16_d16_hi v20, v49 offset:736
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v38, v49 offset:1152
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v53, v49 offset:928
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v21, v49 offset:992
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v39, v49 offset:1408
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v54, v49 offset:1184
	s_waitcnt lgkmcnt(29)
	ds_load_u16_d16_hi v22, v49 offset:1248
	s_waitcnt lgkmcnt(29)
	ds_load_u16_d16_hi v40, v49 offset:1664
	s_waitcnt lgkmcnt(29)
	ds_load_u16_d16_hi v55, v49 offset:1440
	s_waitcnt lgkmcnt(28)
	ds_load_u16_d16_hi v23, v49 offset:1504
	s_waitcnt lgkmcnt(28)
	ds_load_u16_d16_hi v41, v49 offset:1920
	s_waitcnt lgkmcnt(28)
	ds_load_u16_d16_hi v56, v49 offset:1696
	s_waitcnt lgkmcnt(27)
	ds_load_u16_d16_hi v24, v49 offset:1760
	v_ashrrev_i32_e32 v99, 31, v98
	s_waitcnt lgkmcnt(23)
	ds_load_u16_d16_hi v57, v49 offset:1952
	s_waitcnt lgkmcnt(20)
	ds_load_u16_d16_hi v25, v49 offset:2016
	ds_load_u16_d16 v59, v49 offset:2304
	ds_load_u16_d16 v74, v49 offset:2080
	ds_load_u16_d16_hi v58, v49 offset:2176
	ds_load_u16_d16 v67, v49 offset:2368
	ds_load_u16_d16_hi v66, v49 offset:2240
	ds_load_u16_d16 v82, v49 offset:2144
	ds_load_u16_d16 v81, v49 offset:3872
	ds_load_u16_d16 v70, v49 offset:3136
	ds_load_u16_d16 v71, v49 offset:3392
	ds_load_u16_d16 v72, v49 offset:3648
	ds_load_u16_d16 v73, v49 offset:3904
	ds_load_u16_d16 v60, v49 offset:2560
	s_waitcnt lgkmcnt(11)
	ds_load_u16_d16_hi v59, v49 offset:2432
	s_waitcnt lgkmcnt(11)
	ds_load_u16_d16_hi v74, v49 offset:2208
	ds_load_u16_d16 v75, v49 offset:2336
	s_waitcnt lgkmcnt(11)
	ds_load_u16_d16_hi v67, v49 offset:2496
	ds_load_u16_d16 v83, v49 offset:2400
	s_waitcnt lgkmcnt(11)
	ds_load_u16_d16_hi v82, v49 offset:2272
	ds_load_u16_d16 v61, v49 offset:2816
	ds_load_u16_d16 v76, v49 offset:2592
	ds_load_u16_d16_hi v68, v49 offset:2752
	ds_load_u16_d16 v84, v49 offset:2656
	ds_load_u16_d16 v62, v49 offset:3072
	ds_load_u16_d16 v77, v49 offset:2848
	ds_load_u16_d16_hi v69, v49 offset:3008
	ds_load_u16_d16 v85, v49 offset:2912
	ds_load_u16_d16 v63, v49 offset:3328
	ds_load_u16_d16 v78, v49 offset:3104
	s_waitcnt lgkmcnt(20)
	ds_load_u16_d16_hi v70, v49 offset:3264
	ds_load_u16_d16 v86, v49 offset:3168
	ds_load_u16_d16 v64, v49 offset:3584
	ds_load_u16_d16 v79, v49 offset:3360
	s_waitcnt lgkmcnt(23)
	ds_load_u16_d16_hi v71, v49 offset:3520
	ds_load_u16_d16 v87, v49 offset:3424
	ds_load_u16_d16 v65, v49 offset:3840
	ds_load_u16_d16 v80, v49 offset:3616
	s_waitcnt lgkmcnt(26)
	ds_load_u16_d16_hi v72, v49 offset:3776
	ds_load_u16_d16 v88, v49 offset:3680
	s_waitcnt lgkmcnt(26)
	ds_load_u16_d16_hi v60, v49 offset:2688
	s_waitcnt lgkmcnt(24)
	ds_load_u16_d16_hi v75, v49 offset:2464
	s_waitcnt lgkmcnt(23)
	ds_load_u16_d16_hi v83, v49 offset:2528
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v61, v49 offset:2944
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v76, v49 offset:2720
	s_waitcnt lgkmcnt(21)
	ds_load_u16_d16_hi v84, v49 offset:2784
	ds_load_u16_d16_hi v73, v49 offset:4032
	ds_load_u16_d16 v89, v49 offset:3936
	s_waitcnt lgkmcnt(23)
	ds_load_u16_d16_hi v62, v49 offset:3200
	s_waitcnt lgkmcnt(23)
	ds_load_u16_d16_hi v77, v49 offset:2976
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v85, v49 offset:3040
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v63, v49 offset:3456
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v78, v49 offset:3232
	s_waitcnt lgkmcnt(21)
	ds_load_u16_d16_hi v86, v49 offset:3296
	s_waitcnt lgkmcnt(21)
	ds_load_u16_d16_hi v64, v49 offset:3712
	s_waitcnt lgkmcnt(21)
	ds_load_u16_d16_hi v79, v49 offset:3488
	s_waitcnt lgkmcnt(20)
	ds_load_u16_d16_hi v87, v49 offset:3552
	s_waitcnt lgkmcnt(20)
	ds_load_u16_d16_hi v65, v49 offset:3968
	s_waitcnt lgkmcnt(20)
	ds_load_u16_d16_hi v80, v49 offset:3744
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v88, v49 offset:3808
	ds_load_u16_d16_hi v81, v49 offset:4000
	s_waitcnt lgkmcnt(13)
	ds_load_u16_d16_hi v89, v49 offset:4064
	v_wmma_f32_16x16x16_bf16 v[42:49], v[1:8], v[34:41], v[90:97]
	v_wmma_f32_16x16x16_bf16 v[34:41], v[1:8], v[50:57], v[90:97]
	v_wmma_f32_16x16x16_bf16 v[50:57], v[1:8], v[26:33], v[90:97]
	v_wmma_f32_16x16x16_bf16 v[90:97], v[1:8], v[18:25], v[90:97]
	v_lshl_or_b32 v1, s14, 5, v0
	v_lshlrev_b64 v[3:4], 2, v[98:99]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[42:49], v[9:16], v[58:65], v[42:49]
	v_wmma_f32_16x16x16_bf16 v[50:57], v[9:16], v[66:73], v[50:57]
	s_waitcnt lgkmcnt(1)
	v_wmma_f32_16x16x16_bf16 v[34:41], v[9:16], v[74:81], v[34:41]
	v_ashrrev_i32_e32 v2, 31, v1
	v_add_co_u32 v3, vcc_lo, s2, v3
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_add_co_ci_u32_e64 v4, null, s3, v4, vcc_lo
	v_lshlrev_b64 v[1:2], 2, v[1:2]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[90:97], v[9:16], v[82:89], v[90:97]
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v129, vcc_lo, s12, v1
	v_add_co_ci_u32_e64 v130, null, s13, v2, vcc_lo
	s_clause 0x7
	global_store_b128 v[3:4], v[46:49], off offset:16
	global_store_b128 v[3:4], v[42:45], off
	global_store_b128 v[3:4], v[38:41], off offset:48
	global_store_b128 v[3:4], v[34:37], off offset:32
	global_store_b128 v[3:4], v[54:57], off offset:80
	global_store_b128 v[3:4], v[50:53], off offset:64
	global_store_b128 v[3:4], v[94:97], off offset:112
	global_store_b128 v[3:4], v[90:93], off offset:96
	s_waitcnt_vscnt null, 0x0
	global_atomic_add_u32 v1, v[129:130], v100, off glc
	s_waitcnt vmcnt(0)
	buffer_gl1_inv
	buffer_gl0_inv
	v_cmpx_eq_u32_e32 3, v1
	s_cbranch_execz .LBB0_258
	v_or_b32_e32 v1, s15, v17
	s_clause 0x1
	s_load_b128 s[12:15], s[0:1], 0x30
	s_load_b32 s0, s[0:1], 0x40
	s_mulk_i32 s17, 0x410
	v_lshrrev_b32_e32 v0, 4, v0
	s_add_i32 s1, s19, s17
	v_ashrrev_i32_e32 v2, 31, v1
	v_or_b32_e32 v133, s1, v131
	v_or_b32_e32 v131, s19, v131
	v_or_b32_e32 v132, s16, v0
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_lshlrev_b64 v[1:2], 2, v[1:2]
	v_mad_u32_u24 v0, 0x41, v0, v133
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cmp_gt_i32_e64 s7, 0x41, v131
	v_lshlrev_b32_e32 v0, 1, v0
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v13, vcc_lo, s2, v1
	v_add_co_ci_u32_e64 v14, null, s3, v2, vcc_lo
	s_waitcnt lgkmcnt(0)
	s_add_i32 s1, s14, -1
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v5, vcc_lo, 0x1000, v13
	v_add_co_ci_u32_e64 v6, null, 0, v14, vcc_lo
	v_add_co_u32 v7, vcc_lo, v13, 0x2000
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v8, null, 0, v14, vcc_lo
	v_add_co_u32 v9, vcc_lo, 0x1040, v13
	v_add_co_ci_u32_e64 v10, null, 0, v14, vcc_lo
	v_add_co_u32 v15, vcc_lo, 0x2000, v13
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v16, null, 0, v14, vcc_lo
	v_add_co_u32 v29, vcc_lo, 0x2040, v13
	v_add_co_ci_u32_e64 v30, null, 0, v14, vcc_lo
	v_add_co_u32 v45, vcc_lo, 0x3000, v13
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v46, null, 0, v14, vcc_lo
	v_add_co_u32 v47, vcc_lo, 0x3040, v13
	v_add_co_ci_u32_e64 v48, null, 0, v14, vcc_lo
	s_clause 0x1f
	global_load_b128 v[65:68], v[13:14], off offset:48
	global_load_b128 v[81:84], v[13:14], off offset:32
	global_load_b128 v[97:100], v[13:14], off offset:16
	global_load_b128 v[113:116], v[13:14], off
	global_load_b128 v[1:4], v[13:14], off offset:112
	global_load_b128 v[17:20], v[13:14], off offset:96
	global_load_b128 v[33:36], v[13:14], off offset:80
	global_load_b128 v[49:52], v[13:14], off offset:64
	global_load_b128 v[85:88], v[5:6], off offset:32
	global_load_b128 v[101:104], v[5:6], off offset:16
	global_load_b128 v[69:72], v[5:6], off offset:48
	global_load_b128 v[53:56], v[5:6], off offset:64
	global_load_b128 v[21:24], v[9:10], off offset:32
	global_load_b128 v[37:40], v[9:10], off offset:16
	global_load_b128 v[117:120], v[7:8], off offset:-4096
	global_load_b128 v[121:124], v[7:8], off
	global_load_b128 v[73:76], v[15:16], off offset:48
	global_load_b128 v[89:92], v[15:16], off offset:32
	global_load_b128 v[5:8], v[9:10], off offset:48
	global_load_b128 v[105:108], v[15:16], off offset:16
	global_load_b128 v[9:12], v[29:30], off offset:48
	global_load_b128 v[25:28], v[29:30], off offset:32
	global_load_b128 v[57:60], v[15:16], off offset:64
	global_load_b128 v[41:44], v[29:30], off offset:16
	global_load_b128 v[77:80], v[45:46], off offset:48
	global_load_b128 v[93:96], v[45:46], off offset:32
	global_load_b128 v[125:128], v[45:46], off
	global_load_b128 v[109:112], v[45:46], off offset:16
	global_load_b128 v[13:16], v[47:48], off offset:48
	global_load_b128 v[29:32], v[47:48], off offset:32
	global_load_b128 v[61:64], v[45:46], off offset:64
	global_load_b128 v[45:48], v[47:48], off offset:16
	v_cmp_gt_i32_e32 vcc_lo, 17, v132
	s_mul_i32 s0, s0, s1
	s_and_b32 s13, s13, 0xffff
	s_add_i32 s0, s15, s0
	s_mov_b32 s15, 0x31027000
	s_lshl_b32 s14, s0, 1
	s_and_b32 s0, vcc_lo, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s1, s0
	s_cbranch_execz .LBB0_195
	s_waitcnt vmcnt(28)
	v_add_f32_e32 v113, 0, v113
	s_waitcnt vmcnt(17)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v113, v113, v117
	s_waitcnt vmcnt(16)
	v_add_f32_e32 v113, v113, v121
	s_waitcnt vmcnt(5)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v113, v113, v125
	v_bfe_u32 v117, v113, 16, 1
	v_or_b32_e32 v121, 0x400000, v113
	v_cmp_u_f32_e64 s0, v113, v113
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v117, v117, v113, 0x7fff
	v_cndmask_b32_e64 v113, v117, v121, s0
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v113, 16, v113
	buffer_store_b16 v113, v0, s[12:15], 0 offen
.LBB0_195:
	s_or_b32 exec_lo, exec_lo, s1
	s_waitcnt vmcnt(28)
	v_or_b32_e32 v113, 2, v132
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_cmp_gt_i32_e64 s0, 17, v113
	s_and_b32 s1, s0, s7
	s_and_saveexec_b32 s2, s1
	s_cbranch_execz .LBB0_197
	v_add_f32_e32 v113, 0, v114
	s_waitcnt vmcnt(17)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v113, v113, v118
	s_waitcnt vmcnt(16)
	v_add_f32_e32 v113, v113, v122
	s_waitcnt vmcnt(5)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v113, v113, v126
	v_bfe_u32 v114, v113, 16, 1
	v_or_b32_e32 v117, 0x400000, v113
	v_cmp_u_f32_e64 s1, v113, v113
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v114, v114, v113, 0x7fff
	v_cndmask_b32_e64 v113, v114, v117, s1
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v113, 16, v113
	buffer_store_b16 v113, v0, s[12:15], 0 offen offset:260
.LBB0_197:
	s_or_b32 exec_lo, exec_lo, s2
	v_or_b32_e32 v113, 4, v132
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_cmp_gt_i32_e64 s1, 17, v113
	s_and_b32 s2, s1, s7
	s_and_saveexec_b32 s3, s2
	s_cbranch_execz .LBB0_199
	v_add_f32_e32 v113, 0, v115
	s_waitcnt vmcnt(17)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v113, v113, v119
	s_waitcnt vmcnt(16)
	v_add_f32_e32 v113, v113, v123
	s_waitcnt vmcnt(5)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v113, v113, v127
	v_bfe_u32 v114, v113, 16, 1
	v_or_b32_e32 v115, 0x400000, v113
	v_cmp_u_f32_e64 s2, v113, v113
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v114, v114, v113, 0x7fff
	v_cndmask_b32_e64 v113, v114, v115, s2
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v113, 16, v113
	buffer_store_b16 v113, v0, s[12:15], 0 offen offset:520
.LBB0_199:
	s_or_b32 exec_lo, exec_lo, s3
	v_or_b32_e32 v113, 6, v132
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_cmp_gt_i32_e64 s2, 17, v113
	s_and_b32 s3, s2, s7
	s_and_saveexec_b32 s4, s3
	s_cbranch_execz .LBB0_201
	v_add_f32_e32 v113, 0, v116
	s_waitcnt vmcnt(17)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v113, v113, v120
	s_waitcnt vmcnt(16)
	v_add_f32_e32 v113, v113, v124
	s_waitcnt vmcnt(5)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v113, v113, v128
	v_bfe_u32 v114, v113, 16, 1
	v_or_b32_e32 v115, 0x400000, v113
	v_cmp_u_f32_e64 s3, v113, v113
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v114, v114, v113, 0x7fff
	v_cndmask_b32_e64 v113, v114, v115, s3
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v113, 16, v113
	buffer_store_b16 v113, v0, s[12:15], 0 offen offset:780
.LBB0_201:
	s_or_b32 exec_lo, exec_lo, s4
	v_or_b32_e32 v113, 8, v132
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_cmp_gt_i32_e64 s3, 17, v113
	s_and_b32 s4, s3, s7
	s_and_saveexec_b32 s5, s4
	s_cbranch_execz .LBB0_203
	v_add_f32_e32 v97, 0, v97
	s_waitcnt vmcnt(22)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v97, v97, v101
	s_waitcnt vmcnt(12)
	v_add_f32_e32 v97, v97, v105
	s_waitcnt vmcnt(4)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v97, v97, v109
	v_bfe_u32 v101, v97, 16, 1
	v_or_b32_e32 v105, 0x400000, v97
	v_cmp_u_f32_e64 s4, v97, v97
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v101, v101, v97, 0x7fff
	v_cndmask_b32_e64 v97, v101, v105, s4
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v97, 16, v97
	buffer_store_b16 v97, v0, s[12:15], 0 offen offset:1040
.LBB0_203:
	s_or_b32 exec_lo, exec_lo, s5
	v_or_b32_e32 v97, 10, v132
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_cmp_gt_i32_e64 s4, 17, v97
	s_and_b32 s5, s4, s7
	s_and_saveexec_b32 s6, s5
	s_cbranch_execz .LBB0_205
	v_add_f32_e32 v97, 0, v98
	s_waitcnt vmcnt(22)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v97, v97, v102
	s_waitcnt vmcnt(12)
	v_add_f32_e32 v97, v97, v106
	s_waitcnt vmcnt(4)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v97, v97, v110
	v_bfe_u32 v98, v97, 16, 1
	v_or_b32_e32 v101, 0x400000, v97
	v_cmp_u_f32_e64 s5, v97, v97
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v98, v98, v97, 0x7fff
	v_cndmask_b32_e64 v97, v98, v101, s5
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v97, 16, v97
	buffer_store_b16 v97, v0, s[12:15], 0 offen offset:1300
.LBB0_205:
	s_or_b32 exec_lo, exec_lo, s6
	v_or_b32_e32 v97, 12, v132
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_cmp_gt_i32_e64 s5, 17, v97
	s_and_b32 s6, s5, s7
	s_and_saveexec_b32 s8, s6
	s_cbranch_execz .LBB0_207
	v_add_f32_e32 v97, 0, v99
	s_waitcnt vmcnt(22)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v97, v97, v103
	s_waitcnt vmcnt(12)
	v_add_f32_e32 v97, v97, v107
	s_waitcnt vmcnt(4)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v97, v97, v111
	v_bfe_u32 v98, v97, 16, 1
	v_or_b32_e32 v99, 0x400000, v97
	v_cmp_u_f32_e64 s6, v97, v97
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v98, v98, v97, 0x7fff
	v_cndmask_b32_e64 v97, v98, v99, s6
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v97, 16, v97
	buffer_store_b16 v97, v0, s[12:15], 0 offen offset:1560
.LBB0_207:
	s_or_b32 exec_lo, exec_lo, s8
	v_or_b32_e32 v97, 14, v132
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	v_cmp_gt_i32_e64 s6, 17, v97
	s_and_b32 s7, s6, s7
	s_and_saveexec_b32 s8, s7
	s_cbranch_execz .LBB0_209
	v_add_f32_e32 v97, 0, v100
	s_waitcnt vmcnt(22)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v97, v97, v104
	s_waitcnt vmcnt(12)
	v_add_f32_e32 v97, v97, v108
	s_waitcnt vmcnt(4)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v97, v97, v112
	v_bfe_u32 v98, v97, 16, 1
	v_or_b32_e32 v99, 0x400000, v97
	v_cmp_u_f32_e64 s7, v97, v97
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v98, v98, v97, 0x7fff
	v_cndmask_b32_e64 v97, v98, v99, s7
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v97, 16, v97
	buffer_store_b16 v97, v0, s[12:15], 0 offen offset:1820
.LBB0_209:
	s_or_b32 exec_lo, exec_lo, s8
	v_cmp_gt_i32_e64 s7, 49, v131
	s_and_b32 s8, vcc_lo, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s9, s8
	s_cbranch_execz .LBB0_211
	v_add_f32_e32 v81, 0, v81
	s_waitcnt vmcnt(23)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v81, v81, v85
	s_waitcnt vmcnt(14)
	v_add_f32_e32 v81, v81, v89
	s_waitcnt vmcnt(6)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v81, v81, v93
	v_bfe_u32 v85, v81, 16, 1
	v_or_b32_e32 v89, 0x400000, v81
	v_cmp_u_f32_e64 s8, v81, v81
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v85, v85, v81, 0x7fff
	v_cndmask_b32_e64 v81, v85, v89, s8
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v81, 16, v81
	buffer_store_b16 v81, v0, s[12:15], 0 offen offset:32
.LBB0_211:
	s_or_b32 exec_lo, exec_lo, s9
	s_and_b32 s8, s0, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s9, s8
	s_cbranch_execz .LBB0_213
	v_add_f32_e32 v81, 0, v82
	s_waitcnt vmcnt(23)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v81, v81, v86
	s_waitcnt vmcnt(14)
	v_add_f32_e32 v81, v81, v90
	s_waitcnt vmcnt(6)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v81, v81, v94
	v_bfe_u32 v82, v81, 16, 1
	v_or_b32_e32 v85, 0x400000, v81
	v_cmp_u_f32_e64 s8, v81, v81
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v82, v82, v81, 0x7fff
	v_cndmask_b32_e64 v81, v82, v85, s8
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v81, 16, v81
	buffer_store_b16 v81, v0, s[12:15], 0 offen offset:292
.LBB0_213:
	s_or_b32 exec_lo, exec_lo, s9
	s_and_b32 s8, s1, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s9, s8
	s_cbranch_execz .LBB0_215
	v_add_f32_e32 v81, 0, v83
	s_waitcnt vmcnt(23)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v81, v81, v87
	s_waitcnt vmcnt(14)
	v_add_f32_e32 v81, v81, v91
	s_waitcnt vmcnt(6)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v81, v81, v95
	v_bfe_u32 v82, v81, 16, 1
	v_or_b32_e32 v83, 0x400000, v81
	v_cmp_u_f32_e64 s8, v81, v81
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v82, v82, v81, 0x7fff
	v_cndmask_b32_e64 v81, v82, v83, s8
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v81, 16, v81
	buffer_store_b16 v81, v0, s[12:15], 0 offen offset:552
.LBB0_215:
	s_or_b32 exec_lo, exec_lo, s9
	s_and_b32 s8, s2, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s9, s8
	s_cbranch_execz .LBB0_217
	v_add_f32_e32 v81, 0, v84
	s_waitcnt vmcnt(23)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v81, v81, v88
	s_waitcnt vmcnt(14)
	v_add_f32_e32 v81, v81, v92
	s_waitcnt vmcnt(6)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v81, v81, v96
	v_bfe_u32 v82, v81, 16, 1
	v_or_b32_e32 v83, 0x400000, v81
	v_cmp_u_f32_e64 s8, v81, v81
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v82, v82, v81, 0x7fff
	v_cndmask_b32_e64 v81, v82, v83, s8
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v81, 16, v81
	buffer_store_b16 v81, v0, s[12:15], 0 offen offset:812
.LBB0_217:
	s_or_b32 exec_lo, exec_lo, s9
	s_and_b32 s8, s3, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s9, s8
	s_cbranch_execz .LBB0_219
	v_add_f32_e32 v65, 0, v65
	s_waitcnt vmcnt(21)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v65, v65, v69
	s_waitcnt vmcnt(15)
	v_add_f32_e32 v65, v65, v73
	s_waitcnt vmcnt(7)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v65, v65, v77
	v_bfe_u32 v69, v65, 16, 1
	v_or_b32_e32 v73, 0x400000, v65
	v_cmp_u_f32_e64 s8, v65, v65
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v69, v69, v65, 0x7fff
	v_cndmask_b32_e64 v65, v69, v73, s8
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v65, 16, v65
	buffer_store_b16 v65, v0, s[12:15], 0 offen offset:1072
.LBB0_219:
	s_or_b32 exec_lo, exec_lo, s9
	s_and_b32 s8, s4, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s9, s8
	s_cbranch_execz .LBB0_221
	v_add_f32_e32 v65, 0, v66
	s_waitcnt vmcnt(21)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v65, v65, v70
	s_waitcnt vmcnt(15)
	v_add_f32_e32 v65, v65, v74
	s_waitcnt vmcnt(7)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v65, v65, v78
	v_bfe_u32 v66, v65, 16, 1
	v_or_b32_e32 v69, 0x400000, v65
	v_cmp_u_f32_e64 s8, v65, v65
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v66, v66, v65, 0x7fff
	v_cndmask_b32_e64 v65, v66, v69, s8
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v65, 16, v65
	buffer_store_b16 v65, v0, s[12:15], 0 offen offset:1332
.LBB0_221:
	s_or_b32 exec_lo, exec_lo, s9
	s_and_b32 s8, s5, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s9, s8
	s_cbranch_execz .LBB0_223
	v_add_f32_e32 v65, 0, v67
	s_waitcnt vmcnt(21)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v65, v65, v71
	s_waitcnt vmcnt(15)
	v_add_f32_e32 v65, v65, v75
	s_waitcnt vmcnt(7)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v65, v65, v79
	v_bfe_u32 v66, v65, 16, 1
	v_or_b32_e32 v67, 0x400000, v65
	v_cmp_u_f32_e64 s8, v65, v65
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v66, v66, v65, 0x7fff
	v_cndmask_b32_e64 v65, v66, v67, s8
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v65, 16, v65
	buffer_store_b16 v65, v0, s[12:15], 0 offen offset:1592
.LBB0_223:
	s_or_b32 exec_lo, exec_lo, s9
	s_and_b32 s7, s6, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s8, s7
	s_cbranch_execz .LBB0_225
	v_add_f32_e32 v65, 0, v68
	s_waitcnt vmcnt(21)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v65, v65, v72
	s_waitcnt vmcnt(15)
	v_add_f32_e32 v65, v65, v76
	s_waitcnt vmcnt(7)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v65, v65, v80
	v_bfe_u32 v66, v65, 16, 1
	v_or_b32_e32 v67, 0x400000, v65
	v_cmp_u_f32_e64 s7, v65, v65
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v66, v66, v65, 0x7fff
	v_cndmask_b32_e64 v65, v66, v67, s7
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v65, 16, v65
	buffer_store_b16 v65, v0, s[12:15], 0 offen offset:1852
.LBB0_225:
	s_or_b32 exec_lo, exec_lo, s8
	v_cmp_gt_i32_e64 s7, 33, v131
	s_and_b32 s8, vcc_lo, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s9, s8
	s_cbranch_execz .LBB0_227
	s_waitcnt vmcnt(24)
	v_add_f32_e32 v49, 0, v49
	s_waitcnt vmcnt(20)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v49, v49, v53
	s_waitcnt vmcnt(9)
	v_add_f32_e32 v49, v49, v57
	s_waitcnt vmcnt(1)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v49, v49, v61
	v_bfe_u32 v53, v49, 16, 1
	v_or_b32_e32 v57, 0x400000, v49
	v_cmp_u_f32_e64 s8, v49, v49
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v53, v53, v49, 0x7fff
	v_cndmask_b32_e64 v49, v53, v57, s8
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v49, 16, v49
	buffer_store_b16 v49, v0, s[12:15], 0 offen offset:64
.LBB0_227:
	s_or_b32 exec_lo, exec_lo, s9
	s_and_b32 s8, s0, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s9, s8
	s_cbranch_execz .LBB0_229
	s_waitcnt vmcnt(24)
	v_add_f32_e32 v49, 0, v50
	s_waitcnt vmcnt(20)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v49, v49, v54
	s_waitcnt vmcnt(9)
	v_add_f32_e32 v49, v49, v58
	s_waitcnt vmcnt(1)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v49, v49, v62
	v_bfe_u32 v50, v49, 16, 1
	v_or_b32_e32 v53, 0x400000, v49
	v_cmp_u_f32_e64 s8, v49, v49
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v50, v50, v49, 0x7fff
	v_cndmask_b32_e64 v49, v50, v53, s8
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v49, 16, v49
	buffer_store_b16 v49, v0, s[12:15], 0 offen offset:324
.LBB0_229:
	s_or_b32 exec_lo, exec_lo, s9
	s_and_b32 s8, s1, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s9, s8
	s_cbranch_execz .LBB0_231
	s_waitcnt vmcnt(24)
	v_add_f32_e32 v49, 0, v51
	s_waitcnt vmcnt(20)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v49, v49, v55
	s_waitcnt vmcnt(9)
	v_add_f32_e32 v49, v49, v59
	s_waitcnt vmcnt(1)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v49, v49, v63
	v_bfe_u32 v50, v49, 16, 1
	v_or_b32_e32 v51, 0x400000, v49
	v_cmp_u_f32_e64 s8, v49, v49
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v50, v50, v49, 0x7fff
	v_cndmask_b32_e64 v49, v50, v51, s8
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v49, 16, v49
	buffer_store_b16 v49, v0, s[12:15], 0 offen offset:584
.LBB0_231:
	s_or_b32 exec_lo, exec_lo, s9
	s_and_b32 s8, s2, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s9, s8
	s_cbranch_execz .LBB0_233
	s_waitcnt vmcnt(24)
	v_add_f32_e32 v49, 0, v52
	s_waitcnt vmcnt(20)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v49, v49, v56
	s_waitcnt vmcnt(9)
	v_add_f32_e32 v49, v49, v60
	s_waitcnt vmcnt(1)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v49, v49, v64
	v_bfe_u32 v50, v49, 16, 1
	v_or_b32_e32 v51, 0x400000, v49
	v_cmp_u_f32_e64 s8, v49, v49
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v50, v50, v49, 0x7fff
	v_cndmask_b32_e64 v49, v50, v51, s8
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v49, 16, v49
	buffer_store_b16 v49, v0, s[12:15], 0 offen offset:844
.LBB0_233:
	s_or_b32 exec_lo, exec_lo, s9
	s_and_b32 s8, s3, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s9, s8
	s_cbranch_execz .LBB0_235
	s_waitcnt vmcnt(25)
	v_add_f32_e32 v33, 0, v33
	s_waitcnt vmcnt(18)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v33, v33, v37
	s_waitcnt vmcnt(8)
	v_add_f32_e32 v33, v33, v41
	s_waitcnt vmcnt(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v33, v33, v45
	v_bfe_u32 v37, v33, 16, 1
	v_or_b32_e32 v41, 0x400000, v33
	v_cmp_u_f32_e64 s8, v33, v33
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v37, v37, v33, 0x7fff
	v_cndmask_b32_e64 v33, v37, v41, s8
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v33, 16, v33
	buffer_store_b16 v33, v0, s[12:15], 0 offen offset:1104
.LBB0_235:
	s_or_b32 exec_lo, exec_lo, s9
	s_and_b32 s8, s4, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s9, s8
	s_cbranch_execz .LBB0_237
	s_waitcnt vmcnt(25)
	v_add_f32_e32 v33, 0, v34
	s_waitcnt vmcnt(18)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v33, v33, v38
	s_waitcnt vmcnt(8)
	v_add_f32_e32 v33, v33, v42
	s_waitcnt vmcnt(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v33, v33, v46
	v_bfe_u32 v34, v33, 16, 1
	v_or_b32_e32 v37, 0x400000, v33
	v_cmp_u_f32_e64 s8, v33, v33
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v34, v34, v33, 0x7fff
	v_cndmask_b32_e64 v33, v34, v37, s8
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v33, 16, v33
	buffer_store_b16 v33, v0, s[12:15], 0 offen offset:1364
.LBB0_237:
	s_or_b32 exec_lo, exec_lo, s9
	s_and_b32 s8, s5, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s9, s8
	s_cbranch_execz .LBB0_239
	s_waitcnt vmcnt(25)
	v_add_f32_e32 v33, 0, v35
	s_waitcnt vmcnt(18)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v33, v33, v39
	s_waitcnt vmcnt(8)
	v_add_f32_e32 v33, v33, v43
	s_waitcnt vmcnt(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v33, v33, v47
	v_bfe_u32 v34, v33, 16, 1
	v_or_b32_e32 v35, 0x400000, v33
	v_cmp_u_f32_e64 s8, v33, v33
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v34, v34, v33, 0x7fff
	v_cndmask_b32_e64 v33, v34, v35, s8
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v33, 16, v33
	buffer_store_b16 v33, v0, s[12:15], 0 offen offset:1624
.LBB0_239:
	s_or_b32 exec_lo, exec_lo, s9
	s_and_b32 s7, s6, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s8, s7
	s_cbranch_execz .LBB0_241
	s_waitcnt vmcnt(25)
	v_add_f32_e32 v33, 0, v36
	s_waitcnt vmcnt(18)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v33, v33, v40
	s_waitcnt vmcnt(8)
	v_add_f32_e32 v33, v33, v44
	s_waitcnt vmcnt(0)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v33, v33, v48
	v_bfe_u32 v34, v33, 16, 1
	v_or_b32_e32 v35, 0x400000, v33
	v_cmp_u_f32_e64 s7, v33, v33
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v34, v34, v33, 0x7fff
	v_cndmask_b32_e64 v33, v34, v35, s7
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v33, 16, v33
	buffer_store_b16 v33, v0, s[12:15], 0 offen offset:1884
.LBB0_241:
	s_or_b32 exec_lo, exec_lo, s8
	v_cmp_gt_i32_e64 s7, 17, v131
	s_and_b32 s9, vcc_lo, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s8, s9
	s_cbranch_execz .LBB0_243
	s_waitcnt vmcnt(26)
	v_add_f32_e32 v17, 0, v17
	s_waitcnt vmcnt(19)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v17, v17, v21
	s_waitcnt vmcnt(10)
	v_add_f32_e32 v17, v17, v25
	s_waitcnt vmcnt(2)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v17, v17, v29
	v_bfe_u32 v21, v17, 16, 1
	v_or_b32_e32 v25, 0x400000, v17
	v_cmp_u_f32_e32 vcc_lo, v17, v17
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v21, v21, v17, 0x7fff
	v_cndmask_b32_e32 v17, v21, v25, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v17, 16, v17
	buffer_store_b16 v17, v0, s[12:15], 0 offen offset:96
.LBB0_243:
	s_or_b32 exec_lo, exec_lo, s8
	s_and_b32 s8, s0, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s0, s8
	s_cbranch_execz .LBB0_245
	s_waitcnt vmcnt(26)
	v_add_f32_e32 v17, 0, v18
	s_waitcnt vmcnt(19)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v17, v17, v22
	s_waitcnt vmcnt(10)
	v_add_f32_e32 v17, v17, v26
	s_waitcnt vmcnt(2)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v17, v17, v30
	v_bfe_u32 v18, v17, 16, 1
	v_or_b32_e32 v21, 0x400000, v17
	v_cmp_u_f32_e32 vcc_lo, v17, v17
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v18, v18, v17, 0x7fff
	v_cndmask_b32_e32 v17, v18, v21, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v17, 16, v17
	buffer_store_b16 v17, v0, s[12:15], 0 offen offset:356
.LBB0_245:
	s_or_b32 exec_lo, exec_lo, s0
	s_and_b32 s1, s1, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s0, s1
	s_cbranch_execz .LBB0_247
	s_waitcnt vmcnt(26)
	v_add_f32_e32 v17, 0, v19
	s_waitcnt vmcnt(19)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v17, v17, v23
	s_waitcnt vmcnt(10)
	v_add_f32_e32 v17, v17, v27
	s_waitcnt vmcnt(2)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v17, v17, v31
	v_bfe_u32 v18, v17, 16, 1
	v_or_b32_e32 v19, 0x400000, v17
	v_cmp_u_f32_e32 vcc_lo, v17, v17
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v18, v18, v17, 0x7fff
	v_cndmask_b32_e32 v17, v18, v19, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v17, 16, v17
	buffer_store_b16 v17, v0, s[12:15], 0 offen offset:616
.LBB0_247:
	s_or_b32 exec_lo, exec_lo, s0
	s_and_b32 s1, s2, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s0, s1
	s_cbranch_execz .LBB0_249
	s_waitcnt vmcnt(26)
	v_add_f32_e32 v17, 0, v20
	s_waitcnt vmcnt(19)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v17, v17, v24
	s_waitcnt vmcnt(10)
	v_add_f32_e32 v17, v17, v28
	s_waitcnt vmcnt(2)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v17, v17, v32
	v_bfe_u32 v18, v17, 16, 1
	v_or_b32_e32 v19, 0x400000, v17
	v_cmp_u_f32_e32 vcc_lo, v17, v17
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v18, v18, v17, 0x7fff
	v_cndmask_b32_e32 v17, v18, v19, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v17, 16, v17
	buffer_store_b16 v17, v0, s[12:15], 0 offen offset:876
.LBB0_249:
	s_or_b32 exec_lo, exec_lo, s0
	s_and_b32 s1, s3, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s0, s1
	s_cbranch_execz .LBB0_251
	s_waitcnt vmcnt(27)
	v_add_f32_e32 v1, 0, v1
	s_waitcnt vmcnt(13)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v1, v1, v5
	s_waitcnt vmcnt(11)
	v_add_f32_e32 v1, v1, v9
	s_waitcnt vmcnt(3)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v1, v1, v13
	v_bfe_u32 v5, v1, 16, 1
	v_or_b32_e32 v9, 0x400000, v1
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v5, v5, v1, 0x7fff
	v_cndmask_b32_e32 v1, v5, v9, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v1, 16, v1
	buffer_store_b16 v1, v0, s[12:15], 0 offen offset:1136
.LBB0_251:
	s_or_b32 exec_lo, exec_lo, s0
	s_and_b32 s1, s4, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s0, s1
	s_cbranch_execz .LBB0_253
	s_waitcnt vmcnt(27)
	v_add_f32_e32 v1, 0, v2
	s_waitcnt vmcnt(13)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v1, v1, v6
	s_waitcnt vmcnt(11)
	v_add_f32_e32 v1, v1, v10
	s_waitcnt vmcnt(3)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v1, v1, v14
	v_bfe_u32 v2, v1, 16, 1
	v_or_b32_e32 v5, 0x400000, v1
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v2, v2, v1, 0x7fff
	v_cndmask_b32_e32 v1, v2, v5, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v1, 16, v1
	buffer_store_b16 v1, v0, s[12:15], 0 offen offset:1396
.LBB0_253:
	s_or_b32 exec_lo, exec_lo, s0
	s_and_b32 s1, s5, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s0, s1
	s_cbranch_execz .LBB0_255
	s_waitcnt vmcnt(27)
	v_add_f32_e32 v1, 0, v3
	s_waitcnt vmcnt(13)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v1, v1, v7
	s_waitcnt vmcnt(11)
	v_add_f32_e32 v1, v1, v11
	s_waitcnt vmcnt(3)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v1, v1, v15
	v_bfe_u32 v2, v1, 16, 1
	v_or_b32_e32 v3, 0x400000, v1
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v2, v2, v1, 0x7fff
	v_cndmask_b32_e32 v1, v2, v3, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v1, 16, v1
	buffer_store_b16 v1, v0, s[12:15], 0 offen offset:1656
.LBB0_255:
	s_or_b32 exec_lo, exec_lo, s0
	s_and_b32 s1, s6, s7
	s_delay_alu instid0(SALU_CYCLE_1)
	s_and_saveexec_b32 s0, s1
	s_cbranch_execz .LBB0_257
	s_waitcnt vmcnt(27)
	v_add_f32_e32 v1, 0, v4
	s_waitcnt vmcnt(13)
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_f32_e32 v1, v1, v8
	s_waitcnt vmcnt(11)
	v_add_f32_e32 v1, v1, v12
	s_waitcnt vmcnt(3)
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_f32_e32 v1, v1, v16
	v_bfe_u32 v2, v1, 16, 1
	v_or_b32_e32 v3, 0x400000, v1
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v2, v2, v1, 0x7fff
	v_cndmask_b32_e32 v1, v2, v3, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v1, 16, v1
	buffer_store_b16 v1, v0, s[12:15], 0 offen offset:1916
.LBB0_257:
	s_or_b32 exec_lo, exec_lo, s0
	v_mov_b32_e32 v0, 0
	s_waitcnt vmcnt(0)
	s_waitcnt_vscnt null, 0x0
	global_store_b32 v[129:130], v0, off
.LBB0_258:
	s_nop 0
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
	s_endpgm
.Lfunc_end0:
	.size	_matmul_bf16_0, .Lfunc_end0-_matmul_bf16_0
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _matmul_bf16_0
		.amdhsa_group_segment_fixed_size 4096
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
		.amdhsa_next_free_vgpr 169
		.amdhsa_next_free_sgpr 22
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

	.set .L_matmul_bf16_0.num_vgpr, 134
	.set .L_matmul_bf16_0.num_agpr, 0
	.set .L_matmul_bf16_0.numbered_sgpr, 22
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
    .group_segment_fixed_size: 4096
    .kernarg_segment_align: 8
    .kernarg_segment_size: 100
    .max_flat_workgroup_size: 32
    .name:           _matmul_bf16_0
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 32
      - 1
      - 1
    .sgpr_count:     24
    .sgpr_spill_count: 0
    .symbol:         _matmul_bf16_0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     134
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
