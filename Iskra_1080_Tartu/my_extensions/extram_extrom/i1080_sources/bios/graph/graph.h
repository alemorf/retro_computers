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

#include <stdint.h>
#include "4x10/setmode.h"
#include "6x10/setmode.h"

static const uint8_t TEXT_SCREEN_HEIGHT = 25;
static const uint16_t FONT_HEIGHT = 10;

extern uint8_t text_screen_width;
extern uint8_t color_enabled;

void ClearScreen(void);
void ScrollUp(void);
void SetColor(/* a - color */);
void SetColorSafe(/* a - color */);
void DrawChar(/* hl - coords, a - char */);
void DrawCursor(/* hl - coords */);
void DrawText(/* de - coords, hl - text */);
