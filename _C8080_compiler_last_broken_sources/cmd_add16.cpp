#include <stdafx.h>
#include "stackLoadSave.h"
#include "asm.h"

// Сложение 16-битных чисел

void add16(int size_of, bool self) {
  // Аргументы
  Stack& as = stack[stack.size()-2];
  Stack& bs = stack[stack.size()-1];

  // Умножение второго аргумента
  if(size_of != 1) {
    switch(bs.place) {
      case pConst:    bs.value *= size_of; break; 
      case pConstStr: bs.name = "("+bs.name+")*"+i2s(size_of); break;
      default:        pushHL(); mulHL(size_of); popTmpHL();
    }
  }

  // Сложение двух констант
  if(as.place==pConst && bs.place==pConst) {
    as.value += bs.value;
    asm_pop();
    return;
  }

  // Сложение двух констант (вычисляется компилятором)
  if((as.place==pConstStr || as.place==pConst) && (bs.place==pConstStr || bs.place==pConst)) {
    string av = as.place==pConstStr ? as.name : i2s(as.value);
    string bv = bs.place==pConstStr ? bs.name : i2s(bs.value);
    as.place = pConstStr;
    as.name = "("+av+")+("+bv+")";
    asm_pop();
    return;
  }

  // Константа+Переменная. Подстановка INC, DEC
  if(!self && as.place==pConst && as.value>=-4 && as.value<=4) {
    int v = as.value;
    //bc().remark("Сложение с константой "+i2s(v));
    pushHL();
    asm_pop(); // Тут была константа
    for(;v<0; v++) bc().dec_hl(); for(;v>0; v--) bc().inc_hl();
    popTmpHL();
    return;
  }

  // Переменная+Константа. Подстановка INC, DEC
  if(bs.place==pConst && bs.value>=-4 && bs.value<=4) {
    int v = bs.value;
    asm_pop(); // Тут была константа

    // Оптимизация BC
    if(self && as.place==pBC) {
      bc().remark("Сложение BC с константой "+i2s(v));
      for(;v<0; v++) bc().dec_bc(); for(;v>0; v--) bc().inc_bc();
      return;
    }

    // Копируем в HL и работаем с ним  
    bc().remark("Сложение с константой "+i2s(v));
    pushPeekHL(self);
    for(;v<0; v++) bc().dec_hl(); for(;v>0; v--) bc().inc_hl();
    popTmpPokeHL(self);
    return;
  }

  // Оптимизация BC
  if(as.place == pBC) {
    bc().remark("Сложение с BC");
    pushHL();
    if(!self) asm_pop(); // Если это изменение BC, то он в виртуальном стеке и останется
    bc().add_hl_bc();
    popTmpPokeHL(self); // Поместить в BC или оставить в HL
    return;
  }

  // Оптимизация BC
  if(bs.place == pBC) {
    bc().remark("Сложение с BC");
    asm_pop(); // В виртуальном стеке был BC
    pushPeekHL(self);
    bc().add_hl_bc();
    popTmpPokeHL(self);
    return;
  }

  // Стандартный способ
  bc().remark("Сложение");
  pushHLDE(/*Порядок HL DE не важен*/true, /*Стек освобождать не надо*/self);
  bc().add_hl_de();
  popTmpPokeHL(self);
}
     