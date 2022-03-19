#include <apogey/video.h>
                             
void print2n(uchar* dest, uchar len, char* text) {
  asm {
    push b
    xchg
    lhld print2n_1
    lda print2n_2
    mov b, a
print2n_loop:
    ldax d
    ora  a
    jz   print2n_ret
    ani  07Fh
    mov  m, a
    inx  h
    inx  d
    dcr b
    jnz  print2n_loop 
print2n_ret:
    pop b
  }
}
