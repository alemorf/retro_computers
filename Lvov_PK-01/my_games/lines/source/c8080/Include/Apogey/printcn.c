#include <apogey/video.h>
                             
void printcn(uchar x, uchar y, char c, uchar len) {
  uchar* dest = apogeyVideoMem + y * apogeyVideoBpl + x;
  for(;len; ++dest, --len)
    *dest = c;
}
