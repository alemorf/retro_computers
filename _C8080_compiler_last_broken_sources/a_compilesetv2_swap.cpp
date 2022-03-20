#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileSetV2_swap(NodeVar* a, NodeVar* b, NodeOperator* no, const std::function<bool(bool,int)>& result) {
  assert(b->dataType.is16());

  if(a->dataType.is8()) {
    // Компилируем значение в A
    return compileVar(a, regA, [&](int inReg){
      return compileSaveA(b, no->o==oSetVoid, result);
    });
  }

  if(a->dataType.is16()) {
    // Компилируем значение в A или HL
    return compileVar(a, regHL|regA, [&](int inReg){      
      // Значение лежит в A
      if(inReg == regA) {
        // Заранее сохраняем HL
        int poly3 = out.size(); out.push(Assembler::PSW);
        // Надо надо узнать, использует ли скомпилированный код регистры А и DE?
        bool old_deUsed = s.de.used; s.de.used = false;
        bool old_aUsed  = s.a.used;  s.a.used = false;
        // Компилируем адрес в HL
        return compileVar(b, regHL, [&](int inReg) { 
          if(!s.a.used) { // Никуда перемещать не надо.
            ChangeCode cc(poly3, -TIMINGS_PUSH, Assembler::cNop);
            out.mov(Assembler::M, Assembler::A).inx(Assembler::HL).mvi(Assembler::M, 0); s.hl.delta++;
            s.de.used = old_deUsed;
            s.a.used = old_aUsed;
            if(no->o==oSetVoid) return result(false, 0);
            throw;
          }
          if(!s.de.used) { // Сохраняем в регистр
            auto reg = Assembler::D; //@ А можно и в другие регистры
            ChangeCode cc(poly3, TIMINGS_MOV_D_A-TIMINGS_PUSH, Assembler::cMOV, reg, Assembler::A); // DE не используется, сохраняем адрес там
            out.mov(Assembler::M, reg).inx(Assembler::HL).mvi(Assembler::M, 0); s.hl.delta++;
            s.de.used = old_deUsed;
            s.a.used = true;
            if(no->o==oSetVoid) return result(false, 0);
            throw;
          }
          //! А можно и в PSW
          out.pop(Assembler::DE);
          out.mov(Assembler::M, Assembler::D).inx(Assembler::HL).mvi(Assembler::M, 0); s.hl.delta++;        
          s.de.used = true;
          s.a.used = (s.a.used || old_aUsed);
          if(no->o==oSetVoid) return result(false, 0);
          throw;
        });
      }
      return compileSaveHL(b, no->o==oSetVoid, result);      
    });
  }

  throw;
}
