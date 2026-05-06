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

/* Параметры накопителя A: */

static const uint16_t A_BLOCK_SIZE = 1024;
static const uint16_t A_ROM_DIRECORY_BLOCKS = 1;
static const uint16_t A_ROM_BLOCKS = 0x10000 / A_BLOCK_SIZE;
static const uint16_t A_RAM_DIRECORY_BLOCKS = 1;
static const uint16_t A_RAM_BLOCKS = 0x8000 / A_BLOCK_SIZE;
