#include <radio86rk/video.h>
                             
void printm(uchar x, uchar y, uchar len, char* text) {
  print2m(charAddr(x, y), len, text);
}
