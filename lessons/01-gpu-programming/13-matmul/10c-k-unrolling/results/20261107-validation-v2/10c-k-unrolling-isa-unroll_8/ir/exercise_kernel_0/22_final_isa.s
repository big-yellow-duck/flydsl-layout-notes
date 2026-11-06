	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	exercise_kernel_0
	.p2align	8
	.type	exercise_kernel_0,@function
exercise_kernel_0:
	v_lshrrev_b32_e32 v7, 5, v0
	s_lshl_b32 s3, s2, 1
	s_bfe_i32 s2, s2, 0x1001e
	s_clause 0x1
	s_load_b64 s[8:9], s[0:1], 0x0
	s_load_b64 s[4:5], s[0:1], 0x18
	s_lshr_b32 s2, s2, 26
	v_or_b32_e32 v1, s3, v7
	v_bfe_u32 v40, v0, 3, 2
	v_bfe_u32 v47, v0, 1, 4
	s_mov_b32 s10, -1
	s_mov_b32 s11, 0x21027000
	v_dual_mov_b32 v25, 0 :: v_dual_add_nc_u32 v2, s2, v1
	v_lshlrev_b32_e32 v3, 3, v0
	s_mov_b32 s6, s10
	s_mov_b32 s7, s11
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_dual_mov_b32 v27, v25 :: v_dual_and_b32 v2, 0xffffffc0, v2
	v_mov_b32_e32 v26, v25
	v_dual_mov_b32 v29, v25 :: v_dual_and_b32 v38, 56, v3
	v_sub_nc_u32_e32 v39, v1, v2
	v_dual_mov_b32 v28, v25 :: v_dual_lshlrev_b32 v1, 4, v0
	s_delay_alu instid0(VALU_DEP_3)
	v_lshl_or_b32 v41, v40, 12, v38
	s_waitcnt lgkmcnt(0)
	s_and_b32 s9, s9, 0xffff
	v_dual_mov_b32 v31, v25 :: v_dual_lshlrev_b32 v42, 6, v39
	v_dual_mov_b32 v17, v25 :: v_dual_and_b32 v46, 16, v1
	s_and_b32 s5, s5, 0xffff
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_add_lshl_u32 v1, v42, v41, 1
	v_mul_u32_u24_e32 v45, 0x300, v7
	v_lshl_or_b32 v43, v47, 14, v46
	v_dual_mov_b32 v32, v25 :: v_dual_and_b32 v37, 15, v0
	s_delay_alu instid0(VALU_DEP_4)
	v_dual_mov_b32 v19, v25 :: v_dual_add_nc_u32 v2, 0x8000, v1
	v_dual_mov_b32 v30, v25 :: v_dual_add_nc_u32 v3, 0x10000, v1
	v_dual_mov_b32 v21, v25 :: v_dual_add_nc_u32 v4, 0x18000, v1
	buffer_load_b128 v[33:36], v43, s[8:11], 0 offen
	s_clause 0x3
	buffer_load_b128 v[48:51], v1, s[4:7], 0 offen slc
	buffer_load_b128 v[52:55], v2, s[4:7], 0 offen slc
	buffer_load_b128 v[56:59], v3, s[4:7], 0 offen slc
	buffer_load_b128 v[60:63], v4, s[4:7], 0 offen slc
	v_dual_mov_b32 v18, v25 :: v_dual_lshlrev_b32 v65, 11, v7
	v_dual_mov_b32 v11, v25 :: v_dual_lshlrev_b32 v68, 7, v39
	v_or_b32_e32 v66, 0x1000, v45
	v_dual_mov_b32 v23, v25 :: v_dual_and_b32 v64, 7, v0
	s_delay_alu instid0(VALU_DEP_4)
	v_lshl_or_b32 v45, v38, 1, v65
	v_mul_u32_u24_e32 v67, 48, v47
	v_lshl_or_b32 v38, v37, 1, v65
	v_or_b32_e32 v65, v66, v46
	v_mad_u32_u24 v39, v37, 48, v66
	v_lshl_add_u32 v66, v40, 13, v68
	v_dual_mov_b32 v9, v25 :: v_dual_lshlrev_b32 v44, 7, v40
	v_mov_b32_e32 v20, v25
	v_mov_b32_e32 v22, v25
	v_mov_b32_e32 v24, v25
	v_mov_b32_e32 v10, v25
	v_mov_b32_e32 v12, v25
	v_mov_b32_e32 v13, v25
	v_mov_b32_e32 v14, v25
	v_mov_b32_e32 v15, v25
	v_mov_b32_e32 v16, v25
	v_mov_b32_e32 v1, v25
	v_mov_b32_e32 v2, v25
	v_mov_b32_e32 v3, v25
	v_mov_b32_e32 v4, v25
	v_mov_b32_e32 v5, v25
	v_mov_b32_e32 v6, v25
	v_mov_b32_e32 v7, v25
	v_mov_b32_e32 v8, v25
	v_or_b32_e32 v46, 0x80, v43
	v_mad_u32_u24 v68, v47, 48, v65
	v_add_nc_u32_e32 v40, v65, v67
	v_readfirstlane_b32 s12, v42
	v_lshl_or_b32 v47, v64, 4, v66
	v_or_b32_e32 v69, v45, v44
	s_mov_b32 s2, 0
	s_waitcnt vmcnt(4)
	ds_store_b128 v68, v[33:36]
	s_waitcnt vmcnt(3)
	ds_store_b128 v69, v[48:51]
	s_waitcnt vmcnt(2)
	ds_store_b128 v69, v[52:55] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v69, v[56:59] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v69, v[60:63] offset:1536
