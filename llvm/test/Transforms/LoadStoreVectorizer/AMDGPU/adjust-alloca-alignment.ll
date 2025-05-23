; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=load-store-vectorizer --mcpu=hawaii -mattr=-unaligned-access-mode,+max-private-element-size-16 < %s | FileCheck -check-prefixes=CHECK,ALIGNED %s
; RUN: opt -S -passes=load-store-vectorizer --mcpu=hawaii -mattr=+unaligned-access-mode,+unaligned-scratch-access,+max-private-element-size-16 < %s | FileCheck -check-prefixes=CHECK,UNALIGNED %s
; RUN: opt -S -passes='function(load-store-vectorizer)' --mcpu=hawaii -mattr=-unaligned-access-mode,+max-private-element-size-16 < %s | FileCheck -check-prefixes=CHECK,ALIGNED %s
; RUN: opt -S -passes='function(load-store-vectorizer)' --mcpu=hawaii -mattr=+unaligned-access-mode,+unaligned-scratch-access,+max-private-element-size-16 < %s | FileCheck -check-prefixes=CHECK,UNALIGNED %s

target triple = "amdgcn--"

define amdgpu_kernel void @load_unknown_offset_align1_i8(ptr addrspace(1) noalias %out, i32 %offset) #0 {
; ALIGNED-LABEL: @load_unknown_offset_align1_i8(
; ALIGNED-NEXT:    [[ALLOCA:%.*]] = alloca [128 x i8], align 1, addrspace(5)
; ALIGNED-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [128 x i8], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[OFFSET:%.*]]
; ALIGNED-NEXT:    [[VAL0:%.*]] = load i8, ptr addrspace(5) [[PTR0]], align 1
; ALIGNED-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i8, ptr addrspace(5) [[PTR0]], i32 1
; ALIGNED-NEXT:    [[VAL1:%.*]] = load i8, ptr addrspace(5) [[PTR1]], align 1
; ALIGNED-NEXT:    [[ADD:%.*]] = add i8 [[VAL0]], [[VAL1]]
; ALIGNED-NEXT:    store i8 [[ADD]], ptr addrspace(1) [[OUT:%.*]], align 1
; ALIGNED-NEXT:    ret void
;
; UNALIGNED-LABEL: @load_unknown_offset_align1_i8(
; UNALIGNED-NEXT:    [[ALLOCA:%.*]] = alloca [128 x i8], align 1, addrspace(5)
; UNALIGNED-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [128 x i8], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[OFFSET:%.*]]
; UNALIGNED-NEXT:    [[TMP1:%.*]] = load <2 x i8>, ptr addrspace(5) [[PTR0]], align 1
; UNALIGNED-NEXT:    [[VAL01:%.*]] = extractelement <2 x i8> [[TMP1]], i32 0
; UNALIGNED-NEXT:    [[VAL12:%.*]] = extractelement <2 x i8> [[TMP1]], i32 1
; UNALIGNED-NEXT:    [[ADD:%.*]] = add i8 [[VAL01]], [[VAL12]]
; UNALIGNED-NEXT:    store i8 [[ADD]], ptr addrspace(1) [[OUT:%.*]], align 1
; UNALIGNED-NEXT:    ret void
;
  %alloca = alloca [128 x i8], align 1, addrspace(5)
  %ptr0 = getelementptr inbounds [128 x i8], ptr addrspace(5) %alloca, i32 0, i32 %offset
  %val0 = load i8, ptr addrspace(5) %ptr0, align 1
  %ptr1 = getelementptr inbounds i8, ptr addrspace(5) %ptr0, i32 1
  %val1 = load i8, ptr addrspace(5) %ptr1, align 1
  %add = add i8 %val0, %val1
  store i8 %add, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @load_unknown_offset_align1_i16(ptr addrspace(1) noalias %out, i32 %offset) #0 {
