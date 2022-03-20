#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileSaveA(NodeVar* b, bool noResult, const std::function<bool(bool,int)>& result) {
  // Используется в ++, --
  if(b->nodeType==ntConstI) {
    out.sta(b->cast<NodeConst>()->value);
    return result(false, regA);
  }

  if(b->nodeType==ntConstS && b->cast<NodeConst>()->var->reg==regBC) {
    out.stax(Assembler::BC);
    return result(false, regA);
  }

  // Надо узнать, использует ли скомпилированный код эти регистры
  bool old_a_used  = s.a.used;  s.a.used = false;
  bool old_de_used = s.de.used; s.de.used = false;
     
  // Заранее сохраняем А
  int poly = out.size(); out.push(Assembler::PSW);
       
  // Компилируем адрес в HL
  return compileVar(b, regHL, [&](int){
    // А не было изменено, сохранение не нужно
    if(!s.a.used) {
      ChangeCode cc(poly, -TIMINGS_PUSH, Assembler::cNop);
      out.mov(Assembler::M, Assembler::A);              
      s.a.used  = true;
      s.de.used = old_de_used;
      return result(false, regA);
    }
    // А было изменено, но свободно D, сохраняем туда
    if(!s.de.used) {
      auto reg = Assembler::D; //@ Сохранить кстати можем в любой регистр
      ChangeCode cc(poly, TIMINGS_MOV_D_A-TIMINGS_PUSH, Assembler::cMOV, reg, Assembler::A); 
      out.mov(Assembler::M, reg);
      s.a.used  = true;
      s.de.used = true;
      if(noResult) return result(false, 0);
      out.mov(Assembler::A, reg);
      return result(false, regA);
    }
    // В стек
    //! А почему не в A!!!!
    out.pop(Assembler::PSW).mov(Assembler::M, Assembler::A); //@ Вытащить кстати можем в любой регистр        
    s.a.used  = true;
    s.de.used = old_de_used;
    return result(false, regA);
  });
}

//-----------------------------------------------------------------------------
// Скомпилировать код сохранения регистра HL по адресу

bool compileSaveHL(NodeVar* b, bool noResult, const std::function<bool(bool,int)>& result) {
  
  //! Поддержка STAX B !!!

  // Используется в ++, --
  if(b->nodeType==ntConstI) {
    out.shld(b->cast<NodeConst>()->value);
    return result(false, regHL);
  }
  // Далее может быть XCHG, поэтому надо сохранить регистр.
  saveRegs(regHL);
  // Заранее сохраняем HL
  int poly3 = out.size(); out.push(Assembler::HL);
  // Надо надо узнать, использует ли скомпилированный код регистры HL и DE?
  bool old_deUsed = s.de.used; s.de.used = false;
  bool old_hlUsed = s.hl.used; s.hl.used = false;
  // Компилируем адрес в HL
  return compileVar(b, regHL, [&](int inReg) { 
    if(!s.de.used) {
      ChangeCode cc(poly3, TIMINGS_XCHG-TIMINGS_PUSH, Assembler::cXCHG); // DE не используется, сохраняем адрес там
      out.mov(Assembler::M, Assembler::E).inx(Assembler::HL).mov(Assembler::M, Assembler::D); s.hl.delta++;
      s.de.used = true;
      s.hl.used = true;
      if(noResult) return result(false, 0);
      // Сейчас результат в DE. Переносим его в DE
      saveRegHLAndUsed();
      saveRegDEAndUsed();
      out.xchg();
      return result(false, regHL);
    }
    out.pop(Assembler::DE);
    out.mov(Assembler::M, Assembler::E).inx(Assembler::HL).mov(Assembler::M, Assembler::D); s.hl.delta++;        
    s.de.used = true;
    s.hl.used = true;
    if(noResult) return result(false, 0);
    // Сейчас результат в DE. Переносим его в DE
    saveRegHLAndUsed();
    saveRegDEAndUsed();
    out.xchg();
    return result(false, regHL);
  });
}
