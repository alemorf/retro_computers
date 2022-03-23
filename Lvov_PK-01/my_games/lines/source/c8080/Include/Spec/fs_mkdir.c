#include <spec/fs.h>
#include <spec/fs_open0.h>

uchar fs_mkdir(const char* name) {
  return fs_open0(name, O_MKDIR);
}
