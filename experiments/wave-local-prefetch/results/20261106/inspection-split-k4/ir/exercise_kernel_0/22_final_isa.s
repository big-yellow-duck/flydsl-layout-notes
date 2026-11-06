	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	exercise_kernel_0
	.p2align	8
	.type	exercise_kernel_0,@function
exercise_kernel_0:
	v_lshrrev_b32_e32 v54, 5, v0
	s_lshl_b32 s3, s2, 1
	s_bfe_i32 s2, s2, 0x1001e
	v_lshlrev_b32_e32 v4, 3, v0
	s_lshr_b32 s2, s2, 30
	v_or_b32_e32 v56, s3, v54
	s_clause 0x1
	s_load_b64 s[8:9], s[0:1], 0x0
	s_load_b64 s[4:5], s[0:1], 0x18
	v_bfe_u32 v57, v0, 1, 4
	v_bfe_u32 v55, v0, 3, 2
	v_and_b32_e32 v58, 56, v4
	v_add_nc_u32_e32 v1, s2, v56
	s_mov_b32 s11, 0x21027000
	v_lshlrev_b32_e32 v61, 14, v57
	s_mov_b32 s10, -1
	v_lshl_or_b32 v53, v55, 12, v58
	v_ashrrev_i32_e32 v2, 31, v1
	v_ashrrev_i32_e32 v3, 2, v1
	v_and_b32_e32 v1, -4, v1
	s_mov_b32 s6, s10
	s_mov_b32 s7, s11
	v_lshrrev_b32_e32 v2, 26, v2
	v_mul_u32_u24_e32 v64, 0x300, v54
	v_sub_nc_u32_e32 v59, v56, v1
	v_readfirstlane_b32 s14, v56
	v_mul_u32_u24_e32 v65, 48, v57
	v_add_nc_u32_e32 v2, v3, v2
	s_waitcnt lgkmcnt(0)
	s_and_b32 s9, s9, 0xffff
	v_lshlrev_b32_e32 v62, 12, v59
	s_and_b32 s5, s5, 0xffff
	v_or_b32_e32 v64, 0x1000, v64
	v_and_b32_e32 v2, 0xffffffc0, v2
	v_readfirstlane_b32 s3, v59
	s_mov_b32 s2, 0
	v_lshlrev_b32_e32 v68, 13, v55
	v_lshlrev_b32_e32 v66, 11, v54
	v_sub_nc_u32_e32 v103, v3, v2
	v_lshlrev_b32_e32 v2, 4, v0
	v_lshlrev_b32_e32 v54, 7, v55
	v_lshl_or_b32 v56, v59, 24, v68
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_lshlrev_b32_e32 v101, 6, v103
	v_and_b32_e32 v60, 16, v2
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_lshl_add_u32 v1, v59, 23, v101
	v_or_b32_e32 v107, v61, v60
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_add_lshl_u32 v1, v1, v53, 1
	v_add_nc_u32_e32 v2, v62, v107
	s_delay_alu instid0(VALU_DEP_2)
	v_add_nc_u32_e32 v3, 0x8000, v1
	v_add_nc_u32_e32 v4, 0x10000, v1
	v_add_nc_u32_e32 v5, 0x18000, v1
	buffer_load_b128 v[33:36], v2, s[8:11], 0 offen
	s_clause 0x3
	buffer_load_b128 v[37:40], v1, s[4:7], 0 offen slc
	buffer_load_b128 v[41:44], v3, s[4:7], 0 offen slc
	buffer_load_b128 v[45:48], v4, s[4:7], 0 offen slc
	buffer_load_b128 v[49:52], v5, s[4:7], 0 offen slc
	v_dual_mov_b32 v1, 0 :: v_dual_and_b32 v102, 15, v0
	v_and_b32_e32 v63, 7, v0
	s_delay_alu instid0(VALU_DEP_2)
	v_dual_mov_b32 v19, v1 :: v_dual_and_b32 v108, 31, v0
	v_mov_b32_e32 v27, v1
	v_mov_b32_e32 v23, v1
	v_mov_b32_e32 v4, v1
	v_mov_b32_e32 v9, v1
	v_mov_b32_e32 v11, v1
	v_mov_b32_e32 v13, v1
	v_mov_b32_e32 v21, v1
	v_mov_b32_e32 v25, v1
	v_mul_u32_u24_e32 v67, 48, v102
	v_lshl_or_b32 v55, v58, 1, v66
	v_or_b32_e32 v58, v64, v60
	v_add_nc_u32_e32 v61, v61, v62
	v_lshl_add_u32 v62, v103, 7, v56
	v_mov_b32_e32 v2, v1
	v_mov_b32_e32 v3, v1
	v_mov_b32_e32 v5, v1
	v_mov_b32_e32 v6, v1
	v_mov_b32_e32 v7, v1
	v_mov_b32_e32 v8, v1
	v_mov_b32_e32 v10, v1
	v_dual_mov_b32 v12, v1 :: v_dual_add_nc_u32 v105, v64, v67
	v_mov_b32_e32 v14, v1
	v_mov_b32_e32 v15, v1
	v_mov_b32_e32 v16, v1
	v_mov_b32_e32 v17, v1
	v_mov_b32_e32 v18, v1
	v_mov_b32_e32 v20, v1
	v_mov_b32_e32 v22, v1
	v_mov_b32_e32 v24, v1
	v_mov_b32_e32 v26, v1
	v_mov_b32_e32 v28, v1
	v_dual_mov_b32 v29, v1 :: v_dual_add_nc_u32 v106, v58, v65
	v_mov_b32_e32 v30, v1
	v_mov_b32_e32 v31, v1
	v_mov_b32_e32 v32, v1
	v_lshl_or_b32 v104, v102, 1, v66
	v_mad_u32_u24 v64, v57, 48, v58
	v_or3_b32 v56, v61, v60, 0x80
	v_lshl_or_b32 v57, v63, 4, v62
	v_or_b32_e32 v66, v55, v54
	s_waitcnt vmcnt(4)
	ds_store_b128 v64, v[33:36]
	s_waitcnt vmcnt(3)
	ds_store_b128 v66, v[37:40]
	s_waitcnt vmcnt(2)
	ds_store_b128 v66, v[41:44] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v66, v[45:48] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v66, v[49:52] offset:1536
