#include <spec/fs.h>

void fs_reboot() {
  fs_exec("","");
  asm {
    jmp 0C000h
  }
}
