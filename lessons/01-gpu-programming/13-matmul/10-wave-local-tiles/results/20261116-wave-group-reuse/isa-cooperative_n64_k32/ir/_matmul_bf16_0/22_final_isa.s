	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	_matmul_bf16_0
	.p2align	8
	.type	_matmul_bf16_0,@function
_matmul_bf16_0:
	v_lshlrev_b32_e32 v1, 3, v0
	s_clause 0x1
	s_load_b64 s[4:5], s[0:1], 0x0
	s_load_b64 s[8:9], s[0:1], 0x18
	s_ashr_i32 s3, s2, 31
	v_lshrrev_b32_e32 v19, 3, v0
	s_lshr_b32 s3, s3, 26
	v_and_b32_e32 v22, 56, v1
	s_add_i32 s3, s2, s3
	v_lshlrev_b32_e32 v1, 4, v0
	s_and_b32 s3, s3, 0x3ffffc0
	v_lshrrev_b32_e32 v25, 2, v0
	v_lshl_or_b32 v2, v19, 12, v22
	s_sub_i32 s2, s2, s3
	v_and_b32_e32 v24, 48, v1
	s_lshl_b32 s12, s2, 6
	s_mov_b32 s7, 0x21027000
	v_add_lshl_u32 v20, v2, s12, 1
	s_mov_b32 s6, -1
	v_lshl_or_b32 v21, v25, 14, v24
	s_mov_b32 s10, s6
	s_mov_b32 s11, s7
	v_add_nc_u32_e32 v1, 0x10000, v20
	s_waitcnt lgkmcnt(0)
	s_and_b32 s5, s5, 0xffff
	v_add_nc_u32_e32 v2, 0x20000, v20
	s_and_b32 s9, s9, 0xffff
	v_add_nc_u32_e32 v3, 0x30000, v20
	buffer_load_b128 v[26:29], v21, s[4:7], 0 offen
	s_clause 0x3
	buffer_load_b128 v[30:33], v20, s[8:11], 0 offen
	buffer_load_b128 v[34:37], v1, s[8:11], 0 offen
	buffer_load_b128 v[38:41], v2, s[8:11], 0 offen
	buffer_load_b128 v[42:45], v3, s[8:11], 0 offen
	v_mov_b32_e32 v1, 0
	v_lshrrev_b32_e32 v16, 1, v0
	v_and_b32_e32 v17, 15, v0
	v_lshlrev_b32_e32 v23, 7, v19
	v_mul_u32_u24_e32 v47, 0x50, v25
	s_delay_alu instid0(VALU_DEP_4)
	v_dual_mov_b32 v7, v1 :: v_dual_and_b32 v18, 16, v16
	v_mov_b32_e32 v3, v1
	v_mov_b32_e32 v4, v1
	v_mov_b32_e32 v6, v1
	v_or_b32_e32 v46, 0x1000, v24
	v_or_b32_e32 v19, v17, v18
	v_dual_mov_b32 v9, v1 :: v_dual_lshlrev_b32 v24, 1, v22
	v_mov_b32_e32 v2, v1
	v_mov_b32_e32 v5, v1
	s_delay_alu instid0(VALU_DEP_4)
	v_dual_mov_b32 v8, v1 :: v_dual_lshlrev_b32 v19, 1, v19
	v_mov_b32_e32 v10, v1
	v_mov_b32_e32 v11, v1
	v_mov_b32_e32 v12, v1
	v_mov_b32_e32 v13, v1
	v_mov_b32_e32 v14, v1
	v_mov_b32_e32 v15, v1
	v_mov_b32_e32 v16, v1
	v_mul_u32_u24_e32 v22, 0x50, v17
	v_mad_u32_u24 v48, 0x50, v25, v46
	v_add_nc_u32_e32 v25, v46, v47
	v_or_b32_e32 v49, v24, v23
	s_mov_b32 s2, 0
	s_waitcnt vmcnt(4)
	ds_store_b128 v48, v[26:29]
	s_waitcnt vmcnt(3)
	ds_store_b128 v49, v[30:33]
	s_waitcnt vmcnt(2)
	ds_store_b128 v49, v[34:37] offset:1024
	s_waitcnt vmcnt(1)
	ds_store_b128 v49, v[38:41] offset:2048
	s_waitcnt vmcnt(0)
	ds_store_b128 v49, v[42:45] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
