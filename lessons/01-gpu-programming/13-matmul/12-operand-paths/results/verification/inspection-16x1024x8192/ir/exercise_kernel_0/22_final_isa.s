	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	exercise_kernel_0
	.p2align	8
	.type	exercise_kernel_0,@function
exercise_kernel_0:
	s_ashr_i32 s17, s2, 31
	s_clause 0x1
	s_load_b64 s[4:5], s[0:1], 0x0
	s_load_b64 s[8:9], s[0:1], 0x18
	s_lshr_b32 s3, s17, 30
	v_lshlrev_b32_e32 v1, 3, v0
	s_add_i32 s3, s2, s3
	v_lshrrev_b32_e32 v49, 3, v0
	s_ashr_i32 s6, s3, 31
	s_ashr_i32 s14, s3, 2
	s_lshr_b32 s6, s6, 28
	s_and_b32 s3, s3, -4
	s_add_i32 s6, s14, s6
	v_and_b32_e32 v50, 56, v1
	v_and_b32_e32 v81, 15, v0
	s_sub_i32 s18, s2, s3
	s_and_b32 s3, s6, -16
	s_lshl_b32 s12, s18, 21
	s_sub_i32 s16, s14, s3
	v_lshl_or_b32 v65, v49, 10, v50
	s_lshl_b32 s3, s16, 6
	v_lshlrev_b32_e32 v51, 14, v81
	s_add_i32 s12, s12, s3
	s_waitcnt lgkmcnt(0)
	s_and_b32 s5, s5, 0xffff
	v_add_lshl_u32 v1, s12, v65, 1
	s_mov_b32 s7, 0x21027000
	v_lshl_add_u32 v85, s18, 12, v51
	s_mov_b32 s6, -1
	s_and_b32 s9, s9, 0xffff
	v_add_nc_u32_e32 v2, 0x4000, v1
	v_add_nc_u32_e32 v3, 0x8000, v1
	s_mov_b32 s10, s6
	s_mov_b32 s11, s7
	v_add_nc_u32_e32 v4, 0xc000, v1
	s_clause 0x1
	buffer_load_b128 v[25:28], v85, s[4:7], 0 offen
	buffer_load_b128 v[29:32], v85, s[4:7], 0 offen offset:16
	s_clause 0x3
	buffer_load_b128 v[33:36], v1, s[8:11], 0 offen slc
	buffer_load_b128 v[37:40], v2, s[8:11], 0 offen slc
	buffer_load_b128 v[41:44], v3, s[8:11], 0 offen slc
	buffer_load_b128 v[45:48], v4, s[8:11], 0 offen slc
	s_clause 0x1
	buffer_load_b128 v[17:20], v85, s[4:7], 0 offen offset:32
	buffer_load_b128 v[21:24], v85, s[4:7], 0 offen offset:48
	v_mov_b32_e32 v1, 0
	v_lshrrev_b32_e32 v52, 1, v0
	v_lshlrev_b32_e32 v54, 11, v49
	s_lshl_b32 s10, s2, 22
	s_lshl_b32 s11, s16, 7
	v_mov_b32_e32 v7, v1
	v_dual_mov_b32 v8, v1 :: v_dual_and_b32 v53, 7, v0
	v_mov_b32_e32 v4, v1
	v_dual_mov_b32 v9, v1 :: v_dual_lshlrev_b32 v66, 7, v49
	v_dual_mov_b32 v11, v1 :: v_dual_and_b32 v82, 16, v52
	v_lshl_add_u32 v49, s2, 12, v51
	v_add3_u32 v51, s11, s10, v54
	s_lshl_b32 s10, s14, 14
	v_mov_b32_e32 v2, v1
	v_dual_mov_b32 v10, v1 :: v_dual_lshlrev_b32 v67, 1, v50
	v_or_b32_e32 v50, v81, v82
	v_subrev_nc_u32_e32 v49, s10, v49
	v_lshl_or_b32 v51, v53, 4, v51
	s_lshl_b32 s10, s14, 24
	v_mov_b32_e32 v3, v1
	v_mov_b32_e32 v5, v1
	v_mov_b32_e32 v6, v1
	v_dual_mov_b32 v12, v1 :: v_dual_lshlrev_b32 v83, 1, v50
	v_mov_b32_e32 v13, v1
	v_mov_b32_e32 v14, v1
	v_mov_b32_e32 v15, v1
	v_mov_b32_e32 v16, v1
	v_or_b32_e32 v52, v67, v66
	v_or_b32_e32 v68, 0x230, v49
	v_subrev_nc_u32_e32 v69, s10, v51
	s_mov_b32 s13, 0
	s_mov_b32 s10, s6
	s_mov_b32 s11, s7
	s_waitcnt vmcnt(5)
	ds_store_b128 v52, v[33:36]
	s_waitcnt vmcnt(4)
	ds_store_b128 v52, v[37:40] offset:1024
	s_waitcnt vmcnt(3)
	ds_store_b128 v52, v[41:44] offset:2048
	s_waitcnt vmcnt(2)
	ds_store_b128 v52, v[45:48] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
