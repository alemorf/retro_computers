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

#include <string.h>

void* __fastcall memmove(void* destination, const void* source, size_t size) {
    (void)memcpy;  // Link
    (void)destination;
    (void)source;
    (void)size;
    asm {
        ex hl, de            ; de = size
        ld hl, memmove_2_a   ; if (destination > source) goto memmove_3
        ld a, (memmove_1_a)
        sub (hl)
        inc hl
        ld a, (memmove_1_a + 1)
        sbc (hl)
        jp nc, memmove_3
        ld hl, (memmove_1_a) ; return memcpy(destination, source, size`)
        ld (memcpy_1_a), hl
        ld hl, (memmove_2_a)
        ld (memcpy_2_a), hl
        ex hl, de
        jp memcpy

memmove_3:
        push bc
        ld hl, (memmove_2_a) ; bc = source
        add hl, de
        ld c, l
        ld b, h
        ld hl, (memmove_1_a) ; hl = destination
        add hl, de
        inc d                ; enter loop
        xor a
        or e
        jp z, memmove_2
memmove_1:
        dec hl
        dec bc
        ld a, (bc)
        ld (hl), a
        dec e                ; end loop
        jp nz, memmove_1
memmove_2:
        dec d
        jp nz, memmove_1
        pop bc
    }
}
