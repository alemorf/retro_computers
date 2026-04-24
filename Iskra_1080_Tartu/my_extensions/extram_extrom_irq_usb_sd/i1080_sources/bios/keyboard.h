/*
 * Iskra 1080 Extension card firmware
 * Keyboard driver
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

extern uint8_t frame_counter;
extern uint8_t key_rus;

static const int MOD_CTR = 1;
static const int MOD_SHIFT = 2;
static const int MOD_CAPS = 0x10;
static const int MOD_NUM = 0x20;

#define KEY_BUFFER_SIZE 16

void ReadKeyboard();
void CheckKeyboard();
