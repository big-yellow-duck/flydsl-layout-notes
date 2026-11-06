	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	exercise_kernel_0
	.p2align	8
	.type	exercise_kernel_0,@function
exercise_kernel_0:
	s_ashr_i32 s13, s2, 31
	v_lshrrev_b32_e32 v53, 4, v0
	s_lshr_b32 s3, s13, 30
	v_and_b32_e32 v69, 15, v0
	s_add_i32 s6, s2, s3
	s_clause 0x1
	s_load_b64 s[4:5], s[0:1], 0x0
	s_load_b64 s[8:9], s[0:1], 0x18
	s_ashr_i32 s3, s6, 2
	v_lshlrev_b32_e32 v70, 10, v53
	s_lshr_b32 s7, s3, 29
	v_lshlrev_b32_e32 v72, 4, v0
	s_add_i32 s7, s3, s7
	v_lshrrev_b32_e32 v54, 3, v0
	s_and_b32 s7, s7, -8
	v_lshl_or_b32 v1, v69, 3, v70
	s_sub_i32 s12, s3, s7
	v_and_b32_e32 v55, 0x70, v72
	s_lshl_b32 s3, s12, 7
	s_and_b32 s6, s6, -4
	v_add_lshl_u32 v75, v1, s3, 1
	s_sub_i32 s15, s2, s6
	v_lshl_or_b32 v76, v54, 14, v55
	s_mov_b32 s7, 0x21027000
	s_mov_b32 s6, -1
	v_lshl_add_u32 v1, s15, 22, v75
	s_waitcnt lgkmcnt(0)
	s_and_b32 s5, s5, 0xffff
	v_lshl_add_u32 v2, s15, 12, v76
	s_and_b32 s9, s9, 0xffff
	s_mov_b32 s10, s6
	v_add_nc_u32_e32 v3, 0x4000, v1
	s_mov_b32 s11, s7
	buffer_load_b128 v[17:20], v2, s[4:7], 0 offen
	s_clause 0x1
	buffer_load_b128 v[21:24], v1, s[8:11], 0 offen slc
	buffer_load_b128 v[25:28], v3, s[8:11], 0 offen slc
	v_add_nc_u32_e32 v2, 0x8000, v1
	v_add_nc_u32_e32 v3, 0xc000, v1
	v_add_nc_u32_e32 v4, 0x10000, v1
	v_add_nc_u32_e32 v5, 0x14000, v1
	v_add_nc_u32_e32 v6, 0x18000, v1
	v_add_nc_u32_e32 v1, 0x1c000, v1
	s_clause 0x5
	buffer_load_b128 v[29:32], v2, s[8:11], 0 offen slc
	buffer_load_b128 v[33:36], v3, s[8:11], 0 offen slc
	buffer_load_b128 v[37:40], v4, s[8:11], 0 offen slc
	buffer_load_b128 v[41:44], v5, s[8:11], 0 offen slc
	buffer_load_b128 v[45:48], v6, s[8:11], 0 offen slc
	buffer_load_b128 v[49:52], v1, s[8:11], 0 offen slc
	v_mov_b32_e32 v1, 0
	v_lshrrev_b32_e32 v56, 1, v0
	v_mul_u32_u24_e32 v57, 0x90, v54
	v_lshlrev_b32_e32 v78, 8, v53
	s_lshl_b32 s15, s15, 5
	s_delay_alu instid0(VALU_DEP_3)
	v_dual_mov_b32 v12, v1 :: v_dual_and_b32 v71, 48, v56
	v_mov_b32_e32 v2, v1
	v_mov_b32_e32 v4, v1
	v_mov_b32_e32 v11, v1
	v_or_b32_e32 v53, 0x4000, v55
	v_or_b32_e32 v55, v69, v71
	v_dual_mov_b32 v14, v1 :: v_dual_lshlrev_b32 v77, 4, v69
	v_mov_b32_e32 v3, v1
	v_mov_b32_e32 v5, v1
	v_mov_b32_e32 v6, v1
	v_mov_b32_e32 v7, v1
	v_mov_b32_e32 v8, v1
	v_mov_b32_e32 v9, v1
	v_mov_b32_e32 v10, v1
	v_mov_b32_e32 v13, v1
	v_mov_b32_e32 v15, v1
	v_dual_mov_b32 v16, v1 :: v_dual_lshlrev_b32 v73, 1, v55
	v_mul_u32_u24_e32 v74, 0x90, v69
	v_mad_u32_u24 v54, 0x90, v54, v53
	v_add_nc_u32_e32 v79, v53, v57
	v_or_b32_e32 v56, v77, v78
	s_mov_b32 s14, 0
	s_or_b32 s15, s15, 1
	s_waitcnt vmcnt(8)
	ds_store_b128 v54, v[17:20]
	s_waitcnt vmcnt(7)
	ds_store_b128 v56, v[21:24]
	s_waitcnt vmcnt(6)
	ds_store_b128 v56, v[25:28] offset:2048
	s_waitcnt vmcnt(5)
	ds_store_b128 v56, v[29:32] offset:4096
	s_waitcnt vmcnt(4)
	ds_store_b128 v56, v[33:36] offset:6144
	s_waitcnt vmcnt(3)
	ds_store_b128 v56, v[37:40] offset:8192
	s_waitcnt vmcnt(2)
	ds_store_b128 v56, v[41:44] offset:10240
	s_waitcnt vmcnt(1)
	ds_store_b128 v56, v[45:48] offset:12288
	s_waitcnt vmcnt(0)
	ds_store_b128 v56, v[49:52] offset:14336
	s_waitcnt lgkmcnt(0)
	s_barrier
