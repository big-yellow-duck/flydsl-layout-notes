	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	exercise_kernel_0
	.p2align	8
	.type	exercise_kernel_0,@function
exercise_kernel_0:
	v_dual_mov_b32 v1, 0 :: v_dual_lshlrev_b32 v2, 3, v0
	v_lshrrev_b32_e32 v4, 2, v0
	s_clause 0x1
	s_load_b64 s[6:7], s[0:1], 0x0
	s_load_b64 s[4:5], s[0:1], 0x18
	s_lshl_b32 s3, s3, 15
	v_and_b32_e32 v5, 24, v2
	v_and_b32_e32 v14, 15, v0
	v_lshlrev_b32_e32 v6, 10, v4
	v_and_b32_e32 v13, 16, v4
	s_lshl_b32 s2, s2, 5
	v_bfe_u32 v15, v0, 5, 1
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_or3_b32 v2, s3, v6, v5
	v_or_b32_e32 v9, v14, v13
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_ashrrev_i32_e32 v3, 31, v2
	v_lshl_or_b32 v17, v9, 1, 0x800
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_lshlrev_b64 v[2:3], 1, v[2:3]
	s_waitcnt lgkmcnt(0)
	v_add_co_u32 v11, vcc_lo, s6, v2
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v12, null, s7, v3, vcc_lo
	v_dual_mov_b32 v2, v1 :: v_dual_lshlrev_b32 v7, 1, v5
	v_dual_mov_b32 v3, v1 :: v_dual_add_nc_u32 v6, s2, v6
	s_mov_b32 s6, 32
	v_or_b32_e32 v9, v6, v5
	v_dual_mov_b32 v5, v1 :: v_dual_lshlrev_b32 v8, 6, v14
	v_mov_b32_e32 v6, v1
	v_lshl_or_b32 v16, v4, 6, v7
	v_dual_mov_b32 v7, v1 :: v_dual_lshlrev_b32 v4, 10, v15
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_or_b32_e32 v18, 0x800, v16
	v_dual_mov_b32 v8, v1 :: v_dual_add_nc_u32 v19, v8, v4
	v_mov_b32_e32 v4, v1
.LBB0_1:
	v_ashrrev_i32_e32 v10, 31, v9
	global_load_b128 v[20:23], v[11:12], off
	s_add_i32 s6, s6, -1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	s_cmp_lg_u32 s6, 0
	v_lshlrev_b64 v[24:25], 1, v[9:10]
	v_add_nc_u32_e32 v9, 0x8000, v9
	v_add_co_u32 v24, vcc_lo, s4, v24
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v25, null, s5, v25, vcc_lo
	v_add_co_u32 v11, vcc_lo, v11, 64
	v_add_co_ci_u32_e64 v12, null, 0, v12, vcc_lo
	global_load_b128 v[24:27], v[24:25], off
	s_waitcnt vmcnt(1)
	ds_store_b128 v16, v[20:23]
	s_waitcnt vmcnt(0)
	ds_store_b128 v18, v[24:27]
	s_waitcnt lgkmcnt(0)
	s_barrier
	buffer_gl0_inv
	ds_load_u16_d16 v20, v17
	ds_load_u16_d16 v21, v17 offset:128
	ds_load_u16_d16 v22, v17 offset:256
	ds_load_u16_d16 v23, v17 offset:384
	ds_load_u16_d16 v24, v17 offset:512
	ds_load_u16_d16 v25, v17 offset:640
	ds_load_u16_d16 v26, v17 offset:768
	ds_load_u16_d16 v27, v17 offset:896
	ds_load_u16_d16 v28, v17 offset:1024
	ds_load_u16_d16 v29, v17 offset:1152
	ds_load_u16_d16 v30, v17 offset:1280
	ds_load_u16_d16 v31, v17 offset:1408
	ds_load_u16_d16 v32, v17 offset:1536
	ds_load_u16_d16 v33, v17 offset:1664
	ds_load_u16_d16 v34, v17 offset:1792
	ds_load_u16_d16 v35, v17 offset:1920
	ds_load_b128 v[36:39], v19
	ds_load_b128 v[40:43], v19 offset:16
	ds_load_b128 v[44:47], v19 offset:32
	ds_load_b128 v[48:51], v19 offset:48
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v20, v17 offset:64
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v21, v17 offset:192
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v22, v17 offset:320
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v23, v17 offset:448
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v24, v17 offset:576
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v25, v17 offset:704
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v26, v17 offset:832
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v27, v17 offset:960
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v28, v17 offset:1088
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v29, v17 offset:1216
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v30, v17 offset:1344
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v31, v17 offset:1472
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v32, v17 offset:1600
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v33, v17 offset:1728
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v34, v17 offset:1856
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v35, v17 offset:1984
	s_waitcnt lgkmcnt(8)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[36:43], v[20:27], v[1:8]
	s_waitcnt lgkmcnt(0)
	s_delay_alu instid0(VALU_DEP_1)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[44:51], v[28:35], v[1:8]
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
		.amdhsa_next_free_vgpr 52
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

	.set .Lexercise_kernel_0.num_vgpr, 52
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
    .vgpr_count:     52
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
