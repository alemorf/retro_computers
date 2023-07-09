#include "bios.h"
#include "graph.h"
#include "graph4.h"
#include "console.h"
#include "storage.h"
#include "keyboard.h"
#include "macro.h"
#include "opcodes.h"

const int MIT_SUBMENU = 1;
const int MIT_JUMP = 2;

const int cpm_load_address = 0xE500;
void CpmEntryPoint() __address(0xFB33);

extern uint16_t cpm_start;
extern uint16_t cpm_stop;

/* Config */
uint8_t config_begin[0];
uint8_t screen_mode;
uint8_t color_0 = PALETTE_DARK_BLUE;
uint8_t color_1 = PALETTE_CYAN;
uint8_t color_2 = PALETTE_WHITE;
uint8_t color_3 = PALETTE_YELLOW;
uint8_t drive_0 = 0;
uint8_t drive_1 = 1;
uint8_t codepage = 0;
uint8_t uart_baud_rate = 3;
uint8_t uart_data_bits = 3;
uint8_t uart_parity = 0;
uint8_t uart_stop_bits = 0;
uint8_t uart_flow = 0;
uint8_t config_check_sum = 0;

const int MENU_FIRST_ITEM_Y = 3;
const int MENU_VALUES_X = 20;

void StartCpm();
void StartBasic();

void menu_item_address(...) {
    a = e;
    a += a += a += a;
    a += 2;
    ADD_HL_A
}

void menu_item_is_empty(...) {
    push_pop(hl, bc) {
        menu_item_address();
        a = *hl; hl++; h = *hl; l = a;
        a = *hl;
        a |= a;
    }
}

void SetColorEx(...) {
    push_pop(bc, de, hl)
        SetColor(a);
}

void Menu(...) {
    push_pop(de) {
        push_pop(hl) {
            /* Очистка экрана */
            SetColor(a = 2);
            ClearScreen();
        }
        push_pop(hl) {
            /* Рисование заголовка */
            e = *hl; hl++; d = *hl; hl++;
            push_pop(hl) {
                swap(hl, de);
                DrawText(c = 0, de = 0x301);
                SetColor(a = 1);
            }
            /* Рисование пунктов */
            b = 0;
            push_pop(hl) {
                for (;;) {
                    e = *hl; hl++; d = *hl; hl++;
                    if (flag_z((a = e) |= a))
                        break;
                    push_pop(de) {
                        push_pop(hl, bc) {
                            swap(hl, de);
                            d = 3;
                            e = b;
                            e++;
                            e++;
                            e++;
                            SetColorEx(a = 1);
                            DrawText(c = 0, de, hl);
                        }
                        hl++; hl++; /* Тип -> Подменю */
                        hl++; hl++; /* Подменю -> Переменная */
                        push_pop(hl, bc) {
                            e = b;
                            c = *hl; hl++; b = *hl;
                            if (flag_nz((a = b) |= c)) {
                                b = a = *bc;
                                hl--; hl--; /* Переменная H -> Подменю H */
                                c = *hl; hl--; l = *hl; h = c;
                                /* Указатель на меню */
                                /* Заголовок */
                                hl++; hl++;
                                for (;;) {
                                    /* Текст */
                                    a = *hl; hl++; a |= *hl; hl++;
                                    if (flag_z)
                                        break;
                                    /* Тип */
                                    hl++; hl++;
                                    /* Значение */
                                    if ((a = b) == *hl) {
                                        hl--; hl--;
                                        /* Тип */
                                        hl--; hl--;
                                        /* Текст */
                                        c = *hl; hl++; h = *hl; l = c;
                                        SetColorEx(a = 3);
                                        d = MENU_VALUES_X;
                                        e++;
                                        e++;
                                        e++;
                                        DrawText(c = 0, de, hl);
                                        break;
                                    }
                                    hl++; hl++; hl++; hl++;
                                }
                            }
                        }
                        hl++;
                        hl++;
                    }
                    b++;
                }
            }
        }
    }

    /* Меню */
    SetColorEx(a = 2);
    b--;
    for(;;) {
        push_pop(de, bc, hl) {
            e++;
            e++;
            e++;
            DrawText(c = 0, d = 1, hl = "\x10");
        }
        d = e;
        do {
            push_pop(de, bc, hl)
                ReadKeyboard();
        } while(flag_z);

        if (a == KEY_ENTER) {
            push(hl);
            menu_item_address(hl, e);
            hl++; hl++; /* Пропускаем надпись */
            a = *hl;
            if (flag_z(a |= a)) { // MIT_RETURN
                hl++; hl++; /* Пропускаем тип */
                e = *hl; hl++; d = *hl; /* Номер */
                pop(hl);
                return; /* Результат в DE */
            } else if (flag_z(a--)) { // MIT_SUBMENU
                hl++; hl++; d = *hl; hl++;
                push_pop(hl) {
                    h = *hl; l = d;
                    push_pop(de) {
                        e = 0; // TODO: Прочитать переменную
                        Menu(hl);
                        a = e;
                    }
                }
                hl++; d = *hl; hl++; h = *hl; l = d;
                *hl = a;
            } else if (flag_z(a--)) { // MIT_JUMP
                hl++; hl++; d = *hl; hl++; h = *hl; l = d;
                pop(de);
                GotoHl();
            }
            pop(hl);
            return Menu(hl);
        }
        if (a == KEY_UP) {
            while ((a = e) != 0) {
                e--;
                menu_item_is_empty(hl, e);
                if (flag_nz) break;
            }
        } else {
            if (a != KEY_DOWN)
                continue;
            while ((a = e) != b) {
                e++;
                menu_item_is_empty(hl, e);
                if (flag_nz) break;
            }
        }

        push_pop(de, bc, hl) {
            e = d;
            e++;
            e++;
            e++;
            DrawText(c = 0, d = 1, hl = " ");
        }
    }
}

