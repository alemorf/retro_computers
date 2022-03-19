#include <radio86rk/video.h>
                             
void print2cn(uchar* dest, uchar len, char c) {
  asm {
    ani  07Fh
    mov  d, a
    lda  print2cn_2    
    lhld print2cn_1
print2cn_loop:
    mov  m, d
    inx  h
    dcr  a
    jnz  print2cn_loop
  }
}
