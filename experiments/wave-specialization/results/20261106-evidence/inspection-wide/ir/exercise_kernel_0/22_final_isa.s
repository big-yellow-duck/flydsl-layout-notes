	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	exercise_kernel_0
	.p2align	8
	.type	exercise_kernel_0,@function
exercise_kernel_0:
	s_mov_b32 s3, exec_lo
	v_cmpx_eq_u32_e32 0, v0
	s_cbranch_execz .LBB0_2
	v_mov_b32_e32 v1, 0
	v_not_b32_e32 v3, 16
	v_not_b32_e32 v4, 22
	s_delay_alu instid0(VALU_DEP_3)
	v_mov_b32_e32 v2, v1
	ds_store_b128 v1, v[1:4] offset:4864
.LBB0_2:
	s_or_b32 exec_lo, exec_lo, s3
	s_ashr_i32 s3, s2, 31
	v_and_b32_e32 v1, 31, v0
	s_lshr_b32 s3, s3, 27
	v_sub_co_u32 v18, s4, v0, 64
	s_add_i32 s3, s2, s3
	s_waitcnt lgkmcnt(0)
	s_and_b32 s3, s3, 0x1ffffe0
	s_barrier
	s_sub_i32 s2, s2, s3
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_1)
	s_lshl_b32 s3, s2, 7
	s_xor_b32 s2, s4, -1
	s_and_saveexec_b32 s4, s2
	s_delay_alu instid0(SALU_CYCLE_1)
	s_xor_b32 s8, exec_lo, s4
	s_cbranch_execz .LBB0_11
	v_dual_mov_b32 v8, 0 :: v_dual_and_b32 v17, 15, v0
	v_dual_mov_b32 v19, 0 :: v_dual_and_b32 v16, 0xe0, v18
	v_cmp_eq_u32_e64 s2, 0, v1
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_3) | instid1(VALU_DEP_3)
	v_lshlrev_b32_e32 v0, 1, v17
	v_mul_u32_u24_e32 v20, 48, v17
	s_mov_b32 s4, 0
	v_mov_b32_e32 v9, v19
	v_dual_mov_b32 v10, v19 :: v_dual_add_nc_u32 v21, v0, v16
	v_dual_mov_b32 v11, v19 :: v_dual_mov_b32 v0, 0
	v_mov_b32_e32 v12, v19
	v_mov_b32_e32 v13, v19
	v_mov_b32_e32 v14, v19
	v_mov_b32_e32 v15, v19
	v_mov_b32_e32 v1, v19
	v_mov_b32_e32 v2, v19
	v_mov_b32_e32 v3, v19
	v_mov_b32_e32 v4, v19
	v_mov_b32_e32 v5, v19
	v_mov_b32_e32 v6, v19
	v_mov_b32_e32 v7, v19
	s_branch .LBB0_5
.LBB0_4:
	s_or_b32 exec_lo, exec_lo, s5
	s_cmpk_eq_i32 s4, 0x200
	s_cbranch_scc1 .LBB0_10
.LBB0_5:
	s_add_i32 s4, s4, 1
	s_delay_alu instid0(SALU_CYCLE_1)
	s_lshl_b32 s5, s4, 1
