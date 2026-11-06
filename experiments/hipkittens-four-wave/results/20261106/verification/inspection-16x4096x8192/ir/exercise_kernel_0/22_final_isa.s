	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	exercise_kernel_0
	.p2align	8
	.type	exercise_kernel_0,@function
exercise_kernel_0:
	v_lshrrev_b32_e32 v8, 5, v0
	s_lshl_b32 s3, s2, 2
	s_bfe_i32 s2, s2, 0x1001d
	s_clause 0x1
	s_load_b64 s[8:9], s[0:1], 0x0
	s_load_b64 s[4:5], s[0:1], 0x18
	s_lshr_b32 s2, s2, 26
	v_or_b32_e32 v1, s3, v8
	v_bfe_u32 v40, v0, 3, 2
	v_bfe_u32 v58, v0, 1, 4
	s_mov_b32 s10, -1
	s_mov_b32 s11, 0x21027000
	v_dual_mov_b32 v9, 0 :: v_dual_add_nc_u32 v2, s2, v1
	v_lshlrev_b32_e32 v3, 3, v0
	s_mov_b32 s6, s10
	s_mov_b32 s7, s11
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_dual_mov_b32 v11, v9 :: v_dual_and_b32 v2, 0xffffffc0, v2
	v_dual_mov_b32 v10, v9 :: v_dual_and_b32 v39, 56, v3
	v_mov_b32_e32 v12, v9
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_4)
	v_sub_nc_u32_e32 v41, v1, v2
	v_dual_mov_b32 v14, v9 :: v_dual_lshlrev_b32 v1, 4, v0
	v_lshl_or_b32 v89, v40, 12, v39
	s_waitcnt lgkmcnt(0)
	s_and_b32 s9, s9, 0xffff
	v_dual_mov_b32 v13, v9 :: v_dual_lshlrev_b32 v110, 6, v41
	v_dual_mov_b32 v16, v9 :: v_dual_and_b32 v59, 16, v1
	s_and_b32 s5, s5, 0xffff
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_add_lshl_u32 v1, v110, v89, 1
	v_mul_u32_u24_e32 v61, 0x300, v8
	v_lshl_or_b32 v37, v58, 14, v59
	v_dual_mov_b32 v28, v9 :: v_dual_and_b32 v113, 15, v0
	s_delay_alu instid0(VALU_DEP_4)
	v_dual_mov_b32 v15, v9 :: v_dual_add_nc_u32 v2, 0x8000, v1
	v_dual_mov_b32 v26, v9 :: v_dual_add_nc_u32 v3, 0x10000, v1
	v_dual_mov_b32 v25, v9 :: v_dual_add_nc_u32 v4, 0x18000, v1
	buffer_load_b128 v[33:36], v37, s[8:11], 0 offen
	s_clause 0x3
	buffer_load_b128 v[42:45], v1, s[4:7], 0 offen slc
	buffer_load_b128 v[46:49], v2, s[4:7], 0 offen slc
	buffer_load_b128 v[50:53], v3, s[4:7], 0 offen slc
	buffer_load_b128 v[54:57], v4, s[4:7], 0 offen slc
	v_dual_mov_b32 v30, v9 :: v_dual_lshlrev_b32 v41, 7, v41
	v_or_b32_e32 v61, 0x2000, v61
	v_dual_mov_b32 v29, v9 :: v_dual_lshlrev_b32 v62, 11, v8
	v_dual_mov_b32 v27, v9 :: v_dual_and_b32 v60, 7, v0
	v_mul_u32_u24_e32 v63, 48, v58
	v_mul_u32_u24_e32 v64, 48, v113
	v_or_b32_e32 v59, v61, v59
	v_lshl_add_u32 v41, v40, 13, v41
	v_dual_mov_b32 v31, v9 :: v_dual_lshlrev_b32 v38, 7, v40
	v_lshl_or_b32 v39, v39, 1, v62
	v_mov_b32_e32 v32, v9
	v_dual_mov_b32 v17, v9 :: v_dual_add_nc_u32 v112, v59, v63
	v_mov_b32_e32 v18, v9
	v_mov_b32_e32 v19, v9
	v_mov_b32_e32 v20, v9
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
	v_lshl_or_b32 v109, v113, 1, v62
	v_or_b32_e32 v40, 64, v37
	v_add_nc_u32_e32 v111, v61, v64
	v_mad_u32_u24 v58, v58, 48, v59
	v_lshl_or_b32 v41, v60, 4, v41
	v_or_b32_e32 v62, v39, v38
	s_mov_b32 s2, 0
	s_waitcnt vmcnt(4)
	ds_store_b128 v58, v[33:36]
	s_waitcnt vmcnt(3)
	ds_store_b128 v62, v[42:45]
	s_waitcnt vmcnt(2)
	ds_store_b128 v62, v[46:49] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v62, v[50:53] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v62, v[54:57] offset:1536
