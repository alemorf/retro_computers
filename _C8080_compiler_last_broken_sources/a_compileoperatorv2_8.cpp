#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileOperatorV2_8(NodeOperator* o, bool swap, NodeVar* a, NodeVar* b, const std::function<bool(bool, int)>& result) {
  // Регистры B,C можно сравнивать с нулем без участия второго регистра  
  if((o->o==oE || o->o==oNE) && b->nodeType==ntConstI && b->cast<NodeConst>()->value==0) {
    auto reg = a->isRegVar();
    if(s.a.in && s.a.in->reg!=reg) { // Только если переменная не в аккумуляторе!
      if(reg!=regNone) {
        auto r = toAsmReg8(reg);
        if(!zFlagFor8(r)) out.dcr(r).inr(r);
        return result(swap, regNone);
      }
    }
  }     

  return compileVar(a, regA, [&](int inReg){
    // В качестве второго аргумента используется регистр B или C и его можно исползовать как второй аргумент команды.
    auto reg = b->isRegVar();
    if(reg!=regNone && compileOperator2_8_checkAnyReg(o)) {
      return compileOperator2_8(o, !swap, toAsmReg8(reg), result);
    }

    // Если второй аргумент константа, загружаем её непосредственно в регистр D. Или даже выполняем короткую команду.
    // Функция compileOperatorV2_8_const инвертирует SWAP, поэтому туда нельзя!
    if(b->isConst() && !(swap && o->o==oSub)) return compileOperatorV2_8_const(o, swap, b->cast<NodeConst>(), result);

    // Если второй аргумент не константа, узнаем, нужны ли для его расчета регистры A или DE
    s.de.used = false;
    // Заранее сохраняем А или HL
    int poly = out.size(); out.push(Assembler::PSW);
    // Компилируем    
    return compileVar(b, regA, [&](int inReg){
      // Тут оба аргумента одинаковой разрядности      
      if(!s.de.used) { //! Отдельно D и E
        // Если DE не используется, то сохраняем в ней
        ChangeCode cc(poly, TIMINGS_MOV_D_A-TIMINGS_PUSH, Assembler::cMOV, Assembler::D, Assembler::A);
        s.de.used = true;
        return compileOperator2_8(o, swap, Assembler::D, result);
      }
      out.pop(Assembler::DE);
      s.de.used = true;
      return compileOperator2_8(o, swap, Assembler::D, result);
    });      
  });    
}