.LBB0_1:
	v_add_nc_u32_e32 v58, s2, v57
	v_add_nc_u32_e32 v33, 0xffffffa0, v56
	v_subrev_nc_u32_e32 v99, 64, v56
	v_add_nc_u32_e32 v109, v55, v54
	ds_load_b128 v[59:62], v105
	ds_load_b128 v[63:66], v105 offset:16
	ds_load_u16_d16_hi v67, v104 offset:128
	ds_load_u16_d16 v67, v104
	ds_load_u16_d16 v75, v104 offset:32
	ds_load_u16_d16_hi v75, v104 offset:160
	ds_load_u16_d16 v83, v104 offset:64
	ds_load_u16_d16_hi v83, v104 offset:192
	ds_load_u16_d16_hi v91, v104 offset:224
	ds_load_u16_d16 v91, v104 offset:96
	ds_load_u16_d16 v68, v104 offset:256
	ds_load_u16_d16_hi v68, v104 offset:384
	ds_load_u16_d16 v76, v104 offset:288
	ds_load_u16_d16_hi v76, v104 offset:416
	ds_load_u16_d16 v84, v104 offset:320
	ds_load_u16_d16_hi v84, v104 offset:448
	ds_load_u16_d16_hi v92, v104 offset:480
	ds_load_u16_d16 v92, v104 offset:352
	ds_load_u16_d16 v69, v104 offset:512
	ds_load_u16_d16_hi v69, v104 offset:640
	ds_load_u16_d16 v77, v104 offset:544
	ds_load_u16_d16_hi v77, v104 offset:672
	ds_load_u16_d16 v85, v104 offset:576
	ds_load_u16_d16_hi v85, v104 offset:704
	ds_load_u16_d16_hi v93, v104 offset:736
	ds_load_u16_d16 v93, v104 offset:608
	ds_load_u16_d16 v70, v104 offset:768
	ds_load_u16_d16_hi v70, v104 offset:896
	ds_load_u16_d16 v78, v104 offset:800
	ds_load_u16_d16_hi v78, v104 offset:928
	ds_load_u16_d16 v86, v104 offset:832
	ds_load_u16_d16_hi v86, v104 offset:960
	ds_load_u16_d16_hi v94, v104 offset:992
	ds_load_u16_d16 v94, v104 offset:864
	ds_load_u16_d16 v71, v104 offset:1024
	ds_load_u16_d16_hi v71, v104 offset:1152
	ds_load_u16_d16 v79, v104 offset:1056
	ds_load_u16_d16_hi v79, v104 offset:1184
	ds_load_u16_d16 v87, v104 offset:1088
	ds_load_u16_d16_hi v87, v104 offset:1216
	ds_load_u16_d16_hi v95, v104 offset:1248
	ds_load_u16_d16 v95, v104 offset:1120
	ds_load_u16_d16 v72, v104 offset:1280
	ds_load_u16_d16_hi v72, v104 offset:1408
	ds_load_u16_d16 v80, v104 offset:1312
	ds_load_u16_d16_hi v80, v104 offset:1440
	ds_load_u16_d16 v88, v104 offset:1344
	ds_load_u16_d16_hi v88, v104 offset:1472
	ds_load_u16_d16_hi v96, v104 offset:1504
	ds_load_u16_d16 v96, v104 offset:1376
	ds_load_u16_d16 v73, v104 offset:1536
	ds_load_u16_d16_hi v73, v104 offset:1664
	ds_load_u16_d16 v81, v104 offset:1568
	ds_load_u16_d16_hi v81, v104 offset:1696
	ds_load_u16_d16 v89, v104 offset:1600
	ds_load_u16_d16_hi v89, v104 offset:1728
	ds_load_u16_d16_hi v97, v104 offset:1760
	ds_load_u16_d16 v97, v104 offset:1632
	ds_load_u16_d16 v74, v104 offset:1792
	ds_load_u16_d16_hi v74, v104 offset:1920
	ds_load_u16_d16 v82, v104 offset:1824
	ds_load_u16_d16_hi v82, v104 offset:1952
	ds_load_u16_d16 v90, v104 offset:1856
	ds_load_u16_d16_hi v90, v104 offset:1984
	ds_load_u16_d16_hi v98, v104 offset:2016
	ds_load_u16_d16 v98, v104 offset:1888
	v_add_nc_u32_e32 v37, 0x20000, v58
	v_add_nc_u32_e32 v41, 0x28000, v58
	v_add_nc_u32_e32 v45, 0x30000, v58
	v_add_nc_u32_e32 v49, 0x38000, v58
	buffer_load_b128 v[33:36], v33, s[8:11], 0 offen
	s_clause 0x3
	buffer_load_b128 v[37:40], v37, s[4:7], 0 offen slc
	buffer_load_b128 v[41:44], v41, s[4:7], 0 offen slc
	buffer_load_b128 v[45:48], v45, s[4:7], 0 offen slc
	buffer_load_b128 v[49:52], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v100, 0x40000, v58
	v_add_nc_u32_e32 v110, 0x48000, v58
	v_add_nc_u32_e32 v111, 0x50000, v58
	v_add_nc_u32_e32 v112, 0x58000, v58
	v_add_nc_u32_e32 v118, 0x70000, v58
	v_add_nc_u32_e32 v122, 0x78000, v58
	v_add_nc_u32_e32 v114, 0x68000, v58
	s_waitcnt lgkmcnt(6)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[59:66], v[67:74], v[1:8]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[59:66], v[75:82], v[9:16]
	v_add_nc_u32_e32 v126, 0x90000, v58
	s_waitcnt lgkmcnt(2)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[59:66], v[83:90], v[17:24]
	s_add_i32 s2, s2, 0x80000
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[59:66], v[91:98], v[25:32]
	s_cmp_lg_u32 s2, 0xf80000
	s_waitcnt vmcnt(4)
	ds_store_b128 v106, v[33:36]
	s_waitcnt vmcnt(3)
	ds_store_b128 v109, v[37:40]
	s_waitcnt vmcnt(2)
	ds_store_b128 v109, v[41:44] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v109, v[45:48] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v109, v[49:52] offset:1536
	buffer_load_b128 v[33:36], v99, s[8:11], 0 offen
	s_clause 0x3
	buffer_load_b128 v[37:40], v100, s[4:7], 0 offen slc
	buffer_load_b128 v[41:44], v110, s[4:7], 0 offen slc
	buffer_load_b128 v[45:48], v111, s[4:7], 0 offen slc
	buffer_load_b128 v[49:52], v112, s[4:7], 0 offen slc
	v_subrev_nc_u32_e32 v99, 32, v56
	v_add_nc_u32_e32 v100, 0x60000, v58
	ds_load_b128 v[59:62], v105
	ds_load_b128 v[63:66], v105 offset:16
	ds_load_u16_d16 v68, v104 offset:256
	ds_load_u16_d16_hi v68, v104 offset:384
	ds_load_u16_d16 v76, v104 offset:288
	ds_load_u16_d16_hi v76, v104 offset:416
	ds_load_u16_d16 v84, v104 offset:320
	ds_load_u16_d16_hi v84, v104 offset:448
	ds_load_u16_d16 v69, v104 offset:512
	ds_load_u16_d16_hi v69, v104 offset:640
	ds_load_u16_d16 v77, v104 offset:544
	ds_load_u16_d16_hi v77, v104 offset:672
	ds_load_u16_d16 v85, v104 offset:576
	ds_load_u16_d16_hi v85, v104 offset:704
	ds_load_u16_d16 v70, v104 offset:768
	ds_load_u16_d16_hi v70, v104 offset:896
	ds_load_u16_d16 v78, v104 offset:800
	ds_load_u16_d16_hi v78, v104 offset:928
	ds_load_u16_d16 v86, v104 offset:832
	ds_load_u16_d16_hi v86, v104 offset:960
	ds_load_u16_d16 v71, v104 offset:1024
	ds_load_u16_d16_hi v71, v104 offset:1152
	ds_load_u16_d16 v79, v104 offset:1056
	ds_load_u16_d16_hi v79, v104 offset:1184
	ds_load_u16_d16 v87, v104 offset:1088
	ds_load_u16_d16_hi v87, v104 offset:1216
	ds_load_u16_d16 v72, v104 offset:1280
	ds_load_u16_d16_hi v72, v104 offset:1408
	ds_load_u16_d16 v80, v104 offset:1312
	ds_load_u16_d16_hi v80, v104 offset:1440
	ds_load_u16_d16 v88, v104 offset:1344
	ds_load_u16_d16_hi v88, v104 offset:1472
	ds_load_u16_d16 v73, v104 offset:1536
	ds_load_u16_d16_hi v73, v104 offset:1664
	ds_load_u16_d16 v81, v104 offset:1568
	ds_load_u16_d16_hi v81, v104 offset:1696
	ds_load_u16_d16 v89, v104 offset:1600
	ds_load_u16_d16_hi v89, v104 offset:1728
	ds_load_u16_d16 v74, v104 offset:1792
	ds_load_u16_d16_hi v74, v104 offset:1920
	ds_load_u16_d16 v82, v104 offset:1824
	ds_load_u16_d16_hi v82, v104 offset:1952
	ds_load_u16_d16 v90, v104 offset:1856
	ds_load_u16_d16_hi v90, v104 offset:1984
	ds_load_u16_d16_hi v67, v104 offset:128
	ds_load_u16_d16 v67, v104
	ds_load_u16_d16 v75, v104 offset:32
	ds_load_u16_d16_hi v75, v104 offset:160
	ds_load_u16_d16 v83, v104 offset:64
	ds_load_u16_d16_hi v83, v104 offset:192
	ds_load_u16_d16_hi v91, v104 offset:224
	ds_load_u16_d16 v91, v104 offset:96
	ds_load_u16_d16_hi v92, v104 offset:480
	ds_load_u16_d16 v92, v104 offset:352
	ds_load_u16_d16_hi v93, v104 offset:736
	ds_load_u16_d16 v93, v104 offset:608
	ds_load_u16_d16_hi v94, v104 offset:992
	ds_load_u16_d16 v94, v104 offset:864
	ds_load_u16_d16_hi v95, v104 offset:1248
	ds_load_u16_d16 v95, v104 offset:1120
	ds_load_u16_d16_hi v96, v104 offset:1504
	ds_load_u16_d16 v96, v104 offset:1376
	ds_load_u16_d16_hi v97, v104 offset:1760
	ds_load_u16_d16 v97, v104 offset:1632
	ds_load_u16_d16_hi v98, v104 offset:2016
	ds_load_u16_d16 v98, v104 offset:1888
	s_waitcnt lgkmcnt(20)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[59:66], v[67:74], v[1:8]
	s_waitcnt lgkmcnt(18)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[59:66], v[75:82], v[9:16]
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[59:66], v[83:90], v[17:24]
	s_waitcnt vmcnt(4)
	ds_store_b128 v106, v[33:36]
	s_waitcnt vmcnt(3)
	ds_store_b128 v109, v[37:40]
	s_waitcnt vmcnt(2)
	ds_store_b128 v109, v[41:44] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v109, v[45:48] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v109, v[49:52] offset:1536
	buffer_load_b128 v[49:52], v99, s[8:11], 0 offen
	s_clause 0x3
	buffer_load_b128 v[110:113], v100, s[4:7], 0 offen slc
	buffer_load_b128 v[114:117], v114, s[4:7], 0 offen slc
	buffer_load_b128 v[118:121], v118, s[4:7], 0 offen slc
	buffer_load_b128 v[122:125], v122, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v99, 0x80000, v58
	v_add_nc_u32_e32 v100, 0x88000, v58
	v_add_nc_u32_e32 v58, 0x98000, v58
	ds_load_b128 v[33:36], v105
	ds_load_b128 v[37:40], v105 offset:16
	ds_load_u16_d16_hi v41, v104 offset:128
	ds_load_u16_d16 v41, v104
	ds_load_u16_d16 v67, v104 offset:32
	ds_load_u16_d16_hi v67, v104 offset:160
	ds_load_u16_d16 v75, v104 offset:64
	ds_load_u16_d16_hi v75, v104 offset:192
	ds_load_u16_d16_hi v83, v104 offset:224
	ds_load_u16_d16 v83, v104 offset:96
	ds_load_u16_d16 v42, v104 offset:256
	ds_load_u16_d16_hi v42, v104 offset:384
	ds_load_u16_d16 v68, v104 offset:288
	ds_load_u16_d16_hi v68, v104 offset:416
	ds_load_u16_d16 v76, v104 offset:320
	ds_load_u16_d16_hi v76, v104 offset:448
	ds_load_u16_d16_hi v84, v104 offset:480
	ds_load_u16_d16 v84, v104 offset:352
	ds_load_u16_d16 v43, v104 offset:512
	ds_load_u16_d16_hi v43, v104 offset:640
	ds_load_u16_d16 v69, v104 offset:544
	ds_load_u16_d16_hi v69, v104 offset:672
	ds_load_u16_d16 v77, v104 offset:576
	ds_load_u16_d16_hi v77, v104 offset:704
	ds_load_u16_d16_hi v85, v104 offset:736
	ds_load_u16_d16 v85, v104 offset:608
	ds_load_u16_d16 v44, v104 offset:768
	ds_load_u16_d16_hi v44, v104 offset:896
	ds_load_u16_d16 v70, v104 offset:800
	ds_load_u16_d16_hi v70, v104 offset:928
	ds_load_u16_d16 v78, v104 offset:832
	ds_load_u16_d16_hi v78, v104 offset:960
	ds_load_u16_d16_hi v86, v104 offset:992
	ds_load_u16_d16 v86, v104 offset:864
	ds_load_u16_d16 v45, v104 offset:1024
	ds_load_u16_d16_hi v45, v104 offset:1152
	ds_load_u16_d16 v71, v104 offset:1056
	ds_load_u16_d16_hi v71, v104 offset:1184
	ds_load_u16_d16 v79, v104 offset:1088
	ds_load_u16_d16_hi v79, v104 offset:1216
	ds_load_u16_d16_hi v87, v104 offset:1248
	ds_load_u16_d16 v87, v104 offset:1120
	ds_load_u16_d16 v46, v104 offset:1280
	ds_load_u16_d16_hi v46, v104 offset:1408
	ds_load_u16_d16 v72, v104 offset:1312
	ds_load_u16_d16_hi v72, v104 offset:1440
	ds_load_u16_d16 v80, v104 offset:1344
	ds_load_u16_d16_hi v80, v104 offset:1472
	ds_load_u16_d16_hi v88, v104 offset:1504
	ds_load_u16_d16 v88, v104 offset:1376
	ds_load_u16_d16 v47, v104 offset:1536
	ds_load_u16_d16_hi v47, v104 offset:1664
	ds_load_u16_d16 v73, v104 offset:1568
	ds_load_u16_d16_hi v73, v104 offset:1696
	ds_load_u16_d16 v81, v104 offset:1600
	ds_load_u16_d16_hi v81, v104 offset:1728
	ds_load_u16_d16_hi v89, v104 offset:1760
	ds_load_u16_d16 v89, v104 offset:1632
	ds_load_u16_d16 v48, v104 offset:1792
	ds_load_u16_d16_hi v48, v104 offset:1920
	ds_load_u16_d16 v74, v104 offset:1824
	ds_load_u16_d16_hi v74, v104 offset:1952
	ds_load_u16_d16 v82, v104 offset:1856
	ds_load_u16_d16_hi v82, v104 offset:1984
	ds_load_u16_d16_hi v90, v104 offset:2016
	ds_load_u16_d16 v90, v104 offset:1888
	s_waitcnt lgkmcnt(62)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[59:66], v[91:98], v[25:32]
	s_waitcnt vmcnt(3)
	ds_store_b128 v109, v[110:113]
	s_waitcnt vmcnt(2)
	ds_store_b128 v109, v[114:117] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v109, v[118:121] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v109, v[122:125] offset:1536
	ds_store_b128 v106, v[49:52]
	buffer_load_b128 v[49:52], v56, s[8:11], 0 offen
	s_clause 0x3
	buffer_load_b128 v[110:113], v99, s[4:7], 0 offen slc
	buffer_load_b128 v[114:117], v100, s[4:7], 0 offen slc
	buffer_load_b128 v[118:121], v126, s[4:7], 0 offen slc
	buffer_load_b128 v[122:125], v58, s[4:7], 0 offen slc
	s_waitcnt lgkmcnt(11)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[33:40], v[41:48], v[1:8]
	s_waitcnt lgkmcnt(9)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[33:40], v[67:74], v[9:16]
	s_waitcnt lgkmcnt(7)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[33:40], v[75:82], v[17:24]
	ds_load_b128 v[41:44], v105
	ds_load_b128 v[45:48], v105 offset:16
	ds_load_u16_d16_hi v58, v104 offset:128
	ds_load_u16_d16 v58, v104
	ds_load_u16_d16 v66, v104 offset:32
	ds_load_u16_d16_hi v66, v104 offset:160
	ds_load_u16_d16 v74, v104 offset:64
	ds_load_u16_d16_hi v74, v104 offset:192
	ds_load_u16_d16_hi v91, v104 offset:224
	ds_load_u16_d16 v91, v104 offset:96
	ds_load_u16_d16 v59, v104 offset:256
	ds_load_u16_d16_hi v59, v104 offset:384
	ds_load_u16_d16 v67, v104 offset:288
	ds_load_u16_d16_hi v67, v104 offset:416
	ds_load_u16_d16 v75, v104 offset:320
	ds_load_u16_d16_hi v75, v104 offset:448
	ds_load_u16_d16_hi v92, v104 offset:480
	ds_load_u16_d16 v92, v104 offset:352
	ds_load_u16_d16 v60, v104 offset:512
	ds_load_u16_d16_hi v60, v104 offset:640
	ds_load_u16_d16 v68, v104 offset:544
	ds_load_u16_d16_hi v68, v104 offset:672
	ds_load_u16_d16 v76, v104 offset:576
	ds_load_u16_d16_hi v76, v104 offset:704
	ds_load_u16_d16_hi v93, v104 offset:736
	ds_load_u16_d16 v93, v104 offset:608
	ds_load_u16_d16 v61, v104 offset:768
	ds_load_u16_d16_hi v61, v104 offset:896
	ds_load_u16_d16 v69, v104 offset:800
	ds_load_u16_d16_hi v69, v104 offset:928
	ds_load_u16_d16 v77, v104 offset:832
	ds_load_u16_d16_hi v77, v104 offset:960
	ds_load_u16_d16_hi v94, v104 offset:992
	ds_load_u16_d16 v94, v104 offset:864
	ds_load_u16_d16 v62, v104 offset:1024
	ds_load_u16_d16_hi v62, v104 offset:1152
	ds_load_u16_d16 v70, v104 offset:1056
	ds_load_u16_d16_hi v70, v104 offset:1184
	ds_load_u16_d16 v78, v104 offset:1088
	ds_load_u16_d16_hi v78, v104 offset:1216
	ds_load_u16_d16_hi v95, v104 offset:1248
	ds_load_u16_d16 v95, v104 offset:1120
	ds_load_u16_d16 v63, v104 offset:1280
	ds_load_u16_d16_hi v63, v104 offset:1408
	ds_load_u16_d16 v71, v104 offset:1312
	ds_load_u16_d16_hi v71, v104 offset:1440
	ds_load_u16_d16 v79, v104 offset:1344
	ds_load_u16_d16_hi v79, v104 offset:1472
	ds_load_u16_d16_hi v96, v104 offset:1504
	ds_load_u16_d16 v96, v104 offset:1376
	ds_load_u16_d16 v64, v104 offset:1536
	ds_load_u16_d16_hi v64, v104 offset:1664
	ds_load_u16_d16 v72, v104 offset:1568
	ds_load_u16_d16_hi v72, v104 offset:1696
	ds_load_u16_d16 v80, v104 offset:1600
	ds_load_u16_d16_hi v80, v104 offset:1728
	ds_load_u16_d16_hi v97, v104 offset:1760
	ds_load_u16_d16 v97, v104 offset:1632
	ds_load_u16_d16 v65, v104 offset:1792
	ds_load_u16_d16_hi v65, v104 offset:1920
	ds_load_u16_d16 v73, v104 offset:1824
	ds_load_u16_d16_hi v73, v104 offset:1952
	ds_load_u16_d16 v81, v104 offset:1856
	ds_load_u16_d16_hi v81, v104 offset:1984
	ds_load_u16_d16_hi v98, v104 offset:2016
	ds_load_u16_d16 v98, v104 offset:1888
	s_waitcnt lgkmcnt(62)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[33:40], v[83:90], v[25:32]
	v_add_nc_u32_e32 v56, 0x80, v56
	s_waitcnt vmcnt(4)
	ds_store_b128 v106, v[49:52]
	s_waitcnt vmcnt(3)
	ds_store_b128 v109, v[110:113]
	s_waitcnt vmcnt(2)
	ds_store_b128 v109, v[114:117] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v109, v[118:121] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v109, v[122:125] offset:1536
	s_waitcnt lgkmcnt(11)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[41:48], v[58:65], v[1:8]
	s_waitcnt lgkmcnt(9)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[41:48], v[66:73], v[9:16]
	s_waitcnt lgkmcnt(7)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[41:48], v[74:81], v[17:24]
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[41:48], v[91:98], v[25:32]
	s_cbranch_scc1 .LBB0_1
	s_lshl_b32 s15, s3, 7
	s_mov_b32 s6, s10
	s_or_b32 s2, s15, 0x7d
	s_mov_b32 s7, s11
	s_lshl_b32 s3, s2, 16
	v_lshl_add_u32 v34, s2, 5, v107
	v_add_nc_u32_e32 v33, s3, v101
	v_add_lshl_u32 v110, v53, v101, 1
	s_or_b32 s16, s15, 0x7e
	s_clause 0x1
	s_load_b64 s[2:3], s[0:1], 0x48
	s_load_b64 s[12:13], s[0:1], 0x58
	v_lshl_add_u32 v94, s16, 5, v107
	v_add_lshl_u32 v33, v33, v53, 1
	v_lshl_add_u32 v93, s16, 17, v110
	ds_load_u16_d16 v71, v104 offset:1536
	ds_load_u16_d16_hi v71, v104 offset:1664
	ds_load_u16_d16 v47, v104 offset:1568
	ds_load_u16_d16_hi v47, v104 offset:1696
	ds_load_u16_d16 v55, v104 offset:1600
	ds_load_u16_d16_hi v55, v104 offset:1728
	ds_load_u16_d16_hi v63, v104 offset:1760
	ds_load_u16_d16 v63, v104 offset:1632
	ds_load_u16_d16 v72, v104 offset:1792
	ds_load_u16_d16_hi v72, v104 offset:1920
	ds_load_u16_d16 v48, v104 offset:1824
	ds_load_u16_d16_hi v48, v104 offset:1952
	ds_load_u16_d16 v56, v104 offset:1856
	ds_load_u16_d16_hi v56, v104 offset:1984
	ds_load_u16_d16_hi v64, v104 offset:2016
	ds_load_u16_d16 v64, v104 offset:1888
	s_addk_i32 s15, 0x7f
	v_add_nc_u32_e32 v35, 0x8000, v33
	v_add_nc_u32_e32 v36, 0x10000, v33
	v_add_nc_u32_e32 v37, 0x18000, v33
	buffer_load_b128 v[73:76], v34, s[8:11], 0 offen
	s_clause 0x3
	buffer_load_b128 v[77:80], v33, s[4:7], 0 offen slc
	buffer_load_b128 v[81:84], v35, s[4:7], 0 offen slc
	buffer_load_b128 v[85:88], v36, s[4:7], 0 offen slc
	buffer_load_b128 v[89:92], v37, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v95, 0x8000, v93
	v_add_nc_u32_e32 v111, 0x10000, v93
	v_add_nc_u32_e32 v112, 0x18000, v93
	ds_load_b128 v[33:36], v105
	ds_load_b128 v[37:40], v105 offset:16
	ds_load_u16_d16_hi v65, v104 offset:128
	ds_load_u16_d16 v65, v104
	ds_load_u16_d16 v41, v104 offset:32
	ds_load_u16_d16_hi v41, v104 offset:160
	ds_load_u16_d16 v49, v104 offset:64
	ds_load_u16_d16_hi v49, v104 offset:192
	ds_load_u16_d16_hi v57, v104 offset:224
	ds_load_u16_d16 v57, v104 offset:96
	ds_load_u16_d16 v66, v104 offset:256
	ds_load_u16_d16_hi v66, v104 offset:384
	ds_load_u16_d16 v42, v104 offset:288
	ds_load_u16_d16_hi v42, v104 offset:416
	ds_load_u16_d16 v50, v104 offset:320
	ds_load_u16_d16_hi v50, v104 offset:448
	ds_load_u16_d16_hi v58, v104 offset:480
	ds_load_u16_d16 v58, v104 offset:352
	ds_load_u16_d16 v67, v104 offset:512
	ds_load_u16_d16_hi v67, v104 offset:640
	ds_load_u16_d16 v43, v104 offset:544
	ds_load_u16_d16_hi v43, v104 offset:672
	ds_load_u16_d16 v51, v104 offset:576
	ds_load_u16_d16_hi v51, v104 offset:704
	ds_load_u16_d16_hi v59, v104 offset:736
	ds_load_u16_d16 v59, v104 offset:608
	ds_load_u16_d16 v68, v104 offset:768
	ds_load_u16_d16_hi v68, v104 offset:896
	ds_load_u16_d16 v44, v104 offset:800
	ds_load_u16_d16_hi v44, v104 offset:928
	ds_load_u16_d16 v52, v104 offset:832
	ds_load_u16_d16_hi v52, v104 offset:960
	ds_load_u16_d16_hi v60, v104 offset:992
	ds_load_u16_d16 v60, v104 offset:864
	ds_load_u16_d16 v69, v104 offset:1024
	ds_load_u16_d16_hi v69, v104 offset:1152
	ds_load_u16_d16 v45, v104 offset:1056
	ds_load_u16_d16_hi v45, v104 offset:1184
	ds_load_u16_d16 v53, v104 offset:1088
	ds_load_u16_d16_hi v53, v104 offset:1216
	ds_load_u16_d16_hi v61, v104 offset:1248
	ds_load_u16_d16 v61, v104 offset:1120
	ds_load_u16_d16 v70, v104 offset:1280
	ds_load_u16_d16_hi v70, v104 offset:1408
	ds_load_u16_d16 v46, v104 offset:1312
	ds_load_u16_d16_hi v46, v104 offset:1440
	ds_load_u16_d16 v54, v104 offset:1344
	ds_load_u16_d16_hi v54, v104 offset:1472
	ds_load_u16_d16_hi v62, v104 offset:1504
	ds_load_u16_d16 v62, v104 offset:1376
	v_lshl_add_u32 v110, s15, 17, v110
	s_waitcnt vmcnt(4)
	ds_store_b128 v106, v[73:76]
	s_waitcnt vmcnt(3)
	ds_store_b128 v109, v[77:80]
	s_waitcnt vmcnt(2)
	ds_store_b128 v109, v[81:84] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v109, v[85:88] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v109, v[89:92] offset:1536
	buffer_load_b128 v[97:100], v94, s[8:11], 0 offen
	s_clause 0x3
	buffer_load_b128 v[89:92], v93, s[4:7], 0 offen slc
	buffer_load_b128 v[93:96], v95, s[4:7], 0 offen slc
	buffer_load_b128 v[137:140], v111, s[4:7], 0 offen slc
	buffer_load_b128 v[141:144], v112, s[4:7], 0 offen slc
	ds_load_b128 v[73:76], v105
	ds_load_b128 v[77:80], v105 offset:16
	ds_load_u16_d16_hi v113, v104 offset:128
	ds_load_u16_d16 v113, v104
	ds_load_u16_d16 v121, v104 offset:32
	ds_load_u16_d16_hi v121, v104 offset:160
	ds_load_u16_d16 v129, v104 offset:64
	ds_load_u16_d16_hi v129, v104 offset:192
	ds_load_u16_d16_hi v81, v104 offset:224
	ds_load_u16_d16 v81, v104 offset:96
	ds_load_u16_d16 v114, v104 offset:256
	ds_load_u16_d16_hi v114, v104 offset:384
	ds_load_u16_d16 v122, v104 offset:288
	ds_load_u16_d16_hi v122, v104 offset:416
	ds_load_u16_d16 v130, v104 offset:320
	ds_load_u16_d16_hi v130, v104 offset:448
	ds_load_u16_d16_hi v82, v104 offset:480
	ds_load_u16_d16 v82, v104 offset:352
	ds_load_u16_d16 v115, v104 offset:512
	ds_load_u16_d16_hi v115, v104 offset:640
	ds_load_u16_d16 v123, v104 offset:544
	ds_load_u16_d16_hi v123, v104 offset:672
	ds_load_u16_d16 v131, v104 offset:576
	ds_load_u16_d16_hi v131, v104 offset:704
	ds_load_u16_d16_hi v83, v104 offset:736
	ds_load_u16_d16 v83, v104 offset:608
	ds_load_u16_d16 v116, v104 offset:768
	ds_load_u16_d16_hi v116, v104 offset:896
	ds_load_u16_d16 v124, v104 offset:800
	ds_load_u16_d16_hi v124, v104 offset:928
	ds_load_u16_d16 v132, v104 offset:832
	ds_load_u16_d16_hi v132, v104 offset:960
	ds_load_u16_d16_hi v84, v104 offset:992
	ds_load_u16_d16 v84, v104 offset:864
	ds_load_u16_d16 v117, v104 offset:1024
	ds_load_u16_d16_hi v117, v104 offset:1152
	ds_load_u16_d16 v125, v104 offset:1056
	ds_load_u16_d16_hi v125, v104 offset:1184
	ds_load_u16_d16 v133, v104 offset:1088
	ds_load_u16_d16_hi v133, v104 offset:1216
	ds_load_u16_d16_hi v85, v104 offset:1248
	ds_load_u16_d16 v85, v104 offset:1120
	ds_load_u16_d16 v118, v104 offset:1280
	ds_load_u16_d16_hi v118, v104 offset:1408
	ds_load_u16_d16 v126, v104 offset:1312
	ds_load_u16_d16_hi v126, v104 offset:1440
	ds_load_u16_d16 v134, v104 offset:1344
	ds_load_u16_d16_hi v134, v104 offset:1472
	ds_load_u16_d16_hi v86, v104 offset:1504
	ds_load_u16_d16 v86, v104 offset:1376
	ds_load_u16_d16 v119, v104 offset:1536
	ds_load_u16_d16_hi v119, v104 offset:1664
	ds_load_u16_d16 v127, v104 offset:1568
	ds_load_u16_d16_hi v127, v104 offset:1696
	ds_load_u16_d16 v135, v104 offset:1600
	ds_load_u16_d16_hi v135, v104 offset:1728
	ds_load_u16_d16_hi v87, v104 offset:1760
	ds_load_u16_d16 v87, v104 offset:1632
	ds_load_u16_d16 v120, v104 offset:1792
	ds_load_u16_d16_hi v120, v104 offset:1920
	ds_load_u16_d16 v128, v104 offset:1824
	ds_load_u16_d16_hi v128, v104 offset:1952
	ds_load_u16_d16 v136, v104 offset:1856
	ds_load_u16_d16_hi v136, v104 offset:1984
	ds_load_u16_d16_hi v88, v104 offset:2016
	ds_load_u16_d16 v88, v104 offset:1888
	v_add_nc_u32_e32 v111, 0x10000, v110
	v_add_nc_u32_e32 v112, 0x18000, v110
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[33:40], v[65:72], v[1:8]
	v_lshlrev_b32_e32 v65, 5, v108
	v_lshl_or_b32 v66, v103, 5, v108
	v_wmma_f32_16x16x16_bf16 v[9:16], v[33:40], v[41:48], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[33:40], v[49:56], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[33:40], v[57:64], v[25:32]
	v_mov_b32_e32 v70, 1
	v_ashrrev_i32_e32 v67, 31, v66
	s_waitcnt vmcnt(3)
	ds_store_b128 v109, v[89:92]
	s_waitcnt vmcnt(2)
	ds_store_b128 v109, v[93:96] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v109, v[137:140] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v109, v[141:144] offset:1536
	ds_store_b128 v106, v[97:100]
	v_lshl_add_u32 v97, s15, 5, v107
	v_add_nc_u32_e32 v107, 0x8000, v110
	buffer_load_b128 v[97:100], v97, s[8:11], 0 offen
	s_clause 0x3
	buffer_load_b128 v[137:140], v110, s[4:7], 0 offen slc
	buffer_load_b128 v[141:144], v107, s[4:7], 0 offen slc
	buffer_load_b128 v[145:148], v111, s[4:7], 0 offen slc
	buffer_load_b128 v[149:152], v112, s[4:7], 0 offen slc
	s_ashr_i32 s4, s14, 31
	v_wmma_f32_16x16x16_bf16 v[1:8], v[73:80], v[113:120], v[1:8]
	s_lshr_b32 s4, s4, 24
	ds_load_b128 v[35:38], v105
	ds_load_b128 v[39:42], v105 offset:16
	ds_load_u16_d16_hi v43, v104 offset:128
	ds_load_u16_d16 v43, v104
	ds_load_u16_d16 v51, v104 offset:32
	ds_load_u16_d16_hi v51, v104 offset:160
	ds_load_u16_d16 v89, v104 offset:64
	ds_load_u16_d16_hi v89, v104 offset:192
	ds_load_u16_d16_hi v110, v104 offset:224
	ds_load_u16_d16 v110, v104 offset:96
	ds_load_u16_d16 v44, v104 offset:256
	ds_load_u16_d16_hi v44, v104 offset:384
	ds_load_u16_d16 v52, v104 offset:288
	ds_load_u16_d16_hi v52, v104 offset:416
	ds_load_u16_d16 v90, v104 offset:320
	ds_load_u16_d16_hi v90, v104 offset:448
	ds_load_u16_d16_hi v111, v104 offset:480
	ds_load_u16_d16 v111, v104 offset:352
	ds_load_u16_d16 v45, v104 offset:512
	ds_load_u16_d16_hi v45, v104 offset:640
	ds_load_u16_d16 v53, v104 offset:544
	ds_load_u16_d16_hi v53, v104 offset:672
	ds_load_u16_d16 v91, v104 offset:576
	ds_load_u16_d16_hi v91, v104 offset:704
	ds_load_u16_d16_hi v112, v104 offset:736
	ds_load_u16_d16 v112, v104 offset:608
	ds_load_u16_d16 v46, v104 offset:768
	ds_load_u16_d16_hi v46, v104 offset:896
	ds_load_u16_d16 v54, v104 offset:800
	ds_load_u16_d16_hi v54, v104 offset:928
	ds_load_u16_d16 v92, v104 offset:832
	ds_load_u16_d16_hi v92, v104 offset:960
	ds_load_u16_d16_hi v113, v104 offset:992
	ds_load_u16_d16 v113, v104 offset:864
	ds_load_u16_d16 v47, v104 offset:1024
	ds_load_u16_d16_hi v47, v104 offset:1152
	ds_load_u16_d16 v55, v104 offset:1056
	ds_load_u16_d16_hi v55, v104 offset:1184
	ds_load_u16_d16 v93, v104 offset:1088
	ds_load_u16_d16_hi v93, v104 offset:1216
	ds_load_u16_d16_hi v114, v104 offset:1248
	ds_load_u16_d16 v114, v104 offset:1120
	ds_load_u16_d16 v48, v104 offset:1280
	ds_load_u16_d16_hi v48, v104 offset:1408
	ds_load_u16_d16 v56, v104 offset:1312
	ds_load_u16_d16_hi v56, v104 offset:1440
	ds_load_u16_d16 v94, v104 offset:1344
	ds_load_u16_d16_hi v94, v104 offset:1472
	ds_load_u16_d16_hi v115, v104 offset:1504
	ds_load_u16_d16 v115, v104 offset:1376
	ds_load_u16_d16 v49, v104 offset:1536
	ds_load_u16_d16_hi v49, v104 offset:1664
	ds_load_u16_d16 v57, v104 offset:1568
	ds_load_u16_d16_hi v57, v104 offset:1696
	ds_load_u16_d16 v95, v104 offset:1600
	ds_load_u16_d16_hi v95, v104 offset:1728
	ds_load_u16_d16_hi v116, v104 offset:1760
	ds_load_u16_d16 v116, v104 offset:1632
	ds_load_u16_d16 v50, v104 offset:1792
	ds_load_u16_d16_hi v50, v104 offset:1920
	ds_load_u16_d16 v58, v104 offset:1824
	ds_load_u16_d16_hi v58, v104 offset:1952
	ds_load_u16_d16 v96, v104 offset:1856
	ds_load_u16_d16_hi v96, v104 offset:1984
	ds_load_u16_d16_hi v117, v104 offset:2016
	ds_load_u16_d16 v117, v104 offset:1888
	s_add_i32 s4, s14, s4
	v_wmma_f32_16x16x16_bf16 v[9:16], v[73:80], v[121:128], v[9:16]
	s_and_b32 s4, s4, 0x3fff00
	v_wmma_f32_16x16x16_bf16 v[17:24], v[73:80], v[129:136], v[17:24]
	s_sub_i32 s4, s14, s4
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(VALU_DEP_3)
	v_lshl_or_b32 v68, s4, 10, v65
	v_lshlrev_b64 v[66:67], 2, v[66:67]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[73:80], v[81:88], v[25:32]
	s_mov_b32 s4, exec_lo
	v_ashrrev_i32_e32 v69, 31, v68
	s_waitcnt vmcnt(4)
	ds_store_b128 v106, v[97:100]
	s_waitcnt vmcnt(3)
	ds_store_b128 v109, v[137:140]
	s_waitcnt vmcnt(2)
	ds_store_b128 v109, v[141:144] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v109, v[145:148] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v109, v[149:152] offset:1536
	ds_load_b128 v[118:121], v105
	ds_load_b128 v[122:125], v105 offset:16
	ds_load_u16_d16_hi v126, v104 offset:128
	ds_load_u16_d16 v126, v104
	ds_load_u16_d16 v134, v104 offset:32
	ds_load_u16_d16_hi v134, v104 offset:160
	ds_load_u16_d16 v142, v104 offset:64
	ds_load_u16_d16_hi v142, v104 offset:192
	ds_load_u16_d16_hi v150, v104 offset:224
	ds_load_u16_d16 v150, v104 offset:96
	ds_load_u16_d16 v127, v104 offset:256
	ds_load_u16_d16_hi v127, v104 offset:384
	ds_load_u16_d16 v135, v104 offset:288
	ds_load_u16_d16_hi v135, v104 offset:416
	ds_load_u16_d16 v143, v104 offset:320
	ds_load_u16_d16_hi v143, v104 offset:448
	ds_load_u16_d16_hi v151, v104 offset:480
	ds_load_u16_d16 v151, v104 offset:352
	ds_load_u16_d16 v128, v104 offset:512
	ds_load_u16_d16_hi v128, v104 offset:640
	ds_load_u16_d16 v136, v104 offset:544
	ds_load_u16_d16_hi v136, v104 offset:672
	ds_load_u16_d16 v144, v104 offset:576
	ds_load_u16_d16_hi v144, v104 offset:704
	ds_load_u16_d16_hi v152, v104 offset:736
	ds_load_u16_d16 v152, v104 offset:608
	ds_load_u16_d16 v129, v104 offset:768
	ds_load_u16_d16_hi v129, v104 offset:896
	ds_load_u16_d16 v137, v104 offset:800
	ds_load_u16_d16_hi v137, v104 offset:928
	ds_load_u16_d16 v145, v104 offset:832
	ds_load_u16_d16_hi v145, v104 offset:960
	ds_load_u16_d16_hi v153, v104 offset:992
	ds_load_u16_d16 v153, v104 offset:864
	ds_load_u16_d16 v130, v104 offset:1024
	ds_load_u16_d16_hi v130, v104 offset:1152
	ds_load_u16_d16 v138, v104 offset:1056
	ds_load_u16_d16_hi v138, v104 offset:1184
	ds_load_u16_d16 v146, v104 offset:1088
	ds_load_u16_d16_hi v146, v104 offset:1216
	ds_load_u16_d16_hi v154, v104 offset:1248
	ds_load_u16_d16 v154, v104 offset:1120
	ds_load_u16_d16 v131, v104 offset:1280
	ds_load_u16_d16_hi v131, v104 offset:1408
	ds_load_u16_d16 v139, v104 offset:1312
	ds_load_u16_d16_hi v139, v104 offset:1440
	ds_load_u16_d16 v147, v104 offset:1344
	ds_load_u16_d16_hi v147, v104 offset:1472
	ds_load_u16_d16_hi v155, v104 offset:1504
	ds_load_u16_d16 v155, v104 offset:1376
	ds_load_u16_d16 v132, v104 offset:1536
	ds_load_u16_d16_hi v132, v104 offset:1664
	ds_load_u16_d16 v140, v104 offset:1568
	ds_load_u16_d16_hi v140, v104 offset:1696
	ds_load_u16_d16 v148, v104 offset:1600
	ds_load_u16_d16_hi v148, v104 offset:1728
	ds_load_u16_d16_hi v156, v104 offset:1760
	ds_load_u16_d16 v156, v104 offset:1632
	ds_load_u16_d16 v133, v104 offset:1792
	ds_load_u16_d16_hi v133, v104 offset:1920
	ds_load_u16_d16 v141, v104 offset:1824
	ds_load_u16_d16_hi v141, v104 offset:1952
	ds_load_u16_d16 v149, v104 offset:1856
	ds_load_u16_d16_hi v149, v104 offset:1984
	ds_load_u16_d16_hi v157, v104 offset:2016
	ds_load_u16_d16 v157, v104 offset:1888
	v_lshlrev_b64 v[59:60], 2, v[68:69]
	s_waitcnt lgkmcnt(62)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[35:42], v[43:50], v[1:8]
	v_add_co_u32 v33, vcc_lo, s12, v66
	v_wmma_f32_16x16x16_bf16 v[9:16], v[35:42], v[51:58], v[9:16]
	v_add_co_ci_u32_e64 v34, null, s13, v67, vcc_lo
	v_add_co_u32 v59, vcc_lo, s2, v59
	v_wmma_f32_16x16x16_bf16 v[17:24], v[35:42], v[89:96], v[17:24]
	v_add_co_ci_u32_e64 v60, null, s3, v60, vcc_lo
	v_wmma_f32_16x16x16_bf16 v[25:32], v[35:42], v[110:117], v[25:32]
	s_waitcnt lgkmcnt(6)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[118:125], v[126:133], v[1:8]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[118:125], v[134:141], v[9:16]
	s_waitcnt lgkmcnt(2)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[118:125], v[142:149], v[17:24]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[118:125], v[150:157], v[25:32]
	s_clause 0x7
	global_store_b128 v[59:60], v[5:8], off offset:16
	global_store_b128 v[59:60], v[1:4], off
	global_store_b128 v[59:60], v[13:16], off offset:48
	global_store_b128 v[59:60], v[9:12], off offset:32
	global_store_b128 v[59:60], v[21:24], off offset:80
	global_store_b128 v[59:60], v[17:20], off offset:64
	global_store_b128 v[59:60], v[29:32], off offset:112
	global_store_b128 v[59:60], v[25:28], off offset:96
	s_waitcnt_vscnt null, 0x0
	global_atomic_add_u32 v1, v[33:34], v70, off glc
	s_waitcnt vmcnt(0)
	buffer_gl1_inv
	buffer_gl0_inv
	v_cmpx_eq_u32_e32 3, v1
	s_cbranch_execz .LBB0_4
	v_lshl_or_b32 v1, v103, 12, v65
	s_load_b64 s[0:1], s[0:1], 0x30
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v2, 31, v1
	v_lshlrev_b64 v[1:2], 2, v[1:2]
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v99, vcc_lo, s2, v1
	v_add_co_ci_u32_e64 v100, null, s3, v2, vcc_lo
	s_mov_b32 s3, 0x21027000
	v_add_co_u32 v67, vcc_lo, v99, 0x2000
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v68, null, 0, v100, vcc_lo
	v_add_co_u32 v51, vcc_lo, 0x1000, v99
	v_add_co_ci_u32_e64 v52, null, 0, v100, vcc_lo
	v_add_co_u32 v63, vcc_lo, 0x1040, v99
	s_clause 0x7
	global_load_b128 v[9:12], v[99:100], off
	global_load_b128 v[13:16], v[99:100], off offset:16
	global_load_b128 v[17:20], v[99:100], off offset:32
	global_load_b128 v[21:24], v[99:100], off offset:48
	global_load_b128 v[25:28], v[99:100], off offset:64
	global_load_b128 v[5:8], v[99:100], off offset:80
	global_load_b128 v[1:4], v[99:100], off offset:96
	global_load_b128 v[29:32], v[99:100], off offset:112
	v_add_co_ci_u32_e64 v64, null, 0, v100, vcc_lo
	v_add_co_u32 v83, vcc_lo, 0x2000, v99
	s_clause 0x3
	global_load_b128 v[35:38], v[67:68], off offset:-4096
	global_load_b128 v[39:42], v[51:52], off offset:16
	global_load_b128 v[43:46], v[51:52], off offset:32
	global_load_b128 v[47:50], v[51:52], off offset:48
	v_add_co_ci_u32_e64 v84, null, 0, v100, vcc_lo
	s_clause 0x3
	global_load_b128 v[51:54], v[51:52], off offset:64
	global_load_b128 v[55:58], v[63:64], off offset:16
	global_load_b128 v[59:62], v[63:64], off offset:32
	global_load_b128 v[63:66], v[63:64], off offset:48
	v_add_co_u32 v95, vcc_lo, 0x2040, v99
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v96, null, 0, v100, vcc_lo
	v_add_co_u32 v119, vcc_lo, 0x3000, v99
	s_clause 0x3
	global_load_b128 v[67:70], v[67:68], off
	global_load_b128 v[71:74], v[83:84], off offset:16
	global_load_b128 v[75:78], v[83:84], off offset:32
	global_load_b128 v[79:82], v[83:84], off offset:48
	v_add_co_ci_u32_e64 v120, null, 0, v100, vcc_lo
	s_clause 0x7
	global_load_b128 v[83:86], v[83:84], off offset:64
	global_load_b128 v[87:90], v[95:96], off offset:16
	global_load_b128 v[91:94], v[95:96], off offset:32
	global_load_b128 v[95:98], v[95:96], off offset:48
	global_load_b128 v[103:106], v[119:120], off
	global_load_b128 v[107:110], v[119:120], off offset:16
	global_load_b128 v[111:114], v[119:120], off offset:32
	global_load_b128 v[115:118], v[119:120], off offset:48
	v_add_co_u32 v99, vcc_lo, 0x3040, v99
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v100, null, 0, v100, vcc_lo
	s_clause 0x3
	global_load_b128 v[119:122], v[119:120], off offset:64
	global_load_b128 v[123:126], v[99:100], off offset:16
	global_load_b128 v[127:130], v[99:100], off offset:32
	global_load_b128 v[131:134], v[99:100], off offset:48
	v_lshlrev_b32_e32 v0, 8, v0
	s_mov_b32 s2, -1
	s_waitcnt lgkmcnt(0)
	s_and_b32 s1, s1, 0xffff
	s_waitcnt vmcnt(31)
	v_dual_add_f32 v9, 0, v9 :: v_dual_add_f32 v10, 0, v10
	v_dual_add_f32 v11, 0, v11 :: v_dual_add_f32 v12, 0, v12
	s_waitcnt vmcnt(30)
	v_dual_add_f32 v13, 0, v13 :: v_dual_add_f32 v14, 0, v14
	s_waitcnt vmcnt(24)
	v_dual_add_f32 v15, 0, v15 :: v_dual_add_f32 v32, 0, v32
	v_dual_add_f32 v16, 0, v16 :: v_dual_add_f32 v17, 0, v17
	s_waitcnt vmcnt(23)
	v_dual_add_f32 v9, v9, v35 :: v_dual_add_f32 v10, v10, v36
	v_dual_add_f32 v11, v11, v37 :: v_dual_add_f32 v12, v12, v38
	s_waitcnt vmcnt(16)
	v_dual_add_f32 v13, v13, v39 :: v_dual_add_f32 v32, v32, v66
	v_dual_add_f32 v14, v14, v40 :: v_dual_add_f32 v15, v15, v41
	v_dual_add_f32 v18, 0, v18 :: v_dual_add_f32 v19, 0, v19
	s_waitcnt vmcnt(15)
	v_dual_add_f32 v9, v9, v67 :: v_dual_add_f32 v10, v10, v68
	s_waitcnt vmcnt(8)
	v_dual_add_f32 v11, v11, v69 :: v_dual_add_f32 v32, v32, v98
	v_dual_add_f32 v12, v12, v70 :: v_dual_add_f32 v13, v13, v71
	s_waitcnt vmcnt(7)
	v_dual_add_f32 v9, v9, v103 :: v_dual_add_f32 v10, v10, v104
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_dual_add_f32 v11, v11, v105 :: v_dual_add_f32 v12, v12, v106
	s_waitcnt vmcnt(6)
	v_add_f32_e32 v13, v13, v107
	v_bfe_u32 v35, v9, 16, 1
	v_or_b32_e32 v36, 0x400000, v9
	v_bfe_u32 v37, v10, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_or_b32_e32 v38, 0x400000, v10
	v_add3_u32 v35, v35, v9, 0x7fff
	s_waitcnt vmcnt(0)
	v_add_f32_e32 v32, v32, v134
	v_bfe_u32 v39, v11, 16, 1
	v_add3_u32 v37, v37, v10, 0x7fff
	v_dual_add_f32 v14, v14, v72 :: v_dual_add_f32 v15, v15, v73
	v_cndmask_b32_e32 v9, v35, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_or_b32_e32 v40, 0x400000, v11
	v_bfe_u32 v41, v12, 16, 1
	v_add3_u32 v39, v39, v11, 0x7fff
	v_dual_add_f32 v16, v16, v42 :: v_dual_add_f32 v17, v17, v43
	v_cndmask_b32_e32 v10, v37, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_dual_add_f32 v14, v14, v108 :: v_dual_add_f32 v15, v15, v109
	v_or_b32_e32 v42, 0x400000, v12
	v_bfe_u32 v43, v13, 16, 1
	v_add3_u32 v41, v41, v12, 0x7fff
	v_cndmask_b32_e32 v11, v39, v40, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_dual_add_f32 v20, 0, v20 :: v_dual_add_f32 v21, 0, v21
	v_dual_add_f32 v18, v18, v44 :: v_dual_add_f32 v19, v19, v45
	v_dual_add_f32 v16, v16, v74 :: v_dual_add_f32 v17, v17, v75
	v_or_b32_e32 v44, 0x400000, v13
	v_bfe_u32 v45, v14, 16, 1
	v_add3_u32 v43, v43, v13, 0x7fff
	v_cndmask_b32_e32 v12, v41, v42, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_dual_add_f32 v22, 0, v22 :: v_dual_add_f32 v23, 0, v23
	v_dual_add_f32 v20, v20, v46 :: v_dual_add_f32 v21, v21, v47
	v_dual_add_f32 v16, v16, v110 :: v_dual_add_f32 v17, v17, v111
	v_or_b32_e32 v46, 0x400000, v14
	v_bfe_u32 v47, v15, 16, 1
	v_add3_u32 v45, v45, v14, 0x7fff
	v_cndmask_b32_e32 v13, v43, v44, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_dual_add_f32 v24, 0, v24 :: v_dual_add_f32 v25, 0, v25
	v_dual_add_f32 v22, v22, v48 :: v_dual_add_f32 v23, v23, v49
	v_dual_add_f32 v18, v18, v76 :: v_dual_add_f32 v19, v19, v77
	v_or_b32_e32 v48, 0x400000, v15
	v_bfe_u32 v49, v16, 16, 1
	v_add3_u32 v47, v47, v15, 0x7fff
	v_cndmask_b32_e32 v14, v45, v46, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_dual_add_f32 v26, 0, v26 :: v_dual_add_f32 v27, 0, v27
	v_dual_add_f32 v24, v24, v50 :: v_dual_add_f32 v25, v25, v51
	v_dual_add_f32 v18, v18, v112 :: v_dual_add_f32 v19, v19, v113
	v_or_b32_e32 v50, 0x400000, v16
	v_bfe_u32 v51, v17, 16, 1
	v_add3_u32 v49, v49, v16, 0x7fff
	v_cndmask_b32_e32 v15, v47, v48, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	v_dual_add_f32 v28, 0, v28 :: v_dual_add_f32 v5, 0, v5
	v_dual_add_f32 v26, v26, v52 :: v_dual_add_f32 v27, v27, v53
	v_dual_add_f32 v20, v20, v78 :: v_dual_add_f32 v21, v21, v79
	v_or_b32_e32 v52, 0x400000, v17
	v_bfe_u32 v53, v18, 16, 1
	v_add3_u32 v51, v51, v17, 0x7fff
	v_cndmask_b32_e32 v16, v49, v50, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v17, v17
	v_dual_add_f32 v6, 0, v6 :: v_dual_add_f32 v7, 0, v7
	v_dual_add_f32 v28, v28, v54 :: v_dual_add_f32 v5, v5, v55
	v_dual_add_f32 v20, v20, v114 :: v_dual_add_f32 v21, v21, v115
	v_or_b32_e32 v54, 0x400000, v18
	v_bfe_u32 v55, v19, 16, 1
	v_add3_u32 v53, v53, v18, 0x7fff
	v_cndmask_b32_e32 v17, v51, v52, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v18, v18
	v_dual_add_f32 v8, 0, v8 :: v_dual_add_f32 v1, 0, v1
	v_dual_add_f32 v6, v6, v56 :: v_dual_add_f32 v7, v7, v57
	v_dual_add_f32 v22, v22, v80 :: v_dual_add_f32 v23, v23, v81
	v_or_b32_e32 v56, 0x400000, v19
	v_bfe_u32 v57, v20, 16, 1
	v_add3_u32 v55, v55, v19, 0x7fff
	v_cndmask_b32_e32 v18, v53, v54, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v19, v19
	v_dual_add_f32 v2, 0, v2 :: v_dual_add_f32 v3, 0, v3
	v_dual_add_f32 v8, v8, v58 :: v_dual_add_f32 v1, v1, v59
	v_dual_add_f32 v22, v22, v116 :: v_dual_add_f32 v23, v23, v117
	v_or_b32_e32 v58, 0x400000, v20
	v_bfe_u32 v59, v21, 16, 1
	v_add3_u32 v57, v57, v20, 0x7fff
	v_cndmask_b32_e32 v19, v55, v56, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v20, v20
	v_dual_add_f32 v4, 0, v4 :: v_dual_add_f32 v29, 0, v29
	v_dual_add_f32 v2, v2, v60 :: v_dual_add_f32 v3, v3, v61
	v_dual_add_f32 v24, v24, v82 :: v_dual_add_f32 v25, v25, v83
	v_or_b32_e32 v60, 0x400000, v21
	v_bfe_u32 v61, v22, 16, 1
	v_add3_u32 v59, v59, v21, 0x7fff
	v_cndmask_b32_e32 v20, v57, v58, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v21, v21
	v_dual_add_f32 v30, 0, v30 :: v_dual_add_f32 v31, 0, v31
	v_dual_add_f32 v4, v4, v62 :: v_dual_add_f32 v29, v29, v63
	v_dual_add_f32 v24, v24, v118 :: v_dual_add_f32 v25, v25, v119
	v_or_b32_e32 v62, 0x400000, v22
	v_bfe_u32 v63, v23, 16, 1
	v_add3_u32 v61, v61, v22, 0x7fff
	v_cndmask_b32_e32 v21, v59, v60, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v22, v22
	v_dual_add_f32 v30, v30, v64 :: v_dual_add_f32 v31, v31, v65
	v_dual_add_f32 v26, v26, v84 :: v_dual_add_f32 v27, v27, v85
	v_or_b32_e32 v64, 0x400000, v23
	v_bfe_u32 v65, v24, 16, 1
	v_add3_u32 v63, v63, v23, 0x7fff
	v_cndmask_b32_e32 v22, v61, v62, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v23, v23
	v_dual_add_f32 v26, v26, v120 :: v_dual_add_f32 v27, v27, v121
	v_or_b32_e32 v66, 0x400000, v24
	v_bfe_u32 v67, v25, 16, 1
	v_add3_u32 v65, v65, v24, 0x7fff
	v_cndmask_b32_e32 v23, v63, v64, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v24, v24
	v_dual_add_f32 v28, v28, v86 :: v_dual_add_f32 v5, v5, v87
	v_or_b32_e32 v68, 0x400000, v25
	v_bfe_u32 v69, v26, 16, 1
	v_add3_u32 v67, v67, v25, 0x7fff
	v_cndmask_b32_e32 v24, v65, v66, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v25, v25
	v_dual_add_f32 v28, v28, v122 :: v_dual_add_f32 v5, v5, v123
	v_or_b32_e32 v70, 0x400000, v26
	v_bfe_u32 v71, v27, 16, 1
	v_add3_u32 v69, v69, v26, 0x7fff
	v_cndmask_b32_e32 v25, v67, v68, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v26, v26
	v_dual_add_f32 v6, v6, v88 :: v_dual_add_f32 v7, v7, v89
	v_or_b32_e32 v72, 0x400000, v27
	v_bfe_u32 v73, v28, 16, 1
	v_add3_u32 v71, v71, v27, 0x7fff
	v_cndmask_b32_e32 v26, v69, v70, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v27, v27
	v_dual_add_f32 v6, v6, v124 :: v_dual_add_f32 v7, v7, v125
	v_or_b32_e32 v74, 0x400000, v28
	v_bfe_u32 v75, v5, 16, 1
	v_add3_u32 v73, v73, v28, 0x7fff
	v_cndmask_b32_e32 v27, v71, v72, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v28, v28
	v_dual_add_f32 v8, v8, v90 :: v_dual_add_f32 v1, v1, v91
	v_or_b32_e32 v76, 0x400000, v5
	v_bfe_u32 v77, v6, 16, 1
	v_add3_u32 v75, v75, v5, 0x7fff
	v_cndmask_b32_e32 v28, v73, v74, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_dual_add_f32 v8, v8, v126 :: v_dual_add_f32 v1, v1, v127
	v_or_b32_e32 v78, 0x400000, v6
	v_bfe_u32 v79, v7, 16, 1
	v_add3_u32 v77, v77, v6, 0x7fff
	v_cndmask_b32_e32 v5, v75, v76, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_dual_add_f32 v2, v2, v92 :: v_dual_add_f32 v3, v3, v93
	v_or_b32_e32 v80, 0x400000, v7
	v_bfe_u32 v81, v8, 16, 1
	v_add3_u32 v79, v79, v7, 0x7fff
	v_cndmask_b32_e32 v6, v77, v78, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_dual_add_f32 v2, v2, v128 :: v_dual_add_f32 v3, v3, v129
	v_or_b32_e32 v82, 0x400000, v8
	v_bfe_u32 v83, v1, 16, 1
	v_add3_u32 v81, v81, v8, 0x7fff
	v_cndmask_b32_e32 v7, v79, v80, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_dual_add_f32 v4, v4, v94 :: v_dual_add_f32 v29, v29, v95
	v_or_b32_e32 v84, 0x400000, v1
	v_bfe_u32 v85, v2, 16, 1
	v_add3_u32 v83, v83, v1, 0x7fff
	v_cndmask_b32_e32 v8, v81, v82, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	v_dual_add_f32 v4, v4, v130 :: v_dual_add_f32 v29, v29, v131
	v_or_b32_e32 v86, 0x400000, v2
	v_bfe_u32 v87, v3, 16, 1
	v_add3_u32 v85, v85, v2, 0x7fff
	v_cndmask_b32_e32 v1, v83, v84, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_dual_add_f32 v30, v30, v96 :: v_dual_add_f32 v31, v31, v97
	v_or_b32_e32 v88, 0x400000, v3
	v_bfe_u32 v89, v4, 16, 1
	v_add3_u32 v87, v87, v3, 0x7fff
	v_cndmask_b32_e32 v2, v85, v86, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_dual_add_f32 v30, v30, v132 :: v_dual_add_f32 v31, v31, v133
	v_or_b32_e32 v90, 0x400000, v4
	v_bfe_u32 v91, v29, 16, 1
	v_add3_u32 v89, v89, v4, 0x7fff
	v_cndmask_b32_e32 v3, v87, v88, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_or_b32_e32 v92, 0x400000, v29
	v_bfe_u32 v93, v30, 16, 1
	v_add3_u32 v91, v91, v29, 0x7fff
	v_or_b32_e32 v94, 0x400000, v30
	v_cndmask_b32_e32 v4, v89, v90, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v29, v29
	v_bfe_u32 v95, v31, 16, 1
	v_add3_u32 v93, v93, v30, 0x7fff
	v_or_b32_e32 v35, v102, v101
	v_or_b32_e32 v37, 0x400000, v31
	v_cndmask_b32_e32 v29, v91, v92, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v30, v30
	v_add3_u32 v36, v95, v31, 0x7fff
	v_bfe_u32 v96, v32, 16, 1
	v_lshrrev_b32_e32 v9, 16, v9
	v_or_b32_e32 v39, 0x400000, v32
	v_cndmask_b32_e32 v30, v93, v94, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v31, v31
	v_and_b32_e32 v0, 0x1000, v0
	v_add3_u32 v38, v96, v32, 0x7fff
	v_lshrrev_b32_e32 v10, 16, v10
	v_lshrrev_b32_e32 v11, 16, v11
	v_cndmask_b32_e32 v31, v36, v37, vcc_lo
	v_add_lshl_u32 v0, v35, v0, 1
	v_cmp_u_f32_e32 vcc_lo, v32, v32
	v_lshrrev_b32_e32 v12, 16, v12
	v_lshrrev_b32_e32 v13, 16, v13
	v_lshrrev_b32_e32 v14, 16, v14
	v_add_nc_u32_e32 v35, 0x4000, v0
	v_add_nc_u32_e32 v36, 0x8000, v0
	v_cndmask_b32_e32 v32, v38, v39, vcc_lo
	s_clause 0x2
	buffer_store_b16 v9, v0, s[0:3], 0 offen
	buffer_store_b16 v10, v35, s[0:3], 0 offen
	buffer_store_b16 v11, v36, s[0:3], 0 offen
	v_add_nc_u32_e32 v9, 0xc000, v0
	v_add_nc_u32_e32 v10, 0x10000, v0
	v_add_nc_u32_e32 v11, 0x14000, v0
	v_lshrrev_b32_e32 v15, 16, v15
	v_add_nc_u32_e32 v37, 0x18000, v0
	v_lshrrev_b32_e32 v16, 16, v16
	v_add_nc_u32_e32 v38, 0x1c000, v0
	v_lshrrev_b32_e32 v17, 16, v17
	v_lshrrev_b32_e32 v18, 16, v18
	v_lshrrev_b32_e32 v19, 16, v19
	v_lshrrev_b32_e32 v20, 16, v20
	v_lshrrev_b32_e32 v21, 16, v21
	v_lshrrev_b32_e32 v22, 16, v22
	v_lshrrev_b32_e32 v23, 16, v23
	v_lshrrev_b32_e32 v24, 16, v24
	v_lshrrev_b32_e32 v25, 16, v25
	v_lshrrev_b32_e32 v26, 16, v26
	v_lshrrev_b32_e32 v27, 16, v27
	v_lshrrev_b32_e32 v28, 16, v28
	v_lshrrev_b32_e32 v5, 16, v5
	v_lshrrev_b32_e32 v6, 16, v6
	v_lshrrev_b32_e32 v7, 16, v7
	v_lshrrev_b32_e32 v8, 16, v8
	v_lshrrev_b32_e32 v1, 16, v1
	v_lshrrev_b32_e32 v2, 16, v2
	v_lshrrev_b32_e32 v3, 16, v3
	v_lshrrev_b32_e32 v4, 16, v4
	v_lshrrev_b32_e32 v29, 16, v29
	s_clause 0x18
	buffer_store_b16 v12, v9, s[0:3], 0 offen
	buffer_store_b16 v13, v10, s[0:3], 0 offen
	buffer_store_b16 v14, v11, s[0:3], 0 offen
	buffer_store_b16 v15, v37, s[0:3], 0 offen
	buffer_store_b16 v16, v38, s[0:3], 0 offen
	buffer_store_b16 v17, v0, s[0:3], 0 offen offset:32
	buffer_store_b16 v18, v35, s[0:3], 0 offen offset:32
	buffer_store_b16 v19, v36, s[0:3], 0 offen offset:32
	buffer_store_b16 v20, v9, s[0:3], 0 offen offset:32
	buffer_store_b16 v21, v10, s[0:3], 0 offen offset:32
	buffer_store_b16 v22, v11, s[0:3], 0 offen offset:32
	buffer_store_b16 v23, v37, s[0:3], 0 offen offset:32
	buffer_store_b16 v24, v38, s[0:3], 0 offen offset:32
	buffer_store_b16 v25, v0, s[0:3], 0 offen offset:64
	buffer_store_b16 v26, v35, s[0:3], 0 offen offset:64
	buffer_store_b16 v27, v36, s[0:3], 0 offen offset:64
	buffer_store_b16 v28, v9, s[0:3], 0 offen offset:64
	buffer_store_b16 v5, v10, s[0:3], 0 offen offset:64
	buffer_store_b16 v6, v11, s[0:3], 0 offen offset:64
	buffer_store_b16 v7, v37, s[0:3], 0 offen offset:64
	buffer_store_b16 v8, v38, s[0:3], 0 offen offset:64
	buffer_store_b16 v1, v0, s[0:3], 0 offen offset:96
	buffer_store_b16 v2, v35, s[0:3], 0 offen offset:96
	buffer_store_b16 v3, v36, s[0:3], 0 offen offset:96
	buffer_store_b16 v4, v9, s[0:3], 0 offen offset:96
	v_mov_b32_e32 v0, 0
	v_lshrrev_b32_e32 v30, 16, v30
	v_lshrrev_b32_e32 v31, 16, v31
	v_lshrrev_b32_e32 v32, 16, v32
	s_clause 0x3
	buffer_store_b16 v29, v10, s[0:3], 0 offen offset:96
	buffer_store_b16 v30, v11, s[0:3], 0 offen offset:96
	buffer_store_b16 v31, v37, s[0:3], 0 offen offset:96
	buffer_store_b16 v32, v38, s[0:3], 0 offen offset:96
	s_waitcnt_vscnt null, 0x0
	global_store_b32 v[33:34], v0, off
.LBB0_4:
	s_nop 0
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
	s_endpgm
.Lfunc_end0:
	.size	exercise_kernel_0, .Lfunc_end0-exercise_kernel_0
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel exercise_kernel_0
		.amdhsa_group_segment_fixed_size 5632
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
		.amdhsa_next_free_vgpr 158
		.amdhsa_next_free_sgpr 17
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

	.set .Lexercise_kernel_0.num_vgpr, 158
	.set .Lexercise_kernel_0.num_agpr, 0
	.set .Lexercise_kernel_0.numbered_sgpr, 17
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
    .group_segment_fixed_size: 5632
    .kernarg_segment_align: 8
    .kernarg_segment_size: 100
    .max_flat_workgroup_size: 64
    .name:           exercise_kernel_0
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 64
      - 1
      - 1
    .sgpr_count:     19
    .sgpr_spill_count: 0
    .symbol:         exercise_kernel_0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     158
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
