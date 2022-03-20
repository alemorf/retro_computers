#include <stdafx.h>
#include "a.h"
#include "b.h"

bool retWithBC = false;

#define DEEPCMD { if(!n->remark.empty()) { cmdLimit--; if(cmdLimit==0) return true; } }

bool asmLastCmdRetOrJmp() {
  auto lastCmd = out.items[out.ptr-1].cmd;
  return lastCmd==Assembler::cRET || lastCmd==Assembler::cJMP;
}

bool compile(Node* n, const std::function<bool()>& result) {
  // Конец ветки или ограничение рекурсии
  if(n==0) {
    return result();
  };

  DEEPCMD

  // Добавляем в файл комментарий
  if(!n->remark.empty()) {
    out.remark(n->remark.c_str());
  }

  switch(n->nodeType) {
    case ntNop:
      return compile(n->next, result);      
    case ntIf: {
      auto ni = (NodeIf*)n;
      int falseLabel = intLabels++;
      
      // При первом проходе мы не сохраняем регистры. Елси на выходе из условия, переменные останутся в тех же реистрах, то и сохранять не надо.
      return fork(2, [&](int forkNumber) {                                      
        //SaveInt si(out.incorrectFork);
        if(forkNumber==0) out.incorrectFork++;
        return compileCondOperator(falseLabel, false, ni->cond, /*dontSaveRegsBeforeJmp*/forkNumber==0, [&](){
          SaveState s1;
          return compile(ni->t, [&]() { // Сюда можно передать флаг noExec, то есть код дальше не выполняется. И в этом случае не учитывать состояние вообще.
            // Без ELSE
            if(ni->f == 0) {
              //! Заменить прыжок через RET или CALL на RETCC или CALLCC
              if(out.items[out.ptr-1].cmd==Assembler::cRET) {
                auto* x = &out.items[out.ptr-2];
                while(x->cmd==Assembler::cREMARK) x--;
                if(x->cmd==Assembler::cJCC) {
                  ChangeCode cc1(x-&out.items[0], 0, Assembler::cRETCC, x->a, x->b); //! TIMINGS
                  ChangeCode cc2(out.ptr-1, 0, Assembler::cNop); //! TIMINGS
                  s1.restoreRegs();
                  out.label2(falseLabel);
                  return compile(n->next, result);       
                }
              }

              // Программа в условии оканчивается на RET, то есть можно учитывать лишь регистры основной ветки
              //SaveInt si(out.incorrectFork);
              if(asmLastCmdRetOrJmp()) {
                s1.restoreRegs();
                if(forkNumber==0) out.incorrectFork--; // Получилось обьединить
              } else {
                // Обьединяем ветки
                if(combineState_(s1.saved)) {
                  if(forkNumber==0) out.incorrectFork--; // Получилось обьединить
                } else {
                  if(forkNumber!=0) raise("compileIf"); // Неудачная ветка                  
                }
              }              
              out.label2(falseLabel);              
              return compile(n->next, result);       
            }
            // Неудачная ветка, мы не трогаем incorrectFork. //! Потом дописать!

            // C ELSE
            int elseLabel = intLabels++;      
            saveRegs();
            out.jmpl(elseLabel);
            out.label2(falseLabel);
            return compile(ni->f, [&]() {
              saveRegs(); //! Надо бы восстановить состояние при входе сюда
              out.label1(elseLabel);
              return compile(n->next, result);
            });          
          });
        });
      });
    }
    case ntReturn: {
      auto nr = n->cast<NodeReturn>();
      if(nr->var) {
        if(nr->var->dataType.is8()) {
	        return compileVar(((NodeReturn*)n)->var, regA, [&](int){
            saveGlobalRegs();
            if(retWithBC) out.pop(Assembler::BC);
            out.ret(); //! Пропустить код до первой метки
            return compile(n->next, result);
          });
        }
        if(nr->var->dataType.is16()) {
	        return compileVar(((NodeReturn*)n)->var, regHL, [&](int){
            saveGlobalRegs();
            if(retWithBC) out.pop(Assembler::BC);
            out.ret(); //! Пропустить код до первой метки
            return compile(n->next, result);
          });
        }
        throw Exception("ntReturn big");
      }
      saveGlobalRegs();
      if(retWithBC) out.pop(Assembler::BC);
      out.ret(); //! Пропустить код до первой метки      
      return compile(n->next, result);      
    }
    case ntLabel: {
      saveAllRegsAndUsed();
      out.label2(n->cast<NodeLabel>()->n);
      return compile(n->next, result);      
    }
    case ntJmp: {
      auto nj = (NodeJmp*)n;
      // Поиск конечной точки перехода
      auto l = nj->label;
      if(nj->cond) {
        assert(l);
        while(l->next && l->next->nodeType == ntJmp) { // Может быть еще rz, rnz и т.п.
          if(l == ((NodeJmp*)l->next)->label)
            break;
          l = ((NodeJmp*)l->next)->label;
        }
      }
      int ln = l->cast<NodeLabel>()->n;
      // Сохранение всех регистров перед переходом
      saveRegs(-1, true);
      // Беусловный переход
      if(nj->cond == 0) {
        out.jmpl(ln);
        // Пропускаем всё, что не может выполниться
        n = n->next;
        while(n && n->nodeType!=ntLabel) n=n->next; 
        // Продолжение программы
        return compile(n, result);        
      } 
      // Компилируем условие
      return compileCondOperator(ln, !nj->ifZero, nj->cond, false, [&](){
        // Продолжение программы
        return compile(n->next, result);
      });
    }
    case ntSwitch: {
      auto ns = (NodeSwitch*)n;
      return compileVar(ns->var, regA, [&](int){ //! Если значения идут подряд, то можно и остальные регистры
        saveRegs();
        s.a.used = true;        
        assert(ns->var->dataType.is8());
        int initValue = 0;
        //! Двоичный поиск как вараинт
        //! JMP-таблица как вараинт
        for(auto i=ns->cases.begin(); i!=ns->cases.end(); ++i) {
          if(i->first >= 256) break; //! Вывести предупреждение
          int d = i->first - initValue;
          if(d == 0) {
            if(!zFlagForA()) out.alu(Assembler::OR, Assembler::A);
          } else
          if(d == 1) {
            out.dcr(Assembler::A); //! case уже есть!
          } else {
            out.alui(Assembler::SUB, i->first - initValue);
          }
          //out.comment(i2s(i->first));
          out.jcc(Assembler::JZ, i->second->cast<NodeLabel>()->n);
          initValue = i->first;
        }
        out.jmpl(ns->defaultLabel->cast<NodeLabel>()->n);
        return compile(ns->body, [&]() {
          return compile(ns->next, result);
        });
      });
    }
    case ntAsm: {
      saveAllRegsAndUsed();
      out.asmBlock(n->cast<NodeAsm>()->text.c_str());
      return compile(n->next, result);      
    }
    default: 
      return compileVar(n->cast<NodeVar>(), -1, [&](int){
        return compile(n->next, result);      
      });
  }
  throw;
}      
