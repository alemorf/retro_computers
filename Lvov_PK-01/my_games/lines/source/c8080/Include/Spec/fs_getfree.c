#include <spec/fs.h>

uchar fs_getfree() { // fs_high:fs_low - размер в ћб
  return fs_seek(0, 0, 102);
}
