// RUN: llvm-mc -arch=amdgcn -mcpu=fiji -show-encoding %s | FileCheck %s --check-prefix=VI


.globl global
.globl gds

// Parse a global expression
s_mov_b32 s0, global
// VI: s_mov_b32 s0, global ; encoding: [0xff,0x00,0x80,0xbe,A,A,A,A]
// VI-NEXT: ;   fixup A - offset: 4, value: global, kind: FK_PCRel_4

// Use a token with the same name as a global
ds_gws_init v2 gds
// VI: ds_gws_init v2 gds ; encoding: [0x00,0x00,0x33,0xd8,0x02,0x00,0x00,0x00]

// Use a global with the same name as a token
s_mov_b32 s0, gds
// VI: s_mov_b32 s0, gds ; encoding: [0xff,0x00,0x80,0xbe,A,A,A,A]
// VI-NEXT: ;   fixup A - offset: 4, value: gds, kind: FK_PCRel_4

// Use a binary expression
s_mov_b32 s0, gds+4
// VI: s_mov_b32 s0, gds+4 ; encoding: [0xff,0x00,0x80,0xbe,A,A,A,A]
// VI-NEXT: ;   fixup A - offset: 4, value: gds+4, kind: FK_PCRel_4

// Consecutive instructions with no blank line in between to make sure we
// don't call Lex() too many times.
s_add_u32 s0, s0, global+4
s_addc_u32 s1, s1, 0
// VI: s_add_u32 s0, s0, global+4
// VI: s_addc_u32 s1, s1, 0
