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

#include <cmm.h>
#include <stdint.h>

extern uint8_t stack[0] __address(0x100);

/* Константы CP/M */
static const uint8_t CPM_SECTOR_SIZE = 128;
static const uint16_t CPM_LOAD_ADDRESS = 0xE600;

/* Общие переменные для CP/M и BIOS */
extern uint16_t bios_dpb __address(0xFF79);
extern uint8_t bios_storage __address(0xFF7B);
extern uint16_t bios_track __address(0xFF7C);
extern uint16_t bios_sector_128 __address(0xFF7E);
extern uint8_t bios_buffer[128] __address(0xFF80);

/* BIOS вызывает функции CP/M */
void CpmEntryPoint(/*c*/) __address(0xFC33);

/* CP/M вызывает функции BIOS (через точки входа в начале адресного пространства) */
void main(void);
void InterruptHandler(void);
void CpmWBoot(/*c*/);
void CpmConst(void);
void CpmConin(void);
void CpmConout(/*c*/);
void CpmList(/*c*/);
void CpmPunch(/*c*/);
void CpmReader(void);
void CpmSelDsk(/*c*/);
void CpmRead(void);
void CpmWrite(/*c*/);
void CpmPrSta(void);
