#include <spec/fs.h>

uchar fs_read(void* buf, uint size) {
  asm {
    PUSH B
    ; hl = fs_read_2
    XCHG
    LHLD fs_read_1
    XCHG
    MVI  A, 4
    CALL fs_entry ; HL-размер, DE-адрес / HL-сколько загрузили, A-код ошибки
    SHLD fs_low
    POP  B    
  }
}
