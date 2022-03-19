#include <apogey/bios.h>

void clrscr() {
  asm {
    mvi c, 1Fh
    call 0F809h
  }
}
