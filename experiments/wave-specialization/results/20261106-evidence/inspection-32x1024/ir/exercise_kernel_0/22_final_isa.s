	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	exercise_kernel_0
	.p2align	8
	.type	exercise_kernel_0,@function
exercise_kernel_0:
	s_ashr_i32 s13, s2, 31
	s_clause 0x1
	s_load_b64 s[8:9], s[0:1], 0x0
	s_load_b64 s[4:5], s[0:1], 0x18
	s_lshr_b32 s3, s13, 30
	v_lshlrev_b32_e32 v2, 3, v0
	s_add_i32 s6, s2, s3
	v_lshrrev_b32_e32 v1, 3, v0
	s_ashr_i32 s3, s6, 31
	s_ashr_i32 s7, s6, 2
	s_lshr_b32 s3, s3, 28
	v_and_b32_e32 v84, 56, v2
	s_add_i32 s3, s7, s3
	v_lshlrev_b32_e32 v86, 14, v1
	s_and_b32 s3, s3, -16
	v_mul_u32_u24_e32 v83, 0x90, v1
	s_sub_i32 s3, s7, s3
	v_lshlrev_b32_e32 v81, 1, v84
	s_lshl_b32 s12, s3, 6
	v_lshlrev_b32_e32 v82, 7, v1
	v_lshl_add_u32 v85, v1, 10, s12
	v_sub_co_u32 v97, s7, v0, 32
	s_mov_b32 s11, 0x21027000
	s_mov_b32 s10, -1
	s_waitcnt lgkmcnt(0)
	s_and_b32 s9, s9, 0xffff
	s_and_b32 s5, s5, 0xffff
	s_and_b32 s6, s6, -4
	s_xor_b32 s15, s7, -1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_saveexec_b32 s7, s15
	s_xor_b32 s7, exec_lo, s7
	v_lshlrev_b32_e32 v86, 14, v1
	v_lshlrev_b32_e32 v87, 1, v84
	v_mul_u32_u24_e32 v83, 0x90, v1
	v_lshlrev_b32_e32 v82, 7, v1
	s_or_saveexec_b32 s14, s7
	v_or_b32_e32 v2, v85, v84
	s_sub_i32 s16, s2, s6
	s_delay_alu instid0(VALU_DEP_1)
	v_lshlrev_b32_e32 v89, 1, v2
	s_xor_b32 exec_lo, exec_lo, s14
	s_cbranch_execz .LBB0_4
	v_lshl_add_u32 v2, s16, 12, v86
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	v_lshl_add_u32 v74, s16, 22, v89
	s_mov_b32 s6, s10
	s_mov_b32 s7, s11
	v_or_b32_e32 v75, v2, v81
	s_delay_alu instid0(VALU_DEP_2)
	v_add_nc_u32_e32 v26, 0x4000, v74
	v_add_nc_u32_e32 v50, 0x10000, v74
	v_add_nc_u32_e32 v30, 0x6000, v74
	v_add_nc_u32_e32 v54, 0x12000, v74
	v_add_nc_u32_e32 v76, 0x40000, v75
	v_add_nc_u32_e32 v6, 0x10000, v75
	v_add_nc_u32_e32 v78, 0x50000, v75
	v_add_nc_u32_e32 v10, 0x20000, v75
	v_add_nc_u32_e32 v34, 0x8000, v74
	v_add_nc_u32_e32 v58, 0x14000, v74
	v_add_nc_u32_e32 v79, 0x60000, v75
	v_add_nc_u32_e32 v14, 0x30000, v75
	v_add_nc_u32_e32 v38, 0xa000, v74
	v_add_nc_u32_e32 v62, 0x16000, v74
	v_add_nc_u32_e32 v80, 0x70000, v75
	v_add_nc_u32_e32 v22, 0x2000, v74
	v_add_nc_u32_e32 v42, 0xc000, v74
	v_add_nc_u32_e32 v46, 0xe000, v74
	v_add_nc_u32_e32 v66, 0x18000, v74
	v_add_nc_u32_e32 v70, 0x1a000, v74
	v_add_nc_u32_e32 v87, 0x1c000, v74
	s_clause 0x3
	buffer_load_b128 v[2:5], v75, s[8:11], 0 offen
	buffer_load_b128 v[6:9], v6, s[8:11], 0 offen
	buffer_load_b128 v[10:13], v10, s[8:11], 0 offen
	buffer_load_b128 v[14:17], v14, s[8:11], 0 offen
	s_clause 0xd
	buffer_load_b128 v[18:21], v74, s[4:7], 0 offen slc
	buffer_load_b128 v[22:25], v22, s[4:7], 0 offen slc
	buffer_load_b128 v[26:29], v26, s[4:7], 0 offen slc
	buffer_load_b128 v[30:33], v30, s[4:7], 0 offen slc
	buffer_load_b128 v[34:37], v34, s[4:7], 0 offen slc
	buffer_load_b128 v[38:41], v38, s[4:7], 0 offen slc
	buffer_load_b128 v[42:45], v42, s[4:7], 0 offen slc
	buffer_load_b128 v[46:49], v46, s[4:7], 0 offen slc
	buffer_load_b128 v[50:53], v50, s[4:7], 0 offen slc
	buffer_load_b128 v[54:57], v54, s[4:7], 0 offen slc
	buffer_load_b128 v[58:61], v58, s[4:7], 0 offen slc
	buffer_load_b128 v[62:65], v62, s[4:7], 0 offen slc
	buffer_load_b128 v[66:69], v66, s[4:7], 0 offen slc
	buffer_load_b128 v[70:73], v70, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v88, 0x1e000, v74
	s_clause 0x3
	buffer_load_b128 v[74:77], v76, s[8:11], 0 offen
	buffer_load_b128 v[90:93], v78, s[8:11], 0 offen
	buffer_load_b128 v[98:101], v79, s[8:11], 0 offen
	buffer_load_b128 v[102:105], v80, s[8:11], 0 offen
	s_clause 0x1
	buffer_load_b128 v[106:109], v87, s[4:7], 0 offen slc
	buffer_load_b128 v[110:113], v88, s[4:7], 0 offen slc
	v_or_b32_e32 v78, 0x4000, v81
	v_mov_b32_e32 v87, v81
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_or_b32_e32 v79, v78, v82
	v_mad_u32_u24 v1, 0x90, v1, v78
	v_add_nc_u32_e32 v79, 0xffffc000, v79
	s_waitcnt vmcnt(19)
	ds_store_b128 v79, v[18:21]
	s_waitcnt vmcnt(18)
	ds_store_b128 v79, v[22:25] offset:512
	s_waitcnt vmcnt(17)
	ds_store_b128 v79, v[26:29] offset:1024
	s_waitcnt vmcnt(16)
	ds_store_b128 v79, v[30:33] offset:1536
	s_waitcnt vmcnt(15)
	ds_store_b128 v79, v[34:37] offset:2048
	s_waitcnt vmcnt(14)
	ds_store_b128 v79, v[38:41] offset:2560
	s_waitcnt vmcnt(13)
	ds_store_b128 v79, v[42:45] offset:3072
	s_waitcnt vmcnt(12)
	ds_store_b128 v79, v[46:49] offset:3584
	s_waitcnt vmcnt(11)
	ds_store_b128 v79, v[50:53] offset:4096
	s_waitcnt vmcnt(10)
	ds_store_b128 v79, v[54:57] offset:4608
	s_waitcnt vmcnt(9)
	ds_store_b128 v79, v[58:61] offset:5120
	s_waitcnt vmcnt(8)
	ds_store_b128 v79, v[62:65] offset:5632
	s_waitcnt vmcnt(7)
	ds_store_b128 v79, v[66:69] offset:6144
	s_waitcnt vmcnt(6)
	ds_store_b128 v79, v[70:73] offset:6656
	ds_store_b128 v1, v[2:5]
	ds_store_b128 v1, v[6:9] offset:576
	ds_store_b128 v1, v[10:13] offset:1152
	ds_store_b128 v1, v[14:17] offset:1728
	s_waitcnt vmcnt(5)
	ds_store_b128 v1, v[74:77] offset:2304
	s_waitcnt vmcnt(4)
	ds_store_b128 v1, v[90:93] offset:2880
	s_waitcnt vmcnt(3)
	ds_store_b128 v1, v[98:101] offset:3456
	s_waitcnt vmcnt(2)
	ds_store_b128 v1, v[102:105] offset:4032
	s_waitcnt vmcnt(1)
	ds_store_b128 v79, v[106:109] offset:7168
	s_waitcnt vmcnt(0)
	ds_store_b128 v79, v[110:113] offset:7680
.LBB0_4:
	s_or_b32 exec_lo, exec_lo, s14
	v_bfe_i32 v2, v97, 0, 8
	v_mov_b32_e32 v1, 0
	s_movk_i32 s6, 0x90
	v_or_b32_e32 v90, v86, v87
	v_or_b32_e32 v88, 0x4000, v81
	v_mov_b16_e32 v3.l, v2.l
	v_mov_b32_e32 v4, v1
	v_mov_b32_e32 v5, v1
	v_mov_b32_e32 v6, v1
	v_mov_b32_e32 v8, v1
	v_lshrrev_b16 v7.l, 7, v3.l
	v_mov_b32_e32 v3, v1
	v_mov_b32_e32 v9, v1
	v_mov_b32_e32 v10, v1
	v_mov_b32_e32 v12, v1
	v_and_b16 v11.l, 0xff, v7.l
	v_mov_b32_e32 v7, v1
	v_mov_b32_e32 v13, v1
	v_mov_b32_e32 v15, v1
	v_mov_b32_e32 v16, v1
	v_lshrrev_b16 v14.l, 3, v11.l
	v_lshrrev_b16 v14.h, 4, v11.l
	v_mov_b32_e32 v11, v1
	v_mov_b32_e32 v19, v1
	v_mov_b32_e32 v22, v1
	v_add_nc_u16 v18.l, v97.l, v14.l
	v_add_nc_u16 v17.l, v97.l, v14.h
	v_mov_b32_e32 v14, v1
	v_mov_b32_e32 v25, v1
	v_mov_b32_e32 v27, v1
	v_bfe_i32 v21, v18, 0, 8
	v_and_b16 v20.l, 0xf0, v17.l
	v_mov_b32_e32 v17, v1
	v_mov_b32_e32 v18, v1
	v_mov_b32_e32 v28, v1
	v_mov_b16_e32 v23.l, v21.l
	v_sub_nc_u16 v24.l, v97.l, v20.l
	v_mov_b32_e32 v20, v1
	v_mov_b32_e32 v21, v1
	v_mov_b32_e32 v30, v1
	v_ashrrev_i16 v26.l, 5, v23.l
	v_bfe_i32 v98, v24, 0, 8
	v_mov_b32_e32 v2, v1
	v_mov_b32_e32 v23, v1
	v_mov_b32_e32 v24, v1
	v_bfe_i32 v99, v26, 0, 16
	v_dual_mov_b32 v26, v1 :: v_dual_lshlrev_b32 v29, 1, v98
	v_mad_i32_i24 v100, v98, s6, 0x4000
	v_mov_b32_e32 v31, v1
	v_mov_b32_e32 v32, v1
	s_delay_alu instid0(VALU_DEP_4)
	v_lshl_add_u32 v101, v99, 5, v29
	v_mov_b32_e32 v29, v1
	s_lshl_b32 s14, s16, 5
	s_mov_b32 s17, 0
	s_or_b32 s16, s14, 1
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_branch .LBB0_6
.LBB0_5:
	s_or_b32 exec_lo, exec_lo, s19
	s_add_i32 s17, s17, 1
	s_waitcnt lgkmcnt(0)
	s_cmp_lg_u32 s17, 15
	s_barrier
	s_cbranch_scc0 .LBB0_14
