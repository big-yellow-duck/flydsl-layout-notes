; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target datalayout = "e-p:64:64-p1:64:64-p2:32:32-p3:32:32-p4:64:64-p5:32:32-p6:32:32-p7:160:256:256:32-p8:128:128:128:48-p9:192:256:256:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-v2048:2048-n32:64-S32-A5-G1-ni:7:8:9"

@__shared_alloc_1 = external dso_local addrspace(3) global [2048 x i8], align 16
@__shared_alloc_0 = external dso_local addrspace(3) global [768 x i8], align 16

define amdgpu_kernel void @exercise_kernel_0(ptr addrspace(1) %0, <{ <{ i32, i32 }>, <{ i64 }> }> %1, ptr addrspace(1) %2, <{ <{ i32, i32 }>, <{ i64 }> }> %3, ptr addrspace(1) %4, <{ <{ i32, i32 }>, <{ i64 }> }> %5, ptr addrspace(1) %6, <{ <{ i32 }> }> %7, ptr addrspace(1) %8, <{ <{ i32 }> }> %9) #0 !reqd_work_group_size !1 {
  %11 = call range(i32 0, 32) i32 @llvm.amdgcn.workitem.id.x()
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
  %26 = add i32 %25, %21
  %27 = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) %0, i16 0, i64 4294967295, i32 553807872)
  %28 = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) %2, i16 0, i64 4294967295, i32 553807872)
  %29 = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) %4, i16 0, i64 4294967295, i32 553807872)
  %30 = srem i32 %26, 64
  %31 = srem i32 %30, 64
  %32 = sdiv i32 %30, 64
  %33 = mul i32 %32, 64
  %34 = add i32 %31, %33
  %35 = srem i32 %34, 64
  %36 = mul i32 %35, 64
  %37 = mul i32 %21, 384
  %38 = mul i32 %21, 1024
  %39 = srem i32 %22, 2
  %40 = sdiv i32 %22, 2
  %41 = mul i32 %39, 8
  %42 = mul i32 %40, 24
  %43 = add i32 %41, %42
  %44 = add i32 %37, %43
  %45 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %44
  %46 = srem i32 %22, 8
  %47 = sdiv i32 %22, 8
  %48 = mul i32 %46, 8
  %49 = mul i32 %47, 64
  %50 = add i32 %48, %49
  %51 = add i32 %38, %50
  %52 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %51
  %53 = mul i32 %40, 8192
  %54 = add i32 %41, %53
  %55 = mul i32 %47, 4096
  %56 = add i32 %48, %55
  %57 = add i32 %36, %56
  %58 = mul i32 %54, 2
  %59 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %27, i32 %58, i32 0, i32 0)
  %60 = bitcast i128 %59 to <8 x bfloat>
  %61 = mul i32 %57, 2
  %62 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %28, i32 %61, i32 0, i32 0)
  %63 = bitcast i128 %62 to <8 x bfloat>
  %64 = add i32 %57, 16384
  %65 = mul i32 %64, 2
  %66 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %28, i32 %65, i32 0, i32 0)
  %67 = bitcast i128 %66 to <8 x bfloat>
  %68 = add i32 %57, 32768
  %69 = mul i32 %68, 2
  %70 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %28, i32 %69, i32 0, i32 0)
  %71 = bitcast i128 %70 to <8 x bfloat>
  %72 = add i32 %57, 49152
  %73 = mul i32 %72, 2
  %74 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %28, i32 %73, i32 0, i32 0)
  %75 = bitcast i128 %74 to <8 x bfloat>
  store <8 x bfloat> %60, ptr addrspace(3) %45, align 16
  store <8 x bfloat> %63, ptr addrspace(3) %52, align 16
  %76 = getelementptr bfloat, ptr addrspace(3) %52, i32 256
  store <8 x bfloat> %67, ptr addrspace(3) %76, align 16
  %77 = getelementptr bfloat, ptr addrspace(3) %52, i32 512
  store <8 x bfloat> %71, ptr addrspace(3) %77, align 16
  %78 = getelementptr bfloat, ptr addrspace(3) %52, i32 768
  store <8 x bfloat> %75, ptr addrspace(3) %78, align 16
  fence syncscope("workgroup") release
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire
  br label %79

79:                                               ; preds = %83, %10
  %80 = phi i32 [ %84, %83 ], [ 0, %10 ]
  %81 = phi <32 x float> [ %376, %83 ], [ zeroinitializer, %10 ]
  %82 = icmp slt i32 %80, 511
  br i1 %82, label %83, label %377

