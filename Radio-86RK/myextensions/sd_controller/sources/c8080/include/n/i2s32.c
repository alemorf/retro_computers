#include <n.h>
#include <32.h>
#include <stdlib.h>

void i2s32(char* buf, ulong* src, uint n, uchar spc) {
  ulong v;
  set32(&v, src);

  buf += n;  
  *buf = 0;

  while(1) {
    div32_16(&v, 10);
    --buf;
    *buf = "0123456789ABCDEF"[op_div16_mod];
    if(--n == 0) return;
    if(((ushort*)&v)[0] == 0 && ((ushort*)&v)[1] == 0) break;
  }

  while(1) {
    --buf;
    *buf = spc;
    if(--n == 0) break;
  }
}
