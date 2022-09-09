#include <stdlib.h>

uint8_t rand_seed = 0xFA;

uint8_t rand() {
    (void)rand_seed;
    asm {
        ld a, (rand_seed)
        ld b, a
        add a, a
        add a, a
        add a, b
        inc a
        ld (rand_seed), a
    }
}