.LBB0_1:
	s_add_i32 s2, s2, 1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	v_lshl_add_u32 v26, s2, 18, v20
	v_lshl_add_u32 v27, s2, 6, v21
	s_cmpk_lg_i32 s2, 0xff
	v_add_nc_u32_e32 v28, 0x10000, v26
	v_add_nc_u32_e32 v29, 0x20000, v26
	v_add_nc_u32_e32 v30, 0x30000, v26
	buffer_load_b128 v[74:77], v27, s[4:7], 0 offen
	s_clause 0x3
	buffer_load_b128 v[78:81], v26, s[8:11], 0 offen
	buffer_load_b128 v[82:85], v28, s[8:11], 0 offen
	buffer_load_b128 v[86:89], v29, s[8:11], 0 offen
	buffer_load_b128 v[90:93], v30, s[8:11], 0 offen
	ds_load_b128 v[26:29], v22 offset:4096
	ds_load_b128 v[30:33], v22 offset:4112
	ds_load_b128 v[34:37], v22 offset:4128
	ds_load_b128 v[38:41], v22 offset:4144
	ds_load_u16_d16 v42, v19
	ds_load_u16_d16_hi v42, v19 offset:128
	ds_load_u16_d16 v43, v19 offset:256
	ds_load_u16_d16_hi v43, v19 offset:384
	ds_load_u16_d16_hi v51, v19 offset:448
	ds_load_u16_d16 v51, v19 offset:320
	ds_load_u16_d16_hi v50, v19 offset:192
	ds_load_u16_d16 v50, v19 offset:64
	ds_load_u16_d16 v44, v19 offset:512
	ds_load_u16_d16_hi v44, v19 offset:640
	ds_load_u16_d16 v45, v19 offset:768
	ds_load_u16_d16_hi v45, v19 offset:896
	ds_load_u16_d16_hi v53, v19 offset:960
	ds_load_u16_d16 v53, v19 offset:832
	ds_load_u16_d16_hi v52, v19 offset:704
	ds_load_u16_d16 v52, v19 offset:576
	ds_load_u16_d16 v46, v19 offset:1024
	ds_load_u16_d16_hi v46, v19 offset:1152
	ds_load_u16_d16 v47, v19 offset:1280
	ds_load_u16_d16_hi v47, v19 offset:1408
	ds_load_u16_d16_hi v55, v19 offset:1472
	ds_load_u16_d16 v55, v19 offset:1344
	ds_load_u16_d16_hi v54, v19 offset:1216
	ds_load_u16_d16 v54, v19 offset:1088
	ds_load_u16_d16 v48, v19 offset:1536
	ds_load_u16_d16_hi v48, v19 offset:1664
	ds_load_u16_d16 v49, v19 offset:1792
	ds_load_u16_d16_hi v49, v19 offset:1920
	ds_load_u16_d16_hi v57, v19 offset:1984
	ds_load_u16_d16 v57, v19 offset:1856
	ds_load_u16_d16_hi v56, v19 offset:1728
	ds_load_u16_d16 v56, v19 offset:1600
	ds_load_u16_d16 v58, v19 offset:2048
	ds_load_u16_d16_hi v58, v19 offset:2176
	ds_load_u16_d16 v59, v19 offset:2304
	ds_load_u16_d16_hi v59, v19 offset:2432
	ds_load_u16_d16_hi v67, v19 offset:2496
	ds_load_u16_d16 v67, v19 offset:2368
	ds_load_u16_d16_hi v66, v19 offset:2240
	ds_load_u16_d16 v66, v19 offset:2112
	ds_load_u16_d16 v60, v19 offset:2560
	ds_load_u16_d16_hi v60, v19 offset:2688
	ds_load_u16_d16 v61, v19 offset:2816
	ds_load_u16_d16_hi v61, v19 offset:2944
	ds_load_u16_d16_hi v69, v19 offset:3008
	ds_load_u16_d16 v69, v19 offset:2880
	ds_load_u16_d16_hi v68, v19 offset:2752
	ds_load_u16_d16 v68, v19 offset:2624
	ds_load_u16_d16 v62, v19 offset:3072
	ds_load_u16_d16_hi v62, v19 offset:3200
	ds_load_u16_d16 v63, v19 offset:3328
	ds_load_u16_d16_hi v63, v19 offset:3456
	ds_load_u16_d16_hi v71, v19 offset:3520
	ds_load_u16_d16 v71, v19 offset:3392
	ds_load_u16_d16_hi v70, v19 offset:3264
	ds_load_u16_d16 v70, v19 offset:3136
	ds_load_u16_d16 v64, v19 offset:3584
	ds_load_u16_d16_hi v64, v19 offset:3712
	ds_load_u16_d16 v65, v19 offset:3840
	ds_load_u16_d16_hi v65, v19 offset:3968
	ds_load_u16_d16_hi v73, v19 offset:4032
	ds_load_u16_d16 v73, v19 offset:3904
	ds_load_u16_d16_hi v72, v19 offset:3776
	ds_load_u16_d16 v72, v19 offset:3648
	s_waitcnt lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[26:33], v[42:49], v[9:16]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[26:33], v[50:57], v[1:8]
	v_add_nc_u32_e32 v26, v24, v23
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[34:41], v[58:65], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[34:41], v[66:73], v[1:8]
	s_barrier
	s_waitcnt vmcnt(4)
	ds_store_b128 v25, v[74:77]
	s_waitcnt vmcnt(3)
	ds_store_b128 v26, v[78:81]
	s_waitcnt vmcnt(2)
	ds_store_b128 v26, v[82:85] offset:1024
	s_waitcnt vmcnt(1)
	ds_store_b128 v26, v[86:89] offset:2048
	s_waitcnt vmcnt(0)
	ds_store_b128 v26, v[90:93] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_cbranch_scc1 .LBB0_1
	ds_load_b128 v[23:26], v22 offset:4096
	ds_load_b128 v[27:30], v22 offset:4112
	ds_load_b128 v[31:34], v22 offset:4128
	ds_load_b128 v[35:38], v22 offset:4144
	ds_load_u16_d16 v39, v19
	ds_load_u16_d16_hi v39, v19 offset:128
	ds_load_u16_d16 v40, v19 offset:256
	ds_load_u16_d16_hi v40, v19 offset:384
	ds_load_u16_d16_hi v48, v19 offset:448
	ds_load_u16_d16 v48, v19 offset:320
	ds_load_u16_d16_hi v47, v19 offset:192
	ds_load_u16_d16 v47, v19 offset:64
	ds_load_u16_d16 v41, v19 offset:512
	ds_load_u16_d16_hi v41, v19 offset:640
	ds_load_u16_d16 v42, v19 offset:768
	ds_load_u16_d16_hi v42, v19 offset:896
	ds_load_u16_d16_hi v50, v19 offset:960
	ds_load_u16_d16 v50, v19 offset:832
	ds_load_u16_d16_hi v49, v19 offset:704
	ds_load_u16_d16 v49, v19 offset:576
	ds_load_u16_d16 v43, v19 offset:1024
	ds_load_u16_d16_hi v43, v19 offset:1152
	ds_load_u16_d16 v44, v19 offset:1280
	ds_load_u16_d16_hi v44, v19 offset:1408
	ds_load_u16_d16_hi v52, v19 offset:1472
	ds_load_u16_d16 v52, v19 offset:1344
	ds_load_u16_d16_hi v51, v19 offset:1216
	ds_load_u16_d16 v51, v19 offset:1088
	ds_load_u16_d16 v45, v19 offset:1536
	ds_load_u16_d16_hi v45, v19 offset:1664
	ds_load_u16_d16 v46, v19 offset:1792
	ds_load_u16_d16_hi v46, v19 offset:1920
	ds_load_u16_d16_hi v54, v19 offset:1984
	ds_load_u16_d16 v54, v19 offset:1856
	ds_load_u16_d16_hi v53, v19 offset:1728
	ds_load_u16_d16 v53, v19 offset:1600
	ds_load_u16_d16 v57, v19 offset:2560
	ds_load_u16_d16_hi v57, v19 offset:2688
	ds_load_u16_d16 v58, v19 offset:2816
	ds_load_u16_d16_hi v58, v19 offset:2944
	ds_load_u16_d16 v59, v19 offset:3072
	ds_load_u16_d16_hi v59, v19 offset:3200
	ds_load_u16_d16 v60, v19 offset:3328
	ds_load_u16_d16_hi v60, v19 offset:3456
	ds_load_u16_d16 v61, v19 offset:3584
	ds_load_u16_d16_hi v61, v19 offset:3712
	ds_load_u16_d16 v62, v19 offset:3840
	ds_load_u16_d16_hi v62, v19 offset:3968
	ds_load_u16_d16 v55, v19 offset:2048
	ds_load_u16_d16_hi v55, v19 offset:2176
	ds_load_u16_d16 v56, v19 offset:2304
	ds_load_u16_d16_hi v56, v19 offset:2432
	ds_load_u16_d16_hi v64, v19 offset:2496
	ds_load_u16_d16 v64, v19 offset:2368
	ds_load_u16_d16_hi v63, v19 offset:2240
	ds_load_u16_d16 v63, v19 offset:2112
	ds_load_u16_d16_hi v66, v19 offset:3008
	ds_load_u16_d16 v66, v19 offset:2880
	ds_load_u16_d16_hi v65, v19 offset:2752
	ds_load_u16_d16 v65, v19 offset:2624
	ds_load_u16_d16_hi v68, v19 offset:3520
	ds_load_u16_d16 v68, v19 offset:3392
	ds_load_u16_d16_hi v67, v19 offset:3264
	ds_load_u16_d16 v67, v19 offset:3136
	ds_load_u16_d16_hi v70, v19 offset:4032
	ds_load_u16_d16 v70, v19 offset:3904
	ds_load_u16_d16_hi v69, v19 offset:3776
	ds_load_u16_d16 v69, v19 offset:3648
	s_waitcnt lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[23:30], v[39:46], v[9:16]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[23:30], v[47:54], v[1:8]
	s_load_b64 s[0:1], s[0:1], 0x30
	s_mov_b32 s3, 0x21027000
	s_mov_b32 s2, -1
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[31:38], v[55:62], v[9:16]
	v_lshlrev_b32_e32 v0, 8, v0
	s_delay_alu instid0(VALU_DEP_2)
	v_bfe_u32 v19, v9, 16, 1
	v_or_b32_e32 v20, 0x400000, v9
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_or_b32_e32 v22, 0x400000, v10
	v_bfe_u32 v21, v12, 16, 1
	v_add3_u32 v19, v19, v9, 0x7fff
	v_or_b32_e32 v23, 0x400000, v11
	v_or_b32_e32 v24, 0x400000, v12
	v_and_or_b32 v0, 0x1000, v0, v17
	v_add3_u32 v21, v21, v12, 0x7fff
	v_cndmask_b32_e32 v9, v19, v20, vcc_lo
	v_bfe_u32 v19, v10, 16, 1
	v_bfe_u32 v20, v11, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_wmma_f32_16x16x16_bf16 v[1:8], v[31:38], v[63:70], v[1:8]
	v_or_b32_e32 v17, s12, v18
	v_add3_u32 v19, v19, v10, 0x7fff
	v_add3_u32 v20, v20, v11, 0x7fff
	s_and_b32 s1, s1, 0xffff
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_add_lshl_u32 v0, v17, v0, 1
	v_cndmask_b32_e32 v10, v19, v22, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_bfe_u32 v19, v13, 16, 1
	v_or_b32_e32 v22, 0x400000, v13
	v_add_nc_u32_e32 v17, 0x4000, v0
	v_cndmask_b32_e32 v11, v20, v23, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_bfe_u32 v20, v14, 16, 1
	v_add3_u32 v19, v19, v13, 0x7fff
	v_or_b32_e32 v23, 0x400000, v14
	v_lshrrev_b32_e32 v10, 16, v10
	v_cndmask_b32_e32 v12, v21, v24, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_bfe_u32 v21, v15, 16, 1
	v_add3_u32 v20, v20, v14, 0x7fff
	v_or_b32_e32 v24, 0x400000, v15
	v_lshrrev_b32_e32 v11, 16, v11
	v_cndmask_b32_e32 v13, v19, v22, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_add3_u32 v21, v21, v15, 0x7fff
	v_bfe_u32 v19, v16, 16, 1
	v_or_b32_e32 v22, 0x400000, v16
	v_lshrrev_b32_e32 v12, 16, v12
	v_cndmask_b32_e32 v14, v20, v23, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_bfe_u32 v20, v1, 16, 1
	v_add3_u32 v19, v19, v16, 0x7fff
	v_or_b32_e32 v23, 0x400000, v1
	v_lshrrev_b32_e32 v9, 16, v9
	v_cndmask_b32_e32 v15, v21, v24, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	v_bfe_u32 v21, v2, 16, 1
	v_add3_u32 v20, v20, v1, 0x7fff
	v_or_b32_e32 v24, 0x400000, v2
	v_lshrrev_b32_e32 v13, 16, v13
	v_cndmask_b32_e32 v16, v19, v22, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	v_add3_u32 v21, v21, v2, 0x7fff
	v_bfe_u32 v19, v3, 16, 1
	v_bfe_u32 v22, v5, 16, 1
	v_lshrrev_b32_e32 v14, 16, v14
	v_cndmask_b32_e32 v1, v20, v23, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_bfe_u32 v20, v4, 16, 1
	v_add3_u32 v19, v19, v3, 0x7fff
	v_or_b32_e32 v23, 0x400000, v4
	v_lshrrev_b32_e32 v15, 16, v15
	v_cndmask_b32_e32 v2, v21, v24, vcc_lo
	v_or_b32_e32 v21, 0x400000, v3
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_add3_u32 v20, v20, v4, 0x7fff
	v_lshrrev_b32_e32 v16, 16, v16
	v_lshrrev_b32_e32 v1, 16, v1
	v_lshrrev_b32_e32 v2, 16, v2
	v_cndmask_b32_e32 v3, v19, v21, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_add3_u32 v19, v22, v5, 0x7fff
	v_or_b32_e32 v21, 0x400000, v5
	s_barrier
	v_cndmask_b32_e32 v4, v20, v23, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_bfe_u32 v20, v6, 16, 1
	v_lshrrev_b32_e32 v3, 16, v3
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_4)
	v_lshrrev_b32_e32 v4, 16, v4
	v_cndmask_b32_e32 v5, v19, v21, vcc_lo
	v_add3_u32 v19, v20, v6, 0x7fff
	v_or_b32_e32 v20, 0x400000, v6
	v_bfe_u32 v21, v7, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_lshrrev_b32_e32 v5, 16, v5
	s_delay_alu instid0(VALU_DEP_3)
	v_add3_u32 v18, v21, v7, 0x7fff
	v_cndmask_b32_e32 v6, v19, v20, vcc_lo
	v_bfe_u32 v19, v8, 16, 1
	v_or_b32_e32 v20, 0x400000, v7
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_or_b32_e32 v21, 0x400000, v8
	v_lshrrev_b32_e32 v6, 16, v6
	v_add3_u32 v19, v19, v8, 0x7fff
	v_cndmask_b32_e32 v7, v18, v20, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_add_nc_u32_e32 v18, 0x8000, v0
	s_clause 0x2
	buffer_store_b16 v9, v0, s[0:3], 0 offen
	buffer_store_b16 v10, v17, s[0:3], 0 offen
	buffer_store_b16 v11, v18, s[0:3], 0 offen
	v_dual_cndmask_b32 v8, v19, v21 :: v_dual_add_nc_u32 v9, 0xc000, v0
	v_add_nc_u32_e32 v10, 0x10000, v0
	v_add_nc_u32_e32 v11, 0x14000, v0
	v_add_nc_u32_e32 v19, 0x18000, v0
	v_add_nc_u32_e32 v20, 0x1c000, v0
	v_lshrrev_b32_e32 v7, 16, v7
	v_lshrrev_b32_e32 v8, 16, v8
	s_clause 0xc
	buffer_store_b16 v12, v9, s[0:3], 0 offen
	buffer_store_b16 v13, v10, s[0:3], 0 offen
	buffer_store_b16 v14, v11, s[0:3], 0 offen
	buffer_store_b16 v15, v19, s[0:3], 0 offen
	buffer_store_b16 v16, v20, s[0:3], 0 offen
	buffer_store_b16 v1, v0, s[0:3], 0 offen offset:64
	buffer_store_b16 v2, v17, s[0:3], 0 offen offset:64
	buffer_store_b16 v3, v18, s[0:3], 0 offen offset:64
	buffer_store_b16 v4, v9, s[0:3], 0 offen offset:64
	buffer_store_b16 v5, v10, s[0:3], 0 offen offset:64
	buffer_store_b16 v6, v11, s[0:3], 0 offen offset:64
	buffer_store_b16 v7, v19, s[0:3], 0 offen offset:64
	buffer_store_b16 v8, v20, s[0:3], 0 offen offset:64
	s_endpgm
.Lfunc_end0:
	.size	_matmul_bf16_0, .Lfunc_end0-_matmul_bf16_0
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _matmul_bf16_0
		.amdhsa_group_segment_fixed_size 5376
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
		.amdhsa_next_free_vgpr 97
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

	.set .L_matmul_bf16_0.num_vgpr, 94
	.set .L_matmul_bf16_0.num_agpr, 0
	.set .L_matmul_bf16_0.numbered_sgpr, 13
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
    .group_segment_fixed_size: 5376
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 64
    .name:           _matmul_bf16_0
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 64
      - 1
      - 1
    .sgpr_count:     15
    .sgpr_spill_count: 0
    .symbol:         _matmul_bf16_0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     94
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
