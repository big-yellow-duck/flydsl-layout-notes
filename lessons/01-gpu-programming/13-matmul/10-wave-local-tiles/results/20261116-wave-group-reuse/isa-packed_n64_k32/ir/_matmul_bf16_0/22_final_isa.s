	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	_matmul_bf16_0
	.p2align	8
	.type	_matmul_bf16_0,@function
_matmul_bf16_0:
	v_lshrrev_b32_e32 v7, 5, v0
	s_lshl_b32 s3, s2, 1
	s_bfe_i32 s2, s2, 0x1001e
	s_clause 0x1
	s_load_b64 s[4:5], s[0:1], 0x0
	s_load_b64 s[8:9], s[0:1], 0x18
	s_lshr_b32 s2, s2, 26
	v_or_b32_e32 v1, s3, v7
	v_bfe_u32 v74, v0, 3, 2
	v_bfe_u32 v73, v0, 2, 3
	s_mov_b32 s6, -1
	s_mov_b32 s7, 0x21027000
	v_dual_mov_b32 v25, 0 :: v_dual_add_nc_u32 v2, s2, v1
	v_lshlrev_b32_e32 v3, 3, v0
	v_lshlrev_b32_e32 v4, 4, v0
	s_mov_b32 s10, s6
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_dual_mov_b32 v29, v25 :: v_dual_and_b32 v2, 0x3ffffc0, v2
	v_dual_mov_b32 v26, v25 :: v_dual_and_b32 v75, 56, v3
	v_mov_b32_e32 v28, v25
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_sub_nc_u32_e32 v1, v1, v2
	v_dual_mov_b32 v27, v25 :: v_dual_and_b32 v76, 48, v4
	v_mov_b32_e32 v31, v25
	v_lshl_or_b32 v2, v74, 12, v75
	v_dual_mov_b32 v30, v25 :: v_dual_lshlrev_b32 v105, 6, v1
	s_delay_alu instid0(VALU_DEP_4)
	v_lshl_or_b32 v108, v73, 14, v76
	s_waitcnt lgkmcnt(0)
	s_and_b32 s5, s5, 0xffff
	s_mov_b32 s11, s7
	v_add_lshl_u32 v109, v105, v2, 1
	s_and_b32 s9, s9, 0xffff
	v_or_b32_e32 v1, 0x20000, v108
	s_clause 0x1
	buffer_load_b128 v[33:36], v108, s[4:7], 0 offen
	buffer_load_b128 v[37:40], v1, s[4:7], 0 offen
	v_dual_mov_b32 v32, v25 :: v_dual_add_nc_u32 v1, 0x8000, v109
	v_dual_mov_b32 v17, v25 :: v_dual_add_nc_u32 v2, 0x10000, v109
	v_dual_mov_b32 v18, v25 :: v_dual_add_nc_u32 v3, 0x18000, v109
	v_dual_mov_b32 v19, v25 :: v_dual_add_nc_u32 v4, 0x20000, v109
	v_dual_mov_b32 v20, v25 :: v_dual_add_nc_u32 v5, 0x28000, v109
	v_dual_mov_b32 v21, v25 :: v_dual_add_nc_u32 v6, 0x30000, v109
	v_dual_mov_b32 v23, v25 :: v_dual_add_nc_u32 v8, 0x38000, v109
	s_clause 0x7
	buffer_load_b128 v[41:44], v109, s[8:11], 0 offen
	buffer_load_b128 v[45:48], v1, s[8:11], 0 offen
	buffer_load_b128 v[49:52], v2, s[8:11], 0 offen
	buffer_load_b128 v[53:56], v3, s[8:11], 0 offen
	buffer_load_b128 v[57:60], v4, s[8:11], 0 offen
	buffer_load_b128 v[61:64], v5, s[8:11], 0 offen
	buffer_load_b128 v[65:68], v6, s[8:11], 0 offen
	buffer_load_b128 v[69:72], v8, s[8:11], 0 offen
	v_mul_u32_u24_e32 v8, 0x500, v7
	v_dual_mov_b32 v9, v25 :: v_dual_and_b32 v106, 15, v0
	v_dual_mov_b32 v22, v25 :: v_dual_lshlrev_b32 v77, 12, v7
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_2) | instid1(VALU_DEP_4)
	v_or_b32_e32 v78, 0x2000, v8
	v_dual_mov_b32 v24, v25 :: v_dual_lshlrev_b32 v111, 7, v74
	v_mov_b32_e32 v12, v25
	v_lshl_or_b32 v112, v75, 1, v77
	s_delay_alu instid0(VALU_DEP_4)
	v_or_b32_e32 v74, v78, v76
	v_mul_u32_u24_e32 v75, 0x50, v106
	v_mul_u32_u24_e32 v76, 0x50, v73
	v_mov_b32_e32 v10, v25
	v_mov_b32_e32 v11, v25
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
	v_lshl_or_b32 v107, v106, 1, v77
	v_mad_u32_u24 v73, 0x50, v73, v74
	v_add_nc_u32_e32 v110, v78, v75
	v_add_nc_u32_e32 v113, v74, v76
	v_or_b32_e32 v77, v112, v111
	s_mov_b32 s2, 0
	s_waitcnt vmcnt(9)
	ds_store_b128 v73, v[33:36]
	s_waitcnt vmcnt(8)
	ds_store_b128 v73, v[37:40] offset:640
	s_waitcnt vmcnt(7)
	ds_store_b128 v77, v[41:44]
	s_waitcnt vmcnt(6)
	ds_store_b128 v77, v[45:48] offset:512
	s_waitcnt vmcnt(5)
	ds_store_b128 v77, v[49:52] offset:1024
	s_waitcnt vmcnt(4)
	ds_store_b128 v77, v[53:56] offset:1536
	s_waitcnt vmcnt(3)
	ds_store_b128 v77, v[57:60] offset:2048
	s_waitcnt vmcnt(2)
	ds_store_b128 v77, v[61:64] offset:2560
	s_waitcnt vmcnt(1)
	ds_store_b128 v77, v[65:68] offset:3072
	s_waitcnt vmcnt(0)
	ds_store_b128 v77, v[69:72] offset:3584
