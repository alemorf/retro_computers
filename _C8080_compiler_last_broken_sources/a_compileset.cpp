#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileSet(NodeOperator* no, const std::function<bool(bool,int)>& result) {
  // Выдергиваем адрес, далее будет работать только с ним
  if(no->a->nodeType != ntDeaddr) raise("compileSet !ntDeaddr");
  auto dest = no->a->cast<NodeDeaddr>();  

  // Самый простой вид записи. Указан адрес, поэтому мы используем команды sta и shld

  if(dest->var->isConst()) {
    auto destAddr = dest->var->cast<NodeConst>();
    // Константа=константа, поддерживается только для регистровых переменных
    if(no->b->isConst() && destAddr->nodeType == ntConstS && destAddr->var->reg) {
      // Теперь в регистрах некорректное значение
      if(s.hl.in==destAddr->var) s.hl.in=0; // тут s.hl.tmp==0
      if(s.a.in==destAddr->var) s.a.in=0;
      auto constb = no->b->cast<NodeConst>();
      if(no->b->dataType.is8()) {
        if(constb->nodeType==ntConstI && s.a.const_ && s.a.const_value==constb->value) {
          out.mov(toAsmReg8(destAddr->var->reg), Assembler::A);  //! Другие регистры!
        } else {
          out.mvi(toAsmReg8(destAddr->var->reg), constb); 
        }
      } else {
        out.lxi(toAsmReg16(destAddr->var->reg), constb);
      }
      if(no->o==oSetVoid) return result(false, 0);
      saveRegs(regHL); s.hl.used = true;
      out.lxi(Assembler::HL, no->b->cast<NodeConst>());
      return result(false, regHL);
    }    
    // Компилируем значение
    if(no->b->dataType.is8()) {
      // Если в регистре A лежит переменная, которую изменяем, то надо её выкинуть! А то добавится STA!
      if(destAddr->nodeType == ntConstS && s.a.in && s.a.in == destAddr->var) {
        s.a.changed = false;
      }
      // Помещаем значение в A
      return compileVar(no->b, regA, [&](int inReg) {
        // Значение должно быть в A 
        if(destAddr->nodeType == ntConstS) {
          // Отложенная запись
          bool o = s.a.const_;
          loadInA(destAddr->var); // Добавит только лишь команду STA, если копирвоание из не сохраненного регистра
          s.a.const_ = o;
          s.a.changed = true;
          return result(false, regA);
        }
        // Сразу записываем
        assert(destAddr->nodeType == ntConstI);
        s.a.used = true;        
        out.sta(destAddr->value);
        return result(false, regA);
      });
    }
    if(no->b->dataType.is16()) {
      // Если в регистре A лежит переменная, которую изменяем, то надо её выкинуть! А то добавится STA!
      if(destAddr->nodeType == ntConstS && s.hl.in && s.hl.in == destAddr->var) {
        s.hl.changed = false;
      }
      return compileVar(no->b, regHL, [&](int inReg) {
        if(destAddr->nodeType == ntConstS) {
          // Отложенная запись
          bool o = s.hl.const_;
          loadInHL(destAddr->var); // Добавит только лишь команду SHLD, если копирвоание из не сохраненного регистра
          s.hl.const_ = o;
          s.hl.changed = true;
          return result(false, regHL);
        }
        // Сразу записываем
        assert(destAddr->nodeType == ntConstI);
        s.hl.used = true;
        out.shld(destAddr->value);
        return result(false, regHL);            
      });
    }
    throw Exception("compileSet big");
  }

  // Второй простой вид записи, мы записываем константу по вычисляемому значению
  if(no->b->isConst()) {
    auto nb = no->b->cast<NodeConst>();

    //! Это надо исключить. И разбить на две ветки
    // Если адрес хранистя в BC, то мы испольузем команду MVI+STAX B
    if(dest->var->nodeType==ntDeaddr && dest->var->cast<NodeDeaddr>()->var->nodeType==ntConstS && dest->var->cast<NodeDeaddr>()->var->cast<NodeConst>()->var->reg==regBC) {
      if(no->b->dataType.is8()) {
        return compileVar(no->b, regA, [&](int reg) {
          return compileSaveA(dest->var->cast<NodeDeaddr>()->var, no->o==oSetVoid, result);
        });
      }
      if(no->b->dataType.is16()) {
        return compileVar(no->b, regHL, [&](int reg) {
          return compileSaveHL(dest->var->cast<NodeDeaddr>()->var, no->o==oSetVoid, result);
        });
      }
      raise("compileSet big1");
    }

    // Компилируем адрес. Он должен быть в HL
    return compileVar(dest->var, regHL, [&](int){ //! Попробовать в BC, DE
      switch(no->b->dataType.getSize()) {
        case 8:  out.mvi(Assembler::M, nb); break;
        case 16: out.mvi(Assembler::M, nb).inx(Assembler::HL).mvih(Assembler::M, nb); s.hl.delta++; break;
        default: raise("compileSet big1");
      }
      if(no->o==oSetVoid) return result(false, 0);
      switch(no->b->dataType.getSize()) {
        case 8:  saveRegAAndUsed();  out.mvi(Assembler::A,  nb); return result(false, regA );
        case 16: saveRegHLAndUsed(); out.lxi(Assembler::HL, nb); return result(false, regHL);
      }
      throw;
    });
  }

  return fork(2, [&](int n){ 
      if(n) return compileSetV2_nswap(dest->var, no->b, no, result);
       else return compileSetV2_swap (no->b, dest->var, no, result);
  });
}
