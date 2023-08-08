#include "bios.h"
#include "graph.h"
#include "graph4.h"
#include "console.h"
#include "storage.h"
#include "keyboard.h"
#include "macro.h"
#include "opcodes.h"
#include "menu.h"

const int cpm_load_address = 0xE500;
void CpmEntryPoint() __address(0xFB33);

/* Два переменные в начале файла */
extern uint16_t cpm_start;
extern uint16_t cpm_stop;

/* Настройки */
uint8_t cfg_begin[0];
uint8_t cfg_screen_mode;
uint8_t cfg_color_0 = PALETTE_DARK_BLUE;
uint8_t cfg_color_1 = PALETTE_CYAN;
uint8_t cfg_color_2 = PALETTE_WHITE;
uint8_t cfg_color_3 = PALETTE_YELLOW;
uint8_t cfg_drive_0 = 0;
uint8_t cfg_drive_1 = 1;
uint8_t cfg_codepage = 0;
uint8_t cfg_uart_baud_rate = 3;
uint8_t cfg_uart_data_bits = 3;
uint8_t cfg_uart_parity = 0;
uint8_t cfg_uart_stop = 0;
uint8_t cfg_uart_flow = 0;
uint8_t cfg_check_sum = 0;

/* Прототипы функций */
void StartCpm();
void StartBasic();

void SaveConfig() {
    /* Расчет контрольной суммы */
    hl = &cfg_begin;
    c = &cfg_check_sum - &cfg_begin;
    a = 0xAA;
    do {
        a ^= *hl;
        hl++;
    } while (flag_nz(c--));
    *hl = a;

    /* Сохранение */
    return WriteConfig(hl = &cfg_begin, c = &cfg_check_sum - &cfg_begin + 1);
}

uint16_t menu_screen[] = {
    "Выберите режим экрана",
    "64x25 2 цвета", 0, 0, 0,
    "64x25 4 цвета", 0, 1, 0,
    "96x25 2 цвета", 0, 2, 0,
    "96x25 4 цвета", 0, 3, 0,
    0
};

uint16_t menu_drive[] = {
    "Выберите дисковод",
    "Реальный A", 0, 0, 0,
    "Реальный B", 0, 1, 0,
    "USB флешка / SD карта", 0, 2, 0,
    0
};

uint16_t menu_code_page[] = {
    "Выберите кодировку",
    "866", 0, 0, 0,
    "1251", 0, 1, 0,
    "КОИ-7", 0, 2, 0,
    "КОИ-8", 0, 3, 0,
    0
};

uint16_t menu_uart_baud_rate[] = {
    "Выберите скорость UART",
    "1200 бод", 0, 0, 0,
    "2400 бод", 0, 1, 0,
    "4800 бод", 0, 2, 0,
    "9600 бод", 0, 3, 0,
    0
};

uint16_t menu_uart_data_bits[] = {
    "Выберите кол-во бит данных UART",
    "5", 0, 0, 0,
    "6", 0, 1, 0,
    "7", 0, 2, 0,
    "8", 0, 3, 0,
    0
};

uint16_t menu_uart_stop_bits[] = {
    "Выберите кол-во стоповых бит UART",
    "1", 0, 0, 0,
    "1.5", 0, 1, 0,
    "2", 0, 2, 0,
    0
};

uint16_t menu_uart_parity[] = {
    "Выберите контроль чётности UART",
    "Нет", 0, 0, 0,
    "Чётный", 0, 1, 0,
    "Не чётный", 0, 2, 0,
    0
};

uint16_t menu_uart_flow[] = {
    "Выберите контроль потоком UART",
    "Нет", 0, 0, 0,
    "CTS/RTS", 0, 1, 0,
    0
};

uint16_t menu_color[] = {
    "Выберите цвет",
    "Чёрный", 0, PALETTE_BLACK, 0,
    "Тёмно-красный", 0, PALETTE_DARK_RED, 0,
    "Тёмно-зелёный", 0, PALETTE_DARK_GREEN, 0,
    "Тёмно-жёлтый", 0, PALETTE_DARK_YELLOW, 0,
    "Тёмно-синий", 0, PALETTE_DARK_BLUE, 0,
    "Тёмно-фиолетовый", 0, PALETTE_DARK_MAGENTA, 0,
    "Темно-голубой", 0, PALETTE_DARK_CYAN, 0,
    "Серый", 0, PALETTE_GRAY, 0,
    "Красный", 0, PALETTE_RED, 0,
    "Зеленый", 0, PALETTE_GREEN, 0,
    "Жёлтый", 0, PALETTE_YELLOW, 0,
    "Синий", 0, PALETTE_BLUE, 0,
    "Фиолетовый", 0, PALETTE_MAGENTA, 0,
    "Голубой", 0, PALETTE_CYAN, 0,
    "Белый", 0, PALETTE_WHITE, 0,
    0
};

