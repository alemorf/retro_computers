/*
 * Iskra 1080 Extension card firmware
 * Keyboard driver
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
#include "keyboard.h"
#include "../i1080.h"

/* Настройки клавиатуры */

static const uint8_t NEXT_REPLAY_DELAY = 3;
static const uint8_t FIRST_REPLAY_DELAY = 30;

/* Сканкоды клавиатуры */

enum {
    SCAN_LAT = 0x19,
    SCAN_RUS = 0x18,
    SCAN_CAP = 0x1E,
    SCAN_NUM = 0x1C,
};

static const uint8_t LAYOUT_SIZE = 80;

uint8_t key_leds = MOD_NUM;
uint8_t key_pressed = 0;
uint8_t key_delay = 0;
uint8_t key_rus = 0;
uint8_t key_read = key_buffer;
uint8_t key_write = key_buffer;
extern uint16_t key_read_l_write_h __address("key_read");

static void KeyPush(/* a - код клавиши */);

/* Влияние SHIFT, CAP, NUM на нажатую клавишу */

static const uint8_t SHI = 0x40;
static const uint8_t CAP = 0x80;
static const uint8_t NUM = 0x20;

// clang-format off

static uint8_t shiftLayout[] = {
    /* Латинская раскладка */
    SHI, CAP, CAP, CAP, SHI, CAP, CAP, SHI,
    SHI, CAP, CAP, CAP, SHI, CAP, CAP, SHI,
    SHI, CAP, CAP, CAP, SHI, CAP, SHI, SHI,
    0,   0,   0,   0,   0,   0,   0,   0,
    SHI, CAP, CAP, CAP, SHI, SHI, SHI, SHI,
    SHI, CAP, CAP, CAP, SHI, SHI, SHI, SHI,
    SHI, NUM, CAP, CAP, SHI, SHI, SHI, NUM,
    0,   CAP, CAP, CAP, 0,   NUM, NUM, NUM,
    0,   CAP, 0,   0,   SHI, NUM, NUM, NUM,
    0,   0,   0,   0,   0,   NUM, NUM, NUM,

    /* Русская раскладка */
    SHI, CAP, CAP, CAP, SHI, CAP, CAP, CAP,
    SHI, CAP, CAP, CAP, SHI, CAP, CAP, CAP,
    SHI, CAP, CAP, CAP, SHI, CAP, CAP, CAP,
    0,   0,   0,   0,   0,   0,   0,   0,
    SHI, CAP, CAP, CAP, SHI, CAP, CAP, SHI,
    SHI, CAP, CAP, CAP, SHI, CAP, SHI, SHI,
    SHI, NUM, CAP, CAP, SHI, SHI, SHI, NUM,
    0,   CAP, CAP, CAP, 0,   NUM, NUM, NUM,
    0,   CAP, 0,   0,   SHI, NUM, NUM, NUM,
    0,   0,   0,   0,   0,   NUM, NUM, NUM,
};

/* Коды клавиш при нажатом CTL */

#define CTL(C) ((C) & 0x1F)

static uint8_t ctlLayout[] = {
    0x1E,   CTL('u'), CTL('j'), CTL('m'), 0x1F,      CTL('i'),      CTL('k'),  CTL('`'),
    0x1D,   CTL('y'), CTL('h'), CTL('n'), 0x08,      CTL('o'),      CTL('l'),  CTL('@'),
    0x1C,   CTL('t'), CTL('g'), CTL('b'), '9',       CTL('p'),      CTL('['),  '?',
    '?',    '?',      KEY_ALT,  '?',      '?',       KEY_BACKSPACE, '?',       CTL(' '),
    0x1B,   CTL('r'), CTL('f'), CTL('v'), 0x00,      CTL('{'),      CTL(']'),  ',',
    0x00,   CTL('e'), CTL('d'), CTL('c'), CTL('_'),  CTL('}'),      ':',       '.',
    '1',    '.',      CTL('a'), CTL('z'), CTL('^'),  CTL('/'),      ';',       '0',
    '?',    CTL('w'), CTL('s'), CTL('x'), '?',       '7',           '4',       '1',
    0x0A,   CTL('q'), KEY_TAB,  '?',      CTL('\\'), '8',           '5',       '2',
    KEY_F3, '?',      KEY_F1,   KEY_F2,   KEY_ESC,   '9',           '6',       '3'
};

/* Коды клавиш */