.LBB0_1:
	v_add_nc_u32_e32 v70, s13, v69
	v_add_nc_u32_e32 v33, 0xfffffe10, v68
	v_add_nc_u32_e32 v34, 0xfffffe20, v68
	v_add_nc_u32_e32 v35, 0xfffffe30, v68
	v_add_nc_u32_e32 v37, 0xfffffe40, v68
	v_add_nc_u32_e32 v41, 0x10000, v70
	v_add_nc_u32_e32 v42, 0x14000, v70
	v_add_nc_u32_e32 v43, 0x18000, v70
	v_add_nc_u32_e32 v44, 0x1c000, v70
	s_clause 0x3
	buffer_load_b128 v[49:52], v33, s[4:7], 0 offen
	buffer_load_b128 v[53:56], v34, s[4:7], 0 offen
	buffer_load_b128 v[33:36], v35, s[4:7], 0 offen
	buffer_load_b128 v[37:40], v37, s[4:7], 0 offen
	s_clause 0x3
	buffer_load_b128 v[86:89], v41, s[8:11], 0 offen slc
	buffer_load_b128 v[90:93], v42, s[8:11], 0 offen slc
	buffer_load_b128 v[94:97], v43, s[8:11], 0 offen slc
	buffer_load_b128 v[98:101], v44, s[8:11], 0 offen slc
	ds_load_u16_d16 v47, v83 offset:1536
	ds_load_u16_d16_hi v47, v83 offset:1664
	ds_load_u16_d16 v48, v83 offset:1792
	ds_load_u16_d16_hi v48, v83 offset:1920
	ds_load_u16_d16 v41, v83
	ds_load_u16_d16_hi v41, v83 offset:128
	ds_load_u16_d16 v42, v83 offset:256
	ds_load_u16_d16_hi v42, v83 offset:384
	ds_load_u16_d16_hi v58, v83 offset:448
	ds_load_u16_d16 v58, v83 offset:320
	ds_load_u16_d16_hi v57, v83 offset:192
	ds_load_u16_d16 v57, v83 offset:64
	ds_load_u16_d16 v43, v83 offset:512
	ds_load_u16_d16_hi v43, v83 offset:640
	ds_load_u16_d16 v44, v83 offset:768
	ds_load_u16_d16_hi v44, v83 offset:896
	ds_load_u16_d16_hi v60, v83 offset:960
	ds_load_u16_d16 v60, v83 offset:832
	ds_load_u16_d16_hi v59, v83 offset:704
	ds_load_u16_d16 v59, v83 offset:576
	ds_load_u16_d16 v45, v83 offset:1024
	ds_load_u16_d16_hi v45, v83 offset:1152
	ds_load_u16_d16 v46, v83 offset:1280
	ds_load_u16_d16_hi v46, v83 offset:1408
	ds_load_u16_d16_hi v62, v83 offset:1472
	ds_load_u16_d16 v62, v83 offset:1344
	ds_load_u16_d16_hi v61, v83 offset:1216
	ds_load_u16_d16 v61, v83 offset:1088
	ds_load_u16_d16_hi v64, v83 offset:1984
	ds_load_u16_d16 v64, v83 offset:1856
	ds_load_u16_d16_hi v63, v83 offset:1728
	ds_load_u16_d16 v63, v83 offset:1600
	v_add_nc_u32_e32 v84, v67, v66
	v_add_nc_u32_e32 v79, 0xfffffe50, v68
	v_add_nc_u32_e32 v80, 0xfffffe60, v68
	v_add_nc_u32_e32 v102, 0xfffffe90, v68
	v_add_nc_u32_e32 v103, 0xfffffea0, v68
	v_add_nc_u32_e32 v104, 0xfffffeb0, v68
	v_add_nc_u32_e32 v105, 0xfffffec0, v68
	s_add_i32 s13, s13, 0x80000
	s_delay_alu instid0(SALU_CYCLE_1)
	s_cmp_lg_u32 s13, 0x380000
	s_waitcnt vmcnt(10) lgkmcnt(8)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[25:32], v[41:48], v[9:16]
	ds_load_u16_d16_hi v72, v83 offset:2496
	ds_load_u16_d16 v72, v83 offset:2368
	ds_load_u16_d16_hi v71, v83 offset:2240
	ds_load_u16_d16 v71, v83 offset:2112
	ds_load_u16_d16 v43, v83 offset:2560
	ds_load_u16_d16_hi v43, v83 offset:2688
	ds_load_u16_d16 v44, v83 offset:2816
	ds_load_u16_d16_hi v44, v83 offset:2944
	ds_load_u16_d16_hi v74, v83 offset:3008
	ds_load_u16_d16 v74, v83 offset:2880
	ds_load_u16_d16_hi v73, v83 offset:2752
	ds_load_u16_d16 v73, v83 offset:2624
	ds_load_u16_d16 v45, v83 offset:3072
	ds_load_u16_d16_hi v45, v83 offset:3200
	ds_load_u16_d16 v46, v83 offset:3328
	ds_load_u16_d16_hi v46, v83 offset:3456
	ds_load_u16_d16_hi v76, v83 offset:3520
	ds_load_u16_d16 v76, v83 offset:3392
	ds_load_u16_d16_hi v75, v83 offset:3264
	ds_load_u16_d16 v75, v83 offset:3136
	ds_load_u16_d16 v47, v83 offset:3584
	ds_load_u16_d16_hi v47, v83 offset:3712
	ds_load_u16_d16 v48, v83 offset:3840
	ds_load_u16_d16_hi v48, v83 offset:3968
	ds_load_u16_d16_hi v78, v83 offset:4032
	ds_load_u16_d16 v78, v83 offset:3904
	ds_load_u16_d16_hi v77, v83 offset:3776
	ds_load_u16_d16 v77, v83 offset:3648
	ds_load_u16_d16 v41, v83 offset:2048
	ds_load_u16_d16_hi v41, v83 offset:2176
	ds_load_u16_d16 v42, v83 offset:2304
	ds_load_u16_d16_hi v42, v83 offset:2432
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[25:32], v[57:64], v[1:8]
	v_add_nc_u32_e32 v25, 0x20000, v70
	v_add_nc_u32_e32 v29, 0x24000, v70
	v_add_nc_u32_e32 v57, 0x28000, v70
	v_add_nc_u32_e32 v61, 0x2c000, v70
	s_waitcnt vmcnt(8) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[17:24], v[71:78], v[1:8]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[17:24], v[41:48], v[9:16]
	s_barrier
	s_waitcnt vmcnt(3)
	ds_store_b128 v84, v[86:89]
	s_waitcnt vmcnt(2)
	ds_store_b128 v84, v[90:93] offset:1024
	s_waitcnt vmcnt(1)
	ds_store_b128 v84, v[94:97] offset:2048
	s_waitcnt vmcnt(0)
	ds_store_b128 v84, v[98:101] offset:3072
	v_add_nc_u32_e32 v86, 0xfffffe70, v68
	v_add_nc_u32_e32 v87, 0xfffffe80, v68
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x3
	buffer_load_b128 v[25:28], v25, s[8:11], 0 offen slc
	buffer_load_b128 v[29:32], v29, s[8:11], 0 offen slc
	buffer_load_b128 v[57:60], v57, s[8:11], 0 offen slc
	buffer_load_b128 v[61:64], v61, s[8:11], 0 offen slc
	s_clause 0x3
	buffer_load_b128 v[71:74], v79, s[4:7], 0 offen
	buffer_load_b128 v[75:78], v80, s[4:7], 0 offen
	buffer_load_b128 v[41:44], v86, s[4:7], 0 offen
	buffer_load_b128 v[45:48], v87, s[4:7], 0 offen
	ds_load_u16_d16 v21, v83 offset:1024
	ds_load_u16_d16_hi v21, v83 offset:1152
	ds_load_u16_d16 v22, v83 offset:1280
	ds_load_u16_d16_hi v22, v83 offset:1408
	ds_load_u16_d16 v23, v83 offset:1536
	ds_load_u16_d16_hi v23, v83 offset:1664
	ds_load_u16_d16 v24, v83 offset:1792
	ds_load_u16_d16_hi v24, v83 offset:1920
	ds_load_u16_d16 v17, v83
	ds_load_u16_d16_hi v17, v83 offset:128
	ds_load_u16_d16 v18, v83 offset:256
	ds_load_u16_d16_hi v18, v83 offset:384
	ds_load_u16_d16_hi v87, v83 offset:448
	ds_load_u16_d16 v87, v83 offset:320
	ds_load_u16_d16_hi v86, v83 offset:192
	ds_load_u16_d16 v86, v83 offset:64
	ds_load_u16_d16 v19, v83 offset:512
	ds_load_u16_d16_hi v19, v83 offset:640
	ds_load_u16_d16 v20, v83 offset:768
	ds_load_u16_d16_hi v20, v83 offset:896
	ds_load_u16_d16_hi v89, v83 offset:960
	ds_load_u16_d16 v89, v83 offset:832
	ds_load_u16_d16_hi v88, v83 offset:704
	ds_load_u16_d16 v88, v83 offset:576
	ds_load_u16_d16 v90, v83 offset:1088
	ds_load_u16_d16_hi v90, v83 offset:1216
	ds_load_u16_d16 v91, v83 offset:1344
	ds_load_u16_d16_hi v91, v83 offset:1472
	ds_load_u16_d16 v92, v83 offset:1600
	ds_load_u16_d16_hi v92, v83 offset:1728
	ds_load_u16_d16 v93, v83 offset:1856
	ds_load_u16_d16_hi v93, v83 offset:1984
	v_add_nc_u32_e32 v94, 0x30000, v70
	v_add_nc_u32_e32 v79, 0xfffffed0, v68
	v_add_nc_u32_e32 v80, 0xfffffee0, v68
	s_waitcnt lgkmcnt(12)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[49:56], v[17:24], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[49:56], v[86:93], v[1:8]
	ds_load_u16_d16_hi v17, v83 offset:2176
	ds_load_u16_d16 v18, v83 offset:2304
	ds_load_u16_d16_hi v18, v83 offset:2432
	ds_load_u16_d16 v19, v83 offset:2560
	ds_load_u16_d16_hi v87, v83 offset:2496
	ds_load_u16_d16 v87, v83 offset:2368
	ds_load_u16_d16_hi v86, v83 offset:2240
	ds_load_u16_d16 v86, v83 offset:2112
	ds_load_u16_d16_hi v19, v83 offset:2688
	ds_load_u16_d16 v20, v83 offset:2816
	ds_load_u16_d16_hi v20, v83 offset:2944
	ds_load_u16_d16 v21, v83 offset:3072
	ds_load_u16_d16_hi v89, v83 offset:3008
	ds_load_u16_d16 v89, v83 offset:2880
	ds_load_u16_d16_hi v88, v83 offset:2752
	ds_load_u16_d16 v88, v83 offset:2624
	ds_load_u16_d16_hi v21, v83 offset:3200
	ds_load_u16_d16 v22, v83 offset:3328
	ds_load_u16_d16_hi v22, v83 offset:3456
	ds_load_u16_d16 v23, v83 offset:3584
	ds_load_u16_d16_hi v91, v83 offset:3520
	ds_load_u16_d16 v91, v83 offset:3392
	ds_load_u16_d16_hi v90, v83 offset:3264
	ds_load_u16_d16 v90, v83 offset:3136
	ds_load_u16_d16_hi v23, v83 offset:3712
	ds_load_u16_d16 v24, v83 offset:3840
	ds_load_u16_d16_hi v24, v83 offset:3968
	ds_load_u16_d16_hi v93, v83 offset:4032
	ds_load_u16_d16 v93, v83 offset:3904
	ds_load_u16_d16_hi v92, v83 offset:3776
	ds_load_u16_d16 v92, v83 offset:3648
	ds_load_u16_d16 v17, v83 offset:2048
	v_add_nc_u32_e32 v49, 0x34000, v70
	v_add_nc_u32_e32 v50, 0x38000, v70
	v_add_nc_u32_e32 v51, 0x3c000, v70
	s_waitcnt lgkmcnt(1)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[33:40], v[86:93], v[1:8]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[33:40], v[17:24], v[9:16]
	v_add_nc_u32_e32 v86, 0x44000, v70
	v_add_nc_u32_e32 v87, 0x48000, v70
	v_add_nc_u32_e32 v90, 0x4c000, v70
	s_barrier
	s_waitcnt vmcnt(7)
	ds_store_b128 v84, v[25:28]
	s_waitcnt vmcnt(6)
	ds_store_b128 v84, v[29:32] offset:1024
	s_waitcnt vmcnt(5)
	ds_store_b128 v84, v[57:60] offset:2048
	s_waitcnt vmcnt(4)
	ds_store_b128 v84, v[61:64] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x3
	buffer_load_b128 v[57:60], v94, s[8:11], 0 offen slc
	buffer_load_b128 v[61:64], v49, s[8:11], 0 offen slc
	buffer_load_b128 v[94:97], v50, s[8:11], 0 offen slc
	buffer_load_b128 v[98:101], v51, s[8:11], 0 offen slc
	s_clause 0x3
	buffer_load_b128 v[49:52], v102, s[4:7], 0 offen
	buffer_load_b128 v[53:56], v103, s[4:7], 0 offen
	buffer_load_b128 v[17:20], v104, s[4:7], 0 offen
	buffer_load_b128 v[21:24], v105, s[4:7], 0 offen
	ds_load_u16_d16 v25, v83
	ds_load_u16_d16_hi v25, v83 offset:128
	ds_load_u16_d16 v26, v83 offset:256
	ds_load_u16_d16_hi v26, v83 offset:384
	ds_load_u16_d16_hi v34, v83 offset:448
	ds_load_u16_d16 v34, v83 offset:320
	ds_load_u16_d16_hi v33, v83 offset:192
	ds_load_u16_d16 v33, v83 offset:64
	ds_load_u16_d16 v27, v83 offset:512
	ds_load_u16_d16_hi v27, v83 offset:640
	ds_load_u16_d16 v28, v83 offset:768
	ds_load_u16_d16_hi v28, v83 offset:896
	ds_load_u16_d16_hi v36, v83 offset:960
	ds_load_u16_d16 v36, v83 offset:832
	ds_load_u16_d16_hi v35, v83 offset:704
	ds_load_u16_d16 v35, v83 offset:576
	ds_load_u16_d16 v29, v83 offset:1024
	ds_load_u16_d16_hi v29, v83 offset:1152
	ds_load_u16_d16 v30, v83 offset:1280
	ds_load_u16_d16_hi v30, v83 offset:1408
	ds_load_u16_d16_hi v38, v83 offset:1472
	ds_load_u16_d16 v38, v83 offset:1344
	ds_load_u16_d16_hi v37, v83 offset:1216
	ds_load_u16_d16 v37, v83 offset:1088
	ds_load_u16_d16 v31, v83 offset:1536
	ds_load_u16_d16_hi v31, v83 offset:1664
	ds_load_u16_d16 v32, v83 offset:1792
	ds_load_u16_d16_hi v32, v83 offset:1920
	ds_load_u16_d16_hi v40, v83 offset:1984
	ds_load_u16_d16 v40, v83 offset:1856
	ds_load_u16_d16_hi v39, v83 offset:1728
	ds_load_u16_d16 v39, v83 offset:1600
	v_add_nc_u32_e32 v104, 0x40000, v70
	v_add_nc_u32_e32 v102, 0xfffffef0, v68
	v_add_nc_u32_e32 v103, 0xffffff00, v68
	s_waitcnt vmcnt(10) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[71:78], v[25:32], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[71:78], v[33:40], v[1:8]
	ds_load_u16_d16 v25, v83 offset:2048
	ds_load_u16_d16_hi v25, v83 offset:2176
	ds_load_u16_d16 v26, v83 offset:2304
	ds_load_u16_d16_hi v26, v83 offset:2432
	ds_load_u16_d16_hi v34, v83 offset:2496
	ds_load_u16_d16 v34, v83 offset:2368
	ds_load_u16_d16_hi v33, v83 offset:2240
	ds_load_u16_d16 v33, v83 offset:2112
	ds_load_u16_d16 v27, v83 offset:2560
	ds_load_u16_d16_hi v27, v83 offset:2688
	ds_load_u16_d16 v28, v83 offset:2816
	ds_load_u16_d16_hi v28, v83 offset:2944
	ds_load_u16_d16_hi v36, v83 offset:3008
	ds_load_u16_d16 v36, v83 offset:2880
	ds_load_u16_d16_hi v35, v83 offset:2752
	ds_load_u16_d16 v35, v83 offset:2624
	ds_load_u16_d16 v29, v83 offset:3072
	ds_load_u16_d16_hi v29, v83 offset:3200
	ds_load_u16_d16 v30, v83 offset:3328
	ds_load_u16_d16_hi v30, v83 offset:3456
	ds_load_u16_d16_hi v38, v83 offset:3520
	ds_load_u16_d16 v38, v83 offset:3392
	ds_load_u16_d16_hi v37, v83 offset:3264
	ds_load_u16_d16 v37, v83 offset:3136
	ds_load_u16_d16 v31, v83 offset:3584
	ds_load_u16_d16_hi v31, v83 offset:3712
	ds_load_u16_d16 v32, v83 offset:3840
	ds_load_u16_d16_hi v32, v83 offset:3968
	ds_load_u16_d16_hi v40, v83 offset:4032
	ds_load_u16_d16 v40, v83 offset:3904
	ds_load_u16_d16_hi v39, v83 offset:3776
	ds_load_u16_d16 v39, v83 offset:3648
	s_waitcnt vmcnt(8) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[41:48], v[25:32], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[41:48], v[33:40], v[1:8]
	s_barrier
	s_waitcnt vmcnt(7)
	ds_store_b128 v84, v[57:60]
	s_waitcnt vmcnt(6)
	ds_store_b128 v84, v[61:64] offset:1024
	s_waitcnt vmcnt(5)
	ds_store_b128 v84, v[94:97] offset:2048
	s_waitcnt vmcnt(4)
	ds_store_b128 v84, v[98:101] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x3
	buffer_load_b128 v[71:74], v104, s[8:11], 0 offen slc
	buffer_load_b128 v[75:78], v86, s[8:11], 0 offen slc
	buffer_load_b128 v[86:89], v87, s[8:11], 0 offen slc
	buffer_load_b128 v[90:93], v90, s[8:11], 0 offen slc
	s_clause 0x3
	buffer_load_b128 v[57:60], v79, s[4:7], 0 offen
	buffer_load_b128 v[61:64], v80, s[4:7], 0 offen
	buffer_load_b128 v[25:28], v102, s[4:7], 0 offen
	buffer_load_b128 v[29:32], v103, s[4:7], 0 offen
	ds_load_u16_d16 v33, v83
	ds_load_u16_d16_hi v33, v83 offset:128
	ds_load_u16_d16 v34, v83 offset:256
	ds_load_u16_d16_hi v34, v83 offset:384
	ds_load_u16_d16_hi v42, v83 offset:448
	ds_load_u16_d16 v42, v83 offset:320
	ds_load_u16_d16_hi v41, v83 offset:192
	ds_load_u16_d16 v41, v83 offset:64
	ds_load_u16_d16 v35, v83 offset:512
	ds_load_u16_d16_hi v35, v83 offset:640
	ds_load_u16_d16 v36, v83 offset:768
	ds_load_u16_d16_hi v36, v83 offset:896
	ds_load_u16_d16_hi v44, v83 offset:960
	ds_load_u16_d16 v44, v83 offset:832
	ds_load_u16_d16_hi v43, v83 offset:704
	ds_load_u16_d16 v43, v83 offset:576
	ds_load_u16_d16 v37, v83 offset:1024
	ds_load_u16_d16_hi v37, v83 offset:1152
	ds_load_u16_d16 v38, v83 offset:1280
	ds_load_u16_d16_hi v38, v83 offset:1408
	ds_load_u16_d16_hi v46, v83 offset:1472
	ds_load_u16_d16 v46, v83 offset:1344
	ds_load_u16_d16_hi v45, v83 offset:1216
	ds_load_u16_d16 v45, v83 offset:1088
	ds_load_u16_d16 v39, v83 offset:1536
	ds_load_u16_d16_hi v39, v83 offset:1664
	ds_load_u16_d16 v40, v83 offset:1792
	ds_load_u16_d16_hi v40, v83 offset:1920
	ds_load_u16_d16_hi v48, v83 offset:1984
	ds_load_u16_d16 v48, v83 offset:1856
	ds_load_u16_d16_hi v47, v83 offset:1728
	ds_load_u16_d16 v47, v83 offset:1600
	v_add_nc_u32_e32 v96, 0x50000, v70
	v_add_nc_u32_e32 v97, 0x54000, v70
	v_add_nc_u32_e32 v98, 0x58000, v70
	v_add_nc_u32_e32 v99, 0x5c000, v70
	v_add_nc_u32_e32 v79, 0xffffff10, v68
	v_add_nc_u32_e32 v80, 0xffffff20, v68
	v_add_nc_u32_e32 v94, 0xffffff30, v68
	v_add_nc_u32_e32 v95, 0xffffff40, v68
	v_add_nc_u32_e32 v102, 0xffffffb0, v68
	v_subrev_nc_u32_e32 v103, 64, v68
	v_add_nc_u32_e32 v104, 0x84000, v70
	s_waitcnt vmcnt(10) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[49:56], v[33:40], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[49:56], v[41:48], v[1:8]
	ds_load_u16_d16 v33, v83 offset:2048
	ds_load_u16_d16_hi v33, v83 offset:2176
	ds_load_u16_d16 v34, v83 offset:2304
	ds_load_u16_d16_hi v34, v83 offset:2432
	ds_load_u16_d16_hi v50, v83 offset:2496
	ds_load_u16_d16 v50, v83 offset:2368
	ds_load_u16_d16_hi v49, v83 offset:2240
	ds_load_u16_d16 v49, v83 offset:2112
	ds_load_u16_d16 v35, v83 offset:2560
	ds_load_u16_d16_hi v35, v83 offset:2688
	ds_load_u16_d16 v36, v83 offset:2816
	ds_load_u16_d16_hi v36, v83 offset:2944
	ds_load_u16_d16_hi v52, v83 offset:3008
	ds_load_u16_d16 v52, v83 offset:2880
	ds_load_u16_d16_hi v51, v83 offset:2752
	ds_load_u16_d16 v51, v83 offset:2624
	ds_load_u16_d16 v37, v83 offset:3072
	ds_load_u16_d16_hi v37, v83 offset:3200
	ds_load_u16_d16 v38, v83 offset:3328
	ds_load_u16_d16_hi v38, v83 offset:3456
	ds_load_u16_d16_hi v54, v83 offset:3520
	ds_load_u16_d16 v54, v83 offset:3392
	ds_load_u16_d16_hi v53, v83 offset:3264
	ds_load_u16_d16 v53, v83 offset:3136
	ds_load_u16_d16 v39, v83 offset:3584
	ds_load_u16_d16_hi v39, v83 offset:3712
	ds_load_u16_d16 v40, v83 offset:3840
	ds_load_u16_d16_hi v40, v83 offset:3968
	ds_load_u16_d16_hi v56, v83 offset:4032
	ds_load_u16_d16 v56, v83 offset:3904
	ds_load_u16_d16_hi v55, v83 offset:3776
	ds_load_u16_d16 v55, v83 offset:3648
	s_waitcnt vmcnt(8) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[17:24], v[33:40], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[17:24], v[49:56], v[1:8]
	s_barrier
	s_waitcnt vmcnt(7)
	ds_store_b128 v84, v[71:74]
	s_waitcnt vmcnt(6)
	ds_store_b128 v84, v[75:78] offset:1024
	s_waitcnt vmcnt(5)
	ds_store_b128 v84, v[86:89] offset:2048
	s_waitcnt vmcnt(4)
	ds_store_b128 v84, v[90:93] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x3
	buffer_load_b128 v[71:74], v96, s[8:11], 0 offen slc
	buffer_load_b128 v[75:78], v97, s[8:11], 0 offen slc
	buffer_load_b128 v[86:89], v98, s[8:11], 0 offen slc
	buffer_load_b128 v[90:93], v99, s[8:11], 0 offen slc
	s_clause 0x3
	buffer_load_b128 v[41:44], v79, s[4:7], 0 offen
	buffer_load_b128 v[45:48], v80, s[4:7], 0 offen
	buffer_load_b128 v[33:36], v94, s[4:7], 0 offen
	buffer_load_b128 v[37:40], v95, s[4:7], 0 offen
	ds_load_u16_d16 v17, v83
	ds_load_u16_d16_hi v17, v83 offset:128
	ds_load_u16_d16 v18, v83 offset:256
	ds_load_u16_d16_hi v18, v83 offset:384
	ds_load_u16_d16_hi v50, v83 offset:448
	ds_load_u16_d16 v50, v83 offset:320
	ds_load_u16_d16_hi v49, v83 offset:192
	ds_load_u16_d16 v49, v83 offset:64
	ds_load_u16_d16 v19, v83 offset:512
	ds_load_u16_d16_hi v19, v83 offset:640
	ds_load_u16_d16 v20, v83 offset:768
	ds_load_u16_d16_hi v20, v83 offset:896
	ds_load_u16_d16_hi v52, v83 offset:960
	ds_load_u16_d16 v52, v83 offset:832
	ds_load_u16_d16_hi v51, v83 offset:704
	ds_load_u16_d16 v51, v83 offset:576
	ds_load_u16_d16 v21, v83 offset:1024
	ds_load_u16_d16_hi v21, v83 offset:1152
	ds_load_u16_d16 v22, v83 offset:1280
	ds_load_u16_d16_hi v22, v83 offset:1408
	ds_load_u16_d16_hi v54, v83 offset:1472
	ds_load_u16_d16 v54, v83 offset:1344
	ds_load_u16_d16_hi v53, v83 offset:1216
	ds_load_u16_d16 v53, v83 offset:1088
	ds_load_u16_d16 v23, v83 offset:1536
	ds_load_u16_d16_hi v23, v83 offset:1664
	ds_load_u16_d16 v24, v83 offset:1792
	ds_load_u16_d16_hi v24, v83 offset:1920
	ds_load_u16_d16_hi v56, v83 offset:1984
	ds_load_u16_d16 v56, v83 offset:1856
	ds_load_u16_d16_hi v55, v83 offset:1728
	ds_load_u16_d16 v55, v83 offset:1600
	v_add_nc_u32_e32 v96, 0x60000, v70
	v_add_nc_u32_e32 v97, 0x64000, v70
	v_add_nc_u32_e32 v98, 0x68000, v70
	v_add_nc_u32_e32 v99, 0x6c000, v70
	v_add_nc_u32_e32 v79, 0xffffff50, v68
	v_add_nc_u32_e32 v80, 0xffffff60, v68
	v_add_nc_u32_e32 v94, 0xffffff70, v68
	v_add_nc_u32_e32 v95, 0xffffff80, v68
	s_waitcnt vmcnt(10) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[57:64], v[17:24], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[57:64], v[49:56], v[1:8]
	ds_load_u16_d16 v17, v83 offset:2048
	ds_load_u16_d16_hi v17, v83 offset:2176
	ds_load_u16_d16 v18, v83 offset:2304
	ds_load_u16_d16_hi v18, v83 offset:2432
	ds_load_u16_d16_hi v58, v83 offset:2496
	ds_load_u16_d16 v58, v83 offset:2368
	ds_load_u16_d16_hi v57, v83 offset:2240
	ds_load_u16_d16 v57, v83 offset:2112
	ds_load_u16_d16 v19, v83 offset:2560
	ds_load_u16_d16_hi v19, v83 offset:2688
	ds_load_u16_d16 v20, v83 offset:2816
	ds_load_u16_d16_hi v20, v83 offset:2944
	ds_load_u16_d16_hi v60, v83 offset:3008
	ds_load_u16_d16 v60, v83 offset:2880
	ds_load_u16_d16_hi v59, v83 offset:2752
	ds_load_u16_d16 v59, v83 offset:2624
	ds_load_u16_d16 v21, v83 offset:3072
	ds_load_u16_d16_hi v21, v83 offset:3200
	ds_load_u16_d16 v22, v83 offset:3328
	ds_load_u16_d16_hi v22, v83 offset:3456
	ds_load_u16_d16_hi v62, v83 offset:3520
	ds_load_u16_d16 v62, v83 offset:3392
	ds_load_u16_d16_hi v61, v83 offset:3264
	ds_load_u16_d16 v61, v83 offset:3136
	ds_load_u16_d16 v23, v83 offset:3584
	ds_load_u16_d16_hi v23, v83 offset:3712
	ds_load_u16_d16 v24, v83 offset:3840
	ds_load_u16_d16_hi v24, v83 offset:3968
	ds_load_u16_d16_hi v64, v83 offset:4032
	ds_load_u16_d16 v64, v83 offset:3904
	ds_load_u16_d16_hi v63, v83 offset:3776
	ds_load_u16_d16 v63, v83 offset:3648
	s_waitcnt vmcnt(8) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[25:32], v[17:24], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[25:32], v[57:64], v[1:8]
	s_barrier
	s_waitcnt vmcnt(7)
	ds_store_b128 v84, v[71:74]
	s_waitcnt vmcnt(6)
	ds_store_b128 v84, v[75:78] offset:1024
	s_waitcnt vmcnt(5)
	ds_store_b128 v84, v[86:89] offset:2048
	s_waitcnt vmcnt(4)
	ds_store_b128 v84, v[90:93] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x3
	buffer_load_b128 v[71:74], v96, s[8:11], 0 offen slc
	buffer_load_b128 v[75:78], v97, s[8:11], 0 offen slc
	buffer_load_b128 v[86:89], v98, s[8:11], 0 offen slc
	buffer_load_b128 v[90:93], v99, s[8:11], 0 offen slc
	s_clause 0x3
	buffer_load_b128 v[17:20], v79, s[4:7], 0 offen
	buffer_load_b128 v[21:24], v80, s[4:7], 0 offen
	buffer_load_b128 v[49:52], v94, s[4:7], 0 offen
	buffer_load_b128 v[53:56], v95, s[4:7], 0 offen
	ds_load_u16_d16 v25, v83
	ds_load_u16_d16_hi v25, v83 offset:128
	ds_load_u16_d16 v26, v83 offset:256
	ds_load_u16_d16_hi v26, v83 offset:384
	ds_load_u16_d16_hi v58, v83 offset:448
	ds_load_u16_d16 v58, v83 offset:320
	ds_load_u16_d16_hi v57, v83 offset:192
	ds_load_u16_d16 v57, v83 offset:64
	ds_load_u16_d16 v27, v83 offset:512
	ds_load_u16_d16_hi v27, v83 offset:640
	ds_load_u16_d16 v28, v83 offset:768
	ds_load_u16_d16_hi v28, v83 offset:896
	ds_load_u16_d16_hi v60, v83 offset:960
	ds_load_u16_d16 v60, v83 offset:832
	ds_load_u16_d16_hi v59, v83 offset:704
	ds_load_u16_d16 v59, v83 offset:576
	ds_load_u16_d16 v29, v83 offset:1024
	ds_load_u16_d16_hi v29, v83 offset:1152
	ds_load_u16_d16 v30, v83 offset:1280
	ds_load_u16_d16_hi v30, v83 offset:1408
	ds_load_u16_d16_hi v62, v83 offset:1472
	ds_load_u16_d16 v62, v83 offset:1344
	ds_load_u16_d16_hi v61, v83 offset:1216
	ds_load_u16_d16 v61, v83 offset:1088
	ds_load_u16_d16 v31, v83 offset:1536
	ds_load_u16_d16_hi v31, v83 offset:1664
	ds_load_u16_d16 v32, v83 offset:1792
	ds_load_u16_d16_hi v32, v83 offset:1920
	ds_load_u16_d16_hi v64, v83 offset:1984
	ds_load_u16_d16 v64, v83 offset:1856
	ds_load_u16_d16_hi v63, v83 offset:1728
	ds_load_u16_d16 v63, v83 offset:1600
	v_add_nc_u32_e32 v94, 0x70000, v70
	v_add_nc_u32_e32 v95, 0x74000, v70
	v_add_nc_u32_e32 v96, 0x78000, v70
	v_add_nc_u32_e32 v98, 0x7c000, v70
	v_add_nc_u32_e32 v79, 0xffffff90, v68
	v_add_nc_u32_e32 v80, 0xffffffa0, v68
	s_waitcnt vmcnt(10) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[41:48], v[25:32], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[41:48], v[57:64], v[1:8]
	ds_load_u16_d16 v25, v83 offset:2048
	ds_load_u16_d16_hi v25, v83 offset:2176
	ds_load_u16_d16 v26, v83 offset:2304
	ds_load_u16_d16_hi v26, v83 offset:2432
	ds_load_u16_d16_hi v42, v83 offset:2496
	ds_load_u16_d16 v42, v83 offset:2368
	ds_load_u16_d16_hi v41, v83 offset:2240
	ds_load_u16_d16 v41, v83 offset:2112
	ds_load_u16_d16 v27, v83 offset:2560
	ds_load_u16_d16_hi v27, v83 offset:2688
	ds_load_u16_d16 v28, v83 offset:2816
	ds_load_u16_d16_hi v28, v83 offset:2944
	ds_load_u16_d16_hi v44, v83 offset:3008
	ds_load_u16_d16 v44, v83 offset:2880
	ds_load_u16_d16_hi v43, v83 offset:2752
	ds_load_u16_d16 v43, v83 offset:2624
	ds_load_u16_d16 v29, v83 offset:3072
	ds_load_u16_d16_hi v29, v83 offset:3200
	ds_load_u16_d16 v30, v83 offset:3328
	ds_load_u16_d16_hi v30, v83 offset:3456
	ds_load_u16_d16_hi v46, v83 offset:3520
	ds_load_u16_d16 v46, v83 offset:3392
	ds_load_u16_d16_hi v45, v83 offset:3264
	ds_load_u16_d16 v45, v83 offset:3136
	ds_load_u16_d16 v31, v83 offset:3584
	ds_load_u16_d16_hi v31, v83 offset:3712
	ds_load_u16_d16 v32, v83 offset:3840
	ds_load_u16_d16_hi v32, v83 offset:3968
	ds_load_u16_d16_hi v48, v83 offset:4032
	ds_load_u16_d16 v48, v83 offset:3904
	ds_load_u16_d16_hi v47, v83 offset:3776
	ds_load_u16_d16 v47, v83 offset:3648
	s_waitcnt vmcnt(8) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[33:40], v[25:32], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[33:40], v[41:48], v[1:8]
	s_barrier
	s_waitcnt vmcnt(7)
	ds_store_b128 v84, v[71:74]
	s_waitcnt vmcnt(6)
	ds_store_b128 v84, v[75:78] offset:1024
	s_waitcnt vmcnt(5)
	ds_store_b128 v84, v[86:89] offset:2048
	s_waitcnt vmcnt(4)
	ds_store_b128 v84, v[90:93] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x3
	buffer_load_b128 v[86:89], v94, s[8:11], 0 offen slc
	buffer_load_b128 v[90:93], v95, s[8:11], 0 offen slc
	buffer_load_b128 v[94:97], v96, s[8:11], 0 offen slc
	buffer_load_b128 v[98:101], v98, s[8:11], 0 offen slc
	s_clause 0x3
	buffer_load_b128 v[57:60], v79, s[4:7], 0 offen
	buffer_load_b128 v[61:64], v80, s[4:7], 0 offen
	buffer_load_b128 v[71:74], v102, s[4:7], 0 offen
	buffer_load_b128 v[75:78], v103, s[4:7], 0 offen
	ds_load_u16_d16 v25, v83
	ds_load_u16_d16_hi v25, v83 offset:128
	ds_load_u16_d16 v26, v83 offset:256
	ds_load_u16_d16_hi v26, v83 offset:384
	ds_load_u16_d16_hi v34, v83 offset:448
	ds_load_u16_d16 v34, v83 offset:320
	ds_load_u16_d16_hi v33, v83 offset:192
	ds_load_u16_d16 v33, v83 offset:64
	ds_load_u16_d16 v27, v83 offset:512
	ds_load_u16_d16_hi v27, v83 offset:640
	ds_load_u16_d16 v28, v83 offset:768
	ds_load_u16_d16_hi v28, v83 offset:896
	ds_load_u16_d16_hi v36, v83 offset:960
	ds_load_u16_d16 v36, v83 offset:832
	ds_load_u16_d16_hi v35, v83 offset:704
	ds_load_u16_d16 v35, v83 offset:576
	ds_load_u16_d16 v29, v83 offset:1024
	ds_load_u16_d16_hi v29, v83 offset:1152
	ds_load_u16_d16 v30, v83 offset:1280
	ds_load_u16_d16_hi v30, v83 offset:1408
	ds_load_u16_d16_hi v38, v83 offset:1472
	ds_load_u16_d16 v38, v83 offset:1344
	ds_load_u16_d16_hi v37, v83 offset:1216
	ds_load_u16_d16 v37, v83 offset:1088
	ds_load_u16_d16 v31, v83 offset:1536
	ds_load_u16_d16_hi v31, v83 offset:1664
	ds_load_u16_d16 v32, v83 offset:1792
	ds_load_u16_d16_hi v32, v83 offset:1920
	ds_load_u16_d16_hi v40, v83 offset:1984
	ds_load_u16_d16 v40, v83 offset:1856
	ds_load_u16_d16_hi v39, v83 offset:1728
	ds_load_u16_d16 v39, v83 offset:1600
	v_add_nc_u32_e32 v103, 0x80000, v70
	v_subrev_nc_u32_e32 v79, 48, v68
	v_subrev_nc_u32_e32 v80, 32, v68
	v_add_nc_u32_e32 v102, -16, v68
	s_waitcnt vmcnt(10) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[17:24], v[25:32], v[9:16]
	v_add_nc_u32_e32 v25, 0x88000, v70
	v_add_nc_u32_e32 v26, 0x8c000, v70
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[17:24], v[33:40], v[1:8]
	ds_load_u16_d16 v17, v83 offset:2048
	ds_load_u16_d16_hi v17, v83 offset:2176
	ds_load_u16_d16 v18, v83 offset:2304
	ds_load_u16_d16_hi v18, v83 offset:2432
	ds_load_u16_d16_hi v34, v83 offset:2496
	ds_load_u16_d16 v34, v83 offset:2368
	ds_load_u16_d16_hi v33, v83 offset:2240
	ds_load_u16_d16 v33, v83 offset:2112
	ds_load_u16_d16 v19, v83 offset:2560
	ds_load_u16_d16_hi v19, v83 offset:2688
	ds_load_u16_d16 v20, v83 offset:2816
	ds_load_u16_d16_hi v20, v83 offset:2944
	ds_load_u16_d16_hi v36, v83 offset:3008
	ds_load_u16_d16 v36, v83 offset:2880
	ds_load_u16_d16_hi v35, v83 offset:2752
	ds_load_u16_d16 v35, v83 offset:2624
	ds_load_u16_d16 v21, v83 offset:3072
	ds_load_u16_d16_hi v21, v83 offset:3200
	ds_load_u16_d16 v22, v83 offset:3328
	ds_load_u16_d16_hi v22, v83 offset:3456
	ds_load_u16_d16_hi v38, v83 offset:3520
	ds_load_u16_d16 v38, v83 offset:3392
	ds_load_u16_d16_hi v37, v83 offset:3264
	ds_load_u16_d16 v37, v83 offset:3136
	ds_load_u16_d16 v23, v83 offset:3584
	ds_load_u16_d16_hi v23, v83 offset:3712
	ds_load_u16_d16 v24, v83 offset:3840
	ds_load_u16_d16_hi v24, v83 offset:3968
	ds_load_u16_d16_hi v40, v83 offset:4032
	ds_load_u16_d16 v40, v83 offset:3904
	ds_load_u16_d16_hi v39, v83 offset:3776
	ds_load_u16_d16 v39, v83 offset:3648
	s_waitcnt vmcnt(8) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[49:56], v[17:24], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[49:56], v[33:40], v[1:8]
	s_barrier
	s_waitcnt vmcnt(7)
	ds_store_b128 v84, v[86:89]
	s_waitcnt vmcnt(6)
	ds_store_b128 v84, v[90:93] offset:1024
	s_waitcnt vmcnt(5)
	ds_store_b128 v84, v[94:97] offset:2048
	s_waitcnt vmcnt(4)
	ds_store_b128 v84, v[98:101] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x3
	buffer_load_b128 v[86:89], v103, s[8:11], 0 offen slc
	buffer_load_b128 v[90:93], v104, s[8:11], 0 offen slc
	buffer_load_b128 v[94:97], v25, s[8:11], 0 offen slc
	buffer_load_b128 v[98:101], v26, s[8:11], 0 offen slc
	s_clause 0x3
	buffer_load_b128 v[25:28], v79, s[4:7], 0 offen
	buffer_load_b128 v[29:32], v80, s[4:7], 0 offen
	buffer_load_b128 v[17:20], v102, s[4:7], 0 offen
	buffer_load_b128 v[21:24], v68, s[4:7], 0 offen
	ds_load_u16_d16 v39, v83 offset:1536
	ds_load_u16_d16_hi v39, v83 offset:1664
	ds_load_u16_d16 v40, v83 offset:1792
	ds_load_u16_d16_hi v40, v83 offset:1920
	ds_load_u16_d16 v33, v83
	ds_load_u16_d16_hi v33, v83 offset:128
	ds_load_u16_d16 v34, v83 offset:256
	ds_load_u16_d16_hi v34, v83 offset:384
	ds_load_u16_d16_hi v42, v83 offset:448
	ds_load_u16_d16 v42, v83 offset:320
	ds_load_u16_d16_hi v41, v83 offset:192
	ds_load_u16_d16 v41, v83 offset:64
	ds_load_u16_d16 v35, v83 offset:512
	ds_load_u16_d16_hi v35, v83 offset:640
	ds_load_u16_d16 v36, v83 offset:768
	ds_load_u16_d16_hi v36, v83 offset:896
	ds_load_u16_d16_hi v44, v83 offset:960
	ds_load_u16_d16 v44, v83 offset:832
	ds_load_u16_d16_hi v43, v83 offset:704
	ds_load_u16_d16 v43, v83 offset:576
	ds_load_u16_d16 v37, v83 offset:1024
	ds_load_u16_d16_hi v37, v83 offset:1152
	ds_load_u16_d16 v38, v83 offset:1280
	ds_load_u16_d16_hi v38, v83 offset:1408
	ds_load_u16_d16_hi v46, v83 offset:1472
	ds_load_u16_d16 v46, v83 offset:1344
	ds_load_u16_d16_hi v45, v83 offset:1216
	ds_load_u16_d16 v45, v83 offset:1088
	ds_load_u16_d16_hi v48, v83 offset:1984
	ds_load_u16_d16 v48, v83 offset:1856
	ds_load_u16_d16_hi v47, v83 offset:1728
	ds_load_u16_d16 v47, v83 offset:1600
	v_add_nc_u32_e32 v68, 0x200, v68
	s_waitcnt vmcnt(10) lgkmcnt(8)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[57:64], v[33:40], v[9:16]
	ds_load_u16_d16 v33, v83 offset:2048
	ds_load_u16_d16_hi v33, v83 offset:2176
	ds_load_u16_d16 v34, v83 offset:2304
	ds_load_u16_d16_hi v34, v83 offset:2432
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[57:64], v[41:48], v[1:8]
	ds_load_u16_d16_hi v42, v83 offset:2496
	ds_load_u16_d16 v42, v83 offset:2368
	ds_load_u16_d16_hi v41, v83 offset:2240
	ds_load_u16_d16 v41, v83 offset:2112
	ds_load_u16_d16 v35, v83 offset:2560
	ds_load_u16_d16_hi v35, v83 offset:2688
	ds_load_u16_d16 v36, v83 offset:2816
	ds_load_u16_d16_hi v36, v83 offset:2944
	ds_load_u16_d16_hi v44, v83 offset:3008
	ds_load_u16_d16 v44, v83 offset:2880
	ds_load_u16_d16_hi v43, v83 offset:2752
	ds_load_u16_d16 v43, v83 offset:2624
	ds_load_u16_d16 v37, v83 offset:3072
	ds_load_u16_d16_hi v37, v83 offset:3200
	ds_load_u16_d16 v38, v83 offset:3328
	ds_load_u16_d16_hi v38, v83 offset:3456
	ds_load_u16_d16_hi v46, v83 offset:3520
	ds_load_u16_d16 v46, v83 offset:3392
	ds_load_u16_d16_hi v45, v83 offset:3264
	ds_load_u16_d16 v45, v83 offset:3136
	ds_load_u16_d16 v39, v83 offset:3584
	ds_load_u16_d16_hi v39, v83 offset:3712
	ds_load_u16_d16 v40, v83 offset:3840
	ds_load_u16_d16_hi v40, v83 offset:3968
	ds_load_u16_d16_hi v48, v83 offset:4032
	ds_load_u16_d16 v48, v83 offset:3904
	ds_load_u16_d16_hi v47, v83 offset:3776
	ds_load_u16_d16 v47, v83 offset:3648
	s_waitcnt vmcnt(8) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[71:78], v[33:40], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[71:78], v[41:48], v[1:8]
	s_barrier
	s_waitcnt vmcnt(7)
	ds_store_b128 v84, v[86:89]
	s_waitcnt vmcnt(6)
	ds_store_b128 v84, v[90:93] offset:1024
	s_waitcnt vmcnt(5)
	ds_store_b128 v84, v[94:97] offset:2048
	s_waitcnt vmcnt(4)
	ds_store_b128 v84, v[98:101] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_cbranch_scc1 .LBB0_1
	s_add_i32 s12, s12, 0x1c8000
	s_mov_b32 s10, s6
	v_add_lshl_u32 v49, s12, v65, 1
	s_mov_b32 s11, s7
	s_clause 0x1
	buffer_load_b128 v[33:36], v85, s[4:7], 0 offen offset:3648
	buffer_load_b128 v[37:40], v85, s[4:7], 0 offen offset:3664
	ds_load_u16_d16 v86, v83 offset:2048
	ds_load_u16_d16_hi v86, v83 offset:2176
	ds_load_u16_d16 v87, v83 offset:2304
	ds_load_u16_d16_hi v87, v83 offset:2432
	ds_load_u16_d16_hi v95, v83 offset:2496
	ds_load_u16_d16 v95, v83 offset:2368
	ds_load_u16_d16_hi v94, v83 offset:2240
	ds_load_u16_d16 v94, v83 offset:2112
	ds_load_u16_d16 v88, v83 offset:2560
	ds_load_u16_d16_hi v88, v83 offset:2688
	ds_load_u16_d16 v89, v83 offset:2816
	ds_load_u16_d16_hi v89, v83 offset:2944
	ds_load_u16_d16_hi v97, v83 offset:3008
	ds_load_u16_d16 v97, v83 offset:2880
	ds_load_u16_d16_hi v96, v83 offset:2752
	ds_load_u16_d16 v96, v83 offset:2624
	ds_load_u16_d16 v90, v83 offset:3072
	ds_load_u16_d16_hi v90, v83 offset:3200
	ds_load_u16_d16 v91, v83 offset:3328
	ds_load_u16_d16_hi v91, v83 offset:3456
	ds_load_u16_d16_hi v99, v83 offset:3520
	ds_load_u16_d16 v99, v83 offset:3392
	ds_load_u16_d16_hi v98, v83 offset:3264
	ds_load_u16_d16 v98, v83 offset:3136
	ds_load_u16_d16 v92, v83 offset:3584
	ds_load_u16_d16_hi v92, v83 offset:3712
	ds_load_u16_d16 v93, v83 offset:3840
	ds_load_u16_d16_hi v93, v83 offset:3968
	ds_load_u16_d16_hi v101, v83 offset:4032
	ds_load_u16_d16 v101, v83 offset:3904
	ds_load_u16_d16_hi v100, v83 offset:3776
	ds_load_u16_d16 v100, v83 offset:3648
	s_clause 0x1
	s_load_b64 s[12:13], s[0:1], 0x48
	s_load_b64 s[14:15], s[0:1], 0x58
	v_add_nc_u32_e32 v50, 0x4000, v49
	v_add_nc_u32_e32 v51, 0x8000, v49
	v_add_nc_u32_e32 v52, 0xc000, v49
	s_clause 0x1
	buffer_load_b128 v[41:44], v85, s[4:7], 0 offen offset:3680
	buffer_load_b128 v[45:48], v85, s[4:7], 0 offen offset:3696
	s_clause 0x3
	buffer_load_b128 v[66:69], v49, s[8:11], 0 offen slc
	buffer_load_b128 v[74:77], v50, s[8:11], 0 offen slc
	buffer_load_b128 v[102:105], v51, s[8:11], 0 offen slc
	buffer_load_b128 v[106:109], v52, s[8:11], 0 offen slc
	ds_load_u16_d16 v49, v83
	ds_load_u16_d16_hi v49, v83 offset:128
	ds_load_u16_d16 v50, v83 offset:256
	ds_load_u16_d16_hi v50, v83 offset:384
	ds_load_u16_d16_hi v58, v83 offset:448
	ds_load_u16_d16 v58, v83 offset:320
	ds_load_u16_d16_hi v57, v83 offset:192
	ds_load_u16_d16 v57, v83 offset:64
	ds_load_u16_d16 v51, v83 offset:512
	ds_load_u16_d16_hi v51, v83 offset:640
	ds_load_u16_d16 v52, v83 offset:768
	ds_load_u16_d16_hi v52, v83 offset:896
	ds_load_u16_d16_hi v60, v83 offset:960
	ds_load_u16_d16 v60, v83 offset:832
	ds_load_u16_d16_hi v59, v83 offset:704
	ds_load_u16_d16 v59, v83 offset:576
	ds_load_u16_d16 v53, v83 offset:1024
	ds_load_u16_d16_hi v53, v83 offset:1152
	ds_load_u16_d16 v54, v83 offset:1280
	ds_load_u16_d16_hi v54, v83 offset:1408
	ds_load_u16_d16_hi v62, v83 offset:1472
	ds_load_u16_d16 v62, v83 offset:1344
	ds_load_u16_d16_hi v61, v83 offset:1216
	ds_load_u16_d16 v61, v83 offset:1088
	ds_load_u16_d16 v55, v83 offset:1536
	ds_load_u16_d16_hi v55, v83 offset:1664
	ds_load_u16_d16 v56, v83 offset:1792
	ds_load_u16_d16_hi v56, v83 offset:1920
	ds_load_u16_d16_hi v64, v83 offset:1984
	ds_load_u16_d16 v64, v83 offset:1856
	ds_load_u16_d16_hi v63, v83 offset:1728
	ds_load_u16_d16 v63, v83 offset:1600
	v_add_nc_u32_e32 v65, s3, v65
	s_lshl_b32 s18, s18, 22
	s_delay_alu instid0(VALU_DEP_1) | instid1(SALU_CYCLE_1)
	v_lshl_add_u32 v73, v65, 1, s18
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v65, 0x3a0000, v73
	v_add_nc_u32_e32 v70, 0x4000, v65
	s_waitcnt vmcnt(10) lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[25:32], v[49:56], v[9:16]
	v_add_nc_u32_e32 v78, 0x8000, v65
	v_add_nc_u32_e32 v79, 0xc000, v65
	v_wmma_f32_16x16x16_bf16 v[1:8], v[25:32], v[57:64], v[1:8]
	s_waitcnt vmcnt(8)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[17:24], v[86:93], v[9:16]
	s_delay_alu instid0(VALU_DEP_2)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[17:24], v[94:101], v[1:8]
	s_barrier
	s_waitcnt vmcnt(3)
	ds_store_b128 v84, v[66:69]
	s_waitcnt vmcnt(2)
	ds_store_b128 v84, v[74:77] offset:1024
	s_waitcnt vmcnt(1)
	ds_store_b128 v84, v[102:105] offset:2048
	s_waitcnt vmcnt(0)
	ds_store_b128 v84, v[106:109] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x3
	buffer_load_b128 v[65:68], v65, s[8:11], 0 offen slc
	buffer_load_b128 v[69:72], v70, s[8:11], 0 offen slc
	buffer_load_b128 v[74:77], v78, s[8:11], 0 offen slc
	buffer_load_b128 v[102:105], v79, s[8:11], 0 offen slc
	s_clause 0x3
	buffer_load_b128 v[25:28], v85, s[4:7], 0 offen offset:3712
	buffer_load_b128 v[29:32], v85, s[4:7], 0 offen offset:3728
	buffer_load_b128 v[17:20], v85, s[4:7], 0 offen offset:3744
	buffer_load_b128 v[21:24], v85, s[4:7], 0 offen offset:3760
	ds_load_u16_d16 v57, v83
	ds_load_u16_d16_hi v57, v83 offset:128
	ds_load_u16_d16 v58, v83 offset:256
	ds_load_u16_d16_hi v58, v83 offset:384
	ds_load_u16_d16 v59, v83 offset:512
	ds_load_u16_d16_hi v59, v83 offset:640
	ds_load_u16_d16 v60, v83 offset:768
	ds_load_u16_d16_hi v60, v83 offset:896
	ds_load_u16_d16 v61, v83 offset:1024
	ds_load_u16_d16_hi v61, v83 offset:1152
	ds_load_u16_d16 v62, v83 offset:1280
	ds_load_u16_d16_hi v62, v83 offset:1408
	ds_load_u16_d16 v63, v83 offset:1536
	ds_load_u16_d16_hi v63, v83 offset:1664
	ds_load_u16_d16 v64, v83 offset:1792
	ds_load_u16_d16_hi v64, v83 offset:1920
	ds_load_u16_d16 v49, v83 offset:64
	ds_load_u16_d16_hi v49, v83 offset:192
	ds_load_u16_d16 v50, v83 offset:320
	ds_load_u16_d16_hi v50, v83 offset:448
	ds_load_u16_d16 v51, v83 offset:576
	ds_load_u16_d16_hi v51, v83 offset:704
	ds_load_u16_d16 v52, v83 offset:832
	ds_load_u16_d16_hi v52, v83 offset:960
	ds_load_u16_d16 v53, v83 offset:1088
	ds_load_u16_d16_hi v53, v83 offset:1216
	ds_load_u16_d16 v54, v83 offset:1344
	ds_load_u16_d16_hi v54, v83 offset:1472
	ds_load_u16_d16 v55, v83 offset:1600
	ds_load_u16_d16_hi v55, v83 offset:1728
	ds_load_u16_d16 v56, v83 offset:1856
	ds_load_u16_d16_hi v56, v83 offset:1984
	ds_load_u16_d16 v86, v83 offset:2048
	ds_load_u16_d16_hi v86, v83 offset:2176
	ds_load_u16_d16 v87, v83 offset:2304
	ds_load_u16_d16_hi v87, v83 offset:2432
	ds_load_u16_d16 v88, v83 offset:2560
	ds_load_u16_d16_hi v95, v83 offset:2496
	ds_load_u16_d16 v95, v83 offset:2368
	ds_load_u16_d16_hi v94, v83 offset:2240
	ds_load_u16_d16 v94, v83 offset:2112
	ds_load_u16_d16_hi v88, v83 offset:2688
	ds_load_u16_d16 v89, v83 offset:2816
	ds_load_u16_d16_hi v89, v83 offset:2944
	ds_load_u16_d16 v90, v83 offset:3072
	ds_load_u16_d16_hi v97, v83 offset:3008
	ds_load_u16_d16 v97, v83 offset:2880
	ds_load_u16_d16_hi v96, v83 offset:2752
	ds_load_u16_d16 v96, v83 offset:2624
	ds_load_u16_d16_hi v90, v83 offset:3200
	ds_load_u16_d16 v91, v83 offset:3328
	ds_load_u16_d16_hi v91, v83 offset:3456
	ds_load_u16_d16 v92, v83 offset:3584
	ds_load_u16_d16_hi v99, v83 offset:3520
	ds_load_u16_d16 v99, v83 offset:3392
	ds_load_u16_d16_hi v98, v83 offset:3264
	ds_load_u16_d16 v98, v83 offset:3136
	ds_load_u16_d16_hi v92, v83 offset:3712
	ds_load_u16_d16 v93, v83 offset:3840
	ds_load_u16_d16_hi v93, v83 offset:3968
	ds_load_u16_d16_hi v101, v83 offset:4032
	ds_load_u16_d16 v101, v83 offset:3904
	ds_load_u16_d16_hi v100, v83 offset:3776
	ds_load_u16_d16 v100, v83 offset:3648
	v_add_nc_u32_e32 v78, 0x3b0000, v73
	s_waitcnt lgkmcnt(48)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[33:40], v[57:64], v[9:16]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[33:40], v[49:56], v[1:8]
	v_add_nc_u32_e32 v79, 0x4000, v78
	v_add_nc_u32_e32 v80, 0x8000, v78
	v_add_nc_u32_e32 v106, 0xc000, v78
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[41:48], v[86:93], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[41:48], v[94:101], v[1:8]
	v_add_nc_u32_e32 v41, 0x3c0000, v73
	s_delay_alu instid0(VALU_DEP_1)
	v_add_nc_u32_e32 v42, 0x4000, v41
	v_add_nc_u32_e32 v43, 0x8000, v41
	v_add_nc_u32_e32 v44, 0xc000, v41
	s_barrier
	s_waitcnt vmcnt(7)
	ds_store_b128 v84, v[65:68]
	s_waitcnt vmcnt(6)
	ds_store_b128 v84, v[69:72] offset:1024
	s_waitcnt vmcnt(5)
	ds_store_b128 v84, v[74:77] offset:2048
	s_waitcnt vmcnt(4)
	ds_store_b128 v84, v[102:105] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x3
	buffer_load_b128 v[74:77], v78, s[8:11], 0 offen slc
	buffer_load_b128 v[110:113], v79, s[8:11], 0 offen slc
	buffer_load_b128 v[114:117], v80, s[8:11], 0 offen slc
	buffer_load_b128 v[118:121], v106, s[8:11], 0 offen slc
	s_clause 0x3
	buffer_load_b128 v[57:60], v85, s[4:7], 0 offen offset:3776
	buffer_load_b128 v[61:64], v85, s[4:7], 0 offen offset:3792
	buffer_load_b128 v[65:68], v85, s[4:7], 0 offen offset:3808
	buffer_load_b128 v[69:72], v85, s[4:7], 0 offen offset:3824
	ds_load_u16_d16 v33, v83
	ds_load_u16_d16_hi v33, v83 offset:128
	ds_load_u16_d16 v34, v83 offset:256
	ds_load_u16_d16_hi v34, v83 offset:384
	ds_load_u16_d16_hi v87, v83 offset:448
	ds_load_u16_d16 v87, v83 offset:320
	ds_load_u16_d16_hi v86, v83 offset:192
	ds_load_u16_d16 v86, v83 offset:64
	ds_load_u16_d16 v35, v83 offset:512
	ds_load_u16_d16_hi v35, v83 offset:640
	ds_load_u16_d16 v36, v83 offset:768
	ds_load_u16_d16_hi v36, v83 offset:896
	ds_load_u16_d16_hi v89, v83 offset:960
	ds_load_u16_d16 v89, v83 offset:832
	ds_load_u16_d16_hi v88, v83 offset:704
	ds_load_u16_d16 v88, v83 offset:576
	ds_load_u16_d16 v37, v83 offset:1024
	ds_load_u16_d16_hi v37, v83 offset:1152
	ds_load_u16_d16 v38, v83 offset:1280
	ds_load_u16_d16_hi v38, v83 offset:1408
	ds_load_u16_d16_hi v91, v83 offset:1472
	ds_load_u16_d16 v91, v83 offset:1344
	ds_load_u16_d16_hi v90, v83 offset:1216
	ds_load_u16_d16 v90, v83 offset:1088
	ds_load_u16_d16 v39, v83 offset:1536
	ds_load_u16_d16_hi v39, v83 offset:1664
	ds_load_u16_d16 v40, v83 offset:1792
	ds_load_u16_d16_hi v40, v83 offset:1920
	ds_load_u16_d16_hi v93, v83 offset:1984
	ds_load_u16_d16 v93, v83 offset:1856
	ds_load_u16_d16_hi v92, v83 offset:1728
	ds_load_u16_d16 v92, v83 offset:1600
	ds_load_u16_d16 v94, v83 offset:2048
	ds_load_u16_d16_hi v94, v83 offset:2176
	ds_load_u16_d16 v95, v83 offset:2304
	ds_load_u16_d16_hi v95, v83 offset:2432
	ds_load_u16_d16_hi v103, v83 offset:2496
	ds_load_u16_d16 v103, v83 offset:2368
	ds_load_u16_d16_hi v102, v83 offset:2240
	ds_load_u16_d16 v102, v83 offset:2112
	ds_load_u16_d16 v96, v83 offset:2560
	ds_load_u16_d16_hi v96, v83 offset:2688
	ds_load_u16_d16 v97, v83 offset:2816
	ds_load_u16_d16_hi v97, v83 offset:2944
	ds_load_u16_d16_hi v105, v83 offset:3008
	ds_load_u16_d16 v105, v83 offset:2880
	ds_load_u16_d16_hi v104, v83 offset:2752
	ds_load_u16_d16 v104, v83 offset:2624
	ds_load_u16_d16 v98, v83 offset:3072
	ds_load_u16_d16_hi v98, v83 offset:3200
	ds_load_u16_d16 v99, v83 offset:3328
	ds_load_u16_d16_hi v99, v83 offset:3456
	ds_load_u16_d16_hi v107, v83 offset:3520
	ds_load_u16_d16 v107, v83 offset:3392
	ds_load_u16_d16_hi v106, v83 offset:3264
	ds_load_u16_d16 v106, v83 offset:3136
	ds_load_u16_d16 v100, v83 offset:3584
	ds_load_u16_d16_hi v100, v83 offset:3712
	ds_load_u16_d16 v101, v83 offset:3840
	ds_load_u16_d16_hi v101, v83 offset:3968
	ds_load_u16_d16_hi v109, v83 offset:4032
	ds_load_u16_d16 v109, v83 offset:3904
	ds_load_u16_d16_hi v108, v83 offset:3776
	ds_load_u16_d16 v108, v83 offset:3648
	s_waitcnt vmcnt(10) lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[25:32], v[33:40], v[9:16]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[25:32], v[86:93], v[1:8]
	v_add_nc_u32_e32 v78, 0x3d0000, v73
	s_delay_alu instid0(VALU_DEP_1)
	v_add_nc_u32_e32 v79, 0x4000, v78
	v_add_nc_u32_e32 v80, 0x8000, v78
	s_waitcnt vmcnt(8) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[17:24], v[94:101], v[9:16]
	v_add_nc_u32_e32 v94, 0xc000, v78
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[17:24], v[102:109], v[1:8]
	s_barrier
	s_waitcnt vmcnt(7)
	ds_store_b128 v84, v[74:77]
	s_waitcnt vmcnt(6)
	ds_store_b128 v84, v[110:113] offset:1024
	s_waitcnt vmcnt(5)
	ds_store_b128 v84, v[114:117] offset:2048
	s_waitcnt vmcnt(4)
	ds_store_b128 v84, v[118:121] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x3
	buffer_load_b128 v[74:77], v41, s[8:11], 0 offen slc
	buffer_load_b128 v[110:113], v42, s[8:11], 0 offen slc
	buffer_load_b128 v[114:117], v43, s[8:11], 0 offen slc
	buffer_load_b128 v[118:121], v44, s[8:11], 0 offen slc
	s_clause 0x3
	buffer_load_b128 v[41:44], v85, s[4:7], 0 offen offset:3840
	buffer_load_b128 v[45:48], v85, s[4:7], 0 offen offset:3856
	buffer_load_b128 v[49:52], v85, s[4:7], 0 offen offset:3872
	buffer_load_b128 v[53:56], v85, s[4:7], 0 offen offset:3888
	ds_load_u16_d16 v17, v83
	ds_load_u16_d16_hi v17, v83 offset:128
	ds_load_u16_d16 v18, v83 offset:256
	ds_load_u16_d16_hi v18, v83 offset:384
	ds_load_u16_d16_hi v26, v83 offset:448
	ds_load_u16_d16 v26, v83 offset:320
	ds_load_u16_d16_hi v25, v83 offset:192
	ds_load_u16_d16 v25, v83 offset:64
	ds_load_u16_d16 v19, v83 offset:512
	ds_load_u16_d16_hi v19, v83 offset:640
	ds_load_u16_d16 v20, v83 offset:768
	ds_load_u16_d16_hi v20, v83 offset:896
	ds_load_u16_d16_hi v28, v83 offset:960
	ds_load_u16_d16 v28, v83 offset:832
	ds_load_u16_d16_hi v27, v83 offset:704
	ds_load_u16_d16 v27, v83 offset:576
	ds_load_u16_d16 v21, v83 offset:1024
	ds_load_u16_d16_hi v21, v83 offset:1152
	ds_load_u16_d16 v22, v83 offset:1280
	ds_load_u16_d16_hi v22, v83 offset:1408
	ds_load_u16_d16_hi v30, v83 offset:1472
	ds_load_u16_d16 v30, v83 offset:1344
	ds_load_u16_d16_hi v29, v83 offset:1216
	ds_load_u16_d16 v29, v83 offset:1088
	ds_load_u16_d16 v23, v83 offset:1536
	ds_load_u16_d16_hi v23, v83 offset:1664
	ds_load_u16_d16 v24, v83 offset:1792
	ds_load_u16_d16_hi v24, v83 offset:1920
	ds_load_u16_d16_hi v32, v83 offset:1984
	ds_load_u16_d16 v32, v83 offset:1856
	ds_load_u16_d16_hi v31, v83 offset:1728
	ds_load_u16_d16 v31, v83 offset:1600
	ds_load_u16_d16 v33, v83 offset:2048
	ds_load_u16_d16_hi v33, v83 offset:2176
	ds_load_u16_d16 v34, v83 offset:2304
	ds_load_u16_d16_hi v34, v83 offset:2432
	ds_load_u16_d16_hi v87, v83 offset:2496
	ds_load_u16_d16 v87, v83 offset:2368
	ds_load_u16_d16_hi v86, v83 offset:2240
	ds_load_u16_d16 v86, v83 offset:2112
	ds_load_u16_d16 v35, v83 offset:2560
	ds_load_u16_d16_hi v35, v83 offset:2688
	ds_load_u16_d16 v36, v83 offset:2816
	ds_load_u16_d16_hi v36, v83 offset:2944
	ds_load_u16_d16_hi v89, v83 offset:3008
	ds_load_u16_d16 v89, v83 offset:2880
	ds_load_u16_d16_hi v88, v83 offset:2752
	ds_load_u16_d16 v88, v83 offset:2624
	ds_load_u16_d16 v37, v83 offset:3072
	ds_load_u16_d16_hi v37, v83 offset:3200
	ds_load_u16_d16 v38, v83 offset:3328
	ds_load_u16_d16_hi v38, v83 offset:3456
	ds_load_u16_d16_hi v91, v83 offset:3520
	ds_load_u16_d16 v91, v83 offset:3392
	ds_load_u16_d16_hi v90, v83 offset:3264
	ds_load_u16_d16 v90, v83 offset:3136
	ds_load_u16_d16 v39, v83 offset:3584
	ds_load_u16_d16_hi v39, v83 offset:3712
	ds_load_u16_d16 v40, v83 offset:3840
	ds_load_u16_d16_hi v40, v83 offset:3968
	ds_load_u16_d16_hi v93, v83 offset:4032
	ds_load_u16_d16 v93, v83 offset:3904
	ds_load_u16_d16_hi v92, v83 offset:3776
	ds_load_u16_d16 v92, v83 offset:3648
	s_waitcnt vmcnt(10) lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[57:64], v[17:24], v[9:16]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[57:64], v[25:32], v[1:8]
	s_waitcnt vmcnt(8) lgkmcnt(4)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_2)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[65:72], v[33:40], v[9:16]
	v_add_nc_u32_e32 v33, 0x3e0000, v73
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[65:72], v[86:93], v[1:8]
	v_add_nc_u32_e32 v34, 0x4000, v33
	v_add_nc_u32_e32 v35, 0x8000, v33
	v_add_nc_u32_e32 v36, 0xc000, v33
	s_barrier
	s_waitcnt vmcnt(7)
	ds_store_b128 v84, v[74:77]
	s_waitcnt vmcnt(6)
	ds_store_b128 v84, v[110:113] offset:1024
	s_waitcnt vmcnt(5)
	ds_store_b128 v84, v[114:117] offset:2048
	s_waitcnt vmcnt(4)
	ds_store_b128 v84, v[118:121] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x3
	buffer_load_b128 v[74:77], v78, s[8:11], 0 offen slc
	buffer_load_b128 v[102:105], v79, s[8:11], 0 offen slc
	buffer_load_b128 v[106:109], v80, s[8:11], 0 offen slc
	buffer_load_b128 v[110:113], v94, s[8:11], 0 offen slc
	s_clause 0x3
	buffer_load_b128 v[94:97], v85, s[4:7], 0 offen offset:3904
	buffer_load_b128 v[98:101], v85, s[4:7], 0 offen offset:3920
	buffer_load_b128 v[17:20], v85, s[4:7], 0 offen offset:3936
	buffer_load_b128 v[21:24], v85, s[4:7], 0 offen offset:3952
	ds_load_u16_d16 v25, v83
	ds_load_u16_d16_hi v25, v83 offset:128
	ds_load_u16_d16 v26, v83 offset:256
	ds_load_u16_d16_hi v26, v83 offset:384
	ds_load_u16_d16_hi v58, v83 offset:448
	ds_load_u16_d16 v58, v83 offset:320
	ds_load_u16_d16_hi v57, v83 offset:192
	ds_load_u16_d16 v57, v83 offset:64
	ds_load_u16_d16 v27, v83 offset:512
	ds_load_u16_d16_hi v27, v83 offset:640
	ds_load_u16_d16 v28, v83 offset:768
	ds_load_u16_d16_hi v28, v83 offset:896
	ds_load_u16_d16_hi v60, v83 offset:960
	ds_load_u16_d16 v60, v83 offset:832
	ds_load_u16_d16_hi v59, v83 offset:704
	ds_load_u16_d16 v59, v83 offset:576
	ds_load_u16_d16 v29, v83 offset:1024
	ds_load_u16_d16_hi v29, v83 offset:1152
	ds_load_u16_d16 v30, v83 offset:1280
	ds_load_u16_d16_hi v30, v83 offset:1408
	ds_load_u16_d16_hi v62, v83 offset:1472
	ds_load_u16_d16 v62, v83 offset:1344
	ds_load_u16_d16_hi v61, v83 offset:1216
	ds_load_u16_d16 v61, v83 offset:1088
	ds_load_u16_d16 v31, v83 offset:1536
	ds_load_u16_d16_hi v31, v83 offset:1664
	ds_load_u16_d16 v32, v83 offset:1792
	ds_load_u16_d16_hi v32, v83 offset:1920
	ds_load_u16_d16_hi v64, v83 offset:1984
	ds_load_u16_d16 v64, v83 offset:1856
	ds_load_u16_d16_hi v63, v83 offset:1728
	ds_load_u16_d16 v63, v83 offset:1600
	ds_load_u16_d16 v65, v83 offset:2048
	ds_load_u16_d16_hi v65, v83 offset:2176
	ds_load_u16_d16 v66, v83 offset:2304
	ds_load_u16_d16_hi v66, v83 offset:2432
	ds_load_u16_d16_hi v87, v83 offset:2496
	ds_load_u16_d16 v87, v83 offset:2368
	ds_load_u16_d16_hi v86, v83 offset:2240
	ds_load_u16_d16 v86, v83 offset:2112
	ds_load_u16_d16 v67, v83 offset:2560
	ds_load_u16_d16_hi v67, v83 offset:2688
	ds_load_u16_d16 v68, v83 offset:2816
	ds_load_u16_d16_hi v68, v83 offset:2944
	ds_load_u16_d16_hi v89, v83 offset:3008
	ds_load_u16_d16 v89, v83 offset:2880
	ds_load_u16_d16_hi v88, v83 offset:2752
	ds_load_u16_d16 v88, v83 offset:2624
	ds_load_u16_d16 v69, v83 offset:3072
	ds_load_u16_d16_hi v69, v83 offset:3200
	ds_load_u16_d16 v70, v83 offset:3328
	ds_load_u16_d16_hi v70, v83 offset:3456
	ds_load_u16_d16_hi v91, v83 offset:3520
	ds_load_u16_d16 v91, v83 offset:3392
	ds_load_u16_d16_hi v90, v83 offset:3264
	ds_load_u16_d16 v90, v83 offset:3136
	ds_load_u16_d16 v71, v83 offset:3584
	ds_load_u16_d16_hi v71, v83 offset:3712
	ds_load_u16_d16 v72, v83 offset:3840
	ds_load_u16_d16_hi v72, v83 offset:3968
	ds_load_u16_d16_hi v93, v83 offset:4032
	ds_load_u16_d16 v93, v83 offset:3904
	ds_load_u16_d16_hi v92, v83 offset:3776
	ds_load_u16_d16 v92, v83 offset:3648
	s_waitcnt vmcnt(10) lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[41:48], v[25:32], v[9:16]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[41:48], v[57:64], v[1:8]
	v_add_nc_u32_e32 v41, 0x3f0000, v73
	s_delay_alu instid0(VALU_DEP_1)
	v_add_nc_u32_e32 v42, 0x4000, v41
	v_add_nc_u32_e32 v43, 0x8000, v41
	v_add_nc_u32_e32 v44, 0xc000, v41
	s_waitcnt vmcnt(8) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[49:56], v[65:72], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[49:56], v[86:93], v[1:8]
	s_barrier
	s_waitcnt vmcnt(7)
	ds_store_b128 v84, v[74:77]
	s_waitcnt vmcnt(6)
	ds_store_b128 v84, v[102:105] offset:1024
	s_waitcnt vmcnt(5)
	ds_store_b128 v84, v[106:109] offset:2048
	s_waitcnt vmcnt(4)
	ds_store_b128 v84, v[110:113] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x3
	buffer_load_b128 v[74:77], v33, s[8:11], 0 offen slc
	buffer_load_b128 v[118:121], v34, s[8:11], 0 offen slc
	buffer_load_b128 v[122:125], v35, s[8:11], 0 offen slc
	buffer_load_b128 v[126:129], v36, s[8:11], 0 offen slc
	s_clause 0x3
	buffer_load_b128 v[25:28], v85, s[4:7], 0 offen offset:3968
	buffer_load_b128 v[29:32], v85, s[4:7], 0 offen offset:3984
	buffer_load_b128 v[33:36], v85, s[4:7], 0 offen offset:4000
	buffer_load_b128 v[37:40], v85, s[4:7], 0 offen offset:4016
	ds_load_u16_d16 v86, v83
	ds_load_u16_d16_hi v86, v83 offset:128
	ds_load_u16_d16 v87, v83 offset:256
	ds_load_u16_d16_hi v87, v83 offset:384
	ds_load_u16_d16_hi v103, v83 offset:448
	ds_load_u16_d16 v103, v83 offset:320
	ds_load_u16_d16_hi v102, v83 offset:192
	ds_load_u16_d16 v102, v83 offset:64
	ds_load_u16_d16 v88, v83 offset:512
	ds_load_u16_d16_hi v88, v83 offset:640
	ds_load_u16_d16 v89, v83 offset:768
	ds_load_u16_d16_hi v89, v83 offset:896
	ds_load_u16_d16_hi v105, v83 offset:960
	ds_load_u16_d16 v105, v83 offset:832
	ds_load_u16_d16_hi v104, v83 offset:704
	ds_load_u16_d16 v104, v83 offset:576
	ds_load_u16_d16 v90, v83 offset:1024
	ds_load_u16_d16_hi v90, v83 offset:1152
	ds_load_u16_d16 v91, v83 offset:1280
	ds_load_u16_d16_hi v91, v83 offset:1408
	ds_load_u16_d16_hi v107, v83 offset:1472
	ds_load_u16_d16 v107, v83 offset:1344
	ds_load_u16_d16_hi v106, v83 offset:1216
	ds_load_u16_d16 v106, v83 offset:1088
	ds_load_u16_d16 v92, v83 offset:1536
	ds_load_u16_d16_hi v92, v83 offset:1664
	ds_load_u16_d16 v93, v83 offset:1792
	ds_load_u16_d16_hi v93, v83 offset:1920
	ds_load_u16_d16_hi v109, v83 offset:1984
	ds_load_u16_d16 v109, v83 offset:1856
	ds_load_u16_d16_hi v108, v83 offset:1728
	ds_load_u16_d16 v108, v83 offset:1600
	ds_load_u16_d16 v110, v83 offset:2048
	ds_load_u16_d16_hi v110, v83 offset:2176
	ds_load_u16_d16 v111, v83 offset:2304
	ds_load_u16_d16_hi v111, v83 offset:2432
	ds_load_u16_d16_hi v58, v83 offset:2496
	ds_load_u16_d16 v58, v83 offset:2368
	ds_load_u16_d16_hi v57, v83 offset:2240
	ds_load_u16_d16 v57, v83 offset:2112
	ds_load_u16_d16 v112, v83 offset:2560
	ds_load_u16_d16_hi v112, v83 offset:2688
	ds_load_u16_d16 v113, v83 offset:2816
	ds_load_u16_d16_hi v113, v83 offset:2944
	ds_load_u16_d16_hi v60, v83 offset:3008
	ds_load_u16_d16 v60, v83 offset:2880
	ds_load_u16_d16_hi v59, v83 offset:2752
	ds_load_u16_d16 v59, v83 offset:2624
	ds_load_u16_d16 v114, v83 offset:3072
	ds_load_u16_d16_hi v114, v83 offset:3200
	ds_load_u16_d16 v115, v83 offset:3328
	ds_load_u16_d16_hi v115, v83 offset:3456
	ds_load_u16_d16_hi v62, v83 offset:3520
	ds_load_u16_d16 v62, v83 offset:3392
	ds_load_u16_d16_hi v61, v83 offset:3264
	ds_load_u16_d16 v61, v83 offset:3136
	ds_load_u16_d16 v116, v83 offset:3584
	ds_load_u16_d16_hi v116, v83 offset:3712
	ds_load_u16_d16 v117, v83 offset:3840
	ds_load_u16_d16_hi v117, v83 offset:3968
	ds_load_u16_d16_hi v64, v83 offset:4032
	ds_load_u16_d16 v64, v83 offset:3904
	ds_load_u16_d16_hi v63, v83 offset:3776
	ds_load_u16_d16 v63, v83 offset:3648
	s_waitcnt vmcnt(10) lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[94:101], v[86:93], v[9:16]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[94:101], v[102:109], v[1:8]
	s_waitcnt vmcnt(8) lgkmcnt(4)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[17:24], v[110:117], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[17:24], v[57:64], v[1:8]
	v_lshlrev_b32_e32 v19, 4, v0
	v_or_b32_e32 v17, s3, v0
	v_mov_b32_e32 v22, 1
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v18, 31, v17
	v_lshlrev_b64 v[17:18], 2, v[17:18]
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v17, vcc_lo, s14, v17
	v_add_co_ci_u32_e64 v18, null, s15, v18, vcc_lo
	s_barrier
	s_waitcnt vmcnt(7)
	ds_store_b128 v84, v[74:77]
	s_waitcnt vmcnt(6)
	ds_store_b128 v84, v[118:121] offset:1024
	s_waitcnt vmcnt(5)
	ds_store_b128 v84, v[122:125] offset:2048
	s_waitcnt vmcnt(4)
	ds_store_b128 v84, v[126:129] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x3
	buffer_load_b128 v[65:68], v41, s[8:11], 0 offen slc
	buffer_load_b128 v[69:72], v42, s[8:11], 0 offen slc
	buffer_load_b128 v[73:76], v43, s[8:11], 0 offen slc
	buffer_load_b128 v[77:80], v44, s[8:11], 0 offen slc
	s_clause 0x3
	buffer_load_b128 v[49:52], v85, s[4:7], 0 offen offset:4032
	buffer_load_b128 v[53:56], v85, s[4:7], 0 offen offset:4048
	buffer_load_b128 v[41:44], v85, s[4:7], 0 offen offset:4064
	buffer_load_b128 v[45:48], v85, s[4:7], 0 offen offset:4080
	ds_load_u16_d16 v85, v83
	ds_load_u16_d16_hi v85, v83 offset:128
	ds_load_u16_d16 v86, v83 offset:256
	ds_load_u16_d16_hi v86, v83 offset:384
	ds_load_u16_d16_hi v94, v83 offset:448
	ds_load_u16_d16 v94, v83 offset:320
	ds_load_u16_d16_hi v93, v83 offset:192
	ds_load_u16_d16 v93, v83 offset:64
	ds_load_u16_d16 v87, v83 offset:512
	ds_load_u16_d16_hi v87, v83 offset:640
	ds_load_u16_d16 v88, v83 offset:768
	ds_load_u16_d16_hi v88, v83 offset:896
	ds_load_u16_d16_hi v96, v83 offset:960
	ds_load_u16_d16 v96, v83 offset:832
	ds_load_u16_d16_hi v95, v83 offset:704
	ds_load_u16_d16 v95, v83 offset:576
	ds_load_u16_d16 v89, v83 offset:1024
	ds_load_u16_d16_hi v89, v83 offset:1152
	ds_load_u16_d16 v90, v83 offset:1280
	ds_load_u16_d16_hi v90, v83 offset:1408
	ds_load_u16_d16_hi v98, v83 offset:1472
	ds_load_u16_d16 v98, v83 offset:1344
	ds_load_u16_d16_hi v97, v83 offset:1216
	ds_load_u16_d16 v97, v83 offset:1088
	ds_load_u16_d16 v91, v83 offset:1536
	ds_load_u16_d16_hi v91, v83 offset:1664
	ds_load_u16_d16 v92, v83 offset:1792
	ds_load_u16_d16_hi v92, v83 offset:1920
	ds_load_u16_d16_hi v100, v83 offset:1984
	ds_load_u16_d16 v100, v83 offset:1856
	ds_load_u16_d16_hi v99, v83 offset:1728
	ds_load_u16_d16 v99, v83 offset:1600
	ds_load_u16_d16 v101, v83 offset:2048
	ds_load_u16_d16_hi v101, v83 offset:2176
	ds_load_u16_d16 v102, v83 offset:2304
	ds_load_u16_d16_hi v102, v83 offset:2432
	ds_load_u16_d16_hi v110, v83 offset:2496
	ds_load_u16_d16 v110, v83 offset:2368
	ds_load_u16_d16_hi v109, v83 offset:2240
	ds_load_u16_d16 v109, v83 offset:2112
	ds_load_u16_d16 v103, v83 offset:2560
	ds_load_u16_d16_hi v103, v83 offset:2688
	ds_load_u16_d16 v104, v83 offset:2816
	ds_load_u16_d16_hi v104, v83 offset:2944
	ds_load_u16_d16_hi v112, v83 offset:3008
	ds_load_u16_d16 v112, v83 offset:2880
	ds_load_u16_d16_hi v111, v83 offset:2752
	ds_load_u16_d16 v111, v83 offset:2624
	ds_load_u16_d16 v105, v83 offset:3072
	ds_load_u16_d16_hi v105, v83 offset:3200
	ds_load_u16_d16 v106, v83 offset:3328
	ds_load_u16_d16_hi v106, v83 offset:3456
	ds_load_u16_d16_hi v114, v83 offset:3520
	ds_load_u16_d16 v114, v83 offset:3392
	ds_load_u16_d16_hi v113, v83 offset:3264
	ds_load_u16_d16 v113, v83 offset:3136
	ds_load_u16_d16 v107, v83 offset:3584
	ds_load_u16_d16_hi v107, v83 offset:3712
	ds_load_u16_d16 v108, v83 offset:3840
	ds_load_u16_d16_hi v108, v83 offset:3968
	ds_load_u16_d16_hi v116, v83 offset:4032
	ds_load_u16_d16 v116, v83 offset:3904
	ds_load_u16_d16_hi v115, v83 offset:3776
	ds_load_u16_d16 v115, v83 offset:3648
	s_waitcnt vmcnt(10) lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[25:32], v[85:92], v[9:16]
	s_lshr_b32 s4, s17, 26
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[25:32], v[93:100], v[1:8]
	s_add_i32 s4, s2, s4
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s4, s4, 0x3fffc0
	s_sub_i32 s2, s2, s4
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_lshl_or_b32 v20, s2, 10, v19
	s_mov_b32 s2, exec_lo
	v_ashrrev_i32_e32 v21, 31, v20
	s_waitcnt vmcnt(8) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[33:40], v[101:108], v[9:16]
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	v_lshlrev_b64 v[20:21], 2, v[20:21]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[33:40], v[109:116], v[1:8]
	v_add_co_u32 v20, vcc_lo, s12, v20
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v21, null, s13, v21, vcc_lo
	s_barrier
	s_waitcnt vmcnt(7)
	ds_store_b128 v84, v[65:68]
	s_waitcnt vmcnt(6)
	ds_store_b128 v84, v[69:72] offset:1024
	s_waitcnt vmcnt(5)
	ds_store_b128 v84, v[73:76] offset:2048
	s_waitcnt vmcnt(4)
	ds_store_b128 v84, v[77:80] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	ds_load_u16_d16 v57, v83
	ds_load_u16_d16_hi v57, v83 offset:128
	ds_load_u16_d16 v58, v83 offset:256
	ds_load_u16_d16_hi v58, v83 offset:384
	ds_load_u16_d16_hi v66, v83 offset:448
	ds_load_u16_d16 v66, v83 offset:320
	ds_load_u16_d16_hi v65, v83 offset:192
	ds_load_u16_d16 v65, v83 offset:64
	ds_load_u16_d16 v59, v83 offset:512
	ds_load_u16_d16_hi v59, v83 offset:640
	ds_load_u16_d16 v60, v83 offset:768
	ds_load_u16_d16_hi v60, v83 offset:896
	ds_load_u16_d16_hi v68, v83 offset:960
	ds_load_u16_d16 v68, v83 offset:832
	ds_load_u16_d16_hi v67, v83 offset:704
	ds_load_u16_d16 v67, v83 offset:576
	ds_load_u16_d16 v61, v83 offset:1024
	ds_load_u16_d16_hi v61, v83 offset:1152
	ds_load_u16_d16 v62, v83 offset:1280
	ds_load_u16_d16_hi v62, v83 offset:1408
	ds_load_u16_d16_hi v70, v83 offset:1472
	ds_load_u16_d16 v70, v83 offset:1344
	ds_load_u16_d16_hi v69, v83 offset:1216
	ds_load_u16_d16 v69, v83 offset:1088
	ds_load_u16_d16 v63, v83 offset:1536
	ds_load_u16_d16_hi v63, v83 offset:1664
	ds_load_u16_d16 v64, v83 offset:1792
	ds_load_u16_d16_hi v64, v83 offset:1920
	ds_load_u16_d16_hi v72, v83 offset:1984
	ds_load_u16_d16 v72, v83 offset:1856
	ds_load_u16_d16_hi v71, v83 offset:1728
	ds_load_u16_d16 v71, v83 offset:1600
	ds_load_u16_d16 v73, v83 offset:2048
	ds_load_u16_d16_hi v73, v83 offset:2176
	ds_load_u16_d16 v74, v83 offset:2304
	ds_load_u16_d16_hi v74, v83 offset:2432
	ds_load_u16_d16_hi v85, v83 offset:2496
	ds_load_u16_d16 v85, v83 offset:2368
	ds_load_u16_d16_hi v84, v83 offset:2240
	ds_load_u16_d16 v84, v83 offset:2112
	ds_load_u16_d16 v75, v83 offset:2560
	ds_load_u16_d16_hi v75, v83 offset:2688
	ds_load_u16_d16 v76, v83 offset:2816
	ds_load_u16_d16_hi v76, v83 offset:2944
	ds_load_u16_d16_hi v87, v83 offset:3008
	ds_load_u16_d16 v87, v83 offset:2880
	ds_load_u16_d16_hi v86, v83 offset:2752
	ds_load_u16_d16 v86, v83 offset:2624
	ds_load_u16_d16 v77, v83 offset:3072
	ds_load_u16_d16_hi v77, v83 offset:3200
	ds_load_u16_d16 v78, v83 offset:3328
	ds_load_u16_d16_hi v78, v83 offset:3456
	ds_load_u16_d16_hi v89, v83 offset:3520
	ds_load_u16_d16 v89, v83 offset:3392
	ds_load_u16_d16_hi v88, v83 offset:3264
	ds_load_u16_d16 v88, v83 offset:3136
	ds_load_u16_d16 v79, v83 offset:3584
	ds_load_u16_d16_hi v79, v83 offset:3712
	ds_load_u16_d16 v80, v83 offset:3840
	ds_load_u16_d16_hi v80, v83 offset:3968
	ds_load_u16_d16_hi v91, v83 offset:4032
	ds_load_u16_d16 v91, v83 offset:3904
	ds_load_u16_d16_hi v90, v83 offset:3776
	ds_load_u16_d16 v90, v83 offset:3648
	s_waitcnt vmcnt(2) lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[49:56], v[57:64], v[9:16]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[49:56], v[65:72], v[1:8]
	s_waitcnt vmcnt(0) lgkmcnt(4)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[41:48], v[73:80], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[41:48], v[84:91], v[1:8]
	s_barrier
	s_clause 0x3
	global_store_b128 v[20:21], v[13:16], off offset:16
	global_store_b128 v[20:21], v[9:12], off
	global_store_b128 v[20:21], v[5:8], off offset:48
	global_store_b128 v[20:21], v[1:4], off offset:32
	s_waitcnt_vscnt null, 0x0
	global_atomic_add_u32 v1, v[17:18], v22, off glc
	s_waitcnt vmcnt(0)
	buffer_gl1_inv
	buffer_gl0_inv
	v_cmpx_eq_u32_e32 3, v1
	s_cbranch_execz .LBB0_4
	v_lshl_or_b32 v1, s16, 12, v19
	v_lshlrev_b32_e32 v0, 6, v0
	v_or_b32_e32 v67, s3, v82
	s_load_b64 s[0:1], s[0:1], 0x30
	s_mov_b32 s3, 0x21027000
	v_ashrrev_i32_e32 v2, 31, v1
	v_and_or_b32 v0, 0x400, v0, v81
	s_mov_b32 s2, -1
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_lshlrev_b64 v[1:2], 2, v[1:2]
	v_add_lshl_u32 v0, v67, v0, 1
	v_mov_b32_e32 v67, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v47, vcc_lo, s12, v1
	v_add_co_ci_u32_e64 v48, null, s13, v2, vcc_lo
	s_clause 0x3
	global_load_b128 v[1:4], v[47:48], off
	global_load_b128 v[5:8], v[47:48], off offset:16
	global_load_b128 v[9:12], v[47:48], off offset:48
	global_load_b128 v[13:16], v[47:48], off offset:32
	v_add_co_u32 v35, vcc_lo, v47, 0x2000
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v36, null, 0, v48, vcc_lo
	v_add_co_u32 v31, vcc_lo, 0x1000, v47
	v_add_co_ci_u32_e64 v32, null, 0, v48, vcc_lo
	v_add_co_u32 v49, vcc_lo, 0x2000, v47
	s_clause 0x3
	global_load_b128 v[19:22], v[35:36], off offset:-4096
	global_load_b128 v[23:26], v[31:32], off offset:16
	global_load_b128 v[27:30], v[31:32], off offset:32
	global_load_b128 v[31:34], v[31:32], off offset:48
	v_add_co_ci_u32_e64 v50, null, 0, v48, vcc_lo
	s_clause 0x2
	global_load_b128 v[35:38], v[35:36], off
	global_load_b128 v[39:42], v[49:50], off offset:16
	global_load_b128 v[43:46], v[49:50], off offset:32
	v_add_co_u32 v63, vcc_lo, 0x3000, v47
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v64, null, 0, v48, vcc_lo
	s_clause 0x4
	global_load_b128 v[47:50], v[49:50], off offset:48
	global_load_b128 v[51:54], v[63:64], off
	global_load_b128 v[55:58], v[63:64], off offset:16
	global_load_b128 v[59:62], v[63:64], off offset:32
	global_load_b128 v[63:66], v[63:64], off offset:48
	v_add_nc_u32_e32 v68, 0x1000, v0
	v_add_nc_u32_e32 v69, 0x2000, v0
	v_add_nc_u32_e32 v70, 0x3000, v0
	v_add_nc_u32_e32 v72, 0x5000, v0
	v_add_nc_u32_e32 v71, 0x4000, v0
	v_add_nc_u32_e32 v74, 0x7000, v0
	v_add_nc_u32_e32 v73, 0x6000, v0
	s_waitcnt lgkmcnt(0)
	s_and_b32 s1, s1, 0xffff
	s_waitcnt vmcnt(15)
	v_dual_add_f32 v1, 0, v1 :: v_dual_add_f32 v2, 0, v2
	s_waitcnt vmcnt(13)
	v_dual_add_f32 v12, 0, v12 :: v_dual_add_f32 v3, 0, v3
	s_waitcnt vmcnt(12)
	v_dual_add_f32 v4, 0, v4 :: v_dual_add_f32 v13, 0, v13
	v_dual_add_f32 v5, 0, v5 :: v_dual_add_f32 v6, 0, v6
	v_dual_add_f32 v7, 0, v7 :: v_dual_add_f32 v8, 0, v8
	v_add_f32_e32 v15, 0, v15
	s_waitcnt vmcnt(11)
	v_dual_add_f32 v1, v1, v19 :: v_dual_add_f32 v2, v2, v20
	s_waitcnt vmcnt(8)
	v_dual_add_f32 v3, v3, v21 :: v_dual_add_f32 v12, v12, v34
	v_dual_add_f32 v4, v4, v22 :: v_dual_add_f32 v5, v5, v23
	s_waitcnt vmcnt(7)
	v_dual_add_f32 v1, v1, v35 :: v_dual_add_f32 v2, v2, v36
	s_delay_alu instid0(VALU_DEP_2)
	v_dual_add_f32 v3, v3, v37 :: v_dual_add_f32 v4, v4, v38
	s_waitcnt vmcnt(4)
	v_dual_add_f32 v5, v5, v39 :: v_dual_add_f32 v12, v12, v50
	s_waitcnt vmcnt(3)
	v_dual_add_f32 v1, v1, v51 :: v_dual_add_f32 v2, v2, v52
	v_dual_add_f32 v3, v3, v53 :: v_dual_add_f32 v6, v6, v24
	v_add_f32_e32 v7, v7, v25
	s_delay_alu instid0(VALU_DEP_3)
	v_bfe_u32 v19, v1, 16, 1
	v_or_b32_e32 v20, 0x400000, v1
	v_bfe_u32 v21, v2, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	s_waitcnt vmcnt(2)
	v_dual_add_f32 v4, v4, v54 :: v_dual_add_f32 v5, v5, v55
	v_add3_u32 v19, v19, v1, 0x7fff
	s_waitcnt vmcnt(0)
	v_add_f32_e32 v12, v12, v66
	v_or_b32_e32 v22, 0x400000, v2
	v_bfe_u32 v23, v3, 16, 1
	v_add3_u32 v21, v21, v2, 0x7fff
	v_cndmask_b32_e32 v1, v19, v20, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_dual_add_f32 v6, v6, v40 :: v_dual_add_f32 v7, v7, v41
	v_or_b32_e32 v24, 0x400000, v3
	v_bfe_u32 v25, v4, 16, 1
	v_add3_u32 v23, v23, v3, 0x7fff
	v_cndmask_b32_e32 v2, v21, v22, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_add_f32_e32 v14, 0, v14
	v_dual_add_f32 v8, v8, v26 :: v_dual_add_f32 v13, v13, v27
	v_dual_add_f32 v6, v6, v56 :: v_dual_add_f32 v7, v7, v57
	v_or_b32_e32 v26, 0x400000, v4
	v_bfe_u32 v27, v5, 16, 1
	v_add3_u32 v25, v25, v4, 0x7fff
	v_cndmask_b32_e32 v3, v23, v24, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_dual_add_f32 v16, 0, v16 :: v_dual_add_f32 v9, 0, v9
	v_dual_add_f32 v14, v14, v28 :: v_dual_add_f32 v15, v15, v29
	v_dual_add_f32 v8, v8, v42 :: v_dual_add_f32 v13, v13, v43
	v_or_b32_e32 v28, 0x400000, v5
	v_bfe_u32 v29, v6, 16, 1
	v_add3_u32 v27, v27, v5, 0x7fff
	v_cndmask_b32_e32 v4, v25, v26, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_dual_add_f32 v10, 0, v10 :: v_dual_add_f32 v11, 0, v11
	v_dual_add_f32 v16, v16, v30 :: v_dual_add_f32 v9, v9, v31
	v_dual_add_f32 v8, v8, v58 :: v_dual_add_f32 v13, v13, v59
	v_or_b32_e32 v30, 0x400000, v6
	v_bfe_u32 v31, v7, 16, 1
	v_add3_u32 v29, v29, v6, 0x7fff
	v_cndmask_b32_e32 v5, v27, v28, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_dual_add_f32 v10, v10, v32 :: v_dual_add_f32 v11, v11, v33
	v_dual_add_f32 v14, v14, v44 :: v_dual_add_f32 v15, v15, v45
	v_or_b32_e32 v32, 0x400000, v7
	v_bfe_u32 v33, v8, 16, 1
	v_add3_u32 v31, v31, v7, 0x7fff
	v_cndmask_b32_e32 v6, v29, v30, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_dual_add_f32 v14, v14, v60 :: v_dual_add_f32 v15, v15, v61
	v_or_b32_e32 v34, 0x400000, v8
	v_bfe_u32 v35, v13, 16, 1
	v_add3_u32 v33, v33, v8, 0x7fff
	v_cndmask_b32_e32 v7, v31, v32, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_dual_add_f32 v16, v16, v46 :: v_dual_add_f32 v9, v9, v47
	v_or_b32_e32 v36, 0x400000, v13
	v_bfe_u32 v37, v14, 16, 1
	v_add3_u32 v35, v35, v13, 0x7fff
	v_cndmask_b32_e32 v8, v33, v34, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_dual_add_f32 v16, v16, v62 :: v_dual_add_f32 v9, v9, v63
	v_or_b32_e32 v38, 0x400000, v14
	v_bfe_u32 v39, v15, 16, 1
	v_add3_u32 v37, v37, v14, 0x7fff
	v_cndmask_b32_e32 v13, v35, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_dual_add_f32 v10, v10, v48 :: v_dual_add_f32 v11, v11, v49
	v_or_b32_e32 v40, 0x400000, v15
	v_bfe_u32 v41, v16, 16, 1
	v_add3_u32 v39, v39, v15, 0x7fff
	v_cndmask_b32_e32 v14, v37, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_dual_add_f32 v10, v10, v64 :: v_dual_add_f32 v11, v11, v65
	v_or_b32_e32 v42, 0x400000, v16
	v_bfe_u32 v43, v9, 16, 1
	v_add3_u32 v41, v41, v16, 0x7fff
	v_cndmask_b32_e32 v15, v39, v40, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	v_or_b32_e32 v44, 0x400000, v9
	v_bfe_u32 v45, v10, 16, 1
	v_add3_u32 v43, v43, v9, 0x7fff
	v_or_b32_e32 v46, 0x400000, v10
	v_cndmask_b32_e32 v16, v41, v42, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_bfe_u32 v47, v11, 16, 1
	v_add3_u32 v45, v45, v10, 0x7fff
	v_or_b32_e32 v48, 0x400000, v11
	v_bfe_u32 v49, v12, 16, 1
	v_cndmask_b32_e32 v9, v43, v44, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_add3_u32 v47, v47, v11, 0x7fff
	v_or_b32_e32 v50, 0x400000, v12
	v_add3_u32 v49, v49, v12, 0x7fff
	v_lshrrev_b32_e32 v1, 16, v1
	v_cndmask_b32_e32 v10, v45, v46, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_lshrrev_b32_e32 v2, 16, v2
	v_lshrrev_b32_e32 v3, 16, v3
	v_lshrrev_b32_e32 v4, 16, v4
	v_lshrrev_b32_e32 v5, 16, v5
	v_cndmask_b32_e32 v11, v47, v48, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_lshrrev_b32_e32 v6, 16, v6
	v_lshrrev_b32_e32 v7, 16, v7
	v_lshrrev_b32_e32 v8, 16, v8
	v_lshrrev_b32_e32 v13, 16, v13
	v_cndmask_b32_e32 v12, v49, v50, vcc_lo
	v_lshrrev_b32_e32 v14, 16, v14
	v_lshrrev_b32_e32 v15, 16, v15
	v_lshrrev_b32_e32 v16, 16, v16
	v_lshrrev_b32_e32 v9, 16, v9
	v_lshrrev_b32_e32 v10, 16, v10
	v_lshrrev_b32_e32 v11, 16, v11
	v_lshrrev_b32_e32 v12, 16, v12
	s_clause 0xf
	buffer_store_b16 v1, v0, s[0:3], 0 offen
	buffer_store_b16 v2, v68, s[0:3], 0 offen
	buffer_store_b16 v3, v69, s[0:3], 0 offen
	buffer_store_b16 v4, v70, s[0:3], 0 offen
	buffer_store_b16 v5, v71, s[0:3], 0 offen
	buffer_store_b16 v6, v72, s[0:3], 0 offen
	buffer_store_b16 v7, v73, s[0:3], 0 offen
	buffer_store_b16 v8, v74, s[0:3], 0 offen
	buffer_store_b16 v13, v0, s[0:3], 0 offen offset:64
	buffer_store_b16 v14, v68, s[0:3], 0 offen offset:64
	buffer_store_b16 v15, v69, s[0:3], 0 offen offset:64
	buffer_store_b16 v16, v70, s[0:3], 0 offen offset:64
	buffer_store_b16 v9, v71, s[0:3], 0 offen offset:64
	buffer_store_b16 v10, v72, s[0:3], 0 offen offset:64
	buffer_store_b16 v11, v73, s[0:3], 0 offen offset:64
	buffer_store_b16 v12, v74, s[0:3], 0 offen offset:64
	s_waitcnt_vscnt null, 0x0
	global_store_b32 v[17:18], v67, off
.LBB0_4:
	s_nop 0
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
	s_endpgm
.Lfunc_end0:
	.size	exercise_kernel_0, .Lfunc_end0-exercise_kernel_0
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel exercise_kernel_0
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
		.amdhsa_next_free_vgpr 130
		.amdhsa_next_free_sgpr 19
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

	.set .Lexercise_kernel_0.num_vgpr, 130
	.set .Lexercise_kernel_0.num_agpr, 0
	.set .Lexercise_kernel_0.numbered_sgpr, 19
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
    .group_segment_fixed_size: 4096
    .kernarg_segment_align: 8
    .kernarg_segment_size: 100
    .max_flat_workgroup_size: 64
    .name:           exercise_kernel_0
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 64
      - 1
      - 1
    .sgpr_count:     21
    .sgpr_spill_count: 0
    .symbol:         exercise_kernel_0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     130
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
