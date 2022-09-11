/*
 * Game "Color Lines" for Iskra 1080 Tartu
 * Copyright (c) 2022 Aleksey Morozov
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
#include <c8080/c8080.h>

#define FILLRECTARGS(X0, Y0, X1, Y1)                                                                      \
    (uint8_t*)(0xFFFF - ((X0) / 8) * 256 - (Y0)), ((X1) + 1) / 8 - (X0 / 8), (0xFF >> ((uint8_t)(X0)&7)), \
        (0xFF >> ((uint8_t)((X1) + 1) & 7)) ^ 0xFF, (Y1) - (Y0) + 1

void __fastcall SetFillRectColor(uint8_t color);
void __fastcall FillRect1(uint8_t* graphAddress, uint16_t width, uint8_t left, uint8_t right, uint8_t height);
void __fastcall FillRect(uint16_t x0, uint8_t y0, uint16_t x1, uint8_t y1);
