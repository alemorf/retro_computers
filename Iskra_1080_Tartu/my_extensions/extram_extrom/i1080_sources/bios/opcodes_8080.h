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

static const uint8_t OPCODE_NOP = 0x00;
static const uint8_t OPCODE_LD_DE_CONST = 0x11;
static const uint8_t OPCODE_LD_A_CONST = 0x3E;
static const uint8_t OPCODE_LD_H_A = 0x67;
static const uint8_t OPCODE_LD_A_D = 0x7A;
static const uint8_t OPCODE_LD_A_H = 0x7C;
static const uint8_t OPCODE_XOR_A = 0xAF;
static const uint8_t OPCODE_XOR_B = 0xA8;
static const uint8_t OPCODE_JP = 0xC3;
static const uint8_t OPCODE_RET = 0xC9;
static const uint8_t OPCODE_SUB_CONST = 0xD6;
static const uint8_t OPCODE_AND_CONST = 0xE6;
static const uint8_t OPCODE_OR_CONST = 0xF6;
static const uint8_t OPCODE_OUT = 0xD3;
static const uint8_t OPCODE_JMP = 0xC3;
