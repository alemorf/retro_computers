#include <stdafx.h>
#include "assembler.h"

Assembler out;

void Assembler::reg16(FillBuffer& buf, int i) {
  switch(i) {
    case PSW: buf.str("psw"); break;
    case SP:  buf.str("sp");  break;
    case BC:  buf.str("b");   break;
    case DE:  buf.str("d");   break;
    case HL:  buf.str("h");   break;
    default: assert(0);
  }  
}

void Assembler::reg16_z80(FillBuffer& buf, int i) {
  switch(i) {
    case PSW: buf.str("af"); break;
    case SP:  buf.str("sp"); break;
    case BC:  buf.str("bc"); break;
    case DE:  buf.str("de"); break;
    case HL:  buf.str("hl"); break;
    default: assert(0);
  }  
}

void Assembler::reg8_z80(FillBuffer& buf, int i) {
  switch(i) {
    case A:  buf.str("a"); break;
    case B:  buf.str("b"); break;
    case C:  buf.str("c"); break;
    case D:  buf.str("d"); break;
    case E:  buf.str("e"); break;
    case H:  buf.str("h"); break;
    case L:  buf.str("l"); break;
    case M:  buf.str("(hl)"); break;
    default: assert(0);
  }  
}

void Assembler::reg8(FillBuffer& buf, int i) {
  switch(i) {
    case A:  buf.str("a"); break;
    case B:  buf.str("b"); break;
    case C:  buf.str("c"); break;
    case D:  buf.str("d"); break;
    case E:  buf.str("e"); break;
    case H:  buf.str("h"); break;
    case L:  buf.str("l"); break;
    case M:  buf.str("m"); break;
    default: assert(0);
  }  
}

void Assembler::addr(FillBuffer& buf, Item& i, int ia) {
  if(i.s) buf.str(i.s); else buf.i2s(ia);
}