.LBB0_6:
	s_and_saveexec_b32 s6, s15
	s_delay_alu instid0(SALU_CYCLE_1)
	s_xor_b32 s6, exec_lo, s6
	s_cbranch_execz .LBB0_8
	ds_load_b128 v[41:44], v100
	ds_load_b128 v[45:48], v100 offset:16
	ds_load_b128 v[33:36], v100 offset:32
	ds_load_b128 v[37:40], v100 offset:48
	ds_load_b128 v[49:52], v100 offset:2304
	ds_load_b128 v[53:56], v100 offset:2320
	ds_load_b128 v[57:60], v100 offset:2336
	ds_load_b128 v[61:64], v100 offset:2352
	ds_load_u16_d16 v65, v101
	ds_load_u16_d16_hi v65, v101 offset:128
	ds_load_u16_d16 v66, v101 offset:256
	ds_load_u16_d16_hi v66, v101 offset:384
	ds_load_u16_d16_hi v74, v101 offset:448
	ds_load_u16_d16 v74, v101 offset:320
	ds_load_u16_d16_hi v73, v101 offset:192
	ds_load_u16_d16 v73, v101 offset:64
	ds_load_u16_d16 v67, v101 offset:512
	ds_load_u16_d16_hi v67, v101 offset:640
	ds_load_u16_d16 v68, v101 offset:768
	ds_load_u16_d16_hi v68, v101 offset:896
	ds_load_u16_d16_hi v76, v101 offset:960
	ds_load_u16_d16 v76, v101 offset:832
	ds_load_u16_d16_hi v75, v101 offset:704
	ds_load_u16_d16 v75, v101 offset:576
	ds_load_u16_d16 v69, v101 offset:1024
	ds_load_u16_d16_hi v69, v101 offset:1152
	ds_load_u16_d16 v70, v101 offset:1280
	ds_load_u16_d16_hi v70, v101 offset:1408
	ds_load_u16_d16_hi v78, v101 offset:1472
	ds_load_u16_d16 v78, v101 offset:1344
	ds_load_u16_d16_hi v77, v101 offset:1216
	ds_load_u16_d16 v77, v101 offset:1088
	ds_load_u16_d16 v71, v101 offset:1536
	ds_load_u16_d16_hi v71, v101 offset:1664
	ds_load_u16_d16 v72, v101 offset:1792
	ds_load_u16_d16_hi v72, v101 offset:1920
	ds_load_u16_d16_hi v80, v101 offset:1984
	ds_load_u16_d16 v80, v101 offset:1856
	ds_load_u16_d16_hi v79, v101 offset:1728
	ds_load_u16_d16 v79, v101 offset:1600
	ds_load_b128 v[102:105], v100 offset:64
	ds_load_b128 v[106:109], v100 offset:80
	ds_load_b128 v[110:113], v100 offset:2368
	ds_load_b128 v[114:117], v100 offset:2384
	ds_load_u16_d16 v118, v101 offset:2048
	ds_load_u16_d16_hi v118, v101 offset:2176
	ds_load_u16_d16 v119, v101 offset:2304
	ds_load_u16_d16_hi v119, v101 offset:2432
	ds_load_u16_d16_hi v127, v101 offset:2496
	ds_load_u16_d16 v127, v101 offset:2368
	ds_load_u16_d16_hi v126, v101 offset:2240
	ds_load_u16_d16 v126, v101 offset:2112
	ds_load_u16_d16 v120, v101 offset:2560
	ds_load_u16_d16_hi v120, v101 offset:2688
	ds_load_u16_d16 v121, v101 offset:2816
	ds_load_u16_d16_hi v121, v101 offset:2944
	ds_load_u16_d16_hi v129, v101 offset:3008
	ds_load_u16_d16 v129, v101 offset:2880
	ds_load_u16_d16_hi v128, v101 offset:2752
	ds_load_u16_d16 v128, v101 offset:2624
	ds_load_u16_d16 v122, v101 offset:3072
	ds_load_u16_d16_hi v122, v101 offset:3200
	ds_load_u16_d16 v123, v101 offset:3328
	ds_load_u16_d16_hi v123, v101 offset:3456
	ds_load_u16_d16_hi v131, v101 offset:3520
	ds_load_u16_d16 v131, v101 offset:3392
	ds_load_u16_d16_hi v130, v101 offset:3264
	ds_load_u16_d16 v130, v101 offset:3136
	ds_load_u16_d16 v124, v101 offset:3584
	ds_load_u16_d16_hi v124, v101 offset:3712
	ds_load_u16_d16 v125, v101 offset:3840
	ds_load_u16_d16_hi v125, v101 offset:3968
	ds_load_u16_d16_hi v133, v101 offset:4032
	ds_load_u16_d16 v133, v101 offset:3904
	ds_load_u16_d16_hi v132, v101 offset:3776
	ds_load_u16_d16 v132, v101 offset:3648
	ds_load_u16_d16 v134, v101 offset:4096
	ds_load_u16_d16_hi v134, v101 offset:4224
	ds_load_u16_d16 v135, v101 offset:4352
	ds_load_u16_d16_hi v135, v101 offset:4480
	ds_load_u16_d16_hi v143, v101 offset:4544
	ds_load_u16_d16 v143, v101 offset:4416
	ds_load_u16_d16_hi v142, v101 offset:4288
	ds_load_u16_d16 v142, v101 offset:4160
	ds_load_u16_d16 v136, v101 offset:4608
	ds_load_u16_d16_hi v136, v101 offset:4736
	ds_load_u16_d16 v137, v101 offset:4864
	ds_load_u16_d16_hi v137, v101 offset:4992
	ds_load_u16_d16_hi v145, v101 offset:5056
	ds_load_u16_d16 v145, v101 offset:4928
	ds_load_u16_d16_hi v144, v101 offset:4800
	ds_load_u16_d16 v144, v101 offset:4672
	ds_load_u16_d16 v138, v101 offset:5120
	ds_load_u16_d16_hi v138, v101 offset:5248
	ds_load_u16_d16 v139, v101 offset:5376
	ds_load_u16_d16_hi v139, v101 offset:5504
	ds_load_u16_d16_hi v147, v101 offset:5568
	ds_load_u16_d16 v147, v101 offset:5440
	ds_load_u16_d16_hi v146, v101 offset:5312
	ds_load_u16_d16 v146, v101 offset:5184
	ds_load_u16_d16 v140, v101 offset:5632
	ds_load_u16_d16_hi v140, v101 offset:5760
	ds_load_u16_d16 v141, v101 offset:5888
	ds_load_u16_d16_hi v141, v101 offset:6016
	ds_load_u16_d16_hi v149, v101 offset:6080
	ds_load_u16_d16 v149, v101 offset:5952
	ds_load_u16_d16_hi v148, v101 offset:5824
	ds_load_u16_d16 v148, v101 offset:5696
	ds_load_b128 v[150:153], v100 offset:96
	ds_load_b128 v[154:157], v100 offset:112
	ds_load_u16_d16 v158, v101 offset:6144
	ds_load_u16_d16_hi v158, v101 offset:6272
	ds_load_u16_d16 v159, v101 offset:6400
	ds_load_u16_d16_hi v159, v101 offset:6528
	ds_load_u16_d16_hi v167, v101 offset:6592
	ds_load_u16_d16 v167, v101 offset:6464
	ds_load_u16_d16_hi v166, v101 offset:6336
	ds_load_u16_d16 v166, v101 offset:6208
	ds_load_u16_d16 v160, v101 offset:6656
	ds_load_u16_d16_hi v160, v101 offset:6784
	ds_load_u16_d16 v161, v101 offset:6912
	ds_load_u16_d16_hi v161, v101 offset:7040
	ds_load_u16_d16_hi v169, v101 offset:7104
	ds_load_u16_d16 v169, v101 offset:6976
	ds_load_u16_d16_hi v168, v101 offset:6848
	ds_load_u16_d16 v168, v101 offset:6720
	ds_load_u16_d16 v162, v101 offset:7168
	ds_load_u16_d16_hi v162, v101 offset:7296
	ds_load_u16_d16 v163, v101 offset:7424
	ds_load_u16_d16_hi v163, v101 offset:7552
	ds_load_u16_d16_hi v171, v101 offset:7616
	ds_load_u16_d16 v171, v101 offset:7488
	ds_load_u16_d16_hi v170, v101 offset:7360
	ds_load_u16_d16 v170, v101 offset:7232
	ds_load_u16_d16 v164, v101 offset:7680
	ds_load_u16_d16_hi v164, v101 offset:7808
	ds_load_u16_d16 v165, v101 offset:7936
	ds_load_u16_d16_hi v165, v101 offset:8064
	ds_load_u16_d16_hi v173, v101 offset:8128
	ds_load_u16_d16 v173, v101 offset:8000
	ds_load_u16_d16_hi v172, v101 offset:7872
	ds_load_u16_d16 v172, v101 offset:7744
	ds_load_b128 v[174:177], v100 offset:2400
	ds_load_b128 v[178:181], v100 offset:2416
	s_waitcnt lgkmcnt(62)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[41:48], v[65:72], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[41:48], v[73:80], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[49:56], v[65:72], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[49:56], v[73:80], v[25:32]
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[33:40], v[118:125], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[33:40], v[126:133], v[9:16]
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[57:64], v[118:125], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[57:64], v[126:133], v[25:32]
	s_waitcnt lgkmcnt(40)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[102:109], v[134:141], v[1:8]
	s_waitcnt lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[102:109], v[142:149], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[110:117], v[134:141], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[110:117], v[142:149], v[25:32]
	s_waitcnt lgkmcnt(6)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[150:157], v[158:165], v[1:8]
	s_waitcnt lgkmcnt(2)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[150:157], v[166:173], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[174:181], v[158:165], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[174:181], v[166:173], v[25:32]
.LBB0_8:
	s_or_saveexec_b32 s19, s6
	s_lshl_b32 s18, s17, 1
	s_xor_b32 exec_lo, exec_lo, s19
	s_cbranch_execz .LBB0_10
	s_or_b32 s6, s18, s16
	s_mov_b32 s7, s11
	v_lshl_add_u32 v95, s6, 17, v89
	v_lshl_add_u32 v57, s6, 7, v90
	s_mov_b32 s6, s10
	s_delay_alu instid0(VALU_DEP_2)
	v_add_nc_u32_e32 v91, 0x8000, v95
	v_add_nc_u32_e32 v96, 0xa000, v95
	v_add_nc_u32_e32 v106, 0xc000, v95
	v_add_nc_u32_e32 v110, 0xe000, v95
	v_add_nc_u32_e32 v114, 0x10000, v95
	v_add_nc_u32_e32 v118, 0x12000, v95
	v_add_nc_u32_e32 v58, 0x60000, v57
	s_clause 0x5
	buffer_load_b128 v[91:94], v91, s[4:7], 0 offen slc
	buffer_load_b128 v[102:105], v96, s[4:7], 0 offen slc
	buffer_load_b128 v[106:109], v106, s[4:7], 0 offen slc
	buffer_load_b128 v[110:113], v110, s[4:7], 0 offen slc
	buffer_load_b128 v[114:117], v114, s[4:7], 0 offen slc
	buffer_load_b128 v[118:121], v118, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v96, 0x14000, v95
	v_add_nc_u32_e32 v37, 0x10000, v57
	v_add_nc_u32_e32 v61, 0x70000, v57
	v_add_nc_u32_e32 v126, 0x16000, v95
	v_add_nc_u32_e32 v41, 0x20000, v57
	v_add_nc_u32_e32 v130, 0x18000, v95
	v_add_nc_u32_e32 v45, 0x30000, v57
	v_add_nc_u32_e32 v69, 0x2000, v95
	v_add_nc_u32_e32 v134, 0x1a000, v95
	v_add_nc_u32_e32 v49, 0x40000, v57
	v_add_nc_u32_e32 v53, 0x50000, v57
	v_add_nc_u32_e32 v73, 0x4000, v95
	v_add_nc_u32_e32 v77, 0x6000, v95
	v_add_nc_u32_e32 v138, 0x1c000, v95
	s_clause 0x7
	buffer_load_b128 v[33:36], v57, s[8:11], 0 offen
	buffer_load_b128 v[37:40], v37, s[8:11], 0 offen
	buffer_load_b128 v[41:44], v41, s[8:11], 0 offen
	buffer_load_b128 v[45:48], v45, s[8:11], 0 offen
	buffer_load_b128 v[49:52], v49, s[8:11], 0 offen
	buffer_load_b128 v[53:56], v53, s[8:11], 0 offen
	buffer_load_b128 v[57:60], v58, s[8:11], 0 offen
	buffer_load_b128 v[61:64], v61, s[8:11], 0 offen
	s_clause 0x3
	buffer_load_b128 v[65:68], v95, s[4:7], 0 offen slc
	buffer_load_b128 v[69:72], v69, s[4:7], 0 offen slc
	buffer_load_b128 v[73:76], v73, s[4:7], 0 offen slc
	buffer_load_b128 v[77:80], v77, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v95, 0x1e000, v95
	s_clause 0x5
	buffer_load_b128 v[122:125], v96, s[4:7], 0 offen slc
	buffer_load_b128 v[126:129], v126, s[4:7], 0 offen slc
	buffer_load_b128 v[130:133], v130, s[4:7], 0 offen slc
	buffer_load_b128 v[134:137], v134, s[4:7], 0 offen slc
	buffer_load_b128 v[138:141], v138, s[4:7], 0 offen slc
	buffer_load_b128 v[142:145], v95, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v95, v88, v83
	v_add_nc_u32_e32 v96, v81, v82
	s_waitcnt vmcnt(17)
	ds_store_b128 v95, v[33:36] offset:4608
	s_waitcnt vmcnt(16)
	ds_store_b128 v95, v[37:40] offset:5184
	s_waitcnt vmcnt(15)
	ds_store_b128 v95, v[41:44] offset:5760
	s_waitcnt vmcnt(14)
	ds_store_b128 v95, v[45:48] offset:6336
	s_waitcnt vmcnt(13)
	ds_store_b128 v95, v[49:52] offset:6912
	s_waitcnt vmcnt(12)
	ds_store_b128 v95, v[53:56] offset:7488
	s_waitcnt vmcnt(11)
	ds_store_b128 v95, v[57:60] offset:8064
	s_waitcnt vmcnt(10)
	ds_store_b128 v95, v[61:64] offset:8640
	s_waitcnt vmcnt(9)
	ds_store_b128 v96, v[65:68] offset:8192
	s_waitcnt vmcnt(8)
	ds_store_b128 v96, v[69:72] offset:8704
	s_waitcnt vmcnt(7)
	ds_store_b128 v96, v[73:76] offset:9216
	s_waitcnt vmcnt(6)
	ds_store_b128 v96, v[77:80] offset:9728
	ds_store_b128 v96, v[91:94] offset:10240
	ds_store_b128 v96, v[102:105] offset:10752
	ds_store_b128 v96, v[106:109] offset:11264
	ds_store_b128 v96, v[110:113] offset:11776
	ds_store_b128 v96, v[114:117] offset:12288
	ds_store_b128 v96, v[118:121] offset:12800
	s_waitcnt vmcnt(5)
	ds_store_b128 v96, v[122:125] offset:13312
	s_waitcnt vmcnt(4)
	ds_store_b128 v96, v[126:129] offset:13824
	s_waitcnt vmcnt(3)
	ds_store_b128 v96, v[130:133] offset:14336
	s_waitcnt vmcnt(2)
	ds_store_b128 v96, v[134:137] offset:14848
	s_waitcnt vmcnt(1)
	ds_store_b128 v96, v[138:141] offset:15360
	s_waitcnt vmcnt(0)
	ds_store_b128 v96, v[142:145] offset:15872
