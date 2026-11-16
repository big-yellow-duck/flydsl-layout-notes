	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	_matmul_bf16_0
	.p2align	8
	.type	_matmul_bf16_0,@function
_matmul_bf16_0:
	v_lshrrev_b32_e32 v1, 5, v0
	s_lshl_b32 s3, s2, 1
	v_dual_mov_b32 v9, 0 :: v_dual_lshlrev_b32 v2, 3, v0
	s_clause 0x1
	s_load_b64 s[8:9], s[0:1], 0x0
	s_load_b64 s[4:5], s[0:1], 0x18
	v_or_b32_e32 v3, s3, v1
	s_bfe_i32 s3, s2, 0x1001e
	v_bfe_u32 v37, v0, 3, 2
	s_lshr_b32 s3, s3, 26
	v_dual_mov_b32 v11, v9 :: v_dual_and_b32 v38, 56, v2
	v_dual_mov_b32 v10, v9 :: v_dual_add_nc_u32 v1, s3, v3
	v_dual_mov_b32 v13, v9 :: v_dual_lshlrev_b32 v2, 4, v0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_dual_mov_b32 v12, v9 :: v_dual_and_b32 v1, 0x3ffffc0, v1
	v_lshl_or_b32 v33, v37, 12, v38
	v_bfe_u32 v47, v0, 1, 4
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_dual_mov_b32 v14, v9 :: v_dual_and_b32 v63, 16, v2
	v_sub_nc_u32_e32 v1, v3, v1
	s_mov_b32 s10, -1
	s_mov_b32 s11, 0x21027000
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_lshl_or_b32 v35, v47, 14, v63
	v_dual_mov_b32 v15, v9 :: v_dual_lshlrev_b32 v34, 6, v1
	s_waitcnt lgkmcnt(0)
	s_and_b32 s9, s9, 0xffff
	s_mov_b32 s6, s10
	s_mov_b32 s7, s11
	s_and_b32 s5, s5, 0xffff
	v_add_lshl_u32 v36, v34, v33, 1
	s_bfe_u32 s2, s2, 0x1001e
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_dual_mov_b32 v31, v9 :: v_dual_add_nc_u32 v64, s2, v3
	v_dual_mov_b32 v16, v9 :: v_dual_add_nc_u32 v1, 0x8000, v36
	v_dual_mov_b32 v25, v9 :: v_dual_add_nc_u32 v2, 0x10000, v36
	v_dual_mov_b32 v27, v9 :: v_dual_add_nc_u32 v4, 0x18000, v36
	buffer_load_b128 v[39:42], v35, s[8:11], 0 offen
	s_clause 0x3
	buffer_load_b128 v[43:46], v36, s[4:7], 0 offen slc
	buffer_load_b128 v[49:52], v1, s[4:7], 0 offen slc
	buffer_load_b128 v[53:56], v2, s[4:7], 0 offen slc
	buffer_load_b128 v[57:60], v4, s[4:7], 0 offen slc
	v_dual_mov_b32 v17, v9 :: v_dual_and_b32 v4, -2, v64
	s_movk_i32 s6, 0x300
	v_dual_mov_b32 v29, v9 :: v_dual_and_b32 v48, 15, v0
	v_ashrrev_i32_e32 v64, 1, v64
	s_delay_alu instid0(VALU_DEP_3)
	v_sub_nc_u32_e32 v93, v3, v4
	v_mov_b32_e32 v19, v9
	v_mul_u32_u24_e32 v65, 48, v47
	v_mul_u32_u24_e32 v66, 48, v48
	v_dual_mov_b32 v26, v9 :: v_dual_lshlrev_b32 v37, 7, v37
	v_mad_u64_u32 v[61:62], null, v93, s6, 0x1000
	v_lshlrev_b32_e32 v62, 11, v93
	v_mov_b32_e32 v28, v9
	v_mov_b32_e32 v30, v9
	v_mov_b32_e32 v32, v9
	v_mov_b32_e32 v18, v9
	v_lshl_or_b32 v38, v38, 1, v62
	v_mov_b32_e32 v20, v9
	v_or_b32_e32 v63, v61, v63
	v_mov_b32_e32 v21, v9
	v_mov_b32_e32 v22, v9
	v_mov_b32_e32 v23, v9
	v_mov_b32_e32 v24, v9
	v_mov_b32_e32 v1, v9
	v_mov_b32_e32 v2, v9
	v_mov_b32_e32 v3, v9
	v_mov_b32_e32 v4, v9
	v_mov_b32_e32 v5, v9
	v_mov_b32_e32 v6, v9
	v_mov_b32_e32 v7, v9
	v_mov_b32_e32 v8, v9
	v_readfirstlane_b32 s2, v64
	v_lshl_or_b32 v94, v48, 1, v62
	v_add_nc_u32_e32 v95, v61, v66
	v_mad_u32_u24 v47, v47, 48, v63
	v_add_nc_u32_e32 v96, v63, v65
	v_or_b32_e32 v61, v38, v37
	s_mov_b32 s3, 0
	s_mov_b32 s6, s10
	s_waitcnt vmcnt(4)
	ds_store_b128 v47, v[39:42]
	s_waitcnt vmcnt(3)
	ds_store_b128 v61, v[43:46]
	s_waitcnt vmcnt(2)
	ds_store_b128 v61, v[49:52] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v61, v[53:56] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v61, v[57:60] offset:1536
