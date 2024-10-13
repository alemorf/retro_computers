/*
 * c8080 stdlib
 * Copyright (c) 2022 Aleksey Morozov aleksey.f.morozov@gmail.com aleksey.f.morozov@yandex.ru
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

#include <string.h>

int8_t __fastcall memcmp(const void *buffer1, const void *buffer2, size_t size) {
    (void)buffer1;
    (void)buffer2;
    (void)size;
    asm {
        push bc
        ex hl, de             ; de = size
        ld hl, (__a_1_memcmp) ; bc = buffer1
        ld b, h
        ld c, l
        ld hl, (__a_2_memcmp) ; hl = buffer2
        inc d                 ; Enter loop
        xor a
        or e
        jp z, memcmp_2
memcmp_1:
        ld a, (bc)            ; if (buffer1[i] != buffer2[i]) goto memcmp_3
        cp (hl)
        jp nz, memcmp_3
        inc hl
        inc bc
        dec e                 ; End loop
        jp nz, memcmp_1
memcmp_2:
        dec d
        jp nz, memcmp_1
        xor a                 ; return 0;
        pop bc
        ret

memcmp_3:
        pop bc
        sbc a                 ; return buffer1[i] < buffer2[i] ? -1 : 1;
        ret c
        inc a
    }
}