; ALIGNED-LABEL: @load_unknown_offset_align1_i16(
; ALIGNED-NEXT:    [[ALLOCA:%.*]] = alloca [128 x i16], align 1, addrspace(5)
; ALIGNED-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [128 x i16], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[OFFSET:%.*]]
; ALIGNED-NEXT:    [[VAL0:%.*]] = load i16, ptr addrspace(5) [[PTR0]], align 1
; ALIGNED-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i16, ptr addrspace(5) [[PTR0]], i32 1
; ALIGNED-NEXT:    [[VAL1:%.*]] = load i16, ptr addrspace(5) [[PTR1]], align 1
; ALIGNED-NEXT:    [[ADD:%.*]] = add i16 [[VAL0]], [[VAL1]]
; ALIGNED-NEXT:    store i16 [[ADD]], ptr addrspace(1) [[OUT:%.*]], align 2
; ALIGNED-NEXT:    ret void
;
; UNALIGNED-LABEL: @load_unknown_offset_align1_i16(
; UNALIGNED-NEXT:    [[ALLOCA:%.*]] = alloca [128 x i16], align 1, addrspace(5)
; UNALIGNED-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [128 x i16], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[OFFSET:%.*]]
; UNALIGNED-NEXT:    [[TMP1:%.*]] = load <2 x i16>, ptr addrspace(5) [[PTR0]], align 1
; UNALIGNED-NEXT:    [[VAL01:%.*]] = extractelement <2 x i16> [[TMP1]], i32 0
; UNALIGNED-NEXT:    [[VAL12:%.*]] = extractelement <2 x i16> [[TMP1]], i32 1
; UNALIGNED-NEXT:    [[ADD:%.*]] = add i16 [[VAL01]], [[VAL12]]
; UNALIGNED-NEXT:    store i16 [[ADD]], ptr addrspace(1) [[OUT:%.*]], align 2
; UNALIGNED-NEXT:    ret void
;
  %alloca = alloca [128 x i16], align 1, addrspace(5)
  %ptr0 = getelementptr inbounds [128 x i16], ptr addrspace(5) %alloca, i32 0, i32 %offset
  %val0 = load i16, ptr addrspace(5) %ptr0, align 1
  %ptr1 = getelementptr inbounds i16, ptr addrspace(5) %ptr0, i32 1
  %val1 = load i16, ptr addrspace(5) %ptr1, align 1
  %add = add i16 %val0, %val1
  store i16 %add, ptr addrspace(1) %out
  ret void
}

; FIXME: Although the offset is unknown here, we know it is a multiple
; of the element size, so should still be align 4
define amdgpu_kernel void @load_unknown_offset_align1_i32(ptr addrspace(1) noalias %out, i32 %offset) #0 {
; ALIGNED-LABEL: @load_unknown_offset_align1_i32(
; ALIGNED-NEXT:    [[ALLOCA:%.*]] = alloca [128 x i32], align 1, addrspace(5)
; ALIGNED-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [128 x i32], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[OFFSET:%.*]]
; ALIGNED-NEXT:    [[VAL0:%.*]] = load i32, ptr addrspace(5) [[PTR0]], align 1
; ALIGNED-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i32, ptr addrspace(5) [[PTR0]], i32 1
; ALIGNED-NEXT:    [[VAL1:%.*]] = load i32, ptr addrspace(5) [[PTR1]], align 1
; ALIGNED-NEXT:    [[ADD:%.*]] = add i32 [[VAL0]], [[VAL1]]
; ALIGNED-NEXT:    store i32 [[ADD]], ptr addrspace(1) [[OUT:%.*]], align 4
; ALIGNED-NEXT:    ret void
;
; UNALIGNED-LABEL: @load_unknown_offset_align1_i32(
; UNALIGNED-NEXT:    [[ALLOCA:%.*]] = alloca [128 x i32], align 1, addrspace(5)
; UNALIGNED-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [128 x i32], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[OFFSET:%.*]]
; UNALIGNED-NEXT:    [[TMP1:%.*]] = load <2 x i32>, ptr addrspace(5) [[PTR0]], align 1
; UNALIGNED-NEXT:    [[VAL01:%.*]] = extractelement <2 x i32> [[TMP1]], i32 0
; UNALIGNED-NEXT:    [[VAL12:%.*]] = extractelement <2 x i32> [[TMP1]], i32 1
; UNALIGNED-NEXT:    [[ADD:%.*]] = add i32 [[VAL01]], [[VAL12]]
; UNALIGNED-NEXT:    store i32 [[ADD]], ptr addrspace(1) [[OUT:%.*]], align 4
; UNALIGNED-NEXT:    ret void
;
  %alloca = alloca [128 x i32], align 1, addrspace(5)
  %ptr0 = getelementptr inbounds [128 x i32], ptr addrspace(5) %alloca, i32 0, i32 %offset
  %val0 = load i32, ptr addrspace(5) %ptr0, align 1
  %ptr1 = getelementptr inbounds i32, ptr addrspace(5) %ptr0, i32 1
  %val1 = load i32, ptr addrspace(5) %ptr1, align 1
  %add = add i32 %val0, %val1
  store i32 %add, ptr addrspace(1) %out
  ret void
}

