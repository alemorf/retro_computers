#include <apogey/bios.h>

int getMemTop() {
  asm {
    call 0F830h
  }
}
