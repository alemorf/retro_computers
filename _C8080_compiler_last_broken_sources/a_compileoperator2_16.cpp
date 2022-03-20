#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileOperator2_16(NodeOperator* no, bool swap, Assembler::Reg16 second, const std::function<bool(bool, int)>& result) {
  // Результат сравнения в флагах
  if(no->o==oNE || no->o==oE || no->o==oGE || no->o==oLE || no->o==oG || no->o==oL) {
    assert(second == Assembler::DE);
    saveRegAAndUsed(); // op_cmp16 может портить регистр A
    out.call("op_cmp16", need_op_cmp16); out.t += 50;
    return result(swap, 0);
  }

  // Регистр HL будет изменен, поэтому сохраняем переменную хранящуюся в нем
  saveRegHLAndUsed();

  // Аппаратное сложение  
  if(no->o == oAdd) {
    out.dad(second);
    return result(swap, regHL);
  }

  // Второй аргумент должен быть в DE
  assert(second==Assembler::DE); 

  // Вызываем подпрограмму. Она испортитв все регистры.
  saveRegAAndUsed();
  saveRegDEAndUsed();  

  switch(no->o) {
    case oSub: out.call(swap ? "op_sub16_swap" : "op_sub16", need_op_sub16); out.t += 50;  return result(swap, regHL); 
    case oMul: out.call("op_mul16"                         , need_op_mul16); out.t += 300; return result(swap, regHL);
    case oDiv: out.call(swap ? "op_div16_swap" : "op_div16", need_op_div16); out.t += 300; return result(swap, regHL);
    case oMod: out.call(swap ? "op_mod16_swap" : "op_mod16", need_op_div16); out.t += 300; return result(swap, regHL);
    case oXor: out.call("op_xor16"                         , need_op_xor16); out.t += 50;  return result(swap, regHL);
    case oAnd: out.call("op_and16"                         , need_op_and16); out.t += 50;  return result(swap, regHL);
    case oOr:  out.call("op_or16"                          , need_op_or16 ); out.t += 50;  return result(swap, regHL);
    case oShr: out.call(swap ? "op_shr16_swap" : "op_shr16", need_op_shr16); out.t += 200; return result(swap, regHL);
    case oShl: out.call(swap ? "op_shl16_swap" : "op_shl16", need_op_shl16); out.t += 200; return result(swap, regHL);
  }

  raise("compileOperator2_16: operator not imp");
  throw;
}
