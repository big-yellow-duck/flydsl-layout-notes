	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	exercise_kernel_0
	.p2align	8
	.type	exercise_kernel_0,@function
exercise_kernel_0:
	s_ashr_i32 s13, s2, 31
	v_lshlrev_b32_e32 v1, 3, v0
	s_lshr_b32 s3, s13, 30
	s_clause 0x1
	s_load_b64 s[4:5], s[0:1], 0x0
	s_load_b64 s[8:9], s[0:1], 0x18
	s_add_i32 s3, s2, s3
	v_and_b32_e32 v1, 56, v1
	s_ashr_i32 s6, s3, 31
	s_ashr_i32 s7, s3, 2
	s_lshr_b32 s6, s6, 28
	v_lshrrev_b32_e32 v57, 3, v0
	s_add_i32 s6, s7, s6
	s_and_b32 s3, s3, -4
	s_and_b32 s6, s6, -16
	s_sub_i32 s15, s2, s3
	s_sub_i32 s12, s7, s6
	v_lshl_or_b32 v58, v57, 10, v1
	s_lshl_b32 s3, s12, 6
	s_lshl_b32 s6, s15, 21
	v_lshlrev_b32_e32 v77, 1, v1
	s_add_i32 s6, s6, s3
	s_mov_b32 s7, 0x21027000
	v_add_lshl_u32 v1, s6, v58, 1
	s_mov_b32 s6, -1
	v_lshl_or_b32 v78, v57, 14, v77
	s_waitcnt lgkmcnt(0)
	s_and_b32 s9, s9, 0xffff
	s_mov_b32 s10, s6
	v_add_nc_u32_e32 v3, 0x4000, v1
	s_mov_b32 s11, s7
	v_lshl_add_u32 v2, s15, 12, v78
	s_clause 0x1
	buffer_load_b128 v[17:20], v1, s[8:11], 0 offen
	buffer_load_b128 v[21:24], v3, s[8:11], 0 offen
	v_add_nc_u32_e32 v3, 0x8000, v1
	v_add_nc_u32_e32 v5, 0xc000, v1
	v_add_nc_u32_e32 v6, 0x10000, v1
	v_add_nc_u32_e32 v7, 0x14000, v1
	v_add_nc_u32_e32 v8, 0x18000, v1
	s_and_b32 s5, s5, 0xffff
	v_add_nc_u32_e32 v4, 0x20000, v2
	v_add_nc_u32_e32 v1, 0x1c000, v1
	s_clause 0x5
	buffer_load_b128 v[25:28], v3, s[8:11], 0 offen
	buffer_load_b128 v[29:32], v5, s[8:11], 0 offen
	buffer_load_b128 v[33:36], v6, s[8:11], 0 offen
	buffer_load_b128 v[37:40], v7, s[8:11], 0 offen
	buffer_load_b128 v[41:44], v8, s[8:11], 0 offen
	buffer_load_b128 v[45:48], v1, s[8:11], 0 offen
	s_clause 0x1
	buffer_load_b128 v[49:52], v2, s[4:7], 0 offen
	buffer_load_b128 v[53:56], v4, s[4:7], 0 offen
	v_mov_b32_e32 v1, 0
	v_lshrrev_b32_e32 v16, 1, v0
	v_and_b32_e32 v73, 15, v0
	v_mul_u32_u24_e32 v59, 0x90, v57
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_dual_mov_b32 v14, v1 :: v_dual_lshlrev_b32 v79, 7, v57
	v_dual_mov_b32 v7, v1 :: v_dual_and_b32 v74, 16, v16
	v_mov_b32_e32 v2, v1
	v_mov_b32_e32 v12, v1
	v_or_b32_e32 v61, 0x2000, v77
	v_mov_b32_e32 v3, v1
	v_or_b32_e32 v60, v73, v74
	v_mov_b32_e32 v4, v1
	v_mov_b32_e32 v5, v1
	v_mov_b32_e32 v6, v1
	v_mov_b32_e32 v8, v1
	v_mov_b32_e32 v9, v1
	v_mov_b32_e32 v10, v1
	v_mov_b32_e32 v11, v1
	v_mov_b32_e32 v13, v1
	v_mov_b32_e32 v15, v1
	v_dual_mov_b32 v16, v1 :: v_dual_lshlrev_b32 v75, 1, v60
	v_mul_u32_u24_e32 v76, 0x90, v73
	v_or_b32_e32 v62, v77, v79
	v_add_lshl_u32 v80, v58, s3, 1
	v_add_nc_u32_e32 v81, v61, v59
	s_lshl_b32 s15, s15, 5
	s_mov_b32 s14, 0
	s_or_b32 s15, s15, 1
	v_mad_u32_u24 v57, 0x90, v57, v61
	s_waitcnt vmcnt(9)
	ds_store_b128 v62, v[17:20]
	s_waitcnt vmcnt(8)
	ds_store_b128 v62, v[21:24] offset:1024
	s_waitcnt vmcnt(7)
	ds_store_b128 v62, v[25:28] offset:2048
	s_waitcnt vmcnt(6)
	ds_store_b128 v62, v[29:32] offset:3072
	s_waitcnt vmcnt(5)
	ds_store_b128 v62, v[33:36] offset:4096
	s_waitcnt vmcnt(4)
	ds_store_b128 v62, v[37:40] offset:5120
	s_waitcnt vmcnt(3)
	ds_store_b128 v62, v[41:44] offset:6144
	s_waitcnt vmcnt(2)
	ds_store_b128 v62, v[45:48] offset:7168
	s_waitcnt vmcnt(1)
	ds_store_b128 v57, v[49:52]
	s_waitcnt vmcnt(0)
	ds_store_b128 v57, v[53:56] offset:1152
	s_waitcnt lgkmcnt(0)
	s_barrier
	buffer_gl0_inv
