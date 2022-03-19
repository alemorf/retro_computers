#include <apogey/bios.h>

char kbhit() {
  asm {
    call 0F81Bh
    inr a
  }
}