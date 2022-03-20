
#include <stdafx.h>
#include "asm.h"

string replace(cstring, cstring, cstring);

void Writer::put(Opcode o) {
  Opcode1& x = add(l);
  x.o = o;
  x.m = 0;
  x.disabled = false;
}

void Writer::put(Opcode o, int n, int reg) {
  Opcode1& x = add(l);
  x.o = o;
  x.i = n;
  x.m = 1;
  x.reg = reg;
  x.disabled = false;
}

void Writer::putr(Opcode o, int reg, int reg2) {
  Opcode1& x = add(l);
  x.o = o;
  x.reg2 = reg2;
  x.m = 1;
  x.reg = reg;
  x.disabled = false;
}


void Writer::put(Opcode o, cstring n, int reg) {
  Opcode1& x = add(l);
  x.o = o;
  x.s = n;
  x.m = 2;
  x.reg = reg;
  x.disabled = false;
}

//const char* aluOpDescr[] = { "or","and","xor","sub","sbc","add","adc","cp" };

/*
void Writer::make(FillBuffer& b) {
  for(int i=1; i<l.size(); i++) {
    Opcode1& o = l[i];
    if(!o.disabled)
    switch(o.o) {
      case c_ld_a_a:      b.str("  ld a, a\r\n"); break; 
      case c_ld_a_b:      b.str("  ld a, b\r\n"); break; 
      case c_ld_a_c:      b.str("  ld a, c\r\n"); break; 
      case c_ld_a_d:      b.str("  ld a, d\r\n"); break; 
      case c_ld_a_e:      b.str("  ld a, e\r\n"); break; 
      case c_ld_a_l:      b.str("  ld a, l\r\n"); break; 
      case c_ld_a_h:      b.str("  ld a, h\r\n"); break; 
      case c_ld_b_a:      b.str("  ld b, a\r\n"); break; 
      case c_ld_b_c:      b.str("  ld b, c\r\n"); break; 
      case c_ld_b_d:      b.str("  ld b, d\r\n"); break; 
      case c_ld_b_e:      b.str("  ld b, e\r\n"); break; 
      case c_ld_b_h:      b.str("  ld b, h\r\n"); break;
      case c_ld_b_l:      b.str("  ld b, l\r\n"); break;

      case c_ld_c_a:      b.str("  ld c, a\r\n"); break; 
      case c_ld_c_b:      b.str("  ld c, b\r\n"); break; 
      case c_ld_c_d:      b.str("  ld c, d\r\n"); break; 
      case c_ld_c_e:      b.str("  ld c, e\r\n"); break; 
      case c_ld_c_l:      b.str("  ld c, l\r\n"); break;
      case c_ld_d_a:      b.str("  ld d, a\r\n"); break; 
      case c_ld_d_b:      b.str("  ld d, b\r\n"); break; 
      case c_ld_d_c:      b.str("  ld d, c\r\n"); break; 
      case c_ld_d_e:      b.str("  ld d, e\r\n"); break; 
      case c_ld_d_l:      b.str("  ld d, l\r\n"); break; 
      case c_ld_d_h:      b.str("  ld d, h\r\n"); break; 
      case c_ld_e_a:      b.str("  ld e, a\r\n"); break; 
      case c_ld_e_b:      b.str("  ld e, b\r\n"); break; 
      case c_ld_e_c:      b.str("  ld e, c\r\n"); break; 
      case c_ld_e_d:      b.str("  ld e, d\r\n"); break; 
      case c_ld_e_l:      b.str("  ld e, l\r\n"); break; 
      case c_ld_h_a:      b.str("  ld h, a\r\n"); break; 
      case c_ld_h_b:      b.str("  ld h, b\r\n"); break; 
      case c_ld_l_a:      b.str("  ld l, a\r\n"); break; 
      case c_ld_l_b:      b.str("  ld l, b\r\n"); break; 
      case c_ld_l_c:      b.str("  ld l, c\r\n"); break; 
      case c_ld_l_h:      b.str("  ld l, h\r\n"); break; 
      case c_ld_a_HL:     b.str("  ld a, (hl)\r\n"); break; 
      case c_ld_b_HL:     b.str("  ld b, (hl)\r\n"); break; 
      case c_ld_c_HL:     b.str("  ld c, (hl)\r\n"); break; 
      case c_ld_d_HL:     b.str("  ld d, (hl)\r\n"); break; 
      case c_ld_e_HL:     b.str("  ld e, (hl)\r\n"); break; 
      case c_ld_h_HL:     b.str("  ld h, (hl)\r\n"); break; 
      case c_ld_l_HL:     b.str("  ld l, (hl)\r\n"); break; 
      case c_ld_HL_d:     b.str("  ld (hl), d\r\n"); break; 
      case c_ld_HL_e:     b.str("  ld (hl), e\r\n"); break; 

      case c_ld_a_flags:  b.str("  ld a, ").str(o.get()).str("\r\n"); break; 
      case c_ld_a:        b.str("  ld a, ").str(o.get()).str("\r\n"); break; 
      case c_ld_b:        b.str("  ld b, ").str(o.get()).str("\r\n"); break;  
      case c_ld_c:        b.str("  ld c, ").str(o.get()).str("\r\n"); break; 
      case c_ld_d:        b.str("  ld d, ").str(o.get()).str("\r\n"); break; 
      case c_ld_h:        b.str("  ld h, ").str(o.get()).str("\r\n"); break;  
      case c_ld_l:        b.str("  ld l, ").str(o.get()).str("\r\n"); break; 
      case c_ld_hl_bc:    b.str("  ld hl, bc\r\n"); break; 
      case c_ld_bc_hl:    b.str("  ld bc, hl\r\n"); break; 

      case c_ld_HL:     b.str("  ld (hl), ").str(o.get()).str("\r\n"); break;
      case c_ld_BC_a:   b.str("  ld (bc), a\r\n"); break; 
      case c_ld_HL_a:   b.str("  ld (hl), a\r\n"); break; 
      case c_ld_a_BC:   b.str("  ld a, (bc)\r\n"); break;
      case c_ld_a_DE:   b.str("  ld a, (bc)\r\n"); break;
      case c_ld_a_ref:  b.str("  ld a, (").str(o.get()).str(")\r\n"); break;
      case c_ld_ref_a:  b.str("  ld (").str(o.get()).str("), a\r\n"); break;
      case c_dec_HL:    b.str("  dec (hl)\r\n"); break;
      case c_inc_HL:    b.str("  inc (hl)\r\n"); break;
      case c_inc_a:     b.str("  inc a\r\n"); break;
      case c_inc_b:     b.str("  inc b\r\n"); break;
      case c_inc_c:     b.str("  inc c\r\n"); break;
      case c_inc_l:     b.str("  inc l\r\n"); break;
      case c_dec_a:     b.str("  dec a\r\n"); break;
      case c_dec_b:     b.str("  dec b\r\n"); break;
      case c_dec_c:     b.str("  dec c\r\n"); break;
      case c_dec_l:     b.str("  dec l\r\n"); break;

      case c_or_a:     b.str("  or a\r\n"); break;
      case c_or_b:     b.str("  or b\r\n"); break;
      case c_or_c:     b.str("  or c\r\n"); break;
      case c_or_d:     b.str("  or d\r\n"); break;
      case c_or_e:     b.str("  or e\r\n"); break;
      case c_or_h:     b.str("  or h\r\n"); break;
      case c_or_l:     b.str("  or l\r\n"); break;
      case c_or_HL:    b.str("  or (hl)\r\n"); break;
      case c_or:       b.str("  or ").str(o.get()).str("\r\n"); break;

      case c_and_a:     b.str("  and a\r\n"); break;
      case c_and_b:     b.str("  and b\r\n"); break;
      case c_and_c:     b.str("  and c\r\n"); break;
      case c_and_d:     b.str("  and d\r\n"); break;
      case c_and_e:     b.str("  and e\r\n"); break;
      case c_and_h:     b.str("  and h\r\n"); break;
      case c_and_l:     b.str("  and l\r\n"); break;
      case c_and_HL:    b.str("  and (hl)\r\n"); break;
      case c_and:       b.str("  and ").str(o.get()).str("\r\n"); break;

      case c_xor_a:     b.str("  xor a\r\n"); break;
      case c_xor_b:     b.str("  xor b\r\n"); break;
      case c_xor_c:     b.str("  xor c\r\n"); break;
      case c_xor_d:     b.str("  xor d\r\n"); break;
      case c_xor_e:     b.str("  xor e\r\n"); break;
      case c_xor_h:     b.str("  xor h\r\n"); break;
      case c_xor_l:     b.str("  xor l\r\n"); break;
      case c_xor_HL:    b.str("  xor (hl)\r\n"); break;
      case c_xor:       b.str("  xor ").str(o.get()).str("\r\n"); break;

      case c_add_a:     b.str("  add a\r\n"); break;
      case c_add_b:     b.str("  add b\r\n"); break;
      case c_add_c:     b.str("  add c\r\n"); break;
      case c_add_d:     b.str("  add d\r\n"); break;
      case c_add_e:     b.str("  add e\r\n"); break;
      case c_add_h:     b.str("  add h\r\n"); break;
      case c_add_l:     b.str("  add l\r\n"); break;
      case c_add_HL:    b.str("  add (hl)\r\n"); break;
      case c_add:       b.str("  add ").str(o.get()).str("\r\n"); break;

      case c_adc_a:     b.str("  adc a\r\n"); break;
      case c_adc_b:     b.str("  adc b\r\n"); break;
      case c_adc_c:     b.str("  adc c\r\n"); break;
      case c_adc_d:     b.str("  adc d\r\n"); break;
      case c_adc_e:     b.str("  adc e\r\n"); break;
      case c_adc_h:     b.str("  adc h\r\n"); break;
      case c_adc_l:     b.str("  adc l\r\n"); break;
      case c_adc_HL:    b.str("  adc (hl)\r\n"); break;
      case c_adc:       b.str("  adc ").str(o.get()).str("\r\n"); break;

      case c_sub_a:     b.str("  sub a\r\n"); break;
      case c_sub_b:     b.str("  sub b\r\n"); break;
      case c_sub_c:     b.str("  sub c\r\n"); break;
      case c_sub_d:     b.str("  sub d\r\n"); break;
      case c_sub_e:     b.str("  sub e\r\n"); break;
      case c_sub_h:     b.str("  sub h\r\n"); break;
      case c_sub_l:     b.str("  sub l\r\n"); break;
      case c_sub_HL:    b.str("  sub (hl)\r\n"); break;
      case c_sub:       b.str("  sub ").str(o.get()).str("\r\n"); break;

      case c_sbc_a:     b.str("  sbc a\r\n"); break;
      case c_sbc_b:     b.str("  sbc b\r\n"); break;
      case c_sbc_c:     b.str("  sbc c\r\n"); break;
      case c_sbc_d:     b.str("  sbc d\r\n"); break;
      case c_sbc_e:     b.str("  sbc e\r\n"); break;
      case c_sbc_h:     b.str("  sbc h\r\n"); break;
      case c_sbc_l:     b.str("  sbc l\r\n"); break;
      case c_sbc_HL:    b.str("  sbc (hl)\r\n"); break;
      case c_sbc:       b.str("  sbc ").str(o.get()).str("\r\n"); break;

      case c_cp_a:     b.str("  cp a\r\n"); break;
      case c_cp_b:     b.str("  cp b\r\n"); break;
      case c_cp_c:     b.str("  cp c\r\n"); break;
      case c_cp_d:     b.str("  cp d\r\n"); break;
      case c_cp_e:     b.str("  cp e\r\n"); break;
      case c_cp_h:     b.str("  cp h\r\n"); break;
      case c_cp_l:     b.str("  cp l\r\n"); break;
      case c_cpz_HL:
      case c_cp_HL:    b.str("  cp (hl)\r\n"); break;
      case c_cpz:
      case c_cp:       b.str("  cp ").str(o.get()).str("\r\n"); break;

      case c_clcf:      b.str("  cp a\r\n"); break;
      case c_cpl:       b.str("  cpl\r\n"); break;
      case c_rra:       b.str("  rra\r\n"); break;
      case c_push_af:   b.str("  push af\r\n"); break;
      case c_pop_af:    b.str("  pop af\r\n"); break;
      case c_push_bc:   b.str("  push bc\r\n"); break;
      case c_pop_bc:    b.str("  pop bc\r\n"); break;
      case c_push_hl:   b.str("  push hl\r\n"); break;
      case c_pop_hl:    b.str("  pop hl\r\n"); break;
      case c_pop_de:    b.str("  pop de\r\n"); break;
      case c_dec_bc:    b.str("  dec bc\r\n"); break;
      case c_inc_bc:    b.str("  inc bc\r\n"); break;
      case c_dec_hl:    b.str("  dec hl\r\n"); break;
      case c_inc_hl:    b.str("  inc hl\r\n"); break;
      case c_inc_sp:    b.str("  inc sp\r\n"); break;
      case c_dec_sp:    b.str("  dec sp\r\n"); break;
      case c_ld_de:     b.str("  ld de, ").str(o.get()).str("\r\n"); break;
      case c_ld_hl:     b.str("  ld hl, ").str(o.get()).str("\r\n"); break;
      case c_ld_bc:     b.str("  ld bc, ").str(o.get()).str("\r\n"); break;
      case c_ld_hl_ref: b.str("  ld hl, (").str(o.get()).str(")\r\n"); break;
      case c_ld_ref_hl: b.str("  ld (").str(o.get()).str("), hl\r\n"); break;
      case c_add_hl_bc: b.str("  add hl, bc\r\n"); break;
      case c_add_hl_de: b.str("  add hl, de\r\n"); break;
      case c_add_hl_hl: b.str("  add hl, hl\r\n"); break;
      case c_ex_hl_de:  b.str("  ex hl, de\r\n"); break;
      case c_asm:       b.str(o.s).str("\r\n"); break;
      case c_labelProc: b.str(o.s).str(":\r\n"); break;
      case c_label:     b.str("l").i2s(o.i).str(":\r\n"); break;
      case c_jp:        b.str("  jp l").i2s(o.i).str("\r\n"); break;
      case c_jp_c:      b.str("  jp c, l").i2s(o.i).str("\r\n"); break;
      case c_jp_nc:     b.str("  jp nc, l").i2s(o.i).str("\r\n"); break;
      case c_jp_z:      b.str("  jp z, l").i2s(o.i).str("\r\n"); break;
      case c_jp_nz:     b.str("  jp nz, l").i2s(o.i).str("\r\n"); break;
      case c_call:      b.str("  call ").str(o.s).str("\r\n"); break;
      case c_ret:       b.str("  ret\r\n"); break; 
      case c_call_z:    b.str("  call z, ").str(o.s).str("\r\n"); break;
      case c_call_nz:   b.str("  call nz, ").str(o.s).str("\r\n"); break;
      case c_call_c:    b.str("  call cz, ").str(o.s).str("\r\n"); break;
      case c_call_nc:   b.str("  call nc, ").str(o.s).str("\r\n"); break;
      default: raise("make "+i2s(o.o));
    }
    if(!o.remark.empty())
      b.str("  ; ").str(o.remark).str("\r\n");
  }
  b.str(declb);
  b.str("  savebin \"test.rka\",0,$\r\n");
}
*/

