#include <stdafx.h>
#include "b.h"

bool zFlagFor8(Assembler::Reg8 reg) {
  auto lastCmd = out.items.begin()+out.ptr-1;
  if(lastCmd->cmd == Assembler::cREMARK) lastCmd--;
  if((lastCmd->cmd == Assembler::cDcr || lastCmd->cmd == Assembler::cInr) && lastCmd->a == reg) return true;
  return false;
}
