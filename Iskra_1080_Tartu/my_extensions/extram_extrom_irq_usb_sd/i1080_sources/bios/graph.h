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

#include "../i1080.h"

static const int TEXT_SCREEN_HEIGHT = 25;
static const int FONT_HEIGHT = 10;
static const int FONT_WIDTH = 3;

extern uint8_t text_screen_width;

extern uint16_t DrawCharAddress __address("drawchar + 1");
extern uint16_t SetColorAddress __address("setcolor + 1");
extern uint16_t DrawCursorAddress __address("drawcursor + 1");

void SetScreenBw6();
void SetScreenColor6();
void SetColor(...);
void SetColorSave(...);
void ClearScreen();
void DrawText(...);
void DrawChar(...);
void DrawCursor(...);
void ScrollUp(...);

void SetScreenBw();
void SetScreenColor();
