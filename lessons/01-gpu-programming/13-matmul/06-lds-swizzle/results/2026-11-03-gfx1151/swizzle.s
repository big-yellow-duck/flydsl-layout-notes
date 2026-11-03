	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	exercise_kernel_0
	.p2align	8
	.type	exercise_kernel_0,@function
exercise_kernel_0:
	v_lshlrev_b32_e32 v1, 3, v0
	v_lshrrev_b32_e32 v2, 2, v0
	v_and_b32_e32 v14, 15, v0
	v_bfe_u32 v15, v0, 5, 1
	v_lshlrev_b32_e32 v6, 2, v0
	v_and_b32_e32 v4, 24, v1
	v_and_b32_e32 v13, 16, v2
	v_lshlrev_b32_e32 v1, 5, v14
	v_lshlrev_b32_e32 v8, 10, v2
	v_and_b32_e32 v6, 56, v6
	v_lshl_or_b32 v3, v2, 5, v4
	v_or_b32_e32 v5, v14, v13
	v_lshl_or_b32 v7, v15, 9, v1
	s_clause 0x1
	s_load_b64 s[6:7], s[0:1], 0x0
	s_load_b64 s[4:5], s[0:1], 0x18
	v_xor_b32_e32 v1, v1, v6
	v_lshl_or_b32 v16, v3, 1, 0x800
	v_lshl_or_b32 v17, v5, 1, 0x800
	v_and_b32_e32 v5, 56, v0
	v_or_b32_e32 v2, 1, v7
	v_or_b32_e32 v9, 2, v7
	v_or_b32_e32 v10, 3, v7
	s_lshl_b32 s3, s3, 15
	v_xor_b32_e32 v3, v3, v5
	v_lshlrev_b32_e32 v5, 10, v15
	v_xor_b32_e32 v2, v2, v6
	v_xor_b32_e32 v9, v9, v6
	s_lshl_b32 s2, s2, 5
	v_lshlrev_b32_e32 v18, 1, v3
	v_lshl_or_b32 v19, v1, 1, v5
	v_lshlrev_b32_e32 v20, 1, v2
	v_lshlrev_b32_e32 v21, 1, v9
	v_xor_b32_e32 v1, v10, v6
	v_or_b32_e32 v2, 4, v7
	v_or_b32_e32 v3, 5, v7
	v_or_b32_e32 v5, 6, v7
	v_or_b32_e32 v9, 7, v7
	v_lshlrev_b32_e32 v22, 1, v1
	v_xor_b32_e32 v1, v2, v6
	v_xor_b32_e32 v2, v3, v6
	v_xor_b32_e32 v3, v5, v6
	v_xor_b32_e32 v5, v9, v6
	v_or_b32_e32 v9, 8, v7
	v_lshlrev_b32_e32 v23, 1, v1
	v_lshlrev_b32_e32 v24, 1, v2
	v_lshlrev_b32_e32 v25, 1, v3
	v_lshlrev_b32_e32 v26, 1, v5
	v_xor_b32_e32 v1, v9, v6
	v_or_b32_e32 v2, 9, v7
	v_or_b32_e32 v3, 10, v7
	v_or_b32_e32 v5, 11, v7
	v_or_b32_e32 v9, 12, v7
	v_lshlrev_b32_e32 v27, 1, v1
	v_xor_b32_e32 v1, v2, v6
	v_xor_b32_e32 v2, v3, v6
	v_xor_b32_e32 v3, v5, v6
	v_xor_b32_e32 v5, v9, v6
	v_or_b32_e32 v9, 13, v7
	v_lshlrev_b32_e32 v28, 1, v1
	v_lshlrev_b32_e32 v29, 1, v2
	v_lshlrev_b32_e32 v30, 1, v3
	v_lshlrev_b32_e32 v31, 1, v5
	v_xor_b32_e32 v1, v9, v6
	v_or_b32_e32 v2, 14, v7
	v_or_b32_e32 v3, 15, v7
	v_or_b32_e32 v5, 16, v7
	v_or_b32_e32 v9, 17, v7
	v_lshlrev_b32_e32 v32, 1, v1
	v_xor_b32_e32 v1, v2, v6
	v_xor_b32_e32 v2, v3, v6
	v_xor_b32_e32 v3, v5, v6
	v_xor_b32_e32 v5, v9, v6
	v_or_b32_e32 v9, 18, v7
	v_lshlrev_b32_e32 v33, 1, v1
	v_lshlrev_b32_e32 v34, 1, v2
	v_lshlrev_b32_e32 v35, 1, v3
	v_lshlrev_b32_e32 v36, 1, v5
	v_xor_b32_e32 v1, v9, v6
	v_or_b32_e32 v2, 19, v7
	v_or_b32_e32 v3, 20, v7
	v_or_b32_e32 v5, 21, v7
	v_or_b32_e32 v9, 22, v7
	v_lshlrev_b32_e32 v37, 1, v1
	v_xor_b32_e32 v1, v2, v6
	v_xor_b32_e32 v2, v3, v6
	v_xor_b32_e32 v3, v5, v6
	v_xor_b32_e32 v5, v9, v6
	v_or_b32_e32 v9, 23, v7
	v_lshlrev_b32_e32 v38, 1, v1
	v_lshlrev_b32_e32 v39, 1, v2
	v_lshlrev_b32_e32 v40, 1, v3
	v_lshlrev_b32_e32 v41, 1, v5
	v_xor_b32_e32 v1, v9, v6
	v_or_b32_e32 v2, 24, v7
	v_or_b32_e32 v3, 25, v7
	v_or_b32_e32 v5, 26, v7
	v_or_b32_e32 v9, 27, v7
	v_lshlrev_b32_e32 v42, 1, v1
	v_xor_b32_e32 v1, v2, v6
	v_xor_b32_e32 v2, v3, v6
	v_xor_b32_e32 v3, v5, v6
	v_xor_b32_e32 v5, v9, v6
	v_or_b32_e32 v9, 28, v7
	v_lshlrev_b32_e32 v43, 1, v1
	v_lshlrev_b32_e32 v44, 1, v2
	v_lshlrev_b32_e32 v45, 1, v3
	v_or_b32_e32 v3, 29, v7
	v_xor_b32_e32 v2, v9, v6
	v_or3_b32 v1, s3, v8, v4
	v_lshlrev_b32_e32 v46, 1, v5
	v_or_b32_e32 v5, 30, v7
	v_xor_b32_e32 v3, v3, v6
	v_lshlrev_b32_e32 v47, 1, v2
	v_ashrrev_i32_e32 v2, 31, v1
	v_or_b32_e32 v7, 31, v7
	v_xor_b32_e32 v5, v5, v6
	v_lshlrev_b32_e32 v48, 1, v3
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_lshlrev_b64 v[2:3], 1, v[1:2]
	v_xor_b32_e32 v6, v7, v6
	v_add_nc_u32_e32 v7, s2, v8
	v_mov_b32_e32 v1, 0
	v_lshlrev_b32_e32 v49, 1, v5
	s_waitcnt lgkmcnt(0)
	v_add_co_u32 v11, vcc_lo, s6, v2
	v_lshlrev_b32_e32 v50, 1, v6
	v_add_co_ci_u32_e64 v12, null, s7, v3, vcc_lo
	v_mov_b32_e32 v2, v1
	v_mov_b32_e32 v3, v1
	v_or_b32_e32 v9, v7, v4
	v_mov_b32_e32 v4, v1
	v_mov_b32_e32 v5, v1
	v_mov_b32_e32 v6, v1
	v_mov_b32_e32 v7, v1
	v_mov_b32_e32 v8, v1
	s_mov_b32 s6, 32
