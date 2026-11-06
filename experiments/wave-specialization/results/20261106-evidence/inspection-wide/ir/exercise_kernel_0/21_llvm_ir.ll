; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target datalayout = "e-p:64:64-p1:64:64-p2:32:32-p3:32:32-p4:64:64-p5:32:32-p6:32:32-p7:160:256:256:32-p8:128:128:128:48-p9:192:256:256:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-v2048:2048-n32:64-S32-A5-G1-ni:7:8:9"

@__shared_alloc_2 = external dso_local addrspace(3) global [16 x i8], align 16
@__shared_alloc_1 = external dso_local addrspace(3) global [4096 x i8], align 16
@__shared_alloc_0 = external dso_local addrspace(3) global [768 x i8], align 16

define amdgpu_kernel void @exercise_kernel_0(ptr addrspace(1) %0, <{ <{ i32, i32 }>, <{ i64 }> }> %1, ptr addrspace(1) %2, <{ <{ i32, i32 }>, <{ i64 }> }> %3, ptr addrspace(1) %4, <{ <{ i32, i32 }>, <{ i64 }> }> %5, ptr addrspace(1) %6, <{ <{ i32 }> }> %7, ptr addrspace(1) %8, <{ <{ i32 }> }> %9, ptr addrspace(1) %10, <{ <{ i32 }> }> %11) #0 !reqd_work_group_size !1 {
  %13 = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) %0, i16 0, i64 4294967295, i32 553807872)
  %14 = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) %2, i16 0, i64 4294967295, i32 553807872)
  %15 = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) %4, i16 0, i64 4294967295, i32 553807872)
  %16 = call i32 @llvm.amdgcn.workgroup.id.x()
  %17 = sext i32 %16 to i64
  %18 = trunc i64 %17 to i32
  %19 = srem i32 %18, 32
  %20 = srem i32 %19, 32
  %21 = sdiv i32 %19, 32
  %22 = mul i32 %21, 32
  %23 = add i32 %20, %22
  %24 = srem i32 %23, 32
  %25 = mul i32 %24, 128
  %26 = call range(i32 0, 192) i32 @llvm.amdgcn.workitem.id.x()
  %27 = sext i32 %26 to i64
  %28 = trunc i64 %27 to i32
  %29 = srem i32 %28, 32
  %30 = icmp slt i32 %28, 1
  br i1 %30, label %31, label %40

31:                                               ; preds = %12
  %32 = mul i32 %28, 4
  %33 = getelementptr i32, ptr addrspace(3) @__shared_alloc_2, i32 %32
  store i32 0, ptr addrspace(3) %33, align 4
  %34 = add i32 %32, 1
  %35 = getelementptr i32, ptr addrspace(3) @__shared_alloc_2, i32 %34
  store i32 0, ptr addrspace(3) %35, align 4
  %36 = add i32 %32, 2
  %37 = getelementptr i32, ptr addrspace(3) @__shared_alloc_2, i32 %36
  store i32 -17, ptr addrspace(3) %37, align 4
  %38 = add i32 %32, 3
  %39 = getelementptr i32, ptr addrspace(3) @__shared_alloc_2, i32 %38
  store i32 -23, ptr addrspace(3) %39, align 4
  br label %40

40:                                               ; preds = %31, %12
  fence syncscope("workgroup") release, !mmra !2
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire, !mmra !2
  %41 = sub i32 %28, 64
  %42 = icmp slt i32 %28, 64
  br i1 %42, label %43, label %101

43:                                               ; preds = %40
  br label %44

44:                                               ; preds = %98, %43
  %45 = phi i32 [ %99, %98 ], [ 0, %43 ]
  %46 = icmp slt i32 %45, 512
  br i1 %46, label %47, label %100

