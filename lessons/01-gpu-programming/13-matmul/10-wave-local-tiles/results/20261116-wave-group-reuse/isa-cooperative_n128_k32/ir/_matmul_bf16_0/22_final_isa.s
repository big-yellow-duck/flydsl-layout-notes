	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	_matmul_bf16_0
	.p2align	8
	.type	_matmul_bf16_0,@function
_matmul_bf16_0:
	v_lshrrev_b32_e32 v68, 4, v0
	s_clause 0x1
	s_load_b64 s[4:5], s[0:1], 0x0
	s_load_b64 s[8:9], s[0:1], 0x18
	s_ashr_i32 s3, s2, 31
	s_mov_b32 s7, 0x21027000
	s_lshr_b32 s3, s3, 27
	v_dual_mov_b32 v24, 0 :: v_dual_lshlrev_b32 v77, 12, v68
	v_and_b32_e32 v76, 15, v0
	s_add_i32 s3, s2, s3
	v_lshlrev_b32_e32 v1, 4, v0
	s_and_b32 s3, s3, 0x1ffffe0
	v_mov_b32_e32 v25, v24
	v_lshl_or_b32 v2, v76, 3, v77
	s_sub_i32 s2, s2, s3
	s_mov_b32 s6, -1
	s_lshl_b32 s12, s2, 7
	v_mov_b32_e32 v26, v24
	v_add_lshl_u32 v80, v2, s12, 1
	v_dual_mov_b32 v27, v24 :: v_dual_and_b32 v70, 48, v1
	s_mov_b32 s10, s6
	s_mov_b32 s11, s7
	s_delay_alu instid0(VALU_DEP_2)
	v_dual_mov_b32 v28, v24 :: v_dual_add_nc_u32 v1, 0x8000, v80
	s_waitcnt lgkmcnt(0)
	s_and_b32 s9, s9, 0xffff
	v_lshrrev_b32_e32 v69, 2, v0
	v_dual_mov_b32 v29, v24 :: v_dual_add_nc_u32 v2, 0x10000, v80
	s_clause 0x1
	buffer_load_b128 v[36:39], v80, s[8:11], 0 offen
	buffer_load_b128 v[40:43], v1, s[8:11], 0 offen
	v_dual_mov_b32 v30, v24 :: v_dual_add_nc_u32 v1, 0x18000, v80
	v_dual_mov_b32 v16, v24 :: v_dual_add_nc_u32 v3, 0x20000, v80
	v_dual_mov_b32 v31, v24 :: v_dual_add_nc_u32 v4, 0x28000, v80
	v_dual_mov_b32 v18, v24 :: v_dual_add_nc_u32 v5, 0x30000, v80
	v_lshl_or_b32 v81, v69, 14, v70
	v_dual_mov_b32 v17, v24 :: v_dual_add_nc_u32 v6, 0x38000, v80
	s_clause 0x5
	buffer_load_b128 v[44:47], v2, s[8:11], 0 offen
	buffer_load_b128 v[48:51], v1, s[8:11], 0 offen
	buffer_load_b128 v[52:55], v3, s[8:11], 0 offen
	buffer_load_b128 v[56:59], v4, s[8:11], 0 offen
	buffer_load_b128 v[60:63], v5, s[8:11], 0 offen
	buffer_load_b128 v[64:67], v6, s[8:11], 0 offen
	s_and_b32 s5, s5, 0xffff
	v_lshrrev_b32_e32 v7, 1, v0
	buffer_load_b128 v[32:35], v81, s[4:7], 0 offen
	v_mov_b32_e32 v19, v24
	v_dual_mov_b32 v21, v24 :: v_dual_lshlrev_b32 v84, 8, v68
	v_and_b32_e32 v78, 16, v7
	v_or_b32_e32 v68, 0x2000, v70
	v_mul_u32_u24_e32 v71, 0x50, v69
	v_dual_mov_b32 v20, v24 :: v_dual_lshlrev_b32 v83, 4, v76
	s_delay_alu instid0(VALU_DEP_4)
	v_or_b32_e32 v70, v76, v78
	v_mov_b32_e32 v22, v24
	v_mov_b32_e32 v23, v24
	v_mov_b32_e32 v8, v24
	v_mov_b32_e32 v9, v24
	v_mov_b32_e32 v10, v24
	v_mov_b32_e32 v11, v24
	v_mov_b32_e32 v12, v24
	v_mov_b32_e32 v13, v24
	v_mov_b32_e32 v14, v24
	v_mov_b32_e32 v15, v24
	v_mov_b32_e32 v0, v24
	v_mov_b32_e32 v1, v24
	v_mov_b32_e32 v2, v24
	v_mov_b32_e32 v3, v24
	v_mov_b32_e32 v4, v24
	v_mov_b32_e32 v5, v24
	v_mov_b32_e32 v6, v24
	v_mov_b32_e32 v7, v24
	v_mul_u32_u24_e32 v82, 0x50, v76
	v_mad_u32_u24 v69, 0x50, v69, v68
	v_lshlrev_b32_e32 v79, 1, v70
	v_add_nc_u32_e32 v85, v68, v71
	v_or_b32_e32 v72, v83, v84
	s_mov_b32 s2, 0
	s_waitcnt vmcnt(0)
	ds_store_b128 v69, v[32:35]
	ds_store_b128 v72, v[36:39]
	ds_store_b128 v72, v[40:43] offset:1024
	ds_store_b128 v72, v[44:47] offset:2048
	ds_store_b128 v72, v[48:51] offset:3072
	ds_store_b128 v72, v[52:55] offset:4096
	ds_store_b128 v72, v[56:59] offset:5120
	ds_store_b128 v72, v[60:63] offset:6144
	ds_store_b128 v72, v[64:67] offset:7168
	s_waitcnt lgkmcnt(0)
	s_barrier
