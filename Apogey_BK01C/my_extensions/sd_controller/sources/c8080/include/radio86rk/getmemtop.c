#include <radio86rk/bios.h>

int getMemTop() {
  asm {
    call 0F830h
  }
}
