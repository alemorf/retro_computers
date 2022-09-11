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

int8_t __fastcall strcmp(const char string1[], const char string2[]) {
    asm {
        ex hl, de           ; de = string2
        ld hl, (strcmp_1_a) ; hl = string1
strcmp_1:
        ld a, (de)
        cp (hl)
        jp nz, strcmp_2
        inc hl
        inc de
        or a
        jp nz, strcmp_1
        ret
strcmp_2:
        ccf
        sbc a
        ret c
        inc a
    }
}
