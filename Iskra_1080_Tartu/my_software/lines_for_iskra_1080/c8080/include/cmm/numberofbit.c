#include <cmm/numberofbit.h>

uint8_t NumberOfBit(uint8_t b) {
    asm {
        ld e, 0
        ld d, 7
NumberOfBit_0:
        rra
        jp c, NumberOfBit_1
        inc e
        dec d
        jp nz, NumberOfBit_0
NumberOfBit_1:
        ld a, e
    }
}
