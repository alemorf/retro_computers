// Умножение A на константу

#include <stdafx.h>
#include "common.h"
#include "asm.h"

void mulA(int x) {
  // bc().remark("Умножение A на "+i2s(x));

  if(x==5) {
    bc().ld_d_a().add_a().add_a().alu_d(c_add_r);
    return;
  }

  if(x==1 || x==2 || x==4 || x==8 || x==0x10 || x==0x20 || x==0x40 || x==0x80) { 
    for(; x!=1; x/=2) 
      bc().add_a();
    return; 
  }

  p.logicError_("Установите размер структуры равный степени двойки, сейчас размер равен "+i2s(x));
}
