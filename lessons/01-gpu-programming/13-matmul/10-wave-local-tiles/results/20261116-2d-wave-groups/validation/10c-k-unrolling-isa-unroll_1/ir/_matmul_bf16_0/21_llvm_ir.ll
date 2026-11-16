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
  %27 = srem i32 %23, 2
  %28 = sdiv i32 %23, 2
  %29 = srem i32 %28, 32
  %30 = mul i32 %29, 2
  %31 = add i32 %30, %27
  %32 = mul i32 %29, 128
  %33 = mul i32 %27, 64
  %34 = add i32 %32, %33
  %35 = mul i32 %27, 384
  %36 = mul i32 %27, 1024
  %37 = srem i32 %18, 2
  %38 = sdiv i32 %18, 2
  %39 = mul i32 %37, 8
  %40 = mul i32 %38, 24
  %41 = add i32 %39, %40
  %42 = add i32 %35, %41
  %43 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %42
  %44 = srem i32 %18, 8
  %45 = sdiv i32 %18, 8
  %46 = mul i32 %44, 8
  %47 = mul i32 %45, 64
  %48 = add i32 %46, %47
  %49 = add i32 %36, %48
  %50 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %49
  %51 = mul i32 %31, 64
  %52 = mul i32 %38, 8192
  %53 = add i32 %39, %52
  %54 = mul i32 %45, 4096
  %55 = add i32 %46, %54
  %56 = add i32 %51, %55
  %57 = mul i32 %53, 2
  %58 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %24, i32 %57, i32 0, i32 0)
  %59 = bitcast i128 %58 to <8 x bfloat>
  %60 = mul i32 %56, 2
  %61 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %25, i32 %60, i32 0, i32 2)
  %62 = bitcast i128 %61 to <8 x bfloat>
  %63 = add i32 %56, 16384
  %64 = mul i32 %63, 2
  %65 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %25, i32 %64, i32 0, i32 2)
  %66 = bitcast i128 %65 to <8 x bfloat>
  %67 = add i32 %56, 32768
  %68 = mul i32 %67, 2
  %69 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %25, i32 %68, i32 0, i32 2)
  %70 = bitcast i128 %69 to <8 x bfloat>
  %71 = add i32 %56, 49152
  %72 = mul i32 %71, 2
  %73 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %25, i32 %72, i32 0, i32 2)
  %74 = bitcast i128 %73 to <8 x bfloat>
  store <8 x bfloat> %59, ptr addrspace(3) %43, align 16
  store <8 x bfloat> %62, ptr addrspace(3) %50, align 16
  %75 = getelementptr bfloat, ptr addrspace(3) %50, i32 256
  store <8 x bfloat> %66, ptr addrspace(3) %75, align 16
  %76 = getelementptr bfloat, ptr addrspace(3) %50, i32 512
  store <8 x bfloat> %70, ptr addrspace(3) %76, align 16
  %77 = getelementptr bfloat, ptr addrspace(3) %50, i32 768
  store <8 x bfloat> %74, ptr addrspace(3) %77, align 16
  fence syncscope("wavefront") release, !mmra !2
  call void @llvm.amdgcn.wave.barrier()
  fence syncscope("wavefront") acquire, !mmra !2
  br label %78

78:                                               ; preds = %82, %6
  %79 = phi i32 [ %83, %82 ], [ 0, %6 ]
  %80 = phi <32 x float> [ %375, %82 ], [ zeroinitializer, %6 ]
  %81 = icmp slt i32 %79, 511
  br i1 %81, label %82, label %376

