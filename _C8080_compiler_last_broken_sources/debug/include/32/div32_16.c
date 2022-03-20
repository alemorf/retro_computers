// Разделить 32-х битное на 16-битное

#include <n.h>
#include <stdlib.h>

uint div32_16_tmp;

void div32_16(ulong* a, uint b) {
  ((ushort*)a)[1] = ((ushort*)a)[1] / b;

  ((uchar*)&div32_16_tmp)[1] = op_div16_mod;
  ((uchar*)&div32_16_tmp)[0] = ((uchar*)a)[1];
  ((uchar*)a)[1] = div32_16_tmp / b;

  ((uchar*)&div32_16_tmp)[1] = op_div16_mod;
  ((uchar*)&div32_16_tmp)[0] = ((uchar*)a)[0];
  ((uchar*)a)[0] = div32_16_tmp / b;
}
