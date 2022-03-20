#include <spec/fs.h>
#include <spec/fs_open0.h>

uchar fs_create(const char* name) {
  return fs_open0(name, O_CREATE);
}
