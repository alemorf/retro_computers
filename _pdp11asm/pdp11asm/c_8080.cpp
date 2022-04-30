// 8080 Assembler (c) 8-03-2015 vinxru

#include "stdafx.h"
#include "compiler.h"

enum ArgType { C_NONE, C_R8, C_R16, C_R16PSW, C_I8, C_I16, C_R16I16, C_R8I8, C_R8R8, C_I8X, C_BD };

struct Command {
  const char* name;
  ArgType arg;
  int shl;
  int opcode;
};

bool Compiler::compileLine_8080() {
  static const char* r8[] = { "b", "c", "d", "e", "h", "l", "m", "a", 0 }; // Ñ_R8 C_R8I8
  static const char* r16[] = { "b","d","h","sp",0 }; // C_R16 C_R16I16
  static const char* bd[] = { "b","d",0 }; // C_BD
  static const char* r16psw[] = { "b","d","h","psw",0 }; // C_R16PSW
	
  static Command allCommands[] = {
    { "add",  C_R8,     0, 0x80 },
    { "adi",  C_I8,     0, 0xC6 },
    { "adc",  C_R8,     0, 0x88 },
    { "aci",  C_I8,     0, 0xCE },
    { "ana",  C_R8,     0, 0xA0 },
    { "ani",  C_I8,     0, 0xE6 },
    { "call", C_I16,    0, 0xCD },
    { "cz",   C_I16,    0, 0xCC },
    { "cnz",  C_I16,    0, 0xC4 },
    { "cp",   C_I16,    0, 0xF4 },
    { "cm",   C_I16,    0, 0xFC },
    { "cc",   C_I16,    0, 0xDC },
    { "cnc",  C_I16,    0, 0xD4 },
    { "cpe",  C_I16,    0, 0xEC },
    { "cpo",  C_I16,    0, 0xE4 },
    { "cma",  C_NONE,   0, 0x2F },
    { "cmc",  C_NONE,   0, 0x3F },
    { "cmp",  C_R8,     0, 0xB8 },
    { "cpi",  C_I8,     0, 0xFE },
    { "daa",  C_NONE,   0, 0x27 },
    { "dad",  C_R16,    4, 0x09 },
    { "dcr",  C_R8,     3, 0x05 },
    { "dcx",  C_R16,    4, 0x0B },
    { "di",   C_NONE,   0, 0xF3 },
    { "ei",   C_NONE,   0, 0xFB },
    { "hlt",  C_NONE,   0, 0x76 },
    { "in",   C_I8,     0, 0xDB },
    { "inr",  C_R8,     3, 0x04 },
    { "inx",  C_R16,    4, 0x03 },
    { "jmp",  C_I16,    0, 0xC3 },
    { "jz",   C_I16,    0, 0xCA },
    { "jnz",  C_I16,    0, 0xC2 },
    { "jmp",  C_I16,    0, 0xC3 },
    { "jp",   C_I16,    0, 0xF2 },
    { "jm",   C_I16,    0, 0xFA },
    { "jc",   C_I16,    0, 0xDA },
    { "jnc",  C_I16,    0, 0xD2 },
    { "jpe",  C_I16,    0, 0xEA },
    { "jpo",  C_I16,    0, 0xE2 },
    { "lda",  C_I16,    0, 0x3A },
    { "ldax", C_BD,     4, 0x0A },
    { "lhld", C_I16,    0, 0x2A },
    { "lxi",  C_R16I16, 4, 0x01 },
    { "mov",  C_R8R8,   0, 0x40 },
    { "mvi",  C_R8I8,   3, 0x06 },
    { "nop",  C_NONE,   0, 0x00 },
    { "ora",  C_R8,     0, 0xB0 },
    { "ori",  C_I8,     0, 0xF6 },
    { "out",  C_I8,     0, 0xD3 },
    { "pchl", C_NONE,   0, 0xE9 },
    { "pop",  C_R16PSW, 4, 0xC1 },
    { "push", C_R16PSW, 4, 0xC5 },
    { "ral",  C_NONE,   0, 0x17 },
    { "rar",  C_NONE,   0, 0x1F },
    { "rlc",  C_NONE,   0, 0x07 },
    { "rrc",  C_NONE,   0, 0x0F },
    { "ret",  C_NONE,   0, 0xC9 },
    { "rz",   C_NONE,   0, 0xC8 },
    { "rnz",  C_NONE,   0, 0xC0 },
    { "rp",   C_NONE,   0, 0xF0 },
    { "rm",   C_NONE,   0, 0xF8 },
    { "rc",   C_NONE,   0, 0xD8 },
    { "rnc",  C_NONE,   0, 0xD0 },
    { "rpe",  C_NONE,   0, 0xE8 },
    { "rpo",  C_NONE,   0, 0xE0 },
    { "rst",  C_I8X,    3, 0xC7 },
    { "sphl", C_NONE,   0, 0xF9 },
    { "shld", C_I16,    0, 0x22 },
    { "sta",  C_I16,    0, 0x32 },
    { "stax", C_BD,     4, 0x02 },
    { "stc",  C_NONE,   0, 0x37 },
    { "sub",  C_R8,     0, 0x90 },
    { "sui",  C_I8,     0, 0xD6 },
    { "sbb",  C_R8,     0, 0x98 },
    { "sbi",  C_I8,     0, 0xDE },
    { "xchg", C_NONE,   0, 0xEB },
    { "xthl", C_NONE,   0, 0xE3 },
    { "xra",  C_R8,     0, 0xA8 },
    { "xri",  C_I8,     0, 0xEE },
    0,
  };

  int n, i;
  if(p.ifToken(allCommands, n)) {
    Command& c = allCommands[n];
    unsigned char opcode = c.opcode;
    switch(c.arg) {
      case C_I8X:    i = readConst3(); out.write8(opcode | (i & 0x38)); break;
      case C_R8R8:   opcode |= p.needToken(r8) << 3; p.needToken(",");
      case C_R8:     out.write8(opcode | (p.needToken(r8) << c.shl)); break;
      case C_R16:    out.write8(opcode | (p.needToken(r16) << c.shl)); break;
      case C_R16PSW: out.write8(opcode | (p.needToken(r16psw) << c.shl)); break; 
      case C_R8I8:   opcode |= p.needToken(r8) << c.shl; p.needToken(",");
      case C_I8:     i = readConst3(); out.write8(opcode); out.write8(i); break;
      case C_R16I16: opcode |= p.needToken(r16) << c.shl; p.needToken(",");
      case C_I16:    i = readConst3(); out.write8(opcode); out.write16(i); break;
      case C_BD:     out.write8(opcode | (p.needToken(bd) << c.shl)); break;
      case C_NONE:   out.write8(opcode);
    }      
    return true;
  }

  return false;
}
