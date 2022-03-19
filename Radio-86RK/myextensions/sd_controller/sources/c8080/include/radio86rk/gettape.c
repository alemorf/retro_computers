#include <radio86rk/bios.h>

uchar gettape(char) {
  asm {
    call 0F806h
  }
}
