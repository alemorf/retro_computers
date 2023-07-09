#pragma once

#include "cmm.h"
#include "cp866.h"

/* Адреса */
const int SCREEN_0_ADDRESS = 0xD000;
const int SCREEN_1_ADDRESS = 0x9000;

/* Цвета */
const int PALETTE_WHITE = 0;
const int PALETTE_CYAN = 1;
const int PALETTE_MAGENTA = 2;
const int PALETTE_BLUE = 3;
const int PALETTE_YELLOW = 4;
const int PALETTE_GREEN = 5;
const int PALETTE_RED = 6;
const int PALETTE_XXX = 7;
const int PALETTE_GRAY = 8;
const int PALETTE_DARK_CYAN = 9;
const int PALETTE_DARK_MAGENTA = 10;
const int PALETTE_DARK_BLUE = 11;
const int PALETTE_DARK_YELLOW = 12;
const int PALETTE_DARK_GREEN = 13;
const int PALETTE_DARK_RED = 14;
const int PALETTE_BLACK = 15;

/* Коды клавиш */
const int KEY_BACKSPACE = 0x08;
const int KEY_TAB = 0x09;
const int KEY_ENTER = 0x0D;
const int KEY_ESC = 0x1B;
const int KEY_ALT = 1;
const int KEY_F1 = 0xF2;
const int KEY_F2 = 0xF3;
const int KEY_F3 = 0xF4;
const int KEY_UP = 0xF5;
const int KEY_DOWN = 0xF6;
const int KEY_RIGHT = 0xF7;
const int KEY_LEFT = 0xF8;
const int KEY_EXT_5 = 0xF9;
const int KEY_END = 0xFA;
const int KEY_HOME = 0xFB;
const int KEY_INSERT = 0xFC;
const int KEY_DEL = 0xFD;
const int KEY_PG_UP = 0xFE;
const int KEY_PG_DN = 0xFF;

/* Порты ввода вывода */
#define PORT_WINDOW(N) (N)
const int PORT_FRAME_IRQ_RESET = 0x04;
const int PORT_SD_SIZE = 9;
const int PORT_SD_RESULT = 9;
const int PORT_SD_DATA = 8;
const int PORT_UART_DATA = 0x80;
const int PORT_UART_CONFIG = 0x81;
const int PORT_UART_STATE = 0x81;
const int PORT_EXT_DATA_OUT = 0x88;
const int PORT_PALETTE_3 = 0x90;
const int PORT_PALETTE_2 = 0x91;
const int PORT_PALETTE_1 = 0x92;
const int PORT_PALETTE_0 = 0x93;
const int PORT_EXT_IN_DATA = 0x89;
const int PORT_A0 = 0xA0;
const int PORT_ROM_0000 = 0xA8;
const int PORT_ROM_0000__ROM = 0;
const int PORT_ROM_0000__RAM = 0x80;
#define PORT_PALETTE(N) (0x90 + ((N) & 3))
const int PORT_VIDEO_MODE_1_LOW = 0xB9;
const int PORT_VIDEO_MODE_1_HIGH = 0xF9;
const int PORT_VIDEO_MODE_0_LOW = 0xB8;
const int PORT_VIDEO_MODE_0_HIGH = 0xF8;
const int PORT_UART_SPEED_0 = 0xBB;
const int PORT_KEYBOARD = 0xC0;
const int PORT_UART_SPEED_1 = 0xFB;
const int PORT_CODE_ROM = 0xBA;
const int PORT_CHARGEN_ROM = 0xFA;
const int PORT_TAPE_AND_IDX2 = 0x99;
const int PORT_TAPE_AND_IDX2_ID1_2 = 2;
const int PORT_TAPE_AND_IDX2_ID2_2 = 4;
const int PORT_TAPE_AND_IDX2_ID3_2 = 8;
const int PORT_TAPE_AND_IDX2_ID6_2 = 0x40;
const int PORT_TAPE_AND_IDX2_ID7_2 = 0x80;
const int PORT_RESET_CU1 = 0xBC;
const int PORT_RESET_CU2 = 0xBD;
const int PORT_RESET_CU3 = 0xBE;
const int PORT_RESET_CU4 = 0xBF;
const int PORT_SET_CU1 = 0xFC;
const int PORT_SET_CU2 = 0xFD;
const int PORT_SET_CU3 = 0xFE;
const int PORT_SET_CU4 = 0xFF;
const int PORT_TAPE_OUT = 0xB0;

/* Страницы памяти */
#define PAGE_RAM(N) ((N) * 2)
#define PAGE_ROM(N) (3 + (N) * 4)
#define PAGE_STD 1

/* Команды SD контроллера */
const int SD_COMMAND_READ = 1;
const int SD_COMMAND_READ_SIZE = 5;
const int SD_COMMAND_WRITE = 2;
const int SD_COMMAND_WRITE_SIZE = 5 + 128;

/* Ответ SD контроллера */
const int SD_RESULT_BUSY = 0xFF;
const int SD_RESULT_OK = 0;
