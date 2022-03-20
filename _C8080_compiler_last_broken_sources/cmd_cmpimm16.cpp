#include <stdafx.h>
#include "stackLoadSave.h"
#include "asm.h"

void resultFlags(CType& out, CBaseType t) {
  add(stack).place = pFlags;
  out.baseType = t; 
}

// Сравнение 16 битного значения с константой

char cmpImm16(CBaseType t, CBaseType t1, CType& a, int delta, int delta2) {
  // Аргументы
  Stack& as = stack[stack.size()-2];
  Stack& bs = stack[stack.size()-1];

  // Поиск и преобразование константы
  if(as.place==pConst   ) as.value = -as.value+delta2; else
  if(as.place==pConstStr) { as.name  = "-("+as.name+")"; if(delta) as.name += "+"+i2s(delta2); } else
  if(bs.place==pConst   ) bs.value = -bs.value+delta, t = t1; else
  if(bs.place==pConstStr) { bs.name  = "-("+bs.name+")"; if(delta) bs.name += "+"+i2s(delta); t = t1; } else return false;

  // Сложение, результат в HL
  add16(1);
  pushHL();

  // Если проверяем == или !=, то необходимо рассчитать флаг Z
  if(t==cbtFlagsE || t==cbtFlagsNE) bc().ld_a_l().or_h(); 

  // Результат во флагах
  resultFlags(a, t);
 
  // Сравнение выполено
  return true;
} 