void Assembler::build(FillBuffer& buf) {
  for(auto i=items.begin(), ie=i+ptr; i!=ie; ++i) {
    switch(i->cmd) {
      case cNop: break;
      case cRET:   buf.str("  ret\r\n");  break;
      case cXCHG:  buf.str("  xchg\r\n"); break;

      case cDcx:   buf.str("  dcx ");  reg16(buf, i->a); buf.str("\r\n"); break;
      case cInx:   buf.str("  inx ");  reg16(buf, i->a); buf.str("\r\n"); break;
      case cPUSH:  buf.str("  push "); reg16(buf, i->a); buf.str("\r\n"); break;
      case cPOP:   buf.str("  pop ");  reg16(buf, i->a); buf.str("\r\n"); break;
      case cSTAX:  buf.str("  stax "); reg16(buf, i->a); buf.str("\r\n"); break;
      case cLDAX:  buf.str("  ldax "); reg16(buf, i->a); buf.str("\r\n"); break;
      case cDAD:   buf.str("  dad ");  reg16(buf, i->a); buf.str("\r\n"); break;

      case cDcr:   buf.str("  dcr "); reg8(buf, i->a); buf.str("\r\n"); break;
      case cInr:   buf.str("  inr "); reg8(buf, i->a); buf.str("\r\n"); break;

      case cLHLD:  buf.str("  lhld "); addr(buf, *i, i->a); buf.str("\r\n"); break;
      case cLDA:   buf.str("  lda ");  addr(buf, *i, i->a); buf.str("\r\n"); break;
      case cSHLD:  buf.str("  shld "); addr(buf, *i, i->a); buf.str("\r\n"); break;
      case cSTA:   buf.str("  sta ");  addr(buf, *i, i->a); buf.str("\r\n"); break;
      case cCALL:  buf.str("  call "); addr(buf, *i, i->a);  buf.str("\r\n"); break;
      case cJMP:   buf.str("  jmp "); addr(buf, *i, i->a);  buf.str("\r\n"); break;
      case cRRC:   buf.str("  rrc\r\n"); break;
      case cCMA:   buf.str("  cma\r\n"); break;
      case cJMPL:  buf.str("  jmp l"); addr(buf, *i, i->a);  buf.str("\r\n"); break;

      case cMOV:   
        // Замена mov a, m + ora a на xra a, ora m
        // Надо будет учесть это в счетчике тактов
        if(i->a==A && i->b==M && (i+1) != ie && (i+1)->cmd==cALU && (i+1)->a==OR && (i+1)->b==A) { buf.str("  xra a\r\n  ora m\r\n"); ++i; break; }
        buf.str("  mov "); reg8(buf, i->a); buf.str(", "); reg8(buf, i->b); buf.str("\r\n"); break;
      case cMVI:   if(i->s) { buf.str("  mvi "); reg8(buf, i->a); buf.str(", (").str(i->s).str(") & 0FFh\r\n"); break; }
                      else { buf.str("  mvi "); reg8(buf, i->a); buf.str(", ").i2s(i->b&0xFF).str("\r\n"); break; }
      case cMVIH:  if(i->s) { buf.str("  mvi "); reg8(buf, i->a); buf.str(", (").str(i->s).str(" >> 8) & 0FFh\r\n"); break; }
                      else { buf.str("  mvi "); reg8(buf, i->a); buf.str(", ").i2s((i->b>>8)&0xFF).str("\r\n"); break; }
      case cMVIN:  buf.str("  mvi "); reg16(buf, i->a); buf.str(", -("); addr(buf, *i, i->b); buf.str(")\r\n"); break;
      case cLABEL1 :buf.str("; label1\r\n");
      case cLABEL2: buf.str("l").i2s(i->a).str(":\r\n"); break;
      case cLXI:   buf.str("  lxi "); reg16(buf, i->a); buf.str(", "); addr(buf, *i, i->b); buf.str("\r\n"); break;
      case cLXIN:  buf.str("  lxi "); reg16(buf, i->a); buf.str(", -("); addr(buf, *i, i->b); buf.str(")\r\n"); break;
      case cREMARK: buf.str(";").str(i->s).str("\r\n"); break;
      case cASMBLOCK: buf.str(i->s).str("\r\n"); break;
      case cSHLDFN:  buf.str("  shld "); buf.str(i->s); buf.str("_"); buf.i2s(i->a); buf.str("\r\n"); break;
      case cSTAFN:   buf.str("  sta ");  buf.str(i->s); buf.str("_"); buf.i2s(i->a); buf.str("\r\n"); break;
      case cALU:
        switch(i->a) {
          case CMP:  buf.str("  cmp "); break;
          case XOR:  buf.str("  xra "); break;
          case OR:   buf.str("  ora "); break;
          case AND:  buf.str("  ana "); break;
          case SUB:  buf.str("  sub "); break;
          case ADD:  buf.str("  add "); break;
          default: assert(0);
        }
        reg8(buf, i->b); buf.str("\r\n");
        break;
      case cALUI:
        switch(i->a) {
          case CMP:  buf.str("  cpi "); break;
          case XOR:  buf.str("  xri "); break;
          case OR:   buf.str("  ori "); break;
          case AND:  buf.str("  ani "); break;
          case SUB:  buf.str("  sui "); break;
          case ADD:  buf.str("  adi "); break;
          default: assert(0);
        }
        addr(buf, *i, i->b); buf.str("\r\n");
        break;
      case cJCC:
        switch(i->a) {
          case JZ:    buf.str("  jz l").i2s(i->b).str("\r\n"); break;
          case JNZ:   buf.str("  jnz l").i2s(i->b).str("\r\n"); break;
          case JC:    buf.str("  jc l").i2s(i->b).str("\r\n"); break;
          case JNC:   buf.str("  jnc l").i2s(i->b).str("\r\n"); break;
          case JZC:   buf.str("  jz l").i2s(i->b).str("\r\n  jc l").i2s(i->b).str("\r\n"); break;
          case JZNC:  buf.str("  jz $+6\r\n  jnc l").i2s(i->b).str("\r\n"); break;
          default: assert(0);
        }
        break;
      case cRETCC:
        switch(i->a) {
          case JZ:    buf.str("  rnz\n"); break;
          case JNZ:   buf.str("  rz\r\n"); break;
          case JC:    buf.str("  rnc\r\n"); break;
          case JNC:   buf.str("  rc\r\n"); break;
          case JZC:   buf.str("  jz $+6\r\n  rnc\r\n"); break;
          case JZNC:  buf.str("  rz\r\n  rc\r\n"); break;
          default: assert(0);
        }
        break;
      default: assert(0);
    }
  }
}