uint16_t menu_root[] = {
    "Искра 1080М",
    "Запуск CP/M", MIT_JUMP, &StartCpm, 0,
    "Запуск T-BASIC", MIT_JUMP, &StartBasic, 0,
    "", 0, 0, 0,
    "Кодировка", MIT_SUBMENU, &menu_code_page, &cfg_codepage,
    "Экран", MIT_SUBMENU, &menu_screen, &cfg_screen_mode,
    "Цвет 0", MIT_SUBMENU, &menu_color, &cfg_color_0,
    "Цвет 1", MIT_SUBMENU, &menu_color, &cfg_color_1,
    "Цвет 2", MIT_SUBMENU, &menu_color, &cfg_color_2,
    "Цвет 3", MIT_SUBMENU, &menu_color, &cfg_color_3,
    "", 0, 0, 0,
    "UART скорость", MIT_SUBMENU, &menu_uart_baud_rate, &cfg_uart_baud_rate,
    "UART бит данных", MIT_SUBMENU, &menu_uart_data_bits, &cfg_uart_data_bits,
    "UART чётность", MIT_SUBMENU, &menu_uart_parity, &cfg_uart_parity,
    "UART стоп биты", MIT_SUBMENU, &menu_uart_stop_bits, &cfg_uart_stop,
    "UART контроль", MIT_SUBMENU, &menu_uart_flow, &cfg_uart_flow,
    "", 0, 0, 0,
    "Диск A:", MIT_SUBMENU, &menu_drive, &cfg_drive_0,
    "Диск B:", MIT_SUBMENU, &menu_drive, &cfg_drive_1,
    "", 0, 0, 0,
    "Сохранить настройки", MIT_JUMP, &SaveConfig, 0,
    0
};

void main() {
    /* Настройка стека */
    sp = &stack;

    /* Настройка адресного пространства */
    out(PORT_WINDOW(0), a = PAGE_RAM(0));
    out(PORT_WINDOW(1), a = PAGE_RAM(1));
    out(PORT_WINDOW(2), a = PAGE_STD);
    out(PORT_WINDOW(3), a = PAGE_STD);

    /* Чтение настроек */
    ReadConfig(hl = SCREEN_0_ADDRESS, c = &cfg_check_sum - &cfg_begin + 1);
    if (flag_z) {
        /* Проверка контрольной суммы */
        hl = SCREEN_0_ADDRESS;
        c = &cfg_check_sum - &cfg_begin + 1;
        a = 0xAA;
        do {
            a ^= *hl;
            hl++;
        } while(flag_nz(c--));
        /* Если контрольная сумма ОК, то применяем настройки */
        if (a == 0)
            MEMCPY8(&cfg_begin, SCREEN_0_ADDRESS, &cfg_check_sum - &cfg_begin);
    }

    /* Очистка экрана и запуск прерываний */
    SetScreenColor6();
    SetColor(a = 3);
    ConReset();

    /* Настройка палитры */
    out(PORT_PALETTE(0), a = PALETTE_DARK_BLUE);
    out(PORT_PALETTE(1), a = PALETTE_WHITE);
    out(PORT_PALETTE(2), a = PALETTE_YELLOW);
    out(PORT_PALETTE(3), a = PALETTE_CYAN);

    /* Меню */
    for(;;)
        Menu(e = 0, hl = &menu_root);
}

void StartBasic4000() {
    Out(PORT_WINDOW(0), a = 1);
    Out(PORT_ROM_0000, a ^= a);
    return 0();
}

void StartBasic() {
    DisableInterrupts();
    Out(PORT_WINDOW(1), a = PAGE_STD);
    Out(PORT_WINDOW(2), a);
    Out(PORT_WINDOW(3), a);
    MEMCPY8(0x4000, &StartBasic4000, &StartBasic - &StartBasic4000);
    0x4000();
}

void StartCpm() {
    ConSetXlat(a = cfg_codepage);

    a = cfg_screen_mode;
    if (a == 0) {
        SetScreenBw6();
    } else if (flag_z(a--)) {
        SetScreenColor6();
    } else if (flag_z(a--)) {
        SetScreenBw4();
    } else {
        SetScreenColor4();
    }

    SetColor(a = 3);
    ClearScreen();
    Out(PORT_PALETTE(0), a = cfg_color_0);
    con_color_0 = ((a ^= 7) &= 7);
    Out(PORT_PALETTE(1), a = cfg_color_1);
    con_color_1 = ((a ^= 7) &= 7);
    Out(PORT_PALETTE(2), a = cfg_color_2);
    con_color_2 = ((a ^= 7) &= 7);
    Out(PORT_PALETTE(3), a = cfg_color_3);
    con_color_3 = ((a ^= 7) &= 7);
    DrawText(c = 0, de = 0, hl = "Искра 1080М");
    ConUpdateColor();
    cursor_visible = a = 1;
    return CpmWBoot();
}

void CpmWBoot() {
    /* Копирование CP/M */
    out(PORT_WINDOW(3), a = PAGE_RAM(7));
    de = cpm_load_address;
    hl = &cpm_start;
    do {
        *de = a = *hl;
        hl++;
        de++;
    } while ((a = d) != 0);

    /* Запуск CP/M */
    c = a = drive_number;
    return CpmEntryPoint();
}

asm("cpm_start: incbin \"cpm22/cpm22.bin\"");
asm("cpm_stop: db 0");