.LBB0_10:
	s_or_b32 exec_lo, exec_lo, s19
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_and_saveexec_b32 s6, s15
	s_delay_alu instid0(SALU_CYCLE_1)
	s_xor_b32 s6, exec_lo, s6
	s_cbranch_execz .LBB0_12
	ds_load_b128 v[41:44], v100 offset:4608
	ds_load_b128 v[45:48], v100 offset:4624
	ds_load_b128 v[33:36], v100 offset:4640
	ds_load_b128 v[37:40], v100 offset:4656
	ds_load_b128 v[49:52], v100 offset:6912
	ds_load_b128 v[53:56], v100 offset:6928
	ds_load_b128 v[57:60], v100 offset:6944
	ds_load_b128 v[61:64], v100 offset:6960
	ds_load_u16_d16 v65, v101 offset:8192
	ds_load_u16_d16_hi v65, v101 offset:8320
	ds_load_u16_d16 v66, v101 offset:8448
	ds_load_u16_d16_hi v66, v101 offset:8576
	ds_load_u16_d16_hi v74, v101 offset:8640
	ds_load_u16_d16 v74, v101 offset:8512
	ds_load_u16_d16_hi v73, v101 offset:8384
	ds_load_u16_d16 v73, v101 offset:8256
	ds_load_u16_d16 v67, v101 offset:8704
	ds_load_u16_d16_hi v67, v101 offset:8832
	ds_load_u16_d16 v68, v101 offset:8960
	ds_load_u16_d16_hi v68, v101 offset:9088
	ds_load_u16_d16_hi v76, v101 offset:9152
	ds_load_u16_d16 v76, v101 offset:9024
	ds_load_u16_d16_hi v75, v101 offset:8896
	ds_load_u16_d16 v75, v101 offset:8768
	ds_load_u16_d16 v69, v101 offset:9216
	ds_load_u16_d16_hi v69, v101 offset:9344
	ds_load_u16_d16 v70, v101 offset:9472
	ds_load_u16_d16_hi v70, v101 offset:9600
	ds_load_u16_d16_hi v78, v101 offset:9664
	ds_load_u16_d16 v78, v101 offset:9536
	ds_load_u16_d16_hi v77, v101 offset:9408
	ds_load_u16_d16 v77, v101 offset:9280
	ds_load_u16_d16 v71, v101 offset:9728
	ds_load_u16_d16_hi v71, v101 offset:9856
	ds_load_u16_d16 v72, v101 offset:9984
	ds_load_u16_d16_hi v72, v101 offset:10112
	ds_load_u16_d16_hi v80, v101 offset:10176
	ds_load_u16_d16 v80, v101 offset:10048
	ds_load_u16_d16_hi v79, v101 offset:9920
	ds_load_u16_d16 v79, v101 offset:9792
	ds_load_b128 v[102:105], v100 offset:4672
	ds_load_b128 v[106:109], v100 offset:4688
	ds_load_b128 v[110:113], v100 offset:6976
	ds_load_b128 v[114:117], v100 offset:6992
	ds_load_u16_d16 v118, v101 offset:10240
	ds_load_u16_d16_hi v118, v101 offset:10368
	ds_load_u16_d16 v119, v101 offset:10496
	ds_load_u16_d16_hi v119, v101 offset:10624
	ds_load_u16_d16_hi v127, v101 offset:10688
	ds_load_u16_d16 v127, v101 offset:10560
	ds_load_u16_d16_hi v126, v101 offset:10432
	ds_load_u16_d16 v126, v101 offset:10304
	ds_load_u16_d16 v120, v101 offset:10752
	ds_load_u16_d16_hi v120, v101 offset:10880
	ds_load_u16_d16 v121, v101 offset:11008
	ds_load_u16_d16_hi v121, v101 offset:11136
	ds_load_u16_d16_hi v129, v101 offset:11200
	ds_load_u16_d16 v129, v101 offset:11072
	ds_load_u16_d16_hi v128, v101 offset:10944
	ds_load_u16_d16 v128, v101 offset:10816
	ds_load_u16_d16 v122, v101 offset:11264
	ds_load_u16_d16_hi v122, v101 offset:11392
	ds_load_u16_d16 v123, v101 offset:11520
	ds_load_u16_d16_hi v123, v101 offset:11648
	ds_load_u16_d16_hi v131, v101 offset:11712
	ds_load_u16_d16 v131, v101 offset:11584
	ds_load_u16_d16_hi v130, v101 offset:11456
	ds_load_u16_d16 v130, v101 offset:11328
	ds_load_u16_d16 v124, v101 offset:11776
	ds_load_u16_d16_hi v124, v101 offset:11904
	ds_load_u16_d16 v125, v101 offset:12032
	ds_load_u16_d16_hi v125, v101 offset:12160
	ds_load_u16_d16_hi v133, v101 offset:12224
	ds_load_u16_d16 v133, v101 offset:12096
	ds_load_u16_d16_hi v132, v101 offset:11968
	ds_load_u16_d16 v132, v101 offset:11840
	ds_load_u16_d16 v134, v101 offset:12288
	ds_load_u16_d16_hi v134, v101 offset:12416
	ds_load_u16_d16 v135, v101 offset:12544
	ds_load_u16_d16_hi v135, v101 offset:12672
	ds_load_u16_d16_hi v143, v101 offset:12736
	ds_load_u16_d16 v143, v101 offset:12608
	ds_load_u16_d16_hi v142, v101 offset:12480
	ds_load_u16_d16 v142, v101 offset:12352
	ds_load_u16_d16 v136, v101 offset:12800
	ds_load_u16_d16_hi v136, v101 offset:12928
	ds_load_u16_d16 v137, v101 offset:13056
	ds_load_u16_d16_hi v137, v101 offset:13184
	ds_load_u16_d16_hi v145, v101 offset:13248
	ds_load_u16_d16 v145, v101 offset:13120
	ds_load_u16_d16_hi v144, v101 offset:12992
	ds_load_u16_d16 v144, v101 offset:12864
	ds_load_u16_d16 v138, v101 offset:13312
	ds_load_u16_d16_hi v138, v101 offset:13440
	ds_load_u16_d16 v139, v101 offset:13568
	ds_load_u16_d16_hi v139, v101 offset:13696
	ds_load_u16_d16_hi v147, v101 offset:13760
	ds_load_u16_d16 v147, v101 offset:13632
	ds_load_u16_d16_hi v146, v101 offset:13504
	ds_load_u16_d16 v146, v101 offset:13376
	ds_load_u16_d16 v140, v101 offset:13824
	ds_load_u16_d16_hi v140, v101 offset:13952
	ds_load_u16_d16 v141, v101 offset:14080
	ds_load_u16_d16_hi v141, v101 offset:14208
	ds_load_u16_d16_hi v149, v101 offset:14272
	ds_load_u16_d16 v149, v101 offset:14144
	ds_load_u16_d16_hi v148, v101 offset:14016
	ds_load_u16_d16 v148, v101 offset:13888
	ds_load_b128 v[150:153], v100 offset:4704
	ds_load_b128 v[154:157], v100 offset:4720
	ds_load_u16_d16 v158, v101 offset:14336
	ds_load_u16_d16_hi v158, v101 offset:14464
	ds_load_u16_d16 v159, v101 offset:14592
	ds_load_u16_d16_hi v159, v101 offset:14720
	ds_load_u16_d16_hi v167, v101 offset:14784
	ds_load_u16_d16 v167, v101 offset:14656
	ds_load_u16_d16_hi v166, v101 offset:14528
	ds_load_u16_d16 v166, v101 offset:14400
	ds_load_u16_d16 v160, v101 offset:14848
	ds_load_u16_d16_hi v160, v101 offset:14976
	ds_load_u16_d16 v161, v101 offset:15104
	ds_load_u16_d16_hi v161, v101 offset:15232
	ds_load_u16_d16_hi v169, v101 offset:15296
	ds_load_u16_d16 v169, v101 offset:15168
	ds_load_u16_d16_hi v168, v101 offset:15040
	ds_load_u16_d16 v168, v101 offset:14912
	ds_load_u16_d16 v162, v101 offset:15360
	ds_load_u16_d16_hi v162, v101 offset:15488
	ds_load_u16_d16 v163, v101 offset:15616
	ds_load_u16_d16_hi v163, v101 offset:15744
	ds_load_u16_d16_hi v171, v101 offset:15808
	ds_load_u16_d16 v171, v101 offset:15680
	ds_load_u16_d16_hi v170, v101 offset:15552
	ds_load_u16_d16 v170, v101 offset:15424
	ds_load_u16_d16 v164, v101 offset:15872
	ds_load_u16_d16_hi v164, v101 offset:16000
	ds_load_u16_d16 v165, v101 offset:16128
	ds_load_u16_d16_hi v165, v101 offset:16256
	ds_load_u16_d16_hi v173, v101 offset:16320
	ds_load_u16_d16 v173, v101 offset:16192
	ds_load_u16_d16_hi v172, v101 offset:16064
	ds_load_u16_d16 v172, v101 offset:15936
	ds_load_b128 v[174:177], v100 offset:7008
	ds_load_b128 v[178:181], v100 offset:7024
	s_waitcnt lgkmcnt(62)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[41:48], v[65:72], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[41:48], v[73:80], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[49:56], v[65:72], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[49:56], v[73:80], v[25:32]
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[33:40], v[118:125], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[33:40], v[126:133], v[9:16]
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[57:64], v[118:125], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[57:64], v[126:133], v[25:32]
	s_waitcnt lgkmcnt(40)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[102:109], v[134:141], v[1:8]
	s_waitcnt lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[102:109], v[142:149], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[110:117], v[134:141], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[110:117], v[142:149], v[25:32]
	s_waitcnt lgkmcnt(6)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[150:157], v[158:165], v[1:8]
	s_waitcnt lgkmcnt(2)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[150:157], v[166:173], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[174:181], v[158:165], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[174:181], v[166:173], v[25:32]
