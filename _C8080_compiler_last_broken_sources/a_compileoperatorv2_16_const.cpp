#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileOperatorV2_16_const(NodeOperator* o, bool swap, NodeConst* bc, const std::function<bool(bool, int)>& result) {  
  // Оптимизация сложения
  if(o->o == oAdd && bc->nodeType == ntConstI) {
    return compileOperatorV2_16_const_add(o, swap, bc, result);
  }

  // Сравнение с нулем и нужен только флаг Z
  if((o->o == oE || o->o == oNE) && bc->value==0) {
    saveRegAAndUsed();
    out.mov(Assembler::A, Assembler::H).alu(Assembler::OR, Assembler::L);
    return result(swap, 0); 
  }

  // Сокращаем умножение
  if(bc->nodeType==ntConstI && o->o==oMul && bc->value!=0) {
    saveRegHLAndUsed();

    char mask[64];
    char* m = mask;
    bool needSaveDE = false;
    for(unsigned int d = bc->value; d>1; d>>=1)
      if(*m++ = (d & 1))
        needSaveDE = true;

    // Нужен DE
    if(needSaveDE) {
      saveRegDEAndUsed(); // Как вариант, можно и в стек. А можно пометить, что HL теперь в DE!
      out.mov(Assembler::D, Assembler::H).mov(Assembler::E, Assembler::L);
    }

    while(m != mask) {
      m--;
      out.dad(Assembler::HL);      
      if(*m) out.dad(Assembler::DE);
    }

    return result(false, regHL); 
  }

  // Поместить константу в DE
  return loadInDE(bc, false, [&](){
    return compileOperator2_16(o, !swap, Assembler::DE, result);
  });    

  //! Попробовать еще в BC. Только в этой реализации в DE лежит регистр
}
