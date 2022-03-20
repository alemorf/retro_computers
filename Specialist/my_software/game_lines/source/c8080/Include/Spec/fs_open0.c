#include <spec/fs.h>
#include <spec/fs_open0.h>

uchar fs_open0(const char* name, uchar mode) {
  asm {      
    PUSH B
    ; a = fs_open0_2
    MOV  D, A 
    LHLD fs_open0_1
    MVI  A, 2
    CALL fs_entry
    POP  B
  }
}
