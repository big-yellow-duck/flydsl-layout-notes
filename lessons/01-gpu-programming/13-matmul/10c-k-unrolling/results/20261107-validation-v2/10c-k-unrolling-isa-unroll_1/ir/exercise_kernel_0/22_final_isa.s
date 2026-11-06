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
	s_load_b64 s[4:5], s[0:1], 0x0
	s_load_b64 s[8:9], s[0:1], 0x18
	s_lshr_b32 s2, s2, 26
	v_or_b32_e32 v1, s3, v7
	v_bfe_u32 v35, v0, 3, 2
	v_bfe_u32 v41, v0, 1, 4
	s_mov_b32 s6, -1
	s_mov_b32 s7, 0x21027000
	v_dual_mov_b32 v25, 0 :: v_dual_add_nc_u32 v2, s2, v1
	v_lshlrev_b32_e32 v3, 3, v0
	s_mov_b32 s10, s6
	s_mov_b32 s11, s7
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_3)
	v_dual_mov_b32 v27, v25 :: v_dual_and_b32 v2, 0x3ffffc0, v2
	v_mov_b32_e32 v26, v25
	v_dual_mov_b32 v29, v25 :: v_dual_and_b32 v36, 56, v3
	v_sub_nc_u32_e32 v1, v1, v2
	v_dual_mov_b32 v31, v25 :: v_dual_lshlrev_b32 v2, 4, v0
	s_delay_alu instid0(VALU_DEP_3)
	v_lshl_or_b32 v3, v35, 12, v36
	s_waitcnt lgkmcnt(0)
	s_and_b32 s5, s5, 0xffff
	v_dual_mov_b32 v28, v25 :: v_dual_lshlrev_b32 v33, 6, v1
	v_dual_mov_b32 v17, v25 :: v_dual_and_b32 v62, 16, v2
	s_and_b32 s9, s9, 0xffff
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_add_lshl_u32 v37, v33, v3, 1
	v_mul_u32_u24_e32 v8, 0x300, v7
	v_lshl_or_b32 v38, v41, 14, v62
	v_dual_mov_b32 v21, v25 :: v_dual_and_b32 v34, 15, v0
	s_delay_alu instid0(VALU_DEP_4)
	v_dual_mov_b32 v30, v25 :: v_dual_add_nc_u32 v1, 0x8000, v37
	v_dual_mov_b32 v19, v25 :: v_dual_add_nc_u32 v2, 0x10000, v37
	v_dual_mov_b32 v32, v25 :: v_dual_add_nc_u32 v3, 0x18000, v37
	buffer_load_b128 v[42:45], v38, s[4:7], 0 offen
	s_clause 0x3
	buffer_load_b128 v[46:49], v37, s[8:11], 0 offen slc
	buffer_load_b128 v[50:53], v1, s[8:11], 0 offen slc
	buffer_load_b128 v[54:57], v2, s[8:11], 0 offen slc
	buffer_load_b128 v[58:61], v3, s[8:11], 0 offen slc
	v_dual_mov_b32 v18, v25 :: v_dual_lshlrev_b32 v63, 11, v7
	v_or_b32_e32 v64, 0x1000, v8
	v_mul_u32_u24_e32 v65, 48, v41
	v_dual_mov_b32 v20, v25 :: v_dual_lshlrev_b32 v39, 7, v35
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_lshl_or_b32 v40, v36, 1, v63
	v_or_b32_e32 v62, v64, v62
	v_mul_u32_u24_e32 v36, 48, v34
	v_mov_b32_e32 v22, v25
	v_mov_b32_e32 v23, v25
	v_mov_b32_e32 v24, v25
	v_mov_b32_e32 v9, v25
	v_mov_b32_e32 v10, v25
	v_mov_b32_e32 v11, v25
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
	v_lshl_or_b32 v35, v34, 1, v63
	v_mad_u32_u24 v66, v41, 48, v62
	v_add_nc_u32_e32 v36, v64, v36
	v_add_nc_u32_e32 v41, v62, v65
	v_or_b32_e32 v63, v40, v39
	s_mov_b32 s2, 0
	s_waitcnt vmcnt(4)
	ds_store_b128 v66, v[42:45]
	s_waitcnt vmcnt(3)
	ds_store_b128 v63, v[46:49]
	s_waitcnt vmcnt(2)
	ds_store_b128 v63, v[50:53] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v63, v[54:57] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v63, v[58:61] offset:1536