.LBB0_12:
	s_and_not1_saveexec_b32 s19, s6
	s_cbranch_execz .LBB0_5
	s_or_b32 s6, s14, s18
	s_mov_b32 s7, s11
	s_add_i32 s6, s6, 2
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_2) | instid1(VALU_DEP_2)
	v_lshl_add_u32 v95, s6, 17, v89
	v_lshl_add_u32 v57, s6, 7, v90
	s_mov_b32 s6, s10
	v_add_nc_u32_e32 v91, 0x8000, v95
	v_add_nc_u32_e32 v96, 0xa000, v95
	v_add_nc_u32_e32 v106, 0xc000, v95
	v_add_nc_u32_e32 v110, 0xe000, v95
	v_add_nc_u32_e32 v114, 0x10000, v95
	v_add_nc_u32_e32 v118, 0x12000, v95
	v_add_nc_u32_e32 v58, 0x60000, v57
	s_clause 0x5
	buffer_load_b128 v[91:94], v91, s[4:7], 0 offen slc
	buffer_load_b128 v[102:105], v96, s[4:7], 0 offen slc
	buffer_load_b128 v[106:109], v106, s[4:7], 0 offen slc
	buffer_load_b128 v[110:113], v110, s[4:7], 0 offen slc
	buffer_load_b128 v[114:117], v114, s[4:7], 0 offen slc
	buffer_load_b128 v[118:121], v118, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v96, 0x14000, v95
	v_add_nc_u32_e32 v37, 0x10000, v57
	v_add_nc_u32_e32 v61, 0x70000, v57
	v_add_nc_u32_e32 v126, 0x16000, v95
	v_add_nc_u32_e32 v41, 0x20000, v57
	v_add_nc_u32_e32 v130, 0x18000, v95
	v_add_nc_u32_e32 v45, 0x30000, v57
	v_add_nc_u32_e32 v69, 0x2000, v95
	v_add_nc_u32_e32 v134, 0x1a000, v95
	v_add_nc_u32_e32 v49, 0x40000, v57
	v_add_nc_u32_e32 v53, 0x50000, v57
	v_add_nc_u32_e32 v73, 0x4000, v95
	v_add_nc_u32_e32 v77, 0x6000, v95
	v_add_nc_u32_e32 v138, 0x1c000, v95
	s_clause 0x7
	buffer_load_b128 v[33:36], v57, s[8:11], 0 offen
	buffer_load_b128 v[37:40], v37, s[8:11], 0 offen
	buffer_load_b128 v[41:44], v41, s[8:11], 0 offen
	buffer_load_b128 v[45:48], v45, s[8:11], 0 offen
	buffer_load_b128 v[49:52], v49, s[8:11], 0 offen
	buffer_load_b128 v[53:56], v53, s[8:11], 0 offen
	buffer_load_b128 v[57:60], v58, s[8:11], 0 offen
	buffer_load_b128 v[61:64], v61, s[8:11], 0 offen
	s_clause 0x3
	buffer_load_b128 v[65:68], v95, s[4:7], 0 offen slc
	buffer_load_b128 v[69:72], v69, s[4:7], 0 offen slc
	buffer_load_b128 v[73:76], v73, s[4:7], 0 offen slc
	buffer_load_b128 v[77:80], v77, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v95, 0x1e000, v95
	s_clause 0x5
	buffer_load_b128 v[122:125], v96, s[4:7], 0 offen slc
	buffer_load_b128 v[126:129], v126, s[4:7], 0 offen slc
	buffer_load_b128 v[130:133], v130, s[4:7], 0 offen slc
	buffer_load_b128 v[134:137], v134, s[4:7], 0 offen slc
	buffer_load_b128 v[138:141], v138, s[4:7], 0 offen slc
	buffer_load_b128 v[142:145], v95, s[4:7], 0 offen slc
	v_add_nc_u32_e32 v95, v88, v83
	v_add_nc_u32_e32 v96, v81, v82
	s_waitcnt vmcnt(17)
	ds_store_b128 v95, v[33:36]
	s_waitcnt vmcnt(16)
	ds_store_b128 v95, v[37:40] offset:576
	s_waitcnt vmcnt(15)
	ds_store_b128 v95, v[41:44] offset:1152
	s_waitcnt vmcnt(14)
	ds_store_b128 v95, v[45:48] offset:1728
	s_waitcnt vmcnt(13)
	ds_store_b128 v95, v[49:52] offset:2304
	s_waitcnt vmcnt(12)
	ds_store_b128 v95, v[53:56] offset:2880
	s_waitcnt vmcnt(11)
	ds_store_b128 v95, v[57:60] offset:3456
	s_waitcnt vmcnt(10)
	ds_store_b128 v95, v[61:64] offset:4032
	s_waitcnt vmcnt(9)
	ds_store_b128 v96, v[65:68]
	s_waitcnt vmcnt(8)
	ds_store_b128 v96, v[69:72] offset:512
	s_waitcnt vmcnt(7)
	ds_store_b128 v96, v[73:76] offset:1024
	s_waitcnt vmcnt(6)
	ds_store_b128 v96, v[77:80] offset:1536
	ds_store_b128 v96, v[91:94] offset:2048
	ds_store_b128 v96, v[102:105] offset:2560
	ds_store_b128 v96, v[106:109] offset:3072
	ds_store_b128 v96, v[110:113] offset:3584
	ds_store_b128 v96, v[114:117] offset:4096
	ds_store_b128 v96, v[118:121] offset:4608
	s_waitcnt vmcnt(5)
	ds_store_b128 v96, v[122:125] offset:5120
	s_waitcnt vmcnt(4)
	ds_store_b128 v96, v[126:129] offset:5632
	s_waitcnt vmcnt(3)
	ds_store_b128 v96, v[130:133] offset:6144
	s_waitcnt vmcnt(2)
	ds_store_b128 v96, v[134:137] offset:6656
	s_waitcnt vmcnt(1)
	ds_store_b128 v96, v[138:141] offset:7168
	s_waitcnt vmcnt(0)
	ds_store_b128 v96, v[142:145] offset:7680
	s_branch .LBB0_5
.LBB0_14:
	s_and_saveexec_b32 s6, s15
	s_delay_alu instid0(SALU_CYCLE_1)
	s_xor_b32 s6, exec_lo, s6
	s_cbranch_execz .LBB0_16
	ds_load_b128 v[73:76], v100
	ds_load_b128 v[77:80], v100 offset:16
	ds_load_b128 v[65:68], v100 offset:32
	ds_load_b128 v[69:72], v100 offset:48
	ds_load_b128 v[81:84], v100 offset:2304
	ds_load_b128 v[85:88], v100 offset:2320
	ds_load_u16_d16 v89, v101
	ds_load_u16_d16_hi v89, v101 offset:128
	ds_load_u16_d16 v90, v101 offset:256
	ds_load_u16_d16_hi v90, v101 offset:384
	ds_load_u16_d16_hi v103, v101 offset:448
	ds_load_u16_d16 v103, v101 offset:320
	ds_load_u16_d16_hi v102, v101 offset:192
	ds_load_u16_d16 v102, v101 offset:64
	ds_load_u16_d16 v91, v101 offset:512
	ds_load_u16_d16_hi v91, v101 offset:640
	ds_load_u16_d16 v92, v101 offset:768
	ds_load_u16_d16_hi v92, v101 offset:896
	ds_load_u16_d16_hi v105, v101 offset:960
	ds_load_u16_d16 v105, v101 offset:832
	ds_load_u16_d16_hi v104, v101 offset:704
	ds_load_u16_d16 v104, v101 offset:576
	ds_load_u16_d16 v93, v101 offset:1024
	ds_load_u16_d16_hi v93, v101 offset:1152
	ds_load_u16_d16 v94, v101 offset:1280
	ds_load_u16_d16_hi v94, v101 offset:1408
	ds_load_u16_d16_hi v107, v101 offset:1472
	ds_load_u16_d16 v107, v101 offset:1344
	ds_load_u16_d16_hi v106, v101 offset:1216
	ds_load_u16_d16 v106, v101 offset:1088
	ds_load_u16_d16 v95, v101 offset:1536
	ds_load_u16_d16_hi v95, v101 offset:1664
	ds_load_u16_d16 v96, v101 offset:1792
	ds_load_u16_d16_hi v96, v101 offset:1920
	ds_load_u16_d16_hi v109, v101 offset:1984
	ds_load_u16_d16 v109, v101 offset:1856
	ds_load_u16_d16_hi v108, v101 offset:1728
	ds_load_u16_d16 v108, v101 offset:1600
	v_dual_mov_b32 v40, v8 :: v_dual_mov_b32 v39, v7
	v_dual_mov_b32 v38, v6 :: v_dual_mov_b32 v37, v5
	v_dual_mov_b32 v36, v4 :: v_dual_mov_b32 v35, v3
	v_dual_mov_b32 v34, v2 :: v_dual_mov_b32 v33, v1
	v_dual_mov_b32 v48, v16 :: v_dual_mov_b32 v47, v15
	v_dual_mov_b32 v46, v14 :: v_dual_mov_b32 v45, v13
	v_dual_mov_b32 v44, v12 :: v_dual_mov_b32 v43, v11
	v_dual_mov_b32 v42, v10 :: v_dual_mov_b32 v41, v9
	v_dual_mov_b32 v56, v24 :: v_dual_mov_b32 v55, v23
	v_dual_mov_b32 v54, v22 :: v_dual_mov_b32 v53, v21
	v_dual_mov_b32 v52, v20 :: v_dual_mov_b32 v51, v19
	v_dual_mov_b32 v50, v18 :: v_dual_mov_b32 v49, v17
	ds_load_b128 v[110:113], v100 offset:2336
	ds_load_b128 v[114:117], v100 offset:2352
	ds_load_u16_d16 v118, v101 offset:2048
	ds_load_u16_d16_hi v118, v101 offset:2176
	ds_load_u16_d16 v119, v101 offset:2304
	ds_load_u16_d16_hi v119, v101 offset:2432
	ds_load_u16_d16_hi v127, v101 offset:2496
	ds_load_u16_d16 v127, v101 offset:2368
	ds_load_u16_d16_hi v126, v101 offset:2240
	ds_load_u16_d16 v126, v101 offset:2112
	ds_load_u16_d16 v120, v101 offset:2560
	ds_load_u16_d16_hi v120, v101 offset:2688
	ds_load_u16_d16 v121, v101 offset:2816
	ds_load_u16_d16_hi v121, v101 offset:2944
	ds_load_u16_d16_hi v129, v101 offset:3008
	ds_load_u16_d16 v129, v101 offset:2880
	ds_load_u16_d16_hi v128, v101 offset:2752
	ds_load_u16_d16 v128, v101 offset:2624
	ds_load_u16_d16 v122, v101 offset:3072
	ds_load_u16_d16_hi v122, v101 offset:3200
	ds_load_u16_d16 v123, v101 offset:3328
	ds_load_u16_d16_hi v123, v101 offset:3456
	ds_load_u16_d16_hi v131, v101 offset:3520
	ds_load_u16_d16 v131, v101 offset:3392
	ds_load_u16_d16_hi v130, v101 offset:3264
	ds_load_u16_d16 v130, v101 offset:3136
	ds_load_u16_d16 v124, v101 offset:3584
	ds_load_u16_d16_hi v124, v101 offset:3712
	ds_load_u16_d16 v125, v101 offset:3840
	ds_load_u16_d16_hi v125, v101 offset:3968
	ds_load_u16_d16_hi v133, v101 offset:4032
	ds_load_u16_d16 v133, v101 offset:3904
	ds_load_u16_d16_hi v132, v101 offset:3776
	ds_load_u16_d16 v132, v101 offset:3648
	ds_load_b128 v[134:137], v100 offset:64
	ds_load_b128 v[138:141], v100 offset:80
	ds_load_b128 v[142:145], v100 offset:2368
	ds_load_b128 v[146:149], v100 offset:2384
	ds_load_u16_d16 v150, v101 offset:4096
	ds_load_u16_d16_hi v150, v101 offset:4224
	ds_load_u16_d16 v151, v101 offset:4352
	ds_load_u16_d16_hi v151, v101 offset:4480
	ds_load_u16_d16_hi v159, v101 offset:4544
	ds_load_u16_d16 v159, v101 offset:4416
	ds_load_u16_d16_hi v158, v101 offset:4288
	ds_load_u16_d16 v158, v101 offset:4160
	ds_load_u16_d16 v152, v101 offset:4608
	ds_load_u16_d16_hi v152, v101 offset:4736
	ds_load_u16_d16 v153, v101 offset:4864
	ds_load_u16_d16_hi v153, v101 offset:4992
	ds_load_u16_d16_hi v161, v101 offset:5056
	ds_load_u16_d16 v161, v101 offset:4928
	ds_load_u16_d16_hi v160, v101 offset:4800
	ds_load_u16_d16 v160, v101 offset:4672
	ds_load_u16_d16 v154, v101 offset:5120
	ds_load_u16_d16_hi v154, v101 offset:5248
	ds_load_u16_d16 v155, v101 offset:5376
	ds_load_u16_d16_hi v155, v101 offset:5504
	ds_load_u16_d16_hi v163, v101 offset:5568
	ds_load_u16_d16 v163, v101 offset:5440
	ds_load_u16_d16_hi v162, v101 offset:5312
	ds_load_u16_d16 v162, v101 offset:5184
	ds_load_u16_d16 v156, v101 offset:5632
	ds_load_u16_d16_hi v156, v101 offset:5760
	ds_load_u16_d16 v157, v101 offset:5888
	ds_load_u16_d16_hi v157, v101 offset:6016
	ds_load_u16_d16_hi v165, v101 offset:6080
	ds_load_u16_d16 v165, v101 offset:5952
	ds_load_u16_d16_hi v164, v101 offset:5824
	ds_load_u16_d16 v164, v101 offset:5696
	ds_load_b128 v[166:169], v100 offset:96
	ds_load_b128 v[170:173], v100 offset:112
	ds_load_u16_d16 v174, v101 offset:6144
	ds_load_u16_d16_hi v174, v101 offset:6272
	ds_load_u16_d16 v175, v101 offset:6400
	ds_load_u16_d16_hi v175, v101 offset:6528
	ds_load_u16_d16_hi v183, v101 offset:6592
	ds_load_u16_d16 v183, v101 offset:6464
	ds_load_u16_d16_hi v182, v101 offset:6336
	ds_load_u16_d16 v182, v101 offset:6208
	ds_load_u16_d16 v176, v101 offset:6656
	ds_load_u16_d16_hi v176, v101 offset:6784
	ds_load_u16_d16 v177, v101 offset:6912
	ds_load_u16_d16_hi v177, v101 offset:7040
	ds_load_u16_d16_hi v185, v101 offset:7104
	ds_load_u16_d16 v185, v101 offset:6976
	ds_load_u16_d16_hi v184, v101 offset:6848
	ds_load_u16_d16 v184, v101 offset:6720
	ds_load_u16_d16 v178, v101 offset:7168
	ds_load_u16_d16_hi v178, v101 offset:7296
	ds_load_u16_d16 v179, v101 offset:7424
	ds_load_u16_d16_hi v179, v101 offset:7552
	ds_load_u16_d16_hi v187, v101 offset:7616
	ds_load_u16_d16 v187, v101 offset:7488
	ds_load_u16_d16_hi v186, v101 offset:7360
	ds_load_u16_d16 v186, v101 offset:7232
	ds_load_u16_d16 v180, v101 offset:7680
	ds_load_u16_d16_hi v180, v101 offset:7808
	ds_load_u16_d16 v181, v101 offset:7936
	ds_load_u16_d16_hi v181, v101 offset:8064
	ds_load_u16_d16_hi v189, v101 offset:8128
	ds_load_u16_d16 v189, v101 offset:8000
	ds_load_u16_d16_hi v188, v101 offset:7872
	ds_load_u16_d16 v188, v101 offset:7744
	ds_load_b128 v[190:193], v100 offset:2400
	ds_load_b128 v[194:197], v100 offset:2416
	v_dual_mov_b32 v64, v32 :: v_dual_mov_b32 v63, v31
	v_dual_mov_b32 v62, v30 :: v_dual_mov_b32 v61, v29
	v_dual_mov_b32 v60, v28 :: v_dual_mov_b32 v59, v27
	v_dual_mov_b32 v58, v26 :: v_dual_mov_b32 v57, v25
	s_waitcnt lgkmcnt(62)
	v_wmma_f32_16x16x16_bf16 v[33:40], v[73:80], v[89:96], v[33:40]
	v_wmma_f32_16x16x16_bf16 v[41:48], v[73:80], v[102:109], v[41:48]
	v_wmma_f32_16x16x16_bf16 v[49:56], v[81:88], v[89:96], v[49:56]
	v_wmma_f32_16x16x16_bf16 v[57:64], v[81:88], v[102:109], v[57:64]
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_wmma_f32_16x16x16_bf16 v[33:40], v[65:72], v[118:125], v[33:40]
	v_wmma_f32_16x16x16_bf16 v[41:48], v[65:72], v[126:133], v[41:48]
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_wmma_f32_16x16x16_bf16 v[49:56], v[110:117], v[118:125], v[49:56]
	v_wmma_f32_16x16x16_bf16 v[57:64], v[110:117], v[126:133], v[57:64]
	s_waitcnt lgkmcnt(40)
	v_wmma_f32_16x16x16_bf16 v[33:40], v[134:141], v[150:157], v[33:40]
	s_waitcnt lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[41:48], v[134:141], v[158:165], v[41:48]
	v_wmma_f32_16x16x16_bf16 v[49:56], v[142:149], v[150:157], v[49:56]
	v_wmma_f32_16x16x16_bf16 v[57:64], v[142:149], v[158:165], v[57:64]
	s_waitcnt lgkmcnt(6)
	v_wmma_f32_16x16x16_bf16 v[33:40], v[166:173], v[174:181], v[33:40]
	s_waitcnt lgkmcnt(2)
	v_wmma_f32_16x16x16_bf16 v[41:48], v[166:173], v[182:189], v[41:48]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[49:56], v[190:197], v[174:181], v[49:56]
	v_wmma_f32_16x16x16_bf16 v[57:64], v[190:197], v[182:189], v[57:64]
