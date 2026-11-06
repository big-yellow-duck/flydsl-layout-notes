; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target datalayout = "e-p:64:64-p1:64:64-p2:32:32-p3:32:32-p4:64:64-p5:32:32-p6:32:32-p7:160:256:256:32-p8:128:128:128:48-p9:192:256:256:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-v2048:2048-n32:64-S32-A5-G1-ni:7:8:9"

@__shared_alloc_1 = external dso_local addrspace(3) global [1024 x i8], align 16
@__shared_alloc_0 = external dso_local addrspace(3) global [768 x i8], align 16

define amdgpu_kernel void @exercise_kernel_0(ptr addrspace(1) %0, <{ <{ i32, i32 }>, <{ i64 }> }> %1, ptr addrspace(1) %2, <{ <{ i32, i32 }>, <{ i64 }> }> %3, ptr addrspace(1) %4, <{ <{ i32, i32 }>, <{ i64 }> }> %5, ptr addrspace(1) %6, <{ <{ i32 }> }> %7, ptr addrspace(1) %8, <{ <{ i32 }> }> %9) #0 !reqd_work_group_size !1 {
  %11 = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) %0, i16 0, i64 4294967295, i32 553807872)
  %12 = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) %2, i16 0, i64 4294967295, i32 553807872)
  %13 = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) %4, i16 0, i64 4294967295, i32 553807872)
  %14 = call i32 @llvm.amdgcn.workgroup.id.x()
  %15 = sext i32 %14 to i64
  %16 = trunc i64 %15 to i32
  %17 = srem i32 %16, 128
  %18 = srem i32 %17, 128
  %19 = sdiv i32 %17, 128
  %20 = mul i32 %19, 128
  %21 = add i32 %18, %20
  %22 = srem i32 %21, 128
  %23 = mul i32 %22, 32
  %24 = call range(i32 0, 32) i32 @llvm.amdgcn.workitem.id.x()
  %25 = sext i32 %24 to i64
  %26 = trunc i64 %25 to i32
  %27 = srem i32 %26, 2
  %28 = sdiv i32 %26, 2
  %29 = mul i32 %27, 8
  %30 = mul i32 %28, 24
  %31 = add i32 %29, %30
  %32 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %31
  %33 = srem i32 %26, 4
  %34 = sdiv i32 %26, 4
  %35 = mul i32 %33, 8
  %36 = mul i32 %34, 32
  %37 = add i32 %35, %36
  %38 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %37
  %39 = mul i32 %28, 8192
  %40 = add i32 %29, %39
  %41 = mul i32 %34, 4096
  %42 = add i32 %35, %41
  %43 = add i32 %23, %42
  %44 = mul i32 %40, 2
  %45 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %11, i32 %44, i32 0, i32 0)
  %46 = bitcast i128 %45 to <8 x bfloat>
  %47 = mul i32 %43, 2
  %48 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %12, i32 %47, i32 0, i32 0)
  %49 = bitcast i128 %48 to <8 x bfloat>
  %50 = add i32 %43, 32768
  %51 = mul i32 %50, 2
  %52 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %12, i32 %51, i32 0, i32 0)
  %53 = bitcast i128 %52 to <8 x bfloat>
  store <8 x bfloat> %46, ptr addrspace(3) %32, align 16
  store <8 x bfloat> %49, ptr addrspace(3) %38, align 16
  %54 = getelementptr bfloat, ptr addrspace(3) %38, i32 256
  store <8 x bfloat> %53, ptr addrspace(3) %54, align 16
  fence syncscope("workgroup") release
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire
  br label %55

55:                                               ; preds = %59, %10
  %56 = phi i32 [ %60, %59 ], [ 0, %10 ]
  %57 = phi <16 x float> [ %234, %59 ], [ zeroinitializer, %10 ]
  %58 = icmp slt i32 %56, 511
  br i1 %58, label %59, label %235