.LBB0_1:
	s_add_i32 s2, s2, 1
	v_add_nc_u32_e32 v102, v40, v39
	v_lshl_add_u32 v42, s2, 17, v37
	v_lshl_add_u32 v43, s2, 5, v38
	s_cmpk_lg_i32 s2, 0x1ff
	s_delay_alu instid0(VALU_DEP_2)
	v_add_nc_u32_e32 v44, 0x8000, v42
	v_add_nc_u32_e32 v45, 0x10000, v42
	v_add_nc_u32_e32 v46, 0x18000, v42
	buffer_load_b128 v[82:85], v43, s[4:7], 0 offen
	s_clause 0x3
	buffer_load_b128 v[86:89], v42, s[8:11], 0 offen slc
	buffer_load_b128 v[90:93], v44, s[8:11], 0 offen slc
	buffer_load_b128 v[94:97], v45, s[8:11], 0 offen slc
	buffer_load_b128 v[98:101], v46, s[8:11], 0 offen slc
	ds_load_u16_d16 v44, v35 offset:608
	ds_load_u16_d16 v43, v35 offset:352
	ds_load_u16_d16 v52, v35 offset:576
	ds_load_u16_d16 v53, v35 offset:832
	ds_load_u16_d16 v60, v35 offset:512
	ds_load_u16_d16 v67, v35 offset:288
	ds_load_b128 v[74:77], v36
	ds_load_b128 v[78:81], v36 offset:16
	ds_load_u16_d16 v54, v35 offset:1088
	ds_load_u16_d16 v55, v35 offset:1344
	ds_load_u16_d16 v56, v35 offset:1600
	ds_load_u16_d16 v57, v35 offset:1856
	s_waitcnt lgkmcnt(10)
	ds_load_u16_d16_hi v43, v35 offset:480
	ds_load_u16_d16 v61, v35 offset:768
	s_waitcnt lgkmcnt(11)
	ds_load_u16_d16_hi v52, v35 offset:704
	ds_load_u16_d16 v68, v35 offset:544
	ds_load_u16_d16 v59, v35 offset:256
	ds_load_u16_d16 v51, v35 offset:320
	ds_load_u16_d16 v58, v35
	ds_load_u16_d16 v66, v35 offset:32
	ds_load_u16_d16 v50, v35 offset:64
	ds_load_u16_d16 v42, v35 offset:96
	ds_load_u16_d16 v62, v35 offset:1024
	ds_load_u16_d16 v69, v35 offset:800
	s_waitcnt lgkmcnt(20)
	ds_load_u16_d16_hi v53, v35 offset:960
	ds_load_u16_d16 v45, v35 offset:864
	ds_load_u16_d16 v63, v35 offset:1280
	ds_load_u16_d16 v70, v35 offset:1056
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v54, v35 offset:1216
	ds_load_u16_d16 v46, v35 offset:1120
	ds_load_u16_d16 v64, v35 offset:1536
	ds_load_u16_d16 v71, v35 offset:1312
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v55, v35 offset:1472
	ds_load_u16_d16 v47, v35 offset:1376
	ds_load_u16_d16 v65, v35 offset:1792
	ds_load_u16_d16 v72, v35 offset:1568
	s_waitcnt lgkmcnt(25)
	ds_load_u16_d16_hi v56, v35 offset:1728
	ds_load_u16_d16 v48, v35 offset:1632
	ds_load_u16_d16 v73, v35 offset:1824
	s_waitcnt lgkmcnt(27)
	ds_load_u16_d16_hi v57, v35 offset:1984
	ds_load_u16_d16 v49, v35 offset:1888
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v58, v35 offset:128
	s_waitcnt lgkmcnt(20)
	ds_load_u16_d16_hi v42, v35 offset:224
	ds_load_u16_d16_hi v60, v35 offset:640
	ds_load_u16_d16_hi v59, v35 offset:384
	ds_load_u16_d16_hi v67, v35 offset:416
	ds_load_u16_d16_hi v51, v35 offset:448
	ds_load_u16_d16_hi v61, v35 offset:896
	ds_load_u16_d16_hi v68, v35 offset:672
	ds_load_u16_d16_hi v44, v35 offset:736
	s_waitcnt lgkmcnt(27)
	ds_load_u16_d16_hi v62, v35 offset:1152
	s_waitcnt lgkmcnt(27)
	ds_load_u16_d16_hi v69, v35 offset:928
	s_waitcnt lgkmcnt(26)
	ds_load_u16_d16_hi v45, v35 offset:992
	s_waitcnt lgkmcnt(26)
	ds_load_u16_d16_hi v63, v35 offset:1408
	s_waitcnt lgkmcnt(26)
	ds_load_u16_d16_hi v70, v35 offset:1184
	s_waitcnt lgkmcnt(25)
	ds_load_u16_d16_hi v46, v35 offset:1248
	s_waitcnt lgkmcnt(25)
	ds_load_u16_d16_hi v64, v35 offset:1664
	s_waitcnt lgkmcnt(25)
	ds_load_u16_d16_hi v71, v35 offset:1440
	s_waitcnt lgkmcnt(24)
	ds_load_u16_d16_hi v47, v35 offset:1504
	s_waitcnt lgkmcnt(24)
	ds_load_u16_d16_hi v65, v35 offset:1920
	s_waitcnt lgkmcnt(24)
	ds_load_u16_d16_hi v72, v35 offset:1696
	s_waitcnt lgkmcnt(23)
	ds_load_u16_d16_hi v48, v35 offset:1760
	s_waitcnt lgkmcnt(23)
	ds_load_u16_d16_hi v73, v35 offset:1952
	ds_load_u16_d16_hi v66, v35 offset:160
	ds_load_u16_d16_hi v50, v35 offset:192
	s_waitcnt lgkmcnt(24)
	ds_load_u16_d16_hi v49, v35 offset:2016
	s_waitcnt vmcnt(4)
	ds_store_b128 v41, v[82:85]
	s_waitcnt vmcnt(3)
	ds_store_b128 v102, v[86:89]
	s_waitcnt vmcnt(2)
	ds_store_b128 v102, v[90:93] offset:512
	s_waitcnt vmcnt(1)
	ds_store_b128 v102, v[94:97] offset:1024
	s_waitcnt vmcnt(0)
	ds_store_b128 v102, v[98:101] offset:1536
	s_waitcnt lgkmcnt(11)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[74:81], v[58:65], v[25:32]
	s_waitcnt lgkmcnt(7)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[74:81], v[66:73], v[17:24]
	s_waitcnt lgkmcnt(6)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[74:81], v[50:57], v[9:16]
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[74:81], v[42:49], v[1:8]
	s_cbranch_scc1 .LBB0_1
	ds_load_u16_d16 v38, v35 offset:608
	ds_load_u16_d16 v37, v35 offset:352
	ds_load_u16_d16 v46, v35 offset:576
	ds_load_u16_d16 v54, v35 offset:512
	ds_load_u16_d16 v61, v35 offset:288
	s_load_b64 s[0:1], s[0:1], 0x30
	v_or_b32_e32 v33, v34, v33
	s_mov_b32 s3, 0x21027000
	s_mov_b32 s2, -1
	ds_load_u16_d16 v47, v35 offset:832
	ds_load_b128 v[68:71], v36
	ds_load_b128 v[72:75], v36 offset:16
	ds_load_u16_d16 v48, v35 offset:1088
	ds_load_u16_d16 v49, v35 offset:1344
	ds_load_u16_d16 v50, v35 offset:1600
	ds_load_u16_d16 v59, v35 offset:1792
	ds_load_u16_d16 v51, v35 offset:1856
	ds_load_u16_d16 v52, v35
	ds_load_u16_d16 v60, v35 offset:32
	ds_load_u16_d16 v53, v35 offset:256
	ds_load_u16_d16 v44, v35 offset:64
	ds_load_u16_d16 v45, v35 offset:320
	s_waitcnt lgkmcnt(0)
	ds_load_u16_d16_hi v37, v35 offset:480
	ds_load_u16_d16 v36, v35 offset:96
	ds_load_u16_d16 v55, v35 offset:768
	ds_load_u16_d16_hi v46, v35 offset:704
	ds_load_u16_d16 v62, v35 offset:544
	ds_load_u16_d16 v56, v35 offset:1024
	ds_load_u16_d16 v63, v35 offset:800
	ds_load_u16_d16_hi v47, v35 offset:960
	ds_load_u16_d16 v39, v35 offset:864
	ds_load_u16_d16 v57, v35 offset:1280
	ds_load_u16_d16 v64, v35 offset:1056
	ds_load_u16_d16_hi v48, v35 offset:1216
	ds_load_u16_d16 v40, v35 offset:1120
	ds_load_u16_d16 v58, v35 offset:1536
	ds_load_u16_d16 v65, v35 offset:1312
	ds_load_u16_d16_hi v49, v35 offset:1472
	ds_load_u16_d16 v41, v35 offset:1376
	ds_load_u16_d16 v66, v35 offset:1568
	ds_load_u16_d16_hi v50, v35 offset:1728
	ds_load_u16_d16 v42, v35 offset:1632
	ds_load_u16_d16_hi v52, v35 offset:128
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v36, v35 offset:224
	ds_load_u16_d16_hi v59, v35 offset:1920
	ds_load_u16_d16 v67, v35 offset:1824
	ds_load_u16_d16_hi v51, v35 offset:1984
	ds_load_u16_d16 v43, v35 offset:1888
	ds_load_u16_d16_hi v54, v35 offset:640
	ds_load_u16_d16_hi v53, v35 offset:384
	ds_load_u16_d16_hi v61, v35 offset:416
	ds_load_u16_d16_hi v45, v35 offset:448
	s_waitcnt lgkmcnt(27)
	ds_load_u16_d16_hi v55, v35 offset:896
	s_waitcnt lgkmcnt(26)
	ds_load_u16_d16_hi v62, v35 offset:672
	ds_load_u16_d16_hi v38, v35 offset:736
	s_waitcnt lgkmcnt(27)
	ds_load_u16_d16_hi v56, v35 offset:1152
	s_waitcnt lgkmcnt(27)
	ds_load_u16_d16_hi v63, v35 offset:928
	s_and_b32 s1, s1, 0xffff
	s_waitcnt lgkmcnt(26)
	ds_load_u16_d16_hi v39, v35 offset:992
	s_waitcnt lgkmcnt(26)
	ds_load_u16_d16_hi v57, v35 offset:1408
	s_waitcnt lgkmcnt(26)
	ds_load_u16_d16_hi v64, v35 offset:1184
	s_waitcnt lgkmcnt(25)
	ds_load_u16_d16_hi v40, v35 offset:1248
	s_waitcnt lgkmcnt(25)
	ds_load_u16_d16_hi v58, v35 offset:1664
	s_waitcnt lgkmcnt(25)
	ds_load_u16_d16_hi v65, v35 offset:1440
	s_waitcnt lgkmcnt(24)
	ds_load_u16_d16_hi v41, v35 offset:1504
	s_waitcnt lgkmcnt(24)
	ds_load_u16_d16_hi v66, v35 offset:1696
	s_waitcnt lgkmcnt(23)
	ds_load_u16_d16_hi v42, v35 offset:1760
	s_waitcnt lgkmcnt(20)
	ds_load_u16_d16_hi v67, v35 offset:1952
	ds_load_u16_d16_hi v60, v35 offset:160
	ds_load_u16_d16_hi v44, v35 offset:192
	s_waitcnt lgkmcnt(21)
	ds_load_u16_d16_hi v43, v35 offset:2016
	v_lshlrev_b32_e32 v0, 8, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	v_and_b32_e32 v0, 0x1000, v0
	s_waitcnt lgkmcnt(8)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[68:75], v[52:59], v[25:32]
	v_add_lshl_u32 v0, v33, v0, 1
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_bfe_u32 v35, v25, 16, 1
	v_bfe_u32 v52, v26, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v25, v25
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[68:75], v[36:43], v[1:8]
	v_or_b32_e32 v36, 0x400000, v25
	v_add3_u32 v35, v35, v25, 0x7fff
	v_add3_u32 v37, v52, v26, 0x7fff
	v_or_b32_e32 v38, 0x400000, v26
	v_or_b32_e32 v39, 0x400000, v28
	v_or_b32_e32 v40, 0x400000, v29
	v_cndmask_b32_e32 v25, v35, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v26, v26
	v_bfe_u32 v35, v27, 16, 1
	v_bfe_u32 v36, v28, 16, 1
	v_wmma_f32_16x16x16_bf16 v[17:24], v[68:75], v[60:67], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[68:75], v[44:51], v[9:16]
	v_cndmask_b32_e32 v26, v37, v38, vcc_lo
	v_add3_u32 v35, v35, v27, 0x7fff
	v_or_b32_e32 v38, 0x400000, v27
	v_cmp_u_f32_e32 vcc_lo, v27, v27
	v_bfe_u32 v37, v29, 16, 1
	v_add3_u32 v36, v36, v28, 0x7fff
	v_lshrrev_b32_e32 v25, 16, v25
	v_lshrrev_b32_e32 v26, 16, v26
	v_cndmask_b32_e32 v27, v35, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v28, v28
	v_add3_u32 v37, v37, v29, 0x7fff
	v_bfe_u32 v35, v30, 16, 1
	v_or_b32_e32 v38, 0x400000, v30
	v_dual_cndmask_b32 v28, v36, v39 :: v_dual_add_nc_u32 v33, 0x4000, v0
	v_cmp_u_f32_e32 vcc_lo, v29, v29
	v_bfe_u32 v36, v31, 16, 1
	v_add3_u32 v35, v35, v30, 0x7fff
	v_or_b32_e32 v39, 0x400000, v31
	v_lshrrev_b32_e32 v27, 16, v27
	v_cndmask_b32_e32 v29, v37, v40, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v30, v30
	v_bfe_u32 v37, v32, 16, 1
	v_add3_u32 v36, v36, v31, 0x7fff
	v_or_b32_e32 v40, 0x400000, v32
	v_lshrrev_b32_e32 v28, 16, v28
	v_cndmask_b32_e32 v30, v35, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v31, v31
	v_add3_u32 v37, v37, v32, 0x7fff
	v_bfe_u32 v35, v17, 16, 1
	v_or_b32_e32 v38, 0x400000, v17
	v_lshrrev_b32_e32 v29, 16, v29
	v_cndmask_b32_e32 v31, v36, v39, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v32, v32
	v_bfe_u32 v36, v18, 16, 1
	v_add3_u32 v35, v35, v17, 0x7fff
	v_or_b32_e32 v39, 0x400000, v18
	v_lshrrev_b32_e32 v30, 16, v30
	v_cndmask_b32_e32 v32, v37, v40, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v17, v17
	v_bfe_u32 v37, v19, 16, 1
	v_add3_u32 v36, v36, v18, 0x7fff
	v_or_b32_e32 v40, 0x400000, v19
	v_lshrrev_b32_e32 v31, 16, v31
	v_cndmask_b32_e32 v17, v35, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v18, v18
	v_add3_u32 v37, v37, v19, 0x7fff
	v_bfe_u32 v35, v20, 16, 1
	v_or_b32_e32 v38, 0x400000, v20
	v_lshrrev_b32_e32 v32, 16, v32
	v_cndmask_b32_e32 v18, v36, v39, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v19, v19
	v_bfe_u32 v36, v21, 16, 1
	v_add3_u32 v35, v35, v20, 0x7fff
	v_or_b32_e32 v39, 0x400000, v21
	v_lshrrev_b32_e32 v17, 16, v17
	v_cndmask_b32_e32 v19, v37, v40, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v20, v20
	v_bfe_u32 v37, v22, 16, 1
	v_add3_u32 v36, v36, v21, 0x7fff
	v_or_b32_e32 v40, 0x400000, v22
	v_lshrrev_b32_e32 v18, 16, v18
	v_cndmask_b32_e32 v20, v35, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v21, v21
	v_add3_u32 v37, v37, v22, 0x7fff
	v_bfe_u32 v35, v23, 16, 1
	v_or_b32_e32 v38, 0x400000, v23
	v_lshrrev_b32_e32 v19, 16, v19
	v_cndmask_b32_e32 v21, v36, v39, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v22, v22
	v_bfe_u32 v36, v24, 16, 1
	v_add3_u32 v35, v35, v23, 0x7fff
	v_or_b32_e32 v39, 0x400000, v24
	v_lshrrev_b32_e32 v20, 16, v20
	v_cndmask_b32_e32 v22, v37, v40, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v23, v23
	v_bfe_u32 v37, v9, 16, 1
	v_add3_u32 v36, v36, v24, 0x7fff
	v_or_b32_e32 v40, 0x400000, v9
	v_lshrrev_b32_e32 v21, 16, v21
	v_cndmask_b32_e32 v23, v35, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v24, v24
	v_add3_u32 v37, v37, v9, 0x7fff
	v_bfe_u32 v35, v10, 16, 1
	v_or_b32_e32 v38, 0x400000, v10
	v_lshrrev_b32_e32 v22, 16, v22
	v_cndmask_b32_e32 v24, v36, v39, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_bfe_u32 v36, v11, 16, 1
	v_add3_u32 v35, v35, v10, 0x7fff
	v_or_b32_e32 v39, 0x400000, v11
	v_lshrrev_b32_e32 v23, 16, v23
	v_cndmask_b32_e32 v9, v37, v40, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_bfe_u32 v37, v12, 16, 1
	v_add3_u32 v36, v36, v11, 0x7fff
	v_or_b32_e32 v40, 0x400000, v12
	v_lshrrev_b32_e32 v24, 16, v24
	v_cndmask_b32_e32 v10, v35, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_add3_u32 v37, v37, v12, 0x7fff
	v_bfe_u32 v35, v13, 16, 1
	v_or_b32_e32 v38, 0x400000, v13
	v_lshrrev_b32_e32 v9, 16, v9
	v_cndmask_b32_e32 v11, v36, v39, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_bfe_u32 v36, v14, 16, 1
	v_add3_u32 v35, v35, v13, 0x7fff
	v_or_b32_e32 v39, 0x400000, v14
	v_lshrrev_b32_e32 v10, 16, v10
	v_cndmask_b32_e32 v12, v37, v40, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_bfe_u32 v37, v15, 16, 1
	v_add3_u32 v36, v36, v14, 0x7fff
	v_or_b32_e32 v40, 0x400000, v15
	v_lshrrev_b32_e32 v11, 16, v11
	v_cndmask_b32_e32 v13, v35, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_add3_u32 v37, v37, v15, 0x7fff
	v_bfe_u32 v35, v16, 16, 1
	v_or_b32_e32 v38, 0x400000, v16
	v_lshrrev_b32_e32 v12, 16, v12
	v_cndmask_b32_e32 v14, v36, v39, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_bfe_u32 v36, v1, 16, 1
	v_add3_u32 v35, v35, v16, 0x7fff
	v_or_b32_e32 v39, 0x400000, v1
	v_lshrrev_b32_e32 v13, 16, v13
	v_cndmask_b32_e32 v15, v37, v40, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	v_bfe_u32 v37, v2, 16, 1
	v_add3_u32 v36, v36, v1, 0x7fff
	v_or_b32_e32 v40, 0x400000, v2
	v_lshrrev_b32_e32 v14, 16, v14
	v_cndmask_b32_e32 v16, v35, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	v_add3_u32 v37, v37, v2, 0x7fff
	v_bfe_u32 v35, v3, 16, 1
	v_bfe_u32 v38, v5, 16, 1
	v_lshrrev_b32_e32 v15, 16, v15
	v_cndmask_b32_e32 v1, v36, v39, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_bfe_u32 v36, v4, 16, 1
	v_add3_u32 v35, v35, v3, 0x7fff
	v_or_b32_e32 v39, 0x400000, v4
	v_lshrrev_b32_e32 v16, 16, v16
	v_cndmask_b32_e32 v2, v37, v40, vcc_lo
	v_or_b32_e32 v37, 0x400000, v3
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_add3_u32 v36, v36, v4, 0x7fff
	v_lshrrev_b32_e32 v1, 16, v1
	v_lshrrev_b32_e32 v2, 16, v2
	v_cndmask_b32_e32 v3, v35, v37, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_add3_u32 v35, v38, v5, 0x7fff
	v_or_b32_e32 v37, 0x400000, v5
	v_cndmask_b32_e32 v4, v36, v39, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_bfe_u32 v36, v6, 16, 1
	v_lshrrev_b32_e32 v3, 16, v3
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_4)
	v_lshrrev_b32_e32 v4, 16, v4
	v_cndmask_b32_e32 v5, v35, v37, vcc_lo
	v_add3_u32 v35, v36, v6, 0x7fff
	v_or_b32_e32 v36, 0x400000, v6
	v_bfe_u32 v37, v7, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_lshrrev_b32_e32 v5, 16, v5
	s_delay_alu instid0(VALU_DEP_3)
	v_add3_u32 v34, v37, v7, 0x7fff
	v_cndmask_b32_e32 v6, v35, v36, vcc_lo
	v_bfe_u32 v35, v8, 16, 1
	v_or_b32_e32 v36, 0x400000, v7
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_or_b32_e32 v37, 0x400000, v8
	v_lshrrev_b32_e32 v6, 16, v6
	v_add3_u32 v35, v35, v8, 0x7fff
	v_cndmask_b32_e32 v7, v34, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_add_nc_u32_e32 v34, 0x8000, v0
	s_clause 0x2
	buffer_store_b16 v25, v0, s[0:3], 0 offen
	buffer_store_b16 v26, v33, s[0:3], 0 offen
	buffer_store_b16 v27, v34, s[0:3], 0 offen
	v_dual_cndmask_b32 v8, v35, v37 :: v_dual_add_nc_u32 v25, 0xc000, v0
	v_add_nc_u32_e32 v26, 0x10000, v0
	v_add_nc_u32_e32 v27, 0x14000, v0
	v_add_nc_u32_e32 v35, 0x18000, v0
	v_add_nc_u32_e32 v36, 0x1c000, v0
	v_lshrrev_b32_e32 v7, 16, v7
	v_lshrrev_b32_e32 v8, 16, v8
	s_clause 0x1c
	buffer_store_b16 v28, v25, s[0:3], 0 offen
	buffer_store_b16 v29, v26, s[0:3], 0 offen
	buffer_store_b16 v30, v27, s[0:3], 0 offen
	buffer_store_b16 v31, v35, s[0:3], 0 offen
	buffer_store_b16 v32, v36, s[0:3], 0 offen
	buffer_store_b16 v17, v0, s[0:3], 0 offen offset:32
	buffer_store_b16 v18, v33, s[0:3], 0 offen offset:32
	buffer_store_b16 v19, v34, s[0:3], 0 offen offset:32
	buffer_store_b16 v20, v25, s[0:3], 0 offen offset:32
	buffer_store_b16 v21, v26, s[0:3], 0 offen offset:32
	buffer_store_b16 v22, v27, s[0:3], 0 offen offset:32
	buffer_store_b16 v23, v35, s[0:3], 0 offen offset:32
	buffer_store_b16 v24, v36, s[0:3], 0 offen offset:32
	buffer_store_b16 v9, v0, s[0:3], 0 offen offset:64
	buffer_store_b16 v10, v33, s[0:3], 0 offen offset:64
	buffer_store_b16 v11, v34, s[0:3], 0 offen offset:64
	buffer_store_b16 v12, v25, s[0:3], 0 offen offset:64
	buffer_store_b16 v13, v26, s[0:3], 0 offen offset:64
	buffer_store_b16 v14, v27, s[0:3], 0 offen offset:64
	buffer_store_b16 v15, v35, s[0:3], 0 offen offset:64
	buffer_store_b16 v16, v36, s[0:3], 0 offen offset:64
	buffer_store_b16 v1, v0, s[0:3], 0 offen offset:96
	buffer_store_b16 v2, v33, s[0:3], 0 offen offset:96
	buffer_store_b16 v3, v34, s[0:3], 0 offen offset:96
	buffer_store_b16 v4, v25, s[0:3], 0 offen offset:96
	buffer_store_b16 v5, v26, s[0:3], 0 offen offset:96
	buffer_store_b16 v6, v27, s[0:3], 0 offen offset:96
	buffer_store_b16 v7, v35, s[0:3], 0 offen offset:96
	buffer_store_b16 v8, v36, s[0:3], 0 offen offset:96
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
		.amdhsa_next_free_vgpr 103
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

	.set .Lexercise_kernel_0.num_vgpr, 103
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
    .sgpr_count:     14
    .sgpr_spill_count: 0
    .symbol:         exercise_kernel_0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     103
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
