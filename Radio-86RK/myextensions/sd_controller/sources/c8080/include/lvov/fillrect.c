#include <lvov/bda.h>

void fillRect(uchar x0, uchar y0, uchar x1, uchar y1, uchar c) {
  X1 = x0;
  Y1 = y0;
  X2 = x1;
  Y2 = y1;
  GRF_COLOR = c;                               
  asm {
    call 0F82Ah
  }
}
