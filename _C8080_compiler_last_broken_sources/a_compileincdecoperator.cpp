#include <stdafx.h>
#include "a.h"
#include "b.h"

void incDecBC(int step1) {
  for(;step1>0; step1--) out.inx(Assembler::BC);
  for(;step1<0; step1++) out.dcx(Assembler::BC);
}

void incDecDE(int step1) {
  for(;step1>0; step1--) out.inx(Assembler::DE);
  for(;step1<0; step1++) out.dcx(Assembler::DE);
}

void incDecHL(int step1) {
  for(;step1>0; step1--) out.inx(Assembler::HL);
  for(;step1<0; step1++) out.dcx(Assembler::HL);
}

// 7-8-2014 прибрал
bool compileIncDecOperator(NodeMonoOperator* no, const std::function<bool(int)>& result) {
  bool inc = (no->o == moIncVoid || no->o == moPostInc || no->o == moInc);

  // Поддерживаются только переменные!
  if(no->a->nodeType != ntDeaddr) raise("compileIncDecOperator");
  auto var = no->a->cast<NodeDeaddr>()->var;

  // На сколько надо изменить 16 битную переменную?
  int step16 = 1;
  if(no->dataType.addr) step16 = no->dataType.sizeElement();
  if(!inc) step16 = -step16;

  // *************************************************************************
  // * Смысл этой оптимизации в том, что мы можем выполнять команды INC, DEC *
  // * над регистровыми переменными, без занесения их в аккумулятор.         *
  // *************************************************************************

  // Это регистровая переменная
  if(var->nodeType == ntConstS && var->cast<NodeConst>()->var->reg) {
    auto nc = var->cast<NodeConst>();
    // Это 8 битная переменная
    if(no->dataType.is8()) {
      // Но если переменная уже находится в аккумуляторе, а нам  нужно её прошлое значение, 
      // то не копиурем её обратно в B, C.
      if(s.a.in == nc->var) {
        // Проверка: i=5+j; i++; хоть i регистровая переменная, но она будет храниться в аккумуляторе
        if(no->o==moIncVoid || no->o==moDecVoid || no->o==moInc || no->o==moDec) goto stdPath;
        saveRegAAndUsed();
      }
      // На всякий случай, переменная может быть (хотя не должна) в других регистрах
      if(s.de.in == nc->var) saveRegDEAndUsed();
      if(s.hl.in == nc->var) saveRegHLAndUsed();
      // Тут пеменная точно в B, C
      auto reg = toAsmReg8(nc->var->reg);
      switch(no->o) {
        case moIncVoid: out.inr(reg); return result(0);
        case moDecVoid: out.dcr(reg); return result(0);
        case moInc:     saveRegAAndUsed(); out.inr(reg).mov(Assembler::A, reg); return result(regA);
        case moDec:     saveRegAAndUsed(); out.dcr(reg).mov(Assembler::A, reg); return result(regA);
        // было бы быстрее case moInc:     out.inr(reg); return result(nc->var->reg);
        // было бы быстрее case moDec:     out.dcr(reg); return result(nc->var->reg);
        case moPostInc: saveRegAAndUsed(); out.mov(Assembler::A, reg).inr(reg); return result(regA);
        case moPostDec: saveRegAAndUsed(); out.mov(Assembler::A, reg).dcr(reg); return result(regA);
      }
      throw;
    }

    if(no->dataType.is16()) {
      auto nc = var->cast<NodeConst>();
      // Но если переменная уже находится в аккумуляторе, а нам  нужно её прошлое значение, 
      // то не копиурем её обратно в BC.
      if(s.hl.in == nc->var) {
        // Проверка: i=5+j; i++; хоть i регистровая переменная, но она будет храниться в аккумуляторе
        if(no->o==moIncVoid || no->o==moDecVoid || no->o==moInc || no->o==moDec) goto stdPath;
        saveRegHLAndUsed();
      }
      // На всякий случай, переменная может быть (хотя не должна) в других регистрах
      if(s.de.in == nc->var) saveRegDEAndUsed();
      if(s.a.in  == nc->var) saveRegAAndUsed();
      // В этой реализации переменная может быть закреплена только за регистром BC
      if(nc->var->reg != regBC) throw;          
      // Действие
      switch(no->o) {
        case moIncVoid: case moDecVoid: incDecBC(step16); return result(0);        
        case moInc:     case moDec:     saveRegHLAndUsed(); incDecBC(step16); out.mov(Assembler::H, Assembler::B).mov(Assembler::L, Assembler::C); return result(regHL); //! Тут можно вернуть BC
        case moPostInc: case moPostDec: saveRegHLAndUsed(); out.mov(Assembler::H, Assembler::B).mov(Assembler::L, Assembler::C); incDecBC(step16); return result(regHL); //! Тут можно вернуть DE
      }
      throw;
    }
  }

stdPath:
  // *************************************************************************
  // * Далее мы заносим переменную в аккумулятор полюбому                    *
  // *************************************************************************

  // *** 8 битное значение ***

  if(no->dataType.is8()) {    
    // Адрес переменной задается числом, а они не кешируются.
    if(var->nodeType == ntConstI) { //! Вилка lxi h + inc m
      // Адрес переменной цифровой
      auto constAddr = var->cast<NodeConst>();
      saveRegAAndUsed();
      out.lda(constAddr->value);
      if(inc) out.inr(Assembler::A); else out.dcr(Assembler::A);
      out.sta(constAddr->value);
      if(no->o==moDecVoid || no->o==moIncVoid) return result(0);
      if(no->o==moPostDec || no->o==moPostInc) { if(inc) out.dcr(Assembler::A); else out.inr(Assembler::A); }
      return result(regA);
    }
    // Адрес переменной задается строкой, такие кешируются
    if(var->nodeType==ntConstS) { //! Вилка lxi h + inc m
      // Адрес переменной цифровой
      auto constAddr = var->cast<NodeConst>();
      loadInAreal(constAddr->var); // Сохранит прошлый A и загрузит туда переменную
      if(inc) out.inr(Assembler::A); else out.dcr(Assembler::A);
      s.a.changed = true; // Отложенное сохранение
      if(no->o==moDecVoid || no->o==moIncVoid) return result(0);
      if(no->o==moPostDec || no->o==moPostInc) { saveRegAAndUsed(); if(inc) out.dcr(Assembler::A); else out.inr(Assembler::A); }
      return result(regA);
    }
    // Адрес переменной вычисляемый
    return compileVar(var, regHL, [&](int reg){
      int outReg=0;
      if(no->o==moPostDec || no->o==moPostInc) saveRegAAndUsed(), outReg=regA, out.mov(Assembler::A, Assembler::M); //! Другой регистр?
      if(inc) out.inr(Assembler::M); else out.dcr(Assembler::M);
      if(no->o==moDec || no->o==moInc) saveRegAAndUsed(), outReg=regA, out.mov(Assembler::A, Assembler::M); //! Другой регистр?
      return result(outReg);
    });
  }

  // *** 16 битное значение ***

  if(no->dataType.is16()) {
    // Адрес переменной задается числом, а они не кешируются.
    if(var->nodeType==ntConstI) {
      auto constAddr = var->cast<NodeConst>();
      saveRegHLAndUsed();
      out.lhld(constAddr->value);
      incDecHL(step16);
      out.shld(constAddr->value);
      if(no->o==moDecVoid || no->o==moIncVoid) return result(0);
      if(no->o==moPostDec || no->o==moPostInc) incDecHL(-step16);
      out.xchg(); //! Можно попробовать как DE вернуть!!!
      return result(regHL);
    }
    // Адрес переменной задается строкой, такие кешируются
    if(var->nodeType==ntConstS) {      
      auto constAddr = var->cast<NodeConst>();
      loadInHLreal(constAddr->var); // Сохранит прошлый HL и загрузит туда переменную
      s.hl.delta = -step16; // Отложенное сохранение
      s.hl.changed = true; // Отложенное сохранение
      if(no->o==moDecVoid || no->o==moIncVoid) return result(regNone);
      //! Если мы отдаем regHL, то он должен быть корректным! хотя это не оптимально.
      incDecHL(step16); s.hl.delta=0; 
      if(no->o==moPostDec || no->o==moPostInc) { saveRegHLAndUsed(); incDecHL(-step16); }
      return result(regHL);
    }
    // Адрес переменной вычисляемый, поэтому его надо сохранить
    return compileVar(var, regHL, [&](int reg){
      saveRegDEAndUsed(); // В теории можно и в BC
      out.mov(Assembler::E, Assembler::M).inx(Assembler::HL).mov(Assembler::D, Assembler::M);
      incDecDE(step16);
      out.mov(Assembler::M, Assembler::D).dcx(Assembler::HL).mov(Assembler::M, Assembler::E);
      if(no->o==moDecVoid || no->o==moIncVoid) result(0);
      if(no->o==moPostDec || no->o==moPostInc) incDecDE(-step16);
      out.xchg(); //! Можно попробовать как DE вернуть!!!
      return result(regHL);
    });
  }
    
  raise("compileIncDecOperator !8 && !16");
  throw;
}
