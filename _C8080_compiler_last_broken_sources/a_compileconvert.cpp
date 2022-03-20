#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileConvert(NodeConvert* nc, int canRegs, const std::function<bool(int)>& result) {
  // Ничего преобразовывать не надо
  if(nc->var->dataType.getSize() == nc->dataType.getSize()) {
    return compileVar(nc->var, canRegs, result);
  }

  // Упрощаем себе жизнь
  bool to16 = nc->var->dataType.getSize()==8  && nc->dataType.getSize()==16;
  bool to8  = nc->var->dataType.getSize()==16 && nc->dataType.getSize()==8;
  assert(to16 || to8);

  // Мы будем преобразовывать загруженное из памяти значение. Мы можем сразу не загружать
  // из памяти лишние биты или обнулить их позже.
  if(nc->var->nodeType == ntDeaddr) {
    auto nd = nc->var->cast<NodeDeaddr>();

    // Если нужная переменная уже в регистре, то замена lda addr + mov l, a + mvi h, 0 на mov l, a + mvi h, 0
    if(nd->var->nodeType == ntConstS) {
      auto nc = nd->var->cast<NodeConst>();
      if(to16 && nc->var == s.a.in) {
        // Особый случай, когда можно оставить 16 битную переменную в 8 битном регистре.
        if(canRegs & regA) return result(regA); //! Можно вилку            
        // Переносим A в HL
        saveRegHLAndUsed();
        out.mov(Assembler::L, Assembler::A); //! Для ускорения надо как то предусмотреть помещение в DE
        out.mvi(Assembler::H, 0);            
        return result(regHL);
      }
      if(to8 && nc->var == s.hl.in) {
        // Устраняем s.hl.delta. Регистр и так в HL, никаких других действий быть не должно.
        loadInHL(s.hl.in);
        // Переносим HL в A
        saveRegAAndUsed();
        out.mov(Assembler::A, Assembler::L); //! Для ускорения надо как то предусмотреть помещение в другие регистры, если они есть в canRegs
        return result(regA);
      }
      if(to8 && nc->var == s.de.in) {
        // Устраняем inDE_delta. Регистр и так в DE, никаких других действий быть не должно.
        loadInDE(s.de.in);
        // Переносим HL в A
        saveRegAAndUsed();
        out.mov(Assembler::A, Assembler::E); //! Для ускорения надо как то предусмотреть помещение в другие регистры, если они есть в canRegs
        return result(regA);
      }
    }

    if(nd->var->nodeType==ntConstS && (!nd->var->cast<NodeConst>()->var || !nd->var->cast<NodeConst>()->var->reg)) { //! А что если значения в каком то регистре?
      Set<CType> s(nc->var->dataType, nc->dataType);
      if(to8) {
        // Меняем LHLD на LDA
        return compileVar(nc->var, regA, [&](int) {
          return result(regA);
        });
      } else {
        // Меняем LDA на LHLD + MVI H, 0
        return compileVar(nc->var, regHL, [&](int) {
          out.mvi(Assembler::H, 0);
          return result(regHL);
        });
      }
    }
  }

  // Это вычисляемое значение (не значение загруженное из памяти)
  if(to16) {
    // Считаем в любой 8 битный регистр
    return compileVar(nc->var, regA|regB|regC|regD|regE|regH|regL, [&](int inReg) {
      // Если результат лежит в допустимом регистре, сразу выходим
      if(inReg & canRegs) return result(inReg); //! Можно вилку            
      // Будет использован регистр HL //! В другие пары?
      saveRegHLAndUsed();
      switch(inReg) {
        case regA: out.mov(Assembler::L, Assembler::A); break;
        case regB: out.mov(Assembler::L, Assembler::B); break;
        case regC: out.mov(Assembler::L, Assembler::C); break;
        case regD: out.mov(Assembler::L, Assembler::D); break;
        case regE: out.mov(Assembler::L, Assembler::E); break;
        case regH: out.mov(Assembler::L, Assembler::H); break;
        case regL: break;
        default: raise("compileNodeConvert 1");
      }      
      out.mvi(Assembler::H, 0); //! mvi(Assembler::H, 0) можно поменять на MOV A, R где R=0
      return result(regHL);
    });
  } else {
    // Считаем в любой 16 битный регистр
    return compileVar(nc->var, regBC|regDE|regHL, [&](int inReg) {
      // Если результат лежит в допустимом регистре, сразу выходим
      if(inReg & canRegs)  return result(inReg); //! Можно вилку            
      // Будет использован регистр A //! В другие регистры?
      saveRegAAndUsed();
      switch(inReg) {
        case regBC: out.mov(Assembler::A, Assembler::C); break;
        case regDE: out.mov(Assembler::A, Assembler::E); break;
        case regHL: out.mov(Assembler::A, Assembler::L); break;
        default: raise("compileNodeConvert 2");
      }
      return result(regA);
    });
  }
}
