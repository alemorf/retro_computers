#include <string.h>

size_t __fastcall strlen(const char* string) {
    asm {
        ld de, -1
strlen_1:
        xor a, a
        or (hl)
        inc de
        inc hl
        jp nz, strlen_1
        ex hl, de
    }
}
