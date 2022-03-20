#include <spec/fs.h>

uchar fs_findnext(FileInfo* dest, uint size) {  
  return fs_findfirst(":", dest, size);
}
