#include <spec/fs.h>

uchar fs_gettotal() { // fs_high:fs_low - размер в ћб
  return fs_seek(0, 0, 101);
}
