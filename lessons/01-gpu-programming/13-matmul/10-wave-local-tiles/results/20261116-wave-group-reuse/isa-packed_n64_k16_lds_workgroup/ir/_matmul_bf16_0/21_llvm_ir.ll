; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target datalayout = "e-p:64:64-p1:64:64-p2:32:32-p3:32:32-p4:64:64-p5:32:32-p6:32:32-p7:160:256:256:32-p8:128:128:128:48-p9:192:256:256:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-v2048:2048-n32:64-S32-A5-G1-ni:7:8:9"

@__shared_alloc_1 = external dso_local addrspace(3) global [4096 x i8], align 16
@__shared_alloc_0 = external dso_local addrspace(3) global [1536 x i8], align 16

define amdgpu_kernel void @_matmul_bf16_0(ptr addrspace(1) %0, <{ <{ i32, i32 }>, <{ i64 }> }> %1, ptr addrspace(1) %2, <{ <{ i32, i32 }>, <{ i64 }> }> %3, ptr addrspace(1) %4, <{ <{ i32, i32 }>, <{ i64 }> }> %5) #0 !reqd_work_group_size !1 {
  %7 = call range(i32 0, 64) i32 @llvm.amdgcn.workitem.id.x()
  %8 = sext i32 %7 to i64
  %9 = trunc i64 %8 to i32
  %10 = sdiv i32 %9, 32
  %11 = mul i32 %10, 32
  %12 = icmp ne i32 %9, %11
  %13 = icmp slt i32 %9, 0
  %14 = icmp ne i1 %13, false
  %15 = and i1 %12, %14
  %16 = add i32 %10, -1
  %17 = select i1 %15, i32 %16, i32 %10
  %18 = srem i32 %9, 32
  %19 = call i32 @llvm.amdgcn.workgroup.id.x()
  %20 = sext i32 %19 to i64
  %21 = trunc i64 %20 to i32
  %22 = mul i32 %21, 2
  %23 = add i32 %22, %17
  %24 = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) %0, i16 0, i64 4294967295, i32 553807872)
  %25 = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) %2, i16 0, i64 4294967295, i32 553807872)
  %26 = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) %4, i16 0, i64 4294967295, i32 553807872)
  %27 = srem i32 %23, 64
  %28 = mul i32 %27, 64
  %29 = mul i32 %17, 384
  %30 = mul i32 %17, 1024
  %31 = srem i32 %18, 2
  %32 = sdiv i32 %18, 2
  %33 = mul i32 %31, 8
  %34 = mul i32 %32, 24
  %35 = add i32 %33, %34
  %36 = add i32 %29, %35
  %37 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %36
  %38 = srem i32 %18, 8
  %39 = sdiv i32 %18, 8
  %40 = mul i32 %38, 8
  %41 = mul i32 %39, 64
  %42 = add i32 %40, %41
  %43 = add i32 %30, %42
  %44 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %43
  %45 = mul i32 %32, 8192
  %46 = add i32 %33, %45
  %47 = mul i32 %39, 4096
  %48 = add i32 %40, %47
  %49 = add i32 %28, %48
  %50 = mul i32 %46, 2
  %51 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %24, i32 %50, i32 0, i32 0)
  %52 = bitcast i128 %51 to <8 x bfloat>
  %53 = mul i32 %49, 2
  %54 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %25, i32 %53, i32 0, i32 0)
  %55 = bitcast i128 %54 to <8 x bfloat>
  %56 = add i32 %49, 16384
  %57 = mul i32 %56, 2
  %58 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %25, i32 %57, i32 0, i32 0)
  %59 = bitcast i128 %58 to <8 x bfloat>
  %60 = add i32 %49, 32768
  %61 = mul i32 %60, 2
  %62 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %25, i32 %61, i32 0, i32 0)
  %63 = bitcast i128 %62 to <8 x bfloat>
  %64 = add i32 %49, 49152
  %65 = mul i32 %64, 2
  %66 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %25, i32 %65, i32 0, i32 0)
  %67 = bitcast i128 %66 to <8 x bfloat>
  store <8 x bfloat> %52, ptr addrspace(3) %37, align 16
  store <8 x bfloat> %55, ptr addrspace(3) %44, align 16
  %68 = getelementptr bfloat, ptr addrspace(3) %44, i32 256
  store <8 x bfloat> %59, ptr addrspace(3) %68, align 16
  %69 = getelementptr bfloat, ptr addrspace(3) %44, i32 512
  store <8 x bfloat> %63, ptr addrspace(3) %69, align 16
  %70 = getelementptr bfloat, ptr addrspace(3) %44, i32 768
  store <8 x bfloat> %67, ptr addrspace(3) %70, align 16
  fence syncscope("workgroup") release, !mmra !2
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire, !mmra !2
  br label %71

71:                                               ; preds = %75, %6
  %72 = phi i32 [ %76, %75 ], [ 0, %6 ]
  %73 = phi <32 x float> [ %368, %75 ], [ zeroinitializer, %6 ]
  %74 = icmp slt i32 %72, 511
  br i1 %74, label %75, label %369

