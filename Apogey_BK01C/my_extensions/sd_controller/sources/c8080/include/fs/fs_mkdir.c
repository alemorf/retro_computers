#include <fs/fs.h>
#include <fs/fs_open0.h>

uchar fs_mkdir(const char* name) {
  return fs_open0(name, O_MKDIR);
}