47:                                               ; preds = %44
  %48 = mul i32 %45, 16
  %49 = mul i32 %45, 65536
  %50 = add i32 %49, %25
  %51 = srem i32 %28, 4
  %52 = sdiv i32 %28, 4
  %53 = mul i32 %51, 4
  %54 = mul i32 %52, 8192
  %55 = add i32 %53, %54
  %56 = add i32 %48, %55
  %57 = srem i32 %28, 16
  %58 = sdiv i32 %28, 16
  %59 = mul i32 %57, 8
  %60 = mul i32 %58, 4096
  %61 = add i32 %59, %60
  %62 = add i32 %50, %61
  %63 = mul i32 %56, 2
  %64 = call i64 @llvm.amdgcn.raw.ptr.buffer.load.i64(ptr addrspace(8) %13, i32 %63, i32 0, i32 0)
  %65 = bitcast i64 %64 to <4 x bfloat>
  %66 = mul i32 %62, 2
  %67 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %14, i32 %66, i32 0, i32 2)
  %68 = bitcast i128 %67 to <8 x bfloat>
  %69 = add i32 %62, 16384
  %70 = mul i32 %69, 2
  %71 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %14, i32 %70, i32 0, i32 2)
  %72 = bitcast i128 %71 to <8 x bfloat>
  %73 = add i32 %62, 32768
  %74 = mul i32 %73, 2
  %75 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %14, i32 %74, i32 0, i32 2)
  %76 = bitcast i128 %75 to <8 x bfloat>
  %77 = add i32 %62, 49152
  %78 = mul i32 %77, 2
  %79 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %14, i32 %78, i32 0, i32 2)
  %80 = bitcast i128 %79 to <8 x bfloat>
  %81 = mul i32 %45, 4
  br label %82

82:                                               ; preds = %82, %47
  %83 = load atomic i32, ptr addrspace(3) getelementptr inbounds nuw (i8, ptr addrspace(3) @__shared_alloc_2, i32 4) syncscope("workgroup-one-as") acquire, align 4
  %84 = icmp slt i32 %83, %81
  br i1 %84, label %82, label %85

85:                                               ; preds = %82
  %86 = mul i32 %52, 24
  %87 = add i32 %53, %86
  %88 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %87
  store <4 x bfloat> %65, ptr addrspace(3) %88, align 8
  %89 = mul i32 %58, 128
  %90 = add i32 %59, %89
  %91 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %90
  store <8 x bfloat> %68, ptr addrspace(3) %91, align 16
  %92 = getelementptr bfloat, ptr addrspace(3) %91, i32 512
  store <8 x bfloat> %72, ptr addrspace(3) %92, align 16
  %93 = getelementptr bfloat, ptr addrspace(3) %91, i32 1024
  store <8 x bfloat> %76, ptr addrspace(3) %93, align 16
  %94 = getelementptr bfloat, ptr addrspace(3) %91, i32 1536
  store <8 x bfloat> %80, ptr addrspace(3) %94, align 16
  fence syncscope("wavefront") release, !mmra !2
  call void @llvm.amdgcn.wave.barrier()
  fence syncscope("wavefront") acquire, !mmra !2
  %95 = icmp eq i32 %29, 0
  br i1 %95, label %96, label %98

96:                                               ; preds = %85
  %97 = atomicrmw add ptr addrspace(3) @__shared_alloc_2, i32 1 syncscope("workgroup-one-as") acq_rel, align 16
  br label %98

98:                                               ; preds = %96, %85
  %99 = add i32 %45, 1
  br label %44

100:                                              ; preds = %44
  br label %368

101:                                              ; preds = %277, %112, %40
  %102 = phi i32 [ %107, %277 ], [ %107, %112 ], [ 0, %40 ]
  %103 = phi <16 x float> [ %275, %277 ], [ %275, %112 ], [ zeroinitializer, %40 ]
  br label %104

104:                                              ; preds = %101
  %105 = icmp slt i32 %102, 512
  br i1 %105, label %106, label %279

106:                                              ; preds = %104
  %107 = add i32 %102, 1
  %108 = mul i32 %107, 2
  br label %109

109:                                              ; preds = %109, %106
  %110 = load atomic i32, ptr addrspace(3) @__shared_alloc_2 syncscope("workgroup-one-as") acquire, align 16
  %111 = icmp slt i32 %110, %108
  br i1 %111, label %109, label %112

