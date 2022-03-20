#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileCondOperator(int falseLabel, bool neg, NodeVar* cond_, bool dontSaveRegsBeforeJmp, const std::function<bool()>& result) {  
  // Обязано быть условие
  if(cond_->nodeType != ntOperator || cond_->dataType.baseType != cbtFlags) 
    raise("ntIf !");
  auto no = cond_->cast<NodeOperator>();
  
  if(no->o == oLAnd) {
    if(dontSaveRegsBeforeJmp) return false; // неудачная ветка
    assert(no->a->nodeType == ntOperator);
    assert(no->b->nodeType == ntOperator);
    if(!neg) {
      return compileCondOperator(falseLabel, false, no->a, false, [&](){        
        return compileCondOperator(falseLabel, false, no->b, false, [&](){          
          return result();
        });
      });
    } else {
      // Комилируем !A || !B
      int trueLabel = intLabels++;
      return compileCondOperator(trueLabel, false, no->a, false, [&](){        
        return compileCondOperator(falseLabel, true, no->b, false, [&](){          
          out.label2(trueLabel);
          return result();
        });
      });     
    }
  }
  if(no->o == oLOr) {
    if(dontSaveRegsBeforeJmp) return false; // неудачная ветка
    assert(no->a->nodeType == ntOperator);
    assert(no->b->nodeType == ntOperator);
    if(!neg) {
      int trueLabel = intLabels++;
      return compileCondOperator(trueLabel, true, no->a, false, [&](){        
        return compileCondOperator(falseLabel, false, no->b, false, [&](){          
          out.label2(trueLabel);
          return result();
        });
      });     
    } else {
      // Компилируем !A && !B
      return compileCondOperator(falseLabel, true, no->a, false, [&](){        
        return compileCondOperator(falseLabel, true, no->b, false, [&](){          
          return result();
        });
      });
    }
  }

  return compileOperator(no, [&](bool swap, int inReg){
    assert(inReg==0);
    if(!dontSaveRegsBeforeJmp) saveRegs(-1, true);
    writeJmp(swap, !neg, no->o, falseLabel);
    return result();
  });
}
