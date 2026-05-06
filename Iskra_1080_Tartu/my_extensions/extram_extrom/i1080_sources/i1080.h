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
#include <c8080/codepage/866.h>

/* Адреса */
static const uint16_t SCREEN_0_ADDRESS = 0xD000;
static const uint16_t SCREEN_1_ADDRESS = 0x9000;
#define WINDOW_ADDDRESS(N) (0x4000 * (N))

/* Цвета */
static const uint8_t PALETTE_WHITE = 0;
static const uint8_t PALETTE_CYAN = 1;
static const uint8_t PALETTE_MAGENTA = 2;
static const uint8_t PALETTE_BLUE = 3;
static const uint8_t PALETTE_YELLOW = 4;
static const uint8_t PALETTE_GREEN = 5;
static const uint8_t PALETTE_RED = 6;
static const uint8_t PALETTE_XXX = 7;
static const uint8_t PALETTE_GRAY = 8;
static const uint8_t PALETTE_DARK_CYAN = 9;
static const uint8_t PALETTE_DARK_MAGENTA = 10;
static const uint8_t PALETTE_DARK_BLUE = 11;
static const uint8_t PALETTE_DARK_YELLOW = 12;
static const uint8_t PALETTE_DARK_GREEN = 13;
static const uint8_t PALETTE_DARK_RED = 14;
static const uint8_t PALETTE_BLACK = 15;

/* Коды клавиш */
static const uint8_t KEY_BACKSPACE = 0x08;
static const uint8_t KEY_TAB = 0x09;
static const uint8_t KEY_ENTER = 0x0D;
static const uint8_t KEY_ESC = 0x1B;
static const uint8_t KEY_ALT = 1;
static const uint8_t KEY_F1 = 0xF2;
static const uint8_t KEY_F2 = 0xF3;
static const uint8_t KEY_F3 = 0xF4;
static const uint8_t KEY_UP = 0xF5;
static const uint8_t KEY_DOWN = 0xF6;
static const uint8_t KEY_RIGHT = 0xF7;
static const uint8_t KEY_LEFT = 0xF8;
static const uint8_t KEY_EXT_5 = 0xF9;
static const uint8_t KEY_END = 0xFA;
static const uint8_t KEY_HOME = 0xFB;
static const uint8_t KEY_INSERT = 0xFC;
static const uint8_t KEY_DEL = 0xFD;
static const uint8_t KEY_PG_UP = 0xFE;
static const uint8_t KEY_PG_DN = 0xFF;

/* Порты ввода вывода */
#define PORT_WINDOW(N) (N)
static const uint8_t PORT_FRAME_IRQ_RESET = 0x04;
static const uint8_t PORT_ARM_SIZE = 9;
static const uint8_t PORT_ARM_RESULT = 9;
static const uint8_t PORT_ARM_DATA = 8;
static const uint8_t PORT_UART_DATA = 0x80;
static const uint8_t PORT_UART_CONFIG = 0x81;
static const uint8_t PORT_UART_STATE = 0x81;
static const uint8_t PORT_EXT_DATA_OUT = 0x88;
static const uint8_t PORT_PALETTE_3 = 0x90;
static const uint8_t PORT_PALETTE_2 = 0x91;
static const uint8_t PORT_PALETTE_1 = 0x92;
static const uint8_t PORT_PALETTE_0 = 0x93;
static const uint8_t PORT_EXT_IN_DATA = 0x89;
static const uint8_t PORT_A0 = 0xA0;
static const uint8_t PORT_ROM_0000 = 0xA8;
static const uint8_t PORT_ROM_0000__ROM = 0;
static const uint8_t PORT_ROM_0000__RAM = 0x80;
#define PORT_PALETTE(N) (0x90 + ((N)&3))
static const uint8_t PORT_VIDEO_MODE_1_LOW = 0xB9;
static const uint8_t PORT_VIDEO_MODE_1_HIGH = 0xF9;
static const uint8_t PORT_VIDEO_MODE_0_LOW = 0xB8;
static const uint8_t PORT_VIDEO_MODE_0_HIGH = 0xF8;
static const uint8_t PORT_UART_SPEED_0 = 0xBB;
static const uint8_t PORT_KEYBOARD = 0xC0;
static const uint8_t PORT_UART_SPEED_1 = 0xFB;
static const uint8_t PORT_CODE_ROM = 0xBA;
static const uint8_t PORT_CHARGEN_ROM = 0xFA;
static const uint8_t PORT_TAPE_AND_IDX2 = 0x99;
static const uint8_t PORT_TAPE_AND_IDX2_ID1_2 = 2;
static const uint8_t PORT_TAPE_AND_IDX2_ID2_2 = 4;
static const uint8_t PORT_TAPE_AND_IDX2_ID3_2 = 8;
static const uint8_t PORT_TAPE_AND_IDX2_ID6_2 = 0x40;
static const uint8_t PORT_TAPE_AND_IDX2_ID7_2 = 0x80;
static const uint8_t PORT_RESET_CU1 = 0xBC;
static const uint8_t PORT_RESET_CU2 = 0xBD;
static const uint8_t PORT_RESET_CU3 = 0xBE;
static const uint8_t PORT_RESET_CU4 = 0xBF;
static const uint8_t PORT_SET_CU1 = 0xFC;
static const uint8_t PORT_SET_CU2 = 0xFD;
static const uint8_t PORT_SET_CU3 = 0xFE;
static const uint8_t PORT_SET_CU4 = 0xFF;
static const uint8_t PORT_TAPE_OUT = 0xB0;

/* Страницы памяти */
#define PAGE_RAM(N) ((N)*2)
#define PAGE_ROM(N) (3 + (N)*4)
static const uint8_t PAGE_STD = 1;
static const uint8_t PAGE_SCREEN = 1;