112:                                              ; preds = %109
  %113 = srem i32 %41, 16
  %114 = mul i32 %113, 24
  %115 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %114
  %116 = sdiv i32 %41, 16
  %117 = sdiv i32 %116, 2
  %118 = mul i32 %117, 16
  %119 = add i32 %113, %118
  %120 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %119
  %121 = load bfloat, ptr addrspace(3) %115, align 2
  %122 = getelementptr bfloat, ptr addrspace(3) %115, i32 1
  %123 = load bfloat, ptr addrspace(3) %122, align 2
  %124 = getelementptr bfloat, ptr addrspace(3) %115, i32 2
  %125 = load bfloat, ptr addrspace(3) %124, align 2
  %126 = getelementptr bfloat, ptr addrspace(3) %115, i32 3
  %127 = load bfloat, ptr addrspace(3) %126, align 2
  %128 = getelementptr bfloat, ptr addrspace(3) %115, i32 4
  %129 = load bfloat, ptr addrspace(3) %128, align 2
  %130 = getelementptr bfloat, ptr addrspace(3) %115, i32 5
  %131 = load bfloat, ptr addrspace(3) %130, align 2
  %132 = getelementptr bfloat, ptr addrspace(3) %115, i32 6
  %133 = load bfloat, ptr addrspace(3) %132, align 2
  %134 = getelementptr bfloat, ptr addrspace(3) %115, i32 7
  %135 = load bfloat, ptr addrspace(3) %134, align 2
  %136 = getelementptr bfloat, ptr addrspace(3) %115, i32 8
  %137 = load bfloat, ptr addrspace(3) %136, align 2
  %138 = getelementptr bfloat, ptr addrspace(3) %115, i32 9
  %139 = load bfloat, ptr addrspace(3) %138, align 2
  %140 = getelementptr bfloat, ptr addrspace(3) %115, i32 10
  %141 = load bfloat, ptr addrspace(3) %140, align 2
  %142 = getelementptr bfloat, ptr addrspace(3) %115, i32 11
  %143 = load bfloat, ptr addrspace(3) %142, align 2
  %144 = getelementptr bfloat, ptr addrspace(3) %115, i32 12
  %145 = load bfloat, ptr addrspace(3) %144, align 2
  %146 = getelementptr bfloat, ptr addrspace(3) %115, i32 13
  %147 = load bfloat, ptr addrspace(3) %146, align 2
  %148 = getelementptr bfloat, ptr addrspace(3) %115, i32 14
  %149 = load bfloat, ptr addrspace(3) %148, align 2
  %150 = getelementptr bfloat, ptr addrspace(3) %115, i32 15
  %151 = load bfloat, ptr addrspace(3) %150, align 2
  %152 = insertelement <16 x bfloat> poison, bfloat %121, i64 0
  %153 = insertelement <16 x bfloat> %152, bfloat %123, i64 1
  %154 = insertelement <16 x bfloat> %153, bfloat %125, i64 2
  %155 = insertelement <16 x bfloat> %154, bfloat %127, i64 3
  %156 = insertelement <16 x bfloat> %155, bfloat %129, i64 4
  %157 = insertelement <16 x bfloat> %156, bfloat %131, i64 5
  %158 = insertelement <16 x bfloat> %157, bfloat %133, i64 6
  %159 = insertelement <16 x bfloat> %158, bfloat %135, i64 7
  %160 = insertelement <16 x bfloat> %159, bfloat %137, i64 8
  %161 = insertelement <16 x bfloat> %160, bfloat %139, i64 9
  %162 = insertelement <16 x bfloat> %161, bfloat %141, i64 10
  %163 = insertelement <16 x bfloat> %162, bfloat %143, i64 11
  %164 = insertelement <16 x bfloat> %163, bfloat %145, i64 12
  %165 = insertelement <16 x bfloat> %164, bfloat %147, i64 13
  %166 = insertelement <16 x bfloat> %165, bfloat %149, i64 14
  %167 = insertelement <16 x bfloat> %166, bfloat %151, i64 15
  %168 = load bfloat, ptr addrspace(3) %120, align 2
  %169 = getelementptr bfloat, ptr addrspace(3) %120, i32 128
  %170 = load bfloat, ptr addrspace(3) %169, align 2
  %171 = getelementptr bfloat, ptr addrspace(3) %120, i32 256
  %172 = load bfloat, ptr addrspace(3) %171, align 2
  %173 = getelementptr bfloat, ptr addrspace(3) %120, i32 384
  %174 = load bfloat, ptr addrspace(3) %173, align 2
  %175 = getelementptr bfloat, ptr addrspace(3) %120, i32 512
  %176 = load bfloat, ptr addrspace(3) %175, align 2
  %177 = getelementptr bfloat, ptr addrspace(3) %120, i32 640
  %178 = load bfloat, ptr addrspace(3) %177, align 2
  %179 = getelementptr bfloat, ptr addrspace(3) %120, i32 768
  %180 = load bfloat, ptr addrspace(3) %179, align 2
  %181 = getelementptr bfloat, ptr addrspace(3) %120, i32 896
  %182 = load bfloat, ptr addrspace(3) %181, align 2
  %183 = getelementptr bfloat, ptr addrspace(3) %120, i32 1024
  %184 = load bfloat, ptr addrspace(3) %183, align 2
  %185 = getelementptr bfloat, ptr addrspace(3) %120, i32 1152
  %186 = load bfloat, ptr addrspace(3) %185, align 2
  %187 = getelementptr bfloat, ptr addrspace(3) %120, i32 1280
  %188 = load bfloat, ptr addrspace(3) %187, align 2
  %189 = getelementptr bfloat, ptr addrspace(3) %120, i32 1408
  %190 = load bfloat, ptr addrspace(3) %189, align 2
  %191 = getelementptr bfloat, ptr addrspace(3) %120, i32 1536
  %192 = load bfloat, ptr addrspace(3) %191, align 2
  %193 = getelementptr bfloat, ptr addrspace(3) %120, i32 1664
  %194 = load bfloat, ptr addrspace(3) %193, align 2
  %195 = getelementptr bfloat, ptr addrspace(3) %120, i32 1792
  %196 = load bfloat, ptr addrspace(3) %195, align 2
  %197 = getelementptr bfloat, ptr addrspace(3) %120, i32 1920
  %198 = load bfloat, ptr addrspace(3) %197, align 2
  %199 = getelementptr bfloat, ptr addrspace(3) %120, i32 64
  %200 = load bfloat, ptr addrspace(3) %199, align 2
  %201 = getelementptr bfloat, ptr addrspace(3) %120, i32 192
  %202 = load bfloat, ptr addrspace(3) %201, align 2
  %203 = getelementptr bfloat, ptr addrspace(3) %120, i32 320
  %204 = load bfloat, ptr addrspace(3) %203, align 2
  %205 = getelementptr bfloat, ptr addrspace(3) %120, i32 448
  %206 = load bfloat, ptr addrspace(3) %205, align 2
  %207 = getelementptr bfloat, ptr addrspace(3) %120, i32 576
  %208 = load bfloat, ptr addrspace(3) %207, align 2
  %209 = getelementptr bfloat, ptr addrspace(3) %120, i32 704
  %210 = load bfloat, ptr addrspace(3) %209, align 2
  %211 = getelementptr bfloat, ptr addrspace(3) %120, i32 832
  %212 = load bfloat, ptr addrspace(3) %211, align 2
  %213 = getelementptr bfloat, ptr addrspace(3) %120, i32 960
  %214 = load bfloat, ptr addrspace(3) %213, align 2
  %215 = getelementptr bfloat, ptr addrspace(3) %120, i32 1088
  %216 = load bfloat, ptr addrspace(3) %215, align 2
  %217 = getelementptr bfloat, ptr addrspace(3) %120, i32 1216
  %218 = load bfloat, ptr addrspace(3) %217, align 2
  %219 = getelementptr bfloat, ptr addrspace(3) %120, i32 1344
  %220 = load bfloat, ptr addrspace(3) %219, align 2
  %221 = getelementptr bfloat, ptr addrspace(3) %120, i32 1472
  %222 = load bfloat, ptr addrspace(3) %221, align 2
  %223 = getelementptr bfloat, ptr addrspace(3) %120, i32 1600
  %224 = load bfloat, ptr addrspace(3) %223, align 2
  %225 = getelementptr bfloat, ptr addrspace(3) %120, i32 1728
  %226 = load bfloat, ptr addrspace(3) %225, align 2
  %227 = getelementptr bfloat, ptr addrspace(3) %120, i32 1856
  %228 = load bfloat, ptr addrspace(3) %227, align 2
  %229 = getelementptr bfloat, ptr addrspace(3) %120, i32 1984
  %230 = load bfloat, ptr addrspace(3) %229, align 2
  %231 = insertelement <32 x bfloat> poison, bfloat %168, i64 0
  %232 = insertelement <32 x bfloat> %231, bfloat %170, i64 1
  %233 = insertelement <32 x bfloat> %232, bfloat %172, i64 2
  %234 = insertelement <32 x bfloat> %233, bfloat %174, i64 3
  %235 = insertelement <32 x bfloat> %234, bfloat %176, i64 4
  %236 = insertelement <32 x bfloat> %235, bfloat %178, i64 5
  %237 = insertelement <32 x bfloat> %236, bfloat %180, i64 6
  %238 = insertelement <32 x bfloat> %237, bfloat %182, i64 7
  %239 = insertelement <32 x bfloat> %238, bfloat %184, i64 8
  %240 = insertelement <32 x bfloat> %239, bfloat %186, i64 9
  %241 = insertelement <32 x bfloat> %240, bfloat %188, i64 10
  %242 = insertelement <32 x bfloat> %241, bfloat %190, i64 11
  %243 = insertelement <32 x bfloat> %242, bfloat %192, i64 12
  %244 = insertelement <32 x bfloat> %243, bfloat %194, i64 13
  %245 = insertelement <32 x bfloat> %244, bfloat %196, i64 14
  %246 = insertelement <32 x bfloat> %245, bfloat %198, i64 15
  %247 = insertelement <32 x bfloat> %246, bfloat %200, i64 16
  %248 = insertelement <32 x bfloat> %247, bfloat %202, i64 17
  %249 = insertelement <32 x bfloat> %248, bfloat %204, i64 18
  %250 = insertelement <32 x bfloat> %249, bfloat %206, i64 19
  %251 = insertelement <32 x bfloat> %250, bfloat %208, i64 20
  %252 = insertelement <32 x bfloat> %251, bfloat %210, i64 21
  %253 = insertelement <32 x bfloat> %252, bfloat %212, i64 22
  %254 = insertelement <32 x bfloat> %253, bfloat %214, i64 23
  %255 = insertelement <32 x bfloat> %254, bfloat %216, i64 24
  %256 = insertelement <32 x bfloat> %255, bfloat %218, i64 25
  %257 = insertelement <32 x bfloat> %256, bfloat %220, i64 26
  %258 = insertelement <32 x bfloat> %257, bfloat %222, i64 27
  %259 = insertelement <32 x bfloat> %258, bfloat %224, i64 28
  %260 = insertelement <32 x bfloat> %259, bfloat %226, i64 29
  %261 = insertelement <32 x bfloat> %260, bfloat %228, i64 30
  %262 = insertelement <32 x bfloat> %261, bfloat %230, i64 31
  %263 = shufflevector <32 x bfloat> %262, <32 x bfloat> %262, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %264 = shufflevector <16 x float> %103, <16 x float> %103, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %265 = bitcast <16 x bfloat> %167 to <16 x i16>
  %266 = bitcast <16 x bfloat> %263 to <16 x i16>
  %267 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %265, <16 x i16> %266, <8 x float> %264)
  %268 = shufflevector <8 x float> %267, <8 x float> %267, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %269 = shufflevector <16 x float> %268, <16 x float> %103, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %270 = shufflevector <32 x bfloat> %262, <32 x bfloat> %262, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %271 = shufflevector <16 x float> %269, <16 x float> %269, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %272 = bitcast <16 x bfloat> %270 to <16 x i16>
  %273 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %265, <16 x i16> %272, <8 x float> %271)
  %274 = shufflevector <8 x float> %273, <8 x float> %273, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %275 = shufflevector <16 x float> %274, <16 x float> %269, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  fence syncscope("wavefront") release, !mmra !2
  call void @llvm.amdgcn.wave.barrier()
  fence syncscope("wavefront") acquire, !mmra !2
  %276 = icmp eq i32 %29, 0
  br i1 %276, label %277, label %101

