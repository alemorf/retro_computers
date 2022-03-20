#include <stdafx.h>
#include "common.h"
#include "asm.h"

// Умножение HL на конастанту

void mulHL(int x) {
  bc().remark("Умножение HL на "+i2s(x));

  if(x==5) {
    bc().ld_de_hl().add_hl_hl().add_hl_hl().add_hl_de();
    return;
  }

  if(x==1 || x==2 || x==4 || x==8 || x==0x10 || x==0x20 || x==0x40 || x==0x80 || x==0x100 || x==0x200
  || x==0x400 || x==0x800 || x==0x1000 || x==0x2000 || x==0x4000 || x==0x8000) { 
    for(; x!=1; x/=2) 
      bc().add_hl_hl();
    return; 
  }
  p.logicError_("Установите размер структуры равный степени двойки, сейчас размер равен "+i2s(x));
}
