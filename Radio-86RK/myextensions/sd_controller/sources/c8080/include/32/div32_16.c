// Разделить 32-х битное на 16-битное

#include <n.h>
#include <stdlib.h>

void div32_16(ulong* a, uint b) {
  uint tmp;

  ((ushort*)a)[1] = ((ushort*)a)[1] / b;

  ((uchar*)&tmp)[1] = op_div16_mod;
  ((uchar*)&tmp)[0] = ((uchar*)a)[1];
  ((uchar*)a)[1] = tmp / b;

  ((uchar*)&tmp)[1] = op_div16_mod;
  ((uchar*)&tmp)[0] = ((uchar*)a)[0];
  ((uchar*)a)[0] = tmp / b;
}
