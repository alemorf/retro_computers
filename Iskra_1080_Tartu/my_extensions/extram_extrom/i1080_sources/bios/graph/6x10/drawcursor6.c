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
#include "drawcursor6.h"
#include "../graph.h"

void DrawCursor6(/* hl - coords */) {
    /* Calculate mask */
    a = h;
    a &= 3;
    if (flag_z)
        de = 0x00FC;
    else if (flag_z(a--))
        de = 0xF003;
    else if (flag_z(a--))
        de = 0xC00F;
    else
        de = 0x003F;

    /* Calculate address */
    a = l;
    a *= 4;
    a += l;
    a *= 2;
    invert(a);
    l = a;
    a = h;
    a += a;
    a += h;
    cyclic_rotate_right(a, 2);
    a &= 0x3F;
    invert(a);
    h = a;

    /* XOR draw */
    c = FONT_HEIGHT;
    do {
        *hl = ((a = *hl) ^= e);
        h--;
        *hl = ((a = *hl) ^= d);
        h++;
        l--;
    } while (flag_nz(c--));
}
