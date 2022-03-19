#include <apogey/video.h>
                             
uchar* charAddr(uchar x, uchar y) {
  return apogeyVideoMem + y * apogeyVideoBpl + x;
}
