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
  %28 = mul i32 %17, 384
  %29 = mul i32 %17, 1024
  %30 = srem i32 %18, 2
  %31 = sdiv i32 %18, 2
  %32 = mul i32 %30, 8
  %33 = mul i32 %31, 24
  %34 = add i32 %32, %33
  %35 = add i32 %28, %34
  %36 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %35
  %37 = srem i32 %18, 8
  %38 = sdiv i32 %18, 8
  %39 = mul i32 %37, 8
  %40 = mul i32 %38, 64
  %41 = add i32 %39, %40
  %42 = add i32 %29, %41
  %43 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %42
  %44 = mul i32 %31, 8192
  %45 = add i32 %32, %44
  %46 = mul i32 %38, 4096
  %47 = add i32 %39, %46
  %48 = add i32 %27, %47
  %49 = mul i32 %45, 2
  %50 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %23, i32 %49, i32 0, i32 0)
  %51 = bitcast i128 %50 to <8 x bfloat>
  %52 = mul i32 %48, 2
  %53 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %24, i32 %52, i32 0, i32 0)
  %54 = bitcast i128 %53 to <8 x bfloat>
  %55 = add i32 %48, 16384
  %56 = mul i32 %55, 2
  %57 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %24, i32 %56, i32 0, i32 0)
  %58 = bitcast i128 %57 to <8 x bfloat>
  %59 = add i32 %48, 32768
  %60 = mul i32 %59, 2
  %61 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %24, i32 %60, i32 0, i32 0)
  %62 = bitcast i128 %61 to <8 x bfloat>
  %63 = add i32 %48, 49152
  %64 = mul i32 %63, 2
  %65 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %24, i32 %64, i32 0, i32 0)
  %66 = bitcast i128 %65 to <8 x bfloat>
  store <8 x bfloat> %51, ptr addrspace(3) %36, align 16
  store <8 x bfloat> %54, ptr addrspace(3) %43, align 16
  %67 = getelementptr bfloat, ptr addrspace(3) %43, i32 256
  store <8 x bfloat> %58, ptr addrspace(3) %67, align 16
  %68 = getelementptr bfloat, ptr addrspace(3) %43, i32 512
  store <8 x bfloat> %62, ptr addrspace(3) %68, align 16
  %69 = getelementptr bfloat, ptr addrspace(3) %43, i32 768
  store <8 x bfloat> %66, ptr addrspace(3) %69, align 16
  fence syncscope("workgroup") release, !mmra !2
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire, !mmra !2
  br label %70

70:                                               ; preds = %74, %6
  %71 = phi i32 [ %75, %74 ], [ 0, %6 ]
  %72 = phi <32 x float> [ %367, %74 ], [ zeroinitializer, %6 ]
  %73 = icmp slt i32 %71, 511
  br i1 %73, label %74, label %368

