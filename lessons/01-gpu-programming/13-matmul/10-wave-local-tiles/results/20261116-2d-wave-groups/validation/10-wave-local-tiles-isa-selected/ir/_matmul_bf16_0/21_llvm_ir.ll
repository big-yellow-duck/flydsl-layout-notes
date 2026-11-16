; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target datalayout = "e-p:64:64-p1:64:64-p2:32:32-p3:32:32-p4:64:64-p5:32:32-p6:32:32-p7:160:256:256:32-p8:128:128:128:48-p9:192:256:256:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-v2048:2048-n32:64-S32-A5-G1-ni:7:8:9"

@__shared_alloc_1 = external dso_local addrspace(3) global [2048 x i8], align 16
@__shared_alloc_0 = external dso_local addrspace(3) global [768 x i8], align 16

define amdgpu_kernel void @_matmul_bf16_0(ptr addrspace(1) %0, <{ <{ i32, i32 }>, <{ i64 }> }> %1, ptr addrspace(1) %2, <{ <{ i32, i32 }>, <{ i64 }> }> %3, ptr addrspace(1) %4, <{ <{ i32, i32 }>, <{ i64 }> }> %5) #0 !reqd_work_group_size !1 {
  %7 = call range(i32 0, 32) i32 @llvm.amdgcn.workitem.id.x()
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
  %22 = add i32 %21, %17
  %23 = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) %0, i16 0, i64 4294967295, i32 553807872)
  %24 = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) %2, i16 0, i64 4294967295, i32 553807872)
  %25 = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) %4, i16 0, i64 4294967295, i32 553807872)
  %26 = srem i32 %22, 64
  %27 = mul i32 %26, 64
  %28 = srem i32 %18, 2
  %29 = sdiv i32 %18, 2
  %30 = mul i32 %28, 8
  %31 = mul i32 %29, 24
  %32 = add i32 %30, %31
  %33 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %32
  %34 = srem i32 %18, 8
  %35 = sdiv i32 %18, 8
  %36 = mul i32 %34, 8
  %37 = mul i32 %35, 64
  %38 = add i32 %36, %37
  %39 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %38
  %40 = mul i32 %29, 8192
  %41 = add i32 %30, %40
  %42 = mul i32 %35, 4096
  %43 = add i32 %36, %42
  %44 = add i32 %27, %43
  %45 = mul i32 %41, 2
  %46 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %23, i32 %45, i32 0, i32 0)
  %47 = bitcast i128 %46 to <8 x bfloat>
  %48 = mul i32 %44, 2
  %49 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %24, i32 %48, i32 0, i32 0)
  %50 = bitcast i128 %49 to <8 x bfloat>
  %51 = add i32 %44, 16384
  %52 = mul i32 %51, 2
  %53 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %24, i32 %52, i32 0, i32 0)
  %54 = bitcast i128 %53 to <8 x bfloat>
  %55 = add i32 %44, 32768
  %56 = mul i32 %55, 2
  %57 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %24, i32 %56, i32 0, i32 0)
  %58 = bitcast i128 %57 to <8 x bfloat>
  %59 = add i32 %44, 49152
  %60 = mul i32 %59, 2
  %61 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %24, i32 %60, i32 0, i32 0)
  %62 = bitcast i128 %61 to <8 x bfloat>
  store <8 x bfloat> %47, ptr addrspace(3) %33, align 16
  store <8 x bfloat> %50, ptr addrspace(3) %39, align 16
  %63 = getelementptr bfloat, ptr addrspace(3) %39, i32 256
  store <8 x bfloat> %54, ptr addrspace(3) %63, align 16
  %64 = getelementptr bfloat, ptr addrspace(3) %39, i32 512
  store <8 x bfloat> %58, ptr addrspace(3) %64, align 16
  %65 = getelementptr bfloat, ptr addrspace(3) %39, i32 768
  store <8 x bfloat> %62, ptr addrspace(3) %65, align 16
  fence syncscope("workgroup") release
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire
  br label %66

66:                                               ; preds = %70, %6
  %67 = phi i32 [ %71, %70 ], [ 0, %6 ]
  %68 = phi <32 x float> [ %361, %70 ], [ zeroinitializer, %6 ]
  %69 = icmp slt i32 %67, 511
  br i1 %69, label %70, label %362

