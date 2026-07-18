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

#include <cmm.h>
#include "main.h"
#include "menu.h"
#include "start_cpm.h"
#include "start_basic.h"
#include "config.h"
#include "graph/graph.h"
#include "console.h"
#include "storage/memory.h"
#include "../i1080.h"
#include "../common.h"

/* clang-format off */

static uint16_t menu_screen[] = {
    "Выберите режим экрана",
    MENU_RETURN("64x25 2 цвета",    0),
    MENU_RETURN("64x25 4 цвета",    1),
    MENU_RETURN("96x25 2 цвета",    2),
    MENU_RETURN("96x25 4 цвета",    3),
    MENU_END
};

static uint16_t menu_code_page[] = {
    "Выберите кодировку",
    MENU_RETURN("866",              0),
    MENU_RETURN("1251",             1),
    MENU_RETURN("КОИ-7",            2),
    MENU_RETURN("КОИ-8",            3),
    MENU_END
};

static uint16_t menu_uart_baud_rate[] = {
    "Выберите скорость UART",
    MENU_RETURN("1200 бод",         0),
    MENU_RETURN("2400 бод",         1),
    MENU_RETURN("4800 бод",         2),
    MENU_RETURN("9600 бод",         3),
    MENU_END
};

static uint16_t menu_uart_data_bits[] = {
    "Выберите кол-во бит данных UART",
    MENU_RETURN("5",                0),
    MENU_RETURN("6",                1),
    MENU_RETURN("7",                2),
    MENU_RETURN("8",                3),
    MENU_END
};

static uint16_t menu_uart_stop_bits[] = {
    "Выберите кол-во стоповых бит UART",
    MENU_RETURN("1",                0),
    MENU_RETURN("1.5",              1),
    MENU_RETURN("2",                2),
    MENU_END
};

static uint16_t menu_uart_parity[] = {
    "Выберите контроль чётности UART",
    MENU_RETURN("Нет",              0),
    MENU_RETURN("Чётный",           1),
    MENU_RETURN("Не чётный",        2),
    MENU_END
};

static uint16_t menu_uart_flow[] = {
    "Выберите контроль потоком UART",
    MENU_RETURN("Нет",              0),
    MENU_RETURN("CTS/RTS",          1),
    MENU_END
};

static uint16_t menu_color[] = {
    "Выберите цвет",
    MENU_RETURN("Чёрный",           PALETTE_BLACK),
    MENU_RETURN("Тёмно-красный",    PALETTE_DARK_RED),
    MENU_RETURN("Тёмно-зелёный",    PALETTE_DARK_GREEN),
    MENU_RETURN("Тёмно-жёлтый",     PALETTE_DARK_YELLOW),
    MENU_RETURN("Тёмно-синий",      PALETTE_DARK_BLUE),
    MENU_RETURN("Тёмно-фиолетовый", PALETTE_DARK_MAGENTA),
    MENU_RETURN("Тёмно-голубой",    PALETTE_DARK_CYAN),
    MENU_RETURN("Серый",            PALETTE_GRAY),
    MENU_RETURN("Красный",          PALETTE_RED),
    MENU_RETURN("Зеленый",          PALETTE_GREEN),
    MENU_RETURN("Жёлтый",           PALETTE_YELLOW),
    MENU_RETURN("Синий",            PALETTE_BLUE),
    MENU_RETURN("Фиолетовый",       PALETTE_MAGENTA),
    MENU_RETURN("Голубой",          PALETTE_CYAN),
    MENU_RETURN("Белый",            PALETTE_WHITE),
    MENU_END
};

static uint16_t menu_root[] = {
    "Искра 1080М",
    MENU_EXECUTE("Запуск CP/M",       StartCpm),
    MENU_EXECUTE("Запуск T-BASIC",    StartBasic),
    MENU_SEPARATOR,
    MENU_VARIABLE("Кодировка",        &config.codepage, menu_code_page),
    MENU_VARIABLE("Экран",            &config.screen_mode, menu_screen),
    MENU_VARIABLE("Цвет 0",           &config.color_0, menu_color),
    MENU_VARIABLE("Цвет 1",           &config.color_1, menu_color),
    MENU_VARIABLE("Цвет 2",           &config.color_2, menu_color),
    MENU_VARIABLE("Цвет 3",           &config.color_3, menu_color),
    MENU_SEPARATOR,
    MENU_VARIABLE("UART скорость",    &config.uart_baud_rate, menu_uart_baud_rate),
    MENU_VARIABLE("UART бит данных",  &config.uart_data_bits, menu_uart_data_bits),
    MENU_VARIABLE("UART чётность",    &config.uart_parity, menu_uart_parity),
    MENU_VARIABLE("UART стоп биты",   &config.uart_stop, menu_uart_stop_bits),
    MENU_VARIABLE("UART контроль",    &config.uart_flow, menu_uart_flow),
    MENU_SEPARATOR,
    MENU_EXECUTE("Сброс настроек",    ResetConfig),
    // TODO: Format
    MENU_END,
};

/* clang-format on */

void main(void) {
    /* Настройка стека */
    sp = BIOS_STACK;

    /* Переменные по умолчанию для CP/M */
    out(PORT_WINDOW(3), a = PAGE_CPM_3);
    common_dont_exec_nc = (a ^= a);
    common_folder = a;

    /* Настройка адресного пространства */
    out(PORT_ROM_0000, a = PORT_ROM_0000__RAM);
    out(PORT_WINDOW(0), a = PAGE_BIOS_0);
    out(PORT_WINDOW(1), a = PAGE_BIOS_1);
    out(PORT_WINDOW(2), a = PAGE_SCREEN);
    out(PORT_WINDOW(3), a = PAGE_SCREEN);

    /* Проверка настроек в ОЗУ и возможно сброс настроек */
    InitConfig();

    /* Проверка накопителя в ОЗУ и возможно форматирование */
    StorageMemoryFormat();  // TODO: Только если кс config не сошелся

    /* Очистка экрана и запуск прерываний */
    SetGraphModeColor6x10();
    SetColor(a = 3);
    ConReset();

    /* Настройка палитры (включение экрана) */
    out(PORT_PALETTE(0), a = PALETTE_DARK_BLUE);
    out(PORT_PALETTE(1), a = PALETTE_WHITE);
    out(PORT_PALETTE(2), a = PALETTE_YELLOW);
    out(PORT_PALETTE(3), a = PALETTE_CYAN);

    /* Главное меню */
    for (;;)
        Menu(e = 0, hl = menu_root);
}
