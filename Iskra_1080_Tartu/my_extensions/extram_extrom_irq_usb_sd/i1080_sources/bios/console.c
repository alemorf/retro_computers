#include "bios.h"
#include "console.h"
#include "graph.h"
#include "keyboard.h"
#include "macro.h"

uint8_t cursor_blink_counter = 1;
uint8_t cursor_visible = 0;
uint8_t cursor_visible_1 = 0;
uint8_t cursor_y = 0;
uint8_t cursor_x = 0;
extern uint16_t cursor_y_l_x_h __address(cursor_y);
uint8_t esc_param;
uint8_t esc_param_2;
uint16_t esc_param_ptr;
uint16_t long_code;
extern uint8_t long_code_high __address(long_code + 1);
uint8_t console_xlat[256];
uint8_t console_xlat_back[256];

/* Звуковой сигнал */
void Beep(...) {
    DisableInterrupts();
    c = 0; /* Длительность */
    do {
        out(PORT_TAPE_OUT, a);
        a = 48; /* Частота */
        do {
        } while (flag_nz(a--));
        c--;
    } while (flag_nz(c--));
    EnableInterrupts();
}

void BeginConsoleChange() {
    /* Подключаем видеопамять */
    out(PORT_WINDOW(2), a = PAGE_STD);
    out(PORT_WINDOW(3), a);

    /* Стираем курсор */
    hl = &cursor_visible;
    DisableInterrupts();
    a = *hl;
    *hl = 0;
    EnableInterrupts();
    if (a == 3) {
        DrawCursor(hl = cursor_y_l_x_h);
        a = 1;
    }
    cursor_visible_1 = a;
}

void EndConsoleChange() {
    /* Восстанавливаем курсор */
    cursor_blink_counter = a = 2;
    cursor_visible = a = cursor_visible_1;

    /* Отключаем видеопамять */
    out(PORT_WINDOW(2), a = PAGE_RAM(6));
    out(PORT_WINDOW(3), a = PAGE_RAM(7));
}

void ConReset() {
    return ConClear();
}

void ConClear() {
    cursor_visible = (a ^= a);
    cursor_x = a;
    cursor_y = a;
    return ClearScreen();
}

void ConNextLine() {
    cursor_x = (a ^= a);
    a = cursor_y;
    a++;
    if (a >= TEXT_SCREEN_HEIGHT)
        return ScrollUp();
    cursor_y = a;
}

void ConPrintChar(...) {
    /* Преобразование кодировки */
    SET_HL_A_PLUS_CONST(&console_xlat);
    a = *hl;

    /* Рисование символа */
    DrawChar(a, hl = cursor_y_l_x_h);

    /* Координата следующего символа */
    hl = text_screen_width;
    a = cursor_x;
    a++;
    if (a >= l)
        return ConNextLine();
    cursor_x = a;
}

void ConEraseInLine() {
    return; //TODO
    hl = cursor_y_l_x_h;
    for (;;) {
        push_pop(hl) {
            /* Смещение внутри байта */
            a = h;
            a &= 3;
            c = a;

            /* Смещение в байтах */
            a = h;
            CyclicRotateRight(a, 2);
            a &= 0x3F;
            Invert(a);
            h = a;
            swap(hl, de);

            /* Очистка знакоместа */
            a ^= a;
            DrawChar(c, de);
        }

        /* Координата следующего знакоместа */
        (a = h) += FONT_WIDTH;
//        if (a >= TEXT_SCREEN_WIDTH * FONT_WIDTH) return;
        h = a;
    }
}

void CpmConoutCsi2() {
    a = c;
    if (a >= '0') {
        if (a < '9' + 1) {
            c = (a -= '0');
            hl = esc_param_ptr;
            a = *hl;
            a += a; b = a; a += a += a; a += b;
            a += c;
            *hl = a;
            return;
        }
    }
    if (a == ';') {
        esc_param_ptr = hl = &esc_param_2;
        return;
    }
    entry_cpm_conout_address = hl = &CpmConout;
    if (a == 'H') {
        a = esc_param;
        if (a >= TEXT_SCREEN_HEIGHT)
            a ^= a;
        cursor_y = a;

        hl = text_screen_width;
        a = esc_param_2;
        if (a >= l)
            a ^= a;
        cursor_x = a;
        return;
    }
    if (a == 'J') {
        if ((a = esc_param) == 2) {
            ClearScreen();
        }
        return;
    }
    if (a == 'K') {
        if (flag_z((a = esc_param) |= a)) {
            ConEraseInLine();
            return;
        }
        return;
    }
    if (a == 'm') {
        if ((a = esc_param) == 0)
            return SetColor(a = 1);
        if ((a = esc_param) == 7)
            return SetColor(a = 4);
        return SetColor(a = 3);
    }
    return; // TODO: Remove, compiler bug
}

