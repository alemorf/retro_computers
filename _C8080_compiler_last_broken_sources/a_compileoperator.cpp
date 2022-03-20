#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileOperator(NodeOperator* no, const std::function<bool(bool, int)>& result) {
  // Изменение значения переменной, компилируется отдельно
  if(no->o == oSet || no->o == oSetVoid) {
    return compileSet(no, result);
  }
    
  // Компилируем оба вараинта  

  if(no->a->dataType.is8()) {
    assert(no->b->dataType.is8());

    // Аргументы SUB нельзя менять местами
    if(no->o==oSub) return compileOperatorV2_8(no, true,  no->b, no->a, result);  

    return fork(2, [&](int n) {
      if(n) return compileOperatorV2_8(no, false, no->a, no->b, result);
       else return compileOperatorV2_8(no, true,  no->b, no->a, result);  
    });
  }

  if(no->a->dataType.is16()) {
    assert(no->b->dataType.is16());
    return fork(2, [&](int n) {
      if(n) return compileOperatorV2_16(no, false, no->a, no->b, result);
       else return compileOperatorV2_16(no, true,  no->b, no->a, result);  
    });
  }

  throw Exception("compileOperator big");
}