277:                                              ; preds = %112
  %278 = atomicrmw add ptr addrspace(3) getelementptr inbounds nuw (i8, ptr addrspace(3) @__shared_alloc_2, i32 4), i32 1 syncscope("workgroup-one-as") acq_rel, align 4
  br label %101

279:                                              ; preds = %104
  %280 = extractelement <16 x float> %103, i64 0
  %281 = fptrunc float %280 to bfloat
  %282 = extractelement <16 x float> %103, i64 1
  %283 = fptrunc float %282 to bfloat
  %284 = extractelement <16 x float> %103, i64 2
  %285 = fptrunc float %284 to bfloat
  %286 = extractelement <16 x float> %103, i64 3
  %287 = fptrunc float %286 to bfloat
  %288 = extractelement <16 x float> %103, i64 4
  %289 = fptrunc float %288 to bfloat
  %290 = extractelement <16 x float> %103, i64 5
  %291 = fptrunc float %290 to bfloat
  %292 = extractelement <16 x float> %103, i64 6
  %293 = fptrunc float %292 to bfloat
  %294 = extractelement <16 x float> %103, i64 7
  %295 = fptrunc float %294 to bfloat
  %296 = extractelement <16 x float> %103, i64 8
  %297 = fptrunc float %296 to bfloat
  %298 = extractelement <16 x float> %103, i64 9
  %299 = fptrunc float %298 to bfloat
  %300 = extractelement <16 x float> %103, i64 10
  %301 = fptrunc float %300 to bfloat
  %302 = extractelement <16 x float> %103, i64 11
  %303 = fptrunc float %302 to bfloat
  %304 = extractelement <16 x float> %103, i64 12
  %305 = fptrunc float %304 to bfloat
  %306 = extractelement <16 x float> %103, i64 13
  %307 = fptrunc float %306 to bfloat
  %308 = extractelement <16 x float> %103, i64 14
  %309 = fptrunc float %308 to bfloat
  %310 = extractelement <16 x float> %103, i64 15
  %311 = fptrunc float %310 to bfloat
  %312 = srem i32 %41, 16
  %313 = sdiv i32 %41, 16
  %314 = srem i32 %313, 2
  %315 = sdiv i32 %313, 2
  %316 = mul i32 %314, 4096
  %317 = add i32 %312, %316
  %318 = mul i32 %315, 16
  %319 = add i32 %317, %318
  %320 = add i32 %25, %319
  %321 = mul i32 %320, 2
  %322 = bitcast bfloat %281 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %322, ptr addrspace(8) %15, i32 %321, i32 0, i32 0)
  %323 = add i32 %320, 8192
  %324 = mul i32 %323, 2
  %325 = bitcast bfloat %283 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %325, ptr addrspace(8) %15, i32 %324, i32 0, i32 0)
  %326 = add i32 %320, 16384
  %327 = mul i32 %326, 2
  %328 = bitcast bfloat %285 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %328, ptr addrspace(8) %15, i32 %327, i32 0, i32 0)
  %329 = add i32 %320, 24576
  %330 = mul i32 %329, 2
  %331 = bitcast bfloat %287 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %331, ptr addrspace(8) %15, i32 %330, i32 0, i32 0)
  %332 = add i32 %320, 32768
  %333 = mul i32 %332, 2
  %334 = bitcast bfloat %289 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %334, ptr addrspace(8) %15, i32 %333, i32 0, i32 0)
  %335 = add i32 %320, 40960
  %336 = mul i32 %335, 2
  %337 = bitcast bfloat %291 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %337, ptr addrspace(8) %15, i32 %336, i32 0, i32 0)
  %338 = add i32 %320, 49152
  %339 = mul i32 %338, 2
  %340 = bitcast bfloat %293 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %340, ptr addrspace(8) %15, i32 %339, i32 0, i32 0)
  %341 = add i32 %320, 57344
  %342 = mul i32 %341, 2
  %343 = bitcast bfloat %295 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %343, ptr addrspace(8) %15, i32 %342, i32 0, i32 0)
  %344 = add i32 %320, 64
  %345 = mul i32 %344, 2
  %346 = bitcast bfloat %297 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %346, ptr addrspace(8) %15, i32 %345, i32 0, i32 0)
  %347 = add i32 %320, 8256
  %348 = mul i32 %347, 2
  %349 = bitcast bfloat %299 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %349, ptr addrspace(8) %15, i32 %348, i32 0, i32 0)
  %350 = add i32 %320, 16448
  %351 = mul i32 %350, 2
  %352 = bitcast bfloat %301 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %352, ptr addrspace(8) %15, i32 %351, i32 0, i32 0)
  %353 = add i32 %320, 24640
  %354 = mul i32 %353, 2
  %355 = bitcast bfloat %303 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %355, ptr addrspace(8) %15, i32 %354, i32 0, i32 0)
  %356 = add i32 %320, 32832
  %357 = mul i32 %356, 2
  %358 = bitcast bfloat %305 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %358, ptr addrspace(8) %15, i32 %357, i32 0, i32 0)
  %359 = add i32 %320, 41024
  %360 = mul i32 %359, 2
  %361 = bitcast bfloat %307 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %361, ptr addrspace(8) %15, i32 %360, i32 0, i32 0)
  %362 = add i32 %320, 49216
  %363 = mul i32 %362, 2
  %364 = bitcast bfloat %309 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %364, ptr addrspace(8) %15, i32 %363, i32 0, i32 0)
  %365 = add i32 %320, 57408
  %366 = mul i32 %365, 2
  %367 = bitcast bfloat %311 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %367, ptr addrspace(8) %15, i32 %366, i32 0, i32 0)
  br label %368

