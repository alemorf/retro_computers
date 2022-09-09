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
#include <stdbool.h>

static const uint8_t KEY_F1 = 0x01;
static const uint8_t KEY_F2 = 0x02;
static const uint8_t KEY_F3 = 0x03;
static const uint8_t KEY_RUS = 0x04;
static const uint8_t KEY_LAT = 0x05;
static const uint8_t KEY_COP = 0x06;
static const uint8_t KEY_SHIFT = 0x07;
static const uint8_t KEY_BACKSPACE = 0x08;  // Совпадает со стандартным кодом
static const uint8_t KEY_TAB = 0x09;        // Совпадает со стандартным кодом
static const uint8_t KEY_NUM_LOCK = 0x0A;
static const uint8_t KEY_CAPS = 0x0B;
static const uint8_t KEY_DEL = 0x0C;
static const uint8_t KEY_ENTER = 0x0D;  // Совпадает со стандартным кодом
static const uint8_t KEY_HOME = 0x0E;
static const uint8_t KEY_END = 0x0F;
static const uint8_t KEY_CTRL = 0x10;
static const uint8_t KEY_RIGHT_5 = 0x11;
static const uint8_t KEY_PGUP = 0x12;
static const uint8_t KEY_PGDN = 0x13;
static const uint8_t KEY_UNKNOWN1 = 0x14;
static const uint8_t KEY_UNKNOWN2 = 0x15;
// Сводобный код 0x16
static const uint8_t KEY_UP = 0x17;
static const uint8_t KEY_RIGHT = 0x18;
static const uint8_t KEY_LEFT = 0x19;
static const uint8_t KEY_DOWN = 0x1A;
static const uint8_t KEY_ESC = 0x1B;  // Совпадает со стандартным кодом
// Сводобный код 0x1C
// Сводобный код 0x1D
// Сводобный код 0x1E
// Сводобный код 0x1F

uint8_t ReadKeyboard(bool noWait);
