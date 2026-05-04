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

#include "../../opcodes_8080.h"

static const uint8_t DRAW_CHAR_4_BW_INIT = OPCODE_RET;
static const uint8_t DRAW_CHAR_4_COLOR_INIT = OPCODE_LD_A_D;

void DrawChar4Init(/* a = DRAW_CHAR_4_BW_INIT/DRAW_CHAR_4_COLOR_INIT */);
