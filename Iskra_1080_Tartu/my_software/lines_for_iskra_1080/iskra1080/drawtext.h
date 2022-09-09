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

static const uint8_t TEXT_WIDTH = 64;
static const uint8_t TEXT_HEGIHT = 25;

#define DRAWTEXTARGS(X, Y) ((uint8_t*)0xFFFF - ((Y)*10) - (((X)*3 / 4) * 256)), (X)&3

void SetTextColor(uint8_t color);
void DrawText(uint8_t x, uint8_t y, uint8_t n, const char* text);
void DrawText1(uint8_t* d, uint8_t st, uint8_t n, const char* text);