const char* regName[] = { "a", "b", "c", "d", "e", "h", "l" };

void Writer::make(FillBuffer& b) {
  b.str("  .include \"stdlib8080.inc\"\r\n");
  for(int i=1; i<l.size(); i++) {
    Opcode1& o = l[i];
    if(o.disabled) continue; //b.str(";");

    switch(o.o) {
      case c_ld_r_r:      b.str("  mov ").str(regName[o.reg]).str(", ").str(regName[o.reg2]).str("\r\n"); break; 
      case c_ld_r_HL:     b.str("  mov ").str(regName[o.reg]).str(", m\r\n"); break; 
      case c_ld_r:        b.str("  mvi ").str(regName[o.reg]).str(", ").str(o.get()).str("\r\n"); break; 
      case c_ld_HL_r:     b.str("  mov m, ").str(regName[o.reg]).str("\r\n"); break; 

      case c_ld_a_flags:  b.str("  mvi a, ").str(o.get()).str("\r\n"); break; 

      case c_ld_hl_bc:    b.str("  mov h, b\r\n").str("  mov l, c\r\n"); break; 
      case c_ld_bc_hl:    b.str("  mov b, h\r\n").str("  mov c, l\r\n"); break; 

      case c_ld_HL:     b.str("  mvi m, ").str(o.get()).str("\r\n"); break;
      case c_ld_BC_a:   b.str("  stax b\r\n"); break; 
      case c_ld_a_DE:   b.str("  ldax d\r\n"); break;
      case c_ld_a_BC:   b.str("  ldax b\r\n"); break;
      case c_ld_a_ref:  b.str("  lda ").str(o.get()).str("\r\n"); break;
      case c_ld_ref_a:  b.str("  sta ").str(o.get()).str("\r\n"); break;
      case c_dec_HL:    b.str("  dcr m\r\n"); break;
      case c_inc_HL:    b.str("  inr m\r\n"); break;
      case c_inc_r:     b.str("  inr ").str(regName[o.reg]).str("\r\n"); break;
      case c_dec_r:     b.str("  dcr ").str(regName[o.reg]).str("\r\n"); break;

      case c_or_r:     b.str("  ora ").str(regName[o.reg]).str("\r\n"); break;
      case c_or_HL:    b.str("  ora m\r\n"); break;
      case c_or:       b.str("  ori ").str(o.get()).str("\r\n"); break;

      case c_and_r:     b.str("  ana ").str(regName[o.reg]).str("\r\n"); break;
      case c_and_HL:    b.str("  ana m\r\n"); break;
      case c_and:       b.str("  ani ").str(o.get()).str("\r\n"); break;

      case c_xor_r:     b.str("  xra ").str(regName[o.reg]).str("\r\n"); break;
      case c_xor_HL:    b.str("  xra m\r\n"); break;
      case c_xor:       b.str("  xri ").str(o.get()).str("\r\n"); break;

      case c_add_r:     b.str("  add ").str(regName[o.reg]).str("\r\n"); break;
      case c_add_HL:    b.str("  add m\r\n"); break;
      case c_add:       b.str("  adi ").str(o.get()).str("\r\n"); break;

      case c_adc_r:     b.str("  adc ").str(regName[o.reg]).str("\r\n"); break;
      case c_adc_HL:    b.str("  adc m\r\n"); break;
      case c_adc:       b.str("  aci ").str(o.get()).str("\r\n"); break;

      case c_sub_r:     b.str("  sub ").str(regName[o.reg]).str("\r\n"); break;
      case c_sub_HL:    b.str("  sub m\r\n"); break;
      case c_sub:       b.str("  sui ").str(o.get()).str("\r\n"); break;

      case c_sbc_r:     b.str("  sbb ").str(regName[o.reg]).str("\r\n"); break;
      case c_sbc_HL:    b.str("  sbb m\r\n"); break;
      case c_sbc:       b.str("  sbi ").str(o.get()).str("\r\n"); break;

      case c_cpz_r:
      case c_cp_r:     b.str("  cmp ").str(regName[o.reg]).str("\r\n"); break;
      case c_cpz_HL:
      case c_cp_HL:    b.str("  cmp m\r\n"); break;
      case c_cpz:
      case c_cp:       b.str("  cpi ").str(o.get()).str("\r\n"); break;

      case c_clcf:      b.str("  cmp a\r\n"); break;
      case c_cpl:       b.str("  cma\r\n"); break;
      case c_rra:       b.str("  rar\r\n"); break;
      case c_push_af:   b.str("  push psw\r\n"); break;
      case c_pop_af:    b.str("  pop psw\r\n"); break;
      case c_push_bc:   b.str("  push b\r\n"); break;
      case c_pop_bc:    b.str("  pop b\r\n"); break;
      case c_push_hl:   b.str("  push h\r\n"); break;
      case c_pop_hl:    b.str("  pop h\r\n"); break;
      case c_pop_de:    b.str("  pop d\r\n"); break;
      case c_dec_bc:    b.str("  dcx b\r\n"); break;
      case c_inc_bc:    b.str("  inx b\r\n"); break;
      case c_dec_hl:    b.str("  dcx h\r\n"); break;
      case c_inc_hl:    b.str("  inx h\r\n"); break;
      case c_inc_sp:    b.str("  inx sp\r\n"); break;
      case c_dec_sp:    b.str("  dcx sp\r\n"); break;
      case c_ld_de:     b.str("  lxi d, ").str(o.get()).str("\r\n"); break;
      case c_ld_hl:     b.str("  lxi h, ").str(o.get()).str("\r\n"); break;
      case c_ld_bc:     b.str("  lxi b, ").str(o.get()).str("\r\n"); break;
      case c_ld_hl_ref: b.str("  lhld ").str(o.get()).str("\r\n"); break;
      case c_ld_ref_hl: b.str("  shld ").str(o.get()).str("\r\n"); break;
      case c_add_hl_bc: b.str("  dad b\r\n"); break;
      case c_add_hl_de: b.str("  dad d\r\n"); break;
      case c_add_hl_hl: b.str("  dad h\r\n"); break;
      case c_ex_hl_de:  b.str("  xchg\r\n"); break;
      case c_asm:       b.str(o.s).str("\r\n"); break;
      case c_labelProc: b.str(o.s).str(":\r\n"); break;
      case c_label_loop: case c_label_forw: case c_label:     b.str("l").i2s(o.i).str(":\r\n"); break;
      case c_jp_long:   b.str("  jmp ").str(o.get()).str("\r\n"); break;

      case c_jp_loop:   case c_jp_forw:   case c_jp:        b.str("  jmp l").i2s(o.i).str("\r\n"); break;
      case c_jp_c_loop: case c_jp_c_forw: case c_jp_c:      b.str("  jc l").i2s(o.i).str("\r\n"); break;
      case c_jp_nc_loop:case c_jp_nc_forw:case c_jp_nc:     b.str("  jnc l").i2s(o.i).str("\r\n"); break;
      case c_jp_z_loop: case c_jp_z_forw: case c_jp_z:      b.str("  jz l").i2s(o.i).str("\r\n"); break;
      case c_jp_nz_loop:case c_jp_nz_forw:case c_jp_nz:     b.str("  jnz l").i2s(o.i).str("\r\n"); break;
      case c_call:      b.str("  call ").str(o.get()).str("\r\n"); break;
      case c_retPopBC:  if(o.i) b.str("  pop b\r\n"); b.str("  ret\r\n"); break; 
      case c_call_z:    b.str("  cz ").str(o.get()).str("\r\n"); break;
      case c_call_nz:   b.str("  cnz ").str(o.get()).str("\r\n"); break;
      case c_call_c:    b.str("  ccz ").str(o.get()).str("\r\n"); break;
      case c_call_nc:   b.str("  cnc ").str(o.get()).str("\r\n"); break;
      default: raise("make "+i2s(o.o));
    }
    if(!o.remark.empty())
      b.str("  ; ").str(replace("\r","",replace("\n","",o.remark))).str("\r\n");
  }
  b.str(declb);
  b.str("  .end\r\n");
}

