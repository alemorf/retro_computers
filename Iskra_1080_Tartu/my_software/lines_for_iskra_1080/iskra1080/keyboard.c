/*
 * Game "Color Lines" for Iskra 1080 Tartu
 * Copyright (c) 2022 Aleksey Morozov
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

#include "keyboard.h"
#include <c8080/numberofbit.h>

// Таблица из ПЗУ компьютера
// 36 6   75 u   6A j   6D m   37 7   69 i   6B k   60 `
// 35 5   79 y   68 h   6E n   38 8   6F o   6C l   40 @
// 34 4   74 t   67 g   62 b   39 9   70 p   5B [   9A
// 8D     8C     8B     FF     8F      8     8E     20
// 33 3   72 r   66 f   76 v   30 0   7B {   5D ]   2C ,
// 32 2   65 e   64 d   63 c   2D -   7D }   3A :   2E .
// 31 1   8A К   61 a   7A z   5E ^   2F /   3B ;   80
// FF     77 w   73 s   78 x   7F     87 З   84 Д   81
// 0D     71 q    9     0F     5C \   88 И   85 Е   82
// 92     FF     90     91     1B     89     86     83

// 26 &   55 U   4A J   4D M   27 '   49 I   4B K   60 `
// 25 %   59 Y   48 H   4E N   28 (   4F O   4C L   40 @
// 24 $   54 T   47 G   42 B   29 )   50 P   5B [   96
// 8D     8C     8B     FF     8F      8     8E     20
// 23 #   52 R   46 F   56 V   5F _   7B {   5D ]   3C <
// 22 "   45 E   44 D   43 C   3D =   7D }   2A *   3E >
// 21 !   8A К   41 A   5A Z   7E ~   3F ?   2B +   80
// FF     57 W   53 S   58 X   7F     87     84     81
// 0D     51 Q    9     FF     7C |   88     85     82
// 95     FF     93     94     1B     89     86     83

// 36 6   D3 г   DE о   EC ь   37 7   E8 ш   DB л   D1 б
// 35 5   DD н   E0 р   E2 т   38 8   E9 щ   D4 д   EE ю
// 34 4   D5 е   DF п   D8 и   39 9   D7 з   D6 ж   F1 ё
// 8D     8C     8B     FF     8F      8     8E     20
// 33 3   DA к   D0 а   DC м   30 0   E5 х   ED э   2C ,
// 32 2   E3 у   D2 в   E1 с   2D -   EA ъ   3A :   2E .
// 31 1   8A     E4 ф   EF я   5E ^   2F /   3B ;   80
// FF     E6 ц   EB ы   E7 ч   7F     87     84     81
// 0D     D9 й    9     FF     5C \   88     85     82
// 92     FF     90     91     1B     89     86     83

// 26 &   B3 Г   BE О   CC Ь   27 '   C8 Ш   BB Л   B1 Б
// 25 %   BD Н   C0 Р   C2 Т   28 (   C9 Щ   B4 Д   CE Ю
// 24 $   B5 Е   BF П   B8 И   29 )   B7 Х   B6 Ж   A1 Ё
// 8D     8C     8B     FF     8F      8     8E     20
// 23 #   BA К   B0 А   BC М   5F _   C5 Х   CD Э   3C <
// 22 "   C3 У   B2 В   C1 С   3D =   CA Ъ   2A *   3E >
// 21 !   8A     C4 Ф   CF Я   7E ~   3F ?   2B +   80
// FF     C6 Ц   CB Ы   C7 Ч   7F     87     84     81
// 0D     B9 Й    9     FF     7C |   88     85     82
// 95     FF     93     94     1B     89     86     83

static const uint8_t L = 0x80;  // Помечаем ангилийские буквы, что бы на них влиял CAPS LOCK
static const uint8_t KEYBOARD_ROWS = 10;
static const uint8_t KEYBOARD_COLUMNS = 8;
static const uint8_t KEYBOARD_SCAN_SIZE = KEYBOARD_ROWS * KEYBOARD_COLUMNS;
static const uint8_t KEYBOARD_LANGUAGE_SIZE = KEYBOARD_SCAN_SIZE * 2;
static const uint16_t KEYBOARD_TOTAL_SCAN_SIZE = KEYBOARD_LANGUAGE_SIZE * 2;
static const uint8_t SHIFT_MASK = 0x08;
static const uint8_t SHIFT_ROW = 3;

static const uint8_t scanCodes[KEYBOARD_TOTAL_SCAN_SIZE] = {
    // TODO: static
    // Латинская раскладка
    '6', L | 'u', L | 'j', L | 'm', '7', L | 'i', L | 'k', '`',                        // Ряд 0
    '5', L | 'y', L | 'h', L | 'n', '8', L | 'o', L | 'l', '@',                        // Ряд 1
    '4', L | 't', L | 'g', L | 'b', '9', L | 'p', '[', 0,                              // Ряд 2, 0 это Ё
    KEY_RUS, KEY_LAT, KEY_COP, KEY_SHIFT, KEY_NUM_LOCK, KEY_BACKSPACE, KEY_CAPS, ' ',  // Ряд 3
    '3', L | 'r', L | 'f', L | 'v', '0', '{', ']', ',',                                // Ряд 4
    '2', L | 'e', L | 'd', L | 'c', '-', '}', ':', '.',                                // Ряд 5
    '1', '.', L | 'a', L | 'z', '^', '/', ';', '0',  // Ряд 6, тут правый 0 и правая точка
    KEY_UNKNOWN1, L | 'w', L | 's', L | 'x', KEY_DEL, KEY_HOME, KEY_LEFT, KEY_END,  // Ряд 7
    KEY_ENTER, L | 'q', KEY_TAB, KEY_CTRL, '\\', KEY_UP, KEY_RIGHT_5, KEY_DOWN,     // Ряд 8
    KEY_F1, KEY_UNKNOWN2, KEY_F2, KEY_F3, KEY_ESC, KEY_PGUP, KEY_RIGHT, KEY_PGDN,   // Ряд 9

    // Латинская раскладка с нажатым Shift, либо Caps Lock для символов помеченных L
    '&', L | 'U', L | 'J', L | 'M', '\'', L | 'I', L | 'K', '`',                       // Ряд 0
    '%', L | 'Y', L | 'H', L | 'N', '(', L | 'O', L | 'L', '@',                        // Ряд 1
    '$', L | 'T', L | 'G', L | 'B', ')', L | 'P', L | '[', 0,                          // Ряд 2, 0 это Ё
    KEY_RUS, KEY_LAT, KEY_COP, KEY_SHIFT, KEY_NUM_LOCK, KEY_BACKSPACE, KEY_CAPS, ' ',  // Ряд 3
    '#', L | 'R', L | 'F', L | 'V', '_', '{', ']', '<',                                // Ряд 4
    '"', L | 'E', L | 'D', L | 'C', '=', '}', '*', '>',                                // Ряд 5
    '!', '.', L | 'A', L | 'Z', '~', '?', '+', '0',  // Ряд 6, тут правый 0 и правая точка
    KEY_UNKNOWN1, L | 'W', L | 'S', L | 'X', KEY_DEL, KEY_HOME, KEY_LEFT, KEY_END,  // Ряд 7
    KEY_ENTER, L | 'Q', KEY_TAB, KEY_CTRL, '|', KEY_UP, KEY_RIGHT_5, KEY_DOWN,      // Ряд 8
    KEY_F1, KEY_UNKNOWN2, KEY_F2, KEY_F3, KEY_ESC, KEY_PGUP, KEY_RIGHT, KEY_PGDN,   // Ряд 9

    // Русская раскладка
    '6', 'г', 'о', 'ь', '7', 'ш', 'л', 'б',                                            // Ряд 0
    '5', 'н', 'р', 'т', '8', 'щ', 'д', 'ю',                                            // Ряд 1
    '4', 'е', 'п', 'и', '9', 'з', 'ж', 'ё',                                            // Ряд 2
    KEY_RUS, KEY_LAT, KEY_COP, KEY_SHIFT, KEY_NUM_LOCK, KEY_BACKSPACE, KEY_CAPS, ' ',  // Ряд 3
    '3', 'к', 'а', 'м', '0', 'х', 'э', ',',                                            // Ряд 4
    '2', 'у', 'в', 'с', '-', 'ъ', ':', '.',                                            // Ряд 5
    '1', '.', 'ф', 'я', '^', '/', ';', '0',  // Ряд 6, тут правый 0 и правая точка
    KEY_UNKNOWN1, 'ц', 'ы', 'ч', KEY_DEL, KEY_HOME, KEY_LEFT, KEY_END,             // Ряд 7
    KEY_ENTER, 'й', KEY_TAB, KEY_CTRL, '\\', KEY_UP, KEY_RIGHT_5, KEY_DOWN,        // Ряд 8
    KEY_F1, KEY_UNKNOWN2, KEY_F2, KEY_F3, KEY_ESC, KEY_PGUP, KEY_RIGHT, KEY_PGDN,  // Ряд 9

    // Русская раскладка с нажатым Shift, либо Caps Lock для русских символов
    '&', 'Г', 'О', 'Ь', '\'', 'Ш', 'Л', 'Б',                                           // Ряд 0
    '%', 'Н', 'Р', 'Т', '(', 'Щ', 'Д', 'Ю',                                            // Ряд 1
    '$', 'Е', 'П', 'И', ')', 'З', 'Ж', 'Ё',                                            // Ряд 2
    KEY_RUS, KEY_LAT, KEY_COP, KEY_SHIFT, KEY_NUM_LOCK, KEY_BACKSPACE, KEY_CAPS, ' ',  // Ряд 3
    '#', 'К', 'А', 'М', '_', 'Х', 'Э', ',',                                            // Ряд 4
    '"', 'У', 'В', 'С', '=', 'Ъ', '*', '.',                                            // Ряд 5
    '!', '.', 'Ф', 'Я', '~', '?', '+', '0',  // Ряд 6, тут правый 0 и правая точка
    KEY_UNKNOWN1, 'Ц', 'Ы', 'Ч', KEY_DEL, KEY_HOME, KEY_LEFT, KEY_END,             // Ряд 7
    KEY_ENTER, 'Й', KEY_TAB, KEY_CTRL, '|', KEY_UP, KEY_RIGHT_5, KEY_DOWN,         // Ряд 8
    KEY_F1, KEY_UNKNOWN2, KEY_F2, KEY_F3, KEY_ESC, KEY_PGUP, KEY_RIGHT, KEY_PGDN,  // Ряд 9
};

// Номер клавиши в матрице (col + row * 8)
static const uint8_t KEY_COORD_RUS = 24;
static const uint8_t KEY_COORD_LAT = 25;
static const uint8_t KEY_COORD_CAPS = 30;

static const uint8_t MODE_RUS = 1;
static const uint8_t MODE_CAPS = 2;

static uint8_t keyboardMode = MODE_RUS;
static uint8_t keyboardPressedKey;

static uint8_t ReadKeyboardRow(uint8_t row) {
    asm {
        out (0C0h), a
        in a, (0C0h)
    }
}

uint8_t ReadKeyboard(bool noWait) {
    uint8_t keyNumber;
    for (;;) {
        uint8_t i = KEYBOARD_ROWS;
        for (;;) {
            --i;
            keyNumber = ReadKeyboardRow(i);  // TODO: Светодиоды
            if (i == SHIFT_ROW) {            // Удаляем SHIFT
                keyNumber &= ~SHIFT_MASK;
            }
            if (keyNumber != 0) break;
            if (i != 0) continue;
            keyboardPressedKey = 0;
            if (noWait) return 0;
            i = KEYBOARD_ROWS;
        }
        keyNumber = NumberOfBit(keyNumber) + i * KEYBOARD_COLUMNS;
        if (noWait) break;
        if (keyboardPressedKey == keyNumber) continue;
        keyboardPressedKey = keyNumber;
        switch (keyNumber) {
            case KEY_COORD_RUS:
                keyboardMode |= MODE_RUS;
                continue;
            case KEY_COORD_LAT:
                keyboardMode &= ~MODE_RUS;
                continue;
            case KEY_COORD_CAPS:
                keyboardMode ^= MODE_CAPS;
                continue;
        }
        break;
    }

    // Преобразовать номер клавиши в код символа
    uint8_t shiftPressed = ReadKeyboardRow(SHIFT_ROW) & SHIFT_MASK;
    const uint8_t* layout = scanCodes + keyNumber;
    if ((keyboardMode & MODE_RUS) != 0) layout += KEYBOARD_LANGUAGE_SIZE;
    if ((*layout & L) != 0)                   // LETTERS
        if ((keyboardMode & MODE_CAPS) != 0)  // CAPS LOCK
            shiftPressed ^= SHIFT_MASK;       // Применить/отменить SHIFT
    if (shiftPressed != 0) layout += KEYBOARD_SCAN_SIZE;
    char result = *layout;
    if ((keyboardMode & MODE_RUS) == 0)  // LAT
        result &= 0x7F;
    return result;
}
