#include <spec/fs.h>

uchar fs_write(const void* buf, uint size) {
  asm {
    PUSH B
    ; hl = fs_write_2
    XCHG
    LHLD fs_write_1
    XCHG
    LDA  fs_addr
    MVI  A, 5
    CALL fs_entry ; HL-размер, DE-адрес / A-код ошибки
    POP  B    
  }
}