83:                                               ; preds = %79
  %84 = add i32 %80, 1
  %85 = mul i32 %84, 16
  %86 = mul i32 %84, 65536
  %87 = add i32 %86, %36
  %88 = add i32 %85, %54
  %89 = add i32 %87, %56
  %90 = mul i32 %88, 2
  %91 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %27, i32 %90, i32 0, i32 0)
  %92 = bitcast i128 %91 to <8 x bfloat>
  %93 = mul i32 %89, 2
  %94 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %28, i32 %93, i32 0, i32 0)
  %95 = bitcast i128 %94 to <8 x bfloat>
  %96 = add i32 %89, 16384
  %97 = mul i32 %96, 2
  %98 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %28, i32 %97, i32 0, i32 0)
  %99 = bitcast i128 %98 to <8 x bfloat>
  %100 = add i32 %89, 32768
  %101 = mul i32 %100, 2
  %102 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %28, i32 %101, i32 0, i32 0)
  %103 = bitcast i128 %102 to <8 x bfloat>
  %104 = add i32 %89, 49152
  %105 = mul i32 %104, 2
  %106 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %28, i32 %105, i32 0, i32 0)
  %107 = bitcast i128 %106 to <8 x bfloat>
  %108 = srem i32 %22, 16
  %109 = mul i32 %108, 24
  %110 = add i32 %37, %109
  %111 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %110
  %112 = add i32 %38, %108
  %113 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %112
  %114 = load bfloat, ptr addrspace(3) %111, align 2
  %115 = getelementptr bfloat, ptr addrspace(3) %111, i32 1
  %116 = load bfloat, ptr addrspace(3) %115, align 2
  %117 = getelementptr bfloat, ptr addrspace(3) %111, i32 2
  %118 = load bfloat, ptr addrspace(3) %117, align 2
  %119 = getelementptr bfloat, ptr addrspace(3) %111, i32 3
  %120 = load bfloat, ptr addrspace(3) %119, align 2
  %121 = getelementptr bfloat, ptr addrspace(3) %111, i32 4
  %122 = load bfloat, ptr addrspace(3) %121, align 2
  %123 = getelementptr bfloat, ptr addrspace(3) %111, i32 5
  %124 = load bfloat, ptr addrspace(3) %123, align 2
  %125 = getelementptr bfloat, ptr addrspace(3) %111, i32 6
  %126 = load bfloat, ptr addrspace(3) %125, align 2
  %127 = getelementptr bfloat, ptr addrspace(3) %111, i32 7
  %128 = load bfloat, ptr addrspace(3) %127, align 2
  %129 = getelementptr bfloat, ptr addrspace(3) %111, i32 8
  %130 = load bfloat, ptr addrspace(3) %129, align 2
  %131 = getelementptr bfloat, ptr addrspace(3) %111, i32 9
  %132 = load bfloat, ptr addrspace(3) %131, align 2
  %133 = getelementptr bfloat, ptr addrspace(3) %111, i32 10
  %134 = load bfloat, ptr addrspace(3) %133, align 2
  %135 = getelementptr bfloat, ptr addrspace(3) %111, i32 11
  %136 = load bfloat, ptr addrspace(3) %135, align 2
  %137 = getelementptr bfloat, ptr addrspace(3) %111, i32 12
  %138 = load bfloat, ptr addrspace(3) %137, align 2
  %139 = getelementptr bfloat, ptr addrspace(3) %111, i32 13
  %140 = load bfloat, ptr addrspace(3) %139, align 2
  %141 = getelementptr bfloat, ptr addrspace(3) %111, i32 14
  %142 = load bfloat, ptr addrspace(3) %141, align 2
  %143 = getelementptr bfloat, ptr addrspace(3) %111, i32 15
  %144 = load bfloat, ptr addrspace(3) %143, align 2
  %145 = insertelement <16 x bfloat> poison, bfloat %114, i64 0
  %146 = insertelement <16 x bfloat> %145, bfloat %116, i64 1
  %147 = insertelement <16 x bfloat> %146, bfloat %118, i64 2
  %148 = insertelement <16 x bfloat> %147, bfloat %120, i64 3
  %149 = insertelement <16 x bfloat> %148, bfloat %122, i64 4
  %150 = insertelement <16 x bfloat> %149, bfloat %124, i64 5
  %151 = insertelement <16 x bfloat> %150, bfloat %126, i64 6
  %152 = insertelement <16 x bfloat> %151, bfloat %128, i64 7
  %153 = insertelement <16 x bfloat> %152, bfloat %130, i64 8
  %154 = insertelement <16 x bfloat> %153, bfloat %132, i64 9
  %155 = insertelement <16 x bfloat> %154, bfloat %134, i64 10
  %156 = insertelement <16 x bfloat> %155, bfloat %136, i64 11
  %157 = insertelement <16 x bfloat> %156, bfloat %138, i64 12
  %158 = insertelement <16 x bfloat> %157, bfloat %140, i64 13
  %159 = insertelement <16 x bfloat> %158, bfloat %142, i64 14
  %160 = insertelement <16 x bfloat> %159, bfloat %144, i64 15
  %161 = load bfloat, ptr addrspace(3) %113, align 2
  %162 = getelementptr bfloat, ptr addrspace(3) %113, i32 64
  %163 = load bfloat, ptr addrspace(3) %162, align 2
  %164 = getelementptr bfloat, ptr addrspace(3) %113, i32 128
  %165 = load bfloat, ptr addrspace(3) %164, align 2
  %166 = getelementptr bfloat, ptr addrspace(3) %113, i32 192
  %167 = load bfloat, ptr addrspace(3) %166, align 2
  %168 = getelementptr bfloat, ptr addrspace(3) %113, i32 256
  %169 = load bfloat, ptr addrspace(3) %168, align 2
  %170 = getelementptr bfloat, ptr addrspace(3) %113, i32 320
  %171 = load bfloat, ptr addrspace(3) %170, align 2
  %172 = getelementptr bfloat, ptr addrspace(3) %113, i32 384
  %173 = load bfloat, ptr addrspace(3) %172, align 2
  %174 = getelementptr bfloat, ptr addrspace(3) %113, i32 448
  %175 = load bfloat, ptr addrspace(3) %174, align 2
  %176 = getelementptr bfloat, ptr addrspace(3) %113, i32 512
  %177 = load bfloat, ptr addrspace(3) %176, align 2
  %178 = getelementptr bfloat, ptr addrspace(3) %113, i32 576
  %179 = load bfloat, ptr addrspace(3) %178, align 2
  %180 = getelementptr bfloat, ptr addrspace(3) %113, i32 640
  %181 = load bfloat, ptr addrspace(3) %180, align 2
  %182 = getelementptr bfloat, ptr addrspace(3) %113, i32 704
  %183 = load bfloat, ptr addrspace(3) %182, align 2
  %184 = getelementptr bfloat, ptr addrspace(3) %113, i32 768
  %185 = load bfloat, ptr addrspace(3) %184, align 2
  %186 = getelementptr bfloat, ptr addrspace(3) %113, i32 832
  %187 = load bfloat, ptr addrspace(3) %186, align 2
  %188 = getelementptr bfloat, ptr addrspace(3) %113, i32 896
  %189 = load bfloat, ptr addrspace(3) %188, align 2
  %190 = getelementptr bfloat, ptr addrspace(3) %113, i32 960
  %191 = load bfloat, ptr addrspace(3) %190, align 2
  %192 = getelementptr bfloat, ptr addrspace(3) %113, i32 16
  %193 = load bfloat, ptr addrspace(3) %192, align 2
  %194 = getelementptr bfloat, ptr addrspace(3) %113, i32 80
  %195 = load bfloat, ptr addrspace(3) %194, align 2
  %196 = getelementptr bfloat, ptr addrspace(3) %113, i32 144
  %197 = load bfloat, ptr addrspace(3) %196, align 2
  %198 = getelementptr bfloat, ptr addrspace(3) %113, i32 208
  %199 = load bfloat, ptr addrspace(3) %198, align 2
  %200 = getelementptr bfloat, ptr addrspace(3) %113, i32 272
  %201 = load bfloat, ptr addrspace(3) %200, align 2
  %202 = getelementptr bfloat, ptr addrspace(3) %113, i32 336
  %203 = load bfloat, ptr addrspace(3) %202, align 2
  %204 = getelementptr bfloat, ptr addrspace(3) %113, i32 400
  %205 = load bfloat, ptr addrspace(3) %204, align 2
  %206 = getelementptr bfloat, ptr addrspace(3) %113, i32 464
  %207 = load bfloat, ptr addrspace(3) %206, align 2
  %208 = getelementptr bfloat, ptr addrspace(3) %113, i32 528
  %209 = load bfloat, ptr addrspace(3) %208, align 2
  %210 = getelementptr bfloat, ptr addrspace(3) %113, i32 592
  %211 = load bfloat, ptr addrspace(3) %210, align 2
  %212 = getelementptr bfloat, ptr addrspace(3) %113, i32 656
  %213 = load bfloat, ptr addrspace(3) %212, align 2
  %214 = getelementptr bfloat, ptr addrspace(3) %113, i32 720
  %215 = load bfloat, ptr addrspace(3) %214, align 2
  %216 = getelementptr bfloat, ptr addrspace(3) %113, i32 784
  %217 = load bfloat, ptr addrspace(3) %216, align 2
  %218 = getelementptr bfloat, ptr addrspace(3) %113, i32 848
  %219 = load bfloat, ptr addrspace(3) %218, align 2
  %220 = getelementptr bfloat, ptr addrspace(3) %113, i32 912
  %221 = load bfloat, ptr addrspace(3) %220, align 2
  %222 = getelementptr bfloat, ptr addrspace(3) %113, i32 976
  %223 = load bfloat, ptr addrspace(3) %222, align 2
  %224 = getelementptr bfloat, ptr addrspace(3) %113, i32 32
  %225 = load bfloat, ptr addrspace(3) %224, align 2
  %226 = getelementptr bfloat, ptr addrspace(3) %113, i32 96
  %227 = load bfloat, ptr addrspace(3) %226, align 2
  %228 = getelementptr bfloat, ptr addrspace(3) %113, i32 160
  %229 = load bfloat, ptr addrspace(3) %228, align 2
  %230 = getelementptr bfloat, ptr addrspace(3) %113, i32 224
  %231 = load bfloat, ptr addrspace(3) %230, align 2
  %232 = getelementptr bfloat, ptr addrspace(3) %113, i32 288
  %233 = load bfloat, ptr addrspace(3) %232, align 2
  %234 = getelementptr bfloat, ptr addrspace(3) %113, i32 352
  %235 = load bfloat, ptr addrspace(3) %234, align 2
  %236 = getelementptr bfloat, ptr addrspace(3) %113, i32 416
  %237 = load bfloat, ptr addrspace(3) %236, align 2
  %238 = getelementptr bfloat, ptr addrspace(3) %113, i32 480
  %239 = load bfloat, ptr addrspace(3) %238, align 2
  %240 = getelementptr bfloat, ptr addrspace(3) %113, i32 544
  %241 = load bfloat, ptr addrspace(3) %240, align 2
  %242 = getelementptr bfloat, ptr addrspace(3) %113, i32 608
  %243 = load bfloat, ptr addrspace(3) %242, align 2
  %244 = getelementptr bfloat, ptr addrspace(3) %113, i32 672
  %245 = load bfloat, ptr addrspace(3) %244, align 2
  %246 = getelementptr bfloat, ptr addrspace(3) %113, i32 736
  %247 = load bfloat, ptr addrspace(3) %246, align 2
  %248 = getelementptr bfloat, ptr addrspace(3) %113, i32 800
  %249 = load bfloat, ptr addrspace(3) %248, align 2
  %250 = getelementptr bfloat, ptr addrspace(3) %113, i32 864
  %251 = load bfloat, ptr addrspace(3) %250, align 2
  %252 = getelementptr bfloat, ptr addrspace(3) %113, i32 928
  %253 = load bfloat, ptr addrspace(3) %252, align 2
  %254 = getelementptr bfloat, ptr addrspace(3) %113, i32 992
  %255 = load bfloat, ptr addrspace(3) %254, align 2
  %256 = getelementptr bfloat, ptr addrspace(3) %113, i32 48
  %257 = load bfloat, ptr addrspace(3) %256, align 2
  %258 = getelementptr bfloat, ptr addrspace(3) %113, i32 112
  %259 = load bfloat, ptr addrspace(3) %258, align 2
  %260 = getelementptr bfloat, ptr addrspace(3) %113, i32 176
  %261 = load bfloat, ptr addrspace(3) %260, align 2
  %262 = getelementptr bfloat, ptr addrspace(3) %113, i32 240
  %263 = load bfloat, ptr addrspace(3) %262, align 2
  %264 = getelementptr bfloat, ptr addrspace(3) %113, i32 304
  %265 = load bfloat, ptr addrspace(3) %264, align 2
  %266 = getelementptr bfloat, ptr addrspace(3) %113, i32 368
  %267 = load bfloat, ptr addrspace(3) %266, align 2
  %268 = getelementptr bfloat, ptr addrspace(3) %113, i32 432
  %269 = load bfloat, ptr addrspace(3) %268, align 2
  %270 = getelementptr bfloat, ptr addrspace(3) %113, i32 496
  %271 = load bfloat, ptr addrspace(3) %270, align 2
  %272 = getelementptr bfloat, ptr addrspace(3) %113, i32 560
  %273 = load bfloat, ptr addrspace(3) %272, align 2
  %274 = getelementptr bfloat, ptr addrspace(3) %113, i32 624
  %275 = load bfloat, ptr addrspace(3) %274, align 2
  %276 = getelementptr bfloat, ptr addrspace(3) %113, i32 688
  %277 = load bfloat, ptr addrspace(3) %276, align 2
  %278 = getelementptr bfloat, ptr addrspace(3) %113, i32 752
  %279 = load bfloat, ptr addrspace(3) %278, align 2
  %280 = getelementptr bfloat, ptr addrspace(3) %113, i32 816
  %281 = load bfloat, ptr addrspace(3) %280, align 2
  %282 = getelementptr bfloat, ptr addrspace(3) %113, i32 880
  %283 = load bfloat, ptr addrspace(3) %282, align 2
  %284 = getelementptr bfloat, ptr addrspace(3) %113, i32 944
  %285 = load bfloat, ptr addrspace(3) %284, align 2
  %286 = getelementptr bfloat, ptr addrspace(3) %113, i32 1008
  %287 = load bfloat, ptr addrspace(3) %286, align 2
  %288 = insertelement <64 x bfloat> poison, bfloat %161, i64 0
  %289 = insertelement <64 x bfloat> %288, bfloat %163, i64 1
  %290 = insertelement <64 x bfloat> %289, bfloat %165, i64 2
  %291 = insertelement <64 x bfloat> %290, bfloat %167, i64 3
  %292 = insertelement <64 x bfloat> %291, bfloat %169, i64 4
  %293 = insertelement <64 x bfloat> %292, bfloat %171, i64 5
  %294 = insertelement <64 x bfloat> %293, bfloat %173, i64 6
  %295 = insertelement <64 x bfloat> %294, bfloat %175, i64 7
  %296 = insertelement <64 x bfloat> %295, bfloat %177, i64 8
  %297 = insertelement <64 x bfloat> %296, bfloat %179, i64 9
  %298 = insertelement <64 x bfloat> %297, bfloat %181, i64 10
  %299 = insertelement <64 x bfloat> %298, bfloat %183, i64 11
  %300 = insertelement <64 x bfloat> %299, bfloat %185, i64 12
  %301 = insertelement <64 x bfloat> %300, bfloat %187, i64 13
  %302 = insertelement <64 x bfloat> %301, bfloat %189, i64 14
  %303 = insertelement <64 x bfloat> %302, bfloat %191, i64 15
  %304 = insertelement <64 x bfloat> %303, bfloat %193, i64 16
  %305 = insertelement <64 x bfloat> %304, bfloat %195, i64 17
  %306 = insertelement <64 x bfloat> %305, bfloat %197, i64 18
  %307 = insertelement <64 x bfloat> %306, bfloat %199, i64 19
  %308 = insertelement <64 x bfloat> %307, bfloat %201, i64 20
  %309 = insertelement <64 x bfloat> %308, bfloat %203, i64 21
  %310 = insertelement <64 x bfloat> %309, bfloat %205, i64 22
  %311 = insertelement <64 x bfloat> %310, bfloat %207, i64 23
  %312 = insertelement <64 x bfloat> %311, bfloat %209, i64 24
  %313 = insertelement <64 x bfloat> %312, bfloat %211, i64 25
  %314 = insertelement <64 x bfloat> %313, bfloat %213, i64 26
  %315 = insertelement <64 x bfloat> %314, bfloat %215, i64 27
  %316 = insertelement <64 x bfloat> %315, bfloat %217, i64 28
  %317 = insertelement <64 x bfloat> %316, bfloat %219, i64 29
  %318 = insertelement <64 x bfloat> %317, bfloat %221, i64 30
  %319 = insertelement <64 x bfloat> %318, bfloat %223, i64 31
  %320 = insertelement <64 x bfloat> %319, bfloat %225, i64 32
  %321 = insertelement <64 x bfloat> %320, bfloat %227, i64 33
  %322 = insertelement <64 x bfloat> %321, bfloat %229, i64 34
  %323 = insertelement <64 x bfloat> %322, bfloat %231, i64 35
  %324 = insertelement <64 x bfloat> %323, bfloat %233, i64 36
  %325 = insertelement <64 x bfloat> %324, bfloat %235, i64 37
  %326 = insertelement <64 x bfloat> %325, bfloat %237, i64 38
  %327 = insertelement <64 x bfloat> %326, bfloat %239, i64 39
  %328 = insertelement <64 x bfloat> %327, bfloat %241, i64 40
  %329 = insertelement <64 x bfloat> %328, bfloat %243, i64 41
  %330 = insertelement <64 x bfloat> %329, bfloat %245, i64 42
  %331 = insertelement <64 x bfloat> %330, bfloat %247, i64 43
  %332 = insertelement <64 x bfloat> %331, bfloat %249, i64 44
  %333 = insertelement <64 x bfloat> %332, bfloat %251, i64 45
  %334 = insertelement <64 x bfloat> %333, bfloat %253, i64 46
  %335 = insertelement <64 x bfloat> %334, bfloat %255, i64 47
  %336 = insertelement <64 x bfloat> %335, bfloat %257, i64 48
  %337 = insertelement <64 x bfloat> %336, bfloat %259, i64 49
  %338 = insertelement <64 x bfloat> %337, bfloat %261, i64 50
  %339 = insertelement <64 x bfloat> %338, bfloat %263, i64 51
  %340 = insertelement <64 x bfloat> %339, bfloat %265, i64 52
  %341 = insertelement <64 x bfloat> %340, bfloat %267, i64 53
  %342 = insertelement <64 x bfloat> %341, bfloat %269, i64 54
  %343 = insertelement <64 x bfloat> %342, bfloat %271, i64 55
  %344 = insertelement <64 x bfloat> %343, bfloat %273, i64 56
  %345 = insertelement <64 x bfloat> %344, bfloat %275, i64 57
  %346 = insertelement <64 x bfloat> %345, bfloat %277, i64 58
  %347 = insertelement <64 x bfloat> %346, bfloat %279, i64 59
  %348 = insertelement <64 x bfloat> %347, bfloat %281, i64 60
  %349 = insertelement <64 x bfloat> %348, bfloat %283, i64 61
  %350 = insertelement <64 x bfloat> %349, bfloat %285, i64 62
  %351 = insertelement <64 x bfloat> %350, bfloat %287, i64 63
  %352 = shufflevector <64 x bfloat> %351, <64 x bfloat> %351, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %353 = shufflevector <32 x float> %81, <32 x float> %81, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %354 = bitcast <16 x bfloat> %160 to <16 x i16>
  %355 = bitcast <16 x bfloat> %352 to <16 x i16>
  %356 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %354, <16 x i16> %355, <8 x float> %353)
  %357 = shufflevector <8 x float> %356, <8 x float> %356, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %358 = shufflevector <32 x float> %357, <32 x float> %81, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %359 = shufflevector <64 x bfloat> %351, <64 x bfloat> %351, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %360 = shufflevector <32 x float> %358, <32 x float> %358, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %361 = bitcast <16 x bfloat> %359 to <16 x i16>
  %362 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %354, <16 x i16> %361, <8 x float> %360)
  %363 = shufflevector <8 x float> %362, <8 x float> %362, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %364 = shufflevector <32 x float> %363, <32 x float> %358, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %365 = shufflevector <64 x bfloat> %351, <64 x bfloat> %351, <16 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47>
  %366 = shufflevector <32 x float> %364, <32 x float> %364, <8 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %367 = bitcast <16 x bfloat> %365 to <16 x i16>
  %368 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %354, <16 x i16> %367, <8 x float> %366)
  %369 = shufflevector <8 x float> %368, <8 x float> %368, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %370 = shufflevector <32 x float> %369, <32 x float> %364, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %371 = shufflevector <64 x bfloat> %351, <64 x bfloat> %351, <16 x i32> <i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %372 = shufflevector <32 x float> %370, <32 x float> %370, <8 x i32> <i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %373 = bitcast <16 x bfloat> %371 to <16 x i16>
  %374 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %354, <16 x i16> %373, <8 x float> %372)
  %375 = shufflevector <8 x float> %374, <8 x float> %374, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %376 = shufflevector <32 x float> %375, <32 x float> %370, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  fence syncscope("workgroup") release
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire
  store <8 x bfloat> %92, ptr addrspace(3) %45, align 16
  store <8 x bfloat> %95, ptr addrspace(3) %52, align 16
  store <8 x bfloat> %99, ptr addrspace(3) %76, align 16
  store <8 x bfloat> %103, ptr addrspace(3) %77, align 16
  store <8 x bfloat> %107, ptr addrspace(3) %78, align 16
  fence syncscope("workgroup") release
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire
  br label %79

