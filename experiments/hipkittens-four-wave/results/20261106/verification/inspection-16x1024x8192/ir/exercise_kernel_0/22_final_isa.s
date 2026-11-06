	.amdgcn_target "amdgcn-amd-amdhsa-unknown-gfx1151"
	.amdhsa_code_object_version 6
	.text
	.globl	exercise_kernel_0
	.p2align	8
	.type	exercise_kernel_0,@function
exercise_kernel_0:
	s_ashr_i32 s13, s2, 31
	v_lshrrev_b32_e32 v17, 4, v0
	s_lshr_b32 s3, s13, 30
	v_and_b32_e32 v19, 15, v0
	s_add_i32 s6, s2, s3
	s_clause 0x1
	s_load_b64 s[4:5], s[0:1], 0x0
	s_load_b64 s[8:9], s[0:1], 0x18
	s_ashr_i32 s3, s6, 2
	v_lshlrev_b32_e32 v20, 10, v17
	s_lshr_b32 s7, s3, 29
	v_lshlrev_b32_e32 v22, 4, v0
	s_add_i32 s7, s3, s7
	v_lshrrev_b32_e32 v27, 3, v0
	s_and_b32 s7, s7, -8
	v_lshl_or_b32 v1, v19, 3, v20
	s_sub_i32 s12, s3, s7
	v_and_b32_e32 v18, 0x70, v22
	s_lshl_b32 s3, s12, 7
	s_and_b32 s6, s6, -4
	v_add_lshl_u32 v23, v1, s3, 1
	s_sub_i32 s15, s2, s6
	v_lshl_or_b32 v24, v27, 14, v18
	s_mov_b32 s7, 0x21027000
	s_mov_b32 s6, -1
	v_lshl_add_u32 v1, s15, 22, v23
	s_waitcnt lgkmcnt(0)
	s_and_b32 s5, s5, 0xffff
	v_lshl_add_u32 v2, s15, 12, v24
	s_and_b32 s9, s9, 0xffff
	s_mov_b32 s10, s6
	v_add_nc_u32_e32 v3, 0x4000, v1
	s_mov_b32 s11, s7
	buffer_load_b128 v[28:31], v2, s[4:7], 0 offen
	s_clause 0x1
	buffer_load_b128 v[32:35], v1, s[8:11], 0 offen slc
	buffer_load_b128 v[36:39], v3, s[8:11], 0 offen slc
	v_add_nc_u32_e32 v2, 0x8000, v1
	v_add_nc_u32_e32 v3, 0xc000, v1
	v_add_nc_u32_e32 v4, 0x10000, v1
	v_add_nc_u32_e32 v5, 0x14000, v1
	v_add_nc_u32_e32 v6, 0x18000, v1
	v_add_nc_u32_e32 v1, 0x1c000, v1
	s_clause 0x5
	buffer_load_b128 v[40:43], v2, s[8:11], 0 offen slc
	buffer_load_b128 v[44:47], v3, s[8:11], 0 offen slc
	buffer_load_b128 v[48:51], v4, s[8:11], 0 offen slc
	buffer_load_b128 v[52:55], v5, s[8:11], 0 offen slc
	buffer_load_b128 v[56:59], v6, s[8:11], 0 offen slc
	buffer_load_b128 v[60:63], v1, s[8:11], 0 offen slc
	v_mov_b32_e32 v1, 0
	v_lshrrev_b32_e32 v21, 1, v0
	v_mul_u32_u24_e32 v64, 0x90, v27
	v_lshlrev_b32_e32 v26, 8, v17
	s_lshl_b32 s15, s15, 5
	s_delay_alu instid0(VALU_DEP_3)
	v_dual_mov_b32 v10, v1 :: v_dual_and_b32 v21, 48, v21
	v_mov_b32_e32 v2, v1
	v_mov_b32_e32 v5, v1
	v_mov_b32_e32 v13, v1
	v_or_b32_e32 v65, 0x4000, v18
	v_or_b32_e32 v17, v19, v21
	v_dual_mov_b32 v12, v1 :: v_dual_lshlrev_b32 v25, 4, v19
	v_mov_b32_e32 v3, v1
	v_mov_b32_e32 v4, v1
	v_mov_b32_e32 v6, v1
	v_mov_b32_e32 v7, v1
	v_mov_b32_e32 v8, v1
	v_mov_b32_e32 v9, v1
	v_mov_b32_e32 v11, v1
	v_dual_mov_b32 v14, v1 :: v_dual_lshlrev_b32 v17, 1, v17
	v_mov_b32_e32 v15, v1
	v_mov_b32_e32 v16, v1
	v_mul_u32_u24_e32 v18, 0x90, v19
	v_mad_u32_u24 v67, 0x90, v27, v65
	v_add_nc_u32_e32 v27, v65, v64
	v_or_b32_e32 v66, v25, v26
	s_mov_b32 s14, 0
	s_or_b32 s15, s15, 1
	s_waitcnt vmcnt(8)
	ds_store_b128 v67, v[28:31]
	s_waitcnt vmcnt(7)
	ds_store_b128 v66, v[32:35]
	s_waitcnt vmcnt(6)
	ds_store_b128 v66, v[36:39] offset:2048
	s_waitcnt vmcnt(5)
	ds_store_b128 v66, v[40:43] offset:4096
	s_waitcnt vmcnt(4)
	ds_store_b128 v66, v[44:47] offset:6144
	s_waitcnt vmcnt(3)
	ds_store_b128 v66, v[48:51] offset:8192
	s_waitcnt vmcnt(2)
	ds_store_b128 v66, v[52:55] offset:10240
	s_waitcnt vmcnt(1)
	ds_store_b128 v66, v[56:59] offset:12288
	s_waitcnt vmcnt(0)
	ds_store_b128 v66, v[60:63] offset:14336
	s_waitcnt lgkmcnt(0)
	s_barrier
