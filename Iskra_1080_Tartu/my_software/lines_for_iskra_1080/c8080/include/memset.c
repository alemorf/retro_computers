#include <string.h>

void __fastcall memset(void* destination, uint8_t byte, size_t size) {
    asm {
    ld a, (memset_2_a)
    ex hl, de
    ld hl, (memset_1_a)
    ex hl, de
    ld bc, -1
memset_l1:
    add hl, bc
    ret nc
    ld (de), a
    inc de
    jp memset_l1
    }
}
