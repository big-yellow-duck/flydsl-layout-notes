	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	exercise_kernel_0
	.p2align	8
	.type	exercise_kernel_0,@function
exercise_kernel_0:
	v_dual_mov_b32 v57, 0 :: v_dual_and_b32 v72, 15, v0
	v_lshlrev_b32_e32 v1, 3, v0
	v_lshrrev_b32_e32 v74, 2, v0
	v_lshrrev_b32_e32 v75, 3, v0
	s_delay_alu instid0(VALU_DEP_4)
	v_mov_b32_e32 v58, v57
	s_clause 0x1
	s_load_b64 s[6:7], s[0:1], 0x0
	s_load_b64 s[4:5], s[0:1], 0x18
	v_dual_mov_b32 v59, v57 :: v_dual_and_b32 v78, 56, v1
	v_dual_mov_b32 v60, v57 :: v_dual_and_b32 v77, 24, v1
	v_dual_mov_b32 v62, v57 :: v_dual_lshlrev_b32 v1, 10, v74
	s_lshl_b32 s3, s3, 17
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_lshl_or_b32 v2, v75, 10, v78
	s_lshl_b32 s2, s2, 6
	v_or3_b32 v1, v77, v1, s3
	v_mov_b32_e32 v64, v57
	v_bfe_i32 v79, v0, 5, 1
	v_dual_mov_b32 v26, v57 :: v_dual_add_nc_u32 v69, s2, v2
	v_and_b32_e32 v73, 16, v74
	v_ashrrev_i32_e32 v2, 31, v1
	v_dual_mov_b32 v28, v57 :: v_dual_lshlrev_b32 v101, 1, v77
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_4)
	v_ashrrev_i32_e32 v70, 31, v69
	v_dual_mov_b32 v30, v57 :: v_dual_and_b32 v79, 0x500, v79
	v_lshlrev_b64 v[1:2], 1, v[1:2]
	v_mul_u32_u24_e32 v100, 0x50, v74
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_4) | instid1(VALU_DEP_1)
	v_lshlrev_b64 v[3:4], 1, v[69:70]
	v_or_b32_e32 v102, v72, v73
	v_dual_mov_b32 v61, v57 :: v_dual_lshlrev_b32 v76, 7, v75
	s_waitcnt lgkmcnt(0)
	v_add_co_u32 v70, vcc_lo, s6, v1
	v_add_co_ci_u32_e64 v71, null, s7, v2, vcc_lo
	v_add_co_u32 v1, vcc_lo, s4, v3
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_add_co_ci_u32_e64 v2, null, s5, v4, vcc_lo
	v_add_co_u32 v3, vcc_lo, 0x10000, v70
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v4, null, 0, v71, vcc_lo
	v_add_co_u32 v5, vcc_lo, 0x20000, v70
	v_add_co_ci_u32_e64 v6, null, 0, v71, vcc_lo
	v_add_co_u32 v7, vcc_lo, 0x30000, v70
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v8, null, 0, v71, vcc_lo
	v_add_co_u32 v9, vcc_lo, 0x8000, v1
	v_add_co_ci_u32_e64 v10, null, 0, v2, vcc_lo
	s_clause 0x2
	global_load_b128 v[80:83], v[3:4], off
	global_load_b128 v[84:87], v[5:6], off
	global_load_b128 v[88:91], v[7:8], off
	s_clause 0x1
	global_load_b128 v[92:95], v[1:2], off
	global_load_b128 v[96:99], v[9:10], off
	global_load_b128 v[65:68], v[70:71], off
	v_lshl_or_b32 v77, v78, 1, 0x2800
	v_mov_b32_e32 v63, v57
	v_mov_b32_e32 v25, v57
	v_mov_b32_e32 v27, v57
	v_mov_b32_e32 v29, v57
	v_mov_b32_e32 v31, v57
	v_mov_b32_e32 v32, v57
	v_mov_b32_e32 v49, v57
	v_mov_b32_e32 v50, v57
	v_mov_b32_e32 v51, v57
	v_mov_b32_e32 v52, v57
	v_mov_b32_e32 v53, v57
	v_mov_b32_e32 v54, v57
	v_mov_b32_e32 v55, v57
	v_mov_b32_e32 v56, v57
	v_mov_b32_e32 v17, v57
	v_mov_b32_e32 v18, v57
	v_mov_b32_e32 v19, v57
	v_mov_b32_e32 v20, v57
	v_mov_b32_e32 v21, v57
	v_mov_b32_e32 v22, v57
	v_mov_b32_e32 v23, v57
	v_mov_b32_e32 v24, v57
	v_mov_b32_e32 v41, v57
	v_mov_b32_e32 v42, v57
	v_mov_b32_e32 v43, v57
	v_mov_b32_e32 v44, v57
	v_mov_b32_e32 v45, v57
	v_mov_b32_e32 v46, v57
	v_mov_b32_e32 v47, v57
	v_mov_b32_e32 v48, v57
	v_mov_b32_e32 v9, v57
	v_mov_b32_e32 v10, v57
	v_mov_b32_e32 v11, v57
	v_mov_b32_e32 v12, v57
	v_mov_b32_e32 v13, v57
	v_mov_b32_e32 v14, v57
	v_mov_b32_e32 v15, v57
	v_mov_b32_e32 v16, v57
	v_mov_b32_e32 v33, v57
	v_mov_b32_e32 v34, v57
	v_mov_b32_e32 v35, v57
	v_mov_b32_e32 v36, v57
	v_mov_b32_e32 v37, v57
	v_mov_b32_e32 v38, v57
	v_mov_b32_e32 v39, v57
	v_mov_b32_e32 v40, v57
	v_mov_b32_e32 v1, v57
	v_mov_b32_e32 v2, v57
	v_mov_b32_e32 v3, v57
	v_mov_b32_e32 v4, v57
	v_mov_b32_e32 v5, v57
	v_mov_b32_e32 v6, v57
	v_mov_b32_e32 v7, v57
	v_mov_b32_e32 v8, v57
	v_mul_u32_u24_e32 v75, 0x50, v72
	v_mad_u32_u24 v103, 0x50, v74, v101
	v_mad_u32_u24 v78, 0x50, v72, v79
	v_lshl_or_b32 v74, v102, 1, 0x2800
	v_add_nc_u32_e32 v79, v101, v100
	s_mov_b32 s6, 0
	v_or_b32_e32 v104, v77, v76
	s_waitcnt vmcnt(0)
	ds_store_b128 v103, v[65:68]
	ds_store_b128 v103, v[80:83] offset:2560
	ds_store_b128 v103, v[84:87] offset:5120
	ds_store_b128 v103, v[88:91] offset:7680
	ds_store_b128 v104, v[92:95]
	ds_store_b128 v104, v[96:99] offset:2048
	s_waitcnt lgkmcnt(0)
	s_barrier
	buffer_gl0_inv
