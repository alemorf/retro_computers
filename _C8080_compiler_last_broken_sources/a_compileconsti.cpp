#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileConstI(NodeConst* nc, const std::function<bool(int)>& result) {
  if(nc->dataType.is8()) {
    //? assert(canRegs == regA);
    //! Попробовать в В
    //! Попробовать в С
    //! Попробовать в D
    //! Попробовать в E
    //! Попробовать в H
    //! Попробовать в L

    // Проработать INC, DEC, ADD A

    // Регистр уже содержит это значение
    int v = nc->value & 0xFF;
    if(s.a.const_ && s.a.const_value == v) return result(regA);

    // Помещаем в регистр значение
    bool ce = s.a.const_;
    int cv = s.a.const_value;
    saveRegAAndUsed();
    if(nc->value==0) out.alu(Assembler::XOR, Assembler::A);
    else if(ce && ((cv+1) & 0xFF) == v) out.inr(Assembler::A);
    else if(ce && ((cv-1) & 0xFF) == v) out.dcr(Assembler::A); //! Добавить еще вариантов
    else if(ce && ((cv << 1) & 0xFF) == v) out.alu(Assembler::ADD, Assembler::A); //! Добавить еще вариантов
    else if(ce && ((cv ^ 0xFF) & 0xFF) == v) out.cma(); //! Добавить еще вариантов
    else out.mvi(Assembler::A, nc->value & 0xFF);
    s.a.const_ = true;
    s.a.const_value = nc->value & 0xFF;
    return result(regA);
  }

  if(nc->dataType.is16()) {
    //? assert(canRegs == regHL);
    //! Попробовать в ВC
    //! Попробовать в DE

    // Проработать INC, DEC, ADD A

    // Регистр уже содержит это значение
    if(s.hl.const_ && s.hl.const_value==nc->value) return result(regHL);

    //! тут вставить оптимизации

    // Помещаем в регистр значение
    saveRegHLAndUsed();
    out.lxi(Assembler::HL, nc->value & 0xFFFF);
    s.hl.const_ = true;
    s.hl.const_value = nc->value & 0xFFFF;
    return result(regHL);
  }

  raise("compileConstI !8 && !16");
  throw;
}