void SaveConfig() {
    /* Расчет контрольной суммы */
    hl = &config_begin;
    c = &config_check_sum - &config_begin;
    a = 0xAA;
    do {
        a ^= *hl;
        hl++;
    } while (flag_nz(c--));
    *hl = a;

    /* Сохранение */
    return WriteConfig(hl = &config_begin, c = &config_check_sum - &config_begin + 1);
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
    "Кодировка", MIT_SUBMENU, &menu_code_page, &codepage,
    "Экран", MIT_SUBMENU, &menu_screen, &screen_mode,
    "Цвет 0", MIT_SUBMENU, &menu_color, &color_0,
    "Цвет 1", MIT_SUBMENU, &menu_color, &color_1,
    "Цвет 2", MIT_SUBMENU, &menu_color, &color_2,
    "Цвет 3", MIT_SUBMENU, &menu_color, &color_3,
    "", 0, 0, 0,
    "UART скорость", MIT_SUBMENU, &menu_uart_baud_rate, &uart_baud_rate,
    "UART бит данных", MIT_SUBMENU, &menu_uart_data_bits, &uart_data_bits,
    "UART чётность", MIT_SUBMENU, &menu_uart_parity, &uart_parity,
    "UART стоп биты", MIT_SUBMENU, &menu_uart_stop_bits, &uart_stop_bits,
    "UART контроль", MIT_SUBMENU, &menu_uart_flow, &uart_flow,
    "", 0, 0, 0,
    "Диск A:", MIT_SUBMENU, &menu_drive, &drive_0,
    "Диск B:", MIT_SUBMENU, &menu_drive, &drive_1,
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
    ReadConfig(hl = SCREEN_0_ADDRESS, c = &config_check_sum - &config_begin + 1);
    if (flag_z) {
        /* Проверка контрольной суммы */
        hl = SCREEN_0_ADDRESS;
        c = &config_check_sum - &config_begin + 1;
        a = 0xAA;
        do {
            a ^= *hl;
            hl++;
        } while(flag_nz(c--));
        /* Если контрольная сумма ОК, то применяем настройки */
        if (flag_z(a |= a))
            MEMCPY8(&config_begin, SCREEN_0_ADDRESS, &config_check_sum - &config_begin);
    }

    /* Очистка экрана и запуск прерываний */
    SetScreenColor6();
    SetColor(a = 3);
    ConReset();

    /* Настройка палитры */
    out(PORT_PALETTE(0), a = PALETTE_DARK_BLUE);
    out(PORT_PALETTE(1), a = PALETTE_YELLOW);
    out(PORT_PALETTE(2), a = PALETTE_WHITE);
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
    ConSetXlat(a = codepage);

    a = screen_mode;
    if (flag_z(a |= a)) {
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
    Out(PORT_PALETTE(0), a = color_0);
    Out(PORT_PALETTE(1), a = color_1);
    Out(PORT_PALETTE(2), a = color_2);
    Out(PORT_PALETTE(3), a = color_3);
    DrawText(c = 0, de = 0, hl = "Искра 1080М");
    SetColor(a = 1);
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
    } while (flag_nz((a = d) |= a));

    /* Запуск CP/M */
    c = a = drive_number;
    return CpmEntryPoint();
}

asm("cpm_start: incbin \"cpm22/cpm22.bin\"");
asm("cpm_stop: db 0");
