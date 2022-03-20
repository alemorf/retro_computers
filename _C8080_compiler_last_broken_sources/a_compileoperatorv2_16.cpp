#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileOperatorV2_16(NodeOperator* o, bool swap, NodeVar* a, NodeVar* b, const std::function<bool(bool, int)>& result) {
  // Обьединение сложения с дельтой
  if(o->o==oAdd && b->nodeType==ntConstI && a->nodeType==ntDeaddr && a->cast<NodeDeaddr>()->var->nodeType==ntConstS && s.hl.tmp == a->cast<NodeDeaddr>()->var->cast<NodeConst>()->var) {
    return compileOperatorV2_16_const_add(o, swap, b->cast<NodeConst>(), result);
  }

  return compileVar(a, regHL, [&](int inReg){
    // В качестве второго аргумента используется регистр BC и его можно исползовать как второй аргумент команды.
    auto reg = b->isRegVar();
    if(reg!=regNone && o->o==oAdd) {
      return compileOperator2_16(o, !swap, toAsmReg16(reg), result);
    }

    // Если второй аргумент константа, загружаем её непосредственно в регистр D/DE. Или даже выполняем короткую команду.
    if(b->isConst()) return compileOperatorV2_16_const(o, swap, b->cast<NodeConst>(), result);

    // Если второй аргумент не константа, узнаем, нужны ли для его расчета регистры A или DE
    s.de.used = false;
    // Далее может быть XCHG, поэтому надо сохранить регистр.
    saveRegHLAndUsed();
    // Заранее сохраняем А или HL
    int poly = out.size(); out.push(Assembler::HL);
    // Компилируем    
    return compileVar(b, regHL, [&](int inReg){
      // Тут оба аргумента одинаковой разрядности      
      if(!s.de.used) {
        // Если DE не используется, то сохраняем в ней
        ChangeCode cc(poly, TIMINGS_XCHG-TIMINGS_PUSH, Assembler::cXCHG);
        s.de.used = true;
        return compileOperator2_16(o, swap, Assembler::DE, result);
      } else {
        out.pop(Assembler::DE);
        s.de.used = true;
        return compileOperator2_16(o, swap, Assembler::DE, result);
      }
    });    
  });
}
