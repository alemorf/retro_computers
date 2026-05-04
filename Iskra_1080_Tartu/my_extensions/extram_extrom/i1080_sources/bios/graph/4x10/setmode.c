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
#include "drawcursor4.h"
#include "drawchar4.h"

static void SetGraphMode4x10(/* a, b */);

void SetGraphModeBw4x10(void) {
    SetGraphMode4x10(a = DRAW_CHAR_4_BW_INIT, b = GRAPH_INIT_1_BITPLANE);
}

void SetGraphModeColor4x10(void) {
    SetGraphMode4x10(a = DRAW_CHAR_4_COLOR_INIT, b = GRAPH_INIT_2_BITPLANES);
}

static void SetGraphMode4x10(/* a, b */) {
    DrawChar4Init(a);
    GraphInit(a = 96 /* Text width */, b, hl = &DrawCursor4);
}
