#include <lvov/bda.h>

void pset(uchar x, uchar y, uchar c) {
  X1 = x;
  Y1 = y;
  GRF_COLOR = c;                               
  asm {
    call 0F821h
  }
}