368:                                              ; preds = %100, %279
  ret void
}

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) readnone, i16, i64, i32) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef i32 @llvm.amdgcn.workgroup.id.x() #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef range(i32 0, 1024) i32 @llvm.amdgcn.workitem.id.x() #2

; Function Attrs: convergent nocallback nofree nounwind willreturn
declare void @llvm.amdgcn.s.barrier() #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: write)
declare void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16, ptr addrspace(8) writeonly captures(none), i32, i32, i32 immarg) #4

; Function Attrs: convergent nocallback nocreateundeforpoison nofree nounwind willreturn memory(none)
declare <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16>, <16 x i16>, <8 x float>) #5

; Function Attrs: convergent nocallback nofree nounwind willreturn
declare void @llvm.amdgcn.wave.barrier() #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: read)
declare i64 @llvm.amdgcn.raw.ptr.buffer.load.i64(ptr addrspace(8) readonly captures(none), i32, i32, i32 immarg) #6

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: read)
declare i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) readonly captures(none), i32, i32, i32 immarg) #6

attributes #0 = { "amdgpu-flat-work-group-size"="192,192" "uniform-work-group-size" }
attributes #1 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { convergent nocallback nofree nounwind willreturn }
attributes #4 = { nocallback nofree nosync nounwind willreturn memory(argmem: write) }
attributes #5 = { convergent nocallback nocreateundeforpoison nofree nounwind willreturn memory(none) }
attributes #6 = { nocallback nofree nosync nounwind willreturn memory(argmem: read) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{i32 192, i32 1, i32 1}
!2 = !{!"amdgpu-synchronize-as", !"local"}