.LBB0_1:
	s_add_i32 s16, s15, s14
	s_delay_alu instid0(SALU_CYCLE_1)
	v_lshl_add_u32 v28, s16, 7, v24
	v_lshl_add_u32 v29, s16, 17, v23
	buffer_load_b128 v[44:47], v28, s[4:7], 0 offen
	v_add_nc_u32_e32 v28, 0x4000, v29
	v_add_nc_u32_e32 v30, 0x8000, v29
	v_add_nc_u32_e32 v31, 0xc000, v29
	v_add_nc_u32_e32 v32, 0x10000, v29
	v_add_nc_u32_e32 v33, 0x14000, v29
	v_add_nc_u32_e32 v34, 0x18000, v29
	v_add_nc_u32_e32 v35, 0x1c000, v29
	s_clause 0x7
	buffer_load_b128 v[48:51], v29, s[8:11], 0 offen slc
	buffer_load_b128 v[52:55], v28, s[8:11], 0 offen slc
	buffer_load_b128 v[56:59], v30, s[8:11], 0 offen slc
	buffer_load_b128 v[60:63], v31, s[8:11], 0 offen slc
	buffer_load_b128 v[64:67], v32, s[8:11], 0 offen slc
	buffer_load_b128 v[68:71], v33, s[8:11], 0 offen slc
	buffer_load_b128 v[72:75], v34, s[8:11], 0 offen slc
	buffer_load_b128 v[76:79], v35, s[8:11], 0 offen slc
	ds_load_b128 v[28:31], v18 offset:16384
	ds_load_b128 v[32:35], v18 offset:16400
	ds_load_u16_d16 v36, v17
	ds_load_u16_d16_hi v36, v17 offset:256
	ds_load_u16_d16 v37, v17 offset:512
	ds_load_u16_d16_hi v37, v17 offset:768
	ds_load_u16_d16 v38, v17 offset:1024
	ds_load_u16_d16_hi v38, v17 offset:1280
	ds_load_u16_d16 v39, v17 offset:1536
	ds_load_u16_d16_hi v39, v17 offset:1792
	ds_load_u16_d16 v40, v17 offset:2048
	ds_load_u16_d16_hi v40, v17 offset:2304
	ds_load_u16_d16 v41, v17 offset:2560
	ds_load_u16_d16_hi v41, v17 offset:2816
	ds_load_u16_d16 v42, v17 offset:3072
	ds_load_u16_d16_hi v42, v17 offset:3328
	ds_load_u16_d16 v43, v17 offset:3584
	ds_load_u16_d16_hi v43, v17 offset:3840
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[28:35], v[36:43], v[9:16]
	ds_load_u16_d16 v36, v17 offset:128
	ds_load_u16_d16_hi v36, v17 offset:384
	ds_load_u16_d16 v37, v17 offset:640
	ds_load_u16_d16_hi v37, v17 offset:896
	ds_load_u16_d16 v38, v17 offset:1152
	ds_load_u16_d16_hi v38, v17 offset:1408
	ds_load_u16_d16 v39, v17 offset:1664
	ds_load_u16_d16_hi v39, v17 offset:1920
	ds_load_u16_d16 v40, v17 offset:2176
	ds_load_u16_d16_hi v40, v17 offset:2432
	ds_load_u16_d16 v41, v17 offset:2688
	ds_load_u16_d16_hi v41, v17 offset:2944
	ds_load_u16_d16 v42, v17 offset:3200
	ds_load_u16_d16_hi v42, v17 offset:3456
	ds_load_u16_d16 v43, v17 offset:3712
	ds_load_u16_d16_hi v43, v17 offset:3968
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[28:35], v[36:43], v[1:8]
	ds_load_b128 v[28:31], v18 offset:16416
	ds_load_b128 v[32:35], v18 offset:16432
	ds_load_u16_d16 v36, v17 offset:4096
	ds_load_u16_d16_hi v36, v17 offset:4352
	ds_load_u16_d16 v37, v17 offset:4608
	ds_load_u16_d16_hi v37, v17 offset:4864
	ds_load_u16_d16 v38, v17 offset:5120
	ds_load_u16_d16_hi v38, v17 offset:5376
	ds_load_u16_d16 v39, v17 offset:5632
	ds_load_u16_d16_hi v39, v17 offset:5888
	ds_load_u16_d16 v40, v17 offset:6144
	ds_load_u16_d16_hi v40, v17 offset:6400
	ds_load_u16_d16 v41, v17 offset:6656
	ds_load_u16_d16_hi v41, v17 offset:6912
	ds_load_u16_d16 v42, v17 offset:7168
	ds_load_u16_d16_hi v42, v17 offset:7424
	ds_load_u16_d16 v43, v17 offset:7680
	ds_load_u16_d16_hi v43, v17 offset:7936
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[28:35], v[36:43], v[9:16]
	ds_load_u16_d16 v36, v17 offset:4224
	ds_load_u16_d16_hi v36, v17 offset:4480
	ds_load_u16_d16 v37, v17 offset:4736
	ds_load_u16_d16_hi v37, v17 offset:4992
	ds_load_u16_d16 v38, v17 offset:5248
	ds_load_u16_d16_hi v38, v17 offset:5504
	ds_load_u16_d16 v39, v17 offset:5760
	ds_load_u16_d16_hi v39, v17 offset:6016
	ds_load_u16_d16 v40, v17 offset:6272
	ds_load_u16_d16_hi v40, v17 offset:6528
	ds_load_u16_d16 v41, v17 offset:6784
	ds_load_u16_d16_hi v41, v17 offset:7040
	ds_load_u16_d16 v42, v17 offset:7296
	ds_load_u16_d16_hi v42, v17 offset:7552
	ds_load_u16_d16 v43, v17 offset:7808
	ds_load_u16_d16_hi v43, v17 offset:8064
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[28:35], v[36:43], v[1:8]
	ds_load_b128 v[28:31], v18 offset:16448
	ds_load_b128 v[32:35], v18 offset:16464
	ds_load_u16_d16 v36, v17 offset:8192
	ds_load_u16_d16_hi v36, v17 offset:8448
	ds_load_u16_d16 v37, v17 offset:8704
	ds_load_u16_d16_hi v37, v17 offset:8960
	ds_load_u16_d16 v38, v17 offset:9216
	ds_load_u16_d16_hi v38, v17 offset:9472
	ds_load_u16_d16 v39, v17 offset:9728
	ds_load_u16_d16_hi v39, v17 offset:9984
	ds_load_u16_d16 v40, v17 offset:10240
	ds_load_u16_d16_hi v40, v17 offset:10496
	ds_load_u16_d16 v41, v17 offset:10752
	ds_load_u16_d16_hi v41, v17 offset:11008
	ds_load_u16_d16 v42, v17 offset:11264
	ds_load_u16_d16_hi v42, v17 offset:11520
	ds_load_u16_d16 v43, v17 offset:11776
	ds_load_u16_d16_hi v43, v17 offset:12032
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[28:35], v[36:43], v[9:16]
	ds_load_u16_d16 v36, v17 offset:8320
	ds_load_u16_d16_hi v36, v17 offset:8576
	ds_load_u16_d16 v37, v17 offset:8832
	ds_load_u16_d16_hi v37, v17 offset:9088
	ds_load_u16_d16 v38, v17 offset:9344
	ds_load_u16_d16_hi v38, v17 offset:9600
	ds_load_u16_d16 v39, v17 offset:9856
	ds_load_u16_d16_hi v39, v17 offset:10112
	ds_load_u16_d16 v40, v17 offset:10368
	ds_load_u16_d16_hi v40, v17 offset:10624
	ds_load_u16_d16 v41, v17 offset:10880
	ds_load_u16_d16_hi v41, v17 offset:11136
	ds_load_u16_d16 v42, v17 offset:11392
	ds_load_u16_d16_hi v42, v17 offset:11648
	ds_load_u16_d16 v43, v17 offset:11904
	ds_load_u16_d16_hi v43, v17 offset:12160
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[28:35], v[36:43], v[1:8]
	ds_load_b128 v[28:31], v18 offset:16480
	ds_load_b128 v[32:35], v18 offset:16496
	ds_load_u16_d16 v36, v17 offset:12288
	ds_load_u16_d16_hi v36, v17 offset:12544
	ds_load_u16_d16 v37, v17 offset:12800
	ds_load_u16_d16_hi v37, v17 offset:13056
	ds_load_u16_d16 v38, v17 offset:13312
	ds_load_u16_d16_hi v38, v17 offset:13568
	ds_load_u16_d16 v39, v17 offset:13824
	ds_load_u16_d16_hi v39, v17 offset:14080
	ds_load_u16_d16 v40, v17 offset:14336
	ds_load_u16_d16_hi v40, v17 offset:14592
	ds_load_u16_d16 v41, v17 offset:14848
	ds_load_u16_d16_hi v41, v17 offset:15104
	ds_load_u16_d16 v42, v17 offset:15360
	ds_load_u16_d16_hi v42, v17 offset:15616
	ds_load_u16_d16 v43, v17 offset:15872
	ds_load_u16_d16_hi v43, v17 offset:16128
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[28:35], v[36:43], v[9:16]
	ds_load_u16_d16 v36, v17 offset:12416
	ds_load_u16_d16_hi v36, v17 offset:12672
	ds_load_u16_d16 v37, v17 offset:12928
	ds_load_u16_d16_hi v37, v17 offset:13184
	ds_load_u16_d16 v38, v17 offset:13440
	ds_load_u16_d16_hi v38, v17 offset:13696
	ds_load_u16_d16 v39, v17 offset:13952
	ds_load_u16_d16_hi v39, v17 offset:14208
	ds_load_u16_d16 v40, v17 offset:14464
	ds_load_u16_d16_hi v40, v17 offset:14720
	ds_load_u16_d16 v41, v17 offset:14976
	ds_load_u16_d16_hi v41, v17 offset:15232
	ds_load_u16_d16 v42, v17 offset:15488
	ds_load_u16_d16_hi v42, v17 offset:15744
	ds_load_u16_d16 v43, v17 offset:16000
	ds_load_u16_d16_hi v43, v17 offset:16256
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[28:35], v[36:43], v[1:8]
	v_add_nc_u32_e32 v28, v25, v26
	s_add_i32 s14, s14, 1
	s_delay_alu instid0(SALU_CYCLE_1)
	s_cmp_lg_u32 s14, 31
	s_barrier
	s_waitcnt vmcnt(8)
	ds_store_b128 v27, v[44:47]
	s_waitcnt vmcnt(7)
	ds_store_b128 v28, v[48:51]
	s_waitcnt vmcnt(6)
	ds_store_b128 v28, v[52:55] offset:2048
	s_waitcnt vmcnt(5)
	ds_store_b128 v28, v[56:59] offset:4096
	s_waitcnt vmcnt(4)
	ds_store_b128 v28, v[60:63] offset:6144
	s_waitcnt vmcnt(3)
	ds_store_b128 v28, v[64:67] offset:8192
	s_waitcnt vmcnt(2)
	ds_store_b128 v28, v[68:71] offset:10240
	s_waitcnt vmcnt(1)
	ds_store_b128 v28, v[72:75] offset:12288
	s_waitcnt vmcnt(0)
	ds_store_b128 v28, v[76:79] offset:14336
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_cbranch_scc1 .LBB0_1
	ds_load_b128 v[23:26], v18 offset:16384
	ds_load_b128 v[27:30], v18 offset:16400
	ds_load_u16_d16 v31, v17
	ds_load_u16_d16_hi v31, v17 offset:256
	ds_load_u16_d16 v32, v17 offset:512
	ds_load_u16_d16_hi v32, v17 offset:768
	ds_load_u16_d16 v33, v17 offset:1024
	ds_load_u16_d16_hi v33, v17 offset:1280
	ds_load_u16_d16 v34, v17 offset:1536
	ds_load_u16_d16_hi v34, v17 offset:1792
	ds_load_u16_d16 v35, v17 offset:2048
	ds_load_u16_d16_hi v35, v17 offset:2304
	ds_load_u16_d16 v36, v17 offset:2560
	ds_load_u16_d16_hi v36, v17 offset:2816
	ds_load_u16_d16 v37, v17 offset:3072
	ds_load_u16_d16_hi v37, v17 offset:3328
	ds_load_u16_d16 v38, v17 offset:3584
	ds_load_u16_d16_hi v38, v17 offset:3840
	s_clause 0x1
	s_load_b64 s[4:5], s[0:1], 0x48
	s_load_b64 s[6:7], s[0:1], 0x58
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[23:30], v[31:38], v[9:16]
	ds_load_u16_d16 v31, v17 offset:128
	ds_load_u16_d16_hi v31, v17 offset:384
	ds_load_u16_d16 v32, v17 offset:640
	ds_load_u16_d16_hi v32, v17 offset:896
	ds_load_u16_d16 v33, v17 offset:1152
	ds_load_u16_d16_hi v33, v17 offset:1408
	ds_load_u16_d16 v34, v17 offset:1664
	ds_load_u16_d16_hi v34, v17 offset:1920
	ds_load_u16_d16 v35, v17 offset:2176
	ds_load_u16_d16_hi v35, v17 offset:2432
	ds_load_u16_d16 v36, v17 offset:2688
	ds_load_u16_d16_hi v36, v17 offset:2944
	ds_load_u16_d16 v37, v17 offset:3200
	ds_load_u16_d16_hi v37, v17 offset:3456
	ds_load_u16_d16 v38, v17 offset:3712
	ds_load_u16_d16_hi v38, v17 offset:3968
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[23:30], v[31:38], v[1:8]
	ds_load_b128 v[23:26], v18 offset:16416
	ds_load_b128 v[27:30], v18 offset:16432
	ds_load_u16_d16 v31, v17 offset:4096
	ds_load_u16_d16_hi v31, v17 offset:4352
	ds_load_u16_d16 v32, v17 offset:4608
	ds_load_u16_d16_hi v32, v17 offset:4864
	ds_load_u16_d16 v33, v17 offset:5120
	ds_load_u16_d16_hi v33, v17 offset:5376
	ds_load_u16_d16 v34, v17 offset:5632
	ds_load_u16_d16_hi v34, v17 offset:5888
	ds_load_u16_d16 v35, v17 offset:6144
	ds_load_u16_d16_hi v35, v17 offset:6400
	ds_load_u16_d16 v36, v17 offset:6656
	ds_load_u16_d16_hi v36, v17 offset:6912
	ds_load_u16_d16 v37, v17 offset:7168
	ds_load_u16_d16_hi v37, v17 offset:7424
	ds_load_u16_d16 v38, v17 offset:7680
	ds_load_u16_d16_hi v38, v17 offset:7936
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[23:30], v[31:38], v[9:16]
	ds_load_u16_d16 v31, v17 offset:4224
	ds_load_u16_d16_hi v31, v17 offset:4480
	ds_load_u16_d16 v32, v17 offset:4736
	ds_load_u16_d16_hi v32, v17 offset:4992
	ds_load_u16_d16 v33, v17 offset:5248
	ds_load_u16_d16_hi v33, v17 offset:5504
	ds_load_u16_d16 v34, v17 offset:5760
	ds_load_u16_d16_hi v34, v17 offset:6016
	ds_load_u16_d16 v35, v17 offset:6272
	ds_load_u16_d16_hi v35, v17 offset:6528
	ds_load_u16_d16 v36, v17 offset:6784
	ds_load_u16_d16_hi v36, v17 offset:7040
	ds_load_u16_d16 v37, v17 offset:7296
	ds_load_u16_d16_hi v37, v17 offset:7552
	ds_load_u16_d16 v38, v17 offset:7808
	ds_load_u16_d16_hi v38, v17 offset:8064
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[23:30], v[31:38], v[1:8]
	ds_load_b128 v[23:26], v18 offset:16448
	ds_load_b128 v[27:30], v18 offset:16464
	ds_load_u16_d16 v31, v17 offset:8192
	ds_load_u16_d16_hi v31, v17 offset:8448
	ds_load_u16_d16 v32, v17 offset:8704
	ds_load_u16_d16_hi v32, v17 offset:8960
	ds_load_u16_d16 v33, v17 offset:9216
	ds_load_u16_d16_hi v33, v17 offset:9472
	ds_load_u16_d16 v34, v17 offset:9728
	ds_load_u16_d16_hi v34, v17 offset:9984
	ds_load_u16_d16 v35, v17 offset:10240
	ds_load_u16_d16_hi v35, v17 offset:10496
	ds_load_u16_d16 v36, v17 offset:10752
	ds_load_u16_d16_hi v36, v17 offset:11008
	ds_load_u16_d16 v37, v17 offset:11264
	ds_load_u16_d16_hi v37, v17 offset:11520
	ds_load_u16_d16 v38, v17 offset:11776
	ds_load_u16_d16_hi v38, v17 offset:12032
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[23:30], v[31:38], v[9:16]
	ds_load_u16_d16 v31, v17 offset:8320
	ds_load_u16_d16_hi v31, v17 offset:8576
	ds_load_u16_d16 v32, v17 offset:8832
	ds_load_u16_d16_hi v32, v17 offset:9088
	ds_load_u16_d16 v33, v17 offset:9344
	ds_load_u16_d16_hi v33, v17 offset:9600
	ds_load_u16_d16 v34, v17 offset:9856
	ds_load_u16_d16_hi v34, v17 offset:10112
	ds_load_u16_d16 v35, v17 offset:10368
	ds_load_u16_d16_hi v35, v17 offset:10624
	ds_load_u16_d16 v36, v17 offset:10880
	ds_load_u16_d16_hi v36, v17 offset:11136
	ds_load_u16_d16 v37, v17 offset:11392
	ds_load_u16_d16_hi v37, v17 offset:11648
	ds_load_u16_d16 v38, v17 offset:11904
	ds_load_u16_d16_hi v38, v17 offset:12160
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[23:30], v[31:38], v[1:8]
	ds_load_b128 v[23:26], v18 offset:16480
	ds_load_b128 v[27:30], v18 offset:16496
	ds_load_u16_d16 v31, v17 offset:12288
	ds_load_u16_d16_hi v31, v17 offset:12544
	ds_load_u16_d16 v32, v17 offset:12800
	ds_load_u16_d16_hi v32, v17 offset:13056
	ds_load_u16_d16 v33, v17 offset:13312
	ds_load_u16_d16_hi v33, v17 offset:13568
	ds_load_u16_d16 v34, v17 offset:13824
	ds_load_u16_d16_hi v34, v17 offset:14080
	ds_load_u16_d16 v35, v17 offset:14336
	ds_load_u16_d16_hi v35, v17 offset:14592
	ds_load_u16_d16 v36, v17 offset:14848
	ds_load_u16_d16_hi v36, v17 offset:15104
	ds_load_u16_d16 v37, v17 offset:15360
	ds_load_u16_d16_hi v37, v17 offset:15616
	ds_load_u16_d16 v38, v17 offset:15872
	ds_load_u16_d16_hi v38, v17 offset:16128
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[9:16], v[23:30], v[31:38], v[9:16]
	ds_load_u16_d16 v31, v17 offset:12416
	ds_load_u16_d16_hi v31, v17 offset:12672
	ds_load_u16_d16 v32, v17 offset:12928
	ds_load_u16_d16_hi v32, v17 offset:13184
	ds_load_u16_d16 v33, v17 offset:13440
	ds_load_u16_d16_hi v33, v17 offset:13696
	ds_load_u16_d16 v34, v17 offset:13952
	ds_load_u16_d16_hi v34, v17 offset:14208
	ds_load_u16_d16 v35, v17 offset:14464
	ds_load_u16_d16_hi v35, v17 offset:14720
	ds_load_u16_d16 v36, v17 offset:14976
	ds_load_u16_d16_hi v36, v17 offset:15232
	ds_load_u16_d16 v37, v17 offset:15488
	ds_load_u16_d16_hi v37, v17 offset:15744
	ds_load_u16_d16 v38, v17 offset:16000
	ds_load_u16_d16_hi v38, v17 offset:16256
	s_waitcnt lgkmcnt(0)
	v_wmma_f32_16x16x16_bf16 v[1:8], v[23:30], v[31:38], v[1:8]
	s_lshr_b32 s8, s13, 27
	v_or_b32_e32 v23, s3, v0
	s_add_i32 s8, s2, s8
	v_mov_b32_e32 v0, 1
	s_and_b32 s8, s8, 0x1fffe0
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_4) | instid1(VALU_DEP_2)
	s_sub_i32 s2, s2, s8
	v_ashrrev_i32_e32 v24, 31, v23
	v_lshl_or_b32 v17, s2, 11, v22
	s_barrier
	s_mov_b32 s2, exec_lo
	v_lshlrev_b64 v[23:24], 2, v[23:24]
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_ashrrev_i32_e32 v18, 31, v17
	v_lshlrev_b64 v[17:18], 2, v[17:18]
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v25, vcc_lo, s4, v17
	v_add_co_ci_u32_e64 v26, null, s5, v18, vcc_lo
	v_add_co_u32 v17, vcc_lo, s6, v23
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v18, null, s7, v24, vcc_lo
	s_clause 0x3
	global_store_b128 v[25:26], v[13:16], off offset:16
	global_store_b128 v[25:26], v[9:12], off
	global_store_b128 v[25:26], v[5:8], off offset:48
	global_store_b128 v[25:26], v[1:4], off offset:32
	s_waitcnt_vscnt null, 0x0
	global_atomic_add_u32 v0, v[17:18], v0, off glc
	s_waitcnt vmcnt(0)
	buffer_gl1_inv
	buffer_gl0_inv
	v_cmpx_eq_u32_e32 3, v0
	s_cbranch_execz .LBB0_4
	v_lshl_or_b32 v0, s12, 13, v22
	v_and_or_b32 v16, 0x400, v20, v19
	v_or_b32_e32 v19, s3, v21
	s_load_b64 s[0:1], s[0:1], 0x30
	s_mov_b32 s3, 0x21027000
	v_ashrrev_i32_e32 v1, 31, v0
	s_mov_b32 s2, -1
	v_add_lshl_u32 v16, v19, v16, 1
	v_mov_b32_e32 v19, 0
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_lshlrev_b64 v[0:1], 2, v[0:1]
	v_add_nc_u32_e32 v20, 0x1000, v16
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)
	v_add_co_u32 v50, vcc_lo, s4, v0
	v_add_co_ci_u32_e64 v51, null, s5, v1, vcc_lo
	s_clause 0x2
	global_load_b128 v[0:3], v[50:51], off
	global_load_b128 v[4:7], v[50:51], off offset:16
	global_load_b128 v[8:11], v[50:51], off offset:32
	v_add_co_u32 v34, vcc_lo, 0x2000, v50
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v35, null, 0, v51, vcc_lo
	v_add_co_u32 v52, vcc_lo, 0x4000, v50
	s_clause 0x3
	global_load_b128 v[12:15], v[50:51], off offset:48
	global_load_b128 v[22:25], v[34:35], off
	global_load_b128 v[26:29], v[34:35], off offset:16
	global_load_b128 v[30:33], v[34:35], off offset:32
	v_add_co_ci_u32_e64 v53, null, 0, v51, vcc_lo
	s_clause 0x3
	global_load_b128 v[34:37], v[34:35], off offset:48
	global_load_b128 v[38:41], v[52:53], off
	global_load_b128 v[42:45], v[52:53], off offset:16
	global_load_b128 v[46:49], v[52:53], off offset:32
	v_add_co_u32 v66, vcc_lo, 0x6000, v50
	s_delay_alu instid0(VALU_DEP_1)
	v_add_co_ci_u32_e64 v67, null, 0, v51, vcc_lo
	s_clause 0x4
	global_load_b128 v[50:53], v[52:53], off offset:48
	global_load_b128 v[54:57], v[66:67], off
	global_load_b128 v[58:61], v[66:67], off offset:16
	global_load_b128 v[62:65], v[66:67], off offset:32
	global_load_b128 v[66:69], v[66:67], off offset:48
	v_add_nc_u32_e32 v70, 0x3000, v16
	v_add_nc_u32_e32 v21, 0x2000, v16
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
	v_dual_add_f32 v9, 0, v9 :: v_dual_add_f32 v0, v0, v22
	v_dual_add_f32 v1, v1, v23 :: v_dual_add_f32 v2, v2, v24
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)
	v_add_f32_e32 v3, v3, v25
	s_waitcnt vmcnt(7)
	v_dual_add_f32 v5, 0, v5 :: v_dual_add_f32 v0, v0, v38
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_dual_add_f32 v1, v1, v39 :: v_dual_add_f32 v2, v2, v40
	v_dual_add_f32 v3, v3, v41 :: v_dual_add_f32 v4, v4, v26
	s_waitcnt vmcnt(3)
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_dual_add_f32 v5, v5, v27 :: v_dual_add_f32 v0, v0, v54
	v_dual_add_f32 v1, v1, v55 :: v_dual_add_f32 v2, v2, v56
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)
	v_dual_add_f32 v3, v3, v57 :: v_dual_add_f32 v6, 0, v6
	v_bfe_u32 v22, v0, 16, 1
	v_or_b32_e32 v23, 0x400000, v0
	s_delay_alu instid0(VALU_DEP_4)
	v_bfe_u32 v24, v1, 16, 1
	v_cmp_u_f32_e32 vcc_lo, v0, v0
	v_dual_add_f32 v4, v4, v42 :: v_dual_add_f32 v5, v5, v43
	v_add3_u32 v22, v22, v0, 0x7fff
	v_or_b32_e32 v25, 0x400000, v1
	v_bfe_u32 v26, v2, 16, 1
	v_add3_u32 v24, v24, v1, 0x7fff
	v_dual_add_f32 v8, 0, v8 :: v_dual_add_f32 v11, 0, v11
	v_cndmask_b32_e32 v0, v22, v23, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v1, v1
	v_dual_add_f32 v6, v6, v28 :: v_dual_add_f32 v7, v7, v29
	s_waitcnt vmcnt(2)
	v_dual_add_f32 v4, v4, v58 :: v_dual_add_f32 v5, v5, v59
	v_or_b32_e32 v27, 0x400000, v2
	v_bfe_u32 v28, v3, 16, 1
	v_add3_u32 v26, v26, v2, 0x7fff
	v_cndmask_b32_e32 v1, v24, v25, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v2, v2
	v_add_f32_e32 v10, 0, v10
	v_dual_add_f32 v8, v8, v30 :: v_dual_add_f32 v9, v9, v31
	v_dual_add_f32 v6, v6, v44 :: v_dual_add_f32 v7, v7, v45
	v_or_b32_e32 v29, 0x400000, v3
	v_bfe_u32 v30, v4, 16, 1
	v_add3_u32 v28, v28, v3, 0x7fff
	v_cndmask_b32_e32 v2, v26, v27, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v3, v3
	v_dual_add_f32 v12, 0, v12 :: v_dual_add_f32 v13, 0, v13
	v_dual_add_f32 v10, v10, v32 :: v_dual_add_f32 v11, v11, v33
	v_dual_add_f32 v6, v6, v60 :: v_dual_add_f32 v7, v7, v61
	v_or_b32_e32 v31, 0x400000, v4
	v_bfe_u32 v32, v5, 16, 1
	v_add3_u32 v30, v30, v4, 0x7fff
	v_cndmask_b32_e32 v3, v28, v29, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v4, v4
	v_dual_add_f32 v14, 0, v14 :: v_dual_add_f32 v15, 0, v15
	v_dual_add_f32 v12, v12, v34 :: v_dual_add_f32 v13, v13, v35
	v_dual_add_f32 v8, v8, v46 :: v_dual_add_f32 v9, v9, v47
	v_or_b32_e32 v33, 0x400000, v5
	v_bfe_u32 v34, v6, 16, 1
	v_add3_u32 v32, v32, v5, 0x7fff
	v_cndmask_b32_e32 v4, v30, v31, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v5, v5
	v_dual_add_f32 v14, v14, v36 :: v_dual_add_f32 v15, v15, v37
	s_waitcnt vmcnt(1)
	v_dual_add_f32 v8, v8, v62 :: v_dual_add_f32 v9, v9, v63
	v_or_b32_e32 v35, 0x400000, v6
	v_bfe_u32 v36, v7, 16, 1
	v_add3_u32 v34, v34, v6, 0x7fff
	v_cndmask_b32_e32 v5, v32, v33, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v6, v6
	v_dual_add_f32 v10, v10, v48 :: v_dual_add_f32 v11, v11, v49
	v_or_b32_e32 v37, 0x400000, v7
	v_bfe_u32 v38, v8, 16, 1
	v_add3_u32 v36, v36, v7, 0x7fff
	v_cndmask_b32_e32 v6, v34, v35, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v7, v7
	v_dual_add_f32 v10, v10, v64 :: v_dual_add_f32 v11, v11, v65
	v_or_b32_e32 v39, 0x400000, v8
	v_bfe_u32 v40, v9, 16, 1
	v_add3_u32 v38, v38, v8, 0x7fff
	v_cndmask_b32_e32 v7, v36, v37, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v8, v8
	v_dual_add_f32 v12, v12, v50 :: v_dual_add_f32 v13, v13, v51
	v_or_b32_e32 v41, 0x400000, v9
	v_bfe_u32 v42, v10, 16, 1
	v_add3_u32 v40, v40, v9, 0x7fff
	v_cndmask_b32_e32 v8, v38, v39, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v9, v9
	s_waitcnt vmcnt(0)
	v_dual_add_f32 v12, v12, v66 :: v_dual_add_f32 v13, v13, v67
	v_or_b32_e32 v43, 0x400000, v10
	v_bfe_u32 v44, v11, 16, 1
	v_add3_u32 v42, v42, v10, 0x7fff
	v_cndmask_b32_e32 v9, v40, v41, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v10, v10
	v_dual_add_f32 v14, v14, v52 :: v_dual_add_f32 v15, v15, v53
	v_or_b32_e32 v45, 0x400000, v11
	v_bfe_u32 v46, v12, 16, 1
	v_add3_u32 v44, v44, v11, 0x7fff
	v_cndmask_b32_e32 v10, v42, v43, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v11, v11
	v_dual_add_f32 v14, v14, v68 :: v_dual_add_f32 v15, v15, v69
	v_or_b32_e32 v47, 0x400000, v12
	v_bfe_u32 v48, v13, 16, 1
	v_add3_u32 v46, v46, v12, 0x7fff
	v_cndmask_b32_e32 v11, v44, v45, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v12, v12
	v_or_b32_e32 v49, 0x400000, v13
	v_bfe_u32 v50, v14, 16, 1
	v_add3_u32 v48, v48, v13, 0x7fff
	v_or_b32_e32 v51, 0x400000, v14
	v_cndmask_b32_e32 v12, v46, v47, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v13, v13
	v_bfe_u32 v52, v15, 16, 1
	v_add3_u32 v50, v50, v14, 0x7fff
	v_or_b32_e32 v53, 0x400000, v15
	v_lshrrev_b32_e32 v0, 16, v0
	v_cndmask_b32_e32 v13, v48, v49, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v14, v14
	v_add3_u32 v52, v52, v15, 0x7fff
	v_lshrrev_b32_e32 v1, 16, v1
	v_lshrrev_b32_e32 v2, 16, v2
	v_lshrrev_b32_e32 v3, 16, v3
	v_cndmask_b32_e32 v14, v50, v51, vcc_lo
	v_cmp_u_f32_e32 vcc_lo, v15, v15
	v_lshrrev_b32_e32 v4, 16, v4
	v_lshrrev_b32_e32 v5, 16, v5
	v_lshrrev_b32_e32 v6, 16, v6
	v_lshrrev_b32_e32 v7, 16, v7
	v_cndmask_b32_e32 v15, v52, v53, vcc_lo
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
	buffer_store_b16 v1, v20, s[0:3], 0 offen
	buffer_store_b16 v2, v21, s[0:3], 0 offen
	buffer_store_b16 v3, v70, s[0:3], 0 offen
	buffer_store_b16 v4, v71, s[0:3], 0 offen
	buffer_store_b16 v5, v72, s[0:3], 0 offen
	buffer_store_b16 v6, v73, s[0:3], 0 offen
	buffer_store_b16 v7, v74, s[0:3], 0 offen
	buffer_store_b16 v8, v16, s[0:3], 0 offen offset:128
	buffer_store_b16 v9, v20, s[0:3], 0 offen offset:128
	buffer_store_b16 v10, v21, s[0:3], 0 offen offset:128
	buffer_store_b16 v11, v70, s[0:3], 0 offen offset:128
	buffer_store_b16 v12, v71, s[0:3], 0 offen offset:128
	buffer_store_b16 v13, v72, s[0:3], 0 offen offset:128
	buffer_store_b16 v14, v73, s[0:3], 0 offen offset:128
	buffer_store_b16 v15, v74, s[0:3], 0 offen offset:128
	s_waitcnt_vscnt null, 0x0
	global_store_b32 v[17:18], v19, off
.LBB0_4:
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

	.set .Lexercise_kernel_0.num_vgpr, 80
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
    .vgpr_count:     80
    .vgpr_spill_count: 0
    .wavefront_size: 32
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa-unknown-gfx1151
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata
