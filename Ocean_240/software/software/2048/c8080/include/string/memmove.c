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

void *__fastcall memmove(void *destination, const void *source, size_t size) {
    (void)memcpy;  // Link
    (void)destination;
    (void)source;
    (void)size;
    asm {
        ex hl, de              ; de = size
        ld hl, __a_2_memmove   ; if (destination > source) goto memmove_3
        ld a, (__a_1_memmove)
        sub (hl)
        inc hl
        ld a, (__a_1_memmove + 1)
        sbc (hl)
        jp nc, memmove_3
        ld hl, (__a_1_memmove) ; return memcpy(destination, source, size`)
        ld (__a_1_memcpy), hl
        ld hl, (__a_2_memmove)
        ld (__a_2_memcpy), hl
        ex hl, de
        jp memcpy

memmove_3:
        push bc
        ld hl, (__a_2_memmove) ; bc = source
        add hl, de
        ld c, l
        ld b, h
        ld hl, (__a_1_memmove) ; hl = destination
        add hl, de
        inc d                  ; enter loop
        xor a
        or e
        jp z, memmove_2
memmove_1:
        dec hl
        dec bc
        ld a, (bc)
        ld (hl), a
        dec e                  ; end loop
        jp nz, memmove_1
memmove_2:
        dec d
        jp nz, memmove_1
        pop bc
    }
}
