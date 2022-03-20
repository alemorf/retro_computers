#include <stdafx.h>
#include "b.h"

bool loadInA(NodeVariable* var) {  
  if(var == s.a.in) {
    assert(s.a.delta==0);
    return false;
  }

  //! Сначала сохраняем нашу переменную
  if(var == s.hl.in) saveRegHLAndUsed();
  
  // Затем освобождаем A
  saveRegAAndUsed();

  // Закрепляем регистр за переменной  
  s.a.in= var;
  s.a.const_ = false;
  s.a.changed = false;
  return true;
}

void loadInAreal(NodeVariable* var) {
  if(loadInA(var)) {
    if(var->reg) out.mov(Assembler::A, toAsmReg8(var->reg)); //! Можно загружать не в A, а в B,C,D,E,H,L
            else out.lda(var->name.c_str());//! Можно загружать не в A, а в B,C,D,E,H,L
  }
  s.a.used = true;
}

bool loadInHL(NodeVariable* var) {
  if(s.hl.in == var) { 
    // тут s.hl.tmp == 0;   
    normalizeDeltaHL();
    return false; 
  }  
  // Сначала сохраняем наш регистр
  if(var == s.a.in) saveRegs(regA);
  if(var == s.de.in) saveRegs(regDE);
  // Затем освобождаем HL
  saveRegHLAndUsed();
  // Закрепляем регистр за переменной
  s.hl.in = var;
  s.hl.tmp = 0;
  s.hl.delta = 0;
  s.hl.changed = false;  
  s.hl.const_ = false;
  return true;
}

void loadInHLreal(NodeVariable* var) {
  if(loadInHL(var)) {
    if(var->reg) {
      if(var->reg != regBC) 
        throw Exception("compileDeaddr bc");
      out.mov(Assembler::H, Assembler::B).mov(Assembler::L, Assembler::C);
    } else {
      out.lhld(var->name.c_str()); 
    }
  }
  s.hl.used = true;
}

bool loadInDE(NodeVariable* var) {
  if(s.de.in == var) {
    normalizeDeltaDE();
    return false; 
  }  
  // Сначала сохраняем нашу переменную, если она лежит в других регистрах.  //! А может просто её XCHG минуя память???
  if(var == s.a.in  ) saveRegAAndUsed();
  if(var == s.hl.in ) saveRegHLAndUsed();
  // Затем освобождаем DE
  saveRegDEAndUsed();
  // Закрепляем регистр за переменной
  s.de.in = var;
  s.de.delta = 0;
  s.de.changed = false;  
  s.de.const_ = false;
  return true;
}
