#include <lvov/bda.h>

void paint(uchar x, uchar y, uchar c, uchar borderColor) {
  BRD_COLOR = borderColor;
  X1 = x;
  Y1 = y;
  GRF_COLOR = c;
  asm {
    call 0F830h
  }
}
