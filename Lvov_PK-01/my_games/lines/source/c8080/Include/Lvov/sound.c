#include <lvov/bda.h>

void sound(uchar note, uchar delay) {
  asm {  
    mov d, a
    lda sound_1
    mov l, a
    push b
    call 0F81Eh
    pop b
  }
}
