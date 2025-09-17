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

char *__fastcall strcpy(char *destination, const char *source) {
    (void)destination;
    (void)source;
    asm {
        ex hl, de             ; de = source
        ld hl, (__a_1_strcpy) ; hl = destination
strcpy_1:
        ld a, (de)
        ld (hl), a
        inc hl
        inc de
        or a
        jp nz, strcpy_1
        ld hl, (__a_1_strcpy) ; return destination;
    }
}
