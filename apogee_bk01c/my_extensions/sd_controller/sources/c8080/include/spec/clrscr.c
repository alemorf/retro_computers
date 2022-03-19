#include <spec/bios.h>

void clrscr() {
  putch(0x1F);
}