	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	exercise_kernel_0
	.p2align	8
	.type	exercise_kernel_0,@function
exercise_kernel_0:
	s_ashr_i32 s17, s2, 31
	v_lshlrev_b32_e32 v1, 3, v0
	s_lshr_b32 s3, s17, 30
	s_clause 0x1
	s_load_b64 s[8:9], s[0:1], 0x0
	s_load_b64 s[4:5], s[0:1], 0x18
	s_add_i32 s3, s2, s3
	v_and_b32_e32 v161, 15, v0
	s_ashr_i32 s7, s3, 31
	s_ashr_i32 s14, s3, 2
	s_lshr_b32 s7, s7, 28
	v_lshrrev_b32_e32 v81, 3, v0
	s_and_b32 s12, s3, -4
	s_add_i32 s3, s14, s7
	v_and_b32_e32 v83, 56, v1
	v_lshlrev_b32_e32 v82, 14, v161
	s_and_b32 s3, s3, -16
	s_sub_i32 s18, s2, s12
	s_sub_i32 s3, s14, s3
	v_lshl_or_b32 v113, v81, 10, v83
	s_lshl_b32 s16, s3, 6
	s_lshl_b32 s12, s18, 21
	v_lshl_add_u32 v129, s18, 12, v82
	s_add_i32 s12, s12, s16
	s_mov_b32 s11, 0x21027000
	v_add_lshl_u32 v1, s12, v113, 1
	s_mov_b32 s10, -1
	v_add_nc_u32_e32 v130, 0x40000, v129
	s_waitcnt lgkmcnt(0)
	s_and_b32 s9, s9, 0xffff
	s_mov_b32 s6, s10
	v_add_nc_u32_e32 v2, 0x4000, v1
	v_add_nc_u32_e32 v3, 0x8000, v1
	s_and_b32 s5, s5, 0xffff
	s_mov_b32 s7, s11
	v_add_nc_u32_e32 v4, 0xc000, v1
	s_clause 0x1
	buffer_load_b128 v[65:68], v130, s[8:11], 0 offen
	buffer_load_b128 v[69:72], v130, s[8:11], 0 offen offset:16
	s_clause 0x3
	buffer_load_b128 v[33:36], v1, s[4:7], 0 offen slc
	buffer_load_b128 v[37:40], v2, s[4:7], 0 offen slc
	buffer_load_b128 v[41:44], v3, s[4:7], 0 offen slc
	buffer_load_b128 v[45:48], v4, s[4:7], 0 offen slc
	s_clause 0x5
	buffer_load_b128 v[57:60], v130, s[8:11], 0 offen offset:32
	buffer_load_b128 v[61:64], v130, s[8:11], 0 offen offset:48
	buffer_load_b128 v[73:76], v129, s[8:11], 0 offen
	buffer_load_b128 v[77:80], v129, s[8:11], 0 offen offset:16
	buffer_load_b128 v[49:52], v129, s[8:11], 0 offen offset:32
	buffer_load_b128 v[53:56], v129, s[8:11], 0 offen offset:48
	v_dual_mov_b32 v1, 0 :: v_dual_lshlrev_b32 v86, 11, v81
	s_lshl_b32 s6, s2, 22
	s_lshl_b32 s7, s3, 7
	v_lshrrev_b32_e32 v84, 1, v0
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_4)
	v_mov_b32_e32 v9, v1
	v_dual_mov_b32 v8, v1 :: v_dual_and_b32 v85, 7, v0
	v_add3_u32 v86, s7, s6, v86
	v_dual_mov_b32 v11, v1 :: v_dual_and_b32 v162, 16, v84
	v_dual_mov_b32 v13, v1 :: v_dual_lshlrev_b32 v114, 7, v81
	s_delay_alu instid0(VALU_DEP_3)
	v_lshl_or_b32 v81, v85, 4, v86
	s_lshl_b32 s6, s14, 24
	v_mov_b32_e32 v2, v1
	v_mov_b32_e32 v4, v1
	v_dual_mov_b32 v10, v1 :: v_dual_lshlrev_b32 v115, 1, v83
	v_or_b32_e32 v83, v161, v162
	v_lshl_add_u32 v82, s2, 12, v82
	v_subrev_nc_u32_e32 v81, s6, v81
	s_lshl_b32 s7, s14, 14
	v_mov_b32_e32 v3, v1
	v_mov_b32_e32 v5, v1
	v_mov_b32_e32 v6, v1
	v_mov_b32_e32 v7, v1
	v_dual_mov_b32 v12, v1 :: v_dual_lshlrev_b32 v163, 1, v83
	v_dual_mov_b32 v14, v1 :: v_dual_add_nc_u32 v117, 0x8c000, v81
	v_mov_b32_e32 v15, v1
	v_mov_b32_e32 v16, v1
	v_mov_b32_e32 v17, v1
	v_mov_b32_e32 v18, v1
	v_mov_b32_e32 v19, v1
	v_mov_b32_e32 v20, v1
	v_mov_b32_e32 v21, v1
	v_mov_b32_e32 v22, v1
	v_mov_b32_e32 v23, v1
	v_mov_b32_e32 v24, v1
	v_mov_b32_e32 v25, v1
	v_mov_b32_e32 v26, v1
	v_mov_b32_e32 v27, v1
	v_mov_b32_e32 v28, v1
	v_mov_b32_e32 v29, v1
	v_mov_b32_e32 v30, v1
	v_mov_b32_e32 v31, v1
	v_mov_b32_e32 v32, v1
	v_or_b32_e32 v84, v115, v114
	v_subrev_nc_u32_e32 v116, s7, v82
	s_mov_b32 s13, 0
	s_mov_b32 s6, s10
	s_mov_b32 s7, s11
	s_waitcnt vmcnt(9)
	ds_store_b128 v84, v[33:36]
	s_waitcnt vmcnt(8)
	ds_store_b128 v84, v[37:40] offset:1024
	s_waitcnt vmcnt(7)
	ds_store_b128 v84, v[41:44] offset:2048
	s_waitcnt vmcnt(6)
	ds_store_b128 v84, v[45:48] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