.LBB0_6:
	ds_load_b32 v22, v19 offset:4864
	s_waitcnt lgkmcnt(0)
	v_cmp_gt_i32_e32 vcc_lo, s5, v22
	s_cbranch_vccnz .LBB0_6
	ds_load_u16_d16 v22, v21
	ds_load_u16_d16 v23, v21 offset:512
	ds_load_u16_d16 v24, v21 offset:1024
	ds_load_u16_d16 v25, v21 offset:1536
	ds_load_u16_d16 v26, v21 offset:2048
	ds_load_u16_d16 v27, v21 offset:2560
	ds_load_u16_d16 v28, v21 offset:3072
	ds_load_u16_d16 v30, v21 offset:128
	ds_load_u16_d16 v35, v21 offset:2688
	ds_load_u16_d16 v29, v21 offset:3584
	ds_load_u16_d16 v36, v21 offset:3200
	ds_load_u16_d16 v34, v21 offset:2176
	ds_load_u16_d16 v33, v21 offset:1664
	ds_load_u16_d16 v32, v21 offset:1152
	ds_load_u16_d16 v31, v21 offset:640
	ds_load_u16_d16 v37, v21 offset:3712
	s_waitcnt lgkmcnt(14)
	ds_load_u16_d16_hi v23, v21 offset:768
	ds_load_u16_d16_hi v22, v21 offset:256
	s_waitcnt lgkmcnt(10)
	ds_load_u16_d16_hi v30, v21 offset:384
	ds_load_u16_d16_hi v28, v21 offset:3328
	s_waitcnt lgkmcnt(11)
	ds_load_u16_d16_hi v35, v21 offset:2944
	s_waitcnt lgkmcnt(11)
	ds_load_u16_d16_hi v29, v21 offset:3840
	s_waitcnt lgkmcnt(11)
	ds_load_u16_d16_hi v36, v21 offset:3456
	ds_load_b128 v[38:41], v20 offset:4096
	ds_load_b128 v[42:45], v20 offset:4112
	ds_load_u16_d16_hi v24, v21 offset:1280
	ds_load_u16_d16_hi v25, v21 offset:1792
	ds_load_u16_d16_hi v26, v21 offset:2304
	ds_load_u16_d16_hi v27, v21 offset:2816
	s_waitcnt lgkmcnt(17)
	ds_load_u16_d16_hi v34, v21 offset:2432
	s_waitcnt lgkmcnt(17)
	ds_load_u16_d16_hi v33, v21 offset:1920
	s_waitcnt lgkmcnt(17)
	ds_load_u16_d16_hi v32, v21 offset:1408
	s_waitcnt lgkmcnt(17)
	ds_load_u16_d16_hi v31, v21 offset:896
	s_waitcnt lgkmcnt(17)
	ds_load_u16_d16_hi v37, v21 offset:3968
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[8:15], v[38:45], v[22:29], v[8:15]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[0:7], v[38:45], v[30:37], v[0:7]
	s_and_saveexec_b32 s5, s2
	s_cbranch_execz .LBB0_4
	s_mov_b32 s6, exec_lo
	s_mov_b32 s7, exec_lo
	v_mbcnt_lo_u32_b32 v22, s6, 0
	s_delay_alu instid0(VALU_DEP_1)
	v_cmpx_eq_u32_e32 0, v22
	s_xor_b32 s7, exec_lo, s7
	s_cbranch_execz .LBB0_4
	s_bcnt1_i32_b32 s6, s6
	s_delay_alu instid0(SALU_CYCLE_1)
	v_mov_b32_e32 v22, s6
	ds_add_u32 v19, v22 offset:4868
	s_branch .LBB0_4
