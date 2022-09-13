/*
 * i8080 stdlib
 * Copyright (c) 2022 Aleksey Morozov
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include <unistd.h>
#include <stdint.h>

#ifdef ARCH_ISKRA_1080_TARTU
int __fastcall putchar(int c) {
    asm {
        ld a, l
        cp 0Ah
        ld a, 0Dh
        call z, 0C7F0h
        ld a, l
        call 0C7F0h
        ld h, 0
    }
}
#endif

#ifdef ARCH_CPM
static void __fastcall cpmBiosConOut(uint8_t c) {
    asm {
        ld c, a
        ld hl, (1)
        ld l, 0Ch
        jp hl
    }
}

int __fastcall putchar(int c) {
    if (c == 0x0A) cpmBiosConOut(0x0D);
    cpmBiosConOut(c);
    return 0;
}
#endif
