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
#include "i1080.h"

static const uint8_t PAGE_BIOS_0 = PAGE_RAM(0);
static const uint8_t PAGE_BIOS_1 = PAGE_RAM(1);
static const uint8_t PAGE_RAM_DISK = 2; /* 2, 3 */
static const uint8_t PAGE_PACKED_CPM = PAGE_ROM(3);
static const uint8_t PAGE_CPM_0 = PAGE_RAM(4);
static const uint8_t PAGE_CPM_1 = PAGE_RAM(5);
static const uint8_t PAGE_CPM_2 = PAGE_RAM(6);
static const uint8_t PAGE_CPM_3 = PAGE_RAM(7);

#define WINDOW_ADDDRESS(N) (0x4000 * (N))

/* Константы в ПЗУ */
extern uint16_t bios_offset_in_rom __address(0x800A);
extern uint16_t cpm_offset_in_rom __address(0x800C);
extern uint16_t storage_offset_in_rom __address(0x800E);

static const uint8_t CPM_SECTOR_SIZE = 128;

/* Общие переменные для CP/M и BIOS в PAGE_CPM_3 */
extern uint16_t bios_dpb __address(0xFF79);
extern uint8_t bios_storage __address(0xFF7B);
extern uint16_t bios_track __address(0xFF7C);
extern uint16_t bios_sector_128 __address(0xFF7E);
extern uint8_t bios_buffer[128] __address(0xFF80);
