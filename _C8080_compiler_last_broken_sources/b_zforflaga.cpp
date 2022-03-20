#include <stdafx.h>
#include "a.h"

bool zFlagForA() {
  Assembler::Item* lastCmd = &out.items[out.ptr-1];
  // Добавить все варианты
  while(lastCmd->cmd == Assembler::cSTA) lastCmd--;
  if(lastCmd->cmd == Assembler::cALU || lastCmd->cmd == Assembler::cALUI) return true;
  return (lastCmd->cmd == Assembler::cDcr || lastCmd->cmd == Assembler::cInr) && lastCmd->a == Assembler::A;
}