#pragma pack(push,1)

struct State {
  int cursor, label;

  union {
    unsigned char r[7];
    struct {
      unsigned char a,b,c,d,e,h,l;
    };
  };
  string rn[7];
  union {
    unsigned char v[7];
    struct {
      unsigned char av,bv,cv,dv,ev,hv,lv;
    };
  };
  union {
    unsigned char rnv[7];
    struct {
      unsigned char anv,bnv,cnv,dnv,env,hnv,lnv;
    };
  };
  bool hlnv;
  unsigned int hlni;
  string hln;

  bool hlav;
  unsigned int hlai;
  string hla;

  string& an() { return rn[0]; }
  string& bn() { return rn[1]; }
  string& cn() { return rn[2]; }
  string& dn() { return rn[3]; }
  string& en() { return rn[4]; }
  string& hn() { return rn[5]; }
  string& ln() { return rn[6]; }

  void reset() { av=bv=cv=dv=ev=hv=lv=false; anv=bnv=cnv=dnv=env=hnv=lnv=false; hlnv=false; hlav=false; }

  void changed(cstring n) { 
    for(int i=0; i<7; i++)
      if(rnv[i] && rn[i]==n) 
        rnv[i]=false;
    if(hlav && hla==n && n!="*bc") hlav=false;
    if(hlnv && hln==n && n!="*bc") hlnv=false;
  } 
  void changedAll() { 
    anv=bnv=cnv=dnv=env=hnv=lnv=false;
    if(hlav && hla!="*bc") hlav=false;
    if(hlnv && hln!="*bc") hlnv=false;
  } 
  void combine(State& s1);
};

