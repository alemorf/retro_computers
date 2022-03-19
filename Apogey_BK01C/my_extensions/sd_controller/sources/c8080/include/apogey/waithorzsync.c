#include <apogey/video.h>

void waitHorzSync() {
  asm {
    lxi h, 0EF01h
    mov a, m
waitHorzSync_1:
    mov a, m
    ani 20h
    jz waitHorzSync_1
  }
}

