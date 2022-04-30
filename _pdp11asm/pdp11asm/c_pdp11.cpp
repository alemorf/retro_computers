// PDP11 Assembler (c) 15-01-2015 vinxru

#include "stdafx.h"
#include "compiler.h"

struct SimpleCommand {
  const char* name;
  short code;
};

struct ImmCommand {
  const char* name;
  int code, max;
};

//-----------------------------------------------------------------------------

inline void Compiler::write(int n, Arg& a) {
  out.write16(n);
  if(a.used) out.write16(a.val - (a.subip ? short(out.writePtr+2) : 0));  
}

//-----------------------------------------------------------------------------

inline void Compiler::write(int n, Arg& a, Arg& b) {
  out.write16(n);
  if(a.used) out.write16(a.val - (a.subip ? short(out.writePtr+2) : 0) );  
  if(b.used) out.write16(b.val - (b.subip ? short(out.writePtr+2) : 0) );  
}

//-----------------------------------------------------------------------------

int Compiler::readReg() {
  const char* regs[] = { "R0","R1","R2","R3","R4","R5","SP","PC",0 };
  return p.needToken(regs);
}

//-----------------------------------------------------------------------------

bool Compiler::regInParser() {
  if(p.token==ttWord && p.tokenText[2]==0) {
    if(p.tokenText[0]=='R' && p.tokenText[1]>='0' && p.tokenText[1]<='5') return true;
    if(p.tokenText[0]=='P' && p.tokenText[1]=='C') return true;
    if(p.tokenText[0]=='S' && p.tokenText[1]=='P') return true;
  }
  return false;
}

//-----------------------------------------------------------------------------

void Compiler::readArg(Arg& a) {
  a.subip = false;

  int mode, reg;
  bool x = p.ifToken("@");
  bool n = p.ifToken("#");

  Parser::num_t ii;
  if(ifConst3(ii)) { // Вычесть из адреса смещение, если не поствалены @ #
	    a.subip = (!x && !n); 
    a.val = short(ii); // Без контроля переполнения
    a.used = true;
    Parser::Label pl(p);
    if(!n && p.ifToken("(")) {
      if(p.ifToken(")")) { p.jump(pl); goto xxx; }
      mode = 6;
      reg = readReg();
      if(!x) a.subip=0;
      p.needToken(")");
    } else {
xxx:
      reg = 7;
      mode = n ? 2 : 6;
    }
    if(x) mode++;
    a.code = short((mode<<3) | reg);
    return;
  }
  if(n) p.syntaxError();
  bool d = p.ifToken("-");
  a.used = false;
  if(!d) {
    Parser::num_t ii;
    if(ifConst3(ii)) {
      a.subip = !x && !n;
      a.used = true;
      a.val = short(ii); // Без контроля переполнения
    }
  }
  bool o = p.ifToken("("); if((x || d || a.used) && !o) p.needToken("(");  
  reg = readReg();
  if(o) p.needToken(")");
  bool i = false;
  if(o && (!d && !a.used)) i = p.ifToken("+");
  if(x && !d && !i && !a.used) { a.used=true; a.val=0; }
  mode = !o ? 0 : i ? 2 : d ? 4 : a.used ? 6 : 1;
  if(x) mode++;
  a.code = short((mode<<3) | reg);
}

//-----------------------------------------------------------------------------

bool Compiler::compileLine_pdp11() {
  // Комманды без аргументов
  static SimpleCommand simpleCommands[] = {
    "halt", 0, "wait", 1, "rti", 2, "bpt", 3, "iot", 4, "reset", 5, "rtt", 6, "nop", 0240,
    "clc", 0241, "clv", 0242, "clz", 0244, "cln", 0250, "sec", 0261, "sev", 0262, 
    "sez", 0264, "sen", 0270, "scc", 0277, "ccc", 0257, "ret", 0207 /*RTS PC*/, 0
  };

  int n;
  if(p.ifToken(simpleCommands, n)) {
    out.write16(simpleCommands[n].code);
    return true;
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
    readArg(a);
    write((oneCommands[n].code<<6)|a.code, a);
    return true;
  }

  // Комманды перехода
  
  static SimpleCommand jmpCommands[] = { 
    "br",  00004, "bne", 00010, "beq", 00014, "bge", 00020, "blt", 00024, 
    "bgt", 00030, "ble", 00034, "bpl", 01000, "bmi", 01004, "bhi", 01010, 
	"bvs", 01020, 
    "bvc", 01024, "bhis", 01030, "bcc", 01030, "blo", 01034, "bcs", 01034,
    "blos", 01014, 
    0 
  };

  if(p.ifToken(jmpCommands, n)) {
    long long i = (long long)readConst3(true); //! Тут полная неразбериха с signed/unsigned, size_t/Parser::num_t
    i -= out.writePtr; i -= 2;
    if(i & 1) p.syntaxError("Unaligned");
    i /= 2;
    if(step2 && (i < -128 || i > 127)) p.syntaxError("Too far jump");
    out.write16((jmpCommands[n].code<<6) | (i & 0xFF));
    return true;
  }

  // Комманды с константой
  
  static ImmCommand immCommands[] = {
    "emt", 0104000, 0377, "trap", 104400, 0377, "mark", 0006400, 077, 0
  };

  if(p.ifToken(immCommands, n)) {
    p.needToken(ttInteger);
    if(p.loadedNum > immCommands[n].max) p.syntaxError();
    out.write16(immCommands[n].code | int(p.loadedNum));
    return true;
  }

  // Комманды с двумя регистрами

  static const char* twoCommands[] = { 
    "", "mov", "cmp", "bit", "bic", "bis", "add", "", "",
    "movb", "cmpb", "bitb", "bicb", "bisb", "sub", 0
  };

  if(p.ifToken(twoCommands, n)) {
    Arg src, dest;
    readArg(src);
    p.needToken(",");
    readArg(dest);
    write((n<<12)|(src.code<<6)|dest.code, src, dest);
    return true;
  }

  // Остальные команды
  
  static SimpleCommand aCommands[] = {
    "jsr", 004000, "xor", 0074000, 0
  };

  if(p.ifToken(aCommands, n)) {
    int r = readReg();
    p.needToken(",");
    Arg a;
    readArg(a);
    write(aCommands[n].code | (r<<6) | a.code, a);
    return true;
  }

  if(p.ifToken("call")) {
    Arg a;
    readArg(a);    
    write(/*JSR*/004000 | (/*PC*/7<<6) | a.code, a);
    return true;
  }

  if(p.ifToken("sob")) {
    int r = readReg();
    p.needToken(",");
    Parser::num_t n = (out.writePtr + 2) - readConst3(true);
    if(n&1) p.syntaxError();
    n/=2;
    if(n>63) p.syntaxError();
    out.write16(0077000 | (r<<6) | (int(n)&077));
    return true;
  }

  if(p.ifToken("rts")) {
    int r = readReg();
    out.write16(0000200 | r);
    return true;
  }

  return false;
}
