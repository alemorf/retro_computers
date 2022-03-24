#include "stdafx.h"
#include "asm.h"
#include "output.h"
#include "src.h"

struct SimpleCommand {
  const char* name;
  int code;
};

struct ImmCommand {
  const char* name;
  int code, max;
};

void asmJmp(int code, int i) {
  i-=writePos+2;
  if(i&1) p.syntaxError("unaligned");
  i/=2;
  if(step2 && (i<-128 || i>127)) p.syntaxError("Слишком большое расстояние");
  write((code<<6) | (i&0xFF));
}

void asmSob(int r, int a) {
  int n = (writePos+2) - a;
  if(n&1) raise("unaligned");
  n/=2;
  if(n<0 || n>63) raise("Слишком большое расстояние");
  write(0077000 | (r<<6) | (n&077));
}

int readReg(int& argSize) {
  const char* regs[] = { "R0","R1","R2","R3","R4","R5","SP","PC","R0b","R1b","R2b","R3b","R4b","R5b","SPb","PCb",0 };
  int n = p.needToken(regs);
  int argSize1 = n>=8 ? 1 : 2;
  if(argSize==0) argSize = argSize1;
  else if(argSize!=argSize1) p.syntaxError  ("byte & word"); 
  return n&7; 
}

int needAddr() {
  if(!readAddr1()) p.syntaxError();
  return p.bufInt;
}

bool readAddr1() {
  int n;
  if(p.tokenText[0]=='R' && (p.tokenText[1]>='0' || p.tokenText[1]<='5')) return false;
  if(p.tokenText[0]=='P' && p.tokenText[1]=='C') return  false;
  if(p.tokenText[0]=='S' && p.tokenText[1]=='P') return  false;
  if(p.ifToken(labels, n)) { p.bufInt=labels[n].addr; return true; }
  if(p.ifToken(ttWord)) { if(step2) p.syntaxError(p.buf); p.bufInt=2; return true; }
  if(p.ifToken(ttString1)) { p.bufInt = p.buf[0]; return true; }
  return p.ifToken(ttInteger);
}

void readArg(Arg& a, int& argSize) {
  a.subip = false;

  int mode, reg;
  bool x = p.ifToken("@");
  bool n = p.ifToken("#");

  if(readAddr1()) { // Вычесть из адреса смещение, если не поствалены @ #
    a.subip = (!x && !n); 
    a.ext = p.bufInt;
    a.needExt1 = true;
    ParserLabel pl = p.label();
    if(!n && p.ifToken("(")) {
      if(p.ifToken(")")) { p.jump(pl); goto xxx; }
      mode = 6;
      reg = readReg(argSize);
      if(!x) a.subip=0;
      p.needToken(")");
    } else {
xxx:
      reg = 7;
      mode = n ? 2 : 6;
    }
    if(x) mode++;
    a.code = (mode<<3) | reg;
    return;
  }
  if(n) p.syntaxError();
  bool d = p.ifToken("-");
  a.needExt1 = false;
  if(!d) {
    if(readAddr1()) {
      a.subip = !x && !n;
      a.needExt1 = true;
      a.ext = p.bufInt;
    }
  }
  bool o = p.ifToken("("); if((x || d || a.needExt1) && !o) p.needToken("(");  
  reg = readReg(argSize);
  if(o) p.needToken(")");
  bool i = false;
  if(o && (!d && !a.needExt1)) i = p.ifToken("+");
  if(x && !d && !i && !a.needExt1) { a.needExt1=true; a.ext=0; }
  mode = !o ? 0 : i ? 2 : d ? 4 : a.needExt1 ? 6 : 1;
  if(x) mode++;
  a.code = (mode<<3) | reg;
}


void parse_asm() {
  int n;

  // Комманды без аргументов
  static SimpleCommand simpleCommands[] = {
    "halt", 0, "wait", 1, "rti", 2, "bpt", 3, "iot", 4, "reset", 5, "rtt", 6, "nop", 0240,
    "clc", 0241, "clv", 0242, "clz", 0244, "cln", 0250, "sec", 0261, "sev", 0262, 
    "sez", 0264, "sen", 0270, "scc", 0277, "ccc", 0257, 0
  };

  if(p.ifToken(simpleCommands, n)) {
    write(simpleCommands[n].code);
    return;
  }

  // Комманды с одним регистром

  static SimpleCommand oneCommands[] = {
    "jmp", 00001, "swab", 00003,
    "clr", 00050, "clrb", 01050, "com",  00051, "comb", 01051, 
    "inc", 00052, "incb", 01052, "dec",  00053, "decb", 01053, 
    "neg", 00054, "negb", 01054, "adc",  00055, "adcb", 01055, 
    "sbc", 00056, "sbcb", 01056, "tst",  00057, "tstb", 01057, 
    "ror", 00060, "rorb", 01060, "rol",  00061, "rolb", 01061, 
    "asr", 00062, "asrb", 01062, "asl",  00063, "aslb", 01063, 
    "sxt", 00067, "mtps", 01064, "mfps", 01067, 0
  };

  if(p.ifToken(oneCommands, n)) {
    Arg a;
    int argSize=0;
    readArg(a, argSize);
    write((oneCommands[n].code<<6)|a.code, a);
    return;
  }

  // Комманды перехода
  
  static SimpleCommand jmpCommands[] = { 
    "br",  00004, "bne",  00010, "beq", 00014, "bge", 00020, "blt", 00024, 
    "bgt", 00030, "ble", 00034, "bpl",  01000, "bmi", 01004, "bhi", 01010, 
    "bvc", 01024, "bhis", 01030, "bcc", 01030, "blo", 01034, "bcs", 01034,
    "blos", 01014, 
    0 
  };

  if(p.ifToken(jmpCommands, n)) {
    int i = needAddr();
    asmJmp(jmpCommands[n].code, i);
    return;
  }

  // Комманды с константой
  
  static ImmCommand immCommands[] = {
    "emt", 0104000, 0377, "trap", 104400, 0377, "mark", 0006400, 077, 0
  };

  if(p.ifToken(immCommands, n)) {
    int i = p.needInteger();
    if(i<0 || i>immCommands[n].max) p.syntaxError();
    write(immCommands[n].code | i);
    return;
  }

  // Комманды с двумя регистрами

  static const char* twoCommands[] = { 
    "", "mov", "cmp", "bit", "bic", "bis", "add", "", "",
    "movb", "cmpb", "bitb", "bicb", "bisb", "sub", 0
  };

  if(p.ifToken(twoCommands, n)) {
    Arg src, dest;
    int argSize=0;
    readArg(src, argSize);
    p.needToken(",");
    readArg(dest, argSize);
    write((n<<12)|(src.code<<6)|dest.code, src, dest);
    return;
  }

  // Остальные команды
  
  static SimpleCommand aCommands[] = {
    "jsr", 004000, "xor", 0074000, 0
  };

  if(p.ifToken(aCommands, n)) {
    int argSize=0;
    int r = readReg(argSize);
    p.needToken(",");
    Arg a;
    readArg(a, argSize);
    write(aCommands[n].code | (r<<6) | a.code, a);
    return;
  }

  if(p.ifToken("sob")) {
    int argSize=2;
    int r = readReg(argSize);
    p.needToken(",");
    int n = (writePos+2) - needAddr();
    if(n&1) p.syntaxError();
    n/=2;
    if(n<0 || n>63) p.syntaxError();
    write(0077000 | (r<<6) | (n&077));
    return;
  }

  if(p.ifToken("rts")) {
    int argSize = 2;
    int r = readReg(argSize);
    write(0000200 | r);
    return;
  }

  p.syntaxError();
}
