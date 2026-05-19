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
#include "graph.h"
#include "scrollup.h"

uint8_t text_screen_width;
uint8_t color_enabled;

void DrawChar(/* hl - coords, a - char */) {
    DrawChar(hl, a);
}

void SetColor(/* a - color */) {
    b = a;

    cyclic_rotate_right(a, 3);
    hl = 0;
    if (flag_c)
        hl = 0xFFFF;
    color_plane_0_16 = hl;

    cyclic_rotate_right(a, 1);
    hl = 0;
    if (flag_c)
        hl = 0xFFFF;
    color_plane_1_16 = hl;

    a = b;

set_text_color:
    SetColor(a);
}

void DrawCursor(/* hl - coords */) {
    DrawCursor(hl);
}