static uint8_t key_layout_table[] = {
    /* Латинская раскладка */
    '6', 'u', 'j', 'm', '7', 'i', 'k', '`',
    '5', 'y', 'h', 'n', '8', 'o', 'l', '@',
    '4', 't', 'g', 'b', '9', 'p', '[', 0,
    0, 0, KEY_ALT, 0, 0, KEY_BACKSPACE, 0, ' ',
    '3', 'r', 'f', 'v', '0', '{', ']', ',',
    '2', 'e', 'd', 'c', '-', '}', ':', '.',
    '1', KEY_DEL, 'a', 'z', '^', '/', ';', KEY_INSERT,
    0, 'w', 's', 'x', KEY_DEL, KEY_HOME, KEY_LEFT, KEY_END,
    KEY_ENTER, 'q', KEY_TAB, 0, '\\', KEY_UP, KEY_EXT_5, KEY_DOWN,
    KEY_F3, 0, KEY_F1, KEY_F2, KEY_ESC, KEY_PG_UP, KEY_RIGHT, KEY_PG_DN,

    /* Латинская раскладка + shift */
    '&', 'U', 'J', 'M', '\'', 'I', 'K', '`',
    '%', 'Y', 'H', 'N', '(', 'O', 'L', '@',
    '$', 'T', 'G', 'B', ')', 'P', '[', 0,
    0, 0, KEY_ALT, 0, 0, KEY_BACKSPACE, 0, ' ',
    '#', 'R', 'F', 'V', '_', '{', ']', '<',
    '\"', 'E', 'D', 'C', '=', '}', '*', '>',
    '!', '.', 'A', 'Z', '~', '?', '+', '0',
    0, 'W', 'S', 'X', KEY_DEL, '7', '4', '1',
    KEY_ENTER, 'Q', KEY_TAB, 0, '|', '8', '5', '2',
    KEY_F3, 0, KEY_F1, KEY_F2, KEY_ESC, '9', '6', '3',

    /* Русская раскладка */
    '6', 'г', 'о', 'ь', '7', 'ш', 'л', 'б',
    '5', 'н', 'р', 'т', '8', 'щ', 'д', 'ю',
    '4', 'е', 'п', 'и', '9', 'з', 'ж', 'ё',
    0, 0, KEY_ALT, 0, 0, KEY_BACKSPACE, 0, ' ',
    '3', 'к', 'а', 'м', '0', 'х', 'э', ',',
    '2', 'у', 'в', 'с', '-', 'ъ', ':', '.',
    '1', KEY_DEL, 'ф', 'я', '^', '/', ';', KEY_INSERT,
    0, 'ц', 'ы', 'ч', KEY_DEL, KEY_HOME, KEY_LEFT, KEY_END,
    KEY_ENTER, 'й', KEY_TAB, 0, '\\', KEY_UP, KEY_EXT_5, KEY_DOWN,
    KEY_F3, 0, KEY_F1, KEY_F2, KEY_ESC, KEY_PG_UP, KEY_RIGHT, KEY_PG_DN,

    /* Русская раскладка + shift */
    '&', 'Г', 'О', 'Ь', '\'', 'Ш', 'Л', 'Б',
    '%', 'Н', 'Р', 'Т', '(', 'Щ', 'Д', 'Ю',
    '$', 'Е', 'П', 'И', ')', 'X', 'Ж', 'Ё',
    0, 0, KEY_ALT, 0, 0, KEY_BACKSPACE, 0, ' ',
    '#', 'К', 'А', 'М', '_', 'X', 'Э', '<',
    '\"', 'У', 'В', 'С', '=', 'Ъ', '*', '>',
    '!', '.', 'Ф', 'Я', '~', '?', '+', '0',
    0, 'Ц', 'Ы', 'Ч', KEY_DEL, '7', '4', '1',
    KEY_ENTER, 'Й', KEY_TAB, 0, '|', '8', '5', '2',
    KEY_F3, 0, KEY_F1, KEY_F2, KEY_ESC, '9', '6', '3'
};

// clang-format on

void CheckKeyboard(void) {
    /* Если буфер пуст, то выход с флагом Z */
    hl = key_read_l_write_h;
    compare(a = h, l);
}

void ReadKeyboard(void) {
    /* Если буфер пуст, то выход с флагом Z */
    hl = key_read_l_write_h;
    if ((a = h) == l)
        return; /* Флаг Z */

    /* Считывание из буфера в D */
    h = (uintptr_t)key_buffer >> 8;
    d = *hl;
    l++;

    /* Если конца буфера, то переход на начало */
    a = l;
    if (a == (((uintptr_t)key_buffer + KEY_BUFFER_SIZE) & 0xFF))
        a = key_buffer;
    key_read = a;

    (a ^= a)++; /* Флаг NZ */
    a = d;
}

