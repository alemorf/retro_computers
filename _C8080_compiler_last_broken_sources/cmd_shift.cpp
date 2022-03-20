// ок

#include <stdafx.h>
#include "stackLoadSave.h"
#include "asm.h"

void cmd_shr16_1(bool self, int x) {
  if(x<0 || x>=16) raise("Бессмысленно сдвигать на "+i2s(x)+" разрядов");

  // Без сдвига
  if(x==0) return;

  if(x==8) {
    if(stack.back().place == pBC) {
      if(self) {
        bc().remark("Сдвиг BC& на 8 вправо");
        bc().ld_c_b().ld_b(0);
        return;
      }
      bc().remark("Сдвиг BC на 8 вправо");
      useHL(); // Надо ли?
      asm_pop();
      bc().ld_l_b().ld_h(0);
      popTmpPokeHL(self);
      return;
    }
    bc().remark("Сдвиг на 8 вправо");
    pushPeekHL(self);
    bc().ld_l_h().ld_h(0);
    popTmpPokeHL(self);
    return;
  }

  if(x==1) {
    if(stack.back().place == pBC) {
      if(self) {
        bc().remark("Сдвиг BC& на 1 вправо");
        useA();
        bc().ld_a_b().clcf().rra().ld_b_a().ld_a_c().rra().ld_c_a();
        return;
      }
      useHL(); // Надо ли?
      asm_pop();
      bc().remark("Сдвиг BC на 1 вправо");
      bc().ld_a_b().clcf().rra().ld_h_a().ld_a_c().rra().ld_l_a();
      popTmpPokeHL(self);
      return;
    }
    bc().remark("Сдвиг на 1 вправо");
    pushPeekHL(self);
    bc().ld_a_h().clcf().rra().ld_h_a().ld_a_l().rra().ld_l_a();
    popTmpPokeHL(self);
    return;
  }

  bc().remark("Сдвиг вправо");
  pushPeekHL(self);
  bc().ld_de(x).call("op_shr16\r\n");
  popTmpPokeHL(self);
}

void cmd_shr8_1(bool self, int x) {
  if(x<0 || x>=8) raise("Бессмысленно сдвигать на "+i2s(x)+" разрядов");
  if(x==0 && self) return;
  if(x==1) {
    bc().remark("Сдвиг на 1 влево");
    pushPeekA(self);
    bc().clcf().rra();
    popTmpPokeA(self);
    return;
  }
  bc().remark("Сдвиг влево");
  pushPeekA(self);
  int p = 255>>x;
  for(;x>0; x--) bc().rra();
  bc().and(p);
  popTmpPokeA(self);
}

void cmd_shl16_1(bool self, int x) {
  if(x<0 || x>=16) raise("Бессмысленно сдвигать на "+i2s(x)+" разрядов");

  if(x==8) {
    if(stack.back().place == pBC) {
      if(self) {
        bc().remark("Сдвиг BC& на 8 влево");
        bc().ld_b_c().ld_c(0);
        return;
      }
      bc().remark("Сдвиг BC на 8 влево");
      useHL(); // Надо ли?
      asm_pop();
      bc().ld_h_c().ld_b(0);
      popTmpPokeHL(self);
      return;
    }
  }

  bc().remark("Сдвиг на "+i2s(x)+" влево");
  pushPeekHL(self);
  if(x>=8) { bc().ld_h_l().ld_l(0); x-=8; }
  for(;x>0; x--) bc().add_hl_hl();
  popTmpPokeHL(self);
}

void cmd_shl8_1(bool self, int x) {
  if(x<0 || x>=8) raise("Бессмысленно сдвигать на "+i2s(x)+" разрядов");

  bc().remark("Сдвиг на "+i2s(x)+" влево");
  pushPeekA(self);
  for(;x>0; x--) bc().add_a();
  popTmpPokeA(self);
}