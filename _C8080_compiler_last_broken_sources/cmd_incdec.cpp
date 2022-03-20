//! Преверить одновременное использование стека для хранения 8 и 16 битного значенеи (useA, useHL)

// Прибрал 

#include <stdafx.h>
#include "stackLoadSave.h"
#include "asm.h"

void incDec16(int v) {
  //! Заменить на ADD16
  Stack& s = stack.back();
  Writer& w = bc();

  // Ошибка
  if(v==0) p.logicError_("Этот тип не поддерживает арифметические операции");

  // Переменная хранится в регистре BC
  if(s.place == pBC) {
    if(v<-4 || v>4) {
      useHL();
      w.ld_hl(v).add_hl_bc().ld_bc_hl();
    } else {
      for(;v<0; v++) w.dec_bc(); for(;v>0; v--) w.inc_bc(); // 10+5*n тактов
    }
    return;
  }

  peekHL(); // Поместить в регистр HL
  if(v<-4 || v>4) {
    w.ld_de(v).add_hl_de();
  } else  {
    for(;v<0; v++) w.dec_hl(); for(;v>0; v--) w.inc_hl(); 
  }
  pokeHL(); // Значение в регистре HL
}

void incDec8(bool inc) {
  Stack& s = stack.back();
  Writer& w = bc();

  if(s.place==pB) {
    if(inc) w.inc_b(); else w.dec_b();
    return;
  }

  if(s.place==pC) {
    if(inc) w.inc_c(); else w.dec_c();
    return;
  }

  if(s.place==pA) raise("Нельзя изменять временное значение");
  
  useHL();
  peekAasHL_(); // pConstStrRef8, pBCRef8, pHLRef8, pConstStrRefRef8, pConstRef8  
  if(inc) w.inc_HL(); else w.dec_HL();
}


