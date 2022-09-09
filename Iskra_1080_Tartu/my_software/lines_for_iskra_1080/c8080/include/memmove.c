#include <string.h>

void __fastcall memmove(void* arg1, const void* arg2, size_t arg3) {
    (void)memcpy;

    asm {
    ex hl, de
    ld hl, memmove_2_a
    ld a, (memmove_1_a)
    sub (hl)
    inc hl
    ld a, (memmove_1_a + 1)
    sbc (hl)
    jp nc, memmove_l3
    ld hl, (memmove_1_a)
    ld (memcpy_1_a), hl
    ld hl, (memmove_2_a)
    ld (memcpy_2_a), hl
    ex hl, de
    jp memcpy

memmove_l3:
    ; if(cnt==0) return
    ld a, d
    or e
    ret z
    ; bc = from
    ld hl, (memmove_2_a)
    add hl, de
    ld c, l
    ld b, h
    ; hl = to
    ld hl, (memmove_1_a)
    add hl, de
    ; enter loop
    inc d
    xor a
    or e
    jp z, memmove_l2
memmove_l1:
    ; dest--, src--
    dec hl
    dec bc
    ; *dest = *src
    ld a, (bc)
    ld (hl), a
    ; while(cnt)
    dec e
    jp nz, memmove_l1
memmove_l2:
    dec d
    jp nz, memmove_l1
    }
}
