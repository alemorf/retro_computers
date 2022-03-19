#include <apogey/video.h>
                             
void print2(uchar* dest, char* text) {
  asm {
    xchg
    lhld print2_1
print2_loop:
    ldax d
    ora  a
    rz
    ani  07Fh
    mov  m, a
    inx  h
    inx  d
    jmp  print2_loop
  }
}
