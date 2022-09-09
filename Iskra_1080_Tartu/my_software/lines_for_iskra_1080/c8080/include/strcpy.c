#include <string.h>

char* __fastcall strcpy(char* destination, const char* source) {
    asm {
        ex hl, de
        ld hl, (strcpy_1_a)
strcpy_l1:
        ld a, (de)
        ld (hl), a
        inc hl
        inc de
        or a
        jp nz, strcpy_l1
        ld hl, (strcpy_1_a)
    }
}
