#include <n.h>
#include <stdlib.h>

uint div32_l, div32_h;

void div32(uint v) {
  uint tmp;
  uchar am;
  div32_h /= v;
  ((uchar*)&tmp)[1] = op_div16_mod;
  ((uchar*)&tmp)[0] = ((uchar*)&div32_l)[1];
  ((uchar*)&div32_l)[1] = tmp / v;
  ((uchar*)&tmp)[1] = op_div16_mod;
  ((uchar*)&tmp)[0] = ((uchar*)&div32_l)[0];
  ((uchar*)&div32_l)[0] = tmp / v;
}