74:                                               ; preds = %70
  %75 = add i32 %71, 1
  %76 = mul i32 %75, 16
  %77 = mul i32 %75, 65536
  %78 = add i32 %77, %27
  %79 = add i32 %76, %45
  %80 = add i32 %78, %47
  %81 = mul i32 %79, 2
  %82 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %23, i32 %81, i32 0, i32 0)
  %83 = bitcast i128 %82 to <8 x bfloat>
  %84 = mul i32 %80, 2
  %85 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %24, i32 %84, i32 0, i32 0)
  %86 = bitcast i128 %85 to <8 x bfloat>
  %87 = add i32 %80, 16384
  %88 = mul i32 %87, 2
  %89 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %24, i32 %88, i32 0, i32 0)
  %90 = bitcast i128 %89 to <8 x bfloat>
  %91 = add i32 %80, 32768
  %92 = mul i32 %91, 2
  %93 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %24, i32 %92, i32 0, i32 0)
  %94 = bitcast i128 %93 to <8 x bfloat>
  %95 = add i32 %80, 49152
  %96 = mul i32 %95, 2
  %97 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %24, i32 %96, i32 0, i32 0)
  %98 = bitcast i128 %97 to <8 x bfloat>
  %99 = srem i32 %18, 16
  %100 = mul i32 %99, 24
  %101 = add i32 %28, %100
  %102 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %101
  %103 = add i32 %29, %99
  %104 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %103
  %105 = load bfloat, ptr addrspace(3) %102, align 2
  %106 = getelementptr bfloat, ptr addrspace(3) %102, i32 1
  %107 = load bfloat, ptr addrspace(3) %106, align 2
  %108 = getelementptr bfloat, ptr addrspace(3) %102, i32 2
  %109 = load bfloat, ptr addrspace(3) %108, align 2
  %110 = getelementptr bfloat, ptr addrspace(3) %102, i32 3
  %111 = load bfloat, ptr addrspace(3) %110, align 2
  %112 = getelementptr bfloat, ptr addrspace(3) %102, i32 4
  %113 = load bfloat, ptr addrspace(3) %112, align 2
  %114 = getelementptr bfloat, ptr addrspace(3) %102, i32 5
  %115 = load bfloat, ptr addrspace(3) %114, align 2
  %116 = getelementptr bfloat, ptr addrspace(3) %102, i32 6
  %117 = load bfloat, ptr addrspace(3) %116, align 2
  %118 = getelementptr bfloat, ptr addrspace(3) %102, i32 7
  %119 = load bfloat, ptr addrspace(3) %118, align 2
  %120 = getelementptr bfloat, ptr addrspace(3) %102, i32 8
  %121 = load bfloat, ptr addrspace(3) %120, align 2
  %122 = getelementptr bfloat, ptr addrspace(3) %102, i32 9
  %123 = load bfloat, ptr addrspace(3) %122, align 2
  %124 = getelementptr bfloat, ptr addrspace(3) %102, i32 10
  %125 = load bfloat, ptr addrspace(3) %124, align 2
  %126 = getelementptr bfloat, ptr addrspace(3) %102, i32 11
  %127 = load bfloat, ptr addrspace(3) %126, align 2
  %128 = getelementptr bfloat, ptr addrspace(3) %102, i32 12
  %129 = load bfloat, ptr addrspace(3) %128, align 2
  %130 = getelementptr bfloat, ptr addrspace(3) %102, i32 13
  %131 = load bfloat, ptr addrspace(3) %130, align 2
  %132 = getelementptr bfloat, ptr addrspace(3) %102, i32 14
  %133 = load bfloat, ptr addrspace(3) %132, align 2
  %134 = getelementptr bfloat, ptr addrspace(3) %102, i32 15
  %135 = load bfloat, ptr addrspace(3) %134, align 2
  %136 = insertelement <16 x bfloat> poison, bfloat %105, i64 0
  %137 = insertelement <16 x bfloat> %136, bfloat %107, i64 1
  %138 = insertelement <16 x bfloat> %137, bfloat %109, i64 2
  %139 = insertelement <16 x bfloat> %138, bfloat %111, i64 3
  %140 = insertelement <16 x bfloat> %139, bfloat %113, i64 4
  %141 = insertelement <16 x bfloat> %140, bfloat %115, i64 5
  %142 = insertelement <16 x bfloat> %141, bfloat %117, i64 6
  %143 = insertelement <16 x bfloat> %142, bfloat %119, i64 7
  %144 = insertelement <16 x bfloat> %143, bfloat %121, i64 8
  %145 = insertelement <16 x bfloat> %144, bfloat %123, i64 9
  %146 = insertelement <16 x bfloat> %145, bfloat %125, i64 10
  %147 = insertelement <16 x bfloat> %146, bfloat %127, i64 11
  %148 = insertelement <16 x bfloat> %147, bfloat %129, i64 12
  %149 = insertelement <16 x bfloat> %148, bfloat %131, i64 13
  %150 = insertelement <16 x bfloat> %149, bfloat %133, i64 14
  %151 = insertelement <16 x bfloat> %150, bfloat %135, i64 15
  %152 = load bfloat, ptr addrspace(3) %104, align 2
  %153 = getelementptr bfloat, ptr addrspace(3) %104, i32 64
  %154 = load bfloat, ptr addrspace(3) %153, align 2
  %155 = getelementptr bfloat, ptr addrspace(3) %104, i32 128
  %156 = load bfloat, ptr addrspace(3) %155, align 2
  %157 = getelementptr bfloat, ptr addrspace(3) %104, i32 192
  %158 = load bfloat, ptr addrspace(3) %157, align 2
  %159 = getelementptr bfloat, ptr addrspace(3) %104, i32 256
  %160 = load bfloat, ptr addrspace(3) %159, align 2
  %161 = getelementptr bfloat, ptr addrspace(3) %104, i32 320
  %162 = load bfloat, ptr addrspace(3) %161, align 2
  %163 = getelementptr bfloat, ptr addrspace(3) %104, i32 384
  %164 = load bfloat, ptr addrspace(3) %163, align 2
  %165 = getelementptr bfloat, ptr addrspace(3) %104, i32 448
  %166 = load bfloat, ptr addrspace(3) %165, align 2
  %167 = getelementptr bfloat, ptr addrspace(3) %104, i32 512
  %168 = load bfloat, ptr addrspace(3) %167, align 2
  %169 = getelementptr bfloat, ptr addrspace(3) %104, i32 576
  %170 = load bfloat, ptr addrspace(3) %169, align 2
  %171 = getelementptr bfloat, ptr addrspace(3) %104, i32 640
  %172 = load bfloat, ptr addrspace(3) %171, align 2
  %173 = getelementptr bfloat, ptr addrspace(3) %104, i32 704
  %174 = load bfloat, ptr addrspace(3) %173, align 2
  %175 = getelementptr bfloat, ptr addrspace(3) %104, i32 768
  %176 = load bfloat, ptr addrspace(3) %175, align 2
  %177 = getelementptr bfloat, ptr addrspace(3) %104, i32 832
  %178 = load bfloat, ptr addrspace(3) %177, align 2
  %179 = getelementptr bfloat, ptr addrspace(3) %104, i32 896
  %180 = load bfloat, ptr addrspace(3) %179, align 2
  %181 = getelementptr bfloat, ptr addrspace(3) %104, i32 960
  %182 = load bfloat, ptr addrspace(3) %181, align 2
  %183 = getelementptr bfloat, ptr addrspace(3) %104, i32 16
  %184 = load bfloat, ptr addrspace(3) %183, align 2
  %185 = getelementptr bfloat, ptr addrspace(3) %104, i32 80
  %186 = load bfloat, ptr addrspace(3) %185, align 2
  %187 = getelementptr bfloat, ptr addrspace(3) %104, i32 144
  %188 = load bfloat, ptr addrspace(3) %187, align 2
  %189 = getelementptr bfloat, ptr addrspace(3) %104, i32 208
  %190 = load bfloat, ptr addrspace(3) %189, align 2
  %191 = getelementptr bfloat, ptr addrspace(3) %104, i32 272
  %192 = load bfloat, ptr addrspace(3) %191, align 2
  %193 = getelementptr bfloat, ptr addrspace(3) %104, i32 336
  %194 = load bfloat, ptr addrspace(3) %193, align 2
  %195 = getelementptr bfloat, ptr addrspace(3) %104, i32 400
  %196 = load bfloat, ptr addrspace(3) %195, align 2
  %197 = getelementptr bfloat, ptr addrspace(3) %104, i32 464
  %198 = load bfloat, ptr addrspace(3) %197, align 2
  %199 = getelementptr bfloat, ptr addrspace(3) %104, i32 528
  %200 = load bfloat, ptr addrspace(3) %199, align 2
  %201 = getelementptr bfloat, ptr addrspace(3) %104, i32 592
  %202 = load bfloat, ptr addrspace(3) %201, align 2
  %203 = getelementptr bfloat, ptr addrspace(3) %104, i32 656
  %204 = load bfloat, ptr addrspace(3) %203, align 2
  %205 = getelementptr bfloat, ptr addrspace(3) %104, i32 720
  %206 = load bfloat, ptr addrspace(3) %205, align 2
  %207 = getelementptr bfloat, ptr addrspace(3) %104, i32 784
  %208 = load bfloat, ptr addrspace(3) %207, align 2
  %209 = getelementptr bfloat, ptr addrspace(3) %104, i32 848
  %210 = load bfloat, ptr addrspace(3) %209, align 2
  %211 = getelementptr bfloat, ptr addrspace(3) %104, i32 912
  %212 = load bfloat, ptr addrspace(3) %211, align 2
  %213 = getelementptr bfloat, ptr addrspace(3) %104, i32 976
  %214 = load bfloat, ptr addrspace(3) %213, align 2
  %215 = getelementptr bfloat, ptr addrspace(3) %104, i32 32
  %216 = load bfloat, ptr addrspace(3) %215, align 2
  %217 = getelementptr bfloat, ptr addrspace(3) %104, i32 96
  %218 = load bfloat, ptr addrspace(3) %217, align 2
  %219 = getelementptr bfloat, ptr addrspace(3) %104, i32 160
  %220 = load bfloat, ptr addrspace(3) %219, align 2
  %221 = getelementptr bfloat, ptr addrspace(3) %104, i32 224
  %222 = load bfloat, ptr addrspace(3) %221, align 2
  %223 = getelementptr bfloat, ptr addrspace(3) %104, i32 288
  %224 = load bfloat, ptr addrspace(3) %223, align 2
  %225 = getelementptr bfloat, ptr addrspace(3) %104, i32 352
  %226 = load bfloat, ptr addrspace(3) %225, align 2
  %227 = getelementptr bfloat, ptr addrspace(3) %104, i32 416
  %228 = load bfloat, ptr addrspace(3) %227, align 2
  %229 = getelementptr bfloat, ptr addrspace(3) %104, i32 480
  %230 = load bfloat, ptr addrspace(3) %229, align 2
  %231 = getelementptr bfloat, ptr addrspace(3) %104, i32 544
  %232 = load bfloat, ptr addrspace(3) %231, align 2
  %233 = getelementptr bfloat, ptr addrspace(3) %104, i32 608
  %234 = load bfloat, ptr addrspace(3) %233, align 2
  %235 = getelementptr bfloat, ptr addrspace(3) %104, i32 672
  %236 = load bfloat, ptr addrspace(3) %235, align 2
  %237 = getelementptr bfloat, ptr addrspace(3) %104, i32 736
  %238 = load bfloat, ptr addrspace(3) %237, align 2
  %239 = getelementptr bfloat, ptr addrspace(3) %104, i32 800
  %240 = load bfloat, ptr addrspace(3) %239, align 2
  %241 = getelementptr bfloat, ptr addrspace(3) %104, i32 864
  %242 = load bfloat, ptr addrspace(3) %241, align 2
  %243 = getelementptr bfloat, ptr addrspace(3) %104, i32 928
  %244 = load bfloat, ptr addrspace(3) %243, align 2
  %245 = getelementptr bfloat, ptr addrspace(3) %104, i32 992
  %246 = load bfloat, ptr addrspace(3) %245, align 2
  %247 = getelementptr bfloat, ptr addrspace(3) %104, i32 48
  %248 = load bfloat, ptr addrspace(3) %247, align 2
  %249 = getelementptr bfloat, ptr addrspace(3) %104, i32 112
  %250 = load bfloat, ptr addrspace(3) %249, align 2
  %251 = getelementptr bfloat, ptr addrspace(3) %104, i32 176
  %252 = load bfloat, ptr addrspace(3) %251, align 2
  %253 = getelementptr bfloat, ptr addrspace(3) %104, i32 240
  %254 = load bfloat, ptr addrspace(3) %253, align 2
  %255 = getelementptr bfloat, ptr addrspace(3) %104, i32 304
  %256 = load bfloat, ptr addrspace(3) %255, align 2
  %257 = getelementptr bfloat, ptr addrspace(3) %104, i32 368
  %258 = load bfloat, ptr addrspace(3) %257, align 2
  %259 = getelementptr bfloat, ptr addrspace(3) %104, i32 432
  %260 = load bfloat, ptr addrspace(3) %259, align 2
  %261 = getelementptr bfloat, ptr addrspace(3) %104, i32 496
  %262 = load bfloat, ptr addrspace(3) %261, align 2
  %263 = getelementptr bfloat, ptr addrspace(3) %104, i32 560
  %264 = load bfloat, ptr addrspace(3) %263, align 2
  %265 = getelementptr bfloat, ptr addrspace(3) %104, i32 624
  %266 = load bfloat, ptr addrspace(3) %265, align 2
  %267 = getelementptr bfloat, ptr addrspace(3) %104, i32 688
  %268 = load bfloat, ptr addrspace(3) %267, align 2
  %269 = getelementptr bfloat, ptr addrspace(3) %104, i32 752
  %270 = load bfloat, ptr addrspace(3) %269, align 2
  %271 = getelementptr bfloat, ptr addrspace(3) %104, i32 816
  %272 = load bfloat, ptr addrspace(3) %271, align 2
  %273 = getelementptr bfloat, ptr addrspace(3) %104, i32 880
  %274 = load bfloat, ptr addrspace(3) %273, align 2
  %275 = getelementptr bfloat, ptr addrspace(3) %104, i32 944
  %276 = load bfloat, ptr addrspace(3) %275, align 2
  %277 = getelementptr bfloat, ptr addrspace(3) %104, i32 1008
  %278 = load bfloat, ptr addrspace(3) %277, align 2
  %279 = insertelement <64 x bfloat> poison, bfloat %152, i64 0
  %280 = insertelement <64 x bfloat> %279, bfloat %154, i64 1
  %281 = insertelement <64 x bfloat> %280, bfloat %156, i64 2
  %282 = insertelement <64 x bfloat> %281, bfloat %158, i64 3
  %283 = insertelement <64 x bfloat> %282, bfloat %160, i64 4
  %284 = insertelement <64 x bfloat> %283, bfloat %162, i64 5
  %285 = insertelement <64 x bfloat> %284, bfloat %164, i64 6
  %286 = insertelement <64 x bfloat> %285, bfloat %166, i64 7
  %287 = insertelement <64 x bfloat> %286, bfloat %168, i64 8
  %288 = insertelement <64 x bfloat> %287, bfloat %170, i64 9
  %289 = insertelement <64 x bfloat> %288, bfloat %172, i64 10
  %290 = insertelement <64 x bfloat> %289, bfloat %174, i64 11
  %291 = insertelement <64 x bfloat> %290, bfloat %176, i64 12
  %292 = insertelement <64 x bfloat> %291, bfloat %178, i64 13
  %293 = insertelement <64 x bfloat> %292, bfloat %180, i64 14
  %294 = insertelement <64 x bfloat> %293, bfloat %182, i64 15
  %295 = insertelement <64 x bfloat> %294, bfloat %184, i64 16
  %296 = insertelement <64 x bfloat> %295, bfloat %186, i64 17
  %297 = insertelement <64 x bfloat> %296, bfloat %188, i64 18
  %298 = insertelement <64 x bfloat> %297, bfloat %190, i64 19
  %299 = insertelement <64 x bfloat> %298, bfloat %192, i64 20
  %300 = insertelement <64 x bfloat> %299, bfloat %194, i64 21
  %301 = insertelement <64 x bfloat> %300, bfloat %196, i64 22
  %302 = insertelement <64 x bfloat> %301, bfloat %198, i64 23
  %303 = insertelement <64 x bfloat> %302, bfloat %200, i64 24
  %304 = insertelement <64 x bfloat> %303, bfloat %202, i64 25
  %305 = insertelement <64 x bfloat> %304, bfloat %204, i64 26
  %306 = insertelement <64 x bfloat> %305, bfloat %206, i64 27
  %307 = insertelement <64 x bfloat> %306, bfloat %208, i64 28
  %308 = insertelement <64 x bfloat> %307, bfloat %210, i64 29
  %309 = insertelement <64 x bfloat> %308, bfloat %212, i64 30
  %310 = insertelement <64 x bfloat> %309, bfloat %214, i64 31
  %311 = insertelement <64 x bfloat> %310, bfloat %216, i64 32
  %312 = insertelement <64 x bfloat> %311, bfloat %218, i64 33
  %313 = insertelement <64 x bfloat> %312, bfloat %220, i64 34
  %314 = insertelement <64 x bfloat> %313, bfloat %222, i64 35
  %315 = insertelement <64 x bfloat> %314, bfloat %224, i64 36
  %316 = insertelement <64 x bfloat> %315, bfloat %226, i64 37
  %317 = insertelement <64 x bfloat> %316, bfloat %228, i64 38
  %318 = insertelement <64 x bfloat> %317, bfloat %230, i64 39
  %319 = insertelement <64 x bfloat> %318, bfloat %232, i64 40
  %320 = insertelement <64 x bfloat> %319, bfloat %234, i64 41
  %321 = insertelement <64 x bfloat> %320, bfloat %236, i64 42
  %322 = insertelement <64 x bfloat> %321, bfloat %238, i64 43
  %323 = insertelement <64 x bfloat> %322, bfloat %240, i64 44
  %324 = insertelement <64 x bfloat> %323, bfloat %242, i64 45
  %325 = insertelement <64 x bfloat> %324, bfloat %244, i64 46
  %326 = insertelement <64 x bfloat> %325, bfloat %246, i64 47
  %327 = insertelement <64 x bfloat> %326, bfloat %248, i64 48
  %328 = insertelement <64 x bfloat> %327, bfloat %250, i64 49
  %329 = insertelement <64 x bfloat> %328, bfloat %252, i64 50
  %330 = insertelement <64 x bfloat> %329, bfloat %254, i64 51
  %331 = insertelement <64 x bfloat> %330, bfloat %256, i64 52
  %332 = insertelement <64 x bfloat> %331, bfloat %258, i64 53
  %333 = insertelement <64 x bfloat> %332, bfloat %260, i64 54
  %334 = insertelement <64 x bfloat> %333, bfloat %262, i64 55
  %335 = insertelement <64 x bfloat> %334, bfloat %264, i64 56
  %336 = insertelement <64 x bfloat> %335, bfloat %266, i64 57
  %337 = insertelement <64 x bfloat> %336, bfloat %268, i64 58
  %338 = insertelement <64 x bfloat> %337, bfloat %270, i64 59
  %339 = insertelement <64 x bfloat> %338, bfloat %272, i64 60
  %340 = insertelement <64 x bfloat> %339, bfloat %274, i64 61
  %341 = insertelement <64 x bfloat> %340, bfloat %276, i64 62
  %342 = insertelement <64 x bfloat> %341, bfloat %278, i64 63
  %343 = shufflevector <64 x bfloat> %342, <64 x bfloat> %342, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %344 = shufflevector <32 x float> %72, <32 x float> %72, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %345 = bitcast <16 x bfloat> %151 to <16 x i16>
  %346 = bitcast <16 x bfloat> %343 to <16 x i16>
  %347 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %345, <16 x i16> %346, <8 x float> %344)
  %348 = shufflevector <8 x float> %347, <8 x float> %347, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %349 = shufflevector <32 x float> %348, <32 x float> %72, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %350 = shufflevector <64 x bfloat> %342, <64 x bfloat> %342, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %351 = shufflevector <32 x float> %349, <32 x float> %349, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %352 = bitcast <16 x bfloat> %350 to <16 x i16>
  %353 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %345, <16 x i16> %352, <8 x float> %351)
  %354 = shufflevector <8 x float> %353, <8 x float> %353, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %355 = shufflevector <32 x float> %354, <32 x float> %349, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %356 = shufflevector <64 x bfloat> %342, <64 x bfloat> %342, <16 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47>
  %357 = shufflevector <32 x float> %355, <32 x float> %355, <8 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %358 = bitcast <16 x bfloat> %356 to <16 x i16>
  %359 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %345, <16 x i16> %358, <8 x float> %357)
  %360 = shufflevector <8 x float> %359, <8 x float> %359, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %361 = shufflevector <32 x float> %360, <32 x float> %355, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %362 = shufflevector <64 x bfloat> %342, <64 x bfloat> %342, <16 x i32> <i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %363 = shufflevector <32 x float> %361, <32 x float> %361, <8 x i32> <i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %364 = bitcast <16 x bfloat> %362 to <16 x i16>
  %365 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %345, <16 x i16> %364, <8 x float> %363)
  %366 = shufflevector <8 x float> %365, <8 x float> %365, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %367 = shufflevector <32 x float> %366, <32 x float> %361, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  fence syncscope("workgroup") release, !mmra !2
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire, !mmra !2
  store <8 x bfloat> %83, ptr addrspace(3) %36, align 16
  store <8 x bfloat> %86, ptr addrspace(3) %43, align 16
  store <8 x bfloat> %90, ptr addrspace(3) %67, align 16
  store <8 x bfloat> %94, ptr addrspace(3) %68, align 16
  store <8 x bfloat> %98, ptr addrspace(3) %69, align 16
  fence syncscope("workgroup") release, !mmra !2
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire, !mmra !2
  br label %70