59:                                               ; preds = %55
  %60 = add i32 %56, 1
  %61 = mul i32 %60, 16
  %62 = mul i32 %60, 65536
  %63 = add i32 %62, %23
  %64 = add i32 %61, %40
  %65 = add i32 %63, %42
  %66 = mul i32 %64, 2
  %67 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %11, i32 %66, i32 0, i32 0)
  %68 = bitcast i128 %67 to <8 x bfloat>
  %69 = mul i32 %65, 2
  %70 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %12, i32 %69, i32 0, i32 0)
  %71 = bitcast i128 %70 to <8 x bfloat>
  %72 = add i32 %65, 32768
  %73 = mul i32 %72, 2
  %74 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %12, i32 %73, i32 0, i32 0)
  %75 = bitcast i128 %74 to <8 x bfloat>
  %76 = srem i32 %26, 16
  %77 = mul i32 %76, 24
  %78 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %77
  %79 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %76
  %80 = load bfloat, ptr addrspace(3) %78, align 2
  %81 = getelementptr bfloat, ptr addrspace(3) %78, i32 1
  %82 = load bfloat, ptr addrspace(3) %81, align 2
  %83 = getelementptr bfloat, ptr addrspace(3) %78, i32 2
  %84 = load bfloat, ptr addrspace(3) %83, align 2
  %85 = getelementptr bfloat, ptr addrspace(3) %78, i32 3
  %86 = load bfloat, ptr addrspace(3) %85, align 2
  %87 = getelementptr bfloat, ptr addrspace(3) %78, i32 4
  %88 = load bfloat, ptr addrspace(3) %87, align 2
  %89 = getelementptr bfloat, ptr addrspace(3) %78, i32 5
  %90 = load bfloat, ptr addrspace(3) %89, align 2
  %91 = getelementptr bfloat, ptr addrspace(3) %78, i32 6
  %92 = load bfloat, ptr addrspace(3) %91, align 2
  %93 = getelementptr bfloat, ptr addrspace(3) %78, i32 7
  %94 = load bfloat, ptr addrspace(3) %93, align 2
  %95 = getelementptr bfloat, ptr addrspace(3) %78, i32 8
  %96 = load bfloat, ptr addrspace(3) %95, align 2
  %97 = getelementptr bfloat, ptr addrspace(3) %78, i32 9
  %98 = load bfloat, ptr addrspace(3) %97, align 2
  %99 = getelementptr bfloat, ptr addrspace(3) %78, i32 10
  %100 = load bfloat, ptr addrspace(3) %99, align 2
  %101 = getelementptr bfloat, ptr addrspace(3) %78, i32 11
  %102 = load bfloat, ptr addrspace(3) %101, align 2
  %103 = getelementptr bfloat, ptr addrspace(3) %78, i32 12
  %104 = load bfloat, ptr addrspace(3) %103, align 2
  %105 = getelementptr bfloat, ptr addrspace(3) %78, i32 13
  %106 = load bfloat, ptr addrspace(3) %105, align 2
  %107 = getelementptr bfloat, ptr addrspace(3) %78, i32 14
  %108 = load bfloat, ptr addrspace(3) %107, align 2
  %109 = getelementptr bfloat, ptr addrspace(3) %78, i32 15
  %110 = load bfloat, ptr addrspace(3) %109, align 2
  %111 = insertelement <16 x bfloat> poison, bfloat %80, i64 0
  %112 = insertelement <16 x bfloat> %111, bfloat %82, i64 1
  %113 = insertelement <16 x bfloat> %112, bfloat %84, i64 2
  %114 = insertelement <16 x bfloat> %113, bfloat %86, i64 3
  %115 = insertelement <16 x bfloat> %114, bfloat %88, i64 4
  %116 = insertelement <16 x bfloat> %115, bfloat %90, i64 5
  %117 = insertelement <16 x bfloat> %116, bfloat %92, i64 6
  %118 = insertelement <16 x bfloat> %117, bfloat %94, i64 7
  %119 = insertelement <16 x bfloat> %118, bfloat %96, i64 8
  %120 = insertelement <16 x bfloat> %119, bfloat %98, i64 9
  %121 = insertelement <16 x bfloat> %120, bfloat %100, i64 10
  %122 = insertelement <16 x bfloat> %121, bfloat %102, i64 11
  %123 = insertelement <16 x bfloat> %122, bfloat %104, i64 12
  %124 = insertelement <16 x bfloat> %123, bfloat %106, i64 13
  %125 = insertelement <16 x bfloat> %124, bfloat %108, i64 14
  %126 = insertelement <16 x bfloat> %125, bfloat %110, i64 15
  %127 = load bfloat, ptr addrspace(3) %79, align 2
  %128 = getelementptr bfloat, ptr addrspace(3) %79, i32 32
  %129 = load bfloat, ptr addrspace(3) %128, align 2
  %130 = getelementptr bfloat, ptr addrspace(3) %79, i32 64
  %131 = load bfloat, ptr addrspace(3) %130, align 2
  %132 = getelementptr bfloat, ptr addrspace(3) %79, i32 96
  %133 = load bfloat, ptr addrspace(3) %132, align 2
  %134 = getelementptr bfloat, ptr addrspace(3) %79, i32 128
  %135 = load bfloat, ptr addrspace(3) %134, align 2
  %136 = getelementptr bfloat, ptr addrspace(3) %79, i32 160
  %137 = load bfloat, ptr addrspace(3) %136, align 2
  %138 = getelementptr bfloat, ptr addrspace(3) %79, i32 192
  %139 = load bfloat, ptr addrspace(3) %138, align 2
  %140 = getelementptr bfloat, ptr addrspace(3) %79, i32 224
  %141 = load bfloat, ptr addrspace(3) %140, align 2
  %142 = getelementptr bfloat, ptr addrspace(3) %79, i32 256
  %143 = load bfloat, ptr addrspace(3) %142, align 2
  %144 = getelementptr bfloat, ptr addrspace(3) %79, i32 288
  %145 = load bfloat, ptr addrspace(3) %144, align 2
  %146 = getelementptr bfloat, ptr addrspace(3) %79, i32 320
  %147 = load bfloat, ptr addrspace(3) %146, align 2
  %148 = getelementptr bfloat, ptr addrspace(3) %79, i32 352
  %149 = load bfloat, ptr addrspace(3) %148, align 2
  %150 = getelementptr bfloat, ptr addrspace(3) %79, i32 384
  %151 = load bfloat, ptr addrspace(3) %150, align 2
  %152 = getelementptr bfloat, ptr addrspace(3) %79, i32 416
  %153 = load bfloat, ptr addrspace(3) %152, align 2
  %154 = getelementptr bfloat, ptr addrspace(3) %79, i32 448
  %155 = load bfloat, ptr addrspace(3) %154, align 2
  %156 = getelementptr bfloat, ptr addrspace(3) %79, i32 480
  %157 = load bfloat, ptr addrspace(3) %156, align 2
  %158 = getelementptr bfloat, ptr addrspace(3) %79, i32 16
  %159 = load bfloat, ptr addrspace(3) %158, align 2
  %160 = getelementptr bfloat, ptr addrspace(3) %79, i32 48
  %161 = load bfloat, ptr addrspace(3) %160, align 2
  %162 = getelementptr bfloat, ptr addrspace(3) %79, i32 80
  %163 = load bfloat, ptr addrspace(3) %162, align 2
  %164 = getelementptr bfloat, ptr addrspace(3) %79, i32 112
  %165 = load bfloat, ptr addrspace(3) %164, align 2
  %166 = getelementptr bfloat, ptr addrspace(3) %79, i32 144
  %167 = load bfloat, ptr addrspace(3) %166, align 2
  %168 = getelementptr bfloat, ptr addrspace(3) %79, i32 176
  %169 = load bfloat, ptr addrspace(3) %168, align 2
  %170 = getelementptr bfloat, ptr addrspace(3) %79, i32 208
  %171 = load bfloat, ptr addrspace(3) %170, align 2
  %172 = getelementptr bfloat, ptr addrspace(3) %79, i32 240
  %173 = load bfloat, ptr addrspace(3) %172, align 2
  %174 = getelementptr bfloat, ptr addrspace(3) %79, i32 272
  %175 = load bfloat, ptr addrspace(3) %174, align 2
  %176 = getelementptr bfloat, ptr addrspace(3) %79, i32 304
  %177 = load bfloat, ptr addrspace(3) %176, align 2
  %178 = getelementptr bfloat, ptr addrspace(3) %79, i32 336
  %179 = load bfloat, ptr addrspace(3) %178, align 2
  %180 = getelementptr bfloat, ptr addrspace(3) %79, i32 368
  %181 = load bfloat, ptr addrspace(3) %180, align 2
  %182 = getelementptr bfloat, ptr addrspace(3) %79, i32 400
  %183 = load bfloat, ptr addrspace(3) %182, align 2
  %184 = getelementptr bfloat, ptr addrspace(3) %79, i32 432
  %185 = load bfloat, ptr addrspace(3) %184, align 2
  %186 = getelementptr bfloat, ptr addrspace(3) %79, i32 464
  %187 = load bfloat, ptr addrspace(3) %186, align 2
  %188 = getelementptr bfloat, ptr addrspace(3) %79, i32 496
  %189 = load bfloat, ptr addrspace(3) %188, align 2
  %190 = insertelement <32 x bfloat> poison, bfloat %127, i64 0
  %191 = insertelement <32 x bfloat> %190, bfloat %129, i64 1
  %192 = insertelement <32 x bfloat> %191, bfloat %131, i64 2
  %193 = insertelement <32 x bfloat> %192, bfloat %133, i64 3
  %194 = insertelement <32 x bfloat> %193, bfloat %135, i64 4
  %195 = insertelement <32 x bfloat> %194, bfloat %137, i64 5
  %196 = insertelement <32 x bfloat> %195, bfloat %139, i64 6
  %197 = insertelement <32 x bfloat> %196, bfloat %141, i64 7
  %198 = insertelement <32 x bfloat> %197, bfloat %143, i64 8
  %199 = insertelement <32 x bfloat> %198, bfloat %145, i64 9
  %200 = insertelement <32 x bfloat> %199, bfloat %147, i64 10
  %201 = insertelement <32 x bfloat> %200, bfloat %149, i64 11
  %202 = insertelement <32 x bfloat> %201, bfloat %151, i64 12
  %203 = insertelement <32 x bfloat> %202, bfloat %153, i64 13
  %204 = insertelement <32 x bfloat> %203, bfloat %155, i64 14
  %205 = insertelement <32 x bfloat> %204, bfloat %157, i64 15
  %206 = insertelement <32 x bfloat> %205, bfloat %159, i64 16
  %207 = insertelement <32 x bfloat> %206, bfloat %161, i64 17
  %208 = insertelement <32 x bfloat> %207, bfloat %163, i64 18
  %209 = insertelement <32 x bfloat> %208, bfloat %165, i64 19
  %210 = insertelement <32 x bfloat> %209, bfloat %167, i64 20
  %211 = insertelement <32 x bfloat> %210, bfloat %169, i64 21
  %212 = insertelement <32 x bfloat> %211, bfloat %171, i64 22
  %213 = insertelement <32 x bfloat> %212, bfloat %173, i64 23
  %214 = insertelement <32 x bfloat> %213, bfloat %175, i64 24
  %215 = insertelement <32 x bfloat> %214, bfloat %177, i64 25
  %216 = insertelement <32 x bfloat> %215, bfloat %179, i64 26
  %217 = insertelement <32 x bfloat> %216, bfloat %181, i64 27
  %218 = insertelement <32 x bfloat> %217, bfloat %183, i64 28
  %219 = insertelement <32 x bfloat> %218, bfloat %185, i64 29
  %220 = insertelement <32 x bfloat> %219, bfloat %187, i64 30
  %221 = insertelement <32 x bfloat> %220, bfloat %189, i64 31
  %222 = shufflevector <32 x bfloat> %221, <32 x bfloat> %221, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %223 = shufflevector <16 x float> %57, <16 x float> %57, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %224 = bitcast <16 x bfloat> %126 to <16 x i16>
  %225 = bitcast <16 x bfloat> %222 to <16 x i16>
  %226 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %224, <16 x i16> %225, <8 x float> %223)
  %227 = shufflevector <8 x float> %226, <8 x float> %226, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %228 = shufflevector <16 x float> %227, <16 x float> %57, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %229 = shufflevector <32 x bfloat> %221, <32 x bfloat> %221, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %230 = shufflevector <16 x float> %228, <16 x float> %228, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %231 = bitcast <16 x bfloat> %229 to <16 x i16>
  %232 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %224, <16 x i16> %231, <8 x float> %230)
  %233 = shufflevector <8 x float> %232, <8 x float> %232, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %234 = shufflevector <16 x float> %233, <16 x float> %228, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  fence syncscope("workgroup") release
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire
  store <8 x bfloat> %68, ptr addrspace(3) %32, align 16
  store <8 x bfloat> %71, ptr addrspace(3) %38, align 16
  store <8 x bfloat> %75, ptr addrspace(3) %54, align 16
  fence syncscope("workgroup") release
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire
  br label %55

