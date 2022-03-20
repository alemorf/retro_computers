#include <fs/fs.h>
#include <fs/fs_open0.h>

uchar fs_create(const char* name) {
  return fs_open0(name, O_CREATE);
}
