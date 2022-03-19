#include <apogey/video.h>
                             
void printn(uchar x, uchar y, uchar len, char* text) {
  print2n(charAddr(x, y), len, text);
}
