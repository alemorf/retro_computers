#include <apogey/bios.h>

uchar gettape(char) {
  asm {
    call 0F806h
  }
}