235:                                              ; preds = %55
  %236 = srem i32 %26, 16
  %237 = mul i32 %236, 24
  %238 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %237
  %239 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %236
  %240 = load bfloat, ptr addrspace(3) %238, align 2
  %241 = getelementptr bfloat, ptr addrspace(3) %238, i32 1
  %242 = load bfloat, ptr addrspace(3) %241, align 2
  %243 = getelementptr bfloat, ptr addrspace(3) %238, i32 2
  %244 = load bfloat, ptr addrspace(3) %243, align 2
  %245 = getelementptr bfloat, ptr addrspace(3) %238, i32 3
  %246 = load bfloat, ptr addrspace(3) %245, align 2
  %247 = getelementptr bfloat, ptr addrspace(3) %238, i32 4
  %248 = load bfloat, ptr addrspace(3) %247, align 2
  %249 = getelementptr bfloat, ptr addrspace(3) %238, i32 5
  %250 = load bfloat, ptr addrspace(3) %249, align 2
  %251 = getelementptr bfloat, ptr addrspace(3) %238, i32 6
  %252 = load bfloat, ptr addrspace(3) %251, align 2
  %253 = getelementptr bfloat, ptr addrspace(3) %238, i32 7
  %254 = load bfloat, ptr addrspace(3) %253, align 2
  %255 = getelementptr bfloat, ptr addrspace(3) %238, i32 8
  %256 = load bfloat, ptr addrspace(3) %255, align 2
  %257 = getelementptr bfloat, ptr addrspace(3) %238, i32 9
  %258 = load bfloat, ptr addrspace(3) %257, align 2
  %259 = getelementptr bfloat, ptr addrspace(3) %238, i32 10
  %260 = load bfloat, ptr addrspace(3) %259, align 2
  %261 = getelementptr bfloat, ptr addrspace(3) %238, i32 11
  %262 = load bfloat, ptr addrspace(3) %261, align 2
  %263 = getelementptr bfloat, ptr addrspace(3) %238, i32 12
  %264 = load bfloat, ptr addrspace(3) %263, align 2
  %265 = getelementptr bfloat, ptr addrspace(3) %238, i32 13
  %266 = load bfloat, ptr addrspace(3) %265, align 2
  %267 = getelementptr bfloat, ptr addrspace(3) %238, i32 14
  %268 = load bfloat, ptr addrspace(3) %267, align 2
  %269 = getelementptr bfloat, ptr addrspace(3) %238, i32 15
  %270 = load bfloat, ptr addrspace(3) %269, align 2
  %271 = insertelement <16 x bfloat> poison, bfloat %240, i64 0
  %272 = insertelement <16 x bfloat> %271, bfloat %242, i64 1
  %273 = insertelement <16 x bfloat> %272, bfloat %244, i64 2
  %274 = insertelement <16 x bfloat> %273, bfloat %246, i64 3
  %275 = insertelement <16 x bfloat> %274, bfloat %248, i64 4
  %276 = insertelement <16 x bfloat> %275, bfloat %250, i64 5
  %277 = insertelement <16 x bfloat> %276, bfloat %252, i64 6
  %278 = insertelement <16 x bfloat> %277, bfloat %254, i64 7
  %279 = insertelement <16 x bfloat> %278, bfloat %256, i64 8
  %280 = insertelement <16 x bfloat> %279, bfloat %258, i64 9
  %281 = insertelement <16 x bfloat> %280, bfloat %260, i64 10
  %282 = insertelement <16 x bfloat> %281, bfloat %262, i64 11
  %283 = insertelement <16 x bfloat> %282, bfloat %264, i64 12
  %284 = insertelement <16 x bfloat> %283, bfloat %266, i64 13
  %285 = insertelement <16 x bfloat> %284, bfloat %268, i64 14
  %286 = insertelement <16 x bfloat> %285, bfloat %270, i64 15
  %287 = load bfloat, ptr addrspace(3) %239, align 2
  %288 = getelementptr bfloat, ptr addrspace(3) %239, i32 32
  %289 = load bfloat, ptr addrspace(3) %288, align 2
  %290 = getelementptr bfloat, ptr addrspace(3) %239, i32 64
  %291 = load bfloat, ptr addrspace(3) %290, align 2
  %292 = getelementptr bfloat, ptr addrspace(3) %239, i32 96
  %293 = load bfloat, ptr addrspace(3) %292, align 2
  %294 = getelementptr bfloat, ptr addrspace(3) %239, i32 128
  %295 = load bfloat, ptr addrspace(3) %294, align 2
  %296 = getelementptr bfloat, ptr addrspace(3) %239, i32 160
  %297 = load bfloat, ptr addrspace(3) %296, align 2
  %298 = getelementptr bfloat, ptr addrspace(3) %239, i32 192
  %299 = load bfloat, ptr addrspace(3) %298, align 2
  %300 = getelementptr bfloat, ptr addrspace(3) %239, i32 224
  %301 = load bfloat, ptr addrspace(3) %300, align 2
  %302 = getelementptr bfloat, ptr addrspace(3) %239, i32 256
  %303 = load bfloat, ptr addrspace(3) %302, align 2
  %304 = getelementptr bfloat, ptr addrspace(3) %239, i32 288
  %305 = load bfloat, ptr addrspace(3) %304, align 2
  %306 = getelementptr bfloat, ptr addrspace(3) %239, i32 320
  %307 = load bfloat, ptr addrspace(3) %306, align 2
  %308 = getelementptr bfloat, ptr addrspace(3) %239, i32 352
  %309 = load bfloat, ptr addrspace(3) %308, align 2
  %310 = getelementptr bfloat, ptr addrspace(3) %239, i32 384
  %311 = load bfloat, ptr addrspace(3) %310, align 2
  %312 = getelementptr bfloat, ptr addrspace(3) %239, i32 416
  %313 = load bfloat, ptr addrspace(3) %312, align 2
  %314 = getelementptr bfloat, ptr addrspace(3) %239, i32 448
  %315 = load bfloat, ptr addrspace(3) %314, align 2
  %316 = getelementptr bfloat, ptr addrspace(3) %239, i32 480
  %317 = load bfloat, ptr addrspace(3) %316, align 2
  %318 = getelementptr bfloat, ptr addrspace(3) %239, i32 16
  %319 = load bfloat, ptr addrspace(3) %318, align 2
  %320 = getelementptr bfloat, ptr addrspace(3) %239, i32 48
  %321 = load bfloat, ptr addrspace(3) %320, align 2
  %322 = getelementptr bfloat, ptr addrspace(3) %239, i32 80
  %323 = load bfloat, ptr addrspace(3) %322, align 2
  %324 = getelementptr bfloat, ptr addrspace(3) %239, i32 112
  %325 = load bfloat, ptr addrspace(3) %324, align 2
  %326 = getelementptr bfloat, ptr addrspace(3) %239, i32 144
  %327 = load bfloat, ptr addrspace(3) %326, align 2
  %328 = getelementptr bfloat, ptr addrspace(3) %239, i32 176
  %329 = load bfloat, ptr addrspace(3) %328, align 2
  %330 = getelementptr bfloat, ptr addrspace(3) %239, i32 208
  %331 = load bfloat, ptr addrspace(3) %330, align 2
  %332 = getelementptr bfloat, ptr addrspace(3) %239, i32 240
  %333 = load bfloat, ptr addrspace(3) %332, align 2
  %334 = getelementptr bfloat, ptr addrspace(3) %239, i32 272
  %335 = load bfloat, ptr addrspace(3) %334, align 2
  %336 = getelementptr bfloat, ptr addrspace(3) %239, i32 304
  %337 = load bfloat, ptr addrspace(3) %336, align 2
  %338 = getelementptr bfloat, ptr addrspace(3) %239, i32 336
  %339 = load bfloat, ptr addrspace(3) %338, align 2
  %340 = getelementptr bfloat, ptr addrspace(3) %239, i32 368
  %341 = load bfloat, ptr addrspace(3) %340, align 2
  %342 = getelementptr bfloat, ptr addrspace(3) %239, i32 400
  %343 = load bfloat, ptr addrspace(3) %342, align 2
  %344 = getelementptr bfloat, ptr addrspace(3) %239, i32 432
  %345 = load bfloat, ptr addrspace(3) %344, align 2
  %346 = getelementptr bfloat, ptr addrspace(3) %239, i32 464
  %347 = load bfloat, ptr addrspace(3) %346, align 2
  %348 = getelementptr bfloat, ptr addrspace(3) %239, i32 496
  %349 = load bfloat, ptr addrspace(3) %348, align 2
  %350 = insertelement <32 x bfloat> poison, bfloat %287, i64 0
  %351 = insertelement <32 x bfloat> %350, bfloat %289, i64 1
  %352 = insertelement <32 x bfloat> %351, bfloat %291, i64 2
  %353 = insertelement <32 x bfloat> %352, bfloat %293, i64 3
  %354 = insertelement <32 x bfloat> %353, bfloat %295, i64 4
  %355 = insertelement <32 x bfloat> %354, bfloat %297, i64 5
  %356 = insertelement <32 x bfloat> %355, bfloat %299, i64 6
  %357 = insertelement <32 x bfloat> %356, bfloat %301, i64 7
  %358 = insertelement <32 x bfloat> %357, bfloat %303, i64 8
  %359 = insertelement <32 x bfloat> %358, bfloat %305, i64 9
  %360 = insertelement <32 x bfloat> %359, bfloat %307, i64 10
  %361 = insertelement <32 x bfloat> %360, bfloat %309, i64 11
  %362 = insertelement <32 x bfloat> %361, bfloat %311, i64 12
  %363 = insertelement <32 x bfloat> %362, bfloat %313, i64 13
  %364 = insertelement <32 x bfloat> %363, bfloat %315, i64 14
  %365 = insertelement <32 x bfloat> %364, bfloat %317, i64 15
  %366 = insertelement <32 x bfloat> %365, bfloat %319, i64 16
  %367 = insertelement <32 x bfloat> %366, bfloat %321, i64 17
  %368 = insertelement <32 x bfloat> %367, bfloat %323, i64 18
  %369 = insertelement <32 x bfloat> %368, bfloat %325, i64 19
  %370 = insertelement <32 x bfloat> %369, bfloat %327, i64 20
  %371 = insertelement <32 x bfloat> %370, bfloat %329, i64 21
  %372 = insertelement <32 x bfloat> %371, bfloat %331, i64 22
  %373 = insertelement <32 x bfloat> %372, bfloat %333, i64 23
  %374 = insertelement <32 x bfloat> %373, bfloat %335, i64 24
  %375 = insertelement <32 x bfloat> %374, bfloat %337, i64 25
  %376 = insertelement <32 x bfloat> %375, bfloat %339, i64 26
  %377 = insertelement <32 x bfloat> %376, bfloat %341, i64 27
  %378 = insertelement <32 x bfloat> %377, bfloat %343, i64 28
  %379 = insertelement <32 x bfloat> %378, bfloat %345, i64 29
  %380 = insertelement <32 x bfloat> %379, bfloat %347, i64 30
  %381 = insertelement <32 x bfloat> %380, bfloat %349, i64 31
  %382 = shufflevector <32 x bfloat> %381, <32 x bfloat> %381, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %383 = shufflevector <16 x float> %57, <16 x float> %57, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %384 = bitcast <16 x bfloat> %286 to <16 x i16>
  %385 = bitcast <16 x bfloat> %382 to <16 x i16>
  %386 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %384, <16 x i16> %385, <8 x float> %383)
  %387 = shufflevector <8 x float> %386, <8 x float> %386, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %388 = shufflevector <16 x float> %387, <16 x float> %57, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %389 = shufflevector <32 x bfloat> %381, <32 x bfloat> %381, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %390 = shufflevector <16 x float> %388, <16 x float> %388, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %391 = bitcast <16 x bfloat> %389 to <16 x i16>
  %392 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %384, <16 x i16> %391, <8 x float> %390)
  fence syncscope("workgroup") release
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire
  %393 = extractelement <8 x float> %386, i64 0
  %394 = fptrunc float %393 to bfloat
  %395 = extractelement <8 x float> %386, i64 1
  %396 = fptrunc float %395 to bfloat
  %397 = extractelement <8 x float> %386, i64 2
  %398 = fptrunc float %397 to bfloat
  %399 = extractelement <8 x float> %386, i64 3
  %400 = fptrunc float %399 to bfloat
  %401 = extractelement <8 x float> %386, i64 4
  %402 = fptrunc float %401 to bfloat
  %403 = extractelement <8 x float> %386, i64 5
  %404 = fptrunc float %403 to bfloat
  %405 = extractelement <8 x float> %386, i64 6
  %406 = fptrunc float %405 to bfloat
  %407 = extractelement <8 x float> %386, i64 7
  %408 = fptrunc float %407 to bfloat
  %409 = extractelement <8 x float> %392, i64 0
  %410 = fptrunc float %409 to bfloat
  %411 = extractelement <8 x float> %392, i64 1
  %412 = fptrunc float %411 to bfloat
  %413 = extractelement <8 x float> %392, i64 2
  %414 = fptrunc float %413 to bfloat
  %415 = extractelement <8 x float> %392, i64 3
  %416 = fptrunc float %415 to bfloat
  %417 = extractelement <8 x float> %392, i64 4
  %418 = fptrunc float %417 to bfloat
  %419 = extractelement <8 x float> %392, i64 5
  %420 = fptrunc float %419 to bfloat
  %421 = extractelement <8 x float> %392, i64 6
  %422 = fptrunc float %421 to bfloat
  %423 = extractelement <8 x float> %392, i64 7
  %424 = fptrunc float %423 to bfloat
  %425 = sdiv i32 %26, 16
  %426 = mul i32 %425, 4096
  %427 = add i32 %236, %426
  %428 = add i32 %23, %427
  %429 = mul i32 %428, 2
  %430 = bitcast bfloat %394 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %430, ptr addrspace(8) %13, i32 %429, i32 0, i32 0)
  %431 = add i32 %428, 8192
  %432 = mul i32 %431, 2
  %433 = bitcast bfloat %396 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %433, ptr addrspace(8) %13, i32 %432, i32 0, i32 0)
  %434 = add i32 %428, 16384
  %435 = mul i32 %434, 2
  %436 = bitcast bfloat %398 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %436, ptr addrspace(8) %13, i32 %435, i32 0, i32 0)
  %437 = add i32 %428, 24576
  %438 = mul i32 %437, 2
  %439 = bitcast bfloat %400 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %439, ptr addrspace(8) %13, i32 %438, i32 0, i32 0)
  %440 = add i32 %428, 32768
  %441 = mul i32 %440, 2
  %442 = bitcast bfloat %402 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %442, ptr addrspace(8) %13, i32 %441, i32 0, i32 0)
  %443 = add i32 %428, 40960
  %444 = mul i32 %443, 2
  %445 = bitcast bfloat %404 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %445, ptr addrspace(8) %13, i32 %444, i32 0, i32 0)
  %446 = add i32 %428, 49152
  %447 = mul i32 %446, 2
  %448 = bitcast bfloat %406 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %448, ptr addrspace(8) %13, i32 %447, i32 0, i32 0)
  %449 = add i32 %428, 57344
  %450 = mul i32 %449, 2
  %451 = bitcast bfloat %408 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %451, ptr addrspace(8) %13, i32 %450, i32 0, i32 0)
  %452 = add i32 %428, 16
  %453 = mul i32 %452, 2
  %454 = bitcast bfloat %410 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %454, ptr addrspace(8) %13, i32 %453, i32 0, i32 0)
  %455 = add i32 %428, 8208
  %456 = mul i32 %455, 2
  %457 = bitcast bfloat %412 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %457, ptr addrspace(8) %13, i32 %456, i32 0, i32 0)
  %458 = add i32 %428, 16400
  %459 = mul i32 %458, 2
  %460 = bitcast bfloat %414 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %460, ptr addrspace(8) %13, i32 %459, i32 0, i32 0)
  %461 = add i32 %428, 24592
  %462 = mul i32 %461, 2
  %463 = bitcast bfloat %416 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %463, ptr addrspace(8) %13, i32 %462, i32 0, i32 0)
  %464 = add i32 %428, 32784
  %465 = mul i32 %464, 2
  %466 = bitcast bfloat %418 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %466, ptr addrspace(8) %13, i32 %465, i32 0, i32 0)
  %467 = add i32 %428, 40976
  %468 = mul i32 %467, 2
  %469 = bitcast bfloat %420 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %469, ptr addrspace(8) %13, i32 %468, i32 0, i32 0)
  %470 = add i32 %428, 49168
  %471 = mul i32 %470, 2
  %472 = bitcast bfloat %422 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %472, ptr addrspace(8) %13, i32 %471, i32 0, i32 0)
  %473 = add i32 %428, 57360
  %474 = mul i32 %473, 2
  %475 = bitcast bfloat %424 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %475, ptr addrspace(8) %13, i32 %474, i32 0, i32 0)
  ret void
}

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) readnone, i16, i64, i32) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef i32 @llvm.amdgcn.workgroup.id.x() #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef range(i32 0, 1024) i32 @llvm.amdgcn.workitem.id.x() #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: read)
declare i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) readonly captures(none), i32, i32, i32 immarg) #3

; Function Attrs: convergent nocallback nofree nounwind willreturn
declare void @llvm.amdgcn.s.barrier() #4

; Function Attrs: convergent nocallback nocreateundeforpoison nofree nounwind willreturn memory(none)
declare <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16>, <16 x i16>, <8 x float>) #5

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: write)
declare void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16, ptr addrspace(8) writeonly captures(none), i32, i32, i32 immarg) #6

attributes #0 = { "amdgpu-flat-work-group-size"="32,32" "uniform-work-group-size" }
attributes #1 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { nocallback nofree nosync nounwind willreturn memory(argmem: read) }
attributes #4 = { convergent nocallback nofree nounwind willreturn }
attributes #5 = { convergent nocallback nocreateundeforpoison nofree nounwind willreturn memory(none) }
attributes #6 = { nocallback nofree nosync nounwind willreturn memory(argmem: write) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{i32 32, i32 1, i32 1}