.LBB0_10:
	v_bfe_u32 v19, v8, 16, 1
	v_or_b32_e32 v20, 0x400000, v8
	v_bfe_u32 v21, v9, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_or_b32_e32 v22, 0x400000, v9
	v_add3_u32 v19, v19, v8, 0x7fff
	v_bfe_u32 v23, v10, 16, 1
	v_add3_u32 v21, v21, v9, 0x7fff
	v_or_b32_e32 v24, 0x400000, v10
	v_bfe_u32 v25, v11, 16, 1
	v_cndmask_b32_e32 v8, v19, v20, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_add3_u32 v23, v23, v10, 0x7fff
	v_bfe_u32 v19, v12, 16, 1
	v_add3_u32 v20, v25, v11, 0x7fff
	v_or_b32_e32 v17, s3, v17
	v_cndmask_b32_e32 v9, v21, v22, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_or_b32_e32 v21, 0x400000, v11
	v_bfe_u32 v22, v13, 16, 1
	v_add3_u32 v19, v19, v12, 0x7fff
	v_lshl_or_b32 v16, v17, 1, v16
	v_cndmask_b32_e32 v10, v23, v24, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_or_b32_e32 v23, 0x400000, v12
	v_or_b32_e32 v24, 0x400000, v1
	s_load_b64 s[4:5], s[0:1], 0x30
	v_lshrrev_b32_e32 v8, 16, v8
	v_cndmask_b32_e32 v11, v20, v21, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_add3_u32 v20, v22, v13, 0x7fff
	v_or_b32_e32 v21, 0x400000, v13
	v_bfe_u32 v22, v0, 16, 1
	v_lshrrev_b32_e32 v9, 16, v9
	v_cndmask_b32_e32 v12, v19, v23, vcc_lo
	v_bfe_u32 v19, v14, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_add3_u32 v22, v22, v0, 0x7fff
	v_or_b32_e32 v23, 0x400000, v0
	v_lshrrev_b32_e32 v10, 16, v10
	v_add3_u32 v19, v19, v14, 0x7fff
	v_cndmask_b32_e32 v13, v20, v21, vcc_lo
	v_or_b32_e32 v20, 0x400000, v14
	v_bfe_u32 v21, v15, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	s_mov_b32 s7, 0x21027000
	s_mov_b32 s6, -1
	s_waitcnt lgkmcnt(0)
	s_and_b32 s5, s5, 0xffff
	v_lshrrev_b32_e32 v11, 16, v11
	v_cndmask_b32_e32 v14, v19, v20, vcc_lo
	v_add3_u32 v20, v21, v15, 0x7fff
	v_or_b32_e32 v21, 0x400000, v15
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_bfe_u32 v19, v1, 16, 1
	v_lshrrev_b32_e32 v12, 16, v12
	v_lshrrev_b32_e32 v13, 16, v13
	v_cndmask_b32_e32 v15, v20, v21, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v0, v0
	v_add3_u32 v19, v19, v1, 0x7fff
	v_ashrrev_i32_e32 v20, 31, v18
	v_or_b32_e32 v21, 0x400000, v2
	v_lshrrev_b32_e32 v14, 16, v14
	v_cndmask_b32_e32 v0, v22, v23, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	v_bfe_u32 v22, v3, 16, 1
	v_lshrrev_b32_e32 v20, 28, v20
	v_bfe_u32 v23, v4, 16, 1
	v_lshrrev_b32_e32 v15, 16, v15
	v_cndmask_b32_e32 v1, v19, v24, vcc_lo
	v_bfe_u32 v19, v2, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_lshrrev_b32_e32 v0, 16, v0
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_lshrrev_b32_e32 v1, 16, v1
	v_add3_u32 v19, v19, v2, 0x7fff
	s_delay_alu instid0(VALU_DEP_1)
	v_cndmask_b32_e32 v2, v19, v21, vcc_lo
	v_add3_u32 v19, v22, v3, 0x7fff
	v_or_b32_e32 v21, 0x400000, v3
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_add_nc_u32_e32 v18, v18, v20
	v_add3_u32 v20, v23, v4, 0x7fff
	v_or_b32_e32 v22, 0x400000, v4
	v_cndmask_b32_e32 v3, v19, v21, vcc_lo
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_4) | instid1(VALU_DEP_4)
	v_ashrrev_i32_e32 v19, 4, v18
	v_lshrrev_b32_e32 v18, 31, v18
	v_or_b32_e32 v21, 0x400000, v5
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_lshrrev_b32_e32 v3, 16, v3
	v_add_nc_u32_e32 v18, v19, v18
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_and_b32_e32 v18, 0x7fffe, v18
	v_sub_nc_u32_e32 v18, v19, v18
	v_or_b32_e32 v19, 0x400000, v6
	s_delay_alu instid0(VALU_DEP_2)
	v_lshl_add_u32 v16, v18, 13, v16
	v_cndmask_b32_e32 v4, v20, v22, vcc_lo
	v_bfe_u32 v20, v5, 16, 1
	v_bfe_u32 v22, v6, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_add_nc_u32_e32 v18, 0x8000, v16
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_add3_u32 v20, v20, v5, 0x7fff
	v_add3_u32 v17, v22, v6, 0x7fff
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_cndmask_b32_e32 v5, v20, v21, vcc_lo
	v_bfe_u32 v20, v7, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_or_b32_e32 v21, 0x400000, v7
	v_lshrrev_b32_e32 v5, 16, v5
	s_delay_alu instid0(VALU_DEP_4)
	v_add3_u32 v20, v20, v7, 0x7fff
	v_dual_cndmask_b32 v6, v17, v19 :: v_dual_add_nc_u32 v19, 0x18000, v16
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_add_nc_u32_e32 v17, 0x4000, v16
	s_clause 0x2
	buffer_store_b16 v8, v16, s[4:7], 0 offen
	buffer_store_b16 v9, v17, s[4:7], 0 offen
	buffer_store_b16 v10, v18, s[4:7], 0 offen
	v_dual_cndmask_b32 v7, v20, v21 :: v_dual_add_nc_u32 v8, 0xc000, v16
	v_add_nc_u32_e32 v9, 0x10000, v16
	v_add_nc_u32_e32 v10, 0x14000, v16
	v_add_nc_u32_e32 v20, 0x1c000, v16
	v_lshrrev_b32_e32 v2, 16, v2
	v_lshrrev_b32_e32 v4, 16, v4
	v_lshrrev_b32_e32 v6, 16, v6
	v_lshrrev_b32_e32 v7, 16, v7
	s_clause 0xc
	buffer_store_b16 v11, v8, s[4:7], 0 offen
	buffer_store_b16 v12, v9, s[4:7], 0 offen
	buffer_store_b16 v13, v10, s[4:7], 0 offen
	buffer_store_b16 v14, v19, s[4:7], 0 offen
	buffer_store_b16 v15, v20, s[4:7], 0 offen
	buffer_store_b16 v0, v16, s[4:7], 0 offen offset:128
	buffer_store_b16 v1, v17, s[4:7], 0 offen offset:128
	buffer_store_b16 v2, v18, s[4:7], 0 offen offset:128
	buffer_store_b16 v3, v8, s[4:7], 0 offen offset:128
	buffer_store_b16 v4, v9, s[4:7], 0 offen offset:128
	buffer_store_b16 v5, v10, s[4:7], 0 offen offset:128
	buffer_store_b16 v6, v19, s[4:7], 0 offen offset:128
	buffer_store_b16 v7, v20, s[4:7], 0 offen offset:128
