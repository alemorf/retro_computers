// Команды увеличения, уменьшения

#include <stdafx.h>
#include "stackLoadSave.h"
#include "asm.h"

void postIncDec16(int v) {
  Stack& s = stack.back();
  Writer& w = bc();

  // Ошибка
  if(v==0) p.logicError_("Этот тип не поддерживает арифметические операции");
  
  // Переменная хранится в регистре BC
  if(s.place == pBC) {
    asm_pop();
    if(v<-4 || v>4) {
      w.ld_hl(v).ld_de_bc().add_hl_bc().ld_bc_hl().ex_hl_de(); // 44 такта
    } else {
      useHL();
      w.ld_hl_bc();
      for(;v<0; v++) w.dec_bc(); for(;v>0; v--) w.inc_bc(); // 10+5*n тактов
    }
    popTmpHL();
    return;
  }

  // Команда PokeHL не использует регистр DE и мы то же, поэтому мы для временного хранения используем DE
  bool bigNumber = (v<-4 || v>4);
  if(!pokeHL_checkDE() && !bigNumber) {
    peekHL();
    w.ld_de_hl();
    for(;v<0; v++) w.dec_hl(); for(;v>0; v--) w.inc_hl(); 
    pokeHL(); asm_pop();
    w.ex_hl_de();
    popTmpHL();
    return;
  }

  peekHL();
  w.push_hl();
  // Если надо слишком много INC или DEC, то заменяем на ADD HL, DE
  if(bigNumber) {
    w.ld_de(v).add_hl_de();
  } else  {
    for(;v<0; v++) w.dec_hl(); for(;v>0; v--) w.inc_hl(); 
  }
  pokeHL(); asm_pop();
  w.pop_hl();
  popTmpHL();  
}

void postIncDec8(bool inc) {
  Stack& s = stack.back();
  Writer& w = bc();
  
  if(s.place==pB) {
    pushA(); // mov a, b
    if(inc) w.inc_b(); else w.dec_b();
    popTmpA();
    return;
  }

  if(s.place==pC) {
    pushA(); // mov a, c
    if(inc) w.inc_c(); else w.dec_c();
    popTmpA();
    return;
  }

  if(s.place==pA) raise("Нельзя изменять временное значение");

  useA();  
  pushAasHL_(); // pConstStrRef8, pBCRef8, pHLRef8, pConstStrRefRef8, pConstRef8 и сам вызовет useHL();
  w.ld_a_HL();
  if(inc) w.inc_HL(); else w.dec_HL();
  popTmpA();
}


