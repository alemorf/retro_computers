#include <radio86rk/bios.h>

void clrscr() {
  asm {
    mvi c, 1Fh
    call 0F809h
  }
}
