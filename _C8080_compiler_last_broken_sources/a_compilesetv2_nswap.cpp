#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileSetV2_nswap(NodeVar* a, NodeVar* b, NodeOperator* no, const std::function<bool(bool,int)>& result) {
  assert(a->dataType.is16());

  // Компилируем адрес HL (не в A!) или значение в HL или А
  return compileVar(a, regHL, [&](int){
    // Далее может быть XCHG, поэтому надо сохранить регистр.
    saveRegs(regHL);
    // Заранее сохраняем HL
    int poly2 = out.size(); out.push(Assembler::HL);
    // Надо надо узнать, использует ли скомпилированный код эти регистры
    bool old_hlUsed = s.hl.used; s.hl.used = false;
    bool old_deUsed = s.de.used; s.de.used = false;
    // 8 битное значение
    if(b->dataType.is8()) {
      return compileVar(b, regA, [&](int){
        if(!s.hl.used) {
          ChangeCode cc(poly2, -TIMINGS_PUSH, Assembler::cNop); // И перемещать его в DE
          out.mov(Assembler::M, Assembler::A);
          s.a.used  = true;
          s.hl.used = old_hlUsed;
          s.de.used = old_deUsed;
          return result(false, regA);
        }
        if(!s.de.used) {
          ChangeCode cc(poly2, TIMINGS_XCHG-TIMINGS_PUSH, Assembler::cXCHG); // DE не используется, сохраняем адрес там
          out.stax(Assembler::DE);
          s.a.used  = true;
          s.hl.used = old_hlUsed;
          s.de.used = true;
          return result(false, regA);          
        }
        out.pop(Assembler::DE).stax(Assembler::DE); //@ А можно еще pop hl + mov m, a. 
        s.a.used  = true;
        s.hl.used = old_hlUsed;
        s.de.used = true;
        return result(false, regA);        
      });
    }    
    // 16 битное значение.
    if(b->dataType.is16()) {
      return compileVar(b, regA|regHL, [&](int inReg) { 
        if(inReg==regA) {
          if(!s.hl.used) {
            ChangeCode cc(poly2, -TIMINGS_PUSH, Assembler::cNop); // HL не используется, сохраняем адрес там
            out.mov(Assembler::M, Assembler::A).inx(Assembler::HL).mvi(Assembler::M, 0); s.hl.delta++;
            s.hl.used = old_hlUsed;
            s.de.used = old_deUsed;
            if(no->o==oSetVoid) return result(false, 0);
            throw;
          }
          if(!s.de.used) {
            ChangeCode cc(poly2, TIMINGS_XCHG-TIMINGS_PUSH, Assembler::cXCHG); // DE не используется, сохраняем адрес там
            out.stax(Assembler::DE);
            s.hl.used = old_hlUsed;
            s.de.used = true;
            if(no->o==oSetVoid) return result(false, 0);
            throw;
          }
          //@ Тут можно еще в HL восстановиться
          out.pop(Assembler::DE).stax(Assembler::DE);
          s.hl.used = old_hlUsed;
          s.de.used = true;
          if(no->o==oSetVoid) return result(false, 0);
          throw;
        } 
        assert(inReg==regHL);
        // Проверять !s.hl.used нет смысла
        if(!s.de.used) {
          ChangeCode cc(poly2, TIMINGS_XCHG-TIMINGS_PUSH, Assembler::cXCHG); // DE не используется, сохраняем адрес там
          saveRegs(regHL);
          out.xchg();
          out.mov(Assembler::M, Assembler::E).inx(Assembler::HL).mov(Assembler::M, Assembler::D); s.hl.delta++;
          //@ Тут можно восстановить HL добавить XCHG
          s.hl.used = true;
          s.de.used = true;
          if(no->o==oSetVoid) return result(false, 0);
          throw;
        }
        saveRegs(regHL);
        out.pop(Assembler::DE).xchg();
        out.mov(Assembler::M, Assembler::E).inx(Assembler::HL).mov(Assembler::M, Assembler::D); s.hl.delta++;
        //@ Тут можно восстановить HL
        if(no->o==oSetVoid) return result(false, 0);
        out.xchg();
        return result(false, regHL); //! Вернуть в DE
      });
    }
    throw;
  });
}
