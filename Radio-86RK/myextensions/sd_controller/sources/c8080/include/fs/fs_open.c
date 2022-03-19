#include <fs/fs.h>
#include <fs/fs_open0.h>

uchar fs_open(const char* name) {
  return fs_open0(name, O_OPEN);
}