.LBB0_1:
	s_add_i32 s2, s2, 1
	v_add_nc_u32_e32 v158, v83, v84
	v_lshl_add_u32 v32, s2, 6, v81
	v_lshl_add_u32 v33, s2, 18, v80
	s_cmpk_lg_i32 s2, 0xff
	buffer_load_b128 v[40:43], v32, s[4:7], 0 offen
	v_add_nc_u32_e32 v32, 0x8000, v33
	v_add_nc_u32_e32 v34, 0x10000, v33
	v_add_nc_u32_e32 v35, 0x18000, v33
	v_add_nc_u32_e32 v36, 0x20000, v33
	v_add_nc_u32_e32 v37, 0x28000, v33
	v_add_nc_u32_e32 v38, 0x30000, v33
	v_add_nc_u32_e32 v39, 0x38000, v33
	s_clause 0x7
	buffer_load_b128 v[44:47], v33, s[8:11], 0 offen
	buffer_load_b128 v[48:51], v32, s[8:11], 0 offen
	buffer_load_b128 v[52:55], v34, s[8:11], 0 offen
	buffer_load_b128 v[56:59], v35, s[8:11], 0 offen
	buffer_load_b128 v[60:63], v36, s[8:11], 0 offen
	buffer_load_b128 v[64:67], v37, s[8:11], 0 offen
	buffer_load_b128 v[68:71], v38, s[8:11], 0 offen
	buffer_load_b128 v[72:75], v39, s[8:11], 0 offen
	ds_load_b128 v[86:89], v82 offset:8192
	ds_load_b128 v[90:93], v82 offset:8208
	ds_load_b128 v[32:35], v82 offset:8224
	ds_load_b128 v[36:39], v82 offset:8240
	ds_load_u16_d16 v94, v79
	ds_load_u16_d16_hi v94, v79 offset:256
	ds_load_u16_d16 v102, v79 offset:64
	ds_load_u16_d16_hi v102, v79 offset:320
	ds_load_u16_d16 v110, v79 offset:128
	ds_load_u16_d16_hi v110, v79 offset:384
	ds_load_u16_d16_hi v118, v79 offset:448
	ds_load_u16_d16 v118, v79 offset:192
	ds_load_u16_d16 v95, v79 offset:512
	ds_load_u16_d16_hi v95, v79 offset:768
	ds_load_u16_d16 v103, v79 offset:576
	ds_load_u16_d16_hi v103, v79 offset:832
	ds_load_u16_d16 v111, v79 offset:640
	ds_load_u16_d16_hi v111, v79 offset:896
	ds_load_u16_d16_hi v119, v79 offset:960
	ds_load_u16_d16 v119, v79 offset:704
	ds_load_u16_d16 v96, v79 offset:1024
	ds_load_u16_d16_hi v96, v79 offset:1280
	ds_load_u16_d16 v104, v79 offset:1088
	ds_load_u16_d16_hi v104, v79 offset:1344
	ds_load_u16_d16 v112, v79 offset:1152
	ds_load_u16_d16_hi v112, v79 offset:1408
	ds_load_u16_d16_hi v120, v79 offset:1472
	ds_load_u16_d16 v120, v79 offset:1216
	ds_load_u16_d16 v97, v79 offset:1536
	ds_load_u16_d16_hi v97, v79 offset:1792
	ds_load_u16_d16 v105, v79 offset:1600
	ds_load_u16_d16_hi v105, v79 offset:1856
	ds_load_u16_d16 v113, v79 offset:1664
	ds_load_u16_d16_hi v113, v79 offset:1920
	ds_load_u16_d16_hi v121, v79 offset:1984
	ds_load_u16_d16 v121, v79 offset:1728
	ds_load_u16_d16 v98, v79 offset:2048
	ds_load_u16_d16_hi v98, v79 offset:2304
	ds_load_u16_d16 v106, v79 offset:2112
	ds_load_u16_d16_hi v106, v79 offset:2368
	ds_load_u16_d16 v114, v79 offset:2176
	ds_load_u16_d16_hi v114, v79 offset:2432
	ds_load_u16_d16_hi v122, v79 offset:2496
	ds_load_u16_d16 v122, v79 offset:2240
	ds_load_u16_d16 v99, v79 offset:2560
	ds_load_u16_d16_hi v99, v79 offset:2816
	ds_load_u16_d16 v107, v79 offset:2624
	ds_load_u16_d16_hi v107, v79 offset:2880
	ds_load_u16_d16 v115, v79 offset:2688
	ds_load_u16_d16_hi v115, v79 offset:2944
	ds_load_u16_d16_hi v123, v79 offset:3008
	ds_load_u16_d16 v123, v79 offset:2752
	ds_load_u16_d16 v100, v79 offset:3072
	ds_load_u16_d16_hi v100, v79 offset:3328
	ds_load_u16_d16 v108, v79 offset:3136
	ds_load_u16_d16_hi v108, v79 offset:3392
	ds_load_u16_d16 v116, v79 offset:3200
	ds_load_u16_d16_hi v116, v79 offset:3456
	ds_load_u16_d16_hi v124, v79 offset:3520
	ds_load_u16_d16 v124, v79 offset:3264
	ds_load_u16_d16 v101, v79 offset:3584
	ds_load_u16_d16_hi v101, v79 offset:3840
	ds_load_u16_d16 v109, v79 offset:3648
	ds_load_u16_d16_hi v109, v79 offset:3904
	ds_load_u16_d16 v117, v79 offset:3712
	ds_load_u16_d16_hi v117, v79 offset:3968
	ds_load_u16_d16_hi v125, v79 offset:4032
	ds_load_u16_d16 v125, v79 offset:3776
	ds_load_u16_d16 v126, v79 offset:4096
	ds_load_u16_d16_hi v126, v79 offset:4352
	ds_load_u16_d16 v134, v79 offset:4160
	ds_load_u16_d16_hi v134, v79 offset:4416
	ds_load_u16_d16 v142, v79 offset:4224
	ds_load_u16_d16_hi v142, v79 offset:4480
	ds_load_u16_d16_hi v150, v79 offset:4544
	ds_load_u16_d16 v150, v79 offset:4288
	ds_load_u16_d16 v127, v79 offset:4608
	ds_load_u16_d16_hi v127, v79 offset:4864
	ds_load_u16_d16 v135, v79 offset:4672
	ds_load_u16_d16_hi v135, v79 offset:4928
	ds_load_u16_d16 v143, v79 offset:4736
	ds_load_u16_d16_hi v143, v79 offset:4992
	ds_load_u16_d16_hi v151, v79 offset:5056
	ds_load_u16_d16 v151, v79 offset:4800
	ds_load_u16_d16 v128, v79 offset:5120
	ds_load_u16_d16_hi v128, v79 offset:5376
	ds_load_u16_d16 v136, v79 offset:5184
	ds_load_u16_d16_hi v136, v79 offset:5440
	ds_load_u16_d16 v144, v79 offset:5248
	ds_load_u16_d16_hi v144, v79 offset:5504
	ds_load_u16_d16_hi v152, v79 offset:5568
	ds_load_u16_d16 v152, v79 offset:5312
	ds_load_u16_d16 v129, v79 offset:5632
	ds_load_u16_d16_hi v129, v79 offset:5888
	ds_load_u16_d16 v137, v79 offset:5696
	ds_load_u16_d16_hi v137, v79 offset:5952
	ds_load_u16_d16 v145, v79 offset:5760
	ds_load_u16_d16_hi v145, v79 offset:6016
	ds_load_u16_d16_hi v153, v79 offset:6080
	ds_load_u16_d16 v153, v79 offset:5824
	ds_load_u16_d16 v130, v79 offset:6144
	ds_load_u16_d16_hi v130, v79 offset:6400
	ds_load_u16_d16 v138, v79 offset:6208
	ds_load_u16_d16_hi v138, v79 offset:6464
	ds_load_u16_d16 v146, v79 offset:6272
	ds_load_u16_d16_hi v146, v79 offset:6528
	ds_load_u16_d16_hi v154, v79 offset:6592
	ds_load_u16_d16 v154, v79 offset:6336
	ds_load_u16_d16 v131, v79 offset:6656
	ds_load_u16_d16_hi v131, v79 offset:6912
	ds_load_u16_d16 v139, v79 offset:6720
	ds_load_u16_d16_hi v139, v79 offset:6976
	ds_load_u16_d16 v147, v79 offset:6784
	ds_load_u16_d16_hi v147, v79 offset:7040
	ds_load_u16_d16_hi v155, v79 offset:7104
	ds_load_u16_d16 v155, v79 offset:6848
	ds_load_u16_d16 v132, v79 offset:7168
	ds_load_u16_d16_hi v132, v79 offset:7424
	ds_load_u16_d16 v140, v79 offset:7232
	ds_load_u16_d16_hi v140, v79 offset:7488
	ds_load_u16_d16 v148, v79 offset:7296
	ds_load_u16_d16_hi v148, v79 offset:7552
	ds_load_u16_d16_hi v156, v79 offset:7616
	ds_load_u16_d16 v156, v79 offset:7360
	ds_load_u16_d16 v133, v79 offset:7680
	ds_load_u16_d16_hi v133, v79 offset:7936
	ds_load_u16_d16 v141, v79 offset:7744
	ds_load_u16_d16_hi v141, v79 offset:8000
	ds_load_u16_d16 v149, v79 offset:7808
	ds_load_u16_d16_hi v149, v79 offset:8064
	ds_load_u16_d16_hi v157, v79 offset:8128
	ds_load_u16_d16 v157, v79 offset:7872
	s_waitcnt lgkmcnt(62)
	v_wmma_f32_16x16x16_bf16 v[24:31], v[86:93], v[94:101], v[24:31]
	v_wmma_f32_16x16x16_bf16 v[16:23], v[86:93], v[102:109], v[16:23]
	v_wmma_f32_16x16x16_bf16 v[8:15], v[86:93], v[110:117], v[8:15]
	v_wmma_f32_16x16x16_bf16 v[0:7], v[86:93], v[118:125], v[0:7]
	s_waitcnt lgkmcnt(6)
	v_wmma_f32_16x16x16_bf16 v[24:31], v[32:39], v[126:133], v[24:31]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[16:23], v[32:39], v[134:141], v[16:23]
	s_waitcnt lgkmcnt(2)
	v_wmma_f32_16x16x16_bf16 v[8:15], v[32:39], v[142:149], v[8:15]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[0:7], v[32:39], v[150:157], v[0:7]
	s_barrier
	s_waitcnt vmcnt(8)
	ds_store_b128 v85, v[40:43]
	s_waitcnt vmcnt(7)
	ds_store_b128 v158, v[44:47]
	s_waitcnt vmcnt(6)
	ds_store_b128 v158, v[48:51] offset:1024
	s_waitcnt vmcnt(5)
	ds_store_b128 v158, v[52:55] offset:2048
	s_waitcnt vmcnt(4)
	ds_store_b128 v158, v[56:59] offset:3072
	s_waitcnt vmcnt(3)
	ds_store_b128 v158, v[60:63] offset:4096
	s_waitcnt vmcnt(2)
	ds_store_b128 v158, v[64:67] offset:5120
	s_waitcnt vmcnt(1)
	ds_store_b128 v158, v[68:71] offset:6144
	s_waitcnt vmcnt(0)
	ds_store_b128 v158, v[72:75] offset:7168
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_cbranch_scc1 .LBB0_1
	ds_load_b128 v[32:35], v82 offset:8192
	ds_load_b128 v[36:39], v82 offset:8208
	ds_load_b128 v[40:43], v82 offset:8224
	ds_load_b128 v[44:47], v82 offset:8240
	ds_load_u16_d16 v48, v79
	ds_load_u16_d16_hi v48, v79 offset:256
	ds_load_u16_d16 v56, v79 offset:64
	ds_load_u16_d16_hi v56, v79 offset:320
	ds_load_u16_d16 v64, v79 offset:128
	ds_load_u16_d16_hi v64, v79 offset:384
	ds_load_u16_d16_hi v80, v79 offset:448
	ds_load_u16_d16 v80, v79 offset:192
	ds_load_u16_d16 v49, v79 offset:512
	ds_load_u16_d16_hi v49, v79 offset:768
	ds_load_u16_d16 v57, v79 offset:576
	ds_load_u16_d16_hi v57, v79 offset:832
	ds_load_u16_d16 v65, v79 offset:640
	ds_load_u16_d16_hi v65, v79 offset:896
	ds_load_u16_d16_hi v81, v79 offset:960
	ds_load_u16_d16 v81, v79 offset:704
	ds_load_u16_d16 v50, v79 offset:1024
	ds_load_u16_d16_hi v50, v79 offset:1280
	ds_load_u16_d16 v58, v79 offset:1088
	ds_load_u16_d16_hi v58, v79 offset:1344
	ds_load_u16_d16 v66, v79 offset:1152
	ds_load_u16_d16_hi v66, v79 offset:1408
	ds_load_u16_d16_hi v82, v79 offset:1472
	ds_load_u16_d16 v82, v79 offset:1216
	ds_load_u16_d16 v51, v79 offset:1536
	ds_load_u16_d16_hi v51, v79 offset:1792
	ds_load_u16_d16 v59, v79 offset:1600
	ds_load_u16_d16_hi v59, v79 offset:1856
	ds_load_u16_d16 v67, v79 offset:1664
	ds_load_u16_d16_hi v67, v79 offset:1920
	ds_load_u16_d16_hi v83, v79 offset:1984
	ds_load_u16_d16 v83, v79 offset:1728
	ds_load_u16_d16 v52, v79 offset:2048
	ds_load_u16_d16_hi v52, v79 offset:2304
	ds_load_u16_d16 v60, v79 offset:2112
	ds_load_u16_d16_hi v60, v79 offset:2368
	ds_load_u16_d16 v68, v79 offset:2176
	ds_load_u16_d16_hi v68, v79 offset:2432
	ds_load_u16_d16_hi v84, v79 offset:2496
	ds_load_u16_d16 v84, v79 offset:2240
	ds_load_u16_d16 v53, v79 offset:2560
	ds_load_u16_d16_hi v53, v79 offset:2816
	ds_load_u16_d16 v61, v79 offset:2624
	ds_load_u16_d16_hi v61, v79 offset:2880
	ds_load_u16_d16 v69, v79 offset:2688
	ds_load_u16_d16_hi v69, v79 offset:2944
	ds_load_u16_d16_hi v85, v79 offset:3008
	ds_load_u16_d16 v85, v79 offset:2752
	ds_load_u16_d16 v54, v79 offset:3072
	ds_load_u16_d16_hi v54, v79 offset:3328
	ds_load_u16_d16 v62, v79 offset:3136
	ds_load_u16_d16_hi v62, v79 offset:3392
	ds_load_u16_d16 v70, v79 offset:3200
	ds_load_u16_d16_hi v70, v79 offset:3456
	ds_load_u16_d16_hi v86, v79 offset:3520
	ds_load_u16_d16 v86, v79 offset:3264
	ds_load_u16_d16 v55, v79 offset:3584
	ds_load_u16_d16_hi v55, v79 offset:3840
	ds_load_u16_d16 v63, v79 offset:3648
	ds_load_u16_d16_hi v63, v79 offset:3904
	ds_load_u16_d16 v71, v79 offset:3712
	ds_load_u16_d16_hi v71, v79 offset:3968
	ds_load_u16_d16_hi v87, v79 offset:4032
	ds_load_u16_d16 v87, v79 offset:3776
	ds_load_u16_d16 v95, v79 offset:7680
	ds_load_u16_d16_hi v95, v79 offset:7936
	ds_load_u16_d16 v88, v79 offset:4096
	ds_load_u16_d16_hi v88, v79 offset:4352
	ds_load_u16_d16 v96, v79 offset:4160
	ds_load_u16_d16_hi v96, v79 offset:4416
	ds_load_u16_d16 v104, v79 offset:4224
	ds_load_u16_d16_hi v104, v79 offset:4480
	ds_load_u16_d16_hi v112, v79 offset:4544
	ds_load_u16_d16 v112, v79 offset:4288
	ds_load_u16_d16 v89, v79 offset:4608
	ds_load_u16_d16_hi v89, v79 offset:4864
	ds_load_u16_d16 v97, v79 offset:4672
	ds_load_u16_d16_hi v97, v79 offset:4928
	ds_load_u16_d16 v105, v79 offset:4736
	ds_load_u16_d16_hi v105, v79 offset:4992
	ds_load_u16_d16_hi v113, v79 offset:5056
	ds_load_u16_d16 v113, v79 offset:4800
	ds_load_u16_d16 v90, v79 offset:5120
	ds_load_u16_d16_hi v90, v79 offset:5376
	ds_load_u16_d16 v98, v79 offset:5184
	ds_load_u16_d16_hi v98, v79 offset:5440
	ds_load_u16_d16 v106, v79 offset:5248
	ds_load_u16_d16_hi v106, v79 offset:5504
	ds_load_u16_d16_hi v114, v79 offset:5568
	ds_load_u16_d16 v114, v79 offset:5312
	ds_load_u16_d16 v91, v79 offset:5632
	ds_load_u16_d16_hi v91, v79 offset:5888
	ds_load_u16_d16 v99, v79 offset:5696
	ds_load_u16_d16_hi v99, v79 offset:5952
	ds_load_u16_d16 v107, v79 offset:5760
	ds_load_u16_d16_hi v107, v79 offset:6016
	ds_load_u16_d16_hi v115, v79 offset:6080
	ds_load_u16_d16 v115, v79 offset:5824
	ds_load_u16_d16 v92, v79 offset:6144
	ds_load_u16_d16_hi v92, v79 offset:6400
	ds_load_u16_d16 v100, v79 offset:6208
	ds_load_u16_d16_hi v100, v79 offset:6464
	ds_load_u16_d16 v108, v79 offset:6272
	ds_load_u16_d16_hi v108, v79 offset:6528
	ds_load_u16_d16_hi v116, v79 offset:6592
	ds_load_u16_d16 v116, v79 offset:6336
	ds_load_u16_d16 v93, v79 offset:6656
	ds_load_u16_d16_hi v93, v79 offset:6912
	ds_load_u16_d16 v101, v79 offset:6720
	ds_load_u16_d16_hi v101, v79 offset:6976
	ds_load_u16_d16 v109, v79 offset:6784
	ds_load_u16_d16_hi v109, v79 offset:7040
	ds_load_u16_d16_hi v117, v79 offset:7104
	ds_load_u16_d16 v117, v79 offset:6848
	ds_load_u16_d16 v94, v79 offset:7168
	ds_load_u16_d16_hi v94, v79 offset:7424
	ds_load_u16_d16 v102, v79 offset:7232
	ds_load_u16_d16_hi v102, v79 offset:7488
	ds_load_u16_d16 v110, v79 offset:7296
	ds_load_u16_d16_hi v110, v79 offset:7552
	ds_load_u16_d16_hi v118, v79 offset:7616
	ds_load_u16_d16 v118, v79 offset:7360
	ds_load_u16_d16 v103, v79 offset:7744
	ds_load_u16_d16_hi v103, v79 offset:8000
	ds_load_u16_d16 v111, v79 offset:7808
	ds_load_u16_d16_hi v111, v79 offset:8064
	ds_load_u16_d16_hi v119, v79 offset:8128
	ds_load_u16_d16 v119, v79 offset:7872
	s_waitcnt lgkmcnt(62)
	v_wmma_f32_16x16x16_bf16 v[24:31], v[32:39], v[48:55], v[24:31]
	v_wmma_f32_16x16x16_bf16 v[16:23], v[32:39], v[56:63], v[16:23]
	v_wmma_f32_16x16x16_bf16 v[8:15], v[32:39], v[64:71], v[8:15]
	v_wmma_f32_16x16x16_bf16 v[0:7], v[32:39], v[80:87], v[0:7]
	s_load_b64 s[0:1], s[0:1], 0x30
	s_mov_b32 s3, 0x21027000
	s_mov_b32 s2, -1
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[24:31], v[40:47], v[88:95], v[24:31]
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_bfe_u32 v32, v24, 16, 1
	v_bfe_u32 v33, v25, 16, 1
	v_or_b32_e32 v34, 0x400000, v24
	v_cmp_u_f32_e32 vcc_lo, v24, v24
	v_or_b32_e32 v35, 0x400000, v25
	v_add3_u32 v32, v32, v24, 0x7fff
	v_add3_u32 v33, v33, v25, 0x7fff
	v_or_b32_e32 v36, 0x400000, v27
	v_or_b32_e32 v37, 0x400000, v28
	v_wmma_f32_16x16x16_bf16 v[16:23], v[40:47], v[96:103], v[16:23]
	v_cndmask_b32_e32 v24, v32, v34, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v25, v25
	v_bfe_u32 v32, v26, 16, 1
	v_bfe_u32 v34, v28, 16, 1
	v_wmma_f32_16x16x16_bf16 v[8:15], v[40:47], v[104:111], v[8:15]
	v_wmma_f32_16x16x16_bf16 v[0:7], v[40:47], v[112:119], v[0:7]
	v_cndmask_b32_e32 v25, v33, v35, vcc_lo
	v_bfe_u32 v33, v27, 16, 1
	v_add3_u32 v32, v32, v26, 0x7fff
	v_or_b32_e32 v35, 0x400000, v26
	v_cmp_u_f32_e32 vcc_lo, v26, v26
	v_add3_u32 v34, v34, v28, 0x7fff
	v_add3_u32 v33, v33, v27, 0x7fff
	v_lshrrev_b32_e32 v24, 16, v24
	v_lshrrev_b32_e32 v25, 16, v25
	v_cndmask_b32_e32 v26, v32, v35, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v27, v27
	v_bfe_u32 v32, v29, 16, 1
	v_or_b32_e32 v35, 0x400000, v29
	s_and_b32 s1, s1, 0xffff
	v_cndmask_b32_e32 v27, v33, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v28, v28
	v_bfe_u32 v33, v30, 16, 1
	v_add3_u32 v32, v32, v29, 0x7fff
	v_or_b32_e32 v36, 0x400000, v30
	v_lshrrev_b32_e32 v26, 16, v26
	v_cndmask_b32_e32 v28, v34, v37, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v29, v29
	v_bfe_u32 v34, v31, 16, 1
	v_add3_u32 v33, v33, v30, 0x7fff
	v_or_b32_e32 v37, 0x400000, v31
	v_lshrrev_b32_e32 v27, 16, v27
	v_cndmask_b32_e32 v29, v32, v35, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v30, v30
	v_add3_u32 v34, v34, v31, 0x7fff
	v_bfe_u32 v32, v16, 16, 1
	v_or_b32_e32 v35, 0x400000, v16
	v_lshrrev_b32_e32 v28, 16, v28
	v_cndmask_b32_e32 v30, v33, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v31, v31
	v_bfe_u32 v33, v17, 16, 1
	v_add3_u32 v32, v32, v16, 0x7fff
	v_or_b32_e32 v36, 0x400000, v17
	v_lshrrev_b32_e32 v29, 16, v29
	v_cndmask_b32_e32 v31, v34, v37, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	v_bfe_u32 v34, v18, 16, 1
	v_add3_u32 v33, v33, v17, 0x7fff
	v_or_b32_e32 v37, 0x400000, v18
	v_lshrrev_b32_e32 v30, 16, v30
	v_cndmask_b32_e32 v16, v32, v35, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v17, v17
	v_add3_u32 v34, v34, v18, 0x7fff
	v_bfe_u32 v32, v19, 16, 1
	v_or_b32_e32 v35, 0x400000, v19
	v_lshrrev_b32_e32 v31, 16, v31
	v_cndmask_b32_e32 v17, v33, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v18, v18
	v_bfe_u32 v33, v20, 16, 1
	v_add3_u32 v32, v32, v19, 0x7fff
	v_or_b32_e32 v36, 0x400000, v20
	v_lshrrev_b32_e32 v16, 16, v16
	v_cndmask_b32_e32 v18, v34, v37, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v19, v19
	v_bfe_u32 v34, v21, 16, 1
	v_add3_u32 v33, v33, v20, 0x7fff
	v_or_b32_e32 v37, 0x400000, v21
	v_lshrrev_b32_e32 v17, 16, v17
	v_cndmask_b32_e32 v19, v32, v35, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v20, v20
	v_add3_u32 v34, v34, v21, 0x7fff
	v_bfe_u32 v32, v22, 16, 1
	v_or_b32_e32 v35, 0x400000, v22
	v_lshrrev_b32_e32 v18, 16, v18
	v_cndmask_b32_e32 v20, v33, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v21, v21
	v_bfe_u32 v33, v23, 16, 1
	v_add3_u32 v32, v32, v22, 0x7fff
	v_or_b32_e32 v36, 0x400000, v23
	v_lshrrev_b32_e32 v19, 16, v19
	v_cndmask_b32_e32 v21, v34, v37, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v22, v22
	v_bfe_u32 v34, v8, 16, 1
	v_add3_u32 v33, v33, v23, 0x7fff
	v_or_b32_e32 v37, 0x400000, v8
	v_lshrrev_b32_e32 v20, 16, v20
	v_cndmask_b32_e32 v22, v32, v35, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v23, v23
	v_add3_u32 v34, v34, v8, 0x7fff
	v_bfe_u32 v32, v9, 16, 1
	v_or_b32_e32 v35, 0x400000, v9
	v_lshrrev_b32_e32 v21, 16, v21
	v_cndmask_b32_e32 v23, v33, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_bfe_u32 v33, v10, 16, 1
	v_add3_u32 v32, v32, v9, 0x7fff
	v_or_b32_e32 v36, 0x400000, v10
	v_lshrrev_b32_e32 v22, 16, v22
	v_cndmask_b32_e32 v8, v34, v37, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_bfe_u32 v34, v11, 16, 1
	v_add3_u32 v33, v33, v10, 0x7fff
	v_or_b32_e32 v37, 0x400000, v11
	v_lshrrev_b32_e32 v23, 16, v23
	v_cndmask_b32_e32 v9, v32, v35, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_add3_u32 v34, v34, v11, 0x7fff
	v_bfe_u32 v32, v12, 16, 1
	v_or_b32_e32 v35, 0x400000, v12
	v_lshrrev_b32_e32 v8, 16, v8
	v_cndmask_b32_e32 v10, v33, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_bfe_u32 v33, v13, 16, 1
	v_add3_u32 v32, v32, v12, 0x7fff
	v_or_b32_e32 v36, 0x400000, v13
	v_lshrrev_b32_e32 v9, 16, v9
	v_cndmask_b32_e32 v11, v34, v37, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_bfe_u32 v34, v14, 16, 1
	v_add3_u32 v33, v33, v13, 0x7fff
	v_or_b32_e32 v37, 0x400000, v14
	v_lshrrev_b32_e32 v10, 16, v10
	v_cndmask_b32_e32 v12, v32, v35, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_add3_u32 v34, v34, v14, 0x7fff
	v_bfe_u32 v32, v15, 16, 1
	v_bfe_u32 v35, v1, 16, 1
	v_cndmask_b32_e32 v13, v33, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_bfe_u32 v33, v0, 16, 1
	v_add3_u32 v32, v32, v15, 0x7fff
	v_or_b32_e32 v36, 0x400000, v0
	s_barrier
	v_cndmask_b32_e32 v14, v34, v37, vcc_lo
	v_or_b32_e32 v34, 0x400000, v15
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_add3_u32 v33, v33, v0, 0x7fff
	v_or_b32_e32 v37, 0x400000, v7
	v_lshrrev_b32_e32 v11, 16, v11
	v_cndmask_b32_e32 v15, v32, v34, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v0, v0
	v_add3_u32 v32, v35, v1, 0x7fff
	v_or_b32_e32 v34, 0x400000, v1
	v_bfe_u32 v35, v4, 16, 1
	v_lshrrev_b32_e32 v12, 16, v12
	v_cndmask_b32_e32 v0, v33, v36, vcc_lo
	v_bfe_u32 v33, v2, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	v_bfe_u32 v36, v5, 16, 1
	v_lshrrev_b32_e32 v13, 16, v13
	v_lshrrev_b32_e32 v14, 16, v14
	v_lshrrev_b32_e32 v15, 16, v15
	v_cndmask_b32_e32 v1, v32, v34, vcc_lo
	v_add3_u32 v32, v33, v2, 0x7fff
	v_or_b32_e32 v33, 0x400000, v2
	v_bfe_u32 v34, v3, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_lshrrev_b32_e32 v0, 16, v0
	v_lshrrev_b32_e32 v1, 16, v1
	v_cndmask_b32_e32 v2, v32, v33, vcc_lo
	v_add3_u32 v32, v34, v3, 0x7fff
	v_or_b32_e32 v33, 0x400000, v3
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_add3_u32 v34, v35, v4, 0x7fff
	v_or_b32_e32 v35, 0x400000, v4
	v_lshrrev_b32_e32 v2, 16, v2
	v_cndmask_b32_e32 v3, v32, v33, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_add3_u32 v32, v36, v5, 0x7fff
	v_or_b32_e32 v33, 0x400000, v5
	v_or_b32_e32 v36, 0x400000, v6
	v_cndmask_b32_e32 v4, v34, v35, vcc_lo
	v_bfe_u32 v34, v6, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_or_b32_e32 v35, s12, v78
	v_lshrrev_b32_e32 v3, 16, v3
	v_lshrrev_b32_e32 v4, 16, v4
	v_add3_u32 v34, v34, v6, 0x7fff
	v_cndmask_b32_e32 v5, v32, v33, vcc_lo
	v_bfe_u32 v32, v7, 16, 1
	v_and_or_b32 v33, 0x1000, v77, v76
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_add3_u32 v32, v32, v7, 0x7fff
	v_add_lshl_u32 v33, v35, v33, 1
	v_cndmask_b32_e32 v6, v34, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_lshrrev_b32_e32 v5, 16, v5
	s_delay_alu instid0(VALU_DEP_4)
	v_add_nc_u32_e32 v34, 0x8000, v33
	v_add_nc_u32_e32 v35, 0x18000, v33
	v_cndmask_b32_e32 v7, v32, v37, vcc_lo
	v_add_nc_u32_e32 v32, 0x4000, v33
	s_clause 0x2
	buffer_store_b16 v24, v33, s[0:3], 0 offen
	buffer_store_b16 v25, v32, s[0:3], 0 offen
	buffer_store_b16 v26, v34, s[0:3], 0 offen
	v_add_nc_u32_e32 v24, 0xc000, v33
	v_add_nc_u32_e32 v25, 0x10000, v33
	v_add_nc_u32_e32 v26, 0x14000, v33
	v_add_nc_u32_e32 v36, 0x1c000, v33
	v_lshrrev_b32_e32 v6, 16, v6
	v_lshrrev_b32_e32 v7, 16, v7
	s_clause 0x1c
	buffer_store_b16 v27, v24, s[0:3], 0 offen
	buffer_store_b16 v28, v25, s[0:3], 0 offen
	buffer_store_b16 v29, v26, s[0:3], 0 offen
	buffer_store_b16 v30, v35, s[0:3], 0 offen
	buffer_store_b16 v31, v36, s[0:3], 0 offen
	buffer_store_b16 v16, v33, s[0:3], 0 offen offset:64
	buffer_store_b16 v17, v32, s[0:3], 0 offen offset:64
	buffer_store_b16 v18, v34, s[0:3], 0 offen offset:64
	buffer_store_b16 v19, v24, s[0:3], 0 offen offset:64
	buffer_store_b16 v20, v25, s[0:3], 0 offen offset:64
	buffer_store_b16 v21, v26, s[0:3], 0 offen offset:64
	buffer_store_b16 v22, v35, s[0:3], 0 offen offset:64
	buffer_store_b16 v23, v36, s[0:3], 0 offen offset:64
	buffer_store_b16 v8, v33, s[0:3], 0 offen offset:128
	buffer_store_b16 v9, v32, s[0:3], 0 offen offset:128
	buffer_store_b16 v10, v34, s[0:3], 0 offen offset:128
	buffer_store_b16 v11, v24, s[0:3], 0 offen offset:128
	buffer_store_b16 v12, v25, s[0:3], 0 offen offset:128
	buffer_store_b16 v13, v26, s[0:3], 0 offen offset:128
	buffer_store_b16 v14, v35, s[0:3], 0 offen offset:128
	buffer_store_b16 v15, v36, s[0:3], 0 offen offset:128
	buffer_store_b16 v0, v33, s[0:3], 0 offen offset:192
	buffer_store_b16 v1, v32, s[0:3], 0 offen offset:192
	buffer_store_b16 v2, v34, s[0:3], 0 offen offset:192
	buffer_store_b16 v3, v24, s[0:3], 0 offen offset:192
	buffer_store_b16 v4, v25, s[0:3], 0 offen offset:192
	buffer_store_b16 v5, v26, s[0:3], 0 offen offset:192
	buffer_store_b16 v6, v35, s[0:3], 0 offen offset:192
	buffer_store_b16 v7, v36, s[0:3], 0 offen offset:192
	s_nop 0
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
	s_endpgm
.Lfunc_end0:
	.size	_matmul_bf16_0, .Lfunc_end0-_matmul_bf16_0
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _matmul_bf16_0
		.amdhsa_group_segment_fixed_size 9472
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
		.amdhsa_next_free_vgpr 193
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

	.set .L_matmul_bf16_0.num_vgpr, 159
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
    .group_segment_fixed_size: 9472
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
    .vgpr_count:     159
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