82:                                               ; preds = %78
  %83 = add i32 %79, 1
  %84 = mul i32 %83, 16
  %85 = mul i32 %83, 65536
  %86 = add i32 %85, %51
  %87 = add i32 %84, %53
  %88 = add i32 %86, %55
  %89 = mul i32 %87, 2
  %90 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %24, i32 %89, i32 0, i32 0)
  %91 = bitcast i128 %90 to <8 x bfloat>
  %92 = mul i32 %88, 2
  %93 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %25, i32 %92, i32 0, i32 2)
  %94 = bitcast i128 %93 to <8 x bfloat>
  %95 = add i32 %88, 16384
  %96 = mul i32 %95, 2
  %97 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %25, i32 %96, i32 0, i32 2)
  %98 = bitcast i128 %97 to <8 x bfloat>
  %99 = add i32 %88, 32768
  %100 = mul i32 %99, 2
  %101 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %25, i32 %100, i32 0, i32 2)
  %102 = bitcast i128 %101 to <8 x bfloat>
  %103 = add i32 %88, 49152
  %104 = mul i32 %103, 2
  %105 = call i128 @llvm.amdgcn.raw.ptr.buffer.load.i128(ptr addrspace(8) %25, i32 %104, i32 0, i32 2)
  %106 = bitcast i128 %105 to <8 x bfloat>
  %107 = srem i32 %18, 16
  %108 = mul i32 %107, 24
  %109 = add i32 %35, %108
  %110 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %109
  %111 = add i32 %36, %107
  %112 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %111
  %113 = load bfloat, ptr addrspace(3) %110, align 2
  %114 = getelementptr bfloat, ptr addrspace(3) %110, i32 1
  %115 = load bfloat, ptr addrspace(3) %114, align 2
  %116 = getelementptr bfloat, ptr addrspace(3) %110, i32 2
  %117 = load bfloat, ptr addrspace(3) %116, align 2
  %118 = getelementptr bfloat, ptr addrspace(3) %110, i32 3
  %119 = load bfloat, ptr addrspace(3) %118, align 2
  %120 = getelementptr bfloat, ptr addrspace(3) %110, i32 4
  %121 = load bfloat, ptr addrspace(3) %120, align 2
  %122 = getelementptr bfloat, ptr addrspace(3) %110, i32 5
  %123 = load bfloat, ptr addrspace(3) %122, align 2
  %124 = getelementptr bfloat, ptr addrspace(3) %110, i32 6
  %125 = load bfloat, ptr addrspace(3) %124, align 2
  %126 = getelementptr bfloat, ptr addrspace(3) %110, i32 7
  %127 = load bfloat, ptr addrspace(3) %126, align 2
  %128 = getelementptr bfloat, ptr addrspace(3) %110, i32 8
  %129 = load bfloat, ptr addrspace(3) %128, align 2
  %130 = getelementptr bfloat, ptr addrspace(3) %110, i32 9
  %131 = load bfloat, ptr addrspace(3) %130, align 2
  %132 = getelementptr bfloat, ptr addrspace(3) %110, i32 10
  %133 = load bfloat, ptr addrspace(3) %132, align 2
  %134 = getelementptr bfloat, ptr addrspace(3) %110, i32 11
  %135 = load bfloat, ptr addrspace(3) %134, align 2
  %136 = getelementptr bfloat, ptr addrspace(3) %110, i32 12
  %137 = load bfloat, ptr addrspace(3) %136, align 2
  %138 = getelementptr bfloat, ptr addrspace(3) %110, i32 13
  %139 = load bfloat, ptr addrspace(3) %138, align 2
  %140 = getelementptr bfloat, ptr addrspace(3) %110, i32 14
  %141 = load bfloat, ptr addrspace(3) %140, align 2
  %142 = getelementptr bfloat, ptr addrspace(3) %110, i32 15
  %143 = load bfloat, ptr addrspace(3) %142, align 2
  %144 = insertelement <16 x bfloat> poison, bfloat %113, i64 0
  %145 = insertelement <16 x bfloat> %144, bfloat %115, i64 1
  %146 = insertelement <16 x bfloat> %145, bfloat %117, i64 2
  %147 = insertelement <16 x bfloat> %146, bfloat %119, i64 3
  %148 = insertelement <16 x bfloat> %147, bfloat %121, i64 4
  %149 = insertelement <16 x bfloat> %148, bfloat %123, i64 5
  %150 = insertelement <16 x bfloat> %149, bfloat %125, i64 6
  %151 = insertelement <16 x bfloat> %150, bfloat %127, i64 7
  %152 = insertelement <16 x bfloat> %151, bfloat %129, i64 8
  %153 = insertelement <16 x bfloat> %152, bfloat %131, i64 9
  %154 = insertelement <16 x bfloat> %153, bfloat %133, i64 10
  %155 = insertelement <16 x bfloat> %154, bfloat %135, i64 11
  %156 = insertelement <16 x bfloat> %155, bfloat %137, i64 12
  %157 = insertelement <16 x bfloat> %156, bfloat %139, i64 13
  %158 = insertelement <16 x bfloat> %157, bfloat %141, i64 14
  %159 = insertelement <16 x bfloat> %158, bfloat %143, i64 15
  %160 = load bfloat, ptr addrspace(3) %112, align 2
  %161 = getelementptr bfloat, ptr addrspace(3) %112, i32 64
  %162 = load bfloat, ptr addrspace(3) %161, align 2
  %163 = getelementptr bfloat, ptr addrspace(3) %112, i32 128
  %164 = load bfloat, ptr addrspace(3) %163, align 2
  %165 = getelementptr bfloat, ptr addrspace(3) %112, i32 192
  %166 = load bfloat, ptr addrspace(3) %165, align 2
  %167 = getelementptr bfloat, ptr addrspace(3) %112, i32 256
  %168 = load bfloat, ptr addrspace(3) %167, align 2
  %169 = getelementptr bfloat, ptr addrspace(3) %112, i32 320
  %170 = load bfloat, ptr addrspace(3) %169, align 2
  %171 = getelementptr bfloat, ptr addrspace(3) %112, i32 384
  %172 = load bfloat, ptr addrspace(3) %171, align 2
  %173 = getelementptr bfloat, ptr addrspace(3) %112, i32 448
  %174 = load bfloat, ptr addrspace(3) %173, align 2
  %175 = getelementptr bfloat, ptr addrspace(3) %112, i32 512
  %176 = load bfloat, ptr addrspace(3) %175, align 2
  %177 = getelementptr bfloat, ptr addrspace(3) %112, i32 576
  %178 = load bfloat, ptr addrspace(3) %177, align 2
  %179 = getelementptr bfloat, ptr addrspace(3) %112, i32 640
  %180 = load bfloat, ptr addrspace(3) %179, align 2
  %181 = getelementptr bfloat, ptr addrspace(3) %112, i32 704
  %182 = load bfloat, ptr addrspace(3) %181, align 2
  %183 = getelementptr bfloat, ptr addrspace(3) %112, i32 768
  %184 = load bfloat, ptr addrspace(3) %183, align 2
  %185 = getelementptr bfloat, ptr addrspace(3) %112, i32 832
  %186 = load bfloat, ptr addrspace(3) %185, align 2
  %187 = getelementptr bfloat, ptr addrspace(3) %112, i32 896
  %188 = load bfloat, ptr addrspace(3) %187, align 2
  %189 = getelementptr bfloat, ptr addrspace(3) %112, i32 960
  %190 = load bfloat, ptr addrspace(3) %189, align 2
  %191 = getelementptr bfloat, ptr addrspace(3) %112, i32 16
  %192 = load bfloat, ptr addrspace(3) %191, align 2
  %193 = getelementptr bfloat, ptr addrspace(3) %112, i32 80
  %194 = load bfloat, ptr addrspace(3) %193, align 2
  %195 = getelementptr bfloat, ptr addrspace(3) %112, i32 144
  %196 = load bfloat, ptr addrspace(3) %195, align 2
  %197 = getelementptr bfloat, ptr addrspace(3) %112, i32 208
  %198 = load bfloat, ptr addrspace(3) %197, align 2
  %199 = getelementptr bfloat, ptr addrspace(3) %112, i32 272
  %200 = load bfloat, ptr addrspace(3) %199, align 2
  %201 = getelementptr bfloat, ptr addrspace(3) %112, i32 336
  %202 = load bfloat, ptr addrspace(3) %201, align 2
  %203 = getelementptr bfloat, ptr addrspace(3) %112, i32 400
  %204 = load bfloat, ptr addrspace(3) %203, align 2
  %205 = getelementptr bfloat, ptr addrspace(3) %112, i32 464
  %206 = load bfloat, ptr addrspace(3) %205, align 2
  %207 = getelementptr bfloat, ptr addrspace(3) %112, i32 528
  %208 = load bfloat, ptr addrspace(3) %207, align 2
  %209 = getelementptr bfloat, ptr addrspace(3) %112, i32 592
  %210 = load bfloat, ptr addrspace(3) %209, align 2
  %211 = getelementptr bfloat, ptr addrspace(3) %112, i32 656
  %212 = load bfloat, ptr addrspace(3) %211, align 2
  %213 = getelementptr bfloat, ptr addrspace(3) %112, i32 720
  %214 = load bfloat, ptr addrspace(3) %213, align 2
  %215 = getelementptr bfloat, ptr addrspace(3) %112, i32 784
  %216 = load bfloat, ptr addrspace(3) %215, align 2
  %217 = getelementptr bfloat, ptr addrspace(3) %112, i32 848
  %218 = load bfloat, ptr addrspace(3) %217, align 2
  %219 = getelementptr bfloat, ptr addrspace(3) %112, i32 912
  %220 = load bfloat, ptr addrspace(3) %219, align 2
  %221 = getelementptr bfloat, ptr addrspace(3) %112, i32 976
  %222 = load bfloat, ptr addrspace(3) %221, align 2
  %223 = getelementptr bfloat, ptr addrspace(3) %112, i32 32
  %224 = load bfloat, ptr addrspace(3) %223, align 2
  %225 = getelementptr bfloat, ptr addrspace(3) %112, i32 96
  %226 = load bfloat, ptr addrspace(3) %225, align 2
  %227 = getelementptr bfloat, ptr addrspace(3) %112, i32 160
  %228 = load bfloat, ptr addrspace(3) %227, align 2
  %229 = getelementptr bfloat, ptr addrspace(3) %112, i32 224
  %230 = load bfloat, ptr addrspace(3) %229, align 2
  %231 = getelementptr bfloat, ptr addrspace(3) %112, i32 288
  %232 = load bfloat, ptr addrspace(3) %231, align 2
  %233 = getelementptr bfloat, ptr addrspace(3) %112, i32 352
  %234 = load bfloat, ptr addrspace(3) %233, align 2
  %235 = getelementptr bfloat, ptr addrspace(3) %112, i32 416
  %236 = load bfloat, ptr addrspace(3) %235, align 2
  %237 = getelementptr bfloat, ptr addrspace(3) %112, i32 480
  %238 = load bfloat, ptr addrspace(3) %237, align 2
  %239 = getelementptr bfloat, ptr addrspace(3) %112, i32 544
  %240 = load bfloat, ptr addrspace(3) %239, align 2
  %241 = getelementptr bfloat, ptr addrspace(3) %112, i32 608
  %242 = load bfloat, ptr addrspace(3) %241, align 2
  %243 = getelementptr bfloat, ptr addrspace(3) %112, i32 672
  %244 = load bfloat, ptr addrspace(3) %243, align 2
  %245 = getelementptr bfloat, ptr addrspace(3) %112, i32 736
  %246 = load bfloat, ptr addrspace(3) %245, align 2
  %247 = getelementptr bfloat, ptr addrspace(3) %112, i32 800
  %248 = load bfloat, ptr addrspace(3) %247, align 2
  %249 = getelementptr bfloat, ptr addrspace(3) %112, i32 864
  %250 = load bfloat, ptr addrspace(3) %249, align 2
  %251 = getelementptr bfloat, ptr addrspace(3) %112, i32 928
  %252 = load bfloat, ptr addrspace(3) %251, align 2
  %253 = getelementptr bfloat, ptr addrspace(3) %112, i32 992
  %254 = load bfloat, ptr addrspace(3) %253, align 2
  %255 = getelementptr bfloat, ptr addrspace(3) %112, i32 48
  %256 = load bfloat, ptr addrspace(3) %255, align 2
  %257 = getelementptr bfloat, ptr addrspace(3) %112, i32 112
  %258 = load bfloat, ptr addrspace(3) %257, align 2
  %259 = getelementptr bfloat, ptr addrspace(3) %112, i32 176
  %260 = load bfloat, ptr addrspace(3) %259, align 2
  %261 = getelementptr bfloat, ptr addrspace(3) %112, i32 240
  %262 = load bfloat, ptr addrspace(3) %261, align 2
  %263 = getelementptr bfloat, ptr addrspace(3) %112, i32 304
  %264 = load bfloat, ptr addrspace(3) %263, align 2
  %265 = getelementptr bfloat, ptr addrspace(3) %112, i32 368
  %266 = load bfloat, ptr addrspace(3) %265, align 2
  %267 = getelementptr bfloat, ptr addrspace(3) %112, i32 432
  %268 = load bfloat, ptr addrspace(3) %267, align 2
  %269 = getelementptr bfloat, ptr addrspace(3) %112, i32 496
  %270 = load bfloat, ptr addrspace(3) %269, align 2
  %271 = getelementptr bfloat, ptr addrspace(3) %112, i32 560
  %272 = load bfloat, ptr addrspace(3) %271, align 2
  %273 = getelementptr bfloat, ptr addrspace(3) %112, i32 624
  %274 = load bfloat, ptr addrspace(3) %273, align 2
  %275 = getelementptr bfloat, ptr addrspace(3) %112, i32 688
  %276 = load bfloat, ptr addrspace(3) %275, align 2
  %277 = getelementptr bfloat, ptr addrspace(3) %112, i32 752
  %278 = load bfloat, ptr addrspace(3) %277, align 2
  %279 = getelementptr bfloat, ptr addrspace(3) %112, i32 816
  %280 = load bfloat, ptr addrspace(3) %279, align 2
  %281 = getelementptr bfloat, ptr addrspace(3) %112, i32 880
  %282 = load bfloat, ptr addrspace(3) %281, align 2
  %283 = getelementptr bfloat, ptr addrspace(3) %112, i32 944
  %284 = load bfloat, ptr addrspace(3) %283, align 2
  %285 = getelementptr bfloat, ptr addrspace(3) %112, i32 1008
  %286 = load bfloat, ptr addrspace(3) %285, align 2
  %287 = insertelement <64 x bfloat> poison, bfloat %160, i64 0
  %288 = insertelement <64 x bfloat> %287, bfloat %162, i64 1
  %289 = insertelement <64 x bfloat> %288, bfloat %164, i64 2
  %290 = insertelement <64 x bfloat> %289, bfloat %166, i64 3
  %291 = insertelement <64 x bfloat> %290, bfloat %168, i64 4
  %292 = insertelement <64 x bfloat> %291, bfloat %170, i64 5
  %293 = insertelement <64 x bfloat> %292, bfloat %172, i64 6
  %294 = insertelement <64 x bfloat> %293, bfloat %174, i64 7
  %295 = insertelement <64 x bfloat> %294, bfloat %176, i64 8
  %296 = insertelement <64 x bfloat> %295, bfloat %178, i64 9
  %297 = insertelement <64 x bfloat> %296, bfloat %180, i64 10
  %298 = insertelement <64 x bfloat> %297, bfloat %182, i64 11
  %299 = insertelement <64 x bfloat> %298, bfloat %184, i64 12
  %300 = insertelement <64 x bfloat> %299, bfloat %186, i64 13
  %301 = insertelement <64 x bfloat> %300, bfloat %188, i64 14
  %302 = insertelement <64 x bfloat> %301, bfloat %190, i64 15
  %303 = insertelement <64 x bfloat> %302, bfloat %192, i64 16
  %304 = insertelement <64 x bfloat> %303, bfloat %194, i64 17
  %305 = insertelement <64 x bfloat> %304, bfloat %196, i64 18
  %306 = insertelement <64 x bfloat> %305, bfloat %198, i64 19
  %307 = insertelement <64 x bfloat> %306, bfloat %200, i64 20
  %308 = insertelement <64 x bfloat> %307, bfloat %202, i64 21
  %309 = insertelement <64 x bfloat> %308, bfloat %204, i64 22
  %310 = insertelement <64 x bfloat> %309, bfloat %206, i64 23
  %311 = insertelement <64 x bfloat> %310, bfloat %208, i64 24
  %312 = insertelement <64 x bfloat> %311, bfloat %210, i64 25
  %313 = insertelement <64 x bfloat> %312, bfloat %212, i64 26
  %314 = insertelement <64 x bfloat> %313, bfloat %214, i64 27
  %315 = insertelement <64 x bfloat> %314, bfloat %216, i64 28
  %316 = insertelement <64 x bfloat> %315, bfloat %218, i64 29
  %317 = insertelement <64 x bfloat> %316, bfloat %220, i64 30
  %318 = insertelement <64 x bfloat> %317, bfloat %222, i64 31
  %319 = insertelement <64 x bfloat> %318, bfloat %224, i64 32
  %320 = insertelement <64 x bfloat> %319, bfloat %226, i64 33
  %321 = insertelement <64 x bfloat> %320, bfloat %228, i64 34
  %322 = insertelement <64 x bfloat> %321, bfloat %230, i64 35
  %323 = insertelement <64 x bfloat> %322, bfloat %232, i64 36
  %324 = insertelement <64 x bfloat> %323, bfloat %234, i64 37
  %325 = insertelement <64 x bfloat> %324, bfloat %236, i64 38
  %326 = insertelement <64 x bfloat> %325, bfloat %238, i64 39
  %327 = insertelement <64 x bfloat> %326, bfloat %240, i64 40
  %328 = insertelement <64 x bfloat> %327, bfloat %242, i64 41
  %329 = insertelement <64 x bfloat> %328, bfloat %244, i64 42
  %330 = insertelement <64 x bfloat> %329, bfloat %246, i64 43
  %331 = insertelement <64 x bfloat> %330, bfloat %248, i64 44
  %332 = insertelement <64 x bfloat> %331, bfloat %250, i64 45
  %333 = insertelement <64 x bfloat> %332, bfloat %252, i64 46
  %334 = insertelement <64 x bfloat> %333, bfloat %254, i64 47
  %335 = insertelement <64 x bfloat> %334, bfloat %256, i64 48
  %336 = insertelement <64 x bfloat> %335, bfloat %258, i64 49
  %337 = insertelement <64 x bfloat> %336, bfloat %260, i64 50
  %338 = insertelement <64 x bfloat> %337, bfloat %262, i64 51
  %339 = insertelement <64 x bfloat> %338, bfloat %264, i64 52
  %340 = insertelement <64 x bfloat> %339, bfloat %266, i64 53
  %341 = insertelement <64 x bfloat> %340, bfloat %268, i64 54
  %342 = insertelement <64 x bfloat> %341, bfloat %270, i64 55
  %343 = insertelement <64 x bfloat> %342, bfloat %272, i64 56
  %344 = insertelement <64 x bfloat> %343, bfloat %274, i64 57
  %345 = insertelement <64 x bfloat> %344, bfloat %276, i64 58
  %346 = insertelement <64 x bfloat> %345, bfloat %278, i64 59
  %347 = insertelement <64 x bfloat> %346, bfloat %280, i64 60
  %348 = insertelement <64 x bfloat> %347, bfloat %282, i64 61
  %349 = insertelement <64 x bfloat> %348, bfloat %284, i64 62
  %350 = insertelement <64 x bfloat> %349, bfloat %286, i64 63
  %351 = shufflevector <64 x bfloat> %350, <64 x bfloat> %350, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %352 = shufflevector <32 x float> %80, <32 x float> %80, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %353 = bitcast <16 x bfloat> %159 to <16 x i16>
  %354 = bitcast <16 x bfloat> %351 to <16 x i16>
  %355 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %353, <16 x i16> %354, <8 x float> %352)
  %356 = shufflevector <8 x float> %355, <8 x float> %355, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %357 = shufflevector <32 x float> %356, <32 x float> %80, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %358 = shufflevector <64 x bfloat> %350, <64 x bfloat> %350, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %359 = shufflevector <32 x float> %357, <32 x float> %357, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %360 = bitcast <16 x bfloat> %358 to <16 x i16>
  %361 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %353, <16 x i16> %360, <8 x float> %359)
  %362 = shufflevector <8 x float> %361, <8 x float> %361, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %363 = shufflevector <32 x float> %362, <32 x float> %357, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %364 = shufflevector <64 x bfloat> %350, <64 x bfloat> %350, <16 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47>
  %365 = shufflevector <32 x float> %363, <32 x float> %363, <8 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %366 = bitcast <16 x bfloat> %364 to <16 x i16>
  %367 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %353, <16 x i16> %366, <8 x float> %365)
  %368 = shufflevector <8 x float> %367, <8 x float> %367, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %369 = shufflevector <32 x float> %368, <32 x float> %363, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %370 = shufflevector <64 x bfloat> %350, <64 x bfloat> %350, <16 x i32> <i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %371 = shufflevector <32 x float> %369, <32 x float> %369, <8 x i32> <i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %372 = bitcast <16 x bfloat> %370 to <16 x i16>
  %373 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %353, <16 x i16> %372, <8 x float> %371)
  %374 = shufflevector <8 x float> %373, <8 x float> %373, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %375 = shufflevector <32 x float> %374, <32 x float> %369, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  fence syncscope("wavefront") release, !mmra !2
  call void @llvm.amdgcn.wave.barrier()
  fence syncscope("wavefront") acquire, !mmra !2
  store <8 x bfloat> %91, ptr addrspace(3) %43, align 16
  store <8 x bfloat> %94, ptr addrspace(3) %50, align 16
  store <8 x bfloat> %98, ptr addrspace(3) %75, align 16
  store <8 x bfloat> %102, ptr addrspace(3) %76, align 16
  store <8 x bfloat> %106, ptr addrspace(3) %77, align 16
  fence syncscope("wavefront") release, !mmra !2
  call void @llvm.amdgcn.wave.barrier()
  fence syncscope("wavefront") acquire, !mmra !2
  br label %78

