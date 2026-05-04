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
#include "setmode.h"
#include "../graphinit.h"
#include "drawcursor6.h"
#include "drawchar6.h"

static void SetGraphMode6x10(/* a, b */);

void SetGraphModeBw6x10(void) {
    SetGraphMode6x10(a = DRAW_CHAR_6_BW_INIT, b = GRAPH_INIT_1_BITPLANE);
}

void SetGraphModeColor6x10(void) {
    SetGraphMode6x10(a = DRAW_CHAR_6_COLOR_INIT, b = GRAPH_INIT_2_BITPLANES);
}

static void SetGraphMode6x10(/* a, b */) {
    DrawChar6Init(a);
    GraphInit(a = 64 /* Text width */, b, hl = DrawCursor6);
}
