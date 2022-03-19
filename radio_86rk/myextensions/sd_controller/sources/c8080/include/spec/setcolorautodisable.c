#include "mem.h"

void setColorAutoDisable() {
  if(memchr8((void*)0xC000, 0xFB, 16) == 0) {
    asm {
      MVI A, 0C9h
      STA setColor
    }    
  }
}    
