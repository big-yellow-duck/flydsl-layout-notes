	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	exercise_kernel_0
	.p2align	8
	.type	exercise_kernel_0,@function
exercise_kernel_0:
	s_ashr_i32 s13, s2, 31
	v_and_b32_e32 v225, 15, v0
	s_lshr_b32 s3, s13, 30
	s_clause 0x1
	s_load_b64 s[4:5], s[0:1], 0x0
	s_load_b64 s[8:9], s[0:1], 0x18
	v_lshrrev_b32_e32 v113, 4, v0
	s_add_i32 s3, s2, s3
	v_lshlrev_b32_e32 v230, 4, v225
	s_ashr_i32 s6, s3, 2
	s_and_b32 s3, s3, -4
	s_lshr_b32 s10, s6, 29
	v_lshlrev_b32_e32 v226, 10, v113
	s_sub_i32 s15, s2, s3
	s_add_i32 s3, s6, s10
	v_lshl_or_b32 v231, v113, 14, v230
	s_and_b32 s3, s3, -8
	v_lshl_or_b32 v1, v225, 3, v226
	s_sub_i32 s3, s6, s3
	s_mov_b32 s7, 0x21027000
	v_lshl_add_u32 v2, s15, 12, v231
	s_lshl_b32 s12, s3, 7
	s_mov_b32 s6, -1
	v_add_lshl_u32 v232, v1, s12, 1
	s_waitcnt lgkmcnt(0)
	s_and_b32 s5, s5, 0xffff
	v_add_nc_u32_e32 v1, 0x20000, v2
	s_clause 0x1
	buffer_load_b128 v[33:36], v2, s[4:7], 0 offen
	buffer_load_b128 v[37:40], v1, s[4:7], 0 offen
	v_lshl_add_u32 v3, s15, 22, v232
	v_add_nc_u32_e32 v1, 0x40000, v2
	v_add_nc_u32_e32 v2, 0x60000, v2
	s_and_b32 s9, s9, 0xffff
	s_mov_b32 s10, s6
	v_add_nc_u32_e32 v4, 0x4000, v3
	v_add_nc_u32_e32 v5, 0x8000, v3
	s_mov_b32 s11, s7
	v_add_nc_u32_e32 v6, 0xc000, v3
	s_clause 0x1
	buffer_load_b128 v[41:44], v1, s[4:7], 0 offen
	buffer_load_b128 v[45:48], v2, s[4:7], 0 offen
	s_clause 0x3
	buffer_load_b128 v[49:52], v3, s[8:11], 0 offen slc
	buffer_load_b128 v[53:56], v4, s[8:11], 0 offen slc
	buffer_load_b128 v[57:60], v5, s[8:11], 0 offen slc
	buffer_load_b128 v[61:64], v6, s[8:11], 0 offen slc
	v_add_nc_u32_e32 v1, 0x10000, v3
	v_add_nc_u32_e32 v2, 0x14000, v3
	v_add_nc_u32_e32 v4, 0x18000, v3
	v_add_nc_u32_e32 v5, 0x1c000, v3
	v_add_nc_u32_e32 v6, 0x20000, v3
	v_add_nc_u32_e32 v7, 0x24000, v3
	s_clause 0x5
	buffer_load_b128 v[65:68], v1, s[8:11], 0 offen slc
	buffer_load_b128 v[69:72], v2, s[8:11], 0 offen slc
	buffer_load_b128 v[73:76], v4, s[8:11], 0 offen slc
	buffer_load_b128 v[77:80], v5, s[8:11], 0 offen slc
	buffer_load_b128 v[81:84], v6, s[8:11], 0 offen slc
	buffer_load_b128 v[85:88], v7, s[8:11], 0 offen slc
	v_add_nc_u32_e32 v1, 0x28000, v3
	v_add_nc_u32_e32 v2, 0x2c000, v3
	v_add_nc_u32_e32 v4, 0x30000, v3
	v_add_nc_u32_e32 v5, 0x34000, v3
	v_add_nc_u32_e32 v6, 0x38000, v3
	v_add_nc_u32_e32 v3, 0x3c000, v3
	s_clause 0x5
	buffer_load_b128 v[89:92], v1, s[8:11], 0 offen slc
	buffer_load_b128 v[93:96], v2, s[8:11], 0 offen slc
	buffer_load_b128 v[97:100], v4, s[8:11], 0 offen slc
	buffer_load_b128 v[101:104], v5, s[8:11], 0 offen slc
	buffer_load_b128 v[105:108], v6, s[8:11], 0 offen slc
	buffer_load_b128 v[109:112], v3, s[8:11], 0 offen slc
	v_mov_b32_e32 v1, 0
	v_lshrrev_b32_e32 v114, 1, v0
	v_mul_u32_u24_e32 v115, 0x110, v113
	v_or_b32_e32 v116, 0x8000, v230
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_dual_mov_b32 v16, v1 :: v_dual_lshlrev_b32 v233, 8, v113
	v_dual_mov_b32 v14, v1 :: v_dual_and_b32 v227, 48, v114
	v_mov_b32_e32 v2, v1
	v_mul_u32_u24_e32 v114, 0x110, v225
	v_mov_b32_e32 v3, v1
	v_mov_b32_e32 v4, v1
	v_or_b32_e32 v117, v225, v227
	v_mov_b32_e32 v5, v1
	v_mov_b32_e32 v6, v1
	v_mov_b32_e32 v7, v1
	v_mov_b32_e32 v8, v1
	v_mov_b32_e32 v9, v1
	v_mov_b32_e32 v10, v1
	v_mov_b32_e32 v11, v1
	v_mov_b32_e32 v12, v1
	v_mov_b32_e32 v13, v1
	v_mov_b32_e32 v15, v1
	v_mov_b32_e32 v25, v1
	v_mov_b32_e32 v26, v1
	v_mov_b32_e32 v27, v1
	v_mov_b32_e32 v28, v1
	v_mov_b32_e32 v29, v1
	v_mov_b32_e32 v30, v1
	v_dual_mov_b32 v31, v1 :: v_dual_lshlrev_b32 v228, 1, v117
	v_mov_b32_e32 v32, v1
	v_dual_mov_b32 v17, v1 :: v_dual_add_nc_u32 v234, v116, v115
	v_mov_b32_e32 v18, v1
	v_mov_b32_e32 v19, v1
	v_mov_b32_e32 v20, v1
	v_mov_b32_e32 v21, v1
	v_mov_b32_e32 v22, v1
	v_mov_b32_e32 v23, v1
	v_mov_b32_e32 v24, v1
	v_or_b32_e32 v229, 0x8000, v114
	v_mad_u32_u24 v113, 0x110, v113, v116
	s_lshl_b32 s15, s15, 4
	s_mov_b32 s14, 0
	s_or_b32 s15, s15, 1
	v_or_b32_e32 v118, v230, v233
	s_waitcnt vmcnt(19)
	ds_store_b128 v113, v[33:36]
	s_waitcnt vmcnt(18)
	ds_store_b128 v113, v[37:40] offset:2176
	s_waitcnt vmcnt(17)
	ds_store_b128 v113, v[41:44] offset:4352
	s_waitcnt vmcnt(16)
	ds_store_b128 v113, v[45:48] offset:6528
	s_waitcnt vmcnt(15)
	ds_store_b128 v118, v[49:52]
	s_waitcnt vmcnt(14)
	ds_store_b128 v118, v[53:56] offset:2048
	s_waitcnt vmcnt(13)
	ds_store_b128 v118, v[57:60] offset:4096
	s_waitcnt vmcnt(12)
	ds_store_b128 v118, v[61:64] offset:6144
	s_waitcnt vmcnt(11)
	ds_store_b128 v118, v[65:68] offset:8192
	s_waitcnt vmcnt(10)
	ds_store_b128 v118, v[69:72] offset:10240
	s_waitcnt vmcnt(9)
	ds_store_b128 v118, v[73:76] offset:12288
	s_waitcnt vmcnt(8)
	ds_store_b128 v118, v[77:80] offset:14336
	s_waitcnt vmcnt(7)
	ds_store_b128 v118, v[81:84] offset:16384
	s_waitcnt vmcnt(6)
	ds_store_b128 v118, v[85:88] offset:18432
	s_waitcnt vmcnt(5)
	ds_store_b128 v118, v[89:92] offset:20480
	s_waitcnt vmcnt(4)
	ds_store_b128 v118, v[93:96] offset:22528
	s_waitcnt vmcnt(3)
	ds_store_b128 v118, v[97:100] offset:24576
	s_waitcnt vmcnt(2)
	ds_store_b128 v118, v[101:104] offset:26624
	s_waitcnt vmcnt(1)
	ds_store_b128 v118, v[105:108] offset:28672
	s_waitcnt vmcnt(0)
	ds_store_b128 v118, v[109:112] offset:30720
	s_waitcnt lgkmcnt(0)
	s_barrier
