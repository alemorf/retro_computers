#include <spec/fs.h>

uchar fs_exec(const char* fileName, const char* cmdLine) {
  asm {    
    PUSH B
    XCHG
    LHLD fs_exec_1
    XRA  A
    CALL fs_entry
    POP  B
  }
}
