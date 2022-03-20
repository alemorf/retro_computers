#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileOperatorV2_16_const_add(NodeOperator* o, bool swap, NodeConst* bc, const std::function<bool(bool, int)>& result) {    
  // Устраняем дельту в HL и отвязываем регистр от переменной в памяти. HL при этом будет содержать корректное значение
  auto a = s.hl.in;
  if(s.hl.in) {
    saveRegHLAndUsed();
    // HL все еще содержит копию переменной!
    s.hl.tmp = a;
    s.hl.delta = 0;
  }
  assert(s.hl.in==0);
  short value = bc->value - s.hl.delta; // Тут специально short, что бы 65535 привести к -1
  if(value > 0 && value <= 3) {
    for(int i=value; i; --i) out.inx(Assembler::HL);
  } else 
  if(value < 0 && value >= -3) {
    for(int i=value; i; ++i) out.dcx(Assembler::HL);
  } else 
  if(value !=0) {
    saveRegDEAndUsed();
    out.lxi(Assembler::DE, value).dad(Assembler::DE); //! Попробовать BC
  }
  // HL все еще содержит копию переменной! отличающееся на N от значения в памяти
  s.hl.delta = bc->value;
  return result(swap, regHL);           
}
