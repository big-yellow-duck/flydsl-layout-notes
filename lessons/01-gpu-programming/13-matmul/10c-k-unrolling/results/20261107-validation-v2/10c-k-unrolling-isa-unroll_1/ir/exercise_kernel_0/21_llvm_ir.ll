; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target datalayout = "e-p:64:64-p1:64:64-p2:32:32-p3:32:32-p4:64:64-p5:32:32-p6:32:32-p7:160:256:256:32-p8:128:128:128:48-p9:192:256:256:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-v2048:2048-n32:64-S32-A5-G1-ni:7:8:9"

@__shared_alloc_1 = external dso_local addrspace(3) global [4096 x i8], align 16
@__shared_alloc_0 = external dso_local addrspace(3) global [1536 x i8], align 16

define amdgpu_kernel void @exercise_kernel_0(ptr addrspace(1) %0, <{ <{ i32, i32 }>, <{ i64 }> }> %1, ptr addrspace(1) %2, <{ <{ i32, i32 }>, <{ i64 }> }> %3, ptr addrspace(1) %4, <{ <{ i32, i32 }>, <{ i64 }> }> %5, ptr addrspace(1) %6, <{ <{ i32 }> }> %7, ptr addrspace(1) %8, <{ <{ i32 }> }> %9) #0 !reqd_work_group_size !1 {
  %11 = call range(i32 0, 64) i32 @llvm.amdgcn.workitem.id.x()
  %12 = sext i32 %11 to i64
  %13 = trunc i64 %12 to i32
  %14 = sdiv i32 %13, 32
  %15 = mul i32 %14, 32
  %16 = icmp ne i32 %13, %15
  %17 = icmp slt i32 %13, 0
  %18 = icmp ne i1 %17, false
  %19 = and i1 %16, %18
  %20 = add i32 %14, -1
  %21 = select i1 %19, i32 %20, i32 %14
  %22 = srem i32 %13, 32
  %23 = call i32 @llvm.amdgcn.workgroup.id.x()
  %24 = sext i32 %23 to i64
  %25 = trunc i64 %24 to i32
  %26 = mul i32 %25, 2
  %27 = add i32 %26, %21
  %28 = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) %0, i16 0, i64 4294967295, i32 553807872)
  %29 = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) %2, i16 0, i64 4294967295, i32 553807872)
  %30 = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) %4, i16 0, i64 4294967295, i32 553807872)
  %31 = srem i32 %27, 64
  %32 = srem i32 %31, 64
  %33 = sdiv i32 %31, 64
  %34 = mul i32 %33, 64
  %35 = add i32 %32, %34
  %36 = srem i32 %35, 64
  %37 = mul i32 %36, 64
  %38 = mul i32 %21, 384
  %39 = mul i32 %21, 1024
  %40 = srem i32 %22, 2
  %41 = sdiv i32 %22, 2
  %42 = mul i32 %40, 8
  %43 = mul i32 %41, 24
  %44 = add i32 %42, %43
  %45 = add i32 %38, %44
  %46 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %45
  %47 = srem i32 %22, 8
  %48 = sdiv i32 %22, 8
  %49 = mul i32 %47, 8
  %50 = mul i32 %48, 64
  %51 = add i32 %49, %50
  %52 = add i32 %39, %51
  %53 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %52
  %54 = mul i32 %41, 8192
  %55 = add i32 %42, %54
  %56 = mul i32 %48, 4096
  %57 = add i32 %49, %56
  %58 = add i32 %37, %57
  %59 = mul i32 %55, 2
  %60 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %28, i32 %59, i32 0, i32 0)
  %61 = bitcast i128 %60 to <8 x bfloat>
  %62 = mul i32 %58, 2
  %63 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %29, i32 %62, i32 0, i32 2)
  %64 = bitcast i128 %63 to <8 x bfloat>
  %65 = add i32 %58, 16384
  %66 = mul i32 %65, 2
  %67 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %29, i32 %66, i32 0, i32 2)
  %68 = bitcast i128 %67 to <8 x bfloat>
  %69 = add i32 %58, 32768
  %70 = mul i32 %69, 2
  %71 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %29, i32 %70, i32 0, i32 2)
  %72 = bitcast i128 %71 to <8 x bfloat>
  %73 = add i32 %58, 49152
  %74 = mul i32 %73, 2
  %75 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %29, i32 %74, i32 0, i32 2)
  %76 = bitcast i128 %75 to <8 x bfloat>
  store <8 x bfloat> %61, ptr addrspace(3) %46, align 16
  store <8 x bfloat> %64, ptr addrspace(3) %53, align 16
  %77 = getelementptr bfloat, ptr addrspace(3) %53, i32 256
  store <8 x bfloat> %68, ptr addrspace(3) %77, align 16
  %78 = getelementptr bfloat, ptr addrspace(3) %53, i32 512
  store <8 x bfloat> %72, ptr addrspace(3) %78, align 16
  %79 = getelementptr bfloat, ptr addrspace(3) %53, i32 768
  store <8 x bfloat> %76, ptr addrspace(3) %79, align 16
  fence syncscope("wavefront") release, !mmra !2
  call void @llvm.amdgcn.wave.barrier()
  fence syncscope("wavefront") acquire, !mmra !2
  br label %80

80:                                               ; preds = %84, %10
  %81 = phi i32 [ %85, %84 ], [ 0, %10 ]
  %82 = phi <32 x float> [ %377, %84 ], [ zeroinitializer, %10 ]
  %83 = icmp slt i32 %81, 511
  br i1 %83, label %84, label %378

