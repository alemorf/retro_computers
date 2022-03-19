#include <orion/bios.h>

void puthex(char) {
  asm {
    call 0F815h
  }
}