377:                                              ; preds = %79
  %378 = srem i32 %22, 16
  %379 = mul i32 %378, 24
  %380 = add i32 %37, %379
  %381 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %380
  %382 = add i32 %38, %378
  %383 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %382
  %384 = load bfloat, ptr addrspace(3) %381, align 2
  %385 = getelementptr bfloat, ptr addrspace(3) %381, i32 1
  %386 = load bfloat, ptr addrspace(3) %385, align 2
  %387 = getelementptr bfloat, ptr addrspace(3) %381, i32 2
  %388 = load bfloat, ptr addrspace(3) %387, align 2
  %389 = getelementptr bfloat, ptr addrspace(3) %381, i32 3
  %390 = load bfloat, ptr addrspace(3) %389, align 2
  %391 = getelementptr bfloat, ptr addrspace(3) %381, i32 4
  %392 = load bfloat, ptr addrspace(3) %391, align 2
  %393 = getelementptr bfloat, ptr addrspace(3) %381, i32 5
  %394 = load bfloat, ptr addrspace(3) %393, align 2
  %395 = getelementptr bfloat, ptr addrspace(3) %381, i32 6
  %396 = load bfloat, ptr addrspace(3) %395, align 2
  %397 = getelementptr bfloat, ptr addrspace(3) %381, i32 7
  %398 = load bfloat, ptr addrspace(3) %397, align 2
  %399 = getelementptr bfloat, ptr addrspace(3) %381, i32 8
  %400 = load bfloat, ptr addrspace(3) %399, align 2
  %401 = getelementptr bfloat, ptr addrspace(3) %381, i32 9
  %402 = load bfloat, ptr addrspace(3) %401, align 2
  %403 = getelementptr bfloat, ptr addrspace(3) %381, i32 10
  %404 = load bfloat, ptr addrspace(3) %403, align 2
  %405 = getelementptr bfloat, ptr addrspace(3) %381, i32 11
  %406 = load bfloat, ptr addrspace(3) %405, align 2
  %407 = getelementptr bfloat, ptr addrspace(3) %381, i32 12
  %408 = load bfloat, ptr addrspace(3) %407, align 2
  %409 = getelementptr bfloat, ptr addrspace(3) %381, i32 13
  %410 = load bfloat, ptr addrspace(3) %409, align 2
  %411 = getelementptr bfloat, ptr addrspace(3) %381, i32 14
  %412 = load bfloat, ptr addrspace(3) %411, align 2
  %413 = getelementptr bfloat, ptr addrspace(3) %381, i32 15
  %414 = load bfloat, ptr addrspace(3) %413, align 2
  %415 = insertelement <16 x bfloat> poison, bfloat %384, i64 0
  %416 = insertelement <16 x bfloat> %415, bfloat %386, i64 1
  %417 = insertelement <16 x bfloat> %416, bfloat %388, i64 2
  %418 = insertelement <16 x bfloat> %417, bfloat %390, i64 3
  %419 = insertelement <16 x bfloat> %418, bfloat %392, i64 4
  %420 = insertelement <16 x bfloat> %419, bfloat %394, i64 5
  %421 = insertelement <16 x bfloat> %420, bfloat %396, i64 6
  %422 = insertelement <16 x bfloat> %421, bfloat %398, i64 7
  %423 = insertelement <16 x bfloat> %422, bfloat %400, i64 8
  %424 = insertelement <16 x bfloat> %423, bfloat %402, i64 9
  %425 = insertelement <16 x bfloat> %424, bfloat %404, i64 10
  %426 = insertelement <16 x bfloat> %425, bfloat %406, i64 11
  %427 = insertelement <16 x bfloat> %426, bfloat %408, i64 12
  %428 = insertelement <16 x bfloat> %427, bfloat %410, i64 13
  %429 = insertelement <16 x bfloat> %428, bfloat %412, i64 14
  %430 = insertelement <16 x bfloat> %429, bfloat %414, i64 15
  %431 = load bfloat, ptr addrspace(3) %383, align 2
  %432 = getelementptr bfloat, ptr addrspace(3) %383, i32 64
  %433 = load bfloat, ptr addrspace(3) %432, align 2
  %434 = getelementptr bfloat, ptr addrspace(3) %383, i32 128
  %435 = load bfloat, ptr addrspace(3) %434, align 2
  %436 = getelementptr bfloat, ptr addrspace(3) %383, i32 192
  %437 = load bfloat, ptr addrspace(3) %436, align 2
  %438 = getelementptr bfloat, ptr addrspace(3) %383, i32 256
  %439 = load bfloat, ptr addrspace(3) %438, align 2
  %440 = getelementptr bfloat, ptr addrspace(3) %383, i32 320
  %441 = load bfloat, ptr addrspace(3) %440, align 2
  %442 = getelementptr bfloat, ptr addrspace(3) %383, i32 384
  %443 = load bfloat, ptr addrspace(3) %442, align 2
  %444 = getelementptr bfloat, ptr addrspace(3) %383, i32 448
  %445 = load bfloat, ptr addrspace(3) %444, align 2
  %446 = getelementptr bfloat, ptr addrspace(3) %383, i32 512
  %447 = load bfloat, ptr addrspace(3) %446, align 2
  %448 = getelementptr bfloat, ptr addrspace(3) %383, i32 576
  %449 = load bfloat, ptr addrspace(3) %448, align 2
  %450 = getelementptr bfloat, ptr addrspace(3) %383, i32 640
  %451 = load bfloat, ptr addrspace(3) %450, align 2
  %452 = getelementptr bfloat, ptr addrspace(3) %383, i32 704
  %453 = load bfloat, ptr addrspace(3) %452, align 2
  %454 = getelementptr bfloat, ptr addrspace(3) %383, i32 768
  %455 = load bfloat, ptr addrspace(3) %454, align 2
  %456 = getelementptr bfloat, ptr addrspace(3) %383, i32 832
  %457 = load bfloat, ptr addrspace(3) %456, align 2
  %458 = getelementptr bfloat, ptr addrspace(3) %383, i32 896
  %459 = load bfloat, ptr addrspace(3) %458, align 2
  %460 = getelementptr bfloat, ptr addrspace(3) %383, i32 960
  %461 = load bfloat, ptr addrspace(3) %460, align 2
  %462 = getelementptr bfloat, ptr addrspace(3) %383, i32 16
  %463 = load bfloat, ptr addrspace(3) %462, align 2
  %464 = getelementptr bfloat, ptr addrspace(3) %383, i32 80
  %465 = load bfloat, ptr addrspace(3) %464, align 2
  %466 = getelementptr bfloat, ptr addrspace(3) %383, i32 144
  %467 = load bfloat, ptr addrspace(3) %466, align 2
  %468 = getelementptr bfloat, ptr addrspace(3) %383, i32 208
  %469 = load bfloat, ptr addrspace(3) %468, align 2
  %470 = getelementptr bfloat, ptr addrspace(3) %383, i32 272
  %471 = load bfloat, ptr addrspace(3) %470, align 2
  %472 = getelementptr bfloat, ptr addrspace(3) %383, i32 336
  %473 = load bfloat, ptr addrspace(3) %472, align 2
  %474 = getelementptr bfloat, ptr addrspace(3) %383, i32 400
  %475 = load bfloat, ptr addrspace(3) %474, align 2
  %476 = getelementptr bfloat, ptr addrspace(3) %383, i32 464
  %477 = load bfloat, ptr addrspace(3) %476, align 2
  %478 = getelementptr bfloat, ptr addrspace(3) %383, i32 528
  %479 = load bfloat, ptr addrspace(3) %478, align 2
  %480 = getelementptr bfloat, ptr addrspace(3) %383, i32 592
  %481 = load bfloat, ptr addrspace(3) %480, align 2
  %482 = getelementptr bfloat, ptr addrspace(3) %383, i32 656
  %483 = load bfloat, ptr addrspace(3) %482, align 2
  %484 = getelementptr bfloat, ptr addrspace(3) %383, i32 720
  %485 = load bfloat, ptr addrspace(3) %484, align 2
  %486 = getelementptr bfloat, ptr addrspace(3) %383, i32 784
  %487 = load bfloat, ptr addrspace(3) %486, align 2
  %488 = getelementptr bfloat, ptr addrspace(3) %383, i32 848
  %489 = load bfloat, ptr addrspace(3) %488, align 2
  %490 = getelementptr bfloat, ptr addrspace(3) %383, i32 912
  %491 = load bfloat, ptr addrspace(3) %490, align 2
  %492 = getelementptr bfloat, ptr addrspace(3) %383, i32 976
  %493 = load bfloat, ptr addrspace(3) %492, align 2
  %494 = getelementptr bfloat, ptr addrspace(3) %383, i32 32
  %495 = load bfloat, ptr addrspace(3) %494, align 2
  %496 = getelementptr bfloat, ptr addrspace(3) %383, i32 96
  %497 = load bfloat, ptr addrspace(3) %496, align 2
  %498 = getelementptr bfloat, ptr addrspace(3) %383, i32 160
  %499 = load bfloat, ptr addrspace(3) %498, align 2
  %500 = getelementptr bfloat, ptr addrspace(3) %383, i32 224
  %501 = load bfloat, ptr addrspace(3) %500, align 2
  %502 = getelementptr bfloat, ptr addrspace(3) %383, i32 288
  %503 = load bfloat, ptr addrspace(3) %502, align 2
  %504 = getelementptr bfloat, ptr addrspace(3) %383, i32 352
  %505 = load bfloat, ptr addrspace(3) %504, align 2
  %506 = getelementptr bfloat, ptr addrspace(3) %383, i32 416
  %507 = load bfloat, ptr addrspace(3) %506, align 2
  %508 = getelementptr bfloat, ptr addrspace(3) %383, i32 480
  %509 = load bfloat, ptr addrspace(3) %508, align 2
  %510 = getelementptr bfloat, ptr addrspace(3) %383, i32 544
  %511 = load bfloat, ptr addrspace(3) %510, align 2
  %512 = getelementptr bfloat, ptr addrspace(3) %383, i32 608
  %513 = load bfloat, ptr addrspace(3) %512, align 2
  %514 = getelementptr bfloat, ptr addrspace(3) %383, i32 672
  %515 = load bfloat, ptr addrspace(3) %514, align 2
  %516 = getelementptr bfloat, ptr addrspace(3) %383, i32 736
  %517 = load bfloat, ptr addrspace(3) %516, align 2
  %518 = getelementptr bfloat, ptr addrspace(3) %383, i32 800
  %519 = load bfloat, ptr addrspace(3) %518, align 2
  %520 = getelementptr bfloat, ptr addrspace(3) %383, i32 864
  %521 = load bfloat, ptr addrspace(3) %520, align 2
  %522 = getelementptr bfloat, ptr addrspace(3) %383, i32 928
  %523 = load bfloat, ptr addrspace(3) %522, align 2
  %524 = getelementptr bfloat, ptr addrspace(3) %383, i32 992
  %525 = load bfloat, ptr addrspace(3) %524, align 2
  %526 = getelementptr bfloat, ptr addrspace(3) %383, i32 48
  %527 = load bfloat, ptr addrspace(3) %526, align 2
  %528 = getelementptr bfloat, ptr addrspace(3) %383, i32 112
  %529 = load bfloat, ptr addrspace(3) %528, align 2
  %530 = getelementptr bfloat, ptr addrspace(3) %383, i32 176
  %531 = load bfloat, ptr addrspace(3) %530, align 2
  %532 = getelementptr bfloat, ptr addrspace(3) %383, i32 240
  %533 = load bfloat, ptr addrspace(3) %532, align 2
  %534 = getelementptr bfloat, ptr addrspace(3) %383, i32 304
  %535 = load bfloat, ptr addrspace(3) %534, align 2
  %536 = getelementptr bfloat, ptr addrspace(3) %383, i32 368
  %537 = load bfloat, ptr addrspace(3) %536, align 2
  %538 = getelementptr bfloat, ptr addrspace(3) %383, i32 432
  %539 = load bfloat, ptr addrspace(3) %538, align 2
  %540 = getelementptr bfloat, ptr addrspace(3) %383, i32 496
  %541 = load bfloat, ptr addrspace(3) %540, align 2
  %542 = getelementptr bfloat, ptr addrspace(3) %383, i32 560
  %543 = load bfloat, ptr addrspace(3) %542, align 2
  %544 = getelementptr bfloat, ptr addrspace(3) %383, i32 624
  %545 = load bfloat, ptr addrspace(3) %544, align 2
  %546 = getelementptr bfloat, ptr addrspace(3) %383, i32 688
  %547 = load bfloat, ptr addrspace(3) %546, align 2
  %548 = getelementptr bfloat, ptr addrspace(3) %383, i32 752
  %549 = load bfloat, ptr addrspace(3) %548, align 2
  %550 = getelementptr bfloat, ptr addrspace(3) %383, i32 816
  %551 = load bfloat, ptr addrspace(3) %550, align 2
  %552 = getelementptr bfloat, ptr addrspace(3) %383, i32 880
  %553 = load bfloat, ptr addrspace(3) %552, align 2
  %554 = getelementptr bfloat, ptr addrspace(3) %383, i32 944
  %555 = load bfloat, ptr addrspace(3) %554, align 2
  %556 = getelementptr bfloat, ptr addrspace(3) %383, i32 1008
  %557 = load bfloat, ptr addrspace(3) %556, align 2
  %558 = insertelement <64 x bfloat> poison, bfloat %431, i64 0
  %559 = insertelement <64 x bfloat> %558, bfloat %433, i64 1
  %560 = insertelement <64 x bfloat> %559, bfloat %435, i64 2
  %561 = insertelement <64 x bfloat> %560, bfloat %437, i64 3
  %562 = insertelement <64 x bfloat> %561, bfloat %439, i64 4
  %563 = insertelement <64 x bfloat> %562, bfloat %441, i64 5
  %564 = insertelement <64 x bfloat> %563, bfloat %443, i64 6
  %565 = insertelement <64 x bfloat> %564, bfloat %445, i64 7
  %566 = insertelement <64 x bfloat> %565, bfloat %447, i64 8
  %567 = insertelement <64 x bfloat> %566, bfloat %449, i64 9
  %568 = insertelement <64 x bfloat> %567, bfloat %451, i64 10
  %569 = insertelement <64 x bfloat> %568, bfloat %453, i64 11
  %570 = insertelement <64 x bfloat> %569, bfloat %455, i64 12
  %571 = insertelement <64 x bfloat> %570, bfloat %457, i64 13
  %572 = insertelement <64 x bfloat> %571, bfloat %459, i64 14
  %573 = insertelement <64 x bfloat> %572, bfloat %461, i64 15
  %574 = insertelement <64 x bfloat> %573, bfloat %463, i64 16
  %575 = insertelement <64 x bfloat> %574, bfloat %465, i64 17
  %576 = insertelement <64 x bfloat> %575, bfloat %467, i64 18
  %577 = insertelement <64 x bfloat> %576, bfloat %469, i64 19
  %578 = insertelement <64 x bfloat> %577, bfloat %471, i64 20
  %579 = insertelement <64 x bfloat> %578, bfloat %473, i64 21
  %580 = insertelement <64 x bfloat> %579, bfloat %475, i64 22
  %581 = insertelement <64 x bfloat> %580, bfloat %477, i64 23
  %582 = insertelement <64 x bfloat> %581, bfloat %479, i64 24
  %583 = insertelement <64 x bfloat> %582, bfloat %481, i64 25
  %584 = insertelement <64 x bfloat> %583, bfloat %483, i64 26
  %585 = insertelement <64 x bfloat> %584, bfloat %485, i64 27
  %586 = insertelement <64 x bfloat> %585, bfloat %487, i64 28
  %587 = insertelement <64 x bfloat> %586, bfloat %489, i64 29
  %588 = insertelement <64 x bfloat> %587, bfloat %491, i64 30
  %589 = insertelement <64 x bfloat> %588, bfloat %493, i64 31
  %590 = insertelement <64 x bfloat> %589, bfloat %495, i64 32
  %591 = insertelement <64 x bfloat> %590, bfloat %497, i64 33
  %592 = insertelement <64 x bfloat> %591, bfloat %499, i64 34
  %593 = insertelement <64 x bfloat> %592, bfloat %501, i64 35
  %594 = insertelement <64 x bfloat> %593, bfloat %503, i64 36
  %595 = insertelement <64 x bfloat> %594, bfloat %505, i64 37
  %596 = insertelement <64 x bfloat> %595, bfloat %507, i64 38
  %597 = insertelement <64 x bfloat> %596, bfloat %509, i64 39
  %598 = insertelement <64 x bfloat> %597, bfloat %511, i64 40
  %599 = insertelement <64 x bfloat> %598, bfloat %513, i64 41
  %600 = insertelement <64 x bfloat> %599, bfloat %515, i64 42
  %601 = insertelement <64 x bfloat> %600, bfloat %517, i64 43
  %602 = insertelement <64 x bfloat> %601, bfloat %519, i64 44
  %603 = insertelement <64 x bfloat> %602, bfloat %521, i64 45
  %604 = insertelement <64 x bfloat> %603, bfloat %523, i64 46
  %605 = insertelement <64 x bfloat> %604, bfloat %525, i64 47
  %606 = insertelement <64 x bfloat> %605, bfloat %527, i64 48
  %607 = insertelement <64 x bfloat> %606, bfloat %529, i64 49
  %608 = insertelement <64 x bfloat> %607, bfloat %531, i64 50
  %609 = insertelement <64 x bfloat> %608, bfloat %533, i64 51
  %610 = insertelement <64 x bfloat> %609, bfloat %535, i64 52
  %611 = insertelement <64 x bfloat> %610, bfloat %537, i64 53
  %612 = insertelement <64 x bfloat> %611, bfloat %539, i64 54
  %613 = insertelement <64 x bfloat> %612, bfloat %541, i64 55
  %614 = insertelement <64 x bfloat> %613, bfloat %543, i64 56
  %615 = insertelement <64 x bfloat> %614, bfloat %545, i64 57
  %616 = insertelement <64 x bfloat> %615, bfloat %547, i64 58
  %617 = insertelement <64 x bfloat> %616, bfloat %549, i64 59
  %618 = insertelement <64 x bfloat> %617, bfloat %551, i64 60
  %619 = insertelement <64 x bfloat> %618, bfloat %553, i64 61
  %620 = insertelement <64 x bfloat> %619, bfloat %555, i64 62
  %621 = insertelement <64 x bfloat> %620, bfloat %557, i64 63
  %622 = shufflevector <64 x bfloat> %621, <64 x bfloat> %621, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %623 = shufflevector <32 x float> %81, <32 x float> %81, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %624 = bitcast <16 x bfloat> %430 to <16 x i16>
  %625 = bitcast <16 x bfloat> %622 to <16 x i16>
  %626 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %624, <16 x i16> %625, <8 x float> %623)
  %627 = shufflevector <8 x float> %626, <8 x float> %626, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %628 = shufflevector <32 x float> %627, <32 x float> %81, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %629 = shufflevector <64 x bfloat> %621, <64 x bfloat> %621, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %630 = shufflevector <32 x float> %628, <32 x float> %628, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %631 = bitcast <16 x bfloat> %629 to <16 x i16>
  %632 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %624, <16 x i16> %631, <8 x float> %630)
  %633 = shufflevector <8 x float> %632, <8 x float> %632, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %634 = shufflevector <32 x float> %633, <32 x float> %628, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %635 = shufflevector <64 x bfloat> %621, <64 x bfloat> %621, <16 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47>
  %636 = shufflevector <32 x float> %634, <32 x float> %634, <8 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %637 = bitcast <16 x bfloat> %635 to <16 x i16>
  %638 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %624, <16 x i16> %637, <8 x float> %636)
  %639 = shufflevector <8 x float> %638, <8 x float> %638, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %640 = shufflevector <32 x float> %639, <32 x float> %634, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %641 = shufflevector <64 x bfloat> %621, <64 x bfloat> %621, <16 x i32> <i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %642 = shufflevector <32 x float> %640, <32 x float> %640, <8 x i32> <i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %643 = bitcast <16 x bfloat> %641 to <16 x i16>
  %644 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %624, <16 x i16> %643, <8 x float> %642)
  fence syncscope("workgroup") release
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire
  %645 = extractelement <8 x float> %626, i64 0
  %646 = fptrunc float %645 to bfloat
  %647 = extractelement <8 x float> %626, i64 1
  %648 = fptrunc float %647 to bfloat
  %649 = extractelement <8 x float> %626, i64 2
  %650 = fptrunc float %649 to bfloat
  %651 = extractelement <8 x float> %626, i64 3
  %652 = fptrunc float %651 to bfloat
  %653 = extractelement <8 x float> %626, i64 4
  %654 = fptrunc float %653 to bfloat
  %655 = extractelement <8 x float> %626, i64 5
  %656 = fptrunc float %655 to bfloat
  %657 = extractelement <8 x float> %626, i64 6
  %658 = fptrunc float %657 to bfloat
  %659 = extractelement <8 x float> %626, i64 7
  %660 = fptrunc float %659 to bfloat
  %661 = extractelement <8 x float> %632, i64 0
  %662 = fptrunc float %661 to bfloat
  %663 = extractelement <8 x float> %632, i64 1
  %664 = fptrunc float %663 to bfloat
  %665 = extractelement <8 x float> %632, i64 2
  %666 = fptrunc float %665 to bfloat
  %667 = extractelement <8 x float> %632, i64 3
  %668 = fptrunc float %667 to bfloat
  %669 = extractelement <8 x float> %632, i64 4
  %670 = fptrunc float %669 to bfloat
  %671 = extractelement <8 x float> %632, i64 5
  %672 = fptrunc float %671 to bfloat
  %673 = extractelement <8 x float> %632, i64 6
  %674 = fptrunc float %673 to bfloat
  %675 = extractelement <8 x float> %632, i64 7
  %676 = fptrunc float %675 to bfloat
  %677 = extractelement <8 x float> %638, i64 0
  %678 = fptrunc float %677 to bfloat
  %679 = extractelement <8 x float> %638, i64 1
  %680 = fptrunc float %679 to bfloat
  %681 = extractelement <8 x float> %638, i64 2
  %682 = fptrunc float %681 to bfloat
  %683 = extractelement <8 x float> %638, i64 3
  %684 = fptrunc float %683 to bfloat
  %685 = extractelement <8 x float> %638, i64 4
  %686 = fptrunc float %685 to bfloat
  %687 = extractelement <8 x float> %638, i64 5
  %688 = fptrunc float %687 to bfloat
  %689 = extractelement <8 x float> %638, i64 6
  %690 = fptrunc float %689 to bfloat
  %691 = extractelement <8 x float> %638, i64 7
  %692 = fptrunc float %691 to bfloat
  %693 = extractelement <8 x float> %644, i64 0
  %694 = fptrunc float %693 to bfloat
  %695 = extractelement <8 x float> %644, i64 1
  %696 = fptrunc float %695 to bfloat
  %697 = extractelement <8 x float> %644, i64 2
  %698 = fptrunc float %697 to bfloat
  %699 = extractelement <8 x float> %644, i64 3
  %700 = fptrunc float %699 to bfloat
  %701 = extractelement <8 x float> %644, i64 4
  %702 = fptrunc float %701 to bfloat
  %703 = extractelement <8 x float> %644, i64 5
  %704 = fptrunc float %703 to bfloat
  %705 = extractelement <8 x float> %644, i64 6
  %706 = fptrunc float %705 to bfloat
  %707 = extractelement <8 x float> %644, i64 7
  %708 = fptrunc float %707 to bfloat
  %709 = sdiv i32 %22, 16
  %710 = mul i32 %709, 4096
  %711 = add i32 %378, %710
  %712 = add i32 %36, %711
  %713 = mul i32 %712, 2
  %714 = bitcast bfloat %646 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %714, ptr addrspace(8) %29, i32 %713, i32 0, i32 0)
  %715 = add i32 %712, 8192
  %716 = mul i32 %715, 2
  %717 = bitcast bfloat %648 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %717, ptr addrspace(8) %29, i32 %716, i32 0, i32 0)
  %718 = add i32 %712, 16384
  %719 = mul i32 %718, 2
  %720 = bitcast bfloat %650 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %720, ptr addrspace(8) %29, i32 %719, i32 0, i32 0)
  %721 = add i32 %712, 24576
  %722 = mul i32 %721, 2
  %723 = bitcast bfloat %652 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %723, ptr addrspace(8) %29, i32 %722, i32 0, i32 0)
  %724 = add i32 %712, 32768
  %725 = mul i32 %724, 2
  %726 = bitcast bfloat %654 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %726, ptr addrspace(8) %29, i32 %725, i32 0, i32 0)
  %727 = add i32 %712, 40960
  %728 = mul i32 %727, 2
  %729 = bitcast bfloat %656 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %729, ptr addrspace(8) %29, i32 %728, i32 0, i32 0)
  %730 = add i32 %712, 49152
  %731 = mul i32 %730, 2
  %732 = bitcast bfloat %658 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %732, ptr addrspace(8) %29, i32 %731, i32 0, i32 0)
  %733 = add i32 %712, 57344
  %734 = mul i32 %733, 2
  %735 = bitcast bfloat %660 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %735, ptr addrspace(8) %29, i32 %734, i32 0, i32 0)
  %736 = add i32 %712, 16
  %737 = mul i32 %736, 2
  %738 = bitcast bfloat %662 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %738, ptr addrspace(8) %29, i32 %737, i32 0, i32 0)
  %739 = add i32 %712, 8208
  %740 = mul i32 %739, 2
  %741 = bitcast bfloat %664 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %741, ptr addrspace(8) %29, i32 %740, i32 0, i32 0)
  %742 = add i32 %712, 16400
  %743 = mul i32 %742, 2
  %744 = bitcast bfloat %666 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %744, ptr addrspace(8) %29, i32 %743, i32 0, i32 0)
  %745 = add i32 %712, 24592
  %746 = mul i32 %745, 2
  %747 = bitcast bfloat %668 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %747, ptr addrspace(8) %29, i32 %746, i32 0, i32 0)
  %748 = add i32 %712, 32784
  %749 = mul i32 %748, 2
  %750 = bitcast bfloat %670 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %750, ptr addrspace(8) %29, i32 %749, i32 0, i32 0)
  %751 = add i32 %712, 40976
  %752 = mul i32 %751, 2
  %753 = bitcast bfloat %672 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %753, ptr addrspace(8) %29, i32 %752, i32 0, i32 0)
  %754 = add i32 %712, 49168
  %755 = mul i32 %754, 2
  %756 = bitcast bfloat %674 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %756, ptr addrspace(8) %29, i32 %755, i32 0, i32 0)
  %757 = add i32 %712, 57360
  %758 = mul i32 %757, 2
  %759 = bitcast bfloat %676 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %759, ptr addrspace(8) %29, i32 %758, i32 0, i32 0)
  %760 = add i32 %712, 32
  %761 = mul i32 %760, 2
  %762 = bitcast bfloat %678 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %762, ptr addrspace(8) %29, i32 %761, i32 0, i32 0)
  %763 = add i32 %712, 8224
  %764 = mul i32 %763, 2
  %765 = bitcast bfloat %680 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %765, ptr addrspace(8) %29, i32 %764, i32 0, i32 0)
  %766 = add i32 %712, 16416
  %767 = mul i32 %766, 2
  %768 = bitcast bfloat %682 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %768, ptr addrspace(8) %29, i32 %767, i32 0, i32 0)
  %769 = add i32 %712, 24608
  %770 = mul i32 %769, 2
  %771 = bitcast bfloat %684 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %771, ptr addrspace(8) %29, i32 %770, i32 0, i32 0)
  %772 = add i32 %712, 32800
  %773 = mul i32 %772, 2
  %774 = bitcast bfloat %686 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %774, ptr addrspace(8) %29, i32 %773, i32 0, i32 0)
  %775 = add i32 %712, 40992
  %776 = mul i32 %775, 2
  %777 = bitcast bfloat %688 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %777, ptr addrspace(8) %29, i32 %776, i32 0, i32 0)
  %778 = add i32 %712, 49184
  %779 = mul i32 %778, 2
  %780 = bitcast bfloat %690 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %780, ptr addrspace(8) %29, i32 %779, i32 0, i32 0)
  %781 = add i32 %712, 57376
  %782 = mul i32 %781, 2
  %783 = bitcast bfloat %692 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %783, ptr addrspace(8) %29, i32 %782, i32 0, i32 0)
  %784 = add i32 %712, 48
  %785 = mul i32 %784, 2
  %786 = bitcast bfloat %694 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %786, ptr addrspace(8) %29, i32 %785, i32 0, i32 0)
  %787 = add i32 %712, 8240
  %788 = mul i32 %787, 2
  %789 = bitcast bfloat %696 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %789, ptr addrspace(8) %29, i32 %788, i32 0, i32 0)
  %790 = add i32 %712, 16432
  %791 = mul i32 %790, 2
  %792 = bitcast bfloat %698 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %792, ptr addrspace(8) %29, i32 %791, i32 0, i32 0)
  %793 = add i32 %712, 24624
  %794 = mul i32 %793, 2
  %795 = bitcast bfloat %700 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %795, ptr addrspace(8) %29, i32 %794, i32 0, i32 0)
  %796 = add i32 %712, 32816
  %797 = mul i32 %796, 2
  %798 = bitcast bfloat %702 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %798, ptr addrspace(8) %29, i32 %797, i32 0, i32 0)
  %799 = add i32 %712, 41008
  %800 = mul i32 %799, 2
  %801 = bitcast bfloat %704 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %801, ptr addrspace(8) %29, i32 %800, i32 0, i32 0)
  %802 = add i32 %712, 49200
  %803 = mul i32 %802, 2
  %804 = bitcast bfloat %706 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %804, ptr addrspace(8) %29, i32 %803, i32 0, i32 0)
  %805 = add i32 %712, 57392
  %806 = mul i32 %805, 2
  %807 = bitcast bfloat %708 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %807, ptr addrspace(8) %29, i32 %806, i32 0, i32 0)
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
declare void @llvm.amdgcn.s.barrier() #4

; Function Attrs: convergent nocallback nocreateundeforpoison nofree nounwind willreturn memory(none)
declare <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16>, <16 x i16>, <8 x float>) #5

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: write)
declare void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16, ptr addrspace(8) writeonly captures(none), i32, i32, i32 immarg) #6

attributes #0 = { "amdgpu-flat-work-group-size"="32,32" "uniform-work-group-size" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { nocallback nofree nosync nounwind willreturn memory(argmem: read) }
attributes #4 = { convergent nocallback nofree nounwind willreturn }
attributes #5 = { convergent nocallback nocreateundeforpoison nofree nounwind willreturn memory(none) }
attributes #6 = { nocallback nofree nosync nounwind willreturn memory(argmem: write) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{i32 32, i32 1, i32 1}
