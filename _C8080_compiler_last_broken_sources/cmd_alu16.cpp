#include <stdafx.h>
#include "stackLoadSave.h"
#include "asm.h"

void alu16_const(Operator o, cstring v1, cstring v2, Opcode cmd1, Opcode cmd2, int mode);

void alu16(Operator o, Opcode cmd1, Opcode cmd2, bool canSwap, bool self) {
  //CheckStack st(-1);

  // Аргументы
  Stack& a = stack[stack.size()-2];
  Stack& b = stack[stack.size()-1];

  // Второй аргумент константа
  if(b.place==pConst || b.place==pConstStr) {
    // Вычитание можно реализовать через ADD HL, DE
    if(o==oSub) { 
      if(b.place==pConst) b.value = -b.value; else b.name = "-("+b.name+")";
      add16(1, self); 
      return; 
    }
    // Далее вычисляем в функции alu16_const
    string v1 = b.place==pConst ? i2s(b.value      & 0xFF) : "("+b.name+") & 0FFh";
    string v2 = b.place==pConst ? i2s((b.value>>8) & 0xFF) : "(("+b.name+") >> 8) & 0FFh";
    asm_pop();
    pushPeekHL(self);
    alu16_const(o, v1, v2, cmd1, cmd2, 0);
    popTmpPokeHL(self);
    return;
  }

  // Первый аргумент константа
  if(a.place==pConst || a.place==pConstStr) {
    // Далее вычисляем в функции alu16_const
    string v1 = a.place==pConst ? i2s( a.value     & 0xFF) : "("+a.name+") & 0FFh";
    string v2 = a.place==pConst ? i2s((a.value>>8) & 0xFF) : "(("+a.name+") >> 8) & 0FFh";
    pushPeekHL(self);
    alu16_const(o, v1, v2, cmd1, cmd2, 1);
    asm_pop();
    popTmpPokeHL(self);
    return;
  }

  // Первый аргумент BC
  if(a.place==pBC) {
    if(self) {
      pushHL();
      code.alu16_bc_hl_bc(o); //bc().ld_a_c().alu_l(cmd1).ld_c_a().ld_a_h().alu_h(cmd2).ld_b_a();
      return;
    }
    pushHL();
    asm_pop();
    code.alu16_bc_hl_hl(o); // bc().ld_a_c().alu_l(cmd1).ld_l_a().ld_a_h().alu_h(cmd2).ld_h_a();
    popTmpPokeHL(self);
    return;
  }

  // Второй аргумент BC
  if(b.place==pBC) {
    asm_pop();
    pushPeekHL(self);
    code.alu16_hl_bc_hl(o); // bc().ld_a_l().alu_c(cmd1).ld_l_a().ld_a_h().alu_b(cmd2).ld_h_a();
    popTmpPokeHL(self);
    return;
  }

  // Стандартное вычисление
  bool sw = pushHLDE(false/*true*/, self);
  if(sw) bc().ld_a_e().alu_l(cmd1).ld_l_a().ld_a_d().alu_h(cmd2).ld_h_a(); 
    else bc().ld_a_l().alu_e(cmd1).ld_l_a().ld_a_h().alu_d(cmd2).ld_h_a(); 
  popTmpPokeHL(self);
}

//---------------------------------------------------------------------------
// Сборка команды для 16 битной арифметики, где один из аргументов константа

void alu16_const(Operator o, cstring v1, cstring v2, Operator cmd1, Operator cmd2, int mode) {
  bool ignore0 = (o==oOr || o==oXor);

  // Комментарий выведен выше
    
  if(o==oAnd && v1=="0") {
    code.mvi_l(0); // bc().ld_l(0);
  } else {
    if(!((ignore0 && v1=="0") || (o==oAnd && v1=="255"))) {
      useA();
      if(mode==0) code.alu16_l_const(cmd1, v1); // bc().ld_a_l().alu(cmd1, v1).ld_l_a();
             else code.alu16_const_l(cmd1, v1); // bc().ld_a(v1).alu_l(cmd1).ld_l_a();
    }
  }

  if(o==oAnd && v2=="0") {
    code.mvi_h(0); // bc().ld_h(0);
  } else {
    if(!((ignore0 && v2=="0") || (o==oAnd && v2=="255"))) {
      useA();
      if(mode==0) code.alu16_h_const(cmd2, v2); // ld_a_h().alu(cmd2, v2).ld_h_a();  
             else code.alu16_const_h(cmd2, v2); // ld_a(v2).alu_h(cmd2).ld_h_a();  
    }
  }
}
