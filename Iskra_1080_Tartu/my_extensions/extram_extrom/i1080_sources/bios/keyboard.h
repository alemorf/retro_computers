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

static const uint8_t MOD_CTR = 1;
static const uint8_t MOD_SHIFT = 2;
static const uint8_t MOD_CAPS = 0x10;
static const uint8_t MOD_NUM = 0x20;

static const uint8_t KEY_BUFFER_SIZE = 16;

extern uint8_t key_rus;
extern uint8_t key_buffer[KEY_BUFFER_SIZE];

/* Есть ли буфере клавиатуры нажатые клавиши? */
/* Если буфер пуст, то выход с флагом Z */
void CheckKeyboard(void);

/* Получить код нажатой клавиши из буфера клавиатуры в A */
/* Если буфер пуст, то выход с флагом Z */
void ReadKeyboard(void);

void KeyboardInterrupt(void);
