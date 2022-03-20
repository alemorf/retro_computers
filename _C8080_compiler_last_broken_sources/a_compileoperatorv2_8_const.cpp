#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileOperatorV2_8_const(NodeOperator* o, bool swap, NodeConst* bc, const std::function<bool(bool, int)>& result) {  
  switch(o->o) {
    case oE: case oNE: // Сравнение с нулем, результат в флагах

      // Если надо сравнить с нулем 
      if(bc->nodeType==ntConstI && (bc->value&0xFF) == 0) {
        // Если прошлая команда изменила флаг в соответстсвии с A, то OR A не добавляем
        if(!zFlagForA()) out.alu(Assembler::OR, Assembler::A);
        return result(swap, 0);      
      }     

      // Если надо сравнить с единицей. //! Портить регистр A может быть не выгодно
      if(bc->nodeType==ntConstI && (bc->value&0xFF) == 1) {
        saveRegAAndUsed();
        out.dcr(Assembler::A); //! Надо оформить как вилку!
        return result(swap, 0);      
      }     

      // Если надо сравнить с нулем. //! Портить регистр A может быть не выгодно
      if(bc->nodeType==ntConstI && (bc->value&0xFF) == 255) {
        saveRegAAndUsed();
        out.inr(Assembler::A); //! Надо оформить как вилку!
        return result(swap, 0);      
      }     

      // Продолжаем c командой CPIn
    case oGE: case oLE: case oG: case oL:
      out.alui(Assembler::CMP, bc);
      return result(!swap, 0);
    case oXor: { saveRegAAndUsed(); out.alui(Assembler::XOR, bc); return result(swap, regA); }
    case oAnd: { saveRegAAndUsed(); out.alui(Assembler::AND, bc); return result(swap, regA); }
    case oOr:  { saveRegAAndUsed(); out.alui(Assembler::OR,  bc); return result(swap, regA); }
    // oSub не используется, так как заменяется на oAdd        
    case oSub:
      raise("Не должно быть SUB!");
    case oAdd: { 
      saveRegAAndUsed();
      if(bc->nodeType==ntConstI && (bc->value & 0xFF)==1) out.inr(Assembler::A); 
      else if(bc->nodeType==ntConstI && (bc->value & 0xFF)==255) out.dcr(Assembler::A); 
      else out.alui(Assembler::ADD, bc);
      return result(swap, regA);
    }    
    case oShl: {
      saveRegAAndUsed();
      for(unsigned char x = bc->value; x>0; x--) 
        out.alu(Assembler::ADD, Assembler::A);
      return result(false, regA); 
    }
    case oShr: {
      saveRegAAndUsed();
      unsigned char mask = 0xFF;
      for(unsigned char x = bc->value; x>0; x--) {
        out.rrc();
        mask >>= 1;
      }
      out.alui(Assembler::AND, mask);
      return result(false, regA); 
    }
    //! Добавить деление на 1,2,4,8,16,32,64,128
    case oMul: {
      if(((unsigned char)bc->value) > 1) {
        saveRegAAndUsed();

        char mask[64];
        char* m = mask;
        bool needSaveD = false;
        for(unsigned int d = bc->value; d>1; d>>=1)
          if(*m++ = (d & 1))
            needSaveD = true;

        // Нужен D
        if(needSaveD) {
          saveRegDEAndUsed(); // Как вариант, можно и в стек. А можно пометить, что A теперь в D!
          out.mov(Assembler::D, Assembler::A);
        }

        while(m != mask) {
          m--;
          out.alu(Assembler::ADD, Assembler::A);      
          if(*m) out.alu(Assembler::ADD, Assembler::D);
        }

        return result(false, regA); 
      }
    }
  }

  // Поместить константу сразу в D или DE.
  //! Попробовать еще в B,C,D,E,H,L
  return loadInDE(bc, false, [&](){
    return compileOperator2_8(o, !swap, Assembler::D, result);
  });
}