84:                                               ; preds = %80
  %85 = add i32 %81, 1
  %86 = mul i32 %85, 16
  %87 = mul i32 %85, 65536
  %88 = add i32 %87, %37
  %89 = add i32 %86, %55
  %90 = add i32 %88, %57
  %91 = mul i32 %89, 2
  %92 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %28, i32 %91, i32 0, i32 0)
  %93 = bitcast i128 %92 to <8 x bfloat>
  %94 = mul i32 %90, 2
  %95 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %29, i32 %94, i32 0, i32 2)
  %96 = bitcast i128 %95 to <8 x bfloat>
  %97 = add i32 %90, 16384
  %98 = mul i32 %97, 2
  %99 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %29, i32 %98, i32 0, i32 2)
  %100 = bitcast i128 %99 to <8 x bfloat>
  %101 = add i32 %90, 32768
  %102 = mul i32 %101, 2
  %103 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %29, i32 %102, i32 0, i32 2)
  %104 = bitcast i128 %103 to <8 x bfloat>
  %105 = add i32 %90, 49152
  %106 = mul i32 %105, 2
  %107 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %29, i32 %106, i32 0, i32 2)
  %108 = bitcast i128 %107 to <8 x bfloat>
  %109 = srem i32 %22, 16
  %110 = mul i32 %109, 24
  %111 = add i32 %38, %110
  %112 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %111
  %113 = add i32 %39, %109
  %114 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %113
  %115 = load bfloat, ptr addrspace(3) %112, align 2
  %116 = getelementptr bfloat, ptr addrspace(3) %112, i32 1
  %117 = load bfloat, ptr addrspace(3) %116, align 2
  %118 = getelementptr bfloat, ptr addrspace(3) %112, i32 2
  %119 = load bfloat, ptr addrspace(3) %118, align 2
  %120 = getelementptr bfloat, ptr addrspace(3) %112, i32 3
  %121 = load bfloat, ptr addrspace(3) %120, align 2
  %122 = getelementptr bfloat, ptr addrspace(3) %112, i32 4
  %123 = load bfloat, ptr addrspace(3) %122, align 2
  %124 = getelementptr bfloat, ptr addrspace(3) %112, i32 5
  %125 = load bfloat, ptr addrspace(3) %124, align 2
  %126 = getelementptr bfloat, ptr addrspace(3) %112, i32 6
  %127 = load bfloat, ptr addrspace(3) %126, align 2
  %128 = getelementptr bfloat, ptr addrspace(3) %112, i32 7
  %129 = load bfloat, ptr addrspace(3) %128, align 2
  %130 = getelementptr bfloat, ptr addrspace(3) %112, i32 8
  %131 = load bfloat, ptr addrspace(3) %130, align 2
  %132 = getelementptr bfloat, ptr addrspace(3) %112, i32 9
  %133 = load bfloat, ptr addrspace(3) %132, align 2
  %134 = getelementptr bfloat, ptr addrspace(3) %112, i32 10
  %135 = load bfloat, ptr addrspace(3) %134, align 2
  %136 = getelementptr bfloat, ptr addrspace(3) %112, i32 11
  %137 = load bfloat, ptr addrspace(3) %136, align 2
  %138 = getelementptr bfloat, ptr addrspace(3) %112, i32 12
  %139 = load bfloat, ptr addrspace(3) %138, align 2
  %140 = getelementptr bfloat, ptr addrspace(3) %112, i32 13
  %141 = load bfloat, ptr addrspace(3) %140, align 2
  %142 = getelementptr bfloat, ptr addrspace(3) %112, i32 14
  %143 = load bfloat, ptr addrspace(3) %142, align 2
  %144 = getelementptr bfloat, ptr addrspace(3) %112, i32 15
  %145 = load bfloat, ptr addrspace(3) %144, align 2
  %146 = insertelement <16 x bfloat> poison, bfloat %115, i64 0
  %147 = insertelement <16 x bfloat> %146, bfloat %117, i64 1
  %148 = insertelement <16 x bfloat> %147, bfloat %119, i64 2
  %149 = insertelement <16 x bfloat> %148, bfloat %121, i64 3
  %150 = insertelement <16 x bfloat> %149, bfloat %123, i64 4
  %151 = insertelement <16 x bfloat> %150, bfloat %125, i64 5
  %152 = insertelement <16 x bfloat> %151, bfloat %127, i64 6
  %153 = insertelement <16 x bfloat> %152, bfloat %129, i64 7
  %154 = insertelement <16 x bfloat> %153, bfloat %131, i64 8
  %155 = insertelement <16 x bfloat> %154, bfloat %133, i64 9
  %156 = insertelement <16 x bfloat> %155, bfloat %135, i64 10
  %157 = insertelement <16 x bfloat> %156, bfloat %137, i64 11
  %158 = insertelement <16 x bfloat> %157, bfloat %139, i64 12
  %159 = insertelement <16 x bfloat> %158, bfloat %141, i64 13
  %160 = insertelement <16 x bfloat> %159, bfloat %143, i64 14
  %161 = insertelement <16 x bfloat> %160, bfloat %145, i64 15
  %162 = load bfloat, ptr addrspace(3) %114, align 2
  %163 = getelementptr bfloat, ptr addrspace(3) %114, i32 64
  %164 = load bfloat, ptr addrspace(3) %163, align 2
  %165 = getelementptr bfloat, ptr addrspace(3) %114, i32 128
  %166 = load bfloat, ptr addrspace(3) %165, align 2
  %167 = getelementptr bfloat, ptr addrspace(3) %114, i32 192
  %168 = load bfloat, ptr addrspace(3) %167, align 2
  %169 = getelementptr bfloat, ptr addrspace(3) %114, i32 256
  %170 = load bfloat, ptr addrspace(3) %169, align 2
  %171 = getelementptr bfloat, ptr addrspace(3) %114, i32 320
  %172 = load bfloat, ptr addrspace(3) %171, align 2
  %173 = getelementptr bfloat, ptr addrspace(3) %114, i32 384
  %174 = load bfloat, ptr addrspace(3) %173, align 2
  %175 = getelementptr bfloat, ptr addrspace(3) %114, i32 448
  %176 = load bfloat, ptr addrspace(3) %175, align 2
  %177 = getelementptr bfloat, ptr addrspace(3) %114, i32 512
  %178 = load bfloat, ptr addrspace(3) %177, align 2
  %179 = getelementptr bfloat, ptr addrspace(3) %114, i32 576
  %180 = load bfloat, ptr addrspace(3) %179, align 2
  %181 = getelementptr bfloat, ptr addrspace(3) %114, i32 640
  %182 = load bfloat, ptr addrspace(3) %181, align 2
  %183 = getelementptr bfloat, ptr addrspace(3) %114, i32 704
  %184 = load bfloat, ptr addrspace(3) %183, align 2
  %185 = getelementptr bfloat, ptr addrspace(3) %114, i32 768
  %186 = load bfloat, ptr addrspace(3) %185, align 2
  %187 = getelementptr bfloat, ptr addrspace(3) %114, i32 832
  %188 = load bfloat, ptr addrspace(3) %187, align 2
  %189 = getelementptr bfloat, ptr addrspace(3) %114, i32 896
  %190 = load bfloat, ptr addrspace(3) %189, align 2
  %191 = getelementptr bfloat, ptr addrspace(3) %114, i32 960
  %192 = load bfloat, ptr addrspace(3) %191, align 2
  %193 = getelementptr bfloat, ptr addrspace(3) %114, i32 16
  %194 = load bfloat, ptr addrspace(3) %193, align 2
  %195 = getelementptr bfloat, ptr addrspace(3) %114, i32 80
  %196 = load bfloat, ptr addrspace(3) %195, align 2
  %197 = getelementptr bfloat, ptr addrspace(3) %114, i32 144
  %198 = load bfloat, ptr addrspace(3) %197, align 2
  %199 = getelementptr bfloat, ptr addrspace(3) %114, i32 208
  %200 = load bfloat, ptr addrspace(3) %199, align 2
  %201 = getelementptr bfloat, ptr addrspace(3) %114, i32 272
  %202 = load bfloat, ptr addrspace(3) %201, align 2
  %203 = getelementptr bfloat, ptr addrspace(3) %114, i32 336
  %204 = load bfloat, ptr addrspace(3) %203, align 2
  %205 = getelementptr bfloat, ptr addrspace(3) %114, i32 400
  %206 = load bfloat, ptr addrspace(3) %205, align 2
  %207 = getelementptr bfloat, ptr addrspace(3) %114, i32 464
  %208 = load bfloat, ptr addrspace(3) %207, align 2
  %209 = getelementptr bfloat, ptr addrspace(3) %114, i32 528
  %210 = load bfloat, ptr addrspace(3) %209, align 2
  %211 = getelementptr bfloat, ptr addrspace(3) %114, i32 592
  %212 = load bfloat, ptr addrspace(3) %211, align 2
  %213 = getelementptr bfloat, ptr addrspace(3) %114, i32 656
  %214 = load bfloat, ptr addrspace(3) %213, align 2
  %215 = getelementptr bfloat, ptr addrspace(3) %114, i32 720
  %216 = load bfloat, ptr addrspace(3) %215, align 2
  %217 = getelementptr bfloat, ptr addrspace(3) %114, i32 784
  %218 = load bfloat, ptr addrspace(3) %217, align 2
  %219 = getelementptr bfloat, ptr addrspace(3) %114, i32 848
  %220 = load bfloat, ptr addrspace(3) %219, align 2
  %221 = getelementptr bfloat, ptr addrspace(3) %114, i32 912
  %222 = load bfloat, ptr addrspace(3) %221, align 2
  %223 = getelementptr bfloat, ptr addrspace(3) %114, i32 976
  %224 = load bfloat, ptr addrspace(3) %223, align 2
  %225 = getelementptr bfloat, ptr addrspace(3) %114, i32 32
  %226 = load bfloat, ptr addrspace(3) %225, align 2
  %227 = getelementptr bfloat, ptr addrspace(3) %114, i32 96
  %228 = load bfloat, ptr addrspace(3) %227, align 2
  %229 = getelementptr bfloat, ptr addrspace(3) %114, i32 160
  %230 = load bfloat, ptr addrspace(3) %229, align 2
  %231 = getelementptr bfloat, ptr addrspace(3) %114, i32 224
  %232 = load bfloat, ptr addrspace(3) %231, align 2
  %233 = getelementptr bfloat, ptr addrspace(3) %114, i32 288
  %234 = load bfloat, ptr addrspace(3) %233, align 2
  %235 = getelementptr bfloat, ptr addrspace(3) %114, i32 352
  %236 = load bfloat, ptr addrspace(3) %235, align 2
  %237 = getelementptr bfloat, ptr addrspace(3) %114, i32 416
  %238 = load bfloat, ptr addrspace(3) %237, align 2
  %239 = getelementptr bfloat, ptr addrspace(3) %114, i32 480
  %240 = load bfloat, ptr addrspace(3) %239, align 2
  %241 = getelementptr bfloat, ptr addrspace(3) %114, i32 544
  %242 = load bfloat, ptr addrspace(3) %241, align 2
  %243 = getelementptr bfloat, ptr addrspace(3) %114, i32 608
  %244 = load bfloat, ptr addrspace(3) %243, align 2
  %245 = getelementptr bfloat, ptr addrspace(3) %114, i32 672
  %246 = load bfloat, ptr addrspace(3) %245, align 2
  %247 = getelementptr bfloat, ptr addrspace(3) %114, i32 736
  %248 = load bfloat, ptr addrspace(3) %247, align 2
  %249 = getelementptr bfloat, ptr addrspace(3) %114, i32 800
  %250 = load bfloat, ptr addrspace(3) %249, align 2
  %251 = getelementptr bfloat, ptr addrspace(3) %114, i32 864
  %252 = load bfloat, ptr addrspace(3) %251, align 2
  %253 = getelementptr bfloat, ptr addrspace(3) %114, i32 928
  %254 = load bfloat, ptr addrspace(3) %253, align 2
  %255 = getelementptr bfloat, ptr addrspace(3) %114, i32 992
  %256 = load bfloat, ptr addrspace(3) %255, align 2
  %257 = getelementptr bfloat, ptr addrspace(3) %114, i32 48
  %258 = load bfloat, ptr addrspace(3) %257, align 2
  %259 = getelementptr bfloat, ptr addrspace(3) %114, i32 112
  %260 = load bfloat, ptr addrspace(3) %259, align 2
  %261 = getelementptr bfloat, ptr addrspace(3) %114, i32 176
  %262 = load bfloat, ptr addrspace(3) %261, align 2
  %263 = getelementptr bfloat, ptr addrspace(3) %114, i32 240
  %264 = load bfloat, ptr addrspace(3) %263, align 2
  %265 = getelementptr bfloat, ptr addrspace(3) %114, i32 304
  %266 = load bfloat, ptr addrspace(3) %265, align 2
  %267 = getelementptr bfloat, ptr addrspace(3) %114, i32 368
  %268 = load bfloat, ptr addrspace(3) %267, align 2
  %269 = getelementptr bfloat, ptr addrspace(3) %114, i32 432
  %270 = load bfloat, ptr addrspace(3) %269, align 2
  %271 = getelementptr bfloat, ptr addrspace(3) %114, i32 496
  %272 = load bfloat, ptr addrspace(3) %271, align 2
  %273 = getelementptr bfloat, ptr addrspace(3) %114, i32 560
  %274 = load bfloat, ptr addrspace(3) %273, align 2
  %275 = getelementptr bfloat, ptr addrspace(3) %114, i32 624
  %276 = load bfloat, ptr addrspace(3) %275, align 2
  %277 = getelementptr bfloat, ptr addrspace(3) %114, i32 688
  %278 = load bfloat, ptr addrspace(3) %277, align 2
  %279 = getelementptr bfloat, ptr addrspace(3) %114, i32 752
  %280 = load bfloat, ptr addrspace(3) %279, align 2
  %281 = getelementptr bfloat, ptr addrspace(3) %114, i32 816
  %282 = load bfloat, ptr addrspace(3) %281, align 2
  %283 = getelementptr bfloat, ptr addrspace(3) %114, i32 880
  %284 = load bfloat, ptr addrspace(3) %283, align 2
  %285 = getelementptr bfloat, ptr addrspace(3) %114, i32 944
  %286 = load bfloat, ptr addrspace(3) %285, align 2
  %287 = getelementptr bfloat, ptr addrspace(3) %114, i32 1008
  %288 = load bfloat, ptr addrspace(3) %287, align 2
  %289 = insertelement <64 x bfloat> poison, bfloat %162, i64 0
  %290 = insertelement <64 x bfloat> %289, bfloat %164, i64 1
  %291 = insertelement <64 x bfloat> %290, bfloat %166, i64 2
  %292 = insertelement <64 x bfloat> %291, bfloat %168, i64 3
  %293 = insertelement <64 x bfloat> %292, bfloat %170, i64 4
  %294 = insertelement <64 x bfloat> %293, bfloat %172, i64 5
  %295 = insertelement <64 x bfloat> %294, bfloat %174, i64 6
  %296 = insertelement <64 x bfloat> %295, bfloat %176, i64 7
  %297 = insertelement <64 x bfloat> %296, bfloat %178, i64 8
  %298 = insertelement <64 x bfloat> %297, bfloat %180, i64 9
  %299 = insertelement <64 x bfloat> %298, bfloat %182, i64 10
  %300 = insertelement <64 x bfloat> %299, bfloat %184, i64 11
  %301 = insertelement <64 x bfloat> %300, bfloat %186, i64 12
  %302 = insertelement <64 x bfloat> %301, bfloat %188, i64 13
  %303 = insertelement <64 x bfloat> %302, bfloat %190, i64 14
  %304 = insertelement <64 x bfloat> %303, bfloat %192, i64 15
  %305 = insertelement <64 x bfloat> %304, bfloat %194, i64 16
  %306 = insertelement <64 x bfloat> %305, bfloat %196, i64 17
  %307 = insertelement <64 x bfloat> %306, bfloat %198, i64 18
  %308 = insertelement <64 x bfloat> %307, bfloat %200, i64 19
  %309 = insertelement <64 x bfloat> %308, bfloat %202, i64 20
  %310 = insertelement <64 x bfloat> %309, bfloat %204, i64 21
  %311 = insertelement <64 x bfloat> %310, bfloat %206, i64 22
  %312 = insertelement <64 x bfloat> %311, bfloat %208, i64 23
  %313 = insertelement <64 x bfloat> %312, bfloat %210, i64 24
  %314 = insertelement <64 x bfloat> %313, bfloat %212, i64 25
  %315 = insertelement <64 x bfloat> %314, bfloat %214, i64 26
  %316 = insertelement <64 x bfloat> %315, bfloat %216, i64 27
  %317 = insertelement <64 x bfloat> %316, bfloat %218, i64 28
  %318 = insertelement <64 x bfloat> %317, bfloat %220, i64 29
  %319 = insertelement <64 x bfloat> %318, bfloat %222, i64 30
  %320 = insertelement <64 x bfloat> %319, bfloat %224, i64 31
  %321 = insertelement <64 x bfloat> %320, bfloat %226, i64 32
  %322 = insertelement <64 x bfloat> %321, bfloat %228, i64 33
  %323 = insertelement <64 x bfloat> %322, bfloat %230, i64 34
  %324 = insertelement <64 x bfloat> %323, bfloat %232, i64 35
  %325 = insertelement <64 x bfloat> %324, bfloat %234, i64 36
  %326 = insertelement <64 x bfloat> %325, bfloat %236, i64 37
  %327 = insertelement <64 x bfloat> %326, bfloat %238, i64 38
  %328 = insertelement <64 x bfloat> %327, bfloat %240, i64 39
  %329 = insertelement <64 x bfloat> %328, bfloat %242, i64 40
  %330 = insertelement <64 x bfloat> %329, bfloat %244, i64 41
  %331 = insertelement <64 x bfloat> %330, bfloat %246, i64 42
  %332 = insertelement <64 x bfloat> %331, bfloat %248, i64 43
  %333 = insertelement <64 x bfloat> %332, bfloat %250, i64 44
  %334 = insertelement <64 x bfloat> %333, bfloat %252, i64 45
  %335 = insertelement <64 x bfloat> %334, bfloat %254, i64 46
  %336 = insertelement <64 x bfloat> %335, bfloat %256, i64 47
  %337 = insertelement <64 x bfloat> %336, bfloat %258, i64 48
  %338 = insertelement <64 x bfloat> %337, bfloat %260, i64 49
  %339 = insertelement <64 x bfloat> %338, bfloat %262, i64 50
  %340 = insertelement <64 x bfloat> %339, bfloat %264, i64 51
  %341 = insertelement <64 x bfloat> %340, bfloat %266, i64 52
  %342 = insertelement <64 x bfloat> %341, bfloat %268, i64 53
  %343 = insertelement <64 x bfloat> %342, bfloat %270, i64 54
  %344 = insertelement <64 x bfloat> %343, bfloat %272, i64 55
  %345 = insertelement <64 x bfloat> %344, bfloat %274, i64 56
  %346 = insertelement <64 x bfloat> %345, bfloat %276, i64 57
  %347 = insertelement <64 x bfloat> %346, bfloat %278, i64 58
  %348 = insertelement <64 x bfloat> %347, bfloat %280, i64 59
  %349 = insertelement <64 x bfloat> %348, bfloat %282, i64 60
  %350 = insertelement <64 x bfloat> %349, bfloat %284, i64 61
  %351 = insertelement <64 x bfloat> %350, bfloat %286, i64 62
  %352 = insertelement <64 x bfloat> %351, bfloat %288, i64 63
  %353 = shufflevector <64 x bfloat> %352, <64 x bfloat> %352, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %354 = shufflevector <32 x float> %82, <32 x float> %82, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %355 = bitcast <16 x bfloat> %161 to <16 x i16>
  %356 = bitcast <16 x bfloat> %353 to <16 x i16>
  %357 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %355, <16 x i16> %356, <8 x float> %354)
  %358 = shufflevector <8 x float> %357, <8 x float> %357, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %359 = shufflevector <32 x float> %358, <32 x float> %82, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %360 = shufflevector <64 x bfloat> %352, <64 x bfloat> %352, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %361 = shufflevector <32 x float> %359, <32 x float> %359, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %362 = bitcast <16 x bfloat> %360 to <16 x i16>
  %363 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %355, <16 x i16> %362, <8 x float> %361)
  %364 = shufflevector <8 x float> %363, <8 x float> %363, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %365 = shufflevector <32 x float> %364, <32 x float> %359, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %366 = shufflevector <64 x bfloat> %352, <64 x bfloat> %352, <16 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47>
  %367 = shufflevector <32 x float> %365, <32 x float> %365, <8 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %368 = bitcast <16 x bfloat> %366 to <16 x i16>
  %369 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %355, <16 x i16> %368, <8 x float> %367)
  %370 = shufflevector <8 x float> %369, <8 x float> %369, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %371 = shufflevector <32 x float> %370, <32 x float> %365, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %372 = shufflevector <64 x bfloat> %352, <64 x bfloat> %352, <16 x i32> <i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %373 = shufflevector <32 x float> %371, <32 x float> %371, <8 x i32> <i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %374 = bitcast <16 x bfloat> %372 to <16 x i16>
  %375 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %355, <16 x i16> %374, <8 x float> %373)
  %376 = shufflevector <8 x float> %375, <8 x float> %375, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %377 = shufflevector <32 x float> %376, <32 x float> %371, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  fence syncscope("wavefront") release, !mmra !2
  call void @llvm.amdgcn.wave.barrier()
  fence syncscope("wavefront") acquire, !mmra !2
  store <8 x bfloat> %93, ptr addrspace(3) %46, align 16
  store <8 x bfloat> %96, ptr addrspace(3) %53, align 16
  store <8 x bfloat> %100, ptr addrspace(3) %77, align 16
  store <8 x bfloat> %104, ptr addrspace(3) %78, align 16
  store <8 x bfloat> %108, ptr addrspace(3) %79, align 16
  fence syncscope("wavefront") release, !mmra !2
  call void @llvm.amdgcn.wave.barrier()
  fence syncscope("wavefront") acquire, !mmra !2
  br label %80