.LBB0_16:
	s_and_not1_saveexec_b32 s15, s6
	s_cbranch_execz .LBB0_18
	s_or_b32 s14, s14, 31
	s_mov_b32 s6, s10
	v_lshl_add_u32 v33, s14, 7, v86
	v_lshl_add_u32 v34, s14, 16, v85
	s_mov_b32 s7, s11
	v_dual_mov_b32 v62, v30 :: v_dual_add_nc_u32 v83, v88, v83
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_or_b32_e32 v33, v33, v87
	v_or_b32_e32 v34, v34, v84
	v_dual_mov_b32 v60, v28 :: v_dual_add_nc_u32 v81, v81, v82
	v_dual_mov_b32 v53, v21 :: v_dual_mov_b32 v64, v32
	s_delay_alu instid0(VALU_DEP_4)
	v_add_nc_u32_e32 v35, 0x10000, v33
	v_add_nc_u32_e32 v36, 0x20000, v33
	v_lshlrev_b32_e32 v34, 1, v34
	v_add_nc_u32_e32 v37, 0x30000, v33
	v_add_nc_u32_e32 v38, 0x40000, v33
	v_add_nc_u32_e32 v40, 0x60000, v33
	v_add_nc_u32_e32 v39, 0x50000, v33
	s_clause 0x5
	buffer_load_b128 v[65:68], v33, s[8:11], 0 offen
	buffer_load_b128 v[69:72], v35, s[8:11], 0 offen
	buffer_load_b128 v[73:76], v36, s[8:11], 0 offen
	buffer_load_b128 v[77:80], v37, s[8:11], 0 offen
	buffer_load_b128 v[84:87], v38, s[8:11], 0 offen
	buffer_load_b128 v[89:92], v39, s[8:11], 0 offen
	v_add_nc_u32_e32 v33, 0x70000, v33
	v_dual_mov_b32 v42, v10 :: v_dual_add_nc_u32 v35, 0x2000, v34
	v_dual_mov_b32 v41, v9 :: v_dual_add_nc_u32 v36, 0x4000, v34
	v_dual_mov_b32 v44, v12 :: v_dual_add_nc_u32 v37, 0x6000, v34
	s_clause 0x1
	buffer_load_b128 v[93:96], v40, s[8:11], 0 offen
	buffer_load_b128 v[102:105], v33, s[8:11], 0 offen
	s_clause 0x3
	buffer_load_b128 v[106:109], v34, s[4:7], 0 offen slc
	buffer_load_b128 v[110:113], v35, s[4:7], 0 offen slc
	buffer_load_b128 v[114:117], v36, s[4:7], 0 offen slc
	buffer_load_b128 v[118:121], v37, s[4:7], 0 offen slc
	v_dual_mov_b32 v46, v14 :: v_dual_add_nc_u32 v33, 0x8000, v34
	v_dual_mov_b32 v48, v16 :: v_dual_add_nc_u32 v35, 0xa000, v34
	v_dual_mov_b32 v43, v11 :: v_dual_add_nc_u32 v36, 0xc000, v34
	v_dual_mov_b32 v50, v18 :: v_dual_add_nc_u32 v37, 0xe000, v34
	v_dual_mov_b32 v45, v13 :: v_dual_add_nc_u32 v38, 0x10000, v34
	v_dual_mov_b32 v52, v20 :: v_dual_add_nc_u32 v39, 0x12000, v34
	s_clause 0x5
	buffer_load_b128 v[122:125], v33, s[4:7], 0 offen slc
	buffer_load_b128 v[126:129], v35, s[4:7], 0 offen slc
	buffer_load_b128 v[130:133], v36, s[4:7], 0 offen slc
	buffer_load_b128 v[134:137], v37, s[4:7], 0 offen slc
	buffer_load_b128 v[138:141], v38, s[4:7], 0 offen slc
	buffer_load_b128 v[142:145], v39, s[4:7], 0 offen slc
	v_mov_b32_e32 v39, v7
	v_dual_mov_b32 v54, v22 :: v_dual_add_nc_u32 v33, 0x14000, v34
	v_dual_mov_b32 v56, v24 :: v_dual_add_nc_u32 v35, 0x16000, v34
	v_dual_mov_b32 v47, v15 :: v_dual_add_nc_u32 v36, 0x18000, v34
	v_dual_mov_b32 v58, v26 :: v_dual_add_nc_u32 v37, 0x1a000, v34
	v_dual_mov_b32 v49, v17 :: v_dual_add_nc_u32 v38, 0x1c000, v34
	v_dual_mov_b32 v51, v19 :: v_dual_add_nc_u32 v34, 0x1e000, v34
	s_clause 0x5
	buffer_load_b128 v[146:149], v33, s[4:7], 0 offen slc
	buffer_load_b128 v[150:153], v35, s[4:7], 0 offen slc
	buffer_load_b128 v[154:157], v36, s[4:7], 0 offen slc
	buffer_load_b128 v[158:161], v37, s[4:7], 0 offen slc
	buffer_load_b128 v[162:165], v38, s[4:7], 0 offen slc
	buffer_load_b128 v[166:169], v34, s[4:7], 0 offen slc
	v_dual_mov_b32 v33, v1 :: v_dual_mov_b32 v34, v2
	v_dual_mov_b32 v35, v3 :: v_dual_mov_b32 v36, v4
	v_dual_mov_b32 v37, v5 :: v_dual_mov_b32 v38, v6
	v_dual_mov_b32 v40, v8 :: v_dual_mov_b32 v55, v23
	v_mov_b32_e32 v57, v25
	v_mov_b32_e32 v59, v27
	v_mov_b32_e32 v61, v29
	v_mov_b32_e32 v63, v31
	s_waitcnt vmcnt(23)
	ds_store_b128 v83, v[65:68] offset:4608
	s_waitcnt vmcnt(22)
	ds_store_b128 v83, v[69:72] offset:5184
	s_waitcnt vmcnt(21)
	ds_store_b128 v83, v[73:76] offset:5760
	s_waitcnt vmcnt(20)
	ds_store_b128 v83, v[77:80] offset:6336
	s_waitcnt vmcnt(19)
	ds_store_b128 v83, v[84:87] offset:6912
	s_waitcnt vmcnt(18)
	ds_store_b128 v83, v[89:92] offset:7488
	s_waitcnt vmcnt(17)
	ds_store_b128 v83, v[93:96] offset:8064
	s_waitcnt vmcnt(16)
	ds_store_b128 v83, v[102:105] offset:8640
	s_waitcnt vmcnt(15)
	ds_store_b128 v81, v[106:109] offset:8192
	s_waitcnt vmcnt(14)
	ds_store_b128 v81, v[110:113] offset:8704
	s_waitcnt vmcnt(13)
	ds_store_b128 v81, v[114:117] offset:9216
	s_waitcnt vmcnt(12)
	ds_store_b128 v81, v[118:121] offset:9728
	s_waitcnt vmcnt(11)
	ds_store_b128 v81, v[122:125] offset:10240
	s_waitcnt vmcnt(10)
	ds_store_b128 v81, v[126:129] offset:10752
	s_waitcnt vmcnt(9)
	ds_store_b128 v81, v[130:133] offset:11264
	s_waitcnt vmcnt(8)
	ds_store_b128 v81, v[134:137] offset:11776
	s_waitcnt vmcnt(7)
	ds_store_b128 v81, v[138:141] offset:12288
	s_waitcnt vmcnt(6)
	ds_store_b128 v81, v[142:145] offset:12800
	s_waitcnt vmcnt(5)
	ds_store_b128 v81, v[146:149] offset:13312
	s_waitcnt vmcnt(4)
	ds_store_b128 v81, v[150:153] offset:13824
	s_waitcnt vmcnt(3)
	ds_store_b128 v81, v[154:157] offset:14336
	s_waitcnt vmcnt(2)
	ds_store_b128 v81, v[158:161] offset:14848
	s_waitcnt vmcnt(1)
	ds_store_b128 v81, v[162:165] offset:15360
	s_waitcnt vmcnt(0)
	ds_store_b128 v81, v[166:169] offset:15872
