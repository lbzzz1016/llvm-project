; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -verify-machineinstrs -mtriple=aarch64-none-linux-gnu -mattr=+neon | FileCheck %s

; A vector TruncStore can not be selected.
; Test a trunc IR and a vector store IR can be selected correctly.

define void @v2i64_v2i32(<2 x i64> %a, ptr %result) {
; CHECK-LABEL: v2i64_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    xtn v0.2s, v0.2d
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %b = trunc <2 x i64> %a to <2 x i32>
  store <2 x i32> %b, ptr %result
  ret void
}

define void @v4i64_v4i32(<4 x i64> %a, ptr %result) {
; CHECK-LABEL: v4i64_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uzp1 v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %b = trunc <4 x i64> %a to <4 x i32>
  store <4 x i32> %b, ptr %result
  ret void
}

define void @v8i64_v8i32(<8 x i64> %a, ptr %result) {
; CHECK-LABEL: v8i64_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uzp1 v2.4s, v2.4s, v3.4s
; CHECK-NEXT:    uzp1 v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    stp q0, q2, [x0]
; CHECK-NEXT:    ret
  %b = trunc <8 x i64> %a to <8 x i32>
  store <8 x i32> %b, ptr %result
  ret void
}

define void @v2i32_v2i16(<2 x i32> %a, ptr %result) {
; CHECK-LABEL: v2i32_v2i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    mov s1, v0.s[1]
; CHECK-NEXT:    str h0, [x0]
; CHECK-NEXT:    str h1, [x0, #2]
; CHECK-NEXT:    ret
  %b = trunc <2 x i32> %a to <2 x i16>
  store <2 x i16> %b, ptr %result
  ret void
}

define void @v4i32_v4i16(<4 x i32> %a, ptr %result) {
; CHECK-LABEL: v4i32_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %b = trunc <4 x i32> %a to <4 x i16>
  store <4 x i16> %b, ptr %result
  ret void
}

define void @v8i32_v8i16(<8 x i32> %a, ptr %result) {
; CHECK-LABEL: v8i32_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uzp1 v0.8h, v0.8h, v1.8h
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %b = trunc <8 x i32> %a to <8 x i16>
  store <8 x i16> %b, ptr %result
  ret void
}

define void @v16i32_v16i16(<16 x i32> %a, ptr %result) {
; CHECK-LABEL: v16i32_v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uzp1 v2.8h, v2.8h, v3.8h
; CHECK-NEXT:    uzp1 v0.8h, v0.8h, v1.8h
; CHECK-NEXT:    stp q0, q2, [x0]
; CHECK-NEXT:    ret
  %b = trunc <16 x i32> %a to <16 x i16>
  store <16 x i16> %b, ptr %result
  ret void
}

define void @v2i32_v2i8(<2 x i32> %a, ptr %result) {
; CHECK-LABEL: v2i32_v2i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    mov s1, v0.s[1]
; CHECK-NEXT:    str b0, [x0]
; CHECK-NEXT:    stur b1, [x0, #1]
; CHECK-NEXT:    ret
  %b = trunc <2 x i32> %a to <2 x i8>
  store <2 x i8> %b, ptr %result
  ret void
}

define void @v4i32_v4i8(<4 x i32> %a, ptr %result) {
; CHECK-LABEL: v4i32_v4i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    uzp1 v0.8b, v0.8b, v0.8b
; CHECK-NEXT:    str s0, [x0]
; CHECK-NEXT:    ret
  %b = trunc <4 x i32> %a to <4 x i8>
  store <4 x i8> %b, ptr %result
  ret void
}

define void @v8i32_v8i8(<8 x i32> %a, ptr %result) {
; CHECK-LABEL: v8i32_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uzp1 v0.8h, v0.8h, v1.8h
; CHECK-NEXT:    xtn v0.8b, v0.8h
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %b = trunc <8 x i32> %a to <8 x i8>
  store <8 x i8> %b, ptr %result
  ret void
}

define void @v16i32_v16i8(<16 x i32> %a, ptr %result) {
; CHECK-LABEL: v16i32_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uzp1 v2.8h, v2.8h, v3.8h
; CHECK-NEXT:    uzp1 v0.8h, v0.8h, v1.8h
; CHECK-NEXT:    uzp1 v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %b = trunc <16 x i32> %a to <16 x i8>
  store <16 x i8> %b, ptr %result
  ret void
}

define void @v32i32_v32i8(<32 x i32> %a, ptr %result) {
; CHECK-LABEL: v32i32_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uzp1 v6.8h, v6.8h, v7.8h
; CHECK-NEXT:    uzp1 v4.8h, v4.8h, v5.8h
; CHECK-NEXT:    uzp1 v2.8h, v2.8h, v3.8h
; CHECK-NEXT:    uzp1 v0.8h, v0.8h, v1.8h
; CHECK-NEXT:    uzp1 v1.16b, v4.16b, v6.16b
; CHECK-NEXT:    uzp1 v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %b = trunc <32 x i32> %a to <32 x i8>
  store <32 x i8> %b, ptr %result
  ret void
}

define void @v2i16_v2i8(<2 x i16> %a, ptr %result) {
; CHECK-LABEL: v2i16_v2i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    mov s1, v0.s[1]
; CHECK-NEXT:    str b0, [x0]
; CHECK-NEXT:    stur b1, [x0, #1]
; CHECK-NEXT:    ret
  %b = trunc <2 x i16> %a to <2 x i8>
  store <2 x i8> %b, ptr %result
  ret void
}

define void @v4i16_v4i8(<4 x i16> %a, ptr %result) {
; CHECK-LABEL: v4i16_v4i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uzp1 v0.8b, v0.8b, v0.8b
; CHECK-NEXT:    str s0, [x0]
; CHECK-NEXT:    ret
  %b = trunc <4 x i16> %a to <4 x i8>
  store <4 x i8> %b, ptr %result
  ret void
}

define void @v8i16_v8i8(<8 x i16> %a, ptr %result) {
; CHECK-LABEL: v8i16_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    xtn v0.8b, v0.8h
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %b = trunc <8 x i16> %a to <8 x i8>
  store <8 x i8> %b, ptr %result
  ret void
}

define void @v16i16_v16i8(<16 x i16> %a, ptr %result) {
; CHECK-LABEL: v16i16_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uzp1 v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %b = trunc <16 x i16> %a to <16 x i8>
  store <16 x i8> %b, ptr %result
  ret void
}

define void @v32i16_v32i8(<32 x i16> %a, ptr %result) {
; CHECK-LABEL: v32i16_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uzp1 v2.16b, v2.16b, v3.16b
; CHECK-NEXT:    uzp1 v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    stp q0, q2, [x0]
; CHECK-NEXT:    ret
  %b = trunc <32 x i16> %a to <32 x i8>
  store <32 x i8> %b, ptr %result
  ret void
}
