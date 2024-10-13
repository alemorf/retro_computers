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

void *__fastcall memcpy(void *destination, const void *source, size_t size) {
    (void)destination;
    (void)source;
    (void)size;
    asm {
        push bc
        ex hl, de             ; de = size
        ld hl, (__a_2_memcpy) ; bc = source
        ld c, l
        ld b, h
        ld hl, (__a_1_memcpy) ; hl = destination
        inc d                 ; enter loop
        xor a
        or e
        jp z, memcpy_2
memcpy_1:
        ld a, (bc)
        ld (hl), a
        inc hl
        inc bc
        dec e                 ; end loop
        jp nz, memcpy_1
memcpy_2:
        dec d
        jp nz, memcpy_1
        pop bc
        ld hl, (__a_1_memcpy) ; return destination
    }
}