.LBB0_1:
	s_add_i32 s6, s6, 1
	v_add_nc_u32_e32 v164, v77, v76
	v_lshl_add_u32 v80, s6, 15, v69
	s_lshl_b32 s7, s6, 6
	s_cmp_lg_u32 s6, 31
	v_add_co_u32 v82, vcc_lo, v70, s7
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_ashrrev_i32_e32 v81, 31, v80
	v_add_co_ci_u32_e64 v83, null, 0, v71, vcc_lo
	v_add_co_u32 v84, vcc_lo, 0x10000, v82
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_lshlrev_b64 v[80:81], 1, v[80:81]
	v_add_co_ci_u32_e64 v85, null, 0, v83, vcc_lo
	global_load_b128 v[65:68], v[82:83], off
	v_add_co_u32 v80, vcc_lo, s4, v80
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v81, null, s5, v81, vcc_lo
	v_add_co_u32 v86, vcc_lo, 0x20000, v82
	v_add_co_ci_u32_e64 v87, null, 0, v83, vcc_lo
	v_add_co_u32 v82, vcc_lo, 0x30000, v82
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v83, null, 0, v83, vcc_lo
	v_add_co_u32 v88, vcc_lo, 0x8000, v80
	v_add_co_ci_u32_e64 v89, null, 0, v81, vcc_lo
	s_clause 0x2
	global_load_b128 v[144:147], v[84:85], off
	global_load_b128 v[148:151], v[86:87], off
	global_load_b128 v[152:155], v[82:83], off
	s_clause 0x1
	global_load_b128 v[156:159], v[80:81], off
	global_load_b128 v[160:163], v[88:89], off
	ds_load_u16_d16 v80, v74
	ds_load_u16_d16 v81, v74 offset:256
	ds_load_u16_d16 v86, v74 offset:1536
	ds_load_b128 v[88:91], v78
	ds_load_b128 v[92:95], v78 offset:16
	ds_load_b128 v[96:99], v78 offset:2560
	ds_load_b128 v[100:103], v78 offset:2576
	ds_load_u16_d16 v87, v74 offset:1792
	ds_load_u16_d16 v82, v74 offset:512
	ds_load_u16_d16 v83, v74 offset:768
	ds_load_u16_d16 v84, v74 offset:1024
	ds_load_u16_d16 v85, v74 offset:1280
	ds_load_u16_d16 v104, v74 offset:64
	s_waitcnt lgkmcnt(12)
	ds_load_u16_d16_hi v80, v74 offset:128
	s_waitcnt lgkmcnt(12)
	ds_load_u16_d16_hi v81, v74 offset:384
	ds_load_u16_d16 v106, v74 offset:576
	ds_load_u16_d16 v107, v74 offset:832
	ds_load_u16_d16 v108, v74 offset:1088
	ds_load_u16_d16 v109, v74 offset:1344
	ds_load_u16_d16 v105, v74 offset:320
	s_waitcnt lgkmcnt(17)
	ds_load_u16_d16_hi v86, v74 offset:1664
	ds_load_u16_d16 v112, v74 offset:2048
	ds_load_u16_d16 v113, v74 offset:2304
	ds_load_u16_d16 v114, v74 offset:2560
	ds_load_u16_d16 v115, v74 offset:2816
	ds_load_u16_d16 v110, v74 offset:1600
	ds_load_u16_d16 v116, v74 offset:3072
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v87, v74 offset:1920
	ds_load_u16_d16 v120, v74 offset:2112
	ds_load_u16_d16 v121, v74 offset:2368
	ds_load_u16_d16 v122, v74 offset:2624
	ds_load_u16_d16 v123, v74 offset:2880
	ds_load_u16_d16 v111, v74 offset:1856
	s_waitcnt lgkmcnt(24)
	ds_load_u16_d16_hi v82, v74 offset:640
	s_waitcnt lgkmcnt(24)
	ds_load_u16_d16_hi v83, v74 offset:896
	s_waitcnt lgkmcnt(24)
	ds_load_u16_d16_hi v84, v74 offset:1152
	s_waitcnt lgkmcnt(24)
	ds_load_u16_d16_hi v85, v74 offset:1408
	ds_load_b128 v[128:131], v78 offset:5120
	ds_load_b128 v[132:135], v78 offset:5136
	ds_load_b128 v[136:139], v78 offset:7680
	ds_load_b128 v[140:143], v78 offset:7696
	ds_load_u16_d16 v117, v74 offset:3328
	ds_load_u16_d16 v118, v74 offset:3584
	ds_load_u16_d16 v119, v74 offset:3840
	ds_load_u16_d16 v124, v74 offset:3136
	s_waitcnt lgkmcnt(32)
	ds_load_u16_d16_hi v104, v74 offset:192
	s_waitcnt lgkmcnt(27)
	ds_load_u16_d16_hi v109, v74 offset:1472
	s_waitcnt lgkmcnt(21)
	ds_load_u16_d16_hi v110, v74 offset:1728
	ds_load_u16_d16_hi v108, v74 offset:1216
	ds_load_u16_d16_hi v107, v74 offset:960
	ds_load_u16_d16_hi v106, v74 offset:704
	ds_load_u16_d16_hi v105, v74 offset:448
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v111, v74 offset:1984
	ds_load_u16_d16_hi v116, v74 offset:3200
	ds_load_u16_d16_hi v123, v74 offset:3008
	s_waitcnt lgkmcnt(18)
	v_wmma_f32_16x16x16_bf16 v[57:64], v[88:95], v[80:87], v[57:64]
	v_wmma_f32_16x16x16_bf16 v[49:56], v[96:103], v[80:87], v[49:56]
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[41:48], v[128:135], v[80:87], v[41:48]
	s_waitcnt lgkmcnt(14)
	v_wmma_f32_16x16x16_bf16 v[33:40], v[136:143], v[80:87], v[33:40]
	ds_load_b128 v[80:83], v78 offset:32
	ds_load_b128 v[84:87], v78 offset:48
	s_waitcnt lgkmcnt(15)
	ds_load_u16_d16_hi v117, v74 offset:3456
	ds_load_u16_d16 v126, v74 offset:3648
	ds_load_u16_d16 v127, v74 offset:3904
	s_waitcnt lgkmcnt(15)
	ds_load_u16_d16_hi v124, v74 offset:3264
	ds_load_u16_d16 v125, v74 offset:3392
	ds_load_u16_d16_hi v113, v74 offset:2432
	ds_load_u16_d16_hi v114, v74 offset:2688
	ds_load_u16_d16_hi v115, v74 offset:2944
	ds_load_u16_d16_hi v122, v74 offset:2752
	ds_load_u16_d16_hi v121, v74 offset:2496
	ds_load_u16_d16_hi v112, v74 offset:2176
	ds_load_u16_d16_hi v120, v74 offset:2240
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[88:95], v[104:111], v[25:32]
	ds_load_b128 v[88:91], v78 offset:2592
	ds_load_b128 v[92:95], v78 offset:2608
	v_wmma_f32_16x16x16_bf16 v[17:24], v[96:103], v[104:111], v[17:24]
	ds_load_b128 v[96:99], v78 offset:5152
	ds_load_b128 v[100:103], v78 offset:5168
	ds_load_u16_d16_hi v118, v74 offset:3712
	ds_load_u16_d16_hi v119, v74 offset:3968
	v_wmma_f32_16x16x16_bf16 v[9:16], v[128:135], v[104:111], v[9:16]
	ds_load_b128 v[128:131], v78 offset:7712
	ds_load_b128 v[132:135], v78 offset:7728
	s_waitcnt lgkmcnt(17)
	ds_load_u16_d16_hi v127, v74 offset:4032
	ds_load_u16_d16_hi v126, v74 offset:3776
	s_waitcnt lgkmcnt(17)
	ds_load_u16_d16_hi v125, v74 offset:3520
	v_wmma_f32_16x16x16_bf16 v[1:8], v[136:143], v[104:111], v[1:8]
	s_waitcnt lgkmcnt(5)
	v_wmma_f32_16x16x16_bf16 v[57:64], v[80:87], v[112:119], v[57:64]
	v_wmma_f32_16x16x16_bf16 v[49:56], v[88:95], v[112:119], v[49:56]
	v_wmma_f32_16x16x16_bf16 v[41:48], v[96:103], v[112:119], v[41:48]
	s_waitcnt lgkmcnt(3)
	v_wmma_f32_16x16x16_bf16 v[33:40], v[128:135], v[112:119], v[33:40]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[80:87], v[120:127], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[88:95], v[120:127], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[96:103], v[120:127], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[128:135], v[120:127], v[1:8]
	s_waitcnt vmcnt(0)
	s_barrier
	buffer_gl0_inv
	ds_store_b128 v79, v[65:68]
	ds_store_b128 v79, v[144:147] offset:2560
	ds_store_b128 v79, v[148:151] offset:5120
	ds_store_b128 v79, v[152:155] offset:7680
	ds_store_b128 v164, v[156:159]
	ds_store_b128 v164, v[160:163] offset:2048
	s_waitcnt lgkmcnt(0)
	s_barrier
	buffer_gl0_inv
	s_cbranch_scc1 .LBB0_1
	v_bfe_u32 v65, v0, 5, 1
	ds_load_u16_d16 v81, v74 offset:1536
	v_lshlrev_b32_e32 v0, 6, v0
	s_load_b64 s[0:1], s[0:1], 0x30
	v_mad_u32_u24 v66, 0x500, v65, v75
	ds_load_u16_d16 v88, v74 offset:1344
	ds_load_u16_d16 v76, v74 offset:256
	ds_load_u16_d16 v77, v74 offset:512
	ds_load_u16_d16 v78, v74 offset:768
	ds_load_u16_d16 v79, v74 offset:1024
	ds_load_u16_d16 v80, v74 offset:1280
	ds_load_u16_d16 v75, v74
	ds_load_u16_d16 v83, v74 offset:64
	ds_load_b128 v[91:94], v66
	ds_load_b128 v[95:98], v66 offset:16
	ds_load_b128 v[99:102], v66 offset:32
	ds_load_b128 v[103:106], v66 offset:48
	ds_load_b128 v[107:110], v66 offset:2560
	ds_load_b128 v[111:114], v66 offset:2576
	ds_load_b128 v[115:118], v66 offset:5120
	ds_load_b128 v[119:122], v66 offset:5136
	s_waitcnt lgkmcnt(0)
	ds_load_u16_d16_hi v81, v74 offset:1664
	ds_load_u16_d16 v82, v74 offset:1792
	ds_load_u16_d16 v123, v74 offset:2048
	ds_load_u16_d16 v124, v74 offset:2304
	ds_load_u16_d16 v125, v74 offset:2560
	ds_load_u16_d16 v126, v74 offset:2816
	v_and_b32_e32 v0, 0x400, v0
	ds_load_u16_d16_hi v88, v74 offset:1472
	ds_load_u16_d16 v89, v74 offset:1600
	ds_load_u16_d16_hi v77, v74 offset:640
	ds_load_u16_d16_hi v78, v74 offset:896
	ds_load_u16_d16_hi v79, v74 offset:1152
	ds_load_u16_d16_hi v80, v74 offset:1408
	ds_load_u16_d16_hi v76, v74 offset:384
	ds_load_u16_d16 v85, v74 offset:576
	ds_load_u16_d16 v86, v74 offset:832
	ds_load_u16_d16 v87, v74 offset:1088
	ds_load_u16_d16_hi v75, v74 offset:128
	ds_load_u16_d16_hi v83, v74 offset:192
	ds_load_u16_d16 v84, v74 offset:320
	ds_load_u16_d16 v128, v74 offset:3328
	ds_load_u16_d16 v129, v74 offset:3584
	ds_load_u16_d16 v130, v74 offset:3840
	ds_load_u16_d16 v127, v74 offset:3072
	s_waitcnt lgkmcnt(21)
	ds_load_u16_d16_hi v82, v74 offset:1920
	ds_load_b128 v[131:134], v66 offset:7680
	ds_load_b128 v[135:138], v66 offset:7696
	ds_load_u16_d16 v139, v74 offset:2112
	ds_load_u16_d16 v140, v74 offset:2368
	ds_load_u16_d16 v141, v74 offset:2624
	ds_load_u16_d16 v142, v74 offset:2880
	s_waitcnt lgkmcnt(22)
	ds_load_u16_d16_hi v89, v74 offset:1728
	ds_load_u16_d16 v90, v74 offset:1856
	ds_load_b128 v[147:150], v66 offset:2592
	ds_load_b128 v[151:154], v66 offset:2608
	ds_load_b128 v[155:158], v66 offset:5152
	ds_load_b128 v[159:162], v66 offset:5168
	s_waitcnt lgkmcnt(20)
	ds_load_u16_d16_hi v87, v74 offset:1216
	ds_load_u16_d16_hi v86, v74 offset:960
	ds_load_u16_d16_hi v85, v74 offset:704
	s_waitcnt lgkmcnt(20)
	ds_load_u16_d16_hi v84, v74 offset:448
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v129, v74 offset:3712
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v130, v74 offset:3968
	s_waitcnt lgkmcnt(19)
	ds_load_u16_d16_hi v127, v74 offset:3200
	ds_load_u16_d16 v143, v74 offset:3136
	s_waitcnt lgkmcnt(20)
	v_wmma_f32_16x16x16_bf16 v[57:64], v[91:98], v[75:82], v[57:64]
	v_wmma_f32_16x16x16_bf16 v[49:56], v[107:114], v[75:82], v[49:56]
	v_wmma_f32_16x16x16_bf16 v[41:48], v[115:122], v[75:82], v[41:48]
	s_waitcnt lgkmcnt(18)
	v_wmma_f32_16x16x16_bf16 v[33:40], v[131:138], v[75:82], v[33:40]
	ds_load_u16_d16_hi v128, v74 offset:3456
	ds_load_u16_d16 v145, v74 offset:3648
	ds_load_u16_d16 v146, v74 offset:3904
	ds_load_u16_d16 v144, v74 offset:3392
	ds_load_u16_d16_hi v124, v74 offset:2432
	s_waitcnt lgkmcnt(17)
	ds_load_u16_d16_hi v90, v74 offset:1984
	ds_load_u16_d16_hi v125, v74 offset:2688
	ds_load_u16_d16_hi v126, v74 offset:2944
	ds_load_u16_d16_hi v123, v74 offset:2176
	ds_load_b128 v[75:78], v66 offset:7712
	ds_load_b128 v[79:82], v66 offset:7728
	ds_load_u16_d16_hi v142, v74 offset:3008
	s_waitcnt lgkmcnt(12)
	ds_load_u16_d16_hi v143, v74 offset:3264
	ds_load_u16_d16_hi v141, v74 offset:2752
	ds_load_u16_d16_hi v140, v74 offset:2496
	ds_load_u16_d16_hi v139, v74 offset:2240
	s_waitcnt lgkmcnt(13)
	ds_load_u16_d16_hi v146, v74 offset:4032
	ds_load_u16_d16_hi v145, v74 offset:3776
	s_waitcnt lgkmcnt(14)
	ds_load_u16_d16_hi v144, v74 offset:3520
	s_waitcnt lgkmcnt(13)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[91:98], v[83:90], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[107:114], v[83:90], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[115:122], v[83:90], v[9:16]
	s_waitcnt lgkmcnt(10)
	v_wmma_f32_16x16x16_bf16 v[57:64], v[99:106], v[123:130], v[57:64]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[131:138], v[83:90], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[49:56], v[147:154], v[123:130], v[49:56]
	v_wmma_f32_16x16x16_bf16 v[41:48], v[155:162], v[123:130], v[41:48]
	s_delay_alu instid0(VALU_DEP_4)
	v_bfe_u32 v66, v57, 16, 1
	v_or_b32_e32 v67, 0x400000, v57
	v_bfe_u32 v68, v58, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v57, v57
	v_or_b32_e32 v69, 0x400000, v58
	v_add3_u32 v66, v66, v57, 0x7fff
	v_bfe_u32 v70, v59, 16, 1
	v_add3_u32 v68, v68, v58, 0x7fff
	v_or_b32_e32 v71, 0x400000, v59
	v_bfe_u32 v74, v60, 16, 1
	v_cndmask_b32_e32 v66, v66, v67, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v58, v58
	v_add3_u32 v70, v70, v59, 0x7fff
	v_or_b32_e32 v83, 0x400000, v60
	v_bfe_u32 v84, v61, 16, 1
	v_add3_u32 v74, v74, v60, 0x7fff
	v_cndmask_b32_e32 v57, v68, v69, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v59, v59
	v_or_b32_e32 v68, 0x400000, v61
	v_add3_u32 v67, v84, v61, 0x7fff
	v_bfe_u32 v69, v62, 16, 1
	s_waitcnt lgkmcnt(8)
	v_wmma_f32_16x16x16_bf16 v[33:40], v[75:82], v[123:130], v[33:40]
	v_cndmask_b32_e32 v58, v70, v71, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v60, v60
	v_bfe_u32 v70, v63, 16, 1
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[99:106], v[139:146], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[147:154], v[139:146], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[155:162], v[139:146], v[9:16]
	v_cndmask_b32_e32 v59, v74, v83, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v61, v61
	v_add3_u32 v61, v69, v62, 0x7fff
	v_or_b32_e32 v69, 0x400000, v63
	v_wmma_f32_16x16x16_bf16 v[1:8], v[75:82], v[139:146], v[1:8]
	v_cndmask_b32_e32 v60, v67, v68, vcc_lo
	v_or_b32_e32 v67, 0x400000, v62
	v_cmp_u_f32_e32 vcc_lo, v62, v62
	v_add3_u32 v68, v70, v63, 0x7fff
	v_bfe_u32 v70, v64, 16, 1
	s_barrier
	buffer_gl0_inv
	v_cndmask_b32_e32 v61, v61, v67, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v63, v63
	v_bfe_u32 v67, v49, 16, 1
	v_add3_u32 v63, v70, v64, 0x7fff
	v_bfe_u32 v70, v50, 16, 1
	v_cndmask_b32_e32 v62, v68, v69, vcc_lo
	v_or_b32_e32 v68, 0x400000, v64
	v_cmp_u_f32_e32 vcc_lo, v64, v64
	v_add3_u32 v67, v67, v49, 0x7fff
	v_or_b32_e32 v69, 0x400000, v49
	v_bfe_u32 v64, v51, 16, 1
	v_cndmask_b32_e32 v63, v63, v68, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v49, v49
	v_or_b32_e32 v68, 0x400000, v50
	s_delay_alu instid0(VALU_DEP_4)
	v_add3_u32 v64, v64, v51, 0x7fff
	v_cndmask_b32_e32 v49, v67, v69, vcc_lo
	v_add3_u32 v67, v70, v50, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v50, v50
	v_or_b32_e32 v69, 0x400000, v51
	v_bfe_u32 v70, v52, 16, 1
	s_delay_alu instid0(VALU_DEP_4)
	v_cndmask_b32_e32 v50, v67, v68, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v51, v51
	v_bfe_u32 v67, v53, 16, 1
	v_or_b32_e32 v68, 0x400000, v52
	v_cndmask_b32_e32 v51, v64, v69, vcc_lo
	v_add3_u32 v64, v70, v52, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v52, v52
	v_add3_u32 v67, v67, v53, 0x7fff
	v_or_b32_e32 v69, 0x400000, v53
	v_bfe_u32 v70, v54, 16, 1
	v_cndmask_b32_e32 v52, v64, v68, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v53, v53
	v_bfe_u32 v64, v55, 16, 1
	v_or_b32_e32 v68, 0x400000, v54
	v_cndmask_b32_e32 v53, v67, v69, vcc_lo
	v_add3_u32 v67, v70, v54, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v54, v54
	v_add3_u32 v64, v64, v55, 0x7fff
	v_or_b32_e32 v69, 0x400000, v55
	v_bfe_u32 v70, v56, 16, 1
	v_cndmask_b32_e32 v54, v67, v68, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v55, v55
	v_bfe_u32 v67, v41, 16, 1
	v_or_b32_e32 v68, 0x400000, v56
	v_cndmask_b32_e32 v55, v64, v69, vcc_lo
	v_add3_u32 v64, v70, v56, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v56, v56
	v_add3_u32 v67, v67, v41, 0x7fff
	v_or_b32_e32 v69, 0x400000, v41
	v_bfe_u32 v70, v42, 16, 1
	v_cndmask_b32_e32 v56, v64, v68, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v41, v41
	v_bfe_u32 v64, v43, 16, 1
	v_or_b32_e32 v68, 0x400000, v42
	v_cndmask_b32_e32 v41, v67, v69, vcc_lo
	v_add3_u32 v67, v70, v42, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v42, v42
	v_add3_u32 v64, v64, v43, 0x7fff
	v_or_b32_e32 v69, 0x400000, v43
	v_bfe_u32 v70, v44, 16, 1
	v_cndmask_b32_e32 v42, v67, v68, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v43, v43
	v_bfe_u32 v67, v45, 16, 1
	v_or_b32_e32 v68, 0x400000, v44
	v_cndmask_b32_e32 v43, v64, v69, vcc_lo
	v_add3_u32 v64, v70, v44, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v44, v44
	v_add3_u32 v67, v67, v45, 0x7fff
	v_or_b32_e32 v69, 0x400000, v45
	v_bfe_u32 v70, v46, 16, 1
	v_cndmask_b32_e32 v44, v64, v68, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v45, v45
	v_bfe_u32 v64, v47, 16, 1
	v_or_b32_e32 v68, 0x400000, v46
	v_cndmask_b32_e32 v45, v67, v69, vcc_lo
	v_add3_u32 v67, v70, v46, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v46, v46
	v_add3_u32 v64, v64, v47, 0x7fff
	v_or_b32_e32 v69, 0x400000, v47
	v_bfe_u32 v70, v48, 16, 1
	v_cndmask_b32_e32 v46, v67, v68, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v47, v47
	v_bfe_u32 v67, v33, 16, 1
	v_or_b32_e32 v68, 0x400000, v48
	v_cndmask_b32_e32 v47, v64, v69, vcc_lo
	v_add3_u32 v64, v70, v48, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v48, v48
	v_add3_u32 v67, v67, v33, 0x7fff
	v_or_b32_e32 v69, 0x400000, v33
	v_bfe_u32 v70, v34, 16, 1
	v_cndmask_b32_e32 v48, v64, v68, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v33, v33
	v_bfe_u32 v64, v35, 16, 1
	v_or_b32_e32 v68, 0x400000, v34
	v_cndmask_b32_e32 v33, v67, v69, vcc_lo
	v_add3_u32 v67, v70, v34, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v34, v34
	v_add3_u32 v64, v64, v35, 0x7fff
	v_or_b32_e32 v69, 0x400000, v35
	v_bfe_u32 v70, v36, 16, 1
	v_cndmask_b32_e32 v34, v67, v68, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v35, v35
	v_bfe_u32 v67, v37, 16, 1
	v_or_b32_e32 v68, 0x400000, v36
	v_cndmask_b32_e32 v35, v64, v69, vcc_lo
	v_add3_u32 v64, v70, v36, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v36, v36
	v_add3_u32 v67, v67, v37, 0x7fff
	v_or_b32_e32 v69, 0x400000, v37
	v_bfe_u32 v70, v38, 16, 1
	v_cndmask_b32_e32 v36, v64, v68, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v37, v37
	v_bfe_u32 v64, v39, 16, 1
	v_or_b32_e32 v68, 0x400000, v38
	v_cndmask_b32_e32 v37, v67, v69, vcc_lo
	v_add3_u32 v67, v70, v38, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v38, v38
	v_add3_u32 v64, v64, v39, 0x7fff
	v_or_b32_e32 v69, 0x400000, v39
	v_bfe_u32 v70, v40, 16, 1
	v_cndmask_b32_e32 v38, v67, v68, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v39, v39
	v_bfe_u32 v67, v25, 16, 1
	v_or_b32_e32 v68, 0x400000, v40
	v_cndmask_b32_e32 v39, v64, v69, vcc_lo
	v_add3_u32 v64, v70, v40, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v40, v40
	v_add3_u32 v67, v67, v25, 0x7fff
	v_or_b32_e32 v69, 0x400000, v25
	v_bfe_u32 v70, v26, 16, 1
	v_cndmask_b32_e32 v40, v64, v68, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v25, v25
	v_bfe_u32 v64, v27, 16, 1
	s_delay_alu instid0(VALU_DEP_4)
	v_add3_u32 v25, v70, v26, 0x7fff
	v_or_b32_e32 v68, 0x400000, v27
	v_cndmask_b32_e32 v95, v67, v69, vcc_lo
	v_or_b32_e32 v67, 0x400000, v26
	v_cmp_u_f32_e32 vcc_lo, v26, v26
	v_add3_u32 v64, v64, v27, 0x7fff
	v_bfe_u32 v69, v28, 16, 1
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_2) | instid1(VALU_DEP_4)
	v_cndmask_b32_e32 v96, v25, v67, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v27, v27
	v_bfe_u32 v25, v29, 16, 1
	v_add3_u32 v26, v69, v28, 0x7fff
	v_or_b32_e32 v27, 0x400000, v28
	v_bfe_u32 v67, v30, 16, 1
	v_cndmask_b32_e32 v97, v64, v68, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v28, v28
	v_add3_u32 v25, v25, v29, 0x7fff
	v_or_b32_e32 v64, 0x400000, v29
	v_or_b32_e32 v28, 0x400000, v31
	v_cndmask_b32_e32 v98, v26, v27, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v29, v29
	v_bfe_u32 v26, v31, 16, 1
	v_or_b32_e32 v27, 0x400000, v30
	v_bfe_u32 v29, v32, 16, 1
	v_cndmask_b32_e32 v99, v25, v64, vcc_lo
	v_add3_u32 v25, v67, v30, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v30, v30
	v_add3_u32 v26, v26, v31, 0x7fff
	s_delay_alu instid0(VALU_DEP_3)
	v_cndmask_b32_e32 v100, v25, v27, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v31, v31
	v_bfe_u32 v25, v17, 16, 1
	v_or_b32_e32 v27, 0x400000, v32
	v_cndmask_b32_e32 v101, v26, v28, vcc_lo
	v_add3_u32 v26, v29, v32, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v32, v32
	v_add3_u32 v25, v25, v17, 0x7fff
	v_or_b32_e32 v28, 0x400000, v17
	v_bfe_u32 v29, v18, 16, 1
	v_cndmask_b32_e32 v32, v26, v27, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v17, v17
	v_bfe_u32 v26, v19, 16, 1
	s_delay_alu instid0(VALU_DEP_4)
	v_add3_u32 v17, v29, v18, 0x7fff
	v_or_b32_e32 v27, 0x400000, v19
	v_cndmask_b32_e32 v102, v25, v28, vcc_lo
	v_or_b32_e32 v25, 0x400000, v18
	v_cmp_u_f32_e32 vcc_lo, v18, v18
	v_add3_u32 v26, v26, v19, 0x7fff
	v_bfe_u32 v28, v20, 16, 1
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_2) | instid1(VALU_DEP_4)
	v_cndmask_b32_e32 v103, v17, v25, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v19, v19
	v_bfe_u32 v17, v21, 16, 1
	v_add3_u32 v18, v28, v20, 0x7fff
	v_or_b32_e32 v19, 0x400000, v20
	v_or_b32_e32 v25, 0x400000, v21
	v_cndmask_b32_e32 v104, v26, v27, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v20, v20
	v_add3_u32 v17, v17, v21, 0x7fff
	v_bfe_u32 v26, v22, 16, 1
	v_or_b32_e32 v20, 0x400000, v23
	v_cndmask_b32_e32 v105, v18, v19, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v21, v21
	v_bfe_u32 v18, v23, 16, 1
	v_or_b32_e32 v19, 0x400000, v22
	v_bfe_u32 v21, v24, 16, 1
	v_cndmask_b32_e32 v106, v17, v25, vcc_lo
	v_add3_u32 v17, v26, v22, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v22, v22
	v_add3_u32 v18, v18, v23, 0x7fff
	s_delay_alu instid0(VALU_DEP_3)
	v_cndmask_b32_e32 v107, v17, v19, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v23, v23
	v_bfe_u32 v17, v9, 16, 1
	v_or_b32_e32 v19, 0x400000, v24
	v_cndmask_b32_e32 v108, v18, v20, vcc_lo
	v_add3_u32 v18, v21, v24, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v24, v24
	v_add3_u32 v17, v17, v9, 0x7fff
	v_or_b32_e32 v20, 0x400000, v9
	v_bfe_u32 v21, v10, 16, 1
	v_cndmask_b32_e32 v109, v18, v19, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_bfe_u32 v18, v11, 16, 1
	s_delay_alu instid0(VALU_DEP_4)
	v_add3_u32 v9, v21, v10, 0x7fff
	v_or_b32_e32 v19, 0x400000, v11
	v_cndmask_b32_e32 v110, v17, v20, vcc_lo
	v_or_b32_e32 v17, 0x400000, v10
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_add3_u32 v18, v18, v11, 0x7fff
	v_bfe_u32 v20, v12, 16, 1
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_2) | instid1(VALU_DEP_4)
	v_cndmask_b32_e32 v111, v9, v17, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_bfe_u32 v9, v13, 16, 1
	v_add3_u32 v10, v20, v12, 0x7fff
	v_or_b32_e32 v11, 0x400000, v12
	v_or_b32_e32 v17, 0x400000, v13
	v_cndmask_b32_e32 v112, v18, v19, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_add3_u32 v9, v9, v13, 0x7fff
	v_bfe_u32 v18, v14, 16, 1
	v_or_b32_e32 v12, 0x400000, v15
	v_cndmask_b32_e32 v113, v10, v11, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_bfe_u32 v10, v15, 16, 1
	v_or_b32_e32 v11, 0x400000, v14
	v_bfe_u32 v13, v16, 16, 1
	v_cndmask_b32_e32 v114, v9, v17, vcc_lo
	v_add3_u32 v9, v18, v14, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_add3_u32 v10, v10, v15, 0x7fff
	s_delay_alu instid0(VALU_DEP_3)
	v_cndmask_b32_e32 v115, v9, v11, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_bfe_u32 v9, v1, 16, 1
	v_or_b32_e32 v11, 0x400000, v16
	v_cndmask_b32_e32 v116, v10, v12, vcc_lo
	v_add3_u32 v10, v13, v16, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	v_bfe_u32 v12, v2, 16, 1
	v_add3_u32 v9, v9, v1, 0x7fff
	v_or_b32_e32 v13, 0x400000, v1
	v_cndmask_b32_e32 v117, v10, v11, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	v_add3_u32 v10, v12, v2, 0x7fff
	v_or_b32_e32 v11, 0x400000, v2
	v_bfe_u32 v1, v3, 16, 1
	v_bfe_u32 v12, v5, 16, 1
	v_cndmask_b32_e32 v118, v9, v13, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_bfe_u32 v9, v4, 16, 1
	v_add3_u32 v1, v1, v3, 0x7fff
	v_cndmask_b32_e32 v119, v10, v11, vcc_lo
	v_or_b32_e32 v10, 0x400000, v3
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_add3_u32 v9, v9, v4, 0x7fff
	v_or_b32_e32 v11, 0x400000, v4
	v_bfe_u32 v3, v6, 16, 1
	v_cndmask_b32_e32 v120, v1, v10, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_lshlrev_b32_e32 v2, 14, v65
	v_add3_u32 v1, v12, v5, 0x7fff
	v_bfe_u32 v4, v7, 16, 1
	v_cndmask_b32_e32 v121, v9, v11, vcc_lo
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_4)
	v_add3_u32 v2, s3, s2, v2
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_add3_u32 v4, v4, v7, 0x7fff
	v_bfe_u32 v9, v8, 16, 1
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_or_b32_e32 v2, v2, v72
	v_add_nc_u32_e32 v0, v2, v0
	v_or_b32_e32 v2, 0x400000, v5
	v_or_b32_e32 v5, 0x400000, v7
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_or_b32_e32 v0, v0, v73
	v_cndmask_b32_e32 v122, v1, v2, vcc_lo
	v_add3_u32 v2, v3, v6, 0x7fff
	v_or_b32_e32 v3, 0x400000, v6
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_ashrrev_i32_e32 v1, 31, v0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_cndmask_b32_e32 v123, v2, v3, vcc_lo
	v_lshlrev_b64 v[0:1], 1, v[0:1]
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_add3_u32 v2, v9, v8, 0x7fff
	v_or_b32_e32 v3, 0x400000, v8
	v_cndmask_b32_e32 v124, v4, v5, vcc_lo
	v_add_co_u32 v0, vcc_lo, s0, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_4)
	v_add_co_ci_u32_e64 v1, null, s1, v1, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_cndmask_b32_e32 v125, v2, v3, vcc_lo
	v_add_co_u32 v2, vcc_lo, 0x1000, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v3, null, 0, v1, vcc_lo
	v_add_co_u32 v4, vcc_lo, v0, 0x2000
	v_add_co_ci_u32_e64 v5, null, 0, v1, vcc_lo
	v_add_co_u32 v6, vcc_lo, 0x2000, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v7, null, 0, v1, vcc_lo
	v_add_co_u32 v8, vcc_lo, 0x3000, v0
	v_add_co_ci_u32_e64 v9, null, 0, v1, vcc_lo
	v_add_co_u32 v10, vcc_lo, v0, 0x4000
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v11, null, 0, v1, vcc_lo
	v_add_co_u32 v12, vcc_lo, 0x4000, v0
	v_add_co_ci_u32_e64 v13, null, 0, v1, vcc_lo
	v_add_co_u32 v14, vcc_lo, 0x5000, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v15, null, 0, v1, vcc_lo
	v_add_co_u32 v16, vcc_lo, v0, 0x6000
	v_add_co_ci_u32_e64 v17, null, 0, v1, vcc_lo
	v_add_co_u32 v18, vcc_lo, 0x6000, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v19, null, 0, v1, vcc_lo
	v_add_co_u32 v20, vcc_lo, 0x7000, v0
	v_add_co_ci_u32_e64 v21, null, 0, v1, vcc_lo
	v_add_co_u32 v22, vcc_lo, 0x10000, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v23, null, 0, v1, vcc_lo
	v_add_co_u32 v24, vcc_lo, v0, 0x11000
	v_add_co_ci_u32_e64 v25, null, 0, v1, vcc_lo
	v_add_co_u32 v26, vcc_lo, 0x11000, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v27, null, 0, v1, vcc_lo
	v_add_co_u32 v28, vcc_lo, 0x12000, v0
	v_add_co_ci_u32_e64 v29, null, 0, v1, vcc_lo
	v_add_co_u32 v30, vcc_lo, v0, 0x13000
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v31, null, 0, v1, vcc_lo
	v_add_co_u32 v64, vcc_lo, 0x13000, v0
	v_add_co_ci_u32_e64 v65, null, 0, v1, vcc_lo
	v_add_co_u32 v67, vcc_lo, 0x14000, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v68, null, 0, v1, vcc_lo
	v_add_co_u32 v69, vcc_lo, v0, 0x15000
	v_add_co_ci_u32_e64 v70, null, 0, v1, vcc_lo
	v_add_co_u32 v71, vcc_lo, 0x15000, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v72, null, 0, v1, vcc_lo
	v_add_co_u32 v73, vcc_lo, 0x16000, v0
	v_add_co_ci_u32_e64 v74, null, 0, v1, vcc_lo
	v_add_co_u32 v75, vcc_lo, v0, 0x17000
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v76, null, 0, v1, vcc_lo
	v_add_co_u32 v77, vcc_lo, 0x17000, v0
	v_add_co_ci_u32_e64 v78, null, 0, v1, vcc_lo
	s_clause 0x7
	global_store_d16_hi_b16 v[24:25], v49, off offset:-4096
	global_store_d16_hi_b16 v[24:25], v50, off
	global_store_d16_hi_b16 v[30:31], v51, off offset:-4096
	global_store_d16_hi_b16 v[30:31], v52, off
	global_store_d16_hi_b16 v[69:70], v53, off offset:-4096
	global_store_d16_hi_b16 v[69:70], v54, off
	global_store_d16_hi_b16 v[75:76], v55, off offset:-4096
	global_store_d16_hi_b16 v[75:76], v56, off
	v_add_co_u32 v24, vcc_lo, 0x20000, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v25, null, 0, v1, vcc_lo
	v_add_co_u32 v30, vcc_lo, v0, 0x21000
	v_add_co_ci_u32_e64 v31, null, 0, v1, vcc_lo
	v_add_co_u32 v49, vcc_lo, 0x21000, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v50, null, 0, v1, vcc_lo
	v_add_co_u32 v51, vcc_lo, 0x22000, v0
	v_add_co_ci_u32_e64 v52, null, 0, v1, vcc_lo
	v_add_co_u32 v53, vcc_lo, v0, 0x23000
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v54, null, 0, v1, vcc_lo
	v_add_co_u32 v55, vcc_lo, 0x23000, v0
	v_add_co_ci_u32_e64 v56, null, 0, v1, vcc_lo
	v_add_co_u32 v69, vcc_lo, 0x24000, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v70, null, 0, v1, vcc_lo
	v_add_co_u32 v75, vcc_lo, v0, 0x25000
	v_add_co_ci_u32_e64 v76, null, 0, v1, vcc_lo
	v_add_co_u32 v79, vcc_lo, 0x25000, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v80, null, 0, v1, vcc_lo
	v_add_co_u32 v81, vcc_lo, 0x26000, v0
	v_add_co_ci_u32_e64 v82, null, 0, v1, vcc_lo
	v_add_co_u32 v83, vcc_lo, v0, 0x27000
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v84, null, 0, v1, vcc_lo
	v_add_co_u32 v85, vcc_lo, 0x27000, v0
	v_add_co_ci_u32_e64 v86, null, 0, v1, vcc_lo
	s_clause 0x7
	global_store_d16_hi_b16 v[30:31], v41, off offset:-4096
	global_store_d16_hi_b16 v[30:31], v42, off
	global_store_d16_hi_b16 v[53:54], v43, off offset:-4096
	global_store_d16_hi_b16 v[53:54], v44, off
	global_store_d16_hi_b16 v[75:76], v45, off offset:-4096
	global_store_d16_hi_b16 v[75:76], v46, off
	global_store_d16_hi_b16 v[83:84], v47, off offset:-4096
	global_store_d16_hi_b16 v[83:84], v48, off
	v_add_co_u32 v30, vcc_lo, 0x30000, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v31, null, 0, v1, vcc_lo
	v_add_co_u32 v41, vcc_lo, v0, 0x31000
	v_add_co_ci_u32_e64 v42, null, 0, v1, vcc_lo
	v_add_co_u32 v43, vcc_lo, 0x31000, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v44, null, 0, v1, vcc_lo
	v_add_co_u32 v45, vcc_lo, 0x32000, v0
	v_add_co_ci_u32_e64 v46, null, 0, v1, vcc_lo
	v_add_co_u32 v47, vcc_lo, v0, 0x33000
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v48, null, 0, v1, vcc_lo
	v_add_co_u32 v53, vcc_lo, 0x33000, v0
	v_add_co_ci_u32_e64 v54, null, 0, v1, vcc_lo
	v_add_co_u32 v75, vcc_lo, 0x34000, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v76, null, 0, v1, vcc_lo
	v_add_co_u32 v83, vcc_lo, v0, 0x35000
	v_add_co_ci_u32_e64 v84, null, 0, v1, vcc_lo
	v_add_co_u32 v87, vcc_lo, 0x35000, v0
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v88, null, 0, v1, vcc_lo
	v_add_co_u32 v89, vcc_lo, 0x36000, v0
	v_add_co_ci_u32_e64 v90, null, 0, v1, vcc_lo
	v_add_co_u32 v91, vcc_lo, v0, 0x37000
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v92, null, 0, v1, vcc_lo
	v_add_co_u32 v93, vcc_lo, 0x37000, v0
	v_add_co_ci_u32_e64 v94, null, 0, v1, vcc_lo
	s_clause 0x1f
	global_store_d16_hi_b16 v[41:42], v33, off offset:-4096
	global_store_d16_hi_b16 v[41:42], v34, off
	global_store_d16_hi_b16 v[47:48], v35, off offset:-4096
	global_store_d16_hi_b16 v[47:48], v36, off
	global_store_d16_hi_b16 v[83:84], v37, off offset:-4096
	global_store_d16_hi_b16 v[83:84], v38, off
	global_store_d16_hi_b16 v[91:92], v39, off offset:-4096
	global_store_d16_hi_b16 v[91:92], v40, off
	global_store_d16_hi_b16 v[0:1], v66, off
	global_store_d16_hi_b16 v[0:1], v95, off offset:64
	global_store_d16_hi_b16 v[2:3], v96, off offset:64
	global_store_d16_hi_b16 v[6:7], v97, off offset:64
	global_store_d16_hi_b16 v[8:9], v98, off offset:64
	global_store_d16_hi_b16 v[12:13], v99, off offset:64
	global_store_d16_hi_b16 v[14:15], v100, off offset:64
	global_store_d16_hi_b16 v[18:19], v101, off offset:64
	global_store_d16_hi_b16 v[20:21], v63, off
	global_store_d16_hi_b16 v[20:21], v32, off offset:64
	global_store_d16_hi_b16 v[22:23], v102, off offset:64
	global_store_d16_hi_b16 v[26:27], v103, off offset:64
	global_store_d16_hi_b16 v[28:29], v104, off offset:64
	global_store_d16_hi_b16 v[64:65], v105, off offset:64
	global_store_d16_hi_b16 v[67:68], v106, off offset:64
	global_store_d16_hi_b16 v[71:72], v107, off offset:64
	global_store_d16_hi_b16 v[73:74], v108, off offset:64
	global_store_d16_hi_b16 v[77:78], v109, off offset:64
	global_store_d16_hi_b16 v[24:25], v110, off offset:64
	global_store_d16_hi_b16 v[49:50], v111, off offset:64
	global_store_d16_hi_b16 v[51:52], v112, off offset:64
	global_store_d16_hi_b16 v[55:56], v113, off offset:64
	global_store_d16_hi_b16 v[69:70], v114, off offset:64
	global_store_d16_hi_b16 v[79:80], v115, off offset:64
	s_clause 0xf
	global_store_d16_hi_b16 v[81:82], v116, off offset:64
	global_store_d16_hi_b16 v[85:86], v117, off offset:64
	global_store_d16_hi_b16 v[30:31], v118, off offset:64
	global_store_d16_hi_b16 v[43:44], v119, off offset:64
	global_store_d16_hi_b16 v[45:46], v120, off offset:64
	global_store_d16_hi_b16 v[53:54], v121, off offset:64
	global_store_d16_hi_b16 v[75:76], v122, off offset:64
	global_store_d16_hi_b16 v[87:88], v123, off offset:64
	global_store_d16_hi_b16 v[89:90], v124, off offset:64
	global_store_d16_hi_b16 v[4:5], v57, off offset:-4096
	global_store_d16_hi_b16 v[4:5], v58, off
	global_store_d16_hi_b16 v[10:11], v59, off offset:-4096
	global_store_d16_hi_b16 v[10:11], v60, off
	global_store_d16_hi_b16 v[16:17], v61, off offset:-4096
	global_store_d16_hi_b16 v[16:17], v62, off
	global_store_d16_hi_b16 v[93:94], v125, off offset:64
	s_nop 0
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
	s_endpgm
.Lfunc_end0:
	.size	exercise_kernel_0, .Lfunc_end0-exercise_kernel_0
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel exercise_kernel_0
		.amdhsa_group_segment_fixed_size 14336
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
		.amdhsa_next_free_vgpr 165
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

	.set .Lexercise_kernel_0.num_vgpr, 165
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
    .group_segment_fixed_size: 14336
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
    .vgpr_count:     165
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
