#include <lvov/bda.h>

void locate(uchar x, uchar y, uchar c) {
  LOC_COL = x;
  LOC_ROW = y;
  CURSOR1 = c;                               
  asm {
    call 0F82Dh
  }
}