.LBB0_1:
	s_add_i32 s16, s15, s14
	s_add_i32 s14, s14, 1
	v_lshl_add_u32 v17, s16, 7, v76
	v_lshl_add_u32 v18, s16, 17, v75
	v_add_nc_u32_e32 v160, v77, v78
	s_cmp_lg_u32 s14, 31
	buffer_load_b128 v[33:36], v17, s[4:7], 0 offen
	v_add_nc_u32_e32 v17, 0x4000, v18
	v_add_nc_u32_e32 v19, 0x8000, v18
	v_add_nc_u32_e32 v20, 0xc000, v18
	v_add_nc_u32_e32 v21, 0x10000, v18
	v_add_nc_u32_e32 v22, 0x14000, v18
	v_add_nc_u32_e32 v23, 0x18000, v18
	v_add_nc_u32_e32 v24, 0x1c000, v18
	s_clause 0x7
	buffer_load_b128 v[37:40], v18, s[8:11], 0 offen slc
	buffer_load_b128 v[41:44], v17, s[8:11], 0 offen slc
	buffer_load_b128 v[45:48], v19, s[8:11], 0 offen slc
	buffer_load_b128 v[49:52], v20, s[8:11], 0 offen slc
	buffer_load_b128 v[53:56], v21, s[8:11], 0 offen slc
	buffer_load_b128 v[57:60], v22, s[8:11], 0 offen slc
	buffer_load_b128 v[61:64], v23, s[8:11], 0 offen slc
	buffer_load_b128 v[65:68], v24, s[8:11], 0 offen slc
	ds_load_b128 v[17:20], v74 offset:16384
	ds_load_b128 v[21:24], v74 offset:16400
	ds_load_b128 v[25:28], v74 offset:16416
	ds_load_b128 v[29:32], v74 offset:16432
	ds_load_u16_d16 v80, v73
	ds_load_u16_d16_hi v80, v73 offset:256
	ds_load_u16_d16 v81, v73 offset:512
	ds_load_u16_d16_hi v81, v73 offset:768
	ds_load_u16_d16_hi v89, v73 offset:896
	ds_load_u16_d16 v89, v73 offset:640
	ds_load_u16_d16_hi v88, v73 offset:384
	ds_load_u16_d16 v88, v73 offset:128
	ds_load_u16_d16 v82, v73 offset:1024
	ds_load_u16_d16_hi v82, v73 offset:1280
	ds_load_u16_d16 v83, v73 offset:1536
	ds_load_u16_d16_hi v83, v73 offset:1792
	ds_load_u16_d16_hi v91, v73 offset:1920
	ds_load_u16_d16 v91, v73 offset:1664
	ds_load_u16_d16_hi v90, v73 offset:1408
	ds_load_u16_d16 v90, v73 offset:1152
	ds_load_u16_d16 v84, v73 offset:2048
	ds_load_u16_d16_hi v84, v73 offset:2304
	ds_load_u16_d16 v85, v73 offset:2560
	ds_load_u16_d16_hi v85, v73 offset:2816
	ds_load_u16_d16_hi v93, v73 offset:2944
	ds_load_u16_d16 v93, v73 offset:2688
	ds_load_u16_d16_hi v92, v73 offset:2432
	ds_load_u16_d16 v92, v73 offset:2176
	ds_load_u16_d16 v86, v73 offset:3072
	ds_load_u16_d16_hi v86, v73 offset:3328
	ds_load_u16_d16 v87, v73 offset:3584
	ds_load_u16_d16_hi v87, v73 offset:3840
	ds_load_u16_d16_hi v95, v73 offset:3968
	ds_load_u16_d16 v95, v73 offset:3712
	ds_load_u16_d16_hi v94, v73 offset:3456
	ds_load_u16_d16 v94, v73 offset:3200
	ds_load_u16_d16 v96, v73 offset:4096
	ds_load_u16_d16_hi v96, v73 offset:4352
	ds_load_u16_d16 v97, v73 offset:4608
	ds_load_u16_d16_hi v97, v73 offset:4864
	ds_load_u16_d16_hi v105, v73 offset:4992
	ds_load_u16_d16 v105, v73 offset:4736
	ds_load_u16_d16_hi v104, v73 offset:4480
	ds_load_u16_d16 v104, v73 offset:4224
	ds_load_u16_d16 v98, v73 offset:5120
	ds_load_u16_d16_hi v98, v73 offset:5376
	ds_load_u16_d16 v99, v73 offset:5632
	ds_load_u16_d16_hi v99, v73 offset:5888
	ds_load_u16_d16_hi v107, v73 offset:6016
	ds_load_u16_d16 v107, v73 offset:5760
	ds_load_u16_d16_hi v106, v73 offset:5504
	ds_load_u16_d16 v106, v73 offset:5248
	ds_load_u16_d16 v100, v73 offset:6144
	ds_load_u16_d16_hi v100, v73 offset:6400
	ds_load_u16_d16 v101, v73 offset:6656
	ds_load_u16_d16_hi v101, v73 offset:6912
	ds_load_u16_d16_hi v109, v73 offset:7040
	ds_load_u16_d16 v109, v73 offset:6784
	ds_load_u16_d16_hi v108, v73 offset:6528
	ds_load_u16_d16 v108, v73 offset:6272
	ds_load_u16_d16 v102, v73 offset:7168
	ds_load_u16_d16_hi v102, v73 offset:7424
	ds_load_u16_d16 v103, v73 offset:7680
	ds_load_u16_d16_hi v103, v73 offset:7936
	ds_load_u16_d16_hi v111, v73 offset:8064
	ds_load_u16_d16 v111, v73 offset:7808
	ds_load_u16_d16_hi v110, v73 offset:7552
	ds_load_u16_d16 v110, v73 offset:7296
	ds_load_b128 v[112:115], v74 offset:16448
	ds_load_b128 v[116:119], v74 offset:16464
	ds_load_u16_d16 v120, v73 offset:8192
	ds_load_u16_d16_hi v120, v73 offset:8448
	ds_load_u16_d16 v121, v73 offset:8704
	ds_load_u16_d16_hi v121, v73 offset:8960
	ds_load_u16_d16_hi v129, v73 offset:9088
	ds_load_u16_d16 v129, v73 offset:8832
	ds_load_u16_d16_hi v128, v73 offset:8576
	ds_load_u16_d16 v128, v73 offset:8320
	ds_load_u16_d16 v122, v73 offset:9216
	ds_load_u16_d16_hi v122, v73 offset:9472
	ds_load_u16_d16 v123, v73 offset:9728
	ds_load_u16_d16_hi v123, v73 offset:9984
	ds_load_u16_d16_hi v131, v73 offset:10112
	ds_load_u16_d16 v131, v73 offset:9856
	ds_load_u16_d16_hi v130, v73 offset:9600
	ds_load_u16_d16 v130, v73 offset:9344
	ds_load_u16_d16 v124, v73 offset:10240
	ds_load_u16_d16_hi v124, v73 offset:10496
	ds_load_u16_d16 v125, v73 offset:10752
	ds_load_u16_d16_hi v125, v73 offset:11008
	ds_load_u16_d16_hi v133, v73 offset:11136
	ds_load_u16_d16 v133, v73 offset:10880
	ds_load_u16_d16_hi v132, v73 offset:10624
	ds_load_u16_d16 v132, v73 offset:10368
	ds_load_u16_d16 v126, v73 offset:11264
	ds_load_u16_d16_hi v126, v73 offset:11520
	ds_load_u16_d16 v127, v73 offset:11776
	ds_load_u16_d16_hi v127, v73 offset:12032
	ds_load_u16_d16_hi v135, v73 offset:12160
	ds_load_u16_d16 v135, v73 offset:11904
	ds_load_u16_d16_hi v134, v73 offset:11648
	ds_load_u16_d16 v134, v73 offset:11392
	ds_load_b128 v[136:139], v74 offset:16480
	ds_load_b128 v[140:143], v74 offset:16496
	ds_load_u16_d16 v144, v73 offset:12288
	ds_load_u16_d16_hi v144, v73 offset:12544
	ds_load_u16_d16 v145, v73 offset:12800
	ds_load_u16_d16_hi v145, v73 offset:13056
	ds_load_u16_d16_hi v153, v73 offset:13184
	ds_load_u16_d16 v153, v73 offset:12928
	ds_load_u16_d16_hi v152, v73 offset:12672
	ds_load_u16_d16 v152, v73 offset:12416
	ds_load_u16_d16 v146, v73 offset:13312
	ds_load_u16_d16_hi v146, v73 offset:13568
	ds_load_u16_d16 v147, v73 offset:13824
	ds_load_u16_d16_hi v147, v73 offset:14080
	ds_load_u16_d16_hi v155, v73 offset:14208
	ds_load_u16_d16 v155, v73 offset:13952
	ds_load_u16_d16_hi v154, v73 offset:13696
	ds_load_u16_d16 v154, v73 offset:13440
	ds_load_u16_d16 v148, v73 offset:14336
	ds_load_u16_d16_hi v148, v73 offset:14592
	ds_load_u16_d16 v149, v73 offset:14848
	ds_load_u16_d16_hi v149, v73 offset:15104
	ds_load_u16_d16_hi v157, v73 offset:15232
	ds_load_u16_d16 v157, v73 offset:14976
	ds_load_u16_d16_hi v156, v73 offset:14720
	ds_load_u16_d16 v156, v73 offset:14464
	ds_load_u16_d16 v150, v73 offset:15360
	ds_load_u16_d16_hi v150, v73 offset:15616
	ds_load_u16_d16 v151, v73 offset:15872
	ds_load_u16_d16_hi v151, v73 offset:16128
	ds_load_u16_d16_hi v159, v73 offset:16256
	ds_load_u16_d16 v159, v73 offset:16000
	ds_load_u16_d16_hi v158, v73 offset:15744
	ds_load_u16_d16 v158, v73 offset:15488
	s_waitcnt lgkmcnt(62)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[17:24], v[80:87], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[17:24], v[88:95], v[1:8]
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[25:32], v[96:103], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[25:32], v[104:111], v[1:8]
	s_waitcnt lgkmcnt(38)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[112:119], v[120:127], v[9:16]
	s_waitcnt lgkmcnt(34)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[112:119], v[128:135], v[1:8]
	s_waitcnt lgkmcnt(4)
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[136:143], v[144:151], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[136:143], v[152:159], v[1:8]
	s_barrier
	s_waitcnt vmcnt(8)
	ds_store_b128 v79, v[33:36]
	s_waitcnt vmcnt(7)
	ds_store_b128 v160, v[37:40]
	s_waitcnt vmcnt(6)
	ds_store_b128 v160, v[41:44] offset:2048
	s_waitcnt vmcnt(5)
	ds_store_b128 v160, v[45:48] offset:4096
	s_waitcnt vmcnt(4)
	ds_store_b128 v160, v[49:52] offset:6144
	s_waitcnt vmcnt(3)
	ds_store_b128 v160, v[53:56] offset:8192
	s_waitcnt vmcnt(2)
	ds_store_b128 v160, v[57:60] offset:10240
	s_waitcnt vmcnt(1)
	ds_store_b128 v160, v[61:64] offset:12288
	s_waitcnt vmcnt(0)
	ds_store_b128 v160, v[65:68] offset:14336
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_cbranch_scc1 .LBB0_1
	ds_load_b128 v[17:20], v74 offset:16384
	ds_load_b128 v[21:24], v74 offset:16400
	ds_load_b128 v[25:28], v74 offset:16416
	ds_load_b128 v[29:32], v74 offset:16432
	ds_load_u16_d16 v33, v73
	ds_load_u16_d16_hi v33, v73 offset:256
	ds_load_u16_d16 v34, v73 offset:512
	ds_load_u16_d16_hi v34, v73 offset:768
	ds_load_u16_d16_hi v42, v73 offset:896
	ds_load_u16_d16 v42, v73 offset:640
	ds_load_u16_d16_hi v41, v73 offset:384
	ds_load_u16_d16 v41, v73 offset:128
	ds_load_u16_d16 v35, v73 offset:1024
	ds_load_u16_d16_hi v35, v73 offset:1280
	ds_load_u16_d16 v36, v73 offset:1536
	ds_load_u16_d16_hi v36, v73 offset:1792
	ds_load_u16_d16_hi v44, v73 offset:1920
	ds_load_u16_d16 v44, v73 offset:1664
	ds_load_u16_d16_hi v43, v73 offset:1408
	ds_load_u16_d16 v43, v73 offset:1152
	ds_load_u16_d16 v37, v73 offset:2048
	ds_load_u16_d16_hi v37, v73 offset:2304
	ds_load_u16_d16 v38, v73 offset:2560
	ds_load_u16_d16_hi v38, v73 offset:2816
	ds_load_u16_d16_hi v46, v73 offset:2944
	ds_load_u16_d16 v46, v73 offset:2688
	ds_load_u16_d16_hi v45, v73 offset:2432
	ds_load_u16_d16 v45, v73 offset:2176
	ds_load_u16_d16 v39, v73 offset:3072
	ds_load_u16_d16_hi v39, v73 offset:3328
	ds_load_u16_d16 v40, v73 offset:3584
	ds_load_u16_d16_hi v40, v73 offset:3840
	ds_load_u16_d16_hi v48, v73 offset:3968
	ds_load_u16_d16 v48, v73 offset:3712
	ds_load_u16_d16_hi v47, v73 offset:3456
	ds_load_u16_d16 v47, v73 offset:3200
	ds_load_u16_d16 v49, v73 offset:4096
	ds_load_u16_d16_hi v49, v73 offset:4352
	ds_load_u16_d16 v50, v73 offset:4608
	ds_load_u16_d16_hi v50, v73 offset:4864
	ds_load_u16_d16_hi v58, v73 offset:4992
	ds_load_u16_d16 v58, v73 offset:4736
	ds_load_u16_d16_hi v57, v73 offset:4480
	ds_load_u16_d16 v57, v73 offset:4224
	ds_load_u16_d16 v51, v73 offset:5120
	ds_load_u16_d16_hi v51, v73 offset:5376
	ds_load_u16_d16 v52, v73 offset:5632
	ds_load_u16_d16_hi v52, v73 offset:5888
	ds_load_u16_d16_hi v60, v73 offset:6016
	ds_load_u16_d16 v60, v73 offset:5760
	ds_load_u16_d16_hi v59, v73 offset:5504
	ds_load_u16_d16 v59, v73 offset:5248
	ds_load_u16_d16 v53, v73 offset:6144
	ds_load_u16_d16_hi v53, v73 offset:6400
	ds_load_u16_d16 v54, v73 offset:6656
	ds_load_u16_d16_hi v54, v73 offset:6912
	ds_load_u16_d16_hi v62, v73 offset:7040
	ds_load_u16_d16 v62, v73 offset:6784
	ds_load_u16_d16_hi v61, v73 offset:6528
	ds_load_u16_d16 v61, v73 offset:6272
	ds_load_u16_d16 v55, v73 offset:7168
	ds_load_u16_d16_hi v55, v73 offset:7424
	ds_load_u16_d16 v56, v73 offset:7680
	ds_load_u16_d16_hi v56, v73 offset:7936
	ds_load_u16_d16_hi v64, v73 offset:8064
	ds_load_u16_d16 v64, v73 offset:7808
	ds_load_u16_d16_hi v63, v73 offset:7552
	ds_load_u16_d16 v63, v73 offset:7296
	ds_load_b128 v[75:78], v74 offset:16448
	ds_load_b128 v[79:82], v74 offset:16464
	ds_load_u16_d16 v83, v73 offset:8192
	ds_load_u16_d16_hi v83, v73 offset:8448
	ds_load_u16_d16 v84, v73 offset:8704
	ds_load_u16_d16_hi v84, v73 offset:8960
	ds_load_u16_d16_hi v92, v73 offset:9088
	ds_load_u16_d16 v92, v73 offset:8832
	ds_load_u16_d16_hi v91, v73 offset:8576
	ds_load_u16_d16 v91, v73 offset:8320
	ds_load_u16_d16 v85, v73 offset:9216
	ds_load_u16_d16_hi v85, v73 offset:9472
	ds_load_u16_d16 v86, v73 offset:9728
	ds_load_u16_d16_hi v86, v73 offset:9984
	ds_load_u16_d16_hi v94, v73 offset:10112
	ds_load_u16_d16 v94, v73 offset:9856
	ds_load_u16_d16_hi v93, v73 offset:9600
	ds_load_u16_d16 v93, v73 offset:9344
	ds_load_u16_d16 v87, v73 offset:10240
	ds_load_u16_d16_hi v87, v73 offset:10496
	ds_load_u16_d16 v88, v73 offset:10752
	ds_load_u16_d16_hi v88, v73 offset:11008
	ds_load_u16_d16_hi v96, v73 offset:11136
	ds_load_u16_d16 v96, v73 offset:10880
	ds_load_u16_d16_hi v95, v73 offset:10624
	ds_load_u16_d16 v95, v73 offset:10368
	ds_load_u16_d16 v89, v73 offset:11264
	ds_load_u16_d16_hi v89, v73 offset:11520
	ds_load_u16_d16 v90, v73 offset:11776
	ds_load_u16_d16_hi v90, v73 offset:12032
	ds_load_u16_d16_hi v98, v73 offset:12160
	ds_load_u16_d16 v98, v73 offset:11904
	ds_load_u16_d16_hi v97, v73 offset:11648
	ds_load_u16_d16 v97, v73 offset:11392
	ds_load_b128 v[99:102], v74 offset:16480
	ds_load_b128 v[103:106], v74 offset:16496
	ds_load_u16_d16 v107, v73 offset:12288
	ds_load_u16_d16_hi v107, v73 offset:12544
	ds_load_u16_d16 v108, v73 offset:12800
	ds_load_u16_d16_hi v108, v73 offset:13056
	ds_load_u16_d16_hi v116, v73 offset:13184
	ds_load_u16_d16 v116, v73 offset:12928
	ds_load_u16_d16_hi v115, v73 offset:12672
	ds_load_u16_d16 v115, v73 offset:12416
	ds_load_u16_d16 v109, v73 offset:13312
	ds_load_u16_d16_hi v109, v73 offset:13568
	ds_load_u16_d16 v110, v73 offset:13824
	ds_load_u16_d16_hi v110, v73 offset:14080
	ds_load_u16_d16_hi v118, v73 offset:14208
	ds_load_u16_d16 v118, v73 offset:13952
	ds_load_u16_d16_hi v117, v73 offset:13696
	ds_load_u16_d16 v117, v73 offset:13440
	ds_load_u16_d16 v111, v73 offset:14336
	ds_load_u16_d16_hi v111, v73 offset:14592
	ds_load_u16_d16 v112, v73 offset:14848
	ds_load_u16_d16_hi v112, v73 offset:15104
	ds_load_u16_d16_hi v120, v73 offset:15232
	ds_load_u16_d16 v120, v73 offset:14976
	ds_load_u16_d16_hi v119, v73 offset:14720
	ds_load_u16_d16 v119, v73 offset:14464
	ds_load_u16_d16 v113, v73 offset:15360
	ds_load_u16_d16_hi v113, v73 offset:15616
	ds_load_u16_d16 v114, v73 offset:15872
	ds_load_u16_d16_hi v114, v73 offset:16128
	ds_load_u16_d16_hi v122, v73 offset:16256
	ds_load_u16_d16 v122, v73 offset:16000
	ds_load_u16_d16_hi v121, v73 offset:15744
	ds_load_u16_d16 v121, v73 offset:15488
	s_lshr_b32 s8, s13, 27
	s_clause 0x1
	s_load_b64 s[4:5], s[0:1], 0x48
	s_load_b64 s[6:7], s[0:1], 0x58
	s_add_i32 s8, s2, s8
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[17:24], v[33:40], v[9:16]
	s_and_b32 s8, s8, 0x1fffe0
	v_wmma_f32_16x16x16_bf16 v[1:8], v[17:24], v[41:48], v[1:8]
	s_sub_i32 s2, s2, s8
	v_or_b32_e32 v19, s3, v0
	v_lshl_or_b32 v17, s2, 11, v72
	v_wmma_f32_16x16x16_bf16 v[9:16], v[25:32], v[49:56], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[25:32], v[57:64], v[1:8]
	v_mov_b32_e32 v0, 1
	v_ashrrev_i32_e32 v20, 31, v19
	v_ashrrev_i32_e32 v18, 31, v17
	v_wmma_f32_16x16x16_bf16 v[9:16], v[75:82], v[83:90], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[75:82], v[91:98], v[1:8]
	s_mov_b32 s2, exec_lo
	v_lshlrev_b64 v[19:20], 2, v[19:20]
	v_lshlrev_b64 v[17:18], 2, v[17:18]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[99:106], v[107:114], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[99:106], v[115:122], v[1:8]
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v21, vcc_lo, s4, v17
	v_add_co_ci_u32_e64 v22, null, s5, v18, vcc_lo
	v_add_co_u32 v17, vcc_lo, s6, v19
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v18, null, s7, v20, vcc_lo
	s_barrier
	s_clause 0x3
	global_store_b128 v[21:22], v[13:16], off offset:16
	global_store_b128 v[21:22], v[9:12], off
	global_store_b128 v[21:22], v[5:8], off offset:48
	global_store_b128 v[21:22], v[1:4], off offset:32
	s_waitcnt_vscnt null, 0x0
	global_atomic_add_u32 v0, v[17:18], v0, off glc
	s_waitcnt vmcnt(0)
	buffer_gl1_inv
	buffer_gl0_inv
	v_cmpx_eq_u32_e32 3, v0
	s_cbranch_execz .LBB0_4
	v_lshl_or_b32 v0, s12, 13, v72
	v_and_or_b32 v16, 0x400, v70, v69
	v_or_b32_e32 v67, s3, v71
	s_load_b64 s[0:1], s[0:1], 0x30
	s_mov_b32 s3, 0x21027000
	v_ashrrev_i32_e32 v1, 31, v0
	s_mov_b32 s2, -1
	v_add_lshl_u32 v16, v67, v16, 1
	v_mov_b32_e32 v67, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_lshlrev_b64 v[0:1], 2, v[0:1]
	v_add_nc_u32_e32 v68, 0x1000, v16
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v47, vcc_lo, s4, v0
	v_add_co_ci_u32_e64 v48, null, s5, v1, vcc_lo
	s_clause 0x2
	global_load_b128 v[0:3], v[47:48], off
	global_load_b128 v[4:7], v[47:48], off offset:16
	global_load_b128 v[8:11], v[47:48], off offset:32
	v_add_co_u32 v31, vcc_lo, 0x2000, v47
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v32, null, 0, v48, vcc_lo
	v_add_co_u32 v49, vcc_lo, 0x4000, v47
	s_clause 0x3
	global_load_b128 v[12:15], v[47:48], off offset:48
	global_load_b128 v[19:22], v[31:32], off
	global_load_b128 v[23:26], v[31:32], off offset:16
	global_load_b128 v[27:30], v[31:32], off offset:32
	v_add_co_ci_u32_e64 v50, null, 0, v48, vcc_lo
	s_clause 0x3
	global_load_b128 v[31:34], v[31:32], off offset:48
	global_load_b128 v[35:38], v[49:50], off
	global_load_b128 v[39:42], v[49:50], off offset:16
	global_load_b128 v[43:46], v[49:50], off offset:32
	v_add_co_u32 v63, vcc_lo, 0x6000, v47
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v64, null, 0, v48, vcc_lo
	s_clause 0x4
	global_load_b128 v[47:50], v[49:50], off offset:48
	global_load_b128 v[51:54], v[63:64], off
	global_load_b128 v[55:58], v[63:64], off offset:16
	global_load_b128 v[59:62], v[63:64], off offset:32
	global_load_b128 v[63:66], v[63:64], off offset:48
	v_add_nc_u32_e32 v70, 0x3000, v16
	v_add_nc_u32_e32 v69, 0x2000, v16
	v_add_nc_u32_e32 v72, 0x5000, v16
	v_add_nc_u32_e32 v74, 0x7000, v16
	v_add_nc_u32_e32 v71, 0x4000, v16
	v_add_nc_u32_e32 v73, 0x6000, v16
	s_waitcnt lgkmcnt(0)
	s_and_b32 s1, s1, 0xffff
	s_waitcnt vmcnt(14)
	v_dual_add_f32 v0, 0, v0 :: v_dual_add_f32 v7, 0, v7
	v_dual_add_f32 v1, 0, v1 :: v_dual_add_f32 v2, 0, v2
	v_dual_add_f32 v3, 0, v3 :: v_dual_add_f32 v4, 0, v4
	s_waitcnt vmcnt(11)
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_dual_add_f32 v9, 0, v9 :: v_dual_add_f32 v0, v0, v19
	v_dual_add_f32 v1, v1, v20 :: v_dual_add_f32 v2, v2, v21
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_add_f32_e32 v3, v3, v22
	s_waitcnt vmcnt(7)
	v_dual_add_f32 v5, 0, v5 :: v_dual_add_f32 v0, v0, v35
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_dual_add_f32 v1, v1, v36 :: v_dual_add_f32 v2, v2, v37
	v_dual_add_f32 v3, v3, v38 :: v_dual_add_f32 v4, v4, v23
	s_waitcnt vmcnt(3)
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_dual_add_f32 v5, v5, v24 :: v_dual_add_f32 v0, v0, v51
	v_dual_add_f32 v1, v1, v52 :: v_dual_add_f32 v2, v2, v53
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_4)
	v_add_f32_e32 v3, v3, v54
	v_add_f32_e32 v6, 0, v6
	v_bfe_u32 v19, v0, 16, 1
	v_or_b32_e32 v20, 0x400000, v0
	v_bfe_u32 v21, v1, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v0, v0
	v_dual_add_f32 v4, v4, v39 :: v_dual_add_f32 v5, v5, v40
	v_add3_u32 v19, v19, v0, 0x7fff
	v_or_b32_e32 v22, 0x400000, v1
	v_bfe_u32 v23, v2, 16, 1
	v_add3_u32 v21, v21, v1, 0x7fff
	v_dual_add_f32 v8, 0, v8 :: v_dual_add_f32 v11, 0, v11
	v_cndmask_b32_e32 v0, v19, v20, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	v_dual_add_f32 v6, v6, v25 :: v_dual_add_f32 v7, v7, v26
	s_waitcnt vmcnt(2)
	v_dual_add_f32 v4, v4, v55 :: v_dual_add_f32 v5, v5, v56
	v_or_b32_e32 v24, 0x400000, v2
	v_bfe_u32 v25, v3, 16, 1
	v_add3_u32 v23, v23, v2, 0x7fff
	v_cndmask_b32_e32 v1, v21, v22, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_add_f32_e32 v10, 0, v10
	v_dual_add_f32 v8, v8, v27 :: v_dual_add_f32 v9, v9, v28
	v_dual_add_f32 v6, v6, v41 :: v_dual_add_f32 v7, v7, v42
	v_or_b32_e32 v26, 0x400000, v3
	v_bfe_u32 v27, v4, 16, 1
	v_add3_u32 v25, v25, v3, 0x7fff
	v_cndmask_b32_e32 v2, v23, v24, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_dual_add_f32 v12, 0, v12 :: v_dual_add_f32 v13, 0, v13
	v_dual_add_f32 v10, v10, v29 :: v_dual_add_f32 v11, v11, v30
	v_dual_add_f32 v6, v6, v57 :: v_dual_add_f32 v7, v7, v58
	v_or_b32_e32 v28, 0x400000, v4
	v_bfe_u32 v29, v5, 16, 1
	v_add3_u32 v27, v27, v4, 0x7fff
	v_cndmask_b32_e32 v3, v25, v26, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_dual_add_f32 v14, 0, v14 :: v_dual_add_f32 v15, 0, v15
	v_dual_add_f32 v12, v12, v31 :: v_dual_add_f32 v13, v13, v32
	v_dual_add_f32 v8, v8, v43 :: v_dual_add_f32 v9, v9, v44
	v_or_b32_e32 v30, 0x400000, v5
	v_bfe_u32 v31, v6, 16, 1
	v_add3_u32 v29, v29, v5, 0x7fff
	v_cndmask_b32_e32 v4, v27, v28, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_dual_add_f32 v14, v14, v33 :: v_dual_add_f32 v15, v15, v34
	s_waitcnt vmcnt(1)
	v_dual_add_f32 v8, v8, v59 :: v_dual_add_f32 v9, v9, v60
	v_or_b32_e32 v32, 0x400000, v6
	v_bfe_u32 v33, v7, 16, 1
	v_add3_u32 v31, v31, v6, 0x7fff
	v_cndmask_b32_e32 v5, v29, v30, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_dual_add_f32 v10, v10, v45 :: v_dual_add_f32 v11, v11, v46
	v_or_b32_e32 v34, 0x400000, v7
	v_bfe_u32 v35, v8, 16, 1
	v_add3_u32 v33, v33, v7, 0x7fff
	v_cndmask_b32_e32 v6, v31, v32, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_dual_add_f32 v10, v10, v61 :: v_dual_add_f32 v11, v11, v62
	v_or_b32_e32 v36, 0x400000, v8
	v_bfe_u32 v37, v9, 16, 1
	v_add3_u32 v35, v35, v8, 0x7fff
	v_cndmask_b32_e32 v7, v33, v34, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_dual_add_f32 v12, v12, v47 :: v_dual_add_f32 v13, v13, v48
	v_or_b32_e32 v38, 0x400000, v9
	v_bfe_u32 v39, v10, 16, 1
	v_add3_u32 v37, v37, v9, 0x7fff
	v_cndmask_b32_e32 v8, v35, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	s_waitcnt vmcnt(0)
	v_dual_add_f32 v12, v12, v63 :: v_dual_add_f32 v13, v13, v64
	v_or_b32_e32 v40, 0x400000, v10
	v_bfe_u32 v41, v11, 16, 1
	v_add3_u32 v39, v39, v10, 0x7fff
	v_cndmask_b32_e32 v9, v37, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_dual_add_f32 v14, v14, v49 :: v_dual_add_f32 v15, v15, v50
	v_or_b32_e32 v42, 0x400000, v11
	v_bfe_u32 v43, v12, 16, 1
	v_add3_u32 v41, v41, v11, 0x7fff
	v_cndmask_b32_e32 v10, v39, v40, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_dual_add_f32 v14, v14, v65 :: v_dual_add_f32 v15, v15, v66
	v_or_b32_e32 v44, 0x400000, v12
	v_bfe_u32 v45, v13, 16, 1
	v_add3_u32 v43, v43, v12, 0x7fff
	v_cndmask_b32_e32 v11, v41, v42, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_or_b32_e32 v46, 0x400000, v13
	v_bfe_u32 v47, v14, 16, 1
	v_add3_u32 v45, v45, v13, 0x7fff
	v_or_b32_e32 v48, 0x400000, v14
	v_cndmask_b32_e32 v12, v43, v44, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_bfe_u32 v49, v15, 16, 1
	v_add3_u32 v47, v47, v14, 0x7fff
	v_or_b32_e32 v50, 0x400000, v15
	v_lshrrev_b32_e32 v0, 16, v0
	v_cndmask_b32_e32 v13, v45, v46, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_add3_u32 v49, v49, v15, 0x7fff
	v_lshrrev_b32_e32 v1, 16, v1
	v_lshrrev_b32_e32 v2, 16, v2
	v_lshrrev_b32_e32 v3, 16, v3
	v_cndmask_b32_e32 v14, v47, v48, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_lshrrev_b32_e32 v4, 16, v4
	v_lshrrev_b32_e32 v5, 16, v5
	v_lshrrev_b32_e32 v6, 16, v6
	v_lshrrev_b32_e32 v7, 16, v7
	v_cndmask_b32_e32 v15, v49, v50, vcc_lo
	v_lshrrev_b32_e32 v8, 16, v8
	v_lshrrev_b32_e32 v9, 16, v9
	v_lshrrev_b32_e32 v10, 16, v10
	v_lshrrev_b32_e32 v11, 16, v11
	v_lshrrev_b32_e32 v12, 16, v12
	v_lshrrev_b32_e32 v13, 16, v13
	v_lshrrev_b32_e32 v14, 16, v14
	v_lshrrev_b32_e32 v15, 16, v15
	s_clause 0xf
	buffer_store_b16 v0, v16, s[0:3], 0 offen
	buffer_store_b16 v1, v68, s[0:3], 0 offen
	buffer_store_b16 v2, v69, s[0:3], 0 offen
	buffer_store_b16 v3, v70, s[0:3], 0 offen
	buffer_store_b16 v4, v71, s[0:3], 0 offen
	buffer_store_b16 v5, v72, s[0:3], 0 offen
	buffer_store_b16 v6, v73, s[0:3], 0 offen
	buffer_store_b16 v7, v74, s[0:3], 0 offen
	buffer_store_b16 v8, v16, s[0:3], 0 offen offset:128
	buffer_store_b16 v9, v68, s[0:3], 0 offen offset:128
	buffer_store_b16 v10, v69, s[0:3], 0 offen offset:128
	buffer_store_b16 v11, v70, s[0:3], 0 offen offset:128
	buffer_store_b16 v12, v71, s[0:3], 0 offen offset:128
	buffer_store_b16 v13, v72, s[0:3], 0 offen offset:128
	buffer_store_b16 v14, v73, s[0:3], 0 offen offset:128
	buffer_store_b16 v15, v74, s[0:3], 0 offen offset:128
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
		.amdhsa_group_segment_fixed_size 18688
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

	.set .Lexercise_kernel_0.num_vgpr, 161
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
    .group_segment_fixed_size: 18688
    .kernarg_segment_align: 8
    .kernarg_segment_size: 100
    .max_flat_workgroup_size: 128
    .name:           exercise_kernel_0
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 128
      - 1
      - 1
    .sgpr_count:     19
    .sgpr_spill_count: 0
    .symbol:         exercise_kernel_0.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     161
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