75:                                               ; preds = %71
  %76 = add i32 %72, 1
  %77 = mul i32 %76, 16
  %78 = mul i32 %76, 65536
  %79 = add i32 %78, %28
  %80 = add i32 %77, %46
  %81 = add i32 %79, %48
  %82 = mul i32 %80, 2
  %83 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %24, i32 %82, i32 0, i32 0)
  %84 = bitcast i128 %83 to <8 x bfloat>
  %85 = mul i32 %81, 2
  %86 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %25, i32 %85, i32 0, i32 0)
  %87 = bitcast i128 %86 to <8 x bfloat>
  %88 = add i32 %81, 16384
  %89 = mul i32 %88, 2
  %90 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %25, i32 %89, i32 0, i32 0)
  %91 = bitcast i128 %90 to <8 x bfloat>
  %92 = add i32 %81, 32768
  %93 = mul i32 %92, 2
  %94 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %25, i32 %93, i32 0, i32 0)
  %95 = bitcast i128 %94 to <8 x bfloat>
  %96 = add i32 %81, 49152
  %97 = mul i32 %96, 2
  %98 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %25, i32 %97, i32 0, i32 0)
  %99 = bitcast i128 %98 to <8 x bfloat>
  %100 = srem i32 %18, 16
  %101 = mul i32 %100, 24
  %102 = add i32 %29, %101
  %103 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %102
  %104 = add i32 %30, %100
  %105 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %104
  %106 = load bfloat, ptr addrspace(3) %103, align 2
  %107 = getelementptr bfloat, ptr addrspace(3) %103, i32 1
  %108 = load bfloat, ptr addrspace(3) %107, align 2
  %109 = getelementptr bfloat, ptr addrspace(3) %103, i32 2
  %110 = load bfloat, ptr addrspace(3) %109, align 2
  %111 = getelementptr bfloat, ptr addrspace(3) %103, i32 3
  %112 = load bfloat, ptr addrspace(3) %111, align 2
  %113 = getelementptr bfloat, ptr addrspace(3) %103, i32 4
  %114 = load bfloat, ptr addrspace(3) %113, align 2
  %115 = getelementptr bfloat, ptr addrspace(3) %103, i32 5
  %116 = load bfloat, ptr addrspace(3) %115, align 2
  %117 = getelementptr bfloat, ptr addrspace(3) %103, i32 6
  %118 = load bfloat, ptr addrspace(3) %117, align 2
  %119 = getelementptr bfloat, ptr addrspace(3) %103, i32 7
  %120 = load bfloat, ptr addrspace(3) %119, align 2
  %121 = getelementptr bfloat, ptr addrspace(3) %103, i32 8
  %122 = load bfloat, ptr addrspace(3) %121, align 2
  %123 = getelementptr bfloat, ptr addrspace(3) %103, i32 9
  %124 = load bfloat, ptr addrspace(3) %123, align 2
  %125 = getelementptr bfloat, ptr addrspace(3) %103, i32 10
  %126 = load bfloat, ptr addrspace(3) %125, align 2
  %127 = getelementptr bfloat, ptr addrspace(3) %103, i32 11
  %128 = load bfloat, ptr addrspace(3) %127, align 2
  %129 = getelementptr bfloat, ptr addrspace(3) %103, i32 12
  %130 = load bfloat, ptr addrspace(3) %129, align 2
  %131 = getelementptr bfloat, ptr addrspace(3) %103, i32 13
  %132 = load bfloat, ptr addrspace(3) %131, align 2
  %133 = getelementptr bfloat, ptr addrspace(3) %103, i32 14
  %134 = load bfloat, ptr addrspace(3) %133, align 2
  %135 = getelementptr bfloat, ptr addrspace(3) %103, i32 15
  %136 = load bfloat, ptr addrspace(3) %135, align 2
  %137 = insertelement <16 x bfloat> poison, bfloat %106, i64 0
  %138 = insertelement <16 x bfloat> %137, bfloat %108, i64 1
  %139 = insertelement <16 x bfloat> %138, bfloat %110, i64 2
  %140 = insertelement <16 x bfloat> %139, bfloat %112, i64 3
  %141 = insertelement <16 x bfloat> %140, bfloat %114, i64 4
  %142 = insertelement <16 x bfloat> %141, bfloat %116, i64 5
  %143 = insertelement <16 x bfloat> %142, bfloat %118, i64 6
  %144 = insertelement <16 x bfloat> %143, bfloat %120, i64 7
  %145 = insertelement <16 x bfloat> %144, bfloat %122, i64 8
  %146 = insertelement <16 x bfloat> %145, bfloat %124, i64 9
  %147 = insertelement <16 x bfloat> %146, bfloat %126, i64 10
  %148 = insertelement <16 x bfloat> %147, bfloat %128, i64 11
  %149 = insertelement <16 x bfloat> %148, bfloat %130, i64 12
  %150 = insertelement <16 x bfloat> %149, bfloat %132, i64 13
  %151 = insertelement <16 x bfloat> %150, bfloat %134, i64 14
  %152 = insertelement <16 x bfloat> %151, bfloat %136, i64 15
  %153 = load bfloat, ptr addrspace(3) %105, align 2
  %154 = getelementptr bfloat, ptr addrspace(3) %105, i32 64
  %155 = load bfloat, ptr addrspace(3) %154, align 2
  %156 = getelementptr bfloat, ptr addrspace(3) %105, i32 128
  %157 = load bfloat, ptr addrspace(3) %156, align 2
  %158 = getelementptr bfloat, ptr addrspace(3) %105, i32 192
  %159 = load bfloat, ptr addrspace(3) %158, align 2
  %160 = getelementptr bfloat, ptr addrspace(3) %105, i32 256
  %161 = load bfloat, ptr addrspace(3) %160, align 2
  %162 = getelementptr bfloat, ptr addrspace(3) %105, i32 320
  %163 = load bfloat, ptr addrspace(3) %162, align 2
  %164 = getelementptr bfloat, ptr addrspace(3) %105, i32 384
  %165 = load bfloat, ptr addrspace(3) %164, align 2
  %166 = getelementptr bfloat, ptr addrspace(3) %105, i32 448
  %167 = load bfloat, ptr addrspace(3) %166, align 2
  %168 = getelementptr bfloat, ptr addrspace(3) %105, i32 512
  %169 = load bfloat, ptr addrspace(3) %168, align 2
  %170 = getelementptr bfloat, ptr addrspace(3) %105, i32 576
  %171 = load bfloat, ptr addrspace(3) %170, align 2
  %172 = getelementptr bfloat, ptr addrspace(3) %105, i32 640
  %173 = load bfloat, ptr addrspace(3) %172, align 2
  %174 = getelementptr bfloat, ptr addrspace(3) %105, i32 704
  %175 = load bfloat, ptr addrspace(3) %174, align 2
  %176 = getelementptr bfloat, ptr addrspace(3) %105, i32 768
  %177 = load bfloat, ptr addrspace(3) %176, align 2
  %178 = getelementptr bfloat, ptr addrspace(3) %105, i32 832
  %179 = load bfloat, ptr addrspace(3) %178, align 2
  %180 = getelementptr bfloat, ptr addrspace(3) %105, i32 896
  %181 = load bfloat, ptr addrspace(3) %180, align 2
  %182 = getelementptr bfloat, ptr addrspace(3) %105, i32 960
  %183 = load bfloat, ptr addrspace(3) %182, align 2
  %184 = getelementptr bfloat, ptr addrspace(3) %105, i32 16
  %185 = load bfloat, ptr addrspace(3) %184, align 2
  %186 = getelementptr bfloat, ptr addrspace(3) %105, i32 80
  %187 = load bfloat, ptr addrspace(3) %186, align 2
  %188 = getelementptr bfloat, ptr addrspace(3) %105, i32 144
  %189 = load bfloat, ptr addrspace(3) %188, align 2
  %190 = getelementptr bfloat, ptr addrspace(3) %105, i32 208
  %191 = load bfloat, ptr addrspace(3) %190, align 2
  %192 = getelementptr bfloat, ptr addrspace(3) %105, i32 272
  %193 = load bfloat, ptr addrspace(3) %192, align 2
  %194 = getelementptr bfloat, ptr addrspace(3) %105, i32 336
  %195 = load bfloat, ptr addrspace(3) %194, align 2
  %196 = getelementptr bfloat, ptr addrspace(3) %105, i32 400
  %197 = load bfloat, ptr addrspace(3) %196, align 2
  %198 = getelementptr bfloat, ptr addrspace(3) %105, i32 464
  %199 = load bfloat, ptr addrspace(3) %198, align 2
  %200 = getelementptr bfloat, ptr addrspace(3) %105, i32 528
  %201 = load bfloat, ptr addrspace(3) %200, align 2
  %202 = getelementptr bfloat, ptr addrspace(3) %105, i32 592
  %203 = load bfloat, ptr addrspace(3) %202, align 2
  %204 = getelementptr bfloat, ptr addrspace(3) %105, i32 656
  %205 = load bfloat, ptr addrspace(3) %204, align 2
  %206 = getelementptr bfloat, ptr addrspace(3) %105, i32 720
  %207 = load bfloat, ptr addrspace(3) %206, align 2
  %208 = getelementptr bfloat, ptr addrspace(3) %105, i32 784
  %209 = load bfloat, ptr addrspace(3) %208, align 2
  %210 = getelementptr bfloat, ptr addrspace(3) %105, i32 848
  %211 = load bfloat, ptr addrspace(3) %210, align 2
  %212 = getelementptr bfloat, ptr addrspace(3) %105, i32 912
  %213 = load bfloat, ptr addrspace(3) %212, align 2
  %214 = getelementptr bfloat, ptr addrspace(3) %105, i32 976
  %215 = load bfloat, ptr addrspace(3) %214, align 2
  %216 = getelementptr bfloat, ptr addrspace(3) %105, i32 32
  %217 = load bfloat, ptr addrspace(3) %216, align 2
  %218 = getelementptr bfloat, ptr addrspace(3) %105, i32 96
  %219 = load bfloat, ptr addrspace(3) %218, align 2
  %220 = getelementptr bfloat, ptr addrspace(3) %105, i32 160
  %221 = load bfloat, ptr addrspace(3) %220, align 2
  %222 = getelementptr bfloat, ptr addrspace(3) %105, i32 224
  %223 = load bfloat, ptr addrspace(3) %222, align 2
  %224 = getelementptr bfloat, ptr addrspace(3) %105, i32 288
  %225 = load bfloat, ptr addrspace(3) %224, align 2
  %226 = getelementptr bfloat, ptr addrspace(3) %105, i32 352
  %227 = load bfloat, ptr addrspace(3) %226, align 2
  %228 = getelementptr bfloat, ptr addrspace(3) %105, i32 416
  %229 = load bfloat, ptr addrspace(3) %228, align 2
  %230 = getelementptr bfloat, ptr addrspace(3) %105, i32 480
  %231 = load bfloat, ptr addrspace(3) %230, align 2
  %232 = getelementptr bfloat, ptr addrspace(3) %105, i32 544
  %233 = load bfloat, ptr addrspace(3) %232, align 2
  %234 = getelementptr bfloat, ptr addrspace(3) %105, i32 608
  %235 = load bfloat, ptr addrspace(3) %234, align 2
  %236 = getelementptr bfloat, ptr addrspace(3) %105, i32 672
  %237 = load bfloat, ptr addrspace(3) %236, align 2
  %238 = getelementptr bfloat, ptr addrspace(3) %105, i32 736
  %239 = load bfloat, ptr addrspace(3) %238, align 2
  %240 = getelementptr bfloat, ptr addrspace(3) %105, i32 800
  %241 = load bfloat, ptr addrspace(3) %240, align 2
  %242 = getelementptr bfloat, ptr addrspace(3) %105, i32 864
  %243 = load bfloat, ptr addrspace(3) %242, align 2
  %244 = getelementptr bfloat, ptr addrspace(3) %105, i32 928
  %245 = load bfloat, ptr addrspace(3) %244, align 2
  %246 = getelementptr bfloat, ptr addrspace(3) %105, i32 992
  %247 = load bfloat, ptr addrspace(3) %246, align 2
  %248 = getelementptr bfloat, ptr addrspace(3) %105, i32 48
  %249 = load bfloat, ptr addrspace(3) %248, align 2
  %250 = getelementptr bfloat, ptr addrspace(3) %105, i32 112
  %251 = load bfloat, ptr addrspace(3) %250, align 2
  %252 = getelementptr bfloat, ptr addrspace(3) %105, i32 176
  %253 = load bfloat, ptr addrspace(3) %252, align 2
  %254 = getelementptr bfloat, ptr addrspace(3) %105, i32 240
  %255 = load bfloat, ptr addrspace(3) %254, align 2
  %256 = getelementptr bfloat, ptr addrspace(3) %105, i32 304
  %257 = load bfloat, ptr addrspace(3) %256, align 2
  %258 = getelementptr bfloat, ptr addrspace(3) %105, i32 368
  %259 = load bfloat, ptr addrspace(3) %258, align 2
  %260 = getelementptr bfloat, ptr addrspace(3) %105, i32 432
  %261 = load bfloat, ptr addrspace(3) %260, align 2
  %262 = getelementptr bfloat, ptr addrspace(3) %105, i32 496
  %263 = load bfloat, ptr addrspace(3) %262, align 2
  %264 = getelementptr bfloat, ptr addrspace(3) %105, i32 560
  %265 = load bfloat, ptr addrspace(3) %264, align 2
  %266 = getelementptr bfloat, ptr addrspace(3) %105, i32 624
  %267 = load bfloat, ptr addrspace(3) %266, align 2
  %268 = getelementptr bfloat, ptr addrspace(3) %105, i32 688
  %269 = load bfloat, ptr addrspace(3) %268, align 2
  %270 = getelementptr bfloat, ptr addrspace(3) %105, i32 752
  %271 = load bfloat, ptr addrspace(3) %270, align 2
  %272 = getelementptr bfloat, ptr addrspace(3) %105, i32 816
  %273 = load bfloat, ptr addrspace(3) %272, align 2
  %274 = getelementptr bfloat, ptr addrspace(3) %105, i32 880
  %275 = load bfloat, ptr addrspace(3) %274, align 2
  %276 = getelementptr bfloat, ptr addrspace(3) %105, i32 944
  %277 = load bfloat, ptr addrspace(3) %276, align 2
  %278 = getelementptr bfloat, ptr addrspace(3) %105, i32 1008
  %279 = load bfloat, ptr addrspace(3) %278, align 2
  %280 = insertelement <64 x bfloat> poison, bfloat %153, i64 0
  %281 = insertelement <64 x bfloat> %280, bfloat %155, i64 1
  %282 = insertelement <64 x bfloat> %281, bfloat %157, i64 2
  %283 = insertelement <64 x bfloat> %282, bfloat %159, i64 3
  %284 = insertelement <64 x bfloat> %283, bfloat %161, i64 4
  %285 = insertelement <64 x bfloat> %284, bfloat %163, i64 5
  %286 = insertelement <64 x bfloat> %285, bfloat %165, i64 6
  %287 = insertelement <64 x bfloat> %286, bfloat %167, i64 7
  %288 = insertelement <64 x bfloat> %287, bfloat %169, i64 8
  %289 = insertelement <64 x bfloat> %288, bfloat %171, i64 9
  %290 = insertelement <64 x bfloat> %289, bfloat %173, i64 10
  %291 = insertelement <64 x bfloat> %290, bfloat %175, i64 11
  %292 = insertelement <64 x bfloat> %291, bfloat %177, i64 12
  %293 = insertelement <64 x bfloat> %292, bfloat %179, i64 13
  %294 = insertelement <64 x bfloat> %293, bfloat %181, i64 14
  %295 = insertelement <64 x bfloat> %294, bfloat %183, i64 15
  %296 = insertelement <64 x bfloat> %295, bfloat %185, i64 16
  %297 = insertelement <64 x bfloat> %296, bfloat %187, i64 17
  %298 = insertelement <64 x bfloat> %297, bfloat %189, i64 18
  %299 = insertelement <64 x bfloat> %298, bfloat %191, i64 19
  %300 = insertelement <64 x bfloat> %299, bfloat %193, i64 20
  %301 = insertelement <64 x bfloat> %300, bfloat %195, i64 21
  %302 = insertelement <64 x bfloat> %301, bfloat %197, i64 22
  %303 = insertelement <64 x bfloat> %302, bfloat %199, i64 23
  %304 = insertelement <64 x bfloat> %303, bfloat %201, i64 24
  %305 = insertelement <64 x bfloat> %304, bfloat %203, i64 25
  %306 = insertelement <64 x bfloat> %305, bfloat %205, i64 26
  %307 = insertelement <64 x bfloat> %306, bfloat %207, i64 27
  %308 = insertelement <64 x bfloat> %307, bfloat %209, i64 28
  %309 = insertelement <64 x bfloat> %308, bfloat %211, i64 29
  %310 = insertelement <64 x bfloat> %309, bfloat %213, i64 30
  %311 = insertelement <64 x bfloat> %310, bfloat %215, i64 31
  %312 = insertelement <64 x bfloat> %311, bfloat %217, i64 32
  %313 = insertelement <64 x bfloat> %312, bfloat %219, i64 33
  %314 = insertelement <64 x bfloat> %313, bfloat %221, i64 34
  %315 = insertelement <64 x bfloat> %314, bfloat %223, i64 35
  %316 = insertelement <64 x bfloat> %315, bfloat %225, i64 36
  %317 = insertelement <64 x bfloat> %316, bfloat %227, i64 37
  %318 = insertelement <64 x bfloat> %317, bfloat %229, i64 38
  %319 = insertelement <64 x bfloat> %318, bfloat %231, i64 39
  %320 = insertelement <64 x bfloat> %319, bfloat %233, i64 40
  %321 = insertelement <64 x bfloat> %320, bfloat %235, i64 41
  %322 = insertelement <64 x bfloat> %321, bfloat %237, i64 42
  %323 = insertelement <64 x bfloat> %322, bfloat %239, i64 43
  %324 = insertelement <64 x bfloat> %323, bfloat %241, i64 44
  %325 = insertelement <64 x bfloat> %324, bfloat %243, i64 45
  %326 = insertelement <64 x bfloat> %325, bfloat %245, i64 46
  %327 = insertelement <64 x bfloat> %326, bfloat %247, i64 47
  %328 = insertelement <64 x bfloat> %327, bfloat %249, i64 48
  %329 = insertelement <64 x bfloat> %328, bfloat %251, i64 49
  %330 = insertelement <64 x bfloat> %329, bfloat %253, i64 50
  %331 = insertelement <64 x bfloat> %330, bfloat %255, i64 51
  %332 = insertelement <64 x bfloat> %331, bfloat %257, i64 52
  %333 = insertelement <64 x bfloat> %332, bfloat %259, i64 53
  %334 = insertelement <64 x bfloat> %333, bfloat %261, i64 54
  %335 = insertelement <64 x bfloat> %334, bfloat %263, i64 55
  %336 = insertelement <64 x bfloat> %335, bfloat %265, i64 56
  %337 = insertelement <64 x bfloat> %336, bfloat %267, i64 57
  %338 = insertelement <64 x bfloat> %337, bfloat %269, i64 58
  %339 = insertelement <64 x bfloat> %338, bfloat %271, i64 59
  %340 = insertelement <64 x bfloat> %339, bfloat %273, i64 60
  %341 = insertelement <64 x bfloat> %340, bfloat %275, i64 61
  %342 = insertelement <64 x bfloat> %341, bfloat %277, i64 62
  %343 = insertelement <64 x bfloat> %342, bfloat %279, i64 63
  %344 = shufflevector <64 x bfloat> %343, <64 x bfloat> %343, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %345 = shufflevector <32 x float> %73, <32 x float> %73, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %346 = bitcast <16 x bfloat> %152 to <16 x i16>
  %347 = bitcast <16 x bfloat> %344 to <16 x i16>
  %348 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %346, <16 x i16> %347, <8 x float> %345)
  %349 = shufflevector <8 x float> %348, <8 x float> %348, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %350 = shufflevector <32 x float> %349, <32 x float> %73, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %351 = shufflevector <64 x bfloat> %343, <64 x bfloat> %343, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %352 = shufflevector <32 x float> %350, <32 x float> %350, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %353 = bitcast <16 x bfloat> %351 to <16 x i16>
  %354 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %346, <16 x i16> %353, <8 x float> %352)
  %355 = shufflevector <8 x float> %354, <8 x float> %354, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %356 = shufflevector <32 x float> %355, <32 x float> %350, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %357 = shufflevector <64 x bfloat> %343, <64 x bfloat> %343, <16 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47>
  %358 = shufflevector <32 x float> %356, <32 x float> %356, <8 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %359 = bitcast <16 x bfloat> %357 to <16 x i16>
  %360 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %346, <16 x i16> %359, <8 x float> %358)
  %361 = shufflevector <8 x float> %360, <8 x float> %360, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %362 = shufflevector <32 x float> %361, <32 x float> %356, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %363 = shufflevector <64 x bfloat> %343, <64 x bfloat> %343, <16 x i32> <i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %364 = shufflevector <32 x float> %362, <32 x float> %362, <8 x i32> <i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %365 = bitcast <16 x bfloat> %363 to <16 x i16>
  %366 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %346, <16 x i16> %365, <8 x float> %364)
  %367 = shufflevector <8 x float> %366, <8 x float> %366, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %368 = shufflevector <32 x float> %367, <32 x float> %362, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  fence syncscope("workgroup") release, !mmra !2
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire, !mmra !2
  store <8 x bfloat> %84, ptr addrspace(3) %37, align 16
  store <8 x bfloat> %87, ptr addrspace(3) %44, align 16
  store <8 x bfloat> %91, ptr addrspace(3) %68, align 16
  store <8 x bfloat> %95, ptr addrspace(3) %69, align 16
  store <8 x bfloat> %99, ptr addrspace(3) %70, align 16
  fence syncscope("workgroup") release, !mmra !2
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire, !mmra !2
  br label %71

