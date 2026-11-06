	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	exercise_kernel_0
	.p2align	8
	.type	exercise_kernel_0,@function
exercise_kernel_0:
	v_lshrrev_b32_e32 v18, 2, v0
	v_mov_b32_e32 v9, 0
	s_clause 0x1
	s_load_b64 s[4:5], s[0:1], 0x0
	s_load_b64 s[8:9], s[0:1], 0x18
	s_ashr_i32 s3, s2, 31
	v_lshrrev_b32_e32 v23, 1, v0
	v_lshlrev_b32_e32 v20, 6, v18
	v_dual_mov_b32 v10, v9 :: v_dual_lshlrev_b32 v1, 3, v0
	s_lshr_b32 s3, s3, 25
	v_dual_mov_b32 v12, v9 :: v_dual_lshlrev_b32 v19, 12, v18
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_2)
	v_dual_mov_b32 v11, v9 :: v_dual_and_b32 v22, 24, v1
	s_add_i32 s3, s2, s3
	v_dual_mov_b32 v14, v9 :: v_dual_lshlrev_b32 v1, 4, v0
	s_and_b32 s3, s3, 0x7ffff80
	v_or_b32_e32 v2, v22, v19
	s_sub_i32 s2, s2, s3
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_2)
	v_dual_mov_b32 v16, v9 :: v_dual_and_b32 v21, 16, v1
	s_lshl_b32 s12, s2, 5
	s_mov_b32 s6, -1
	v_add_lshl_u32 v1, v2, s12, 1
	v_lshl_or_b32 v24, v23, 14, v21
	s_mov_b32 s7, 0x21027000
	s_waitcnt lgkmcnt(0)
	s_and_b32 s5, s5, 0xffff
	s_mov_b32 s10, s6
	v_dual_mov_b32 v13, v9 :: v_dual_add_nc_u32 v2, 0x10000, v1
	s_mov_b32 s11, s7
	s_and_b32 s9, s9, 0xffff
	buffer_load_b128 v[25:28], v24, s[4:7], 0 offen
	s_clause 0x1
	buffer_load_b128 v[29:32], v1, s[8:11], 0 offen
	buffer_load_b128 v[33:36], v2, s[8:11], 0 offen
	v_dual_mov_b32 v15, v9 :: v_dual_add_nc_u32 v38, s12, v19
	v_dual_mov_b32 v2, v9 :: v_dual_and_b32 v17, 15, v0
	v_mul_u32_u24_e32 v37, 48, v23
	v_or_b32_e32 v39, 0x400, v21
	s_delay_alu instid0(VALU_DEP_4)
	v_or_b32_e32 v38, v38, v22
	v_dual_mov_b32 v4, v9 :: v_dual_lshlrev_b32 v21, 1, v22
	v_dual_mov_b32 v1, v9 :: v_dual_lshlrev_b32 v18, 1, v17
	v_mov_b32_e32 v3, v9
	v_mov_b32_e32 v5, v9
	v_mov_b32_e32 v6, v9
	v_mov_b32_e32 v7, v9
	v_mov_b32_e32 v8, v9
	v_mul_u32_u24_e32 v19, 48, v17
	v_mad_u32_u24 v40, v23, 48, v39
	v_or_b32_e32 v22, 32, v24
	v_add_nc_u32_e32 v23, v39, v37
	v_lshl_add_u32 v24, v38, 1, 0x20000
	v_or_b32_e32 v41, v21, v20
	s_movk_i32 s2, 0x1ff
	s_waitcnt vmcnt(2)
	ds_store_b128 v40, v[25:28]
	s_waitcnt vmcnt(1)
	ds_store_b128 v41, v[29:32]
	s_waitcnt vmcnt(0)
	ds_store_b128 v41, v[33:36] offset:512
	s_waitcnt lgkmcnt(0)
	buffer_gl0_inv
