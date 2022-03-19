#include <radio86rk/bios.h>

char kbhit() {
  asm {
    call 0F81Bh
    inr a
  }
}