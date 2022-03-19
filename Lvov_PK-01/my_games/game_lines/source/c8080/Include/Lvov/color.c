#include <lvov/bda.h>

void color(uchar palette, uchar bgcolor) {
  PALETTE = palette;
  GROUND_COLOR = bgcolor;
  asm {
    call 0F833h
  }
}
