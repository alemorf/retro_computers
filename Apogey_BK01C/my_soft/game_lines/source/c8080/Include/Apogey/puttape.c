#include <apogey/bios.h>

void puttape(char) {
  asm {
    mov c, a
    call 0F80Ch
  }
}
