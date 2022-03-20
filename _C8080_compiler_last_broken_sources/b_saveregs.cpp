#include <stdafx.h>
#include "b.h"
#include "assembler.h"

State s;

// В HL должно лежать корректное значение.
//   tmp - значит, что значение корректное. Оно не связано с регистром. Но из него можно вычислить регистр.
//   in  - значит, что значение не корректное и оно свзяно с регистром.

void normalizeDeltaHL() {
  if(s.hl.in) {
    for(;s.hl.delta>0; --s.hl.delta) out.dcx(Assembler::HL);
    for(;s.hl.delta<0; ++s.hl.delta) out.inx(Assembler::HL);
  }
}

void saveRegs(int reg, bool dontForgot) {
  if((reg & regHL) != 0) {
    if(s.hl.in && s.hl.changed) {
      normalizeDeltaHL();
      if(s.hl.in->reg) {
        if(s.hl.in->reg != regBC) throw Exception("saveRegs BC");
        out.mov(Assembler::B, Assembler::H).mov(Assembler::C, Assembler::L);
      } else {
        out.shld(s.hl.in->name.c_str());
      }
    }
    s.hl.changed = false;
    if(!dontForgot) {        
      s.hl.in = 0; 
      s.hl.tmp = 0; 
      s.hl.const_ = false;
    }
  }
  if((reg & regA) != 0) {
    if(s.a.in && s.a.changed) {
      if(s.a.in->reg) {
        out.mov(toAsmReg8(s.a.in->reg), Assembler::A);
      } else {
        out.sta(s.a.in->name.c_str());
      }
    }
    s.a.changed = false;
    if(!dontForgot) {
      s.a.in = 0; 
      s.a.tmp = 0; 
      s.a.const_ = false;
    }
  }
  if((reg & regDE) != 0) {
    if(s.de.in && s.de.changed) {
      normalizeDeltaDE();
      if(s.de.in->reg) {
        if(s.de.in->reg != regBC) throw Exception("saveRegs BC");
        out.mov(Assembler::B, Assembler::D).mov(Assembler::C, Assembler::E);
      } else {
        out.shld(s.de.in->name.c_str());
      }
    }
    s.de.changed = false;
    if(!dontForgot) {        
      s.de.in = 0; 
      s.de.tmp = 0; 
      s.de.const_ = false;
    }
  }
}

inline void saveRegA() {
  s.a.const_ = false;
  s.a.tmp = 0;
  if(s.a.in) {
    if(s.a.changed) {
      if(s.a.in->reg) { // Переменная закреплена за регистром
        out.mov(toAsmReg8(s.a.in->reg), Assembler::A);
      } else {
        out.sta(s.a.in->name.c_str());
      }
      s.a.changed = false;
    }
    s.a.in = 0; 
  }
}

inline void saveRegHL() {
  s.hl.const_ = false;
  s.hl.tmp = 0;
  if(s.hl.in) {
    if(s.hl.changed) {
      normalizeDeltaHL();
      if(s.hl.in->reg) {
        if(s.hl.in->reg != regBC) throw Exception("saveRegs BC");
        out.mov(Assembler::B, Assembler::H).mov(Assembler::C, Assembler::L);
      } else {        
        out.shld(s.hl.in->name.c_str());
      }
      s.hl.changed = false;
    }    
    s.hl.in = 0; 
  }
}

void normalizeDeltaDE() {
  if(s.de.in) {
    for(;s.hl.delta>0; --s.hl.delta) out.dcx(Assembler::DE); //! Может быть много
    for(;s.hl.delta<0; ++s.hl.delta) out.inx(Assembler::DE); //! Может быть много
  }
}

inline void saveRegDE() {
  s.de.const_ = false;
  s.de.tmp = false;
  if(s.de.in) {
    if(s.de.changed) {
      normalizeDeltaDE();
      if(s.de.in->reg) {
        if(s.de.in->reg != regBC) throw Exception("saveRegs BC");
        out.mov(Assembler::B, Assembler::D).mov(Assembler::C, Assembler::E);
      } else {
        out.xchg().shld(s.de.in->name.c_str()).xchg(); //! Надо сделать так, что бы Xвторой CHG получался автоматом
      }
      s.de.changed = false;
    }
    s.de.in = 0; 
  }
}

void saveRegAAndUsed() {
  saveRegA();
  s.a.used = true;
}

void saveRegHLAndUsed() {
  saveRegHL();
  s.hl.used = true;
}

void saveRegDEAndUsed() {
  saveRegDE();
  s.de.used = true;
}

void saveGlobalRegs() {
  if(s.a.in && !s.a.in->stack) saveRegAAndUsed();
  if(s.hl.in && !s.hl.in->stack) saveRegHLAndUsed();
  if(s.de.in && !s.de.in->stack) saveRegDEAndUsed();
  s.a.in=0; s.hl.in=0; s.hl.tmp=0;
}

void saveAllRegsAndUsed() {
  saveRegAAndUsed();
  saveRegHLAndUsed();
  saveRegDEAndUsed();
}