70:                                               ; preds = %66
  %71 = add i32 %67, 1
  %72 = mul i32 %71, 16
  %73 = mul i32 %71, 65536
  %74 = add i32 %73, %27
  %75 = add i32 %72, %41
  %76 = add i32 %74, %43
  %77 = mul i32 %75, 2
  %78 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %23, i32 %77, i32 0, i32 0)
  %79 = bitcast i128 %78 to <8 x bfloat>
  %80 = mul i32 %76, 2
  %81 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %24, i32 %80, i32 0, i32 0)
  %82 = bitcast i128 %81 to <8 x bfloat>
  %83 = add i32 %76, 16384
  %84 = mul i32 %83, 2
  %85 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %24, i32 %84, i32 0, i32 0)
  %86 = bitcast i128 %85 to <8 x bfloat>
  %87 = add i32 %76, 32768
  %88 = mul i32 %87, 2
  %89 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %24, i32 %88, i32 0, i32 0)
  %90 = bitcast i128 %89 to <8 x bfloat>
  %91 = add i32 %76, 49152
  %92 = mul i32 %91, 2
  %93 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %24, i32 %92, i32 0, i32 0)
  %94 = bitcast i128 %93 to <8 x bfloat>
  %95 = srem i32 %18, 16
  %96 = mul i32 %95, 24
  %97 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %96
  %98 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %95
  %99 = load bfloat, ptr addrspace(3) %97, align 2
  %100 = getelementptr bfloat, ptr addrspace(3) %97, i32 1
  %101 = load bfloat, ptr addrspace(3) %100, align 2
  %102 = getelementptr bfloat, ptr addrspace(3) %97, i32 2
  %103 = load bfloat, ptr addrspace(3) %102, align 2
  %104 = getelementptr bfloat, ptr addrspace(3) %97, i32 3
  %105 = load bfloat, ptr addrspace(3) %104, align 2
  %106 = getelementptr bfloat, ptr addrspace(3) %97, i32 4
  %107 = load bfloat, ptr addrspace(3) %106, align 2
  %108 = getelementptr bfloat, ptr addrspace(3) %97, i32 5
  %109 = load bfloat, ptr addrspace(3) %108, align 2
  %110 = getelementptr bfloat, ptr addrspace(3) %97, i32 6
  %111 = load bfloat, ptr addrspace(3) %110, align 2
  %112 = getelementptr bfloat, ptr addrspace(3) %97, i32 7
  %113 = load bfloat, ptr addrspace(3) %112, align 2
  %114 = getelementptr bfloat, ptr addrspace(3) %97, i32 8
  %115 = load bfloat, ptr addrspace(3) %114, align 2
  %116 = getelementptr bfloat, ptr addrspace(3) %97, i32 9
  %117 = load bfloat, ptr addrspace(3) %116, align 2
  %118 = getelementptr bfloat, ptr addrspace(3) %97, i32 10
  %119 = load bfloat, ptr addrspace(3) %118, align 2
  %120 = getelementptr bfloat, ptr addrspace(3) %97, i32 11
  %121 = load bfloat, ptr addrspace(3) %120, align 2
  %122 = getelementptr bfloat, ptr addrspace(3) %97, i32 12
  %123 = load bfloat, ptr addrspace(3) %122, align 2
  %124 = getelementptr bfloat, ptr addrspace(3) %97, i32 13
  %125 = load bfloat, ptr addrspace(3) %124, align 2
  %126 = getelementptr bfloat, ptr addrspace(3) %97, i32 14
  %127 = load bfloat, ptr addrspace(3) %126, align 2
  %128 = getelementptr bfloat, ptr addrspace(3) %97, i32 15
  %129 = load bfloat, ptr addrspace(3) %128, align 2
  %130 = insertelement <16 x bfloat> poison, bfloat %99, i64 0
  %131 = insertelement <16 x bfloat> %130, bfloat %101, i64 1
  %132 = insertelement <16 x bfloat> %131, bfloat %103, i64 2
  %133 = insertelement <16 x bfloat> %132, bfloat %105, i64 3
  %134 = insertelement <16 x bfloat> %133, bfloat %107, i64 4
  %135 = insertelement <16 x bfloat> %134, bfloat %109, i64 5
  %136 = insertelement <16 x bfloat> %135, bfloat %111, i64 6
  %137 = insertelement <16 x bfloat> %136, bfloat %113, i64 7
  %138 = insertelement <16 x bfloat> %137, bfloat %115, i64 8
  %139 = insertelement <16 x bfloat> %138, bfloat %117, i64 9
  %140 = insertelement <16 x bfloat> %139, bfloat %119, i64 10
  %141 = insertelement <16 x bfloat> %140, bfloat %121, i64 11
  %142 = insertelement <16 x bfloat> %141, bfloat %123, i64 12
  %143 = insertelement <16 x bfloat> %142, bfloat %125, i64 13
  %144 = insertelement <16 x bfloat> %143, bfloat %127, i64 14
  %145 = insertelement <16 x bfloat> %144, bfloat %129, i64 15
  %146 = load bfloat, ptr addrspace(3) %98, align 2
  %147 = getelementptr bfloat, ptr addrspace(3) %98, i32 64
  %148 = load bfloat, ptr addrspace(3) %147, align 2
  %149 = getelementptr bfloat, ptr addrspace(3) %98, i32 128
  %150 = load bfloat, ptr addrspace(3) %149, align 2
  %151 = getelementptr bfloat, ptr addrspace(3) %98, i32 192
  %152 = load bfloat, ptr addrspace(3) %151, align 2
  %153 = getelementptr bfloat, ptr addrspace(3) %98, i32 256
  %154 = load bfloat, ptr addrspace(3) %153, align 2
  %155 = getelementptr bfloat, ptr addrspace(3) %98, i32 320
  %156 = load bfloat, ptr addrspace(3) %155, align 2
  %157 = getelementptr bfloat, ptr addrspace(3) %98, i32 384
  %158 = load bfloat, ptr addrspace(3) %157, align 2
  %159 = getelementptr bfloat, ptr addrspace(3) %98, i32 448
  %160 = load bfloat, ptr addrspace(3) %159, align 2
  %161 = getelementptr bfloat, ptr addrspace(3) %98, i32 512
  %162 = load bfloat, ptr addrspace(3) %161, align 2
  %163 = getelementptr bfloat, ptr addrspace(3) %98, i32 576
  %164 = load bfloat, ptr addrspace(3) %163, align 2
  %165 = getelementptr bfloat, ptr addrspace(3) %98, i32 640
  %166 = load bfloat, ptr addrspace(3) %165, align 2
  %167 = getelementptr bfloat, ptr addrspace(3) %98, i32 704
  %168 = load bfloat, ptr addrspace(3) %167, align 2
  %169 = getelementptr bfloat, ptr addrspace(3) %98, i32 768
  %170 = load bfloat, ptr addrspace(3) %169, align 2
  %171 = getelementptr bfloat, ptr addrspace(3) %98, i32 832
  %172 = load bfloat, ptr addrspace(3) %171, align 2
  %173 = getelementptr bfloat, ptr addrspace(3) %98, i32 896
  %174 = load bfloat, ptr addrspace(3) %173, align 2
  %175 = getelementptr bfloat, ptr addrspace(3) %98, i32 960
  %176 = load bfloat, ptr addrspace(3) %175, align 2
  %177 = getelementptr bfloat, ptr addrspace(3) %98, i32 16
  %178 = load bfloat, ptr addrspace(3) %177, align 2
  %179 = getelementptr bfloat, ptr addrspace(3) %98, i32 80
  %180 = load bfloat, ptr addrspace(3) %179, align 2
  %181 = getelementptr bfloat, ptr addrspace(3) %98, i32 144
  %182 = load bfloat, ptr addrspace(3) %181, align 2
  %183 = getelementptr bfloat, ptr addrspace(3) %98, i32 208
  %184 = load bfloat, ptr addrspace(3) %183, align 2
  %185 = getelementptr bfloat, ptr addrspace(3) %98, i32 272
  %186 = load bfloat, ptr addrspace(3) %185, align 2
  %187 = getelementptr bfloat, ptr addrspace(3) %98, i32 336
  %188 = load bfloat, ptr addrspace(3) %187, align 2
  %189 = getelementptr bfloat, ptr addrspace(3) %98, i32 400
  %190 = load bfloat, ptr addrspace(3) %189, align 2
  %191 = getelementptr bfloat, ptr addrspace(3) %98, i32 464
  %192 = load bfloat, ptr addrspace(3) %191, align 2
  %193 = getelementptr bfloat, ptr addrspace(3) %98, i32 528
  %194 = load bfloat, ptr addrspace(3) %193, align 2
  %195 = getelementptr bfloat, ptr addrspace(3) %98, i32 592
  %196 = load bfloat, ptr addrspace(3) %195, align 2
  %197 = getelementptr bfloat, ptr addrspace(3) %98, i32 656
  %198 = load bfloat, ptr addrspace(3) %197, align 2
  %199 = getelementptr bfloat, ptr addrspace(3) %98, i32 720
  %200 = load bfloat, ptr addrspace(3) %199, align 2
  %201 = getelementptr bfloat, ptr addrspace(3) %98, i32 784
  %202 = load bfloat, ptr addrspace(3) %201, align 2
  %203 = getelementptr bfloat, ptr addrspace(3) %98, i32 848
  %204 = load bfloat, ptr addrspace(3) %203, align 2
  %205 = getelementptr bfloat, ptr addrspace(3) %98, i32 912
  %206 = load bfloat, ptr addrspace(3) %205, align 2
  %207 = getelementptr bfloat, ptr addrspace(3) %98, i32 976
  %208 = load bfloat, ptr addrspace(3) %207, align 2
  %209 = getelementptr bfloat, ptr addrspace(3) %98, i32 32
  %210 = load bfloat, ptr addrspace(3) %209, align 2
  %211 = getelementptr bfloat, ptr addrspace(3) %98, i32 96
  %212 = load bfloat, ptr addrspace(3) %211, align 2
  %213 = getelementptr bfloat, ptr addrspace(3) %98, i32 160
  %214 = load bfloat, ptr addrspace(3) %213, align 2
  %215 = getelementptr bfloat, ptr addrspace(3) %98, i32 224
  %216 = load bfloat, ptr addrspace(3) %215, align 2
  %217 = getelementptr bfloat, ptr addrspace(3) %98, i32 288
  %218 = load bfloat, ptr addrspace(3) %217, align 2
  %219 = getelementptr bfloat, ptr addrspace(3) %98, i32 352
  %220 = load bfloat, ptr addrspace(3) %219, align 2
  %221 = getelementptr bfloat, ptr addrspace(3) %98, i32 416
  %222 = load bfloat, ptr addrspace(3) %221, align 2
  %223 = getelementptr bfloat, ptr addrspace(3) %98, i32 480
  %224 = load bfloat, ptr addrspace(3) %223, align 2
  %225 = getelementptr bfloat, ptr addrspace(3) %98, i32 544
  %226 = load bfloat, ptr addrspace(3) %225, align 2
  %227 = getelementptr bfloat, ptr addrspace(3) %98, i32 608
  %228 = load bfloat, ptr addrspace(3) %227, align 2
  %229 = getelementptr bfloat, ptr addrspace(3) %98, i32 672
  %230 = load bfloat, ptr addrspace(3) %229, align 2
  %231 = getelementptr bfloat, ptr addrspace(3) %98, i32 736
  %232 = load bfloat, ptr addrspace(3) %231, align 2
  %233 = getelementptr bfloat, ptr addrspace(3) %98, i32 800
  %234 = load bfloat, ptr addrspace(3) %233, align 2
  %235 = getelementptr bfloat, ptr addrspace(3) %98, i32 864
  %236 = load bfloat, ptr addrspace(3) %235, align 2
  %237 = getelementptr bfloat, ptr addrspace(3) %98, i32 928
  %238 = load bfloat, ptr addrspace(3) %237, align 2
  %239 = getelementptr bfloat, ptr addrspace(3) %98, i32 992
  %240 = load bfloat, ptr addrspace(3) %239, align 2
  %241 = getelementptr bfloat, ptr addrspace(3) %98, i32 48
  %242 = load bfloat, ptr addrspace(3) %241, align 2
  %243 = getelementptr bfloat, ptr addrspace(3) %98, i32 112
  %244 = load bfloat, ptr addrspace(3) %243, align 2
  %245 = getelementptr bfloat, ptr addrspace(3) %98, i32 176
  %246 = load bfloat, ptr addrspace(3) %245, align 2
  %247 = getelementptr bfloat, ptr addrspace(3) %98, i32 240
  %248 = load bfloat, ptr addrspace(3) %247, align 2
  %249 = getelementptr bfloat, ptr addrspace(3) %98, i32 304
  %250 = load bfloat, ptr addrspace(3) %249, align 2
  %251 = getelementptr bfloat, ptr addrspace(3) %98, i32 368
  %252 = load bfloat, ptr addrspace(3) %251, align 2
  %253 = getelementptr bfloat, ptr addrspace(3) %98, i32 432
  %254 = load bfloat, ptr addrspace(3) %253, align 2
  %255 = getelementptr bfloat, ptr addrspace(3) %98, i32 496
  %256 = load bfloat, ptr addrspace(3) %255, align 2
  %257 = getelementptr bfloat, ptr addrspace(3) %98, i32 560
  %258 = load bfloat, ptr addrspace(3) %257, align 2
  %259 = getelementptr bfloat, ptr addrspace(3) %98, i32 624
  %260 = load bfloat, ptr addrspace(3) %259, align 2
  %261 = getelementptr bfloat, ptr addrspace(3) %98, i32 688
  %262 = load bfloat, ptr addrspace(3) %261, align 2
  %263 = getelementptr bfloat, ptr addrspace(3) %98, i32 752
  %264 = load bfloat, ptr addrspace(3) %263, align 2
  %265 = getelementptr bfloat, ptr addrspace(3) %98, i32 816
  %266 = load bfloat, ptr addrspace(3) %265, align 2
  %267 = getelementptr bfloat, ptr addrspace(3) %98, i32 880
  %268 = load bfloat, ptr addrspace(3) %267, align 2
  %269 = getelementptr bfloat, ptr addrspace(3) %98, i32 944
  %270 = load bfloat, ptr addrspace(3) %269, align 2
  %271 = getelementptr bfloat, ptr addrspace(3) %98, i32 1008
  %272 = load bfloat, ptr addrspace(3) %271, align 2
  %273 = insertelement <64 x bfloat> poison, bfloat %146, i64 0
  %274 = insertelement <64 x bfloat> %273, bfloat %148, i64 1
  %275 = insertelement <64 x bfloat> %274, bfloat %150, i64 2
  %276 = insertelement <64 x bfloat> %275, bfloat %152, i64 3
  %277 = insertelement <64 x bfloat> %276, bfloat %154, i64 4
  %278 = insertelement <64 x bfloat> %277, bfloat %156, i64 5
  %279 = insertelement <64 x bfloat> %278, bfloat %158, i64 6
  %280 = insertelement <64 x bfloat> %279, bfloat %160, i64 7
  %281 = insertelement <64 x bfloat> %280, bfloat %162, i64 8
  %282 = insertelement <64 x bfloat> %281, bfloat %164, i64 9
  %283 = insertelement <64 x bfloat> %282, bfloat %166, i64 10
  %284 = insertelement <64 x bfloat> %283, bfloat %168, i64 11
  %285 = insertelement <64 x bfloat> %284, bfloat %170, i64 12
  %286 = insertelement <64 x bfloat> %285, bfloat %172, i64 13
  %287 = insertelement <64 x bfloat> %286, bfloat %174, i64 14
  %288 = insertelement <64 x bfloat> %287, bfloat %176, i64 15
  %289 = insertelement <64 x bfloat> %288, bfloat %178, i64 16
  %290 = insertelement <64 x bfloat> %289, bfloat %180, i64 17
  %291 = insertelement <64 x bfloat> %290, bfloat %182, i64 18
  %292 = insertelement <64 x bfloat> %291, bfloat %184, i64 19
  %293 = insertelement <64 x bfloat> %292, bfloat %186, i64 20
  %294 = insertelement <64 x bfloat> %293, bfloat %188, i64 21
  %295 = insertelement <64 x bfloat> %294, bfloat %190, i64 22
  %296 = insertelement <64 x bfloat> %295, bfloat %192, i64 23
  %297 = insertelement <64 x bfloat> %296, bfloat %194, i64 24
  %298 = insertelement <64 x bfloat> %297, bfloat %196, i64 25
  %299 = insertelement <64 x bfloat> %298, bfloat %198, i64 26
  %300 = insertelement <64 x bfloat> %299, bfloat %200, i64 27
  %301 = insertelement <64 x bfloat> %300, bfloat %202, i64 28
  %302 = insertelement <64 x bfloat> %301, bfloat %204, i64 29
  %303 = insertelement <64 x bfloat> %302, bfloat %206, i64 30
  %304 = insertelement <64 x bfloat> %303, bfloat %208, i64 31
  %305 = insertelement <64 x bfloat> %304, bfloat %210, i64 32
  %306 = insertelement <64 x bfloat> %305, bfloat %212, i64 33
  %307 = insertelement <64 x bfloat> %306, bfloat %214, i64 34
  %308 = insertelement <64 x bfloat> %307, bfloat %216, i64 35
  %309 = insertelement <64 x bfloat> %308, bfloat %218, i64 36
  %310 = insertelement <64 x bfloat> %309, bfloat %220, i64 37
  %311 = insertelement <64 x bfloat> %310, bfloat %222, i64 38
  %312 = insertelement <64 x bfloat> %311, bfloat %224, i64 39
  %313 = insertelement <64 x bfloat> %312, bfloat %226, i64 40
  %314 = insertelement <64 x bfloat> %313, bfloat %228, i64 41
  %315 = insertelement <64 x bfloat> %314, bfloat %230, i64 42
  %316 = insertelement <64 x bfloat> %315, bfloat %232, i64 43
  %317 = insertelement <64 x bfloat> %316, bfloat %234, i64 44
  %318 = insertelement <64 x bfloat> %317, bfloat %236, i64 45
  %319 = insertelement <64 x bfloat> %318, bfloat %238, i64 46
  %320 = insertelement <64 x bfloat> %319, bfloat %240, i64 47
  %321 = insertelement <64 x bfloat> %320, bfloat %242, i64 48
  %322 = insertelement <64 x bfloat> %321, bfloat %244, i64 49
  %323 = insertelement <64 x bfloat> %322, bfloat %246, i64 50
  %324 = insertelement <64 x bfloat> %323, bfloat %248, i64 51
  %325 = insertelement <64 x bfloat> %324, bfloat %250, i64 52
  %326 = insertelement <64 x bfloat> %325, bfloat %252, i64 53
  %327 = insertelement <64 x bfloat> %326, bfloat %254, i64 54
  %328 = insertelement <64 x bfloat> %327, bfloat %256, i64 55
  %329 = insertelement <64 x bfloat> %328, bfloat %258, i64 56
  %330 = insertelement <64 x bfloat> %329, bfloat %260, i64 57
  %331 = insertelement <64 x bfloat> %330, bfloat %262, i64 58
  %332 = insertelement <64 x bfloat> %331, bfloat %264, i64 59
  %333 = insertelement <64 x bfloat> %332, bfloat %266, i64 60
  %334 = insertelement <64 x bfloat> %333, bfloat %268, i64 61
  %335 = insertelement <64 x bfloat> %334, bfloat %270, i64 62
  %336 = insertelement <64 x bfloat> %335, bfloat %272, i64 63
  %337 = shufflevector <64 x bfloat> %336, <64 x bfloat> %336, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %338 = shufflevector <32 x float> %68, <32 x float> %68, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %339 = bitcast <16 x bfloat> %145 to <16 x i16>
  %340 = bitcast <16 x bfloat> %337 to <16 x i16>
  %341 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %339, <16 x i16> %340, <8 x float> %338)
  %342 = shufflevector <8 x float> %341, <8 x float> %341, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %343 = shufflevector <32 x float> %342, <32 x float> %68, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %344 = shufflevector <64 x bfloat> %336, <64 x bfloat> %336, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %345 = shufflevector <32 x float> %343, <32 x float> %343, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %346 = bitcast <16 x bfloat> %344 to <16 x i16>
  %347 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %339, <16 x i16> %346, <8 x float> %345)
  %348 = shufflevector <8 x float> %347, <8 x float> %347, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %349 = shufflevector <32 x float> %348, <32 x float> %343, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %350 = shufflevector <64 x bfloat> %336, <64 x bfloat> %336, <16 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47>
  %351 = shufflevector <32 x float> %349, <32 x float> %349, <8 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %352 = bitcast <16 x bfloat> %350 to <16 x i16>
  %353 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %339, <16 x i16> %352, <8 x float> %351)
  %354 = shufflevector <8 x float> %353, <8 x float> %353, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %355 = shufflevector <32 x float> %354, <32 x float> %349, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %356 = shufflevector <64 x bfloat> %336, <64 x bfloat> %336, <16 x i32> <i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %357 = shufflevector <32 x float> %355, <32 x float> %355, <8 x i32> <i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %358 = bitcast <16 x bfloat> %356 to <16 x i16>
  %359 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %339, <16 x i16> %358, <8 x float> %357)
  %360 = shufflevector <8 x float> %359, <8 x float> %359, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %361 = shufflevector <32 x float> %360, <32 x float> %355, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  fence syncscope("workgroup") release
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire
  store <8 x bfloat> %79, ptr addrspace(3) %33, align 16
  store <8 x bfloat> %82, ptr addrspace(3) %39, align 16
  store <8 x bfloat> %86, ptr addrspace(3) %63, align 16
  store <8 x bfloat> %90, ptr addrspace(3) %64, align 16
  store <8 x bfloat> %94, ptr addrspace(3) %65, align 16
  fence syncscope("workgroup") release
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire
  br label %66

