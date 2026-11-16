	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	_matmul_bf16_0
	.p2align	8
	.type	_matmul_bf16_0,@function
_matmul_bf16_0:
	v_lshrrev_b32_e32 v1, 5, v0
	s_lshl_b32 s3, s2, 2
	v_bfe_u32 v49, v0, 1, 4
	v_bfe_u32 v40, v0, 3, 2
	s_mov_b32 s7, 0x21027000
	v_or_b32_e32 v1, s3, v1
	s_bfe_i32 s3, s2, 0x1001d
	s_bfe_u32 s2, s2, 0x1001d
	s_lshr_b32 s4, s3, 30
	s_lshr_b32 s5, s3, 29
	v_add_nc_u32_e32 v2, s2, v1
	s_lshr_b32 s2, s3, 27
	v_add_nc_u32_e32 v3, s4, v1
	v_add_nc_u32_e32 v5, s2, v1
	v_add_nc_u32_e32 v4, s5, v1
	v_ashrrev_i32_e32 v6, 1, v2
	v_lshrrev_b32_e32 v7, 31, v2
	v_ashrrev_i32_e32 v8, 2, v3
	v_lshrrev_b32_e32 v3, 31, v3
	v_ashrrev_i32_e32 v9, 5, v5
	v_lshrrev_b32_e32 v5, 31, v5
	v_add_nc_u32_e32 v7, v6, v7
	v_ashrrev_i32_e32 v4, 3, v4
	v_add_nc_u32_e32 v3, v8, v3
	v_and_b32_e32 v2, -2, v2
	v_add_nc_u32_e32 v5, v9, v5
	v_and_b32_e32 v7, -2, v7
	v_lshrrev_b32_e32 v10, 30, v4
	v_and_b32_e32 v3, -2, v3
	v_sub_nc_u32_e32 v33, v1, v2
	v_and_b32_e32 v5, -2, v5
	v_sub_nc_u32_e32 v35, v6, v7
	v_add_nc_u32_e32 v1, v4, v10
	v_sub_nc_u32_e32 v36, v8, v3
	v_lshlrev_b32_e32 v2, 3, v0
	v_sub_nc_u32_e32 v34, v9, v5
	s_clause 0x1
	s_load_b64 s[4:5], s[0:1], 0x0
	s_load_b64 s[8:9], s[0:1], 0x18
	v_and_b32_e32 v1, -4, v1
	v_lshl_add_u32 v41, v36, 1, v35
	v_and_b32_e32 v47, 8, v2
	v_lshl_add_u32 v42, v34, 1, v33
	v_and_b32_e32 v45, 56, v2
	v_sub_nc_u32_e32 v38, v4, v1
	v_mul_lo_u32 v43, 0x1800, v41
	v_mul_u32_u24_e32 v4, 0x180, v49
	v_lshlrev_b32_e32 v46, 6, v42
	v_lshl_or_b32 v48, v40, 8, v45
	s_mov_b32 s6, -1
	s_mov_b32 s11, s7
	v_or_b32_e32 v70, v4, v47
	v_mad_u64_u32 v[1:2], null, 0x6000, v38, v[46:47]
	v_mad_u64_u32 v[2:3], null, 0x60, v38, v[43:44]
	s_mov_b32 s10, s6
	v_mul_lo_u32 v71, 0x300, v33
	v_mul_lo_u32 v72, 0x600, v35
	s_waitcnt lgkmcnt(0)
	s_and_b32 s5, s5, 0xffff
	s_and_b32 s9, s9, 0xffff
	v_mul_lo_u32 v74, v38, 6
	v_add_lshl_u32 v1, v1, v48, 1
	v_add_lshl_u32 v2, v2, v70, 1
	s_mov_b32 s2, 0
	v_lshlrev_b32_e32 v32, 11, v33
	v_add3_u32 v71, v72, v71, 0x2000
	v_add_nc_u32_e32 v3, 0x1000, v1
	buffer_load_b128 v[50:53], v2, s[4:7], 0 offen
	s_clause 0x3
	buffer_load_b128 v[54:57], v1, s[8:11], 0 offen slc
	buffer_load_b128 v[58:61], v1, s[8:11], 0 offen offset:2048 slc
	buffer_load_b128 v[62:65], v3, s[8:11], 0 offen slc
	buffer_load_b128 v[66:69], v3, s[8:11], 0 offen offset:2048 slc
	v_mov_b32_e32 v1, 0
	v_and_b32_e32 v37, 15, v0
	v_lshlrev_b32_e32 v44, 7, v40
	v_mul_u32_u24_e32 v72, 48, v49
	s_delay_alu instid0(VALU_DEP_4)
	v_dual_mov_b32 v22, v1 :: v_dual_and_b32 v39, 31, v0
	v_mov_b32_e32 v11, v1
	v_lshl_add_u32 v73, v35, 12, v32
	v_mov_b32_e32 v13, v1
	v_mov_b32_e32 v16, v1
	v_mov_b32_e32 v18, v1
	v_mov_b32_e32 v24, v1
	v_lshl_or_b32 v45, v45, 1, v73
	v_mul_u32_u24_e32 v75, 48, v37
	v_lshl_or_b32 v40, v37, 1, v73
	v_lshl_or_b32 v73, v47, 1, v71
	v_mov_b32_e32 v2, v1
	v_mov_b32_e32 v3, v1
	v_mov_b32_e32 v4, v1
	v_mov_b32_e32 v5, v1
	v_mov_b32_e32 v6, v1
	v_mov_b32_e32 v7, v1
	v_mov_b32_e32 v8, v1
	v_mov_b32_e32 v9, v1
	v_mov_b32_e32 v10, v1
	v_mov_b32_e32 v12, v1
	v_mov_b32_e32 v14, v1
	v_mov_b32_e32 v15, v1
	v_mov_b32_e32 v17, v1
	v_mov_b32_e32 v19, v1
	v_mov_b32_e32 v20, v1
	v_mov_b32_e32 v21, v1
	v_mov_b32_e32 v23, v1
	v_mov_b32_e32 v25, v1
	v_mov_b32_e32 v26, v1
	v_mov_b32_e32 v27, v1
	v_mov_b32_e32 v28, v1
	v_mov_b32_e32 v29, v1
	v_mov_b32_e32 v30, v1
	v_mov_b32_e32 v31, v1
	v_mov_b32_e32 v32, v1
	v_add_lshl_u32 v46, v48, v46, 1
	v_or_b32_e32 v47, 1, v74
	v_add_lshl_u32 v48, v70, v43, 1
	v_mad_u32_u24 v70, v49, 48, v73
	v_add_nc_u32_e32 v43, v71, v75
	v_add_nc_u32_e32 v49, v73, v72
	v_or_b32_e32 v76, v45, v44
	s_waitcnt vmcnt(4)
	ds_store_b128 v70, v[50:53]
	s_waitcnt vmcnt(3)
	ds_store_b128 v76, v[54:57]
	s_waitcnt vmcnt(2)
	ds_store_b128 v76, v[58:61] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v76, v[62:65] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v76, v[66:69] offset:1536
