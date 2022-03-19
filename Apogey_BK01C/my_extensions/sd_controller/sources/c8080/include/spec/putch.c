#include <spec/bios.h>

void putch(char) {
  asm {
    mov c, a
    call 0C809h
  }
}