368:                                              ; preds = %70
  %369 = srem i32 %18, 16
  %370 = mul i32 %369, 24
  %371 = add i32 %28, %370
  %372 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %371
  %373 = add i32 %29, %369
  %374 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %373
  %375 = load bfloat, ptr addrspace(3) %372, align 2
  %376 = getelementptr bfloat, ptr addrspace(3) %372, i32 1
  %377 = load bfloat, ptr addrspace(3) %376, align 2
  %378 = getelementptr bfloat, ptr addrspace(3) %372, i32 2
  %379 = load bfloat, ptr addrspace(3) %378, align 2
  %380 = getelementptr bfloat, ptr addrspace(3) %372, i32 3
  %381 = load bfloat, ptr addrspace(3) %380, align 2
  %382 = getelementptr bfloat, ptr addrspace(3) %372, i32 4
  %383 = load bfloat, ptr addrspace(3) %382, align 2
  %384 = getelementptr bfloat, ptr addrspace(3) %372, i32 5
  %385 = load bfloat, ptr addrspace(3) %384, align 2
  %386 = getelementptr bfloat, ptr addrspace(3) %372, i32 6
  %387 = load bfloat, ptr addrspace(3) %386, align 2
  %388 = getelementptr bfloat, ptr addrspace(3) %372, i32 7
  %389 = load bfloat, ptr addrspace(3) %388, align 2
  %390 = getelementptr bfloat, ptr addrspace(3) %372, i32 8
  %391 = load bfloat, ptr addrspace(3) %390, align 2
  %392 = getelementptr bfloat, ptr addrspace(3) %372, i32 9
  %393 = load bfloat, ptr addrspace(3) %392, align 2
  %394 = getelementptr bfloat, ptr addrspace(3) %372, i32 10
  %395 = load bfloat, ptr addrspace(3) %394, align 2
  %396 = getelementptr bfloat, ptr addrspace(3) %372, i32 11
  %397 = load bfloat, ptr addrspace(3) %396, align 2
  %398 = getelementptr bfloat, ptr addrspace(3) %372, i32 12
  %399 = load bfloat, ptr addrspace(3) %398, align 2
  %400 = getelementptr bfloat, ptr addrspace(3) %372, i32 13
  %401 = load bfloat, ptr addrspace(3) %400, align 2
  %402 = getelementptr bfloat, ptr addrspace(3) %372, i32 14
  %403 = load bfloat, ptr addrspace(3) %402, align 2
  %404 = getelementptr bfloat, ptr addrspace(3) %372, i32 15
  %405 = load bfloat, ptr addrspace(3) %404, align 2
  %406 = insertelement <16 x bfloat> poison, bfloat %375, i64 0
  %407 = insertelement <16 x bfloat> %406, bfloat %377, i64 1
  %408 = insertelement <16 x bfloat> %407, bfloat %379, i64 2
  %409 = insertelement <16 x bfloat> %408, bfloat %381, i64 3
  %410 = insertelement <16 x bfloat> %409, bfloat %383, i64 4
  %411 = insertelement <16 x bfloat> %410, bfloat %385, i64 5
  %412 = insertelement <16 x bfloat> %411, bfloat %387, i64 6
  %413 = insertelement <16 x bfloat> %412, bfloat %389, i64 7
  %414 = insertelement <16 x bfloat> %413, bfloat %391, i64 8
  %415 = insertelement <16 x bfloat> %414, bfloat %393, i64 9
  %416 = insertelement <16 x bfloat> %415, bfloat %395, i64 10
  %417 = insertelement <16 x bfloat> %416, bfloat %397, i64 11
  %418 = insertelement <16 x bfloat> %417, bfloat %399, i64 12
  %419 = insertelement <16 x bfloat> %418, bfloat %401, i64 13
  %420 = insertelement <16 x bfloat> %419, bfloat %403, i64 14
  %421 = insertelement <16 x bfloat> %420, bfloat %405, i64 15
  %422 = load bfloat, ptr addrspace(3) %374, align 2
  %423 = getelementptr bfloat, ptr addrspace(3) %374, i32 64
  %424 = load bfloat, ptr addrspace(3) %423, align 2
  %425 = getelementptr bfloat, ptr addrspace(3) %374, i32 128
  %426 = load bfloat, ptr addrspace(3) %425, align 2
  %427 = getelementptr bfloat, ptr addrspace(3) %374, i32 192
  %428 = load bfloat, ptr addrspace(3) %427, align 2
  %429 = getelementptr bfloat, ptr addrspace(3) %374, i32 256
  %430 = load bfloat, ptr addrspace(3) %429, align 2
  %431 = getelementptr bfloat, ptr addrspace(3) %374, i32 320
  %432 = load bfloat, ptr addrspace(3) %431, align 2
  %433 = getelementptr bfloat, ptr addrspace(3) %374, i32 384
  %434 = load bfloat, ptr addrspace(3) %433, align 2
  %435 = getelementptr bfloat, ptr addrspace(3) %374, i32 448
  %436 = load bfloat, ptr addrspace(3) %435, align 2
  %437 = getelementptr bfloat, ptr addrspace(3) %374, i32 512
  %438 = load bfloat, ptr addrspace(3) %437, align 2
  %439 = getelementptr bfloat, ptr addrspace(3) %374, i32 576
  %440 = load bfloat, ptr addrspace(3) %439, align 2
  %441 = getelementptr bfloat, ptr addrspace(3) %374, i32 640
  %442 = load bfloat, ptr addrspace(3) %441, align 2
  %443 = getelementptr bfloat, ptr addrspace(3) %374, i32 704
  %444 = load bfloat, ptr addrspace(3) %443, align 2
  %445 = getelementptr bfloat, ptr addrspace(3) %374, i32 768
  %446 = load bfloat, ptr addrspace(3) %445, align 2
  %447 = getelementptr bfloat, ptr addrspace(3) %374, i32 832
  %448 = load bfloat, ptr addrspace(3) %447, align 2
  %449 = getelementptr bfloat, ptr addrspace(3) %374, i32 896
  %450 = load bfloat, ptr addrspace(3) %449, align 2
  %451 = getelementptr bfloat, ptr addrspace(3) %374, i32 960
  %452 = load bfloat, ptr addrspace(3) %451, align 2
  %453 = getelementptr bfloat, ptr addrspace(3) %374, i32 16
  %454 = load bfloat, ptr addrspace(3) %453, align 2
  %455 = getelementptr bfloat, ptr addrspace(3) %374, i32 80
  %456 = load bfloat, ptr addrspace(3) %455, align 2
  %457 = getelementptr bfloat, ptr addrspace(3) %374, i32 144
  %458 = load bfloat, ptr addrspace(3) %457, align 2
  %459 = getelementptr bfloat, ptr addrspace(3) %374, i32 208
  %460 = load bfloat, ptr addrspace(3) %459, align 2
  %461 = getelementptr bfloat, ptr addrspace(3) %374, i32 272
  %462 = load bfloat, ptr addrspace(3) %461, align 2
  %463 = getelementptr bfloat, ptr addrspace(3) %374, i32 336
  %464 = load bfloat, ptr addrspace(3) %463, align 2
  %465 = getelementptr bfloat, ptr addrspace(3) %374, i32 400
  %466 = load bfloat, ptr addrspace(3) %465, align 2
  %467 = getelementptr bfloat, ptr addrspace(3) %374, i32 464
  %468 = load bfloat, ptr addrspace(3) %467, align 2
  %469 = getelementptr bfloat, ptr addrspace(3) %374, i32 528
  %470 = load bfloat, ptr addrspace(3) %469, align 2
  %471 = getelementptr bfloat, ptr addrspace(3) %374, i32 592
  %472 = load bfloat, ptr addrspace(3) %471, align 2
  %473 = getelementptr bfloat, ptr addrspace(3) %374, i32 656
  %474 = load bfloat, ptr addrspace(3) %473, align 2
  %475 = getelementptr bfloat, ptr addrspace(3) %374, i32 720
  %476 = load bfloat, ptr addrspace(3) %475, align 2
  %477 = getelementptr bfloat, ptr addrspace(3) %374, i32 784
  %478 = load bfloat, ptr addrspace(3) %477, align 2
  %479 = getelementptr bfloat, ptr addrspace(3) %374, i32 848
  %480 = load bfloat, ptr addrspace(3) %479, align 2
  %481 = getelementptr bfloat, ptr addrspace(3) %374, i32 912
  %482 = load bfloat, ptr addrspace(3) %481, align 2
  %483 = getelementptr bfloat, ptr addrspace(3) %374, i32 976
  %484 = load bfloat, ptr addrspace(3) %483, align 2
  %485 = getelementptr bfloat, ptr addrspace(3) %374, i32 32
  %486 = load bfloat, ptr addrspace(3) %485, align 2
  %487 = getelementptr bfloat, ptr addrspace(3) %374, i32 96
  %488 = load bfloat, ptr addrspace(3) %487, align 2
  %489 = getelementptr bfloat, ptr addrspace(3) %374, i32 160
  %490 = load bfloat, ptr addrspace(3) %489, align 2
  %491 = getelementptr bfloat, ptr addrspace(3) %374, i32 224
  %492 = load bfloat, ptr addrspace(3) %491, align 2
  %493 = getelementptr bfloat, ptr addrspace(3) %374, i32 288
  %494 = load bfloat, ptr addrspace(3) %493, align 2
  %495 = getelementptr bfloat, ptr addrspace(3) %374, i32 352
  %496 = load bfloat, ptr addrspace(3) %495, align 2
  %497 = getelementptr bfloat, ptr addrspace(3) %374, i32 416
  %498 = load bfloat, ptr addrspace(3) %497, align 2
  %499 = getelementptr bfloat, ptr addrspace(3) %374, i32 480
  %500 = load bfloat, ptr addrspace(3) %499, align 2
  %501 = getelementptr bfloat, ptr addrspace(3) %374, i32 544
  %502 = load bfloat, ptr addrspace(3) %501, align 2
  %503 = getelementptr bfloat, ptr addrspace(3) %374, i32 608
  %504 = load bfloat, ptr addrspace(3) %503, align 2
  %505 = getelementptr bfloat, ptr addrspace(3) %374, i32 672
  %506 = load bfloat, ptr addrspace(3) %505, align 2
  %507 = getelementptr bfloat, ptr addrspace(3) %374, i32 736
  %508 = load bfloat, ptr addrspace(3) %507, align 2
  %509 = getelementptr bfloat, ptr addrspace(3) %374, i32 800
  %510 = load bfloat, ptr addrspace(3) %509, align 2
  %511 = getelementptr bfloat, ptr addrspace(3) %374, i32 864
  %512 = load bfloat, ptr addrspace(3) %511, align 2
  %513 = getelementptr bfloat, ptr addrspace(3) %374, i32 928
  %514 = load bfloat, ptr addrspace(3) %513, align 2
  %515 = getelementptr bfloat, ptr addrspace(3) %374, i32 992
  %516 = load bfloat, ptr addrspace(3) %515, align 2
  %517 = getelementptr bfloat, ptr addrspace(3) %374, i32 48
  %518 = load bfloat, ptr addrspace(3) %517, align 2
  %519 = getelementptr bfloat, ptr addrspace(3) %374, i32 112
  %520 = load bfloat, ptr addrspace(3) %519, align 2
  %521 = getelementptr bfloat, ptr addrspace(3) %374, i32 176
  %522 = load bfloat, ptr addrspace(3) %521, align 2
  %523 = getelementptr bfloat, ptr addrspace(3) %374, i32 240
  %524 = load bfloat, ptr addrspace(3) %523, align 2
  %525 = getelementptr bfloat, ptr addrspace(3) %374, i32 304
  %526 = load bfloat, ptr addrspace(3) %525, align 2
  %527 = getelementptr bfloat, ptr addrspace(3) %374, i32 368
  %528 = load bfloat, ptr addrspace(3) %527, align 2
  %529 = getelementptr bfloat, ptr addrspace(3) %374, i32 432
  %530 = load bfloat, ptr addrspace(3) %529, align 2
  %531 = getelementptr bfloat, ptr addrspace(3) %374, i32 496
  %532 = load bfloat, ptr addrspace(3) %531, align 2
  %533 = getelementptr bfloat, ptr addrspace(3) %374, i32 560
  %534 = load bfloat, ptr addrspace(3) %533, align 2
  %535 = getelementptr bfloat, ptr addrspace(3) %374, i32 624
  %536 = load bfloat, ptr addrspace(3) %535, align 2
  %537 = getelementptr bfloat, ptr addrspace(3) %374, i32 688
  %538 = load bfloat, ptr addrspace(3) %537, align 2
  %539 = getelementptr bfloat, ptr addrspace(3) %374, i32 752
  %540 = load bfloat, ptr addrspace(3) %539, align 2
  %541 = getelementptr bfloat, ptr addrspace(3) %374, i32 816
  %542 = load bfloat, ptr addrspace(3) %541, align 2
  %543 = getelementptr bfloat, ptr addrspace(3) %374, i32 880
  %544 = load bfloat, ptr addrspace(3) %543, align 2
  %545 = getelementptr bfloat, ptr addrspace(3) %374, i32 944
  %546 = load bfloat, ptr addrspace(3) %545, align 2
  %547 = getelementptr bfloat, ptr addrspace(3) %374, i32 1008
  %548 = load bfloat, ptr addrspace(3) %547, align 2
  %549 = insertelement <64 x bfloat> poison, bfloat %422, i64 0
  %550 = insertelement <64 x bfloat> %549, bfloat %424, i64 1
  %551 = insertelement <64 x bfloat> %550, bfloat %426, i64 2
  %552 = insertelement <64 x bfloat> %551, bfloat %428, i64 3
  %553 = insertelement <64 x bfloat> %552, bfloat %430, i64 4
  %554 = insertelement <64 x bfloat> %553, bfloat %432, i64 5
  %555 = insertelement <64 x bfloat> %554, bfloat %434, i64 6
  %556 = insertelement <64 x bfloat> %555, bfloat %436, i64 7
  %557 = insertelement <64 x bfloat> %556, bfloat %438, i64 8
  %558 = insertelement <64 x bfloat> %557, bfloat %440, i64 9
  %559 = insertelement <64 x bfloat> %558, bfloat %442, i64 10
  %560 = insertelement <64 x bfloat> %559, bfloat %444, i64 11
  %561 = insertelement <64 x bfloat> %560, bfloat %446, i64 12
  %562 = insertelement <64 x bfloat> %561, bfloat %448, i64 13
  %563 = insertelement <64 x bfloat> %562, bfloat %450, i64 14
  %564 = insertelement <64 x bfloat> %563, bfloat %452, i64 15
  %565 = insertelement <64 x bfloat> %564, bfloat %454, i64 16
  %566 = insertelement <64 x bfloat> %565, bfloat %456, i64 17
  %567 = insertelement <64 x bfloat> %566, bfloat %458, i64 18
  %568 = insertelement <64 x bfloat> %567, bfloat %460, i64 19
  %569 = insertelement <64 x bfloat> %568, bfloat %462, i64 20
  %570 = insertelement <64 x bfloat> %569, bfloat %464, i64 21
  %571 = insertelement <64 x bfloat> %570, bfloat %466, i64 22
  %572 = insertelement <64 x bfloat> %571, bfloat %468, i64 23
  %573 = insertelement <64 x bfloat> %572, bfloat %470, i64 24
  %574 = insertelement <64 x bfloat> %573, bfloat %472, i64 25
  %575 = insertelement <64 x bfloat> %574, bfloat %474, i64 26
  %576 = insertelement <64 x bfloat> %575, bfloat %476, i64 27
  %577 = insertelement <64 x bfloat> %576, bfloat %478, i64 28
  %578 = insertelement <64 x bfloat> %577, bfloat %480, i64 29
  %579 = insertelement <64 x bfloat> %578, bfloat %482, i64 30
  %580 = insertelement <64 x bfloat> %579, bfloat %484, i64 31
  %581 = insertelement <64 x bfloat> %580, bfloat %486, i64 32
  %582 = insertelement <64 x bfloat> %581, bfloat %488, i64 33
  %583 = insertelement <64 x bfloat> %582, bfloat %490, i64 34
  %584 = insertelement <64 x bfloat> %583, bfloat %492, i64 35
  %585 = insertelement <64 x bfloat> %584, bfloat %494, i64 36
  %586 = insertelement <64 x bfloat> %585, bfloat %496, i64 37
  %587 = insertelement <64 x bfloat> %586, bfloat %498, i64 38
  %588 = insertelement <64 x bfloat> %587, bfloat %500, i64 39
  %589 = insertelement <64 x bfloat> %588, bfloat %502, i64 40
  %590 = insertelement <64 x bfloat> %589, bfloat %504, i64 41
  %591 = insertelement <64 x bfloat> %590, bfloat %506, i64 42
  %592 = insertelement <64 x bfloat> %591, bfloat %508, i64 43
  %593 = insertelement <64 x bfloat> %592, bfloat %510, i64 44
  %594 = insertelement <64 x bfloat> %593, bfloat %512, i64 45
  %595 = insertelement <64 x bfloat> %594, bfloat %514, i64 46
  %596 = insertelement <64 x bfloat> %595, bfloat %516, i64 47
  %597 = insertelement <64 x bfloat> %596, bfloat %518, i64 48
  %598 = insertelement <64 x bfloat> %597, bfloat %520, i64 49
  %599 = insertelement <64 x bfloat> %598, bfloat %522, i64 50
  %600 = insertelement <64 x bfloat> %599, bfloat %524, i64 51
  %601 = insertelement <64 x bfloat> %600, bfloat %526, i64 52
  %602 = insertelement <64 x bfloat> %601, bfloat %528, i64 53
  %603 = insertelement <64 x bfloat> %602, bfloat %530, i64 54
  %604 = insertelement <64 x bfloat> %603, bfloat %532, i64 55
  %605 = insertelement <64 x bfloat> %604, bfloat %534, i64 56
  %606 = insertelement <64 x bfloat> %605, bfloat %536, i64 57
  %607 = insertelement <64 x bfloat> %606, bfloat %538, i64 58
  %608 = insertelement <64 x bfloat> %607, bfloat %540, i64 59
  %609 = insertelement <64 x bfloat> %608, bfloat %542, i64 60
  %610 = insertelement <64 x bfloat> %609, bfloat %544, i64 61
  %611 = insertelement <64 x bfloat> %610, bfloat %546, i64 62
  %612 = insertelement <64 x bfloat> %611, bfloat %548, i64 63
  %613 = shufflevector <64 x bfloat> %612, <64 x bfloat> %612, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %614 = shufflevector <32 x float> %72, <32 x float> %72, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %615 = bitcast <16 x bfloat> %421 to <16 x i16>
  %616 = bitcast <16 x bfloat> %613 to <16 x i16>
  %617 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %615, <16 x i16> %616, <8 x float> %614)
  %618 = shufflevector <8 x float> %617, <8 x float> %617, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %619 = shufflevector <32 x float> %618, <32 x float> %72, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %620 = shufflevector <64 x bfloat> %612, <64 x bfloat> %612, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %621 = shufflevector <32 x float> %619, <32 x float> %619, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %622 = bitcast <16 x bfloat> %620 to <16 x i16>
  %623 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %615, <16 x i16> %622, <8 x float> %621)
  %624 = shufflevector <8 x float> %623, <8 x float> %623, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %625 = shufflevector <32 x float> %624, <32 x float> %619, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %626 = shufflevector <64 x bfloat> %612, <64 x bfloat> %612, <16 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47>
  %627 = shufflevector <32 x float> %625, <32 x float> %625, <8 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %628 = bitcast <16 x bfloat> %626 to <16 x i16>
  %629 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %615, <16 x i16> %628, <8 x float> %627)
  %630 = shufflevector <8 x float> %629, <8 x float> %629, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %631 = shufflevector <32 x float> %630, <32 x float> %625, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %632 = shufflevector <64 x bfloat> %612, <64 x bfloat> %612, <16 x i32> <i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %633 = shufflevector <32 x float> %631, <32 x float> %631, <8 x i32> <i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %634 = bitcast <16 x bfloat> %632 to <16 x i16>
  %635 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %615, <16 x i16> %634, <8 x float> %633)
  fence syncscope("workgroup") release, !mmra !2
  call void @llvm.amdgcn.s.barrier()
  fence syncscope("workgroup") acquire, !mmra !2
  %636 = extractelement <8 x float> %617, i64 0
  %637 = fptrunc float %636 to bfloat
  %638 = extractelement <8 x float> %617, i64 1
  %639 = fptrunc float %638 to bfloat
  %640 = extractelement <8 x float> %617, i64 2
  %641 = fptrunc float %640 to bfloat
  %642 = extractelement <8 x float> %617, i64 3
  %643 = fptrunc float %642 to bfloat
  %644 = extractelement <8 x float> %617, i64 4
  %645 = fptrunc float %644 to bfloat
  %646 = extractelement <8 x float> %617, i64 5
  %647 = fptrunc float %646 to bfloat
  %648 = extractelement <8 x float> %617, i64 6
  %649 = fptrunc float %648 to bfloat
  %650 = extractelement <8 x float> %617, i64 7
  %651 = fptrunc float %650 to bfloat
  %652 = extractelement <8 x float> %623, i64 0
  %653 = fptrunc float %652 to bfloat
  %654 = extractelement <8 x float> %623, i64 1
  %655 = fptrunc float %654 to bfloat
  %656 = extractelement <8 x float> %623, i64 2
  %657 = fptrunc float %656 to bfloat
  %658 = extractelement <8 x float> %623, i64 3
  %659 = fptrunc float %658 to bfloat
  %660 = extractelement <8 x float> %623, i64 4
  %661 = fptrunc float %660 to bfloat
  %662 = extractelement <8 x float> %623, i64 5
  %663 = fptrunc float %662 to bfloat
  %664 = extractelement <8 x float> %623, i64 6
  %665 = fptrunc float %664 to bfloat
  %666 = extractelement <8 x float> %623, i64 7
  %667 = fptrunc float %666 to bfloat
  %668 = extractelement <8 x float> %629, i64 0
  %669 = fptrunc float %668 to bfloat
  %670 = extractelement <8 x float> %629, i64 1
  %671 = fptrunc float %670 to bfloat
  %672 = extractelement <8 x float> %629, i64 2
  %673 = fptrunc float %672 to bfloat
  %674 = extractelement <8 x float> %629, i64 3
  %675 = fptrunc float %674 to bfloat
  %676 = extractelement <8 x float> %629, i64 4
  %677 = fptrunc float %676 to bfloat
  %678 = extractelement <8 x float> %629, i64 5
  %679 = fptrunc float %678 to bfloat
  %680 = extractelement <8 x float> %629, i64 6
  %681 = fptrunc float %680 to bfloat
  %682 = extractelement <8 x float> %629, i64 7
  %683 = fptrunc float %682 to bfloat
  %684 = extractelement <8 x float> %635, i64 0
  %685 = fptrunc float %684 to bfloat
  %686 = extractelement <8 x float> %635, i64 1
  %687 = fptrunc float %686 to bfloat
  %688 = extractelement <8 x float> %635, i64 2
  %689 = fptrunc float %688 to bfloat
  %690 = extractelement <8 x float> %635, i64 3
  %691 = fptrunc float %690 to bfloat
  %692 = extractelement <8 x float> %635, i64 4
  %693 = fptrunc float %692 to bfloat
  %694 = extractelement <8 x float> %635, i64 5
  %695 = fptrunc float %694 to bfloat
  %696 = extractelement <8 x float> %635, i64 6
  %697 = fptrunc float %696 to bfloat
  %698 = extractelement <8 x float> %635, i64 7
  %699 = fptrunc float %698 to bfloat
  %700 = sdiv i32 %18, 16
  %701 = mul i32 %700, 4096
  %702 = add i32 %369, %701
  %703 = add i32 %27, %702
  %704 = mul i32 %703, 2
  %705 = bitcast bfloat %637 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %705, ptr addrspace(8) %25, i32 %704, i32 0, i32 0)
  %706 = add i32 %703, 8192
  %707 = mul i32 %706, 2
  %708 = bitcast bfloat %639 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %708, ptr addrspace(8) %25, i32 %707, i32 0, i32 0)
  %709 = add i32 %703, 16384
  %710 = mul i32 %709, 2
  %711 = bitcast bfloat %641 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %711, ptr addrspace(8) %25, i32 %710, i32 0, i32 0)
  %712 = add i32 %703, 24576
  %713 = mul i32 %712, 2
  %714 = bitcast bfloat %643 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %714, ptr addrspace(8) %25, i32 %713, i32 0, i32 0)
  %715 = add i32 %703, 32768
  %716 = mul i32 %715, 2
  %717 = bitcast bfloat %645 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %717, ptr addrspace(8) %25, i32 %716, i32 0, i32 0)
  %718 = add i32 %703, 40960
  %719 = mul i32 %718, 2
  %720 = bitcast bfloat %647 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %720, ptr addrspace(8) %25, i32 %719, i32 0, i32 0)
  %721 = add i32 %703, 49152
  %722 = mul i32 %721, 2
  %723 = bitcast bfloat %649 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %723, ptr addrspace(8) %25, i32 %722, i32 0, i32 0)
  %724 = add i32 %703, 57344
  %725 = mul i32 %724, 2
  %726 = bitcast bfloat %651 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %726, ptr addrspace(8) %25, i32 %725, i32 0, i32 0)
  %727 = add i32 %703, 16
  %728 = mul i32 %727, 2
  %729 = bitcast bfloat %653 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %729, ptr addrspace(8) %25, i32 %728, i32 0, i32 0)
  %730 = add i32 %703, 8208
  %731 = mul i32 %730, 2
  %732 = bitcast bfloat %655 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %732, ptr addrspace(8) %25, i32 %731, i32 0, i32 0)
  %733 = add i32 %703, 16400
  %734 = mul i32 %733, 2
  %735 = bitcast bfloat %657 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %735, ptr addrspace(8) %25, i32 %734, i32 0, i32 0)
  %736 = add i32 %703, 24592
  %737 = mul i32 %736, 2
  %738 = bitcast bfloat %659 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %738, ptr addrspace(8) %25, i32 %737, i32 0, i32 0)
  %739 = add i32 %703, 32784
  %740 = mul i32 %739, 2
  %741 = bitcast bfloat %661 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %741, ptr addrspace(8) %25, i32 %740, i32 0, i32 0)
  %742 = add i32 %703, 40976
  %743 = mul i32 %742, 2
  %744 = bitcast bfloat %663 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %744, ptr addrspace(8) %25, i32 %743, i32 0, i32 0)
  %745 = add i32 %703, 49168
  %746 = mul i32 %745, 2
  %747 = bitcast bfloat %665 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %747, ptr addrspace(8) %25, i32 %746, i32 0, i32 0)
  %748 = add i32 %703, 57360
  %749 = mul i32 %748, 2
  %750 = bitcast bfloat %667 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %750, ptr addrspace(8) %25, i32 %749, i32 0, i32 0)
  %751 = add i32 %703, 32
  %752 = mul i32 %751, 2
  %753 = bitcast bfloat %669 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %753, ptr addrspace(8) %25, i32 %752, i32 0, i32 0)
  %754 = add i32 %703, 8224
  %755 = mul i32 %754, 2
  %756 = bitcast bfloat %671 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %756, ptr addrspace(8) %25, i32 %755, i32 0, i32 0)
  %757 = add i32 %703, 16416
  %758 = mul i32 %757, 2
  %759 = bitcast bfloat %673 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %759, ptr addrspace(8) %25, i32 %758, i32 0, i32 0)
  %760 = add i32 %703, 24608
  %761 = mul i32 %760, 2
  %762 = bitcast bfloat %675 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %762, ptr addrspace(8) %25, i32 %761, i32 0, i32 0)
  %763 = add i32 %703, 32800
  %764 = mul i32 %763, 2
  %765 = bitcast bfloat %677 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %765, ptr addrspace(8) %25, i32 %764, i32 0, i32 0)
  %766 = add i32 %703, 40992
  %767 = mul i32 %766, 2
  %768 = bitcast bfloat %679 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %768, ptr addrspace(8) %25, i32 %767, i32 0, i32 0)
  %769 = add i32 %703, 49184
  %770 = mul i32 %769, 2
  %771 = bitcast bfloat %681 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %771, ptr addrspace(8) %25, i32 %770, i32 0, i32 0)
  %772 = add i32 %703, 57376
  %773 = mul i32 %772, 2
  %774 = bitcast bfloat %683 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %774, ptr addrspace(8) %25, i32 %773, i32 0, i32 0)
  %775 = add i32 %703, 48
  %776 = mul i32 %775, 2
  %777 = bitcast bfloat %685 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %777, ptr addrspace(8) %25, i32 %776, i32 0, i32 0)
  %778 = add i32 %703, 8240
  %779 = mul i32 %778, 2
  %780 = bitcast bfloat %687 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %780, ptr addrspace(8) %25, i32 %779, i32 0, i32 0)
  %781 = add i32 %703, 16432
  %782 = mul i32 %781, 2
  %783 = bitcast bfloat %689 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %783, ptr addrspace(8) %25, i32 %782, i32 0, i32 0)
  %784 = add i32 %703, 24624
  %785 = mul i32 %784, 2
  %786 = bitcast bfloat %691 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %786, ptr addrspace(8) %25, i32 %785, i32 0, i32 0)
  %787 = add i32 %703, 32816
  %788 = mul i32 %787, 2
  %789 = bitcast bfloat %693 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %789, ptr addrspace(8) %25, i32 %788, i32 0, i32 0)
  %790 = add i32 %703, 41008
  %791 = mul i32 %790, 2
  %792 = bitcast bfloat %695 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %792, ptr addrspace(8) %25, i32 %791, i32 0, i32 0)
  %793 = add i32 %703, 49200
  %794 = mul i32 %793, 2
  %795 = bitcast bfloat %697 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %795, ptr addrspace(8) %25, i32 %794, i32 0, i32 0)
  %796 = add i32 %703, 57392
  %797 = mul i32 %796, 2
  %798 = bitcast bfloat %699 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %798, ptr addrspace(8) %25, i32 %797, i32 0, i32 0)
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
!2 = !{!"amdgpu-synchronize-as", !"local"}
