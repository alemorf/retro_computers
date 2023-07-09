#include "keyboard.h"
#include "bios.h"
#include "console.h"
#include "graph.h"
#include "macro.h"

// TODO: ALT
// TODO: Special keys with SHIFT, CTRL, ALT

const int NEXT_REPLAY_DELAY = 3;
const int FIRST_REPLAY_DELAY = 30;

const int SCAN_LAT = 0x19;
const int SCAN_RUS = 0x18;
const int SCAN_CAP = 0x1E;
const int SCAN_NUM = 0x1C;

const int LAYOUT_SIZE = 80;

const int CURSOR_BLINK_PERIOD = 35;

uint8_t frame_counter = 0;
uint8_t key_leds = MOD_NUM;
uint8_t key_pressed = 0;
uint8_t key_delay = 0;
uint8_t key_rus = 0;
extern uint8_t key_buffer[KEY_BUFFER_SIZE];
uint8_t key_read = &key_buffer;
uint8_t key_write = &key_buffer;
extern uint16_t key_read_l_write_h __address(key_read);

/* Влияние SHIFT, CAP, NUM на нажатую клавишу */

const int SHI = 0x40;
const int CAP = 0x80;
const int NUM = 0x20;
#define CTL(C) ((C)&0x1F)

// clang-format off

uint8_t shiftLayout[] = {
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

uint8_t ctrLayout[] = {
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

uint8_t key_layout_table[] = {
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

void CheckKeyboard() {
    /* Если буфер пуст, то выходим с флагом Z */
    hl = key_read_l_write_h;
    Compare(a = h, l);
}

void ReadKeyboard() {
    /* Если буфер пуст, то выходим с флагом Z */
    hl = key_read_l_write_h;
    if ((a = h) == l)
        return; /* Флаг Z */

    /* Считываем из буфера слово в DE */
    h = &key_buffer >> 8;
    d = *hl;
    l++;

    /* Если мы достигли конца буфера, то начинаем сначала */
    a = l;
    if (a == &key_buffer + KEY_BUFFER_SIZE)
        a = &key_buffer;
    key_read = a;

    (a ^= a)++; /* Флаг NZ */
    a = d;
}

void KeyPush(...) {
    push_pop(hl) {
        hl = key_read_l_write_h;
        h = &key_buffer >> 8;
        *hl = a;
        l++;
        a = l;
        if (a == ((&key_buffer + KEY_BUFFER_SIZE) & 0xFF))
            a = &key_buffer;
        key_write = a;
    }
    // TODO: keyboard_read == keyboard_write
}

void KeyPressed() {
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

    /* Если нажат CTR, то сканируем по таблице ctrLayout */
    if (flag_nz((a = e) &= MOD_CTR)) {
        a = d;
        SET_HL_A_PLUS_CONST(&ctrLayout);
        a = *hl;
        KeyPush(a);
        return;
    }

    /* Определяем влияние SHIFT, CAP, NUM, RUS на нажатую клавишу */
    a = d;
    SET_HL_A_PLUS_CONST(&shiftLayout);
    if (flag_nz((a = key_rus) |= a)) {  // TODO: use e
        a = LAYOUT_SIZE;
        ADD_HL_A
    }
    a = *hl;

    /* Выбираем таблицу в зависимости от SHIFT, CAP, NUM, RUS */
    h = 0;
    if (flag_c(a += a)) { /* CAPS + SHIFT */
        if (flag_nz((a = e) &= MOD_SHIFT))
            h = LAYOUT_SIZE;
        if (flag_z((a = e) &= MOD_CAPS))
            h = ((a = LAYOUT_SIZE) -= h);
    } else if (flag_c(a += a)) { /* SHIFT */
        if (flag_nz((a = e) &= MOD_SHIFT))
            h = LAYOUT_SIZE;
    } else if (flag_c(a += a)) { /* NUM */
        if (flag_z((a = e) &= MOD_NUM))
            h = LAYOUT_SIZE;
    }

    /* Преобразование по таблице */
    a = d;
    a += h;
    SET_HL_A_PLUS_CONST(&key_layout_table);
    if (flag_nz((a = key_rus) |= a)) {
        a = LAYOUT_SIZE * 2;
        ADD_HL_A
    }
    a = *hl;

    return KeyPush(a);
}

void InterruptHandler() {
    /* Выходим, если не было кадрового прерывания */
    a = in(PORT_FRAME_IRQ_RESET);
    CyclicRotateRight(a);
    if (flag_c)
        return;

    /* Сброс триггера кадрового прерывания */
    out(PORT_FRAME_IRQ_RESET, a);

    /* Увеличиваем счетчик кадров */
    hl = &frame_counter;
    (*hl)++;

    /* Мигание курсора */
    if (flag_nz((a = cursor_visible) |= a)) {
        a = cursor_blink_counter;
        a--;
        if (flag_z) {
            a = cursor_visible;
            a ^= 2;
            cursor_visible = a;

            a = in(PORT_WINDOW(3));
            push_pop(a) {
                out(PORT_WINDOW(3), a = PAGE_STD);
                DrawCursor(hl = cursor_y);
            }
            out(PORT_WINDOW(3), a);

            cursor_blink_counter = a = CURSOR_BLINK_PERIOD;
        }
        cursor_blink_counter = a;
    }

    /* Сканирование клавиш CTL, SHIFT */
    out(PORT_KEYBOARD, (a = key_leds) |= 8);
    a = In(PORT_KEYBOARD);
    a &= 8;
    a = key_leds;
    if (flag_nz)
        a |= MOD_CTR;
    e = a;
    out(PORT_KEYBOARD, (a = key_leds) |= 3);
    a = In(PORT_KEYBOARD);
    a &= 8;
    if (flag_nz)
        e = ((a = MOD_SHIFT) |= e);

    /* Сканирование остальных клавиш */
    b = 9;
    do {
        out(PORT_KEYBOARD, (a = key_leds) |= b);
        a = In(PORT_KEYBOARD);
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
                    /* Пропускаем CTL, SHIFT */
                    if (a != 0x1B)      // TODO:
                        if (a != 0x43)  // TODO:
                            return KeyPressed(a);
                    a = d;
                }
            } while (flag_p(c--));
        }
    } while (flag_p(b--));
    key_pressed = a = 0xFF;
}
