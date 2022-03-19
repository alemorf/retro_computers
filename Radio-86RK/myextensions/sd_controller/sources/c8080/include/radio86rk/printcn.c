#include <radio86rk/video.h>
                             
void printcn(uchar x, uchar y, uchar len, char c) {
  print2cn(charAddr(x, y),len, c);
}
