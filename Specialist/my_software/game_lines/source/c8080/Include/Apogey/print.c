#include <apogey/video.h>
                             
void print(uchar x, uchar y, char* text) {
  uchar* dest = apogeyVideoMem + y * apogeyVideoBpl + x;
  for(;*text; ++text, ++dest)
    *dest = *text;
}