.LBB0_1:
	s_add_i32 s16, s15, s14
	s_add_i32 s14, s14, 1
	v_lshl_add_u32 v17, s16, 7, v78
	v_lshl_add_u32 v18, s16, 17, v80
	v_add_nc_u32_e32 v162, v77, v79
	s_cmp_lg_u32 s14, 31
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_add_nc_u32_e32 v19, 0x20000, v17
	v_add_nc_u32_e32 v20, 0x4000, v18
	v_add_nc_u32_e32 v21, 0x8000, v18
	v_add_nc_u32_e32 v22, 0xc000, v18
	buffer_load_b128 v[33:36], v18, s[8:11], 0 offen
	v_add_nc_u32_e32 v23, 0x10000, v18
	v_add_nc_u32_e32 v24, 0x14000, v18
	v_add_nc_u32_e32 v25, 0x18000, v18
	v_add_nc_u32_e32 v18, 0x1c000, v18
	s_clause 0x1
	buffer_load_b128 v[65:68], v17, s[4:7], 0 offen
	buffer_load_b128 v[69:72], v19, s[4:7], 0 offen
	s_clause 0x6
	buffer_load_b128 v[37:40], v20, s[8:11], 0 offen
	buffer_load_b128 v[41:44], v21, s[8:11], 0 offen
	buffer_load_b128 v[45:48], v22, s[8:11], 0 offen
	buffer_load_b128 v[49:52], v23, s[8:11], 0 offen
	buffer_load_b128 v[53:56], v24, s[8:11], 0 offen
	buffer_load_b128 v[57:60], v25, s[8:11], 0 offen
	buffer_load_b128 v[61:64], v18, s[8:11], 0 offen
	ds_load_b128 v[17:20], v76 offset:8192
	ds_load_b128 v[21:24], v76 offset:8208
	ds_load_b128 v[25:28], v76 offset:8224
	ds_load_b128 v[29:32], v76 offset:8240
	ds_load_u16_d16 v82, v75
	ds_load_u16_d16_hi v82, v75 offset:128
	ds_load_u16_d16 v83, v75 offset:256
	ds_load_u16_d16_hi v83, v75 offset:384
	ds_load_u16_d16_hi v91, v75 offset:448
	ds_load_u16_d16 v91, v75 offset:320
	ds_load_u16_d16_hi v90, v75 offset:192
	ds_load_u16_d16 v90, v75 offset:64
	ds_load_u16_d16 v84, v75 offset:512
	ds_load_u16_d16_hi v84, v75 offset:640
	ds_load_u16_d16 v85, v75 offset:768
	ds_load_u16_d16_hi v85, v75 offset:896
	ds_load_u16_d16_hi v93, v75 offset:960
	ds_load_u16_d16 v93, v75 offset:832
	ds_load_u16_d16_hi v92, v75 offset:704
	ds_load_u16_d16 v92, v75 offset:576
	ds_load_u16_d16 v86, v75 offset:1024
	ds_load_u16_d16_hi v86, v75 offset:1152
	ds_load_u16_d16 v87, v75 offset:1280
	ds_load_u16_d16_hi v87, v75 offset:1408
	ds_load_u16_d16_hi v95, v75 offset:1472
	ds_load_u16_d16 v95, v75 offset:1344
	ds_load_u16_d16_hi v94, v75 offset:1216
	ds_load_u16_d16 v94, v75 offset:1088
	ds_load_u16_d16 v88, v75 offset:1536
	ds_load_u16_d16_hi v88, v75 offset:1664
	ds_load_u16_d16 v89, v75 offset:1792
	ds_load_u16_d16_hi v89, v75 offset:1920
	ds_load_u16_d16_hi v97, v75 offset:1984
	ds_load_u16_d16 v97, v75 offset:1856
	ds_load_u16_d16_hi v96, v75 offset:1728
	ds_load_u16_d16 v96, v75 offset:1600
	ds_load_u16_d16 v98, v75 offset:2048
	ds_load_u16_d16_hi v98, v75 offset:2176
	ds_load_u16_d16 v99, v75 offset:2304
	ds_load_u16_d16_hi v99, v75 offset:2432
	ds_load_u16_d16_hi v107, v75 offset:2496
	ds_load_u16_d16 v107, v75 offset:2368
	ds_load_u16_d16_hi v106, v75 offset:2240
	ds_load_u16_d16 v106, v75 offset:2112
	ds_load_u16_d16 v100, v75 offset:2560
	ds_load_u16_d16_hi v100, v75 offset:2688
	ds_load_u16_d16 v101, v75 offset:2816
	ds_load_u16_d16_hi v101, v75 offset:2944
	ds_load_u16_d16_hi v109, v75 offset:3008
	ds_load_u16_d16 v109, v75 offset:2880
	ds_load_u16_d16_hi v108, v75 offset:2752
	ds_load_u16_d16 v108, v75 offset:2624
	ds_load_u16_d16 v102, v75 offset:3072
	ds_load_u16_d16_hi v102, v75 offset:3200
	ds_load_u16_d16 v103, v75 offset:3328
	ds_load_u16_d16_hi v103, v75 offset:3456
	ds_load_u16_d16_hi v111, v75 offset:3520
	ds_load_u16_d16 v111, v75 offset:3392
	ds_load_u16_d16_hi v110, v75 offset:3264
	ds_load_u16_d16 v110, v75 offset:3136
	ds_load_u16_d16 v104, v75 offset:3584
	ds_load_u16_d16_hi v104, v75 offset:3712
	ds_load_u16_d16 v105, v75 offset:3840
	ds_load_u16_d16_hi v105, v75 offset:3968
	ds_load_u16_d16_hi v113, v75 offset:4032
	ds_load_u16_d16 v113, v75 offset:3904
	ds_load_u16_d16_hi v112, v75 offset:3776
	ds_load_u16_d16 v112, v75 offset:3648
	ds_load_b128 v[114:117], v76 offset:8256
	ds_load_b128 v[118:121], v76 offset:8272
	ds_load_u16_d16 v122, v75 offset:4096
	ds_load_u16_d16_hi v122, v75 offset:4224
	ds_load_u16_d16 v123, v75 offset:4352
	ds_load_u16_d16_hi v123, v75 offset:4480
	ds_load_u16_d16_hi v131, v75 offset:4544
	ds_load_u16_d16 v131, v75 offset:4416
	ds_load_u16_d16_hi v130, v75 offset:4288
	ds_load_u16_d16 v130, v75 offset:4160
	ds_load_u16_d16 v124, v75 offset:4608
	ds_load_u16_d16_hi v124, v75 offset:4736
	ds_load_u16_d16 v125, v75 offset:4864
	ds_load_u16_d16_hi v125, v75 offset:4992
	ds_load_u16_d16_hi v133, v75 offset:5056
	ds_load_u16_d16 v133, v75 offset:4928
	ds_load_u16_d16_hi v132, v75 offset:4800
	ds_load_u16_d16 v132, v75 offset:4672
	ds_load_u16_d16 v126, v75 offset:5120
	ds_load_u16_d16_hi v126, v75 offset:5248
	ds_load_u16_d16 v127, v75 offset:5376
	ds_load_u16_d16_hi v127, v75 offset:5504
	ds_load_u16_d16_hi v135, v75 offset:5568
	ds_load_u16_d16 v135, v75 offset:5440
	ds_load_u16_d16_hi v134, v75 offset:5312
	ds_load_u16_d16 v134, v75 offset:5184
	ds_load_u16_d16 v128, v75 offset:5632
	ds_load_u16_d16_hi v128, v75 offset:5760
	ds_load_u16_d16 v129, v75 offset:5888
	ds_load_u16_d16_hi v129, v75 offset:6016
	ds_load_u16_d16_hi v137, v75 offset:6080
	ds_load_u16_d16 v137, v75 offset:5952
	ds_load_u16_d16_hi v136, v75 offset:5824
	ds_load_u16_d16 v136, v75 offset:5696
	ds_load_b128 v[138:141], v76 offset:8288
	ds_load_b128 v[142:145], v76 offset:8304
	ds_load_u16_d16 v146, v75 offset:6144
	ds_load_u16_d16_hi v146, v75 offset:6272
	ds_load_u16_d16 v147, v75 offset:6400
	ds_load_u16_d16_hi v147, v75 offset:6528
	ds_load_u16_d16_hi v155, v75 offset:6592
	ds_load_u16_d16 v155, v75 offset:6464
	ds_load_u16_d16_hi v154, v75 offset:6336
	ds_load_u16_d16 v154, v75 offset:6208
	ds_load_u16_d16 v148, v75 offset:6656
	ds_load_u16_d16_hi v148, v75 offset:6784
	ds_load_u16_d16 v149, v75 offset:6912
	ds_load_u16_d16_hi v149, v75 offset:7040
	ds_load_u16_d16_hi v157, v75 offset:7104
	ds_load_u16_d16 v157, v75 offset:6976
	ds_load_u16_d16_hi v156, v75 offset:6848
	ds_load_u16_d16 v156, v75 offset:6720
	ds_load_u16_d16 v150, v75 offset:7168
	ds_load_u16_d16_hi v150, v75 offset:7296
	ds_load_u16_d16 v151, v75 offset:7424
	ds_load_u16_d16_hi v151, v75 offset:7552
	ds_load_u16_d16_hi v159, v75 offset:7616
	ds_load_u16_d16 v159, v75 offset:7488
	ds_load_u16_d16_hi v158, v75 offset:7360
	ds_load_u16_d16 v158, v75 offset:7232
	ds_load_u16_d16 v152, v75 offset:7680
	ds_load_u16_d16_hi v152, v75 offset:7808
	ds_load_u16_d16 v153, v75 offset:7936
	ds_load_u16_d16_hi v153, v75 offset:8064
	ds_load_u16_d16_hi v161, v75 offset:8128
	ds_load_u16_d16 v161, v75 offset:8000
	ds_load_u16_d16_hi v160, v75 offset:7872
	ds_load_u16_d16 v160, v75 offset:7744
	s_waitcnt lgkmcnt(62)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[17:24], v[82:89], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[17:24], v[90:97], v[1:8]
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[25:32], v[98:105], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[25:32], v[106:113], v[1:8]
	s_waitcnt lgkmcnt(38)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[114:121], v[122:129], v[9:16]
	s_waitcnt lgkmcnt(34)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[114:121], v[130:137], v[1:8]
	s_waitcnt lgkmcnt(4)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[138:145], v[146:153], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[138:145], v[154:161], v[1:8]
	s_waitcnt vmcnt(0)
	s_barrier
	buffer_gl0_inv
	ds_store_b128 v81, v[65:68]
	ds_store_b128 v81, v[69:72] offset:1152
	ds_store_b128 v162, v[33:36]
	ds_store_b128 v162, v[37:40] offset:1024
	ds_store_b128 v162, v[41:44] offset:2048
	ds_store_b128 v162, v[45:48] offset:3072
	ds_store_b128 v162, v[49:52] offset:4096
	ds_store_b128 v162, v[53:56] offset:5120
	ds_store_b128 v162, v[57:60] offset:6144
	ds_store_b128 v162, v[61:64] offset:7168
	s_waitcnt lgkmcnt(0)
	s_barrier
	buffer_gl0_inv
	s_cbranch_scc1 .LBB0_1
	ds_load_b128 v[17:20], v76 offset:8192
	ds_load_b128 v[21:24], v76 offset:8208
	ds_load_u16_d16 v25, v75
	ds_load_u16_d16_hi v25, v75 offset:128
	ds_load_u16_d16 v26, v75 offset:256
	ds_load_u16_d16_hi v26, v75 offset:384
	ds_load_u16_d16 v27, v75 offset:512
	ds_load_u16_d16_hi v27, v75 offset:640
	ds_load_u16_d16 v28, v75 offset:768
	ds_load_u16_d16_hi v28, v75 offset:896
	ds_load_u16_d16 v29, v75 offset:1024
	ds_load_u16_d16_hi v29, v75 offset:1152
	ds_load_u16_d16 v30, v75 offset:1280
	ds_load_u16_d16_hi v30, v75 offset:1408
	ds_load_u16_d16 v31, v75 offset:1536
	ds_load_u16_d16_hi v31, v75 offset:1664
	ds_load_u16_d16 v32, v75 offset:1792
	ds_load_u16_d16_hi v32, v75 offset:1920
	ds_load_b128 v[33:36], v76 offset:8224
	ds_load_b128 v[37:40], v76 offset:8240
	ds_load_u16_d16_hi v42, v75 offset:448
	ds_load_u16_d16 v42, v75 offset:320
	ds_load_u16_d16_hi v41, v75 offset:192
	ds_load_u16_d16 v41, v75 offset:64
	ds_load_u16_d16_hi v44, v75 offset:960
	ds_load_u16_d16 v44, v75 offset:832
	ds_load_u16_d16_hi v43, v75 offset:704
	ds_load_u16_d16 v43, v75 offset:576
	ds_load_u16_d16_hi v46, v75 offset:1472
	ds_load_u16_d16 v46, v75 offset:1344
	ds_load_u16_d16_hi v45, v75 offset:1216
	ds_load_u16_d16 v45, v75 offset:1088
	ds_load_u16_d16_hi v48, v75 offset:1984
	ds_load_u16_d16 v48, v75 offset:1856
	ds_load_u16_d16_hi v47, v75 offset:1728
	ds_load_u16_d16 v47, v75 offset:1600
	s_lshr_b32 s8, s13, 26
	s_waitcnt lgkmcnt(18)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[17:24], v[25:32], v[9:16]
	ds_load_u16_d16 v25, v75 offset:2048
	ds_load_u16_d16_hi v25, v75 offset:2176
	ds_load_u16_d16 v26, v75 offset:2304
	ds_load_u16_d16_hi v26, v75 offset:2432
	ds_load_u16_d16_hi v50, v75 offset:2496
	ds_load_u16_d16 v50, v75 offset:2368
	ds_load_u16_d16_hi v49, v75 offset:2240
	ds_load_u16_d16 v49, v75 offset:2112
	ds_load_u16_d16 v27, v75 offset:2560
	ds_load_u16_d16_hi v27, v75 offset:2688
	ds_load_u16_d16 v28, v75 offset:2816
	ds_load_u16_d16_hi v28, v75 offset:2944
	ds_load_u16_d16_hi v52, v75 offset:3008
	ds_load_u16_d16 v52, v75 offset:2880
	ds_load_u16_d16_hi v51, v75 offset:2752
	ds_load_u16_d16 v51, v75 offset:2624
	ds_load_u16_d16 v29, v75 offset:3072
	ds_load_u16_d16_hi v29, v75 offset:3200
	ds_load_u16_d16 v30, v75 offset:3328
	ds_load_u16_d16_hi v30, v75 offset:3456
	ds_load_u16_d16_hi v54, v75 offset:3520
	ds_load_u16_d16 v54, v75 offset:3392
	ds_load_u16_d16_hi v53, v75 offset:3264
	ds_load_u16_d16 v53, v75 offset:3136
	ds_load_u16_d16 v31, v75 offset:3584
	ds_load_u16_d16_hi v31, v75 offset:3712
	ds_load_u16_d16 v32, v75 offset:3840
	ds_load_u16_d16_hi v32, v75 offset:3968
	ds_load_u16_d16_hi v56, v75 offset:4032
	ds_load_u16_d16 v56, v75 offset:3904
	ds_load_u16_d16_hi v55, v75 offset:3776
	ds_load_u16_d16 v55, v75 offset:3648
	ds_load_b128 v[57:60], v76 offset:8256
	ds_load_b128 v[61:64], v76 offset:8272
	ds_load_u16_d16 v65, v75 offset:4096
	ds_load_u16_d16_hi v65, v75 offset:4224
	ds_load_u16_d16 v66, v75 offset:4352
	ds_load_u16_d16_hi v66, v75 offset:4480
	ds_load_u16_d16_hi v78, v75 offset:4544
	ds_load_u16_d16 v78, v75 offset:4416
	ds_load_u16_d16_hi v77, v75 offset:4288
	ds_load_u16_d16 v77, v75 offset:4160
	ds_load_u16_d16 v67, v75 offset:4608
	ds_load_u16_d16_hi v67, v75 offset:4736
	ds_load_u16_d16 v68, v75 offset:4864
	ds_load_u16_d16_hi v68, v75 offset:4992
	ds_load_u16_d16_hi v80, v75 offset:5056
	ds_load_u16_d16 v80, v75 offset:4928
	ds_load_u16_d16_hi v79, v75 offset:4800
	ds_load_u16_d16 v79, v75 offset:4672
	ds_load_u16_d16 v69, v75 offset:5120
	ds_load_u16_d16_hi v69, v75 offset:5248
	ds_load_u16_d16 v70, v75 offset:5376
	ds_load_u16_d16_hi v70, v75 offset:5504
	ds_load_u16_d16_hi v82, v75 offset:5568
	ds_load_u16_d16 v82, v75 offset:5440
	ds_load_u16_d16_hi v81, v75 offset:5312
	ds_load_u16_d16 v81, v75 offset:5184
	ds_load_u16_d16 v71, v75 offset:5632
	ds_load_u16_d16_hi v71, v75 offset:5760
	ds_load_u16_d16 v72, v75 offset:5888
	ds_load_u16_d16_hi v72, v75 offset:6016
	ds_load_u16_d16_hi v84, v75 offset:6080
	ds_load_u16_d16 v84, v75 offset:5952
	ds_load_u16_d16_hi v83, v75 offset:5824
	ds_load_u16_d16 v83, v75 offset:5696
	ds_load_b128 v[85:88], v76 offset:8288
	ds_load_b128 v[89:92], v76 offset:8304
	ds_load_u16_d16 v93, v75 offset:6144
	ds_load_u16_d16_hi v93, v75 offset:6272
	ds_load_u16_d16 v94, v75 offset:6400
	ds_load_u16_d16_hi v94, v75 offset:6528
	ds_load_u16_d16_hi v102, v75 offset:6592
	ds_load_u16_d16 v102, v75 offset:6464
	ds_load_u16_d16_hi v101, v75 offset:6336
	ds_load_u16_d16 v101, v75 offset:6208
	ds_load_u16_d16 v95, v75 offset:6656
	ds_load_u16_d16_hi v95, v75 offset:6784
	ds_load_u16_d16 v96, v75 offset:6912
	ds_load_u16_d16_hi v96, v75 offset:7040
	ds_load_u16_d16_hi v104, v75 offset:7104
	ds_load_u16_d16 v104, v75 offset:6976
	ds_load_u16_d16_hi v103, v75 offset:6848
	ds_load_u16_d16 v103, v75 offset:6720
	ds_load_u16_d16 v97, v75 offset:7168
	ds_load_u16_d16_hi v97, v75 offset:7296
	ds_load_u16_d16 v98, v75 offset:7424
	ds_load_u16_d16_hi v98, v75 offset:7552
	ds_load_u16_d16_hi v106, v75 offset:7616
	ds_load_u16_d16 v106, v75 offset:7488
	ds_load_u16_d16_hi v105, v75 offset:7360
	ds_load_u16_d16 v105, v75 offset:7232
	ds_load_u16_d16 v99, v75 offset:7680
	ds_load_u16_d16_hi v99, v75 offset:7808
	ds_load_u16_d16 v100, v75 offset:7936
	ds_load_u16_d16_hi v100, v75 offset:8064
	ds_load_u16_d16_hi v108, v75 offset:8128
	ds_load_u16_d16 v108, v75 offset:8000
	ds_load_u16_d16_hi v107, v75 offset:7872
	ds_load_u16_d16 v107, v75 offset:7744
	s_add_i32 s8, s2, s8
	s_clause 0x1
	s_load_b64 s[4:5], s[0:1], 0x48
	s_load_b64 s[6:7], s[0:1], 0x58
	s_and_b32 s8, s8, 0x3fffc0
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[33:40], v[25:32], v[9:16]
	s_sub_i32 s2, s2, s8
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_4) | instid1(VALU_DEP_3)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[57:64], v[65:72], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[85:92], v[93:100], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[17:24], v[41:48], v[1:8]
	v_lshlrev_b32_e32 v19, 4, v0
	v_or_b32_e32 v20, s3, v0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[33:40], v[49:56], v[1:8]
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_lshl_or_b32 v17, s2, 10, v19
	v_ashrrev_i32_e32 v21, 31, v20
	s_mov_b32 s2, exec_lo
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[57:64], v[77:84], v[1:8]
	v_ashrrev_i32_e32 v18, 31, v17
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_lshlrev_b64 v[20:21], 2, v[20:21]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[85:92], v[101:108], v[1:8]
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_lshlrev_b64 v[17:18], 2, v[17:18]
	v_add_co_u32 v22, vcc_lo, s4, v17
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v23, null, s5, v18, vcc_lo
	v_add_co_u32 v17, vcc_lo, s6, v20
	v_add_co_ci_u32_e64 v18, null, s7, v21, vcc_lo
	v_mov_b32_e32 v20, 1
	s_barrier
	buffer_gl0_inv
	s_clause 0x3
	global_store_b128 v[22:23], v[13:16], off offset:16
	global_store_b128 v[22:23], v[9:12], off
	global_store_b128 v[22:23], v[5:8], off offset:48
	global_store_b128 v[22:23], v[1:4], off offset:32
	s_waitcnt_vscnt null, 0x0
	global_atomic_add_u32 v1, v[17:18], v20, off glc
	s_waitcnt vmcnt(0)
	buffer_gl1_inv
	buffer_gl0_inv
	v_cmpx_eq_u32_e32 3, v1
	s_cbranch_execz .LBB0_4
	v_lshl_or_b32 v1, s12, 12, v19
	v_lshlrev_b32_e32 v0, 6, v0
	v_or_b32_e32 v67, s3, v74
	s_load_b64 s[0:1], s[0:1], 0x30
	s_mov_b32 s3, 0x21027000
	v_ashrrev_i32_e32 v2, 31, v1
	v_and_or_b32 v0, 0x400, v0, v73
	s_mov_b32 s2, -1
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_lshlrev_b64 v[1:2], 2, v[1:2]
	v_add_lshl_u32 v0, v67, v0, 1
	v_mov_b32_e32 v67, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v47, vcc_lo, s4, v1
	v_add_co_ci_u32_e64 v48, null, s5, v2, vcc_lo
	s_clause 0x3
	global_load_b128 v[1:4], v[47:48], off
	global_load_b128 v[5:8], v[47:48], off offset:16
	global_load_b128 v[9:12], v[47:48], off offset:48
	global_load_b128 v[13:16], v[47:48], off offset:32
	v_add_co_u32 v35, vcc_lo, v47, 0x2000
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v36, null, 0, v48, vcc_lo
	v_add_co_u32 v31, vcc_lo, 0x1000, v47
	v_add_co_ci_u32_e64 v32, null, 0, v48, vcc_lo
	v_add_co_u32 v49, vcc_lo, 0x2000, v47
	s_clause 0x3
	global_load_b128 v[19:22], v[35:36], off offset:-4096
	global_load_b128 v[23:26], v[31:32], off offset:16
	global_load_b128 v[27:30], v[31:32], off offset:32
	global_load_b128 v[31:34], v[31:32], off offset:48
	v_add_co_ci_u32_e64 v50, null, 0, v48, vcc_lo
	s_clause 0x2
	global_load_b128 v[35:38], v[35:36], off
	global_load_b128 v[39:42], v[49:50], off offset:16
	global_load_b128 v[43:46], v[49:50], off offset:32
	v_add_co_u32 v63, vcc_lo, 0x3000, v47
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v64, null, 0, v48, vcc_lo
	s_clause 0x4
	global_load_b128 v[47:50], v[49:50], off offset:48
	global_load_b128 v[51:54], v[63:64], off
	global_load_b128 v[55:58], v[63:64], off offset:16
	global_load_b128 v[59:62], v[63:64], off offset:32
	global_load_b128 v[63:66], v[63:64], off offset:48
	v_add_nc_u32_e32 v68, 0x1000, v0
	v_add_nc_u32_e32 v69, 0x2000, v0
	v_add_nc_u32_e32 v70, 0x3000, v0
	v_add_nc_u32_e32 v72, 0x5000, v0
	v_add_nc_u32_e32 v71, 0x4000, v0
	v_add_nc_u32_e32 v74, 0x7000, v0
	v_add_nc_u32_e32 v73, 0x6000, v0
	s_waitcnt lgkmcnt(0)
	s_and_b32 s1, s1, 0xffff
	s_waitcnt vmcnt(15)
	v_dual_add_f32 v1, 0, v1 :: v_dual_add_f32 v2, 0, v2
	s_waitcnt vmcnt(13)
	v_dual_add_f32 v12, 0, v12 :: v_dual_add_f32 v3, 0, v3
	s_waitcnt vmcnt(12)
	v_dual_add_f32 v4, 0, v4 :: v_dual_add_f32 v13, 0, v13
	v_dual_add_f32 v5, 0, v5 :: v_dual_add_f32 v6, 0, v6
	v_dual_add_f32 v7, 0, v7 :: v_dual_add_f32 v8, 0, v8
	v_add_f32_e32 v15, 0, v15
	s_waitcnt vmcnt(11)
	v_dual_add_f32 v1, v1, v19 :: v_dual_add_f32 v2, v2, v20
	s_waitcnt vmcnt(8)
	v_dual_add_f32 v3, v3, v21 :: v_dual_add_f32 v12, v12, v34
	v_dual_add_f32 v4, v4, v22 :: v_dual_add_f32 v5, v5, v23
	s_waitcnt vmcnt(7)
	v_dual_add_f32 v1, v1, v35 :: v_dual_add_f32 v2, v2, v36
	s_delay_alu instid0(VALU_DEP_2)
	v_dual_add_f32 v3, v3, v37 :: v_dual_add_f32 v4, v4, v38
	s_waitcnt vmcnt(4)
	v_dual_add_f32 v5, v5, v39 :: v_dual_add_f32 v12, v12, v50
	s_waitcnt vmcnt(3)
	v_dual_add_f32 v1, v1, v51 :: v_dual_add_f32 v2, v2, v52
	v_dual_add_f32 v3, v3, v53 :: v_dual_add_f32 v6, v6, v24
	v_add_f32_e32 v7, v7, v25
	s_delay_alu instid0(VALU_DEP_3)
	v_bfe_u32 v19, v1, 16, 1
	v_or_b32_e32 v20, 0x400000, v1
	v_bfe_u32 v21, v2, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	s_waitcnt vmcnt(2)
	v_dual_add_f32 v4, v4, v54 :: v_dual_add_f32 v5, v5, v55
	v_add3_u32 v19, v19, v1, 0x7fff
	s_waitcnt vmcnt(0)
	v_add_f32_e32 v12, v12, v66
	v_or_b32_e32 v22, 0x400000, v2
	v_bfe_u32 v23, v3, 16, 1
	v_add3_u32 v21, v21, v2, 0x7fff
	v_cndmask_b32_e32 v1, v19, v20, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_dual_add_f32 v6, v6, v40 :: v_dual_add_f32 v7, v7, v41
	v_or_b32_e32 v24, 0x400000, v3
	v_bfe_u32 v25, v4, 16, 1
	v_add3_u32 v23, v23, v3, 0x7fff
	v_cndmask_b32_e32 v2, v21, v22, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_add_f32_e32 v14, 0, v14
	v_dual_add_f32 v8, v8, v26 :: v_dual_add_f32 v13, v13, v27
	v_dual_add_f32 v6, v6, v56 :: v_dual_add_f32 v7, v7, v57
	v_or_b32_e32 v26, 0x400000, v4
	v_bfe_u32 v27, v5, 16, 1
	v_add3_u32 v25, v25, v4, 0x7fff
	v_cndmask_b32_e32 v3, v23, v24, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_dual_add_f32 v16, 0, v16 :: v_dual_add_f32 v9, 0, v9
	v_dual_add_f32 v14, v14, v28 :: v_dual_add_f32 v15, v15, v29
	v_dual_add_f32 v8, v8, v42 :: v_dual_add_f32 v13, v13, v43
	v_or_b32_e32 v28, 0x400000, v5
	v_bfe_u32 v29, v6, 16, 1
	v_add3_u32 v27, v27, v5, 0x7fff
	v_cndmask_b32_e32 v4, v25, v26, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_dual_add_f32 v10, 0, v10 :: v_dual_add_f32 v11, 0, v11
	v_dual_add_f32 v16, v16, v30 :: v_dual_add_f32 v9, v9, v31
	v_dual_add_f32 v8, v8, v58 :: v_dual_add_f32 v13, v13, v59
	v_or_b32_e32 v30, 0x400000, v6
	v_bfe_u32 v31, v7, 16, 1
	v_add3_u32 v29, v29, v6, 0x7fff
	v_cndmask_b32_e32 v5, v27, v28, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_dual_add_f32 v10, v10, v32 :: v_dual_add_f32 v11, v11, v33
	v_dual_add_f32 v14, v14, v44 :: v_dual_add_f32 v15, v15, v45
	v_or_b32_e32 v32, 0x400000, v7
	v_bfe_u32 v33, v8, 16, 1
	v_add3_u32 v31, v31, v7, 0x7fff
	v_cndmask_b32_e32 v6, v29, v30, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_dual_add_f32 v14, v14, v60 :: v_dual_add_f32 v15, v15, v61
	v_or_b32_e32 v34, 0x400000, v8
	v_bfe_u32 v35, v13, 16, 1
	v_add3_u32 v33, v33, v8, 0x7fff
	v_cndmask_b32_e32 v7, v31, v32, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_dual_add_f32 v16, v16, v46 :: v_dual_add_f32 v9, v9, v47
	v_or_b32_e32 v36, 0x400000, v13
	v_bfe_u32 v37, v14, 16, 1
	v_add3_u32 v35, v35, v13, 0x7fff
	v_cndmask_b32_e32 v8, v33, v34, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_dual_add_f32 v16, v16, v62 :: v_dual_add_f32 v9, v9, v63
	v_or_b32_e32 v38, 0x400000, v14
	v_bfe_u32 v39, v15, 16, 1
	v_add3_u32 v37, v37, v14, 0x7fff
	v_cndmask_b32_e32 v13, v35, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_dual_add_f32 v10, v10, v48 :: v_dual_add_f32 v11, v11, v49
	v_or_b32_e32 v40, 0x400000, v15
	v_bfe_u32 v41, v16, 16, 1
	v_add3_u32 v39, v39, v15, 0x7fff
	v_cndmask_b32_e32 v14, v37, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_dual_add_f32 v10, v10, v64 :: v_dual_add_f32 v11, v11, v65
	v_or_b32_e32 v42, 0x400000, v16
	v_bfe_u32 v43, v9, 16, 1
	v_add3_u32 v41, v41, v16, 0x7fff
	v_cndmask_b32_e32 v15, v39, v40, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	v_or_b32_e32 v44, 0x400000, v9
	v_bfe_u32 v45, v10, 16, 1
	v_add3_u32 v43, v43, v9, 0x7fff
	v_or_b32_e32 v46, 0x400000, v10
	v_cndmask_b32_e32 v16, v41, v42, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_bfe_u32 v47, v11, 16, 1
	v_add3_u32 v45, v45, v10, 0x7fff
	v_or_b32_e32 v48, 0x400000, v11
	v_bfe_u32 v49, v12, 16, 1
	v_cndmask_b32_e32 v9, v43, v44, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_add3_u32 v47, v47, v11, 0x7fff
	v_or_b32_e32 v50, 0x400000, v12
	v_add3_u32 v49, v49, v12, 0x7fff
	v_lshrrev_b32_e32 v1, 16, v1
	v_cndmask_b32_e32 v10, v45, v46, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_lshrrev_b32_e32 v2, 16, v2
	v_lshrrev_b32_e32 v3, 16, v3
	v_lshrrev_b32_e32 v4, 16, v4
	v_lshrrev_b32_e32 v5, 16, v5
	v_cndmask_b32_e32 v11, v47, v48, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_lshrrev_b32_e32 v6, 16, v6
	v_lshrrev_b32_e32 v7, 16, v7
	v_lshrrev_b32_e32 v8, 16, v8
	v_lshrrev_b32_e32 v13, 16, v13
	v_cndmask_b32_e32 v12, v49, v50, vcc_lo
	v_lshrrev_b32_e32 v14, 16, v14
	v_lshrrev_b32_e32 v15, 16, v15
	v_lshrrev_b32_e32 v16, 16, v16
	v_lshrrev_b32_e32 v9, 16, v9
	v_lshrrev_b32_e32 v10, 16, v10
	v_lshrrev_b32_e32 v11, 16, v11
	v_lshrrev_b32_e32 v12, 16, v12
	s_clause 0xf
	buffer_store_b16 v1, v0, s[0:3], 0 offen
	buffer_store_b16 v2, v68, s[0:3], 0 offen
	buffer_store_b16 v3, v69, s[0:3], 0 offen
	buffer_store_b16 v4, v70, s[0:3], 0 offen
	buffer_store_b16 v5, v71, s[0:3], 0 offen
	buffer_store_b16 v6, v72, s[0:3], 0 offen
	buffer_store_b16 v7, v73, s[0:3], 0 offen
	buffer_store_b16 v8, v74, s[0:3], 0 offen
	buffer_store_b16 v13, v0, s[0:3], 0 offen offset:64
	buffer_store_b16 v14, v68, s[0:3], 0 offen offset:64
	buffer_store_b16 v15, v69, s[0:3], 0 offen offset:64
	buffer_store_b16 v16, v70, s[0:3], 0 offen offset:64
	buffer_store_b16 v9, v71, s[0:3], 0 offen offset:64
	buffer_store_b16 v10, v72, s[0:3], 0 offen offset:64
	buffer_store_b16 v11, v73, s[0:3], 0 offen offset:64
	buffer_store_b16 v12, v74, s[0:3], 0 offen offset:64
	s_waitcnt_vscnt null, 0x0
	global_store_b32 v[17:18], v67, off
.LBB0_4:
	s_nop 0
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
	s_endpgm
.Lfunc_end0:
	.size	exercise_kernel_0, .Lfunc_end0-exercise_kernel_0
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel exercise_kernel_0
		.amdhsa_group_segment_fixed_size 10496
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
		.amdhsa_next_free_vgpr 217
		.amdhsa_next_free_sgpr 17
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

	.set .Lexercise_kernel_0.num_vgpr, 163
	.set .Lexercise_kernel_0.num_agpr, 0
	.set .Lexercise_kernel_0.numbered_sgpr, 17
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
    .group_segment_fixed_size: 10496
    .kernarg_segment_align: 8
    .kernarg_segment_size: 100
    .max_flat_workgroup_size: 64
    .name:           exercise_kernel_0
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 64
      - 1
      - 1
    .sgpr_count:     19
    .sgpr_spill_count: 0
    .symbol:         exercise_kernel_0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     163
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