376:                                              ; preds = %78
  %377 = srem i32 %18, 16
  %378 = mul i32 %377, 24
  %379 = add i32 %35, %378
  %380 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_0, i32 %379
  %381 = add i32 %36, %377
  %382 = getelementptr bfloat, ptr addrspace(3) @__shared_alloc_1, i32 %381
  %383 = load bfloat, ptr addrspace(3) %380, align 2
  %384 = getelementptr bfloat, ptr addrspace(3) %380, i32 1
  %385 = load bfloat, ptr addrspace(3) %384, align 2
  %386 = getelementptr bfloat, ptr addrspace(3) %380, i32 2
  %387 = load bfloat, ptr addrspace(3) %386, align 2
  %388 = getelementptr bfloat, ptr addrspace(3) %380, i32 3
  %389 = load bfloat, ptr addrspace(3) %388, align 2
  %390 = getelementptr bfloat, ptr addrspace(3) %380, i32 4
  %391 = load bfloat, ptr addrspace(3) %390, align 2
  %392 = getelementptr bfloat, ptr addrspace(3) %380, i32 5
  %393 = load bfloat, ptr addrspace(3) %392, align 2
  %394 = getelementptr bfloat, ptr addrspace(3) %380, i32 6
  %395 = load bfloat, ptr addrspace(3) %394, align 2
  %396 = getelementptr bfloat, ptr addrspace(3) %380, i32 7
  %397 = load bfloat, ptr addrspace(3) %396, align 2
  %398 = getelementptr bfloat, ptr addrspace(3) %380, i32 8
  %399 = load bfloat, ptr addrspace(3) %398, align 2
  %400 = getelementptr bfloat, ptr addrspace(3) %380, i32 9
  %401 = load bfloat, ptr addrspace(3) %400, align 2
  %402 = getelementptr bfloat, ptr addrspace(3) %380, i32 10
  %403 = load bfloat, ptr addrspace(3) %402, align 2
  %404 = getelementptr bfloat, ptr addrspace(3) %380, i32 11
  %405 = load bfloat, ptr addrspace(3) %404, align 2
  %406 = getelementptr bfloat, ptr addrspace(3) %380, i32 12
  %407 = load bfloat, ptr addrspace(3) %406, align 2
  %408 = getelementptr bfloat, ptr addrspace(3) %380, i32 13
  %409 = load bfloat, ptr addrspace(3) %408, align 2
  %410 = getelementptr bfloat, ptr addrspace(3) %380, i32 14
  %411 = load bfloat, ptr addrspace(3) %410, align 2
  %412 = getelementptr bfloat, ptr addrspace(3) %380, i32 15
  %413 = load bfloat, ptr addrspace(3) %412, align 2
  %414 = insertelement <16 x bfloat> poison, bfloat %383, i64 0
  %415 = insertelement <16 x bfloat> %414, bfloat %385, i64 1
  %416 = insertelement <16 x bfloat> %415, bfloat %387, i64 2
  %417 = insertelement <16 x bfloat> %416, bfloat %389, i64 3
  %418 = insertelement <16 x bfloat> %417, bfloat %391, i64 4
  %419 = insertelement <16 x bfloat> %418, bfloat %393, i64 5
  %420 = insertelement <16 x bfloat> %419, bfloat %395, i64 6
  %421 = insertelement <16 x bfloat> %420, bfloat %397, i64 7
  %422 = insertelement <16 x bfloat> %421, bfloat %399, i64 8
  %423 = insertelement <16 x bfloat> %422, bfloat %401, i64 9
  %424 = insertelement <16 x bfloat> %423, bfloat %403, i64 10
  %425 = insertelement <16 x bfloat> %424, bfloat %405, i64 11
  %426 = insertelement <16 x bfloat> %425, bfloat %407, i64 12
  %427 = insertelement <16 x bfloat> %426, bfloat %409, i64 13
  %428 = insertelement <16 x bfloat> %427, bfloat %411, i64 14
  %429 = insertelement <16 x bfloat> %428, bfloat %413, i64 15
  %430 = load bfloat, ptr addrspace(3) %382, align 2
  %431 = getelementptr bfloat, ptr addrspace(3) %382, i32 64
  %432 = load bfloat, ptr addrspace(3) %431, align 2
  %433 = getelementptr bfloat, ptr addrspace(3) %382, i32 128
  %434 = load bfloat, ptr addrspace(3) %433, align 2
  %435 = getelementptr bfloat, ptr addrspace(3) %382, i32 192
  %436 = load bfloat, ptr addrspace(3) %435, align 2
  %437 = getelementptr bfloat, ptr addrspace(3) %382, i32 256
  %438 = load bfloat, ptr addrspace(3) %437, align 2
  %439 = getelementptr bfloat, ptr addrspace(3) %382, i32 320
  %440 = load bfloat, ptr addrspace(3) %439, align 2
  %441 = getelementptr bfloat, ptr addrspace(3) %382, i32 384
  %442 = load bfloat, ptr addrspace(3) %441, align 2
  %443 = getelementptr bfloat, ptr addrspace(3) %382, i32 448
  %444 = load bfloat, ptr addrspace(3) %443, align 2
  %445 = getelementptr bfloat, ptr addrspace(3) %382, i32 512
  %446 = load bfloat, ptr addrspace(3) %445, align 2
  %447 = getelementptr bfloat, ptr addrspace(3) %382, i32 576
  %448 = load bfloat, ptr addrspace(3) %447, align 2
  %449 = getelementptr bfloat, ptr addrspace(3) %382, i32 640
  %450 = load bfloat, ptr addrspace(3) %449, align 2
  %451 = getelementptr bfloat, ptr addrspace(3) %382, i32 704
  %452 = load bfloat, ptr addrspace(3) %451, align 2
  %453 = getelementptr bfloat, ptr addrspace(3) %382, i32 768
  %454 = load bfloat, ptr addrspace(3) %453, align 2
  %455 = getelementptr bfloat, ptr addrspace(3) %382, i32 832
  %456 = load bfloat, ptr addrspace(3) %455, align 2
  %457 = getelementptr bfloat, ptr addrspace(3) %382, i32 896
  %458 = load bfloat, ptr addrspace(3) %457, align 2
  %459 = getelementptr bfloat, ptr addrspace(3) %382, i32 960
  %460 = load bfloat, ptr addrspace(3) %459, align 2
  %461 = getelementptr bfloat, ptr addrspace(3) %382, i32 16
  %462 = load bfloat, ptr addrspace(3) %461, align 2
  %463 = getelementptr bfloat, ptr addrspace(3) %382, i32 80
  %464 = load bfloat, ptr addrspace(3) %463, align 2
  %465 = getelementptr bfloat, ptr addrspace(3) %382, i32 144
  %466 = load bfloat, ptr addrspace(3) %465, align 2
  %467 = getelementptr bfloat, ptr addrspace(3) %382, i32 208
  %468 = load bfloat, ptr addrspace(3) %467, align 2
  %469 = getelementptr bfloat, ptr addrspace(3) %382, i32 272
  %470 = load bfloat, ptr addrspace(3) %469, align 2
  %471 = getelementptr bfloat, ptr addrspace(3) %382, i32 336
  %472 = load bfloat, ptr addrspace(3) %471, align 2
  %473 = getelementptr bfloat, ptr addrspace(3) %382, i32 400
  %474 = load bfloat, ptr addrspace(3) %473, align 2
  %475 = getelementptr bfloat, ptr addrspace(3) %382, i32 464
  %476 = load bfloat, ptr addrspace(3) %475, align 2
  %477 = getelementptr bfloat, ptr addrspace(3) %382, i32 528
  %478 = load bfloat, ptr addrspace(3) %477, align 2
  %479 = getelementptr bfloat, ptr addrspace(3) %382, i32 592
  %480 = load bfloat, ptr addrspace(3) %479, align 2
  %481 = getelementptr bfloat, ptr addrspace(3) %382, i32 656
  %482 = load bfloat, ptr addrspace(3) %481, align 2
  %483 = getelementptr bfloat, ptr addrspace(3) %382, i32 720
  %484 = load bfloat, ptr addrspace(3) %483, align 2
  %485 = getelementptr bfloat, ptr addrspace(3) %382, i32 784
  %486 = load bfloat, ptr addrspace(3) %485, align 2
  %487 = getelementptr bfloat, ptr addrspace(3) %382, i32 848
  %488 = load bfloat, ptr addrspace(3) %487, align 2
  %489 = getelementptr bfloat, ptr addrspace(3) %382, i32 912
  %490 = load bfloat, ptr addrspace(3) %489, align 2
  %491 = getelementptr bfloat, ptr addrspace(3) %382, i32 976
  %492 = load bfloat, ptr addrspace(3) %491, align 2
  %493 = getelementptr bfloat, ptr addrspace(3) %382, i32 32
  %494 = load bfloat, ptr addrspace(3) %493, align 2
  %495 = getelementptr bfloat, ptr addrspace(3) %382, i32 96
  %496 = load bfloat, ptr addrspace(3) %495, align 2
  %497 = getelementptr bfloat, ptr addrspace(3) %382, i32 160
  %498 = load bfloat, ptr addrspace(3) %497, align 2
  %499 = getelementptr bfloat, ptr addrspace(3) %382, i32 224
  %500 = load bfloat, ptr addrspace(3) %499, align 2
  %501 = getelementptr bfloat, ptr addrspace(3) %382, i32 288
  %502 = load bfloat, ptr addrspace(3) %501, align 2
  %503 = getelementptr bfloat, ptr addrspace(3) %382, i32 352
  %504 = load bfloat, ptr addrspace(3) %503, align 2
  %505 = getelementptr bfloat, ptr addrspace(3) %382, i32 416
  %506 = load bfloat, ptr addrspace(3) %505, align 2
  %507 = getelementptr bfloat, ptr addrspace(3) %382, i32 480
  %508 = load bfloat, ptr addrspace(3) %507, align 2
  %509 = getelementptr bfloat, ptr addrspace(3) %382, i32 544
  %510 = load bfloat, ptr addrspace(3) %509, align 2
  %511 = getelementptr bfloat, ptr addrspace(3) %382, i32 608
  %512 = load bfloat, ptr addrspace(3) %511, align 2
  %513 = getelementptr bfloat, ptr addrspace(3) %382, i32 672
  %514 = load bfloat, ptr addrspace(3) %513, align 2
  %515 = getelementptr bfloat, ptr addrspace(3) %382, i32 736
  %516 = load bfloat, ptr addrspace(3) %515, align 2
  %517 = getelementptr bfloat, ptr addrspace(3) %382, i32 800
  %518 = load bfloat, ptr addrspace(3) %517, align 2
  %519 = getelementptr bfloat, ptr addrspace(3) %382, i32 864
  %520 = load bfloat, ptr addrspace(3) %519, align 2
  %521 = getelementptr bfloat, ptr addrspace(3) %382, i32 928
  %522 = load bfloat, ptr addrspace(3) %521, align 2
  %523 = getelementptr bfloat, ptr addrspace(3) %382, i32 992
  %524 = load bfloat, ptr addrspace(3) %523, align 2
  %525 = getelementptr bfloat, ptr addrspace(3) %382, i32 48
  %526 = load bfloat, ptr addrspace(3) %525, align 2
  %527 = getelementptr bfloat, ptr addrspace(3) %382, i32 112
  %528 = load bfloat, ptr addrspace(3) %527, align 2
  %529 = getelementptr bfloat, ptr addrspace(3) %382, i32 176
  %530 = load bfloat, ptr addrspace(3) %529, align 2
  %531 = getelementptr bfloat, ptr addrspace(3) %382, i32 240
  %532 = load bfloat, ptr addrspace(3) %531, align 2
  %533 = getelementptr bfloat, ptr addrspace(3) %382, i32 304
  %534 = load bfloat, ptr addrspace(3) %533, align 2
  %535 = getelementptr bfloat, ptr addrspace(3) %382, i32 368
  %536 = load bfloat, ptr addrspace(3) %535, align 2
  %537 = getelementptr bfloat, ptr addrspace(3) %382, i32 432
  %538 = load bfloat, ptr addrspace(3) %537, align 2
  %539 = getelementptr bfloat, ptr addrspace(3) %382, i32 496
  %540 = load bfloat, ptr addrspace(3) %539, align 2
  %541 = getelementptr bfloat, ptr addrspace(3) %382, i32 560
  %542 = load bfloat, ptr addrspace(3) %541, align 2
  %543 = getelementptr bfloat, ptr addrspace(3) %382, i32 624
  %544 = load bfloat, ptr addrspace(3) %543, align 2
  %545 = getelementptr bfloat, ptr addrspace(3) %382, i32 688
  %546 = load bfloat, ptr addrspace(3) %545, align 2
  %547 = getelementptr bfloat, ptr addrspace(3) %382, i32 752
  %548 = load bfloat, ptr addrspace(3) %547, align 2
  %549 = getelementptr bfloat, ptr addrspace(3) %382, i32 816
  %550 = load bfloat, ptr addrspace(3) %549, align 2
  %551 = getelementptr bfloat, ptr addrspace(3) %382, i32 880
  %552 = load bfloat, ptr addrspace(3) %551, align 2
  %553 = getelementptr bfloat, ptr addrspace(3) %382, i32 944
  %554 = load bfloat, ptr addrspace(3) %553, align 2
  %555 = getelementptr bfloat, ptr addrspace(3) %382, i32 1008
  %556 = load bfloat, ptr addrspace(3) %555, align 2
  %557 = insertelement <64 x bfloat> poison, bfloat %430, i64 0
  %558 = insertelement <64 x bfloat> %557, bfloat %432, i64 1
  %559 = insertelement <64 x bfloat> %558, bfloat %434, i64 2
  %560 = insertelement <64 x bfloat> %559, bfloat %436, i64 3
  %561 = insertelement <64 x bfloat> %560, bfloat %438, i64 4
  %562 = insertelement <64 x bfloat> %561, bfloat %440, i64 5
  %563 = insertelement <64 x bfloat> %562, bfloat %442, i64 6
  %564 = insertelement <64 x bfloat> %563, bfloat %444, i64 7
  %565 = insertelement <64 x bfloat> %564, bfloat %446, i64 8
  %566 = insertelement <64 x bfloat> %565, bfloat %448, i64 9
  %567 = insertelement <64 x bfloat> %566, bfloat %450, i64 10
  %568 = insertelement <64 x bfloat> %567, bfloat %452, i64 11
  %569 = insertelement <64 x bfloat> %568, bfloat %454, i64 12
  %570 = insertelement <64 x bfloat> %569, bfloat %456, i64 13
  %571 = insertelement <64 x bfloat> %570, bfloat %458, i64 14
  %572 = insertelement <64 x bfloat> %571, bfloat %460, i64 15
  %573 = insertelement <64 x bfloat> %572, bfloat %462, i64 16
  %574 = insertelement <64 x bfloat> %573, bfloat %464, i64 17
  %575 = insertelement <64 x bfloat> %574, bfloat %466, i64 18
  %576 = insertelement <64 x bfloat> %575, bfloat %468, i64 19
  %577 = insertelement <64 x bfloat> %576, bfloat %470, i64 20
  %578 = insertelement <64 x bfloat> %577, bfloat %472, i64 21
  %579 = insertelement <64 x bfloat> %578, bfloat %474, i64 22
  %580 = insertelement <64 x bfloat> %579, bfloat %476, i64 23
  %581 = insertelement <64 x bfloat> %580, bfloat %478, i64 24
  %582 = insertelement <64 x bfloat> %581, bfloat %480, i64 25
  %583 = insertelement <64 x bfloat> %582, bfloat %482, i64 26
  %584 = insertelement <64 x bfloat> %583, bfloat %484, i64 27
  %585 = insertelement <64 x bfloat> %584, bfloat %486, i64 28
  %586 = insertelement <64 x bfloat> %585, bfloat %488, i64 29
  %587 = insertelement <64 x bfloat> %586, bfloat %490, i64 30
  %588 = insertelement <64 x bfloat> %587, bfloat %492, i64 31
  %589 = insertelement <64 x bfloat> %588, bfloat %494, i64 32
  %590 = insertelement <64 x bfloat> %589, bfloat %496, i64 33
  %591 = insertelement <64 x bfloat> %590, bfloat %498, i64 34
  %592 = insertelement <64 x bfloat> %591, bfloat %500, i64 35
  %593 = insertelement <64 x bfloat> %592, bfloat %502, i64 36
  %594 = insertelement <64 x bfloat> %593, bfloat %504, i64 37
  %595 = insertelement <64 x bfloat> %594, bfloat %506, i64 38
  %596 = insertelement <64 x bfloat> %595, bfloat %508, i64 39
  %597 = insertelement <64 x bfloat> %596, bfloat %510, i64 40
  %598 = insertelement <64 x bfloat> %597, bfloat %512, i64 41
  %599 = insertelement <64 x bfloat> %598, bfloat %514, i64 42
  %600 = insertelement <64 x bfloat> %599, bfloat %516, i64 43
  %601 = insertelement <64 x bfloat> %600, bfloat %518, i64 44
  %602 = insertelement <64 x bfloat> %601, bfloat %520, i64 45
  %603 = insertelement <64 x bfloat> %602, bfloat %522, i64 46
  %604 = insertelement <64 x bfloat> %603, bfloat %524, i64 47
  %605 = insertelement <64 x bfloat> %604, bfloat %526, i64 48
  %606 = insertelement <64 x bfloat> %605, bfloat %528, i64 49
  %607 = insertelement <64 x bfloat> %606, bfloat %530, i64 50
  %608 = insertelement <64 x bfloat> %607, bfloat %532, i64 51
  %609 = insertelement <64 x bfloat> %608, bfloat %534, i64 52
  %610 = insertelement <64 x bfloat> %609, bfloat %536, i64 53
  %611 = insertelement <64 x bfloat> %610, bfloat %538, i64 54
  %612 = insertelement <64 x bfloat> %611, bfloat %540, i64 55
  %613 = insertelement <64 x bfloat> %612, bfloat %542, i64 56
  %614 = insertelement <64 x bfloat> %613, bfloat %544, i64 57
  %615 = insertelement <64 x bfloat> %614, bfloat %546, i64 58
  %616 = insertelement <64 x bfloat> %615, bfloat %548, i64 59
  %617 = insertelement <64 x bfloat> %616, bfloat %550, i64 60
  %618 = insertelement <64 x bfloat> %617, bfloat %552, i64 61
  %619 = insertelement <64 x bfloat> %618, bfloat %554, i64 62
  %620 = insertelement <64 x bfloat> %619, bfloat %556, i64 63
  %621 = shufflevector <64 x bfloat> %620, <64 x bfloat> %620, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %622 = shufflevector <32 x float> %80, <32 x float> %80, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %623 = bitcast <16 x bfloat> %429 to <16 x i16>
  %624 = bitcast <16 x bfloat> %621 to <16 x i16>
  %625 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %623, <16 x i16> %624, <8 x float> %622)
  %626 = shufflevector <8 x float> %625, <8 x float> %625, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %627 = shufflevector <32 x float> %626, <32 x float> %80, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %628 = shufflevector <64 x bfloat> %620, <64 x bfloat> %620, <16 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %629 = shufflevector <32 x float> %627, <32 x float> %627, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %630 = bitcast <16 x bfloat> %628 to <16 x i16>
  %631 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %623, <16 x i16> %630, <8 x float> %629)
  %632 = shufflevector <8 x float> %631, <8 x float> %631, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %633 = shufflevector <32 x float> %632, <32 x float> %627, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %634 = shufflevector <64 x bfloat> %620, <64 x bfloat> %620, <16 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47>
  %635 = shufflevector <32 x float> %633, <32 x float> %633, <8 x i32> <i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23>
  %636 = bitcast <16 x bfloat> %634 to <16 x i16>
  %637 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %623, <16 x i16> %636, <8 x float> %635)
  %638 = shufflevector <8 x float> %637, <8 x float> %637, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  %639 = shufflevector <32 x float> %638, <32 x float> %633, <32 x i32> <i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %640 = shufflevector <64 x bfloat> %620, <64 x bfloat> %620, <16 x i32> <i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  %641 = shufflevector <32 x float> %639, <32 x float> %639, <8 x i32> <i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %642 = bitcast <16 x bfloat> %640 to <16 x i16>
  %643 = call <8 x float> @llvm.amdgcn.wmma.f32.16x16x16.bf16.v8f32.v16i16(<16 x i16> %623, <16 x i16> %642, <8 x float> %641)
  fence syncscope("wavefront") release, !mmra !2
  call void @llvm.amdgcn.wave.barrier()
  fence syncscope("wavefront") acquire, !mmra !2
  %644 = extractelement <8 x float> %625, i64 0
  %645 = fptrunc float %644 to bfloat
  %646 = extractelement <8 x float> %625, i64 1
  %647 = fptrunc float %646 to bfloat
  %648 = extractelement <8 x float> %625, i64 2
  %649 = fptrunc float %648 to bfloat
  %650 = extractelement <8 x float> %625, i64 3
  %651 = fptrunc float %650 to bfloat
  %652 = extractelement <8 x float> %625, i64 4
  %653 = fptrunc float %652 to bfloat
  %654 = extractelement <8 x float> %625, i64 5
  %655 = fptrunc float %654 to bfloat
  %656 = extractelement <8 x float> %625, i64 6
  %657 = fptrunc float %656 to bfloat
  %658 = extractelement <8 x float> %625, i64 7
  %659 = fptrunc float %658 to bfloat
  %660 = extractelement <8 x float> %631, i64 0
  %661 = fptrunc float %660 to bfloat
  %662 = extractelement <8 x float> %631, i64 1
  %663 = fptrunc float %662 to bfloat
  %664 = extractelement <8 x float> %631, i64 2
  %665 = fptrunc float %664 to bfloat
  %666 = extractelement <8 x float> %631, i64 3
  %667 = fptrunc float %666 to bfloat
  %668 = extractelement <8 x float> %631, i64 4
  %669 = fptrunc float %668 to bfloat
  %670 = extractelement <8 x float> %631, i64 5
  %671 = fptrunc float %670 to bfloat
  %672 = extractelement <8 x float> %631, i64 6
  %673 = fptrunc float %672 to bfloat
  %674 = extractelement <8 x float> %631, i64 7
  %675 = fptrunc float %674 to bfloat
  %676 = extractelement <8 x float> %637, i64 0
  %677 = fptrunc float %676 to bfloat
  %678 = extractelement <8 x float> %637, i64 1
  %679 = fptrunc float %678 to bfloat
  %680 = extractelement <8 x float> %637, i64 2
  %681 = fptrunc float %680 to bfloat
  %682 = extractelement <8 x float> %637, i64 3
  %683 = fptrunc float %682 to bfloat
  %684 = extractelement <8 x float> %637, i64 4
  %685 = fptrunc float %684 to bfloat
  %686 = extractelement <8 x float> %637, i64 5
  %687 = fptrunc float %686 to bfloat
  %688 = extractelement <8 x float> %637, i64 6
  %689 = fptrunc float %688 to bfloat
  %690 = extractelement <8 x float> %637, i64 7
  %691 = fptrunc float %690 to bfloat
  %692 = extractelement <8 x float> %643, i64 0
  %693 = fptrunc float %692 to bfloat
  %694 = extractelement <8 x float> %643, i64 1
  %695 = fptrunc float %694 to bfloat
  %696 = extractelement <8 x float> %643, i64 2
  %697 = fptrunc float %696 to bfloat
  %698 = extractelement <8 x float> %643, i64 3
  %699 = fptrunc float %698 to bfloat
  %700 = extractelement <8 x float> %643, i64 4
  %701 = fptrunc float %700 to bfloat
  %702 = extractelement <8 x float> %643, i64 5
  %703 = fptrunc float %702 to bfloat
  %704 = extractelement <8 x float> %643, i64 6
  %705 = fptrunc float %704 to bfloat
  %706 = extractelement <8 x float> %643, i64 7
  %707 = fptrunc float %706 to bfloat
  %708 = sdiv i32 %18, 16
  %709 = mul i32 %708, 4096
  %710 = add i32 %377, %709
  %711 = add i32 %34, %710
  %712 = mul i32 %711, 2
  %713 = bitcast bfloat %645 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %713, ptr addrspace(8) %26, i32 %712, i32 0, i32 0)
  %714 = add i32 %711, 8192
  %715 = mul i32 %714, 2
  %716 = bitcast bfloat %647 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %716, ptr addrspace(8) %26, i32 %715, i32 0, i32 0)
  %717 = add i32 %711, 16384
  %718 = mul i32 %717, 2
  %719 = bitcast bfloat %649 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %719, ptr addrspace(8) %26, i32 %718, i32 0, i32 0)
  %720 = add i32 %711, 24576
  %721 = mul i32 %720, 2
  %722 = bitcast bfloat %651 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %722, ptr addrspace(8) %26, i32 %721, i32 0, i32 0)
  %723 = add i32 %711, 32768
  %724 = mul i32 %723, 2
  %725 = bitcast bfloat %653 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %725, ptr addrspace(8) %26, i32 %724, i32 0, i32 0)
  %726 = add i32 %711, 40960
  %727 = mul i32 %726, 2
  %728 = bitcast bfloat %655 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %728, ptr addrspace(8) %26, i32 %727, i32 0, i32 0)
  %729 = add i32 %711, 49152
  %730 = mul i32 %729, 2
  %731 = bitcast bfloat %657 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %731, ptr addrspace(8) %26, i32 %730, i32 0, i32 0)
  %732 = add i32 %711, 57344
  %733 = mul i32 %732, 2
  %734 = bitcast bfloat %659 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %734, ptr addrspace(8) %26, i32 %733, i32 0, i32 0)
  %735 = add i32 %711, 16
  %736 = mul i32 %735, 2
  %737 = bitcast bfloat %661 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %737, ptr addrspace(8) %26, i32 %736, i32 0, i32 0)
  %738 = add i32 %711, 8208
  %739 = mul i32 %738, 2
  %740 = bitcast bfloat %663 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %740, ptr addrspace(8) %26, i32 %739, i32 0, i32 0)
  %741 = add i32 %711, 16400
  %742 = mul i32 %741, 2
  %743 = bitcast bfloat %665 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %743, ptr addrspace(8) %26, i32 %742, i32 0, i32 0)
  %744 = add i32 %711, 24592
  %745 = mul i32 %744, 2
  %746 = bitcast bfloat %667 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %746, ptr addrspace(8) %26, i32 %745, i32 0, i32 0)
  %747 = add i32 %711, 32784
  %748 = mul i32 %747, 2
  %749 = bitcast bfloat %669 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %749, ptr addrspace(8) %26, i32 %748, i32 0, i32 0)
  %750 = add i32 %711, 40976
  %751 = mul i32 %750, 2
  %752 = bitcast bfloat %671 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %752, ptr addrspace(8) %26, i32 %751, i32 0, i32 0)
  %753 = add i32 %711, 49168
  %754 = mul i32 %753, 2
  %755 = bitcast bfloat %673 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %755, ptr addrspace(8) %26, i32 %754, i32 0, i32 0)
  %756 = add i32 %711, 57360
  %757 = mul i32 %756, 2
  %758 = bitcast bfloat %675 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %758, ptr addrspace(8) %26, i32 %757, i32 0, i32 0)
  %759 = add i32 %711, 32
  %760 = mul i32 %759, 2
  %761 = bitcast bfloat %677 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %761, ptr addrspace(8) %26, i32 %760, i32 0, i32 0)
  %762 = add i32 %711, 8224
  %763 = mul i32 %762, 2
  %764 = bitcast bfloat %679 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %764, ptr addrspace(8) %26, i32 %763, i32 0, i32 0)
  %765 = add i32 %711, 16416
  %766 = mul i32 %765, 2
  %767 = bitcast bfloat %681 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %767, ptr addrspace(8) %26, i32 %766, i32 0, i32 0)
  %768 = add i32 %711, 24608
  %769 = mul i32 %768, 2
  %770 = bitcast bfloat %683 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %770, ptr addrspace(8) %26, i32 %769, i32 0, i32 0)
  %771 = add i32 %711, 32800
  %772 = mul i32 %771, 2
  %773 = bitcast bfloat %685 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %773, ptr addrspace(8) %26, i32 %772, i32 0, i32 0)
  %774 = add i32 %711, 40992
  %775 = mul i32 %774, 2
  %776 = bitcast bfloat %687 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %776, ptr addrspace(8) %26, i32 %775, i32 0, i32 0)
  %777 = add i32 %711, 49184
  %778 = mul i32 %777, 2
  %779 = bitcast bfloat %689 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %779, ptr addrspace(8) %26, i32 %778, i32 0, i32 0)
  %780 = add i32 %711, 57376
  %781 = mul i32 %780, 2
  %782 = bitcast bfloat %691 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %782, ptr addrspace(8) %26, i32 %781, i32 0, i32 0)
  %783 = add i32 %711, 48
  %784 = mul i32 %783, 2
  %785 = bitcast bfloat %693 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %785, ptr addrspace(8) %26, i32 %784, i32 0, i32 0)
  %786 = add i32 %711, 8240
  %787 = mul i32 %786, 2
  %788 = bitcast bfloat %695 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %788, ptr addrspace(8) %26, i32 %787, i32 0, i32 0)
  %789 = add i32 %711, 16432
  %790 = mul i32 %789, 2
  %791 = bitcast bfloat %697 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %791, ptr addrspace(8) %26, i32 %790, i32 0, i32 0)
  %792 = add i32 %711, 24624
  %793 = mul i32 %792, 2
  %794 = bitcast bfloat %699 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %794, ptr addrspace(8) %26, i32 %793, i32 0, i32 0)
  %795 = add i32 %711, 32816
  %796 = mul i32 %795, 2
  %797 = bitcast bfloat %701 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %797, ptr addrspace(8) %26, i32 %796, i32 0, i32 0)
  %798 = add i32 %711, 41008
  %799 = mul i32 %798, 2
  %800 = bitcast bfloat %703 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %800, ptr addrspace(8) %26, i32 %799, i32 0, i32 0)
  %801 = add i32 %711, 49200
  %802 = mul i32 %801, 2
  %803 = bitcast bfloat %705 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %803, ptr addrspace(8) %26, i32 %802, i32 0, i32 0)
  %804 = add i32 %711, 57392
  %805 = mul i32 %804, 2
  %806 = bitcast bfloat %707 to i16
  call void @llvm.amdgcn.raw.ptr.buffer.store.i16(i16 %806, ptr addrspace(8) %26, i32 %805, i32 0, i32 0)
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
