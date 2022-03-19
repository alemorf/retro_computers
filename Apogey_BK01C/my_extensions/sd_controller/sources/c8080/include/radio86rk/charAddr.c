#include <radio86rk/video.h>
                             
uchar* charAddr(uchar x, uchar y) {
  return radio86rkVideoMem + y * radio86rkVideoBpl + x;
}