#pragma pack(pop)

void State::combine(State& s1) {
  for(int i=0; i<7; i++) {
    v[i] = v[i] && s1.v[i]; if(r[i] != s1.r[i]) v[i] = false;
    rnv[i] = rnv[i] && s1.rnv[i]; if(rn[i] != s1.rn[i]) rnv[i] = false;
  }
  hlnv = hlnv & s1.hlnv;
  if(hlni != s1.hlni || hln != s1.hln) hlnv=false;

  hlav = hlav & s1.hlav;
  if(hlai != s1.hlai || hla != s1.hla) hlav=false;
}

bool returnFlagsOfA(const Opcode1& o) {
  switch(o.o) {
    case c_or_HL:  case c_or_r:  case c_or:
    case c_and_HL: case c_and_r: case c_and:
    case c_add_HL: case c_add_r:  case c_add:
    case c_sub_HL: case c_sub_r: case c_sub:
    case c_xor_HL: case c_xor_r: case c_xor:
      return true;
    case c_dec_r:
    case c_inc_r:
      return o.reg==0;
  }
  return false;
}

void Writer::optimize() {
  State s;
  s.reset();

  std::list<State> forwardState;
  std::list<State> loopState;
  int optimizationOff=0;

  int t = calc();
  for(int i=1; i<this->l.size(); i++) {
retry:
    const Opcode1* o = &this->l[i];
    Opcode1* o1 = &this->l[i];
    if(!o->disabled)
    switch(o->o) {
      case c_ld_r_r:      //! Удалить
                          s.r[o->reg]  = s.r[o->reg2];  s.v[o->reg]   = s.v[o->reg2];   // Копирование константы
                          s.rn[o->reg] = s.rn[o->reg2]; s.rnv[o->reg] = s.rnv[o->reg2]; // Копирование значения переменной
                          if(o->reg==5 || o->reg==6) s.hlnv=false, s.hlav=false; // При изменении HL сбрасываем HL
                          break; 

      case c_ld_r_HL:     // Замена MOV A, M + ORA A на XOR A + OR M
                          if(optimizationOff==0 && o->reg==0 && o[1].o==c_or_r && o[1].reg==0) {
                            string x = s.hla; if(s.hlai) x += ".", x += i2s(s.hlai);
                            if(!(s.hlav && s.rnv[o->reg] && s.rn[o->reg]==x)) {
                              o1->o = c_xor_r;
                              o1[1].o=c_or_HL;
                              goto retry;
                            }
                          }
                          s.v[o->reg] = false; // В регистре не константа
                          if(s.hlav) { // HL содержит адрес переменной 
                            string x = s.hla; if(s.hlai) x += ".", x += i2s(s.hlai);
                            // Удаление MOV R, HL                          
                            if(optimizationOff==0 && s.rnv[o->reg] && s.rn[o->reg]==x) { o1->disabled=true; break; } // Регистр содержит ту же переменную
                            s.rn[o->reg]=x, s.rnv[o->reg]=true; // Регистр теперь содержит ту же переменную
                          } else {
                            s.rnv[o->reg] = false; // HL содержал неизвестно что
                          }
                          if(o->reg==5 || o->reg==6) s.hlnv=false, s.hlav=false; // При изменении HL сбрасываем HL

                          break; 

      case c_ld_bc_hl:    s.changed("*bc"); // BC изменилось, удалить её из регистров
                          s.hla="*bc", s.hlai=0, s.hlav=true; // HL теперь содержит значение BC
                          s.b=s.h; s.bv=s.hv; s.c=s.l; s.cv=s.lv; // Копируем константы
                          s.hlnv=false; // s.hlav=false; 
                          // Знетаменить команду на ld_b_h или ld_c_l
                          // Хранить состояние BC-HL
                          break; 

      case c_ld_hl_bc:    s.hlnv = false;
                          if(optimizationOff==0 && s.hlav && s.hla=="*bc") {
                            // Замена ..
                            if(s.hlai==2) { 
                              if(o[1].o != c_inc_hl) { o1->o=c_dec_hl; o=&insertir(l, i); o1->disabled=false; o1->o=c_dec_hl; goto retry; }
                              if(o[2].o != c_inc_hl) { o1[1].disabled=true; o1->o=c_dec_hl; goto retry; }
                              o1->disabled = true; o1[1].disabled=true; o1[2].disabled=true; break;
                            }
                            if(s.hlai==1) { if(o[1].o==c_inc_hl) o1->disabled=true; else o1->o=c_dec_hl; goto retry; }
                            if(s.hlai==0) { o1->disabled=true; break; }
                          }
                          s.h=s.b; s.hv=s.bv; s.l=s.c; s.lv=s.cv;                          
                          s.hla="*bc", s.hlai=0, s.hlav=true; 
                          // Заменить команду на ld_b_h или ld_c_l
                          // Хранить состояние BC-HL
                          break;


      case c_ld_a_flags:  s.anv=false; if(o->m==1) { s.a=o->i; s.av=true; } else s.av=false; break; 

      case c_ld_r:        s.rnv[o->reg]=false;
                          if(o->reg==5 || o->reg==6) s.hlav=s.hlnv=false;
                          if(o->m!=1) { s.v[o->reg] = false; break; }
                          if(optimizationOff==0) {
                            // Удаление MVI R, N
                            if(s.v[o->reg] && s.r[o->reg]==o->i) { o1->disabled=true; break; }
                            if(o->reg==0) { 
                              // Удаление MVI R, N
                              if(s.av && s.a==o->i) { o1->disabled = true; break; }
                              // Замена MVI A, N на XOR A
                              if(o->i==0) { s.a=o->i; s.av=true; o1->o = c_xor_r; goto retry; }
                              if(s.av) {
                                // Замена MVI A, N на CPL
                                if((s.a^0xFF)     ==o->i) { o1->o = c_cpl; goto retry; }
                                // Замена MVI A, N на ADD A
                                if(((s.a<<1)&0xFF)==o->i) { o1->o = c_add_r; goto retry; }
                              }
                            }
                            if(s.v[o->reg]) {
                              // Удаление MVI R, N
                              if(s.r[o->reg]==o->i) { o1->disabled=true; break; }
                              // Замена MVI R, N на INC R
                              if(((s.r[o->reg]+1)&0xFF) == o->i) { o1->o = c_inc_r; goto retry; }
                              // Замена MVI R, N на DEC R
                              if(((s.r[o->reg]-1)&0xFF) == o->i) { o1->o = c_dec_r; goto retry; }
                            }
                            // Замена MVI R, N на MOV R, R
                            for(int j=0; j<7; j++)
                              if(j!=o->reg)
                                if(s.v[j] && s.r[j]==o->i) { 
                                  o1->o = c_ld_r_r; o1->reg2=j; goto retry; 
                                }
                          }
                          s.r[o->reg]=o->i; s.v[o->reg]=true;
                          break; 
      case c_ld_HL:       // Замена MVI M, N + LD A, N на LD A, N + MVI M, A
                          if(optimizationOff==0 && o->m==1 && o[1].o==c_ld_r && o[1].reg==0 && o[1].i==o->i) {
                            std::swap(o1[0], o1[1]);
                            o1->o = c_ld_r;
                            o1->reg = 0;
                            o1[1].o = c_ld_HL_r; o1[1].reg = 0;
                            goto retry;
                          }
                          break;
      case c_ld_BC_a:     break; 
      case c_ld_a_DE:     
      case c_ld_a_BC:     s.av=false; s.anv=false; break;

      case c_ld_a_ref:    s.av = false; // Не числовое значение
                          if(o->m==2) { // Переменная
                            // Удаление LDA 
                            if(optimizationOff==0 && s.anv && s.an()==o->s) { o1->disabled = true; break; } // Уже загружено
                            // Замена LDA на MOV A, M 
                            if(optimizationOff==0 && s.hlav && s.hlai==0 && s.hla==o->s) { o1->o = c_ld_r_HL; o1->reg=0; goto retry; }
                            s.anv=true; s.an()=o->s; 
                          } else { // Константа
                            s.anv=false; 
                          }
                          break;

      case c_ld_ref_a:    if(o->m==2) { // Переменная
                            s.changed(o->s); // Изменили переменную в памяти, теперь только в регистре A содержится эта переменная
                            s.anv = true; s.an() = o->s; 
                            // Замена STA на MOV M, A 
                            if(optimizationOff==0 && s.hlav && s.hla==o->s && s.hlai==0) o1->o=c_ld_HL_r, o1->reg=0; // Более оптимальная команда
                          } else { // Константа
                            s.changedAll();
                          }
                          break;

      case c_ld_HL_r:     if(s.hlav && s.hlai==0) { s.changed(s.hla); s.rn[o->reg]=s.hla; s.rnv[o->reg]=true; }  // Изменили переменную в памяти, теперь только в регистре A содержится эта переменная
                                             else s.changedAll();    // Мы не знаем, что изменили, поэтому помечаем все переменные как измененные

      case c_inc_HL:      
      case c_dec_HL:      // Удаление середины из DCX H + MOV A, M + ORA A + JP CCC 
                          if(optimizationOff==0 
                          && ((o[1].o==c_ld_r_HL && o[1].reg==0) || (s.hlav && o[1].o==c_ld_a_ref && o[1].m==2 && o[1].s==s.hla))
                          && o[2].o==c_or_r && o[2].reg==0 
                          && (o[3].o==c_jp_z || o[3].o==c_jp_nz || o[3].o==c_jp_z_loop || o[3].o==c_jp_nz_loop || o[3].o==c_jp_z_forw || o[3].o==c_jp_nz_forw)) {
                            o1[1].disabled = true;  
                            o1[2].disabled = true;                            
                          }
                          if(s.hlav && s.hlai==0) s.changed(s.hla);  // Изменили переменную в памяти, в регистрах теперь содержится не эта переменная
                                             else s.changedAll();    // Мы не знаем, что изменили, поэтому помечаем все переменные как измененные
                          break;

      case c_inc_r:       s.rnv[o->reg] = false; s.r[o->reg] = (s.r[o->reg] + 1) & 0xFF; break;
      case c_dec_r:       
                          s.rnv[o->reg] = false; s.r[o->reg] = (s.r[o->reg] - 1) & 0xFF; break;

      // *** Арифметика ***

      case c_or_HL:       s.anv = false; s.av = false; break; //! Заменить на регистр
      case c_or:          s.anv = false; if(o->m==1) s.a |= o->i&0xFF; else s.av=false; break; //! Заменить на регистр
      case c_or_r:        if(optimizationOff==0 && o->reg==0) {
                            // Удаление OR A
                            if(returnFlagsOfA(o[-1])) { o1->disabled = true; break; } // Убираем лишний OR_A
                            // Удаление середины из DEC R/INC R + LD A, R + OR A + JP CCC
                            if(o[-1].o==c_ld_r_r && o[-1].reg==0 && o[-1].reg2==o[-2].reg && (o[-2].o==c_dec_r || o[-2].o==c_inc_r) && (o[1].o==c_jp_z || o[1].o==c_jp_nz || o[1].o==c_jp_z_loop || o[1].o==c_jp_nz_loop || o[1].o==c_jp_z_forw || o[1].o==c_jp_nz_forw)) { o1->disabled = true; o1[-1].disabled = true; }
                          }
                          s.anv = false; 
                          s.a |= s.r[o->reg]; s.av = s.av && s.v[o->reg]; break;

      case c_and_HL:      s.anv = false; s.av = false; break; //! Заменить на регистр
      case c_and_r:       if(o->reg==0) break; // and a ничего не делает
                          s.anv = false; s.a &= s.r[o->reg2]; s.av = s.av && s.v[o->reg]; break;
      case c_and:         s.anv = false;
                          if(o->m==1) s.a &= o->i&0xFF; else s.av=false;
                          // Объединение двух подряд идущих ANI
                          if(optimizationOff==0 && o[-1].o==c_and) { 
                            if(o->m==1 && o[-1].m==1) o1[-1].i &= o->i;
                                                 else o1[-1].s = "("+o1[-1].get()+")&("+o1->get()+")";
                            o1->disabled = true;
                          } 
                          break;  //! Заменить на регистр
      case c_xor_r:       s.anv=false;
                          if(o->reg==0) { s.a = 0; s.av = true; break; }
                          s.a ^= s.r[o->reg2]; s.av = s.av && s.v[o->reg]; break;
      case c_xor_HL:      s.anv=false; s.av = false; break;
      case c_xor:         s.anv=false; if(o->m==1) s.a ^= o->i&0xFF; else s.av=false; break;

      case c_add_r:       s.anv=false;
                          s.a = (s.a + s.r[o->reg]) & 0xFF; s.av = s.av && s.v[o->reg]; break;
      case c_add_HL:      s.anv=false; s.av = false; break;
      case c_add:         s.anv=false; if(o->m==1) s.a = (s.a + o->i) & 0xFF; else s.av=false; break;

      case c_sub_r:       s.anv = false; // Константа
                          if(o->reg==0) { s.a = 0; s.av = true; break; } // Значение SUB A всегда известно
                          s.a = (s.a - s.r[o->reg]) & 0xFF; s.av = s.av && s.v[o->reg];
                          break;
      case c_sub_HL:      s.anv = false; // Константа
                          s.av = false;
                          break;
      case c_sub:         s.anv=false; // Константа
                          if(o->m==1) s.a = (s.a - o->i) & 0xFF; 
                                 else s.av = false; 
                          break;

      case c_adc_r:       s.av = false; s.anv=false; break; // Мы не рассчитываем флаг C
      case c_adc_HL:      s.av = false; s.anv=false; break; // Мы не рассчитываем флаг C
      case c_adc:         s.av = false; s.anv=false; break; // Мы не рассчитываем флаг C
      case c_sbc_r:       s.av = false; s.anv=false; break; // Мы не рассчитываем флаг C
      case c_sbc_HL:      s.av = false; s.anv=false; break; // Мы не рассчитываем флаг C
      case c_sbc:         s.av = false; s.anv=false; break; // Мы не рассчитываем флаг C

      case c_cp_r:        break;
      case c_cp_HL:       break;
      case c_cp:          break;


      // Нам треубется только флаг Z

      case c_cpz_r:       break;
      case c_cpz_HL:      break;
      case c_cpz:         // Замена CP 0 на OR A
                          if(optimizationOff==0 && o->m==1 && o->i==0) 
                            { o1->o = c_or_r; o1->reg=0; goto retry; } 
                          break;

      case c_clcf:        break;
      case c_cpl:         s.anv=false; s.a ^= 0xFF; break;
      case c_rra:         s.anv=false;
                          // Замена RRA+RRA+AND+ADD A+ADD A на AND
                          if(optimizationOff==0 && o[1].o==c_rra && o[2].o==c_and && o[2].i==63 && o[3].o==c_add_r && o[3].reg==0 && o[4].o==c_add_r && o[4].reg==0) {
                            o1[0].disabled = true;
                            o1[1].disabled = true;
                            o1[2].i <<= 2;
                            o1[3].disabled = true;
                            o1[4].disabled = true;
                          }
                          s.a = false; s.av=false; break;
      case c_push_af:     break; //! Рассчитать стек
      case c_push_bc:     break; //! Рассчитать стек
      case c_push_hl:     break; //! Рассчитать стек
      case c_pop_af:      s.av = false; s.anv = false; break;
      case c_pop_bc:      s.bv = false; s.cv = false; s.bnv=false; s.cnv=false; break;
      case c_pop_hl:      s.hv = false; s.lv = false; s.hnv=false; s.lnv=false; s.hlav=false; s.hlnv=false; break;
      case c_pop_de:      s.dv = false; s.ev = false; s.dnv=false; s.env=false; break;
      case c_dec_bc:      s.c = (s.c-1)&0xFF; if(s.c==0xFF) s.b = (s.b-1)&0xFF; break;
      case c_inc_bc:      s.c = (s.c+1)&0xFF; if(s.c==0   ) s.b = (s.b+1)&0xFF; break;
      case c_dec_hl:      s.hlai--; s.hlnv=false; s.h = (s.h-1)&0xFF; if(s.h==0xFF) s.l = (s.l-1)&0xFF; break;
      case c_inc_hl:      s.hlai++; s.hlnv=false; s.h = (s.h+1)&0xFF; if(s.h==0   ) s.l = (s.l+1)&0xFF; break;
      case c_inc_sp:      break;
      case c_dec_sp:      break;

      case c_ld_de:       if(o->m==1) s.e=(o->i&0xFF), s.d=((o->i>>8)&0xFF), s.ev=true, s.dv=true; 
                                 else s.ev=false, s.dv=false; break;

      case c_ld_hl:       if(o->m==1) { // Константа
                            s.hlnv = s.hlav = false;
                            if(optimizationOff==0) {
                              bool la = (s.lv && s.l==(o->i&0xFF));
                              bool ha = (s.hv && s.h==((o->i>>8)&0xFF));
                              // Удаление LXI H
                              if(la && ha) { o1->disabled = true; break; }
                              // Замена LXI H на LDI H
                              if(la) { o1->o = c_ld_r, o1->reg=5, o1->i = o->i>>8; goto retry; } // h
                              // Замена LXI H на LDI L
                              if(ha) { o1->o = c_ld_r, o1->reg=6, o1->i = o->i&0xFF; goto retry; } // l
                            }
                            s.l=(o->i&0xFF), s.h=((o->i>>8)&0xFF), s.lv=true, s.hv=true;
                          } else { // Адрес переменной
                            s.lv=false, s.hv=false; 
                            s.hlnv = false;
                            if(optimizationOff==0 && s.hlav && s.hla==o1->get()) {
                              // Удаление LXI H
                              if(s.hlai==0) o1->disabled = true; else
                              // Замена LXI H на DCX H
                              if(s.hlai==1) o1->o = c_dec_hl; else
                              // Замена LXI H на INX H
                              if(s.hlai==-1) o1->o = c_inc_hl;
                            }
                            s.hla=o->get(), s.hlai=0, s.hlav=true; 
                          }
                          break;

      case c_ld_bc:       if(o->m==1) s.c=(o->i&0xFF), s.b=((o->i>>8)&0xFF), s.cv=true, s.bv=true; 
                                 else s.cv=false, s.bv=false;    break;
      case c_ld_ref_hl:   if(o->m==2) s.hlnv=true, s.hln=o->s, s.hlni=0; break;
      case c_ld_hl_ref:   s.hv=false; s.lv=false; 
                          if(o->m==2) { 
                            // Замена LHLD + MVI H, 0 на MOV H, A + MVI H, 0
                            if(optimizationOff==0 && s.anv && s.an()==o->s && o[1].o==c_ld_r && o[1].reg==5 && o[1].m==1 && o[1].i==0) 
                              { o1->o = c_ld_r_r; o1->reg=6; o1->reg2=0; i++; break; }
                            // Удаление LHLD
                            if(optimizationOff==0 && s.hlnv && s.hln==o->s && s.hlni==0) { o1->disabled = true; break; }
                            s.hlnv=true; s.hln=o->s; s.hlni=0; 
                          } else {
                            s.hlnv=false;
                          }
                          break;
      case c_add_hl_bc:   s.hv=false; s.lv=false; s.hlnv=s.hlav=false; 
                          //! Оптимизировать LD HL, N + LD DE, X + ADD HL, DE + LD HL, N + LD DE, Y + ADD HL, DE на LD HL, N + LD DE, X + ADD HL, DE + LD DE, Y-X + ADD HL, DE
                          break;
      case c_add_hl_de:   s.hv=false; s.lv=false; s.hlnv=s.hlav=false;
                          //! Оптимизировать LD HL, N + LD DE, X + ADD HL, DE + LD HL, N + LD DE, Y + ADD HL, DE на LD HL, N + LD DE, X + ADD HL, DE + LD DE, Y-X + ADD HL, DE
                          break;
      case c_add_hl_hl:   s.hv=false; s.lv=false; s.hlnv=s.hlav=false;
                          //! Оптимизировать LD HL, N + LD DE, X + ADD HL, DE + LD HL, N + LD DE, Y + ADD HL, DE на LD HL, N + LD DE, X + ADD HL, DE + LD DE, Y-X + ADD HL, DE
                          break;

      case c_ex_hl_de:    if(optimizationOff==0) {
                            if(o[1].o==c_ex_hl_de) { o1[1].disabled=true; o1->disabled = true; break; }
                            if(o[1].o==c_add_hl_de || o[1].o==c_add_hl_bc || o[1].o==c_add_hl_hl) { o1->disabled=true; break; } //! Такого быть не должно. Но оптимизируем на всякий случай
                          }
                          std::swap(s.h,s.d); std::swap(s.l,s.e); std::swap(s.hv,s.dv); std::swap(s.lv,s.ev); // Меняем константы местами
                          s.hlnv = s.hlav = false;
//                          std::swap(s.hln,s.den); std::swap(s.hlnv,s.denv); std::swap(s.hliv,s.deiv); // Меняем значения переменных местами
//                          std::swap(s.hla,s.dea); std::swap(s.hlav,s.deav); std::swap(s.hlav,s.deav); // Меняем значения переменных местами
                          break;

      //*** Оптимизация CALL, RET, JP ***

      case c_jp_loop: break;
      case c_jp_c_loop: break;
      case c_jp_nc_loop: break;
      case c_jp_z_loop: break;
      case c_jp_nz_loop: break; // При удалении надо убрать метку

      case c_retPopBC:    if(optimizationOff==0 && o[1].o==c_retPopBC) o1->disabled=true; break;

                          // Удаление бесполезных переходов
                          // Замена JC + CALL на CALL NC

      case c_jp_c_forw:   if(optimizationOff==0) {
                            if(o[1].o==c_label_forw && o->i==o[1].i) { o1->disabled=true, o1[1].disabled=true; break; }
                            if(o[1].o==c_call  && o[2].o==c_label_forw && o->i==o[2].i) { o1->disabled=true; o1[1].o = c_call_nc; o1[2].disabled=true; break; }
                            if(o[1].o==c_jp    && o[2].o==c_label_forw && o->i==o[2].i) { o1->disabled=true; o1[1].o = c_jp_nc; o1[2].disabled=true; break; } 
                          }
                          // ret
                          break;

      case c_jp_c:        if(optimizationOff==0) {
                            if(o[1].o==c_label && o->i==o[1].i) o1->disabled=true;
                            if(o[1].o==c_call  && o[2].o==c_label && o->i==o[2].i) { o1->disabled=true; o1[1].o = c_call_nc; }
                            if(o[1].o==c_jp    && o[2].o==c_label && o->i==o[2].i) { o1->disabled=true; o1[1].o = c_jp_nc; } 
//                          if(o[1].o==c_ret   && o[2].o==c_label && o->i==o[2].i) { o->disabled=true; o[1].o = c_ret_nc; } 
                          }
                          break;

      case c_jp_nc_forw:  if(optimizationOff==0) {
                            if(o[1].o==c_label_forw && o->i==o[1].i) { o1->disabled=true, o1[1].disabled=true; break; }
                            if(o[1].o==c_call  && o[2].o==c_label_forw && o->i==o[2].i) { o1->disabled=true; o1[1].o = c_call_c; o1[2].disabled=true; break; }
                            if(o[1].o==c_jp    && o[2].o==c_label_forw && o->i==o[2].i) { o1->disabled=true; o1[1].o = c_jp_c; o1[2].disabled=true; break; } 
                          // ret
                          }
                          break;
      case c_jp_nc:       if(optimizationOff==0) {
                            if(o[1].o==c_label && o->i==o[1].i) o1->disabled=true;
                            if(o[1].o==c_call  && o[2].o==c_label && o->i==o[2].i) { o1->disabled=true; o1[1].o = c_call_c; }
                            if(o[1].o==c_jp    && o[2].o==c_label && o->i==o[2].i) { o1->disabled=true; o1[1].o = c_jp_c; } 
//                          if(o[1].o==c_ret   && o[2].o==c_label && o->i==o[2].i) { o->disabled=true; o[1].o = c_ret_c; } 
                          }
                          break;

      case c_jp_z_forw:   if(optimizationOff==0) {
                            if(o[1].o==c_label_forw && o->i==o[1].i) { o1->disabled=true, o1[1].disabled=true; break; }
                            if(o[1].o==c_call  && o[2].o==c_label_forw && o->i==o[2].i) { o1->disabled=true; o1[1].o = c_call_nz; o1[2].disabled=true; break; }
                            if(o[1].o==c_jp    && o[2].o==c_label_forw && o->i==o[2].i) { o1->disabled=true; o1[1].o = c_jp_nz; o1[2].disabled=true; break; } 
                          // ret
                          }
                          break;

      case c_jp_z:        if(optimizationOff==0) {
                            if(o[1].o==c_label && o->i==o[1].i) o1->disabled=true;
                            if(o[1].o==c_call  && o[2].o==c_label && o->i==o[2].i) { o1->disabled=true; o1[1].o = c_call_nz; }
                            if(o[1].o==c_jp    && o[2].o==c_label && o->i==o[2].i) { o1->disabled=true; o1[1].o = c_jp_nz; } 
//                          if(o[1].o==c_ret   && o[2].o==c_label && o->i==o[2].i) { o->disabled=true; o[1].o = c_ret_z; } 
                          }
                          break;

      case c_jp_nz_forw:  if(optimizationOff==0) {
                            if(o[1].o==c_label_forw && o->i==o[1].i) { o1->disabled=true, o1[1].disabled=true; break; }
                            if(o[1].o==c_call  && o[2].o==c_label_forw && o->i==o[2].i) { o1->disabled=true; o1[1].o = c_call_z; o1[2].disabled=true; break; }
                            if(o[1].o==c_jp    && o[2].o==c_label_forw && o->i==o[2].i) { o1->disabled=true; o1[1].o = c_jp_z; o1[2].disabled=true; break; } 
                          // ret
                          }
                          break;

      case c_jp_nz:       if(optimizationOff==0) {
                            if(o[1].o==c_label && o->i==o[1].i) o1->disabled=true;
                            if(o[1].o==c_call  && o[2].o==c_label && o->i==o[2].i) { o1->disabled=true; o1[1].o = c_call_z; }
                            if(o[1].o==c_jp    && o[2].o==c_label && o->i==o[2].i) { o1->disabled=true; o1[1].o = c_jp_z; } 
//                          if(o[1].o==c_ret   && o[2].o==c_label && o->i==o[2].i) { o->disabled=true; o[1].o = c_ret_z; } 
                          }
                          break;
      case c_jp_forw:
      case c_jp:          if(optimizationOff==0 && o[1].o==c_label && o->i==o[1].i) o1->disabled=true; 
                          break;

      //*** Комманды сбрасывающие состояние ***

      case c_labelProc: s.reset(); break;

      case c_call:        s.reset();
                          // Замена CALL + RET на JMP
                          if(optimizationOff==0 && o[1].o==c_retPopBC && o[1].i==0) {
                            o1->o = c_jp_long;
                            o1[1].disabled = true;
                          }
                          break;

      case c_asm:
      case c_jp_long:
      case c_label:
      case c_call_z:
      case c_call_nz:
      case c_call_c:
      case c_call_nc:     s.reset(); break;

      // *** Переход вперед ***
      case c_label_forw:  s.combine(forwardState.back()); erasei(forwardState, forwardState.size()-1); break;

      // *** Переход назад ***
      case c_label_loop:  { optimizationOff++; State& ss = add(loopState); ss=s; ss.cursor=i; ss.label=o->i; break; }

      default: raise("make "+i2s(o->o));
    }
    if(!o->disabled)
    switch(o->o) {
      //*** Переход вперед ***

      case c_jp_forw: 
      case c_jp_c_forw: 
      case c_jp_nc_forw:
      case c_jp_z_forw:
      case c_jp_nz_forw:  forwardState.push_back(s); break;

      //*** Переход назад ***

      case c_jp_loop: 
      case c_jp_c_loop: 
      case c_jp_nc_loop:
      case c_jp_z_loop: 
      case c_jp_nz_loop:
        if(loopState.size()>0 && loopState.back().label==o->i) { // Первый проход
          i = loopState.back().cursor+1; 
          s.combine(loopState.back()); 
          erasei(loopState, loopState.size()-1);
          optimizationOff--;
          goto retry; 
        } // Во время второго прохода ничего не делаем
        break;

      //*** Ветвление ***

      
    }
  }
  int x = calc();
  //MessageBox(0,(i2s(x)+" "+i2s(x*100/t)).c_str(),"",0);
}