; Make sure alloca alignment isn't decreased
define amdgpu_kernel void @load_alloca16_unknown_offset_align1_i32(ptr addrspace(1) noalias %out, i32 %offset) #0 {
; ALIGNED-LABEL: @load_alloca16_unknown_offset_align1_i32(
; ALIGNED-NEXT:    [[ALLOCA:%.*]] = alloca [128 x i32], align 16, addrspace(5)
; ALIGNED-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [128 x i32], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[OFFSET:%.*]]
; ALIGNED-NEXT:    [[VAL0:%.*]] = load i32, ptr addrspace(5) [[PTR0]], align 1
; ALIGNED-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i32, ptr addrspace(5) [[PTR0]], i32 1
; ALIGNED-NEXT:    [[VAL1:%.*]] = load i32, ptr addrspace(5) [[PTR1]], align 1
; ALIGNED-NEXT:    [[ADD:%.*]] = add i32 [[VAL0]], [[VAL1]]
; ALIGNED-NEXT:    store i32 [[ADD]], ptr addrspace(1) [[OUT:%.*]], align 4
; ALIGNED-NEXT:    ret void
;
; UNALIGNED-LABEL: @load_alloca16_unknown_offset_align1_i32(
; UNALIGNED-NEXT:    [[ALLOCA:%.*]] = alloca [128 x i32], align 16, addrspace(5)
; UNALIGNED-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [128 x i32], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[OFFSET:%.*]]
; UNALIGNED-NEXT:    [[TMP1:%.*]] = load <2 x i32>, ptr addrspace(5) [[PTR0]], align 4
; UNALIGNED-NEXT:    [[VAL01:%.*]] = extractelement <2 x i32> [[TMP1]], i32 0
; UNALIGNED-NEXT:    [[VAL12:%.*]] = extractelement <2 x i32> [[TMP1]], i32 1
; UNALIGNED-NEXT:    [[ADD:%.*]] = add i32 [[VAL01]], [[VAL12]]
; UNALIGNED-NEXT:    store i32 [[ADD]], ptr addrspace(1) [[OUT:%.*]], align 4
; UNALIGNED-NEXT:    ret void
;
  %alloca = alloca [128 x i32], align 16, addrspace(5)
  %ptr0 = getelementptr inbounds [128 x i32], ptr addrspace(5) %alloca, i32 0, i32 %offset
  %val0 = load i32, ptr addrspace(5) %ptr0, align 1
  %ptr1 = getelementptr inbounds i32, ptr addrspace(5) %ptr0, i32 1
  %val1 = load i32, ptr addrspace(5) %ptr1, align 1
  %add = add i32 %val0, %val1
  store i32 %add, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @store_unknown_offset_align1_i8(ptr addrspace(1) noalias %out, i32 %offset) #0 {
; ALIGNED-LABEL: @store_unknown_offset_align1_i8(
; ALIGNED-NEXT:    [[ALLOCA:%.*]] = alloca [128 x i8], align 1, addrspace(5)
; ALIGNED-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [128 x i8], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[OFFSET:%.*]]
; ALIGNED-NEXT:    store i8 9, ptr addrspace(5) [[PTR0]], align 1
; ALIGNED-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i8, ptr addrspace(5) [[PTR0]], i32 1
; ALIGNED-NEXT:    store i8 10, ptr addrspace(5) [[PTR1]], align 1
; ALIGNED-NEXT:    ret void
;
; UNALIGNED-LABEL: @store_unknown_offset_align1_i8(
; UNALIGNED-NEXT:    [[ALLOCA:%.*]] = alloca [128 x i8], align 1, addrspace(5)
; UNALIGNED-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [128 x i8], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[OFFSET:%.*]]
; UNALIGNED-NEXT:    store <2 x i8> <i8 9, i8 10>, ptr addrspace(5) [[PTR0]], align 1
; UNALIGNED-NEXT:    ret void
;
  %alloca = alloca [128 x i8], align 1, addrspace(5)
  %ptr0 = getelementptr inbounds [128 x i8], ptr addrspace(5) %alloca, i32 0, i32 %offset
  store i8 9, ptr addrspace(5) %ptr0, align 1
  %ptr1 = getelementptr inbounds i8, ptr addrspace(5) %ptr0, i32 1
  store i8 10, ptr addrspace(5) %ptr1, align 1
  ret void
}