.LBB0_11:
	s_and_not1_saveexec_b32 s2, s8
	s_cbranch_execz .LBB0_24
	s_clause 0x1
	s_load_b64 s[4:5], s[0:1], 0x0
	s_load_b64 s[8:9], s[0:1], 0x18
	v_lshlrev_b32_e32 v2, 3, v0
	v_lshrrev_b32_e32 v3, 4, v0
	v_lshrrev_b32_e32 v0, 2, v0
	v_cmp_eq_u32_e64 s0, 0, v1
	s_delay_alu instid0(VALU_DEP_4)
	v_dual_mov_b32 v18, 0 :: v_dual_and_b32 v1, 24, v2
	v_and_b32_e32 v4, 0x78, v2
	v_lshl_add_u32 v5, v3, 12, s3
	v_mul_u32_u24_e32 v2, 48, v0
	v_lshlrev_b32_e32 v3, 8, v3
	v_or_b32_e32 v6, 0x1000, v1
	v_lshl_or_b32 v19, v0, 14, v1
	v_or_b32_e32 v5, v5, v4
	v_lshlrev_b32_e32 v4, 1, v4
	s_mov_b32 s7, 0x21027000
	v_add_nc_u32_e32 v21, v6, v2
	s_mov_b32 s6, -1
	v_lshlrev_b32_e32 v20, 1, v5
	v_add_nc_u32_e32 v22, v4, v3
	s_waitcnt lgkmcnt(0)
	s_and_b32 s5, s5, 0xffff
	s_and_b32 s9, s9, 0xffff
	s_mov_b32 s1, 0
	s_mov_b32 s10, s6
	s_mov_b32 s11, s7
	s_branch .LBB0_14
