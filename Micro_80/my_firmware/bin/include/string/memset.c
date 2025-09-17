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

void *__fastcall memset(void *destination, uint8_t byte, size_t size) {
    (void)destination;
    (void)byte;
    (void)size;
    asm {
        ex hl, de             ; de = size
        ld hl, (__a_1_memset) ; hl = destination
        inc d                 ; enter loop
        xor a
        or e
        ld a, (__a_2_memset)  ; bc = byte
        jp z, memset_2
memset_1:
        ld (hl), a
        inc hl
        inc bc
        dec e               ; end loop
        jp nz, memset_1
memset_2:
        dec d
        jp nz, memset_1
        ld hl, (__a_1_memset) ; return destination
    }
}