void CpmConoutCsi() {
    push_pop(bc) {
        BeginConsoleChange();
    }
    CpmConoutCsi2();
    EndConsoleChange();
}

void CpmConoutEscY1() {
    a = c;
    a -= ' ';
    hl = text_screen_width;
    if (a >= l)
        a ^= a;
    push_pop(a) {
        BeginConsoleChange();
    }
    cursor_x = a;
    cursor_y = a = esc_param;
    EndConsoleChange();
    entry_cpm_conout_address = hl = &CpmConout;
}

void CpmConoutEscY() {
    a = c;
    a -= ' ';
    if (a >= TEXT_SCREEN_HEIGHT)
        a ^= a;
    esc_param = a;
    entry_cpm_conout_address = hl = &CpmConoutEscY1;
}

void CpmConoutEsc() {
    hl = &CpmConout;
    if ((a = c) == '[') {
        esc_param = (a ^= a);
        esc_param_2 = a;
        esc_param_ptr = hl = &esc_param;
        hl = &CpmConoutCsi;
    } else if (a == 'K') {
        ConEraseInLine();
        hl = &CpmConout;
    } else if (a == 'Y') {
        hl = &CpmConoutEscY;
    } else if (a == '=') { /* For PACMAN */
        hl = &CpmConoutEscY;
    } else if (a == ';') { /* For PACMAN */
        BeginConsoleChange();
        ClearScreen();
        cursor_y_l_x_h = hl = 0;
        EndConsoleChange();
        hl = &CpmConout;
    }
    entry_cpm_conout_address = hl;
}

uint8_t console_xlat_koi7[] = {
    0x60,
    0x9e, 0x80, 0x81, 0x96, 0x84, 0x85, 0x94, 0x83, 0x95, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e,
    0x8f, 0x9f, 0x90, 0x91, 0x92, 0x93, 0x86, 0x82, 0x9c, 0x9b, 0x87, 0x98, 0x9d, 0x99, 0x97, 0x7f,
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
    0x20, 0x21, 0x22, 0x23, 0xfd, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f,
    0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f,
    0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 0x4F,
    0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5A, 0x5B, 0x5C, 0x5D, 0x5E, 0x5F,
    0x9e, 0x80, 0x81, 0x96, 0x84, 0x85, 0x94, 0x83, 0x95, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e,
    0x8f, 0x9f, 0x90, 0x91, 0x92, 0x93, 0x86, 0x82, 0x9c, 0x9b, 0x87, 0x98, 0x9d, 0x99, 0x97, 0x7f
};

uint8_t console_xlat_koi8[] = {
    0x80,
    0xc4, 0xb3, 0xda, 0xbf, 0xc0, 0xd9, 0xc3, 0xb4, 0xc2, 0xc1, 0xc5, 0xdf, 0xdc, 0xdb, 0xdd, 0xde,
    0xb0, 0xb1, 0xb2, 0xf4, 0xfe, 0xf9, 0xfb, 0xf7, 0xf3, 0xf2, 0xff, 0xf5, 0xf8, 0xfd, 0xfa, 0xf6,
    0xcd, 0xba, 0xd5, 0xf1, 0xd6, 0xc9, 0xb8, 0xb7, 0xbb, 0xd4, 0xd3, 0xc8, 0xbe, 0xbd, 0xbc, 0xc6,
    0xc7, 0xcc, 0xb5, 0xf0, 0xb6, 0xb9, 0xd1, 0xd2, 0xcb, 0xcf, 0xd0, 0xca, 0xd8, 0xd7, 0xce, 0xfc,
    0xee, 0xa0, 0xa1, 0xe6, 0xa4, 0xa5, 0xe4, 0xa3, 0xe5, 0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae,
    0xaf, 0xef, 0xe0, 0xe1, 0xe2, 0xe3, 0xa6, 0xa2, 0xec, 0xeb, 0xa7, 0xe8, 0xed, 0xe9, 0xe7, 0xea,
    0x9e, 0x80, 0x81, 0x96, 0x84, 0x85, 0x94, 0x83, 0x95, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e,
    0x8f, 0x9f, 0x90, 0x91, 0x92, 0x93, 0x86, 0x82, 0x9c, 0x9b, 0x87, 0x98, 0x9d, 0x99, 0x97, 0x9a
};

uint8_t console_xlat_1251[] = {
    0x80,
    0xB0, 0xB1, 0xB2, 0xB3, 0xB4, 0xB5, 0xB6, 0xB7, 0xB8, 0xB9, 0xBA, 0xBB, 0xBC, 0xBD, 0xBE, 0xBF, // Нестандарт
    0xC0, 0xC1, 0xC2, 0xC3, 0xC4, 0xC5, 0xC6, 0xC7, 0xC8, 0xC9, 0xCA, 0xCB, 0xCC, 0xCD, 0xCE, 0xCF, // Нестандарт
    0xD0, 0xD1, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6, 0xD7, 0xD8, 0xD9, 0xDA, 0xDB, 0xDC, 0xDD, 0xDE, 0xDF, // Нестандарт
    0xF0, 0xF1, 0xF2, 0xF3, 0xF4, 0xF5, 0xF6, 0xF7, 0xF8, 0xF9, 0xFA, 0xFB, 0xFC, 0xFD, 0xFE, 0xFF, // Нестандарт
    0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f,
    0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0x9f,
    0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7, 0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf,
    0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xee, 0xef
};

