#include <stdlib.h>

void i2s(char* buf, uint v, uint n, uchar spc) {
  buf += n;  
  *buf = 0;
  while(1) {
    v /= 10;
    --buf;
    *buf = "0123456789ABCDEF"[op_div16_mod];
    --n;
    if(n == 0) return;
    if(v == 0) break;
  }
  while(1) {
    --buf;
    *buf = spc;
    if(--n == 0) break;
  }
}
