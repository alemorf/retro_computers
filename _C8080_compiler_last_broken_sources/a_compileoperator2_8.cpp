#include <stdafx.h>
#include "a.h"
#include "b.h"

const int TIME_OP_MUL = 200;
const int TIME_OP_SHR = 50;
const int TIME_OP_SHL = 50;

bool compileOperator2_8_checkAnyReg(NodeOperator* no) {
  switch(no->o) {
    case oE:
    case oNE:
    case oGE:
    case oLE:
    case oG:
    case oL:
    case oAdd: 
    case oSub: 
    case oXor: 
    case oAnd: 
    case oOr: return true;
    // oShr, oShl, oMul принимают второй аргумент только в D, потому что это подпрограммы
  }
  return false;
}

bool compileOperator2_8(NodeOperator* no, bool swap, Assembler::Reg8 second, const std::function<bool(bool, int)>& result) {
  // Результат сравнения в флагах
  if(no->o==oE || no->o==oNE || no->o==oGE || no->o==oLE || no->o==oG || no->o==oL) {
    out.alu(Assembler::CMP, second);
    return result(swap, 0);      
  }

  // Регистр A будет изменен, поэтому сохраняем переменную хранящуюся в нем
  saveRegAAndUsed();

  // Выполняем оператор
  switch(no->o) {
    case oAdd: out.alu(Assembler::ADD, second); break;
    case oSub: assert(swap); out.alu(Assembler::SUB, second); break; // При вызове этой функции, надо учесть этот assert
    case oXor: out.alu(Assembler::XOR, second); break;
    case oAnd: out.alu(Assembler::AND, second); break;
    case oOr:  out.alu(Assembler::OR, second); break;        
    case oShr: assert(second==Assembler::D); out.call(swap ? "op_shr" : "op_shr_swap", need_op_shr8); out.t += TIME_OP_SHR; break;
    case oShl: assert(second==Assembler::D); out.call(swap ? "op_shl" : "op_shl_swap", need_op_shl8); out.t += TIME_OP_SHL; break;
    case oMul: assert(second==Assembler::D); out.call("op_mul", need_op_mul); out.t += TIME_OP_MUL; break;    
    default: raise("compileOperator2_8 " + i2s(no->o));
  }

  // Продолжаем
  return result(swap, regA);    
}