static void KeyPressed(/* a - скан-код клавиши, e - модификаторы */) {
    d = a;
    /* Повторные нажатия */
    hl = key_pressed;
    if (a == l) {
        hl = &key_delay;
        (*hl)--;
        if (flag_nz)
            return;
        *hl = NEXT_REPLAY_DELAY;
    } else {
        key_pressed = a;
        hl = &key_delay;
        *hl = FIRST_REPLAY_DELAY;
    }

    /* Обработка специальных клавиш */
    if (a == SCAN_LAT) {
        key_rus = (a ^= a);
        return;
    }
    if (a == SCAN_RUS) {
        key_rus = a = LAYOUT_SIZE;
        return;
    }
    if (a == SCAN_CAP) {
        a = key_leds;
        a ^= MOD_CAPS;
        key_leds = a;
        return;
    }
    if (a == SCAN_NUM) {
        a = key_leds;
        a ^= MOD_NUM;
        key_leds = a;
        return;
    }

    /* Если нажат CTR, то сканирование по таблице ctrLayout */
    if (flag_nz((a = e) &= MOD_CTR)) {
        h = 0;
        l = d;
        hl += (de = ctlLayout);
        a = *hl;
        KeyPush(a);
        return;
    }

    /* Как влияет SHIFT, CAP, NUM, RUS на нажатую клавишу */
    a = key_rus;
    a += d;
    h = 0;
    l = a;
    hl += (bc = shiftLayout);
    a = *hl;

    /* Выбор таблицы в зависимости от SHIFT, CAP, NUM, RUS */
    hl = 0;
    if (flag_c(a += a)) { /* CAPS + SHIFT */
        if (flag_nz((a = e) &= MOD_SHIFT))
            l = LAYOUT_SIZE;
        if (flag_z((a = e) &= MOD_CAPS))
            l = ((a = LAYOUT_SIZE) -= l);
    } else if (flag_c(a += a)) { /* SHIFT */
        if (flag_nz((a = e) &= MOD_SHIFT))
            l = LAYOUT_SIZE;
    } else if (flag_c(a += a)) { /* NUM */
        if (flag_z((a = e) &= MOD_NUM))
            l = LAYOUT_SIZE;
    }

    /* Преобразование по таблице */
    a = l;
    a += d;
    l = a;
    de = key_layout_table;
    if ((a = key_rus) != 0)
        de = key_layout_table + LAYOUT_SIZE * 2;
    hl += de;
    a = *hl;

    KeyPush(a);
}

static void KeyPush(/* a - код клавиши */) {
    push_pop(hl) {
        /* Сохранение кода клавиши */
        hl = key_write;
        h = (uintptr_t)key_buffer >> 8;
        *hl = a;

        /* Увеличение указателя записи */
        a = l;
        a++;
        if (a == (((uintptr_t)key_buffer + KEY_BUFFER_SIZE) & 0xFF))
            a = key_buffer;

        /* Если увеличение указателя не приведет к потере буфера */
        hl = key_read;
        if (a != l)
            key_write = a;
    }
}

void KeyboardInterrupt(void) {
    /* Сканирование клавиш CTL, SHIFT */
    out(PORT_KEYBOARD, (a = key_leds) |= 8);
    a = in(PORT_KEYBOARD);
    a &= 8;
    a = key_leds;
    if (flag_nz)
        a |= MOD_CTR;
    e = a;
    out(PORT_KEYBOARD, (a = key_leds) |= 3);
    a = in(PORT_KEYBOARD);
    a &= 8;
    if (flag_nz)
        e = ((a = MOD_SHIFT) |= e);

    /* Сканирование остальных клавиш */
    b = 9;
    do {
        out(PORT_KEYBOARD, (a = key_leds) |= b);
        a = in(PORT_KEYBOARD);
        if (flag_nz(a |= a)) {
            c = 7;
            do {
                a += a;
                if (flag_c) {
                    d = a;
                    /* Номер нажатой клавиши */
                    a = b;
                    a *= 8;
                    a += c;
                    /* Пропуск CTL, SHIFT */
                    if (a != 0x1B)
                        if (a != 0x43)
                            return KeyPressed(a, e);
                    a = d;
                }
            } while (flag_p(c--));
        }
    } while (flag_p(b--));
    key_pressed = a = 0xFF;
}
