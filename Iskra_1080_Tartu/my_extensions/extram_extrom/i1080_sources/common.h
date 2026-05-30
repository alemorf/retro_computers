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

/* Использование страниц памяти */
static const uint8_t PAGE_CPM_0 = PAGE_RAM(0);
static const uint8_t PAGE_CPM_1 = PAGE_RAM(1);
static const uint8_t PAGE_CPM_2 = PAGE_RAM(2);
static const uint8_t PAGE_CPM_3 = PAGE_RAM(3);
static const uint8_t PAGE_BIOS_0 = PAGE_RAM(4);
static const uint8_t PAGE_BIOS_1 = PAGE_RAM(5);
static const uint8_t PAGE_RAM_DISK = 6; /* 7... */
static const uint8_t PAGE_PACKED_CPM = PAGE_ROM(63);

/* Константы в ПЗУ */
extern uint16_t bios_offset_in_rom __address(0x800A);
extern uint16_t cpm_offset_in_rom __address(0x800C);
extern uint16_t storage_offset_in_rom __address(0x800E);
extern void UnpackMegaLz8000(/* hl - from addr, bc - to addr */) __address(0x8010);

/* Стек для функций BIOS */
static const uint16_t BIOS_STACK = 0x100;

/* Точки входа BIOS */
void BiosEntryInterrupt(void) __address(1 * 3);
void BiosEntryWBoot(/* c */) __address(2 * 3);
void BiosEntryConSt(void) __address(3 * 3);
void BiosEntryConIn(void) __address(4 * 3);
void BiosEntryConOut(/* c */) __address(5 * 3);
void BiosEntryList(/* c */) __address(6 * 3);
void BiosEntryPunch(/* c */) __address(7 * 3);
void BiosEntryReader(void) __address(8 * 3);
void BiosEntrySelDsk(/* c */) __address(9 * 3);
void BiosEntryRead(void) __address(10 * 3);
void BiosEntryWrite(/* c */) __address(11 * 3);
void BiosEntryPrStat(void) __address(12 * 3);

/* Общие переменные для CP/M и BIOS в PAGE_CPM_3 */
extern uint8_t common[0] __address(0xFF77);
extern uint8_t common_folder __address(0xFF77);
extern uint8_t common_dont_exec_nc __address(0xFF78);
extern uint16_t common_dpb __address(0xFF79);
extern uint8_t common_storage __address(0xFF7B);
extern uint16_t common_track __address(0xFF7C);
extern uint16_t common_sector_128 __address(0xFF7E);
extern uint8_t common_buffer[128] __address(0xFF80);

/* Адрес загрузки CP/M */
extern uint8_t cpm_base[0] __address(0xE600);

/* Размер блока CP/M */
static const uint8_t CPM_SECTOR_SIZE = 128;
