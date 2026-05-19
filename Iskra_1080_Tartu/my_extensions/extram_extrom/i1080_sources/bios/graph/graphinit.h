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

#pragma once

#include <cmm.h>
#include <stdint.h>
#include "graph.h"

static const uint16_t SCREEN_SIZE = 0x3000;
static const uint16_t BITPLANE_OFFSET = 0x4000;
static const uint8_t SCREEN_WIDTH_BYTES = 48;
static const uint16_t SCREEN_HEIGHT_BYTES = 256;

extern uint16_t draw_char __address("drawchar + 1");
extern uint16_t set_color __address("set_text_color + 1");
extern uint16_t draw_cursor __address("drawcursor + 1");

extern uint16_t color_plane_0_16 __address("color_plane_0_16_ + 1");
extern uint16_t color_plane_1_16 __address("color_plane_1_16_ + 1");

static const uint8_t GRAPH_INIT_1_BITPLANE = 0;
static const uint8_t GRAPH_INIT_2_BITPLANES = 1;

void GraphInit(/* a - text screen width, b - GRAPH_INIT_?_BITPLANE, hl - DrawCursorAddress */);
