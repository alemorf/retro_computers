#include <apogey/video.h>
#include <apogey/screen_constrcutor.h>

void directCursor(uchar x, uchar y) {
  VG75[1] = 0x80;
  VG75[0] = x;
  VG75[0] = y;
}
