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

#include "../i1080.h"

extern uint8_t stack __address(0x100);

void main();
void InterruptHandler();
void CpmWBoot();
void CpmConst();
void CpmConin();
void CpmConout();
void CpmList();
void CpmPunch();
void CpmReader();
void CpmSelDsk();
void CpmSetTrk();
void CpmSetSec();
void CpmRead();
void CpmWrite();
void CpmPrSta();

extern uint16_t entry_cpm_conout_address __address("entrycpmconout + 1");

extern uint8_t cpm_dph_a __address(0xFF60);
extern uint8_t cpm_dph_b __address(0xFF70);
extern uint8_t cpm_dma_buffer __address(0xFF80);
