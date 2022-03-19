#include <orion/bios.h>

void putch(char) {
  asm {
    mov c, a
    call 0F809h
  }
}