.LBB0_18:
	s_or_b32 exec_lo, exec_lo, s15
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_mov_b32 s4, exec_lo
	v_cmpx_lt_u32_e32 31, v0
	s_cbranch_execz .LBB0_21
	ds_load_b128 v[1:4], v100 offset:4608
	ds_load_b128 v[5:8], v100 offset:4624
	ds_load_b128 v[9:12], v100 offset:4640
	ds_load_b128 v[13:16], v100 offset:4656
	ds_load_b128 v[17:20], v100 offset:6912
	ds_load_b128 v[21:24], v100 offset:6928
	ds_load_u16_d16 v25, v101 offset:8192
	ds_load_u16_d16_hi v25, v101 offset:8320
	ds_load_u16_d16 v26, v101 offset:8448
	ds_load_u16_d16_hi v26, v101 offset:8576
	ds_load_u16_d16_hi v66, v101 offset:8640
	ds_load_u16_d16 v66, v101 offset:8512
	ds_load_u16_d16_hi v65, v101 offset:8384
	ds_load_u16_d16 v65, v101 offset:8256
	ds_load_u16_d16 v27, v101 offset:8704
	ds_load_u16_d16_hi v27, v101 offset:8832
	ds_load_u16_d16 v28, v101 offset:8960
	ds_load_u16_d16_hi v28, v101 offset:9088
	ds_load_u16_d16_hi v68, v101 offset:9152
	ds_load_u16_d16 v68, v101 offset:9024
	ds_load_u16_d16_hi v67, v101 offset:8896
	ds_load_u16_d16 v67, v101 offset:8768
	ds_load_u16_d16 v29, v101 offset:9216
	ds_load_u16_d16_hi v29, v101 offset:9344
	ds_load_u16_d16 v30, v101 offset:9472
	ds_load_u16_d16_hi v30, v101 offset:9600
	ds_load_u16_d16_hi v70, v101 offset:9664
	ds_load_u16_d16 v70, v101 offset:9536
	ds_load_u16_d16_hi v69, v101 offset:9408
	ds_load_u16_d16 v69, v101 offset:9280
	ds_load_u16_d16 v31, v101 offset:9728
	ds_load_u16_d16_hi v31, v101 offset:9856
	ds_load_u16_d16 v32, v101 offset:9984
	ds_load_u16_d16_hi v32, v101 offset:10112
	ds_load_u16_d16_hi v72, v101 offset:10176
	ds_load_u16_d16 v72, v101 offset:10048
	ds_load_u16_d16_hi v71, v101 offset:9920
	ds_load_u16_d16 v71, v101 offset:9792
	ds_load_u16_d16 v73, v101 offset:10240
	ds_load_u16_d16_hi v73, v101 offset:10368
	ds_load_u16_d16 v74, v101 offset:10496
	ds_load_u16_d16_hi v74, v101 offset:10624
	ds_load_u16_d16_hi v82, v101 offset:10688
	ds_load_u16_d16 v82, v101 offset:10560
	ds_load_u16_d16_hi v81, v101 offset:10432
	ds_load_u16_d16 v81, v101 offset:10304
	ds_load_u16_d16 v75, v101 offset:10752
	ds_load_u16_d16_hi v75, v101 offset:10880
	ds_load_u16_d16 v76, v101 offset:11008
	ds_load_u16_d16_hi v76, v101 offset:11136
	ds_load_u16_d16_hi v84, v101 offset:11200
	ds_load_u16_d16 v84, v101 offset:11072
	ds_load_u16_d16_hi v83, v101 offset:10944
	ds_load_u16_d16 v83, v101 offset:10816
	ds_load_u16_d16 v77, v101 offset:11264
	ds_load_u16_d16_hi v77, v101 offset:11392
	ds_load_u16_d16 v78, v101 offset:11520
	ds_load_u16_d16_hi v78, v101 offset:11648
	ds_load_u16_d16_hi v86, v101 offset:11712
	ds_load_u16_d16 v86, v101 offset:11584
	ds_load_u16_d16_hi v85, v101 offset:11456
	ds_load_u16_d16 v85, v101 offset:11328
	ds_load_u16_d16 v79, v101 offset:11776
	ds_load_u16_d16_hi v79, v101 offset:11904
	ds_load_u16_d16 v80, v101 offset:12032
	ds_load_u16_d16_hi v80, v101 offset:12160
	ds_load_u16_d16_hi v88, v101 offset:12224
	ds_load_u16_d16 v88, v101 offset:12096
	ds_load_u16_d16_hi v87, v101 offset:11968
	ds_load_u16_d16 v87, v101 offset:11840
	s_waitcnt lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[33:40], v[1:8], v[25:32], v[33:40]
	s_waitcnt lgkmcnt(32)
	v_wmma_f32_16x16x16_bf16 v[41:48], v[1:8], v[65:72], v[41:48]
	v_wmma_f32_16x16x16_bf16 v[49:56], v[17:24], v[25:32], v[49:56]
	v_wmma_f32_16x16x16_bf16 v[57:64], v[17:24], v[65:72], v[57:64]
	ds_load_b128 v[17:20], v100 offset:6944
	ds_load_b128 v[21:24], v100 offset:6960
	s_lshr_b32 s8, s13, 26
	v_lshlrev_b32_e32 v2, 5, v97
	s_add_i32 s8, s2, s8
	s_clause 0x1
	s_load_b64 s[4:5], s[0:1], 0x48
	s_load_b64 s[6:7], s[0:1], 0x58
	s_and_b32 s8, s8, 0x1fffc0
	ds_load_u16_d16 v112, v101 offset:14848
	ds_load_u16_d16_hi v112, v101 offset:14976
	ds_load_u16_d16 v113, v101 offset:15104
	ds_load_u16_d16_hi v113, v101 offset:15232
	ds_load_u16_d16_hi v121, v101 offset:15296
	ds_load_u16_d16 v121, v101 offset:15168
	ds_load_u16_d16_hi v120, v101 offset:15040
	ds_load_u16_d16 v120, v101 offset:14912
	s_sub_i32 s2, s2, s8
	ds_load_u16_d16 v114, v101 offset:15360
	ds_load_u16_d16_hi v114, v101 offset:15488
	ds_load_u16_d16 v115, v101 offset:15616
	ds_load_u16_d16_hi v115, v101 offset:15744
	ds_load_u16_d16_hi v123, v101 offset:15808
	ds_load_u16_d16 v123, v101 offset:15680
	ds_load_u16_d16_hi v122, v101 offset:15552
	ds_load_u16_d16 v122, v101 offset:15424
	ds_load_u16_d16_hi v125, v101 offset:16320
	ds_load_u16_d16 v125, v101 offset:16192
	ds_load_u16_d16_hi v124, v101 offset:16064
	ds_load_u16_d16 v124, v101 offset:15936
	ds_load_b128 v[126:129], v100 offset:7008
	ds_load_b128 v[130:133], v100 offset:7024
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[33:40], v[9:16], v[73:80], v[33:40]
	v_add_co_u32 v0, s8, s12, v0
	v_wmma_f32_16x16x16_bf16 v[41:48], v[9:16], v[81:88], v[41:48]
	ds_load_b128 v[3:6], v100 offset:4672
	ds_load_b128 v[7:10], v100 offset:4688
	ds_load_b128 v[25:28], v100 offset:6976
	ds_load_b128 v[29:32], v100 offset:6992
	ds_load_u16_d16 v65, v101 offset:12288
	ds_load_u16_d16_hi v65, v101 offset:12416
	ds_load_u16_d16 v66, v101 offset:12544
	ds_load_u16_d16_hi v66, v101 offset:12672
	ds_load_u16_d16_hi v90, v101 offset:12736
	ds_load_u16_d16 v90, v101 offset:12608
	ds_load_u16_d16_hi v89, v101 offset:12480
	ds_load_u16_d16 v89, v101 offset:12352
	ds_load_u16_d16 v67, v101 offset:12800
	ds_load_u16_d16_hi v67, v101 offset:12928
	ds_load_u16_d16 v68, v101 offset:13056
	ds_load_u16_d16_hi v68, v101 offset:13184
	ds_load_u16_d16_hi v92, v101 offset:13248
	ds_load_u16_d16 v92, v101 offset:13120
	ds_load_u16_d16_hi v91, v101 offset:12992
	ds_load_u16_d16 v91, v101 offset:12864
	ds_load_u16_d16 v69, v101 offset:13312
	ds_load_u16_d16_hi v69, v101 offset:13440
	ds_load_u16_d16 v70, v101 offset:13568
	ds_load_u16_d16_hi v70, v101 offset:13696
	ds_load_u16_d16_hi v94, v101 offset:13760
	ds_load_u16_d16 v94, v101 offset:13632
	ds_load_u16_d16_hi v93, v101 offset:13504
	ds_load_u16_d16 v93, v101 offset:13376
	ds_load_u16_d16 v71, v101 offset:13824
	ds_load_u16_d16_hi v71, v101 offset:13952
	ds_load_u16_d16 v72, v101 offset:14080
	ds_load_u16_d16_hi v72, v101 offset:14208
	ds_load_u16_d16_hi v96, v101 offset:14272
	ds_load_u16_d16 v96, v101 offset:14144
	ds_load_u16_d16_hi v95, v101 offset:14016
	ds_load_u16_d16 v95, v101 offset:13888
	ds_load_b128 v[102:105], v100 offset:4704
	ds_load_b128 v[106:109], v100 offset:4720
	ds_load_u16_d16 v116, v101 offset:15872
	ds_load_u16_d16_hi v116, v101 offset:16000
	ds_load_u16_d16 v117, v101 offset:16128
	ds_load_u16_d16_hi v117, v101 offset:16256
	ds_load_u16_d16 v110, v101 offset:14336
	ds_load_u16_d16_hi v110, v101 offset:14464
	ds_load_u16_d16 v111, v101 offset:14592
	ds_load_u16_d16_hi v111, v101 offset:14720
	ds_load_u16_d16_hi v119, v101 offset:14784
	ds_load_u16_d16 v119, v101 offset:14656
	ds_load_u16_d16_hi v118, v101 offset:14528
	ds_load_u16_d16 v118, v101 offset:14400
	s_waitcnt lgkmcnt(18)
	v_wmma_f32_16x16x16_bf16 v[33:40], v[3:10], v[65:72], v[33:40]
	v_wmma_f32_16x16x16_bf16 v[49:56], v[17:24], v[73:80], v[49:56]
	v_wmma_f32_16x16x16_bf16 v[57:64], v[17:24], v[81:88], v[57:64]
	s_waitcnt lgkmcnt(14)
	v_wmma_f32_16x16x16_bf16 v[41:48], v[3:10], v[89:96], v[41:48]
	v_mov_b32_e32 v5, 1
	v_lshl_add_u32 v11, s2, 11, v2
	s_ashr_i32 s2, s12, 31
	v_wmma_f32_16x16x16_bf16 v[49:56], v[25:32], v[65:72], v[49:56]
	v_add_co_ci_u32_e64 v1, null, s2, 0, s8
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_ashrrev_i32_e32 v12, 31, v11
	v_wmma_f32_16x16x16_bf16 v[57:64], v[25:32], v[89:96], v[57:64]
	v_lshlrev_b64 v[0:1], 2, v[0:1]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[33:40], v[102:109], v[110:117], v[33:40]
	v_lshlrev_b64 v[3:4], 2, v[11:12]
	v_wmma_f32_16x16x16_bf16 v[49:56], v[126:133], v[110:117], v[49:56]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[41:48], v[102:109], v[118:125], v[41:48]
	v_wmma_f32_16x16x16_bf16 v[57:64], v[126:133], v[118:125], v[57:64]
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v3, vcc_lo, s4, v3
	v_add_co_ci_u32_e64 v4, null, s5, v4, vcc_lo
	v_add_co_u32 v0, vcc_lo, s6, v0
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v1, null, s7, v1, vcc_lo
	s_clause 0x7
	global_store_b128 v[3:4], v[37:40], off offset:16
	global_store_b128 v[3:4], v[33:36], off
	global_store_b128 v[3:4], v[53:56], off offset:80
	global_store_b128 v[3:4], v[49:52], off offset:64
	global_store_b128 v[3:4], v[45:48], off offset:48
	global_store_b128 v[3:4], v[41:44], off offset:32
	global_store_b128 v[3:4], v[61:64], off offset:112
	global_store_b128 v[3:4], v[57:60], off offset:96
	s_waitcnt_vscnt null, 0x0
	global_atomic_add_u32 v3, v[0:1], v5, off offset:-128 glc
	s_waitcnt vmcnt(0)
	buffer_gl1_inv
	buffer_gl0_inv
	v_cmp_eq_u32_e32 vcc_lo, 3, v3
	s_and_b32 exec_lo, exec_lo, vcc_lo
	s_cbranch_execz .LBB0_21
	v_lshl_add_u32 v2, s3, 13, v2
	s_load_b64 s[0:1], s[0:1], 0x30
	s_mov_b32 s3, 0x21027000
	s_mov_b32 s2, -1
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v3, 31, v2
	v_lshlrev_b64 v[2:3], 2, v[2:3]
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v94, vcc_lo, s4, v2
	v_add_co_ci_u32_e64 v95, null, s5, v3, vcc_lo
	s_clause 0x6
	global_load_b128 v[2:5], v[94:95], off
	global_load_b128 v[6:9], v[94:95], off offset:16
	global_load_b128 v[10:13], v[94:95], off offset:64
	global_load_b128 v[14:17], v[94:95], off offset:80
	global_load_b128 v[18:21], v[94:95], off offset:32
	global_load_b128 v[22:25], v[94:95], off offset:48
	global_load_b128 v[26:29], v[94:95], off offset:96
	v_add_co_u32 v62, vcc_lo, 0x2000, v94
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v63, null, 0, v95, vcc_lo
	v_add_co_u32 v100, vcc_lo, 0x4000, v94
	s_clause 0x7
	global_load_b128 v[30:33], v[94:95], off offset:112
	global_load_b128 v[34:37], v[62:63], off
	global_load_b128 v[38:41], v[62:63], off offset:16
	global_load_b128 v[42:45], v[62:63], off offset:64
	global_load_b128 v[46:49], v[62:63], off offset:80
	global_load_b128 v[50:53], v[62:63], off offset:32
	global_load_b128 v[54:57], v[62:63], off offset:48
	global_load_b128 v[58:61], v[62:63], off offset:96
	v_add_co_ci_u32_e64 v101, null, 0, v95, vcc_lo
	s_clause 0x7
	global_load_b128 v[62:65], v[62:63], off offset:112
	global_load_b128 v[66:69], v[100:101], off
	global_load_b128 v[70:73], v[100:101], off offset:16
	global_load_b128 v[74:77], v[100:101], off offset:64
	global_load_b128 v[78:81], v[100:101], off offset:80
	global_load_b128 v[82:85], v[100:101], off offset:32
	global_load_b128 v[86:89], v[100:101], off offset:48
	global_load_b128 v[90:93], v[100:101], off offset:96
	v_add_co_u32 v94, vcc_lo, 0x6000, v94
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v95, null, 0, v95, vcc_lo
	s_clause 0x8
	global_load_b128 v[100:103], v[100:101], off offset:112
	global_load_b128 v[104:107], v[94:95], off
	global_load_b128 v[108:111], v[94:95], off offset:16
	global_load_b128 v[112:115], v[94:95], off offset:64
	global_load_b128 v[116:119], v[94:95], off offset:80
	global_load_b128 v[120:123], v[94:95], off offset:32
	global_load_b128 v[124:127], v[94:95], off offset:48
	global_load_b128 v[128:131], v[94:95], off offset:96
	global_load_b128 v[132:135], v[94:95], off offset:112
	v_ashrrev_i32_e32 v94, 31, v97
	v_lshlrev_b32_e32 v96, 4, v99
	s_waitcnt lgkmcnt(0)
	s_and_b32 s1, s1, 0xffff
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshrrev_b32_e32 v94, 28, v94
	v_add_nc_u32_e32 v94, v97, v94
	s_waitcnt vmcnt(31)
	v_dual_add_f32 v4, 0, v4 :: v_dual_add_nc_u32 v97, s12, v98
	s_waitcnt vmcnt(29)
	v_dual_add_f32 v2, 0, v2 :: v_dual_add_f32 v11, 0, v11
	v_add_f32_e32 v3, 0, v3
	v_ashrrev_i32_e32 v95, 4, v94
	v_lshrrev_b32_e32 v94, 31, v94
	v_add_f32_e32 v5, 0, v5
	s_waitcnt vmcnt(23)
	v_dual_add_f32 v9, 0, v9 :: v_dual_add_f32 v2, v2, v34
	v_dual_add_f32 v28, 0, v28 :: v_dual_add_f32 v3, v3, v35
	v_add_nc_u32_e32 v94, v95, v94
	v_dual_add_f32 v30, 0, v30 :: v_dual_add_f32 v5, v5, v37
	s_waitcnt vmcnt(15)
	v_dual_add_f32 v9, v9, v41 :: v_dual_add_f32 v2, v2, v66
	s_delay_alu instid0(VALU_DEP_3)
	v_dual_add_f32 v7, 0, v7 :: v_dual_and_b32 v94, 0x1ffffe, v94
	v_dual_add_f32 v4, v4, v36 :: v_dual_add_f32 v11, v11, v43
	v_dual_add_f32 v28, v28, v60 :: v_dual_add_f32 v3, v3, v67
	v_dual_add_f32 v30, v30, v62 :: v_dual_add_f32 v5, v5, v69
	s_waitcnt vmcnt(7)
	v_dual_add_f32 v9, v9, v73 :: v_dual_add_f32 v2, v2, v104
	v_dual_add_f32 v6, 0, v6 :: v_dual_add_f32 v13, 0, v13
	v_dual_add_f32 v8, 0, v8 :: v_dual_add_f32 v15, 0, v15
	v_dual_add_f32 v32, 0, v32 :: v_dual_add_f32 v7, v7, v39
	v_dual_add_f32 v4, v4, v68 :: v_dual_add_f32 v11, v11, v75
	v_dual_add_f32 v28, v28, v92 :: v_dual_add_f32 v3, v3, v105
	v_dual_add_f32 v30, v30, v100 :: v_dual_add_f32 v5, v5, v107
	s_waitcnt vmcnt(6)
	v_add_f32_e32 v9, v9, v111
	v_bfe_u32 v34, v2, 16, 1
	v_dual_add_f32 v6, v6, v38 :: v_dual_add_f32 v13, v13, v45
	v_dual_add_f32 v8, v8, v40 :: v_dual_add_f32 v15, v15, v47
	v_dual_add_f32 v32, v32, v64 :: v_dual_add_f32 v7, v7, v71
	s_waitcnt vmcnt(5)
	v_dual_add_f32 v4, v4, v106 :: v_dual_add_f32 v11, v11, v113
	v_or_b32_e32 v35, 0x400000, v2
	v_bfe_u32 v36, v3, 16, 1
	v_bfe_u32 v40, v5, 16, 1
	v_add3_u32 v34, v34, v2, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_dual_add_f32 v12, 0, v12 :: v_dual_add_f32 v19, 0, v19
	v_dual_add_f32 v6, v6, v70 :: v_dual_add_f32 v13, v13, v77
	v_dual_add_f32 v32, v32, v102 :: v_dual_add_f32 v7, v7, v109
	v_or_b32_e32 v37, 0x400000, v3
	v_bfe_u32 v38, v4, 16, 1
	v_or_b32_e32 v41, 0x400000, v5
	v_add3_u32 v36, v36, v3, 0x7fff
	v_add3_u32 v40, v40, v5, 0x7fff
	v_cndmask_b32_e32 v2, v34, v35, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_dual_add_f32 v10, 0, v10 :: v_dual_add_f32 v17, 0, v17
	v_dual_add_f32 v12, v12, v44 :: v_dual_add_f32 v19, v19, v51
	v_dual_add_f32 v6, v6, v108 :: v_dual_add_f32 v13, v13, v115
	s_waitcnt vmcnt(0)
	v_dual_add_f32 v30, v30, v132 :: v_dual_cndmask_b32 v3, v36, v37
	v_or_b32_e32 v39, 0x400000, v4
	v_bfe_u32 v44, v7, 16, 1
	v_add3_u32 v38, v38, v4, 0x7fff
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_dual_add_f32 v16, 0, v16 :: v_dual_add_f32 v23, 0, v23
	v_dual_add_f32 v10, v10, v42 :: v_dual_add_f32 v17, v17, v49
	v_dual_add_f32 v8, v8, v72 :: v_dual_add_f32 v15, v15, v79
	v_bfe_u32 v42, v6, 16, 1
	v_or_b32_e32 v45, 0x400000, v7
	v_add3_u32 v44, v44, v7, 0x7fff
	v_cndmask_b32_e32 v4, v38, v39, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_dual_add_f32 v14, 0, v14 :: v_dual_add_f32 v21, 0, v21
	v_dual_add_f32 v16, v16, v48 :: v_dual_add_f32 v23, v23, v55
	v_dual_add_f32 v8, v8, v110 :: v_dual_add_f32 v15, v15, v117
	v_or_b32_e32 v43, 0x400000, v6
	v_bfe_u32 v48, v9, 16, 1
	v_add3_u32 v42, v42, v6, 0x7fff
	v_cndmask_b32_e32 v5, v40, v41, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_dual_add_f32 v20, 0, v20 :: v_dual_add_f32 v27, 0, v27
	v_dual_add_f32 v14, v14, v46 :: v_dual_add_f32 v21, v21, v53
	v_dual_add_f32 v10, v10, v74 :: v_dual_add_f32 v17, v17, v81
	v_bfe_u32 v46, v8, 16, 1
	v_or_b32_e32 v49, 0x400000, v9
	v_add3_u32 v48, v48, v9, 0x7fff
	v_cndmask_b32_e32 v6, v42, v43, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_dual_add_f32 v18, 0, v18 :: v_dual_add_f32 v25, 0, v25
	v_dual_add_f32 v20, v20, v52 :: v_dual_add_f32 v27, v27, v59
	v_dual_add_f32 v10, v10, v112 :: v_dual_add_f32 v17, v17, v119
	v_or_b32_e32 v47, 0x400000, v8
	v_bfe_u32 v52, v11, 16, 1
	v_add3_u32 v46, v46, v8, 0x7fff
	v_cndmask_b32_e32 v7, v44, v45, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_dual_add_f32 v24, 0, v24 :: v_dual_add_f32 v31, 0, v31
	v_dual_add_f32 v18, v18, v50 :: v_dual_add_f32 v25, v25, v57
	v_dual_add_f32 v12, v12, v76 :: v_dual_add_f32 v19, v19, v83
	v_bfe_u32 v50, v10, 16, 1
	v_or_b32_e32 v53, 0x400000, v11
	v_add3_u32 v52, v52, v11, 0x7fff
	v_cndmask_b32_e32 v8, v46, v47, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_dual_add_f32 v22, 0, v22 :: v_dual_add_f32 v29, 0, v29
	v_dual_add_f32 v24, v24, v56 :: v_dual_add_f32 v31, v31, v63
	v_dual_add_f32 v12, v12, v114 :: v_dual_add_f32 v19, v19, v121
	v_or_b32_e32 v51, 0x400000, v10
	v_bfe_u32 v56, v13, 16, 1
	v_add3_u32 v50, v50, v10, 0x7fff
	v_cndmask_b32_e32 v9, v48, v49, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_dual_add_f32 v22, v22, v54 :: v_dual_add_f32 v29, v29, v61
	v_dual_add_f32 v14, v14, v78 :: v_dual_add_f32 v21, v21, v85
	v_bfe_u32 v54, v12, 16, 1
	v_or_b32_e32 v57, 0x400000, v13
	v_add3_u32 v56, v56, v13, 0x7fff
	v_cndmask_b32_e32 v10, v50, v51, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_dual_add_f32 v26, 0, v26 :: v_dual_add_f32 v33, 0, v33
	v_dual_add_f32 v14, v14, v116 :: v_dual_add_f32 v21, v21, v123
	v_or_b32_e32 v55, 0x400000, v12
	v_bfe_u32 v60, v15, 16, 1
	v_add3_u32 v54, v54, v12, 0x7fff
	v_cndmask_b32_e32 v11, v52, v53, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_dual_add_f32 v26, v26, v58 :: v_dual_add_f32 v33, v33, v65
	v_dual_add_f32 v16, v16, v80 :: v_dual_add_f32 v23, v23, v87
	v_bfe_u32 v58, v14, 16, 1
	v_or_b32_e32 v61, 0x400000, v15
	v_add3_u32 v60, v60, v15, 0x7fff
	v_cndmask_b32_e32 v12, v54, v55, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_dual_add_f32 v16, v16, v118 :: v_dual_add_f32 v23, v23, v125
	v_or_b32_e32 v59, 0x400000, v14
	v_bfe_u32 v64, v17, 16, 1
	v_add3_u32 v58, v58, v14, 0x7fff
	v_cndmask_b32_e32 v13, v56, v57, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_dual_add_f32 v18, v18, v82 :: v_dual_add_f32 v25, v25, v89
	v_bfe_u32 v62, v16, 16, 1
	v_or_b32_e32 v65, 0x400000, v17
	v_add3_u32 v64, v64, v17, 0x7fff
	v_cndmask_b32_e32 v14, v58, v59, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_dual_add_f32 v18, v18, v120 :: v_dual_add_f32 v25, v25, v127
	v_or_b32_e32 v63, 0x400000, v16
	v_bfe_u32 v68, v19, 16, 1
	v_add3_u32 v62, v62, v16, 0x7fff
	v_cndmask_b32_e32 v15, v60, v61, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	v_dual_add_f32 v20, v20, v84 :: v_dual_add_f32 v27, v27, v91
	v_bfe_u32 v66, v18, 16, 1
	v_or_b32_e32 v69, 0x400000, v19
	v_add3_u32 v68, v68, v19, 0x7fff
	v_cndmask_b32_e32 v16, v62, v63, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v17, v17
	v_dual_add_f32 v20, v20, v122 :: v_dual_add_f32 v27, v27, v129
	v_or_b32_e32 v67, 0x400000, v18
	v_bfe_u32 v72, v21, 16, 1
	v_add3_u32 v66, v66, v18, 0x7fff
	v_cndmask_b32_e32 v17, v64, v65, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v18, v18
	v_dual_add_f32 v22, v22, v86 :: v_dual_add_f32 v29, v29, v93
	v_bfe_u32 v70, v20, 16, 1
	v_or_b32_e32 v73, 0x400000, v21
	v_add3_u32 v72, v72, v21, 0x7fff
	v_cndmask_b32_e32 v18, v66, v67, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v19, v19
	v_dual_add_f32 v22, v22, v124 :: v_dual_add_f32 v29, v29, v131
	v_or_b32_e32 v71, 0x400000, v20
	v_bfe_u32 v76, v23, 16, 1
	v_add3_u32 v70, v70, v20, 0x7fff
	v_cndmask_b32_e32 v19, v68, v69, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v20, v20
	v_dual_add_f32 v24, v24, v88 :: v_dual_add_f32 v31, v31, v101
	v_bfe_u32 v74, v22, 16, 1
	v_or_b32_e32 v77, 0x400000, v23
	v_add3_u32 v76, v76, v23, 0x7fff
	v_cndmask_b32_e32 v20, v70, v71, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v21, v21
	v_dual_add_f32 v24, v24, v126 :: v_dual_add_f32 v31, v31, v133
	v_or_b32_e32 v75, 0x400000, v22
	v_bfe_u32 v80, v25, 16, 1
	v_add3_u32 v74, v74, v22, 0x7fff
	v_cndmask_b32_e32 v21, v72, v73, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v22, v22
	v_dual_add_f32 v26, v26, v90 :: v_dual_add_f32 v33, v33, v103
	v_bfe_u32 v78, v24, 16, 1
	v_or_b32_e32 v81, 0x400000, v25
	v_add3_u32 v80, v80, v25, 0x7fff
	v_cndmask_b32_e32 v22, v74, v75, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v23, v23
	v_dual_add_f32 v26, v26, v128 :: v_dual_add_f32 v33, v33, v135
	v_or_b32_e32 v79, 0x400000, v24
	v_bfe_u32 v84, v27, 16, 1
	v_add3_u32 v78, v78, v24, 0x7fff
	v_cndmask_b32_e32 v23, v76, v77, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v24, v24
	v_bfe_u32 v82, v26, 16, 1
	v_or_b32_e32 v85, 0x400000, v27
	v_bfe_u32 v99, v33, 16, 1
	v_add3_u32 v84, v84, v27, 0x7fff
	v_cndmask_b32_e32 v24, v78, v79, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v25, v25
	v_or_b32_e32 v83, 0x400000, v26
	v_bfe_u32 v88, v29, 16, 1
	v_or_b32_e32 v100, 0x400000, v33
	v_add3_u32 v82, v82, v26, 0x7fff
	v_add3_u32 v99, v99, v33, 0x7fff
	v_add_f32_e32 v28, v28, v130
	v_cndmask_b32_e32 v25, v80, v81, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v26, v26
	v_or_b32_e32 v89, 0x400000, v29
	v_add3_u32 v88, v88, v29, 0x7fff
	v_bfe_u32 v86, v28, 16, 1
	v_or_b32_e32 v87, 0x400000, v28
	v_cndmask_b32_e32 v26, v82, v83, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v27, v27
	v_bfe_u32 v92, v31, 16, 1
	v_add3_u32 v86, v86, v28, 0x7fff
	v_bfe_u32 v90, v30, 16, 1
	v_or_b32_e32 v93, 0x400000, v31
	v_cndmask_b32_e32 v27, v84, v85, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v28, v28
	v_add3_u32 v92, v92, v31, 0x7fff
	v_sub_nc_u32_e32 v94, v95, v94
	v_add_lshl_u32 v34, v97, v96, 1
	v_add_f32_e32 v32, v32, v134
	v_cndmask_b32_e32 v28, v86, v87, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v29, v29
	v_or_b32_e32 v91, 0x400000, v30
	v_add3_u32 v90, v90, v30, 0x7fff
	v_lshrrev_b32_e32 v2, 16, v2
	v_lshl_add_u32 v34, v94, 11, v34
	v_cndmask_b32_e32 v29, v88, v89, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v30, v30
	v_bfe_u32 v95, v32, 16, 1
	v_lshrrev_b32_e32 v3, 16, v3
	buffer_store_b16 v2, v34, s[0:3], 0 offen
	v_add_nc_u32_e32 v2, 0x1000, v34
	v_dual_cndmask_b32 v30, v90, v91 :: v_dual_add_nc_u32 v35, 0x2000, v34
	v_cmp_u_f32_e32 vcc_lo, v31, v31
	v_lshrrev_b32_e32 v4, 16, v4
	v_lshrrev_b32_e32 v5, 16, v5
	v_add_nc_u32_e32 v36, 0x3000, v34
	v_or_b32_e32 v98, 0x400000, v32
	v_add3_u32 v95, v95, v32, 0x7fff
	v_cndmask_b32_e32 v31, v92, v93, vcc_lo
	v_lshrrev_b32_e32 v6, 16, v6
	v_cmp_u_f32_e32 vcc_lo, v32, v32
	v_add_nc_u32_e32 v37, 0x4000, v34
	v_lshrrev_b32_e32 v7, 16, v7
	v_add_nc_u32_e32 v38, 0x5000, v34
	v_lshrrev_b32_e32 v8, 16, v8
	s_clause 0x4
	buffer_store_b16 v3, v2, s[0:3], 0 offen
	buffer_store_b16 v4, v35, s[0:3], 0 offen
	buffer_store_b16 v5, v36, s[0:3], 0 offen
	buffer_store_b16 v6, v37, s[0:3], 0 offen
	buffer_store_b16 v7, v38, s[0:3], 0 offen
	v_add_nc_u32_e32 v3, 0x6000, v34
	v_lshrrev_b32_e32 v9, 16, v9
	v_add_nc_u32_e32 v4, 0x7000, v34
	v_lshrrev_b32_e32 v10, 16, v10
	v_add_nc_u32_e32 v5, 0x8000, v34
	v_lshrrev_b32_e32 v11, 16, v11
	v_cndmask_b32_e32 v32, v95, v98, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v33, v33
	v_add_nc_u32_e32 v6, 0x9000, v34
	v_lshrrev_b32_e32 v12, 16, v12
	v_add_nc_u32_e32 v7, 0xa000, v34
	v_lshrrev_b32_e32 v13, 16, v13
	s_clause 0x4
	buffer_store_b16 v8, v3, s[0:3], 0 offen
	buffer_store_b16 v9, v4, s[0:3], 0 offen
	buffer_store_b16 v10, v5, s[0:3], 0 offen
	buffer_store_b16 v11, v6, s[0:3], 0 offen
	buffer_store_b16 v12, v7, s[0:3], 0 offen
	v_add_nc_u32_e32 v8, 0xb000, v34
	v_lshrrev_b32_e32 v14, 16, v14
	v_add_nc_u32_e32 v9, 0xc000, v34
	v_lshrrev_b32_e32 v15, 16, v15
	v_add_nc_u32_e32 v10, 0xd000, v34
	v_lshrrev_b32_e32 v16, 16, v16
	v_cndmask_b32_e32 v33, v99, v100, vcc_lo
	v_add_nc_u32_e32 v11, 0xe000, v34
	v_lshrrev_b32_e32 v17, 16, v17
	v_add_nc_u32_e32 v12, 0xf000, v34
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
	v_lshrrev_b32_e32 v30, 16, v30
	s_clause 0x10
	buffer_store_b16 v13, v8, s[0:3], 0 offen
	buffer_store_b16 v14, v9, s[0:3], 0 offen
	buffer_store_b16 v15, v10, s[0:3], 0 offen
	buffer_store_b16 v16, v11, s[0:3], 0 offen
	buffer_store_b16 v17, v12, s[0:3], 0 offen
	buffer_store_b16 v18, v34, s[0:3], 0 offen offset:64
	buffer_store_b16 v19, v2, s[0:3], 0 offen offset:64
	buffer_store_b16 v20, v35, s[0:3], 0 offen offset:64
	buffer_store_b16 v21, v36, s[0:3], 0 offen offset:64
	buffer_store_b16 v22, v37, s[0:3], 0 offen offset:64
	buffer_store_b16 v23, v38, s[0:3], 0 offen offset:64
	buffer_store_b16 v24, v3, s[0:3], 0 offen offset:64
	buffer_store_b16 v25, v4, s[0:3], 0 offen offset:64
	buffer_store_b16 v26, v5, s[0:3], 0 offen offset:64
	buffer_store_b16 v27, v6, s[0:3], 0 offen offset:64
	buffer_store_b16 v28, v7, s[0:3], 0 offen offset:64
	buffer_store_b16 v29, v8, s[0:3], 0 offen offset:64
	v_mov_b32_e32 v2, 0
	v_lshrrev_b32_e32 v31, 16, v31
	v_lshrrev_b32_e32 v32, 16, v32
	v_lshrrev_b32_e32 v33, 16, v33
	s_clause 0x3
	buffer_store_b16 v30, v9, s[0:3], 0 offen offset:64
	buffer_store_b16 v31, v10, s[0:3], 0 offen offset:64
	buffer_store_b16 v32, v11, s[0:3], 0 offen offset:64
	buffer_store_b16 v33, v12, s[0:3], 0 offen offset:64
	s_waitcnt_vscnt null, 0x0
	global_store_b32 v[0:1], v2, off offset:-128
.LBB0_21:
	s_nop 0
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
	s_endpgm
.Lfunc_end0:
	.size	exercise_kernel_0, .Lfunc_end0-exercise_kernel_0
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel exercise_kernel_0
		.amdhsa_group_segment_fixed_size 25600
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 116
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
		.amdhsa_next_free_vgpr 241
		.amdhsa_next_free_sgpr 20
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

	.set .Lexercise_kernel_0.num_vgpr, 198
	.set .Lexercise_kernel_0.num_agpr, 0
	.set .Lexercise_kernel_0.numbered_sgpr, 20
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
      - .address_space:  global
        .offset:         104
        .size:           8
        .value_kind:     global_buffer
      - .offset:         112
        .size:           4
        .value_kind:     by_value
    .group_segment_fixed_size: 25600
    .kernarg_segment_align: 8
    .kernarg_segment_size: 116
    .max_flat_workgroup_size: 96
    .name:           exercise_kernel_0
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 96
      - 1
      - 1
    .sgpr_count:     22
    .sgpr_spill_count: 0
    .symbol:         exercise_kernel_0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     198
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
