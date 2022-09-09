#include <string.h>

const char* __fastcall strchr(const char* d, char s) {
    asm {
        ld d, a
        ld hl, (strchr_1_a)
strchr_l1:
        ld a, (hl)
        cp d
        ret z
        inc hl
        or a
        jp nz, strchr_l1
        ld h, a  ; hl = 0
        ld l, a
    }
}
