/*
 * Iskra 1080 Extension card firmware
 * Copyright (c) 2026 Aleksey Morozov aleksey.f.morozov@gmail.com aleksey.f.morozov@yandex.ru
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

#include <cmm.h>
#include "drawcursor4.h"
#include "../graph.h"

void DrawCursor4(/* hl - coords */) {
    /* Calculate address */
    a = h;
    a |= a;
    carry_rotate_right(a);
    invert(a);
    d = a;
    a = l;
    a *= 4;
    a += l;
    a += a;
    invert(a);
    e = a;

    /* Calculate mask */
    b = 0x0F;
    if (flag_z((a = h) &= 1))
        b = 0xF0;

    /* XOR draw */
    c = FONT_HEIGHT;
    do {
        *de = ((a = *de) ^= b);
        e--;
    } while (flag_nz(c--));
}