.LBB0_1:
	v_add_nc_u32_e32 v50, s2, v47
	s_add_i32 s2, s2, 1
	v_add_nc_u32_e32 v110, v45, v44
	s_cmp_lg_u32 s2, 5
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_lshl_add_u32 v51, v50, 13, v46
	v_lshl_add_u32 v50, v50, 5, v48
	v_add_nc_u32_e32 v52, 0x1000, v51
	buffer_load_b128 v[90:93], v50, s[4:7], 0 offen
	s_clause 0x3
	buffer_load_b128 v[94:97], v51, s[8:11], 0 offen slc
	buffer_load_b128 v[98:101], v51, s[8:11], 0 offen offset:2048 slc
	buffer_load_b128 v[102:105], v52, s[8:11], 0 offen slc
	buffer_load_b128 v[106:109], v52, s[8:11], 0 offen offset:2048 slc
	ds_load_b128 v[50:53], v43
	ds_load_b128 v[54:57], v43 offset:16
	ds_load_u16_d16 v65, v40 offset:1824
	ds_load_u16_d16 v68, v40 offset:576
	ds_load_u16_d16 v76, v40 offset:512
	ds_load_u16_d16 v59, v40 offset:288
	ds_load_u16_d16 v84, v40 offset:608
	ds_load_u16_d16 v83, v40 offset:352
	ds_load_u16_d16 v77, v40 offset:768
	ds_load_u16_d16 v69, v40 offset:832
	ds_load_u16_d16 v78, v40 offset:1024
	ds_load_u16_d16 v61, v40 offset:800
	ds_load_u16_d16 v70, v40 offset:1088
	ds_load_u16_d16 v79, v40 offset:1280
	ds_load_u16_d16 v62, v40 offset:1056
	ds_load_u16_d16 v71, v40 offset:1344
	ds_load_u16_d16 v80, v40 offset:1536
	ds_load_u16_d16 v63, v40 offset:1312
	ds_load_u16_d16 v72, v40 offset:1600
	ds_load_u16_d16 v81, v40 offset:1792
	ds_load_u16_d16 v64, v40 offset:1568
	ds_load_u16_d16 v73, v40 offset:1856
	ds_load_u16_d16 v74, v40
	ds_load_u16_d16 v58, v40 offset:32
	ds_load_u16_d16 v75, v40 offset:256
	ds_load_u16_d16 v66, v40 offset:64
	ds_load_u16_d16 v67, v40 offset:320
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v83, v40 offset:480
	ds_load_u16_d16_hi v68, v40 offset:704
	ds_load_u16_d16 v60, v40 offset:544
	ds_load_u16_d16 v82, v40 offset:96
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v77, v40 offset:896
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v69, v40 offset:960
	ds_load_u16_d16 v85, v40 offset:864
	s_waitcnt lgkmcnt(23)
	ds_load_u16_d16_hi v78, v40 offset:1152
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v70, v40 offset:1216
	ds_load_u16_d16 v86, v40 offset:1120
	s_waitcnt lgkmcnt(23)
	ds_load_u16_d16_hi v79, v40 offset:1408
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v71, v40 offset:1472
	ds_load_u16_d16 v87, v40 offset:1376
	s_waitcnt lgkmcnt(23)
	ds_load_u16_d16_hi v80, v40 offset:1664
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v72, v40 offset:1728
	ds_load_u16_d16 v88, v40 offset:1632
	s_waitcnt lgkmcnt(23)
	ds_load_u16_d16_hi v81, v40 offset:1920
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v73, v40 offset:1984
	ds_load_u16_d16 v89, v40 offset:1888
	ds_load_u16_d16_hi v76, v40 offset:640
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v75, v40 offset:384
	ds_load_u16_d16_hi v74, v40 offset:128
	ds_load_u16_d16_hi v58, v40 offset:160
	s_waitcnt lgkmcnt(24)
	ds_load_u16_d16_hi v66, v40 offset:192
	s_waitcnt lgkmcnt(20)
	ds_load_u16_d16_hi v82, v40 offset:224
	ds_load_u16_d16_hi v59, v40 offset:416
	ds_load_u16_d16_hi v67, v40 offset:448
	ds_load_u16_d16_hi v60, v40 offset:672
	ds_load_u16_d16_hi v84, v40 offset:736
	ds_load_u16_d16_hi v61, v40 offset:928
	s_waitcnt lgkmcnt(23)
	ds_load_u16_d16_hi v85, v40 offset:992
	ds_load_u16_d16_hi v62, v40 offset:1184
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v86, v40 offset:1248
	ds_load_u16_d16_hi v63, v40 offset:1440
	s_waitcnt lgkmcnt(21)
	ds_load_u16_d16_hi v87, v40 offset:1504
	ds_load_u16_d16_hi v64, v40 offset:1696
	s_waitcnt lgkmcnt(20)
	ds_load_u16_d16_hi v88, v40 offset:1760
	ds_load_u16_d16_hi v65, v40 offset:1952
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v89, v40 offset:2016
	s_waitcnt lgkmcnt(17)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[50:57], v[74:81], v[1:8]
	s_waitcnt vmcnt(4)
	ds_store_b128 v49, v[90:93]
	s_waitcnt vmcnt(3)
	ds_store_b128 v110, v[94:97]
	s_waitcnt vmcnt(2)
	ds_store_b128 v110, v[98:101] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v110, v[102:105] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v110, v[106:109] offset:1536
	s_waitcnt lgkmcnt(6)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[50:57], v[58:65], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[50:57], v[66:73], v[17:24]
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[50:57], v[82:89], v[25:32]
	s_cbranch_scc1 .LBB0_1
	ds_load_u16_d16 v45, v40 offset:608
	ds_load_u16_d16 v44, v40 offset:352
	ds_load_u16_d16 v53, v40 offset:576
	ds_load_u16_d16 v61, v40 offset:512
	ds_load_u16_d16 v68, v40 offset:288
	v_lshl_add_u32 v42, v41, 2, v42
	v_lshlrev_b32_e32 v83, 10, v38
	v_lshlrev_b32_e32 v38, 5, v39
	s_clause 0x1
	s_load_b64 s[2:3], s[0:1], 0x48
	s_load_b64 s[4:5], s[0:1], 0x58
	v_lshlrev_b32_e32 v41, 12, v42
	v_lshl_or_b32 v39, v42, 5, v39
	ds_load_u16_d16 v54, v40 offset:832
	ds_load_b128 v[75:78], v43
	ds_load_b128 v[79:82], v43 offset:16
	ds_load_u16_d16 v74, v40 offset:1824
	ds_load_u16_d16 v55, v40 offset:1088
	ds_load_u16_d16 v56, v40 offset:1344
	ds_load_u16_d16 v57, v40 offset:1600
	ds_load_u16_d16 v58, v40 offset:1856
	ds_load_u16_d16 v59, v40
	ds_load_u16_d16 v67, v40 offset:32
	ds_load_u16_d16 v60, v40 offset:256
	ds_load_u16_d16 v51, v40 offset:64
	ds_load_u16_d16 v52, v40 offset:320
	s_waitcnt lgkmcnt(0)
	ds_load_u16_d16_hi v44, v40 offset:480
	ds_load_u16_d16 v43, v40 offset:96
	ds_load_u16_d16 v62, v40 offset:768
	ds_load_u16_d16_hi v53, v40 offset:704
	ds_load_u16_d16 v69, v40 offset:544
	ds_load_u16_d16 v63, v40 offset:1024
	ds_load_u16_d16 v70, v40 offset:800
	v_add_nc_u32_e32 v83, v41, v83
	ds_load_u16_d16_hi v59, v40 offset:128
	ds_load_u16_d16_hi v67, v40 offset:160
	ds_load_u16_d16_hi v51, v40 offset:192
	v_or_b32_e32 v83, v83, v38
	ds_load_u16_d16_hi v54, v40 offset:960
	ds_load_u16_d16 v46, v40 offset:864
	ds_load_u16_d16 v64, v40 offset:1280
	ds_load_u16_d16 v71, v40 offset:1056
	ds_load_u16_d16_hi v55, v40 offset:1216
	ds_load_u16_d16 v47, v40 offset:1120
	ds_load_u16_d16 v65, v40 offset:1536
	ds_load_u16_d16 v72, v40 offset:1312
	ds_load_u16_d16_hi v56, v40 offset:1472
	ds_load_u16_d16 v48, v40 offset:1376
	ds_load_u16_d16 v66, v40 offset:1792
	ds_load_u16_d16 v73, v40 offset:1568
	ds_load_u16_d16_hi v57, v40 offset:1728
	ds_load_u16_d16 v49, v40 offset:1632
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v43, v40 offset:224
	ds_load_u16_d16_hi v61, v40 offset:640
	ds_load_u16_d16_hi v60, v40 offset:384
	ds_load_u16_d16_hi v68, v40 offset:416
	ds_load_u16_d16_hi v52, v40 offset:448
	s_waitcnt lgkmcnt(26)
	ds_load_u16_d16_hi v62, v40 offset:896
	s_waitcnt lgkmcnt(25)
	ds_load_u16_d16_hi v69, v40 offset:672
	ds_load_u16_d16_hi v45, v40 offset:736
	s_waitcnt lgkmcnt(26)
	ds_load_u16_d16_hi v63, v40 offset:1152
	s_waitcnt lgkmcnt(26)
	ds_load_u16_d16_hi v70, v40 offset:928
	v_ashrrev_i32_e32 v84, 31, v83
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v46, v40 offset:992
	ds_load_u16_d16_hi v58, v40 offset:1984
	ds_load_u16_d16 v50, v40 offset:1888
	s_waitcnt lgkmcnt(24)
	ds_load_u16_d16_hi v64, v40 offset:1408
	s_waitcnt lgkmcnt(24)
	ds_load_u16_d16_hi v71, v40 offset:1184
	s_waitcnt lgkmcnt(23)
	ds_load_u16_d16_hi v47, v40 offset:1248
	s_waitcnt lgkmcnt(23)
	ds_load_u16_d16_hi v65, v40 offset:1664
	s_waitcnt lgkmcnt(23)
	ds_load_u16_d16_hi v72, v40 offset:1440
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v48, v40 offset:1504
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v66, v40 offset:1920
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v73, v40 offset:1696
	s_waitcnt lgkmcnt(21)
	ds_load_u16_d16_hi v49, v40 offset:1760
	ds_load_u16_d16_hi v74, v40 offset:1952
	v_lshlrev_b64 v[83:84], 2, v[83:84]
	s_waitcnt lgkmcnt(11)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[75:82], v[51:58], v[17:24]
	s_waitcnt lgkmcnt(10)
	ds_load_u16_d16_hi v50, v40 offset:2016
	v_ashrrev_i32_e32 v40, 31, v39
	v_add_co_u32 v51, vcc_lo, s2, v83
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_add_co_ci_u32_e64 v52, null, s3, v84, vcc_lo
	v_lshlrev_b64 v[39:40], 2, v[39:40]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[75:82], v[59:66], v[1:8]
	s_waitcnt lgkmcnt(1)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[75:82], v[67:74], v[9:16]
	s_clause 0x3
	global_store_b128 v[51:52], v[5:8], off offset:16
	global_store_b128 v[51:52], v[1:4], off
	global_store_b128 v[51:52], v[13:16], off offset:48
	global_store_b128 v[51:52], v[9:12], off offset:32
	v_add_co_u32 v1, vcc_lo, s4, v39
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v2, null, s5, v40, vcc_lo
	v_mov_b32_e32 v3, 1
	s_mov_b32 s4, exec_lo
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[75:82], v[43:50], v[25:32]
	s_clause 0x3
	global_store_b128 v[51:52], v[21:24], off offset:80
	global_store_b128 v[51:52], v[17:20], off offset:64
	global_store_b128 v[51:52], v[29:32], off offset:112
	global_store_b128 v[51:52], v[25:28], off offset:96
	s_waitcnt_vscnt null, 0x0
	global_atomic_add_u32 v3, v[1:2], v3, off glc
	s_waitcnt vmcnt(0)
	buffer_gl1_inv
	buffer_gl0_inv
	v_cmpx_eq_u32_e32 3, v3
	s_cbranch_execz .LBB0_4
	v_or_b32_e32 v3, v41, v38
	v_lshlrev_b32_e32 v35, 13, v35
	v_lshlrev_b32_e32 v36, 14, v36
	s_load_b64 s[0:1], s[0:1], 0x30
	v_lshlrev_b32_e32 v34, 8, v34
	v_ashrrev_i32_e32 v4, 31, v3
	v_lshlrev_b32_e32 v33, 7, v33
	v_add_nc_u32_e32 v35, v35, v36
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_lshlrev_b64 v[3:4], 2, v[3:4]
	v_add_nc_u32_e32 v34, v35, v34
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v31, vcc_lo, s2, v3
	v_add_co_ci_u32_e64 v32, null, s3, v4, vcc_lo
	s_mov_b32 s3, 0x21027000
	v_add_co_u32 v70, vcc_lo, v31, 0x2000
	s_clause 0x7
	global_load_b128 v[3:6], v[31:32], off
	global_load_b128 v[7:10], v[31:32], off offset:16
	global_load_b128 v[11:14], v[31:32], off offset:32
	global_load_b128 v[15:18], v[31:32], off offset:48
	global_load_b128 v[19:22], v[31:32], off offset:64
	global_load_b128 v[23:26], v[31:32], off offset:80
	global_load_b128 v[27:30], v[31:32], off offset:96
	global_load_b128 v[38:41], v[31:32], off offset:112
	v_add_co_ci_u32_e64 v71, null, 0, v32, vcc_lo
	v_add_co_u32 v58, vcc_lo, 0x1000, v31
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v59, null, 0, v32, vcc_lo
	v_add_co_u32 v82, vcc_lo, 0x1040, v31
	v_add_co_ci_u32_e64 v83, null, 0, v32, vcc_lo
	v_add_co_u32 v98, vcc_lo, 0x2000, v31
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v99, null, 0, v32, vcc_lo
	v_add_co_u32 v102, vcc_lo, 0x2040, v31
	s_clause 0x4
	global_load_b128 v[42:45], v[70:71], off offset:-4096
	global_load_b128 v[46:49], v[58:59], off offset:16
	global_load_b128 v[50:53], v[58:59], off offset:32
	global_load_b128 v[54:57], v[58:59], off offset:48
	global_load_b128 v[58:61], v[58:59], off offset:64
	v_add_co_ci_u32_e64 v103, null, 0, v32, vcc_lo
	v_add_co_u32 v106, vcc_lo, 0x3000, v31
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v107, null, 0, v32, vcc_lo
	v_add_co_u32 v31, vcc_lo, 0x3040, v31
	v_add_co_ci_u32_e64 v32, null, 0, v32, vcc_lo
	s_clause 0xa
	global_load_b128 v[62:65], v[82:83], off offset:32
	global_load_b128 v[66:69], v[82:83], off offset:16
	global_load_b128 v[70:73], v[70:71], off
	global_load_b128 v[74:77], v[98:99], off offset:48
	global_load_b128 v[78:81], v[98:99], off offset:32
	global_load_b128 v[82:85], v[82:83], off offset:48
	global_load_b128 v[86:89], v[98:99], off offset:16
	global_load_b128 v[90:93], v[102:103], off offset:48
	global_load_b128 v[94:97], v[102:103], off offset:32
	global_load_b128 v[98:101], v[98:99], off offset:64
	global_load_b128 v[102:105], v[102:103], off offset:16
	s_mov_b32 s2, -1
	s_waitcnt lgkmcnt(0)
	s_and_b32 s1, s1, 0xffff
	s_waitcnt vmcnt(23)
	v_dual_add_f32 v108, 0, v3 :: v_dual_add_f32 v109, 0, v4
	v_dual_add_f32 v110, 0, v5 :: v_dual_add_f32 v111, 0, v6
	s_waitcnt vmcnt(22)
	v_dual_add_f32 v112, 0, v7 :: v_dual_add_f32 v113, 0, v8
	v_dual_add_f32 v114, 0, v9 :: v_dual_add_f32 v115, 0, v10
	s_clause 0x1
	global_load_b128 v[3:6], v[106:107], off
	global_load_b128 v[7:10], v[106:107], off offset:16
	s_waitcnt vmcnt(21)
	v_dual_add_f32 v124, 0, v19 :: v_dual_add_f32 v125, 0, v20
	v_dual_add_f32 v126, 0, v21 :: v_dual_add_f32 v127, 0, v22
	s_waitcnt vmcnt(20)
	v_dual_add_f32 v128, 0, v23 :: v_dual_add_f32 v129, 0, v24
	v_dual_add_f32 v130, 0, v25 :: v_dual_add_f32 v131, 0, v26
	s_waitcnt vmcnt(19)
	v_dual_add_f32 v132, 0, v27 :: v_dual_add_f32 v133, 0, v28
	v_dual_add_f32 v134, 0, v29 :: v_dual_add_f32 v135, 0, v30
	s_waitcnt vmcnt(18)
	v_dual_add_f32 v136, 0, v38 :: v_dual_add_f32 v137, 0, v39
	v_dual_add_f32 v138, 0, v40 :: v_dual_add_f32 v139, 0, v41
	s_clause 0x3
	global_load_b128 v[19:22], v[106:107], off offset:64
	global_load_b128 v[23:26], v[31:32], off offset:16
	global_load_b128 v[27:30], v[31:32], off offset:32
	global_load_b128 v[38:41], v[31:32], off offset:48
	v_dual_add_f32 v116, 0, v11 :: v_dual_add_f32 v117, 0, v12
	v_dual_add_f32 v118, 0, v13 :: v_dual_add_f32 v119, 0, v14
	v_dual_add_f32 v120, 0, v15 :: v_dual_add_f32 v121, 0, v16
	v_dual_add_f32 v122, 0, v17 :: v_dual_add_f32 v123, 0, v18
	s_clause 0x1
	global_load_b128 v[11:14], v[106:107], off offset:32
	global_load_b128 v[15:18], v[106:107], off offset:48
	s_waitcnt vmcnt(23)
	v_dual_add_f32 v42, v108, v42 :: v_dual_add_f32 v43, v109, v43
	s_waitcnt vmcnt(17)
	v_dual_add_f32 v31, v128, v66 :: v_dual_add_f32 v32, v129, v67
	v_dual_add_f32 v66, v130, v68 :: v_dual_add_f32 v67, v131, v69
	s_waitcnt vmcnt(13)
	v_dual_add_f32 v68, v136, v82 :: v_dual_add_f32 v69, v137, v83
	v_dual_add_f32 v82, v138, v84 :: v_dual_add_f32 v83, v139, v85
	v_dual_add_f32 v42, v42, v70 :: v_dual_add_f32 v43, v43, v71
	v_dual_add_f32 v44, v110, v44 :: v_dual_add_f32 v45, v111, v45
	s_waitcnt vmcnt(8)
	v_dual_add_f32 v31, v31, v102 :: v_dual_add_f32 v32, v32, v103
	v_dual_add_f32 v68, v68, v90 :: v_dual_add_f32 v69, v69, v91
	v_dual_add_f32 v70, v82, v92 :: v_dual_add_f32 v71, v83, v93
	v_dual_add_f32 v44, v44, v72 :: v_dual_add_f32 v45, v45, v73
	v_dual_add_f32 v46, v112, v46 :: v_dual_add_f32 v47, v113, v47
	v_dual_add_f32 v48, v114, v48 :: v_dual_add_f32 v49, v115, v49
	v_dual_add_f32 v50, v116, v50 :: v_dual_add_f32 v51, v117, v51
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_dual_add_f32 v46, v46, v86 :: v_dual_add_f32 v47, v47, v87
	v_dual_add_f32 v48, v48, v88 :: v_dual_add_f32 v49, v49, v89
	v_dual_add_f32 v52, v118, v52 :: v_dual_add_f32 v53, v119, v53
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_dual_add_f32 v50, v50, v78 :: v_dual_add_f32 v51, v51, v79
	v_dual_add_f32 v54, v120, v54 :: v_dual_add_f32 v55, v121, v55
	v_dual_add_f32 v52, v52, v80 :: v_dual_add_f32 v53, v53, v81
	v_dual_add_f32 v56, v122, v56 :: v_dual_add_f32 v57, v123, v57
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_dual_add_f32 v54, v54, v74 :: v_dual_add_f32 v55, v55, v75
	v_dual_add_f32 v58, v124, v58 :: v_dual_add_f32 v59, v125, v59
	v_dual_add_f32 v56, v56, v76 :: v_dual_add_f32 v57, v57, v77
	v_dual_add_f32 v60, v126, v60 :: v_dual_add_f32 v61, v127, v61
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_dual_add_f32 v58, v58, v98 :: v_dual_add_f32 v59, v59, v99
	v_dual_add_f32 v62, v132, v62 :: v_dual_add_f32 v63, v133, v63
	v_dual_add_f32 v60, v60, v100 :: v_dual_add_f32 v61, v61, v101
	v_dual_add_f32 v64, v134, v64 :: v_dual_add_f32 v65, v135, v65
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_dual_add_f32 v62, v62, v94 :: v_dual_add_f32 v63, v63, v95
	v_dual_add_f32 v66, v66, v104 :: v_dual_add_f32 v67, v67, v105
	v_dual_add_f32 v64, v64, v96 :: v_dual_add_f32 v65, v65, v97
	s_waitcnt vmcnt(7)
	v_dual_add_f32 v3, v42, v3 :: v_dual_add_f32 v4, v43, v4
	v_dual_add_f32 v5, v44, v5 :: v_dual_add_f32 v6, v45, v6
	s_waitcnt vmcnt(6)
	v_dual_add_f32 v7, v46, v7 :: v_dual_add_f32 v8, v47, v8
	s_delay_alu instid0(VALU_DEP_3)
	v_bfe_u32 v42, v4, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_or_b32_e32 v43, 0x400000, v4
	v_bfe_u32 v44, v5, 16, 1
	v_or_b32_e32 v45, 0x400000, v5
	v_add3_u32 v42, v42, v4, 0x7fff
	v_bfe_u32 v46, v6, 16, 1
	v_dual_add_f32 v9, v48, v9 :: v_dual_add_f32 v10, v49, v10
	v_add3_u32 v44, v44, v5, 0x7fff
	v_or_b32_e32 v47, 0x400000, v6
	v_bfe_u32 v48, v7, 16, 1
	v_add3_u32 v46, v46, v6, 0x7fff
	s_waitcnt vmcnt(4)
	v_dual_add_f32 v23, v31, v23 :: v_dual_add_f32 v24, v32, v24
	s_waitcnt vmcnt(2)
	v_dual_add_f32 v31, v68, v38 :: v_dual_add_f32 v32, v69, v39
	v_dual_add_f32 v38, v70, v40 :: v_dual_add_f32 v39, v71, v41
	v_bfe_u32 v40, v3, 16, 1
	v_or_b32_e32 v41, 0x400000, v3
	v_or_b32_e32 v49, 0x400000, v7
	s_waitcnt vmcnt(1)
	v_dual_add_f32 v11, v50, v11 :: v_dual_add_f32 v12, v51, v12
	v_add3_u32 v40, v40, v3, 0x7fff
	v_bfe_u32 v50, v8, 16, 1
	v_add3_u32 v48, v48, v7, 0x7fff
	v_dual_add_f32 v13, v52, v13 :: v_dual_add_f32 v14, v53, v14
	s_delay_alu instid0(VALU_DEP_4)
	v_cndmask_b32_e32 v3, v40, v41, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_or_b32_e32 v51, 0x400000, v8
	v_bfe_u32 v52, v9, 16, 1
	v_add3_u32 v50, v50, v8, 0x7fff
	s_waitcnt vmcnt(0)
	v_dual_add_f32 v15, v54, v15 :: v_dual_add_f32 v16, v55, v16
	v_cndmask_b32_e32 v4, v42, v43, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_or_b32_e32 v53, 0x400000, v9
	v_bfe_u32 v54, v10, 16, 1
	v_add3_u32 v52, v52, v9, 0x7fff
	v_dual_add_f32 v17, v56, v17 :: v_dual_add_f32 v18, v57, v18
	v_cndmask_b32_e32 v5, v44, v45, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_or_b32_e32 v55, 0x400000, v10
	v_bfe_u32 v56, v11, 16, 1
	v_add3_u32 v54, v54, v10, 0x7fff
	v_dual_add_f32 v19, v58, v19 :: v_dual_add_f32 v20, v59, v20
	v_cndmask_b32_e32 v6, v46, v47, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_or_b32_e32 v57, 0x400000, v11
	v_bfe_u32 v58, v12, 16, 1
	v_add3_u32 v56, v56, v11, 0x7fff
	v_dual_add_f32 v21, v60, v21 :: v_dual_add_f32 v22, v61, v22
	v_cndmask_b32_e32 v7, v48, v49, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_or_b32_e32 v59, 0x400000, v12
	v_bfe_u32 v60, v13, 16, 1
	v_add3_u32 v58, v58, v12, 0x7fff
	v_dual_add_f32 v27, v62, v27 :: v_dual_add_f32 v28, v63, v28
	v_cndmask_b32_e32 v8, v50, v51, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_or_b32_e32 v61, 0x400000, v13
	v_bfe_u32 v62, v14, 16, 1
	v_add3_u32 v60, v60, v13, 0x7fff
	v_dual_add_f32 v29, v64, v29 :: v_dual_add_f32 v30, v65, v30
	v_cndmask_b32_e32 v9, v52, v53, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_or_b32_e32 v63, 0x400000, v14
	v_bfe_u32 v64, v15, 16, 1
	v_add3_u32 v62, v62, v14, 0x7fff
	v_dual_add_f32 v25, v66, v25 :: v_dual_add_f32 v26, v67, v26
	v_cndmask_b32_e32 v10, v54, v55, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_or_b32_e32 v65, 0x400000, v15
	v_bfe_u32 v66, v16, 16, 1
	v_add3_u32 v64, v64, v15, 0x7fff
	v_or_b32_e32 v67, 0x400000, v16
	v_cndmask_b32_e32 v11, v56, v57, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_bfe_u32 v68, v17, 16, 1
	v_add3_u32 v66, v66, v16, 0x7fff
	v_or_b32_e32 v69, 0x400000, v17
	v_bfe_u32 v70, v18, 16, 1
	v_cndmask_b32_e32 v12, v58, v59, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_add3_u32 v68, v68, v17, 0x7fff
	v_or_b32_e32 v71, 0x400000, v18
	v_bfe_u32 v72, v19, 16, 1
	v_add3_u32 v70, v70, v18, 0x7fff
	v_cndmask_b32_e32 v13, v60, v61, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_or_b32_e32 v73, 0x400000, v19
	v_bfe_u32 v74, v20, 16, 1
	v_add3_u32 v72, v72, v19, 0x7fff
	v_or_b32_e32 v75, 0x400000, v20
	v_cndmask_b32_e32 v14, v62, v63, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_bfe_u32 v76, v21, 16, 1
	v_add3_u32 v74, v74, v20, 0x7fff
	v_or_b32_e32 v77, 0x400000, v21
	v_bfe_u32 v78, v22, 16, 1
	v_cndmask_b32_e32 v15, v64, v65, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	v_add3_u32 v76, v76, v21, 0x7fff
	v_or_b32_e32 v79, 0x400000, v22
	v_bfe_u32 v80, v23, 16, 1
	v_add3_u32 v78, v78, v22, 0x7fff
	v_cndmask_b32_e32 v16, v66, v67, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v17, v17
	v_or_b32_e32 v81, 0x400000, v23
	v_bfe_u32 v82, v24, 16, 1
	v_add3_u32 v80, v80, v23, 0x7fff
	v_or_b32_e32 v83, 0x400000, v24
	v_cndmask_b32_e32 v17, v68, v69, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v18, v18
	v_bfe_u32 v84, v25, 16, 1
	v_add3_u32 v82, v82, v24, 0x7fff
	v_or_b32_e32 v85, 0x400000, v25
	v_bfe_u32 v86, v26, 16, 1
	v_cndmask_b32_e32 v18, v70, v71, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v19, v19
	v_add3_u32 v84, v84, v25, 0x7fff
	v_or_b32_e32 v87, 0x400000, v26
	v_bfe_u32 v88, v27, 16, 1
	v_add3_u32 v86, v86, v26, 0x7fff
	v_cndmask_b32_e32 v19, v72, v73, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v20, v20
	v_or_b32_e32 v89, 0x400000, v27
	v_bfe_u32 v90, v28, 16, 1
	v_add3_u32 v88, v88, v27, 0x7fff
	v_or_b32_e32 v91, 0x400000, v28
	v_cndmask_b32_e32 v20, v74, v75, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v21, v21
	v_bfe_u32 v92, v29, 16, 1
	v_add3_u32 v90, v90, v28, 0x7fff
	v_or_b32_e32 v93, 0x400000, v29
	v_bfe_u32 v94, v30, 16, 1
	v_cndmask_b32_e32 v21, v76, v77, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v22, v22
	v_add3_u32 v92, v92, v29, 0x7fff
	v_or_b32_e32 v95, 0x400000, v30
	v_bfe_u32 v96, v31, 16, 1
	v_add3_u32 v94, v94, v30, 0x7fff
	v_cndmask_b32_e32 v22, v78, v79, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v23, v23
	v_or_b32_e32 v97, 0x400000, v31
	v_bfe_u32 v98, v32, 16, 1
	v_add3_u32 v96, v96, v31, 0x7fff
	v_or_b32_e32 v99, 0x400000, v32
	v_cndmask_b32_e32 v23, v80, v81, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v24, v24
	v_bfe_u32 v100, v38, 16, 1
	v_add3_u32 v98, v98, v32, 0x7fff
	v_or_b32_e32 v42, 0x400000, v38
	v_bfe_u32 v41, v39, 16, 1
	v_cndmask_b32_e32 v24, v82, v83, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v25, v25
	v_add3_u32 v40, v100, v38, 0x7fff
	v_lshrrev_b32_e32 v3, 16, v3
	v_add3_u32 v36, v41, v39, 0x7fff
	v_lshrrev_b32_e32 v4, 16, v4
	v_cndmask_b32_e32 v25, v84, v85, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v26, v26
	v_lshrrev_b32_e32 v5, 16, v5
	v_lshrrev_b32_e32 v6, 16, v6
	v_lshrrev_b32_e32 v7, 16, v7
	v_lshrrev_b32_e32 v8, 16, v8
	v_cndmask_b32_e32 v26, v86, v87, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v27, v27
	v_lshrrev_b32_e32 v9, 16, v9
	v_lshrrev_b32_e32 v10, 16, v10
	v_lshrrev_b32_e32 v11, 16, v11
	v_lshrrev_b32_e32 v12, 16, v12
	v_cndmask_b32_e32 v27, v88, v89, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v28, v28
	v_lshrrev_b32_e32 v13, 16, v13
	v_lshrrev_b32_e32 v14, 16, v14
	v_lshrrev_b32_e32 v15, 16, v15
	v_lshrrev_b32_e32 v16, 16, v16
	v_cndmask_b32_e32 v28, v90, v91, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v29, v29
	v_lshrrev_b32_e32 v17, 16, v17
	v_lshrrev_b32_e32 v18, 16, v18
	v_lshrrev_b32_e32 v19, 16, v19
	v_lshrrev_b32_e32 v20, 16, v20
	v_cndmask_b32_e32 v29, v92, v93, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v30, v30
	v_lshrrev_b32_e32 v21, 16, v21
	v_lshrrev_b32_e32 v22, 16, v22
	v_lshrrev_b32_e32 v23, 16, v23
	v_lshrrev_b32_e32 v24, 16, v24
	v_cndmask_b32_e32 v30, v94, v95, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v31, v31
	v_lshrrev_b32_e32 v25, 16, v25
	v_lshrrev_b32_e32 v26, 16, v26
	v_lshrrev_b32_e32 v27, 16, v27
	v_lshrrev_b32_e32 v28, 16, v28
	v_cndmask_b32_e32 v31, v96, v97, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v32, v32
	v_lshrrev_b32_e32 v29, 16, v29
	v_lshrrev_b32_e32 v30, 16, v30
	v_cndmask_b32_e32 v32, v98, v99, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v38, v38
	v_lshlrev_b32_e32 v0, 4, v0
	v_lshrrev_b32_e32 v31, 16, v31
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_4)
	v_lshrrev_b32_e32 v32, 16, v32
	v_cndmask_b32_e32 v35, v40, v42, vcc_lo
	v_and_or_b32 v0, 0x100, v0, v37
	v_or_b32_e32 v37, 0x400000, v39
	v_cmp_u_f32_e32 vcc_lo, v39, v39
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_lshlrev_b32_e32 v0, 1, v0
	v_cndmask_b32_e32 v36, v36, v37, vcc_lo
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_add3_u32 v0, v34, v33, v0
	v_lshrrev_b32_e32 v33, 16, v35
	v_lshrrev_b32_e32 v34, 16, v36
	s_delay_alu instid0(VALU_DEP_3)
	v_add_nc_u32_e32 v35, 0x1000, v0
	s_clause 0x1b
	buffer_store_b16 v3, v0, s[0:3], 0 offen
	buffer_store_b16 v4, v0, s[0:3], 0 offen offset:1024
	buffer_store_b16 v5, v0, s[0:3], 0 offen offset:2048
	buffer_store_b16 v6, v0, s[0:3], 0 offen offset:3072
	buffer_store_b16 v7, v35, s[0:3], 0 offen
	buffer_store_b16 v8, v35, s[0:3], 0 offen offset:1024
	buffer_store_b16 v9, v35, s[0:3], 0 offen offset:2048
	buffer_store_b16 v10, v35, s[0:3], 0 offen offset:3072
	buffer_store_b16 v11, v0, s[0:3], 0 offen offset:32
	buffer_store_b16 v12, v0, s[0:3], 0 offen offset:1056
	buffer_store_b16 v13, v0, s[0:3], 0 offen offset:2080
	buffer_store_b16 v14, v0, s[0:3], 0 offen offset:3104
	buffer_store_b16 v15, v35, s[0:3], 0 offen offset:32
	buffer_store_b16 v16, v35, s[0:3], 0 offen offset:1056
	buffer_store_b16 v17, v35, s[0:3], 0 offen offset:2080
	buffer_store_b16 v18, v35, s[0:3], 0 offen offset:3104
	buffer_store_b16 v19, v0, s[0:3], 0 offen offset:64
	buffer_store_b16 v20, v0, s[0:3], 0 offen offset:1088
	buffer_store_b16 v21, v0, s[0:3], 0 offen offset:2112
	buffer_store_b16 v22, v0, s[0:3], 0 offen offset:3136
	buffer_store_b16 v23, v35, s[0:3], 0 offen offset:64
	buffer_store_b16 v24, v35, s[0:3], 0 offen offset:1088
	buffer_store_b16 v25, v35, s[0:3], 0 offen offset:2112
	buffer_store_b16 v26, v35, s[0:3], 0 offen offset:3136
	buffer_store_b16 v27, v0, s[0:3], 0 offen offset:96
	buffer_store_b16 v28, v0, s[0:3], 0 offen offset:1120
	buffer_store_b16 v29, v0, s[0:3], 0 offen offset:2144
	buffer_store_b16 v30, v0, s[0:3], 0 offen offset:3168
	v_mov_b32_e32 v0, 0
	s_clause 0x3
	buffer_store_b16 v31, v35, s[0:3], 0 offen offset:96
	buffer_store_b16 v32, v35, s[0:3], 0 offen offset:1120
	buffer_store_b16 v33, v35, s[0:3], 0 offen offset:2144
	buffer_store_b16 v34, v35, s[0:3], 0 offen offset:3168
	s_waitcnt_vscnt null, 0x0
	global_store_b32 v[1:2], v0, off
.LBB0_4:
	s_nop 0
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
	s_endpgm
.Lfunc_end0:
	.size	_matmul_bf16_0, .Lfunc_end0-_matmul_bf16_0
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _matmul_bf16_0
		.amdhsa_group_segment_fixed_size 11264
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
		.amdhsa_next_free_vgpr 140
		.amdhsa_next_free_sgpr 12
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

	.set .L_matmul_bf16_0.num_vgpr, 140
	.set .L_matmul_bf16_0.num_agpr, 0
	.set .L_matmul_bf16_0.numbered_sgpr, 12
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
    .group_segment_fixed_size: 11264
    .kernarg_segment_align: 8
    .kernarg_segment_size: 100
    .max_flat_workgroup_size: 128
    .name:           _matmul_bf16_0
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 128
      - 1
      - 1
    .sgpr_count:     14
    .sgpr_spill_count: 0
    .symbol:         _matmul_bf16_0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     140
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
