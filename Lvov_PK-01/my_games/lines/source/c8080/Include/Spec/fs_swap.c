#include <spec/fs.h>
#include <spec/fs_open0.h>

uchar fs_swap() {
  return fs_open0("", O_SWAP);
}