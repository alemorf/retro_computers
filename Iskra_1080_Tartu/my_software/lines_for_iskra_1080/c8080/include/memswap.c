#include "string.h"

void __fastcall memswap(void* arg1, void* arg2, size_t arg3) {
    asm {
    push bc
    ; de = count
    ex hl, de
    ; bc = from
    ld hl, (memswap_2_a)
    ld c, l
    ld b, h
    ; hl = to
    ld hl, (memswap_1_a)
memswap_l1:
    ; if (cnt == 0) return
    ld a, d
    or a, e
    jp z, memswap_l2
    ; *dest = *src
    ld a, (bc)
    ld (memswap_v1), a
    ld a, (hl)
    ld (bc), a
    .db 36h ; mov (hl), const
memswap_v1:
    .db 0
    ; dest++, src++, cnt--
    inc hl
    inc bc
    dec de
    ; loop
    jp memswap_l1
memswap_l2:
    pop bc
    }
}
