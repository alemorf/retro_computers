#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileDeaddr(NodeDeaddr* nd, int canRegs, const std::function<bool(int)>& result) {
  // Загрузка значений из памяти по константному адресу
  if(nd->var->nodeType == ntConstI) {
    switch(nd->dataType.getSize()) {
      case 8:  { 
        saveRegAAndUsed(); //! Можем скинуть А в другой регистр
        out.lda(nd->var->cast<NodeConst>()->value); 
        //! Можно еще через регистры HL,DE,BC в другие регистры
        return result(regA);
      }  
      case 16: {
        saveRegHLAndUsed();  //! Можем скинуть HL в другой регистр
        out.lhld(nd->var->cast<NodeConst>()->value); 
        //! Можно еще через регистр A в HL,DE,BC
        //! Можно еще через регистры HL,DE,BC в другие регистры
        return result(regHL);
      }
      default: raise("compileDeadr !8 && !16");
    }
  }
 
  // Загрузка значений из регистровой переменной
  if(nd->var->nodeType == ntDeaddr && nd->var->cast<NodeDeaddr>()->var->nodeType == ntConstS) {
    auto src2 = nd->var->cast<NodeDeaddr>()->var->cast<NodeConst>();   
    if(src2->var->reg == regBC || src2->var->reg == regDE || src2->var->reg == regHL) {
      saveRegAAndUsed();
      if(src2->var->reg==regHL) out.mov(Assembler::A, Assembler::M);
                           else out.ldax(toAsmReg16(src2->var->reg));
      //! Проработать все canRegs
      return result(regA);
    }
  }

  // Загрузка значений из переменной
  if(nd->var->nodeType == ntConstS) {        
    auto src = (NodeConst*)nd->var;    
    // Копируем в A
    switch(nd->dataType.getSize()) {
      case 8: {
        if(canRegs & src->var->reg) {
          return result(src->var->reg);
        }
        loadInAreal(src->var);
        return result(regA);
      }
      case 16: {
        loadInHLreal(src->var);
        return result(regHL);
      }
    }
    throw;    
  }

  // Загрузка значения из вычисленного адреса
  return compileVar(nd->var, regBC|regDE|regHL, [&](int inReg){
    switch(nd->dataType.getSize()) {
      case 8:  { 
        saveRegAAndUsed(); 
        switch(inReg) {
          case regBC: out.ldax(Assembler::BC); break; //! Можно загружать не в A, а в B,C,D,E,H,L
          case regDE: normalizeDeltaDE(); out.ldax(Assembler::DE); break; //! Можно загружать не в A, а в B,C,D,E,H,L
          case regHL: normalizeDeltaHL(); out.mov(Assembler::A, Assembler::M); break; //! Можно загружать не в A, а в B,C,D,E,H,L
          default: throw;
        }
        return result(regA);
      }
      case 16: {        
        saveRegHLAndUsed();
        saveRegAAndUsed();
        switch(inReg) {
          case regBC: 
            out.ldax(Assembler::BC).mov(Assembler::L, Assembler::A); //! Можно загружать не в HL, а в BC, DE
            out.inx(Assembler::BC);
            out.ldax(Assembler::BC).mov(Assembler::H, Assembler::A);
            out.dcx(Assembler::BC);
            return result(regHL);
          case regDE: 
            normalizeDeltaDE();
            out.ldax(Assembler::DE).mov(Assembler::L, Assembler::A); //! Можно загружать не в HL, а в BC, DE
            out.inx(Assembler::DE);
            s.de.delta++;
            out.ldax(Assembler::DE).mov(Assembler::H, Assembler::A); 
            return result(regHL);
          case regHL:
            normalizeDeltaHL();
            out.mov(Assembler::A, Assembler::M); //! Можно загружать не в HL, а в BC, DE
            out.inx(Assembler::HL);
            s.hl.delta++;
            out.mov(Assembler::H, Assembler::M);
            out.mov(Assembler::L, Assembler::A);
            return result(regHL);
        }        
        throw;
      }
    }    
    throw;
  });
}
