#include <stdafx.h>
#include "stackLoadSave.h"
#include "asm.h"

bool cmd_alu_swap(Opcode op, bool self, bool flags=false);
void cmd_alu(Opcode op, bool self, bool flags=false);
void alu16(Operator o, Opcode cmd1, Opcode cmd2, bool canSwap, bool self);

void asm_callOperator(Operator o, CType& a, CType b) {    
  // Оператор всегда уменьшает кол-во аргументов в стеке
  //CheckStack st(-1);

  // Тип данных cbtVoid ничего не кладет в стек, поэтому ниже будет ошибка
  if((a.baseType==cbtVoid && a.addr==0) || (b.baseType==cbtVoid && b.addr==0))
    p.logicError_("Операции с типом void недопустимы.");

  // Аргументы
  Stack& as = stack[stack.size()-2];
  Stack& bs = stack[stack.size()-1];

  // *** Операция между указателем и числом (константа обрабатывается внутри) ***

  if(a.addr>0 && b.addr==0) {
    // Сравнение указателя с нулем или запись в указатель нуля обрабатывается как обычное 16-битное
    if(o==oE || o==oNE) {
      if(bs.place!=pConst || bs.value!=0) p.logicError_("Указатель можно сравнивать только с нулем или другим указателем");
      goto ok;
    }

    // Сравнение указателя с нулем или запись в указатель нуля обрабатывается как обычное 16-битное
    if(o==oSet) {
      if(bs.place!=pConst || bs.value!=0) p.logicError_("Указателю можно присваивать только нуль или другой указатель");
      goto ok;
    }

    // Число надо преобразовать к 16 битному значению
    asm_convert(0, b, cbtUShort);

    // Сложение или вычитание указателя
    switch(o) {
      case oAdd:  add16(a.sizeElement()); return;
      case oSub:  sub16(a.sizeElement()); return;
      case oSAdd: add16(a.sizeElement(),true); return;
      case oSSub: sub16(a.sizeElement(),true); return; 
    }

    p.logicError_("К указателю можно только прибавлять или вычитать числа. А так же вычитать укзатель из указателя.");
  }

  // *** Операция между двумя указателями ***

  if(a.addr>0 && b.addr>0) {
    // Возможные операции
    if(o!=oSub && o!=oSet && o!=oL && o!=oG && o!=oLE && o!=oGE && o!=oE && o!=oNE) 
      p.logicError_("Указатели можно только вычитать, сравнивать и присваивать с другими указателями.");

    // У указателей должны быть идентичные типы
    if(a.addr!=b.addr || a.baseType!=b.baseType) 
      p.logicError_((string)"Операция "+opName(o)+" невозможна между "+a.descr()+" и "+b.descr());

    //! Надо обработать вычисление указателей (вызов деления)    

    // Работаем с указателями, как с 16-битными значениями
    a.addr=0; a.baseType=cbtUShort; b.addr=0; b.baseType=cbtUShort;
    goto ok;
  }

  // *** Операция между двумя константами ***

  if(as.place==pConst && bs.place==pConst) {
    bool i = a.addr==0 && (a.baseType==cbtChar || a.baseType==cbtShort);
    switch(o) {
      case oDiv: if(bs.value==0) p.logicError_("Деление на 0"); if(i) as.value = (int)as.value / (int)bs.value; else as.value = (unsigned int)as.value / (unsigned int)bs.value; break;
      case oMod: if(bs.value==0) p.logicError_("Деление на 0"); if(i) as.value = (int)as.value % (int)bs.value; else as.value = (unsigned int)as.value % (unsigned int)bs.value; break;
      case oMul: if(i) as.value = (int)as.value * (int)bs.value; else as.value = (unsigned int)as.value * (unsigned int)bs.value; break;
      case oMul8: if(i) as.value = (as.value * bs.value)&0xFF; else as.uvalue = (as.uvalue * bs.value)&0xFF; break;
      case oSub: as.value -= bs.value; break;
      case oAdd: as.value += bs.value; break;
      case oShr: as.value >>= bs.value; break;
      case oShl: as.value <<= bs.value; break;
      case oL:   as.value = i ? ((int)as.value <  (int)bs.value) : ((unsigned int)as.value <  (unsigned int)bs.value); break;
      case oG:   as.value = i ? ((int)as.value >  (int)bs.value) : ((unsigned int)as.value >  (unsigned int)bs.value); break;
      case oLE:  as.value = i ? ((int)as.value <= (int)bs.value) : ((unsigned int)as.value <= (unsigned int)bs.value); break;
      case oGE:  as.value = i ? ((int)as.value >= (int)bs.value) : ((unsigned int)as.value >= (unsigned int)bs.value); break;
      case oE:   as.value = i ? ((int)as.value == (int)bs.value) : ((unsigned int)as.value == (unsigned int)bs.value); break;
      case oNE:  as.value = i ? ((int)as.value != (int)bs.value) : ((unsigned int)as.value != (unsigned int)bs.value); break;
      case oAnd: as.value &= bs.value; break;
      case oXor: as.value ^= bs.value; break;
      case oOr:  as.value |= bs.value; break;
      case oLAnd:as.value = (as.value && bs.value); break;
      case oLOr: as.value = (as.value && bs.value); break;
      case oSet: case oSAdd: case oSSub: case oSMul: case oSDiv: case oSMod: case oSShl: case oSShr: 
      case oSAnd: case oSXor: case oSOr: p.logicError_("Нельзя изменить константу");
      default: p.logicError_((string)"Калькулятор для "+a.descr()+" "+opName(o)+" не написан");
    }
    asm_pop(); 
    return;
  }

  // *** Операция между двумя константами. Вычислять будет ассемблер ***

  if((as.place==pConstStr || as.place==pConst) && (bs.place==pConstStr || bs.place==pConst)) {
    string av = as.place==pConstStr ? as.name : i2s(as.value);
    string bv = bs.place==pConstStr ? bs.name : i2s(bs.value);
    as.place = pConstStr;
    switch(o) {
      case oDiv: as.name = "("+av+")/("+bv+")"; break;
      case oMod: as.name = "("+av+")%("+bv+")"; break;
      case oMul: as.name = "("+av+")*("+bv+")"; break;
      case oMul8: as.name = "(("+av+")*("+bv+"))&0xFF"; break;
      case oSub: as.name = "("+av+")-("+bv+")"; break;
      case oAdd: as.name = "("+av+")+("+bv+")"; break;
      case oShr: as.name = "("+av+")>>("+bv+")"; break;
      case oShl: as.name = "("+av+")<<("+bv+")"; break;
      case oL:   as.name = "("+av+")<("+bv+")"; break;
      case oG:   as.name = "("+av+")>("+bv+")"; break;
      case oLE:  as.name = "("+av+")<=("+bv+")"; break;
      case oGE:  as.name = "("+av+")>=("+bv+")"; break;
      case oE:   as.name = "("+av+")==("+bv+")"; break;
      case oNE:  as.name = "("+av+")!=("+bv+")"; break;
      case oAnd: as.name = "("+av+")&("+bv+")"; break;
      case oXor: as.name = "("+av+")|("+bv+")"; break;
      case oOr:  as.name = "("+av+")^("+bv+")"; break;
      case oSet: case oSAdd: case oSSub: case oSMul: case oSDiv: case oSMod: case oSShl: case oSShr: 
      case oSAnd: case oSXor: case oSOr: p.logicError_("Нельзя изменить константу");
      default: p.logicError_((string)"Калькулятор для "+a.descr()+" "+opName(o)+" не написан");
    }
    if(a.addr==0) {
      bool i = (a.baseType==cbtChar || a.baseType==cbtShort);
      if(i) a.baseType=cbtShort; else a.baseType=cbtUShort;  //! Проверить корректность преобразования к signed
    }
    asm_pop(); 
    return;
  }

  // *** Контроль типов ***
  
  //! Переписать весь блок ниже

  // Обратное преобразование константы USHORT в UCHAR
  if(a.addr==0 && b.addr==0) {
    if(bs.place==pConst) b.baseType = a.baseType; else
    if(as.place==pConst) a.baseType = b.baseType;
  }

  // Прямое преобразование
  if(b.addr==0 && a.addr==0) {
    if(o!=oSet && o!=oSAdd && o!=oSAnd && o!=oSDiv && o!=oSMod && o!=oSMul && o!=oSOr && o!=oSShl && o!=oSShr && o!=oSSub) {
      if(a.baseType==cbtUChar && b.baseType==cbtShort) b.baseType = cbtUShort;
      if(((a.baseType==cbtUChar || a.baseType==cbtChar || a.baseType==cbtShort) && b.baseType==cbtUShort)
      || (a.baseType==cbtChar && b.baseType==cbtUChar)
      || (a.baseType==cbtChar && b.baseType==cbtShort)
        ) {
        asm_convert(0, a, b); a = b.baseType;
      }
      if(b.baseType==cbtUChar && a.baseType==cbtShort) a.baseType = cbtUShort;
      if(((b.baseType==cbtUChar || b.baseType==cbtChar || b.baseType==cbtShort) && a.baseType==cbtUShort)
      || (b.baseType==cbtChar && a.baseType==cbtUChar)
      || (b.baseType==cbtChar && a.baseType==cbtShort)
        ) {
        asm_convert(0, b, a); b = a.baseType;
      }
    } else {
      if(a.baseType!=b.baseType)
        if(b.isStackType()) b.baseType = a.baseType;
    }
  }

  //! Это не совсем корректно!
  if(a.baseType!=b.baseType || a.addr !=b.addr) 
    p.logicError_((string)"Операция "+opName(o)+" невозможна между "+a.descr()+" и "+b.descr());


ok:


  // *** 8 битные типы данных ***

  if(a.is8()) {
    bool i = a.baseType==cbtChar;
    switch(o) {
      case oSet: set8(); return;
      case oSAdd: cmd_alu_swap(c_add_r, true); return;
      case oSSub: cmd_alu(c_sub_r, true); return;
      case oSOr:  cmd_alu_swap(c_or_r,  true); return;
      case oSAnd: cmd_alu_swap(c_and_r, true); return;
      case oSXor: cmd_alu_swap(c_xor_r, true); return;

      case oAdd:  cmd_alu_swap(c_add_r, false); return;
      case oSub:  if(bs.place==pConst && bs.value==1) { asm_pop(); pushA(); bc().dec_a(); popTmpA(); return; }
                  cmd_alu(c_sub_r, false); return;
      case oOr:   cmd_alu_swap(c_or_r , false); return;
      case oAnd:  cmd_alu_swap(c_and_r, false); return;
      case oXor:  cmd_alu_swap(c_xor_r, false); return;

      case oShr:  if(bs.place==pConst) { int x=bs.value; asm_pop(); cmd_shr8_1(false,x); return; } cmd_call_operator("op_shr"); return;
      case oSShr: if(bs.place==pConst) { int x=bs.value; asm_pop(); cmd_shr8_1(true ,x); return; } cmd_call_operator("op_shr", true); return;
      case oShl:  if(bs.place==pConst) { int x=bs.value; asm_pop(); cmd_shl8_1(false,x); return; } cmd_call_operator("op_shl"); return;
      case oSShl: if(bs.place==pConst) { int x=bs.value; asm_pop(); cmd_shl8_1(true ,x); return; } cmd_call_operator("op_shl", true); return;
      case oMul:
        if(a.baseType==cbtUChar && bs.place==pConst) { // Умножение беззнаковых чисел на константу
          switch(bs.value) {
            case 1: asm_pop(); return;
            case 2: case 4: case 5: case 8: case 16: asm_pop(); asm_convert(0,a,cbtUShort); pushHL(); mulHL(bs.value); popTmpHL(); a.baseType = cbtUShort; return;
          }
        }
        if(b.baseType==cbtUChar && as.place==pConst) { // Умножение беззнаковых чисел на константу
          switch(as.value) {
            case 1: asm_pop(); return;
            case 2: case 4: case 5: case 8: case 16: asm_convert(0,b,cbtUShort); pushHL(); asm_pop(); mulHL(as.value); popTmpHL(); a.baseType = cbtUShort; return;
          }
        }
        useHL(); cmd_call_operator_swap(i ? "op_imul" : "op_mul", 0, false, true);  a.baseType = i ? cbtShort : cbtUShort; return;
      case oMul8:
        if(a.baseType==cbtUChar && bs.place==pConst) { // Умножение беззнаковых чисел на константу
          switch(bs.value) {
            case 1: asm_pop(); return;
            case 2: case 4: case 5: case 8: case 16: asm_pop(); pushA(); mulA(bs.value); popTmpA(); return;
          }
        }
        if(b.baseType==cbtUChar && as.place==pConst) { // Умножение беззнаковых чисел на константу
          switch(as.value) {
            case 1: asm_pop(); return;
            case 2: case 4: case 5: case 8: case 16: pushA(); asm_pop(); mulA(as.value); popTmpA(); return;
          }
        }
        useHL(); cmd_call_operator_swap(i ? "op_imul" : "op_mul", 0, false, true);  a.baseType = i ? cbtShort : cbtUShort; return;
      case oSMul: useHL(); cmd_call_operator_swap(i ? "op_imul": "op_mul", 0, true, true); return;
      case oMod:
        if(a.baseType==cbtUChar && bs.place==pConst) {
          if(bs.value >= 256) { asm_pop(); return; }
          switch(bs.value) {
            case 1:   asm_pop(); asm_pop(); asm_pushInteger(0); return;
            case 2:   asm_pop(); pushA(); bc().and(1);   popTmpA(); return;
            case 4:   asm_pop(); pushA(); bc().and(3);   popTmpA(); return;
            case 8:   asm_pop(); pushA(); bc().and(7);   popTmpA(); return;
            case 16:  asm_pop(); pushA(); bc().and(0x0F); popTmpA(); return;
            case 32:  asm_pop(); pushA(); bc().and(0x1F); popTmpA(); return;
            case 64:  asm_pop(); pushA(); bc().and(0x3F); popTmpA(); return;
            case 128: asm_pop(); pushA(); bc().and(0x7F); popTmpA(); return;
          }
        }
        cmd_call_operator(i ? "op_imod" : "op_mod");
        return;
      case oDiv:  
        if(a.baseType==cbtUChar && bs.place==pConst) {
          switch(bs.value) {
            case 1: asm_pop(); return;
            case 2:  asm_pop(); pushA(); bc().clcf().rra(); popTmpA(); return;
            case 4:  asm_pop(); pushA(); bc().rra().rra().and(0x3F); popTmpA(); return;
            case 8:  asm_pop(); pushA(); bc().rra().rra().rra().and(0x1F); popTmpA(); return;
            case 16: asm_pop(); pushA(); bc().rra().rra().rra().rra().and(0x0F); popTmpA(); return;
          }
        }
        cmd_call_operator(i ? "op_idiv" : "op_div");
        return;
      case oSDiv: cmd_call_operator(i ? "op_idiv" : "op_div", true); return;
      case oL:    if(!i) { a.baseType = cmd_alu_swap(c_cp_r, false, true) ? cbtFlagsG  : cbtFlagsL;  } else{  cmd_call_operator_swap("op_il" ,"op_ig" ); a.baseType = cbtUChar; } return;
      case oG:    if(!i) { a.baseType = cmd_alu_swap(c_cp_r, false, true) ? cbtFlagsL  : cbtFlagsG;  } else { cmd_call_operator_swap("op_ig" ,"op_il" ); a.baseType = cbtUChar; } return;
      case oLE:   if(!i) { a.baseType = cmd_alu_swap(c_cp_r, false, true) ? cbtFlagsGE : cbtFlagsLE; } else { cmd_call_operator_swap("op_ile","op_ige"); a.baseType = cbtUChar; } return;
      case oGE:   if(!i) { a.baseType = cmd_alu_swap(c_cp_r, false, true) ? cbtFlagsLE : cbtFlagsGE; } else { cmd_call_operator_swap("op_ige","op_ile"); a.baseType = cbtUChar; } return;
      case oE:    cmd_alu_swap(c_cpz_r, false, true); a.baseType = cbtFlagsE;  return;
      case oNE:   cmd_alu_swap(c_cpz_r, false, true); a.baseType = cbtFlagsNE; return;
    }
    p.logicError_((string)"Операция "+opName(o)+" невозможна между "+a.descr()+" и "+b.descr());
  }

  // Копирование структур
  if(a.baseType==cbtStruct && b.baseType==cbtStruct && a.i==b.i && o==oSet) {
   // peekHL();
    asm_arg("memcpy",cbtUShort,1,false);

   // pushHL();
    asm_arg("memcpy",cbtUShort,2,false);

    asm_pushInteger(get(structs, a.i).size);
    asm_arg("memcpy",cbtUShort,3,true);

    bc().call("memcpy");    

    popTmpHL();
    return;
  }

  if(a.isStackType()) {
    bool i = a.addr==0 && a.baseType==cbtShort; 
    switch(o) {
      case oSet:  set16(); return;
      case oSOr:  alu16(o, c_or_r,  c_or_r,  true,  true ); return;
      case oSXor: alu16(o, c_xor_r, c_xor_r, true,  true ); return;
      case oSSub: alu16(o, c_sub_r, c_sbc_r, false, true ); return;
      case oOr:   alu16(o, c_or_r,  c_or_r,  true,  false); return;
      case oXor:  alu16(o, c_xor_r, c_xor_r, true,  false); return;
      case oAnd:  alu16(o, c_and_r, c_and_r, true,  false); return;
      case oSub:  alu16(o, c_sub_r, c_sbc_r, false, false); return;
      case oSAdd: add16(1, true); return;
      case oAdd:  add16(1, false); return;
      case oShr:  if(bs.place==pConst) { int x=bs.value; asm_pop(); cmd_shr16_1(false,x); } else { pushHLDE(false);       bc().callFile("op_shr16\r\n"); popTmpHL(); } return;
      case oSShr: if(bs.place==pConst) { int x=bs.value; asm_pop(); cmd_shr16_1(true ,x); } else { pushHLDE(false, true); bc().callFile("op_shr16\r\n"); pokeHL();   } return;
      case oShl:  if(bs.place==pConst) { int x=bs.value; asm_pop(); cmd_shl16_1(false,x); } else { pushHLDE(false);       bc().callFile("op_shl16\r\n"); popTmpHL(); } return;
      case oSShl: if(bs.place==pConst) { int x=bs.value; asm_pop(); cmd_shl16_1(true ,x); } else { pushHLDE(false, true); bc().callFile("op_shl16\r\n"); pokeHL();   } return;
      case oMul:  pushHLDE(true);        bc().callFile(i ? "op_imul16" : "op_mul16"); popTmpHL(); return;
      case oSMul: pushHLDE(true,  true); bc().callFile(i ? "op_imul16" : "op_mul16"); pokeHL();   return;
      case oMod:  pushHLDE(false);       bc().callFile(i ? "op_imod16" : "op_mod16"); popTmpHL(); return;
      case oDiv:  pushHLDE(false);       bc().callFile(i ? "op_idiv16" : "op_div16"); popTmpHL(); return;
      case oSDiv: pushHLDE(false, true); bc().callFile(i ? "op_idiv16" : "op_div16"); pokeHL();   return;

      case oL:  { if(cmpImm16(cbtFlagsL, cbtFlagsGE, a, -1)) return;
                  bool swap = pushHLDE(true);
                  if(i) { bc().callFile(swap ? "op_ige16" : "op_il16"); add(stack).place = pFlags; a.baseType = cbtFlagsE; return; }
                  bc().callFile("op_cmp16"); resultFlags(a, swap ? cbtFlagsG : cbtFlagsL); return; }

      case oLE: { if(cmpImm16(cbtFlagsLE, cbtFlagsG, a, -1)) return; //! Скорее всего тут ошибка, проверить
                  bool swap = pushHLDE(true);
                  if(i) { bc().callFile(swap ? "op_ig16" : "op_ile16"); add(stack).place = pFlags; a.baseType = cbtFlagsE; return; }
                  bc().callFile("op_cmp16"); resultFlags(a, swap ? cbtFlagsGE : cbtFlagsLE); return; }

      case oG:  { if(cmpImm16(cbtFlagsG, cbtFlagsLE, a, -1)) return; //! Скорее всего тут ошибка, проверить
                  bool swap = pushHLDE(true);
                  if(i) { bc().callFile(swap ? "op_ile16" : "op_ig16"); add(stack).place = pFlags; a.baseType = cbtFlagsE; return; }
                  bc().callFile("op_cmp16"); resultFlags(a, swap ? cbtFlagsL : cbtFlagsG); return; }

      case oGE: { if(cmpImm16(cbtFlagsGE, cbtFlagsL, a, 0, -1)) return; //! Скорее всего тут ошибка, проверить
                  bool swap = pushHLDE(true);
                  if(i) { bc().callFile(swap ? "op_il16" : "op_ige16"); add(stack).place = pFlags; a.baseType = cbtFlagsE; return; }
                  bc().callFile("op_cmp16"); resultFlags(a, swap ? cbtFlagsLE : cbtFlagsGE); return; }

      case oE:    if(cmpImm16(cbtFlagsE, cbtFlagsE, a)) return;
                  pushHLDE(true); bc().callFile("op_cmp16"); resultFlags(a, cbtFlagsE); return;

      case oNE:   if(cmpImm16(cbtFlagsNE, cbtFlagsNE, a)) return;
                  pushHLDE(true); bc().callFile("op_cmp16"); resultFlags(a, cbtFlagsNE); return;
    }
    p.logicError_((string)"Операция "+opName(o)+" невозможна между "+a.descr()+" и "+b.descr());
  }

  p.logicError_("Операции с типом данных "+a.descr()+" не поддерживаются");
}