.LBB0_1:
	v_add_nc_u32_e32 v118, s13, v116
	v_add_nc_u32_e32 v33, 0xfff84000, v117
	v_add_nc_u32_e32 v34, 0xfff88000, v117
	v_add_nc_u32_e32 v35, 0xfff8c000, v117
	v_add_nc_u32_e32 v36, 0xfff90000, v117
	v_add_nc_u32_e32 v119, 0x40000, v118
	s_clause 0x3
	buffer_load_b128 v[97:100], v33, s[4:7], 0 offen slc
	buffer_load_b128 v[101:104], v34, s[4:7], 0 offen slc
	buffer_load_b128 v[105:108], v35, s[4:7], 0 offen slc
	buffer_load_b128 v[109:112], v36, s[4:7], 0 offen slc
	s_clause 0x7
	buffer_load_b128 v[81:84], v118, s[8:11], 0 offen offset:64
	buffer_load_b128 v[85:88], v118, s[8:11], 0 offen offset:80
	buffer_load_b128 v[41:44], v118, s[8:11], 0 offen offset:96
	buffer_load_b128 v[45:48], v118, s[8:11], 0 offen offset:112
	buffer_load_b128 v[131:134], v119, s[8:11], 0 offen offset:64
	buffer_load_b128 v[135:138], v119, s[8:11], 0 offen offset:80
	buffer_load_b128 v[33:36], v119, s[8:11], 0 offen offset:96
	buffer_load_b128 v[37:40], v119, s[8:11], 0 offen offset:112
	ds_load_u16_d16 v89, v163
	ds_load_u16_d16_hi v89, v163 offset:128
	ds_load_u16_d16 v90, v163 offset:256
	ds_load_u16_d16_hi v90, v163 offset:384
	ds_load_u16_d16_hi v140, v163 offset:448
	ds_load_u16_d16 v140, v163 offset:320
	ds_load_u16_d16_hi v139, v163 offset:192
	ds_load_u16_d16 v139, v163 offset:64
	ds_load_u16_d16 v91, v163 offset:512
	ds_load_u16_d16_hi v91, v163 offset:640
	ds_load_u16_d16 v92, v163 offset:768
	ds_load_u16_d16_hi v92, v163 offset:896
	ds_load_u16_d16_hi v142, v163 offset:960
	ds_load_u16_d16 v142, v163 offset:832
	ds_load_u16_d16_hi v141, v163 offset:704
	ds_load_u16_d16 v141, v163 offset:576
	ds_load_u16_d16 v93, v163 offset:1024
	ds_load_u16_d16_hi v93, v163 offset:1152
	ds_load_u16_d16 v94, v163 offset:1280
	ds_load_u16_d16_hi v94, v163 offset:1408
	ds_load_u16_d16_hi v144, v163 offset:1472
	ds_load_u16_d16 v144, v163 offset:1344
	ds_load_u16_d16_hi v143, v163 offset:1216
	ds_load_u16_d16 v143, v163 offset:1088
	ds_load_u16_d16 v95, v163 offset:1536
	ds_load_u16_d16_hi v95, v163 offset:1664
	ds_load_u16_d16 v96, v163 offset:1792
	ds_load_u16_d16_hi v96, v163 offset:1920
	ds_load_u16_d16_hi v146, v163 offset:1984
	ds_load_u16_d16 v146, v163 offset:1856
	ds_load_u16_d16_hi v145, v163 offset:1728
	ds_load_u16_d16 v145, v163 offset:1600
	v_add_nc_u32_e32 v164, v115, v114
	v_add_nc_u32_e32 v120, 0xfff94000, v117
	v_add_nc_u32_e32 v121, 0xfff98000, v117
	v_add_nc_u32_e32 v122, 0xfff9c000, v117
	v_add_nc_u32_e32 v123, 0xfffa0000, v117
	v_add_nc_u32_e32 v128, 0xfffb4000, v117
	s_addk_i32 s13, 0x200
	s_delay_alu instid0(SALU_CYCLE_1)
	s_cmpk_lg_i32 s13, 0xe00
	s_waitcnt vmcnt(14) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[73:80], v[89:96], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[65:72], v[89:96], v[17:24]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[73:80], v[139:146], v[9:16]
	ds_load_u16_d16_hi v90, v163 offset:2496
	ds_load_u16_d16 v90, v163 offset:2368
	ds_load_u16_d16_hi v89, v163 offset:2240
	ds_load_u16_d16 v89, v163 offset:2112
	ds_load_u16_d16 v75, v163 offset:2560
	ds_load_u16_d16_hi v75, v163 offset:2688
	ds_load_u16_d16 v76, v163 offset:2816
	ds_load_u16_d16_hi v76, v163 offset:2944
	ds_load_u16_d16_hi v92, v163 offset:3008
	ds_load_u16_d16 v92, v163 offset:2880
	ds_load_u16_d16_hi v91, v163 offset:2752
	ds_load_u16_d16 v91, v163 offset:2624
	ds_load_u16_d16 v77, v163 offset:3072
	ds_load_u16_d16_hi v77, v163 offset:3200
	ds_load_u16_d16 v78, v163 offset:3328
	ds_load_u16_d16_hi v78, v163 offset:3456
	ds_load_u16_d16_hi v94, v163 offset:3520
	ds_load_u16_d16 v94, v163 offset:3392
	ds_load_u16_d16_hi v93, v163 offset:3264
	ds_load_u16_d16 v93, v163 offset:3136
	ds_load_u16_d16 v79, v163 offset:3584
	ds_load_u16_d16_hi v79, v163 offset:3712
	ds_load_u16_d16 v80, v163 offset:3840
	ds_load_u16_d16_hi v80, v163 offset:3968
	ds_load_u16_d16_hi v96, v163 offset:4032
	ds_load_u16_d16 v96, v163 offset:3904
	ds_load_u16_d16_hi v95, v163 offset:3776
	ds_load_u16_d16 v95, v163 offset:3648
	ds_load_u16_d16 v73, v163 offset:2048
	ds_load_u16_d16_hi v73, v163 offset:2176
	ds_load_u16_d16 v74, v163 offset:2304
	ds_load_u16_d16_hi v74, v163 offset:2432
	v_wmma_f32_16x16x16_bf16 v[25:32], v[65:72], v[139:146], v[25:32]
	s_waitcnt vmcnt(12) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[49:56], v[89:96], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[49:56], v[73:80], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[57:64], v[73:80], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[57:64], v[89:96], v[25:32]
	s_barrier
	s_waitcnt vmcnt(11)
	ds_store_b128 v164, v[97:100]
	s_waitcnt vmcnt(10)
	ds_store_b128 v164, v[101:104] offset:1024
	s_waitcnt vmcnt(9)
	ds_store_b128 v164, v[105:108] offset:2048
	s_waitcnt vmcnt(8)
	ds_store_b128 v164, v[109:112] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x7
	buffer_load_b128 v[73:76], v118, s[8:11], 0 offen offset:128
	buffer_load_b128 v[77:80], v118, s[8:11], 0 offen offset:144
	buffer_load_b128 v[57:60], v118, s[8:11], 0 offen offset:160
	buffer_load_b128 v[61:64], v118, s[8:11], 0 offen offset:176
	buffer_load_b128 v[65:68], v119, s[8:11], 0 offen offset:128
	buffer_load_b128 v[69:72], v119, s[8:11], 0 offen offset:144
	buffer_load_b128 v[49:52], v119, s[8:11], 0 offen offset:160
	buffer_load_b128 v[53:56], v119, s[8:11], 0 offen offset:176
	s_clause 0x3
	buffer_load_b128 v[97:100], v120, s[4:7], 0 offen slc
	buffer_load_b128 v[101:104], v121, s[4:7], 0 offen slc
	buffer_load_b128 v[105:108], v122, s[4:7], 0 offen slc
	buffer_load_b128 v[109:112], v123, s[4:7], 0 offen slc
	ds_load_u16_d16 v139, v163
	ds_load_u16_d16_hi v139, v163 offset:128
	ds_load_u16_d16 v140, v163 offset:256
	ds_load_u16_d16_hi v140, v163 offset:384
	ds_load_u16_d16_hi v148, v163 offset:448
	ds_load_u16_d16 v148, v163 offset:320
	ds_load_u16_d16_hi v147, v163 offset:192
	ds_load_u16_d16 v147, v163 offset:64
	ds_load_u16_d16 v141, v163 offset:512
	ds_load_u16_d16_hi v141, v163 offset:640
	ds_load_u16_d16 v142, v163 offset:768
	ds_load_u16_d16_hi v142, v163 offset:896
	ds_load_u16_d16_hi v150, v163 offset:960
	ds_load_u16_d16 v150, v163 offset:832
	ds_load_u16_d16_hi v149, v163 offset:704
	ds_load_u16_d16 v149, v163 offset:576
	ds_load_u16_d16 v143, v163 offset:1024
	ds_load_u16_d16_hi v143, v163 offset:1152
	ds_load_u16_d16 v144, v163 offset:1280
	ds_load_u16_d16_hi v144, v163 offset:1408
	ds_load_u16_d16_hi v152, v163 offset:1472
	ds_load_u16_d16 v152, v163 offset:1344
	ds_load_u16_d16_hi v151, v163 offset:1216
	ds_load_u16_d16 v151, v163 offset:1088
	ds_load_u16_d16 v145, v163 offset:1536
	ds_load_u16_d16_hi v145, v163 offset:1664
	ds_load_u16_d16 v146, v163 offset:1792
	ds_load_u16_d16_hi v146, v163 offset:1920
	ds_load_u16_d16_hi v154, v163 offset:1984
	ds_load_u16_d16 v154, v163 offset:1856
	ds_load_u16_d16_hi v153, v163 offset:1728
	ds_load_u16_d16 v153, v163 offset:1600
	ds_load_u16_d16 v89, v163 offset:2048
	ds_load_u16_d16_hi v89, v163 offset:2176
	ds_load_u16_d16 v90, v163 offset:2304
	ds_load_u16_d16_hi v90, v163 offset:2432
	ds_load_u16_d16 v91, v163 offset:2560
	ds_load_u16_d16_hi v91, v163 offset:2688
	ds_load_u16_d16 v92, v163 offset:2816
	ds_load_u16_d16_hi v92, v163 offset:2944
	ds_load_u16_d16 v93, v163 offset:3072
	ds_load_u16_d16_hi v93, v163 offset:3200
	ds_load_u16_d16 v94, v163 offset:3328
	ds_load_u16_d16_hi v94, v163 offset:3456
	ds_load_u16_d16 v95, v163 offset:3584
	ds_load_u16_d16_hi v95, v163 offset:3712
	ds_load_u16_d16 v96, v163 offset:3840
	ds_load_u16_d16_hi v96, v163 offset:3968
	v_add_nc_u32_e32 v120, 0xfffa4000, v117
	v_add_nc_u32_e32 v121, 0xfffa8000, v117
	v_add_nc_u32_e32 v122, 0xfffac000, v117
	v_add_nc_u32_e32 v123, 0xfffb0000, v117
	s_waitcnt vmcnt(18) lgkmcnt(20)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[81:88], v[139:146], v[1:8]
	s_waitcnt vmcnt(14)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[131:138], v[139:146], v[17:24]
	v_add_nc_u32_e32 v139, 0xfffb8000, v117
	v_add_nc_u32_e32 v140, 0xfffbc000, v117
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[81:88], v[147:154], v[9:16]
	ds_load_u16_d16 v81, v163 offset:2112
	ds_load_u16_d16_hi v81, v163 offset:2240
	ds_load_u16_d16 v82, v163 offset:2368
	ds_load_u16_d16_hi v82, v163 offset:2496
	ds_load_u16_d16 v83, v163 offset:2624
	ds_load_u16_d16_hi v83, v163 offset:2752
	ds_load_u16_d16 v84, v163 offset:2880
	ds_load_u16_d16_hi v84, v163 offset:3008
	ds_load_u16_d16 v85, v163 offset:3136
	ds_load_u16_d16_hi v85, v163 offset:3264
	ds_load_u16_d16 v86, v163 offset:3392
	ds_load_u16_d16_hi v86, v163 offset:3520
	ds_load_u16_d16 v87, v163 offset:3648
	ds_load_u16_d16_hi v87, v163 offset:3776
	ds_load_u16_d16 v88, v163 offset:3904
	ds_load_u16_d16_hi v88, v163 offset:4032
	v_wmma_f32_16x16x16_bf16 v[25:32], v[131:138], v[147:154], v[25:32]
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[41:48], v[89:96], v[1:8]
	s_waitcnt vmcnt(12)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[33:40], v[89:96], v[17:24]
	v_add_nc_u32_e32 v141, 0xfffc0000, v117
	v_add_nc_u32_e32 v143, 0xfffd0000, v117
	v_add_nc_u32_e32 v147, 0xfffd8000, v117
	v_add_nc_u32_e32 v148, 0xfffdc000, v117
	v_add_nc_u32_e32 v149, 0xfffe0000, v117
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[41:48], v[81:88], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[33:40], v[81:88], v[25:32]
	s_barrier
	s_waitcnt vmcnt(3)
	ds_store_b128 v164, v[97:100]
	s_waitcnt vmcnt(2)
	ds_store_b128 v164, v[101:104] offset:1024
	s_waitcnt vmcnt(1)
	ds_store_b128 v164, v[105:108] offset:2048
	s_waitcnt vmcnt(0)
	ds_store_b128 v164, v[109:112] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x3
	buffer_load_b128 v[124:127], v120, s[4:7], 0 offen slc
	buffer_load_b128 v[131:134], v121, s[4:7], 0 offen slc
	buffer_load_b128 v[135:138], v122, s[4:7], 0 offen slc
	buffer_load_b128 v[120:123], v123, s[4:7], 0 offen slc
	s_clause 0x7
	buffer_load_b128 v[41:44], v118, s[8:11], 0 offen offset:192
	buffer_load_b128 v[45:48], v118, s[8:11], 0 offen offset:208
	buffer_load_b128 v[89:92], v119, s[8:11], 0 offen offset:192
	buffer_load_b128 v[93:96], v119, s[8:11], 0 offen offset:208
	buffer_load_b128 v[97:100], v118, s[8:11], 0 offen offset:224
	buffer_load_b128 v[101:104], v118, s[8:11], 0 offen offset:240
	buffer_load_b128 v[105:108], v119, s[8:11], 0 offen offset:224
	buffer_load_b128 v[109:112], v119, s[8:11], 0 offen offset:240
	ds_load_u16_d16 v33, v163
	ds_load_u16_d16_hi v33, v163 offset:128
	ds_load_u16_d16 v34, v163 offset:256
	ds_load_u16_d16_hi v34, v163 offset:384
	ds_load_u16_d16_hi v82, v163 offset:448
	ds_load_u16_d16 v82, v163 offset:320
	ds_load_u16_d16_hi v81, v163 offset:192
	ds_load_u16_d16 v81, v163 offset:64
	ds_load_u16_d16 v35, v163 offset:512
	ds_load_u16_d16_hi v35, v163 offset:640
	ds_load_u16_d16 v36, v163 offset:768
	ds_load_u16_d16_hi v36, v163 offset:896
	ds_load_u16_d16_hi v84, v163 offset:960
	ds_load_u16_d16 v84, v163 offset:832
	ds_load_u16_d16_hi v83, v163 offset:704
	ds_load_u16_d16 v83, v163 offset:576
	ds_load_u16_d16 v37, v163 offset:1024
	ds_load_u16_d16_hi v37, v163 offset:1152
	ds_load_u16_d16 v38, v163 offset:1280
	ds_load_u16_d16_hi v38, v163 offset:1408
	ds_load_u16_d16_hi v86, v163 offset:1472
	ds_load_u16_d16 v86, v163 offset:1344
	ds_load_u16_d16_hi v85, v163 offset:1216
	ds_load_u16_d16 v85, v163 offset:1088
	ds_load_u16_d16 v39, v163 offset:1536
	ds_load_u16_d16_hi v39, v163 offset:1664
	ds_load_u16_d16 v40, v163 offset:1792
	ds_load_u16_d16_hi v40, v163 offset:1920
	ds_load_u16_d16_hi v88, v163 offset:1984
	ds_load_u16_d16 v88, v163 offset:1856
	ds_load_u16_d16_hi v87, v163 offset:1728
	ds_load_u16_d16 v87, v163 offset:1600
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[73:80], v[33:40], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[65:72], v[33:40], v[17:24]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[73:80], v[81:88], v[9:16]
	ds_load_u16_d16_hi v34, v163 offset:2496
	ds_load_u16_d16 v34, v163 offset:2368
	ds_load_u16_d16_hi v33, v163 offset:2240
	ds_load_u16_d16 v33, v163 offset:2112
	ds_load_u16_d16 v75, v163 offset:2560
	ds_load_u16_d16_hi v75, v163 offset:2688
	ds_load_u16_d16 v76, v163 offset:2816
	ds_load_u16_d16_hi v76, v163 offset:2944
	ds_load_u16_d16_hi v36, v163 offset:3008
	ds_load_u16_d16 v36, v163 offset:2880
	ds_load_u16_d16_hi v35, v163 offset:2752
	ds_load_u16_d16 v35, v163 offset:2624
	ds_load_u16_d16 v77, v163 offset:3072
	ds_load_u16_d16_hi v77, v163 offset:3200
	ds_load_u16_d16 v78, v163 offset:3328
	ds_load_u16_d16_hi v78, v163 offset:3456
	ds_load_u16_d16_hi v38, v163 offset:3520
	ds_load_u16_d16 v38, v163 offset:3392
	ds_load_u16_d16_hi v37, v163 offset:3264
	ds_load_u16_d16 v37, v163 offset:3136
	ds_load_u16_d16 v79, v163 offset:3584
	ds_load_u16_d16_hi v79, v163 offset:3712
	ds_load_u16_d16 v80, v163 offset:3840
	ds_load_u16_d16_hi v80, v163 offset:3968
	ds_load_u16_d16_hi v40, v163 offset:4032
	ds_load_u16_d16 v40, v163 offset:3904
	ds_load_u16_d16_hi v39, v163 offset:3776
	ds_load_u16_d16 v39, v163 offset:3648
	ds_load_u16_d16 v73, v163 offset:2048
	ds_load_u16_d16_hi v73, v163 offset:2176
	ds_load_u16_d16 v74, v163 offset:2304
	ds_load_u16_d16_hi v74, v163 offset:2432
	v_wmma_f32_16x16x16_bf16 v[25:32], v[65:72], v[81:88], v[25:32]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[57:64], v[33:40], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[57:64], v[73:80], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[49:56], v[73:80], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[49:56], v[33:40], v[25:32]
	s_barrier
	s_waitcnt vmcnt(11)
	ds_store_b128 v164, v[124:127]
	s_waitcnt vmcnt(10)
	ds_store_b128 v164, v[131:134] offset:1024
	s_waitcnt vmcnt(9)
	ds_store_b128 v164, v[135:138] offset:2048
	s_waitcnt vmcnt(8)
	ds_store_b128 v164, v[120:123] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x3
	buffer_load_b128 v[120:123], v128, s[4:7], 0 offen slc
	buffer_load_b128 v[124:127], v139, s[4:7], 0 offen slc
	buffer_load_b128 v[131:134], v140, s[4:7], 0 offen slc
	buffer_load_b128 v[135:138], v141, s[4:7], 0 offen slc
	s_clause 0x7
	buffer_load_b128 v[57:60], v118, s[8:11], 0 offen offset:256
	buffer_load_b128 v[61:64], v118, s[8:11], 0 offen offset:272
	buffer_load_b128 v[65:68], v119, s[8:11], 0 offen offset:256
	buffer_load_b128 v[69:72], v119, s[8:11], 0 offen offset:272
	buffer_load_b128 v[73:76], v118, s[8:11], 0 offen offset:288
	buffer_load_b128 v[77:80], v118, s[8:11], 0 offen offset:304
	buffer_load_b128 v[81:84], v119, s[8:11], 0 offen offset:288
	buffer_load_b128 v[85:88], v119, s[8:11], 0 offen offset:304
	ds_load_u16_d16 v33, v163
	ds_load_u16_d16_hi v33, v163 offset:128
	ds_load_u16_d16 v34, v163 offset:256
	ds_load_u16_d16_hi v34, v163 offset:384
	ds_load_u16_d16_hi v50, v163 offset:448
	ds_load_u16_d16 v50, v163 offset:320
	ds_load_u16_d16_hi v49, v163 offset:192
	ds_load_u16_d16 v49, v163 offset:64
	ds_load_u16_d16 v35, v163 offset:512
	ds_load_u16_d16_hi v35, v163 offset:640
	ds_load_u16_d16 v36, v163 offset:768
	ds_load_u16_d16_hi v36, v163 offset:896
	ds_load_u16_d16_hi v52, v163 offset:960
	ds_load_u16_d16 v52, v163 offset:832
	ds_load_u16_d16_hi v51, v163 offset:704
	ds_load_u16_d16 v51, v163 offset:576
	ds_load_u16_d16 v37, v163 offset:1024
	ds_load_u16_d16_hi v37, v163 offset:1152
	ds_load_u16_d16 v38, v163 offset:1280
	ds_load_u16_d16_hi v38, v163 offset:1408
	ds_load_u16_d16_hi v54, v163 offset:1472
	ds_load_u16_d16 v54, v163 offset:1344
	ds_load_u16_d16_hi v53, v163 offset:1216
	ds_load_u16_d16 v53, v163 offset:1088
	ds_load_u16_d16 v39, v163 offset:1536
	ds_load_u16_d16_hi v39, v163 offset:1664
	ds_load_u16_d16 v40, v163 offset:1792
	ds_load_u16_d16_hi v40, v163 offset:1920
	ds_load_u16_d16_hi v56, v163 offset:1984
	ds_load_u16_d16 v56, v163 offset:1856
	ds_load_u16_d16_hi v55, v163 offset:1728
	ds_load_u16_d16 v55, v163 offset:1600
	v_add_nc_u32_e32 v128, 0xfffc4000, v117
	v_add_nc_u32_e32 v139, 0xfffc8000, v117
	v_add_nc_u32_e32 v140, 0xfffcc000, v117
	s_waitcnt vmcnt(18) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[41:48], v[33:40], v[1:8]
	s_waitcnt vmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[89:96], v[33:40], v[17:24]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[41:48], v[49:56], v[9:16]
	ds_load_u16_d16_hi v34, v163 offset:2496
	ds_load_u16_d16 v34, v163 offset:2368
	ds_load_u16_d16_hi v33, v163 offset:2240
	ds_load_u16_d16 v33, v163 offset:2112
	ds_load_u16_d16 v43, v163 offset:2560
	ds_load_u16_d16_hi v43, v163 offset:2688
	ds_load_u16_d16 v44, v163 offset:2816
	ds_load_u16_d16_hi v44, v163 offset:2944
	ds_load_u16_d16_hi v36, v163 offset:3008
	ds_load_u16_d16 v36, v163 offset:2880
	ds_load_u16_d16_hi v35, v163 offset:2752
	ds_load_u16_d16 v35, v163 offset:2624
	ds_load_u16_d16 v45, v163 offset:3072
	ds_load_u16_d16_hi v45, v163 offset:3200
	ds_load_u16_d16 v46, v163 offset:3328
	ds_load_u16_d16_hi v46, v163 offset:3456
	ds_load_u16_d16_hi v38, v163 offset:3520
	ds_load_u16_d16 v38, v163 offset:3392
	ds_load_u16_d16_hi v37, v163 offset:3264
	ds_load_u16_d16 v37, v163 offset:3136
	ds_load_u16_d16 v47, v163 offset:3584
	ds_load_u16_d16_hi v47, v163 offset:3712
	ds_load_u16_d16 v48, v163 offset:3840
	ds_load_u16_d16_hi v48, v163 offset:3968
	ds_load_u16_d16_hi v40, v163 offset:4032
	ds_load_u16_d16 v40, v163 offset:3904
	ds_load_u16_d16_hi v39, v163 offset:3776
	ds_load_u16_d16 v39, v163 offset:3648
	ds_load_u16_d16 v41, v163 offset:2048
	ds_load_u16_d16_hi v41, v163 offset:2176
	ds_load_u16_d16 v42, v163 offset:2304
	ds_load_u16_d16_hi v42, v163 offset:2432
	v_wmma_f32_16x16x16_bf16 v[25:32], v[89:96], v[49:56], v[25:32]
	s_waitcnt vmcnt(14) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[97:104], v[33:40], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[97:104], v[41:48], v[1:8]
	s_waitcnt vmcnt(12)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[105:112], v[41:48], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[105:112], v[33:40], v[25:32]
	s_barrier
	s_waitcnt vmcnt(11)
	ds_store_b128 v164, v[120:123]
	s_waitcnt vmcnt(10)
	ds_store_b128 v164, v[124:127] offset:1024
	s_waitcnt vmcnt(9)
	ds_store_b128 v164, v[131:134] offset:2048
	s_waitcnt vmcnt(8)
	ds_store_b128 v164, v[135:138] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x3
	buffer_load_b128 v[131:134], v128, s[4:7], 0 offen slc
	buffer_load_b128 v[135:138], v139, s[4:7], 0 offen slc
	buffer_load_b128 v[139:142], v140, s[4:7], 0 offen slc
	buffer_load_b128 v[143:146], v143, s[4:7], 0 offen slc
	s_clause 0x7
	buffer_load_b128 v[41:44], v118, s[8:11], 0 offen offset:320
	buffer_load_b128 v[45:48], v118, s[8:11], 0 offen offset:336
	buffer_load_b128 v[49:52], v119, s[8:11], 0 offen offset:320
	buffer_load_b128 v[53:56], v119, s[8:11], 0 offen offset:336
	buffer_load_b128 v[89:92], v118, s[8:11], 0 offen offset:352
	buffer_load_b128 v[93:96], v118, s[8:11], 0 offen offset:368
	buffer_load_b128 v[97:100], v119, s[8:11], 0 offen offset:352
	buffer_load_b128 v[101:104], v119, s[8:11], 0 offen offset:368
	ds_load_u16_d16 v33, v163
	ds_load_u16_d16_hi v33, v163 offset:128
	ds_load_u16_d16 v34, v163 offset:256
	ds_load_u16_d16_hi v34, v163 offset:384
	ds_load_u16_d16_hi v106, v163 offset:448
	ds_load_u16_d16 v106, v163 offset:320
	ds_load_u16_d16_hi v105, v163 offset:192
	ds_load_u16_d16 v105, v163 offset:64
	ds_load_u16_d16 v35, v163 offset:512
	ds_load_u16_d16_hi v35, v163 offset:640
	ds_load_u16_d16 v36, v163 offset:768
	ds_load_u16_d16_hi v36, v163 offset:896
	ds_load_u16_d16_hi v108, v163 offset:960
	ds_load_u16_d16 v108, v163 offset:832
	ds_load_u16_d16_hi v107, v163 offset:704
	ds_load_u16_d16 v107, v163 offset:576
	ds_load_u16_d16 v37, v163 offset:1024
	ds_load_u16_d16_hi v37, v163 offset:1152
	ds_load_u16_d16 v38, v163 offset:1280
	ds_load_u16_d16_hi v38, v163 offset:1408
	ds_load_u16_d16_hi v110, v163 offset:1472
	ds_load_u16_d16 v110, v163 offset:1344
	ds_load_u16_d16_hi v109, v163 offset:1216
	ds_load_u16_d16 v109, v163 offset:1088
	ds_load_u16_d16 v39, v163 offset:1536
	ds_load_u16_d16_hi v39, v163 offset:1664
	ds_load_u16_d16 v40, v163 offset:1792
	ds_load_u16_d16_hi v40, v163 offset:1920
	ds_load_u16_d16_hi v112, v163 offset:1984
	ds_load_u16_d16 v112, v163 offset:1856
	ds_load_u16_d16_hi v111, v163 offset:1728
	ds_load_u16_d16 v111, v163 offset:1600
	v_add_nc_u32_e32 v128, 0xfffd4000, v117
	s_waitcnt vmcnt(18) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[57:64], v[33:40], v[1:8]
	s_waitcnt vmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[65:72], v[33:40], v[17:24]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[57:64], v[105:112], v[9:16]
	ds_load_u16_d16_hi v121, v163 offset:2496
	ds_load_u16_d16 v121, v163 offset:2368
	ds_load_u16_d16_hi v120, v163 offset:2240
	ds_load_u16_d16 v120, v163 offset:2112
	ds_load_u16_d16 v59, v163 offset:2560
	ds_load_u16_d16_hi v59, v163 offset:2688
	ds_load_u16_d16 v60, v163 offset:2816
	ds_load_u16_d16_hi v60, v163 offset:2944
	ds_load_u16_d16_hi v123, v163 offset:3008
	ds_load_u16_d16 v123, v163 offset:2880
	ds_load_u16_d16_hi v122, v163 offset:2752
	ds_load_u16_d16 v122, v163 offset:2624
	ds_load_u16_d16 v61, v163 offset:3072
	ds_load_u16_d16_hi v61, v163 offset:3200
	ds_load_u16_d16 v62, v163 offset:3328
	ds_load_u16_d16_hi v62, v163 offset:3456
	ds_load_u16_d16_hi v125, v163 offset:3520
	ds_load_u16_d16 v125, v163 offset:3392
	ds_load_u16_d16_hi v124, v163 offset:3264
	ds_load_u16_d16 v124, v163 offset:3136
	ds_load_u16_d16 v63, v163 offset:3584
	ds_load_u16_d16_hi v63, v163 offset:3712
	ds_load_u16_d16 v64, v163 offset:3840
	ds_load_u16_d16_hi v64, v163 offset:3968
	ds_load_u16_d16_hi v127, v163 offset:4032
	ds_load_u16_d16 v127, v163 offset:3904
	ds_load_u16_d16_hi v126, v163 offset:3776
	ds_load_u16_d16 v126, v163 offset:3648
	ds_load_u16_d16 v57, v163 offset:2048
	ds_load_u16_d16_hi v57, v163 offset:2176
	ds_load_u16_d16 v58, v163 offset:2304
	ds_load_u16_d16_hi v58, v163 offset:2432
	v_wmma_f32_16x16x16_bf16 v[25:32], v[65:72], v[105:112], v[25:32]
	s_waitcnt vmcnt(14) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[73:80], v[120:127], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[73:80], v[57:64], v[1:8]
	s_waitcnt vmcnt(12)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[81:88], v[57:64], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[81:88], v[120:127], v[25:32]
	s_barrier
	s_waitcnt vmcnt(11)
	ds_store_b128 v164, v[131:134]
	s_waitcnt vmcnt(10)
	ds_store_b128 v164, v[135:138] offset:1024
	s_waitcnt vmcnt(9)
	ds_store_b128 v164, v[139:142] offset:2048
	s_waitcnt vmcnt(8)
	ds_store_b128 v164, v[143:146] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x3
	buffer_load_b128 v[131:134], v128, s[4:7], 0 offen slc
	buffer_load_b128 v[135:138], v147, s[4:7], 0 offen slc
	buffer_load_b128 v[139:142], v148, s[4:7], 0 offen slc
	buffer_load_b128 v[143:146], v149, s[4:7], 0 offen slc
	s_clause 0x7
	buffer_load_b128 v[57:60], v118, s[8:11], 0 offen offset:384
	buffer_load_b128 v[61:64], v118, s[8:11], 0 offen offset:400
	buffer_load_b128 v[65:68], v119, s[8:11], 0 offen offset:384
	buffer_load_b128 v[69:72], v119, s[8:11], 0 offen offset:400
	buffer_load_b128 v[73:76], v118, s[8:11], 0 offen offset:416
	buffer_load_b128 v[77:80], v118, s[8:11], 0 offen offset:432
	buffer_load_b128 v[33:36], v119, s[8:11], 0 offen offset:416
	buffer_load_b128 v[37:40], v119, s[8:11], 0 offen offset:432
	ds_load_u16_d16 v81, v163
	ds_load_u16_d16_hi v81, v163 offset:128
	ds_load_u16_d16 v82, v163 offset:256
	ds_load_u16_d16_hi v82, v163 offset:384
	ds_load_u16_d16_hi v106, v163 offset:448
	ds_load_u16_d16 v106, v163 offset:320
	ds_load_u16_d16_hi v105, v163 offset:192
	ds_load_u16_d16 v105, v163 offset:64
	ds_load_u16_d16 v83, v163 offset:512
	ds_load_u16_d16_hi v83, v163 offset:640
	ds_load_u16_d16 v84, v163 offset:768
	ds_load_u16_d16_hi v84, v163 offset:896
	ds_load_u16_d16_hi v108, v163 offset:960
	ds_load_u16_d16 v108, v163 offset:832
	ds_load_u16_d16_hi v107, v163 offset:704
	ds_load_u16_d16 v107, v163 offset:576
	ds_load_u16_d16 v85, v163 offset:1024
	ds_load_u16_d16_hi v85, v163 offset:1152
	ds_load_u16_d16 v86, v163 offset:1280
	ds_load_u16_d16_hi v86, v163 offset:1408
	ds_load_u16_d16_hi v110, v163 offset:1472
	ds_load_u16_d16 v110, v163 offset:1344
	ds_load_u16_d16_hi v109, v163 offset:1216
	ds_load_u16_d16 v109, v163 offset:1088
	ds_load_u16_d16 v87, v163 offset:1536
	ds_load_u16_d16_hi v87, v163 offset:1664
	ds_load_u16_d16 v88, v163 offset:1792
	ds_load_u16_d16_hi v88, v163 offset:1920
	ds_load_u16_d16_hi v112, v163 offset:1984
	ds_load_u16_d16 v112, v163 offset:1856
	ds_load_u16_d16_hi v111, v163 offset:1728
	ds_load_u16_d16 v111, v163 offset:1600
	v_add_nc_u32_e32 v128, 0xfffe4000, v117
	v_add_nc_u32_e32 v147, 0xfffe8000, v117
	v_add_nc_u32_e32 v148, 0xfffec000, v117
	v_add_nc_u32_e32 v149, 0xffff0000, v117
	s_waitcnt vmcnt(18) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[41:48], v[81:88], v[1:8]
	s_waitcnt vmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[49:56], v[81:88], v[17:24]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[41:48], v[105:112], v[9:16]
	ds_load_u16_d16_hi v121, v163 offset:2496
	ds_load_u16_d16 v121, v163 offset:2368
	ds_load_u16_d16_hi v120, v163 offset:2240
	ds_load_u16_d16 v120, v163 offset:2112
	ds_load_u16_d16 v43, v163 offset:2560
	ds_load_u16_d16_hi v43, v163 offset:2688
	ds_load_u16_d16 v44, v163 offset:2816
	ds_load_u16_d16_hi v44, v163 offset:2944
	ds_load_u16_d16_hi v123, v163 offset:3008
	ds_load_u16_d16 v123, v163 offset:2880
	ds_load_u16_d16_hi v122, v163 offset:2752
	ds_load_u16_d16 v122, v163 offset:2624
	ds_load_u16_d16 v45, v163 offset:3072
	ds_load_u16_d16_hi v45, v163 offset:3200
	ds_load_u16_d16 v46, v163 offset:3328
	ds_load_u16_d16_hi v46, v163 offset:3456
	ds_load_u16_d16_hi v125, v163 offset:3520
	ds_load_u16_d16 v125, v163 offset:3392
	ds_load_u16_d16_hi v124, v163 offset:3264
	ds_load_u16_d16 v124, v163 offset:3136
	ds_load_u16_d16 v47, v163 offset:3584
	ds_load_u16_d16_hi v47, v163 offset:3712
	ds_load_u16_d16 v48, v163 offset:3840
	ds_load_u16_d16_hi v48, v163 offset:3968
	ds_load_u16_d16_hi v127, v163 offset:4032
	ds_load_u16_d16 v127, v163 offset:3904
	ds_load_u16_d16_hi v126, v163 offset:3776
	ds_load_u16_d16 v126, v163 offset:3648
	ds_load_u16_d16 v41, v163 offset:2048
	ds_load_u16_d16_hi v41, v163 offset:2176
	ds_load_u16_d16 v42, v163 offset:2304
	ds_load_u16_d16_hi v42, v163 offset:2432
	v_wmma_f32_16x16x16_bf16 v[25:32], v[49:56], v[105:112], v[25:32]
	s_waitcnt vmcnt(14) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[89:96], v[120:127], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[89:96], v[41:48], v[1:8]
	s_waitcnt vmcnt(12)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[97:104], v[41:48], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[97:104], v[120:127], v[25:32]
	s_barrier
	s_waitcnt vmcnt(11)
	ds_store_b128 v164, v[131:134]
	s_waitcnt vmcnt(10)
	ds_store_b128 v164, v[135:138] offset:1024
	s_waitcnt vmcnt(9)
	ds_store_b128 v164, v[139:142] offset:2048
	s_waitcnt vmcnt(8)
	ds_store_b128 v164, v[143:146] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x3
	buffer_load_b128 v[131:134], v128, s[4:7], 0 offen slc
	buffer_load_b128 v[135:138], v147, s[4:7], 0 offen slc
	buffer_load_b128 v[139:142], v148, s[4:7], 0 offen slc
	buffer_load_b128 v[143:146], v149, s[4:7], 0 offen slc
	s_clause 0x7
	buffer_load_b128 v[105:108], v118, s[8:11], 0 offen offset:448
	buffer_load_b128 v[109:112], v118, s[8:11], 0 offen offset:464
	buffer_load_b128 v[81:84], v119, s[8:11], 0 offen offset:448
	buffer_load_b128 v[85:88], v119, s[8:11], 0 offen offset:464
	buffer_load_b128 v[89:92], v118, s[8:11], 0 offen offset:480
	buffer_load_b128 v[93:96], v118, s[8:11], 0 offen offset:496
	buffer_load_b128 v[41:44], v119, s[8:11], 0 offen offset:480
	buffer_load_b128 v[45:48], v119, s[8:11], 0 offen offset:496
	ds_load_u16_d16 v49, v163
	ds_load_u16_d16_hi v49, v163 offset:128
	ds_load_u16_d16 v50, v163 offset:256
	ds_load_u16_d16_hi v50, v163 offset:384
	ds_load_u16_d16_hi v98, v163 offset:448
	ds_load_u16_d16 v98, v163 offset:320
	ds_load_u16_d16_hi v97, v163 offset:192
	ds_load_u16_d16 v97, v163 offset:64
	ds_load_u16_d16 v51, v163 offset:512
	ds_load_u16_d16_hi v51, v163 offset:640
	ds_load_u16_d16 v52, v163 offset:768
	ds_load_u16_d16_hi v52, v163 offset:896
	ds_load_u16_d16_hi v100, v163 offset:960
	ds_load_u16_d16 v100, v163 offset:832
	ds_load_u16_d16_hi v99, v163 offset:704
	ds_load_u16_d16 v99, v163 offset:576
	ds_load_u16_d16 v53, v163 offset:1024
	ds_load_u16_d16_hi v53, v163 offset:1152
	ds_load_u16_d16 v54, v163 offset:1280
	ds_load_u16_d16_hi v54, v163 offset:1408
	ds_load_u16_d16_hi v102, v163 offset:1472
	ds_load_u16_d16 v102, v163 offset:1344
	ds_load_u16_d16_hi v101, v163 offset:1216
	ds_load_u16_d16 v101, v163 offset:1088
	ds_load_u16_d16 v55, v163 offset:1536
	ds_load_u16_d16_hi v55, v163 offset:1664
	ds_load_u16_d16 v56, v163 offset:1792
	ds_load_u16_d16_hi v56, v163 offset:1920
	ds_load_u16_d16_hi v104, v163 offset:1984
	ds_load_u16_d16 v104, v163 offset:1856
	ds_load_u16_d16_hi v103, v163 offset:1728
	ds_load_u16_d16 v103, v163 offset:1600
	v_add_nc_u32_e32 v128, 0xffff4000, v117
	v_add_nc_u32_e32 v147, 0xffff8000, v117
	v_add_nc_u32_e32 v148, 0xffffc000, v117
	s_waitcnt vmcnt(18) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[57:64], v[49:56], v[1:8]
	s_waitcnt vmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[65:72], v[49:56], v[17:24]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[57:64], v[97:104], v[9:16]
	ds_load_u16_d16_hi v121, v163 offset:2496
	ds_load_u16_d16 v121, v163 offset:2368
	ds_load_u16_d16_hi v120, v163 offset:2240
	ds_load_u16_d16 v120, v163 offset:2112
	ds_load_u16_d16 v59, v163 offset:2560
	ds_load_u16_d16_hi v59, v163 offset:2688
	ds_load_u16_d16 v60, v163 offset:2816
	ds_load_u16_d16_hi v60, v163 offset:2944
	ds_load_u16_d16_hi v123, v163 offset:3008
	ds_load_u16_d16 v123, v163 offset:2880
	ds_load_u16_d16_hi v122, v163 offset:2752
	ds_load_u16_d16 v122, v163 offset:2624
	ds_load_u16_d16 v61, v163 offset:3072
	ds_load_u16_d16_hi v61, v163 offset:3200
	ds_load_u16_d16 v62, v163 offset:3328
	ds_load_u16_d16_hi v62, v163 offset:3456
	ds_load_u16_d16_hi v125, v163 offset:3520
	ds_load_u16_d16 v125, v163 offset:3392
	ds_load_u16_d16_hi v124, v163 offset:3264
	ds_load_u16_d16 v124, v163 offset:3136
	ds_load_u16_d16 v63, v163 offset:3584
	ds_load_u16_d16_hi v63, v163 offset:3712
	ds_load_u16_d16 v64, v163 offset:3840
	ds_load_u16_d16_hi v64, v163 offset:3968
	ds_load_u16_d16_hi v127, v163 offset:4032
	ds_load_u16_d16 v127, v163 offset:3904
	ds_load_u16_d16_hi v126, v163 offset:3776
	ds_load_u16_d16 v126, v163 offset:3648
	ds_load_u16_d16 v57, v163 offset:2048
	ds_load_u16_d16_hi v57, v163 offset:2176
	ds_load_u16_d16 v58, v163 offset:2304
	ds_load_u16_d16_hi v58, v163 offset:2432
	v_wmma_f32_16x16x16_bf16 v[25:32], v[65:72], v[97:104], v[25:32]
	s_waitcnt vmcnt(14) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[73:80], v[120:127], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[73:80], v[57:64], v[1:8]
	s_waitcnt vmcnt(12)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[33:40], v[57:64], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[33:40], v[120:127], v[25:32]
	s_barrier
	s_waitcnt vmcnt(11)
	ds_store_b128 v164, v[131:134]
	s_waitcnt vmcnt(10)
	ds_store_b128 v164, v[135:138] offset:1024
	s_waitcnt vmcnt(9)
	ds_store_b128 v164, v[139:142] offset:2048
	s_waitcnt vmcnt(8)
	ds_store_b128 v164, v[143:146] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x3
	buffer_load_b128 v[73:76], v118, s[8:11], 0 offen offset:512
	buffer_load_b128 v[77:80], v118, s[8:11], 0 offen offset:528
	buffer_load_b128 v[49:52], v118, s[8:11], 0 offen offset:544
	buffer_load_b128 v[53:56], v118, s[8:11], 0 offen offset:560
	s_clause 0x3
	buffer_load_b128 v[131:134], v128, s[4:7], 0 offen slc
	buffer_load_b128 v[135:138], v147, s[4:7], 0 offen slc
	buffer_load_b128 v[139:142], v148, s[4:7], 0 offen slc
	buffer_load_b128 v[143:146], v117, s[4:7], 0 offen slc
	s_clause 0x3
	buffer_load_b128 v[65:68], v119, s[8:11], 0 offen offset:512
	buffer_load_b128 v[69:72], v119, s[8:11], 0 offen offset:528
	buffer_load_b128 v[57:60], v119, s[8:11], 0 offen offset:544
	buffer_load_b128 v[61:64], v119, s[8:11], 0 offen offset:560
	ds_load_u16_d16 v33, v163
	ds_load_u16_d16_hi v33, v163 offset:128
	ds_load_u16_d16 v34, v163 offset:256
	ds_load_u16_d16_hi v34, v163 offset:384
	ds_load_u16_d16_hi v98, v163 offset:448
	ds_load_u16_d16 v98, v163 offset:320
	ds_load_u16_d16_hi v97, v163 offset:192
	ds_load_u16_d16 v97, v163 offset:64
	ds_load_u16_d16 v35, v163 offset:512
	ds_load_u16_d16_hi v35, v163 offset:640
	ds_load_u16_d16 v36, v163 offset:768
	ds_load_u16_d16_hi v36, v163 offset:896
	ds_load_u16_d16_hi v100, v163 offset:960
	ds_load_u16_d16 v100, v163 offset:832
	ds_load_u16_d16_hi v99, v163 offset:704
	ds_load_u16_d16 v99, v163 offset:576
	ds_load_u16_d16 v37, v163 offset:1024
	ds_load_u16_d16_hi v37, v163 offset:1152
	ds_load_u16_d16 v38, v163 offset:1280
	ds_load_u16_d16_hi v38, v163 offset:1408
	ds_load_u16_d16_hi v102, v163 offset:1472
	ds_load_u16_d16 v102, v163 offset:1344
	ds_load_u16_d16_hi v101, v163 offset:1216
	ds_load_u16_d16 v101, v163 offset:1088
	ds_load_u16_d16 v39, v163 offset:1536
	ds_load_u16_d16_hi v39, v163 offset:1664
	ds_load_u16_d16 v40, v163 offset:1792
	ds_load_u16_d16_hi v40, v163 offset:1920
	ds_load_u16_d16_hi v104, v163 offset:1984
	ds_load_u16_d16 v104, v163 offset:1856
	ds_load_u16_d16_hi v103, v163 offset:1728
	ds_load_u16_d16 v103, v163 offset:1600
	v_add_nc_u32_e32 v117, 0x80000, v117
	s_waitcnt vmcnt(18) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[105:112], v[33:40], v[1:8]
	s_waitcnt vmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[81:88], v[33:40], v[17:24]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[105:112], v[97:104], v[9:16]
	ds_load_u16_d16_hi v34, v163 offset:2496
	ds_load_u16_d16 v34, v163 offset:2368
	ds_load_u16_d16_hi v33, v163 offset:2240
	ds_load_u16_d16 v33, v163 offset:2112
	ds_load_u16_d16 v107, v163 offset:2560
	ds_load_u16_d16_hi v107, v163 offset:2688
	ds_load_u16_d16 v108, v163 offset:2816
	ds_load_u16_d16_hi v108, v163 offset:2944
	ds_load_u16_d16_hi v36, v163 offset:3008
	ds_load_u16_d16 v36, v163 offset:2880
	ds_load_u16_d16_hi v35, v163 offset:2752
	ds_load_u16_d16 v35, v163 offset:2624
	ds_load_u16_d16 v109, v163 offset:3072
	ds_load_u16_d16_hi v109, v163 offset:3200
	ds_load_u16_d16 v110, v163 offset:3328
	ds_load_u16_d16_hi v110, v163 offset:3456
	ds_load_u16_d16_hi v38, v163 offset:3520
	ds_load_u16_d16 v38, v163 offset:3392
	ds_load_u16_d16_hi v37, v163 offset:3264
	ds_load_u16_d16 v37, v163 offset:3136
	ds_load_u16_d16 v111, v163 offset:3584
	ds_load_u16_d16_hi v111, v163 offset:3712
	ds_load_u16_d16 v112, v163 offset:3840
	ds_load_u16_d16_hi v112, v163 offset:3968
	ds_load_u16_d16_hi v40, v163 offset:4032
	ds_load_u16_d16 v40, v163 offset:3904
	ds_load_u16_d16_hi v39, v163 offset:3776
	ds_load_u16_d16 v39, v163 offset:3648
	ds_load_u16_d16 v105, v163 offset:2048
	ds_load_u16_d16_hi v105, v163 offset:2176
	ds_load_u16_d16 v106, v163 offset:2304
	ds_load_u16_d16_hi v106, v163 offset:2432
	v_wmma_f32_16x16x16_bf16 v[25:32], v[81:88], v[97:104], v[25:32]
	s_waitcnt vmcnt(14) lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[89:96], v[33:40], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[89:96], v[105:112], v[1:8]
	s_waitcnt vmcnt(12)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[41:48], v[105:112], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[41:48], v[33:40], v[25:32]
	s_barrier
	s_waitcnt vmcnt(7)
	ds_store_b128 v164, v[131:134]
	s_waitcnt vmcnt(6)
	ds_store_b128 v164, v[135:138] offset:1024
	s_waitcnt vmcnt(5)
	ds_store_b128 v164, v[139:142] offset:2048
	s_waitcnt vmcnt(4)
	ds_store_b128 v164, v[143:146] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_cbranch_scc1 .LBB0_1
	s_add_i32 s12, s12, 0x1c8000
	s_mov_b32 s6, s10
	v_add_lshl_u32 v97, s12, v113, 1
	s_mov_b32 s7, s11
	s_clause 0x5
	buffer_load_b128 v[81:84], v129, s[8:11], 0 offen offset:3648
	buffer_load_b128 v[85:88], v129, s[8:11], 0 offen offset:3664
	buffer_load_b128 v[33:36], v129, s[8:11], 0 offen offset:3680
	buffer_load_b128 v[37:40], v129, s[8:11], 0 offen offset:3696
	buffer_load_b128 v[89:92], v130, s[8:11], 0 offen offset:3648
	buffer_load_b128 v[93:96], v130, s[8:11], 0 offen offset:3664
	ds_load_u16_d16 v114, v163 offset:2048
	ds_load_u16_d16_hi v114, v163 offset:2176
	ds_load_u16_d16 v115, v163 offset:2304
	ds_load_u16_d16_hi v115, v163 offset:2432
	ds_load_u16_d16_hi v133, v163 offset:2496
	ds_load_u16_d16 v133, v163 offset:2368
	ds_load_u16_d16_hi v132, v163 offset:2240
	ds_load_u16_d16 v132, v163 offset:2112
	ds_load_u16_d16 v116, v163 offset:2560
	ds_load_u16_d16_hi v116, v163 offset:2688
	ds_load_u16_d16 v117, v163 offset:2816
	ds_load_u16_d16_hi v117, v163 offset:2944
	ds_load_u16_d16_hi v135, v163 offset:3008
	ds_load_u16_d16 v135, v163 offset:2880
	ds_load_u16_d16_hi v134, v163 offset:2752
	ds_load_u16_d16 v134, v163 offset:2624
	ds_load_u16_d16 v118, v163 offset:3072
	ds_load_u16_d16_hi v118, v163 offset:3200
	ds_load_u16_d16 v119, v163 offset:3328
	ds_load_u16_d16_hi v119, v163 offset:3456
	ds_load_u16_d16_hi v137, v163 offset:3520
	ds_load_u16_d16 v137, v163 offset:3392
	ds_load_u16_d16_hi v136, v163 offset:3264
	ds_load_u16_d16 v136, v163 offset:3136
	ds_load_u16_d16 v120, v163 offset:3584
	ds_load_u16_d16_hi v120, v163 offset:3712
	ds_load_u16_d16 v121, v163 offset:3840
	ds_load_u16_d16_hi v121, v163 offset:3968
	ds_load_u16_d16_hi v139, v163 offset:4032
	ds_load_u16_d16 v139, v163 offset:3904
	ds_load_u16_d16_hi v138, v163 offset:3776
	ds_load_u16_d16 v138, v163 offset:3648
	v_add_nc_u32_e32 v98, 0x4000, v97
	v_add_nc_u32_e32 v99, 0x8000, v97
	v_add_nc_u32_e32 v100, 0xc000, v97
	s_clause 0x1
	buffer_load_b128 v[41:44], v130, s[8:11], 0 offen offset:3680
	buffer_load_b128 v[45:48], v130, s[8:11], 0 offen offset:3696
	s_clause 0x3
	buffer_load_b128 v[122:125], v97, s[4:7], 0 offen slc
	buffer_load_b128 v[140:143], v98, s[4:7], 0 offen slc
	buffer_load_b128 v[144:147], v99, s[4:7], 0 offen slc
	buffer_load_b128 v[148:151], v100, s[4:7], 0 offen slc
	ds_load_u16_d16 v97, v163
	ds_load_u16_d16_hi v97, v163 offset:128
	ds_load_u16_d16 v98, v163 offset:256
	ds_load_u16_d16_hi v98, v163 offset:384
	ds_load_u16_d16_hi v106, v163 offset:448
	ds_load_u16_d16 v106, v163 offset:320
	ds_load_u16_d16_hi v105, v163 offset:192
	ds_load_u16_d16 v105, v163 offset:64
	ds_load_u16_d16 v99, v163 offset:512
	ds_load_u16_d16_hi v99, v163 offset:640
	ds_load_u16_d16 v100, v163 offset:768
	ds_load_u16_d16_hi v100, v163 offset:896
	ds_load_u16_d16_hi v108, v163 offset:960
	ds_load_u16_d16 v108, v163 offset:832
	ds_load_u16_d16_hi v107, v163 offset:704
	ds_load_u16_d16 v107, v163 offset:576
	ds_load_u16_d16 v101, v163 offset:1024
	ds_load_u16_d16_hi v101, v163 offset:1152
	ds_load_u16_d16 v102, v163 offset:1280
	ds_load_u16_d16_hi v102, v163 offset:1408
	ds_load_u16_d16_hi v110, v163 offset:1472
	ds_load_u16_d16 v110, v163 offset:1344
	ds_load_u16_d16_hi v109, v163 offset:1216
	ds_load_u16_d16 v109, v163 offset:1088
	ds_load_u16_d16 v103, v163 offset:1536
	ds_load_u16_d16_hi v103, v163 offset:1664
	ds_load_u16_d16 v104, v163 offset:1792
	ds_load_u16_d16_hi v104, v163 offset:1920
	ds_load_u16_d16_hi v112, v163 offset:1984
	ds_load_u16_d16 v112, v163 offset:1856
	ds_load_u16_d16_hi v111, v163 offset:1728
	ds_load_u16_d16 v111, v163 offset:1600
	s_clause 0x1
	s_load_b64 s[12:13], s[0:1], 0x48
	s_load_b64 s[14:15], s[0:1], 0x58
	v_add_nc_u32_e32 v113, s16, v113
	s_lshl_b32 s18, s18, 22
	s_delay_alu instid0(VALU_DEP_1) | instid1(SALU_CYCLE_1)
	v_lshl_add_u32 v131, v113, 1, s18
	s_delay_alu instid0(VALU_DEP_1)
	v_add_nc_u32_e32 v113, 0x3a0000, v131
	v_add_nc_u32_e32 v156, 0x3b0000, v131
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[73:80], v[97:104], v[1:8]
	s_waitcnt vmcnt(14)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[65:72], v[97:104], v[17:24]
	v_add_nc_u32_e32 v126, 0x4000, v113
	v_add_nc_u32_e32 v127, 0x8000, v113
	v_add_nc_u32_e32 v128, 0xc000, v113
	v_wmma_f32_16x16x16_bf16 v[9:16], v[73:80], v[105:112], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[65:72], v[105:112], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[49:56], v[114:121], v[1:8]
	s_waitcnt vmcnt(12)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[57:64], v[114:121], v[17:24]
	v_add_nc_u32_e32 v157, 0x4000, v156
	v_wmma_f32_16x16x16_bf16 v[9:16], v[49:56], v[132:139], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[57:64], v[132:139], v[25:32]
	v_add_nc_u32_e32 v158, 0x8000, v156
	v_add_nc_u32_e32 v159, 0xc000, v156
	s_barrier
	s_waitcnt vmcnt(3)
	ds_store_b128 v164, v[122:125]
	s_waitcnt vmcnt(2)
	ds_store_b128 v164, v[140:143] offset:1024
	s_waitcnt vmcnt(1)
	ds_store_b128 v164, v[144:147] offset:2048
	s_waitcnt vmcnt(0)
	ds_store_b128 v164, v[148:151] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x3
	buffer_load_b128 v[140:143], v113, s[4:7], 0 offen slc
	buffer_load_b128 v[144:147], v126, s[4:7], 0 offen slc
	buffer_load_b128 v[148:151], v127, s[4:7], 0 offen slc
	buffer_load_b128 v[152:155], v128, s[4:7], 0 offen slc
	s_clause 0x7
	buffer_load_b128 v[73:76], v129, s[8:11], 0 offen offset:3712
	buffer_load_b128 v[77:80], v129, s[8:11], 0 offen offset:3728
	buffer_load_b128 v[105:108], v129, s[8:11], 0 offen offset:3744
	buffer_load_b128 v[109:112], v129, s[8:11], 0 offen offset:3760
	buffer_load_b128 v[97:100], v130, s[8:11], 0 offen offset:3712
	buffer_load_b128 v[101:104], v130, s[8:11], 0 offen offset:3728
	buffer_load_b128 v[113:116], v130, s[8:11], 0 offen offset:3744
	buffer_load_b128 v[117:120], v130, s[8:11], 0 offen offset:3760
	ds_load_u16_d16 v49, v163
	ds_load_u16_d16_hi v49, v163 offset:128
	ds_load_u16_d16 v50, v163 offset:256
	ds_load_u16_d16_hi v50, v163 offset:384
	ds_load_u16_d16_hi v58, v163 offset:448
	ds_load_u16_d16 v58, v163 offset:320
	ds_load_u16_d16_hi v57, v163 offset:192
	ds_load_u16_d16 v57, v163 offset:64
	ds_load_u16_d16 v51, v163 offset:512
	ds_load_u16_d16_hi v51, v163 offset:640
	ds_load_u16_d16 v52, v163 offset:768
	ds_load_u16_d16_hi v52, v163 offset:896
	ds_load_u16_d16_hi v60, v163 offset:960
	ds_load_u16_d16 v60, v163 offset:832
	ds_load_u16_d16_hi v59, v163 offset:704
	ds_load_u16_d16 v59, v163 offset:576
	ds_load_u16_d16 v53, v163 offset:1024
	ds_load_u16_d16_hi v53, v163 offset:1152
	ds_load_u16_d16 v54, v163 offset:1280
	ds_load_u16_d16_hi v54, v163 offset:1408
	ds_load_u16_d16_hi v62, v163 offset:1472
	ds_load_u16_d16 v62, v163 offset:1344
	ds_load_u16_d16_hi v61, v163 offset:1216
	ds_load_u16_d16 v61, v163 offset:1088
	ds_load_u16_d16 v55, v163 offset:1536
	ds_load_u16_d16_hi v55, v163 offset:1664
	ds_load_u16_d16 v56, v163 offset:1792
	ds_load_u16_d16_hi v56, v163 offset:1920
	ds_load_u16_d16_hi v64, v163 offset:1984
	ds_load_u16_d16 v64, v163 offset:1856
	ds_load_u16_d16_hi v63, v163 offset:1728
	ds_load_u16_d16 v63, v163 offset:1600
	ds_load_u16_d16 v121, v163 offset:2048
	ds_load_u16_d16_hi v121, v163 offset:2176
	ds_load_u16_d16 v122, v163 offset:2304
	ds_load_u16_d16_hi v122, v163 offset:2432
	ds_load_u16_d16 v123, v163 offset:2560
	ds_load_u16_d16_hi v123, v163 offset:2688
	ds_load_u16_d16 v124, v163 offset:2816
	ds_load_u16_d16_hi v124, v163 offset:2944
	ds_load_u16_d16 v125, v163 offset:3072
	ds_load_u16_d16 v132, v163 offset:2112
	ds_load_u16_d16_hi v132, v163 offset:2240
	ds_load_u16_d16 v133, v163 offset:2368
	ds_load_u16_d16_hi v133, v163 offset:2496
	ds_load_u16_d16 v134, v163 offset:2624
	ds_load_u16_d16_hi v134, v163 offset:2752
	ds_load_u16_d16 v135, v163 offset:2880
	ds_load_u16_d16_hi v135, v163 offset:3008
	ds_load_u16_d16_hi v125, v163 offset:3200
	ds_load_u16_d16 v126, v163 offset:3328
	ds_load_u16_d16_hi v126, v163 offset:3456
	ds_load_u16_d16 v127, v163 offset:3584
	ds_load_u16_d16_hi v137, v163 offset:3520
	ds_load_u16_d16 v137, v163 offset:3392
	ds_load_u16_d16_hi v136, v163 offset:3264
	ds_load_u16_d16 v136, v163 offset:3136
	ds_load_u16_d16_hi v127, v163 offset:3712
	ds_load_u16_d16 v128, v163 offset:3840
	ds_load_u16_d16_hi v128, v163 offset:3968
	ds_load_u16_d16_hi v139, v163 offset:4032
	ds_load_u16_d16 v139, v163 offset:3904
	ds_load_u16_d16_hi v138, v163 offset:3776
	ds_load_u16_d16 v138, v163 offset:3648
	s_waitcnt lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[81:88], v[49:56], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[89:96], v[49:56], v[17:24]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[81:88], v[57:64], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[89:96], v[57:64], v[25:32]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[33:40], v[121:128], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[41:48], v[121:128], v[17:24]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[33:40], v[132:139], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[41:48], v[132:139], v[25:32]
	s_barrier
	s_waitcnt vmcnt(11)
	ds_store_b128 v164, v[140:143]
	s_waitcnt vmcnt(10)
	ds_store_b128 v164, v[144:147] offset:1024
	s_waitcnt vmcnt(9)
	ds_store_b128 v164, v[148:151] offset:2048
	s_waitcnt vmcnt(8)
	ds_store_b128 v164, v[152:155] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x7
	buffer_load_b128 v[65:68], v129, s[8:11], 0 offen offset:3776
	buffer_load_b128 v[69:72], v129, s[8:11], 0 offen offset:3792
	buffer_load_b128 v[49:52], v129, s[8:11], 0 offen offset:3808
	buffer_load_b128 v[53:56], v129, s[8:11], 0 offen offset:3824
	buffer_load_b128 v[89:92], v130, s[8:11], 0 offen offset:3776
	buffer_load_b128 v[93:96], v130, s[8:11], 0 offen offset:3792
	buffer_load_b128 v[57:60], v130, s[8:11], 0 offen offset:3808
	buffer_load_b128 v[61:64], v130, s[8:11], 0 offen offset:3824
	s_clause 0x3
	buffer_load_b128 v[81:84], v156, s[4:7], 0 offen slc
	buffer_load_b128 v[85:88], v157, s[4:7], 0 offen slc
	buffer_load_b128 v[140:143], v158, s[4:7], 0 offen slc
	buffer_load_b128 v[144:147], v159, s[4:7], 0 offen slc
	ds_load_u16_d16 v33, v163
	ds_load_u16_d16_hi v33, v163 offset:128
	ds_load_u16_d16 v34, v163 offset:256
	ds_load_u16_d16_hi v34, v163 offset:384
	ds_load_u16_d16_hi v42, v163 offset:448
	ds_load_u16_d16 v42, v163 offset:320
	ds_load_u16_d16_hi v41, v163 offset:192
	ds_load_u16_d16 v41, v163 offset:64
	ds_load_u16_d16 v35, v163 offset:512
	ds_load_u16_d16_hi v35, v163 offset:640
	ds_load_u16_d16 v36, v163 offset:768
	ds_load_u16_d16_hi v36, v163 offset:896
	ds_load_u16_d16_hi v44, v163 offset:960
	ds_load_u16_d16 v44, v163 offset:832
	ds_load_u16_d16_hi v43, v163 offset:704
	ds_load_u16_d16 v43, v163 offset:576
	ds_load_u16_d16 v37, v163 offset:1024
	ds_load_u16_d16_hi v37, v163 offset:1152
	ds_load_u16_d16 v38, v163 offset:1280
	ds_load_u16_d16_hi v38, v163 offset:1408
	ds_load_u16_d16_hi v46, v163 offset:1472
	ds_load_u16_d16 v46, v163 offset:1344
	ds_load_u16_d16_hi v45, v163 offset:1216
	ds_load_u16_d16 v45, v163 offset:1088
	ds_load_u16_d16 v39, v163 offset:1536
	ds_load_u16_d16_hi v39, v163 offset:1664
	ds_load_u16_d16 v40, v163 offset:1792
	ds_load_u16_d16_hi v40, v163 offset:1920
	ds_load_u16_d16_hi v48, v163 offset:1984
	ds_load_u16_d16 v48, v163 offset:1856
	ds_load_u16_d16_hi v47, v163 offset:1728
	ds_load_u16_d16 v47, v163 offset:1600
	ds_load_u16_d16 v121, v163 offset:2048
	ds_load_u16_d16_hi v121, v163 offset:2176
	ds_load_u16_d16 v122, v163 offset:2304
	ds_load_u16_d16_hi v122, v163 offset:2432
	ds_load_u16_d16_hi v133, v163 offset:2496
	ds_load_u16_d16 v133, v163 offset:2368
	ds_load_u16_d16_hi v132, v163 offset:2240
	ds_load_u16_d16 v132, v163 offset:2112
	ds_load_u16_d16 v123, v163 offset:2560
	ds_load_u16_d16_hi v123, v163 offset:2688
	ds_load_u16_d16 v124, v163 offset:2816
	ds_load_u16_d16_hi v124, v163 offset:2944
	ds_load_u16_d16_hi v135, v163 offset:3008
	ds_load_u16_d16 v135, v163 offset:2880
	ds_load_u16_d16_hi v134, v163 offset:2752
	ds_load_u16_d16 v134, v163 offset:2624
	ds_load_u16_d16 v125, v163 offset:3072
	ds_load_u16_d16_hi v125, v163 offset:3200
	ds_load_u16_d16 v126, v163 offset:3328
	ds_load_u16_d16_hi v126, v163 offset:3456
	ds_load_u16_d16_hi v137, v163 offset:3520
	ds_load_u16_d16 v137, v163 offset:3392
	ds_load_u16_d16_hi v136, v163 offset:3264
	ds_load_u16_d16 v136, v163 offset:3136
	ds_load_u16_d16 v127, v163 offset:3584
	ds_load_u16_d16_hi v127, v163 offset:3712
	ds_load_u16_d16 v128, v163 offset:3840
	ds_load_u16_d16_hi v128, v163 offset:3968
	ds_load_u16_d16_hi v139, v163 offset:4032
	ds_load_u16_d16 v139, v163 offset:3904
	ds_load_u16_d16_hi v138, v163 offset:3776
	ds_load_u16_d16 v138, v163 offset:3648
	v_add_nc_u32_e32 v148, 0x3c0000, v131
	s_waitcnt vmcnt(18) lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[73:80], v[33:40], v[1:8]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[73:80], v[41:48], v[9:16]
	s_waitcnt vmcnt(14)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[97:104], v[33:40], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[97:104], v[41:48], v[25:32]
	v_add_nc_u32_e32 v149, 0x4000, v148
	v_add_nc_u32_e32 v150, 0x8000, v148
	v_add_nc_u32_e32 v152, 0xc000, v148
	v_add_nc_u32_e32 v156, 0x3d0000, v131
	s_delay_alu instid0(VALU_DEP_1)
	v_add_nc_u32_e32 v157, 0x4000, v156
	v_add_nc_u32_e32 v158, 0x8000, v156
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[105:112], v[121:128], v[1:8]
	s_waitcnt vmcnt(12)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[113:120], v[121:128], v[17:24]
	v_add_nc_u32_e32 v159, 0xc000, v156
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[105:112], v[132:139], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[113:120], v[132:139], v[25:32]
	s_barrier
	s_waitcnt vmcnt(3)
	ds_store_b128 v164, v[81:84]
	s_waitcnt vmcnt(2)
	ds_store_b128 v164, v[85:88] offset:1024
	s_waitcnt vmcnt(1)
	ds_store_b128 v164, v[140:143] offset:2048
	s_waitcnt vmcnt(0)
	ds_store_b128 v164, v[144:147] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x7
	buffer_load_b128 v[41:44], v129, s[8:11], 0 offen offset:3840
	buffer_load_b128 v[45:48], v129, s[8:11], 0 offen offset:3856
	buffer_load_b128 v[73:76], v129, s[8:11], 0 offen offset:3872
	buffer_load_b128 v[77:80], v129, s[8:11], 0 offen offset:3888
	buffer_load_b128 v[97:100], v130, s[8:11], 0 offen offset:3840
	buffer_load_b128 v[101:104], v130, s[8:11], 0 offen offset:3856
	buffer_load_b128 v[81:84], v130, s[8:11], 0 offen offset:3872
	buffer_load_b128 v[85:88], v130, s[8:11], 0 offen offset:3888
	s_clause 0x3
	buffer_load_b128 v[140:143], v148, s[4:7], 0 offen slc
	buffer_load_b128 v[144:147], v149, s[4:7], 0 offen slc
	buffer_load_b128 v[148:151], v150, s[4:7], 0 offen slc
	buffer_load_b128 v[152:155], v152, s[4:7], 0 offen slc
	ds_load_u16_d16 v33, v163
	ds_load_u16_d16_hi v33, v163 offset:128
	ds_load_u16_d16 v34, v163 offset:256
	ds_load_u16_d16_hi v34, v163 offset:384
	ds_load_u16_d16_hi v106, v163 offset:448
	ds_load_u16_d16 v106, v163 offset:320
	ds_load_u16_d16_hi v105, v163 offset:192
	ds_load_u16_d16 v105, v163 offset:64
	ds_load_u16_d16 v35, v163 offset:512
	ds_load_u16_d16_hi v35, v163 offset:640
	ds_load_u16_d16 v36, v163 offset:768
	ds_load_u16_d16_hi v36, v163 offset:896
	ds_load_u16_d16_hi v108, v163 offset:960
	ds_load_u16_d16 v108, v163 offset:832
	ds_load_u16_d16_hi v107, v163 offset:704
	ds_load_u16_d16 v107, v163 offset:576
	ds_load_u16_d16 v37, v163 offset:1024
	ds_load_u16_d16_hi v37, v163 offset:1152
	ds_load_u16_d16 v38, v163 offset:1280
	ds_load_u16_d16_hi v38, v163 offset:1408
	ds_load_u16_d16_hi v110, v163 offset:1472
	ds_load_u16_d16 v110, v163 offset:1344
	ds_load_u16_d16_hi v109, v163 offset:1216
	ds_load_u16_d16 v109, v163 offset:1088
	ds_load_u16_d16 v39, v163 offset:1536
	ds_load_u16_d16_hi v39, v163 offset:1664
	ds_load_u16_d16 v40, v163 offset:1792
	ds_load_u16_d16_hi v40, v163 offset:1920
	ds_load_u16_d16_hi v112, v163 offset:1984
	ds_load_u16_d16 v112, v163 offset:1856
	ds_load_u16_d16_hi v111, v163 offset:1728
	ds_load_u16_d16 v111, v163 offset:1600
	ds_load_u16_d16 v121, v163 offset:2048
	ds_load_u16_d16_hi v121, v163 offset:2176
	ds_load_u16_d16 v122, v163 offset:2304
	ds_load_u16_d16_hi v122, v163 offset:2432
	ds_load_u16_d16_hi v133, v163 offset:2496
	ds_load_u16_d16 v133, v163 offset:2368
	ds_load_u16_d16_hi v132, v163 offset:2240
	ds_load_u16_d16 v132, v163 offset:2112
	ds_load_u16_d16 v123, v163 offset:2560
	ds_load_u16_d16_hi v123, v163 offset:2688
	ds_load_u16_d16 v124, v163 offset:2816
	ds_load_u16_d16_hi v124, v163 offset:2944
	ds_load_u16_d16_hi v135, v163 offset:3008
	ds_load_u16_d16 v135, v163 offset:2880
	ds_load_u16_d16_hi v134, v163 offset:2752
	ds_load_u16_d16 v134, v163 offset:2624
	ds_load_u16_d16 v125, v163 offset:3072
	ds_load_u16_d16_hi v125, v163 offset:3200
	ds_load_u16_d16 v126, v163 offset:3328
	ds_load_u16_d16_hi v126, v163 offset:3456
	ds_load_u16_d16_hi v137, v163 offset:3520
	ds_load_u16_d16 v137, v163 offset:3392
	ds_load_u16_d16_hi v136, v163 offset:3264
	ds_load_u16_d16 v136, v163 offset:3136
	ds_load_u16_d16 v127, v163 offset:3584
	ds_load_u16_d16_hi v127, v163 offset:3712
	ds_load_u16_d16 v128, v163 offset:3840
	ds_load_u16_d16_hi v128, v163 offset:3968
	ds_load_u16_d16_hi v139, v163 offset:4032
	ds_load_u16_d16 v139, v163 offset:3904
	ds_load_u16_d16_hi v138, v163 offset:3776
	ds_load_u16_d16 v138, v163 offset:3648
	s_waitcnt lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[65:72], v[33:40], v[1:8]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[65:72], v[105:112], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[89:96], v[33:40], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[89:96], v[105:112], v[25:32]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[49:56], v[121:128], v[1:8]
	s_delay_alu instid0(VALU_DEP_3)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[57:64], v[121:128], v[17:24]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[49:56], v[132:139], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[57:64], v[132:139], v[25:32]
	s_barrier
	s_waitcnt vmcnt(3)
	ds_store_b128 v164, v[140:143]
	s_waitcnt vmcnt(2)
	ds_store_b128 v164, v[144:147] offset:1024
	s_waitcnt vmcnt(1)
	ds_store_b128 v164, v[148:151] offset:2048
	s_waitcnt vmcnt(0)
	ds_store_b128 v164, v[152:155] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x7
	buffer_load_b128 v[89:92], v129, s[8:11], 0 offen offset:3904
	buffer_load_b128 v[93:96], v129, s[8:11], 0 offen offset:3920
	buffer_load_b128 v[105:108], v129, s[8:11], 0 offen offset:3936
	buffer_load_b128 v[109:112], v129, s[8:11], 0 offen offset:3952
	buffer_load_b128 v[113:116], v130, s[8:11], 0 offen offset:3904
	buffer_load_b128 v[117:120], v130, s[8:11], 0 offen offset:3920
	buffer_load_b128 v[33:36], v130, s[8:11], 0 offen offset:3936
	buffer_load_b128 v[37:40], v130, s[8:11], 0 offen offset:3952
	s_clause 0x3
	buffer_load_b128 v[65:68], v156, s[4:7], 0 offen slc
	buffer_load_b128 v[69:72], v157, s[4:7], 0 offen slc
	buffer_load_b128 v[140:143], v158, s[4:7], 0 offen slc
	buffer_load_b128 v[144:147], v159, s[4:7], 0 offen slc
	ds_load_u16_d16 v49, v163
	ds_load_u16_d16_hi v49, v163 offset:128
	ds_load_u16_d16 v50, v163 offset:256
	ds_load_u16_d16_hi v50, v163 offset:384
	ds_load_u16_d16_hi v58, v163 offset:448
	ds_load_u16_d16 v58, v163 offset:320
	ds_load_u16_d16_hi v57, v163 offset:192
	ds_load_u16_d16 v57, v163 offset:64
	ds_load_u16_d16 v51, v163 offset:512
	ds_load_u16_d16_hi v51, v163 offset:640
	ds_load_u16_d16 v52, v163 offset:768
	ds_load_u16_d16_hi v52, v163 offset:896
	ds_load_u16_d16_hi v60, v163 offset:960
	ds_load_u16_d16 v60, v163 offset:832
	ds_load_u16_d16_hi v59, v163 offset:704
	ds_load_u16_d16 v59, v163 offset:576
	ds_load_u16_d16 v53, v163 offset:1024
	ds_load_u16_d16_hi v53, v163 offset:1152
	ds_load_u16_d16 v54, v163 offset:1280
	ds_load_u16_d16_hi v54, v163 offset:1408
	ds_load_u16_d16_hi v62, v163 offset:1472
	ds_load_u16_d16 v62, v163 offset:1344
	ds_load_u16_d16_hi v61, v163 offset:1216
	ds_load_u16_d16 v61, v163 offset:1088
	ds_load_u16_d16 v55, v163 offset:1536
	ds_load_u16_d16_hi v55, v163 offset:1664
	ds_load_u16_d16 v56, v163 offset:1792
	ds_load_u16_d16_hi v56, v163 offset:1920
	ds_load_u16_d16_hi v64, v163 offset:1984
	ds_load_u16_d16 v64, v163 offset:1856
	ds_load_u16_d16_hi v63, v163 offset:1728
	ds_load_u16_d16 v63, v163 offset:1600
	ds_load_u16_d16 v121, v163 offset:2048
	ds_load_u16_d16_hi v121, v163 offset:2176
	ds_load_u16_d16 v122, v163 offset:2304
	ds_load_u16_d16_hi v122, v163 offset:2432
	ds_load_u16_d16_hi v133, v163 offset:2496
	ds_load_u16_d16 v133, v163 offset:2368
	ds_load_u16_d16_hi v132, v163 offset:2240
	ds_load_u16_d16 v132, v163 offset:2112
	ds_load_u16_d16 v123, v163 offset:2560
	ds_load_u16_d16_hi v123, v163 offset:2688
	ds_load_u16_d16 v124, v163 offset:2816
	ds_load_u16_d16_hi v124, v163 offset:2944
	ds_load_u16_d16_hi v135, v163 offset:3008
	ds_load_u16_d16 v135, v163 offset:2880
	ds_load_u16_d16_hi v134, v163 offset:2752
	ds_load_u16_d16 v134, v163 offset:2624
	ds_load_u16_d16 v125, v163 offset:3072
	ds_load_u16_d16_hi v125, v163 offset:3200
	ds_load_u16_d16 v126, v163 offset:3328
	ds_load_u16_d16_hi v126, v163 offset:3456
	ds_load_u16_d16_hi v137, v163 offset:3520
	ds_load_u16_d16 v137, v163 offset:3392
	ds_load_u16_d16_hi v136, v163 offset:3264
	ds_load_u16_d16 v136, v163 offset:3136
	ds_load_u16_d16 v127, v163 offset:3584
	ds_load_u16_d16_hi v127, v163 offset:3712
	ds_load_u16_d16 v128, v163 offset:3840
	ds_load_u16_d16_hi v128, v163 offset:3968
	ds_load_u16_d16_hi v139, v163 offset:4032
	ds_load_u16_d16 v139, v163 offset:3904
	ds_load_u16_d16_hi v138, v163 offset:3776
	ds_load_u16_d16 v138, v163 offset:3648
	v_add_nc_u32_e32 v148, 0x3e0000, v131
	s_waitcnt lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[41:48], v[49:56], v[1:8]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[41:48], v[57:64], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[97:104], v[49:56], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[97:104], v[57:64], v[25:32]
	v_add_nc_u32_e32 v149, 0x4000, v148
	v_add_nc_u32_e32 v150, 0x8000, v148
	v_add_nc_u32_e32 v151, 0xc000, v148
	v_add_nc_u32_e32 v131, 0x3f0000, v131
	s_delay_alu instid0(VALU_DEP_1)
	v_add_nc_u32_e32 v153, 0x8000, v131
	v_add_nc_u32_e32 v157, 0xc000, v131
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[73:80], v[121:128], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[81:88], v[121:128], v[17:24]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[73:80], v[132:139], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[81:88], v[132:139], v[25:32]
	s_barrier
	s_waitcnt vmcnt(3)
	ds_store_b128 v164, v[65:68]
	s_waitcnt vmcnt(2)
	ds_store_b128 v164, v[69:72] offset:1024
	s_waitcnt vmcnt(1)
	ds_store_b128 v164, v[140:143] offset:2048
	s_waitcnt vmcnt(0)
	ds_store_b128 v164, v[144:147] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x7
	buffer_load_b128 v[65:68], v129, s[8:11], 0 offen offset:3968
	buffer_load_b128 v[69:72], v129, s[8:11], 0 offen offset:3984
	buffer_load_b128 v[41:44], v129, s[8:11], 0 offen offset:4000
	buffer_load_b128 v[45:48], v129, s[8:11], 0 offen offset:4016
	buffer_load_b128 v[57:60], v130, s[8:11], 0 offen offset:3968
	buffer_load_b128 v[61:64], v130, s[8:11], 0 offen offset:3984
	buffer_load_b128 v[49:52], v130, s[8:11], 0 offen offset:4000
	buffer_load_b128 v[53:56], v130, s[8:11], 0 offen offset:4016
	s_clause 0x3
	buffer_load_b128 v[97:100], v148, s[4:7], 0 offen slc
	buffer_load_b128 v[101:104], v149, s[4:7], 0 offen slc
	buffer_load_b128 v[140:143], v150, s[4:7], 0 offen slc
	buffer_load_b128 v[144:147], v151, s[4:7], 0 offen slc
	ds_load_u16_d16 v73, v163
	ds_load_u16_d16_hi v73, v163 offset:128
	ds_load_u16_d16 v74, v163 offset:256
	ds_load_u16_d16_hi v74, v163 offset:384
	ds_load_u16_d16_hi v133, v163 offset:448
	ds_load_u16_d16 v133, v163 offset:320
	ds_load_u16_d16_hi v132, v163 offset:192
	ds_load_u16_d16 v132, v163 offset:64
	ds_load_u16_d16 v75, v163 offset:512
	ds_load_u16_d16_hi v75, v163 offset:640
	ds_load_u16_d16 v76, v163 offset:768
	ds_load_u16_d16_hi v76, v163 offset:896
	ds_load_u16_d16_hi v135, v163 offset:960
	ds_load_u16_d16 v135, v163 offset:832
	ds_load_u16_d16_hi v134, v163 offset:704
	ds_load_u16_d16 v134, v163 offset:576
	ds_load_u16_d16 v77, v163 offset:1024
	ds_load_u16_d16_hi v77, v163 offset:1152
	ds_load_u16_d16 v78, v163 offset:1280
	ds_load_u16_d16_hi v78, v163 offset:1408
	ds_load_u16_d16_hi v137, v163 offset:1472
	ds_load_u16_d16 v137, v163 offset:1344
	ds_load_u16_d16_hi v136, v163 offset:1216
	ds_load_u16_d16 v136, v163 offset:1088
	ds_load_u16_d16 v79, v163 offset:1536
	ds_load_u16_d16_hi v79, v163 offset:1664
	ds_load_u16_d16 v80, v163 offset:1792
	ds_load_u16_d16_hi v80, v163 offset:1920
	ds_load_u16_d16_hi v139, v163 offset:1984
	ds_load_u16_d16 v139, v163 offset:1856
	ds_load_u16_d16_hi v138, v163 offset:1728
	ds_load_u16_d16 v138, v163 offset:1600
	ds_load_u16_d16 v165, v163 offset:2048
	ds_load_u16_d16_hi v165, v163 offset:2176
	ds_load_u16_d16 v166, v163 offset:2304
	ds_load_u16_d16_hi v166, v163 offset:2432
	ds_load_u16_d16_hi v122, v163 offset:2496
	ds_load_u16_d16 v122, v163 offset:2368
	ds_load_u16_d16_hi v121, v163 offset:2240
	ds_load_u16_d16 v121, v163 offset:2112
	ds_load_u16_d16 v167, v163 offset:2560
	ds_load_u16_d16_hi v167, v163 offset:2688
	ds_load_u16_d16 v168, v163 offset:2816
	ds_load_u16_d16_hi v168, v163 offset:2944
	ds_load_u16_d16_hi v124, v163 offset:3008
	ds_load_u16_d16 v124, v163 offset:2880
	ds_load_u16_d16_hi v123, v163 offset:2752
	ds_load_u16_d16 v123, v163 offset:2624
	ds_load_u16_d16 v169, v163 offset:3072
	ds_load_u16_d16_hi v169, v163 offset:3200
	ds_load_u16_d16 v170, v163 offset:3328
	ds_load_u16_d16_hi v170, v163 offset:3456
	ds_load_u16_d16_hi v126, v163 offset:3520
	ds_load_u16_d16 v126, v163 offset:3392
	ds_load_u16_d16_hi v125, v163 offset:3264
	ds_load_u16_d16 v125, v163 offset:3136
	ds_load_u16_d16 v171, v163 offset:3584
	ds_load_u16_d16_hi v171, v163 offset:3712
	ds_load_u16_d16 v172, v163 offset:3840
	ds_load_u16_d16_hi v172, v163 offset:3968
	ds_load_u16_d16_hi v128, v163 offset:4032
	ds_load_u16_d16 v128, v163 offset:3904
	ds_load_u16_d16_hi v127, v163 offset:3776
	ds_load_u16_d16 v127, v163 offset:3648
	v_add_nc_u32_e32 v149, 0x4000, v131
	s_waitcnt lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[89:96], v[73:80], v[1:8]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[89:96], v[132:139], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[113:120], v[73:80], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[113:120], v[132:139], v[25:32]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[105:112], v[165:172], v[1:8]
	s_delay_alu instid0(VALU_DEP_3)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[33:40], v[165:172], v[17:24]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[105:112], v[121:128], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[33:40], v[121:128], v[25:32]
	v_lshlrev_b32_e32 v35, 5, v0
	v_or_b32_e32 v33, s16, v0
	v_mov_b32_e32 v38, 1
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v34, 31, v33
	v_lshlrev_b64 v[33:34], 2, v[33:34]
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v33, vcc_lo, s14, v33
	v_add_co_ci_u32_e64 v34, null, s15, v34, vcc_lo
	s_barrier
	s_waitcnt vmcnt(3)
	ds_store_b128 v164, v[97:100]
	s_waitcnt vmcnt(2)
	ds_store_b128 v164, v[101:104] offset:1024
	s_waitcnt vmcnt(1)
	ds_store_b128 v164, v[140:143] offset:2048
	s_waitcnt vmcnt(0)
	ds_store_b128 v164, v[144:147] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_clause 0x7
	buffer_load_b128 v[89:92], v129, s[8:11], 0 offen offset:4032
	buffer_load_b128 v[93:96], v129, s[8:11], 0 offen offset:4048
	buffer_load_b128 v[73:76], v129, s[8:11], 0 offen offset:4064
	buffer_load_b128 v[77:80], v129, s[8:11], 0 offen offset:4080
	buffer_load_b128 v[97:100], v130, s[8:11], 0 offen offset:4032
	buffer_load_b128 v[101:104], v130, s[8:11], 0 offen offset:4048
	buffer_load_b128 v[81:84], v130, s[8:11], 0 offen offset:4064
	buffer_load_b128 v[85:88], v130, s[8:11], 0 offen offset:4080
	s_clause 0x3
	buffer_load_b128 v[145:148], v131, s[4:7], 0 offen slc
	buffer_load_b128 v[149:152], v149, s[4:7], 0 offen slc
	buffer_load_b128 v[153:156], v153, s[4:7], 0 offen slc
	buffer_load_b128 v[157:160], v157, s[4:7], 0 offen slc
	ds_load_u16_d16 v105, v163
	ds_load_u16_d16_hi v105, v163 offset:128
	ds_load_u16_d16 v106, v163 offset:256
	ds_load_u16_d16_hi v106, v163 offset:384
	ds_load_u16_d16_hi v114, v163 offset:448
	ds_load_u16_d16 v114, v163 offset:320
	ds_load_u16_d16_hi v113, v163 offset:192
	ds_load_u16_d16 v113, v163 offset:64
	ds_load_u16_d16 v107, v163 offset:512
	ds_load_u16_d16_hi v107, v163 offset:640
	ds_load_u16_d16 v108, v163 offset:768
	ds_load_u16_d16_hi v108, v163 offset:896
	ds_load_u16_d16_hi v116, v163 offset:960
	ds_load_u16_d16 v116, v163 offset:832
	ds_load_u16_d16_hi v115, v163 offset:704
	ds_load_u16_d16 v115, v163 offset:576
	ds_load_u16_d16 v109, v163 offset:1024
	ds_load_u16_d16_hi v109, v163 offset:1152
	ds_load_u16_d16 v110, v163 offset:1280
	ds_load_u16_d16_hi v110, v163 offset:1408
	ds_load_u16_d16_hi v118, v163 offset:1472
	ds_load_u16_d16 v118, v163 offset:1344
	ds_load_u16_d16_hi v117, v163 offset:1216
	ds_load_u16_d16 v117, v163 offset:1088
	ds_load_u16_d16 v111, v163 offset:1536
	ds_load_u16_d16_hi v111, v163 offset:1664
	ds_load_u16_d16 v112, v163 offset:1792
	ds_load_u16_d16_hi v112, v163 offset:1920
	ds_load_u16_d16_hi v120, v163 offset:1984
	ds_load_u16_d16 v120, v163 offset:1856
	ds_load_u16_d16_hi v119, v163 offset:1728
	ds_load_u16_d16 v119, v163 offset:1600
	ds_load_u16_d16 v129, v163 offset:2048
	ds_load_u16_d16_hi v129, v163 offset:2176
	ds_load_u16_d16 v130, v163 offset:2304
	ds_load_u16_d16_hi v130, v163 offset:2432
	ds_load_u16_d16_hi v138, v163 offset:2496
	ds_load_u16_d16 v138, v163 offset:2368
	ds_load_u16_d16_hi v137, v163 offset:2240
	ds_load_u16_d16 v137, v163 offset:2112
	ds_load_u16_d16 v131, v163 offset:2560
	ds_load_u16_d16_hi v131, v163 offset:2688
	ds_load_u16_d16 v132, v163 offset:2816
	ds_load_u16_d16_hi v132, v163 offset:2944
	ds_load_u16_d16_hi v140, v163 offset:3008
	ds_load_u16_d16 v140, v163 offset:2880
	ds_load_u16_d16_hi v139, v163 offset:2752
	ds_load_u16_d16 v139, v163 offset:2624
	ds_load_u16_d16 v133, v163 offset:3072
	ds_load_u16_d16_hi v133, v163 offset:3200
	ds_load_u16_d16 v134, v163 offset:3328
	ds_load_u16_d16_hi v134, v163 offset:3456
	ds_load_u16_d16_hi v142, v163 offset:3520
	ds_load_u16_d16 v142, v163 offset:3392
	ds_load_u16_d16_hi v141, v163 offset:3264
	ds_load_u16_d16 v141, v163 offset:3136
	ds_load_u16_d16 v135, v163 offset:3584
	ds_load_u16_d16_hi v135, v163 offset:3712
	ds_load_u16_d16 v136, v163 offset:3840
	ds_load_u16_d16_hi v136, v163 offset:3968
	ds_load_u16_d16_hi v144, v163 offset:4032
	ds_load_u16_d16 v144, v163 offset:3904
	ds_load_u16_d16_hi v143, v163 offset:3776
	ds_load_u16_d16 v143, v163 offset:3648
	s_waitcnt lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[65:72], v[105:112], v[1:8]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[65:72], v[113:120], v[9:16]
	s_lshr_b32 s4, s17, 26
	v_wmma_f32_16x16x16_bf16 v[17:24], v[57:64], v[105:112], v[17:24]
	s_add_i32 s4, s2, s4
	v_wmma_f32_16x16x16_bf16 v[25:32], v[57:64], v[113:120], v[25:32]
	s_and_b32 s4, s4, 0x1fffc0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_sub_i32 s2, s2, s4
	v_lshl_or_b32 v36, s2, 11, v35
	s_mov_b32 s2, exec_lo
	s_delay_alu instid0(VALU_DEP_1)
	v_ashrrev_i32_e32 v37, 31, v36
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[41:48], v[129:136], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[49:56], v[129:136], v[17:24]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[41:48], v[137:144], v[9:16]
	v_lshlrev_b64 v[36:37], 2, v[36:37]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[49:56], v[137:144], v[25:32]
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v36, vcc_lo, s12, v36
	v_add_co_ci_u32_e64 v37, null, s13, v37, vcc_lo
	s_barrier
	s_waitcnt vmcnt(3)
	ds_store_b128 v164, v[145:148]
	s_waitcnt vmcnt(2)
	ds_store_b128 v164, v[149:152] offset:1024
	s_waitcnt vmcnt(1)
	ds_store_b128 v164, v[153:156] offset:2048
	s_waitcnt vmcnt(0)
	ds_store_b128 v164, v[157:160] offset:3072
	s_waitcnt lgkmcnt(0)
	s_barrier
	ds_load_u16_d16 v65, v163
	ds_load_u16_d16_hi v65, v163 offset:128
	ds_load_u16_d16 v66, v163 offset:256
	ds_load_u16_d16_hi v66, v163 offset:384
	ds_load_u16_d16_hi v122, v163 offset:448
	ds_load_u16_d16 v122, v163 offset:320
	ds_load_u16_d16_hi v121, v163 offset:192
	ds_load_u16_d16 v121, v163 offset:64
	ds_load_u16_d16 v67, v163 offset:512
	ds_load_u16_d16_hi v67, v163 offset:640
	ds_load_u16_d16 v68, v163 offset:768
	ds_load_u16_d16_hi v68, v163 offset:896
	ds_load_u16_d16_hi v124, v163 offset:960
	ds_load_u16_d16 v124, v163 offset:832
	ds_load_u16_d16_hi v123, v163 offset:704
	ds_load_u16_d16 v123, v163 offset:576
	ds_load_u16_d16 v69, v163 offset:1024
	ds_load_u16_d16_hi v69, v163 offset:1152
	ds_load_u16_d16 v70, v163 offset:1280
	ds_load_u16_d16_hi v70, v163 offset:1408
	ds_load_u16_d16_hi v126, v163 offset:1472
	ds_load_u16_d16 v126, v163 offset:1344
	ds_load_u16_d16_hi v125, v163 offset:1216
	ds_load_u16_d16 v125, v163 offset:1088
	ds_load_u16_d16 v71, v163 offset:1536
	ds_load_u16_d16_hi v71, v163 offset:1664
	ds_load_u16_d16 v72, v163 offset:1792
	ds_load_u16_d16_hi v72, v163 offset:1920
	ds_load_u16_d16_hi v128, v163 offset:1984
	ds_load_u16_d16 v128, v163 offset:1856
	ds_load_u16_d16_hi v127, v163 offset:1728
	ds_load_u16_d16 v127, v163 offset:1600
	ds_load_u16_d16 v145, v163 offset:2048
	ds_load_u16_d16_hi v145, v163 offset:2176
	ds_load_u16_d16 v146, v163 offset:2304
	ds_load_u16_d16_hi v146, v163 offset:2432
	ds_load_u16_d16_hi v154, v163 offset:2496
	ds_load_u16_d16 v154, v163 offset:2368
	ds_load_u16_d16_hi v153, v163 offset:2240
	ds_load_u16_d16 v153, v163 offset:2112
	ds_load_u16_d16 v147, v163 offset:2560
	ds_load_u16_d16_hi v147, v163 offset:2688
	ds_load_u16_d16 v148, v163 offset:2816
	ds_load_u16_d16_hi v148, v163 offset:2944
	ds_load_u16_d16_hi v156, v163 offset:3008
	ds_load_u16_d16 v156, v163 offset:2880
	ds_load_u16_d16_hi v155, v163 offset:2752
	ds_load_u16_d16 v155, v163 offset:2624
	ds_load_u16_d16 v149, v163 offset:3072
	ds_load_u16_d16_hi v149, v163 offset:3200
	ds_load_u16_d16 v150, v163 offset:3328
	ds_load_u16_d16_hi v150, v163 offset:3456
	ds_load_u16_d16_hi v158, v163 offset:3520
	ds_load_u16_d16 v158, v163 offset:3392
	ds_load_u16_d16_hi v157, v163 offset:3264
	ds_load_u16_d16 v157, v163 offset:3136
	ds_load_u16_d16 v151, v163 offset:3584
	ds_load_u16_d16_hi v151, v163 offset:3712
	ds_load_u16_d16 v152, v163 offset:3840
	ds_load_u16_d16_hi v152, v163 offset:3968
	ds_load_u16_d16_hi v160, v163 offset:4032
	ds_load_u16_d16 v160, v163 offset:3904
	ds_load_u16_d16_hi v159, v163 offset:3776
	ds_load_u16_d16 v159, v163 offset:3648
	s_waitcnt lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[89:96], v[65:72], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[97:104], v[65:72], v[17:24]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[89:96], v[121:128], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[97:104], v[121:128], v[25:32]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[73:80], v[145:152], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[81:88], v[145:152], v[17:24]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[73:80], v[153:160], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[81:88], v[153:160], v[25:32]
	s_barrier
	s_clause 0x7
	global_store_b128 v[36:37], v[5:8], off offset:16
	global_store_b128 v[36:37], v[1:4], off
	global_store_b128 v[36:37], v[21:24], off offset:80
	global_store_b128 v[36:37], v[17:20], off offset:64
	global_store_b128 v[36:37], v[13:16], off offset:48
	global_store_b128 v[36:37], v[9:12], off offset:32
	global_store_b128 v[36:37], v[29:32], off offset:112
	global_store_b128 v[36:37], v[25:28], off offset:96
	s_waitcnt_vscnt null, 0x0
	global_atomic_add_u32 v1, v[33:34], v38, off glc
	s_waitcnt vmcnt(0)
	buffer_gl1_inv
	buffer_gl0_inv
	v_cmpx_eq_u32_e32 3, v1
	s_cbranch_execz .LBB0_4
	v_lshl_or_b32 v1, s3, 13, v35
	s_load_b64 s[0:1], s[0:1], 0x30
	s_mov_b32 s3, 0x21027000
	s_mov_b32 s2, -1
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v2, 31, v1
	v_lshlrev_b64 v[1:2], 2, v[1:2]
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v107, vcc_lo, s12, v1
	v_add_co_ci_u32_e64 v108, null, s13, v2, vcc_lo
	s_clause 0x6
	global_load_b128 v[1:4], v[107:108], off
	global_load_b128 v[5:8], v[107:108], off offset:16
	global_load_b128 v[9:12], v[107:108], off offset:64
	global_load_b128 v[13:16], v[107:108], off offset:80
	global_load_b128 v[17:20], v[107:108], off offset:32
	global_load_b128 v[21:24], v[107:108], off offset:48
	global_load_b128 v[25:28], v[107:108], off offset:96
	v_add_co_u32 v55, vcc_lo, 0x2000, v107
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v56, null, 0, v108, vcc_lo
	v_add_co_u32 v63, vcc_lo, 0x2040, v107
	v_add_co_ci_u32_e64 v64, null, 0, v108, vcc_lo
	v_add_co_u32 v87, vcc_lo, 0x4000, v107
	s_clause 0x2
	global_load_b128 v[29:32], v[107:108], off offset:112
	global_load_b128 v[35:38], v[55:56], off
	global_load_b128 v[39:42], v[55:56], off offset:16
	v_add_co_ci_u32_e64 v88, null, 0, v108, vcc_lo
	v_add_co_u32 v95, vcc_lo, 0x4040, v107
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v96, null, 0, v108, vcc_lo
	v_add_co_u32 v119, vcc_lo, 0x6000, v107
	s_clause 0x7
	global_load_b128 v[43:46], v[55:56], off offset:64
	global_load_b128 v[47:50], v[63:64], off offset:16
	global_load_b128 v[51:54], v[55:56], off offset:32
	global_load_b128 v[55:58], v[55:56], off offset:48
	global_load_b128 v[59:62], v[63:64], off offset:32
	global_load_b128 v[63:66], v[63:64], off offset:48
	global_load_b128 v[67:70], v[87:88], off
	global_load_b128 v[71:74], v[87:88], off offset:16
	v_add_co_ci_u32_e64 v120, null, 0, v108, vcc_lo
	s_clause 0x7
	global_load_b128 v[75:78], v[87:88], off offset:64
	global_load_b128 v[79:82], v[95:96], off offset:16
	global_load_b128 v[83:86], v[87:88], off offset:32
	global_load_b128 v[87:90], v[87:88], off offset:48
	global_load_b128 v[91:94], v[95:96], off offset:32
	global_load_b128 v[95:98], v[95:96], off offset:48
	global_load_b128 v[99:102], v[119:120], off
	global_load_b128 v[103:106], v[119:120], off offset:16
	v_add_co_u32 v127, vcc_lo, 0x6040, v107
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v128, null, 0, v108, vcc_lo
	s_clause 0x5
	global_load_b128 v[107:110], v[119:120], off offset:64
	global_load_b128 v[111:114], v[127:128], off offset:16
	global_load_b128 v[115:118], v[119:120], off offset:32
	global_load_b128 v[119:122], v[119:120], off offset:48
	global_load_b128 v[123:126], v[127:128], off offset:32
	global_load_b128 v[127:130], v[127:128], off offset:48
	v_lshlrev_b32_e32 v0, 6, v0
	s_waitcnt lgkmcnt(0)
	s_and_b32 s1, s1, 0xffff
	s_waitcnt vmcnt(31)
	v_dual_add_f32 v1, 0, v1 :: v_dual_add_f32 v2, 0, v2
	v_dual_add_f32 v3, 0, v3 :: v_dual_add_f32 v4, 0, v4
	s_waitcnt vmcnt(30)
	v_dual_add_f32 v5, 0, v5 :: v_dual_add_f32 v6, 0, v6
	v_dual_add_f32 v7, 0, v7 :: v_dual_add_f32 v8, 0, v8
	s_waitcnt vmcnt(29)
	v_dual_add_f32 v9, 0, v9 :: v_dual_add_f32 v10, 0, v10
	v_dual_add_f32 v11, 0, v11 :: v_dual_add_f32 v12, 0, v12
	s_waitcnt vmcnt(28)
	v_dual_add_f32 v13, 0, v13 :: v_dual_add_f32 v14, 0, v14
	s_waitcnt vmcnt(24)
	v_dual_add_f32 v15, 0, v15 :: v_dual_add_f32 v32, 0, v32
	s_waitcnt vmcnt(23)
	v_dual_add_f32 v1, v1, v35 :: v_dual_add_f32 v2, v2, v36
	v_dual_add_f32 v3, v3, v37 :: v_dual_add_f32 v4, v4, v38
	s_waitcnt vmcnt(22)
	v_dual_add_f32 v5, v5, v39 :: v_dual_add_f32 v6, v6, v40
	v_dual_add_f32 v7, v7, v41 :: v_dual_add_f32 v8, v8, v42
	s_waitcnt vmcnt(16)
	v_dual_add_f32 v9, v9, v43 :: v_dual_add_f32 v32, v32, v66
	s_waitcnt vmcnt(15)
	v_dual_add_f32 v1, v1, v67 :: v_dual_add_f32 v2, v2, v68
	v_dual_add_f32 v3, v3, v69 :: v_dual_add_f32 v4, v4, v70
	s_waitcnt vmcnt(8)
	v_dual_add_f32 v5, v5, v71 :: v_dual_add_f32 v32, v32, v98
	s_waitcnt vmcnt(7)
	v_dual_add_f32 v1, v1, v99 :: v_dual_add_f32 v2, v2, v100
	v_dual_add_f32 v3, v3, v101 :: v_dual_add_f32 v4, v4, v102
	s_waitcnt vmcnt(6)
	v_add_f32_e32 v5, v5, v103
	s_delay_alu instid0(VALU_DEP_3)
	v_bfe_u32 v35, v1, 16, 1
	v_or_b32_e32 v36, 0x400000, v1
	v_bfe_u32 v37, v2, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	v_or_b32_e32 v38, 0x400000, v2
	v_add3_u32 v35, v35, v1, 0x7fff
	s_waitcnt vmcnt(0)
	v_add_f32_e32 v32, v32, v130
	v_bfe_u32 v39, v3, 16, 1
	v_add3_u32 v37, v37, v2, 0x7fff
	v_dual_add_f32 v6, v6, v72 :: v_dual_add_f32 v7, v7, v73
	v_cndmask_b32_e32 v1, v35, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_or_b32_e32 v40, 0x400000, v3
	v_bfe_u32 v41, v4, 16, 1
	v_add3_u32 v39, v39, v3, 0x7fff
	v_dual_add_f32 v6, v6, v104 :: v_dual_add_f32 v7, v7, v105
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
	v_dual_add_f32 v8, v8, v106 :: v_dual_add_f32 v9, v9, v107
	v_or_b32_e32 v46, 0x400000, v6
	v_bfe_u32 v47, v7, 16, 1
	v_add3_u32 v45, v45, v6, 0x7fff
	v_cndmask_b32_e32 v5, v43, v44, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_dual_add_f32 v16, 0, v16 :: v_dual_add_f32 v17, 0, v17
	v_dual_add_f32 v14, v14, v48 :: v_dual_add_f32 v15, v15, v49
	v_dual_add_f32 v10, v10, v76 :: v_dual_add_f32 v11, v11, v77
	v_or_b32_e32 v48, 0x400000, v7
	v_bfe_u32 v49, v8, 16, 1
	v_add3_u32 v47, v47, v7, 0x7fff
	v_cndmask_b32_e32 v6, v45, v46, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_dual_add_f32 v18, 0, v18 :: v_dual_add_f32 v19, 0, v19
	v_dual_add_f32 v16, v16, v50 :: v_dual_add_f32 v17, v17, v51
	v_dual_add_f32 v10, v10, v108 :: v_dual_add_f32 v11, v11, v109
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
	v_dual_add_f32 v12, v12, v110 :: v_dual_add_f32 v13, v13, v111
	v_or_b32_e32 v54, 0x400000, v10
	v_bfe_u32 v55, v11, 16, 1
	v_add3_u32 v53, v53, v10, 0x7fff
	v_cndmask_b32_e32 v9, v51, v52, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_dual_add_f32 v24, 0, v24 :: v_dual_add_f32 v25, 0, v25
	v_dual_add_f32 v22, v22, v56 :: v_dual_add_f32 v23, v23, v57
	v_dual_add_f32 v14, v14, v80 :: v_dual_add_f32 v15, v15, v81
	v_or_b32_e32 v56, 0x400000, v11
	v_bfe_u32 v57, v12, 16, 1
	v_add3_u32 v55, v55, v11, 0x7fff
	v_cndmask_b32_e32 v10, v53, v54, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_dual_add_f32 v26, 0, v26 :: v_dual_add_f32 v27, 0, v27
	v_dual_add_f32 v24, v24, v58 :: v_dual_add_f32 v25, v25, v59
	v_dual_add_f32 v14, v14, v112 :: v_dual_add_f32 v15, v15, v113
	v_or_b32_e32 v58, 0x400000, v12
	v_bfe_u32 v59, v13, 16, 1
	v_add3_u32 v57, v57, v12, 0x7fff
	v_cndmask_b32_e32 v11, v55, v56, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_dual_add_f32 v28, 0, v28 :: v_dual_add_f32 v29, 0, v29
	v_dual_add_f32 v26, v26, v60 :: v_dual_add_f32 v27, v27, v61
	v_dual_add_f32 v16, v16, v82 :: v_dual_add_f32 v17, v17, v83
	v_or_b32_e32 v60, 0x400000, v13
	v_bfe_u32 v61, v14, 16, 1
	v_add3_u32 v59, v59, v13, 0x7fff
	v_cndmask_b32_e32 v12, v57, v58, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_dual_add_f32 v30, 0, v30 :: v_dual_add_f32 v31, 0, v31
	v_dual_add_f32 v28, v28, v62 :: v_dual_add_f32 v29, v29, v63
	v_dual_add_f32 v16, v16, v114 :: v_dual_add_f32 v17, v17, v115
	v_or_b32_e32 v62, 0x400000, v14
	v_bfe_u32 v63, v15, 16, 1
	v_add3_u32 v61, v61, v14, 0x7fff
	v_cndmask_b32_e32 v13, v59, v60, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_dual_add_f32 v30, v30, v64 :: v_dual_add_f32 v31, v31, v65
	v_dual_add_f32 v18, v18, v84 :: v_dual_add_f32 v19, v19, v85
	v_or_b32_e32 v64, 0x400000, v15
	v_bfe_u32 v65, v16, 16, 1
	v_add3_u32 v63, v63, v15, 0x7fff
	v_cndmask_b32_e32 v14, v61, v62, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_dual_add_f32 v18, v18, v116 :: v_dual_add_f32 v19, v19, v117
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
	v_dual_add_f32 v20, v20, v118 :: v_dual_add_f32 v21, v21, v119
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
	v_dual_add_f32 v22, v22, v120 :: v_dual_add_f32 v23, v23, v121
	v_or_b32_e32 v74, 0x400000, v20
	v_bfe_u32 v75, v21, 16, 1
	v_add3_u32 v73, v73, v20, 0x7fff
	v_cndmask_b32_e32 v19, v71, v72, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v20, v20
	v_dual_add_f32 v24, v24, v90 :: v_dual_add_f32 v25, v25, v91
	v_or_b32_e32 v76, 0x400000, v21
	v_bfe_u32 v77, v22, 16, 1
	v_add3_u32 v75, v75, v21, 0x7fff
	v_cndmask_b32_e32 v20, v73, v74, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v21, v21
	v_dual_add_f32 v24, v24, v122 :: v_dual_add_f32 v25, v25, v123
	v_or_b32_e32 v78, 0x400000, v22
	v_bfe_u32 v79, v23, 16, 1
	v_add3_u32 v77, v77, v22, 0x7fff
	v_cndmask_b32_e32 v21, v75, v76, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v22, v22
	v_dual_add_f32 v26, v26, v92 :: v_dual_add_f32 v27, v27, v93
	v_or_b32_e32 v80, 0x400000, v23
	v_bfe_u32 v81, v24, 16, 1
	v_add3_u32 v79, v79, v23, 0x7fff
	v_cndmask_b32_e32 v22, v77, v78, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v23, v23
	v_dual_add_f32 v26, v26, v124 :: v_dual_add_f32 v27, v27, v125
	v_or_b32_e32 v82, 0x400000, v24
	v_bfe_u32 v83, v25, 16, 1
	v_add3_u32 v81, v81, v24, 0x7fff
	v_cndmask_b32_e32 v23, v79, v80, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v24, v24
	v_dual_add_f32 v28, v28, v94 :: v_dual_add_f32 v29, v29, v95
	v_or_b32_e32 v84, 0x400000, v25
	v_bfe_u32 v85, v26, 16, 1
	v_add3_u32 v83, v83, v25, 0x7fff
	v_cndmask_b32_e32 v24, v81, v82, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v25, v25
	v_dual_add_f32 v28, v28, v126 :: v_dual_add_f32 v29, v29, v127
	v_or_b32_e32 v86, 0x400000, v26
	v_bfe_u32 v87, v27, 16, 1
	v_add3_u32 v85, v85, v26, 0x7fff
	v_cndmask_b32_e32 v25, v83, v84, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v26, v26
	v_dual_add_f32 v30, v30, v96 :: v_dual_add_f32 v31, v31, v97
	v_or_b32_e32 v88, 0x400000, v27
	v_bfe_u32 v89, v28, 16, 1
	v_add3_u32 v87, v87, v27, 0x7fff
	v_cndmask_b32_e32 v26, v85, v86, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v27, v27
	v_dual_add_f32 v30, v30, v128 :: v_dual_add_f32 v31, v31, v129
	v_or_b32_e32 v90, 0x400000, v28
	v_bfe_u32 v91, v29, 16, 1
	v_add3_u32 v89, v89, v28, 0x7fff
	v_cndmask_b32_e32 v27, v87, v88, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v28, v28
	v_or_b32_e32 v92, 0x400000, v29
	v_bfe_u32 v93, v30, 16, 1
	v_add3_u32 v91, v91, v29, 0x7fff
	v_or_b32_e32 v94, 0x400000, v30
	v_cndmask_b32_e32 v28, v89, v90, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v29, v29
	v_bfe_u32 v95, v31, 16, 1
	v_add3_u32 v93, v93, v30, 0x7fff
	v_bfe_u32 v96, v32, 16, 1
	v_or_b32_e32 v35, 0x400000, v31
	v_cndmask_b32_e32 v29, v91, v92, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v30, v30
	v_add3_u32 v95, v95, v31, 0x7fff
	v_and_or_b32 v0, 0x400, v0, v161
	v_or_b32_e32 v38, s16, v162
	v_lshrrev_b32_e32 v1, 16, v1
	v_cndmask_b32_e32 v30, v93, v94, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v31, v31
	v_add3_u32 v36, v96, v32, 0x7fff
	v_or_b32_e32 v37, 0x400000, v32
	v_add_lshl_u32 v0, v38, v0, 1
	v_lshrrev_b32_e32 v2, 16, v2
	v_cndmask_b32_e32 v31, v95, v35, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v32, v32
	v_lshrrev_b32_e32 v3, 16, v3
	buffer_store_b16 v1, v0, s[0:3], 0 offen
	v_add_nc_u32_e32 v1, 0x1000, v0
	v_dual_cndmask_b32 v32, v36, v37 :: v_dual_add_nc_u32 v35, 0x2000, v0
	v_lshrrev_b32_e32 v4, 16, v4
	v_add_nc_u32_e32 v36, 0x3000, v0
	v_lshrrev_b32_e32 v5, 16, v5
	v_add_nc_u32_e32 v37, 0x4000, v0
	v_lshrrev_b32_e32 v6, 16, v6
	v_add_nc_u32_e32 v38, 0x5000, v0
	v_lshrrev_b32_e32 v7, 16, v7
	s_clause 0x4
	buffer_store_b16 v2, v1, s[0:3], 0 offen
	buffer_store_b16 v3, v35, s[0:3], 0 offen
	buffer_store_b16 v4, v36, s[0:3], 0 offen
	buffer_store_b16 v5, v37, s[0:3], 0 offen
	buffer_store_b16 v6, v38, s[0:3], 0 offen
	v_add_nc_u32_e32 v2, 0x6000, v0
	v_lshrrev_b32_e32 v8, 16, v8
	v_add_nc_u32_e32 v3, 0x7000, v0
	v_lshrrev_b32_e32 v9, 16, v9
	v_add_nc_u32_e32 v4, 0x8000, v0
	v_lshrrev_b32_e32 v10, 16, v10
	v_add_nc_u32_e32 v5, 0x9000, v0
	v_lshrrev_b32_e32 v11, 16, v11
	v_add_nc_u32_e32 v6, 0xa000, v0
	v_lshrrev_b32_e32 v12, 16, v12
	s_clause 0x4
	buffer_store_b16 v7, v2, s[0:3], 0 offen
	buffer_store_b16 v8, v3, s[0:3], 0 offen
	buffer_store_b16 v9, v4, s[0:3], 0 offen
	buffer_store_b16 v10, v5, s[0:3], 0 offen
	buffer_store_b16 v11, v6, s[0:3], 0 offen
	v_add_nc_u32_e32 v7, 0xb000, v0
	v_lshrrev_b32_e32 v13, 16, v13
	v_add_nc_u32_e32 v8, 0xc000, v0
	v_lshrrev_b32_e32 v14, 16, v14
	v_add_nc_u32_e32 v9, 0xd000, v0
	v_lshrrev_b32_e32 v15, 16, v15
	v_add_nc_u32_e32 v10, 0xe000, v0
	v_lshrrev_b32_e32 v16, 16, v16
	v_add_nc_u32_e32 v11, 0xf000, v0
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
	v_lshrrev_b32_e32 v29, 16, v29
	s_clause 0x10
	buffer_store_b16 v12, v7, s[0:3], 0 offen
	buffer_store_b16 v13, v8, s[0:3], 0 offen
	buffer_store_b16 v14, v9, s[0:3], 0 offen
	buffer_store_b16 v15, v10, s[0:3], 0 offen
	buffer_store_b16 v16, v11, s[0:3], 0 offen
	buffer_store_b16 v17, v0, s[0:3], 0 offen offset:64
	buffer_store_b16 v18, v1, s[0:3], 0 offen offset:64
	buffer_store_b16 v19, v35, s[0:3], 0 offen offset:64
	buffer_store_b16 v20, v36, s[0:3], 0 offen offset:64
	buffer_store_b16 v21, v37, s[0:3], 0 offen offset:64
	buffer_store_b16 v22, v38, s[0:3], 0 offen offset:64
	buffer_store_b16 v23, v2, s[0:3], 0 offen offset:64
	buffer_store_b16 v24, v3, s[0:3], 0 offen offset:64
	buffer_store_b16 v25, v4, s[0:3], 0 offen offset:64
	buffer_store_b16 v26, v5, s[0:3], 0 offen offset:64
	buffer_store_b16 v27, v6, s[0:3], 0 offen offset:64
	buffer_store_b16 v28, v7, s[0:3], 0 offen offset:64
	v_mov_b32_e32 v0, 0
	v_lshrrev_b32_e32 v30, 16, v30
	v_lshrrev_b32_e32 v31, 16, v31
	v_lshrrev_b32_e32 v32, 16, v32
	s_clause 0x3
	buffer_store_b16 v29, v8, s[0:3], 0 offen offset:64
	buffer_store_b16 v30, v9, s[0:3], 0 offen offset:64
	buffer_store_b16 v31, v10, s[0:3], 0 offen offset:64
	buffer_store_b16 v32, v11, s[0:3], 0 offen offset:64
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
		.amdhsa_next_free_vgpr 173
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

	.set .Lexercise_kernel_0.num_vgpr, 173
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
    .vgpr_count:     173
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
