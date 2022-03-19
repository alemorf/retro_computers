#include <apogey/bios.h>

int crcTape(void* start, void*) {
  asm {
    push b
    xchg
    lhld crcTape_1
    call 0F82Ah
    mov h, b
    mov l, c
    pop b
  }
}
