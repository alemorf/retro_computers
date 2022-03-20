#include <stdafx.h>
#include "a.h"
#include "b.h"

// Поместить адрес переменной в аккумулятор. Значение переменной получается, когда
// NodeConstS обернуто в NodeDeaddr. compileConstS при этом не вызывается.

bool compileConstS(NodeConst* nc, int canRegs, const std::function<bool(int)>& result) {
  if(nc->var->reg) raise("У регистровых переменных нет адреса!\n" + nc->var->name);

  if(nc->dataType.is8()) {
    saveRegAAndUsed();
    //! А может уже загружено? Нет контроля константных имен
    //! Грузить в остальные регистры
    out.mvi(Assembler::A, nc->var->name.c_str());
    return result(regA); 
  }

  if(nc->dataType.is16()) {
    saveRegHLAndUsed();
    //! А может уже загружено? Нет констроля константных имен
    //! Грузить в остальные регистры
    out.lxi(Assembler::HL, nc->var->name.c_str());
    return result(regHL);
  }

  raise("compileConstS !8 && !16");
  throw;
}