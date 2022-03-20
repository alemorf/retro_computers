#include <stdafx.h>
#include "a.h"
#include "b.h"
#include <algorithm>

bool compileVar(NodeVar* n, int canRegs, const std::function<bool(int)>& result) {
  switch(n->nodeType) {
    case ntDeaddr: return compileDeaddr((NodeDeaddr*)n, canRegs, result);
    // Компиляция условия
    case ntCond: {      
      auto nc = n->cast<NodeCond>();
      int falseLabel = intLabels++, trueLabel = intLabels++;
      return compileCondOperator(falseLabel, false, nc->a, false, [&]() {
        saveRegAAndUsed();
        out.mvi(Assembler::A, 1).jmpl(trueLabel).label1(falseLabel).alu(Assembler::XOR, Assembler::A).label1(trueLabel);
        return result(regA);
      });      
    }
    case ntConstI: return compileConstI((NodeConst*)n, result);
    case ntConstS: return compileConstS((NodeConst*)n, canRegs, result);
    case ntMonoOperator: return compileMonoOperator((NodeMonoOperator*)n, result);
    case ntOperator: {
      auto no = (NodeOperator*)n;
      if(no->o==oIf) {
        int trueLabel = intLabels++, falseLabel = intLabels++;
        auto myReg = no->dataType.is8() ? regA : regHL;
        return compileCondOperator(falseLabel, false, no->cond, false, [&](){
          return compileVar(no->a, myReg, [&](int reg) { //! Можно то же вилку сделать
            assert(reg==myReg);
            out.jmpl(trueLabel);
            out.label1(falseLabel);
            return compileVar(no->b, myReg, [&](int reg) {
              assert(reg==myReg);
              out.label1(trueLabel);
              return result(myReg);
            });
          });        
        });
      }
      return compileOperator(no, [&](bool swap, int inReg){
        return result(inReg);
      });
    }
    case ntConvert: return compileConvert((NodeConvert*)n, canRegs, result);
    case ntCallS: 
      needFunction(((NodeCall*)n)->name);
    case ntCallI: {
      auto nc = (NodeCall*)n;

      // Порядок загрузки аргументов
      std::vector<int> argOrder;
      if(nc->args.size()>0) {
        std::vector<std::pair<int,int>> constArgs;
        for(unsigned int i=0; i<nc->args.size()-1; i++) {
          if(nc->args[i]->nodeType==ntConstI) {
            constArgs.push_back(std::pair<int,int>(i, nc->args[i]->cast<NodeConst>()->value));
          } else {
            argOrder.push_back(i);
          }
        }
        std::sort(constArgs.begin(), constArgs.end(), [&](const std::pair<int,int>& a, const std::pair<int,int>& b) { return a.second < b.second; } );
        for(unsigned int i=0; i<constArgs.size(); i++)
          argOrder.push_back(constArgs[i].first);
        argOrder.push_back(nc->args.size()-1);
      } //! перенести в конструктор NodeCall

      std::function<bool(int)> compileArg;      
      compileArg = [&](unsigned int nn){
        if(nn < argOrder.size()) {
          int n = argOrder[nn];
          auto a = nc->args[n];
          if(a->dataType.is8()) {
            return compileVar(a, regA, [&](int){            
              if(nn+1 < nc->args.size()) out.stafn(nc->name.c_str(), n+1);
              return compileArg(nn+1);
            });
          } 
          if(a->dataType.is16()) {
            return compileVar(a, regHL, [&](int){            
              if(nn+1 < nc->args.size()) out.shldfn(nc->name.c_str(), n+1);
              return compileArg(nn+1);
            });
          }
          throw Exception("compileArg big");
        }        

        // Все регистры будут испорчены функцией
        saveAllRegsAndUsed();
//        setDeUsed(true);
//        setHlUsed(true);
//        setAUsed(true);

        if(nc->nodeType == ntCallI) out.call(nc->addr);
                               else out.call(nc->name.c_str());

        return result(nc->dataType.is8() ? regA : regHL);
      };
      return compileArg(0);
    }
  }
  throw;
}
