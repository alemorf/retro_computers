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

extern uint16_t storage_sector_512;

extern uint8_t storage_buffer_changed;
extern uint8_t storage_buffer_storage;
extern uint16_t storage_buffer_track;
extern uint16_t storage_buffer_sector_512;
extern uint8_t storage_buffer[512];

static const uint16_t STORAGE_512_READ = 0x0101;  /* Чтение */
static const uint16_t STORAGE_512_WRITE = 0x0001; /* Запись */
static const uint16_t STORAGE_512_FIRST_WRITE = 0x0000; /* Запись в блок не содержащий полезных данных */

void Storage512(/* bc = STORAGE_512_ */);
