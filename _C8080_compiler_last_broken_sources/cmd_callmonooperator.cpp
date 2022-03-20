#include <stdafx.h>
#include "stackLoadSave.h"
#include "asm.h"

void doDeaddr(CType type);

// Выполнить монооператор
void asm_callMonoOperator(MonoOperator mo, CType& type) {
  Stack& s = stack.back();

  if(mo==moDeaddr && type.addr>0) {    
    type.addr--;
    doDeaddr(type);
    return;
  }

  if(mo==moAddr) {    
    type.addr++;
    doAddr();
    return;
  }

  if(mo==moPostDec || mo==moPostInc) {
    if(type.addr>0) { postIncDec16(mo==moPostInc ? type.sizeElement() : -type.sizeElement()); return; }
    if(type.is8()) { postIncDec8(mo==moPostInc); return; }
    if(type.is16()) { postIncDec16(mo==moPostInc ? 1 : -1); return; }
    raise("asm_callMonoOperator");
  }

  if(mo==moDec || mo==moInc) {
    if(type.addr>0) { incDec16(mo==moInc ? type.sizeElement() : -type.sizeElement()); return; }
    if(type.is8()) { incDec8(mo==moInc); return; }
    if(type.is16()) { incDec16(mo==moInc ? 1 : -1); return; }
    raise("asm_callMonoOperator");
  }

  if(mo==moNeg) {
    if(s.place == pConst) { s.value = -s.value; type.baseType=cbtShort; return; }
    if(type.is8()) {
      pushA();
      bc().dec_a().cpl();
      popTmpA();
      return;
    }
    if(type.isStackType()) {
      if(s.place==pBC) {
        asm_pop();
        bc().ld_a(0).sub_c().ld_l_a().ld_a_flags(0).sbc_b().ld_h_a();
        popTmpHL();
      }
      pushHL();
      bc().ld_a(0).sub_l().ld_l_a().ld_a_flags(0).sbc_h().ld_h_a();
      popTmpHL();
      return;
    }
  }
  if(mo==moXor) {
    if(s.place == pConst) { s.value = ~s.value; return; }
    if(type.is8()) {
      pushA();
      bc().cpl();
      popTmpA();
      return;
    }
    if(type.isStackType()) {
      useA();
      if(s.place==pBC) {
        useHL(); //! Надо ли?
        asm_pop();
        bc().ld_a_c().cpl().ld_l_a().ld_a_b().cpl().ld_h_a();
        popTmpHL();
      }
      pushHL();
      if(optimizeSize) bc().call("op_inv16");
                  else bc().ld_a_l().cpl().ld_l_a().ld_a_h().cpl().ld_h_a();
      popTmpHL();
      return;
    }
  }

  if(mo==moNot) {
    if(s.place == pConst) { s.value = s.value ? 0 : 1; type.baseType = cbtUChar; return; }
    convertToConfition(type);
    switch(type.baseType) {
      case cbtFlagsE: type.baseType=cbtFlagsNE; break;
      case cbtFlagsNE: type.baseType=cbtFlagsE; break;
      default: raise("oNot");
    }
    return;
  }

  raise("asm_callMonoOperator");
}

void asm_struct(int offset, CType& type, CType& toType) {
/*  if(stack.last()->place==pConstStr||stack.last()->place==pConst) {
    asm_pushInteger(offset);
    add16(1, false);
    return;
  }*/

  doAddr();
  if(offset!=0) {
    asm_pushInteger(offset);
    add16(1, false);
  }
  if(toType.arr==0) 
    doDeaddr(toType);
}

void asm_index(CType idxType, CType& arrType) {
  if(arrType.addr==0) raise("Оператор [] можно пременять только к указателю или массиву"); 
  if(idxType.addr!=0) raise("asm_index"); 
  if(idxType.baseType==cbtChar || idxType.baseType==cbtUChar) asm_convert(0, idxType, cbtUShort); 




  /*if(stack.last()->place == pConst) {
    if(stack[stack.size()-2].place == pConstStr) {
      stack[stack.size()-2].name += "+" + i2s(stack.last()->value * arrType.sizeElement());
      asm_pop();
      stack.last()->place = pVar;
      arrType.addr--;
      arrType.arr = 0;
      return;
    } else {
      stack.last()->value *= arrType.sizeElement();
      pushDE();
    }
  } else {
    pushHL();
    mulHL(arrType.sizeElement());
    popTmpHL();//bc().str("  ex hl, de\r\n");
  }*/
  bool addr = arrType.arr==0; //stack.last()->place!=pConst && stack.last()->place!=pConstStr;
  add16(arrType.sizeElement());
  //peekHL(/*saveHl=*/true,1,/*canSwap=*/true);
  //bc().str("  add hl, de\r\n");
  //popTmpHL();
  //stack.last()->place = pHLRef;
  arrType.addr--;
  //if(arrType.arr==0) doDeaddr(arrType);

  // Мы должны изменять элекмент массива, а не адрес массива
  doDeaddr(arrType); 

  //arrType.arr = 0;
}

void doAddr() {
  Stack& s = stack.back();
  switch(s.place) {
    case pConstStrRefRef16:  s.place = pConstStrRef16; break;
    case pConstStrRefRef8:   s.place = pConstStrRef8;  break;    

    case pConstStrRef16: case pConstStrRef8: s.place = pConstStr; break;
    case pConstRef16:    case pConstRef8:    s.place = pConst; break;    
    case pHLRef16:       case pHLRef8:       s.place = pHL; break;
    case pBCRef16:       case pBCRef8:       s.place = pBC; break;
 
    case pA: case pHL: case pStack8: case pStack16: p.logicError_("Нельзя получить адрес временного значения"); break;
    case pB: case pC: case pBC: p.logicError_("Нельзя получить адрес регистровой переменной"); break;
    case pConstStr: case pConst: p.logicError_("Нельзя получить адрес константы"); break;
    default: raise("asm_callMonoOperator moFddr");
  }
}

void doDeaddr(CType type) {
  Stack& s = stack.back();
  switch(s.place) {
    case pConstStrRef16: s.place = type.is8() ? pConstStrRefRef8 : pConstStrRefRef16; break;
    case pConstStr:      s.place = type.is8() ? pConstStrRef8    : pConstStrRef16;    break;
    case pConst:         s.place = type.is8() ? pConstRef8       : pConstRef16;       break;
    case pBC:            s.place = type.is8() ? pBCRef8          : pBCRef16;          break;
    case pHL:            s.place = type.is8() ? pHLRef8          : pHLRef16;          break;

    // Требуется программа
    case pHLRef16:  
    case pBCRef16: 
    case pConstRef16:
    //case pConstStrRef16:
    case pConstStrRefRef16:
      pushHL(); popTmpHL(); s.place = type.is8() ? pHLRef8 : pHLRef16; break;

    case pHLRef8:  
    case pBCRef8: 
    case pConstRef8:
    case pConstStrRef8:
    case pConstStrRefRef8:
      p.logicError_("8 битная переменная не может выступать в качестве адреса");

    default: raise("asm_callMonoOperator moDeaddr "+i2s(s.place));
    // Адрес не может быть в pVar8, pA, pB, pC, 
  }
}