define amdgpu_kernel void @store_unknown_offset_align1_i16(ptr addrspace(1) noalias %out, i32 %offset) #0 {
; ALIGNED-LABEL: @store_unknown_offset_align1_i16(
; ALIGNED-NEXT:    [[ALLOCA:%.*]] = alloca [128 x i16], align 1, addrspace(5)
; ALIGNED-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [128 x i16], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[OFFSET:%.*]]
; ALIGNED-NEXT:    store i16 9, ptr addrspace(5) [[PTR0]], align 1
; ALIGNED-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i16, ptr addrspace(5) [[PTR0]], i32 1
; ALIGNED-NEXT:    store i16 10, ptr addrspace(5) [[PTR1]], align 1
; ALIGNED-NEXT:    ret void
;
; UNALIGNED-LABEL: @store_unknown_offset_align1_i16(
; UNALIGNED-NEXT:    [[ALLOCA:%.*]] = alloca [128 x i16], align 1, addrspace(5)
; UNALIGNED-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [128 x i16], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[OFFSET:%.*]]
; UNALIGNED-NEXT:    store <2 x i16> <i16 9, i16 10>, ptr addrspace(5) [[PTR0]], align 1
; UNALIGNED-NEXT:    ret void
;
  %alloca = alloca [128 x i16], align 1, addrspace(5)
  %ptr0 = getelementptr inbounds [128 x i16], ptr addrspace(5) %alloca, i32 0, i32 %offset
  store i16 9, ptr addrspace(5) %ptr0, align 1
  %ptr1 = getelementptr inbounds i16, ptr addrspace(5) %ptr0, i32 1
  store i16 10, ptr addrspace(5) %ptr1, align 1
  ret void
}

; FIXME: Although the offset is unknown here, we know it is a multiple
; of the element size, so it still should be align 4.

define amdgpu_kernel void @store_unknown_offset_align1_i32(ptr addrspace(1) noalias %out, i32 %offset) #0 {
; ALIGNED-LABEL: @store_unknown_offset_align1_i32(
; ALIGNED-NEXT:    [[ALLOCA:%.*]] = alloca [128 x i32], align 1, addrspace(5)
; ALIGNED-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [128 x i32], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[OFFSET:%.*]]
; ALIGNED-NEXT:    store i32 9, ptr addrspace(5) [[PTR0]], align 1
; ALIGNED-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i32, ptr addrspace(5) [[PTR0]], i32 1
; ALIGNED-NEXT:    store i32 10, ptr addrspace(5) [[PTR1]], align 1
; ALIGNED-NEXT:    ret void
;
; UNALIGNED-LABEL: @store_unknown_offset_align1_i32(
; UNALIGNED-NEXT:    [[ALLOCA:%.*]] = alloca [128 x i32], align 1, addrspace(5)
; UNALIGNED-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [128 x i32], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[OFFSET:%.*]]
; UNALIGNED-NEXT:    store <2 x i32> <i32 9, i32 10>, ptr addrspace(5) [[PTR0]], align 1
; UNALIGNED-NEXT:    ret void
;
  %alloca = alloca [128 x i32], align 1, addrspace(5)
  %ptr0 = getelementptr inbounds [128 x i32], ptr addrspace(5) %alloca, i32 0, i32 %offset
  store i32 9, ptr addrspace(5) %ptr0, align 1
  %ptr1 = getelementptr inbounds i32, ptr addrspace(5) %ptr0, i32 1
  store i32 10, ptr addrspace(5) %ptr1, align 1
  ret void
}

