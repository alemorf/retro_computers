#include <string.h>

void __fastcall memcpy(void* arg1, const void* arg2, size_t arg3) {
    asm {
        ; if (cnt == 0) return
        ld a, h
        or l
        ret z
        ; de = count
        ex hl, de
        ; bc = from
        ld hl, (memcpy_2_a)
        ld c, l
        ld b, h
        ; hl = to
        ld hl, (memcpy_1_a)
        ; enter loop
        inc d
        xor a
        or e
        jp z, memcpy_l2
memcpy_l1:
        ; *dest = *src
        ld a, (bc)
        ld (hl), a
        ; dest++, src++
        inc hl
        inc bc
        ; while(--cnt)
        dec e
        jp nz, memcpy_l1
memcpy_l2:
        dec d
        jp nz, memcpy_l1
    }
}