.LBB0_13:
	s_or_b32 exec_lo, exec_lo, s2
	s_add_i32 s1, s1, 2
	s_delay_alu instid0(SALU_CYCLE_1)
	s_cmpk_eq_i32 s1, 0x200
	s_cbranch_scc1 .LBB0_24
.LBB0_14:
	v_lshl_add_u32 v0, s1, 17, v20
	v_lshl_add_u32 v1, s1, 5, v19
	s_lshl_b32 s2, s1, 2
	s_delay_alu instid0(VALU_DEP_2)
	v_add_nc_u32_e32 v2, 0x8000, v0
	v_add_nc_u32_e32 v3, 0x10000, v0
	v_add_nc_u32_e32 v23, 0x18000, v0
	buffer_load_b64 v[16:17], v1, s[4:7], 0 offen
	s_clause 0x3
	buffer_load_b128 v[12:15], v0, s[8:11], 0 offen slc
	buffer_load_b128 v[8:11], v2, s[8:11], 0 offen slc
	buffer_load_b128 v[4:7], v3, s[8:11], 0 offen slc
	buffer_load_b128 v[0:3], v23, s[8:11], 0 offen slc
.LBB0_15:
	ds_load_b32 v23, v18 offset:4868
	s_waitcnt lgkmcnt(0)
	v_cmp_gt_i32_e32 vcc_lo, s2, v23
	s_cbranch_vccnz .LBB0_15
	s_waitcnt vmcnt(4)
	ds_store_b64 v21, v[16:17]
	s_waitcnt vmcnt(3)
	ds_store_b128 v22, v[12:15]
	s_waitcnt vmcnt(2)
	ds_store_b128 v22, v[8:11] offset:1024
	s_waitcnt vmcnt(1)
	ds_store_b128 v22, v[4:7] offset:2048
	s_waitcnt vmcnt(0)
	ds_store_b128 v22, v[0:3] offset:3072
	s_and_saveexec_b32 s2, s0
	s_cbranch_execz .LBB0_19
	s_mov_b32 s3, exec_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mbcnt_lo_u32_b32 v0, s3, 0
	v_cmp_eq_u32_e32 vcc_lo, 0, v0
	s_and_b32 s12, exec_lo, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1)
	s_mov_b32 exec_lo, s12
	s_bcnt1_i32_b32 s3, s3
	s_delay_alu instid0(SALU_CYCLE_1)
	v_mov_b32_e32 v0, s3
	ds_add_u32 v18, v0 offset:4864
.LBB0_19:
	s_or_b32 exec_lo, exec_lo, s2
	s_or_b32 s2, s1, 1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	v_lshl_add_u32 v0, s2, 17, v20
	v_lshl_add_u32 v1, s2, 5, v19
	s_lshl_b32 s2, s2, 2
	v_add_nc_u32_e32 v2, 0x8000, v0
	v_add_nc_u32_e32 v3, 0x10000, v0
	v_add_nc_u32_e32 v23, 0x18000, v0
	buffer_load_b64 v[16:17], v1, s[4:7], 0 offen
	s_clause 0x3
	buffer_load_b128 v[12:15], v0, s[8:11], 0 offen slc
	buffer_load_b128 v[8:11], v2, s[8:11], 0 offen slc
	buffer_load_b128 v[4:7], v3, s[8:11], 0 offen slc
	buffer_load_b128 v[0:3], v23, s[8:11], 0 offen slc