.LBB0_1:
	v_add_nc_u32_e32 v25, 0x10000, v24
	v_add_nc_u32_e32 v61, v21, v20
	s_add_i32 s2, s2, -1
	buffer_load_b128 v[49:52], v22, s[4:7], 0 offen
	s_clause 0x1
	buffer_load_b128 v[53:56], v24, s[8:11], 0 offen
	buffer_load_b128 v[57:60], v25, s[8:11], 0 offen
	ds_load_u16_d16 v26, v18 offset:128
	ds_load_u16_d16 v25, v18
	ds_load_u16_d16 v33, v18 offset:32
	ds_load_u16_d16 v31, v18 offset:768
	ds_load_u16_d16 v27, v18 offset:256
	ds_load_u16_d16 v28, v18 offset:384
	ds_load_u16_d16 v29, v18 offset:512
	ds_load_u16_d16 v30, v18 offset:640
	v_add_nc_u32_e32 v22, 32, v22
	v_add_nc_u32_e32 v24, 0x20000, v24
	s_cmp_lg_u32 s2, 0
	s_waitcnt lgkmcnt(7)
	ds_load_u16_d16_hi v26, v18 offset:192
	ds_load_u16_d16 v38, v18 offset:672
	ds_load_u16_d16 v35, v18 offset:288
	ds_load_u16_d16 v36, v18 offset:416
	ds_load_u16_d16 v37, v18 offset:544
	ds_load_u16_d16 v32, v18 offset:896
	s_waitcnt lgkmcnt(10)
	ds_load_u16_d16_hi v31, v18 offset:832
	ds_load_u16_d16 v39, v18 offset:800
	s_waitcnt lgkmcnt(6)
	ds_load_u16_d16_hi v38, v18 offset:736
	ds_load_u16_d16_hi v25, v18 offset:64
	ds_load_u16_d16_hi v33, v18 offset:96
	ds_load_u16_d16 v34, v18 offset:160
	s_waitcnt lgkmcnt(6)
	ds_load_u16_d16_hi v32, v18 offset:960
	ds_load_u16_d16 v40, v18 offset:928
	s_waitcnt lgkmcnt(6)
	ds_load_u16_d16_hi v39, v18 offset:864
	ds_load_b128 v[41:44], v19 offset:1024
	ds_load_b128 v[45:48], v19 offset:1040
	ds_load_u16_d16_hi v27, v18 offset:320
	ds_load_u16_d16_hi v28, v18 offset:448
	ds_load_u16_d16_hi v29, v18 offset:576
	ds_load_u16_d16_hi v30, v18 offset:704
	ds_load_u16_d16_hi v37, v18 offset:608
	ds_load_u16_d16_hi v36, v18 offset:480
	ds_load_u16_d16_hi v35, v18 offset:352
	s_waitcnt lgkmcnt(12)
	ds_load_u16_d16_hi v34, v18 offset:224
	s_waitcnt lgkmcnt(11)
	ds_load_u16_d16_hi v40, v18 offset:992
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[41:48], v[25:32], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[41:48], v[33:40], v[1:8]
	s_waitcnt vmcnt(0)
	buffer_gl0_inv
	ds_store_b128 v23, v[49:52]
	ds_store_b128 v61, v[53:56]
	ds_store_b128 v61, v[57:60] offset:512
	s_waitcnt lgkmcnt(0)
	buffer_gl0_inv
	s_cbranch_scc1 .LBB0_1
	ds_load_u16_d16 v22, v18 offset:256
	ds_load_u16_d16 v23, v18 offset:384
	ds_load_u16_d16 v24, v18 offset:512
	ds_load_u16_d16 v25, v18 offset:640
	ds_load_u16_d16 v21, v18 offset:128
	ds_load_u16_d16 v20, v18
	ds_load_u16_d16 v27, v18 offset:896
	ds_load_u16_d16 v26, v18 offset:768
	ds_load_u16_d16 v28, v18 offset:32
	ds_load_b128 v[36:39], v19 offset:1024
	ds_load_b128 v[40:43], v19 offset:1040
	s_load_b64 s[0:1], s[0:1], 0x30
	v_or_b32_e32 v17, s12, v17
	s_mov_b32 s3, 0x21027000
	s_mov_b32 s2, -1
	s_waitcnt lgkmcnt(0)
	ds_load_u16_d16_hi v22, v18 offset:320
	ds_load_u16_d16_hi v23, v18 offset:448
	ds_load_u16_d16_hi v24, v18 offset:576
	ds_load_u16_d16_hi v25, v18 offset:704
	ds_load_u16_d16_hi v21, v18 offset:192
	ds_load_u16_d16 v32, v18 offset:544
	ds_load_u16_d16 v33, v18 offset:672
	ds_load_u16_d16 v30, v18 offset:288
	ds_load_u16_d16 v31, v18 offset:416
	ds_load_u16_d16_hi v20, v18 offset:64
	ds_load_u16_d16 v29, v18 offset:160
	ds_load_u16_d16_hi v27, v18 offset:960
	ds_load_u16_d16_hi v26, v18 offset:832
	ds_load_u16_d16 v34, v18 offset:800
	ds_load_u16_d16_hi v28, v18 offset:96
	s_waitcnt lgkmcnt(8)
	ds_load_u16_d16_hi v33, v18 offset:736
	ds_load_u16_d16_hi v32, v18 offset:608
	s_waitcnt lgkmcnt(8)
	ds_load_u16_d16_hi v31, v18 offset:480
	ds_load_u16_d16_hi v30, v18 offset:352
	s_waitcnt lgkmcnt(8)
	ds_load_u16_d16_hi v29, v18 offset:224
	ds_load_u16_d16 v35, v18 offset:928
	s_and_b32 s1, s1, 0xffff
	s_waitcnt lgkmcnt(8)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[36:43], v[20:27], v[9:16]
	s_waitcnt lgkmcnt(7)
	ds_load_u16_d16_hi v34, v18 offset:864
	v_lshlrev_b32_e32 v0, 8, v0
	v_bfe_u32 v19, v9, 16, 1
	v_or_b32_e32 v20, 0x400000, v9
	v_bfe_u32 v21, v10, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_or_b32_e32 v22, 0x400000, v10
	v_add3_u32 v19, v19, v9, 0x7fff
	v_bfe_u32 v23, v11, 16, 1
	v_add3_u32 v21, v21, v10, 0x7fff
	v_or_b32_e32 v24, 0x400000, v11
	v_bfe_u32 v25, v12, 16, 1
	v_cndmask_b32_e32 v9, v19, v20, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_add3_u32 v23, v23, v11, 0x7fff
	s_waitcnt lgkmcnt(1)
	ds_load_u16_d16_hi v35, v18 offset:992
	v_or_b32_e32 v26, 0x400000, v12
	v_bfe_u32 v27, v13, 16, 1
	v_cndmask_b32_e32 v10, v21, v22, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_add3_u32 v25, v25, v12, 0x7fff
	v_or_b32_e32 v44, 0x400000, v13
	v_bfe_u32 v45, v14, 16, 1
	v_add3_u32 v27, v27, v13, 0x7fff
	v_cndmask_b32_e32 v11, v23, v24, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_or_b32_e32 v46, 0x400000, v14
	v_bfe_u32 v47, v15, 16, 1
	v_add3_u32 v45, v45, v14, 0x7fff
	v_or_b32_e32 v48, 0x400000, v15
	v_cndmask_b32_e32 v12, v25, v26, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_bfe_u32 v49, v16, 16, 1
	v_add3_u32 v47, v47, v15, 0x7fff
	v_or_b32_e32 v50, 0x400000, v16
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[36:43], v[28:35], v[1:8]
	v_cndmask_b32_e32 v13, v27, v44, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_add3_u32 v49, v49, v16, 0x7fff
	v_lshrrev_b32_e32 v9, 16, v9
	v_bfe_u32 v18, v1, 16, 1
	v_or_b32_e32 v19, 0x400000, v1
	v_cndmask_b32_e32 v14, v45, v46, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_bfe_u32 v20, v2, 16, 1
	v_add3_u32 v18, v18, v1, 0x7fff
	v_or_b32_e32 v21, 0x400000, v2
	v_bfe_u32 v22, v3, 16, 1
	v_cndmask_b32_e32 v15, v47, v48, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	v_add3_u32 v20, v20, v2, 0x7fff
	v_or_b32_e32 v23, 0x400000, v3
	v_bfe_u32 v24, v4, 16, 1
	v_add3_u32 v22, v22, v3, 0x7fff
	v_cndmask_b32_e32 v16, v49, v50, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	v_or_b32_e32 v25, 0x400000, v4
	v_bfe_u32 v26, v5, 16, 1
	v_add3_u32 v24, v24, v4, 0x7fff
	v_or_b32_e32 v27, 0x400000, v5
	v_cndmask_b32_e32 v1, v18, v19, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_bfe_u32 v28, v6, 16, 1
	v_add3_u32 v26, v26, v5, 0x7fff
	v_or_b32_e32 v18, 0x400000, v6
	v_bfe_u32 v19, v7, 16, 1
	v_cndmask_b32_e32 v2, v20, v21, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_add3_u32 v28, v28, v6, 0x7fff
	v_or_b32_e32 v20, 0x400000, v7
	v_add3_u32 v19, v19, v7, 0x7fff
	v_or_b32_e32 v21, 0x400000, v8
	v_cndmask_b32_e32 v3, v22, v23, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_lshrrev_b32_e32 v10, 16, v10
	v_lshrrev_b32_e32 v11, 16, v11
	v_lshrrev_b32_e32 v12, 16, v12
	v_and_b32_e32 v0, 0x1000, v0
	v_cndmask_b32_e32 v4, v24, v25, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	buffer_gl0_inv
	v_add_lshl_u32 v0, v17, v0, 1
	v_lshrrev_b32_e32 v13, 16, v13
	v_cndmask_b32_e32 v5, v26, v27, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_lshrrev_b32_e32 v14, 16, v14
	v_add_nc_u32_e32 v17, 0x4000, v0
	v_lshrrev_b32_e32 v15, 16, v15
	v_lshrrev_b32_e32 v16, 16, v16
	v_cndmask_b32_e32 v6, v28, v18, vcc_lo
	v_bfe_u32 v18, v8, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_lshrrev_b32_e32 v1, 16, v1
	v_lshrrev_b32_e32 v2, 16, v2
	v_lshrrev_b32_e32 v3, 16, v3
	v_add3_u32 v18, v18, v8, 0x7fff
	v_cndmask_b32_e32 v7, v19, v20, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_add_nc_u32_e32 v19, 0x18000, v0
	v_add_nc_u32_e32 v20, 0x1c000, v0
	v_lshrrev_b32_e32 v4, 16, v4
	v_lshrrev_b32_e32 v5, 16, v5
	v_cndmask_b32_e32 v8, v18, v21, vcc_lo
	v_add_nc_u32_e32 v18, 0x8000, v0
	s_clause 0x2
	buffer_store_b16 v9, v0, s[0:3], 0 offen
	buffer_store_b16 v10, v17, s[0:3], 0 offen
	buffer_store_b16 v11, v18, s[0:3], 0 offen
	v_add_nc_u32_e32 v9, 0xc000, v0
	v_add_nc_u32_e32 v10, 0x10000, v0
	v_add_nc_u32_e32 v11, 0x14000, v0
	v_lshrrev_b32_e32 v6, 16, v6
	v_lshrrev_b32_e32 v7, 16, v7
	v_lshrrev_b32_e32 v8, 16, v8
	s_clause 0xc
	buffer_store_b16 v12, v9, s[0:3], 0 offen
	buffer_store_b16 v13, v10, s[0:3], 0 offen
	buffer_store_b16 v14, v11, s[0:3], 0 offen
	buffer_store_b16 v15, v19, s[0:3], 0 offen
	buffer_store_b16 v16, v20, s[0:3], 0 offen
	buffer_store_b16 v1, v0, s[0:3], 0 offen offset:32
	buffer_store_b16 v2, v17, s[0:3], 0 offen offset:32
	buffer_store_b16 v3, v18, s[0:3], 0 offen offset:32
	buffer_store_b16 v4, v9, s[0:3], 0 offen offset:32
	buffer_store_b16 v5, v10, s[0:3], 0 offen offset:32
	buffer_store_b16 v6, v11, s[0:3], 0 offen offset:32
	buffer_store_b16 v7, v19, s[0:3], 0 offen offset:32
	buffer_store_b16 v8, v20, s[0:3], 0 offen offset:32
	s_endpgm
.Lfunc_end0:
	.size	exercise_kernel_0, .Lfunc_end0-exercise_kernel_0
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel exercise_kernel_0
		.amdhsa_group_segment_fixed_size 1792
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
		.amdhsa_next_free_vgpr 62
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

	.set .Lexercise_kernel_0.num_vgpr, 62
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
    .group_segment_fixed_size: 1792
    .kernarg_segment_align: 8
    .kernarg_segment_size: 100
    .max_flat_workgroup_size: 32
    .name:           exercise_kernel_0
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 32
      - 1
      - 1
    .sgpr_count:     15
    .sgpr_spill_count: 0
    .symbol:         exercise_kernel_0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     62
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