define amdgpu_kernel void @merge_private_store_4_vector_elts_loads_v4i32() {
; CHECK-LABEL: @merge_private_store_4_vector_elts_loads_v4i32(
; CHECK-NEXT:    [[ALLOCA:%.*]] = alloca [8 x i32], align 4, addrspace(5)
; CHECK-NEXT:    store <4 x i32> <i32 9, i32 1, i32 23, i32 19>, ptr addrspace(5) [[ALLOCA]], align 4
; CHECK-NEXT:    ret void
;
  %alloca = alloca [8 x i32], align 1, addrspace(5)
  %out.gep.1 = getelementptr i32, ptr addrspace(5) %alloca, i32 1
  %out.gep.2 = getelementptr i32, ptr addrspace(5) %alloca, i32 2
  %out.gep.3 = getelementptr i32, ptr addrspace(5) %alloca, i32 3

  store i32 9, ptr addrspace(5) %alloca, align 1
  store i32 1, ptr addrspace(5) %out.gep.1, align 1
  store i32 23, ptr addrspace(5) %out.gep.2, align 1
  store i32 19, ptr addrspace(5) %out.gep.3, align 1
  ret void
}

define amdgpu_kernel void @merge_private_store_4_vector_elts_loads_v4i8() {
; CHECK-LABEL: @merge_private_store_4_vector_elts_loads_v4i8(
; CHECK-NEXT:    [[ALLOCA:%.*]] = alloca [8 x i8], align 4, addrspace(5)
; CHECK-NEXT:    store <4 x i8> <i8 9, i8 1, i8 23, i8 19>, ptr addrspace(5) [[ALLOCA]], align 4
; CHECK-NEXT:    ret void
;
  %alloca = alloca [8 x i8], align 1, addrspace(5)
  %out.gep.1 = getelementptr i8, ptr addrspace(5) %alloca, i8 1
  %out.gep.2 = getelementptr i8, ptr addrspace(5) %alloca, i8 2
  %out.gep.3 = getelementptr i8, ptr addrspace(5) %alloca, i8 3

  store i8 9, ptr addrspace(5) %alloca, align 1
  store i8 1, ptr addrspace(5) %out.gep.1, align 1
  store i8 23, ptr addrspace(5) %out.gep.2, align 1
  store i8 19, ptr addrspace(5) %out.gep.3, align 1
  ret void
}

define amdgpu_kernel void @merge_private_load_4_vector_elts_loads_v4i32() {
; CHECK-LABEL: @merge_private_load_4_vector_elts_loads_v4i32(
; CHECK-NEXT:    [[ALLOCA:%.*]] = alloca [8 x i32], align 4, addrspace(5)
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr addrspace(5) [[ALLOCA]], align 4
; CHECK-NEXT:    [[LOAD01:%.*]] = extractelement <4 x i32> [[TMP1]], i32 0
; CHECK-NEXT:    [[LOAD12:%.*]] = extractelement <4 x i32> [[TMP1]], i32 1
; CHECK-NEXT:    [[LOAD23:%.*]] = extractelement <4 x i32> [[TMP1]], i32 2
; CHECK-NEXT:    [[LOAD34:%.*]] = extractelement <4 x i32> [[TMP1]], i32 3
; CHECK-NEXT:    ret void
;
  %alloca = alloca [8 x i32], align 1, addrspace(5)
  %out.gep.1 = getelementptr i32, ptr addrspace(5) %alloca, i32 1
  %out.gep.2 = getelementptr i32, ptr addrspace(5) %alloca, i32 2
  %out.gep.3 = getelementptr i32, ptr addrspace(5) %alloca, i32 3

  %load0 = load i32, ptr addrspace(5) %alloca, align 1
  %load1 = load i32, ptr addrspace(5) %out.gep.1, align 1
  %load2 = load i32, ptr addrspace(5) %out.gep.2, align 1
  %load3 = load i32, ptr addrspace(5) %out.gep.3, align 1
  ret void
}

define amdgpu_kernel void @merge_private_load_4_vector_elts_loads_v4i8() {
; CHECK-LABEL: @merge_private_load_4_vector_elts_loads_v4i8(
; CHECK-NEXT:    [[ALLOCA:%.*]] = alloca [8 x i8], align 4, addrspace(5)
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i8>, ptr addrspace(5) [[ALLOCA]], align 4
; CHECK-NEXT:    [[LOAD01:%.*]] = extractelement <4 x i8> [[TMP1]], i32 0
; CHECK-NEXT:    [[LOAD12:%.*]] = extractelement <4 x i8> [[TMP1]], i32 1
; CHECK-NEXT:    [[LOAD23:%.*]] = extractelement <4 x i8> [[TMP1]], i32 2
; CHECK-NEXT:    [[LOAD34:%.*]] = extractelement <4 x i8> [[TMP1]], i32 3
; CHECK-NEXT:    ret void
;
  %alloca = alloca [8 x i8], align 1, addrspace(5)
  %out.gep.1 = getelementptr i8, ptr addrspace(5) %alloca, i8 1
  %out.gep.2 = getelementptr i8, ptr addrspace(5) %alloca, i8 2
  %out.gep.3 = getelementptr i8, ptr addrspace(5) %alloca, i8 3

  %load0 = load i8, ptr addrspace(5) %alloca, align 1
  %load1 = load i8, ptr addrspace(5) %out.gep.1, align 1
  %load2 = load i8, ptr addrspace(5) %out.gep.2, align 1
  %load3 = load i8, ptr addrspace(5) %out.gep.3, align 1
  ret void
}

; Make sure we don't think the alignment will increase if the base address isn't an alloca
define void @private_store_2xi16_align2_not_alloca(ptr addrspace(5) %p, ptr addrspace(5) %r) #0 {
; ALIGNED-LABEL: @private_store_2xi16_align2_not_alloca(
; ALIGNED-NEXT:    [[GEP_R:%.*]] = getelementptr i16, ptr addrspace(5) [[R:%.*]], i32 1
; ALIGNED-NEXT:    store i16 1, ptr addrspace(5) [[R]], align 2
; ALIGNED-NEXT:    store i16 2, ptr addrspace(5) [[GEP_R]], align 2
; ALIGNED-NEXT:    ret void
;
; UNALIGNED-LABEL: @private_store_2xi16_align2_not_alloca(
; UNALIGNED-NEXT:    store <2 x i16> <i16 1, i16 2>, ptr addrspace(5) [[R:%.*]], align 2
; UNALIGNED-NEXT:    ret void
;
  %gep.r = getelementptr i16, ptr addrspace(5) %r, i32 1
  store i16 1, ptr addrspace(5) %r, align 2
  store i16 2, ptr addrspace(5) %gep.r, align 2
  ret void
}

define void @private_store_2xi16_align1_not_alloca(ptr addrspace(5) %p, ptr addrspace(5) %r) #0 {
; ALIGNED-LABEL: @private_store_2xi16_align1_not_alloca(
; ALIGNED-NEXT:    [[GEP_R:%.*]] = getelementptr i16, ptr addrspace(5) [[R:%.*]], i32 1
; ALIGNED-NEXT:    store i16 1, ptr addrspace(5) [[R]], align 1
; ALIGNED-NEXT:    store i16 2, ptr addrspace(5) [[GEP_R]], align 1
; ALIGNED-NEXT:    ret void
;
; UNALIGNED-LABEL: @private_store_2xi16_align1_not_alloca(
; UNALIGNED-NEXT:    store <2 x i16> <i16 1, i16 2>, ptr addrspace(5) [[R:%.*]], align 1
; UNALIGNED-NEXT:    ret void
;
  %gep.r = getelementptr i16, ptr addrspace(5) %r, i32 1
  store i16 1, ptr addrspace(5) %r, align 1
  store i16 2, ptr addrspace(5) %gep.r, align 1
  ret void
}

define i32 @private_load_2xi16_align2_not_alloca(ptr addrspace(5) %p) #0 {
; ALIGNED-LABEL: @private_load_2xi16_align2_not_alloca(
; ALIGNED-NEXT:    [[GEP_P:%.*]] = getelementptr i16, ptr addrspace(5) [[P:%.*]], i64 1
; ALIGNED-NEXT:    [[P_0:%.*]] = load i16, ptr addrspace(5) [[P]], align 2
; ALIGNED-NEXT:    [[P_1:%.*]] = load i16, ptr addrspace(5) [[GEP_P]], align 2
; ALIGNED-NEXT:    [[ZEXT_0:%.*]] = zext i16 [[P_0]] to i32
; ALIGNED-NEXT:    [[ZEXT_1:%.*]] = zext i16 [[P_1]] to i32
; ALIGNED-NEXT:    [[SHL_1:%.*]] = shl i32 [[ZEXT_1]], 16
; ALIGNED-NEXT:    [[OR:%.*]] = or i32 [[ZEXT_0]], [[SHL_1]]
; ALIGNED-NEXT:    ret i32 [[OR]]
;
; UNALIGNED-LABEL: @private_load_2xi16_align2_not_alloca(
; UNALIGNED-NEXT:    [[TMP1:%.*]] = load <2 x i16>, ptr addrspace(5) [[P:%.*]], align 2
; UNALIGNED-NEXT:    [[P_01:%.*]] = extractelement <2 x i16> [[TMP1]], i32 0
; UNALIGNED-NEXT:    [[P_12:%.*]] = extractelement <2 x i16> [[TMP1]], i32 1
; UNALIGNED-NEXT:    [[ZEXT_0:%.*]] = zext i16 [[P_01]] to i32
; UNALIGNED-NEXT:    [[ZEXT_1:%.*]] = zext i16 [[P_12]] to i32
; UNALIGNED-NEXT:    [[SHL_1:%.*]] = shl i32 [[ZEXT_1]], 16
; UNALIGNED-NEXT:    [[OR:%.*]] = or i32 [[ZEXT_0]], [[SHL_1]]
; UNALIGNED-NEXT:    ret i32 [[OR]]
;
  %gep.p = getelementptr i16, ptr addrspace(5) %p, i64 1
  %p.0 = load i16, ptr addrspace(5) %p, align 2
  %p.1 = load i16, ptr addrspace(5) %gep.p, align 2
  %zext.0 = zext i16 %p.0 to i32
  %zext.1 = zext i16 %p.1 to i32
  %shl.1 = shl i32 %zext.1, 16
  %or = or i32 %zext.0, %shl.1
  ret i32 %or
}

define i32 @private_load_2xi16_align1_not_alloca(ptr addrspace(5) %p) #0 {
; ALIGNED-LABEL: @private_load_2xi16_align1_not_alloca(
; ALIGNED-NEXT:    [[GEP_P:%.*]] = getelementptr i16, ptr addrspace(5) [[P:%.*]], i64 1
; ALIGNED-NEXT:    [[P_0:%.*]] = load i16, ptr addrspace(5) [[P]], align 1
; ALIGNED-NEXT:    [[P_1:%.*]] = load i16, ptr addrspace(5) [[GEP_P]], align 1
; ALIGNED-NEXT:    [[ZEXT_0:%.*]] = zext i16 [[P_0]] to i32
; ALIGNED-NEXT:    [[ZEXT_1:%.*]] = zext i16 [[P_1]] to i32
; ALIGNED-NEXT:    [[SHL_1:%.*]] = shl i32 [[ZEXT_1]], 16
; ALIGNED-NEXT:    [[OR:%.*]] = or i32 [[ZEXT_0]], [[SHL_1]]
; ALIGNED-NEXT:    ret i32 [[OR]]
;
; UNALIGNED-LABEL: @private_load_2xi16_align1_not_alloca(
; UNALIGNED-NEXT:    [[TMP1:%.*]] = load <2 x i16>, ptr addrspace(5) [[P:%.*]], align 1
; UNALIGNED-NEXT:    [[P_01:%.*]] = extractelement <2 x i16> [[TMP1]], i32 0
; UNALIGNED-NEXT:    [[P_12:%.*]] = extractelement <2 x i16> [[TMP1]], i32 1
; UNALIGNED-NEXT:    [[ZEXT_0:%.*]] = zext i16 [[P_01]] to i32
; UNALIGNED-NEXT:    [[ZEXT_1:%.*]] = zext i16 [[P_12]] to i32
; UNALIGNED-NEXT:    [[SHL_1:%.*]] = shl i32 [[ZEXT_1]], 16
; UNALIGNED-NEXT:    [[OR:%.*]] = or i32 [[ZEXT_0]], [[SHL_1]]
; UNALIGNED-NEXT:    ret i32 [[OR]]
;
  %gep.p = getelementptr i16, ptr addrspace(5) %p, i64 1
  %p.0 = load i16, ptr addrspace(5) %p, align 1
  %p.1 = load i16, ptr addrspace(5) %gep.p, align 1
  %zext.0 = zext i16 %p.0 to i32
  %zext.1 = zext i16 %p.1 to i32
  %shl.1 = shl i32 %zext.1, 16
  %or = or i32 %zext.0, %shl.1
  ret i32 %or
}

define void @load_alloca16_unknown_offset_align1_i8(ptr addrspace(1) noalias %out, i32 %offset) #0 {
; ALIGNED-LABEL: @load_alloca16_unknown_offset_align1_i8(
; ALIGNED-NEXT:    [[ALLOCA:%.*]] = alloca [128 x i8], align 16, addrspace(5)
; ALIGNED-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [128 x i8], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[OFFSET:%.*]]
; ALIGNED-NEXT:    [[VAL0:%.*]] = load i8, ptr addrspace(5) [[PTR0]], align 1
; ALIGNED-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i8, ptr addrspace(5) [[PTR0]], i32 1
; ALIGNED-NEXT:    [[VAL1:%.*]] = load i8, ptr addrspace(5) [[PTR1]], align 1
; ALIGNED-NEXT:    [[ADD:%.*]] = add i8 [[VAL0]], [[VAL1]]
; ALIGNED-NEXT:    store i8 [[ADD]], ptr addrspace(1) [[OUT:%.*]], align 1
; ALIGNED-NEXT:    ret void
;
; UNALIGNED-LABEL: @load_alloca16_unknown_offset_align1_i8(
; UNALIGNED-NEXT:    [[ALLOCA:%.*]] = alloca [128 x i8], align 16, addrspace(5)
; UNALIGNED-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [128 x i8], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[OFFSET:%.*]]
; UNALIGNED-NEXT:    [[TMP1:%.*]] = load <2 x i8>, ptr addrspace(5) [[PTR0]], align 1
; UNALIGNED-NEXT:    [[VAL01:%.*]] = extractelement <2 x i8> [[TMP1]], i32 0
; UNALIGNED-NEXT:    [[VAL12:%.*]] = extractelement <2 x i8> [[TMP1]], i32 1
; UNALIGNED-NEXT:    [[ADD:%.*]] = add i8 [[VAL01]], [[VAL12]]
; UNALIGNED-NEXT:    store i8 [[ADD]], ptr addrspace(1) [[OUT:%.*]], align 1
; UNALIGNED-NEXT:    ret void
;
  %alloca = alloca [128 x i8], align 16, addrspace(5)
  %ptr0 = getelementptr inbounds [128 x i8], ptr addrspace(5) %alloca, i32 0, i32 %offset
  %val0 = load i8, ptr addrspace(5) %ptr0, align 1
  %ptr1 = getelementptr inbounds i8, ptr addrspace(5) %ptr0, i32 1
  %val1 = load i8, ptr addrspace(5) %ptr1, align 1
  %add = add i8 %val0, %val1
  store i8 %add, ptr addrspace(1) %out
  ret void
}

define void @store_alloca16_unknown_offset_align1_i32(ptr addrspace(1) noalias %out, i32 %offset) #0 {
; ALIGNED-LABEL: @store_alloca16_unknown_offset_align1_i32(
; ALIGNED-NEXT:    [[ALLOCA:%.*]] = alloca [128 x i32], align 16, addrspace(5)
; ALIGNED-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [128 x i32], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[OFFSET:%.*]]
; ALIGNED-NEXT:    store i32 9, ptr addrspace(5) [[PTR0]], align 1
; ALIGNED-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i32, ptr addrspace(5) [[PTR0]], i32 1
; ALIGNED-NEXT:    store i32 10, ptr addrspace(5) [[PTR1]], align 1
; ALIGNED-NEXT:    ret void
;
; UNALIGNED-LABEL: @store_alloca16_unknown_offset_align1_i32(
; UNALIGNED-NEXT:    [[ALLOCA:%.*]] = alloca [128 x i32], align 16, addrspace(5)
; UNALIGNED-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [128 x i32], ptr addrspace(5) [[ALLOCA]], i32 0, i32 [[OFFSET:%.*]]
; UNALIGNED-NEXT:    store <2 x i32> <i32 9, i32 10>, ptr addrspace(5) [[PTR0]], align 4
; UNALIGNED-NEXT:    ret void
;
  %alloca = alloca [128 x i32], align 16, addrspace(5)
  %ptr0 = getelementptr inbounds [128 x i32], ptr addrspace(5) %alloca, i32 0, i32 %offset
  store i32 9, ptr addrspace(5) %ptr0, align 1
  %ptr1 = getelementptr inbounds i32, ptr addrspace(5) %ptr0, i32 1
  store i32 10, ptr addrspace(5) %ptr1, align 1
  ret void
}

attributes #0 = { nounwind }
