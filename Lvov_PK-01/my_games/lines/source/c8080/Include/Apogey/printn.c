#include <apogey/video.h>
                             
void printn(uchar x, uchar y, char* text, uchar len) {
  uchar* dest = apogeyVideoMem + y * apogeyVideoBpl + x;
  for(;len; ++text, ++dest, --len)
    *dest = *text;
}