uint16_t codepages[] = {
    &console_xlat_koi7,
    &console_xlat_koi8,
    &console_xlat_1251,
};

void ConSetXlat(...) {
    /* Сброс таблиц */
    push_pop(a) {
        de = &console_xlat;
        hl = &console_xlat_back;
        a ^= a;
        b = '?';
        do {
            *hl = b;
            *de = a;
            hl++;
            de++;
        } while(flag_nz(a++));
    }

    /* Коррекция */
    if (flag_nz(a |= a)) {
        if (flag_z(a--))
            de = &console_xlat_1251;
        else if (flag_z(a--))
            de = &console_xlat_koi7;
        else
            de = &console_xlat_koi8;
        c = a = *de;
        SET_HL_A_PLUS_CONST(&console_xlat);
        do {
            de++;
            *hl = a = *de;
            hl++;
        } while(flag_nz(c++));
    }

    /* Расчет обратной таблицы */
    de = &console_xlat + 0xFF;
    c = 0xFF;
    do {
        a = *de;
        SET_HL_A_PLUS_CONST(&console_xlat_back);
        *hl = c;
        de--;
    } while(flag_nz(c--));
}

void CpmConout() {
    a = c;
    if (a == KEY_ESC) { /* ESC последовательности */
        entry_cpm_conout_address = hl = &CpmConoutEsc;
        return;
    }
    if (a == 7) /* Звук */
        return Beep();
    if (a == 10)
        return;

    /* Подключаем видеопамять и стираем курсор */
    push_pop(a) {
        BeginConsoleChange();
    }

    if (a >= 28) { /* Для ускорения */
        ConPrintChar(a);
        return EndConsoleChange();
    }
    if (a == 8) {
        a = cursor_x;
        a--;
        if (flag_p) {
            cursor_x = a;
            return EndConsoleChange();
        }
        a = cursor_y;
        a--;
        if (flag_m)
            return EndConsoleChange();
        cursor_y = a;
        a = text_screen_width;
        a--;
        cursor_x = a;
        return EndConsoleChange();
    }
    if (a == 12) {
        ClearScreen();
        cursor_y_l_x_h = hl = 0;
        return EndConsoleChange();
    }
    if (a == 26) {
        ClearScreen();
        cursor_y_l_x_h = hl = 0;
        return EndConsoleChange();
    }
    if (a == 13) {
        ConNextLine();
        return EndConsoleChange();
    }
    ConPrintChar(a);
    return EndConsoleChange();
}

uint8_t con_special_keys[] = {
    '[', 'O', 'P', 0, /* F1 */
    '[', 'O', 'Q', 0, /* F2 */
    '[', 'O', 'R', 0, /* F3 */
    '[', 'A', 0,   0, /* UP */
    '[', 'B', 0,   0, /* DOWN */
    '[', 'C', 0,   0, /* RIGHT */
    '[', 'D', 0,   0, /* LEFT */
    '[', 'E', 0,   0, /* RIGHT 5 */
    '[', 'F', 0,   0, /* END */
    '[', 'H', 0,   0, /* HOME */
    '[', '2', '~', 0, /* INS */
    '[', '3', '~', 0, /* DEL */
    '[', '5', '~', 0, /* PAGE UP */
    '[', '6', '~', 0, /* PAGE DOWN */
};

void CpmConst() {
    /* Многобайтные коды клавиш */
    a = long_code_high;
    a |= a;
    /* Если нажата клавиша */
    if (flag_z)
        CheckKeyboard();
    d = 0; /* Результат - клавиша не нажата */
    if (flag_z) return;
    d--; /* Результат - клавиша нажата */
}

void CpmConin() {
    /* Многобайтные коды клавиш */
    if (flag_nz((a = long_code_high) |= a)) {
        hl = long_code;
        d = *hl;
        hl++;
        if (flag_z((a = *hl) |= a))
            hl = 0;
        long_code = hl;
        a = d;
    } else {
        /* Ждем нажатия клавиши */
        do {
            ReadKeyboard();
        } while(flag_z);

        /* У этой клавиши многобайтный код */
        if (a >= KEY_F1) {
            a -= KEY_F1;
            a *= 4;
            SET_HL_A_PLUS_CONST(&con_special_keys);
            long_code = hl;
            a = KEY_ESC;
        }
    }
    /* Преборвазование в выбранную кодировку */
    SET_HL_A_PLUS_CONST(&console_xlat_back);
    d = *hl;
}
