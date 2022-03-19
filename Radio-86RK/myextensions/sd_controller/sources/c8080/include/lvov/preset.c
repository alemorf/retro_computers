#include <lvov/bda.h>

void preset(uchar x, uchar y) {
  X1 = x;
  Y1 = y;
  asm {
    push b
    call 0F020h
    pop b
  }
}
