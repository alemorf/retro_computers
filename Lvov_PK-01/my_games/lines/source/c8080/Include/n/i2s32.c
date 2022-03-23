#include <n.h>
#include <stdlib.h>

void i2s32(char* buf, uint n, ulong* val, uchar spc) {
  buf += n;  
  *buf = 0;

  div32_l = ((ushort*)val)[0];
  div32_h = ((ushort*)val)[1];

  while(1) {
    div32(10);
    --buf;
    *buf = "0123456789ABCDEF"[op_div16_mod];
    if(--n==0) return;
    if(div32_l == 0 && div32_h == 0) break;
  }

  while(1) {
    --buf;
    *buf = spc;
    if(--n == 0) break;
  }
}
