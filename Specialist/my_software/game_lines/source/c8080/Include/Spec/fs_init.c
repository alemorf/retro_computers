#include <spec/fs.h>

const char* fs_cmdLine;
const char* fs_selfName;
uint        fs_low;
uint        fs_high;
uchar       fs_addr;

void fs_init() {
  asm {
    SHLD fs_cmdLine
    XCHG
    SHLD fs_selfName
    MOV H, B
    MOV L, C
    SHLD fs_entry_n+1
  }
}

void fs_entry() {
  asm {
fs_entry_n:
    JMP 0000h
  }
}
