#include <radio86rk/video.h>
                             
void print2m(uchar* dest, uchar len, char* text) {
  asm {
    push b
    xchg
    lhld print2m_1
    lda print2m_2
    mov b, a
print2m_loop:
    ldax d
    ora  a
    jz   print2m_ret
    inx  d
print2m_ret:
    ani  07Fh
    mov  m, a
    inx  h
    dcr b
    jnz  print2m_loop 
    pop b
  }
}
