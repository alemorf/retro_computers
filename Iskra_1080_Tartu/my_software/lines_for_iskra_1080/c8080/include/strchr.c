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

const char* __fastcall strchr(const char string[], char what) {
    (void)string;
    (void)what;
    asm {
        ; d = what
        ld d, a
        ; hl = string
        ld hl, (strchr_1_a)
        ; loop
strchr_1:
        ld a, (hl)
        cp d
        ret z
        inc hl
        or a
        jp nz, strchr_1
        ; return 0;
        ld h, a
        ld l, a
    }
}
