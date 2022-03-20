#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileMonoOperator(NodeMonoOperator* no, const std::function<bool(int)>& result) {
  // Если увеличить или уменьшить регистровую переменную на единицу
  if(no->o==moIncVoid || no->o==moPostInc || no->o==moInc || no->o==moDecVoid || no->o==moPostDec || no->o==moDec) {
    return compileIncDecOperator(no, result);
  }

  if(no->dataType.is8()) {    
    return compileVar(no->a, regA, [&](int reg) {
      saveRegAAndUsed();
      switch(no->o) {      
        case moNeg: out.cma(); break;
        case moXor: out.cma().inr(Assembler::A); break;
        default: raise("compileMonoOperator 8 "+i2s(no->o));
      }
      return result(regA);      
    });      
  }

  if(no->dataType.is16()) {    
    return compileVar(no->a, regHL, [&](int reg) {
      saveRegHLAndUsed();
      switch(no->o) {
        case moNeg: raise("not imp"); break;
        case moXor: raise("not imp"); break;
        default: raise("compileMonoOperator 16 "+i2s(no->o));
      }
      return result(regHL);
    });      
  }

  raise("compileMonoOperator !8 && !16");
  throw;
}
