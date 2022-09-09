#include "string.h"

int8_t __fastcall memcmp(const void* buffer1, const void* buffer2, size_t size) {
    asm {
        ; if (len == 0) return 0;
        ld a, l
        or h
        ret z
        push bc
        ; de = len
        ex hl, de
        ; bc = d
        ld hl, (memcmp_1_a)
        ld b, h
        ld c, l
        ; hl = s
        ld hl, (memcmp_2_a)
        ; loop
memcmp_l1:
        ld a, (bc)
        cp (hl)
        jp nz, memcmp_stop
        inc hl
        inc bc
        dec de
        ld a, d
        or e
        jp nz, memcmp_l1
        pop bc
        ; a=0
        ret
memcmp_stop:
        pop bc
        sbc a
        ret c
        inc a
    }
}
