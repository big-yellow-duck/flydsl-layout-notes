	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	_matmul_bf16_0
	.p2align	8
	.type	_matmul_bf16_0,@function
_matmul_bf16_0:
	v_lshrrev_b32_e32 v1, 5, v0
	s_lshl_b32 s3, s2, 2
	s_mov_b32 s16, 0
	s_mov_b32 s6, -1
	s_mov_b32 s17, s16
	v_or_b32_e32 v1, s3, v1
	s_bfe_i32 s3, s2, 0x1001d
	s_bfe_u32 s2, s2, 0x1001d
	s_lshr_b32 s4, s3, 30
	s_mov_b32 s18, s16
	s_mov_b32 s19, s16
	s_mov_b32 s20, s16
	s_mov_b32 s21, s16
	s_mov_b32 s22, s16
	s_mov_b32 s23, s16
	v_add_nc_u32_e32 v2, s2, v1
	s_lshr_b32 s2, s3, 27
	v_add_nc_u32_e32 v3, s4, v1
	v_add_nc_u32_e32 v5, s2, v1
	s_lshr_b32 s5, s3, 29
	v_ashrrev_i32_e32 v6, 1, v2
	v_lshrrev_b32_e32 v7, 31, v2
	v_ashrrev_i32_e32 v8, 2, v3
	v_lshrrev_b32_e32 v3, 31, v3
	v_add_nc_u32_e32 v4, s5, v1
	v_ashrrev_i32_e32 v9, 5, v5
	v_lshrrev_b32_e32 v5, 31, v5
	v_add_nc_u32_e32 v7, v6, v7
	v_add_nc_u32_e32 v3, v8, v3
	v_ashrrev_i32_e32 v4, 3, v4
	v_and_b32_e32 v2, -2, v2
	v_add_nc_u32_e32 v5, v9, v5
	v_and_b32_e32 v7, -2, v7
	v_and_b32_e32 v3, -2, v3
	v_lshrrev_b32_e32 v10, 30, v4
	v_sub_nc_u32_e32 v97, v1, v2
	v_and_b32_e32 v5, -2, v5
	v_sub_nc_u32_e32 v98, v6, v7
	v_sub_nc_u32_e32 v100, v8, v3
	v_add_nc_u32_e32 v1, v4, v10
	v_lshlrev_b32_e32 v7, 3, v0
	v_sub_nc_u32_e32 v99, v9, v5
	s_clause 0x1
	s_load_b64 s[4:5], s[0:1], 0x0
	s_load_b64 s[8:9], s[0:1], 0x18
	v_lshl_add_u32 v101, v100, 1, v98
	v_and_b32_e32 v2, -4, v1
	v_bfe_u32 v3, v0, 1, 4
	v_lshl_add_u32 v102, v99, 1, v97
	v_bfe_u32 v6, v0, 3, 2
	v_mul_lo_u32 v1, 0x1800, v101
	v_sub_nc_u32_e32 v103, v4, v2
	v_and_b32_e32 v5, 56, v7
	v_lshlrev_b32_e32 v2, 6, v102
	v_and_b32_e32 v4, 8, v7
	v_mul_u32_u24_e32 v7, 0x180, v3
	s_mov_b32 s7, 0x21027000
	v_lshl_or_b32 v8, v6, 8, v5
	v_mad_u64_u32 v[9:10], null, 0x6000, v103, v[2:3]
	v_mad_u64_u32 v[10:11], null, 0x60, v103, v[1:2]
	v_or_b32_e32 v7, v7, v4
	s_mov_b32 s10, s6
	s_mov_b32 s11, s7
	s_waitcnt lgkmcnt(0)
	s_and_b32 s5, s5, 0xffff
	s_and_b32 s9, s9, 0xffff
	v_mul_lo_u32 v30, 0x600, v98
	v_add_lshl_u32 v9, v9, v8, 1
	v_add_lshl_u32 v10, v10, v7, 1
	v_mul_lo_u32 v111, v103, 6
	v_add_lshl_u32 v110, v8, v2, 1
	v_add_lshl_u32 v109, v7, v1, 1
	v_add_nc_u32_e32 v26, 0x1000, v9
	buffer_load_b128 v[10:13], v10, s[4:7], 0 offen
	s_clause 0x3
	buffer_load_b128 v[14:17], v9, s[8:11], 0 offen slc
	buffer_load_b128 v[18:21], v9, s[8:11], 0 offen offset:2048 slc
	buffer_load_b128 v[22:25], v26, s[8:11], 0 offen slc
	buffer_load_b128 v[26:29], v26, s[8:11], 0 offen offset:2048 slc
	v_mul_lo_u32 v9, 0x300, v97
	v_lshlrev_b32_e32 v6, 7, v6
	v_or_b32_e32 v2, 1, v111
	v_lshlrev_b32_e32 v5, 1, v5
	v_and_b32_e32 v104, 15, v0
	s_clause 0x1
	s_load_b64 s[2:3], s[0:1], 0x48
	s_load_b64 s[12:13], s[0:1], 0x58
	v_lshl_add_u32 v31, v2, 13, v110
	v_add3_u32 v9, v30, v9, 0x2000
	v_lshlrev_b32_e32 v30, 11, v97
	v_lshl_add_u32 v1, v2, 5, v109
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_add_nc_u32_e32 v32, 0x1000, v31
	v_lshl_or_b32 v4, v4, 1, v9
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_lshl_add_u32 v30, v98, 12, v30
	v_mad_u32_u24 v107, v104, 48, v9
	v_mad_u32_u24 v108, v3, 48, v4
	s_delay_alu instid0(VALU_DEP_3)
	v_or3_b32 v106, v30, v5, v6
	v_lshl_or_b32 v105, v104, 1, v30
	s_waitcnt vmcnt(4)
	ds_store_b128 v108, v[10:13]
	s_waitcnt vmcnt(3)
	ds_store_b128 v106, v[14:17]
	s_waitcnt vmcnt(2)
	ds_store_b128 v106, v[18:21] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v106, v[22:25] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v106, v[26:29] offset:1536
	buffer_load_b128 v[1:4], v1, s[4:7], 0 offen
	s_clause 0x3
	buffer_load_b128 v[5:8], v31, s[8:11], 0 offen slc
	buffer_load_b128 v[17:20], v31, s[8:11], 0 offen offset:2048 slc
	buffer_load_b128 v[21:24], v32, s[8:11], 0 offen slc
	buffer_load_b128 v[25:28], v32, s[8:11], 0 offen offset:2048 slc
	ds_load_u16_d16 v50, v105 offset:352
	v_add_nc_u32_e32 v10, 2, v111
	s_delay_alu instid0(VALU_DEP_1)
	v_lshl_add_u32 v29, v10, 13, v110
	v_lshl_add_u32 v30, v10, 5, v109
	ds_load_u16_d16 v51, v105 offset:608
	ds_load_u16_d16 v11, v105 offset:512
	ds_load_u16_d16 v58, v105 offset:288
	ds_load_b128 v[69:72], v107 offset:16
	ds_load_u16_d16 v115, v105 offset:832
	ds_load_u16_d16 v12, v105 offset:768
	ds_load_u16_d16 v59, v105 offset:544
	ds_load_u16_d16 v114, v105 offset:576
	ds_load_u16_d16 v10, v105 offset:256
	ds_load_u16_d16 v113, v105 offset:320
	ds_load_u16_d16 v9, v105
	ds_load_u16_d16 v57, v105 offset:32
	ds_load_u16_d16 v112, v105 offset:64
	s_waitcnt lgkmcnt(0)
	ds_load_u16_d16_hi v50, v105 offset:480
	ds_load_u16_d16 v49, v105 offset:96
	ds_load_u16_d16 v116, v105 offset:1088
	ds_load_u16_d16 v13, v105 offset:1024
	ds_load_u16_d16 v60, v105 offset:800
	ds_load_u16_d16 v52, v105 offset:864
	ds_load_u16_d16 v117, v105 offset:1344
	ds_load_u16_d16 v14, v105 offset:1280
	ds_load_u16_d16 v61, v105 offset:1056
	ds_load_u16_d16 v53, v105 offset:1120
	ds_load_u16_d16 v118, v105 offset:1600
	ds_load_u16_d16 v15, v105 offset:1536
	ds_load_u16_d16 v62, v105 offset:1312
	ds_load_u16_d16 v54, v105 offset:1376
	ds_load_u16_d16 v119, v105 offset:1856
	ds_load_u16_d16 v16, v105 offset:1792
	ds_load_u16_d16 v63, v105 offset:1568
	ds_load_u16_d16 v55, v105 offset:1632
	ds_load_u16_d16 v64, v105 offset:1824
	ds_load_u16_d16 v56, v105 offset:1888
	ds_load_u16_d16_hi v9, v105 offset:128
	ds_load_u16_d16_hi v57, v105 offset:160
	ds_load_u16_d16_hi v112, v105 offset:192
	s_waitcnt lgkmcnt(21)
	ds_load_u16_d16_hi v49, v105 offset:224
	ds_load_u16_d16_hi v114, v105 offset:704
	ds_load_u16_d16_hi v11, v105 offset:640
	ds_load_u16_d16_hi v10, v105 offset:384
	ds_load_u16_d16_hi v58, v105 offset:416
	ds_load_u16_d16_hi v113, v105 offset:448
	ds_load_u16_d16_hi v115, v105 offset:960
	ds_load_u16_d16_hi v12, v105 offset:896
	ds_load_u16_d16_hi v59, v105 offset:672
	ds_load_u16_d16_hi v51, v105 offset:736
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v116, v105 offset:1216
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v13, v105 offset:1152
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v60, v105 offset:928
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v52, v105 offset:992
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v117, v105 offset:1472
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v14, v105 offset:1408
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v61, v105 offset:1184
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v53, v105 offset:1248
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v118, v105 offset:1728
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v15, v105 offset:1664
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v62, v105 offset:1440
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v54, v105 offset:1504
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v119, v105 offset:1984
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v16, v105 offset:1920
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v63, v105 offset:1696
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v55, v105 offset:1760
	ds_load_b128 v[65:68], v107
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v64, v105 offset:1952
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v56, v105 offset:2016
	v_add_nc_u32_e32 v31, 0x1000, v29
	s_waitcnt vmcnt(4)
	ds_store_b128 v108, v[1:4]
	s_waitcnt vmcnt(3)
	ds_store_b128 v106, v[5:8]
	s_waitcnt vmcnt(2)
	ds_store_b128 v106, v[17:20] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v106, v[21:24] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v106, v[25:28] offset:1536
	buffer_load_b128 v[1:4], v30, s[4:7], 0 offen
	s_clause 0x3
	buffer_load_b128 v[5:8], v29, s[8:11], 0 offen slc
	buffer_load_b128 v[17:20], v29, s[8:11], 0 offen offset:2048 slc
	buffer_load_b128 v[21:24], v31, s[8:11], 0 offen slc
	buffer_load_b128 v[25:28], v31, s[8:11], 0 offen offset:2048 slc
	ds_load_u16_d16 v42, v105 offset:352
	ds_load_u16_d16 v43, v105 offset:608
	ds_load_u16_d16 v122, v105 offset:512
	ds_load_u16_d16 v90, v105 offset:288
	ds_load_b128 v[77:80], v107 offset:16
	ds_load_u16_d16 v87, v105 offset:1600
	ds_load_u16_d16 v88, v105 offset:1856
	ds_load_u16_d16 v84, v105 offset:832
	ds_load_u16_d16 v123, v105 offset:768
	ds_load_u16_d16 v91, v105 offset:544
	ds_load_u16_d16 v83, v105 offset:576
	ds_load_u16_d16 v120, v105
	ds_load_u16_d16 v121, v105 offset:256
	ds_load_u16_d16 v82, v105 offset:320
	ds_load_u16_d16 v89, v105 offset:32
	ds_load_u16_d16 v81, v105 offset:64
	s_waitcnt lgkmcnt(15)
	ds_load_u16_d16_hi v42, v105 offset:480
	ds_load_u16_d16 v41, v105 offset:96
	ds_load_u16_d16 v85, v105 offset:1088
	ds_load_u16_d16 v124, v105 offset:1024
	ds_load_u16_d16 v92, v105 offset:800
	ds_load_u16_d16 v44, v105 offset:864
	ds_load_u16_d16 v86, v105 offset:1344
	ds_load_u16_d16 v125, v105 offset:1280
	ds_load_u16_d16 v93, v105 offset:1056
	ds_load_u16_d16 v45, v105 offset:1120
	ds_load_u16_d16 v126, v105 offset:1536
	ds_load_u16_d16 v94, v105 offset:1312
	ds_load_u16_d16 v46, v105 offset:1376
	ds_load_u16_d16 v127, v105 offset:1792
	ds_load_u16_d16 v95, v105 offset:1568
	v_add_nc_u32_e32 v29, 3, v111
	s_waitcnt lgkmcnt(25)
	ds_load_u16_d16_hi v87, v105 offset:1728
	ds_load_u16_d16 v47, v105 offset:1632
	ds_load_u16_d16 v96, v105 offset:1824
	s_waitcnt lgkmcnt(27)
	ds_load_u16_d16_hi v88, v105 offset:1984
	ds_load_u16_d16 v48, v105 offset:1888
	s_waitcnt lgkmcnt(24)
	ds_load_u16_d16_hi v120, v105 offset:128
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v89, v105 offset:160
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v81, v105 offset:192
	s_waitcnt lgkmcnt(21)
	ds_load_u16_d16_hi v41, v105 offset:224
	ds_load_u16_d16_hi v122, v105 offset:640
	ds_load_u16_d16_hi v121, v105 offset:384
	ds_load_u16_d16_hi v83, v105 offset:704
	ds_load_u16_d16_hi v90, v105 offset:416
	ds_load_u16_d16_hi v82, v105 offset:448
	ds_load_u16_d16_hi v123, v105 offset:896
	ds_load_u16_d16_hi v84, v105 offset:960
	ds_load_u16_d16_hi v91, v105 offset:672
	ds_load_u16_d16_hi v43, v105 offset:736
	s_waitcnt lgkmcnt(29)
	ds_load_u16_d16_hi v124, v105 offset:1152
	ds_load_u16_d16_hi v85, v105 offset:1216
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v92, v105 offset:928
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v44, v105 offset:992
	s_waitcnt lgkmcnt(29)
	ds_load_u16_d16_hi v125, v105 offset:1408
	ds_load_u16_d16_hi v86, v105 offset:1472
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v93, v105 offset:1184
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v45, v105 offset:1248
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v126, v105 offset:1664
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v94, v105 offset:1440
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v46, v105 offset:1504
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v127, v105 offset:1920
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v95, v105 offset:1696
	s_waitcnt lgkmcnt(29)
	ds_load_u16_d16_hi v47, v105 offset:1760
	ds_load_b128 v[73:76], v107
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v96, v105 offset:1952
	s_waitcnt lgkmcnt(29)
	ds_load_u16_d16_hi v48, v105 offset:2016
	v_lshl_add_u32 v30, v29, 5, v109
	s_waitcnt vmcnt(4)
	ds_store_b128 v108, v[1:4]
	s_waitcnt vmcnt(3)
	ds_store_b128 v106, v[5:8]
	s_waitcnt vmcnt(2)
	ds_store_b128 v106, v[17:20] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v106, v[21:24] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v106, v[25:28] offset:1536
	v_lshl_add_u32 v1, v29, 13, v110
	buffer_load_b128 v[128:131], v30, s[4:7], 0 offen
	ds_load_u16_d16 v34, v105 offset:352
	v_add_nc_u32_e32 v2, 0x1000, v1
	s_clause 0x3
	buffer_load_b128 v[132:135], v1, s[8:11], 0 offen slc
	buffer_load_b128 v[136:139], v1, s[8:11], 0 offen offset:2048 slc
	buffer_load_b128 v[140:143], v2, s[8:11], 0 offen slc
	buffer_load_b128 v[144:147], v2, s[8:11], 0 offen offset:2048 slc
	v_dual_mov_b32 v1, s16 :: v_dual_mov_b32 v2, s17
	v_dual_mov_b32 v3, s18 :: v_dual_mov_b32 v4, s19
	v_dual_mov_b32 v5, s20 :: v_dual_mov_b32 v6, s21
	v_dual_mov_b32 v7, s22 :: v_dual_mov_b32 v8, s23
	s_delay_alu instid0(VALU_DEP_1)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[65:72], v[9:16], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[65:72], v[57:64], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[65:72], v[112:119], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[65:72], v[49:56], v[1:8]
	ds_load_u16_d16 v35, v105 offset:608
	ds_load_u16_d16 v114, v105 offset:512
	ds_load_u16_d16 v58, v105 offset:288
	ds_load_b128 v[53:56], v107 offset:16
	ds_load_u16_d16 v68, v105 offset:832
	ds_load_u16_d16 v115, v105 offset:768
	ds_load_u16_d16 v59, v105 offset:544
	ds_load_u16_d16 v67, v105 offset:576
	ds_load_u16_d16 v113, v105 offset:256
	ds_load_u16_d16 v66, v105 offset:320
	ds_load_u16_d16 v112, v105
	ds_load_u16_d16 v57, v105 offset:32
	ds_load_u16_d16 v65, v105 offset:64
	s_waitcnt lgkmcnt(13)
	ds_load_u16_d16_hi v34, v105 offset:480
	ds_load_u16_d16 v33, v105 offset:96
	ds_load_u16_d16 v69, v105 offset:1088
	ds_load_u16_d16 v116, v105 offset:1024
	ds_load_u16_d16 v60, v105 offset:800
	ds_load_u16_d16 v36, v105 offset:864
	ds_load_u16_d16 v70, v105 offset:1344
	ds_load_u16_d16 v117, v105 offset:1280
	ds_load_u16_d16 v61, v105 offset:1056
	ds_load_u16_d16 v37, v105 offset:1120
	ds_load_u16_d16 v71, v105 offset:1600
	ds_load_u16_d16 v118, v105 offset:1536
	ds_load_u16_d16 v62, v105 offset:1312
	ds_load_u16_d16 v38, v105 offset:1376
	ds_load_u16_d16 v72, v105 offset:1856
	ds_load_u16_d16 v119, v105 offset:1792
	ds_load_u16_d16 v63, v105 offset:1568
	ds_load_u16_d16 v39, v105 offset:1632
	ds_load_u16_d16 v64, v105 offset:1824
	ds_load_u16_d16 v40, v105 offset:1888
	v_wmma_f32_16x16x16_bf16 v[25:32], v[73:80], v[120:127], v[25:32]
	v_add_nc_u32_e32 v120, 4, v111
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v112, v105 offset:128
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v57, v105 offset:160
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v65, v105 offset:192
	s_waitcnt lgkmcnt(21)
	ds_load_u16_d16_hi v33, v105 offset:224
	ds_load_u16_d16_hi v67, v105 offset:704
	ds_load_u16_d16_hi v114, v105 offset:640
	ds_load_u16_d16_hi v113, v105 offset:384
	ds_load_u16_d16_hi v58, v105 offset:416
	ds_load_u16_d16_hi v66, v105 offset:448
	ds_load_u16_d16_hi v68, v105 offset:960
	ds_load_u16_d16_hi v115, v105 offset:896
	ds_load_u16_d16_hi v59, v105 offset:672
	ds_load_u16_d16_hi v35, v105 offset:736
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v69, v105 offset:1216
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v116, v105 offset:1152
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v60, v105 offset:928
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v36, v105 offset:992
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v70, v105 offset:1472
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v117, v105 offset:1408
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v61, v105 offset:1184
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v37, v105 offset:1248
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v71, v105 offset:1728
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v118, v105 offset:1664
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v62, v105 offset:1440
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v38, v105 offset:1504
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v72, v105 offset:1984
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v119, v105 offset:1920
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v63, v105 offset:1696
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v39, v105 offset:1760
	ds_load_b128 v[49:52], v107
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v64, v105 offset:1952
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v40, v105 offset:2016
	v_lshl_add_u32 v121, v120, 13, v110
	v_lshl_add_u32 v120, v120, 5, v109
	v_wmma_f32_16x16x16_bf16 v[17:24], v[73:80], v[89:96], v[17:24]
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_3) | instid1(VALU_DEP_1)
	v_add_nc_u32_e32 v122, 0x1000, v121
	v_wmma_f32_16x16x16_bf16 v[9:16], v[73:80], v[81:88], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[73:80], v[41:48], v[1:8]
	v_add_nc_u32_e32 v111, 5, v111
	v_lshl_add_u32 v96, v111, 5, v109
	s_waitcnt lgkmcnt(2)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[49:56], v[112:119], v[25:32]
	s_waitcnt lgkmcnt(1)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[49:56], v[57:64], v[17:24]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[49:56], v[33:40], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[49:56], v[65:72], v[9:16]
	s_waitcnt vmcnt(4)
	ds_store_b128 v108, v[128:131]
	s_waitcnt vmcnt(3)
	ds_store_b128 v106, v[132:135]
	s_waitcnt vmcnt(2)
	ds_store_b128 v106, v[136:139] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v106, v[140:143] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v106, v[144:147] offset:1536
	buffer_load_b128 v[125:128], v120, s[4:7], 0 offen
	s_clause 0x3
	buffer_load_b128 v[129:132], v121, s[8:11], 0 offen slc
	buffer_load_b128 v[133:136], v121, s[8:11], 0 offen offset:2048 slc
	buffer_load_b128 v[137:140], v122, s[8:11], 0 offen slc
	buffer_load_b128 v[141:144], v122, s[8:11], 0 offen offset:2048 slc
	ds_load_u16_d16 v89, v105 offset:352
	ds_load_u16_d16 v90, v105 offset:608
	ds_load_u16_d16 v43, v105 offset:512
	ds_load_u16_d16 v74, v105 offset:288
	ds_load_b128 v[113:116], v107 offset:16
	ds_load_u16_d16 v120, v105 offset:832
	ds_load_u16_d16 v44, v105 offset:768
	ds_load_u16_d16 v75, v105 offset:544
	ds_load_u16_d16 v119, v105 offset:576
	ds_load_u16_d16 v42, v105 offset:256
	ds_load_u16_d16 v118, v105 offset:320
	ds_load_u16_d16 v41, v105
	ds_load_u16_d16 v73, v105 offset:32
	ds_load_u16_d16 v117, v105 offset:64
	s_waitcnt lgkmcnt(13)
	ds_load_u16_d16_hi v89, v105 offset:480
	ds_load_u16_d16 v88, v105 offset:96
	ds_load_u16_d16 v121, v105 offset:1088
	ds_load_u16_d16 v45, v105 offset:1024
	ds_load_u16_d16 v76, v105 offset:800
	ds_load_u16_d16 v91, v105 offset:864
	ds_load_u16_d16 v122, v105 offset:1344
	ds_load_u16_d16 v46, v105 offset:1280
	ds_load_u16_d16 v77, v105 offset:1056
	ds_load_u16_d16 v92, v105 offset:1120
	ds_load_u16_d16 v123, v105 offset:1600
	ds_load_u16_d16 v47, v105 offset:1536
	ds_load_u16_d16 v78, v105 offset:1312
	ds_load_u16_d16 v93, v105 offset:1376
	ds_load_u16_d16 v124, v105 offset:1856
	ds_load_u16_d16 v48, v105 offset:1792
	ds_load_u16_d16 v79, v105 offset:1568
	ds_load_u16_d16 v94, v105 offset:1632
	ds_load_u16_d16 v80, v105 offset:1824
	ds_load_u16_d16 v95, v105 offset:1888
	v_lshl_add_u32 v145, v111, 13, v110
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v41, v105 offset:128
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v73, v105 offset:160
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v117, v105 offset:192
	s_waitcnt lgkmcnt(21)
	ds_load_u16_d16_hi v88, v105 offset:224
	ds_load_u16_d16_hi v119, v105 offset:704
	ds_load_u16_d16_hi v43, v105 offset:640
	ds_load_u16_d16_hi v42, v105 offset:384
	ds_load_u16_d16_hi v74, v105 offset:416
	ds_load_u16_d16_hi v118, v105 offset:448
	ds_load_u16_d16_hi v120, v105 offset:960
	ds_load_u16_d16_hi v44, v105 offset:896
	ds_load_u16_d16_hi v75, v105 offset:672
	ds_load_u16_d16_hi v90, v105 offset:736
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v121, v105 offset:1216
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v45, v105 offset:1152
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v76, v105 offset:928
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v91, v105 offset:992
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v122, v105 offset:1472
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v46, v105 offset:1408
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v77, v105 offset:1184
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v92, v105 offset:1248
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v123, v105 offset:1728
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v47, v105 offset:1664
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v78, v105 offset:1440
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v93, v105 offset:1504
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v124, v105 offset:1984
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v48, v105 offset:1920
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v79, v105 offset:1696
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v94, v105 offset:1760
	ds_load_b128 v[109:112], v107
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v80, v105 offset:1952
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v95, v105 offset:2016
	v_add_nc_u32_e32 v146, 0x1000, v145
	s_waitcnt vmcnt(4)
	ds_store_b128 v108, v[125:128]
	s_waitcnt vmcnt(3)
	ds_store_b128 v106, v[129:132]
	s_waitcnt vmcnt(2)
	ds_store_b128 v106, v[133:136] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v106, v[137:140] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v106, v[141:144] offset:1536
	buffer_load_b128 v[33:36], v96, s[4:7], 0 offen
	s_clause 0x3
	buffer_load_b128 v[37:40], v145, s[8:11], 0 offen slc
	buffer_load_b128 v[81:84], v145, s[8:11], 0 offen offset:2048 slc
	buffer_load_b128 v[141:144], v146, s[8:11], 0 offen slc
	buffer_load_b128 v[145:148], v146, s[8:11], 0 offen offset:2048 slc
	ds_load_u16_d16 v126, v105 offset:352
	ds_load_u16_d16 v127, v105 offset:608
	ds_load_u16_d16 v51, v105 offset:512
	ds_load_u16_d16 v58, v105 offset:288
	ds_load_b128 v[69:72], v107 offset:16
	ds_load_u16_d16 v136, v105 offset:832
	ds_load_u16_d16 v52, v105 offset:768
	ds_load_u16_d16 v59, v105 offset:544
	ds_load_u16_d16 v135, v105 offset:576
	ds_load_u16_d16 v50, v105 offset:256
	ds_load_u16_d16 v49, v105
	ds_load_u16_d16 v57, v105 offset:32
	ds_load_u16_d16 v134, v105 offset:320
	ds_load_u16_d16 v133, v105 offset:64
	s_waitcnt lgkmcnt(13)
	ds_load_u16_d16_hi v126, v105 offset:480
	ds_load_u16_d16 v125, v105 offset:96
	ds_load_u16_d16 v137, v105 offset:1088
	ds_load_u16_d16 v53, v105 offset:1024
	ds_load_u16_d16 v60, v105 offset:800
	ds_load_u16_d16 v128, v105 offset:864
	ds_load_u16_d16 v138, v105 offset:1344
	ds_load_u16_d16 v54, v105 offset:1280
	ds_load_u16_d16 v61, v105 offset:1056
	ds_load_u16_d16 v129, v105 offset:1120
	ds_load_u16_d16 v139, v105 offset:1600
	ds_load_u16_d16 v55, v105 offset:1536
	ds_load_u16_d16 v62, v105 offset:1312
	ds_load_u16_d16 v130, v105 offset:1376
	ds_load_u16_d16 v140, v105 offset:1856
	ds_load_u16_d16 v56, v105 offset:1792
	ds_load_u16_d16 v63, v105 offset:1568
	ds_load_u16_d16 v131, v105 offset:1632
	ds_load_u16_d16 v64, v105 offset:1824
	ds_load_u16_d16 v132, v105 offset:1888
	s_waitcnt lgkmcnt(23)
	ds_load_u16_d16_hi v49, v105 offset:128
	s_waitcnt lgkmcnt(23)
	ds_load_u16_d16_hi v57, v105 offset:160
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v133, v105 offset:192
	s_waitcnt lgkmcnt(21)
	ds_load_u16_d16_hi v125, v105 offset:224
	ds_load_u16_d16_hi v51, v105 offset:640
	ds_load_u16_d16_hi v50, v105 offset:384
	ds_load_u16_d16_hi v135, v105 offset:704
	ds_load_u16_d16_hi v58, v105 offset:416
	ds_load_u16_d16_hi v134, v105 offset:448
	ds_load_u16_d16_hi v52, v105 offset:896
	ds_load_u16_d16_hi v136, v105 offset:960
	ds_load_u16_d16_hi v59, v105 offset:672
	ds_load_u16_d16_hi v127, v105 offset:736
	s_waitcnt lgkmcnt(29)
	ds_load_u16_d16_hi v53, v105 offset:1152
	ds_load_u16_d16_hi v137, v105 offset:1216
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v60, v105 offset:928
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v128, v105 offset:992
	s_waitcnt lgkmcnt(29)
	ds_load_u16_d16_hi v54, v105 offset:1408
	ds_load_u16_d16_hi v138, v105 offset:1472
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v61, v105 offset:1184
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v129, v105 offset:1248
	s_waitcnt lgkmcnt(29)
	ds_load_u16_d16_hi v55, v105 offset:1664
	ds_load_u16_d16_hi v139, v105 offset:1728
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v62, v105 offset:1440
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v130, v105 offset:1504
	s_waitcnt lgkmcnt(29)
	ds_load_u16_d16_hi v56, v105 offset:1920
	ds_load_u16_d16_hi v140, v105 offset:1984
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v63, v105 offset:1696
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v131, v105 offset:1760
	ds_load_b128 v[65:68], v107
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v64, v105 offset:1952
	s_waitcnt lgkmcnt(31)
	ds_load_u16_d16_hi v132, v105 offset:2016
	v_wmma_f32_16x16x16_bf16 v[25:32], v[109:116], v[41:48], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[109:116], v[73:80], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[109:116], v[117:124], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[109:116], v[88:95], v[1:8]
	v_mov_b32_e32 v47, 1
	s_mov_b32 s4, exec_lo
	s_waitcnt lgkmcnt(2)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[65:72], v[49:56], v[25:32]
	s_waitcnt lgkmcnt(1)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[65:72], v[57:64], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[65:72], v[133:140], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[65:72], v[125:132], v[1:8]
	s_waitcnt vmcnt(4)
	ds_store_b128 v108, v[33:36]
	s_waitcnt vmcnt(3)
	ds_store_b128 v106, v[37:40]
	v_lshl_add_u32 v33, v101, 2, v102
	v_and_b32_e32 v34, 31, v0
	s_waitcnt vmcnt(2)
	ds_store_b128 v106, v[81:84] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v106, v[141:144] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v106, v[145:148] offset:1536
	v_lshlrev_b32_e32 v35, 12, v33
	ds_load_u16_d16 v38, v105 offset:352
	v_lshlrev_b32_e32 v36, 5, v34
	v_lshl_or_b32 v33, v33, 5, v34
	v_lshl_add_u32 v37, v103, 10, v35
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_ashrrev_i32_e32 v34, 31, v33
	v_or_b32_e32 v101, v37, v36
	ds_load_b128 v[73:76], v107
	ds_load_b128 v[77:80], v107 offset:16
	ds_load_u16_d16 v39, v105 offset:608
	ds_load_u16_d16 v83, v105 offset:512
	ds_load_u16_d16 v90, v105 offset:288
	ds_load_u16_d16 v109, v105 offset:832
	ds_load_u16_d16 v84, v105 offset:768
	ds_load_u16_d16 v91, v105 offset:544
	ds_load_u16_d16 v108, v105 offset:576
	ds_load_u16_d16 v82, v105 offset:256
	ds_load_u16_d16 v107, v105 offset:320
	ds_load_u16_d16 v81, v105
	ds_load_u16_d16 v89, v105 offset:32
	ds_load_u16_d16 v106, v105 offset:64
	s_waitcnt lgkmcnt(14)
	ds_load_u16_d16_hi v38, v105 offset:480
	ds_load_u16_d16 v37, v105 offset:96
	ds_load_u16_d16 v110, v105 offset:1088
	ds_load_u16_d16 v85, v105 offset:1024
	ds_load_u16_d16 v92, v105 offset:800
	ds_load_u16_d16 v40, v105 offset:864
	ds_load_u16_d16 v111, v105 offset:1344
	ds_load_u16_d16 v86, v105 offset:1280
	ds_load_u16_d16 v93, v105 offset:1056
	ds_load_u16_d16 v41, v105 offset:1120
	ds_load_u16_d16 v112, v105 offset:1600
	ds_load_u16_d16 v87, v105 offset:1536
	ds_load_u16_d16 v94, v105 offset:1312
	ds_load_u16_d16 v42, v105 offset:1376
	ds_load_u16_d16 v113, v105 offset:1856
	ds_load_u16_d16 v88, v105 offset:1792
	ds_load_u16_d16 v95, v105 offset:1568
	ds_load_u16_d16 v43, v105 offset:1632
	ds_load_u16_d16 v96, v105 offset:1824
	ds_load_u16_d16 v44, v105 offset:1888
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v81, v105 offset:128
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v37, v105 offset:224
	ds_load_u16_d16_hi v108, v105 offset:704
	ds_load_u16_d16_hi v83, v105 offset:640
	ds_load_u16_d16_hi v82, v105 offset:384
	ds_load_u16_d16_hi v90, v105 offset:416
	ds_load_u16_d16_hi v107, v105 offset:448
	ds_load_u16_d16_hi v109, v105 offset:960
	ds_load_u16_d16_hi v84, v105 offset:896
	ds_load_u16_d16_hi v91, v105 offset:672
	ds_load_u16_d16_hi v39, v105 offset:736
	s_waitcnt lgkmcnt(28)
	ds_load_u16_d16_hi v110, v105 offset:1216
	s_waitcnt lgkmcnt(28)
	ds_load_u16_d16_hi v85, v105 offset:1152
	s_waitcnt lgkmcnt(28)
	ds_load_u16_d16_hi v92, v105 offset:928
	s_waitcnt lgkmcnt(28)
	ds_load_u16_d16_hi v40, v105 offset:992
	s_waitcnt lgkmcnt(28)
	ds_load_u16_d16_hi v111, v105 offset:1472
	s_waitcnt lgkmcnt(28)
	ds_load_u16_d16_hi v86, v105 offset:1408
	s_waitcnt lgkmcnt(28)
	ds_load_u16_d16_hi v93, v105 offset:1184
	s_waitcnt lgkmcnt(28)
	ds_load_u16_d16_hi v41, v105 offset:1248
	s_waitcnt lgkmcnt(28)
	ds_load_u16_d16_hi v112, v105 offset:1728
	s_waitcnt lgkmcnt(28)
	ds_load_u16_d16_hi v87, v105 offset:1664
	s_waitcnt lgkmcnt(28)
	ds_load_u16_d16_hi v94, v105 offset:1440
	s_waitcnt lgkmcnt(28)
	ds_load_u16_d16_hi v42, v105 offset:1504
	s_waitcnt lgkmcnt(28)
	ds_load_u16_d16_hi v113, v105 offset:1984
	s_waitcnt lgkmcnt(28)
	ds_load_u16_d16_hi v88, v105 offset:1920
	s_waitcnt lgkmcnt(28)
	ds_load_u16_d16_hi v95, v105 offset:1696
	s_waitcnt lgkmcnt(28)
	ds_load_u16_d16_hi v43, v105 offset:1760
	s_waitcnt lgkmcnt(28)
	ds_load_u16_d16_hi v96, v105 offset:1952
	ds_load_u16_d16_hi v89, v105 offset:160
	ds_load_u16_d16_hi v106, v105 offset:192
	s_waitcnt lgkmcnt(30)
	ds_load_u16_d16_hi v44, v105 offset:2016
	v_ashrrev_i32_e32 v102, 31, v101
	v_lshlrev_b64 v[33:34], 2, v[33:34]
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_lshlrev_b64 v[45:46], 2, v[101:102]
	v_add_co_u32 v33, vcc_lo, s12, v33
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_add_co_ci_u32_e64 v34, null, s13, v34, vcc_lo
	v_add_co_u32 v45, vcc_lo, s2, v45
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v46, null, s3, v46, vcc_lo
	s_waitcnt lgkmcnt(6)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[73:80], v[81:88], v[25:32]
	s_clause 0x1
	global_store_b128 v[45:46], v[29:32], off offset:16
	global_store_b128 v[45:46], v[25:28], off
	s_waitcnt lgkmcnt(2)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[73:80], v[89:96], v[17:24]
	s_waitcnt lgkmcnt(1)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[73:80], v[106:113], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[73:80], v[37:44], v[1:8]
	s_clause 0x5
	global_store_b128 v[45:46], v[21:24], off offset:48
	global_store_b128 v[45:46], v[17:20], off offset:32
	global_store_b128 v[45:46], v[13:16], off offset:80
	global_store_b128 v[45:46], v[9:12], off offset:64
	global_store_b128 v[45:46], v[5:8], off offset:112
	global_store_b128 v[45:46], v[1:4], off offset:96
	s_waitcnt_vscnt null, 0x0
	global_atomic_add_u32 v1, v[33:34], v47, off glc
	s_waitcnt vmcnt(0)
	buffer_gl1_inv
	buffer_gl0_inv
	v_cmpx_eq_u32_e32 3, v1
	s_cbranch_execz .LBB0_2
	v_or_b32_e32 v1, v35, v36
	s_load_b64 s[4:5], s[0:1], 0x30
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v2, 31, v1
	v_lshlrev_b64 v[1:2], 2, v[1:2]
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v95, vcc_lo, s2, v1
	v_add_co_ci_u32_e64 v96, null, s3, v2, vcc_lo
	s_clause 0x7
	global_load_b128 v[1:4], v[95:96], off
	global_load_b128 v[5:8], v[95:96], off offset:16
	global_load_b128 v[9:12], v[95:96], off offset:32
	global_load_b128 v[13:16], v[95:96], off offset:48
	global_load_b128 v[17:20], v[95:96], off offset:64
	global_load_b128 v[21:24], v[95:96], off offset:80
	global_load_b128 v[25:28], v[95:96], off offset:112
	global_load_b128 v[29:32], v[95:96], off offset:96
	v_add_co_u32 v67, vcc_lo, v95, 0x2000
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v68, null, 0, v96, vcc_lo
	v_add_co_u32 v51, vcc_lo, 0x1000, v95
	v_add_co_ci_u32_e64 v52, null, 0, v96, vcc_lo
	v_add_co_u32 v63, vcc_lo, 0x1040, v95
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v64, null, 0, v96, vcc_lo
	v_add_co_u32 v83, vcc_lo, 0x2000, v95
	s_clause 0x3
	global_load_b128 v[35:38], v[67:68], off offset:-4096
	global_load_b128 v[39:42], v[51:52], off offset:16
	global_load_b128 v[43:46], v[51:52], off offset:32
	global_load_b128 v[47:50], v[51:52], off offset:48
	v_add_co_ci_u32_e64 v84, null, 0, v96, vcc_lo
	s_clause 0x3
	global_load_b128 v[51:54], v[51:52], off offset:64
	global_load_b128 v[55:58], v[63:64], off offset:16
	global_load_b128 v[59:62], v[63:64], off offset:32
	global_load_b128 v[63:66], v[63:64], off offset:48
	v_add_co_u32 v101, vcc_lo, 0x2040, v95
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v102, null, 0, v96, vcc_lo
	v_add_co_u32 v125, vcc_lo, 0x3000, v95
	s_clause 0x3
	global_load_b128 v[67:70], v[67:68], off
	global_load_b128 v[71:74], v[83:84], off offset:16
	global_load_b128 v[75:78], v[83:84], off offset:32
	global_load_b128 v[79:82], v[83:84], off offset:48
	v_add_co_ci_u32_e64 v126, null, 0, v96, vcc_lo
	s_clause 0x7
	global_load_b128 v[105:108], v[101:102], off offset:48
	global_load_b128 v[109:112], v[125:126], off
	global_load_b128 v[113:116], v[125:126], off offset:16
	global_load_b128 v[117:120], v[125:126], off offset:32
	global_load_b128 v[121:124], v[125:126], off offset:48
	global_load_b128 v[83:86], v[83:84], off offset:64
	global_load_b128 v[87:90], v[101:102], off offset:16
	global_load_b128 v[91:94], v[101:102], off offset:32
	v_add_co_u32 v95, vcc_lo, 0x3040, v95
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v96, null, 0, v96, vcc_lo
	s_clause 0x3
	global_load_b128 v[125:128], v[125:126], off offset:64
	global_load_b128 v[129:132], v[95:96], off offset:16
	global_load_b128 v[133:136], v[95:96], off offset:32
	global_load_b128 v[137:140], v[95:96], off offset:48
	v_lshlrev_b32_e32 v0, 4, v0
	v_lshlrev_b32_e32 v95, 13, v100
	s_waitcnt lgkmcnt(0)
	s_and_b32 s5, s5, 0xffff
	s_waitcnt vmcnt(31)
	v_dual_add_f32 v1, 0, v1 :: v_dual_add_f32 v2, 0, v2
	v_dual_add_f32 v3, 0, v3 :: v_dual_and_b32 v0, 0x100, v0
	s_waitcnt vmcnt(30)
	v_dual_add_f32 v4, 0, v4 :: v_dual_add_f32 v5, 0, v5
	s_waitcnt vmcnt(25)
	v_add_f32_e32 v28, 0, v28
	v_dual_add_f32 v6, 0, v6 :: v_dual_add_f32 v7, 0, v7
	v_dual_add_f32 v8, 0, v8 :: v_dual_add_f32 v9, 0, v9
	v_dual_add_f32 v10, 0, v10 :: v_dual_add_f32 v11, 0, v11
	v_dual_add_f32 v12, 0, v12 :: v_dual_add_f32 v13, 0, v13
	v_dual_add_f32 v14, 0, v14 :: v_dual_add_f32 v15, 0, v15
	v_dual_add_f32 v16, 0, v16 :: v_dual_add_f32 v17, 0, v17
	s_waitcnt vmcnt(23)
	v_dual_add_f32 v1, v1, v35 :: v_dual_add_f32 v2, v2, v36
	v_dual_add_f32 v3, v3, v37 :: v_dual_add_f32 v4, v4, v38
	s_waitcnt vmcnt(22)
	v_dual_add_f32 v5, v5, v39 :: v_dual_add_f32 v6, v6, v40
	s_waitcnt vmcnt(16)
	v_dual_add_f32 v7, v7, v41 :: v_dual_add_f32 v28, v28, v66
	v_dual_add_f32 v8, v8, v42 :: v_dual_add_f32 v9, v9, v43
	s_waitcnt vmcnt(15)
	v_dual_add_f32 v1, v1, v67 :: v_dual_add_f32 v2, v2, v68
	v_dual_add_f32 v3, v3, v69 :: v_dual_add_f32 v4, v4, v70
	s_waitcnt vmcnt(11)
	v_dual_add_f32 v5, v5, v71 :: v_dual_add_f32 v28, v28, v108
	s_waitcnt vmcnt(10)
	v_dual_add_f32 v1, v1, v109 :: v_dual_add_f32 v2, v2, v110
	v_dual_add_f32 v3, v3, v111 :: v_dual_add_f32 v4, v4, v112
	s_waitcnt vmcnt(9)
	v_add_f32_e32 v5, v5, v113
	s_delay_alu instid0(VALU_DEP_3)
	v_bfe_u32 v35, v1, 16, 1
	v_or_b32_e32 v36, 0x400000, v1
	v_bfe_u32 v37, v2, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	v_or_b32_e32 v38, 0x400000, v2
	v_add3_u32 v35, v35, v1, 0x7fff
	v_bfe_u32 v39, v3, 16, 1
	v_add3_u32 v37, v37, v2, 0x7fff
	v_dual_add_f32 v6, v6, v72 :: v_dual_add_f32 v7, v7, v73
	s_delay_alu instid0(VALU_DEP_4)
	v_cndmask_b32_e32 v1, v35, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_or_b32_e32 v40, 0x400000, v3
	v_bfe_u32 v41, v4, 16, 1
	v_add3_u32 v39, v39, v3, 0x7fff
	v_dual_add_f32 v6, v6, v114 :: v_dual_add_f32 v7, v7, v115
	v_cndmask_b32_e32 v2, v37, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_or_b32_e32 v42, 0x400000, v4
	v_bfe_u32 v43, v5, 16, 1
	v_add3_u32 v41, v41, v4, 0x7fff
	v_dual_add_f32 v10, v10, v44 :: v_dual_add_f32 v11, v11, v45
	v_cndmask_b32_e32 v3, v39, v40, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_dual_add_f32 v8, v8, v74 :: v_dual_add_f32 v9, v9, v75
	v_or_b32_e32 v44, 0x400000, v5
	v_bfe_u32 v45, v6, 16, 1
	v_add3_u32 v43, v43, v5, 0x7fff
	v_cndmask_b32_e32 v4, v41, v42, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_dual_add_f32 v12, v12, v46 :: v_dual_add_f32 v13, v13, v47
	s_waitcnt vmcnt(8)
	v_dual_add_f32 v8, v8, v116 :: v_dual_add_f32 v9, v9, v117
	v_or_b32_e32 v46, 0x400000, v6
	v_bfe_u32 v47, v7, 16, 1
	v_add3_u32 v45, v45, v6, 0x7fff
	v_cndmask_b32_e32 v5, v43, v44, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_dual_add_f32 v14, v14, v48 :: v_dual_add_f32 v15, v15, v49
	v_dual_add_f32 v10, v10, v76 :: v_dual_add_f32 v11, v11, v77
	v_or_b32_e32 v48, 0x400000, v7
	v_bfe_u32 v49, v8, 16, 1
	v_add3_u32 v47, v47, v7, 0x7fff
	v_cndmask_b32_e32 v6, v45, v46, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_dual_add_f32 v18, 0, v18 :: v_dual_add_f32 v19, 0, v19
	v_dual_add_f32 v16, v16, v50 :: v_dual_add_f32 v17, v17, v51
	v_dual_add_f32 v10, v10, v118 :: v_dual_add_f32 v11, v11, v119
	v_or_b32_e32 v50, 0x400000, v8
	v_bfe_u32 v51, v9, 16, 1
	v_add3_u32 v49, v49, v8, 0x7fff
	v_cndmask_b32_e32 v7, v47, v48, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_dual_add_f32 v20, 0, v20 :: v_dual_add_f32 v21, 0, v21
	v_dual_add_f32 v18, v18, v52 :: v_dual_add_f32 v19, v19, v53
	v_dual_add_f32 v12, v12, v78 :: v_dual_add_f32 v13, v13, v79
	v_or_b32_e32 v52, 0x400000, v9
	v_bfe_u32 v53, v10, 16, 1
	v_add3_u32 v51, v51, v9, 0x7fff
	v_cndmask_b32_e32 v8, v49, v50, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_dual_add_f32 v22, 0, v22 :: v_dual_add_f32 v23, 0, v23
	v_dual_add_f32 v20, v20, v54 :: v_dual_add_f32 v21, v21, v55
	s_waitcnt vmcnt(7)
	v_dual_add_f32 v12, v12, v120 :: v_dual_add_f32 v13, v13, v121
	v_or_b32_e32 v54, 0x400000, v10
	v_bfe_u32 v55, v11, 16, 1
	v_add3_u32 v53, v53, v10, 0x7fff
	v_cndmask_b32_e32 v9, v51, v52, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_dual_add_f32 v24, 0, v24 :: v_dual_add_f32 v29, 0, v29
	v_dual_add_f32 v22, v22, v56 :: v_dual_add_f32 v23, v23, v57
	v_dual_add_f32 v14, v14, v80 :: v_dual_add_f32 v15, v15, v81
	v_or_b32_e32 v56, 0x400000, v11
	v_bfe_u32 v57, v12, 16, 1
	v_add3_u32 v55, v55, v11, 0x7fff
	v_cndmask_b32_e32 v10, v53, v54, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_dual_add_f32 v30, 0, v30 :: v_dual_add_f32 v31, 0, v31
	v_dual_add_f32 v24, v24, v58 :: v_dual_add_f32 v29, v29, v59
	v_dual_add_f32 v14, v14, v122 :: v_dual_add_f32 v15, v15, v123
	v_or_b32_e32 v58, 0x400000, v12
	v_bfe_u32 v59, v13, 16, 1
	v_add3_u32 v57, v57, v12, 0x7fff
	v_cndmask_b32_e32 v11, v55, v56, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_dual_add_f32 v32, 0, v32 :: v_dual_add_f32 v25, 0, v25
	v_dual_add_f32 v30, v30, v60 :: v_dual_add_f32 v31, v31, v61
	s_waitcnt vmcnt(6)
	v_dual_add_f32 v16, v16, v82 :: v_dual_add_f32 v17, v17, v83
	v_or_b32_e32 v60, 0x400000, v13
	v_bfe_u32 v61, v14, 16, 1
	v_add3_u32 v59, v59, v13, 0x7fff
	v_cndmask_b32_e32 v12, v57, v58, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_dual_add_f32 v26, 0, v26 :: v_dual_add_f32 v27, 0, v27
	v_dual_add_f32 v32, v32, v62 :: v_dual_add_f32 v25, v25, v63
	s_waitcnt vmcnt(3)
	v_dual_add_f32 v16, v16, v124 :: v_dual_add_f32 v17, v17, v125
	v_or_b32_e32 v62, 0x400000, v14
	v_bfe_u32 v63, v15, 16, 1
	v_add3_u32 v61, v61, v14, 0x7fff
	v_cndmask_b32_e32 v13, v59, v60, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_dual_add_f32 v26, v26, v64 :: v_dual_add_f32 v27, v27, v65
	v_dual_add_f32 v18, v18, v84 :: v_dual_add_f32 v19, v19, v85
	v_or_b32_e32 v64, 0x400000, v15
	v_bfe_u32 v65, v16, 16, 1
	v_add3_u32 v63, v63, v15, 0x7fff
	v_cndmask_b32_e32 v14, v61, v62, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_dual_add_f32 v18, v18, v126 :: v_dual_add_f32 v19, v19, v127
	v_or_b32_e32 v66, 0x400000, v16
	v_bfe_u32 v67, v17, 16, 1
	v_add3_u32 v65, v65, v16, 0x7fff
	v_cndmask_b32_e32 v15, v63, v64, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	v_dual_add_f32 v20, v20, v86 :: v_dual_add_f32 v21, v21, v87
	v_or_b32_e32 v68, 0x400000, v17
	v_bfe_u32 v69, v18, 16, 1
	v_add3_u32 v67, v67, v17, 0x7fff
	v_cndmask_b32_e32 v16, v65, v66, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v17, v17
	s_waitcnt vmcnt(2)
	v_dual_add_f32 v20, v20, v128 :: v_dual_add_f32 v21, v21, v129
	v_or_b32_e32 v70, 0x400000, v18
	v_bfe_u32 v71, v19, 16, 1
	v_add3_u32 v69, v69, v18, 0x7fff
	v_cndmask_b32_e32 v17, v67, v68, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v18, v18
	v_dual_add_f32 v22, v22, v88 :: v_dual_add_f32 v23, v23, v89
	v_or_b32_e32 v72, 0x400000, v19
	v_bfe_u32 v73, v20, 16, 1
	v_add3_u32 v71, v71, v19, 0x7fff
	v_cndmask_b32_e32 v18, v69, v70, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v19, v19
	v_dual_add_f32 v22, v22, v130 :: v_dual_add_f32 v23, v23, v131
	v_or_b32_e32 v74, 0x400000, v20
	v_bfe_u32 v75, v21, 16, 1
	v_add3_u32 v73, v73, v20, 0x7fff
	v_cndmask_b32_e32 v19, v71, v72, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v20, v20
	v_dual_add_f32 v24, v24, v90 :: v_dual_add_f32 v29, v29, v91
	v_or_b32_e32 v76, 0x400000, v21
	v_bfe_u32 v77, v22, 16, 1
	v_add3_u32 v75, v75, v21, 0x7fff
	v_cndmask_b32_e32 v20, v73, v74, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v21, v21
	s_waitcnt vmcnt(1)
	v_dual_add_f32 v24, v24, v132 :: v_dual_add_f32 v29, v29, v133
	v_or_b32_e32 v78, 0x400000, v22
	v_bfe_u32 v79, v23, 16, 1
	v_add3_u32 v77, v77, v22, 0x7fff
	v_cndmask_b32_e32 v21, v75, v76, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v22, v22
	v_dual_add_f32 v30, v30, v92 :: v_dual_add_f32 v31, v31, v93
	v_or_b32_e32 v80, 0x400000, v23
	v_bfe_u32 v81, v24, 16, 1
	v_add3_u32 v79, v79, v23, 0x7fff
	v_cndmask_b32_e32 v22, v77, v78, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v23, v23
	v_dual_add_f32 v30, v30, v134 :: v_dual_add_f32 v31, v31, v135
	v_or_b32_e32 v82, 0x400000, v24
	v_bfe_u32 v83, v29, 16, 1
	v_add3_u32 v81, v81, v24, 0x7fff
	v_cndmask_b32_e32 v23, v79, v80, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v24, v24
	v_dual_add_f32 v32, v32, v94 :: v_dual_add_f32 v25, v25, v105
	v_or_b32_e32 v84, 0x400000, v29
	v_bfe_u32 v85, v30, 16, 1
	v_add3_u32 v83, v83, v29, 0x7fff
	v_cndmask_b32_e32 v24, v81, v82, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v29, v29
	s_waitcnt vmcnt(0)
	v_dual_add_f32 v32, v32, v136 :: v_dual_add_f32 v25, v25, v137
	v_or_b32_e32 v86, 0x400000, v30
	v_bfe_u32 v87, v31, 16, 1
	v_add3_u32 v85, v85, v30, 0x7fff
	v_cndmask_b32_e32 v29, v83, v84, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v30, v30
	v_dual_add_f32 v26, v26, v106 :: v_dual_add_f32 v27, v27, v107
	v_or_b32_e32 v88, 0x400000, v31
	v_bfe_u32 v89, v32, 16, 1
	v_add3_u32 v87, v87, v31, 0x7fff
	v_cndmask_b32_e32 v30, v85, v86, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v31, v31
	v_dual_add_f32 v26, v26, v138 :: v_dual_add_f32 v27, v27, v139
	v_or_b32_e32 v90, 0x400000, v32
	v_bfe_u32 v91, v25, 16, 1
	v_add3_u32 v89, v89, v32, 0x7fff
	v_cndmask_b32_e32 v31, v87, v88, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v32, v32
	v_or_b32_e32 v92, 0x400000, v25
	v_bfe_u32 v93, v26, 16, 1
	v_add3_u32 v91, v91, v25, 0x7fff
	v_dual_add_f32 v28, v28, v140 :: v_dual_lshlrev_b32 v39, 8, v99
	v_cndmask_b32_e32 v32, v89, v90, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v25, v25
	v_or_b32_e32 v94, 0x400000, v26
	v_bfe_u32 v96, v27, 16, 1
	v_add3_u32 v93, v93, v26, 0x7fff
	v_bfe_u32 v36, v28, 16, 1
	v_cndmask_b32_e32 v25, v91, v92, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v26, v26
	v_add3_u32 v35, v96, v27, 0x7fff
	v_or_b32_e32 v37, 0x400000, v27
	v_or3_b32 v0, v95, v0, v104
	v_add3_u32 v36, v36, v28, 0x7fff
	v_cndmask_b32_e32 v26, v93, v94, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v27, v27
	v_lshlrev_b32_e32 v38, 13, v98
	v_or_b32_e32 v40, 0x400000, v28
	v_lshlrev_b32_e32 v0, 1, v0
	v_lshrrev_b32_e32 v1, 16, v1
	s_delay_alu instid0(VALU_DEP_4)
	v_dual_cndmask_b32 v27, v35, v37 :: v_dual_add_nc_u32 v38, v38, v39
	v_cmp_u_f32_e32 vcc_lo, v28, v28
	v_lshlrev_b32_e32 v41, 7, v97
	v_lshrrev_b32_e32 v2, 16, v2
	v_lshrrev_b32_e32 v3, 16, v3
	v_lshrrev_b32_e32 v4, 16, v4
	v_cndmask_b32_e32 v28, v36, v40, vcc_lo
	v_add3_u32 v0, v38, v41, v0
	v_lshrrev_b32_e32 v5, 16, v5
	v_lshrrev_b32_e32 v6, 16, v6
	v_lshrrev_b32_e32 v7, 16, v7
	v_lshrrev_b32_e32 v8, 16, v8
	v_add_nc_u32_e32 v35, 0x1000, v0
	v_lshrrev_b32_e32 v9, 16, v9
	v_lshrrev_b32_e32 v10, 16, v10
	v_lshrrev_b32_e32 v11, 16, v11
	v_lshrrev_b32_e32 v12, 16, v12
	v_lshrrev_b32_e32 v13, 16, v13
	v_lshrrev_b32_e32 v14, 16, v14
	v_lshrrev_b32_e32 v15, 16, v15
	v_lshrrev_b32_e32 v16, 16, v16
	v_lshrrev_b32_e32 v17, 16, v17
	v_lshrrev_b32_e32 v18, 16, v18
	v_lshrrev_b32_e32 v19, 16, v19
	v_lshrrev_b32_e32 v20, 16, v20
	v_lshrrev_b32_e32 v21, 16, v21
	v_lshrrev_b32_e32 v22, 16, v22
	v_lshrrev_b32_e32 v23, 16, v23
	v_lshrrev_b32_e32 v24, 16, v24
	v_lshrrev_b32_e32 v29, 16, v29
	v_lshrrev_b32_e32 v30, 16, v30
	v_lshrrev_b32_e32 v31, 16, v31
	v_lshrrev_b32_e32 v32, 16, v32
	v_lshrrev_b32_e32 v25, 16, v25
	s_clause 0x1b
	buffer_store_b16 v1, v0, s[4:7], 0 offen
	buffer_store_b16 v2, v0, s[4:7], 0 offen offset:1024
	buffer_store_b16 v3, v0, s[4:7], 0 offen offset:2048
	buffer_store_b16 v4, v0, s[4:7], 0 offen offset:3072
	buffer_store_b16 v5, v35, s[4:7], 0 offen
	buffer_store_b16 v6, v35, s[4:7], 0 offen offset:1024
	buffer_store_b16 v7, v35, s[4:7], 0 offen offset:2048
	buffer_store_b16 v8, v35, s[4:7], 0 offen offset:3072
	buffer_store_b16 v9, v0, s[4:7], 0 offen offset:32
	buffer_store_b16 v10, v0, s[4:7], 0 offen offset:1056
	buffer_store_b16 v11, v0, s[4:7], 0 offen offset:2080
	buffer_store_b16 v12, v0, s[4:7], 0 offen offset:3104
	buffer_store_b16 v13, v35, s[4:7], 0 offen offset:32
	buffer_store_b16 v14, v35, s[4:7], 0 offen offset:1056
	buffer_store_b16 v15, v35, s[4:7], 0 offen offset:2080
	buffer_store_b16 v16, v35, s[4:7], 0 offen offset:3104
	buffer_store_b16 v17, v0, s[4:7], 0 offen offset:64
	buffer_store_b16 v18, v0, s[4:7], 0 offen offset:1088
	buffer_store_b16 v19, v0, s[4:7], 0 offen offset:2112
	buffer_store_b16 v20, v0, s[4:7], 0 offen offset:3136
	buffer_store_b16 v21, v35, s[4:7], 0 offen offset:64
	buffer_store_b16 v22, v35, s[4:7], 0 offen offset:1088
	buffer_store_b16 v23, v35, s[4:7], 0 offen offset:2112
	buffer_store_b16 v24, v35, s[4:7], 0 offen offset:3136
	buffer_store_b16 v29, v0, s[4:7], 0 offen offset:96
	buffer_store_b16 v30, v0, s[4:7], 0 offen offset:1120
	buffer_store_b16 v31, v0, s[4:7], 0 offen offset:2144
	buffer_store_b16 v32, v0, s[4:7], 0 offen offset:3168
	v_mov_b32_e32 v0, 0
	v_lshrrev_b32_e32 v26, 16, v26
	v_lshrrev_b32_e32 v27, 16, v27
	v_lshrrev_b32_e32 v28, 16, v28
	s_clause 0x3
	buffer_store_b16 v25, v35, s[4:7], 0 offen offset:96
	buffer_store_b16 v26, v35, s[4:7], 0 offen offset:1120
	buffer_store_b16 v27, v35, s[4:7], 0 offen offset:2144
	buffer_store_b16 v28, v35, s[4:7], 0 offen offset:3168
	s_waitcnt_vscnt null, 0x0
	global_store_b32 v[33:34], v0, off
.LBB0_2:
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
		.amdhsa_next_free_vgpr 149
		.amdhsa_next_free_sgpr 24
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

	.set .L_matmul_bf16_0.num_vgpr, 149
	.set .L_matmul_bf16_0.num_agpr, 0
	.set .L_matmul_bf16_0.numbered_sgpr, 24
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
    .sgpr_count:     26
    .sgpr_spill_count: 0
    .symbol:         _matmul_bf16_0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     149
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