//-----------------------------------------------------------------------------

void Assembler::build_z80(FillBuffer& buf) {
  for(auto i=items.begin(), ie=i+ptr; i!=ie; ++i) {
    switch(i->cmd) {
      case cNop: break;
      case cRET:   buf.str("  ret\r\n");  break;
      case cXCHG:  buf.str("  ex hl, de\r\n"); break;

      case cDcx:   buf.str("  dec ");  reg16_z80(buf, i->a); buf.str("\r\n"); break;
      case cInx:   buf.str("  inc ");  reg16_z80(buf, i->a); buf.str("\r\n"); break;
      case cPUSH:  buf.str("  push "); reg16_z80(buf, i->a); buf.str("\r\n"); break;
      case cPOP:   buf.str("  pop ");  reg16_z80(buf, i->a); buf.str("\r\n"); break;
      case cSTAX:  buf.str("  ld ("); reg16_z80(buf, i->a); buf.str("), a\r\n"); break;
      case cLDAX:  buf.str("  ld a, ("); reg16_z80(buf, i->a); buf.str(")\r\n"); break;
      case cDAD:   buf.str("  add hl, ");  reg16_z80(buf, i->a); buf.str("\r\n"); break;

      case cDcr:   buf.str("  dec "); reg8_z80(buf, i->a); buf.str("\r\n"); break;
      case cInr:   buf.str("  inc "); reg8_z80(buf, i->a); buf.str("\r\n"); break;

      case cLHLD:  buf.str("  ld hl, ("); addr(buf, *i, i->a); buf.str(")\r\n"); break;
      case cLDA:   buf.str("  ld a, (");  addr(buf, *i, i->a); buf.str(")\r\n"); break;
      case cSHLD:  buf.str("  ld ("); addr(buf, *i, i->a); buf.str("), hl\r\n"); break;
      case cSTA:   buf.str("  ld (");  addr(buf, *i, i->a); buf.str("), a\r\n"); break;
      case cCALL:  buf.str("  call "); addr(buf, *i, i->a);  buf.str("\r\n"); break;
      case cJMP:   buf.str("  jp "); addr(buf, *i, i->a);  buf.str("\r\n"); break;
      case cRRC:   buf.str("  rrca\r\n"); break;
      case cCMA:   buf.str("  cpl\r\n"); break;
      case cJMPL:  buf.str("  jp l"); addr(buf, *i, i->a);  buf.str("\r\n"); break;

      case cMOV:   
        // Замена mov a, m + ora a на xra a, ora m
        // Надо будет учесть это в счетчике тактов
        if(i->a==A && i->b==M && (i+1) != ie && (i+1)->cmd==cALU && (i+1)->a==OR && (i+1)->b==A) { buf.str("  xor a\r\n  or a, (hl)\r\n"); ++i; break; }
        buf.str("  ld "); reg8_z80(buf, i->a); buf.str(", "); reg8_z80(buf, i->b); buf.str("\r\n"); break;
      case cMVI:   if(i->s) { buf.str("  ld "); reg8_z80(buf, i->a); buf.str(", (").str(i->s).str(") & 0xFF\r\n"); break; }
                      else { buf.str("  ld "); reg8_z80(buf, i->a); buf.str(", ").i2s(i->b&0xFF).str("\r\n"); break; }
      case cMVIH:  if(i->s) { buf.str("  ld "); reg8_z80(buf, i->a); buf.str(", (").str(i->s).str(" >> 8) & 0xFF\r\n"); break; }
                      else { buf.str("  ld "); reg8_z80(buf, i->a); buf.str(", ").i2s((i->b>>8)&0xFF).str("\r\n"); break; }
      case cMVIN:  buf.str("  ld "); reg16_z80(buf, i->a); buf.str(", -("); addr(buf, *i, i->b); buf.str(")\r\n"); break;
      case cLABEL1 :buf.str("; label1\r\n");
      case cLABEL2: buf.str("l").i2s(i->a).str(":\r\n"); break;
      case cLXI:   buf.str("  ld "); reg16_z80(buf, i->a); buf.str(", "); addr(buf, *i, i->b); buf.str("\r\n"); break;
      case cLXIN:  buf.str("  ld "); reg16_z80(buf, i->a); buf.str(", -("); addr(buf, *i, i->b); buf.str(")\r\n"); break;
      case cREMARK: buf.str(";").str(i->s).str("\r\n"); break;
      case cASMBLOCK: buf.str(i->s).str("\r\n"); break;
      case cSHLDFN:  buf.str("  ld ("); buf.str(i->s); buf.str("_"); buf.i2s(i->a); buf.str("), hl\r\n"); break;
      case cSTAFN:   buf.str("  ld (");  buf.str(i->s); buf.str("_"); buf.i2s(i->a); buf.str("), a\r\n"); break;
      case cALU:
        switch(i->a) {
          case CMP:  buf.str("  cp "); break;
          case XOR:  buf.str("  xor "); break;
          case OR:   buf.str("  or "); break;
          case AND:  buf.str("  and "); break;
          case SUB:  buf.str("  sub "); break;
          case ADD:  buf.str("  add "); break;
          default: assert(0);
        }
        reg8_z80(buf, i->b); buf.str("\r\n");
        break;
      case cALUI:
        switch(i->a) {
          case CMP:  buf.str("  cp "); break;
          case XOR:  buf.str("  xor "); break;
          case OR:   buf.str("  or "); break;
          case AND:  buf.str("  and "); break;
          case SUB:  buf.str("  sub "); break;
          case ADD:  buf.str("  add "); break;

          default: assert(0);
        }
        addr(buf, *i, i->b); buf.str("\r\n");
        break;
      case cJCC:
        switch(i->a) {
          case JZ:    buf.str("  jp z, l").i2s(i->b).str("\r\n"); break;
          case JNZ:   buf.str("  jp nz, l").i2s(i->b).str("\r\n"); break;
          case JC:    buf.str("  jp c, l").i2s(i->b).str("\r\n"); break;
          case JNC:   buf.str("  jp nc, l").i2s(i->b).str("\r\n"); break;
          case JZC:   buf.str("  jp z, l").i2s(i->b).str("\r\n  jp c, l").i2s(i->b).str("\r\n"); break;
          case JZNC:  buf.str("  jp z, $+6\r\n  jp nc, l").i2s(i->b).str("\r\n"); break;
          default: assert(0);
        }
        break;
      case cRETCC:
        switch(i->a) {
          case JZ:    buf.str("  ret nz\n"); break;
          case JNZ:   buf.str("  ret z\r\n"); break;
          case JC:    buf.str("  ret nc\r\n"); break;
          case JNC:   buf.str("  ret c\r\n"); break;
          case JZC:   buf.str("  jp z, $+6\r\n  ret nc\r\n"); break;
          case JZNC:  buf.str("  ret z\r\n  rc\r\n"); break;
          default: assert(0);
        }
        break;
      default: assert(0);
    }
  }
}