378:                                              ; preds = %80
  %379 = srem i32 %22, 16
  %380 = mul i32 %379, 24
  %381 = add i32 %38, %380
  %382 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %381
  %383 = add i32 %39, %379
  %384 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %383
  %385 = load bfloat, ptr addrspace(3) %382, align 2
  %386 = getelementptr bfloat, ptr addrspace(3) %382, i32 1
  %387 = load bfloat, ptr addrspace(3) %386, align 2
  %388 = getelementptr bfloat, ptr addrspace(3) %382, i32 2
  %389 = load bfloat, ptr addrspace(3) %388, align 2
  %390 = getelementptr bfloat, ptr addrspace(3) %382, i32 3
  %391 = load bfloat, ptr addrspace(3) %390, align 2
  %392 = getelementptr bfloat, ptr addrspace(3) %382, i32 4
  %393 = load bfloat, ptr addrspace(3) %392, align 2
  %394 = getelementptr bfloat, ptr addrspace(3) %382, i32 5
  %395 = load bfloat, ptr addrspace(3) %394, align 2
  %396 = getelementptr bfloat, ptr addrspace(3) %382, i32 6
  %397 = load bfloat, ptr addrspace(3) %396, align 2
  %398 = getelementptr bfloat, ptr addrspace(3) %382, i32 7
  %399 = load bfloat, ptr addrspace(3) %398, align 2
  %400 = getelementptr bfloat, ptr addrspace(3) %382, i32 8
  %401 = load bfloat, ptr addrspace(3) %400, align 2
  %402 = getelementptr bfloat, ptr addrspace(3) %382, i32 9
  %403 = load bfloat, ptr addrspace(3) %402, align 2
  %404 = getelementptr bfloat, ptr addrspace(3) %382, i32 10
  %405 = load bfloat, ptr addrspace(3) %404, align 2
  %406 = getelementptr bfloat, ptr addrspace(3) %382, i32 11
  %407 = load bfloat, ptr addrspace(3) %406, align 2
  %408 = getelementptr bfloat, ptr addrspace(3) %382, i32 12
  %409 = load bfloat, ptr addrspace(3) %408, align 2
  %410 = getelementptr bfloat, ptr addrspace(3) %382, i32 13
  %411 = load bfloat, ptr addrspace(3) %410, align 2
  %412 = getelementptr bfloat, ptr addrspace(3) %382, i32 14
  %413 = load bfloat, ptr addrspace(3) %412, align 2
  %414 = getelementptr bfloat, ptr addrspace(3) %382, i32 15
  %415 = load bfloat, ptr addrspace(3) %414, align 2
  %416 = insertelement <16 x bfloat> poison, bfloat %385, i64 0
  %417 = insertelement <16 x bfloat> %416, bfloat %387, i64 1
  %418 = insertelement <16 x bfloat> %417, bfloat %389, i64 2
  %419 = insertelement <16 x bfloat> %418, bfloat %391, i64 3
  %420 = insertelement <16 x bfloat> %419, bfloat %393, i64 4
  %421 = insertelement <16 x bfloat> %420, bfloat %395, i64 5
  %422 = insertelement <16 x bfloat> %421, bfloat %397, i64 6
  %423 = insertelement <16 x bfloat> %422, bfloat %399, i64 7
  %424 = insertelement <16 x bfloat> %423, bfloat %401, i64 8
  %425 = insertelement <16 x bfloat> %424, bfloat %403, i64 9
  %426 = insertelement <16 x bfloat> %425, bfloat %405, i64 10
  %427 = insertelement <16 x bfloat> %426, bfloat %407, i64 11
  %428 = insertelement <16 x bfloat> %427, bfloat %409, i64 12
  %429 = insertelement <16 x bfloat> %428, bfloat %411, i64 13
  %430 = insertelement <16 x bfloat> %429, bfloat %413, i64 14
  %431 = insertelement <16 x bfloat> %430, bfloat %415, i64 15
  %432 = load bfloat, ptr addrspace(3) %384, align 2
  %433 = getelementptr bfloat, ptr addrspace(3) %384, i32 64
  %434 = load bfloat, ptr addrspace(3) %433, align 2
  %435 = getelementptr bfloat, ptr addrspace(3) %384, i32 128
  %436 = load bfloat, ptr addrspace(3) %435, align 2
  %437 = getelementptr bfloat, ptr addrspace(3) %384, i32 192
  %438 = load bfloat, ptr addrspace(3) %437, align 2
  %439 = getelementptr bfloat, ptr addrspace(3) %384, i32 256
  %440 = load bfloat, ptr addrspace(3) %439, align 2
  %441 = getelementptr bfloat, ptr addrspace(3) %384, i32 320
  %442 = load bfloat, ptr addrspace(3) %441, align 2
  %443 = getelementptr bfloat, ptr addrspace(3) %384, i32 384
  %444 = load bfloat, ptr addrspace(3) %443, align 2
  %445 = getelementptr bfloat, ptr addrspace(3) %384, i32 448
  %446 = load bfloat, ptr addrspace(3) %445, align 2
  %447 = getelementptr bfloat, ptr addrspace(3) %384, i32 512
  %448 = load bfloat, ptr addrspace(3) %447, align 2
  %449 = getelementptr bfloat, ptr addrspace(3) %384, i32 576
  %450 = load bfloat, ptr addrspace(3) %449, align 2
  %451 = getelementptr bfloat, ptr addrspace(3) %384, i32 640
  %452 = load bfloat, ptr addrspace(3) %451, align 2
  %453 = getelementptr bfloat, ptr addrspace(3) %384, i32 704
  %454 = load bfloat, ptr addrspace(3) %453, align 2
  %455 = getelementptr bfloat, ptr addrspace(3) %384, i32 768
  %456 = load bfloat, ptr addrspace(3) %455, align 2
  %457 = getelementptr bfloat, ptr addrspace(3) %384, i32 832
  %458 = load bfloat, ptr addrspace(3) %457, align 2
  %459 = getelementptr bfloat, ptr addrspace(3) %384, i32 896
  %460 = load bfloat, ptr addrspace(3) %459, align 2
  %461 = getelementptr bfloat, ptr addrspace(3) %384, i32 960
  %462 = load bfloat, ptr addrspace(3) %461, align 2
  %463 = getelementptr bfloat, ptr addrspace(3) %384, i32 16
  %464 = load bfloat, ptr addrspace(3) %463, align 2
  %465 = getelementptr bfloat, ptr addrspace(3) %384, i32 80
  %466 = load bfloat, ptr addrspace(3) %465, align 2
  %467 = getelementptr bfloat, ptr addrspace(3) %384, i32 144
  %468 = load bfloat, ptr addrspace(3) %467, align 2
  %469 = getelementptr bfloat, ptr addrspace(3) %384, i32 208
  %470 = load bfloat, ptr addrspace(3) %469, align 2
  %471 = getelementptr bfloat, ptr addrspace(3) %384, i32 272
  %472 = load bfloat, ptr addrspace(3) %471, align 2
  %473 = getelementptr bfloat, ptr addrspace(3) %384, i32 336
  %474 = load bfloat, ptr addrspace(3) %473, align 2
  %475 = getelementptr bfloat, ptr addrspace(3) %384, i32 400
  %476 = load bfloat, ptr addrspace(3) %475, align 2
  %477 = getelementptr bfloat, ptr addrspace(3) %384, i32 464
  %478 = load bfloat, ptr addrspace(3) %477, align 2
  %479 = getelementptr bfloat, ptr addrspace(3) %384, i32 528
  %480 = load bfloat, ptr addrspace(3) %479, align 2
  %481 = getelementptr bfloat, ptr addrspace(3) %384, i32 592
  %482 = load bfloat, ptr addrspace(3) %481, align 2
  %483 = getelementptr bfloat, ptr addrspace(3) %384, i32 656
  %484 = load bfloat, ptr addrspace(3) %483, align 2
  %485 = getelementptr bfloat, ptr addrspace(3) %384, i32 720
  %486 = load bfloat, ptr addrspace(3) %485, align 2
  %487 = getelementptr bfloat, ptr addrspace(3) %384, i32 784
  %488 = load bfloat, ptr addrspace(3) %487, align 2
  %489 = getelementptr bfloat, ptr addrspace(3) %384, i32 848
  %490 = load bfloat, ptr addrspace(3) %489, align 2
  %491 = getelementptr bfloat, ptr addrspace(3) %384, i32 912
  %492 = load bfloat, ptr addrspace(3) %491, align 2
  %493 = getelementptr bfloat, ptr addrspace(3) %384, i32 976
  %494 = load bfloat, ptr addrspace(3) %493, align 2
  %495 = getelementptr bfloat, ptr addrspace(3) %384, i32 32
  %496 = load bfloat, ptr addrspace(3) %495, align 2
  %497 = getelementptr bfloat, ptr addrspace(3) %384, i32 96
  %498 = load bfloat, ptr addrspace(3) %497, align 2
  %499 = getelementptr bfloat, ptr addrspace(3) %384, i32 160
  %500 = load bfloat, ptr addrspace(3) %499, align 2
  %501 = getelementptr bfloat, ptr addrspace(3) %384, i32 224
  %502 = load bfloat, ptr addrspace(3) %501, align 2
  %503 = getelementptr bfloat, ptr addrspace(3) %384, i32 288
  %504 = load bfloat, ptr addrspace(3) %503, align 2
  %505 = getelementptr bfloat, ptr addrspace(3) %384, i32 352
  %506 = load bfloat, ptr addrspace(3) %505, align 2
  %507 = getelementptr bfloat, ptr addrspace(3) %384, i32 416
  %508 = load bfloat, ptr addrspace(3) %507, align 2
  %509 = getelementptr bfloat, ptr addrspace(3) %384, i32 480
  %510 = load bfloat, ptr addrspace(3) %509, align 2
  %511 = getelementptr bfloat, ptr addrspace(3) %384, i32 544
  %512 = load bfloat, ptr addrspace(3) %511, align 2
  %513 = getelementptr bfloat, ptr addrspace(3) %384, i32 608
  %514 = load bfloat, ptr addrspace(3) %513, align 2
  %515 = getelementptr bfloat, ptr addrspace(3) %384, i32 672
  %516 = load bfloat, ptr addrspace(3) %515, align 2
  %517 = getelementptr bfloat, ptr addrspace(3) %384, i32 736
  %518 = load bfloat, ptr addrspace(3) %517, align 2
  %519 = getelementptr bfloat, ptr addrspace(3) %384, i32 800
  %520 = load bfloat, ptr addrspace(3) %519, align 2
  %521 = getelementptr bfloat, ptr addrspace(3) %384, i32 864
  %522 = load bfloat, ptr addrspace(3) %521, align 2
  %523 = getelementptr bfloat, ptr addrspace(3) %384, i32 928
  %524 = load bfloat, ptr addrspace(3) %523, align 2
  %525 = getelementptr bfloat, ptr addrspace(3) %384, i32 992
  %526 = load bfloat, ptr addrspace(3) %525, align 2
  %527 = getelementptr bfloat, ptr addrspace(3) %384, i32 48
  %528 = load bfloat, ptr addrspace(3) %527, align 2
  %529 = getelementptr bfloat, ptr addrspace(3) %384, i32 112
  %530 = load bfloat, ptr addrspace(3) %529, align 2
  %531 = getelementptr bfloat, ptr addrspace(3) %384, i32 176
  %532 = load bfloat, ptr addrspace(3) %531, align 2
  %533 = getelementptr bfloat, ptr addrspace(3) %384, i32 240
  %534 = load bfloat, ptr addrspace(3) %533, align 2
  %535 = getelementptr bfloat, ptr addrspace(3) %384, i32 304
  %536 = load bfloat, ptr addrspace(3) %535, align 2
  %537 = getelementptr bfloat, ptr addrspace(3) %384, i32 368
  %538 = load bfloat, ptr addrspace(3) %537, align 2
  %539 = getelementptr bfloat, ptr addrspace(3) %384, i32 432
  %540 = load bfloat, ptr addrspace(3) %539, align 2
  %541 = getelementptr bfloat, ptr addrspace(3) %384, i32 496
  %542 = load bfloat, ptr addrspace(3) %541, align 2
  %543 = getelementptr bfloat, ptr addrspace(3) %384, i32 560
  %544 = load bfloat, ptr addrspace(3) %543, align 2
  %545 = getelementptr bfloat, ptr addrspace(3) %384, i32 624
  %546 = load bfloat, ptr addrspace(3) %545, align 2
  %547 = getelementptr bfloat, ptr addrspace(3) %384, i32 688
  %548 = load bfloat, ptr addrspace(3) %547, align 2
  %549 = getelementptr bfloat, ptr addrspace(3) %384, i32 752
  %550 = load bfloat, ptr addrspace(3) %549, align 2
  %551 = getelementptr bfloat, ptr addrspace(3) %384, i32 816
  %552 = load bfloat, ptr addrspace(3) %551, align 2
  %553 = getelementptr bfloat, ptr addrspace(3) %384, i32 880
  %554 = load bfloat, ptr addrspace(3) %553, align 2
  %555 = getelementptr bfloat, ptr addrspace(3) %384, i32 944
  %556 = load bfloat, ptr addrspace(3) %555, align 2
  %557 = getelementptr bfloat, ptr addrspace(3) %384, i32 1008
  %558 = load bfloat, ptr addrspace(3) %557, align 2
  %559 = insertelement <64 x bfloat> poison, bfloat %432, i64 0
  %560 = insertelement <64 x bfloat> %559, bfloat %434, i64 1
  %561 = insertelement <64 x bfloat> %560, bfloat %436, i64 2
  %562 = insertelement <64 x bfloat> %561, bfloat %438, i64 3
  %563 = insertelement <64 x bfloat> %562, bfloat %440, i64 4
  %564 = insertelement <64 x bfloat> %563, bfloat %442, i64 5
  %565 = insertelement <64 x bfloat> %564, bfloat %444, i64 6
  %566 = insertelement <64 x bfloat> %565, bfloat %446, i64 7
  %567 = insertelement <64 x bfloat> %566, bfloat %448, i64 8
  %568 = insertelement <64 x bfloat> %567, bfloat %450, i64 9
  %569 = insertelement <64 x bfloat> %568, bfloat %452, i64 10
  %570 = insertelement <64 x bfloat> %569, bfloat %454, i64 11
  %571 = insertelement <64 x bfloat> %570, bfloat %456, i64 12
  %572 = insertelement <64 x bfloat> %571, bfloat %458, i64 13
  %573 = insertelement <64 x bfloat> %572, bfloat %460, i64 14
  %574 = insertelement <64 x bfloat> %573, bfloat %462, i64 15
  %575 = insertelement <64 x bfloat> %574, bfloat %464, i64 16
  %576 = insertelement <64 x bfloat> %575, bfloat %466, i64 17
  %577 = insertelement <64 x bfloat> %576, bfloat %468, i64 18
  %578 = insertelement <64 x bfloat> %577, bfloat %470, i64 19
  %579 = insertelement <64 x bfloat> %578, bfloat %472, i64 20
  %580 = insertelement <64 x bfloat> %579, bfloat %474, i64 21
  %581 = insertelement <64 x bfloat> %580, bfloat %476, i64 22
  %582 = insertelement <64 x bfloat> %581, bfloat %478, i64 23
  %583 = insertelement <64 x bfloat> %582, bfloat %480, i64 24
  %584 = insertelement <64 x bfloat> %583, bfloat %482, i64 25
  %585 = insertelement <64 x bfloat> %584, bfloat %484, i64 26
  %586 = insertelement <64 x bfloat> %585, bfloat %486, i64 27
  %587 = insertelement <64 x bfloat> %586, bfloat %488, i64 28
  %588 = insertelement <64 x bfloat> %587, bfloat %490, i64 29
  %589 = insertelement <64 x bfloat> %588, bfloat %492, i64 30
  %590 = insertelement <64 x bfloat> %589, bfloat %494, i64 31
  %591 = insertelement <64 x bfloat> %590, bfloat %496, i64 32
  %592 = insertelement <64 x bfloat> %591, bfloat %498, i64 33
  %593 = insertelement <64 x bfloat> %592, bfloat %500, i64 34
  %594 = insertelement <64 x bfloat> %593, bfloat %502, i64 35
  %595 = insertelement <64 x bfloat> %594, bfloat %504, i64 36
  %596 = insertelement <64 x bfloat> %595, bfloat %506, i64 37
  %597 = insertelement <64 x bfloat> %596, bfloat %508, i64 38
  %598 = insertelement <64 x bfloat> %597, bfloat %510, i64 39
  %599 = insertelement <64 x bfloat> %598, bfloat %512, i64 40
  %600 = insertelement <64 x bfloat> %599, bfloat %514, i64 41
  %601 = insertelement <64 x bfloat> %600, bfloat %516, i64 42
  %602 = insertelement <64 x bfloat> %601, bfloat %518, i64 43
  %603 = insertelement <64 x bfloat> %602, bfloat %520, i64 44
  %604 = insertelement <64 x bfloat> %603, bfloat %522, i64 45
  %605 = insertelement <64 x bfloat> %604, bfloat %524, i64 46
  %606 = insertelement <64 x bfloat> %605, bfloat %526, i64 47
  %607 = insertelement <64 x bfloat> %606, bfloat %528, i64 48
  %608 = insertelement <64 x bfloat> %607, bfloat %530, i64 49
  %609 = insertelement <64 x bfloat> %608, bfloat %532, i64 50
  %610 = insertelement <64 x bfloat> %609, bfloat %534, i64 51
  %611 = insertelement <64 x bfloat> %610, bfloat %536, i64 52
  %612 = insertelement <64 x bfloat> %611, bfloat %538, i64 53
  %613 = insertelement <64 x bfloat> %612, bfloat %540, i64 54
  %614 = insertelement <64 x bfloat> %613, bfloat %542, i64 55
  %615 = insertelement <64 x bfloat> %614, bfloat %544, i64 56
  %616 = insertelement <64 x bfloat> %615, bfloat %546, i64 57
  %617 = insertelement <64 x bfloat> %616, bfloat %548, i64 58
  %618 = insertelement <64 x bfloat> %617, bfloat %550, i64 59
  %619 = insertelement <64 x bfloat> %618, bfloat %552, i64 60
  %620 = insertelement <64 x bfloat> %619, bfloat %554, i64 61
  %621 = insertelement <64 x bfloat> %620, bfloat %556, i64 62
  %622 = insertelement <64 x bfloat> %621, bfloat %558, i64 63
  %623 = shufflevector <64 x bfloat> %622, <64 x bfloat> %622, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %624 = shufflevector <32 x float> %82, <32 x float> %82, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %625 = bitcast <16 x bfloat> %431 to <16 x i16>
  %626 = bitcast <16 x bfloat> %623 to <16 x i16>
  %627 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %625, <16 x i16> %626, <8 x float> %624)
  %628 = shufflevector <8 x float> %627, <8 x float> %627, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %629 = shufflevector <32 x float> %628, <32 x float> %82, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %630 = shufflevector <64 x bfloat> %622, <64 x bfloat> %622, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %631 = shufflevector <32 x float> %629, <32 x float> %629, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %632 = bitcast <16 x bfloat> %630 to <16 x i16>
  %633 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %625, <16 x i16> %632, <8 x float> %631)
  %634 = shufflevector <8 x float> %633, <8 x float> %633, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %635 = shufflevector <32 x float> %634, <32 x float> %629, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %636 = shufflevector <64 x bfloat> %622, <64 x bfloat> %622, <16 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47>
  %637 = shufflevector <32 x float> %635, <32 x float> %635, <8 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %638 = bitcast <16 x bfloat> %636 to <16 x i16>
  %639 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %625, <16 x i16> %638, <8 x float> %637)
  %640 = shufflevector <8 x float> %639, <8 x float> %639, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %641 = shufflevector <32 x float> %640, <32 x float> %635, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %642 = shufflevector <64 x bfloat> %622, <64 x bfloat> %622, <16 x i32> <i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %643 = shufflevector <32 x float> %641, <32 x float> %641, <8 x i32> <i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %644 = bitcast <16 x bfloat> %642 to <16 x i16>
  %645 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %625, <16 x i16> %644, <8 x float> %643)
  fence syncscope("wavefront") release, !mmra !2
  call void @llvm.amdgcn.wave.barrier()
  fence syncscope("wavefront") acquire, !mmra !2
  %646 = extractelement <8 x float> %627, i64 0
  %647 = fptrunc float %646 to bfloat
  %648 = extractelement <8 x float> %627, i64 1
  %649 = fptrunc float %648 to bfloat
  %650 = extractelement <8 x float> %627, i64 2
  %651 = fptrunc float %650 to bfloat
  %652 = extractelement <8 x float> %627, i64 3
  %653 = fptrunc float %652 to bfloat
  %654 = extractelement <8 x float> %627, i64 4
  %655 = fptrunc float %654 to bfloat
  %656 = extractelement <8 x float> %627, i64 5
  %657 = fptrunc float %656 to bfloat
  %658 = extractelement <8 x float> %627, i64 6
  %659 = fptrunc float %658 to bfloat
  %660 = extractelement <8 x float> %627, i64 7
  %661 = fptrunc float %660 to bfloat
  %662 = extractelement <8 x float> %633, i64 0
  %663 = fptrunc float %662 to bfloat
  %664 = extractelement <8 x float> %633, i64 1
  %665 = fptrunc float %664 to bfloat
  %666 = extractelement <8 x float> %633, i64 2
  %667 = fptrunc float %666 to bfloat
  %668 = extractelement <8 x float> %633, i64 3
  %669 = fptrunc float %668 to bfloat
  %670 = extractelement <8 x float> %633, i64 4
  %671 = fptrunc float %670 to bfloat
  %672 = extractelement <8 x float> %633, i64 5
  %673 = fptrunc float %672 to bfloat
  %674 = extractelement <8 x float> %633, i64 6
  %675 = fptrunc float %674 to bfloat
  %676 = extractelement <8 x float> %633, i64 7
  %677 = fptrunc float %676 to bfloat
  %678 = extractelement <8 x float> %639, i64 0
  %679 = fptrunc float %678 to bfloat
  %680 = extractelement <8 x float> %639, i64 1
  %681 = fptrunc float %680 to bfloat
  %682 = extractelement <8 x float> %639, i64 2
  %683 = fptrunc float %682 to bfloat
  %684 = extractelement <8 x float> %639, i64 3
  %685 = fptrunc float %684 to bfloat
  %686 = extractelement <8 x float> %639, i64 4
  %687 = fptrunc float %686 to bfloat
  %688 = extractelement <8 x float> %639, i64 5
  %689 = fptrunc float %688 to bfloat
  %690 = extractelement <8 x float> %639, i64 6
  %691 = fptrunc float %690 to bfloat
  %692 = extractelement <8 x float> %639, i64 7
  %693 = fptrunc float %692 to bfloat
  %694 = extractelement <8 x float> %645, i64 0
  %695 = fptrunc float %694 to bfloat
  %696 = extractelement <8 x float> %645, i64 1
  %697 = fptrunc float %696 to bfloat
  %698 = extractelement <8 x float> %645, i64 2
  %699 = fptrunc float %698 to bfloat
  %700 = extractelement <8 x float> %645, i64 3
  %701 = fptrunc float %700 to bfloat
  %702 = extractelement <8 x float> %645, i64 4
  %703 = fptrunc float %702 to bfloat
  %704 = extractelement <8 x float> %645, i64 5
  %705 = fptrunc float %704 to bfloat
  %706 = extractelement <8 x float> %645, i64 6
  %707 = fptrunc float %706 to bfloat
  %708 = extractelement <8 x float> %645, i64 7
  %709 = fptrunc float %708 to bfloat
  %710 = sdiv i32 %22, 16
  %711 = mul i32 %710, 4096
  %712 = add i32 %379, %711
  %713 = add i32 %37, %712
  %714 = mul i32 %713, 2
  %715 = bitcast bfloat %647 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %715, ptr addrspace(8) %30, i32 %714, i32 0, i32 0)
  %716 = add i32 %713, 8192
  %717 = mul i32 %716, 2
  %718 = bitcast bfloat %649 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %718, ptr addrspace(8) %30, i32 %717, i32 0, i32 0)
  %719 = add i32 %713, 16384
  %720 = mul i32 %719, 2
  %721 = bitcast bfloat %651 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %721, ptr addrspace(8) %30, i32 %720, i32 0, i32 0)
  %722 = add i32 %713, 24576
  %723 = mul i32 %722, 2
  %724 = bitcast bfloat %653 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %724, ptr addrspace(8) %30, i32 %723, i32 0, i32 0)
  %725 = add i32 %713, 32768
  %726 = mul i32 %725, 2
  %727 = bitcast bfloat %655 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %727, ptr addrspace(8) %30, i32 %726, i32 0, i32 0)
  %728 = add i32 %713, 40960
  %729 = mul i32 %728, 2
  %730 = bitcast bfloat %657 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %730, ptr addrspace(8) %30, i32 %729, i32 0, i32 0)
  %731 = add i32 %713, 49152
  %732 = mul i32 %731, 2
  %733 = bitcast bfloat %659 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %733, ptr addrspace(8) %30, i32 %732, i32 0, i32 0)
  %734 = add i32 %713, 57344
  %735 = mul i32 %734, 2
  %736 = bitcast bfloat %661 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %736, ptr addrspace(8) %30, i32 %735, i32 0, i32 0)
  %737 = add i32 %713, 16
  %738 = mul i32 %737, 2
  %739 = bitcast bfloat %663 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %739, ptr addrspace(8) %30, i32 %738, i32 0, i32 0)
  %740 = add i32 %713, 8208
  %741 = mul i32 %740, 2
  %742 = bitcast bfloat %665 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %742, ptr addrspace(8) %30, i32 %741, i32 0, i32 0)
  %743 = add i32 %713, 16400
  %744 = mul i32 %743, 2
  %745 = bitcast bfloat %667 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %745, ptr addrspace(8) %30, i32 %744, i32 0, i32 0)
  %746 = add i32 %713, 24592
  %747 = mul i32 %746, 2
  %748 = bitcast bfloat %669 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %748, ptr addrspace(8) %30, i32 %747, i32 0, i32 0)
  %749 = add i32 %713, 32784
  %750 = mul i32 %749, 2
  %751 = bitcast bfloat %671 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %751, ptr addrspace(8) %30, i32 %750, i32 0, i32 0)
  %752 = add i32 %713, 40976
  %753 = mul i32 %752, 2
  %754 = bitcast bfloat %673 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %754, ptr addrspace(8) %30, i32 %753, i32 0, i32 0)
  %755 = add i32 %713, 49168
  %756 = mul i32 %755, 2
  %757 = bitcast bfloat %675 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %757, ptr addrspace(8) %30, i32 %756, i32 0, i32 0)
  %758 = add i32 %713, 57360
  %759 = mul i32 %758, 2
  %760 = bitcast bfloat %677 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %760, ptr addrspace(8) %30, i32 %759, i32 0, i32 0)
  %761 = add i32 %713, 32
  %762 = mul i32 %761, 2
  %763 = bitcast bfloat %679 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %763, ptr addrspace(8) %30, i32 %762, i32 0, i32 0)
  %764 = add i32 %713, 8224
  %765 = mul i32 %764, 2
  %766 = bitcast bfloat %681 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %766, ptr addrspace(8) %30, i32 %765, i32 0, i32 0)
  %767 = add i32 %713, 16416
  %768 = mul i32 %767, 2
  %769 = bitcast bfloat %683 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %769, ptr addrspace(8) %30, i32 %768, i32 0, i32 0)
  %770 = add i32 %713, 24608
  %771 = mul i32 %770, 2
  %772 = bitcast bfloat %685 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %772, ptr addrspace(8) %30, i32 %771, i32 0, i32 0)
  %773 = add i32 %713, 32800
  %774 = mul i32 %773, 2
  %775 = bitcast bfloat %687 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %775, ptr addrspace(8) %30, i32 %774, i32 0, i32 0)
  %776 = add i32 %713, 40992
  %777 = mul i32 %776, 2
  %778 = bitcast bfloat %689 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %778, ptr addrspace(8) %30, i32 %777, i32 0, i32 0)
  %779 = add i32 %713, 49184
  %780 = mul i32 %779, 2
  %781 = bitcast bfloat %691 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %781, ptr addrspace(8) %30, i32 %780, i32 0, i32 0)
  %782 = add i32 %713, 57376
  %783 = mul i32 %782, 2
  %784 = bitcast bfloat %693 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %784, ptr addrspace(8) %30, i32 %783, i32 0, i32 0)
  %785 = add i32 %713, 48
  %786 = mul i32 %785, 2
  %787 = bitcast bfloat %695 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %787, ptr addrspace(8) %30, i32 %786, i32 0, i32 0)
  %788 = add i32 %713, 8240
  %789 = mul i32 %788, 2
  %790 = bitcast bfloat %697 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %790, ptr addrspace(8) %30, i32 %789, i32 0, i32 0)
  %791 = add i32 %713, 16432
  %792 = mul i32 %791, 2
  %793 = bitcast bfloat %699 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %793, ptr addrspace(8) %30, i32 %792, i32 0, i32 0)
  %794 = add i32 %713, 24624
  %795 = mul i32 %794, 2
  %796 = bitcast bfloat %701 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %796, ptr addrspace(8) %30, i32 %795, i32 0, i32 0)
  %797 = add i32 %713, 32816
  %798 = mul i32 %797, 2
  %799 = bitcast bfloat %703 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %799, ptr addrspace(8) %30, i32 %798, i32 0, i32 0)
  %800 = add i32 %713, 41008
  %801 = mul i32 %800, 2
  %802 = bitcast bfloat %705 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %802, ptr addrspace(8) %30, i32 %801, i32 0, i32 0)
  %803 = add i32 %713, 49200
  %804 = mul i32 %803, 2
  %805 = bitcast bfloat %707 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %805, ptr addrspace(8) %30, i32 %804, i32 0, i32 0)
  %806 = add i32 %713, 57392
  %807 = mul i32 %806, 2
  %808 = bitcast bfloat %709 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %808, ptr addrspace(8) %30, i32 %807, i32 0, i32 0)
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef range(i32 0, 1024) i32 @llvm.amdgcn.workitem.id.x() #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare noundef i32 @llvm.amdgcn.workgroup.id.x() #1

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) readnone, i16, i64, i32) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: read)
declare i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) readonly captures(none), i32, i32, i32 immarg) #3

; Function Attrs: convergent nocallback nofree nounwind willreturn
declare void @llvm.amdgcn.wave.barrier() #4

; Function Attrs: convergent nocallback nocreateundeforpoison nofree nounwind willreturn memory(none)
declare <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16>, <16 x i16>, <8 x float>) #5

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: write)
declare void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16, ptr addrspace(8) writeonly captures(none), i32, i32, i32 immarg) #6

attributes #0 = { "amdgpu-flat-work-group-size"="64,64" "uniform-work-group-size" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { nocallback nofree nosync nounwind willreturn memory(argmem: read) }
attributes #4 = { convergent nocallback nofree nounwind willreturn }
attributes #5 = { convergent nocallback nocreateundeforpoison nofree nounwind willreturn memory(none) }
attributes #6 = { nocallback nofree nosync nounwind willreturn memory(argmem: write) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{i32 64, i32 1, i32 1}
!2 = !{!"amdgpu-synchronize-as", !"local"}