.LBB0_20:
	ds_load_b32 v23, v18 offset:4868
	s_waitcnt lgkmcnt(0)
	v_cmp_gt_i32_e32 vcc_lo, s2, v23
	s_cbranch_vccnz .LBB0_20
	s_waitcnt vmcnt(4)
	ds_store_b64 v21, v[16:17]
	s_waitcnt vmcnt(3)
	ds_store_b128 v22, v[12:15]
	s_waitcnt vmcnt(2)
	ds_store_b128 v22, v[8:11] offset:1024
	s_waitcnt vmcnt(1)
	ds_store_b128 v22, v[4:7] offset:2048
	s_waitcnt vmcnt(0)
	ds_store_b128 v22, v[0:3] offset:3072
	s_and_saveexec_b32 s2, s0
	s_cbranch_execz .LBB0_13
	s_mov_b32 s3, exec_lo
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_mbcnt_lo_u32_b32 v0, s3, 0
	v_cmp_eq_u32_e32 vcc_lo, 0, v0
	s_and_b32 s12, exec_lo, vcc_lo
	s_delay_alu instid0(SALU_CYCLE_1)
	s_mov_b32 exec_lo, s12
	s_cbranch_execz .LBB0_13
	s_bcnt1_i32_b32 s3, s3
	s_delay_alu instid0(SALU_CYCLE_1)
	v_mov_b32_e32 v0, s3
	ds_add_u32 v18, v0 offset:4864
	s_branch .LBB0_13
.LBB0_24:
	s_endpgm
.Lfunc_end0:
	.size	exercise_kernel_0, .Lfunc_end0-exercise_kernel_0
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel exercise_kernel_0
		.amdhsa_group_segment_fixed_size 4880
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 116
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
		.amdhsa_next_free_vgpr 46
		.amdhsa_next_free_sgpr 13
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
		.amdhsa_inst_pref_size ((instprefsize(.Lfunc_end0-exercise_kernel_0)<<4)&1008)>>4
		.amdhsa_exception_fp_ieee_invalid_op 0
		.amdhsa_exception_fp_denorm_src 0
		.amdhsa_exception_fp_ieee_div_zero 0
		.amdhsa_exception_fp_ieee_overflow 0
		.amdhsa_exception_fp_ieee_underflow 0
		.amdhsa_exception_fp_ieee_inexact 0
		.amdhsa_exception_int_div_zero 0
	.end_amdhsa_kernel
	.text

	.set .Lexercise_kernel_0.num_vgpr, 46
	.set .Lexercise_kernel_0.num_agpr, 0
	.set .Lexercise_kernel_0.numbered_sgpr, 13
	.set .Lexercise_kernel_0.num_named_barrier, 0
	.set .Lexercise_kernel_0.private_seg_size, 0
	.set .Lexercise_kernel_0.uses_vcc, 1
	.set .Lexercise_kernel_0.uses_flat_scratch, 0
	.set .Lexercise_kernel_0.has_dyn_sized_stack, 0
	.set .Lexercise_kernel_0.has_recursion, 0
	.set .Lexercise_kernel_0.has_indirect_call, 0
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
      - .address_space:  global
        .offset:         104
        .size:           8
        .value_kind:     global_buffer
      - .offset:         112
        .size:           4
        .value_kind:     by_value
    .group_segment_fixed_size: 4880
    .kernarg_segment_align: 8
    .kernarg_segment_size: 116
    .max_flat_workgroup_size: 192
    .name:           exercise_kernel_0
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 192
      - 1
      - 1
    .sgpr_count:     15
    .sgpr_spill_count: 0
    .symbol:         exercise_kernel_0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     46
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
