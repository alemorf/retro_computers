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

extern uint8_t cursor_blink_counter;
extern uint8_t cursor_visible;
extern uint8_t cursor_y;
extern uint8_t cursor_x;

extern uint8_t con_color_0;
extern uint8_t con_color_1;
extern uint8_t con_color_2;
extern uint8_t con_color_3;

void ConSetXlat(...);
void ConClear();
void ConReset();
void ConNextLine();
void ConUpdateColor();
void CpmConout(/*c*/);
void CpmConst(void);
void CpmConin(void);