.LBB0_1:
	s_lshl_b32 s12, s3, 1
	v_add_nc_u32_e32 v97, v38, v37
	s_or_b32 s13, s12, 1
	s_add_i32 s12, s12, 2
	v_lshl_add_u32 v39, s13, 5, v35
	s_add_i32 s3, s3, 1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_2) | instid1(VALU_DEP_1)
	s_cmpk_lg_i32 s3, 0xff
	buffer_load_b128 v[81:84], v39, s[8:11], 0 offen
	v_lshl_add_u32 v39, s13, 17, v36
	v_add_nc_u32_e32 v40, 0x8000, v39
	s_clause 0x1
	buffer_load_b128 v[85:88], v39, s[4:7], 0 offen slc
	buffer_load_b128 v[89:92], v40, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v40, 0x10000, v39
	v_add_nc_u32_e32 v39, 0x18000, v39
	s_clause 0x1
	buffer_load_b128 v[98:101], v40, s[4:7], 0 offen slc
	buffer_load_b128 v[102:105], v39, s[4:7], 0 offen slc
	ds_load_b128 v[39:42], v95
	ds_load_b128 v[43:46], v95 offset:16
	ds_load_u16_d16_hi v49, v94 offset:128
	ds_load_u16_d16 v49, v94
	ds_load_u16_d16 v57, v94 offset:32
	ds_load_u16_d16 v50, v94 offset:256
	ds_load_u16_d16_hi v50, v94 offset:384
	ds_load_u16_d16 v51, v94 offset:512
	ds_load_u16_d16_hi v51, v94 offset:640
	ds_load_u16_d16 v52, v94 offset:768
	ds_load_u16_d16_hi v52, v94 offset:896
	ds_load_u16_d16 v53, v94 offset:1024
	ds_load_u16_d16_hi v53, v94 offset:1152
	ds_load_u16_d16 v54, v94 offset:1280
	ds_load_u16_d16_hi v54, v94 offset:1408
	ds_load_u16_d16 v55, v94 offset:1536
	ds_load_u16_d16_hi v55, v94 offset:1664
	ds_load_u16_d16 v56, v94 offset:1792
	ds_load_u16_d16_hi v56, v94 offset:1920
	ds_load_u16_d16_hi v57, v94 offset:160
	ds_load_u16_d16 v58, v94 offset:288
	ds_load_u16_d16_hi v58, v94 offset:416
	ds_load_u16_d16 v59, v94 offset:544
	ds_load_u16_d16_hi v59, v94 offset:672
	ds_load_u16_d16 v60, v94 offset:800
	ds_load_u16_d16_hi v60, v94 offset:928
	ds_load_u16_d16 v61, v94 offset:1056
	ds_load_u16_d16_hi v61, v94 offset:1184
	ds_load_u16_d16 v62, v94 offset:1312
	ds_load_u16_d16_hi v62, v94 offset:1440
	ds_load_u16_d16 v63, v94 offset:1568
	ds_load_u16_d16_hi v63, v94 offset:1696
	ds_load_u16_d16 v64, v94 offset:1824
	ds_load_u16_d16_hi v64, v94 offset:1952
	ds_load_u16_d16 v65, v94 offset:64
	ds_load_u16_d16_hi v65, v94 offset:192
	ds_load_u16_d16 v66, v94 offset:320
	ds_load_u16_d16_hi v66, v94 offset:448
	ds_load_u16_d16 v67, v94 offset:576
	ds_load_u16_d16_hi v67, v94 offset:704
	ds_load_u16_d16 v68, v94 offset:832
	ds_load_u16_d16_hi v68, v94 offset:960
	ds_load_u16_d16 v69, v94 offset:1088
	ds_load_u16_d16_hi v69, v94 offset:1216
	ds_load_u16_d16 v70, v94 offset:1344
	ds_load_u16_d16_hi v70, v94 offset:1472
	ds_load_u16_d16 v71, v94 offset:1600
	ds_load_u16_d16_hi v71, v94 offset:1728
	ds_load_u16_d16 v72, v94 offset:1856
	ds_load_u16_d16_hi v72, v94 offset:1984
	ds_load_u16_d16 v73, v94 offset:96
	ds_load_u16_d16_hi v73, v94 offset:224
	ds_load_u16_d16 v74, v94 offset:352
	ds_load_u16_d16_hi v74, v94 offset:480
	ds_load_u16_d16 v75, v94 offset:608
	ds_load_u16_d16_hi v75, v94 offset:736
	ds_load_u16_d16 v76, v94 offset:864
	ds_load_u16_d16_hi v76, v94 offset:992
	ds_load_u16_d16 v77, v94 offset:1120
	ds_load_u16_d16_hi v77, v94 offset:1248
	ds_load_u16_d16 v78, v94 offset:1376
	ds_load_u16_d16_hi v78, v94 offset:1504
	ds_load_u16_d16 v79, v94 offset:1632
	ds_load_u16_d16_hi v79, v94 offset:1760
	ds_load_u16_d16 v80, v94 offset:1888
	ds_load_u16_d16_hi v80, v94 offset:2016
	s_waitcnt lgkmcnt(47)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[39:46], v[49:56], v[9:16]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[39:46], v[57:64], v[25:32]
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[39:46], v[65:72], v[17:24]
	s_waitcnt vmcnt(3)
	ds_store_b128 v97, v[85:88]
	s_waitcnt vmcnt(2)
	ds_store_b128 v97, v[89:92] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v97, v[98:101] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v97, v[102:105] offset:1536
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[39:46], v[73:80], v[1:8]
	v_lshl_add_u32 v39, s12, 5, v35
	ds_store_b128 v96, v[81:84]
	buffer_load_b128 v[81:84], v39, s[8:11], 0 offen
	v_lshl_add_u32 v39, s12, 17, v36
	s_delay_alu instid0(VALU_DEP_1)
	v_add_nc_u32_e32 v40, 0x8000, v39
	s_clause 0x1
	buffer_load_b128 v[85:88], v39, s[4:7], 0 offen slc
	buffer_load_b128 v[89:92], v40, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v40, 0x10000, v39
	v_add_nc_u32_e32 v39, 0x18000, v39
	s_clause 0x1
	buffer_load_b128 v[98:101], v40, s[4:7], 0 offen slc
	buffer_load_b128 v[102:105], v39, s[4:7], 0 offen slc
	ds_load_b128 v[39:42], v95
	ds_load_b128 v[43:46], v95 offset:16
	ds_load_u16_d16_hi v49, v94 offset:128
	ds_load_u16_d16 v49, v94
	ds_load_u16_d16 v57, v94 offset:32
	ds_load_u16_d16 v50, v94 offset:256
	ds_load_u16_d16_hi v50, v94 offset:384
	ds_load_u16_d16 v51, v94 offset:512
	ds_load_u16_d16_hi v51, v94 offset:640
	ds_load_u16_d16 v52, v94 offset:768
	ds_load_u16_d16_hi v52, v94 offset:896
	ds_load_u16_d16 v53, v94 offset:1024
	ds_load_u16_d16_hi v53, v94 offset:1152
	ds_load_u16_d16 v54, v94 offset:1280
	ds_load_u16_d16_hi v54, v94 offset:1408
	ds_load_u16_d16 v55, v94 offset:1536
	ds_load_u16_d16_hi v55, v94 offset:1664
	ds_load_u16_d16 v56, v94 offset:1792
	ds_load_u16_d16_hi v56, v94 offset:1920
	ds_load_u16_d16_hi v57, v94 offset:160
	ds_load_u16_d16 v58, v94 offset:288
	ds_load_u16_d16_hi v58, v94 offset:416
	ds_load_u16_d16 v59, v94 offset:544
	ds_load_u16_d16_hi v59, v94 offset:672
	ds_load_u16_d16 v60, v94 offset:800
	ds_load_u16_d16_hi v60, v94 offset:928
	ds_load_u16_d16 v61, v94 offset:1056
	ds_load_u16_d16_hi v61, v94 offset:1184
	ds_load_u16_d16 v62, v94 offset:1312
	ds_load_u16_d16_hi v62, v94 offset:1440
	ds_load_u16_d16 v63, v94 offset:1568
	ds_load_u16_d16_hi v63, v94 offset:1696
	ds_load_u16_d16 v64, v94 offset:1824
	ds_load_u16_d16_hi v64, v94 offset:1952
	ds_load_u16_d16 v65, v94 offset:64
	ds_load_u16_d16_hi v65, v94 offset:192
	ds_load_u16_d16 v66, v94 offset:320
	ds_load_u16_d16_hi v66, v94 offset:448
	ds_load_u16_d16 v67, v94 offset:576
	ds_load_u16_d16_hi v67, v94 offset:704
	ds_load_u16_d16 v68, v94 offset:832
	ds_load_u16_d16_hi v68, v94 offset:960
	ds_load_u16_d16 v69, v94 offset:1088
	ds_load_u16_d16_hi v69, v94 offset:1216
	ds_load_u16_d16 v70, v94 offset:1344
	ds_load_u16_d16_hi v70, v94 offset:1472
	ds_load_u16_d16 v71, v94 offset:1600
	ds_load_u16_d16_hi v71, v94 offset:1728
	ds_load_u16_d16 v72, v94 offset:1856
	ds_load_u16_d16_hi v72, v94 offset:1984
	ds_load_u16_d16 v73, v94 offset:96
	ds_load_u16_d16_hi v73, v94 offset:224
	ds_load_u16_d16 v74, v94 offset:352
	ds_load_u16_d16_hi v74, v94 offset:480
	ds_load_u16_d16 v75, v94 offset:608
	ds_load_u16_d16_hi v75, v94 offset:736
	ds_load_u16_d16 v76, v94 offset:864
	ds_load_u16_d16_hi v76, v94 offset:992
	ds_load_u16_d16 v77, v94 offset:1120
	ds_load_u16_d16_hi v77, v94 offset:1248
	ds_load_u16_d16 v78, v94 offset:1376
	ds_load_u16_d16_hi v78, v94 offset:1504
	ds_load_u16_d16 v79, v94 offset:1632
	ds_load_u16_d16_hi v79, v94 offset:1760
	ds_load_u16_d16 v80, v94 offset:1888
	ds_load_u16_d16_hi v80, v94 offset:2016
	s_waitcnt lgkmcnt(47)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[39:46], v[49:56], v[9:16]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[39:46], v[57:64], v[25:32]
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[39:46], v[65:72], v[17:24]
	s_waitcnt vmcnt(4)
	ds_store_b128 v96, v[81:84]
	s_waitcnt vmcnt(3)
	ds_store_b128 v97, v[85:88]
	s_waitcnt vmcnt(2)
	ds_store_b128 v97, v[89:92] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v97, v[98:101] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v97, v[102:105] offset:1536
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[39:46], v[73:80], v[1:8]
	s_cbranch_scc1 .LBB0_1
	v_add_nc_u32_e32 v34, 0x1ff0000, v34
	s_mov_b32 s6, s10
	s_mov_b32 s7, s11
	v_lshlrev_b32_e32 v0, 8, v0
	ds_load_u16_d16 v46, v94 offset:1280
	ds_load_u16_d16_hi v46, v94 offset:1408
	ds_load_u16_d16 v54, v94 offset:1312
	ds_load_u16_d16_hi v54, v94 offset:1440
	ds_load_u16_d16 v62, v94 offset:1344
	ds_load_u16_d16_hi v62, v94 offset:1472
	ds_load_u16_d16_hi v70, v94 offset:1504
	ds_load_u16_d16 v70, v94 offset:1376
	v_add_lshl_u32 v33, v34, v33, 1
	v_add_nc_u32_e32 v34, 0x3000, v35
	ds_load_u16_d16 v47, v94 offset:1536
	ds_load_u16_d16_hi v47, v94 offset:1664
	ds_load_u16_d16 v55, v94 offset:1568
	ds_load_u16_d16_hi v55, v94 offset:1696
	ds_load_u16_d16 v63, v94 offset:1600
	ds_load_u16_d16_hi v63, v94 offset:1728
	ds_load_u16_d16_hi v71, v94 offset:1760
	ds_load_u16_d16 v71, v94 offset:1632
	v_and_b32_e32 v0, 0x1000, v0
	s_load_b64 s[0:1], s[0:1], 0x30
	v_add_nc_u32_e32 v35, 0x8000, v33
	v_add_nc_u32_e32 v36, 0x10000, v33
	v_add_nc_u32_e32 v37, 0x18000, v33
	buffer_load_b128 v[73:76], v34, s[8:11], 0 offen offset:4064
	s_clause 0x3
	buffer_load_b128 v[77:80], v33, s[4:7], 0 offen slc
	buffer_load_b128 v[81:84], v35, s[4:7], 0 offen slc
	buffer_load_b128 v[85:88], v36, s[4:7], 0 offen slc
	buffer_load_b128 v[89:92], v37, s[4:7], 0 offen slc
	s_ashr_i32 s4, s2, 31
	ds_load_b128 v[33:36], v95
	ds_load_b128 v[37:40], v95 offset:16
	ds_load_u16_d16_hi v41, v94 offset:128
	ds_load_u16_d16 v41, v94
	ds_load_u16_d16 v49, v94 offset:32
	ds_load_u16_d16_hi v49, v94 offset:160
	ds_load_u16_d16 v57, v94 offset:64
	ds_load_u16_d16_hi v57, v94 offset:192
	ds_load_u16_d16_hi v65, v94 offset:224
	ds_load_u16_d16 v65, v94 offset:96
	ds_load_u16_d16 v42, v94 offset:256
	ds_load_u16_d16_hi v42, v94 offset:384
	ds_load_u16_d16 v50, v94 offset:288
	ds_load_u16_d16_hi v50, v94 offset:416
	ds_load_u16_d16 v58, v94 offset:320
	ds_load_u16_d16_hi v58, v94 offset:448
	ds_load_u16_d16_hi v66, v94 offset:480
	ds_load_u16_d16 v66, v94 offset:352
	ds_load_u16_d16 v43, v94 offset:512
	ds_load_u16_d16_hi v43, v94 offset:640
	ds_load_u16_d16 v51, v94 offset:544
	ds_load_u16_d16_hi v51, v94 offset:672
	ds_load_u16_d16 v59, v94 offset:576
	ds_load_u16_d16_hi v59, v94 offset:704
	ds_load_u16_d16_hi v67, v94 offset:736
	ds_load_u16_d16 v67, v94 offset:608
	ds_load_u16_d16 v44, v94 offset:768
	ds_load_u16_d16_hi v44, v94 offset:896
	ds_load_u16_d16 v52, v94 offset:800
	ds_load_u16_d16_hi v52, v94 offset:928
	ds_load_u16_d16 v60, v94 offset:832
	ds_load_u16_d16_hi v60, v94 offset:960
	ds_load_u16_d16_hi v68, v94 offset:992
	ds_load_u16_d16 v68, v94 offset:864
	ds_load_u16_d16 v45, v94 offset:1024
	ds_load_u16_d16_hi v45, v94 offset:1152
	ds_load_u16_d16 v53, v94 offset:1056
	ds_load_u16_d16_hi v53, v94 offset:1184
	ds_load_u16_d16 v61, v94 offset:1088
	ds_load_u16_d16_hi v61, v94 offset:1216
	ds_load_u16_d16_hi v69, v94 offset:1248
	ds_load_u16_d16 v69, v94 offset:1120
	s_lshr_b32 s4, s4, 27
	s_mov_b32 s3, 0x21027000
	s_add_i32 s4, s2, s4
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s4, s4, 0xffffe0
	s_sub_i32 s2, s2, s4
	s_delay_alu instid0(SALU_CYCLE_1)
	v_lshl_or_b32 v98, s2, 7, v48
	ds_load_u16_d16 v48, v94 offset:1792
	ds_load_u16_d16_hi v48, v94 offset:1920
	ds_load_u16_d16 v56, v94 offset:1824
	ds_load_u16_d16_hi v56, v94 offset:1952
	ds_load_u16_d16 v64, v94 offset:1856
	ds_load_u16_d16_hi v64, v94 offset:1984
	ds_load_u16_d16_hi v72, v94 offset:2016
	ds_load_u16_d16 v72, v94 offset:1888
	s_mov_b32 s2, -1
	v_add_lshl_u32 v0, v98, v0, 1
	s_waitcnt lgkmcnt(0)
	s_and_b32 s1, s1, 0xffff
	s_waitcnt vmcnt(4)
	ds_store_b128 v96, v[73:76]
	s_waitcnt vmcnt(3)
	ds_store_b128 v97, v[77:80]
	s_waitcnt vmcnt(2)
	ds_store_b128 v97, v[81:84] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v97, v[85:88] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v97, v[89:92] offset:1536
	ds_load_b128 v[73:76], v95
	ds_load_b128 v[77:80], v95 offset:16
	ds_load_u16_d16_hi v81, v94 offset:128
	ds_load_u16_d16 v81, v94
	ds_load_u16_d16 v95, v94 offset:32
	ds_load_u16_d16_hi v95, v94 offset:160
	ds_load_u16_d16 v103, v94 offset:64
	ds_load_u16_d16_hi v103, v94 offset:192
	ds_load_u16_d16_hi v111, v94 offset:224
	ds_load_u16_d16 v111, v94 offset:96
	ds_load_u16_d16 v82, v94 offset:256
	ds_load_u16_d16_hi v82, v94 offset:384
	ds_load_u16_d16 v96, v94 offset:288
	ds_load_u16_d16_hi v96, v94 offset:416
	ds_load_u16_d16 v104, v94 offset:320
	ds_load_u16_d16_hi v104, v94 offset:448
	ds_load_u16_d16_hi v112, v94 offset:480
	ds_load_u16_d16 v112, v94 offset:352
	ds_load_u16_d16 v83, v94 offset:512
	ds_load_u16_d16_hi v83, v94 offset:640
	ds_load_u16_d16 v97, v94 offset:544
	ds_load_u16_d16_hi v97, v94 offset:672
	ds_load_u16_d16 v105, v94 offset:576
	ds_load_u16_d16_hi v105, v94 offset:704
	ds_load_u16_d16_hi v113, v94 offset:736
	ds_load_u16_d16 v113, v94 offset:608
	ds_load_u16_d16 v84, v94 offset:768
	ds_load_u16_d16_hi v84, v94 offset:896
	ds_load_u16_d16 v98, v94 offset:800
	ds_load_u16_d16_hi v98, v94 offset:928
	ds_load_u16_d16 v106, v94 offset:832
	ds_load_u16_d16_hi v106, v94 offset:960
	ds_load_u16_d16_hi v114, v94 offset:992
	ds_load_u16_d16 v114, v94 offset:864
	ds_load_u16_d16 v85, v94 offset:1024
	ds_load_u16_d16_hi v85, v94 offset:1152
	ds_load_u16_d16 v99, v94 offset:1056
	ds_load_u16_d16_hi v99, v94 offset:1184
	ds_load_u16_d16 v107, v94 offset:1088
	ds_load_u16_d16_hi v107, v94 offset:1216
	ds_load_u16_d16_hi v115, v94 offset:1248
	ds_load_u16_d16 v115, v94 offset:1120
	ds_load_u16_d16 v86, v94 offset:1280
	ds_load_u16_d16_hi v86, v94 offset:1408
	ds_load_u16_d16 v100, v94 offset:1312
	ds_load_u16_d16_hi v100, v94 offset:1440
	ds_load_u16_d16 v108, v94 offset:1344
	ds_load_u16_d16_hi v108, v94 offset:1472
	ds_load_u16_d16_hi v116, v94 offset:1504
	ds_load_u16_d16 v116, v94 offset:1376
	ds_load_u16_d16 v87, v94 offset:1536
	ds_load_u16_d16_hi v87, v94 offset:1664
	ds_load_u16_d16 v101, v94 offset:1568
	ds_load_u16_d16_hi v101, v94 offset:1696
	ds_load_u16_d16 v109, v94 offset:1600
	ds_load_u16_d16_hi v109, v94 offset:1728
	ds_load_u16_d16_hi v117, v94 offset:1760
	ds_load_u16_d16 v117, v94 offset:1632
	ds_load_u16_d16 v88, v94 offset:1792
	ds_load_u16_d16_hi v88, v94 offset:1920
	ds_load_u16_d16 v102, v94 offset:1824
	ds_load_u16_d16_hi v102, v94 offset:1952
	ds_load_u16_d16 v110, v94 offset:1856
	ds_load_u16_d16_hi v110, v94 offset:1984
	ds_load_u16_d16_hi v118, v94 offset:2016
	ds_load_u16_d16 v118, v94 offset:1888
	v_wmma_f32_16x16x16_bf16 v[9:16], v[33:40], v[41:48], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[33:40], v[49:56], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[33:40], v[57:64], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[33:40], v[65:72], v[1:8]
	v_lshl_add_u32 v0, v93, 7, v0
	s_waitcnt lgkmcnt(6)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[73:80], v[81:88], v[9:16]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[73:80], v[95:102], v[25:32]
	s_waitcnt lgkmcnt(2)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[73:80], v[103:110], v[17:24]
	v_bfe_u32 v40, v9, 16, 1
	v_or_b32_e32 v41, 0x400000, v9
	v_bfe_u32 v42, v10, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_or_b32_e32 v43, 0x400000, v10
	v_add3_u32 v40, v40, v9, 0x7fff
	v_bfe_u32 v44, v11, 16, 1
	v_add3_u32 v42, v42, v10, 0x7fff
	v_or_b32_e32 v45, 0x400000, v11
	v_bfe_u32 v46, v12, 16, 1
	v_cndmask_b32_e32 v9, v40, v41, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_add_nc_u32_e32 v33, 0x4000, v0
	v_add3_u32 v44, v44, v11, 0x7fff
	v_or_b32_e32 v47, 0x400000, v12
	v_bfe_u32 v48, v13, 16, 1
	v_cndmask_b32_e32 v10, v42, v43, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_add3_u32 v46, v46, v12, 0x7fff
	v_or_b32_e32 v49, 0x400000, v13
	v_bfe_u32 v50, v14, 16, 1
	v_add3_u32 v48, v48, v13, 0x7fff
	v_cndmask_b32_e32 v11, v44, v45, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_add_nc_u32_e32 v35, 0xc000, v0
	v_or_b32_e32 v51, 0x400000, v14
	v_bfe_u32 v52, v15, 16, 1
	v_add3_u32 v50, v50, v14, 0x7fff
	v_cndmask_b32_e32 v12, v46, v47, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_add_nc_u32_e32 v34, 0x8000, v0
	v_or_b32_e32 v53, 0x400000, v15
	v_bfe_u32 v54, v16, 16, 1
	v_add3_u32 v52, v52, v15, 0x7fff
	v_cndmask_b32_e32 v13, v48, v49, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_add_nc_u32_e32 v37, 0x14000, v0
	v_or_b32_e32 v55, 0x400000, v16
	v_bfe_u32 v56, v25, 16, 1
	v_add3_u32 v54, v54, v16, 0x7fff
	v_cndmask_b32_e32 v14, v50, v51, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_add_nc_u32_e32 v36, 0x10000, v0
	v_or_b32_e32 v57, 0x400000, v25
	v_bfe_u32 v58, v26, 16, 1
	v_add3_u32 v56, v56, v25, 0x7fff
	v_cndmask_b32_e32 v15, v52, v53, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	v_add_nc_u32_e32 v39, 0x1c000, v0
	v_or_b32_e32 v59, 0x400000, v26
	v_bfe_u32 v60, v27, 16, 1
	v_add3_u32 v58, v58, v26, 0x7fff
	v_cndmask_b32_e32 v16, v54, v55, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v25, v25
	v_add_nc_u32_e32 v38, 0x18000, v0
	v_or_b32_e32 v61, 0x400000, v27
	v_bfe_u32 v62, v28, 16, 1
	v_add3_u32 v60, v60, v27, 0x7fff
	v_cndmask_b32_e32 v25, v56, v57, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v26, v26
	v_or_b32_e32 v63, 0x400000, v28
	v_bfe_u32 v64, v29, 16, 1
	v_add3_u32 v62, v62, v28, 0x7fff
	v_or_b32_e32 v65, 0x400000, v29
	v_cndmask_b32_e32 v26, v58, v59, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v27, v27
	v_bfe_u32 v66, v30, 16, 1
	v_add3_u32 v64, v64, v29, 0x7fff
	v_or_b32_e32 v67, 0x400000, v30
	v_bfe_u32 v68, v31, 16, 1
	v_cndmask_b32_e32 v27, v60, v61, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v28, v28
	v_add3_u32 v66, v66, v30, 0x7fff
	v_or_b32_e32 v69, 0x400000, v31
	v_bfe_u32 v70, v32, 16, 1
	v_add3_u32 v68, v68, v31, 0x7fff
	v_cndmask_b32_e32 v28, v62, v63, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v29, v29
	v_or_b32_e32 v71, 0x400000, v32
	v_bfe_u32 v72, v17, 16, 1
	v_add3_u32 v70, v70, v32, 0x7fff
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[73:80], v[111:118], v[1:8]
	v_cndmask_b32_e32 v29, v64, v65, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v30, v30
	v_or_b32_e32 v73, 0x400000, v17
	v_bfe_u32 v74, v18, 16, 1
	v_add3_u32 v72, v72, v17, 0x7fff
	v_or_b32_e32 v75, 0x400000, v18
	v_cndmask_b32_e32 v30, v66, v67, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v31, v31
	v_bfe_u32 v76, v19, 16, 1
	v_add3_u32 v74, v74, v18, 0x7fff
	v_or_b32_e32 v77, 0x400000, v19
	v_bfe_u32 v78, v20, 16, 1
	v_cndmask_b32_e32 v31, v68, v69, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v32, v32
	v_add3_u32 v76, v76, v19, 0x7fff
	v_or_b32_e32 v79, 0x400000, v20
	v_bfe_u32 v80, v21, 16, 1
	v_add3_u32 v78, v78, v20, 0x7fff
	v_cndmask_b32_e32 v32, v70, v71, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v17, v17
	v_or_b32_e32 v81, 0x400000, v21
	v_bfe_u32 v82, v22, 16, 1
	v_add3_u32 v80, v80, v21, 0x7fff
	v_or_b32_e32 v83, 0x400000, v22
	v_cndmask_b32_e32 v17, v72, v73, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v18, v18
	v_bfe_u32 v84, v23, 16, 1
	v_add3_u32 v82, v82, v22, 0x7fff
	v_or_b32_e32 v85, 0x400000, v23
	v_bfe_u32 v86, v24, 16, 1
	v_cndmask_b32_e32 v18, v74, v75, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v19, v19
	v_add3_u32 v84, v84, v23, 0x7fff
	v_or_b32_e32 v87, 0x400000, v24
	v_bfe_u32 v88, v1, 16, 1
	v_add3_u32 v86, v86, v24, 0x7fff
	v_cndmask_b32_e32 v19, v76, v77, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v20, v20
	v_or_b32_e32 v89, 0x400000, v1
	v_bfe_u32 v90, v2, 16, 1
	v_add3_u32 v88, v88, v1, 0x7fff
	v_or_b32_e32 v91, 0x400000, v2
	v_cndmask_b32_e32 v20, v78, v79, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v21, v21
	v_bfe_u32 v92, v3, 16, 1
	v_add3_u32 v90, v90, v2, 0x7fff
	v_or_b32_e32 v93, 0x400000, v3
	v_bfe_u32 v94, v4, 16, 1
	v_cndmask_b32_e32 v21, v80, v81, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v22, v22
	v_add3_u32 v92, v92, v3, 0x7fff
	v_or_b32_e32 v95, 0x400000, v4
	v_bfe_u32 v96, v5, 16, 1
	v_add3_u32 v94, v94, v4, 0x7fff
	v_cndmask_b32_e32 v22, v82, v83, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v23, v23
	v_or_b32_e32 v97, 0x400000, v5
	v_bfe_u32 v98, v6, 16, 1
	v_add3_u32 v96, v96, v5, 0x7fff
	v_or_b32_e32 v99, 0x400000, v6
	v_cndmask_b32_e32 v23, v84, v85, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v24, v24
	v_bfe_u32 v100, v7, 16, 1
	v_add3_u32 v98, v98, v6, 0x7fff
	v_or_b32_e32 v101, 0x400000, v7
	v_bfe_u32 v102, v8, 16, 1
	v_cndmask_b32_e32 v24, v86, v87, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	v_add3_u32 v100, v100, v7, 0x7fff
	v_or_b32_e32 v103, 0x400000, v8
	v_add3_u32 v102, v102, v8, 0x7fff
	v_lshrrev_b32_e32 v9, 16, v9
	v_cndmask_b32_e32 v1, v88, v89, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_lshrrev_b32_e32 v10, 16, v10
	v_lshrrev_b32_e32 v11, 16, v11
	v_lshrrev_b32_e32 v12, 16, v12
	v_lshrrev_b32_e32 v13, 16, v13
	v_cndmask_b32_e32 v2, v90, v91, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_lshrrev_b32_e32 v14, 16, v14
	v_lshrrev_b32_e32 v15, 16, v15
	v_lshrrev_b32_e32 v16, 16, v16
	v_lshrrev_b32_e32 v25, 16, v25
	v_cndmask_b32_e32 v3, v92, v93, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_lshrrev_b32_e32 v26, 16, v26
	v_lshrrev_b32_e32 v27, 16, v27
	v_lshrrev_b32_e32 v28, 16, v28
	v_lshrrev_b32_e32 v29, 16, v29
	v_cndmask_b32_e32 v4, v94, v95, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_lshrrev_b32_e32 v30, 16, v30
	v_lshrrev_b32_e32 v31, 16, v31
	v_lshrrev_b32_e32 v32, 16, v32
	v_lshrrev_b32_e32 v17, 16, v17
	v_cndmask_b32_e32 v5, v96, v97, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_lshrrev_b32_e32 v18, 16, v18
	v_lshrrev_b32_e32 v19, 16, v19
	v_lshrrev_b32_e32 v20, 16, v20
	v_lshrrev_b32_e32 v21, 16, v21
	v_cndmask_b32_e32 v6, v98, v99, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_lshrrev_b32_e32 v22, 16, v22
	v_lshrrev_b32_e32 v23, 16, v23
	v_lshrrev_b32_e32 v24, 16, v24
	v_lshrrev_b32_e32 v1, 16, v1
	v_cndmask_b32_e32 v7, v100, v101, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_lshrrev_b32_e32 v2, 16, v2
	v_lshrrev_b32_e32 v3, 16, v3
	v_lshrrev_b32_e32 v4, 16, v4
	v_lshrrev_b32_e32 v5, 16, v5
	v_cndmask_b32_e32 v8, v102, v103, vcc_lo
	v_lshrrev_b32_e32 v6, 16, v6
	v_lshrrev_b32_e32 v7, 16, v7
	s_delay_alu instid0(VALU_DEP_3)
	v_lshrrev_b32_e32 v8, 16, v8
	s_clause 0x1f
	buffer_store_b16 v9, v0, s[0:3], 0 offen
	buffer_store_b16 v10, v33, s[0:3], 0 offen
	buffer_store_b16 v11, v34, s[0:3], 0 offen
	buffer_store_b16 v12, v35, s[0:3], 0 offen
	buffer_store_b16 v13, v36, s[0:3], 0 offen
	buffer_store_b16 v14, v37, s[0:3], 0 offen
	buffer_store_b16 v15, v38, s[0:3], 0 offen
	buffer_store_b16 v16, v39, s[0:3], 0 offen
	buffer_store_b16 v25, v0, s[0:3], 0 offen offset:32
	buffer_store_b16 v26, v33, s[0:3], 0 offen offset:32
	buffer_store_b16 v27, v34, s[0:3], 0 offen offset:32
	buffer_store_b16 v28, v35, s[0:3], 0 offen offset:32
	buffer_store_b16 v29, v36, s[0:3], 0 offen offset:32
	buffer_store_b16 v30, v37, s[0:3], 0 offen offset:32
	buffer_store_b16 v31, v38, s[0:3], 0 offen offset:32
	buffer_store_b16 v32, v39, s[0:3], 0 offen offset:32
	buffer_store_b16 v17, v0, s[0:3], 0 offen offset:64
	buffer_store_b16 v18, v33, s[0:3], 0 offen offset:64
	buffer_store_b16 v19, v34, s[0:3], 0 offen offset:64
	buffer_store_b16 v20, v35, s[0:3], 0 offen offset:64
	buffer_store_b16 v21, v36, s[0:3], 0 offen offset:64
	buffer_store_b16 v22, v37, s[0:3], 0 offen offset:64
	buffer_store_b16 v23, v38, s[0:3], 0 offen offset:64
	buffer_store_b16 v24, v39, s[0:3], 0 offen offset:64
	buffer_store_b16 v1, v0, s[0:3], 0 offen offset:96
	buffer_store_b16 v2, v33, s[0:3], 0 offen offset:96
	buffer_store_b16 v3, v34, s[0:3], 0 offen offset:96
	buffer_store_b16 v4, v35, s[0:3], 0 offen offset:96
	buffer_store_b16 v5, v36, s[0:3], 0 offen offset:96
	buffer_store_b16 v6, v37, s[0:3], 0 offen offset:96
	buffer_store_b16 v7, v38, s[0:3], 0 offen offset:96
	buffer_store_b16 v8, v39, s[0:3], 0 offen offset:96
	s_nop 0
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
	s_endpgm
.Lfunc_end0:
	.size	_matmul_bf16_0, .Lfunc_end0-_matmul_bf16_0
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _matmul_bf16_0
		.amdhsa_group_segment_fixed_size 5632
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
		.amdhsa_system_sgpr_workgroup_id_y 0
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 119
		.amdhsa_next_free_sgpr 14
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

	.set .L_matmul_bf16_0.num_vgpr, 119
	.set .L_matmul_bf16_0.num_agpr, 0
	.set .L_matmul_bf16_0.numbered_sgpr, 14
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
    .group_segment_fixed_size: 5632
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 64
    .name:           _matmul_bf16_0
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 64
      - 1
      - 1
    .sgpr_count:     16
    .sgpr_spill_count: 0
    .symbol:         _matmul_bf16_0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     119
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