362:                                              ; preds = %66
  %363 = srem i32 %18, 16
  %364 = mul i32 %363, 24
  %365 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %364
  %366 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %363
  %367 = load bfloat, ptr addrspace(3) %365, align 2
  %368 = getelementptr bfloat, ptr addrspace(3) %365, i32 1
  %369 = load bfloat, ptr addrspace(3) %368, align 2
  %370 = getelementptr bfloat, ptr addrspace(3) %365, i32 2
  %371 = load bfloat, ptr addrspace(3) %370, align 2
  %372 = getelementptr bfloat, ptr addrspace(3) %365, i32 3
  %373 = load bfloat, ptr addrspace(3) %372, align 2
  %374 = getelementptr bfloat, ptr addrspace(3) %365, i32 4
  %375 = load bfloat, ptr addrspace(3) %374, align 2
  %376 = getelementptr bfloat, ptr addrspace(3) %365, i32 5
  %377 = load bfloat, ptr addrspace(3) %376, align 2
  %378 = getelementptr bfloat, ptr addrspace(3) %365, i32 6
  %379 = load bfloat, ptr addrspace(3) %378, align 2
  %380 = getelementptr bfloat, ptr addrspace(3) %365, i32 7
  %381 = load bfloat, ptr addrspace(3) %380, align 2
  %382 = getelementptr bfloat, ptr addrspace(3) %365, i32 8
  %383 = load bfloat, ptr addrspace(3) %382, align 2
  %384 = getelementptr bfloat, ptr addrspace(3) %365, i32 9
  %385 = load bfloat, ptr addrspace(3) %384, align 2
  %386 = getelementptr bfloat, ptr addrspace(3) %365, i32 10
  %387 = load bfloat, ptr addrspace(3) %386, align 2
  %388 = getelementptr bfloat, ptr addrspace(3) %365, i32 11
  %389 = load bfloat, ptr addrspace(3) %388, align 2
  %390 = getelementptr bfloat, ptr addrspace(3) %365, i32 12
  %391 = load bfloat, ptr addrspace(3) %390, align 2
  %392 = getelementptr bfloat, ptr addrspace(3) %365, i32 13
  %393 = load bfloat, ptr addrspace(3) %392, align 2
  %394 = getelementptr bfloat, ptr addrspace(3) %365, i32 14
  %395 = load bfloat, ptr addrspace(3) %394, align 2
  %396 = getelementptr bfloat, ptr addrspace(3) %365, i32 15
  %397 = load bfloat, ptr addrspace(3) %396, align 2
  %398 = insertelement <16 x bfloat> poison, bfloat %367, i64 0
  %399 = insertelement <16 x bfloat> %398, bfloat %369, i64 1
  %400 = insertelement <16 x bfloat> %399, bfloat %371, i64 2
  %401 = insertelement <16 x bfloat> %400, bfloat %373, i64 3
  %402 = insertelement <16 x bfloat> %401, bfloat %375, i64 4
  %403 = insertelement <16 x bfloat> %402, bfloat %377, i64 5
  %404 = insertelement <16 x bfloat> %403, bfloat %379, i64 6
  %405 = insertelement <16 x bfloat> %404, bfloat %381, i64 7
  %406 = insertelement <16 x bfloat> %405, bfloat %383, i64 8
  %407 = insertelement <16 x bfloat> %406, bfloat %385, i64 9
  %408 = insertelement <16 x bfloat> %407, bfloat %387, i64 10
  %409 = insertelement <16 x bfloat> %408, bfloat %389, i64 11
  %410 = insertelement <16 x bfloat> %409, bfloat %391, i64 12
  %411 = insertelement <16 x bfloat> %410, bfloat %393, i64 13
  %412 = insertelement <16 x bfloat> %411, bfloat %395, i64 14
  %413 = insertelement <16 x bfloat> %412, bfloat %397, i64 15
  %414 = load bfloat, ptr addrspace(3) %366, align 2
  %415 = getelementptr bfloat, ptr addrspace(3) %366, i32 64
  %416 = load bfloat, ptr addrspace(3) %415, align 2
  %417 = getelementptr bfloat, ptr addrspace(3) %366, i32 128
  %418 = load bfloat, ptr addrspace(3) %417, align 2
  %419 = getelementptr bfloat, ptr addrspace(3) %366, i32 192
  %420 = load bfloat, ptr addrspace(3) %419, align 2
  %421 = getelementptr bfloat, ptr addrspace(3) %366, i32 256
  %422 = load bfloat, ptr addrspace(3) %421, align 2
  %423 = getelementptr bfloat, ptr addrspace(3) %366, i32 320
  %424 = load bfloat, ptr addrspace(3) %423, align 2
  %425 = getelementptr bfloat, ptr addrspace(3) %366, i32 384
  %426 = load bfloat, ptr addrspace(3) %425, align 2
  %427 = getelementptr bfloat, ptr addrspace(3) %366, i32 448
  %428 = load bfloat, ptr addrspace(3) %427, align 2
  %429 = getelementptr bfloat, ptr addrspace(3) %366, i32 512
  %430 = load bfloat, ptr addrspace(3) %429, align 2
  %431 = getelementptr bfloat, ptr addrspace(3) %366, i32 576
  %432 = load bfloat, ptr addrspace(3) %431, align 2
  %433 = getelementptr bfloat, ptr addrspace(3) %366, i32 640
  %434 = load bfloat, ptr addrspace(3) %433, align 2
  %435 = getelementptr bfloat, ptr addrspace(3) %366, i32 704
  %436 = load bfloat, ptr addrspace(3) %435, align 2
  %437 = getelementptr bfloat, ptr addrspace(3) %366, i32 768
  %438 = load bfloat, ptr addrspace(3) %437, align 2
  %439 = getelementptr bfloat, ptr addrspace(3) %366, i32 832
  %440 = load bfloat, ptr addrspace(3) %439, align 2
  %441 = getelementptr bfloat, ptr addrspace(3) %366, i32 896
  %442 = load bfloat, ptr addrspace(3) %441, align 2
  %443 = getelementptr bfloat, ptr addrspace(3) %366, i32 960
  %444 = load bfloat, ptr addrspace(3) %443, align 2
  %445 = getelementptr bfloat, ptr addrspace(3) %366, i32 16
  %446 = load bfloat, ptr addrspace(3) %445, align 2
  %447 = getelementptr bfloat, ptr addrspace(3) %366, i32 80
  %448 = load bfloat, ptr addrspace(3) %447, align 2
  %449 = getelementptr bfloat, ptr addrspace(3) %366, i32 144
  %450 = load bfloat, ptr addrspace(3) %449, align 2
  %451 = getelementptr bfloat, ptr addrspace(3) %366, i32 208
  %452 = load bfloat, ptr addrspace(3) %451, align 2
  %453 = getelementptr bfloat, ptr addrspace(3) %366, i32 272
  %454 = load bfloat, ptr addrspace(3) %453, align 2
  %455 = getelementptr bfloat, ptr addrspace(3) %366, i32 336
  %456 = load bfloat, ptr addrspace(3) %455, align 2
  %457 = getelementptr bfloat, ptr addrspace(3) %366, i32 400
  %458 = load bfloat, ptr addrspace(3) %457, align 2
  %459 = getelementptr bfloat, ptr addrspace(3) %366, i32 464
  %460 = load bfloat, ptr addrspace(3) %459, align 2
  %461 = getelementptr bfloat, ptr addrspace(3) %366, i32 528
  %462 = load bfloat, ptr addrspace(3) %461, align 2
  %463 = getelementptr bfloat, ptr addrspace(3) %366, i32 592
  %464 = load bfloat, ptr addrspace(3) %463, align 2
  %465 = getelementptr bfloat, ptr addrspace(3) %366, i32 656
  %466 = load bfloat, ptr addrspace(3) %465, align 2
  %467 = getelementptr bfloat, ptr addrspace(3) %366, i32 720
  %468 = load bfloat, ptr addrspace(3) %467, align 2
  %469 = getelementptr bfloat, ptr addrspace(3) %366, i32 784
  %470 = load bfloat, ptr addrspace(3) %469, align 2
  %471 = getelementptr bfloat, ptr addrspace(3) %366, i32 848
  %472 = load bfloat, ptr addrspace(3) %471, align 2
  %473 = getelementptr bfloat, ptr addrspace(3) %366, i32 912
  %474 = load bfloat, ptr addrspace(3) %473, align 2
  %475 = getelementptr bfloat, ptr addrspace(3) %366, i32 976
  %476 = load bfloat, ptr addrspace(3) %475, align 2
  %477 = getelementptr bfloat, ptr addrspace(3) %366, i32 32
  %478 = load bfloat, ptr addrspace(3) %477, align 2
  %479 = getelementptr bfloat, ptr addrspace(3) %366, i32 96
  %480 = load bfloat, ptr addrspace(3) %479, align 2
  %481 = getelementptr bfloat, ptr addrspace(3) %366, i32 160
  %482 = load bfloat, ptr addrspace(3) %481, align 2
  %483 = getelementptr bfloat, ptr addrspace(3) %366, i32 224
  %484 = load bfloat, ptr addrspace(3) %483, align 2
  %485 = getelementptr bfloat, ptr addrspace(3) %366, i32 288
  %486 = load bfloat, ptr addrspace(3) %485, align 2
  %487 = getelementptr bfloat, ptr addrspace(3) %366, i32 352
  %488 = load bfloat, ptr addrspace(3) %487, align 2
  %489 = getelementptr bfloat, ptr addrspace(3) %366, i32 416
  %490 = load bfloat, ptr addrspace(3) %489, align 2
  %491 = getelementptr bfloat, ptr addrspace(3) %366, i32 480
  %492 = load bfloat, ptr addrspace(3) %491, align 2
  %493 = getelementptr bfloat, ptr addrspace(3) %366, i32 544
  %494 = load bfloat, ptr addrspace(3) %493, align 2
  %495 = getelementptr bfloat, ptr addrspace(3) %366, i32 608
  %496 = load bfloat, ptr addrspace(3) %495, align 2
  %497 = getelementptr bfloat, ptr addrspace(3) %366, i32 672
  %498 = load bfloat, ptr addrspace(3) %497, align 2
  %499 = getelementptr bfloat, ptr addrspace(3) %366, i32 736
  %500 = load bfloat, ptr addrspace(3) %499, align 2
  %501 = getelementptr bfloat, ptr addrspace(3) %366, i32 800
  %502 = load bfloat, ptr addrspace(3) %501, align 2
  %503 = getelementptr bfloat, ptr addrspace(3) %366, i32 864
  %504 = load bfloat, ptr addrspace(3) %503, align 2
  %505 = getelementptr bfloat, ptr addrspace(3) %366, i32 928
  %506 = load bfloat, ptr addrspace(3) %505, align 2
  %507 = getelementptr bfloat, ptr addrspace(3) %366, i32 992
  %508 = load bfloat, ptr addrspace(3) %507, align 2
  %509 = getelementptr bfloat, ptr addrspace(3) %366, i32 48
  %510 = load bfloat, ptr addrspace(3) %509, align 2
  %511 = getelementptr bfloat, ptr addrspace(3) %366, i32 112
  %512 = load bfloat, ptr addrspace(3) %511, align 2
  %513 = getelementptr bfloat, ptr addrspace(3) %366, i32 176
  %514 = load bfloat, ptr addrspace(3) %513, align 2
  %515 = getelementptr bfloat, ptr addrspace(3) %366, i32 240
  %516 = load bfloat, ptr addrspace(3) %515, align 2
  %517 = getelementptr bfloat, ptr addrspace(3) %366, i32 304
  %518 = load bfloat, ptr addrspace(3) %517, align 2
  %519 = getelementptr bfloat, ptr addrspace(3) %366, i32 368
  %520 = load bfloat, ptr addrspace(3) %519, align 2
  %521 = getelementptr bfloat, ptr addrspace(3) %366, i32 432
  %522 = load bfloat, ptr addrspace(3) %521, align 2
  %523 = getelementptr bfloat, ptr addrspace(3) %366, i32 496
  %524 = load bfloat, ptr addrspace(3) %523, align 2
  %525 = getelementptr bfloat, ptr addrspace(3) %366, i32 560
  %526 = load bfloat, ptr addrspace(3) %525, align 2
  %527 = getelementptr bfloat, ptr addrspace(3) %366, i32 624
  %528 = load bfloat, ptr addrspace(3) %527, align 2
  %529 = getelementptr bfloat, ptr addrspace(3) %366, i32 688
  %530 = load bfloat, ptr addrspace(3) %529, align 2
  %531 = getelementptr bfloat, ptr addrspace(3) %366, i32 752
  %532 = load bfloat, ptr addrspace(3) %531, align 2
  %533 = getelementptr bfloat, ptr addrspace(3) %366, i32 816
  %534 = load bfloat, ptr addrspace(3) %533, align 2
  %535 = getelementptr bfloat, ptr addrspace(3) %366, i32 880
  %536 = load bfloat, ptr addrspace(3) %535, align 2
  %537 = getelementptr bfloat, ptr addrspace(3) %366, i32 944
  %538 = load bfloat, ptr addrspace(3) %537, align 2
  %539 = getelementptr bfloat, ptr addrspace(3) %366, i32 1008
  %540 = load bfloat, ptr addrspace(3) %539, align 2
  %541 = insertelement <64 x bfloat> poison, bfloat %414, i64 0
  %542 = insertelement <64 x bfloat> %541, bfloat %416, i64 1
  %543 = insertelement <64 x bfloat> %542, bfloat %418, i64 2
  %544 = insertelement <64 x bfloat> %543, bfloat %420, i64 3
  %545 = insertelement <64 x bfloat> %544, bfloat %422, i64 4
  %546 = insertelement <64 x bfloat> %545, bfloat %424, i64 5
  %547 = insertelement <64 x bfloat> %546, bfloat %426, i64 6
  %548 = insertelement <64 x bfloat> %547, bfloat %428, i64 7
  %549 = insertelement <64 x bfloat> %548, bfloat %430, i64 8
  %550 = insertelement <64 x bfloat> %549, bfloat %432, i64 9
  %551 = insertelement <64 x bfloat> %550, bfloat %434, i64 10
  %552 = insertelement <64 x bfloat> %551, bfloat %436, i64 11
  %553 = insertelement <64 x bfloat> %552, bfloat %438, i64 12
  %554 = insertelement <64 x bfloat> %553, bfloat %440, i64 13
  %555 = insertelement <64 x bfloat> %554, bfloat %442, i64 14
  %556 = insertelement <64 x bfloat> %555, bfloat %444, i64 15
  %557 = insertelement <64 x bfloat> %556, bfloat %446, i64 16
  %558 = insertelement <64 x bfloat> %557, bfloat %448, i64 17
  %559 = insertelement <64 x bfloat> %558, bfloat %450, i64 18
  %560 = insertelement <64 x bfloat> %559, bfloat %452, i64 19
  %561 = insertelement <64 x bfloat> %560, bfloat %454, i64 20
  %562 = insertelement <64 x bfloat> %561, bfloat %456, i64 21
  %563 = insertelement <64 x bfloat> %562, bfloat %458, i64 22
  %564 = insertelement <64 x bfloat> %563, bfloat %460, i64 23
  %565 = insertelement <64 x bfloat> %564, bfloat %462, i64 24
  %566 = insertelement <64 x bfloat> %565, bfloat %464, i64 25
  %567 = insertelement <64 x bfloat> %566, bfloat %466, i64 26
  %568 = insertelement <64 x bfloat> %567, bfloat %468, i64 27
  %569 = insertelement <64 x bfloat> %568, bfloat %470, i64 28
  %570 = insertelement <64 x bfloat> %569, bfloat %472, i64 29
  %571 = insertelement <64 x bfloat> %570, bfloat %474, i64 30
  %572 = insertelement <64 x bfloat> %571, bfloat %476, i64 31
  %573 = insertelement <64 x bfloat> %572, bfloat %478, i64 32
  %574 = insertelement <64 x bfloat> %573, bfloat %480, i64 33
  %575 = insertelement <64 x bfloat> %574, bfloat %482, i64 34
  %576 = insertelement <64 x bfloat> %575, bfloat %484, i64 35
  %577 = insertelement <64 x bfloat> %576, bfloat %486, i64 36
  %578 = insertelement <64 x bfloat> %577, bfloat %488, i64 37
  %579 = insertelement <64 x bfloat> %578, bfloat %490, i64 38
  %580 = insertelement <64 x bfloat> %579, bfloat %492, i64 39
  %581 = insertelement <64 x bfloat> %580, bfloat %494, i64 40
  %582 = insertelement <64 x bfloat> %581, bfloat %496, i64 41
  %583 = insertelement <64 x bfloat> %582, bfloat %498, i64 42
  %584 = insertelement <64 x bfloat> %583, bfloat %500, i64 43
  %585 = insertelement <64 x bfloat> %584, bfloat %502, i64 44
  %586 = insertelement <64 x bfloat> %585, bfloat %504, i64 45
  %587 = insertelement <64 x bfloat> %586, bfloat %506, i64 46
  %588 = insertelement <64 x bfloat> %587, bfloat %508, i64 47
  %589 = insertelement <64 x bfloat> %588, bfloat %510, i64 48
  %590 = insertelement <64 x bfloat> %589, bfloat %512, i64 49
  %591 = insertelement <64 x bfloat> %590, bfloat %514, i64 50
  %592 = insertelement <64 x bfloat> %591, bfloat %516, i64 51
  %593 = insertelement <64 x bfloat> %592, bfloat %518, i64 52
  %594 = insertelement <64 x bfloat> %593, bfloat %520, i64 53
  %595 = insertelement <64 x bfloat> %594, bfloat %522, i64 54
  %596 = insertelement <64 x bfloat> %595, bfloat %524, i64 55
  %597 = insertelement <64 x bfloat> %596, bfloat %526, i64 56
  %598 = insertelement <64 x bfloat> %597, bfloat %528, i64 57
  %599 = insertelement <64 x bfloat> %598, bfloat %530, i64 58
  %600 = insertelement <64 x bfloat> %599, bfloat %532, i64 59
  %601 = insertelement <64 x bfloat> %600, bfloat %534, i64 60
  %602 = insertelement <64 x bfloat> %601, bfloat %536, i64 61
  %603 = insertelement <64 x bfloat> %602, bfloat %538, i64 62
  %604 = insertelement <64 x bfloat> %603, bfloat %540, i64 63
  %605 = shufflevector <64 x bfloat> %604, <64 x bfloat> %604, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %606 = shufflevector <32 x float> %68, <32 x float> %68, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %607 = bitcast <16 x bfloat> %413 to <16 x i16>
  %608 = bitcast <16 x bfloat> %605 to <16 x i16>
  %609 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %607, <16 x i16> %608, <8 x float> %606)
  %610 = shufflevector <8 x float> %609, <8 x float> %609, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %611 = shufflevector <32 x float> %610, <32 x float> %68, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %612 = shufflevector <64 x bfloat> %604, <64 x bfloat> %604, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %613 = shufflevector <32 x float> %611, <32 x float> %611, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %614 = bitcast <16 x bfloat> %612 to <16 x i16>
  %615 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %607, <16 x i16> %614, <8 x float> %613)
  %616 = shufflevector <8 x float> %615, <8 x float> %615, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %617 = shufflevector <32 x float> %616, <32 x float> %611, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %618 = shufflevector <64 x bfloat> %604, <64 x bfloat> %604, <16 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47>
  %619 = shufflevector <32 x float> %617, <32 x float> %617, <8 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %620 = bitcast <16 x bfloat> %618 to <16 x i16>
  %621 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %607, <16 x i16> %620, <8 x float> %619)
  %622 = shufflevector <8 x float> %621, <8 x float> %621, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %623 = shufflevector <32 x float> %622, <32 x float> %617, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %624 = shufflevector <64 x bfloat> %604, <64 x bfloat> %604, <16 x i32> <i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %625 = shufflevector <32 x float> %623, <32 x float> %623, <8 x i32> <i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %626 = bitcast <16 x bfloat> %624 to <16 x i16>
  %627 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %607, <16 x i16> %626, <8 x float> %625)
  fence syncscope("workgroup") release
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire
  %628 = extractelement <8 x float> %609, i64 0
  %629 = fptrunc float %628 to bfloat
  %630 = extractelement <8 x float> %609, i64 1
  %631 = fptrunc float %630 to bfloat
  %632 = extractelement <8 x float> %609, i64 2
  %633 = fptrunc float %632 to bfloat
  %634 = extractelement <8 x float> %609, i64 3
  %635 = fptrunc float %634 to bfloat
  %636 = extractelement <8 x float> %609, i64 4
  %637 = fptrunc float %636 to bfloat
  %638 = extractelement <8 x float> %609, i64 5
  %639 = fptrunc float %638 to bfloat
  %640 = extractelement <8 x float> %609, i64 6
  %641 = fptrunc float %640 to bfloat
  %642 = extractelement <8 x float> %609, i64 7
  %643 = fptrunc float %642 to bfloat
  %644 = extractelement <8 x float> %615, i64 0
  %645 = fptrunc float %644 to bfloat
  %646 = extractelement <8 x float> %615, i64 1
  %647 = fptrunc float %646 to bfloat
  %648 = extractelement <8 x float> %615, i64 2
  %649 = fptrunc float %648 to bfloat
  %650 = extractelement <8 x float> %615, i64 3
  %651 = fptrunc float %650 to bfloat
  %652 = extractelement <8 x float> %615, i64 4
  %653 = fptrunc float %652 to bfloat
  %654 = extractelement <8 x float> %615, i64 5
  %655 = fptrunc float %654 to bfloat
  %656 = extractelement <8 x float> %615, i64 6
  %657 = fptrunc float %656 to bfloat
  %658 = extractelement <8 x float> %615, i64 7
  %659 = fptrunc float %658 to bfloat
  %660 = extractelement <8 x float> %621, i64 0
  %661 = fptrunc float %660 to bfloat
  %662 = extractelement <8 x float> %621, i64 1
  %663 = fptrunc float %662 to bfloat
  %664 = extractelement <8 x float> %621, i64 2
  %665 = fptrunc float %664 to bfloat
  %666 = extractelement <8 x float> %621, i64 3
  %667 = fptrunc float %666 to bfloat
  %668 = extractelement <8 x float> %621, i64 4
  %669 = fptrunc float %668 to bfloat
  %670 = extractelement <8 x float> %621, i64 5
  %671 = fptrunc float %670 to bfloat
  %672 = extractelement <8 x float> %621, i64 6
  %673 = fptrunc float %672 to bfloat
  %674 = extractelement <8 x float> %621, i64 7
  %675 = fptrunc float %674 to bfloat
  %676 = extractelement <8 x float> %627, i64 0
  %677 = fptrunc float %676 to bfloat
  %678 = extractelement <8 x float> %627, i64 1
  %679 = fptrunc float %678 to bfloat
  %680 = extractelement <8 x float> %627, i64 2
  %681 = fptrunc float %680 to bfloat
  %682 = extractelement <8 x float> %627, i64 3
  %683 = fptrunc float %682 to bfloat
  %684 = extractelement <8 x float> %627, i64 4
  %685 = fptrunc float %684 to bfloat
  %686 = extractelement <8 x float> %627, i64 5
  %687 = fptrunc float %686 to bfloat
  %688 = extractelement <8 x float> %627, i64 6
  %689 = fptrunc float %688 to bfloat
  %690 = extractelement <8 x float> %627, i64 7
  %691 = fptrunc float %690 to bfloat
  %692 = sdiv i32 %18, 16
  %693 = mul i32 %692, 4096
  %694 = add i32 %363, %693
  %695 = add i32 %27, %694
  %696 = mul i32 %695, 2
  %697 = bitcast bfloat %629 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %697, ptr addrspace(8) %25, i32 %696, i32 0, i32 0)
  %698 = add i32 %695, 8192
  %699 = mul i32 %698, 2
  %700 = bitcast bfloat %631 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %700, ptr addrspace(8) %25, i32 %699, i32 0, i32 0)
  %701 = add i32 %695, 16384
  %702 = mul i32 %701, 2
  %703 = bitcast bfloat %633 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %703, ptr addrspace(8) %25, i32 %702, i32 0, i32 0)
  %704 = add i32 %695, 24576
  %705 = mul i32 %704, 2
  %706 = bitcast bfloat %635 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %706, ptr addrspace(8) %25, i32 %705, i32 0, i32 0)
  %707 = add i32 %695, 32768
  %708 = mul i32 %707, 2
  %709 = bitcast bfloat %637 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %709, ptr addrspace(8) %25, i32 %708, i32 0, i32 0)
  %710 = add i32 %695, 40960
  %711 = mul i32 %710, 2
  %712 = bitcast bfloat %639 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %712, ptr addrspace(8) %25, i32 %711, i32 0, i32 0)
  %713 = add i32 %695, 49152
  %714 = mul i32 %713, 2
  %715 = bitcast bfloat %641 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %715, ptr addrspace(8) %25, i32 %714, i32 0, i32 0)
  %716 = add i32 %695, 57344
  %717 = mul i32 %716, 2
  %718 = bitcast bfloat %643 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %718, ptr addrspace(8) %25, i32 %717, i32 0, i32 0)
  %719 = add i32 %695, 16
  %720 = mul i32 %719, 2
  %721 = bitcast bfloat %645 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %721, ptr addrspace(8) %25, i32 %720, i32 0, i32 0)
  %722 = add i32 %695, 8208
  %723 = mul i32 %722, 2
  %724 = bitcast bfloat %647 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %724, ptr addrspace(8) %25, i32 %723, i32 0, i32 0)
  %725 = add i32 %695, 16400
  %726 = mul i32 %725, 2
  %727 = bitcast bfloat %649 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %727, ptr addrspace(8) %25, i32 %726, i32 0, i32 0)
  %728 = add i32 %695, 24592
  %729 = mul i32 %728, 2
  %730 = bitcast bfloat %651 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %730, ptr addrspace(8) %25, i32 %729, i32 0, i32 0)
  %731 = add i32 %695, 32784
  %732 = mul i32 %731, 2
  %733 = bitcast bfloat %653 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %733, ptr addrspace(8) %25, i32 %732, i32 0, i32 0)
  %734 = add i32 %695, 40976
  %735 = mul i32 %734, 2
  %736 = bitcast bfloat %655 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %736, ptr addrspace(8) %25, i32 %735, i32 0, i32 0)
  %737 = add i32 %695, 49168
  %738 = mul i32 %737, 2
  %739 = bitcast bfloat %657 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %739, ptr addrspace(8) %25, i32 %738, i32 0, i32 0)
  %740 = add i32 %695, 57360
  %741 = mul i32 %740, 2
  %742 = bitcast bfloat %659 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %742, ptr addrspace(8) %25, i32 %741, i32 0, i32 0)
  %743 = add i32 %695, 32
  %744 = mul i32 %743, 2
  %745 = bitcast bfloat %661 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %745, ptr addrspace(8) %25, i32 %744, i32 0, i32 0)
  %746 = add i32 %695, 8224
  %747 = mul i32 %746, 2
  %748 = bitcast bfloat %663 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %748, ptr addrspace(8) %25, i32 %747, i32 0, i32 0)
  %749 = add i32 %695, 16416
  %750 = mul i32 %749, 2
  %751 = bitcast bfloat %665 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %751, ptr addrspace(8) %25, i32 %750, i32 0, i32 0)
  %752 = add i32 %695, 24608
  %753 = mul i32 %752, 2
  %754 = bitcast bfloat %667 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %754, ptr addrspace(8) %25, i32 %753, i32 0, i32 0)
  %755 = add i32 %695, 32800
  %756 = mul i32 %755, 2
  %757 = bitcast bfloat %669 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %757, ptr addrspace(8) %25, i32 %756, i32 0, i32 0)
  %758 = add i32 %695, 40992
  %759 = mul i32 %758, 2
  %760 = bitcast bfloat %671 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %760, ptr addrspace(8) %25, i32 %759, i32 0, i32 0)
  %761 = add i32 %695, 49184
  %762 = mul i32 %761, 2
  %763 = bitcast bfloat %673 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %763, ptr addrspace(8) %25, i32 %762, i32 0, i32 0)
  %764 = add i32 %695, 57376
  %765 = mul i32 %764, 2
  %766 = bitcast bfloat %675 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %766, ptr addrspace(8) %25, i32 %765, i32 0, i32 0)
  %767 = add i32 %695, 48
  %768 = mul i32 %767, 2
  %769 = bitcast bfloat %677 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %769, ptr addrspace(8) %25, i32 %768, i32 0, i32 0)
  %770 = add i32 %695, 8240
  %771 = mul i32 %770, 2
  %772 = bitcast bfloat %679 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %772, ptr addrspace(8) %25, i32 %771, i32 0, i32 0)
  %773 = add i32 %695, 16432
  %774 = mul i32 %773, 2
  %775 = bitcast bfloat %681 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %775, ptr addrspace(8) %25, i32 %774, i32 0, i32 0)
  %776 = add i32 %695, 24624
  %777 = mul i32 %776, 2
  %778 = bitcast bfloat %683 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %778, ptr addrspace(8) %25, i32 %777, i32 0, i32 0)
  %779 = add i32 %695, 32816
  %780 = mul i32 %779, 2
  %781 = bitcast bfloat %685 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %781, ptr addrspace(8) %25, i32 %780, i32 0, i32 0)
  %782 = add i32 %695, 41008
  %783 = mul i32 %782, 2
  %784 = bitcast bfloat %687 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %784, ptr addrspace(8) %25, i32 %783, i32 0, i32 0)
  %785 = add i32 %695, 49200
  %786 = mul i32 %785, 2
  %787 = bitcast bfloat %689 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %787, ptr addrspace(8) %25, i32 %786, i32 0, i32 0)
  %788 = add i32 %695, 57392
  %789 = mul i32 %788, 2
  %790 = bitcast bfloat %691 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %790, ptr addrspace(8) %25, i32 %789, i32 0, i32 0)
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