.LBB0_1:
	s_add_i32 s2, s2, 1
	v_add_nc_u32_e32 v162, v112, v111
	v_lshl_add_u32 v33, s2, 6, v108
	v_lshl_add_u32 v34, s2, 18, v109
	s_cmpk_lg_i32 s2, 0xff
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
	v_add_nc_u32_e32 v35, 0x20000, v33
	v_add_nc_u32_e32 v36, 0x8000, v34
	v_add_nc_u32_e32 v37, 0x10000, v34
	v_add_nc_u32_e32 v38, 0x18000, v34
	v_add_nc_u32_e32 v39, 0x20000, v34
	v_add_nc_u32_e32 v40, 0x28000, v34
	v_add_nc_u32_e32 v41, 0x30000, v34
	v_add_nc_u32_e32 v42, 0x38000, v34
	s_clause 0x1
	buffer_load_b128 v[65:68], v33, s[4:7], 0 offen
	buffer_load_b128 v[69:72], v35, s[4:7], 0 offen
	s_clause 0x7
	buffer_load_b128 v[73:76], v34, s[8:11], 0 offen
	buffer_load_b128 v[77:80], v36, s[8:11], 0 offen
	buffer_load_b128 v[81:84], v37, s[8:11], 0 offen
	buffer_load_b128 v[85:88], v38, s[8:11], 0 offen
	buffer_load_b128 v[89:92], v39, s[8:11], 0 offen
	buffer_load_b128 v[93:96], v40, s[8:11], 0 offen
	buffer_load_b128 v[97:100], v41, s[8:11], 0 offen
	buffer_load_b128 v[101:104], v42, s[8:11], 0 offen
	ds_load_b128 v[41:44], v110
	ds_load_b128 v[45:48], v110 offset:16
	ds_load_b128 v[37:40], v110 offset:48
	ds_load_b128 v[33:36], v110 offset:32
	ds_load_u16_d16_hi v49, v107 offset:128
	ds_load_u16_d16 v49, v107
	ds_load_u16_d16 v57, v107 offset:32
	ds_load_u16_d16_hi v57, v107 offset:160
	ds_load_u16_d16 v114, v107 offset:64
	ds_load_u16_d16_hi v114, v107 offset:192
	ds_load_u16_d16_hi v122, v107 offset:224
	ds_load_u16_d16 v122, v107 offset:96
	ds_load_u16_d16 v50, v107 offset:256
	ds_load_u16_d16_hi v50, v107 offset:384
	ds_load_u16_d16 v58, v107 offset:288
	ds_load_u16_d16_hi v58, v107 offset:416
	ds_load_u16_d16 v115, v107 offset:320
	ds_load_u16_d16_hi v115, v107 offset:448
	ds_load_u16_d16_hi v123, v107 offset:480
	ds_load_u16_d16 v123, v107 offset:352
	ds_load_u16_d16 v51, v107 offset:512
	ds_load_u16_d16_hi v51, v107 offset:640
	ds_load_u16_d16 v59, v107 offset:544
	ds_load_u16_d16_hi v59, v107 offset:672
	ds_load_u16_d16 v116, v107 offset:576
	ds_load_u16_d16_hi v116, v107 offset:704
	ds_load_u16_d16_hi v124, v107 offset:736
	ds_load_u16_d16 v124, v107 offset:608
	ds_load_u16_d16 v52, v107 offset:768
	ds_load_u16_d16_hi v52, v107 offset:896
	ds_load_u16_d16 v60, v107 offset:800
	ds_load_u16_d16_hi v60, v107 offset:928
	ds_load_u16_d16 v117, v107 offset:832
	ds_load_u16_d16_hi v117, v107 offset:960
	ds_load_u16_d16_hi v125, v107 offset:992
	ds_load_u16_d16 v125, v107 offset:864
	ds_load_u16_d16 v53, v107 offset:1024
	ds_load_u16_d16_hi v53, v107 offset:1152
	ds_load_u16_d16 v61, v107 offset:1056
	ds_load_u16_d16_hi v61, v107 offset:1184
	ds_load_u16_d16 v118, v107 offset:1088
	ds_load_u16_d16_hi v118, v107 offset:1216
	ds_load_u16_d16_hi v126, v107 offset:1248
	ds_load_u16_d16 v126, v107 offset:1120
	ds_load_u16_d16 v54, v107 offset:1280
	ds_load_u16_d16_hi v54, v107 offset:1408
	ds_load_u16_d16 v62, v107 offset:1312
	ds_load_u16_d16_hi v62, v107 offset:1440
	ds_load_u16_d16 v119, v107 offset:1344
	ds_load_u16_d16_hi v119, v107 offset:1472
	ds_load_u16_d16_hi v127, v107 offset:1504
	ds_load_u16_d16 v127, v107 offset:1376
	ds_load_u16_d16 v55, v107 offset:1536
	ds_load_u16_d16_hi v55, v107 offset:1664
	ds_load_u16_d16 v63, v107 offset:1568
	ds_load_u16_d16_hi v63, v107 offset:1696
	ds_load_u16_d16 v120, v107 offset:1600
	ds_load_u16_d16_hi v120, v107 offset:1728
	ds_load_u16_d16_hi v128, v107 offset:1760
	ds_load_u16_d16 v128, v107 offset:1632
	ds_load_u16_d16 v56, v107 offset:1792
	ds_load_u16_d16_hi v56, v107 offset:1920
	ds_load_u16_d16 v64, v107 offset:1824
	ds_load_u16_d16_hi v64, v107 offset:1952
	ds_load_u16_d16 v121, v107 offset:1856
	ds_load_u16_d16_hi v121, v107 offset:1984
	ds_load_u16_d16_hi v129, v107 offset:2016
	ds_load_u16_d16 v129, v107 offset:1888
	ds_load_u16_d16 v130, v107 offset:2048
	ds_load_u16_d16_hi v130, v107 offset:2176
	ds_load_u16_d16 v138, v107 offset:2080
	ds_load_u16_d16_hi v138, v107 offset:2208
	ds_load_u16_d16 v146, v107 offset:2112
	ds_load_u16_d16_hi v146, v107 offset:2240
	ds_load_u16_d16_hi v154, v107 offset:2272
	ds_load_u16_d16 v154, v107 offset:2144
	ds_load_u16_d16 v131, v107 offset:2304
	ds_load_u16_d16_hi v131, v107 offset:2432
	ds_load_u16_d16 v139, v107 offset:2336
	ds_load_u16_d16_hi v139, v107 offset:2464
	ds_load_u16_d16 v147, v107 offset:2368
	ds_load_u16_d16_hi v147, v107 offset:2496
	ds_load_u16_d16_hi v155, v107 offset:2528
	ds_load_u16_d16 v155, v107 offset:2400
	ds_load_u16_d16 v132, v107 offset:2560
	ds_load_u16_d16_hi v132, v107 offset:2688
	ds_load_u16_d16 v140, v107 offset:2592
	ds_load_u16_d16_hi v140, v107 offset:2720
	ds_load_u16_d16 v148, v107 offset:2624
	ds_load_u16_d16_hi v148, v107 offset:2752
	ds_load_u16_d16_hi v156, v107 offset:2784
	ds_load_u16_d16 v156, v107 offset:2656
	ds_load_u16_d16 v133, v107 offset:2816
	ds_load_u16_d16_hi v133, v107 offset:2944
	ds_load_u16_d16 v141, v107 offset:2848
	ds_load_u16_d16_hi v141, v107 offset:2976
	ds_load_u16_d16 v149, v107 offset:2880
	ds_load_u16_d16_hi v149, v107 offset:3008
	ds_load_u16_d16_hi v157, v107 offset:3040
	ds_load_u16_d16 v157, v107 offset:2912
	ds_load_u16_d16 v134, v107 offset:3072
	ds_load_u16_d16_hi v134, v107 offset:3200
	ds_load_u16_d16 v142, v107 offset:3104
	ds_load_u16_d16_hi v142, v107 offset:3232
	ds_load_u16_d16 v150, v107 offset:3136
	ds_load_u16_d16_hi v150, v107 offset:3264
	ds_load_u16_d16_hi v158, v107 offset:3296
	ds_load_u16_d16 v158, v107 offset:3168
	ds_load_u16_d16 v135, v107 offset:3328
	ds_load_u16_d16_hi v135, v107 offset:3456
	ds_load_u16_d16 v143, v107 offset:3360
	ds_load_u16_d16_hi v143, v107 offset:3488
	ds_load_u16_d16 v151, v107 offset:3392
	ds_load_u16_d16_hi v151, v107 offset:3520
	ds_load_u16_d16_hi v159, v107 offset:3552
	ds_load_u16_d16 v159, v107 offset:3424
	ds_load_u16_d16 v136, v107 offset:3584
	ds_load_u16_d16_hi v136, v107 offset:3712
	ds_load_u16_d16 v144, v107 offset:3616
	ds_load_u16_d16_hi v144, v107 offset:3744
	ds_load_u16_d16 v152, v107 offset:3648
	ds_load_u16_d16_hi v152, v107 offset:3776
	ds_load_u16_d16_hi v160, v107 offset:3808
	ds_load_u16_d16 v160, v107 offset:3680
	ds_load_u16_d16 v137, v107 offset:3840
	ds_load_u16_d16_hi v137, v107 offset:3968
	ds_load_u16_d16 v145, v107 offset:3872
	ds_load_u16_d16_hi v145, v107 offset:4000
	ds_load_u16_d16 v153, v107 offset:3904
	ds_load_u16_d16_hi v153, v107 offset:4032
	ds_load_u16_d16_hi v161, v107 offset:4064
	ds_load_u16_d16 v161, v107 offset:3936
	s_waitcnt lgkmcnt(62)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[41:48], v[49:56], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[41:48], v[57:64], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[41:48], v[114:121], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[41:48], v[122:129], v[1:8]
	s_waitcnt vmcnt(9)
	ds_store_b128 v113, v[65:68]
	s_waitcnt vmcnt(8)
	ds_store_b128 v113, v[69:72] offset:640
	s_waitcnt vmcnt(7)
	ds_store_b128 v162, v[73:76]
	s_waitcnt vmcnt(6)
	ds_store_b128 v162, v[77:80] offset:512
	s_waitcnt vmcnt(5)
	ds_store_b128 v162, v[81:84] offset:1024
	s_waitcnt vmcnt(4)
	ds_store_b128 v162, v[85:88] offset:1536
	s_waitcnt vmcnt(3)
	ds_store_b128 v162, v[89:92] offset:2048
	s_waitcnt vmcnt(2)
	ds_store_b128 v162, v[93:96] offset:2560
	s_waitcnt vmcnt(1)
	ds_store_b128 v162, v[97:100] offset:3072
	s_waitcnt vmcnt(0)
	ds_store_b128 v162, v[101:104] offset:3584
	s_waitcnt lgkmcnt(16)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[33:40], v[130:137], v[25:32]
	s_waitcnt lgkmcnt(14)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[33:40], v[138:145], v[17:24]
	s_waitcnt lgkmcnt(12)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[33:40], v[146:153], v[9:16]
	s_waitcnt lgkmcnt(10)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[33:40], v[154:161], v[1:8]
	s_cbranch_scc1 .LBB0_1
	ds_load_b128 v[33:36], v110
	ds_load_b128 v[37:40], v110 offset:16
	ds_load_b128 v[45:48], v110 offset:48
	ds_load_b128 v[41:44], v110 offset:32
	ds_load_u16_d16_hi v49, v107 offset:128
	ds_load_u16_d16 v49, v107
	ds_load_u16_d16 v57, v107 offset:32
	ds_load_u16_d16_hi v57, v107 offset:160
	ds_load_u16_d16 v65, v107 offset:64
	ds_load_u16_d16_hi v65, v107 offset:192
	ds_load_u16_d16_hi v73, v107 offset:224
	ds_load_u16_d16 v73, v107 offset:96
	ds_load_u16_d16 v50, v107 offset:256
	ds_load_u16_d16_hi v50, v107 offset:384
	ds_load_u16_d16 v58, v107 offset:288
	ds_load_u16_d16_hi v58, v107 offset:416
	ds_load_u16_d16 v66, v107 offset:320
	ds_load_u16_d16_hi v66, v107 offset:448
	ds_load_u16_d16_hi v74, v107 offset:480
	ds_load_u16_d16 v74, v107 offset:352
	ds_load_u16_d16 v51, v107 offset:512
	ds_load_u16_d16_hi v51, v107 offset:640
	ds_load_u16_d16 v59, v107 offset:544
	ds_load_u16_d16_hi v59, v107 offset:672
	ds_load_u16_d16 v67, v107 offset:576
	ds_load_u16_d16_hi v67, v107 offset:704
	ds_load_u16_d16_hi v75, v107 offset:736
	ds_load_u16_d16 v75, v107 offset:608
	ds_load_u16_d16 v52, v107 offset:768
	ds_load_u16_d16_hi v52, v107 offset:896
	ds_load_u16_d16 v60, v107 offset:800
	ds_load_u16_d16_hi v60, v107 offset:928
	ds_load_u16_d16 v68, v107 offset:832
	ds_load_u16_d16_hi v68, v107 offset:960
	ds_load_u16_d16_hi v76, v107 offset:992
	ds_load_u16_d16 v76, v107 offset:864
	ds_load_u16_d16 v53, v107 offset:1024
	ds_load_u16_d16_hi v53, v107 offset:1152
	ds_load_u16_d16 v61, v107 offset:1056
	ds_load_u16_d16_hi v61, v107 offset:1184
	ds_load_u16_d16 v69, v107 offset:1088
	ds_load_u16_d16_hi v69, v107 offset:1216
	ds_load_u16_d16_hi v77, v107 offset:1248
	ds_load_u16_d16 v77, v107 offset:1120
	ds_load_u16_d16 v54, v107 offset:1280
	ds_load_u16_d16_hi v54, v107 offset:1408
	ds_load_u16_d16 v62, v107 offset:1312
	ds_load_u16_d16_hi v62, v107 offset:1440
	ds_load_u16_d16 v70, v107 offset:1344
	ds_load_u16_d16_hi v70, v107 offset:1472
	ds_load_u16_d16_hi v78, v107 offset:1504
	ds_load_u16_d16 v78, v107 offset:1376
	ds_load_u16_d16 v55, v107 offset:1536
	ds_load_u16_d16_hi v55, v107 offset:1664
	ds_load_u16_d16 v63, v107 offset:1568
	ds_load_u16_d16_hi v63, v107 offset:1696
	ds_load_u16_d16 v71, v107 offset:1600
	ds_load_u16_d16_hi v71, v107 offset:1728
	ds_load_u16_d16_hi v79, v107 offset:1760
	ds_load_u16_d16 v79, v107 offset:1632
	ds_load_u16_d16 v56, v107 offset:1792
	ds_load_u16_d16_hi v56, v107 offset:1920
	ds_load_u16_d16 v64, v107 offset:1824
	ds_load_u16_d16_hi v64, v107 offset:1952
	ds_load_u16_d16 v72, v107 offset:1856
	ds_load_u16_d16_hi v72, v107 offset:1984
	ds_load_u16_d16_hi v80, v107 offset:2016
	ds_load_u16_d16 v80, v107 offset:1888
	ds_load_u16_d16 v88, v107 offset:3840
	ds_load_u16_d16_hi v88, v107 offset:3968
	ds_load_u16_d16 v81, v107 offset:2048
	ds_load_u16_d16_hi v81, v107 offset:2176
	ds_load_u16_d16 v89, v107 offset:2080
	ds_load_u16_d16_hi v89, v107 offset:2208
	ds_load_u16_d16 v97, v107 offset:2112
	ds_load_u16_d16_hi v97, v107 offset:2240
	ds_load_u16_d16_hi v108, v107 offset:2272
	ds_load_u16_d16 v108, v107 offset:2144
	ds_load_u16_d16 v82, v107 offset:2304
	ds_load_u16_d16_hi v82, v107 offset:2432
	ds_load_u16_d16 v90, v107 offset:2336
	ds_load_u16_d16_hi v90, v107 offset:2464
	ds_load_u16_d16 v98, v107 offset:2368
	ds_load_u16_d16_hi v98, v107 offset:2496
	ds_load_u16_d16_hi v109, v107 offset:2528
	ds_load_u16_d16 v109, v107 offset:2400
	ds_load_u16_d16 v83, v107 offset:2560
	ds_load_u16_d16_hi v83, v107 offset:2688
	ds_load_u16_d16 v91, v107 offset:2592
	ds_load_u16_d16_hi v91, v107 offset:2720
	ds_load_u16_d16 v99, v107 offset:2624
	ds_load_u16_d16_hi v99, v107 offset:2752
	ds_load_u16_d16_hi v110, v107 offset:2784
	ds_load_u16_d16 v110, v107 offset:2656
	ds_load_u16_d16 v84, v107 offset:2816
	ds_load_u16_d16_hi v84, v107 offset:2944
	ds_load_u16_d16 v92, v107 offset:2848
	ds_load_u16_d16_hi v92, v107 offset:2976
	ds_load_u16_d16 v100, v107 offset:2880
	ds_load_u16_d16_hi v100, v107 offset:3008
	ds_load_u16_d16_hi v111, v107 offset:3040
	ds_load_u16_d16 v111, v107 offset:2912
	ds_load_u16_d16 v85, v107 offset:3072
	ds_load_u16_d16_hi v85, v107 offset:3200
	ds_load_u16_d16 v93, v107 offset:3104
	ds_load_u16_d16_hi v93, v107 offset:3232
	ds_load_u16_d16 v101, v107 offset:3136
	ds_load_u16_d16_hi v101, v107 offset:3264
	ds_load_u16_d16_hi v112, v107 offset:3296
	ds_load_u16_d16 v112, v107 offset:3168
	ds_load_u16_d16 v86, v107 offset:3328
	ds_load_u16_d16_hi v86, v107 offset:3456
	ds_load_u16_d16 v94, v107 offset:3360
	ds_load_u16_d16_hi v94, v107 offset:3488
	ds_load_u16_d16 v102, v107 offset:3392
	ds_load_u16_d16_hi v102, v107 offset:3520
	ds_load_u16_d16_hi v113, v107 offset:3552
	ds_load_u16_d16 v113, v107 offset:3424
	ds_load_u16_d16 v87, v107 offset:3584
	ds_load_u16_d16_hi v87, v107 offset:3712
	ds_load_u16_d16 v95, v107 offset:3616
	ds_load_u16_d16_hi v95, v107 offset:3744
	ds_load_u16_d16 v103, v107 offset:3648
	ds_load_u16_d16_hi v103, v107 offset:3776
	ds_load_u16_d16_hi v114, v107 offset:3808
	ds_load_u16_d16 v114, v107 offset:3680
	ds_load_u16_d16 v96, v107 offset:3872
	ds_load_u16_d16_hi v96, v107 offset:4000
	ds_load_u16_d16 v104, v107 offset:3904
	ds_load_u16_d16_hi v104, v107 offset:4032
	ds_load_u16_d16_hi v115, v107 offset:4064
	ds_load_u16_d16 v115, v107 offset:3936
	s_waitcnt lgkmcnt(62)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[33:40], v[49:56], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[33:40], v[57:64], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[33:40], v[65:72], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[33:40], v[73:80], v[1:8]
	s_load_b64 s[0:1], s[0:1], 0x30
	s_mov_b32 s3, 0x21027000
	s_mov_b32 s2, -1
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[41:48], v[81:88], v[25:32]
	v_lshlrev_b32_e32 v0, 8, v0
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_bfe_u32 v33, v25, 16, 1
	v_bfe_u32 v34, v26, 16, 1
	v_or_b32_e32 v35, 0x400000, v25
	v_cmp_u_f32_e32 vcc_lo, v25, v25
	v_or_b32_e32 v36, 0x400000, v26
	v_add3_u32 v33, v33, v25, 0x7fff
	v_add3_u32 v34, v34, v26, 0x7fff
	v_or_b32_e32 v37, 0x400000, v28
	v_or_b32_e32 v38, 0x400000, v29
	v_wmma_f32_16x16x16_bf16 v[17:24], v[41:48], v[89:96], v[17:24]
	v_cndmask_b32_e32 v25, v33, v35, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v26, v26
	v_bfe_u32 v33, v27, 16, 1
	v_bfe_u32 v35, v29, 16, 1
	v_wmma_f32_16x16x16_bf16 v[9:16], v[41:48], v[97:104], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[41:48], v[108:115], v[1:8]
	v_cndmask_b32_e32 v26, v34, v36, vcc_lo
	v_bfe_u32 v34, v28, 16, 1
	v_add3_u32 v33, v33, v27, 0x7fff
	v_or_b32_e32 v36, 0x400000, v27
	v_cmp_u_f32_e32 vcc_lo, v27, v27
	v_add3_u32 v35, v35, v29, 0x7fff
	v_add3_u32 v34, v34, v28, 0x7fff
	v_lshrrev_b32_e32 v25, 16, v25
	v_lshrrev_b32_e32 v26, 16, v26
	v_cndmask_b32_e32 v27, v33, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v28, v28
	v_bfe_u32 v33, v30, 16, 1
	v_or_b32_e32 v36, 0x400000, v30
	s_and_b32 s1, s1, 0xffff
	v_and_b32_e32 v0, 0x1000, v0
	v_cndmask_b32_e32 v28, v34, v37, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v29, v29
	v_bfe_u32 v34, v31, 16, 1
	v_add3_u32 v33, v33, v30, 0x7fff
	v_or_b32_e32 v37, 0x400000, v31
	v_lshrrev_b32_e32 v27, 16, v27
	v_cndmask_b32_e32 v29, v35, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v30, v30
	v_bfe_u32 v35, v32, 16, 1
	v_add3_u32 v34, v34, v31, 0x7fff
	v_or_b32_e32 v38, 0x400000, v32
	v_lshrrev_b32_e32 v28, 16, v28
	v_cndmask_b32_e32 v30, v33, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v31, v31
	v_add3_u32 v35, v35, v32, 0x7fff
	v_bfe_u32 v33, v17, 16, 1
	v_or_b32_e32 v36, 0x400000, v17
	v_lshrrev_b32_e32 v29, 16, v29
	v_cndmask_b32_e32 v31, v34, v37, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v32, v32
	v_bfe_u32 v34, v18, 16, 1
	v_add3_u32 v33, v33, v17, 0x7fff
	v_or_b32_e32 v37, 0x400000, v18
	v_lshrrev_b32_e32 v30, 16, v30
	v_cndmask_b32_e32 v32, v35, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v17, v17
	v_bfe_u32 v35, v19, 16, 1
	v_add3_u32 v34, v34, v18, 0x7fff
	v_or_b32_e32 v38, 0x400000, v19
	v_lshrrev_b32_e32 v31, 16, v31
	v_cndmask_b32_e32 v17, v33, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v18, v18
	v_add3_u32 v35, v35, v19, 0x7fff
	v_bfe_u32 v33, v20, 16, 1
	v_or_b32_e32 v36, 0x400000, v20
	v_lshrrev_b32_e32 v32, 16, v32
	v_cndmask_b32_e32 v18, v34, v37, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v19, v19
	v_bfe_u32 v34, v21, 16, 1
	v_add3_u32 v33, v33, v20, 0x7fff
	v_or_b32_e32 v37, 0x400000, v21
	v_lshrrev_b32_e32 v17, 16, v17
	v_cndmask_b32_e32 v19, v35, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v20, v20
	v_bfe_u32 v35, v22, 16, 1
	v_add3_u32 v34, v34, v21, 0x7fff
	v_or_b32_e32 v38, 0x400000, v22
	v_lshrrev_b32_e32 v18, 16, v18
	v_cndmask_b32_e32 v20, v33, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v21, v21
	v_add3_u32 v35, v35, v22, 0x7fff
	v_bfe_u32 v33, v23, 16, 1
	v_or_b32_e32 v36, 0x400000, v23
	v_lshrrev_b32_e32 v19, 16, v19
	v_cndmask_b32_e32 v21, v34, v37, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v22, v22
	v_bfe_u32 v34, v24, 16, 1
	v_add3_u32 v33, v33, v23, 0x7fff
	v_or_b32_e32 v37, 0x400000, v24
	v_lshrrev_b32_e32 v20, 16, v20
	v_cndmask_b32_e32 v22, v35, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v23, v23
	v_bfe_u32 v35, v9, 16, 1
	v_add3_u32 v34, v34, v24, 0x7fff
	v_or_b32_e32 v38, 0x400000, v9
	v_lshrrev_b32_e32 v21, 16, v21
	v_cndmask_b32_e32 v23, v33, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v24, v24
	v_add3_u32 v35, v35, v9, 0x7fff
	v_bfe_u32 v33, v10, 16, 1
	v_or_b32_e32 v36, 0x400000, v10
	v_lshrrev_b32_e32 v22, 16, v22
	v_cndmask_b32_e32 v24, v34, v37, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_bfe_u32 v34, v11, 16, 1
	v_add3_u32 v33, v33, v10, 0x7fff
	v_or_b32_e32 v37, 0x400000, v11
	v_lshrrev_b32_e32 v23, 16, v23
	v_cndmask_b32_e32 v9, v35, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_bfe_u32 v35, v12, 16, 1
	v_add3_u32 v34, v34, v11, 0x7fff
	v_or_b32_e32 v38, 0x400000, v12
	v_lshrrev_b32_e32 v24, 16, v24
	v_cndmask_b32_e32 v10, v33, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_add3_u32 v35, v35, v12, 0x7fff
	v_bfe_u32 v33, v13, 16, 1
	v_or_b32_e32 v36, 0x400000, v13
	v_lshrrev_b32_e32 v9, 16, v9
	v_cndmask_b32_e32 v11, v34, v37, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_bfe_u32 v34, v14, 16, 1
	v_add3_u32 v33, v33, v13, 0x7fff
	v_or_b32_e32 v37, 0x400000, v14
	v_lshrrev_b32_e32 v10, 16, v10
	v_cndmask_b32_e32 v12, v35, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_bfe_u32 v35, v15, 16, 1
	v_add3_u32 v34, v34, v14, 0x7fff
	v_or_b32_e32 v38, 0x400000, v15
	v_lshrrev_b32_e32 v11, 16, v11
	v_cndmask_b32_e32 v13, v33, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_add3_u32 v35, v35, v15, 0x7fff
	v_bfe_u32 v33, v16, 16, 1
	v_or_b32_e32 v36, 0x400000, v16
	v_lshrrev_b32_e32 v12, 16, v12
	v_cndmask_b32_e32 v14, v34, v37, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_bfe_u32 v34, v1, 16, 1
	v_add3_u32 v33, v33, v16, 0x7fff
	v_or_b32_e32 v37, 0x400000, v1
	v_lshrrev_b32_e32 v13, 16, v13
	v_cndmask_b32_e32 v15, v35, v38, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	v_bfe_u32 v35, v2, 16, 1
	v_add3_u32 v34, v34, v1, 0x7fff
	v_or_b32_e32 v38, 0x400000, v2
	v_lshrrev_b32_e32 v14, 16, v14
	v_cndmask_b32_e32 v16, v33, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	v_add3_u32 v35, v35, v2, 0x7fff
	v_bfe_u32 v33, v3, 16, 1
	v_bfe_u32 v36, v5, 16, 1
	v_lshrrev_b32_e32 v15, 16, v15
	v_cndmask_b32_e32 v1, v34, v37, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_bfe_u32 v34, v4, 16, 1
	v_add3_u32 v33, v33, v3, 0x7fff
	v_or_b32_e32 v37, 0x400000, v4
	v_lshrrev_b32_e32 v16, 16, v16
	v_cndmask_b32_e32 v2, v35, v38, vcc_lo
	v_or_b32_e32 v35, 0x400000, v3
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_add3_u32 v34, v34, v4, 0x7fff
	v_lshrrev_b32_e32 v1, 16, v1
	v_lshrrev_b32_e32 v2, 16, v2
	v_cndmask_b32_e32 v3, v33, v35, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_add3_u32 v33, v36, v5, 0x7fff
	v_or_b32_e32 v35, 0x400000, v5
	v_or_b32_e32 v36, 0x400000, v7
	v_cndmask_b32_e32 v4, v34, v37, vcc_lo
	v_bfe_u32 v34, v6, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_or_b32_e32 v37, 0x400000, v8
	v_lshrrev_b32_e32 v3, 16, v3
	v_lshrrev_b32_e32 v4, 16, v4
	v_cndmask_b32_e32 v5, v33, v35, vcc_lo
	v_add3_u32 v33, v34, v6, 0x7fff
	v_or_b32_e32 v34, 0x400000, v6
	v_bfe_u32 v35, v7, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_lshrrev_b32_e32 v5, 16, v5
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_4) | instid1(VALU_DEP_3)
	v_add3_u32 v35, v35, v7, 0x7fff
	v_cndmask_b32_e32 v6, v33, v34, vcc_lo
	v_bfe_u32 v33, v8, 16, 1
	v_or_b32_e32 v34, v106, v105
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_add3_u32 v33, v33, v8, 0x7fff
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_3) | instid1(VALU_DEP_4)
	v_add_lshl_u32 v0, v34, v0, 1
	v_cndmask_b32_e32 v7, v35, v36, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_lshrrev_b32_e32 v6, 16, v6
	v_add_nc_u32_e32 v34, 0x8000, v0
	v_dual_cndmask_b32 v8, v33, v37 :: v_dual_add_nc_u32 v35, 0x18000, v0
	v_add_nc_u32_e32 v33, 0x4000, v0
	s_clause 0x2
	buffer_store_b16 v25, v0, s[0:3], 0 offen
	buffer_store_b16 v26, v33, s[0:3], 0 offen
	buffer_store_b16 v27, v34, s[0:3], 0 offen
	v_add_nc_u32_e32 v25, 0xc000, v0
	v_add_nc_u32_e32 v26, 0x10000, v0
	v_add_nc_u32_e32 v27, 0x14000, v0
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
	.size	_matmul_bf16_0, .Lfunc_end0-_matmul_bf16_0
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _matmul_bf16_0
		.amdhsa_group_segment_fixed_size 10752
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
		.amdhsa_next_free_vgpr 217
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

	.set .L_matmul_bf16_0.num_vgpr, 163
	.set .L_matmul_bf16_0.num_agpr, 0
	.set .L_matmul_bf16_0.numbered_sgpr, 12
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
    .group_segment_fixed_size: 10752
    .kernarg_segment_align: 8
    .kernarg_segment_size: 72
    .max_flat_workgroup_size: 64
    .name:           _matmul_bf16_0
    .private_segment_fixed_size: 0
    .reqd_workgroup_size:
      - 64
      - 1
      - 1
    .sgpr_count:     14
    .sgpr_spill_count: 0
    .symbol:         _matmul_bf16_0.kd
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
