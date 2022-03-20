#include <spec/fs.h>

uchar fs_getsize() { // fs_high:fs_low - размер
  return fs_seek(0, 0, 100);
}