.LBB0_1:
	v_add_nc_u32_e32 v48, s2, v47
	v_add_nc_u32_e32 v33, 0xffffffa0, v46
	ds_load_b128 v[49:52], v39
	ds_load_b128 v[53:56], v39 offset:16
	ds_load_u16_d16_hi v57, v38 offset:128
	ds_load_u16_d16 v57, v38
	ds_load_u16_d16 v65, v38 offset:32
	ds_load_u16_d16 v58, v38 offset:256
	ds_load_u16_d16_hi v58, v38 offset:384
	ds_load_u16_d16 v59, v38 offset:512
	ds_load_u16_d16_hi v59, v38 offset:640
	ds_load_u16_d16 v60, v38 offset:768
	ds_load_u16_d16_hi v60, v38 offset:896
	ds_load_u16_d16 v61, v38 offset:1024
	ds_load_u16_d16_hi v61, v38 offset:1152
	ds_load_u16_d16 v62, v38 offset:1280
	ds_load_u16_d16_hi v62, v38 offset:1408
	ds_load_u16_d16 v63, v38 offset:1536
	ds_load_u16_d16_hi v63, v38 offset:1664
	ds_load_u16_d16 v64, v38 offset:1792
	ds_load_u16_d16_hi v64, v38 offset:1920
	ds_load_u16_d16_hi v65, v38 offset:160
	ds_load_u16_d16 v66, v38 offset:288
	ds_load_u16_d16_hi v66, v38 offset:416
	ds_load_u16_d16 v67, v38 offset:544
	ds_load_u16_d16_hi v67, v38 offset:672
	ds_load_u16_d16 v68, v38 offset:800
	ds_load_u16_d16_hi v68, v38 offset:928
	ds_load_u16_d16 v69, v38 offset:1056
	ds_load_u16_d16_hi v69, v38 offset:1184
	ds_load_u16_d16 v70, v38 offset:1312
	ds_load_u16_d16_hi v70, v38 offset:1440
	ds_load_u16_d16 v71, v38 offset:1568
	ds_load_u16_d16_hi v71, v38 offset:1696
	ds_load_u16_d16 v72, v38 offset:1824
	ds_load_u16_d16_hi v72, v38 offset:1952
	ds_load_u16_d16 v73, v38 offset:64
	ds_load_u16_d16_hi v73, v38 offset:192
	ds_load_u16_d16 v74, v38 offset:320
	ds_load_u16_d16_hi v74, v38 offset:448
	ds_load_u16_d16 v75, v38 offset:576
	ds_load_u16_d16_hi v75, v38 offset:704
	ds_load_u16_d16 v76, v38 offset:832
	ds_load_u16_d16_hi v76, v38 offset:960
	ds_load_u16_d16 v77, v38 offset:1088
	ds_load_u16_d16_hi v77, v38 offset:1216
	ds_load_u16_d16 v78, v38 offset:1344
	ds_load_u16_d16_hi v78, v38 offset:1472
	ds_load_u16_d16 v79, v38 offset:1600
	ds_load_u16_d16_hi v79, v38 offset:1728
	ds_load_u16_d16 v80, v38 offset:1856
	ds_load_u16_d16_hi v80, v38 offset:1984
	ds_load_u16_d16 v81, v38 offset:96
	ds_load_u16_d16_hi v81, v38 offset:224
	ds_load_u16_d16 v82, v38 offset:352
	ds_load_u16_d16_hi v82, v38 offset:480
	ds_load_u16_d16 v83, v38 offset:608
	ds_load_u16_d16_hi v83, v38 offset:736
	ds_load_u16_d16 v84, v38 offset:864
	ds_load_u16_d16_hi v84, v38 offset:992
	ds_load_u16_d16 v85, v38 offset:1120
	ds_load_u16_d16_hi v85, v38 offset:1248
	ds_load_u16_d16 v86, v38 offset:1376
	ds_load_u16_d16_hi v86, v38 offset:1504
	ds_load_u16_d16 v87, v38 offset:1632
	ds_load_u16_d16_hi v87, v38 offset:1760
	ds_load_u16_d16 v88, v38 offset:1888
	ds_load_u16_d16_hi v88, v38 offset:2016
	s_waitcnt lgkmcnt(47)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[49:56], v[57:64], v[25:32]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[49:56], v[65:72], v[17:24]
	v_add_nc_u32_e32 v42, 0x20000, v48
	buffer_load_b128 v[33:36], v33, s[8:11], 0 offen
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[49:56], v[73:80], v[9:16]
	s_add_i32 s2, s2, 0x100000
	s_delay_alu instid0(SALU_CYCLE_1)
	s_cmp_lg_u32 s2, 0x3f00000
	buffer_load_b128 v[89:92], v42, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v42, 0x28000, v48
	buffer_load_b128 v[93:96], v42, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v42, 0x30000, v48
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[49:56], v[81:88], v[1:8]
	buffer_load_b128 v[97:100], v42, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v42, 0x38000, v48
	v_add_nc_u32_e32 v49, 0x40000, v48
	buffer_load_b128 v[101:104], v42, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v42, v45, v44
	s_waitcnt vmcnt(3)
	ds_store_b128 v42, v[89:92]
	s_waitcnt vmcnt(2)
	ds_store_b128 v42, v[93:96] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v42, v[97:100] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v42, v[101:104] offset:1536
	ds_store_b128 v40, v[33:36]
	buffer_load_b128 v[89:92], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v49, 0x48000, v48
	v_subrev_nc_u32_e32 v33, 64, v46
	buffer_load_b128 v[93:96], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v49, 0x50000, v48
	buffer_load_b128 v[33:36], v33, s[8:11], 0 offen
	buffer_load_b128 v[97:100], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v49, 0x58000, v48
	buffer_load_b128 v[101:104], v49, s[4:7], 0 offen slc
	ds_load_b128 v[49:52], v39
	ds_load_b128 v[53:56], v39 offset:16
	ds_load_u16_d16_hi v57, v38 offset:128
	ds_load_u16_d16 v57, v38
	ds_load_u16_d16 v65, v38 offset:32
	ds_load_u16_d16 v58, v38 offset:256
	ds_load_u16_d16_hi v58, v38 offset:384
	ds_load_u16_d16 v59, v38 offset:512
	ds_load_u16_d16_hi v59, v38 offset:640
	ds_load_u16_d16 v60, v38 offset:768
	ds_load_u16_d16_hi v60, v38 offset:896
	ds_load_u16_d16 v61, v38 offset:1024
	ds_load_u16_d16_hi v61, v38 offset:1152
	ds_load_u16_d16 v62, v38 offset:1280
	ds_load_u16_d16_hi v62, v38 offset:1408
	ds_load_u16_d16 v63, v38 offset:1536
	ds_load_u16_d16_hi v63, v38 offset:1664
	ds_load_u16_d16 v64, v38 offset:1792
	ds_load_u16_d16_hi v64, v38 offset:1920
	ds_load_u16_d16_hi v65, v38 offset:160
	ds_load_u16_d16 v66, v38 offset:288
	ds_load_u16_d16_hi v66, v38 offset:416
	ds_load_u16_d16 v67, v38 offset:544
	ds_load_u16_d16_hi v67, v38 offset:672
	ds_load_u16_d16 v68, v38 offset:800
	ds_load_u16_d16_hi v68, v38 offset:928
	ds_load_u16_d16 v69, v38 offset:1056
	ds_load_u16_d16_hi v69, v38 offset:1184
	ds_load_u16_d16 v70, v38 offset:1312
	ds_load_u16_d16_hi v70, v38 offset:1440
	ds_load_u16_d16 v71, v38 offset:1568
	ds_load_u16_d16_hi v71, v38 offset:1696
	ds_load_u16_d16 v72, v38 offset:1824
	ds_load_u16_d16_hi v72, v38 offset:1952
	ds_load_u16_d16 v73, v38 offset:64
	ds_load_u16_d16_hi v73, v38 offset:192
	ds_load_u16_d16 v74, v38 offset:320
	ds_load_u16_d16_hi v74, v38 offset:448
	ds_load_u16_d16 v75, v38 offset:576
	ds_load_u16_d16_hi v75, v38 offset:704
	ds_load_u16_d16 v76, v38 offset:832
	ds_load_u16_d16_hi v76, v38 offset:960
	ds_load_u16_d16 v77, v38 offset:1088
	ds_load_u16_d16_hi v77, v38 offset:1216
	ds_load_u16_d16 v78, v38 offset:1344
	ds_load_u16_d16_hi v78, v38 offset:1472
	ds_load_u16_d16 v79, v38 offset:1600
	ds_load_u16_d16_hi v79, v38 offset:1728
	ds_load_u16_d16 v80, v38 offset:1856
	ds_load_u16_d16_hi v80, v38 offset:1984
	ds_load_u16_d16 v81, v38 offset:96
	ds_load_u16_d16_hi v81, v38 offset:224
	ds_load_u16_d16 v82, v38 offset:352
	ds_load_u16_d16_hi v82, v38 offset:480
	ds_load_u16_d16 v83, v38 offset:608
	ds_load_u16_d16_hi v83, v38 offset:736
	ds_load_u16_d16 v84, v38 offset:864
	ds_load_u16_d16_hi v84, v38 offset:992
	ds_load_u16_d16 v85, v38 offset:1120
	ds_load_u16_d16_hi v85, v38 offset:1248
	ds_load_u16_d16 v86, v38 offset:1376
	ds_load_u16_d16_hi v86, v38 offset:1504
	ds_load_u16_d16 v87, v38 offset:1632
	ds_load_u16_d16_hi v87, v38 offset:1760
	ds_load_u16_d16 v88, v38 offset:1888
	ds_load_u16_d16_hi v88, v38 offset:2016
	s_waitcnt lgkmcnt(47)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[49:56], v[57:64], v[25:32]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[49:56], v[65:72], v[17:24]
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[49:56], v[73:80], v[9:16]
	s_waitcnt vmcnt(2)
	ds_store_b128 v40, v[33:36]
	ds_store_b128 v42, v[89:92]
	ds_store_b128 v42, v[93:96] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v42, v[97:100] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v42, v[101:104] offset:1536
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[49:56], v[81:88], v[1:8]
	v_add_nc_u32_e32 v49, 0x60000, v48
	v_subrev_nc_u32_e32 v33, 32, v46
	buffer_load_b128 v[89:92], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v49, 0x68000, v48
	buffer_load_b128 v[33:36], v33, s[8:11], 0 offen
	buffer_load_b128 v[93:96], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v49, 0x70000, v48
	buffer_load_b128 v[97:100], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v49, 0x78000, v48
	buffer_load_b128 v[101:104], v49, s[4:7], 0 offen slc
	ds_load_b128 v[49:52], v39
	ds_load_b128 v[53:56], v39 offset:16
	ds_load_u16_d16_hi v57, v38 offset:128
	ds_load_u16_d16 v57, v38
	ds_load_u16_d16 v65, v38 offset:32
	ds_load_u16_d16 v58, v38 offset:256
	ds_load_u16_d16_hi v58, v38 offset:384
	ds_load_u16_d16 v59, v38 offset:512
	ds_load_u16_d16_hi v59, v38 offset:640
	ds_load_u16_d16 v60, v38 offset:768
	ds_load_u16_d16_hi v60, v38 offset:896
	ds_load_u16_d16 v61, v38 offset:1024
	ds_load_u16_d16_hi v61, v38 offset:1152
	ds_load_u16_d16 v62, v38 offset:1280
	ds_load_u16_d16_hi v62, v38 offset:1408
	ds_load_u16_d16 v63, v38 offset:1536
	ds_load_u16_d16_hi v63, v38 offset:1664
	ds_load_u16_d16 v64, v38 offset:1792
	ds_load_u16_d16_hi v64, v38 offset:1920
	ds_load_u16_d16_hi v65, v38 offset:160
	ds_load_u16_d16 v66, v38 offset:288
	ds_load_u16_d16_hi v66, v38 offset:416
	ds_load_u16_d16 v67, v38 offset:544
	ds_load_u16_d16_hi v67, v38 offset:672
	ds_load_u16_d16 v68, v38 offset:800
	ds_load_u16_d16_hi v68, v38 offset:928
	ds_load_u16_d16 v69, v38 offset:1056
	ds_load_u16_d16_hi v69, v38 offset:1184
	ds_load_u16_d16 v70, v38 offset:1312
	ds_load_u16_d16_hi v70, v38 offset:1440
	ds_load_u16_d16 v71, v38 offset:1568
	ds_load_u16_d16_hi v71, v38 offset:1696
	ds_load_u16_d16 v72, v38 offset:1824
	ds_load_u16_d16_hi v72, v38 offset:1952
	ds_load_u16_d16 v73, v38 offset:64
	ds_load_u16_d16_hi v73, v38 offset:192
	ds_load_u16_d16 v74, v38 offset:320
	ds_load_u16_d16_hi v74, v38 offset:448
	ds_load_u16_d16 v75, v38 offset:576
	ds_load_u16_d16_hi v75, v38 offset:704
	ds_load_u16_d16 v76, v38 offset:832
	ds_load_u16_d16_hi v76, v38 offset:960
	ds_load_u16_d16 v77, v38 offset:1088
	ds_load_u16_d16_hi v77, v38 offset:1216
	ds_load_u16_d16 v78, v38 offset:1344
	ds_load_u16_d16_hi v78, v38 offset:1472
	ds_load_u16_d16 v79, v38 offset:1600
	ds_load_u16_d16_hi v79, v38 offset:1728
	ds_load_u16_d16 v80, v38 offset:1856
	ds_load_u16_d16_hi v80, v38 offset:1984
	ds_load_u16_d16 v81, v38 offset:96
	ds_load_u16_d16_hi v81, v38 offset:224
	ds_load_u16_d16 v82, v38 offset:352
	ds_load_u16_d16_hi v82, v38 offset:480
	ds_load_u16_d16 v83, v38 offset:608
	ds_load_u16_d16_hi v83, v38 offset:736
	ds_load_u16_d16 v84, v38 offset:864
	ds_load_u16_d16_hi v84, v38 offset:992
	ds_load_u16_d16 v85, v38 offset:1120
	ds_load_u16_d16_hi v85, v38 offset:1248
	ds_load_u16_d16 v86, v38 offset:1376
	ds_load_u16_d16_hi v86, v38 offset:1504
	ds_load_u16_d16 v87, v38 offset:1632
	ds_load_u16_d16_hi v87, v38 offset:1760
	ds_load_u16_d16 v88, v38 offset:1888
	ds_load_u16_d16_hi v88, v38 offset:2016
	s_waitcnt lgkmcnt(47)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[49:56], v[57:64], v[25:32]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[49:56], v[65:72], v[17:24]
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[49:56], v[73:80], v[9:16]
	s_waitcnt vmcnt(3)
	ds_store_b128 v40, v[33:36]
	ds_store_b128 v42, v[89:92]
	s_waitcnt vmcnt(2)
	ds_store_b128 v42, v[93:96] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v42, v[97:100] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v42, v[101:104] offset:1536
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[49:56], v[81:88], v[1:8]
	v_add_nc_u32_e32 v49, 0x80000, v48
	buffer_load_b128 v[33:36], v46, s[8:11], 0 offen
	buffer_load_b128 v[89:92], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v49, 0x88000, v48
	buffer_load_b128 v[93:96], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v49, 0x90000, v48
	buffer_load_b128 v[97:100], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v49, 0x98000, v48
	buffer_load_b128 v[101:104], v49, s[4:7], 0 offen slc
	ds_load_b128 v[49:52], v39
	ds_load_b128 v[53:56], v39 offset:16
	ds_load_u16_d16_hi v57, v38 offset:128
	ds_load_u16_d16 v57, v38
	ds_load_u16_d16 v65, v38 offset:32
	ds_load_u16_d16 v58, v38 offset:256
	ds_load_u16_d16_hi v58, v38 offset:384
	ds_load_u16_d16 v59, v38 offset:512
	ds_load_u16_d16_hi v59, v38 offset:640
	ds_load_u16_d16 v60, v38 offset:768
	ds_load_u16_d16_hi v60, v38 offset:896
	ds_load_u16_d16 v61, v38 offset:1024
	ds_load_u16_d16_hi v61, v38 offset:1152
	ds_load_u16_d16 v62, v38 offset:1280
	ds_load_u16_d16_hi v62, v38 offset:1408
	ds_load_u16_d16 v63, v38 offset:1536
	ds_load_u16_d16_hi v63, v38 offset:1664
	ds_load_u16_d16 v64, v38 offset:1792
	ds_load_u16_d16_hi v64, v38 offset:1920
	ds_load_u16_d16_hi v65, v38 offset:160
	ds_load_u16_d16 v66, v38 offset:288
	ds_load_u16_d16_hi v66, v38 offset:416
	ds_load_u16_d16 v67, v38 offset:544
	ds_load_u16_d16_hi v67, v38 offset:672
	ds_load_u16_d16 v68, v38 offset:800
	ds_load_u16_d16_hi v68, v38 offset:928
	ds_load_u16_d16 v69, v38 offset:1056
	ds_load_u16_d16_hi v69, v38 offset:1184
	ds_load_u16_d16 v70, v38 offset:1312
	ds_load_u16_d16_hi v70, v38 offset:1440
	ds_load_u16_d16 v71, v38 offset:1568
	ds_load_u16_d16_hi v71, v38 offset:1696
	ds_load_u16_d16 v72, v38 offset:1824
	ds_load_u16_d16_hi v72, v38 offset:1952
	ds_load_u16_d16 v73, v38 offset:64
	ds_load_u16_d16_hi v73, v38 offset:192
	ds_load_u16_d16 v74, v38 offset:320
	ds_load_u16_d16_hi v74, v38 offset:448
	ds_load_u16_d16 v75, v38 offset:576
	ds_load_u16_d16_hi v75, v38 offset:704
	ds_load_u16_d16 v76, v38 offset:832
	ds_load_u16_d16_hi v76, v38 offset:960
	ds_load_u16_d16 v77, v38 offset:1088
	ds_load_u16_d16_hi v77, v38 offset:1216
	ds_load_u16_d16 v78, v38 offset:1344
	ds_load_u16_d16_hi v78, v38 offset:1472
	ds_load_u16_d16 v79, v38 offset:1600
	ds_load_u16_d16_hi v79, v38 offset:1728
	ds_load_u16_d16 v80, v38 offset:1856
	ds_load_u16_d16_hi v80, v38 offset:1984
	ds_load_u16_d16 v81, v38 offset:96
	ds_load_u16_d16_hi v81, v38 offset:224
	ds_load_u16_d16 v82, v38 offset:352
	ds_load_u16_d16_hi v82, v38 offset:480
	ds_load_u16_d16 v83, v38 offset:608
	ds_load_u16_d16_hi v83, v38 offset:736
	ds_load_u16_d16 v84, v38 offset:864
	ds_load_u16_d16_hi v84, v38 offset:992
	ds_load_u16_d16 v85, v38 offset:1120
	ds_load_u16_d16_hi v85, v38 offset:1248
	ds_load_u16_d16 v86, v38 offset:1376
	ds_load_u16_d16_hi v86, v38 offset:1504
	ds_load_u16_d16 v87, v38 offset:1632
	ds_load_u16_d16_hi v87, v38 offset:1760
	ds_load_u16_d16 v88, v38 offset:1888
	ds_load_u16_d16_hi v88, v38 offset:2016
	s_waitcnt lgkmcnt(47)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[49:56], v[57:64], v[25:32]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[49:56], v[65:72], v[17:24]
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[49:56], v[73:80], v[9:16]
	s_waitcnt vmcnt(4)
	ds_store_b128 v40, v[33:36]
	s_waitcnt vmcnt(3)
	ds_store_b128 v42, v[89:92]
	s_waitcnt vmcnt(2)
	ds_store_b128 v42, v[93:96] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v42, v[97:100] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v42, v[101:104] offset:1536
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[49:56], v[81:88], v[1:8]
	v_add_nc_u32_e32 v49, 0xa0000, v48
	buffer_load_b128 v[33:36], v46, s[8:11], 0 offen offset:32
	buffer_load_b128 v[89:92], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v49, 0xa8000, v48
	buffer_load_b128 v[93:96], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v49, 0xb0000, v48
	buffer_load_b128 v[97:100], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v49, 0xb8000, v48
	buffer_load_b128 v[101:104], v49, s[4:7], 0 offen slc
	ds_load_b128 v[49:52], v39
	ds_load_b128 v[53:56], v39 offset:16
	ds_load_u16_d16_hi v57, v38 offset:128
	ds_load_u16_d16 v57, v38
	ds_load_u16_d16 v65, v38 offset:32
	ds_load_u16_d16 v58, v38 offset:256
	ds_load_u16_d16_hi v58, v38 offset:384
	ds_load_u16_d16 v59, v38 offset:512
	ds_load_u16_d16_hi v59, v38 offset:640
	ds_load_u16_d16 v60, v38 offset:768
	ds_load_u16_d16_hi v60, v38 offset:896
	ds_load_u16_d16 v61, v38 offset:1024
	ds_load_u16_d16_hi v61, v38 offset:1152
	ds_load_u16_d16 v62, v38 offset:1280
	ds_load_u16_d16_hi v62, v38 offset:1408
	ds_load_u16_d16 v63, v38 offset:1536
	ds_load_u16_d16_hi v63, v38 offset:1664
	ds_load_u16_d16 v64, v38 offset:1792
	ds_load_u16_d16_hi v64, v38 offset:1920
	ds_load_u16_d16_hi v65, v38 offset:160
	ds_load_u16_d16 v66, v38 offset:288
	ds_load_u16_d16_hi v66, v38 offset:416
	ds_load_u16_d16 v67, v38 offset:544
	ds_load_u16_d16_hi v67, v38 offset:672
	ds_load_u16_d16 v68, v38 offset:800
	ds_load_u16_d16_hi v68, v38 offset:928
	ds_load_u16_d16 v69, v38 offset:1056
	ds_load_u16_d16_hi v69, v38 offset:1184
	ds_load_u16_d16 v70, v38 offset:1312
	ds_load_u16_d16_hi v70, v38 offset:1440
	ds_load_u16_d16 v71, v38 offset:1568
	ds_load_u16_d16_hi v71, v38 offset:1696
	ds_load_u16_d16 v72, v38 offset:1824
	ds_load_u16_d16_hi v72, v38 offset:1952
	ds_load_u16_d16 v73, v38 offset:64
	ds_load_u16_d16_hi v73, v38 offset:192
	ds_load_u16_d16 v74, v38 offset:320
	ds_load_u16_d16_hi v74, v38 offset:448
	ds_load_u16_d16 v75, v38 offset:576
	ds_load_u16_d16_hi v75, v38 offset:704
	ds_load_u16_d16 v76, v38 offset:832
	ds_load_u16_d16_hi v76, v38 offset:960
	ds_load_u16_d16 v77, v38 offset:1088
	ds_load_u16_d16_hi v77, v38 offset:1216
	ds_load_u16_d16 v78, v38 offset:1344
	ds_load_u16_d16_hi v78, v38 offset:1472
	ds_load_u16_d16 v79, v38 offset:1600
	ds_load_u16_d16_hi v79, v38 offset:1728
	ds_load_u16_d16 v80, v38 offset:1856
	ds_load_u16_d16_hi v80, v38 offset:1984
	ds_load_u16_d16 v81, v38 offset:96
	ds_load_u16_d16_hi v81, v38 offset:224
	ds_load_u16_d16 v82, v38 offset:352
	ds_load_u16_d16_hi v82, v38 offset:480
	ds_load_u16_d16 v83, v38 offset:608
	ds_load_u16_d16_hi v83, v38 offset:736
	ds_load_u16_d16 v84, v38 offset:864
	ds_load_u16_d16_hi v84, v38 offset:992
	ds_load_u16_d16 v85, v38 offset:1120
	ds_load_u16_d16_hi v85, v38 offset:1248
	ds_load_u16_d16 v86, v38 offset:1376
	ds_load_u16_d16_hi v86, v38 offset:1504
	ds_load_u16_d16 v87, v38 offset:1632
	ds_load_u16_d16_hi v87, v38 offset:1760
	ds_load_u16_d16 v88, v38 offset:1888
	ds_load_u16_d16_hi v88, v38 offset:2016
	s_waitcnt lgkmcnt(47)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[49:56], v[57:64], v[25:32]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[49:56], v[65:72], v[17:24]
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[49:56], v[73:80], v[9:16]
	s_waitcnt vmcnt(4)
	ds_store_b128 v40, v[33:36]
	s_waitcnt vmcnt(3)
	ds_store_b128 v42, v[89:92]
	s_waitcnt vmcnt(2)
	ds_store_b128 v42, v[93:96] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v42, v[97:100] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v42, v[101:104] offset:1536
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[49:56], v[81:88], v[1:8]
	v_add_nc_u32_e32 v49, 0xc0000, v48
	buffer_load_b128 v[33:36], v46, s[8:11], 0 offen offset:64
	buffer_load_b128 v[89:92], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v49, 0xc8000, v48
	buffer_load_b128 v[93:96], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v49, 0xd0000, v48
	buffer_load_b128 v[97:100], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v49, 0xd8000, v48
	buffer_load_b128 v[101:104], v49, s[4:7], 0 offen slc
	ds_load_b128 v[49:52], v39
	ds_load_b128 v[53:56], v39 offset:16
	ds_load_u16_d16_hi v57, v38 offset:128
	ds_load_u16_d16 v57, v38
	ds_load_u16_d16 v65, v38 offset:32
	ds_load_u16_d16 v58, v38 offset:256
	ds_load_u16_d16_hi v58, v38 offset:384
	ds_load_u16_d16 v59, v38 offset:512
	ds_load_u16_d16_hi v59, v38 offset:640
	ds_load_u16_d16 v60, v38 offset:768
	ds_load_u16_d16_hi v60, v38 offset:896
	ds_load_u16_d16 v61, v38 offset:1024
	ds_load_u16_d16_hi v61, v38 offset:1152
	ds_load_u16_d16 v62, v38 offset:1280
	ds_load_u16_d16_hi v62, v38 offset:1408
	ds_load_u16_d16 v63, v38 offset:1536
	ds_load_u16_d16_hi v63, v38 offset:1664
	ds_load_u16_d16 v64, v38 offset:1792
	ds_load_u16_d16_hi v64, v38 offset:1920
	ds_load_u16_d16_hi v65, v38 offset:160
	ds_load_u16_d16 v66, v38 offset:288
	ds_load_u16_d16_hi v66, v38 offset:416
	ds_load_u16_d16 v67, v38 offset:544
	ds_load_u16_d16_hi v67, v38 offset:672
	ds_load_u16_d16 v68, v38 offset:800
	ds_load_u16_d16_hi v68, v38 offset:928
	ds_load_u16_d16 v69, v38 offset:1056
	ds_load_u16_d16_hi v69, v38 offset:1184
	ds_load_u16_d16 v70, v38 offset:1312
	ds_load_u16_d16_hi v70, v38 offset:1440
	ds_load_u16_d16 v71, v38 offset:1568
	ds_load_u16_d16_hi v71, v38 offset:1696
	ds_load_u16_d16 v72, v38 offset:1824
	ds_load_u16_d16_hi v72, v38 offset:1952
	ds_load_u16_d16 v73, v38 offset:64
	ds_load_u16_d16_hi v73, v38 offset:192
	ds_load_u16_d16 v74, v38 offset:320
	ds_load_u16_d16_hi v74, v38 offset:448
	ds_load_u16_d16 v75, v38 offset:576
	ds_load_u16_d16_hi v75, v38 offset:704
	ds_load_u16_d16 v76, v38 offset:832
	ds_load_u16_d16_hi v76, v38 offset:960
	ds_load_u16_d16 v77, v38 offset:1088
	ds_load_u16_d16_hi v77, v38 offset:1216
	ds_load_u16_d16 v78, v38 offset:1344
	ds_load_u16_d16_hi v78, v38 offset:1472
	ds_load_u16_d16 v79, v38 offset:1600
	ds_load_u16_d16_hi v79, v38 offset:1728
	ds_load_u16_d16 v80, v38 offset:1856
	ds_load_u16_d16_hi v80, v38 offset:1984
	ds_load_u16_d16 v81, v38 offset:96
	ds_load_u16_d16_hi v81, v38 offset:224
	ds_load_u16_d16 v82, v38 offset:352
	ds_load_u16_d16_hi v82, v38 offset:480
	ds_load_u16_d16 v83, v38 offset:608
	ds_load_u16_d16_hi v83, v38 offset:736
	ds_load_u16_d16 v84, v38 offset:864
	ds_load_u16_d16_hi v84, v38 offset:992
	ds_load_u16_d16 v85, v38 offset:1120
	ds_load_u16_d16_hi v85, v38 offset:1248
	ds_load_u16_d16 v86, v38 offset:1376
	ds_load_u16_d16_hi v86, v38 offset:1504
	ds_load_u16_d16 v87, v38 offset:1632
	ds_load_u16_d16_hi v87, v38 offset:1760
	ds_load_u16_d16 v88, v38 offset:1888
	ds_load_u16_d16_hi v88, v38 offset:2016
	s_waitcnt lgkmcnt(47)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[49:56], v[57:64], v[25:32]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[49:56], v[65:72], v[17:24]
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[49:56], v[73:80], v[9:16]
	s_waitcnt vmcnt(4)
	ds_store_b128 v40, v[33:36]
	s_waitcnt vmcnt(3)
	ds_store_b128 v42, v[89:92]
	s_waitcnt vmcnt(2)
	ds_store_b128 v42, v[93:96] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v42, v[97:100] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v42, v[101:104] offset:1536
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[49:56], v[81:88], v[1:8]
	v_add_nc_u32_e32 v49, 0xe0000, v48
	buffer_load_b128 v[33:36], v46, s[8:11], 0 offen offset:96
	buffer_load_b128 v[89:92], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v49, 0xe8000, v48
	buffer_load_b128 v[93:96], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v49, 0xf0000, v48
	buffer_load_b128 v[97:100], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v49, 0xf8000, v48
	buffer_load_b128 v[101:104], v49, s[4:7], 0 offen slc
	ds_load_b128 v[49:52], v39
	ds_load_b128 v[53:56], v39 offset:16
	ds_load_u16_d16_hi v57, v38 offset:128
	ds_load_u16_d16 v57, v38
	ds_load_u16_d16 v65, v38 offset:32
	ds_load_u16_d16 v58, v38 offset:256
	ds_load_u16_d16_hi v58, v38 offset:384
	ds_load_u16_d16 v59, v38 offset:512
	ds_load_u16_d16_hi v59, v38 offset:640
	ds_load_u16_d16 v60, v38 offset:768
	ds_load_u16_d16_hi v60, v38 offset:896
	ds_load_u16_d16 v61, v38 offset:1024
	ds_load_u16_d16_hi v61, v38 offset:1152
	ds_load_u16_d16 v62, v38 offset:1280
	ds_load_u16_d16_hi v62, v38 offset:1408
	ds_load_u16_d16 v63, v38 offset:1536
	ds_load_u16_d16_hi v63, v38 offset:1664
	ds_load_u16_d16 v64, v38 offset:1792
	ds_load_u16_d16_hi v64, v38 offset:1920
	ds_load_u16_d16_hi v65, v38 offset:160
	ds_load_u16_d16 v66, v38 offset:288
	ds_load_u16_d16_hi v66, v38 offset:416
	ds_load_u16_d16 v67, v38 offset:544
	ds_load_u16_d16_hi v67, v38 offset:672
	ds_load_u16_d16 v68, v38 offset:800
	ds_load_u16_d16_hi v68, v38 offset:928
	ds_load_u16_d16 v69, v38 offset:1056
	ds_load_u16_d16_hi v69, v38 offset:1184
	ds_load_u16_d16 v70, v38 offset:1312
	ds_load_u16_d16_hi v70, v38 offset:1440
	ds_load_u16_d16 v71, v38 offset:1568
	ds_load_u16_d16_hi v71, v38 offset:1696
	ds_load_u16_d16 v72, v38 offset:1824
	ds_load_u16_d16_hi v72, v38 offset:1952
	ds_load_u16_d16 v73, v38 offset:64
	ds_load_u16_d16_hi v73, v38 offset:192
	ds_load_u16_d16 v74, v38 offset:320
	ds_load_u16_d16_hi v74, v38 offset:448
	ds_load_u16_d16 v75, v38 offset:576
	ds_load_u16_d16_hi v75, v38 offset:704
	ds_load_u16_d16 v76, v38 offset:832
	ds_load_u16_d16_hi v76, v38 offset:960
	ds_load_u16_d16 v77, v38 offset:1088
	ds_load_u16_d16_hi v77, v38 offset:1216
	ds_load_u16_d16 v78, v38 offset:1344
	ds_load_u16_d16_hi v78, v38 offset:1472
	ds_load_u16_d16 v79, v38 offset:1600
	ds_load_u16_d16_hi v79, v38 offset:1728
	ds_load_u16_d16 v80, v38 offset:1856
	ds_load_u16_d16_hi v80, v38 offset:1984
	ds_load_u16_d16 v81, v38 offset:96
	ds_load_u16_d16_hi v81, v38 offset:224
	ds_load_u16_d16 v82, v38 offset:352
	ds_load_u16_d16_hi v82, v38 offset:480
	ds_load_u16_d16 v83, v38 offset:608
	ds_load_u16_d16_hi v83, v38 offset:736
	ds_load_u16_d16 v84, v38 offset:864
	ds_load_u16_d16_hi v84, v38 offset:992
	ds_load_u16_d16 v85, v38 offset:1120
	ds_load_u16_d16_hi v85, v38 offset:1248
	ds_load_u16_d16 v86, v38 offset:1376
	ds_load_u16_d16_hi v86, v38 offset:1504
	ds_load_u16_d16 v87, v38 offset:1632
	ds_load_u16_d16_hi v87, v38 offset:1760
	ds_load_u16_d16 v88, v38 offset:1888
	ds_load_u16_d16_hi v88, v38 offset:2016
	s_waitcnt lgkmcnt(47)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[49:56], v[57:64], v[25:32]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[49:56], v[65:72], v[17:24]
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[49:56], v[73:80], v[9:16]
	s_waitcnt vmcnt(4)
	ds_store_b128 v40, v[33:36]
	s_waitcnt vmcnt(3)
	ds_store_b128 v42, v[89:92]
	s_waitcnt vmcnt(2)
	ds_store_b128 v42, v[93:96] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v42, v[97:100] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v42, v[101:104] offset:1536
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[49:56], v[81:88], v[1:8]
	v_add_nc_u32_e32 v49, 0x100000, v48
	buffer_load_b128 v[33:36], v46, s[8:11], 0 offen offset:128
	v_add_nc_u32_e32 v46, 0x100, v46
	buffer_load_b128 v[88:91], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v49, 0x108000, v48
	buffer_load_b128 v[92:95], v49, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v49, 0x110000, v48
	v_add_nc_u32_e32 v48, 0x118000, v48
	s_clause 0x1
	buffer_load_b128 v[96:99], v49, s[4:7], 0 offen slc
	buffer_load_b128 v[100:103], v48, s[4:7], 0 offen slc
	ds_load_b128 v[48:51], v39
	ds_load_b128 v[52:55], v39 offset:16
	ds_load_u16_d16_hi v56, v38 offset:128
	ds_load_u16_d16 v56, v38
	ds_load_u16_d16 v64, v38 offset:32
	ds_load_u16_d16 v57, v38 offset:256
	ds_load_u16_d16_hi v57, v38 offset:384
	ds_load_u16_d16 v58, v38 offset:512
	ds_load_u16_d16_hi v58, v38 offset:640
	ds_load_u16_d16 v59, v38 offset:768
	ds_load_u16_d16_hi v59, v38 offset:896
	ds_load_u16_d16 v60, v38 offset:1024
	ds_load_u16_d16_hi v60, v38 offset:1152
	ds_load_u16_d16 v61, v38 offset:1280
	ds_load_u16_d16_hi v61, v38 offset:1408
	ds_load_u16_d16 v62, v38 offset:1536
	ds_load_u16_d16_hi v62, v38 offset:1664
	ds_load_u16_d16 v63, v38 offset:1792
	ds_load_u16_d16_hi v63, v38 offset:1920
	ds_load_u16_d16_hi v64, v38 offset:160
	ds_load_u16_d16 v65, v38 offset:288
	ds_load_u16_d16_hi v65, v38 offset:416
	ds_load_u16_d16 v66, v38 offset:544
	ds_load_u16_d16_hi v66, v38 offset:672
	ds_load_u16_d16 v67, v38 offset:800
	ds_load_u16_d16_hi v67, v38 offset:928
	ds_load_u16_d16 v68, v38 offset:1056
	ds_load_u16_d16_hi v68, v38 offset:1184
	ds_load_u16_d16 v69, v38 offset:1312
	ds_load_u16_d16_hi v69, v38 offset:1440
	ds_load_u16_d16 v70, v38 offset:1568
	ds_load_u16_d16_hi v70, v38 offset:1696
	ds_load_u16_d16 v71, v38 offset:1824
	ds_load_u16_d16_hi v71, v38 offset:1952
	ds_load_u16_d16 v72, v38 offset:64
	ds_load_u16_d16_hi v72, v38 offset:192
	ds_load_u16_d16 v73, v38 offset:320
	ds_load_u16_d16_hi v73, v38 offset:448
	ds_load_u16_d16 v74, v38 offset:576
	ds_load_u16_d16_hi v74, v38 offset:704
	ds_load_u16_d16 v75, v38 offset:832
	ds_load_u16_d16_hi v75, v38 offset:960
	ds_load_u16_d16 v76, v38 offset:1088
	ds_load_u16_d16_hi v76, v38 offset:1216
	ds_load_u16_d16 v77, v38 offset:1344
	ds_load_u16_d16_hi v77, v38 offset:1472
	ds_load_u16_d16 v78, v38 offset:1600
	ds_load_u16_d16_hi v78, v38 offset:1728
	ds_load_u16_d16 v79, v38 offset:1856
	ds_load_u16_d16_hi v79, v38 offset:1984
	ds_load_u16_d16 v80, v38 offset:96
	ds_load_u16_d16_hi v80, v38 offset:224
	ds_load_u16_d16 v81, v38 offset:352
	ds_load_u16_d16_hi v81, v38 offset:480
	ds_load_u16_d16 v82, v38 offset:608
	ds_load_u16_d16_hi v82, v38 offset:736
	ds_load_u16_d16 v83, v38 offset:864
	ds_load_u16_d16_hi v83, v38 offset:992
	ds_load_u16_d16 v84, v38 offset:1120
	ds_load_u16_d16_hi v84, v38 offset:1248
	ds_load_u16_d16 v85, v38 offset:1376
	ds_load_u16_d16_hi v85, v38 offset:1504
	ds_load_u16_d16 v86, v38 offset:1632
	ds_load_u16_d16_hi v86, v38 offset:1760
	ds_load_u16_d16 v87, v38 offset:1888
	ds_load_u16_d16_hi v87, v38 offset:2016
	s_waitcnt lgkmcnt(47)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[48:55], v[56:63], v[25:32]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[48:55], v[64:71], v[17:24]
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[48:55], v[72:79], v[9:16]
	s_waitcnt vmcnt(4)
	ds_store_b128 v40, v[33:36]
	s_waitcnt vmcnt(3)
	ds_store_b128 v42, v[88:91]
	s_waitcnt vmcnt(2)
	ds_store_b128 v42, v[92:95] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v42, v[96:99] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v42, v[100:103] offset:1536
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[48:55], v[80:87], v[1:8]
	s_cbranch_scc1 .LBB0_1
	s_add_i32 s6, s12, 0x1f90000
	v_add_nc_u32_e32 v33, 0x3000, v43
	v_add_lshl_u32 v34, s6, v41, 1
	s_mov_b32 s6, s10
	s_mov_b32 s7, s11
	s_add_i32 s13, s12, 0x1fa0000
	buffer_load_b128 v[83:86], v33, s[8:11], 0 offen offset:3872
	v_add_nc_u32_e32 v35, 0x8000, v34
	buffer_load_b128 v[87:90], v34, s[4:7], 0 offen slc
	s_load_b64 s[0:1], s[0:1], 0x30
	ds_load_b128 v[43:46], v39
	ds_load_b128 v[47:50], v39 offset:16
	ds_load_u16_d16_hi v51, v38 offset:128
	ds_load_u16_d16 v51, v38
	ds_load_u16_d16 v59, v38 offset:32
	ds_load_u16_d16 v52, v38 offset:256
	ds_load_u16_d16_hi v52, v38 offset:384
	ds_load_u16_d16 v53, v38 offset:512
	ds_load_u16_d16_hi v53, v38 offset:640
	ds_load_u16_d16 v54, v38 offset:768
	ds_load_u16_d16_hi v54, v38 offset:896
	ds_load_u16_d16 v55, v38 offset:1024
	ds_load_u16_d16_hi v55, v38 offset:1152
	ds_load_u16_d16 v56, v38 offset:1280
	ds_load_u16_d16_hi v56, v38 offset:1408
	ds_load_u16_d16 v57, v38 offset:1536
	ds_load_u16_d16_hi v57, v38 offset:1664
	ds_load_u16_d16 v58, v38 offset:1792
	ds_load_u16_d16_hi v58, v38 offset:1920
	ds_load_u16_d16_hi v59, v38 offset:160
	ds_load_u16_d16 v60, v38 offset:288
	ds_load_u16_d16_hi v60, v38 offset:416
	ds_load_u16_d16 v61, v38 offset:544
	ds_load_u16_d16_hi v61, v38 offset:672
	ds_load_u16_d16 v62, v38 offset:800
	ds_load_u16_d16_hi v62, v38 offset:928
	ds_load_u16_d16 v63, v38 offset:1056
	ds_load_u16_d16_hi v63, v38 offset:1184
	ds_load_u16_d16 v64, v38 offset:1312
	ds_load_u16_d16_hi v64, v38 offset:1440
	ds_load_u16_d16 v65, v38 offset:1568
	ds_load_u16_d16_hi v65, v38 offset:1696
	ds_load_u16_d16 v66, v38 offset:1824
	ds_load_u16_d16_hi v66, v38 offset:1952
	ds_load_u16_d16 v67, v38 offset:64
	ds_load_u16_d16_hi v67, v38 offset:192
	ds_load_u16_d16 v68, v38 offset:320
	ds_load_u16_d16_hi v68, v38 offset:448
	ds_load_u16_d16 v69, v38 offset:576
	ds_load_u16_d16_hi v69, v38 offset:704
	ds_load_u16_d16 v70, v38 offset:832
	ds_load_u16_d16_hi v70, v38 offset:960
	ds_load_u16_d16 v71, v38 offset:1088
	ds_load_u16_d16_hi v71, v38 offset:1216
	ds_load_u16_d16 v72, v38 offset:1344
	ds_load_u16_d16_hi v72, v38 offset:1472
	ds_load_u16_d16 v73, v38 offset:1600
	ds_load_u16_d16_hi v73, v38 offset:1728
	ds_load_u16_d16 v74, v38 offset:1856
	ds_load_u16_d16_hi v74, v38 offset:1984
	ds_load_u16_d16 v75, v38 offset:96
	ds_load_u16_d16_hi v75, v38 offset:224
	ds_load_u16_d16 v76, v38 offset:352
	ds_load_u16_d16_hi v76, v38 offset:480
	ds_load_u16_d16 v77, v38 offset:608
	ds_load_u16_d16_hi v77, v38 offset:736
	ds_load_u16_d16 v78, v38 offset:864
	ds_load_u16_d16_hi v78, v38 offset:992
	ds_load_u16_d16 v79, v38 offset:1120
	ds_load_u16_d16_hi v79, v38 offset:1248
	ds_load_u16_d16 v80, v38 offset:1376
	ds_load_u16_d16_hi v80, v38 offset:1504
	ds_load_u16_d16 v81, v38 offset:1632
	ds_load_u16_d16_hi v81, v38 offset:1760
	ds_load_u16_d16 v82, v38 offset:1888
	ds_load_u16_d16_hi v82, v38 offset:2016
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[43:50], v[51:58], v[25:32]
	buffer_load_b128 v[91:94], v35, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v35, 0x10000, v34
	v_add_nc_u32_e32 v34, 0x18000, v34
	v_wmma_f32_16x16x16_bf16 v[17:24], v[43:50], v[59:66], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[43:50], v[67:74], v[9:16]
	s_mov_b32 s3, 0x21027000
	s_clause 0x1
	buffer_load_b128 v[95:98], v35, s[4:7], 0 offen slc
	buffer_load_b128 v[99:102], v34, s[4:7], 0 offen slc
	v_add_lshl_u32 v34, s13, v41, 1
	s_add_i32 s13, s12, 0x1fb0000
	s_mov_b32 s2, -1
	s_delay_alu instid0(VALU_DEP_1)
	v_add_nc_u32_e32 v35, 0x8000, v34
	s_waitcnt vmcnt(4)
	ds_store_b128 v40, v[83:86]
	s_waitcnt vmcnt(3)
	ds_store_b128 v42, v[87:90]
	s_waitcnt vmcnt(2)
	ds_store_b128 v42, v[91:94] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v42, v[95:98] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v42, v[99:102] offset:1536
	s_clause 0x1
	buffer_load_b128 v[87:90], v34, s[4:7], 0 offen slc
	buffer_load_b128 v[91:94], v35, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v35, 0x10000, v34
	v_add_nc_u32_e32 v34, 0x18000, v34
	buffer_load_b128 v[83:86], v33, s[8:11], 0 offen offset:3904
	v_wmma_f32_16x16x16_bf16 v[1:8], v[43:50], v[75:82], v[1:8]
	ds_load_b128 v[43:46], v39
	ds_load_b128 v[47:50], v39 offset:16
	ds_load_u16_d16_hi v51, v38 offset:128
	ds_load_u16_d16 v51, v38
	ds_load_u16_d16 v59, v38 offset:32
	ds_load_u16_d16 v52, v38 offset:256
	ds_load_u16_d16_hi v52, v38 offset:384
	ds_load_u16_d16 v53, v38 offset:512
	ds_load_u16_d16_hi v53, v38 offset:640
	ds_load_u16_d16 v54, v38 offset:768
	ds_load_u16_d16_hi v54, v38 offset:896
	ds_load_u16_d16 v55, v38 offset:1024
	ds_load_u16_d16_hi v55, v38 offset:1152
	ds_load_u16_d16 v56, v38 offset:1280
	ds_load_u16_d16_hi v56, v38 offset:1408
	ds_load_u16_d16 v57, v38 offset:1536
	ds_load_u16_d16_hi v57, v38 offset:1664
	ds_load_u16_d16 v58, v38 offset:1792
	ds_load_u16_d16_hi v58, v38 offset:1920
	ds_load_u16_d16_hi v59, v38 offset:160
	ds_load_u16_d16 v60, v38 offset:288
	ds_load_u16_d16_hi v60, v38 offset:416
	ds_load_u16_d16 v61, v38 offset:544
	ds_load_u16_d16_hi v61, v38 offset:672
	ds_load_u16_d16 v62, v38 offset:800
	ds_load_u16_d16_hi v62, v38 offset:928
	ds_load_u16_d16 v63, v38 offset:1056
	ds_load_u16_d16_hi v63, v38 offset:1184
	ds_load_u16_d16 v64, v38 offset:1312
	ds_load_u16_d16_hi v64, v38 offset:1440
	ds_load_u16_d16 v65, v38 offset:1568
	ds_load_u16_d16_hi v65, v38 offset:1696
	ds_load_u16_d16 v66, v38 offset:1824
	ds_load_u16_d16_hi v66, v38 offset:1952
	ds_load_u16_d16 v67, v38 offset:64
	ds_load_u16_d16_hi v67, v38 offset:192
	ds_load_u16_d16 v68, v38 offset:320
	ds_load_u16_d16_hi v68, v38 offset:448
	ds_load_u16_d16 v69, v38 offset:576
	ds_load_u16_d16_hi v69, v38 offset:704
	ds_load_u16_d16 v70, v38 offset:832
	ds_load_u16_d16_hi v70, v38 offset:960
	ds_load_u16_d16 v71, v38 offset:1088
	ds_load_u16_d16_hi v71, v38 offset:1216
	ds_load_u16_d16 v72, v38 offset:1344
	ds_load_u16_d16_hi v72, v38 offset:1472
	ds_load_u16_d16 v73, v38 offset:1600
	ds_load_u16_d16_hi v73, v38 offset:1728
	ds_load_u16_d16 v74, v38 offset:1856
	ds_load_u16_d16_hi v74, v38 offset:1984
	ds_load_u16_d16 v75, v38 offset:96
	ds_load_u16_d16_hi v75, v38 offset:224
	ds_load_u16_d16 v76, v38 offset:352
	ds_load_u16_d16_hi v76, v38 offset:480
	ds_load_u16_d16 v77, v38 offset:608
	ds_load_u16_d16_hi v77, v38 offset:736
	ds_load_u16_d16 v78, v38 offset:864
	ds_load_u16_d16_hi v78, v38 offset:992
	ds_load_u16_d16 v79, v38 offset:1120
	ds_load_u16_d16_hi v79, v38 offset:1248
	ds_load_u16_d16 v80, v38 offset:1376
	ds_load_u16_d16_hi v80, v38 offset:1504
	ds_load_u16_d16 v81, v38 offset:1632
	ds_load_u16_d16_hi v81, v38 offset:1760
	ds_load_u16_d16 v82, v38 offset:1888
	ds_load_u16_d16_hi v82, v38 offset:2016
	s_clause 0x1
	buffer_load_b128 v[95:98], v35, s[4:7], 0 offen slc
	buffer_load_b128 v[99:102], v34, s[4:7], 0 offen slc
	v_add_lshl_u32 v34, s13, v41, 1
	s_add_i32 s13, s12, 0x1fc0000
	s_waitcnt lgkmcnt(47)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[43:50], v[51:58], v[25:32]
	s_delay_alu instid0(VALU_DEP_2)
	v_add_nc_u32_e32 v35, 0x8000, v34
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[43:50], v[59:66], v[17:24]
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[43:50], v[67:74], v[9:16]
	s_and_b32 s1, s1, 0xffff
	s_waitcnt vmcnt(2)
	ds_store_b128 v40, v[83:86]
	ds_store_b128 v42, v[87:90]
	ds_store_b128 v42, v[91:94] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v42, v[95:98] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v42, v[99:102] offset:1536
	s_clause 0x1
	buffer_load_b128 v[87:90], v34, s[4:7], 0 offen slc
	buffer_load_b128 v[91:94], v35, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v35, 0x10000, v34
	v_add_nc_u32_e32 v34, 0x18000, v34
	buffer_load_b128 v[83:86], v33, s[8:11], 0 offen offset:3936
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[43:50], v[75:82], v[1:8]
	ds_load_b128 v[43:46], v39
	ds_load_b128 v[47:50], v39 offset:16
	ds_load_u16_d16_hi v51, v38 offset:128
	ds_load_u16_d16 v51, v38
	ds_load_u16_d16 v59, v38 offset:32
	ds_load_u16_d16 v52, v38 offset:256
	ds_load_u16_d16_hi v52, v38 offset:384
	ds_load_u16_d16 v53, v38 offset:512
	ds_load_u16_d16_hi v53, v38 offset:640
	ds_load_u16_d16 v54, v38 offset:768
	ds_load_u16_d16_hi v54, v38 offset:896
	ds_load_u16_d16 v55, v38 offset:1024
	ds_load_u16_d16_hi v55, v38 offset:1152
	ds_load_u16_d16 v56, v38 offset:1280
	ds_load_u16_d16_hi v56, v38 offset:1408
	ds_load_u16_d16 v57, v38 offset:1536
	ds_load_u16_d16_hi v57, v38 offset:1664
	ds_load_u16_d16 v58, v38 offset:1792
	ds_load_u16_d16_hi v58, v38 offset:1920
	ds_load_u16_d16_hi v59, v38 offset:160
	ds_load_u16_d16 v60, v38 offset:288
	ds_load_u16_d16_hi v60, v38 offset:416
	ds_load_u16_d16 v61, v38 offset:544
	ds_load_u16_d16_hi v61, v38 offset:672
	ds_load_u16_d16 v62, v38 offset:800
	ds_load_u16_d16_hi v62, v38 offset:928
	ds_load_u16_d16 v63, v38 offset:1056
	ds_load_u16_d16_hi v63, v38 offset:1184
	ds_load_u16_d16 v64, v38 offset:1312
	ds_load_u16_d16_hi v64, v38 offset:1440
	ds_load_u16_d16 v65, v38 offset:1568
	ds_load_u16_d16_hi v65, v38 offset:1696
	ds_load_u16_d16 v66, v38 offset:1824
	ds_load_u16_d16_hi v66, v38 offset:1952
	ds_load_u16_d16 v67, v38 offset:64
	ds_load_u16_d16_hi v67, v38 offset:192
	ds_load_u16_d16 v68, v38 offset:320
	ds_load_u16_d16_hi v68, v38 offset:448
	ds_load_u16_d16 v69, v38 offset:576
	ds_load_u16_d16_hi v69, v38 offset:704
	ds_load_u16_d16 v70, v38 offset:832
	ds_load_u16_d16_hi v70, v38 offset:960
	ds_load_u16_d16 v71, v38 offset:1088
	ds_load_u16_d16_hi v71, v38 offset:1216
	ds_load_u16_d16 v72, v38 offset:1344
	ds_load_u16_d16_hi v72, v38 offset:1472
	ds_load_u16_d16 v73, v38 offset:1600
	ds_load_u16_d16_hi v73, v38 offset:1728
	ds_load_u16_d16 v74, v38 offset:1856
	ds_load_u16_d16_hi v74, v38 offset:1984
	ds_load_u16_d16 v75, v38 offset:96
	ds_load_u16_d16_hi v75, v38 offset:224
	ds_load_u16_d16 v76, v38 offset:352
	ds_load_u16_d16_hi v76, v38 offset:480
	ds_load_u16_d16 v77, v38 offset:608
	ds_load_u16_d16_hi v77, v38 offset:736
	ds_load_u16_d16 v78, v38 offset:864
	ds_load_u16_d16_hi v78, v38 offset:992
	ds_load_u16_d16 v79, v38 offset:1120
	ds_load_u16_d16_hi v79, v38 offset:1248
	ds_load_u16_d16 v80, v38 offset:1376
	ds_load_u16_d16_hi v80, v38 offset:1504
	ds_load_u16_d16 v81, v38 offset:1632
	ds_load_u16_d16_hi v81, v38 offset:1760
	ds_load_u16_d16 v82, v38 offset:1888
	ds_load_u16_d16_hi v82, v38 offset:2016
	s_clause 0x1
	buffer_load_b128 v[95:98], v35, s[4:7], 0 offen slc
	buffer_load_b128 v[99:102], v34, s[4:7], 0 offen slc
	v_add_lshl_u32 v34, s13, v41, 1
	s_add_i32 s13, s12, 0x1fd0000
	s_waitcnt lgkmcnt(47)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[43:50], v[51:58], v[25:32]
	s_delay_alu instid0(VALU_DEP_2)
	v_add_nc_u32_e32 v35, 0x8000, v34
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[43:50], v[59:66], v[17:24]
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[43:50], v[67:74], v[9:16]
	s_waitcnt vmcnt(2)
	ds_store_b128 v40, v[83:86]
	ds_store_b128 v42, v[87:90]
	ds_store_b128 v42, v[91:94] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v42, v[95:98] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v42, v[99:102] offset:1536
	s_clause 0x1
	buffer_load_b128 v[87:90], v34, s[4:7], 0 offen slc
	buffer_load_b128 v[91:94], v35, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v35, 0x10000, v34
	v_add_nc_u32_e32 v34, 0x18000, v34
	buffer_load_b128 v[83:86], v33, s[8:11], 0 offen offset:3968
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[43:50], v[75:82], v[1:8]
	ds_load_b128 v[43:46], v39
	ds_load_b128 v[47:50], v39 offset:16
	ds_load_u16_d16_hi v51, v38 offset:128
	ds_load_u16_d16 v51, v38
	ds_load_u16_d16 v59, v38 offset:32
	ds_load_u16_d16 v52, v38 offset:256
	ds_load_u16_d16_hi v52, v38 offset:384
	ds_load_u16_d16 v53, v38 offset:512
	ds_load_u16_d16_hi v53, v38 offset:640
	ds_load_u16_d16 v54, v38 offset:768
	ds_load_u16_d16_hi v54, v38 offset:896
	ds_load_u16_d16 v55, v38 offset:1024
	ds_load_u16_d16_hi v55, v38 offset:1152
	ds_load_u16_d16 v56, v38 offset:1280
	ds_load_u16_d16_hi v56, v38 offset:1408
	ds_load_u16_d16 v57, v38 offset:1536
	ds_load_u16_d16_hi v57, v38 offset:1664
	ds_load_u16_d16 v58, v38 offset:1792
	ds_load_u16_d16_hi v58, v38 offset:1920
	ds_load_u16_d16_hi v59, v38 offset:160
	ds_load_u16_d16 v60, v38 offset:288
	ds_load_u16_d16_hi v60, v38 offset:416
	ds_load_u16_d16 v61, v38 offset:544
	ds_load_u16_d16_hi v61, v38 offset:672
	ds_load_u16_d16 v62, v38 offset:800
	ds_load_u16_d16_hi v62, v38 offset:928
	ds_load_u16_d16 v63, v38 offset:1056
	ds_load_u16_d16_hi v63, v38 offset:1184
	ds_load_u16_d16 v64, v38 offset:1312
	ds_load_u16_d16_hi v64, v38 offset:1440
	ds_load_u16_d16 v65, v38 offset:1568
	ds_load_u16_d16_hi v65, v38 offset:1696
	ds_load_u16_d16 v66, v38 offset:1824
	ds_load_u16_d16_hi v66, v38 offset:1952
	ds_load_u16_d16 v67, v38 offset:64
	ds_load_u16_d16_hi v67, v38 offset:192
	ds_load_u16_d16 v68, v38 offset:320
	ds_load_u16_d16_hi v68, v38 offset:448
	ds_load_u16_d16 v69, v38 offset:576
	ds_load_u16_d16_hi v69, v38 offset:704
	ds_load_u16_d16 v70, v38 offset:832
	ds_load_u16_d16_hi v70, v38 offset:960
	ds_load_u16_d16 v71, v38 offset:1088
	ds_load_u16_d16_hi v71, v38 offset:1216
	ds_load_u16_d16 v72, v38 offset:1344
	ds_load_u16_d16_hi v72, v38 offset:1472
	ds_load_u16_d16 v73, v38 offset:1600
	ds_load_u16_d16_hi v73, v38 offset:1728
	ds_load_u16_d16 v74, v38 offset:1856
	ds_load_u16_d16_hi v74, v38 offset:1984
	ds_load_u16_d16 v75, v38 offset:96
	ds_load_u16_d16_hi v75, v38 offset:224
	ds_load_u16_d16 v76, v38 offset:352
	ds_load_u16_d16_hi v76, v38 offset:480
	ds_load_u16_d16 v77, v38 offset:608
	ds_load_u16_d16_hi v77, v38 offset:736
	ds_load_u16_d16 v78, v38 offset:864
	ds_load_u16_d16_hi v78, v38 offset:992
	ds_load_u16_d16 v79, v38 offset:1120
	ds_load_u16_d16_hi v79, v38 offset:1248
	ds_load_u16_d16 v80, v38 offset:1376
	ds_load_u16_d16_hi v80, v38 offset:1504
	ds_load_u16_d16 v81, v38 offset:1632
	ds_load_u16_d16_hi v81, v38 offset:1760
	ds_load_u16_d16 v82, v38 offset:1888
	ds_load_u16_d16_hi v82, v38 offset:2016
	s_clause 0x1
	buffer_load_b128 v[95:98], v35, s[4:7], 0 offen slc
	buffer_load_b128 v[99:102], v34, s[4:7], 0 offen slc
	v_add_lshl_u32 v34, s13, v41, 1
	s_add_i32 s13, s12, 0x1fe0000
	s_waitcnt lgkmcnt(47)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[43:50], v[51:58], v[25:32]
	s_delay_alu instid0(VALU_DEP_2)
	v_add_nc_u32_e32 v35, 0x8000, v34
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[43:50], v[59:66], v[17:24]
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[43:50], v[67:74], v[9:16]
	s_waitcnt vmcnt(2)
	ds_store_b128 v40, v[83:86]
	ds_store_b128 v42, v[87:90]
	ds_store_b128 v42, v[91:94] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v42, v[95:98] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v42, v[99:102] offset:1536
	s_clause 0x1
	buffer_load_b128 v[87:90], v34, s[4:7], 0 offen slc
	buffer_load_b128 v[91:94], v35, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v35, 0x10000, v34
	v_add_nc_u32_e32 v34, 0x18000, v34
	buffer_load_b128 v[83:86], v33, s[8:11], 0 offen offset:4000
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[43:50], v[75:82], v[1:8]
	ds_load_b128 v[43:46], v39
	ds_load_b128 v[47:50], v39 offset:16
	ds_load_u16_d16_hi v51, v38 offset:128
	ds_load_u16_d16 v51, v38
	ds_load_u16_d16 v59, v38 offset:32
	ds_load_u16_d16 v52, v38 offset:256
	ds_load_u16_d16_hi v52, v38 offset:384
	ds_load_u16_d16 v53, v38 offset:512
	ds_load_u16_d16_hi v53, v38 offset:640
	ds_load_u16_d16 v54, v38 offset:768
	ds_load_u16_d16_hi v54, v38 offset:896
	ds_load_u16_d16 v55, v38 offset:1024
	ds_load_u16_d16_hi v55, v38 offset:1152
	ds_load_u16_d16 v56, v38 offset:1280
	ds_load_u16_d16_hi v56, v38 offset:1408
	ds_load_u16_d16 v57, v38 offset:1536
	ds_load_u16_d16_hi v57, v38 offset:1664
	ds_load_u16_d16 v58, v38 offset:1792
	ds_load_u16_d16_hi v58, v38 offset:1920
	ds_load_u16_d16_hi v59, v38 offset:160
	ds_load_u16_d16 v60, v38 offset:288
	ds_load_u16_d16_hi v60, v38 offset:416
	ds_load_u16_d16 v61, v38 offset:544
	ds_load_u16_d16_hi v61, v38 offset:672
	ds_load_u16_d16 v62, v38 offset:800
	ds_load_u16_d16_hi v62, v38 offset:928
	ds_load_u16_d16 v63, v38 offset:1056
	ds_load_u16_d16_hi v63, v38 offset:1184
	ds_load_u16_d16 v64, v38 offset:1312
	ds_load_u16_d16_hi v64, v38 offset:1440
	ds_load_u16_d16 v65, v38 offset:1568
	ds_load_u16_d16_hi v65, v38 offset:1696
	ds_load_u16_d16 v66, v38 offset:1824
	ds_load_u16_d16_hi v66, v38 offset:1952
	ds_load_u16_d16 v67, v38 offset:64
	ds_load_u16_d16_hi v67, v38 offset:192
	ds_load_u16_d16 v68, v38 offset:320
	ds_load_u16_d16_hi v68, v38 offset:448
	ds_load_u16_d16 v69, v38 offset:576
	ds_load_u16_d16_hi v69, v38 offset:704
	ds_load_u16_d16 v70, v38 offset:832
	ds_load_u16_d16_hi v70, v38 offset:960
	ds_load_u16_d16 v71, v38 offset:1088
	ds_load_u16_d16_hi v71, v38 offset:1216
	ds_load_u16_d16 v72, v38 offset:1344
	ds_load_u16_d16_hi v72, v38 offset:1472
	ds_load_u16_d16 v73, v38 offset:1600
	ds_load_u16_d16_hi v73, v38 offset:1728
	ds_load_u16_d16 v74, v38 offset:1856
	ds_load_u16_d16_hi v74, v38 offset:1984
	ds_load_u16_d16 v75, v38 offset:96
	ds_load_u16_d16_hi v75, v38 offset:224
	ds_load_u16_d16 v76, v38 offset:352
	ds_load_u16_d16_hi v76, v38 offset:480
	ds_load_u16_d16 v77, v38 offset:608
	ds_load_u16_d16_hi v77, v38 offset:736
	ds_load_u16_d16 v78, v38 offset:864
	ds_load_u16_d16_hi v78, v38 offset:992
	ds_load_u16_d16 v79, v38 offset:1120
	ds_load_u16_d16_hi v79, v38 offset:1248
	ds_load_u16_d16 v80, v38 offset:1376
	ds_load_u16_d16_hi v80, v38 offset:1504
	ds_load_u16_d16 v81, v38 offset:1632
	ds_load_u16_d16_hi v81, v38 offset:1760
	ds_load_u16_d16 v82, v38 offset:1888
	ds_load_u16_d16_hi v82, v38 offset:2016
	s_clause 0x1
	buffer_load_b128 v[95:98], v35, s[4:7], 0 offen slc
	buffer_load_b128 v[99:102], v34, s[4:7], 0 offen slc
	v_add_lshl_u32 v34, s13, v41, 1
	s_waitcnt lgkmcnt(47)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[43:50], v[51:58], v[25:32]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[43:50], v[59:66], v[17:24]
	v_add_nc_u32_e32 v35, 0x8000, v34
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[43:50], v[67:74], v[9:16]
	s_add_i32 s13, s12, 0x1ff0000
	s_waitcnt vmcnt(2)
	ds_store_b128 v40, v[83:86]
	ds_store_b128 v42, v[87:90]
	ds_store_b128 v42, v[91:94] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v42, v[95:98] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v42, v[99:102] offset:1536
	s_clause 0x1
	buffer_load_b128 v[87:90], v34, s[4:7], 0 offen slc
	buffer_load_b128 v[91:94], v35, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v35, 0x10000, v34
	v_add_nc_u32_e32 v34, 0x18000, v34
	buffer_load_b128 v[83:86], v33, s[8:11], 0 offen offset:4032
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[43:50], v[75:82], v[1:8]
	ds_load_b128 v[43:46], v39
	ds_load_b128 v[47:50], v39 offset:16
	ds_load_u16_d16_hi v51, v38 offset:128
	ds_load_u16_d16 v51, v38
	ds_load_u16_d16 v59, v38 offset:32
	ds_load_u16_d16 v52, v38 offset:256
	ds_load_u16_d16_hi v52, v38 offset:384
	ds_load_u16_d16 v53, v38 offset:512
	ds_load_u16_d16_hi v53, v38 offset:640
	ds_load_u16_d16 v54, v38 offset:768
	ds_load_u16_d16_hi v54, v38 offset:896
	ds_load_u16_d16 v55, v38 offset:1024
	ds_load_u16_d16_hi v55, v38 offset:1152
	ds_load_u16_d16 v56, v38 offset:1280
	ds_load_u16_d16_hi v56, v38 offset:1408
	ds_load_u16_d16 v57, v38 offset:1536
	ds_load_u16_d16_hi v57, v38 offset:1664
	ds_load_u16_d16 v58, v38 offset:1792
	ds_load_u16_d16_hi v58, v38 offset:1920
	ds_load_u16_d16_hi v59, v38 offset:160
	ds_load_u16_d16 v60, v38 offset:288
	ds_load_u16_d16_hi v60, v38 offset:416
	ds_load_u16_d16 v61, v38 offset:544
	ds_load_u16_d16_hi v61, v38 offset:672
	ds_load_u16_d16 v62, v38 offset:800
	ds_load_u16_d16_hi v62, v38 offset:928
	ds_load_u16_d16 v63, v38 offset:1056
	ds_load_u16_d16_hi v63, v38 offset:1184
	ds_load_u16_d16 v64, v38 offset:1312
	ds_load_u16_d16_hi v64, v38 offset:1440
	ds_load_u16_d16 v65, v38 offset:1568
	ds_load_u16_d16_hi v65, v38 offset:1696
	ds_load_u16_d16 v66, v38 offset:1824
	ds_load_u16_d16_hi v66, v38 offset:1952
	ds_load_u16_d16 v67, v38 offset:64
	ds_load_u16_d16_hi v67, v38 offset:192
	ds_load_u16_d16 v68, v38 offset:320
	ds_load_u16_d16_hi v68, v38 offset:448
	ds_load_u16_d16 v69, v38 offset:576
	ds_load_u16_d16_hi v69, v38 offset:704
	ds_load_u16_d16 v70, v38 offset:832
	ds_load_u16_d16_hi v70, v38 offset:960
	ds_load_u16_d16 v71, v38 offset:1088
	ds_load_u16_d16_hi v71, v38 offset:1216
	ds_load_u16_d16 v72, v38 offset:1344
	ds_load_u16_d16_hi v72, v38 offset:1472
	ds_load_u16_d16 v73, v38 offset:1600
	ds_load_u16_d16_hi v73, v38 offset:1728
	ds_load_u16_d16 v74, v38 offset:1856
	ds_load_u16_d16_hi v74, v38 offset:1984
	ds_load_u16_d16 v75, v38 offset:96
	ds_load_u16_d16_hi v75, v38 offset:224
	ds_load_u16_d16 v76, v38 offset:352
	ds_load_u16_d16_hi v76, v38 offset:480
	ds_load_u16_d16 v77, v38 offset:608
	ds_load_u16_d16_hi v77, v38 offset:736
	ds_load_u16_d16 v78, v38 offset:864
	ds_load_u16_d16_hi v78, v38 offset:992
	ds_load_u16_d16 v79, v38 offset:1120
	ds_load_u16_d16_hi v79, v38 offset:1248
	ds_load_u16_d16 v80, v38 offset:1376
	ds_load_u16_d16_hi v80, v38 offset:1504
	ds_load_u16_d16 v81, v38 offset:1632
	ds_load_u16_d16_hi v81, v38 offset:1760
	ds_load_u16_d16 v82, v38 offset:1888
	ds_load_u16_d16_hi v82, v38 offset:2016
	s_clause 0x1
	buffer_load_b128 v[95:98], v35, s[4:7], 0 offen slc
	buffer_load_b128 v[99:102], v34, s[4:7], 0 offen slc
	v_add_lshl_u32 v41, s13, v41, 1
	s_waitcnt lgkmcnt(47)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[43:50], v[51:58], v[25:32]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[43:50], v[59:66], v[17:24]
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[43:50], v[67:74], v[9:16]
	s_waitcnt vmcnt(2)
	ds_store_b128 v40, v[83:86]
	ds_store_b128 v42, v[87:90]
	ds_store_b128 v42, v[91:94] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v42, v[95:98] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v42, v[99:102] offset:1536
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[43:50], v[75:82], v[1:8]
	v_add_nc_u32_e32 v43, 0x8000, v41
	buffer_load_b128 v[83:86], v41, s[4:7], 0 offen slc
	buffer_load_b128 v[33:36], v33, s[8:11], 0 offen offset:4064
	buffer_load_b128 v[87:90], v43, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v43, 0x10000, v41
	v_add_nc_u32_e32 v41, 0x18000, v41
	v_lshlrev_b32_e32 v0, 8, v0
	s_clause 0x1
	buffer_load_b128 v[91:94], v43, s[4:7], 0 offen slc
	buffer_load_b128 v[95:98], v41, s[4:7], 0 offen slc
	ds_load_b128 v[43:46], v39
	ds_load_b128 v[47:50], v39 offset:16
	ds_load_u16_d16_hi v51, v38 offset:128
	ds_load_u16_d16 v51, v38
	ds_load_u16_d16 v59, v38 offset:32
	ds_load_u16_d16 v52, v38 offset:256
	ds_load_u16_d16_hi v52, v38 offset:384
	ds_load_u16_d16 v53, v38 offset:512
	ds_load_u16_d16_hi v53, v38 offset:640
	ds_load_u16_d16 v54, v38 offset:768
	ds_load_u16_d16_hi v54, v38 offset:896
	ds_load_u16_d16 v55, v38 offset:1024
	ds_load_u16_d16_hi v55, v38 offset:1152
	ds_load_u16_d16 v56, v38 offset:1280
	ds_load_u16_d16_hi v56, v38 offset:1408
	ds_load_u16_d16 v57, v38 offset:1536
	ds_load_u16_d16_hi v57, v38 offset:1664
	ds_load_u16_d16 v58, v38 offset:1792
	ds_load_u16_d16_hi v58, v38 offset:1920
	ds_load_u16_d16_hi v59, v38 offset:160
	ds_load_u16_d16 v60, v38 offset:288
	ds_load_u16_d16_hi v60, v38 offset:416
	ds_load_u16_d16 v61, v38 offset:544
	ds_load_u16_d16_hi v61, v38 offset:672
	ds_load_u16_d16 v62, v38 offset:800
	ds_load_u16_d16_hi v62, v38 offset:928
	ds_load_u16_d16 v63, v38 offset:1056
	ds_load_u16_d16_hi v63, v38 offset:1184
	ds_load_u16_d16 v64, v38 offset:1312
	ds_load_u16_d16_hi v64, v38 offset:1440
	ds_load_u16_d16 v65, v38 offset:1568
	ds_load_u16_d16_hi v65, v38 offset:1696
	ds_load_u16_d16 v66, v38 offset:1824
	ds_load_u16_d16_hi v66, v38 offset:1952
	ds_load_u16_d16 v67, v38 offset:64
	ds_load_u16_d16_hi v67, v38 offset:192
	ds_load_u16_d16 v68, v38 offset:320
	ds_load_u16_d16_hi v68, v38 offset:448
	ds_load_u16_d16 v69, v38 offset:576
	ds_load_u16_d16_hi v69, v38 offset:704
	ds_load_u16_d16 v70, v38 offset:832
	ds_load_u16_d16_hi v70, v38 offset:960
	ds_load_u16_d16 v71, v38 offset:1088
	ds_load_u16_d16_hi v71, v38 offset:1216
	ds_load_u16_d16 v72, v38 offset:1344
	ds_load_u16_d16_hi v72, v38 offset:1472
	ds_load_u16_d16 v73, v38 offset:1600
	ds_load_u16_d16_hi v73, v38 offset:1728
	ds_load_u16_d16 v74, v38 offset:1856
	ds_load_u16_d16_hi v74, v38 offset:1984
	ds_load_u16_d16 v75, v38 offset:96
	ds_load_u16_d16_hi v75, v38 offset:224
	ds_load_u16_d16 v76, v38 offset:352
	ds_load_u16_d16_hi v76, v38 offset:480
	ds_load_u16_d16 v77, v38 offset:608
	ds_load_u16_d16_hi v77, v38 offset:736
	ds_load_u16_d16 v78, v38 offset:864
	ds_load_u16_d16_hi v78, v38 offset:992
	ds_load_u16_d16 v79, v38 offset:1120
	ds_load_u16_d16_hi v79, v38 offset:1248
	ds_load_u16_d16 v80, v38 offset:1376
	ds_load_u16_d16_hi v80, v38 offset:1504
	ds_load_u16_d16 v81, v38 offset:1632
	ds_load_u16_d16_hi v81, v38 offset:1760
	ds_load_u16_d16 v82, v38 offset:1888
	ds_load_u16_d16_hi v82, v38 offset:2016
	s_waitcnt lgkmcnt(47)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[43:50], v[51:58], v[25:32]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[43:50], v[59:66], v[17:24]
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[43:50], v[67:74], v[9:16]
	s_waitcnt vmcnt(3)
	ds_store_b128 v40, v[33:36]
	ds_store_b128 v42, v[83:86]
	s_waitcnt vmcnt(2)
	ds_store_b128 v42, v[87:90] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v42, v[91:94] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v42, v[95:98] offset:1536
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[43:50], v[75:82], v[1:8]
	ds_load_b128 v[40:43], v39
	ds_load_b128 v[44:47], v39 offset:16
	ds_load_u16_d16_hi v48, v38 offset:128
	ds_load_u16_d16 v48, v38
	ds_load_u16_d16 v56, v38 offset:32
	ds_load_u16_d16 v49, v38 offset:256
	ds_load_u16_d16_hi v49, v38 offset:384
	ds_load_u16_d16 v50, v38 offset:512
	ds_load_u16_d16_hi v50, v38 offset:640
	ds_load_u16_d16 v51, v38 offset:768
	ds_load_u16_d16_hi v51, v38 offset:896
	ds_load_u16_d16 v52, v38 offset:1024
	ds_load_u16_d16_hi v52, v38 offset:1152
	ds_load_u16_d16 v53, v38 offset:1280
	ds_load_u16_d16_hi v53, v38 offset:1408
	ds_load_u16_d16 v54, v38 offset:1536
	ds_load_u16_d16_hi v54, v38 offset:1664
	ds_load_u16_d16 v55, v38 offset:1792
	ds_load_u16_d16_hi v55, v38 offset:1920
	ds_load_u16_d16_hi v56, v38 offset:160
	ds_load_u16_d16 v57, v38 offset:288
	ds_load_u16_d16_hi v57, v38 offset:416
	ds_load_u16_d16 v58, v38 offset:544
	ds_load_u16_d16_hi v58, v38 offset:672
	ds_load_u16_d16 v59, v38 offset:800
	ds_load_u16_d16_hi v59, v38 offset:928
	ds_load_u16_d16 v60, v38 offset:1056
	ds_load_u16_d16_hi v60, v38 offset:1184
	ds_load_u16_d16 v61, v38 offset:1312
	ds_load_u16_d16_hi v61, v38 offset:1440
	ds_load_u16_d16 v62, v38 offset:1568
	ds_load_u16_d16_hi v62, v38 offset:1696
	ds_load_u16_d16 v63, v38 offset:1824
	ds_load_u16_d16_hi v63, v38 offset:1952
	ds_load_u16_d16 v64, v38 offset:64
	ds_load_u16_d16_hi v64, v38 offset:192
	ds_load_u16_d16 v65, v38 offset:320
	ds_load_u16_d16_hi v65, v38 offset:448
	ds_load_u16_d16 v66, v38 offset:576
	ds_load_u16_d16_hi v66, v38 offset:704
	ds_load_u16_d16 v67, v38 offset:832
	ds_load_u16_d16_hi v67, v38 offset:960
	ds_load_u16_d16 v68, v38 offset:1088
	ds_load_u16_d16_hi v68, v38 offset:1216
	ds_load_u16_d16 v69, v38 offset:1344
	ds_load_u16_d16_hi v69, v38 offset:1472
	ds_load_u16_d16 v70, v38 offset:1600
	ds_load_u16_d16_hi v70, v38 offset:1728
	ds_load_u16_d16 v71, v38 offset:1856
	ds_load_u16_d16_hi v71, v38 offset:1984
	ds_load_u16_d16 v72, v38 offset:96
	ds_load_u16_d16_hi v72, v38 offset:224
	ds_load_u16_d16 v73, v38 offset:352
	ds_load_u16_d16_hi v73, v38 offset:480
	ds_load_u16_d16 v74, v38 offset:608
	ds_load_u16_d16_hi v74, v38 offset:736
	ds_load_u16_d16 v75, v38 offset:864
	ds_load_u16_d16_hi v75, v38 offset:992
	ds_load_u16_d16 v76, v38 offset:1120
	ds_load_u16_d16_hi v76, v38 offset:1248
	ds_load_u16_d16 v77, v38 offset:1376
	ds_load_u16_d16_hi v77, v38 offset:1504
	ds_load_u16_d16 v78, v38 offset:1632
	ds_load_u16_d16_hi v78, v38 offset:1760
	ds_load_u16_d16 v79, v38 offset:1888
	ds_load_u16_d16_hi v79, v38 offset:2016
	s_waitcnt lgkmcnt(47)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[40:47], v[48:55], v[25:32]
	v_and_b32_e32 v0, 0x1000, v0
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[40:47], v[56:63], v[17:24]
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[40:47], v[64:71], v[9:16]
	v_bfe_u32 v33, v25, 16, 1
	v_or_b32_e32 v34, 0x400000, v25
	v_cmp_u_f32_e32 vcc_lo, v25, v25
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v33, v33, v25, 0x7fff
	v_cndmask_b32_e32 v25, v33, v34, vcc_lo
	v_or_b32_e32 v34, 0x400000, v26
	v_cmp_u_f32_e32 vcc_lo, v26, v26
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[40:47], v[72:79], v[1:8]
	v_lshrrev_b32_e32 v33, 16, v25
	v_bfe_u32 v25, v26, 16, 1
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v25, v25, v26, 0x7fff
	v_cndmask_b32_e32 v25, v25, v34, vcc_lo
	v_or_b32_e32 v34, 0x400000, v27
	v_cmp_u_f32_e32 vcc_lo, v27, v27
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_lshrrev_b32_e32 v26, 16, v25
	v_bfe_u32 v25, v27, 16, 1
	v_add3_u32 v25, v25, v27, 0x7fff
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_cndmask_b32_e32 v25, v25, v34, vcc_lo
	v_or_b32_e32 v34, 0x400000, v28
	v_cmp_u_f32_e32 vcc_lo, v28, v28
	v_lshrrev_b32_e32 v27, 16, v25
	v_bfe_u32 v25, v28, 16, 1
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v25, v25, v28, 0x7fff
	v_cndmask_b32_e32 v25, v25, v34, vcc_lo
	v_or_b32_e32 v34, 0x400000, v29
	v_cmp_u_f32_e32 vcc_lo, v29, v29
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_lshrrev_b32_e32 v28, 16, v25
	v_bfe_u32 v25, v29, 16, 1
	v_add3_u32 v25, v25, v29, 0x7fff
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_cndmask_b32_e32 v25, v25, v34, vcc_lo
	v_or_b32_e32 v34, 0x400000, v30
	v_cmp_u_f32_e32 vcc_lo, v30, v30
	v_lshrrev_b32_e32 v29, 16, v25
	v_bfe_u32 v25, v30, 16, 1
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v25, v25, v30, 0x7fff
	v_cndmask_b32_e32 v25, v25, v34, vcc_lo
	v_or_b32_e32 v34, 0x400000, v31
	v_cmp_u_f32_e32 vcc_lo, v31, v31
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_lshrrev_b32_e32 v30, 16, v25
	v_bfe_u32 v25, v31, 16, 1
	v_add3_u32 v25, v25, v31, 0x7fff
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_cndmask_b32_e32 v25, v25, v34, vcc_lo
	v_or_b32_e32 v34, 0x400000, v32
	v_cmp_u_f32_e32 vcc_lo, v32, v32
	v_lshrrev_b32_e32 v31, 16, v25
	v_bfe_u32 v25, v32, 16, 1
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_add3_u32 v25, v25, v32, 0x7fff
	v_bfe_u32 v32, v17, 16, 1
	v_cndmask_b32_e32 v25, v25, v34, vcc_lo
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_4)
	v_add3_u32 v32, v32, v17, 0x7fff
	v_or_b32_e32 v34, 0x400000, v17
	v_cmp_u_f32_e32 vcc_lo, v17, v17
	v_lshrrev_b32_e32 v25, 16, v25
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_cndmask_b32_e32 v17, v32, v34, vcc_lo
	v_bfe_u32 v32, v18, 16, 1
	v_or_b32_e32 v34, 0x400000, v18
	v_cmp_u_f32_e32 vcc_lo, v18, v18
	v_lshrrev_b32_e32 v17, 16, v17
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v32, v32, v18, 0x7fff
	v_cndmask_b32_e32 v18, v32, v34, vcc_lo
	v_bfe_u32 v32, v19, 16, 1
	v_or_b32_e32 v34, 0x400000, v19
	v_cmp_u_f32_e32 vcc_lo, v19, v19
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v32, v32, v19, 0x7fff
	v_cndmask_b32_e32 v19, v32, v34, vcc_lo
	v_bfe_u32 v32, v20, 16, 1
	v_or_b32_e32 v34, 0x400000, v20
	v_cmp_u_f32_e32 vcc_lo, v20, v20
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_lshrrev_b32_e32 v19, 16, v19
	v_add3_u32 v32, v32, v20, 0x7fff
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_3)
	v_cndmask_b32_e32 v20, v32, v34, vcc_lo
	v_bfe_u32 v32, v21, 16, 1
	v_or_b32_e32 v34, 0x400000, v21
	v_cmp_u_f32_e32 vcc_lo, v21, v21
	v_add3_u32 v32, v32, v21, 0x7fff
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_cndmask_b32_e32 v21, v32, v34, vcc_lo
	v_bfe_u32 v32, v22, 16, 1
	v_or_b32_e32 v34, 0x400000, v22
	v_cmp_u_f32_e32 vcc_lo, v22, v22
	v_lshrrev_b32_e32 v21, 16, v21
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v32, v32, v22, 0x7fff
	v_cndmask_b32_e32 v22, v32, v34, vcc_lo
	v_bfe_u32 v32, v23, 16, 1
	v_or_b32_e32 v34, 0x400000, v23
	v_cmp_u_f32_e32 vcc_lo, v23, v23
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v32, v32, v23, 0x7fff
	v_cndmask_b32_e32 v23, v32, v34, vcc_lo
	v_bfe_u32 v32, v24, 16, 1
	v_or_b32_e32 v34, 0x400000, v24
	v_cmp_u_f32_e32 vcc_lo, v24, v24
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_lshrrev_b32_e32 v23, 16, v23
	v_add3_u32 v32, v32, v24, 0x7fff
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_cndmask_b32_e32 v24, v32, v34, vcc_lo
	v_bfe_u32 v32, v9, 16, 1
	v_or_b32_e32 v34, 0x400000, v9
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_lshrrev_b32_e32 v24, 16, v24
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v32, v32, v9, 0x7fff
	v_cndmask_b32_e32 v9, v32, v34, vcc_lo
	v_bfe_u32 v32, v10, 16, 1
	v_or_b32_e32 v34, 0x400000, v10
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_lshrrev_b32_e32 v9, 16, v9
	v_add3_u32 v32, v32, v10, 0x7fff
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_cndmask_b32_e32 v10, v32, v34, vcc_lo
	v_bfe_u32 v32, v11, 16, 1
	v_or_b32_e32 v34, 0x400000, v11
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_lshrrev_b32_e32 v10, 16, v10
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v32, v32, v11, 0x7fff
	v_cndmask_b32_e32 v11, v32, v34, vcc_lo
	v_bfe_u32 v32, v12, 16, 1
	v_or_b32_e32 v34, 0x400000, v12
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_lshrrev_b32_e32 v11, 16, v11
	v_add3_u32 v32, v32, v12, 0x7fff
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_cndmask_b32_e32 v12, v32, v34, vcc_lo
	v_bfe_u32 v32, v13, 16, 1
	v_or_b32_e32 v34, 0x400000, v13
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_lshrrev_b32_e32 v12, 16, v12
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v32, v32, v13, 0x7fff
	v_cndmask_b32_e32 v13, v32, v34, vcc_lo
	v_bfe_u32 v32, v14, 16, 1
	v_or_b32_e32 v34, 0x400000, v14
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_lshrrev_b32_e32 v13, 16, v13
	v_add3_u32 v32, v32, v14, 0x7fff
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_cndmask_b32_e32 v14, v32, v34, vcc_lo
	v_bfe_u32 v32, v15, 16, 1
	v_or_b32_e32 v34, 0x400000, v15
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_lshrrev_b32_e32 v14, 16, v14
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v32, v32, v15, 0x7fff
	v_cndmask_b32_e32 v15, v32, v34, vcc_lo
	v_bfe_u32 v32, v16, 16, 1
	v_or_b32_e32 v34, 0x400000, v16
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_lshrrev_b32_e32 v15, 16, v15
	v_add3_u32 v32, v32, v16, 0x7fff
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_cndmask_b32_e32 v16, v32, v34, vcc_lo
	v_bfe_u32 v32, v1, 16, 1
	v_or_b32_e32 v34, 0x400000, v1
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	v_lshrrev_b32_e32 v16, 16, v16
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v32, v32, v1, 0x7fff
	v_cndmask_b32_e32 v1, v32, v34, vcc_lo
	v_bfe_u32 v32, v2, 16, 1
	v_or_b32_e32 v34, 0x400000, v2
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_lshrrev_b32_e32 v1, 16, v1
	v_add3_u32 v32, v32, v2, 0x7fff
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_cndmask_b32_e32 v2, v32, v34, vcc_lo
	v_bfe_u32 v32, v3, 16, 1
	v_or_b32_e32 v34, 0x400000, v3
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_lshrrev_b32_e32 v2, 16, v2
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v32, v32, v3, 0x7fff
	v_cndmask_b32_e32 v3, v32, v34, vcc_lo
	v_bfe_u32 v32, v4, 16, 1
	v_or_b32_e32 v34, 0x400000, v4
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_lshrrev_b32_e32 v3, 16, v3
	v_add3_u32 v32, v32, v4, 0x7fff
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_cndmask_b32_e32 v4, v32, v34, vcc_lo
	v_bfe_u32 v32, v5, 16, 1
	v_or_b32_e32 v34, 0x400000, v5
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_lshrrev_b32_e32 v4, 16, v4
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v32, v32, v5, 0x7fff
	v_cndmask_b32_e32 v5, v32, v34, vcc_lo
	v_bfe_u32 v32, v6, 16, 1
	v_or_b32_e32 v34, 0x400000, v6
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_lshrrev_b32_e32 v5, 16, v5
	v_add3_u32 v32, v32, v6, 0x7fff
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_cndmask_b32_e32 v6, v32, v34, vcc_lo
	v_bfe_u32 v32, v7, 16, 1
	v_or_b32_e32 v34, 0x400000, v7
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_lshrrev_b32_e32 v6, 16, v6
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add3_u32 v32, v32, v7, 0x7fff
	v_cndmask_b32_e32 v7, v32, v34, vcc_lo
	v_bfe_u32 v32, v8, 16, 1
	v_or_b32_e32 v34, 0x400000, v8
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_lshrrev_b32_e32 v7, 16, v7
	v_add3_u32 v32, v32, v8, 0x7fff
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_cndmask_b32_e32 v8, v32, v34, vcc_lo
	v_or_b32_e32 v32, s12, v37
	v_lshrrev_b32_e32 v8, 16, v8
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_lshl_u32 v0, v32, v0, 1
	v_add_nc_u32_e32 v32, 0x4000, v0
	s_clause 0x1
	buffer_store_b16 v33, v0, s[0:3], 0 offen
	buffer_store_b16 v26, v32, s[0:3], 0 offen
	v_add_nc_u32_e32 v26, 0x8000, v0
	buffer_store_b16 v27, v26, s[0:3], 0 offen
	v_add_nc_u32_e32 v27, 0xc000, v0
	v_lshrrev_b32_e32 v18, 16, v18
	buffer_store_b16 v28, v27, s[0:3], 0 offen
	v_add_nc_u32_e32 v28, 0x10000, v0
	buffer_store_b16 v29, v28, s[0:3], 0 offen
	v_add_nc_u32_e32 v29, 0x14000, v0
	v_lshrrev_b32_e32 v20, 16, v20
	buffer_store_b16 v30, v29, s[0:3], 0 offen
	v_add_nc_u32_e32 v30, 0x18000, v0
	buffer_store_b16 v31, v30, s[0:3], 0 offen
	v_add_nc_u32_e32 v31, 0x1c000, v0
	v_lshrrev_b32_e32 v22, 16, v22
	s_clause 0x18
	buffer_store_b16 v25, v31, s[0:3], 0 offen
	buffer_store_b16 v17, v0, s[0:3], 0 offen offset:32
	buffer_store_b16 v18, v32, s[0:3], 0 offen offset:32
	buffer_store_b16 v19, v26, s[0:3], 0 offen offset:32
	buffer_store_b16 v20, v27, s[0:3], 0 offen offset:32
	buffer_store_b16 v21, v28, s[0:3], 0 offen offset:32
	buffer_store_b16 v22, v29, s[0:3], 0 offen offset:32
	buffer_store_b16 v23, v30, s[0:3], 0 offen offset:32
	buffer_store_b16 v24, v31, s[0:3], 0 offen offset:32
	buffer_store_b16 v9, v0, s[0:3], 0 offen offset:64
	buffer_store_b16 v10, v32, s[0:3], 0 offen offset:64
	buffer_store_b16 v11, v26, s[0:3], 0 offen offset:64
	buffer_store_b16 v12, v27, s[0:3], 0 offen offset:64
	buffer_store_b16 v13, v28, s[0:3], 0 offen offset:64
	buffer_store_b16 v14, v29, s[0:3], 0 offen offset:64
	buffer_store_b16 v15, v30, s[0:3], 0 offen offset:64
	buffer_store_b16 v16, v31, s[0:3], 0 offen offset:64
	buffer_store_b16 v1, v0, s[0:3], 0 offen offset:96
	buffer_store_b16 v2, v32, s[0:3], 0 offen offset:96
	buffer_store_b16 v3, v26, s[0:3], 0 offen offset:96
	buffer_store_b16 v4, v27, s[0:3], 0 offen offset:96
	buffer_store_b16 v5, v28, s[0:3], 0 offen offset:96
	buffer_store_b16 v6, v29, s[0:3], 0 offen offset:96
	buffer_store_b16 v7, v30, s[0:3], 0 offen offset:96
	buffer_store_b16 v8, v31, s[0:3], 0 offen offset:96
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
		.amdhsa_next_free_vgpr 105
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

	.set .Lexercise_kernel_0.num_vgpr, 105
	.set .Lexercise_kernel_0.num_agpr, 0
	.set .Lexercise_kernel_0.numbered_sgpr, 14
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
    .sgpr_count:     16
    .sgpr_spill_count: 0
    .symbol:         exercise_kernel_0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     105
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
