#include <spec/fs.h>

uchar fs_findfirst(const char* path, FileInfo* dest, uint size) {
  if(path[0] == '/') path++;
  asm {
    PUSH B
    ; hl = fs_findfirst_3
    XCHG
    LHLD fs_findfirst_2
    MOV  B, H  
    MOV  C, L
    LHLD fs_findfirst_1 
    MVI  A, 1
    CALL fs_entry
    SHLD fs_low
    POP  B
  }
}