.LBB0_1:
	v_ashrrev_i32_e32 v10, 31, v9
	global_load_b128 v[51:54], v[11:12], off
	s_add_i32 s6, s6, -1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	s_cmp_lg_u32 s6, 0
	v_lshlrev_b64 v[55:56], 1, v[9:10]
	v_add_nc_u32_e32 v9, 0x8000, v9
	v_add_co_u32 v55, vcc_lo, s4, v55
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v56, null, s5, v56, vcc_lo
	v_add_co_u32 v11, vcc_lo, v11, 64
	v_add_co_ci_u32_e64 v12, null, 0, v12, vcc_lo
	global_load_b128 v[55:58], v[55:56], off
	s_waitcnt vmcnt(1)
	ds_store_b128 v18, v[51:54]
	s_waitcnt vmcnt(0)
	ds_store_b128 v16, v[55:58]
	s_waitcnt lgkmcnt(0)
	s_barrier
	buffer_gl0_inv
	ds_load_u16_d16 v51, v19
	ds_load_u16_d16 v52, v21
	ds_load_u16_d16 v53, v23
	ds_load_u16_d16 v54, v25
	ds_load_u16_d16 v55, v27
	ds_load_u16_d16 v56, v29
	ds_load_u16_d16 v57, v31
	ds_load_u16_d16 v58, v33
	ds_load_u16_d16 v59, v35
	ds_load_u16_d16 v60, v37
	ds_load_u16_d16 v61, v39
	ds_load_u16_d16 v62, v41
	ds_load_u16_d16 v63, v43
	ds_load_u16_d16 v64, v45
	ds_load_u16_d16 v65, v47
	ds_load_u16_d16 v66, v49
	ds_load_u16_d16 v67, v17
	ds_load_u16_d16 v68, v17 offset:128
	ds_load_u16_d16 v69, v17 offset:256
	ds_load_u16_d16 v70, v17 offset:384
	ds_load_u16_d16 v71, v17 offset:512
	ds_load_u16_d16 v72, v17 offset:640
	ds_load_u16_d16 v73, v17 offset:768
	ds_load_u16_d16 v74, v17 offset:896
	ds_load_u16_d16 v75, v17 offset:1024
	ds_load_u16_d16 v76, v17 offset:1152
	ds_load_u16_d16 v77, v17 offset:1280
	ds_load_u16_d16 v78, v17 offset:1408
	ds_load_u16_d16 v79, v17 offset:1536
	ds_load_u16_d16 v80, v17 offset:1664
	ds_load_u16_d16 v81, v17 offset:1792
	ds_load_u16_d16 v82, v17 offset:1920
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v51, v20
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v52, v22
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v53, v24
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v54, v26
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v55, v28
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v56, v30
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v57, v32
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v58, v34
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v59, v36
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v60, v38
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v61, v40
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v62, v42
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v63, v44
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v64, v46
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v65, v48
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v66, v50
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v67, v17 offset:64
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v68, v17 offset:192
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v69, v17 offset:320
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v70, v17 offset:448
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v71, v17 offset:576
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v72, v17 offset:704
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v73, v17 offset:832
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v74, v17 offset:960
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v75, v17 offset:1088
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v76, v17 offset:1216
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v77, v17 offset:1344
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v78, v17 offset:1472
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v79, v17 offset:1600
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v80, v17 offset:1728
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v81, v17 offset:1856
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v82, v17 offset:1984
	s_waitcnt lgkmcnt(8)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[51:58], v[67:74], v[1:8]
	s_waitcnt lgkmcnt(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[59:66], v[75:82], v[1:8]
	s_barrier
	buffer_gl0_inv
	s_cbranch_scc1 .LBB0_1
	v_bfe_u32 v9, v1, 16, 1
	v_bfe_u32 v10, v2, 16, 1
	v_or_b32_e32 v11, 0x400000, v1
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	v_or_b32_e32 v12, 0x400000, v2
	v_add3_u32 v9, v9, v1, 0x7fff
	v_add3_u32 v10, v10, v2, 0x7fff
	v_bfe_u32 v16, v3, 16, 1
	s_add_i32 s3, s3, s2
	s_load_b64 s[0:1], s[0:1], 0x30
	v_cndmask_b32_e32 v11, v9, v11, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_add3_u32 v1, v16, v3, 0x7fff
	v_lshlrev_b32_e32 v2, 14, v15
	v_bfe_u32 v9, v4, 16, 1
	v_or_b32_e32 v15, 0x400000, v4
	v_cndmask_b32_e32 v10, v10, v12, vcc_lo
	v_or_b32_e32 v12, 0x400000, v3
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_add_nc_u32_e32 v2, s3, v2
	v_add3_u32 v9, v9, v4, 0x7fff
	v_bfe_u32 v16, v5, 16, 1
	v_bfe_u32 v3, v6, 16, 1
	v_cndmask_b32_e32 v12, v1, v12, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_or_b32_e32 v2, v2, v14
	v_add3_u32 v1, v16, v5, 0x7fff
	v_bfe_u32 v4, v7, 16, 1
	v_cndmask_b32_e32 v14, v9, v15, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_lshlrev_b32_e32 v0, 6, v0
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_add3_u32 v4, v4, v7, 0x7fff
	v_bfe_u32 v9, v8, 16, 1
	v_and_b32_e32 v0, 0x400, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_add_nc_u32_e32 v0, v2, v0
	v_or_b32_e32 v2, 0x400000, v5
	v_or_b32_e32 v5, 0x400000, v7
	v_or_b32_e32 v0, v0, v13
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_4) | instid1(VALU_DEP_3)
	v_cndmask_b32_e32 v13, v1, v2, vcc_lo
	v_add3_u32 v2, v3, v6, 0x7fff
	v_or_b32_e32 v3, 0x400000, v6
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_ashrrev_i32_e32 v1, 31, v0
	v_cndmask_b32_e32 v15, v2, v3, vcc_lo
	s_delay_alu instid0(VALU_DEP_2)
	v_lshlrev_b64 v[0:1], 1, v[0:1]
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_add3_u32 v2, v9, v8, 0x7fff
	v_or_b32_e32 v3, 0x400000, v8
	v_cndmask_b32_e32 v16, v4, v5, vcc_lo
	s_waitcnt lgkmcnt(0)
	v_add_co_u32 v0, vcc_lo, s0, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_4)
	v_add_co_ci_u32_e64 v1, null, s1, v1, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_cndmask_b32_e32 v17, v2, v3, vcc_lo
	v_add_co_u32 v2, vcc_lo, v0, 0x2000
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v3, null, 0, v1, vcc_lo
	v_add_co_u32 v4, vcc_lo, v0, 0x4000
	v_add_co_ci_u32_e64 v5, null, 0, v1, vcc_lo
	v_add_co_u32 v6, vcc_lo, v0, 0x6000
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v7, null, 0, v1, vcc_lo
	v_add_co_u32 v8, vcc_lo, 0x7000, v0
	v_add_co_ci_u32_e64 v9, null, 0, v1, vcc_lo
	s_clause 0x7
	global_store_d16_hi_b16 v[0:1], v11, off
	global_store_d16_hi_b16 v[2:3], v10, off offset:-4096
	global_store_d16_hi_b16 v[2:3], v12, off
	global_store_d16_hi_b16 v[4:5], v14, off offset:-4096
	global_store_d16_hi_b16 v[4:5], v13, off
	global_store_d16_hi_b16 v[6:7], v15, off offset:-4096
	global_store_d16_hi_b16 v[6:7], v16, off
	global_store_d16_hi_b16 v[8:9], v17, off
	s_endpgm
.Lfunc_end0:
	.size	exercise_kernel_0, .Lfunc_end0-exercise_kernel_0
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel exercise_kernel_0
		.amdhsa_group_segment_fixed_size 4096
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 72
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
		.amdhsa_system_sgpr_workgroup_id_y 1
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 83
		.amdhsa_next_free_sgpr 8
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

	.set .Lexercise_kernel_0.num_vgpr, 83
	.set .Lexercise_kernel_0.num_agpr, 0
	.set .Lexercise_kernel_0.numbered_sgpr, 8
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
    .group_segment_fixed_size: 4096
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 128
    .name:           exercise_kernel_0
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 128
      - 1
      - 1
    .sgpr_count:     10
    .sgpr_spill_count: 0
    .symbol:         exercise_kernel_0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     83
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