.LBB0_1:
	s_add_i32 s16, s15, s14
	ds_load_b128 v[41:44], v229
	ds_load_b128 v[45:48], v229 offset:16
	ds_load_b128 v[33:36], v229 offset:32
	ds_load_b128 v[37:40], v229 offset:48
	ds_load_b128 v[57:60], v229 offset:4352
	ds_load_b128 v[61:64], v229 offset:4368
	ds_load_u16_d16 v55, v228 offset:3072
	ds_load_u16_d16_hi v55, v228 offset:3328
	ds_load_u16_d16 v49, v228
	ds_load_u16_d16_hi v49, v228 offset:256
	ds_load_u16_d16 v50, v228 offset:512
	ds_load_u16_d16_hi v50, v228 offset:768
	ds_load_u16_d16_hi v66, v228 offset:896
	ds_load_u16_d16 v66, v228 offset:640
	ds_load_u16_d16_hi v65, v228 offset:384
	ds_load_u16_d16 v65, v228 offset:128
	ds_load_u16_d16 v51, v228 offset:1024
	ds_load_u16_d16_hi v51, v228 offset:1280
	ds_load_u16_d16 v52, v228 offset:1536
	ds_load_u16_d16_hi v52, v228 offset:1792
	ds_load_u16_d16_hi v68, v228 offset:1920
	ds_load_u16_d16 v68, v228 offset:1664
	ds_load_u16_d16_hi v67, v228 offset:1408
	ds_load_u16_d16 v67, v228 offset:1152
	ds_load_u16_d16 v53, v228 offset:2048
	ds_load_u16_d16_hi v53, v228 offset:2304
	ds_load_u16_d16 v54, v228 offset:2560
	ds_load_u16_d16_hi v54, v228 offset:2816
	ds_load_u16_d16_hi v70, v228 offset:2944
	ds_load_u16_d16 v70, v228 offset:2688
	ds_load_u16_d16_hi v69, v228 offset:2432
	ds_load_u16_d16 v69, v228 offset:2176
	v_lshl_add_u32 v56, s16, 8, v231
	v_lshl_add_u32 v71, s16, 18, v232
	s_add_i32 s14, s14, 1
	v_add_nc_u32_e32 v251, v230, v233
	s_cmp_lg_u32 s14, 15
	v_add_nc_u32_e32 v72, 0x20000, v56
	v_add_nc_u32_e32 v73, 0x40000, v56
	v_add_nc_u32_e32 v74, 0x60000, v56
	v_add_nc_u32_e32 v75, 0x4000, v71
	buffer_load_b128 v[145:148], v71, s[8:11], 0 offen slc
	v_add_nc_u32_e32 v76, 0x8000, v71
	v_add_nc_u32_e32 v77, 0xc000, v71
	v_add_nc_u32_e32 v78, 0x10000, v71
	v_add_nc_u32_e32 v79, 0x14000, v71
	v_add_nc_u32_e32 v80, 0x18000, v71
	v_add_nc_u32_e32 v81, 0x1c000, v71
	v_add_nc_u32_e32 v82, 0x20000, v71
	v_add_nc_u32_e32 v83, 0x24000, v71
	v_add_nc_u32_e32 v84, 0x28000, v71
	v_add_nc_u32_e32 v85, 0x2c000, v71
	v_add_nc_u32_e32 v86, 0x30000, v71
	v_add_nc_u32_e32 v87, 0x34000, v71
	v_add_nc_u32_e32 v88, 0x38000, v71
	v_add_nc_u32_e32 v71, 0x3c000, v71
	s_clause 0x3
	buffer_load_b128 v[209:212], v56, s[4:7], 0 offen
	buffer_load_b128 v[213:216], v72, s[4:7], 0 offen
	buffer_load_b128 v[217:220], v73, s[4:7], 0 offen
	buffer_load_b128 v[221:224], v74, s[4:7], 0 offen
	s_clause 0xe
	buffer_load_b128 v[149:152], v75, s[8:11], 0 offen slc
	buffer_load_b128 v[153:156], v76, s[8:11], 0 offen slc
	buffer_load_b128 v[157:160], v77, s[8:11], 0 offen slc
	buffer_load_b128 v[161:164], v78, s[8:11], 0 offen slc
	buffer_load_b128 v[165:168], v79, s[8:11], 0 offen slc
	buffer_load_b128 v[169:172], v80, s[8:11], 0 offen slc
	buffer_load_b128 v[173:176], v81, s[8:11], 0 offen slc
	buffer_load_b128 v[177:180], v82, s[8:11], 0 offen slc
	buffer_load_b128 v[181:184], v83, s[8:11], 0 offen slc
	buffer_load_b128 v[185:188], v84, s[8:11], 0 offen slc
	buffer_load_b128 v[189:192], v85, s[8:11], 0 offen slc
	buffer_load_b128 v[193:196], v86, s[8:11], 0 offen slc
	buffer_load_b128 v[197:200], v87, s[8:11], 0 offen slc
	buffer_load_b128 v[201:204], v88, s[8:11], 0 offen slc
	buffer_load_b128 v[205:208], v71, s[8:11], 0 offen slc
	ds_load_u16_d16 v56, v228 offset:3584
	ds_load_u16_d16_hi v56, v228 offset:3840
	ds_load_u16_d16_hi v72, v228 offset:3968
	ds_load_u16_d16 v72, v228 offset:3712
	ds_load_u16_d16_hi v71, v228 offset:3456
	ds_load_u16_d16 v71, v228 offset:3200
	ds_load_b128 v[97:100], v229 offset:4384
	ds_load_b128 v[101:104], v229 offset:4400
	ds_load_u16_d16 v113, v228 offset:4096
	ds_load_u16_d16_hi v113, v228 offset:4352
	ds_load_u16_d16 v114, v228 offset:4608
	ds_load_u16_d16_hi v114, v228 offset:4864
	ds_load_u16_d16_hi v236, v228 offset:4992
	ds_load_u16_d16 v236, v228 offset:4736
	ds_load_u16_d16_hi v235, v228 offset:4480
	ds_load_u16_d16 v235, v228 offset:4224
	ds_load_u16_d16 v115, v228 offset:5120
	ds_load_u16_d16_hi v115, v228 offset:5376
	ds_load_u16_d16 v116, v228 offset:5632
	ds_load_u16_d16_hi v116, v228 offset:5888
	ds_load_u16_d16_hi v238, v228 offset:6016
	ds_load_u16_d16 v238, v228 offset:5760
	ds_load_u16_d16_hi v237, v228 offset:5504
	ds_load_u16_d16 v237, v228 offset:5248
	ds_load_u16_d16 v117, v228 offset:6144
	ds_load_u16_d16_hi v117, v228 offset:6400
	ds_load_u16_d16 v118, v228 offset:6656
	ds_load_u16_d16_hi v118, v228 offset:6912
	ds_load_u16_d16_hi v240, v228 offset:7040
	ds_load_u16_d16 v240, v228 offset:6784
	ds_load_u16_d16_hi v239, v228 offset:6528
	ds_load_u16_d16 v239, v228 offset:6272
	ds_load_u16_d16 v119, v228 offset:7168
	ds_load_u16_d16_hi v119, v228 offset:7424
	ds_load_u16_d16 v120, v228 offset:7680
	ds_load_u16_d16_hi v120, v228 offset:7936
	ds_load_u16_d16_hi v242, v228 offset:8064
	ds_load_u16_d16 v242, v228 offset:7808
	ds_load_u16_d16_hi v241, v228 offset:7552
	ds_load_u16_d16 v241, v228 offset:7296
	ds_load_b128 v[243:246], v229 offset:64
	ds_load_b128 v[247:250], v229 offset:80
	ds_load_b128 v[81:84], v229 offset:4416
	ds_load_b128 v[85:88], v229 offset:4432
	ds_load_u16_d16 v105, v228 offset:8192
	ds_load_u16_d16_hi v105, v228 offset:8448
	ds_load_u16_d16 v106, v228 offset:8704
	ds_load_u16_d16_hi v106, v228 offset:8960
	ds_load_u16_d16_hi v130, v228 offset:9088
	ds_load_u16_d16 v130, v228 offset:8832
	ds_load_u16_d16_hi v129, v228 offset:8576
	ds_load_u16_d16 v129, v228 offset:8320
	ds_load_u16_d16 v107, v228 offset:9216
	ds_load_u16_d16_hi v107, v228 offset:9472
	ds_load_u16_d16 v108, v228 offset:9728
	ds_load_u16_d16_hi v108, v228 offset:9984
	ds_load_u16_d16_hi v132, v228 offset:10112
	ds_load_u16_d16 v132, v228 offset:9856
	ds_load_u16_d16_hi v131, v228 offset:9600
	ds_load_u16_d16 v131, v228 offset:9344
	ds_load_u16_d16 v109, v228 offset:10240
	ds_load_u16_d16_hi v109, v228 offset:10496
	ds_load_u16_d16 v110, v228 offset:10752
	ds_load_u16_d16_hi v110, v228 offset:11008
	ds_load_u16_d16_hi v134, v228 offset:11136
	ds_load_u16_d16 v134, v228 offset:10880
	ds_load_u16_d16_hi v133, v228 offset:10624
	ds_load_u16_d16 v133, v228 offset:10368
	ds_load_u16_d16 v111, v228 offset:11264
	ds_load_u16_d16_hi v111, v228 offset:11520
	ds_load_u16_d16 v112, v228 offset:11776
	ds_load_u16_d16_hi v112, v228 offset:12032
	ds_load_u16_d16_hi v136, v228 offset:12160
	ds_load_u16_d16 v136, v228 offset:11904
	ds_load_u16_d16_hi v135, v228 offset:11648
	ds_load_u16_d16 v135, v228 offset:11392
	ds_load_b128 v[137:140], v229 offset:96
	ds_load_b128 v[141:144], v229 offset:112
	ds_load_b128 v[73:76], v229 offset:4448
	ds_load_b128 v[77:80], v229 offset:4464
	ds_load_u16_d16 v89, v228 offset:12288
	ds_load_u16_d16_hi v89, v228 offset:12544
	ds_load_u16_d16 v90, v228 offset:12800
	ds_load_u16_d16_hi v90, v228 offset:13056
	ds_load_u16_d16_hi v122, v228 offset:13184
	ds_load_u16_d16 v122, v228 offset:12928
	ds_load_u16_d16_hi v121, v228 offset:12672
	ds_load_u16_d16 v121, v228 offset:12416
	ds_load_u16_d16 v91, v228 offset:13312
	ds_load_u16_d16_hi v91, v228 offset:13568
	ds_load_u16_d16 v92, v228 offset:13824
	ds_load_u16_d16_hi v92, v228 offset:14080
	ds_load_u16_d16_hi v124, v228 offset:14208
	ds_load_u16_d16 v124, v228 offset:13952
	ds_load_u16_d16_hi v123, v228 offset:13696
	ds_load_u16_d16 v123, v228 offset:13440
	ds_load_u16_d16 v93, v228 offset:14336
	ds_load_u16_d16_hi v93, v228 offset:14592
	ds_load_u16_d16 v94, v228 offset:14848
	ds_load_u16_d16_hi v94, v228 offset:15104
	ds_load_u16_d16_hi v126, v228 offset:15232
	ds_load_u16_d16 v126, v228 offset:14976
	ds_load_u16_d16_hi v125, v228 offset:14720
	ds_load_u16_d16 v125, v228 offset:14464
	ds_load_u16_d16 v95, v228 offset:15360
	ds_load_u16_d16_hi v95, v228 offset:15616
	ds_load_u16_d16 v96, v228 offset:15872
	ds_load_u16_d16_hi v96, v228 offset:16128
	ds_load_u16_d16_hi v128, v228 offset:16256
	ds_load_u16_d16 v128, v228 offset:16000
	ds_load_u16_d16_hi v127, v228 offset:15744
	ds_load_u16_d16 v127, v228 offset:15488
	s_waitcnt lgkmcnt(62)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[41:48], v[65:72], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[57:64], v[49:56], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[57:64], v[65:72], v[17:24]
	ds_load_u16_d16 v57, v228 offset:16384
	ds_load_u16_d16_hi v57, v228 offset:16640
	ds_load_u16_d16 v58, v228 offset:16896
	ds_load_u16_d16_hi v58, v228 offset:17152
	ds_load_u16_d16_hi v66, v228 offset:17280
	ds_load_u16_d16 v66, v228 offset:17024
	ds_load_u16_d16_hi v65, v228 offset:16768
	ds_load_u16_d16 v65, v228 offset:16512
	ds_load_u16_d16 v59, v228 offset:17408
	ds_load_u16_d16_hi v59, v228 offset:17664
	ds_load_u16_d16 v60, v228 offset:17920
	ds_load_u16_d16_hi v60, v228 offset:18176
	ds_load_u16_d16_hi v68, v228 offset:18304
	ds_load_u16_d16 v68, v228 offset:18048
	ds_load_u16_d16_hi v67, v228 offset:17792
	ds_load_u16_d16 v67, v228 offset:17536
	ds_load_u16_d16 v61, v228 offset:18432
	ds_load_u16_d16_hi v61, v228 offset:18688
	ds_load_u16_d16 v62, v228 offset:18944
	ds_load_u16_d16_hi v62, v228 offset:19200
	ds_load_u16_d16_hi v70, v228 offset:19328
	ds_load_u16_d16 v70, v228 offset:19072
	ds_load_u16_d16_hi v69, v228 offset:18816
	ds_load_u16_d16 v69, v228 offset:18560
	ds_load_u16_d16 v63, v228 offset:19456
	ds_load_u16_d16_hi v63, v228 offset:19712
	ds_load_u16_d16 v64, v228 offset:19968
	ds_load_u16_d16_hi v64, v228 offset:20224
	ds_load_u16_d16_hi v72, v228 offset:20352
	ds_load_u16_d16 v72, v228 offset:20096
	ds_load_u16_d16_hi v71, v228 offset:19840
	ds_load_u16_d16 v71, v228 offset:19584
	v_wmma_f32_16x16x16_bf16 v[1:8], v[41:48], v[49:56], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[33:40], v[235:242], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[97:104], v[113:120], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[97:104], v[235:242], v[17:24]
	ds_load_u16_d16 v97, v228 offset:20480
	ds_load_u16_d16_hi v97, v228 offset:20736
	ds_load_u16_d16 v98, v228 offset:20992
	ds_load_u16_d16_hi v98, v228 offset:21248
	ds_load_u16_d16_hi v236, v228 offset:21376
	ds_load_u16_d16 v236, v228 offset:21120
	ds_load_u16_d16_hi v235, v228 offset:20864
	ds_load_u16_d16 v235, v228 offset:20608
	ds_load_u16_d16 v99, v228 offset:21504
	ds_load_u16_d16_hi v99, v228 offset:21760
	ds_load_u16_d16 v100, v228 offset:22016
	ds_load_u16_d16_hi v100, v228 offset:22272
	ds_load_u16_d16_hi v238, v228 offset:22400
	ds_load_u16_d16 v238, v228 offset:22144
	ds_load_u16_d16_hi v237, v228 offset:21888
	ds_load_u16_d16 v237, v228 offset:21632
	ds_load_u16_d16 v101, v228 offset:22528
	ds_load_u16_d16_hi v101, v228 offset:22784
	ds_load_u16_d16 v102, v228 offset:23040
	ds_load_u16_d16_hi v102, v228 offset:23296
	ds_load_u16_d16_hi v240, v228 offset:23424
	ds_load_u16_d16 v240, v228 offset:23168
	ds_load_u16_d16_hi v239, v228 offset:22912
	ds_load_u16_d16 v239, v228 offset:22656
	ds_load_u16_d16 v103, v228 offset:23552
	ds_load_u16_d16_hi v103, v228 offset:23808
	ds_load_u16_d16 v104, v228 offset:24064
	ds_load_u16_d16_hi v104, v228 offset:24320
	ds_load_u16_d16_hi v242, v228 offset:24448
	ds_load_u16_d16 v242, v228 offset:24192
	ds_load_u16_d16_hi v241, v228 offset:23936
	ds_load_u16_d16 v241, v228 offset:23680
	ds_load_b128 v[41:44], v229 offset:128
	ds_load_b128 v[45:48], v229 offset:144
	s_waitcnt lgkmcnt(62)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[243:250], v[129:136], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[81:88], v[105:112], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[81:88], v[129:136], v[17:24]
	ds_load_u16_d16 v81, v228 offset:24576
	ds_load_u16_d16_hi v81, v228 offset:24832
	ds_load_u16_d16 v82, v228 offset:25088
	ds_load_u16_d16_hi v82, v228 offset:25344
	ds_load_u16_d16_hi v130, v228 offset:25472
	ds_load_u16_d16 v130, v228 offset:25216
	ds_load_u16_d16_hi v129, v228 offset:24960
	ds_load_u16_d16 v129, v228 offset:24704
	ds_load_u16_d16 v83, v228 offset:25600
	ds_load_u16_d16_hi v83, v228 offset:25856
	ds_load_u16_d16 v84, v228 offset:26112
	ds_load_u16_d16_hi v84, v228 offset:26368
	ds_load_u16_d16_hi v132, v228 offset:26496
	ds_load_u16_d16 v132, v228 offset:26240
	ds_load_u16_d16_hi v131, v228 offset:25984
	ds_load_u16_d16 v131, v228 offset:25728
	ds_load_u16_d16 v85, v228 offset:26624
	ds_load_u16_d16_hi v85, v228 offset:26880
	ds_load_u16_d16 v86, v228 offset:27136
	ds_load_u16_d16_hi v86, v228 offset:27392
	ds_load_u16_d16_hi v134, v228 offset:27520
	ds_load_u16_d16 v134, v228 offset:27264
	ds_load_u16_d16_hi v133, v228 offset:27008
	ds_load_u16_d16 v133, v228 offset:26752
	ds_load_u16_d16 v87, v228 offset:27648
	ds_load_u16_d16_hi v87, v228 offset:27904
	ds_load_u16_d16 v88, v228 offset:28160
	ds_load_u16_d16_hi v88, v228 offset:28416
	ds_load_u16_d16_hi v136, v228 offset:28544
	ds_load_u16_d16 v136, v228 offset:28288
	ds_load_u16_d16_hi v135, v228 offset:28032
	ds_load_u16_d16 v135, v228 offset:27776
	ds_load_b128 v[49:52], v229 offset:4480
	ds_load_b128 v[53:56], v229 offset:4496
	v_wmma_f32_16x16x16_bf16 v[1:8], v[33:40], v[113:120], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[73:80], v[89:96], v[25:32]
	ds_load_b128 v[33:36], v229 offset:160
	ds_load_b128 v[37:40], v229 offset:176
	ds_load_b128 v[113:116], v229 offset:4512
	ds_load_b128 v[117:120], v229 offset:4528
	v_wmma_f32_16x16x16_bf16 v[9:16], v[137:144], v[121:128], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[73:80], v[121:128], v[17:24]
	ds_load_u16_d16 v73, v228 offset:28672
	ds_load_u16_d16_hi v73, v228 offset:28928
	ds_load_u16_d16 v74, v228 offset:29184
	ds_load_u16_d16_hi v74, v228 offset:29440
	ds_load_u16_d16_hi v122, v228 offset:29568
	ds_load_u16_d16 v122, v228 offset:29312
	ds_load_u16_d16_hi v121, v228 offset:29056
	ds_load_u16_d16 v121, v228 offset:28800
	ds_load_u16_d16 v75, v228 offset:29696
	ds_load_u16_d16_hi v75, v228 offset:29952
	ds_load_u16_d16 v76, v228 offset:30208
	ds_load_u16_d16_hi v76, v228 offset:30464
	ds_load_u16_d16_hi v124, v228 offset:30592
	ds_load_u16_d16 v124, v228 offset:30336
	ds_load_u16_d16_hi v123, v228 offset:30080
	ds_load_u16_d16 v123, v228 offset:29824
	ds_load_u16_d16 v77, v228 offset:30720
	ds_load_u16_d16_hi v77, v228 offset:30976
	ds_load_u16_d16 v78, v228 offset:31232
	ds_load_u16_d16_hi v78, v228 offset:31488
	ds_load_u16_d16_hi v126, v228 offset:31616
	ds_load_u16_d16 v126, v228 offset:31360
	ds_load_u16_d16_hi v125, v228 offset:31104
	ds_load_u16_d16 v125, v228 offset:30848
	ds_load_u16_d16 v79, v228 offset:31744
	ds_load_u16_d16_hi v79, v228 offset:32000
	ds_load_u16_d16 v80, v228 offset:32256
	ds_load_u16_d16_hi v80, v228 offset:32512
	ds_load_u16_d16_hi v128, v228 offset:32640
	ds_load_u16_d16 v128, v228 offset:32384
	ds_load_u16_d16_hi v127, v228 offset:32128
	ds_load_u16_d16 v127, v228 offset:31872
	v_wmma_f32_16x16x16_bf16 v[1:8], v[243:250], v[105:112], v[1:8]
	ds_load_b128 v[243:246], v229 offset:192
	ds_load_b128 v[247:250], v229 offset:208
	ds_load_b128 v[105:108], v229 offset:4544
	ds_load_b128 v[109:112], v229 offset:4560
	v_wmma_f32_16x16x16_bf16 v[1:8], v[137:144], v[89:96], v[1:8]
	ds_load_b128 v[137:140], v229 offset:224
	ds_load_b128 v[141:144], v229 offset:240
	ds_load_b128 v[89:92], v229 offset:4576
	ds_load_b128 v[93:96], v229 offset:4592
	s_waitcnt lgkmcnt(62)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[41:48], v[65:72], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[41:48], v[57:64], v[1:8]
	s_waitcnt lgkmcnt(44)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[49:56], v[57:64], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[49:56], v[65:72], v[17:24]
	s_waitcnt lgkmcnt(42)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[33:40], v[97:104], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[33:40], v[235:242], v[9:16]
	s_waitcnt lgkmcnt(40)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[113:120], v[97:104], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[113:120], v[235:242], v[17:24]
	s_waitcnt lgkmcnt(6)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[243:250], v[81:88], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[243:250], v[129:136], v[9:16]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[105:112], v[81:88], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[105:112], v[129:136], v[17:24]
	s_waitcnt lgkmcnt(2)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[137:144], v[73:80], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[137:144], v[121:128], v[9:16]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[25:32], v[89:96], v[73:80], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[89:96], v[121:128], v[17:24]
	s_barrier
	s_waitcnt vmcnt(18)
	ds_store_b128 v234, v[209:212]
	s_waitcnt vmcnt(17)
	ds_store_b128 v234, v[213:216] offset:2176
	s_waitcnt vmcnt(16)
	ds_store_b128 v234, v[217:220] offset:4352
	s_waitcnt vmcnt(15)
	ds_store_b128 v234, v[221:224] offset:6528
	ds_store_b128 v251, v[145:148]
	s_waitcnt vmcnt(14)
	ds_store_b128 v251, v[149:152] offset:2048
	s_waitcnt vmcnt(13)
	ds_store_b128 v251, v[153:156] offset:4096
	s_waitcnt vmcnt(12)
	ds_store_b128 v251, v[157:160] offset:6144
	s_waitcnt vmcnt(11)
	ds_store_b128 v251, v[161:164] offset:8192
	s_waitcnt vmcnt(10)
	ds_store_b128 v251, v[165:168] offset:10240
	s_waitcnt vmcnt(9)
	ds_store_b128 v251, v[169:172] offset:12288
	s_waitcnt vmcnt(8)
	ds_store_b128 v251, v[173:176] offset:14336
	s_waitcnt vmcnt(7)
	ds_store_b128 v251, v[177:180] offset:16384
	s_waitcnt vmcnt(6)
	ds_store_b128 v251, v[181:184] offset:18432
	s_waitcnt vmcnt(5)
	ds_store_b128 v251, v[185:188] offset:20480
	s_waitcnt vmcnt(4)
	ds_store_b128 v251, v[189:192] offset:22528
	s_waitcnt vmcnt(3)
	ds_store_b128 v251, v[193:196] offset:24576
	s_waitcnt vmcnt(2)
	ds_store_b128 v251, v[197:200] offset:26624
	s_waitcnt vmcnt(1)
	ds_store_b128 v251, v[201:204] offset:28672
	s_waitcnt vmcnt(0)
	ds_store_b128 v251, v[205:208] offset:30720
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_cbranch_scc1 .LBB0_1
	ds_load_b128 v[57:60], v229
	ds_load_b128 v[61:64], v229 offset:16
	ds_load_u16_d16 v65, v228
	ds_load_u16_d16_hi v65, v228 offset:256
	ds_load_u16_d16 v66, v228 offset:512
	ds_load_u16_d16_hi v66, v228 offset:768
	ds_load_u16_d16_hi v34, v228 offset:896
	ds_load_u16_d16 v34, v228 offset:640
	ds_load_u16_d16_hi v33, v228 offset:384
	ds_load_u16_d16 v33, v228 offset:128
	ds_load_u16_d16 v67, v228 offset:1024
	ds_load_u16_d16_hi v67, v228 offset:1280
	ds_load_u16_d16 v68, v228 offset:1536
	ds_load_u16_d16_hi v68, v228 offset:1792
	ds_load_u16_d16_hi v36, v228 offset:1920
	ds_load_u16_d16 v36, v228 offset:1664
	ds_load_u16_d16_hi v35, v228 offset:1408
	ds_load_u16_d16 v35, v228 offset:1152
	ds_load_u16_d16 v69, v228 offset:2048
	ds_load_u16_d16_hi v69, v228 offset:2304
	ds_load_u16_d16 v70, v228 offset:2560
	ds_load_u16_d16_hi v70, v228 offset:2816
	ds_load_u16_d16_hi v38, v228 offset:2944
	ds_load_u16_d16 v38, v228 offset:2688
	ds_load_u16_d16_hi v37, v228 offset:2432
	ds_load_u16_d16 v37, v228 offset:2176
	ds_load_u16_d16 v71, v228 offset:3072
	ds_load_u16_d16_hi v71, v228 offset:3328
	ds_load_u16_d16 v72, v228 offset:3584
	ds_load_u16_d16_hi v72, v228 offset:3840
	ds_load_u16_d16_hi v40, v228 offset:3968
	ds_load_u16_d16 v40, v228 offset:3712
	ds_load_u16_d16_hi v39, v228 offset:3456
	ds_load_u16_d16 v39, v228 offset:3200
	ds_load_b128 v[41:44], v229 offset:4352
	ds_load_b128 v[45:48], v229 offset:4368
	ds_load_b128 v[49:52], v229 offset:32
	ds_load_b128 v[53:56], v229 offset:48
	s_lshr_b32 s8, s13, 27
	s_clause 0x1
	s_load_b64 s[4:5], s[0:1], 0x48
	s_load_b64 s[6:7], s[0:1], 0x58
	s_add_i32 s8, s2, s8
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)
	s_and_b32 s8, s8, 0xfffe0
	s_sub_i32 s2, s2, s8
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[57:64], v[65:72], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[57:64], v[33:40], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[41:48], v[65:72], v[25:32]
	ds_load_b128 v[65:68], v229 offset:4384
	ds_load_b128 v[69:72], v229 offset:4400
	ds_load_u16_d16 v73, v228 offset:4096
	ds_load_u16_d16_hi v73, v228 offset:4352
	ds_load_u16_d16 v74, v228 offset:4608
	ds_load_u16_d16_hi v74, v228 offset:4864
	ds_load_u16_d16_hi v82, v228 offset:4992
	ds_load_u16_d16 v82, v228 offset:4736
	ds_load_u16_d16_hi v81, v228 offset:4480
	ds_load_u16_d16 v81, v228 offset:4224
	ds_load_u16_d16 v75, v228 offset:5120
	ds_load_u16_d16_hi v75, v228 offset:5376
	ds_load_u16_d16 v76, v228 offset:5632
	ds_load_u16_d16_hi v76, v228 offset:5888
	ds_load_u16_d16_hi v84, v228 offset:6016
	ds_load_u16_d16 v84, v228 offset:5760
	ds_load_u16_d16_hi v83, v228 offset:5504
	ds_load_u16_d16 v83, v228 offset:5248
	ds_load_u16_d16 v77, v228 offset:6144
	ds_load_u16_d16_hi v77, v228 offset:6400
	ds_load_u16_d16 v78, v228 offset:6656
	ds_load_u16_d16_hi v78, v228 offset:6912
	ds_load_u16_d16_hi v86, v228 offset:7040
	ds_load_u16_d16 v86, v228 offset:6784
	ds_load_u16_d16_hi v85, v228 offset:6528
	ds_load_u16_d16 v85, v228 offset:6272
	ds_load_u16_d16 v79, v228 offset:7168
	ds_load_u16_d16_hi v79, v228 offset:7424
	ds_load_u16_d16 v80, v228 offset:7680
	ds_load_u16_d16_hi v80, v228 offset:7936
	ds_load_u16_d16_hi v88, v228 offset:8064
	ds_load_u16_d16 v88, v228 offset:7808
	ds_load_u16_d16_hi v87, v228 offset:7552
	ds_load_u16_d16 v87, v228 offset:7296
	ds_load_b128 v[89:92], v229 offset:64
	ds_load_b128 v[93:96], v229 offset:80
	ds_load_b128 v[97:100], v229 offset:4416
	ds_load_b128 v[101:104], v229 offset:4432
	ds_load_u16_d16 v105, v228 offset:8192
	ds_load_u16_d16_hi v105, v228 offset:8448
	ds_load_u16_d16 v106, v228 offset:8704
	ds_load_u16_d16_hi v106, v228 offset:8960
	ds_load_u16_d16_hi v114, v228 offset:9088
	ds_load_u16_d16 v114, v228 offset:8832
	ds_load_u16_d16_hi v113, v228 offset:8576
	ds_load_u16_d16 v113, v228 offset:8320
	ds_load_u16_d16 v107, v228 offset:9216
	ds_load_u16_d16_hi v107, v228 offset:9472
	ds_load_u16_d16 v108, v228 offset:9728
	ds_load_u16_d16_hi v108, v228 offset:9984
	ds_load_u16_d16_hi v116, v228 offset:10112
	ds_load_u16_d16 v116, v228 offset:9856
	ds_load_u16_d16_hi v115, v228 offset:9600
	ds_load_u16_d16 v115, v228 offset:9344
	ds_load_u16_d16 v109, v228 offset:10240
	ds_load_u16_d16_hi v109, v228 offset:10496
	ds_load_u16_d16 v110, v228 offset:10752
	ds_load_u16_d16_hi v110, v228 offset:11008
	ds_load_u16_d16_hi v118, v228 offset:11136
	ds_load_u16_d16 v118, v228 offset:10880
	ds_load_u16_d16_hi v117, v228 offset:10624
	ds_load_u16_d16 v117, v228 offset:10368
	ds_load_u16_d16 v111, v228 offset:11264
	ds_load_u16_d16_hi v111, v228 offset:11520
	ds_load_u16_d16 v112, v228 offset:11776
	ds_load_u16_d16_hi v112, v228 offset:12032
	ds_load_u16_d16_hi v120, v228 offset:12160
	ds_load_u16_d16 v120, v228 offset:11904
	ds_load_u16_d16_hi v119, v228 offset:11648
	ds_load_u16_d16 v119, v228 offset:11392
	ds_load_b128 v[121:124], v229 offset:96
	ds_load_b128 v[125:128], v229 offset:112
	ds_load_b128 v[129:132], v229 offset:4448
	ds_load_b128 v[133:136], v229 offset:4464
	ds_load_u16_d16 v137, v228 offset:12288
	ds_load_u16_d16_hi v137, v228 offset:12544
	ds_load_u16_d16 v138, v228 offset:12800
	ds_load_u16_d16_hi v138, v228 offset:13056
	ds_load_u16_d16_hi v146, v228 offset:13184
	ds_load_u16_d16 v146, v228 offset:12928
	ds_load_u16_d16_hi v145, v228 offset:12672
	ds_load_u16_d16 v145, v228 offset:12416
	ds_load_u16_d16 v139, v228 offset:13312
	ds_load_u16_d16_hi v139, v228 offset:13568
	ds_load_u16_d16 v140, v228 offset:13824
	ds_load_u16_d16_hi v140, v228 offset:14080
	ds_load_u16_d16_hi v148, v228 offset:14208
	ds_load_u16_d16 v148, v228 offset:13952
	ds_load_u16_d16_hi v147, v228 offset:13696
	ds_load_u16_d16 v147, v228 offset:13440
	ds_load_u16_d16 v141, v228 offset:14336
	ds_load_u16_d16_hi v141, v228 offset:14592
	ds_load_u16_d16 v142, v228 offset:14848
	ds_load_u16_d16_hi v142, v228 offset:15104
	ds_load_u16_d16_hi v150, v228 offset:15232
	ds_load_u16_d16 v150, v228 offset:14976
	ds_load_u16_d16_hi v149, v228 offset:14720
	ds_load_u16_d16 v149, v228 offset:14464
	ds_load_u16_d16 v143, v228 offset:15360
	ds_load_u16_d16_hi v143, v228 offset:15616
	ds_load_u16_d16 v144, v228 offset:15872
	ds_load_u16_d16_hi v144, v228 offset:16128
	ds_load_u16_d16_hi v152, v228 offset:16256
	ds_load_u16_d16 v152, v228 offset:16000
	ds_load_u16_d16_hi v151, v228 offset:15744
	ds_load_u16_d16 v151, v228 offset:15488
	ds_load_b128 v[153:156], v229 offset:128
	ds_load_b128 v[157:160], v229 offset:144
	ds_load_u16_d16 v161, v228 offset:16384
	ds_load_u16_d16_hi v161, v228 offset:16640
	ds_load_u16_d16 v162, v228 offset:16896
	ds_load_u16_d16_hi v162, v228 offset:17152
	ds_load_u16_d16_hi v58, v228 offset:17280
	ds_load_u16_d16 v58, v228 offset:17024
	ds_load_u16_d16_hi v57, v228 offset:16768
	ds_load_u16_d16 v57, v228 offset:16512
	ds_load_u16_d16 v163, v228 offset:17408
	ds_load_u16_d16_hi v163, v228 offset:17664
	ds_load_u16_d16 v164, v228 offset:17920
	ds_load_u16_d16_hi v164, v228 offset:18176
	ds_load_u16_d16_hi v60, v228 offset:18304
	ds_load_u16_d16 v60, v228 offset:18048
	ds_load_u16_d16_hi v59, v228 offset:17792
	ds_load_u16_d16 v59, v228 offset:17536
	ds_load_u16_d16 v165, v228 offset:18432
	ds_load_u16_d16_hi v165, v228 offset:18688
	ds_load_u16_d16 v166, v228 offset:18944
	ds_load_u16_d16_hi v166, v228 offset:19200
	ds_load_u16_d16_hi v62, v228 offset:19328
	ds_load_u16_d16 v62, v228 offset:19072
	ds_load_u16_d16_hi v61, v228 offset:18816
	ds_load_u16_d16 v61, v228 offset:18560
	ds_load_u16_d16 v167, v228 offset:19456
	ds_load_u16_d16_hi v167, v228 offset:19712
	ds_load_u16_d16 v168, v228 offset:19968
	ds_load_u16_d16_hi v168, v228 offset:20224
	ds_load_u16_d16_hi v64, v228 offset:20352
	ds_load_u16_d16 v64, v228 offset:20096
	ds_load_u16_d16_hi v63, v228 offset:19840
	ds_load_u16_d16 v63, v228 offset:19584
	ds_load_b128 v[169:172], v229 offset:4480
	ds_load_b128 v[173:176], v229 offset:4496
	v_wmma_f32_16x16x16_bf16 v[17:24], v[41:48], v[33:40], v[17:24]
	s_waitcnt lgkmcnt(62)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[49:56], v[73:80], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[49:56], v[81:88], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[65:72], v[73:80], v[25:32]
	v_lshlrev_b32_e32 v33, 5, v0
	v_wmma_f32_16x16x16_bf16 v[17:24], v[65:72], v[81:88], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[1:8], v[89:96], v[105:112], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[89:96], v[113:120], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[97:104], v[105:112], v[25:32]
	s_delay_alu instid0(VALU_DEP_4)
	v_wmma_f32_16x16x16_bf16 v[17:24], v[97:104], v[113:120], v[17:24]
	s_waitcnt lgkmcnt(40)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[121:128], v[137:144], v[1:8]
	s_waitcnt lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[121:128], v[145:152], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[129:136], v[137:144], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[129:136], v[145:152], v[17:24]
	ds_load_b128 v[34:37], v229 offset:160
	ds_load_b128 v[38:41], v229 offset:176
	ds_load_b128 v[42:45], v229 offset:4512
	ds_load_b128 v[46:49], v229 offset:4528
	ds_load_u16_d16 v65, v228 offset:20480
	ds_load_u16_d16_hi v65, v228 offset:20736
	ds_load_u16_d16 v66, v228 offset:20992
	ds_load_u16_d16_hi v66, v228 offset:21248
	ds_load_u16_d16_hi v74, v228 offset:21376
	ds_load_u16_d16 v74, v228 offset:21120
	ds_load_u16_d16_hi v73, v228 offset:20864
	ds_load_u16_d16 v73, v228 offset:20608
	ds_load_u16_d16 v67, v228 offset:21504
	ds_load_u16_d16_hi v67, v228 offset:21760
	ds_load_u16_d16 v68, v228 offset:22016
	ds_load_u16_d16_hi v68, v228 offset:22272
	ds_load_u16_d16_hi v76, v228 offset:22400
	ds_load_u16_d16 v76, v228 offset:22144
	ds_load_u16_d16_hi v75, v228 offset:21888
	ds_load_u16_d16 v75, v228 offset:21632
	ds_load_u16_d16 v69, v228 offset:22528
	ds_load_u16_d16_hi v69, v228 offset:22784
	ds_load_u16_d16 v70, v228 offset:23040
	ds_load_u16_d16_hi v70, v228 offset:23296
	ds_load_u16_d16_hi v78, v228 offset:23424
	ds_load_u16_d16 v78, v228 offset:23168
	ds_load_u16_d16_hi v77, v228 offset:22912
	ds_load_u16_d16 v77, v228 offset:22656
	ds_load_u16_d16 v71, v228 offset:23552
	ds_load_u16_d16_hi v71, v228 offset:23808
	ds_load_u16_d16 v72, v228 offset:24064
	ds_load_u16_d16_hi v72, v228 offset:24320
	ds_load_u16_d16_hi v80, v228 offset:24448
	ds_load_u16_d16 v80, v228 offset:24192
	ds_load_u16_d16_hi v79, v228 offset:23936
	ds_load_u16_d16 v79, v228 offset:23680
	ds_load_b128 v[81:84], v229 offset:192
	ds_load_b128 v[85:88], v229 offset:208
	ds_load_b128 v[89:92], v229 offset:4544
	ds_load_b128 v[93:96], v229 offset:4560
	ds_load_u16_d16 v97, v228 offset:24576
	ds_load_u16_d16_hi v97, v228 offset:24832
	ds_load_u16_d16 v98, v228 offset:25088
	ds_load_u16_d16_hi v98, v228 offset:25344
	ds_load_u16_d16_hi v106, v228 offset:25472
	ds_load_u16_d16 v106, v228 offset:25216
	ds_load_u16_d16_hi v105, v228 offset:24960
	ds_load_u16_d16 v105, v228 offset:24704
	ds_load_u16_d16 v99, v228 offset:25600
	ds_load_u16_d16_hi v99, v228 offset:25856
	ds_load_u16_d16 v100, v228 offset:26112
	ds_load_u16_d16_hi v100, v228 offset:26368
	ds_load_u16_d16_hi v108, v228 offset:26496
	ds_load_u16_d16 v108, v228 offset:26240
	ds_load_u16_d16_hi v107, v228 offset:25984
	ds_load_u16_d16 v107, v228 offset:25728
	ds_load_u16_d16 v101, v228 offset:26624
	ds_load_u16_d16_hi v101, v228 offset:26880
	ds_load_u16_d16 v102, v228 offset:27136
	ds_load_u16_d16_hi v102, v228 offset:27392
	ds_load_u16_d16_hi v110, v228 offset:27520
	ds_load_u16_d16 v110, v228 offset:27264
	ds_load_u16_d16_hi v109, v228 offset:27008
	ds_load_u16_d16 v109, v228 offset:26752
	ds_load_u16_d16 v103, v228 offset:27648
	ds_load_u16_d16_hi v103, v228 offset:27904
	ds_load_u16_d16 v104, v228 offset:28160
	ds_load_u16_d16_hi v104, v228 offset:28416
	ds_load_u16_d16_hi v112, v228 offset:28544
	ds_load_u16_d16 v112, v228 offset:28288
	ds_load_u16_d16_hi v111, v228 offset:28032
	ds_load_u16_d16 v111, v228 offset:27776
	ds_load_b128 v[113:116], v229 offset:224
	ds_load_b128 v[117:120], v229 offset:240
	ds_load_b128 v[121:124], v229 offset:4576
	ds_load_b128 v[125:128], v229 offset:4592
	ds_load_u16_d16 v129, v228 offset:28672
	ds_load_u16_d16_hi v129, v228 offset:28928
	ds_load_u16_d16 v130, v228 offset:29184
	ds_load_u16_d16_hi v130, v228 offset:29440
	ds_load_u16_d16_hi v138, v228 offset:29568
	ds_load_u16_d16 v138, v228 offset:29312
	ds_load_u16_d16_hi v137, v228 offset:29056
	ds_load_u16_d16 v137, v228 offset:28800
	ds_load_u16_d16 v131, v228 offset:29696
	ds_load_u16_d16_hi v131, v228 offset:29952
	ds_load_u16_d16 v132, v228 offset:30208
	ds_load_u16_d16_hi v132, v228 offset:30464
	ds_load_u16_d16_hi v140, v228 offset:30592
	ds_load_u16_d16 v140, v228 offset:30336
	ds_load_u16_d16_hi v139, v228 offset:30080
	ds_load_u16_d16 v139, v228 offset:29824
	ds_load_u16_d16 v133, v228 offset:30720
	ds_load_u16_d16_hi v133, v228 offset:30976
	ds_load_u16_d16 v134, v228 offset:31232
	ds_load_u16_d16_hi v134, v228 offset:31488
	ds_load_u16_d16_hi v142, v228 offset:31616
	ds_load_u16_d16 v142, v228 offset:31360
	ds_load_u16_d16_hi v141, v228 offset:31104
	ds_load_u16_d16 v141, v228 offset:30848
	ds_load_u16_d16 v135, v228 offset:31744
	ds_load_u16_d16_hi v135, v228 offset:32000
	ds_load_u16_d16 v136, v228 offset:32256
	ds_load_u16_d16_hi v136, v228 offset:32512
	ds_load_u16_d16_hi v144, v228 offset:32640
	ds_load_u16_d16 v144, v228 offset:32384
	ds_load_u16_d16_hi v143, v228 offset:32128
	ds_load_u16_d16 v143, v228 offset:31872
	s_waitcnt lgkmcnt(62)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[153:160], v[161:168], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[153:160], v[57:64], v[9:16]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[169:176], v[161:168], v[25:32]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[169:176], v[57:64], v[17:24]
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[34:41], v[65:72], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[9:16], v[34:41], v[73:80], v[9:16]
	v_lshl_or_b32 v34, s2, 12, v33
	v_or_b32_e32 v36, s12, v0
	v_wmma_f32_16x16x16_bf16 v[25:32], v[42:49], v[65:72], v[25:32]
	s_waitcnt lgkmcnt(40)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[81:88], v[97:104], v[1:8]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[42:49], v[73:80], v[17:24]
	v_ashrrev_i32_e32 v35, 31, v34
	v_ashrrev_i32_e32 v37, 31, v36
	v_wmma_f32_16x16x16_bf16 v[25:32], v[89:96], v[97:104], v[25:32]
	s_waitcnt lgkmcnt(36)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[81:88], v[105:112], v[9:16]
	s_waitcnt lgkmcnt(4)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[113:120], v[129:136], v[1:8]
	v_lshlrev_b64 v[34:35], 2, v[34:35]
	v_lshlrev_b64 v[36:37], 2, v[36:37]
	v_wmma_f32_16x16x16_bf16 v[17:24], v[89:96], v[105:112], v[17:24]
	v_wmma_f32_16x16x16_bf16 v[25:32], v[121:128], v[129:136], v[25:32]
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[113:120], v[137:144], v[9:16]
	s_mov_b32 s2, exec_lo
	v_add_co_u32 v34, vcc_lo, s4, v34
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v35, null, s5, v35, vcc_lo
	v_add_co_u32 v0, vcc_lo, s6, v36
	v_wmma_f32_16x16x16_bf16 v[17:24], v[121:128], v[137:144], v[17:24]
	s_barrier
	s_clause 0x3
	global_store_b128 v[34:35], v[5:8], off offset:16
	global_store_b128 v[34:35], v[1:4], off
	global_store_b128 v[34:35], v[29:32], off offset:80
	global_store_b128 v[34:35], v[25:28], off offset:64
	v_add_co_ci_u32_e64 v1, null, s7, v37, vcc_lo
	v_mov_b32_e32 v2, 1
	s_clause 0x3
	global_store_b128 v[34:35], v[13:16], off offset:48
	global_store_b128 v[34:35], v[9:12], off offset:32
	global_store_b128 v[34:35], v[21:24], off offset:112
	global_store_b128 v[34:35], v[17:20], off offset:96
	s_waitcnt_vscnt null, 0x0
	global_atomic_add_u32 v2, v[0:1], v2, off glc
	s_waitcnt vmcnt(0)
	buffer_gl1_inv
	buffer_gl0_inv
	v_cmpx_eq_u32_e32 3, v2
	s_cbranch_execz .LBB0_4
	v_lshl_or_b32 v2, s3, 14, v33
	s_load_b64 s[0:1], s[0:1], 0x30
	s_mov_b32 s3, 0x21027000
	s_mov_b32 s2, -1
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v3, 31, v2
	v_lshlrev_b64 v[2:3], 2, v[2:3]
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v106, vcc_lo, s4, v2
	v_add_co_ci_u32_e64 v107, null, s5, v3, vcc_lo
	s_clause 0x6
	global_load_b128 v[2:5], v[106:107], off
	global_load_b128 v[6:9], v[106:107], off offset:16
	global_load_b128 v[10:13], v[106:107], off offset:64
	global_load_b128 v[14:17], v[106:107], off offset:80
	global_load_b128 v[18:21], v[106:107], off offset:32
	global_load_b128 v[22:25], v[106:107], off offset:48
	global_load_b128 v[26:29], v[106:107], off offset:96
	v_add_co_u32 v54, vcc_lo, 0x4000, v106
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)
	v_add_co_ci_u32_e64 v55, null, 0, v107, vcc_lo
	v_add_co_u32 v62, vcc_lo, 0x4040, v106
	v_add_co_ci_u32_e64 v63, null, 0, v107, vcc_lo
	v_add_co_u32 v86, vcc_lo, 0x8000, v106
	s_clause 0x2
	global_load_b128 v[30:33], v[106:107], off offset:112
	global_load_b128 v[34:37], v[54:55], off
	global_load_b128 v[38:41], v[54:55], off offset:16
	v_add_co_ci_u32_e64 v87, null, 0, v107, vcc_lo
	v_add_co_u32 v94, vcc_lo, 0x8040, v106
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v95, null, 0, v107, vcc_lo
	v_add_co_u32 v118, vcc_lo, 0xc000, v106
	s_clause 0x7
	global_load_b128 v[42:45], v[54:55], off offset:64
	global_load_b128 v[46:49], v[62:63], off offset:16
	global_load_b128 v[50:53], v[54:55], off offset:32
	global_load_b128 v[54:57], v[54:55], off offset:48
	global_load_b128 v[58:61], v[62:63], off offset:32
	global_load_b128 v[62:65], v[62:63], off offset:48
	global_load_b128 v[66:69], v[86:87], off
	global_load_b128 v[70:73], v[86:87], off offset:16
	v_add_co_ci_u32_e64 v119, null, 0, v107, vcc_lo
	s_clause 0x7
	global_load_b128 v[74:77], v[86:87], off offset:64
	global_load_b128 v[78:81], v[94:95], off offset:16
	global_load_b128 v[82:85], v[86:87], off offset:32
	global_load_b128 v[86:89], v[86:87], off offset:48
	global_load_b128 v[90:93], v[94:95], off offset:32
	global_load_b128 v[94:97], v[94:95], off offset:48
	global_load_b128 v[98:101], v[118:119], off
	global_load_b128 v[102:105], v[118:119], off offset:16
	v_add_co_u32 v126, vcc_lo, 0xc040, v106
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v127, null, 0, v107, vcc_lo
	s_clause 0x5
	global_load_b128 v[106:109], v[118:119], off offset:64
	global_load_b128 v[110:113], v[126:127], off offset:16
	global_load_b128 v[114:117], v[118:119], off offset:32
	global_load_b128 v[118:121], v[118:119], off offset:48
	global_load_b128 v[122:125], v[126:127], off offset:32
	global_load_b128 v[126:129], v[126:127], off offset:48
	s_waitcnt lgkmcnt(0)
	s_and_b32 s1, s1, 0xffff
	s_waitcnt vmcnt(31)
	v_dual_add_f32 v2, 0, v2 :: v_dual_add_f32 v3, 0, v3
	v_dual_add_f32 v4, 0, v4 :: v_dual_add_f32 v5, 0, v5
	s_waitcnt vmcnt(30)
	v_dual_add_f32 v6, 0, v6 :: v_dual_add_f32 v7, 0, v7
	v_dual_add_f32 v8, 0, v8 :: v_dual_add_f32 v9, 0, v9
	s_waitcnt vmcnt(29)
	v_dual_add_f32 v10, 0, v10 :: v_dual_add_f32 v11, 0, v11
	v_dual_add_f32 v12, 0, v12 :: v_dual_add_f32 v13, 0, v13
	s_waitcnt vmcnt(28)
	v_dual_add_f32 v14, 0, v14 :: v_dual_add_f32 v15, 0, v15
	v_dual_add_f32 v16, 0, v16 :: v_dual_add_f32 v17, 0, v17
	s_waitcnt vmcnt(23)
	v_dual_add_f32 v2, v2, v34 :: v_dual_add_f32 v3, v3, v35
	v_dual_add_f32 v4, v4, v36 :: v_dual_add_f32 v5, v5, v37
	s_waitcnt vmcnt(22)
	v_dual_add_f32 v6, v6, v38 :: v_dual_add_f32 v7, v7, v39
	v_dual_add_f32 v8, v8, v40 :: v_dual_add_f32 v9, v9, v41
	s_waitcnt vmcnt(21)
	v_dual_add_f32 v10, v10, v42 :: v_dual_add_f32 v11, v11, v43
	s_waitcnt vmcnt(15)
	v_dual_add_f32 v2, v2, v66 :: v_dual_add_f32 v3, v3, v67
	v_dual_add_f32 v4, v4, v68 :: v_dual_add_f32 v5, v5, v69
	s_waitcnt vmcnt(14)
	v_dual_add_f32 v6, v6, v70 :: v_dual_add_f32 v7, v7, v71
	s_waitcnt vmcnt(7)
	v_dual_add_f32 v2, v2, v98 :: v_dual_add_f32 v3, v3, v99
	v_dual_add_f32 v4, v4, v100 :: v_dual_add_f32 v5, v5, v101
	s_waitcnt vmcnt(6)
	v_dual_add_f32 v6, v6, v102 :: v_dual_add_f32 v7, v7, v103
	s_delay_alu instid0(VALU_DEP_3)
	v_bfe_u32 v34, v2, 16, 1
	v_or_b32_e32 v35, 0x400000, v2
	v_bfe_u32 v36, v3, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_or_b32_e32 v37, 0x400000, v3
	v_add3_u32 v34, v34, v2, 0x7fff
	v_bfe_u32 v38, v4, 16, 1
	v_add3_u32 v36, v36, v3, 0x7fff
	v_or_b32_e32 v39, 0x400000, v4
	v_bfe_u32 v40, v5, 16, 1
	v_cndmask_b32_e32 v2, v34, v35, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_add3_u32 v38, v38, v4, 0x7fff
	v_dual_add_f32 v8, v8, v72 :: v_dual_add_f32 v9, v9, v73
	v_or_b32_e32 v41, 0x400000, v5
	v_cndmask_b32_e32 v3, v36, v37, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_bfe_u32 v42, v6, 16, 1
	v_add3_u32 v40, v40, v5, 0x7fff
	v_dual_add_f32 v12, v12, v44 :: v_dual_add_f32 v13, v13, v45
	v_cndmask_b32_e32 v4, v38, v39, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_dual_add_f32 v8, v8, v104 :: v_dual_add_f32 v9, v9, v105
	v_or_b32_e32 v43, 0x400000, v6
	v_bfe_u32 v44, v7, 16, 1
	v_add3_u32 v42, v42, v6, 0x7fff
	v_cndmask_b32_e32 v5, v40, v41, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_dual_add_f32 v14, v14, v46 :: v_dual_add_f32 v15, v15, v47
	v_dual_add_f32 v10, v10, v74 :: v_dual_add_f32 v11, v11, v75
	v_or_b32_e32 v45, 0x400000, v7
	v_bfe_u32 v46, v8, 16, 1
	v_add3_u32 v44, v44, v7, 0x7fff
	v_cndmask_b32_e32 v6, v42, v43, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_dual_add_f32 v18, 0, v18 :: v_dual_add_f32 v19, 0, v19
	v_dual_add_f32 v16, v16, v48 :: v_dual_add_f32 v17, v17, v49
	s_waitcnt vmcnt(5)
	v_dual_add_f32 v10, v10, v106 :: v_dual_add_f32 v11, v11, v107
	v_or_b32_e32 v47, 0x400000, v8
	v_bfe_u32 v48, v9, 16, 1
	v_add3_u32 v46, v46, v8, 0x7fff
	v_cndmask_b32_e32 v7, v44, v45, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_dual_add_f32 v20, 0, v20 :: v_dual_add_f32 v21, 0, v21
	v_dual_add_f32 v18, v18, v50 :: v_dual_add_f32 v19, v19, v51
	v_dual_add_f32 v12, v12, v76 :: v_dual_add_f32 v13, v13, v77
	v_or_b32_e32 v49, 0x400000, v9
	v_bfe_u32 v50, v10, 16, 1
	v_add3_u32 v48, v48, v9, 0x7fff
	v_cndmask_b32_e32 v8, v46, v47, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	v_dual_add_f32 v22, 0, v22 :: v_dual_add_f32 v23, 0, v23
	v_dual_add_f32 v20, v20, v52 :: v_dual_add_f32 v21, v21, v53
	v_dual_add_f32 v12, v12, v108 :: v_dual_add_f32 v13, v13, v109
	v_or_b32_e32 v51, 0x400000, v10
	v_bfe_u32 v52, v11, 16, 1
	v_add3_u32 v50, v50, v10, 0x7fff
	v_cndmask_b32_e32 v9, v48, v49, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_dual_add_f32 v24, 0, v24 :: v_dual_add_f32 v25, 0, v25
	v_dual_add_f32 v22, v22, v54 :: v_dual_add_f32 v23, v23, v55
	v_dual_add_f32 v14, v14, v78 :: v_dual_add_f32 v15, v15, v79
	v_or_b32_e32 v53, 0x400000, v11
	v_bfe_u32 v54, v12, 16, 1
	v_add3_u32 v52, v52, v11, 0x7fff
	v_cndmask_b32_e32 v10, v50, v51, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_dual_add_f32 v26, 0, v26 :: v_dual_add_f32 v27, 0, v27
	v_dual_add_f32 v24, v24, v56 :: v_dual_add_f32 v25, v25, v57
	s_waitcnt vmcnt(4)
	v_dual_add_f32 v14, v14, v110 :: v_dual_add_f32 v15, v15, v111
	v_or_b32_e32 v55, 0x400000, v12
	v_bfe_u32 v56, v13, 16, 1
	v_add3_u32 v54, v54, v12, 0x7fff
	v_cndmask_b32_e32 v11, v52, v53, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_dual_add_f32 v28, 0, v28 :: v_dual_add_f32 v29, 0, v29
	v_dual_add_f32 v26, v26, v58 :: v_dual_add_f32 v27, v27, v59
	v_dual_add_f32 v16, v16, v80 :: v_dual_add_f32 v17, v17, v81
	v_or_b32_e32 v57, 0x400000, v13
	v_bfe_u32 v58, v14, 16, 1
	v_add3_u32 v56, v56, v13, 0x7fff
	v_cndmask_b32_e32 v12, v54, v55, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_dual_add_f32 v30, 0, v30 :: v_dual_add_f32 v31, 0, v31
	v_dual_add_f32 v28, v28, v60 :: v_dual_add_f32 v29, v29, v61
	v_dual_add_f32 v16, v16, v112 :: v_dual_add_f32 v17, v17, v113
	v_or_b32_e32 v59, 0x400000, v14
	v_bfe_u32 v60, v15, 16, 1
	v_add3_u32 v58, v58, v14, 0x7fff
	v_cndmask_b32_e32 v13, v56, v57, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_dual_add_f32 v32, 0, v32 :: v_dual_add_f32 v33, 0, v33
	v_dual_add_f32 v30, v30, v62 :: v_dual_add_f32 v31, v31, v63
	v_dual_add_f32 v18, v18, v82 :: v_dual_add_f32 v19, v19, v83
	v_or_b32_e32 v61, 0x400000, v15
	v_bfe_u32 v62, v16, 16, 1
	v_add3_u32 v60, v60, v15, 0x7fff
	v_cndmask_b32_e32 v14, v58, v59, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_dual_add_f32 v32, v32, v64 :: v_dual_add_f32 v33, v33, v65
	s_waitcnt vmcnt(3)
	v_dual_add_f32 v18, v18, v114 :: v_dual_add_f32 v19, v19, v115
	v_or_b32_e32 v63, 0x400000, v16
	v_bfe_u32 v64, v17, 16, 1
	v_add3_u32 v62, v62, v16, 0x7fff
	v_cndmask_b32_e32 v15, v60, v61, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v16, v16
	v_dual_add_f32 v20, v20, v84 :: v_dual_add_f32 v21, v21, v85
	v_or_b32_e32 v65, 0x400000, v17
	v_bfe_u32 v66, v18, 16, 1
	v_add3_u32 v64, v64, v17, 0x7fff
	v_cndmask_b32_e32 v16, v62, v63, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v17, v17
	v_dual_add_f32 v20, v20, v116 :: v_dual_add_f32 v21, v21, v117
	v_or_b32_e32 v67, 0x400000, v18
	v_bfe_u32 v68, v19, 16, 1
	v_add3_u32 v66, v66, v18, 0x7fff
	v_cndmask_b32_e32 v17, v64, v65, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v18, v18
	v_dual_add_f32 v22, v22, v86 :: v_dual_add_f32 v23, v23, v87
	v_or_b32_e32 v69, 0x400000, v19
	v_bfe_u32 v70, v20, 16, 1
	v_add3_u32 v68, v68, v19, 0x7fff
	v_cndmask_b32_e32 v18, v66, v67, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v19, v19
	s_waitcnt vmcnt(2)
	v_dual_add_f32 v22, v22, v118 :: v_dual_add_f32 v23, v23, v119
	v_or_b32_e32 v71, 0x400000, v20
	v_bfe_u32 v72, v21, 16, 1
	v_add3_u32 v70, v70, v20, 0x7fff
	v_cndmask_b32_e32 v19, v68, v69, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v20, v20
	v_dual_add_f32 v24, v24, v88 :: v_dual_add_f32 v25, v25, v89
	v_or_b32_e32 v73, 0x400000, v21
	v_bfe_u32 v74, v22, 16, 1
	v_add3_u32 v72, v72, v21, 0x7fff
	v_cndmask_b32_e32 v20, v70, v71, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v21, v21
	v_dual_add_f32 v24, v24, v120 :: v_dual_add_f32 v25, v25, v121
	v_or_b32_e32 v75, 0x400000, v22
	v_bfe_u32 v76, v23, 16, 1
	v_add3_u32 v74, v74, v22, 0x7fff
	v_cndmask_b32_e32 v21, v72, v73, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v22, v22
	v_dual_add_f32 v26, v26, v90 :: v_dual_add_f32 v27, v27, v91
	v_or_b32_e32 v77, 0x400000, v23
	v_bfe_u32 v78, v24, 16, 1
	v_add3_u32 v76, v76, v23, 0x7fff
	v_cndmask_b32_e32 v22, v74, v75, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v23, v23
	s_waitcnt vmcnt(1)
	v_dual_add_f32 v26, v26, v122 :: v_dual_add_f32 v27, v27, v123
	v_or_b32_e32 v79, 0x400000, v24
	v_bfe_u32 v80, v25, 16, 1
	v_add3_u32 v78, v78, v24, 0x7fff
	v_cndmask_b32_e32 v23, v76, v77, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v24, v24
	v_dual_add_f32 v28, v28, v92 :: v_dual_add_f32 v29, v29, v93
	v_or_b32_e32 v81, 0x400000, v25
	v_bfe_u32 v82, v26, 16, 1
	v_add3_u32 v80, v80, v25, 0x7fff
	v_cndmask_b32_e32 v24, v78, v79, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v25, v25
	v_dual_add_f32 v28, v28, v124 :: v_dual_add_f32 v29, v29, v125
	v_or_b32_e32 v83, 0x400000, v26
	v_bfe_u32 v84, v27, 16, 1
	v_add3_u32 v82, v82, v26, 0x7fff
	v_cndmask_b32_e32 v25, v80, v81, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v26, v26
	v_dual_add_f32 v30, v30, v94 :: v_dual_add_f32 v31, v31, v95
	v_or_b32_e32 v85, 0x400000, v27
	v_bfe_u32 v86, v28, 16, 1
	v_add3_u32 v84, v84, v27, 0x7fff
	v_cndmask_b32_e32 v26, v82, v83, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v27, v27
	s_waitcnt vmcnt(0)
	v_dual_add_f32 v30, v30, v126 :: v_dual_add_f32 v31, v31, v127
	v_or_b32_e32 v87, 0x400000, v28
	v_bfe_u32 v88, v29, 16, 1
	v_add3_u32 v86, v86, v28, 0x7fff
	v_cndmask_b32_e32 v27, v84, v85, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v28, v28
	v_dual_add_f32 v32, v32, v96 :: v_dual_add_f32 v33, v33, v97
	v_or_b32_e32 v89, 0x400000, v29
	v_bfe_u32 v90, v30, 16, 1
	v_add3_u32 v88, v88, v29, 0x7fff
	v_cndmask_b32_e32 v28, v86, v87, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v29, v29
	v_dual_add_f32 v32, v32, v128 :: v_dual_add_f32 v33, v33, v129
	v_or_b32_e32 v91, 0x400000, v30
	v_bfe_u32 v92, v31, 16, 1
	v_add3_u32 v90, v90, v30, 0x7fff
	v_cndmask_b32_e32 v29, v88, v89, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v30, v30
	v_or_b32_e32 v93, 0x400000, v31
	v_bfe_u32 v94, v32, 16, 1
	v_add3_u32 v92, v92, v31, 0x7fff
	v_or_b32_e32 v95, 0x400000, v32
	v_cndmask_b32_e32 v30, v90, v91, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v31, v31
	v_bfe_u32 v96, v33, 16, 1
	v_add3_u32 v94, v94, v32, 0x7fff
	v_or_b32_e32 v35, 0x400000, v33
	v_and_or_b32 v36, 0x400, v226, v225
	v_cndmask_b32_e32 v31, v92, v93, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v32, v32
	v_add3_u32 v34, v96, v33, 0x7fff
	v_or_b32_e32 v37, s12, v227
	v_lshrrev_b32_e32 v2, 16, v2
	v_lshrrev_b32_e32 v3, 16, v3
	v_cndmask_b32_e32 v32, v94, v95, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v33, v33
	v_lshrrev_b32_e32 v4, 16, v4
	v_lshrrev_b32_e32 v5, 16, v5
	v_lshrrev_b32_e32 v6, 16, v6
	v_lshrrev_b32_e32 v7, 16, v7
	v_cndmask_b32_e32 v33, v34, v35, vcc_lo
	v_add_lshl_u32 v34, v37, v36, 1
	v_lshrrev_b32_e32 v8, 16, v8
	v_lshrrev_b32_e32 v9, 16, v9
	v_lshrrev_b32_e32 v10, 16, v10
	v_lshrrev_b32_e32 v11, 16, v11
	buffer_store_b16 v2, v34, s[0:3], 0 offen
	v_add_nc_u32_e32 v2, 0x1000, v34
	v_add_nc_u32_e32 v35, 0x2000, v34
	v_add_nc_u32_e32 v36, 0x3000, v34
	v_add_nc_u32_e32 v37, 0x4000, v34
	v_add_nc_u32_e32 v38, 0x5000, v34
	s_clause 0x4
	buffer_store_b16 v3, v2, s[0:3], 0 offen
	buffer_store_b16 v4, v35, s[0:3], 0 offen
	buffer_store_b16 v5, v36, s[0:3], 0 offen
	buffer_store_b16 v6, v37, s[0:3], 0 offen
	buffer_store_b16 v7, v38, s[0:3], 0 offen
	v_add_nc_u32_e32 v3, 0x6000, v34
	v_add_nc_u32_e32 v4, 0x7000, v34
	v_add_nc_u32_e32 v5, 0x8000, v34
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
	buffer_store_b16 v18, v34, s[0:3], 0 offen offset:128
	buffer_store_b16 v19, v2, s[0:3], 0 offen offset:128
	buffer_store_b16 v20, v35, s[0:3], 0 offen offset:128
	buffer_store_b16 v21, v36, s[0:3], 0 offen offset:128
	buffer_store_b16 v22, v37, s[0:3], 0 offen offset:128
	buffer_store_b16 v23, v38, s[0:3], 0 offen offset:128
	buffer_store_b16 v24, v3, s[0:3], 0 offen offset:128
	buffer_store_b16 v25, v4, s[0:3], 0 offen offset:128
	buffer_store_b16 v26, v5, s[0:3], 0 offen offset:128
	buffer_store_b16 v27, v6, s[0:3], 0 offen offset:128
	buffer_store_b16 v28, v7, s[0:3], 0 offen offset:128
	buffer_store_b16 v29, v8, s[0:3], 0 offen offset:128
	v_mov_b32_e32 v2, 0
	v_lshrrev_b32_e32 v31, 16, v31
	v_lshrrev_b32_e32 v32, 16, v32
	v_lshrrev_b32_e32 v33, 16, v33
	s_clause 0x3
	buffer_store_b16 v30, v9, s[0:3], 0 offen offset:128
	buffer_store_b16 v31, v10, s[0:3], 0 offen offset:128
	buffer_store_b16 v32, v11, s[0:3], 0 offen offset:128
	buffer_store_b16 v33, v12, s[0:3], 0 offen offset:128
	s_waitcnt_vscnt null, 0x0
	global_store_b32 v[0:1], v2, off
.LBB0_4:
	s_nop 0
	s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
	s_endpgm
.Lfunc_end0:
	.size	exercise_kernel_0, .Lfunc_end0-exercise_kernel_0
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel exercise_kernel_0
		.amdhsa_group_segment_fixed_size 41472
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
		.amdhsa_next_free_vgpr 252
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

	.set .Lexercise_kernel_0.num_vgpr, 252
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
    .group_segment_fixed_size: 41472
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
    .vgpr_count:     252
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