int Writer::calc() {
  int n = 0;
  for(int i=1; i<this->l.size(); i++) {
    Opcode1* o = &this->l[i];
    if(!o->disabled)
    switch(o->o) {
      case c_ld_r_r:      n += 5;  break;
      case c_ld_r_HL:     n += 7;  break;
      case c_ld_bc_hl: case c_ld_hl_bc:               n += 10; break;
      case c_ld_HL_r:                                 n += 7;  break;
      case c_ld_a_flags: case c_ld_r:                 n += 7;  break;
      case c_ld_HL:                                   n += 10;  break;
      case c_ld_BC_a:     n += 7;  break; 
      case c_ld_a_DE:
      case c_ld_a_BC:     n += 7;  break;
      case c_ld_a_ref:    n += 13; break;
      case c_ld_ref_a:    n += 13; break;
      case c_dec_HL:      n += 10; break; 
      case c_inc_HL:      n += 10; break; 
      case c_inc_r:       n += 5; break; 
      case c_dec_r:       n += 5; break;
      case c_or_r:        n += 4; break;
      case c_or_HL:       n += 7; break;
      case c_or:          n += 7; break;
      case c_and_r:       n += 4; break;
      case c_and_HL:      n += 7; break;
      case c_and:         n += 7; break;
      case c_xor_r:       n += 4; break;
      case c_xor_HL:      n += 7; break;
      case c_xor:         n += 7; break;
      case c_add_r:       n += 4; break;
      case c_add_HL:      n += 7; break;
      case c_add:         n += 7; break;
      case c_adc_r:       n += 4; break;
      case c_adc_HL:      n += 7; break;
      case c_adc:         n += 7; break;
      case c_sub_r:       n += 4; break;
      case c_sub_HL:      n += 7; break;
      case c_sub:         n += 7; break;
      case c_sbc_r:       n += 4; break;
      case c_sbc_HL:      n += 7; break;
      case c_sbc:         n += 7; break;
      case c_cp_r:        n += 4; break;
      case c_cp_HL:       n += 7; break;
      case c_cp:          n += 7; break;
      case c_cpz_r:       n += 4; break;
      case c_cpz_HL:      n += 7; break;
      case c_cpz:         n += 7; break;
      case c_clcf:        n += 4; break;
      case c_cpl:         n += 4; break;
      case c_rra:         n += 4; break;
      case c_push_af:     
      case c_push_bc:     
      case c_push_hl:     n += 11; break;
      case c_pop_af:      
      case c_pop_bc:      
      case c_pop_hl:      
      case c_pop_de:      n += 10; break;
      case c_dec_bc: case c_inc_bc: case c_dec_hl: case c_inc_hl: case c_inc_sp: case c_dec_sp: n += 5; break;
      case c_ld_de: case c_ld_hl: case c_ld_bc: n += 10; break;
      case c_ld_ref_hl:   n += 16; break;
      case c_ld_hl_ref:   n += 16; break;
      case c_add_hl_bc:   
      case c_add_hl_de:   
      case c_add_hl_hl:   n += 10; break;
      case c_ex_hl_de:    n += 4; break;
      case c_jp_c_loop:   case c_jp_c_forw:   case c_jp_c:        n += 10; break;
      case c_jp_nc_loop:  case c_jp_nc_forw:  case c_jp_nc:       n += 10; break;
      case c_jp_z_loop:   case c_jp_z_forw:   case c_jp_z:        n += 10; break;
      case c_jp_nz_loop:  case c_jp_nz_forw:  case c_jp_nz:       n += 10; break;
      case c_jp_long:
      case c_jp_loop:     case c_jp_forw:     case c_jp:          n += 10; break;
      case c_asm:         n += 0; break;
      case c_labelProc:   n += 0; break;
      case c_label_loop:  case c_label_forw:  case c_label:       n += 0; break;
      case c_call:        n += 17; break;
      case c_call_z:      n += 17; break; // 1
      case c_call_nz:     n += 17; break; // 1
      case c_call_c:      n += 17; break; // 1
      case c_call_nc:     n += 17; break; // 1
      case c_retPopBC:    n += 10; if(o->i) n += 10; break;
      //case c_ret_z:       n += 11; break; // 5
      //case c_ret_nz:      n += 11; break; // 5
      //case c_ret_c:       n += 11; break; // 5
      //case c_ret_nc:      n += 11; break; // 5
      default: raise("make "+i2s(o->o));
    }
  }

  return n;
}