.LBB0_1:
	v_add_nc_u32_e32 v42, s2, v41
	v_subrev_nc_u32_e32 v33, 32, v40
	ds_load_u16_d16_hi v59, v109 offset:160
	ds_load_u16_d16 v60, v109 offset:288
	ds_load_u16_d16_hi v60, v109 offset:416
	ds_load_u16_d16 v61, v109 offset:544
	ds_load_u16_d16_hi v61, v109 offset:672
	ds_load_u16_d16 v62, v109 offset:800
	ds_load_u16_d16_hi v62, v109 offset:928
	ds_load_u16_d16 v63, v109 offset:1056
	ds_load_u16_d16_hi v63, v109 offset:1184
	ds_load_u16_d16 v64, v109 offset:1312
	ds_load_u16_d16_hi v64, v109 offset:1440
	ds_load_u16_d16 v65, v109 offset:1568
	ds_load_u16_d16_hi v65, v109 offset:1696
	ds_load_u16_d16 v66, v109 offset:1824
	ds_load_u16_d16_hi v66, v109 offset:1952
	v_add_nc_u32_e32 v114, v39, v38
	s_add_i32 s2, s2, 0x80000
	v_add_nc_u32_e32 v43, 0x20000, v42
	buffer_load_b128 v[33:36], v33, s[8:11], 0 offen
	s_cmp_lg_u32 s2, 0x3f80000
	buffer_load_b128 v[67:70], v43, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v43, 0x28000, v42
	buffer_load_b128 v[71:74], v43, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v43, 0x30000, v42
	buffer_load_b128 v[75:78], v43, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v43, 0x38000, v42
	buffer_load_b128 v[79:82], v43, s[4:7], 0 offen slc
	ds_load_b128 v[43:46], v111
	ds_load_b128 v[47:50], v111 offset:16
	ds_load_u16_d16_hi v51, v109 offset:128
	ds_load_u16_d16 v51, v109
	ds_load_u16_d16 v59, v109 offset:32
	ds_load_u16_d16 v52, v109 offset:256
	ds_load_u16_d16_hi v52, v109 offset:384
	ds_load_u16_d16 v53, v109 offset:512
	ds_load_u16_d16_hi v53, v109 offset:640
	ds_load_u16_d16 v54, v109 offset:768
	ds_load_u16_d16_hi v54, v109 offset:896
	ds_load_u16_d16 v55, v109 offset:1024
	ds_load_u16_d16_hi v55, v109 offset:1152
	ds_load_u16_d16 v56, v109 offset:1280
	ds_load_u16_d16_hi v56, v109 offset:1408
	ds_load_u16_d16 v57, v109 offset:1536
	ds_load_u16_d16_hi v57, v109 offset:1664
	ds_load_u16_d16 v58, v109 offset:1792
	ds_load_u16_d16_hi v58, v109 offset:1920
	s_waitcnt lgkmcnt(14)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[43:50], v[59:66], v[25:32]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[43:50], v[51:58], v[9:16]
	ds_load_u16_d16 v51, v109 offset:64
	ds_load_u16_d16_hi v51, v109 offset:192
	ds_load_u16_d16 v52, v109 offset:320
	ds_load_u16_d16_hi v52, v109 offset:448
	ds_load_u16_d16 v53, v109 offset:576
	ds_load_u16_d16_hi v53, v109 offset:704
	ds_load_u16_d16 v54, v109 offset:832
	ds_load_u16_d16_hi v54, v109 offset:960
	ds_load_u16_d16 v55, v109 offset:1088
	ds_load_u16_d16_hi v55, v109 offset:1216
	ds_load_u16_d16 v56, v109 offset:1344
	ds_load_u16_d16_hi v56, v109 offset:1472
	ds_load_u16_d16 v57, v109 offset:1600
	ds_load_u16_d16_hi v57, v109 offset:1728
	ds_load_u16_d16 v58, v109 offset:1856
	ds_load_u16_d16_hi v58, v109 offset:1984
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[43:50], v[51:58], v[17:24]
	ds_load_u16_d16 v51, v109 offset:96
	ds_load_u16_d16_hi v51, v109 offset:224
	ds_load_u16_d16 v52, v109 offset:352
	ds_load_u16_d16_hi v52, v109 offset:480
	ds_load_u16_d16 v53, v109 offset:608
	ds_load_u16_d16_hi v53, v109 offset:736
	ds_load_u16_d16 v54, v109 offset:864
	ds_load_u16_d16_hi v54, v109 offset:992
	ds_load_u16_d16 v55, v109 offset:1120
	ds_load_u16_d16_hi v55, v109 offset:1248
	ds_load_u16_d16 v56, v109 offset:1376
	ds_load_u16_d16_hi v56, v109 offset:1504
	ds_load_u16_d16 v57, v109 offset:1632
	ds_load_u16_d16_hi v57, v109 offset:1760
	ds_load_u16_d16 v58, v109 offset:1888
	ds_load_u16_d16_hi v58, v109 offset:2016
	s_waitcnt vmcnt(3)
	ds_store_b128 v114, v[67:70]
	s_waitcnt vmcnt(2)
	ds_store_b128 v114, v[71:74] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v114, v[75:78] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v114, v[79:82] offset:1536
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[43:50], v[51:58], v[1:8]
	v_add_nc_u32_e32 v43, 0x40000, v42
	ds_store_b128 v112, v[33:36]
	buffer_load_b128 v[33:36], v40, s[8:11], 0 offen
	buffer_load_b128 v[67:70], v43, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v43, 0x48000, v42
	ds_load_u16_d16_hi v59, v109 offset:160
	ds_load_u16_d16 v60, v109 offset:288
	ds_load_u16_d16_hi v60, v109 offset:416
	ds_load_u16_d16 v61, v109 offset:544
	ds_load_u16_d16_hi v61, v109 offset:672
	ds_load_u16_d16 v62, v109 offset:800
	ds_load_u16_d16_hi v62, v109 offset:928
	ds_load_u16_d16 v63, v109 offset:1056
	ds_load_u16_d16_hi v63, v109 offset:1184
	ds_load_u16_d16 v64, v109 offset:1312
	ds_load_u16_d16_hi v64, v109 offset:1440
	ds_load_u16_d16 v65, v109 offset:1568
	ds_load_u16_d16_hi v65, v109 offset:1696
	ds_load_u16_d16 v66, v109 offset:1824
	ds_load_u16_d16_hi v66, v109 offset:1952
	buffer_load_b128 v[71:74], v43, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v43, 0x50000, v42
	buffer_load_b128 v[75:78], v43, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v43, 0x58000, v42
	buffer_load_b128 v[79:82], v43, s[4:7], 0 offen slc
	ds_load_b128 v[43:46], v111
	ds_load_b128 v[47:50], v111 offset:16
	ds_load_u16_d16_hi v51, v109 offset:128
	ds_load_u16_d16 v51, v109
	ds_load_u16_d16 v59, v109 offset:32
	ds_load_u16_d16 v52, v109 offset:256
	ds_load_u16_d16_hi v52, v109 offset:384
	ds_load_u16_d16 v53, v109 offset:512
	ds_load_u16_d16_hi v53, v109 offset:640
	ds_load_u16_d16 v54, v109 offset:768
	ds_load_u16_d16_hi v54, v109 offset:896
	ds_load_u16_d16 v55, v109 offset:1024
	ds_load_u16_d16_hi v55, v109 offset:1152
	ds_load_u16_d16 v56, v109 offset:1280
	ds_load_u16_d16_hi v56, v109 offset:1408
	ds_load_u16_d16 v57, v109 offset:1536
	ds_load_u16_d16_hi v57, v109 offset:1664
	ds_load_u16_d16 v58, v109 offset:1792
	ds_load_u16_d16_hi v58, v109 offset:1920
	s_waitcnt lgkmcnt(14)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[43:50], v[59:66], v[25:32]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[43:50], v[51:58], v[9:16]
	ds_load_u16_d16 v51, v109 offset:64
	ds_load_u16_d16_hi v51, v109 offset:192
	ds_load_u16_d16 v52, v109 offset:320
	ds_load_u16_d16_hi v52, v109 offset:448
	ds_load_u16_d16 v53, v109 offset:576
	ds_load_u16_d16_hi v53, v109 offset:704
	ds_load_u16_d16 v54, v109 offset:832
	ds_load_u16_d16_hi v54, v109 offset:960
	ds_load_u16_d16 v55, v109 offset:1088
	ds_load_u16_d16_hi v55, v109 offset:1216
	ds_load_u16_d16 v56, v109 offset:1344
	ds_load_u16_d16_hi v56, v109 offset:1472
	ds_load_u16_d16 v57, v109 offset:1600
	ds_load_u16_d16_hi v57, v109 offset:1728
	ds_load_u16_d16 v58, v109 offset:1856
	ds_load_u16_d16_hi v58, v109 offset:1984
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[43:50], v[51:58], v[17:24]
	ds_load_u16_d16 v51, v109 offset:96
	ds_load_u16_d16_hi v51, v109 offset:224
	ds_load_u16_d16 v52, v109 offset:352
	ds_load_u16_d16_hi v52, v109 offset:480
	ds_load_u16_d16 v53, v109 offset:608
	ds_load_u16_d16_hi v53, v109 offset:736
	ds_load_u16_d16 v54, v109 offset:864
	ds_load_u16_d16_hi v54, v109 offset:992
	ds_load_u16_d16 v55, v109 offset:1120
	ds_load_u16_d16_hi v55, v109 offset:1248
	ds_load_u16_d16 v56, v109 offset:1376
	ds_load_u16_d16_hi v56, v109 offset:1504
	ds_load_u16_d16 v57, v109 offset:1632
	ds_load_u16_d16_hi v57, v109 offset:1760
	ds_load_u16_d16 v58, v109 offset:1888
	ds_load_u16_d16_hi v58, v109 offset:2016
	s_waitcnt vmcnt(4)
	ds_store_b128 v112, v[33:36]
	s_waitcnt vmcnt(3)
	ds_store_b128 v114, v[67:70]
	s_waitcnt vmcnt(2)
	ds_store_b128 v114, v[71:74] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v114, v[75:78] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v114, v[79:82] offset:1536
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[43:50], v[51:58], v[1:8]
	v_add_nc_u32_e32 v43, 0x60000, v42
	buffer_load_b128 v[33:36], v40, s[8:11], 0 offen offset:32
	ds_load_u16_d16_hi v59, v109 offset:160
	ds_load_u16_d16 v60, v109 offset:288
	ds_load_u16_d16_hi v60, v109 offset:416
	ds_load_u16_d16 v61, v109 offset:544
	ds_load_u16_d16_hi v61, v109 offset:672
	ds_load_u16_d16 v62, v109 offset:800
	ds_load_u16_d16_hi v62, v109 offset:928
	ds_load_u16_d16 v63, v109 offset:1056
	ds_load_u16_d16_hi v63, v109 offset:1184
	ds_load_u16_d16 v64, v109 offset:1312
	ds_load_u16_d16_hi v64, v109 offset:1440
	ds_load_u16_d16 v65, v109 offset:1568
	ds_load_u16_d16_hi v65, v109 offset:1696
	ds_load_u16_d16 v66, v109 offset:1824
	ds_load_u16_d16_hi v66, v109 offset:1952
	buffer_load_b128 v[67:70], v43, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v43, 0x68000, v42
	buffer_load_b128 v[71:74], v43, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v43, 0x70000, v42
	buffer_load_b128 v[75:78], v43, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v43, 0x78000, v42
	buffer_load_b128 v[79:82], v43, s[4:7], 0 offen slc
	ds_load_b128 v[43:46], v111
	ds_load_b128 v[47:50], v111 offset:16
	ds_load_u16_d16_hi v51, v109 offset:128
	ds_load_u16_d16 v51, v109
	ds_load_u16_d16 v59, v109 offset:32
	ds_load_u16_d16 v52, v109 offset:256
	ds_load_u16_d16_hi v52, v109 offset:384
	ds_load_u16_d16 v53, v109 offset:512
	ds_load_u16_d16_hi v53, v109 offset:640
	ds_load_u16_d16 v54, v109 offset:768
	ds_load_u16_d16_hi v54, v109 offset:896
	ds_load_u16_d16 v55, v109 offset:1024
	ds_load_u16_d16_hi v55, v109 offset:1152
	ds_load_u16_d16 v56, v109 offset:1280
	ds_load_u16_d16_hi v56, v109 offset:1408
	ds_load_u16_d16 v57, v109 offset:1536
	ds_load_u16_d16_hi v57, v109 offset:1664
	ds_load_u16_d16 v58, v109 offset:1792
	ds_load_u16_d16_hi v58, v109 offset:1920
	s_waitcnt lgkmcnt(14)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[43:50], v[59:66], v[25:32]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[43:50], v[51:58], v[9:16]
	ds_load_u16_d16 v51, v109 offset:64
	ds_load_u16_d16_hi v51, v109 offset:192
	ds_load_u16_d16 v52, v109 offset:320
	ds_load_u16_d16_hi v52, v109 offset:448
	ds_load_u16_d16 v53, v109 offset:576
	ds_load_u16_d16_hi v53, v109 offset:704
	ds_load_u16_d16 v54, v109 offset:832
	ds_load_u16_d16_hi v54, v109 offset:960
	ds_load_u16_d16 v55, v109 offset:1088
	ds_load_u16_d16_hi v55, v109 offset:1216
	ds_load_u16_d16 v56, v109 offset:1344
	ds_load_u16_d16_hi v56, v109 offset:1472
	ds_load_u16_d16 v57, v109 offset:1600
	ds_load_u16_d16_hi v57, v109 offset:1728
	ds_load_u16_d16 v58, v109 offset:1856
	ds_load_u16_d16_hi v58, v109 offset:1984
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[43:50], v[51:58], v[17:24]
	ds_load_u16_d16 v51, v109 offset:96
	ds_load_u16_d16_hi v51, v109 offset:224
	ds_load_u16_d16 v52, v109 offset:352
	ds_load_u16_d16_hi v52, v109 offset:480
	ds_load_u16_d16 v53, v109 offset:608
	ds_load_u16_d16_hi v53, v109 offset:736
	ds_load_u16_d16 v54, v109 offset:864
	ds_load_u16_d16_hi v54, v109 offset:992
	ds_load_u16_d16 v55, v109 offset:1120
	ds_load_u16_d16_hi v55, v109 offset:1248
	ds_load_u16_d16 v56, v109 offset:1376
	ds_load_u16_d16_hi v56, v109 offset:1504
	ds_load_u16_d16 v57, v109 offset:1632
	ds_load_u16_d16_hi v57, v109 offset:1760
	ds_load_u16_d16 v58, v109 offset:1888
	ds_load_u16_d16_hi v58, v109 offset:2016
	s_waitcnt vmcnt(4)
	ds_store_b128 v112, v[33:36]
	s_waitcnt vmcnt(3)
	ds_store_b128 v114, v[67:70]
	s_waitcnt vmcnt(2)
	ds_store_b128 v114, v[71:74] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v114, v[75:78] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v114, v[79:82] offset:1536
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[43:50], v[51:58], v[1:8]
	v_add_nc_u32_e32 v43, 0x80000, v42
	buffer_load_b128 v[33:36], v40, s[8:11], 0 offen offset:64
	ds_load_u16_d16_hi v58, v109 offset:160
	ds_load_u16_d16 v59, v109 offset:288
	ds_load_u16_d16_hi v59, v109 offset:416
	ds_load_u16_d16 v60, v109 offset:544
	ds_load_u16_d16_hi v60, v109 offset:672
	ds_load_u16_d16 v61, v109 offset:800
	ds_load_u16_d16_hi v61, v109 offset:928
	ds_load_u16_d16 v62, v109 offset:1056
	ds_load_u16_d16_hi v62, v109 offset:1184
	ds_load_u16_d16 v63, v109 offset:1312
	ds_load_u16_d16_hi v63, v109 offset:1440
	ds_load_u16_d16 v64, v109 offset:1568
	ds_load_u16_d16_hi v64, v109 offset:1696
	ds_load_u16_d16 v65, v109 offset:1824
	ds_load_u16_d16_hi v65, v109 offset:1952
	buffer_load_b128 v[66:69], v43, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v43, 0x88000, v42
	v_add_nc_u32_e32 v40, 0x80, v40
	buffer_load_b128 v[70:73], v43, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v43, 0x90000, v42
	v_add_nc_u32_e32 v42, 0x98000, v42
	s_clause 0x1
	buffer_load_b128 v[74:77], v43, s[4:7], 0 offen slc
	buffer_load_b128 v[78:81], v42, s[4:7], 0 offen slc
	ds_load_b128 v[42:45], v111
	ds_load_b128 v[46:49], v111 offset:16
	ds_load_u16_d16_hi v50, v109 offset:128
	ds_load_u16_d16 v50, v109
	ds_load_u16_d16 v58, v109 offset:32
	ds_load_u16_d16 v51, v109 offset:256
	ds_load_u16_d16_hi v51, v109 offset:384
	ds_load_u16_d16 v52, v109 offset:512
	ds_load_u16_d16_hi v52, v109 offset:640
	ds_load_u16_d16 v53, v109 offset:768
	ds_load_u16_d16_hi v53, v109 offset:896
	ds_load_u16_d16 v54, v109 offset:1024
	ds_load_u16_d16_hi v54, v109 offset:1152
	ds_load_u16_d16 v55, v109 offset:1280
	ds_load_u16_d16_hi v55, v109 offset:1408
	ds_load_u16_d16 v56, v109 offset:1536
	ds_load_u16_d16_hi v56, v109 offset:1664
	ds_load_u16_d16 v57, v109 offset:1792
	ds_load_u16_d16_hi v57, v109 offset:1920
	s_waitcnt lgkmcnt(14)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[42:49], v[58:65], v[25:32]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[42:49], v[50:57], v[9:16]
	ds_load_u16_d16 v50, v109 offset:64
	ds_load_u16_d16_hi v50, v109 offset:192
	ds_load_u16_d16 v51, v109 offset:320
	ds_load_u16_d16_hi v51, v109 offset:448
	ds_load_u16_d16 v52, v109 offset:576
	ds_load_u16_d16_hi v52, v109 offset:704
	ds_load_u16_d16 v53, v109 offset:832
	ds_load_u16_d16_hi v53, v109 offset:960
	ds_load_u16_d16 v54, v109 offset:1088
	ds_load_u16_d16_hi v54, v109 offset:1216
	ds_load_u16_d16 v55, v109 offset:1344
	ds_load_u16_d16_hi v55, v109 offset:1472
	ds_load_u16_d16 v56, v109 offset:1600
	ds_load_u16_d16_hi v56, v109 offset:1728
	ds_load_u16_d16 v57, v109 offset:1856
	ds_load_u16_d16_hi v57, v109 offset:1984
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[42:49], v[50:57], v[17:24]
	ds_load_u16_d16 v50, v109 offset:96
	ds_load_u16_d16_hi v50, v109 offset:224
	ds_load_u16_d16 v51, v109 offset:352
	ds_load_u16_d16_hi v51, v109 offset:480
	ds_load_u16_d16 v52, v109 offset:608
	ds_load_u16_d16_hi v52, v109 offset:736
	ds_load_u16_d16 v53, v109 offset:864
	ds_load_u16_d16_hi v53, v109 offset:992
	ds_load_u16_d16 v54, v109 offset:1120
	ds_load_u16_d16_hi v54, v109 offset:1248
	ds_load_u16_d16 v55, v109 offset:1376
	ds_load_u16_d16_hi v55, v109 offset:1504
	ds_load_u16_d16 v56, v109 offset:1632
	ds_load_u16_d16_hi v56, v109 offset:1760
	ds_load_u16_d16 v57, v109 offset:1888
	ds_load_u16_d16_hi v57, v109 offset:2016
	s_waitcnt vmcnt(4)
	ds_store_b128 v112, v[33:36]
	s_waitcnt vmcnt(3)
	ds_store_b128 v114, v[66:69]
	s_waitcnt vmcnt(2)
	ds_store_b128 v114, v[70:73] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v114, v[74:77] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v114, v[78:81] offset:1536
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[42:49], v[50:57], v[1:8]
	s_cbranch_scc1 .LBB0_1
	v_add_nc_u32_e32 v33, 0x1fd0000, v110
	v_add_nc_u32_e32 v90, 0x3000, v37
	s_mov_b32 s6, s10
	s_mov_b32 s7, s11
	v_add_nc_u32_e32 v47, 0x1fe0000, v110
	v_add_lshl_u32 v33, v33, v89, 1
	s_load_b64 s[0:1], s[0:1], 0x30
	ds_load_u16_d16_hi v45, v109 offset:1248
	ds_load_u16_d16 v45, v109 offset:1120
	ds_load_u16_d16_hi v46, v109 offset:1504
	ds_load_u16_d16 v46, v109 offset:1376
	v_lshlrev_b32_e32 v0, 8, v0
	v_add_lshl_u32 v95, v47, v89, 1
	v_add_nc_u32_e32 v34, 0x8000, v33
	v_add_nc_u32_e32 v35, 0x10000, v33
	v_add_nc_u32_e32 v36, 0x18000, v33
	buffer_load_b128 v[73:76], v90, s[8:11], 0 offen offset:4000
	s_clause 0x3
	buffer_load_b128 v[77:80], v33, s[4:7], 0 offen slc
	buffer_load_b128 v[81:84], v34, s[4:7], 0 offen slc
	buffer_load_b128 v[85:88], v35, s[4:7], 0 offen slc
	buffer_load_b128 v[91:94], v36, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v99, 0x8000, v95
	ds_load_b128 v[33:36], v111
	ds_load_b128 v[37:40], v111 offset:16
	ds_load_u16_d16 v53, v109 offset:1024
	ds_load_u16_d16_hi v53, v109 offset:1152
	ds_load_u16_d16 v61, v109 offset:1056
	ds_load_u16_d16_hi v61, v109 offset:1184
	ds_load_u16_d16 v69, v109 offset:1088
	ds_load_u16_d16_hi v69, v109 offset:1216
	ds_load_u16_d16 v54, v109 offset:1280
	ds_load_u16_d16_hi v54, v109 offset:1408
	ds_load_u16_d16 v62, v109 offset:1312
	ds_load_u16_d16_hi v62, v109 offset:1440
	ds_load_u16_d16 v70, v109 offset:1344
	ds_load_u16_d16_hi v70, v109 offset:1472
	ds_load_u16_d16 v55, v109 offset:1536
	ds_load_u16_d16_hi v55, v109 offset:1664
	ds_load_u16_d16 v63, v109 offset:1568
	ds_load_u16_d16_hi v63, v109 offset:1696
	ds_load_u16_d16 v71, v109 offset:1600
	ds_load_u16_d16_hi v71, v109 offset:1728
	ds_load_u16_d16 v56, v109 offset:1792
	ds_load_u16_d16_hi v56, v109 offset:1920
	ds_load_u16_d16 v64, v109 offset:1824
	ds_load_u16_d16_hi v64, v109 offset:1952
	ds_load_u16_d16 v72, v109 offset:1856
	ds_load_u16_d16_hi v72, v109 offset:1984
	ds_load_u16_d16_hi v49, v109 offset:128
	ds_load_u16_d16 v49, v109
	ds_load_u16_d16 v57, v109 offset:32
	ds_load_u16_d16_hi v57, v109 offset:160
	ds_load_u16_d16 v65, v109 offset:64
	ds_load_u16_d16_hi v65, v109 offset:192
	ds_load_u16_d16_hi v41, v109 offset:224
	ds_load_u16_d16 v41, v109 offset:96
	ds_load_u16_d16 v50, v109 offset:256
	ds_load_u16_d16_hi v50, v109 offset:384
	ds_load_u16_d16 v58, v109 offset:288
	ds_load_u16_d16_hi v58, v109 offset:416
	ds_load_u16_d16 v66, v109 offset:320
	ds_load_u16_d16_hi v66, v109 offset:448
	ds_load_u16_d16_hi v42, v109 offset:480
	ds_load_u16_d16 v42, v109 offset:352
	ds_load_u16_d16 v51, v109 offset:512
	ds_load_u16_d16_hi v51, v109 offset:640
	ds_load_u16_d16 v59, v109 offset:544
	ds_load_u16_d16_hi v59, v109 offset:672
	ds_load_u16_d16 v67, v109 offset:576
	ds_load_u16_d16_hi v67, v109 offset:704
	ds_load_u16_d16_hi v43, v109 offset:736
	ds_load_u16_d16 v43, v109 offset:608
	ds_load_u16_d16 v52, v109 offset:768
	ds_load_u16_d16_hi v52, v109 offset:896
	ds_load_u16_d16 v60, v109 offset:800
	ds_load_u16_d16_hi v60, v109 offset:928
	ds_load_u16_d16 v68, v109 offset:832
	ds_load_u16_d16_hi v68, v109 offset:960
	ds_load_u16_d16_hi v44, v109 offset:992
	ds_load_u16_d16 v44, v109 offset:864
	ds_load_u16_d16_hi v47, v109 offset:1760
	ds_load_u16_d16 v47, v109 offset:1632
	ds_load_u16_d16_hi v48, v109 offset:2016
	ds_load_u16_d16 v48, v109 offset:1888
	v_add_nc_u32_e32 v103, 0x10000, v95
	v_add_nc_u32_e32 v107, 0x18000, v95
	v_and_b32_e32 v0, 0x1000, v0
	s_mov_b32 s3, 0x21027000
	s_mov_b32 s2, -1
	s_waitcnt vmcnt(4)
	ds_store_b128 v112, v[73:76]
	s_waitcnt vmcnt(3)
	ds_store_b128 v114, v[77:80]
	s_waitcnt vmcnt(2)
	ds_store_b128 v114, v[81:84] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v114, v[85:88] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v114, v[91:94] offset:1536
	buffer_load_b128 v[91:94], v90, s[8:11], 0 offen offset:4032
	s_clause 0x3
	buffer_load_b128 v[95:98], v95, s[4:7], 0 offen slc
	buffer_load_b128 v[99:102], v99, s[4:7], 0 offen slc
	buffer_load_b128 v[103:106], v103, s[4:7], 0 offen slc
	buffer_load_b128 v[115:118], v107, s[4:7], 0 offen slc
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[33:40], v[49:56], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[33:40], v[57:64], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[33:40], v[65:72], v[17:24]
	ds_load_b128 v[49:52], v111
	ds_load_b128 v[53:56], v111 offset:16
	ds_load_u16_d16_hi v57, v109 offset:128
	ds_load_u16_d16 v57, v109
	ds_load_u16_d16 v65, v109 offset:32
	ds_load_u16_d16_hi v65, v109 offset:160
	ds_load_u16_d16 v73, v109 offset:64
	ds_load_u16_d16_hi v73, v109 offset:192
	ds_load_u16_d16_hi v81, v109 offset:224
	ds_load_u16_d16 v81, v109 offset:96
	ds_load_u16_d16 v58, v109 offset:256
	ds_load_u16_d16_hi v58, v109 offset:384
	ds_load_u16_d16 v66, v109 offset:288
	ds_load_u16_d16_hi v66, v109 offset:416
	ds_load_u16_d16 v74, v109 offset:320
	ds_load_u16_d16_hi v74, v109 offset:448
	ds_load_u16_d16_hi v82, v109 offset:480
	ds_load_u16_d16 v82, v109 offset:352
	ds_load_u16_d16 v59, v109 offset:512
	ds_load_u16_d16_hi v59, v109 offset:640
	ds_load_u16_d16 v67, v109 offset:544
	ds_load_u16_d16_hi v67, v109 offset:672
	ds_load_u16_d16 v75, v109 offset:576
	ds_load_u16_d16_hi v75, v109 offset:704
	ds_load_u16_d16_hi v83, v109 offset:736
	ds_load_u16_d16 v83, v109 offset:608
	ds_load_u16_d16 v60, v109 offset:768
	ds_load_u16_d16_hi v60, v109 offset:896
	ds_load_u16_d16 v68, v109 offset:800
	ds_load_u16_d16_hi v68, v109 offset:928
	ds_load_u16_d16 v76, v109 offset:832
	ds_load_u16_d16_hi v76, v109 offset:960
	ds_load_u16_d16_hi v84, v109 offset:992
	ds_load_u16_d16 v84, v109 offset:864
	ds_load_u16_d16 v61, v109 offset:1024
	ds_load_u16_d16_hi v61, v109 offset:1152
	ds_load_u16_d16 v69, v109 offset:1056
	ds_load_u16_d16_hi v69, v109 offset:1184
	ds_load_u16_d16 v77, v109 offset:1088
	ds_load_u16_d16_hi v77, v109 offset:1216
	ds_load_u16_d16_hi v85, v109 offset:1248
	ds_load_u16_d16 v85, v109 offset:1120
	ds_load_u16_d16 v62, v109 offset:1280
	ds_load_u16_d16_hi v62, v109 offset:1408
	ds_load_u16_d16 v70, v109 offset:1312
	ds_load_u16_d16_hi v70, v109 offset:1440
	ds_load_u16_d16 v78, v109 offset:1344
	ds_load_u16_d16_hi v78, v109 offset:1472
	ds_load_u16_d16_hi v86, v109 offset:1504
	ds_load_u16_d16 v86, v109 offset:1376
	ds_load_u16_d16 v63, v109 offset:1536
	ds_load_u16_d16_hi v63, v109 offset:1664
	ds_load_u16_d16 v71, v109 offset:1568
	ds_load_u16_d16_hi v71, v109 offset:1696
	ds_load_u16_d16 v79, v109 offset:1600
	ds_load_u16_d16_hi v79, v109 offset:1728
	ds_load_u16_d16_hi v87, v109 offset:1760
	ds_load_u16_d16 v87, v109 offset:1632
	ds_load_u16_d16 v64, v109 offset:1792
	ds_load_u16_d16_hi v64, v109 offset:1920
	ds_load_u16_d16 v72, v109 offset:1824
	ds_load_u16_d16_hi v72, v109 offset:1952
	ds_load_u16_d16 v80, v109 offset:1856
	ds_load_u16_d16_hi v80, v109 offset:1984
	ds_load_u16_d16_hi v88, v109 offset:2016
	ds_load_u16_d16 v88, v109 offset:1888
	v_wmma_f32_16x16x16_bf16 v[1:8], v[33:40], v[41:48], v[1:8]
	s_and_b32 s1, s1, 0xffff
	s_waitcnt vmcnt(3)
	ds_store_b128 v114, v[95:98]
	s_waitcnt vmcnt(2)
	ds_store_b128 v114, v[99:102] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v114, v[103:106] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v114, v[115:118] offset:1536
	ds_store_b128 v112, v[91:94]
	v_add_nc_u32_e32 v91, 0x1ff0000, v110
	v_or_b32_e32 v110, v113, v110
	s_waitcnt lgkmcnt(11)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[49:56], v[57:64], v[9:16]
	s_delay_alu instid0(VALU_DEP_3)
	v_add_lshl_u32 v93, v91, v89, 1
	s_waitcnt lgkmcnt(9)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[49:56], v[65:72], v[25:32]
	s_waitcnt lgkmcnt(7)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[49:56], v[73:80], v[17:24]
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[49:56], v[81:88], v[1:8]
	ds_load_b128 v[33:36], v111
	ds_load_b128 v[37:40], v111 offset:16
	ds_load_u16_d16_hi v41, v109 offset:128
	ds_load_u16_d16 v41, v109
	ds_load_u16_d16 v49, v109 offset:32
	ds_load_u16_d16_hi v49, v109 offset:160
	ds_load_u16_d16 v57, v109 offset:64
	ds_load_u16_d16_hi v57, v109 offset:192
	ds_load_u16_d16_hi v65, v109 offset:224
	ds_load_u16_d16 v65, v109 offset:96
	ds_load_u16_d16 v42, v109 offset:256
	ds_load_u16_d16_hi v42, v109 offset:384
	ds_load_u16_d16 v50, v109 offset:288
	ds_load_u16_d16_hi v50, v109 offset:416
	ds_load_u16_d16 v58, v109 offset:320
	ds_load_u16_d16_hi v58, v109 offset:448
	ds_load_u16_d16_hi v66, v109 offset:480
	ds_load_u16_d16 v66, v109 offset:352
	ds_load_u16_d16 v43, v109 offset:512
	ds_load_u16_d16_hi v43, v109 offset:640
	ds_load_u16_d16 v51, v109 offset:544
	ds_load_u16_d16_hi v51, v109 offset:672
	ds_load_u16_d16 v59, v109 offset:576
	ds_load_u16_d16_hi v59, v109 offset:704
	ds_load_u16_d16_hi v67, v109 offset:736
	ds_load_u16_d16 v67, v109 offset:608
	ds_load_u16_d16 v44, v109 offset:768
	ds_load_u16_d16_hi v44, v109 offset:896
	ds_load_u16_d16 v52, v109 offset:800
	ds_load_u16_d16_hi v52, v109 offset:928
	ds_load_u16_d16 v60, v109 offset:832
	ds_load_u16_d16_hi v60, v109 offset:960
	ds_load_u16_d16_hi v68, v109 offset:992
	ds_load_u16_d16 v68, v109 offset:864
	ds_load_u16_d16 v45, v109 offset:1024
	ds_load_u16_d16_hi v45, v109 offset:1152
	ds_load_u16_d16 v53, v109 offset:1056
	ds_load_u16_d16_hi v53, v109 offset:1184
	ds_load_u16_d16 v61, v109 offset:1088
	ds_load_u16_d16_hi v61, v109 offset:1216
	ds_load_u16_d16_hi v69, v109 offset:1248
	ds_load_u16_d16 v69, v109 offset:1120
	ds_load_u16_d16 v46, v109 offset:1280
	ds_load_u16_d16_hi v46, v109 offset:1408
	ds_load_u16_d16 v54, v109 offset:1312
	ds_load_u16_d16_hi v54, v109 offset:1440
	ds_load_u16_d16 v62, v109 offset:1344
	ds_load_u16_d16_hi v62, v109 offset:1472
	ds_load_u16_d16_hi v70, v109 offset:1504
	ds_load_u16_d16 v70, v109 offset:1376
	ds_load_u16_d16 v47, v109 offset:1536
	ds_load_u16_d16_hi v47, v109 offset:1664
	ds_load_u16_d16 v55, v109 offset:1568
	ds_load_u16_d16_hi v55, v109 offset:1696
	ds_load_u16_d16 v63, v109 offset:1600
	ds_load_u16_d16_hi v63, v109 offset:1728
	ds_load_u16_d16_hi v71, v109 offset:1760
	ds_load_u16_d16 v71, v109 offset:1632
	ds_load_u16_d16 v48, v109 offset:1792
	ds_load_u16_d16_hi v48, v109 offset:1920
	ds_load_u16_d16 v56, v109 offset:1824
	ds_load_u16_d16_hi v56, v109 offset:1952
	ds_load_u16_d16 v64, v109 offset:1856
	ds_load_u16_d16_hi v64, v109 offset:1984
	ds_load_u16_d16_hi v72, v109 offset:2016
	ds_load_u16_d16 v72, v109 offset:1888
	v_add_nc_u32_e32 v107, 0x8000, v93
	v_add_nc_u32_e32 v108, 0x10000, v93
	v_add_nc_u32_e32 v119, 0x18000, v93
	buffer_load_b128 v[89:92], v90, s[8:11], 0 offen offset:4064
	s_clause 0x3
	buffer_load_b128 v[93:96], v93, s[4:7], 0 offen slc
	buffer_load_b128 v[97:100], v107, s[4:7], 0 offen slc
	buffer_load_b128 v[101:104], v108, s[4:7], 0 offen slc
	buffer_load_b128 v[105:108], v119, s[4:7], 0 offen slc
	v_add_lshl_u32 v0, v110, v0, 1
	s_waitcnt vmcnt(4)
	ds_store_b128 v112, v[89:92]
	s_waitcnt vmcnt(3)
	ds_store_b128 v114, v[93:96]
	s_waitcnt vmcnt(2)
	ds_store_b128 v114, v[97:100] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v114, v[101:104] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v114, v[105:108] offset:1536
	ds_load_b128 v[73:76], v111
	ds_load_b128 v[77:80], v111 offset:16
	ds_load_u16_d16_hi v81, v109 offset:128
	ds_load_u16_d16 v81, v109
	ds_load_u16_d16 v89, v109 offset:32
	ds_load_u16_d16_hi v89, v109 offset:160
	ds_load_u16_d16 v97, v109 offset:64
	ds_load_u16_d16_hi v97, v109 offset:192
	ds_load_u16_d16_hi v110, v109 offset:224
	ds_load_u16_d16 v110, v109 offset:96
	ds_load_u16_d16 v82, v109 offset:256
	ds_load_u16_d16_hi v82, v109 offset:384
	ds_load_u16_d16 v90, v109 offset:288
	ds_load_u16_d16_hi v90, v109 offset:416
	ds_load_u16_d16 v98, v109 offset:320
	ds_load_u16_d16_hi v98, v109 offset:448
	ds_load_u16_d16_hi v111, v109 offset:480
	ds_load_u16_d16 v111, v109 offset:352
	ds_load_u16_d16 v83, v109 offset:512
	ds_load_u16_d16_hi v83, v109 offset:640
	ds_load_u16_d16 v91, v109 offset:544
	ds_load_u16_d16_hi v91, v109 offset:672
	ds_load_u16_d16 v99, v109 offset:576
	ds_load_u16_d16_hi v99, v109 offset:704
	ds_load_u16_d16_hi v112, v109 offset:736
	ds_load_u16_d16 v112, v109 offset:608
	ds_load_u16_d16 v84, v109 offset:768
	ds_load_u16_d16_hi v84, v109 offset:896
	ds_load_u16_d16 v92, v109 offset:800
	ds_load_u16_d16_hi v92, v109 offset:928
	ds_load_u16_d16 v100, v109 offset:832
	ds_load_u16_d16_hi v100, v109 offset:960
	ds_load_u16_d16_hi v113, v109 offset:992
	ds_load_u16_d16 v113, v109 offset:864
	ds_load_u16_d16 v85, v109 offset:1024
	ds_load_u16_d16_hi v85, v109 offset:1152
	ds_load_u16_d16 v93, v109 offset:1056
	ds_load_u16_d16_hi v93, v109 offset:1184
	ds_load_u16_d16 v101, v109 offset:1088
	ds_load_u16_d16_hi v101, v109 offset:1216
	ds_load_u16_d16_hi v114, v109 offset:1248
	ds_load_u16_d16 v114, v109 offset:1120
	ds_load_u16_d16 v86, v109 offset:1280
	ds_load_u16_d16_hi v86, v109 offset:1408
	ds_load_u16_d16 v94, v109 offset:1312
	ds_load_u16_d16_hi v94, v109 offset:1440
	ds_load_u16_d16 v102, v109 offset:1344
	ds_load_u16_d16_hi v102, v109 offset:1472
	ds_load_u16_d16_hi v115, v109 offset:1504
	ds_load_u16_d16 v115, v109 offset:1376
	ds_load_u16_d16 v87, v109 offset:1536
	ds_load_u16_d16_hi v87, v109 offset:1664
	ds_load_u16_d16 v95, v109 offset:1568
	ds_load_u16_d16_hi v95, v109 offset:1696
	ds_load_u16_d16 v103, v109 offset:1600
	ds_load_u16_d16_hi v103, v109 offset:1728
	ds_load_u16_d16_hi v116, v109 offset:1760
	ds_load_u16_d16 v116, v109 offset:1632
	ds_load_u16_d16 v88, v109 offset:1792
	ds_load_u16_d16_hi v88, v109 offset:1920
	ds_load_u16_d16 v96, v109 offset:1824
	ds_load_u16_d16_hi v96, v109 offset:1952
	ds_load_u16_d16 v104, v109 offset:1856
	ds_load_u16_d16_hi v104, v109 offset:1984
	ds_load_u16_d16_hi v117, v109 offset:2016
	ds_load_u16_d16 v117, v109 offset:1888
	s_waitcnt lgkmcnt(62)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[33:40], v[41:48], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[33:40], v[49:56], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[33:40], v[57:64], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[33:40], v[65:72], v[1:8]
	v_add_nc_u32_e32 v105, 0x4000, v0
	v_add_nc_u32_e32 v107, 0xc000, v0
	v_add_nc_u32_e32 v41, 0x10000, v0
	v_add_nc_u32_e32 v43, 0x18000, v0
	s_waitcnt lgkmcnt(6)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[73:80], v[81:88], v[9:16]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[73:80], v[89:96], v[25:32]
	s_waitcnt lgkmcnt(2)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[73:80], v[97:104], v[17:24]
	v_bfe_u32 v33, v9, 16, 1
	v_or_b32_e32 v34, 0x400000, v9
	v_bfe_u32 v35, v10, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_or_b32_e32 v36, 0x400000, v10
	v_add3_u32 v33, v33, v9, 0x7fff
	v_bfe_u32 v37, v11, 16, 1
	v_bfe_u32 v57, v27, 16, 1
	v_add3_u32 v35, v35, v10, 0x7fff
	v_or_b32_e32 v38, 0x400000, v11
	v_cndmask_b32_e32 v9, v33, v34, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_bfe_u32 v39, v12, 16, 1
	v_or_b32_e32 v58, 0x400000, v27
	v_add3_u32 v37, v37, v11, 0x7fff
	v_add3_u32 v57, v57, v27, 0x7fff
	v_cndmask_b32_e32 v10, v35, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_or_b32_e32 v40, 0x400000, v12
	v_bfe_u32 v45, v13, 16, 1
	v_bfe_u32 v61, v29, 16, 1
	v_add3_u32 v39, v39, v12, 0x7fff
	v_cndmask_b32_e32 v11, v37, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_or_b32_e32 v46, 0x400000, v13
	v_bfe_u32 v47, v14, 16, 1
	v_or_b32_e32 v62, 0x400000, v29
	v_add3_u32 v45, v45, v13, 0x7fff
	v_add3_u32 v61, v61, v29, 0x7fff
	v_cndmask_b32_e32 v12, v39, v40, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_add_nc_u32_e32 v106, 0x8000, v0
	v_or_b32_e32 v48, 0x400000, v14
	v_bfe_u32 v49, v15, 16, 1
	v_bfe_u32 v65, v31, 16, 1
	v_add3_u32 v47, v47, v14, 0x7fff
	v_cndmask_b32_e32 v13, v45, v46, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_or_b32_e32 v50, 0x400000, v15
	v_bfe_u32 v51, v16, 16, 1
	v_or_b32_e32 v66, 0x400000, v31
	v_add3_u32 v49, v49, v15, 0x7fff
	v_add3_u32 v65, v65, v31, 0x7fff
	v_cndmask_b32_e32 v14, v47, v48, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_add_nc_u32_e32 v42, 0x14000, v0
	v_or_b32_e32 v52, 0x400000, v16
	v_bfe_u32 v53, v25, 16, 1
	v_bfe_u32 v69, v17, 16, 1
	v_add3_u32 v51, v51, v16, 0x7fff
	v_cndmask_b32_e32 v15, v49, v50, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	v_or_b32_e32 v54, 0x400000, v25
	v_bfe_u32 v55, v26, 16, 1
	v_or_b32_e32 v70, 0x400000, v17
	v_add3_u32 v53, v53, v25, 0x7fff
	v_add3_u32 v69, v69, v17, 0x7fff
	v_cndmask_b32_e32 v16, v51, v52, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v25, v25
	v_add_nc_u32_e32 v44, 0x1c000, v0
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[73:80], v[110:117], v[1:8]
	v_or_b32_e32 v56, 0x400000, v26
	v_bfe_u32 v73, v19, 16, 1
	v_add3_u32 v55, v55, v26, 0x7fff
	v_cndmask_b32_e32 v25, v53, v54, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v26, v26
	v_bfe_u32 v59, v28, 16, 1
	v_or_b32_e32 v74, 0x400000, v19
	v_add3_u32 v73, v73, v19, 0x7fff
	v_or_b32_e32 v60, 0x400000, v28
	v_cndmask_b32_e32 v26, v55, v56, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v27, v27
	v_bfe_u32 v77, v21, 16, 1
	v_add3_u32 v59, v59, v28, 0x7fff
	v_bfe_u32 v63, v30, 16, 1
	v_or_b32_e32 v78, 0x400000, v21
	v_cndmask_b32_e32 v27, v57, v58, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v28, v28
	v_add3_u32 v77, v77, v21, 0x7fff
	v_or_b32_e32 v64, 0x400000, v30
	v_bfe_u32 v81, v23, 16, 1
	v_add3_u32 v63, v63, v30, 0x7fff
	v_cndmask_b32_e32 v28, v59, v60, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v29, v29
	v_bfe_u32 v67, v32, 16, 1
	v_or_b32_e32 v82, 0x400000, v23
	v_add3_u32 v81, v81, v23, 0x7fff
	v_or_b32_e32 v68, 0x400000, v32
	v_cndmask_b32_e32 v29, v61, v62, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v30, v30
	v_bfe_u32 v85, v1, 16, 1
	v_add3_u32 v67, v67, v32, 0x7fff
	v_bfe_u32 v71, v18, 16, 1
	v_or_b32_e32 v86, 0x400000, v1
	v_cndmask_b32_e32 v30, v63, v64, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v31, v31
	v_add3_u32 v85, v85, v1, 0x7fff
	v_or_b32_e32 v72, 0x400000, v18
	v_bfe_u32 v89, v3, 16, 1
	v_add3_u32 v71, v71, v18, 0x7fff
	v_cndmask_b32_e32 v31, v65, v66, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v32, v32
	v_bfe_u32 v75, v20, 16, 1
	v_or_b32_e32 v90, 0x400000, v3
	v_add3_u32 v89, v89, v3, 0x7fff
	v_or_b32_e32 v76, 0x400000, v20
	v_cndmask_b32_e32 v32, v67, v68, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v17, v17
	v_bfe_u32 v93, v5, 16, 1
	v_add3_u32 v75, v75, v20, 0x7fff
	v_bfe_u32 v79, v22, 16, 1
	v_or_b32_e32 v94, 0x400000, v5
	v_cndmask_b32_e32 v17, v69, v70, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v18, v18
	v_add3_u32 v93, v93, v5, 0x7fff
	v_or_b32_e32 v80, 0x400000, v22
	v_bfe_u32 v97, v7, 16, 1
	v_add3_u32 v79, v79, v22, 0x7fff
	v_cndmask_b32_e32 v18, v71, v72, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v19, v19
	v_bfe_u32 v83, v24, 16, 1
	v_or_b32_e32 v98, 0x400000, v7
	v_add3_u32 v97, v97, v7, 0x7fff
	v_or_b32_e32 v84, 0x400000, v24
	v_cndmask_b32_e32 v19, v73, v74, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v20, v20
	v_add3_u32 v83, v83, v24, 0x7fff
	v_bfe_u32 v87, v2, 16, 1
	v_or_b32_e32 v88, 0x400000, v2
	v_bfe_u32 v91, v4, 16, 1
	v_cndmask_b32_e32 v20, v75, v76, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v21, v21
	v_add3_u32 v87, v87, v2, 0x7fff
	v_or_b32_e32 v92, 0x400000, v4
	v_add3_u32 v91, v91, v4, 0x7fff
	v_bfe_u32 v95, v6, 16, 1
	v_cndmask_b32_e32 v21, v77, v78, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v22, v22
	v_or_b32_e32 v96, 0x400000, v6
	v_bfe_u32 v99, v8, 16, 1
	v_add3_u32 v95, v95, v6, 0x7fff
	v_or_b32_e32 v100, 0x400000, v8
	v_cndmask_b32_e32 v22, v79, v80, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v23, v23
	v_add3_u32 v99, v99, v8, 0x7fff
	v_lshrrev_b32_e32 v9, 16, v9
	v_lshrrev_b32_e32 v10, 16, v10
	v_lshrrev_b32_e32 v11, 16, v11
	v_cndmask_b32_e32 v23, v81, v82, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v24, v24
	v_lshrrev_b32_e32 v12, 16, v12
	v_lshrrev_b32_e32 v13, 16, v13
	v_lshrrev_b32_e32 v14, 16, v14
	v_lshrrev_b32_e32 v15, 16, v15
	v_cndmask_b32_e32 v24, v83, v84, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	v_lshrrev_b32_e32 v16, 16, v16
	v_lshrrev_b32_e32 v25, 16, v25
	v_lshrrev_b32_e32 v26, 16, v26
	v_lshrrev_b32_e32 v27, 16, v27
	v_cndmask_b32_e32 v1, v85, v86, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_lshrrev_b32_e32 v28, 16, v28
	v_lshrrev_b32_e32 v29, 16, v29
	v_lshrrev_b32_e32 v30, 16, v30
	v_lshrrev_b32_e32 v31, 16, v31
	v_cndmask_b32_e32 v2, v87, v88, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_lshrrev_b32_e32 v32, 16, v32
	v_lshrrev_b32_e32 v17, 16, v17
	v_lshrrev_b32_e32 v19, 16, v19
	v_lshrrev_b32_e32 v21, 16, v21
	v_cndmask_b32_e32 v3, v89, v90, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_lshrrev_b32_e32 v18, 16, v18
	v_lshrrev_b32_e32 v23, 16, v23
	v_lshrrev_b32_e32 v24, 16, v24
	v_lshrrev_b32_e32 v1, 16, v1
	v_cndmask_b32_e32 v4, v91, v92, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_lshrrev_b32_e32 v2, 16, v2
	v_lshrrev_b32_e32 v3, 16, v3
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_3) | instid1(VALU_DEP_3)
	v_lshrrev_b32_e32 v4, 16, v4
	v_cndmask_b32_e32 v5, v93, v94, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_lshrrev_b32_e32 v20, 16, v20
	v_lshrrev_b32_e32 v5, 16, v5
	v_cndmask_b32_e32 v6, v95, v96, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_3)
	v_lshrrev_b32_e32 v6, 16, v6
	v_cndmask_b32_e32 v7, v97, v98, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_lshrrev_b32_e32 v22, 16, v22
	v_lshrrev_b32_e32 v7, 16, v7
	v_cndmask_b32_e32 v8, v99, v100, vcc_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_lshrrev_b32_e32 v8, 16, v8
	s_clause 0x1f
	buffer_store_b16 v9, v0, s[0:3], 0 offen
	buffer_store_b16 v10, v105, s[0:3], 0 offen
	buffer_store_b16 v11, v106, s[0:3], 0 offen
	buffer_store_b16 v12, v107, s[0:3], 0 offen
	buffer_store_b16 v13, v41, s[0:3], 0 offen
	buffer_store_b16 v14, v42, s[0:3], 0 offen
	buffer_store_b16 v15, v43, s[0:3], 0 offen
	buffer_store_b16 v16, v44, s[0:3], 0 offen
	buffer_store_b16 v25, v0, s[0:3], 0 offen offset:32
	buffer_store_b16 v26, v105, s[0:3], 0 offen offset:32
	buffer_store_b16 v27, v106, s[0:3], 0 offen offset:32
	buffer_store_b16 v28, v107, s[0:3], 0 offen offset:32
	buffer_store_b16 v29, v41, s[0:3], 0 offen offset:32
	buffer_store_b16 v30, v42, s[0:3], 0 offen offset:32
	buffer_store_b16 v31, v43, s[0:3], 0 offen offset:32
	buffer_store_b16 v32, v44, s[0:3], 0 offen offset:32
	buffer_store_b16 v17, v0, s[0:3], 0 offen offset:64
	buffer_store_b16 v18, v105, s[0:3], 0 offen offset:64
	buffer_store_b16 v19, v106, s[0:3], 0 offen offset:64
	buffer_store_b16 v20, v107, s[0:3], 0 offen offset:64
	buffer_store_b16 v21, v41, s[0:3], 0 offen offset:64
	buffer_store_b16 v22, v42, s[0:3], 0 offen offset:64
	buffer_store_b16 v23, v43, s[0:3], 0 offen offset:64
	buffer_store_b16 v24, v44, s[0:3], 0 offen offset:64
	buffer_store_b16 v1, v0, s[0:3], 0 offen offset:96
	buffer_store_b16 v2, v105, s[0:3], 0 offen offset:96
	buffer_store_b16 v3, v106, s[0:3], 0 offen offset:96
	buffer_store_b16 v4, v107, s[0:3], 0 offen offset:96
	buffer_store_b16 v5, v41, s[0:3], 0 offen offset:96
	buffer_store_b16 v6, v42, s[0:3], 0 offen offset:96
	buffer_store_b16 v7, v43, s[0:3], 0 offen offset:96
	buffer_store_b16 v8, v44, s[0:3], 0 offen offset:96
	s_nop 0
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
	s_endpgm
.Lfunc_end0:
	.size	exercise_kernel_0, .Lfunc_end0-exercise_kernel_0
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel exercise_kernel_0
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
		.amdhsa_next_free_vgpr 120
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

	.set .Lexercise_kernel_0.num_vgpr, 120
	.set .Lexercise_kernel_0.num_agpr, 0
	.set .Lexercise_kernel_0.numbered_sgpr, 12
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
    .group_segment_fixed_size: 11264
    .kernarg_segment_align: 8
    .kernarg_segment_size: 100
    .max_flat_workgroup_size: 128
    .name:           exercise_kernel_0
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 128
      - 1
      - 1
    .sgpr_count:     14
    .sgpr_spill_count: 0
    .symbol:         exercise_kernel_0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     120
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