369:                                              ; preds = %71
  %370 = srem i32 %18, 16
  %371 = mul i32 %370, 24
  %372 = add i32 %29, %371
  %373 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %372
  %374 = add i32 %30, %370
  %375 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %374
  %376 = load bfloat, ptr addrspace(3) %373, align 2
  %377 = getelementptr bfloat, ptr addrspace(3) %373, i32 1
  %378 = load bfloat, ptr addrspace(3) %377, align 2
  %379 = getelementptr bfloat, ptr addrspace(3) %373, i32 2
  %380 = load bfloat, ptr addrspace(3) %379, align 2
  %381 = getelementptr bfloat, ptr addrspace(3) %373, i32 3
  %382 = load bfloat, ptr addrspace(3) %381, align 2
  %383 = getelementptr bfloat, ptr addrspace(3) %373, i32 4
  %384 = load bfloat, ptr addrspace(3) %383, align 2
  %385 = getelementptr bfloat, ptr addrspace(3) %373, i32 5
  %386 = load bfloat, ptr addrspace(3) %385, align 2
  %387 = getelementptr bfloat, ptr addrspace(3) %373, i32 6
  %388 = load bfloat, ptr addrspace(3) %387, align 2
  %389 = getelementptr bfloat, ptr addrspace(3) %373, i32 7
  %390 = load bfloat, ptr addrspace(3) %389, align 2
  %391 = getelementptr bfloat, ptr addrspace(3) %373, i32 8
  %392 = load bfloat, ptr addrspace(3) %391, align 2
  %393 = getelementptr bfloat, ptr addrspace(3) %373, i32 9
  %394 = load bfloat, ptr addrspace(3) %393, align 2
  %395 = getelementptr bfloat, ptr addrspace(3) %373, i32 10
  %396 = load bfloat, ptr addrspace(3) %395, align 2
  %397 = getelementptr bfloat, ptr addrspace(3) %373, i32 11
  %398 = load bfloat, ptr addrspace(3) %397, align 2
  %399 = getelementptr bfloat, ptr addrspace(3) %373, i32 12
  %400 = load bfloat, ptr addrspace(3) %399, align 2
  %401 = getelementptr bfloat, ptr addrspace(3) %373, i32 13
  %402 = load bfloat, ptr addrspace(3) %401, align 2
  %403 = getelementptr bfloat, ptr addrspace(3) %373, i32 14
  %404 = load bfloat, ptr addrspace(3) %403, align 2
  %405 = getelementptr bfloat, ptr addrspace(3) %373, i32 15
  %406 = load bfloat, ptr addrspace(3) %405, align 2
  %407 = insertelement <16 x bfloat> poison, bfloat %376, i64 0
  %408 = insertelement <16 x bfloat> %407, bfloat %378, i64 1
  %409 = insertelement <16 x bfloat> %408, bfloat %380, i64 2
  %410 = insertelement <16 x bfloat> %409, bfloat %382, i64 3
  %411 = insertelement <16 x bfloat> %410, bfloat %384, i64 4
  %412 = insertelement <16 x bfloat> %411, bfloat %386, i64 5
  %413 = insertelement <16 x bfloat> %412, bfloat %388, i64 6
  %414 = insertelement <16 x bfloat> %413, bfloat %390, i64 7
  %415 = insertelement <16 x bfloat> %414, bfloat %392, i64 8
  %416 = insertelement <16 x bfloat> %415, bfloat %394, i64 9
  %417 = insertelement <16 x bfloat> %416, bfloat %396, i64 10
  %418 = insertelement <16 x bfloat> %417, bfloat %398, i64 11
  %419 = insertelement <16 x bfloat> %418, bfloat %400, i64 12
  %420 = insertelement <16 x bfloat> %419, bfloat %402, i64 13
  %421 = insertelement <16 x bfloat> %420, bfloat %404, i64 14
  %422 = insertelement <16 x bfloat> %421, bfloat %406, i64 15
  %423 = load bfloat, ptr addrspace(3) %375, align 2
  %424 = getelementptr bfloat, ptr addrspace(3) %375, i32 64
  %425 = load bfloat, ptr addrspace(3) %424, align 2
  %426 = getelementptr bfloat, ptr addrspace(3) %375, i32 128
  %427 = load bfloat, ptr addrspace(3) %426, align 2
  %428 = getelementptr bfloat, ptr addrspace(3) %375, i32 192
  %429 = load bfloat, ptr addrspace(3) %428, align 2
  %430 = getelementptr bfloat, ptr addrspace(3) %375, i32 256
  %431 = load bfloat, ptr addrspace(3) %430, align 2
  %432 = getelementptr bfloat, ptr addrspace(3) %375, i32 320
  %433 = load bfloat, ptr addrspace(3) %432, align 2
  %434 = getelementptr bfloat, ptr addrspace(3) %375, i32 384
  %435 = load bfloat, ptr addrspace(3) %434, align 2
  %436 = getelementptr bfloat, ptr addrspace(3) %375, i32 448
  %437 = load bfloat, ptr addrspace(3) %436, align 2
  %438 = getelementptr bfloat, ptr addrspace(3) %375, i32 512
  %439 = load bfloat, ptr addrspace(3) %438, align 2
  %440 = getelementptr bfloat, ptr addrspace(3) %375, i32 576
  %441 = load bfloat, ptr addrspace(3) %440, align 2
  %442 = getelementptr bfloat, ptr addrspace(3) %375, i32 640
  %443 = load bfloat, ptr addrspace(3) %442, align 2
  %444 = getelementptr bfloat, ptr addrspace(3) %375, i32 704
  %445 = load bfloat, ptr addrspace(3) %444, align 2
  %446 = getelementptr bfloat, ptr addrspace(3) %375, i32 768
  %447 = load bfloat, ptr addrspace(3) %446, align 2
  %448 = getelementptr bfloat, ptr addrspace(3) %375, i32 832
  %449 = load bfloat, ptr addrspace(3) %448, align 2
  %450 = getelementptr bfloat, ptr addrspace(3) %375, i32 896
  %451 = load bfloat, ptr addrspace(3) %450, align 2
  %452 = getelementptr bfloat, ptr addrspace(3) %375, i32 960
  %453 = load bfloat, ptr addrspace(3) %452, align 2
  %454 = getelementptr bfloat, ptr addrspace(3) %375, i32 16
  %455 = load bfloat, ptr addrspace(3) %454, align 2
  %456 = getelementptr bfloat, ptr addrspace(3) %375, i32 80
  %457 = load bfloat, ptr addrspace(3) %456, align 2
  %458 = getelementptr bfloat, ptr addrspace(3) %375, i32 144
  %459 = load bfloat, ptr addrspace(3) %458, align 2
  %460 = getelementptr bfloat, ptr addrspace(3) %375, i32 208
  %461 = load bfloat, ptr addrspace(3) %460, align 2
  %462 = getelementptr bfloat, ptr addrspace(3) %375, i32 272
  %463 = load bfloat, ptr addrspace(3) %462, align 2
  %464 = getelementptr bfloat, ptr addrspace(3) %375, i32 336
  %465 = load bfloat, ptr addrspace(3) %464, align 2
  %466 = getelementptr bfloat, ptr addrspace(3) %375, i32 400
  %467 = load bfloat, ptr addrspace(3) %466, align 2
  %468 = getelementptr bfloat, ptr addrspace(3) %375, i32 464
  %469 = load bfloat, ptr addrspace(3) %468, align 2
  %470 = getelementptr bfloat, ptr addrspace(3) %375, i32 528
  %471 = load bfloat, ptr addrspace(3) %470, align 2
  %472 = getelementptr bfloat, ptr addrspace(3) %375, i32 592
  %473 = load bfloat, ptr addrspace(3) %472, align 2
  %474 = getelementptr bfloat, ptr addrspace(3) %375, i32 656
  %475 = load bfloat, ptr addrspace(3) %474, align 2
  %476 = getelementptr bfloat, ptr addrspace(3) %375, i32 720
  %477 = load bfloat, ptr addrspace(3) %476, align 2
  %478 = getelementptr bfloat, ptr addrspace(3) %375, i32 784
  %479 = load bfloat, ptr addrspace(3) %478, align 2
  %480 = getelementptr bfloat, ptr addrspace(3) %375, i32 848
  %481 = load bfloat, ptr addrspace(3) %480, align 2
  %482 = getelementptr bfloat, ptr addrspace(3) %375, i32 912
  %483 = load bfloat, ptr addrspace(3) %482, align 2
  %484 = getelementptr bfloat, ptr addrspace(3) %375, i32 976
  %485 = load bfloat, ptr addrspace(3) %484, align 2
  %486 = getelementptr bfloat, ptr addrspace(3) %375, i32 32
  %487 = load bfloat, ptr addrspace(3) %486, align 2
  %488 = getelementptr bfloat, ptr addrspace(3) %375, i32 96
  %489 = load bfloat, ptr addrspace(3) %488, align 2
  %490 = getelementptr bfloat, ptr addrspace(3) %375, i32 160
  %491 = load bfloat, ptr addrspace(3) %490, align 2
  %492 = getelementptr bfloat, ptr addrspace(3) %375, i32 224
  %493 = load bfloat, ptr addrspace(3) %492, align 2
  %494 = getelementptr bfloat, ptr addrspace(3) %375, i32 288
  %495 = load bfloat, ptr addrspace(3) %494, align 2
  %496 = getelementptr bfloat, ptr addrspace(3) %375, i32 352
  %497 = load bfloat, ptr addrspace(3) %496, align 2
  %498 = getelementptr bfloat, ptr addrspace(3) %375, i32 416
  %499 = load bfloat, ptr addrspace(3) %498, align 2
  %500 = getelementptr bfloat, ptr addrspace(3) %375, i32 480
  %501 = load bfloat, ptr addrspace(3) %500, align 2
  %502 = getelementptr bfloat, ptr addrspace(3) %375, i32 544
  %503 = load bfloat, ptr addrspace(3) %502, align 2
  %504 = getelementptr bfloat, ptr addrspace(3) %375, i32 608
  %505 = load bfloat, ptr addrspace(3) %504, align 2
  %506 = getelementptr bfloat, ptr addrspace(3) %375, i32 672
  %507 = load bfloat, ptr addrspace(3) %506, align 2
  %508 = getelementptr bfloat, ptr addrspace(3) %375, i32 736
  %509 = load bfloat, ptr addrspace(3) %508, align 2
  %510 = getelementptr bfloat, ptr addrspace(3) %375, i32 800
  %511 = load bfloat, ptr addrspace(3) %510, align 2
  %512 = getelementptr bfloat, ptr addrspace(3) %375, i32 864
  %513 = load bfloat, ptr addrspace(3) %512, align 2
  %514 = getelementptr bfloat, ptr addrspace(3) %375, i32 928
  %515 = load bfloat, ptr addrspace(3) %514, align 2
  %516 = getelementptr bfloat, ptr addrspace(3) %375, i32 992
  %517 = load bfloat, ptr addrspace(3) %516, align 2
  %518 = getelementptr bfloat, ptr addrspace(3) %375, i32 48
  %519 = load bfloat, ptr addrspace(3) %518, align 2
  %520 = getelementptr bfloat, ptr addrspace(3) %375, i32 112
  %521 = load bfloat, ptr addrspace(3) %520, align 2
  %522 = getelementptr bfloat, ptr addrspace(3) %375, i32 176
  %523 = load bfloat, ptr addrspace(3) %522, align 2
  %524 = getelementptr bfloat, ptr addrspace(3) %375, i32 240
  %525 = load bfloat, ptr addrspace(3) %524, align 2
  %526 = getelementptr bfloat, ptr addrspace(3) %375, i32 304
  %527 = load bfloat, ptr addrspace(3) %526, align 2
  %528 = getelementptr bfloat, ptr addrspace(3) %375, i32 368
  %529 = load bfloat, ptr addrspace(3) %528, align 2
  %530 = getelementptr bfloat, ptr addrspace(3) %375, i32 432
  %531 = load bfloat, ptr addrspace(3) %530, align 2
  %532 = getelementptr bfloat, ptr addrspace(3) %375, i32 496
  %533 = load bfloat, ptr addrspace(3) %532, align 2
  %534 = getelementptr bfloat, ptr addrspace(3) %375, i32 560
  %535 = load bfloat, ptr addrspace(3) %534, align 2
  %536 = getelementptr bfloat, ptr addrspace(3) %375, i32 624
  %537 = load bfloat, ptr addrspace(3) %536, align 2
  %538 = getelementptr bfloat, ptr addrspace(3) %375, i32 688
  %539 = load bfloat, ptr addrspace(3) %538, align 2
  %540 = getelementptr bfloat, ptr addrspace(3) %375, i32 752
  %541 = load bfloat, ptr addrspace(3) %540, align 2
  %542 = getelementptr bfloat, ptr addrspace(3) %375, i32 816
  %543 = load bfloat, ptr addrspace(3) %542, align 2
  %544 = getelementptr bfloat, ptr addrspace(3) %375, i32 880
  %545 = load bfloat, ptr addrspace(3) %544, align 2
  %546 = getelementptr bfloat, ptr addrspace(3) %375, i32 944
  %547 = load bfloat, ptr addrspace(3) %546, align 2
  %548 = getelementptr bfloat, ptr addrspace(3) %375, i32 1008
  %549 = load bfloat, ptr addrspace(3) %548, align 2
  %550 = insertelement <64 x bfloat> poison, bfloat %423, i64 0
  %551 = insertelement <64 x bfloat> %550, bfloat %425, i64 1
  %552 = insertelement <64 x bfloat> %551, bfloat %427, i64 2
  %553 = insertelement <64 x bfloat> %552, bfloat %429, i64 3
  %554 = insertelement <64 x bfloat> %553, bfloat %431, i64 4
  %555 = insertelement <64 x bfloat> %554, bfloat %433, i64 5
  %556 = insertelement <64 x bfloat> %555, bfloat %435, i64 6
  %557 = insertelement <64 x bfloat> %556, bfloat %437, i64 7
  %558 = insertelement <64 x bfloat> %557, bfloat %439, i64 8
  %559 = insertelement <64 x bfloat> %558, bfloat %441, i64 9
  %560 = insertelement <64 x bfloat> %559, bfloat %443, i64 10
  %561 = insertelement <64 x bfloat> %560, bfloat %445, i64 11
  %562 = insertelement <64 x bfloat> %561, bfloat %447, i64 12
  %563 = insertelement <64 x bfloat> %562, bfloat %449, i64 13
  %564 = insertelement <64 x bfloat> %563, bfloat %451, i64 14
  %565 = insertelement <64 x bfloat> %564, bfloat %453, i64 15
  %566 = insertelement <64 x bfloat> %565, bfloat %455, i64 16
  %567 = insertelement <64 x bfloat> %566, bfloat %457, i64 17
  %568 = insertelement <64 x bfloat> %567, bfloat %459, i64 18
  %569 = insertelement <64 x bfloat> %568, bfloat %461, i64 19
  %570 = insertelement <64 x bfloat> %569, bfloat %463, i64 20
  %571 = insertelement <64 x bfloat> %570, bfloat %465, i64 21
  %572 = insertelement <64 x bfloat> %571, bfloat %467, i64 22
  %573 = insertelement <64 x bfloat> %572, bfloat %469, i64 23
  %574 = insertelement <64 x bfloat> %573, bfloat %471, i64 24
  %575 = insertelement <64 x bfloat> %574, bfloat %473, i64 25
  %576 = insertelement <64 x bfloat> %575, bfloat %475, i64 26
  %577 = insertelement <64 x bfloat> %576, bfloat %477, i64 27
  %578 = insertelement <64 x bfloat> %577, bfloat %479, i64 28
  %579 = insertelement <64 x bfloat> %578, bfloat %481, i64 29
  %580 = insertelement <64 x bfloat> %579, bfloat %483, i64 30
  %581 = insertelement <64 x bfloat> %580, bfloat %485, i64 31
  %582 = insertelement <64 x bfloat> %581, bfloat %487, i64 32
  %583 = insertelement <64 x bfloat> %582, bfloat %489, i64 33
  %584 = insertelement <64 x bfloat> %583, bfloat %491, i64 34
  %585 = insertelement <64 x bfloat> %584, bfloat %493, i64 35
  %586 = insertelement <64 x bfloat> %585, bfloat %495, i64 36
  %587 = insertelement <64 x bfloat> %586, bfloat %497, i64 37
  %588 = insertelement <64 x bfloat> %587, bfloat %499, i64 38
  %589 = insertelement <64 x bfloat> %588, bfloat %501, i64 39
  %590 = insertelement <64 x bfloat> %589, bfloat %503, i64 40
  %591 = insertelement <64 x bfloat> %590, bfloat %505, i64 41
  %592 = insertelement <64 x bfloat> %591, bfloat %507, i64 42
  %593 = insertelement <64 x bfloat> %592, bfloat %509, i64 43
  %594 = insertelement <64 x bfloat> %593, bfloat %511, i64 44
  %595 = insertelement <64 x bfloat> %594, bfloat %513, i64 45
  %596 = insertelement <64 x bfloat> %595, bfloat %515, i64 46
  %597 = insertelement <64 x bfloat> %596, bfloat %517, i64 47
  %598 = insertelement <64 x bfloat> %597, bfloat %519, i64 48
  %599 = insertelement <64 x bfloat> %598, bfloat %521, i64 49
  %600 = insertelement <64 x bfloat> %599, bfloat %523, i64 50
  %601 = insertelement <64 x bfloat> %600, bfloat %525, i64 51
  %602 = insertelement <64 x bfloat> %601, bfloat %527, i64 52
  %603 = insertelement <64 x bfloat> %602, bfloat %529, i64 53
  %604 = insertelement <64 x bfloat> %603, bfloat %531, i64 54
  %605 = insertelement <64 x bfloat> %604, bfloat %533, i64 55
  %606 = insertelement <64 x bfloat> %605, bfloat %535, i64 56
  %607 = insertelement <64 x bfloat> %606, bfloat %537, i64 57
  %608 = insertelement <64 x bfloat> %607, bfloat %539, i64 58
  %609 = insertelement <64 x bfloat> %608, bfloat %541, i64 59
  %610 = insertelement <64 x bfloat> %609, bfloat %543, i64 60
  %611 = insertelement <64 x bfloat> %610, bfloat %545, i64 61
  %612 = insertelement <64 x bfloat> %611, bfloat %547, i64 62
  %613 = insertelement <64 x bfloat> %612, bfloat %549, i64 63
  %614 = shufflevector <64 x bfloat> %613, <64 x bfloat> %613, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %615 = shufflevector <32 x float> %73, <32 x float> %73, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %616 = bitcast <16 x bfloat> %422 to <16 x i16>
  %617 = bitcast <16 x bfloat> %614 to <16 x i16>
  %618 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %616, <16 x i16> %617, <8 x float> %615)
  %619 = shufflevector <8 x float> %618, <8 x float> %618, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %620 = shufflevector <32 x float> %619, <32 x float> %73, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %621 = shufflevector <64 x bfloat> %613, <64 x bfloat> %613, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %622 = shufflevector <32 x float> %620, <32 x float> %620, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %623 = bitcast <16 x bfloat> %621 to <16 x i16>
  %624 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %616, <16 x i16> %623, <8 x float> %622)
  %625 = shufflevector <8 x float> %624, <8 x float> %624, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %626 = shufflevector <32 x float> %625, <32 x float> %620, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %627 = shufflevector <64 x bfloat> %613, <64 x bfloat> %613, <16 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47>
  %628 = shufflevector <32 x float> %626, <32 x float> %626, <8 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %629 = bitcast <16 x bfloat> %627 to <16 x i16>
  %630 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %616, <16 x i16> %629, <8 x float> %628)
  %631 = shufflevector <8 x float> %630, <8 x float> %630, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %632 = shufflevector <32 x float> %631, <32 x float> %626, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %633 = shufflevector <64 x bfloat> %613, <64 x bfloat> %613, <16 x i32> <i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %634 = shufflevector <32 x float> %632, <32 x float> %632, <8 x i32> <i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %635 = bitcast <16 x bfloat> %633 to <16 x i16>
  %636 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %616, <16 x i16> %635, <8 x float> %634)
  fence syncscope("workgroup") release, !mmra !2
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire, !mmra !2
  %637 = extractelement <8 x float> %618, i64 0
  %638 = fptrunc float %637 to bfloat
  %639 = extractelement <8 x float> %618, i64 1
  %640 = fptrunc float %639 to bfloat
  %641 = extractelement <8 x float> %618, i64 2
  %642 = fptrunc float %641 to bfloat
  %643 = extractelement <8 x float> %618, i64 3
  %644 = fptrunc float %643 to bfloat
  %645 = extractelement <8 x float> %618, i64 4
  %646 = fptrunc float %645 to bfloat
  %647 = extractelement <8 x float> %618, i64 5
  %648 = fptrunc float %647 to bfloat
  %649 = extractelement <8 x float> %618, i64 6
  %650 = fptrunc float %649 to bfloat
  %651 = extractelement <8 x float> %618, i64 7
  %652 = fptrunc float %651 to bfloat
  %653 = extractelement <8 x float> %624, i64 0
  %654 = fptrunc float %653 to bfloat
  %655 = extractelement <8 x float> %624, i64 1
  %656 = fptrunc float %655 to bfloat
  %657 = extractelement <8 x float> %624, i64 2
  %658 = fptrunc float %657 to bfloat
  %659 = extractelement <8 x float> %624, i64 3
  %660 = fptrunc float %659 to bfloat
  %661 = extractelement <8 x float> %624, i64 4
  %662 = fptrunc float %661 to bfloat
  %663 = extractelement <8 x float> %624, i64 5
  %664 = fptrunc float %663 to bfloat
  %665 = extractelement <8 x float> %624, i64 6
  %666 = fptrunc float %665 to bfloat
  %667 = extractelement <8 x float> %624, i64 7
  %668 = fptrunc float %667 to bfloat
  %669 = extractelement <8 x float> %630, i64 0
  %670 = fptrunc float %669 to bfloat
  %671 = extractelement <8 x float> %630, i64 1
  %672 = fptrunc float %671 to bfloat
  %673 = extractelement <8 x float> %630, i64 2
  %674 = fptrunc float %673 to bfloat
  %675 = extractelement <8 x float> %630, i64 3
  %676 = fptrunc float %675 to bfloat
  %677 = extractelement <8 x float> %630, i64 4
  %678 = fptrunc float %677 to bfloat
  %679 = extractelement <8 x float> %630, i64 5
  %680 = fptrunc float %679 to bfloat
  %681 = extractelement <8 x float> %630, i64 6
  %682 = fptrunc float %681 to bfloat
  %683 = extractelement <8 x float> %630, i64 7
  %684 = fptrunc float %683 to bfloat
  %685 = extractelement <8 x float> %636, i64 0
  %686 = fptrunc float %685 to bfloat
  %687 = extractelement <8 x float> %636, i64 1
  %688 = fptrunc float %687 to bfloat
  %689 = extractelement <8 x float> %636, i64 2
  %690 = fptrunc float %689 to bfloat
  %691 = extractelement <8 x float> %636, i64 3
  %692 = fptrunc float %691 to bfloat
  %693 = extractelement <8 x float> %636, i64 4
  %694 = fptrunc float %693 to bfloat
  %695 = extractelement <8 x float> %636, i64 5
  %696 = fptrunc float %695 to bfloat
  %697 = extractelement <8 x float> %636, i64 6
  %698 = fptrunc float %697 to bfloat
  %699 = extractelement <8 x float> %636, i64 7
  %700 = fptrunc float %699 to bfloat
  %701 = sdiv i32 %18, 16
  %702 = mul i32 %701, 4096
  %703 = add i32 %370, %702
  %704 = add i32 %28, %703
  %705 = mul i32 %704, 2
  %706 = bitcast bfloat %638 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %706, ptr addrspace(8) %26, i32 %705, i32 0, i32 0)
  %707 = add i32 %704, 8192
  %708 = mul i32 %707, 2
  %709 = bitcast bfloat %640 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %709, ptr addrspace(8) %26, i32 %708, i32 0, i32 0)
  %710 = add i32 %704, 16384
  %711 = mul i32 %710, 2
  %712 = bitcast bfloat %642 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %712, ptr addrspace(8) %26, i32 %711, i32 0, i32 0)
  %713 = add i32 %704, 24576
  %714 = mul i32 %713, 2
  %715 = bitcast bfloat %644 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %715, ptr addrspace(8) %26, i32 %714, i32 0, i32 0)
  %716 = add i32 %704, 32768
  %717 = mul i32 %716, 2
  %718 = bitcast bfloat %646 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %718, ptr addrspace(8) %26, i32 %717, i32 0, i32 0)
  %719 = add i32 %704, 40960
  %720 = mul i32 %719, 2
  %721 = bitcast bfloat %648 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %721, ptr addrspace(8) %26, i32 %720, i32 0, i32 0)
  %722 = add i32 %704, 49152
  %723 = mul i32 %722, 2
  %724 = bitcast bfloat %650 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %724, ptr addrspace(8) %26, i32 %723, i32 0, i32 0)
  %725 = add i32 %704, 57344
  %726 = mul i32 %725, 2
  %727 = bitcast bfloat %652 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %727, ptr addrspace(8) %26, i32 %726, i32 0, i32 0)
  %728 = add i32 %704, 16
  %729 = mul i32 %728, 2
  %730 = bitcast bfloat %654 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %730, ptr addrspace(8) %26, i32 %729, i32 0, i32 0)
  %731 = add i32 %704, 8208
  %732 = mul i32 %731, 2
  %733 = bitcast bfloat %656 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %733, ptr addrspace(8) %26, i32 %732, i32 0, i32 0)
  %734 = add i32 %704, 16400
  %735 = mul i32 %734, 2
  %736 = bitcast bfloat %658 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %736, ptr addrspace(8) %26, i32 %735, i32 0, i32 0)
  %737 = add i32 %704, 24592
  %738 = mul i32 %737, 2
  %739 = bitcast bfloat %660 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %739, ptr addrspace(8) %26, i32 %738, i32 0, i32 0)
  %740 = add i32 %704, 32784
  %741 = mul i32 %740, 2
  %742 = bitcast bfloat %662 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %742, ptr addrspace(8) %26, i32 %741, i32 0, i32 0)
  %743 = add i32 %704, 40976
  %744 = mul i32 %743, 2
  %745 = bitcast bfloat %664 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %745, ptr addrspace(8) %26, i32 %744, i32 0, i32 0)
  %746 = add i32 %704, 49168
  %747 = mul i32 %746, 2
  %748 = bitcast bfloat %666 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %748, ptr addrspace(8) %26, i32 %747, i32 0, i32 0)
  %749 = add i32 %704, 57360
  %750 = mul i32 %749, 2
  %751 = bitcast bfloat %668 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %751, ptr addrspace(8) %26, i32 %750, i32 0, i32 0)
  %752 = add i32 %704, 32
  %753 = mul i32 %752, 2
  %754 = bitcast bfloat %670 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %754, ptr addrspace(8) %26, i32 %753, i32 0, i32 0)
  %755 = add i32 %704, 8224
  %756 = mul i32 %755, 2
  %757 = bitcast bfloat %672 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %757, ptr addrspace(8) %26, i32 %756, i32 0, i32 0)
  %758 = add i32 %704, 16416
  %759 = mul i32 %758, 2
  %760 = bitcast bfloat %674 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %760, ptr addrspace(8) %26, i32 %759, i32 0, i32 0)
  %761 = add i32 %704, 24608
  %762 = mul i32 %761, 2
  %763 = bitcast bfloat %676 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %763, ptr addrspace(8) %26, i32 %762, i32 0, i32 0)
  %764 = add i32 %704, 32800
  %765 = mul i32 %764, 2
  %766 = bitcast bfloat %678 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %766, ptr addrspace(8) %26, i32 %765, i32 0, i32 0)
  %767 = add i32 %704, 40992
  %768 = mul i32 %767, 2
  %769 = bitcast bfloat %680 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %769, ptr addrspace(8) %26, i32 %768, i32 0, i32 0)
  %770 = add i32 %704, 49184
  %771 = mul i32 %770, 2
  %772 = bitcast bfloat %682 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %772, ptr addrspace(8) %26, i32 %771, i32 0, i32 0)
  %773 = add i32 %704, 57376
  %774 = mul i32 %773, 2
  %775 = bitcast bfloat %684 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %775, ptr addrspace(8) %26, i32 %774, i32 0, i32 0)
  %776 = add i32 %704, 48
  %777 = mul i32 %776, 2
  %778 = bitcast bfloat %686 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %778, ptr addrspace(8) %26, i32 %777, i32 0, i32 0)
  %779 = add i32 %704, 8240
  %780 = mul i32 %779, 2
  %781 = bitcast bfloat %688 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %781, ptr addrspace(8) %26, i32 %780, i32 0, i32 0)
  %782 = add i32 %704, 16432
  %783 = mul i32 %782, 2
  %784 = bitcast bfloat %690 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %784, ptr addrspace(8) %26, i32 %783, i32 0, i32 0)
  %785 = add i32 %704, 24624
  %786 = mul i32 %785, 2
  %787 = bitcast bfloat %692 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %787, ptr addrspace(8) %26, i32 %786, i32 0, i32 0)
  %788 = add i32 %704, 32816
  %789 = mul i32 %788, 2
  %790 = bitcast bfloat %694 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %790, ptr addrspace(8) %26, i32 %789, i32 0, i32 0)
  %791 = add i32 %704, 41008
  %792 = mul i32 %791, 2
  %793 = bitcast bfloat %696 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %793, ptr addrspace(8) %26, i32 %792, i32 0, i32 0)
  %794 = add i32 %704, 49200
  %795 = mul i32 %794, 2
  %796 = bitcast bfloat %698 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %796, ptr addrspace(8) %26, i32 %795, i32 0, i32 0)
  %797 = add i32 %704, 57392
  %798 = mul i32 %797, 2
  %799 = bitcast bfloat %700 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %799, ptr addrspace(8) %26, i32 %798, i32 0, i32 0)
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
