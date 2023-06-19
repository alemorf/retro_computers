#include "bios.h"
#include "console.h"
#include "graph.h"
#include "keyboard.h"

uint8_t cursor_blink_counter = 1;
uint8_t cursor_visible = 0;
uint8_t cursor_visible_1 = 0;
uint8_t cursor_y = 0;
uint8_t cursor_x = 0;
uint8_t esc_param;
uint8_t esc_param_2;
uint16_t esc_param_ptr;

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
        DrawCursor(hl = cursor_y);
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
    ClearScreen();
}

void ConNextLine() {
    cursor_x = (a ^= a);
    a = cursor_y;
    a++;
    if (a < TEXT_SCREEN_HEIGHT) {
        cursor_y = a;
        return;
    }
    ScrollUp();
}

void ConPrintChar(...) {
    hl = cursor_y;
    DrawChar(a, hl);

    /* Координата следующего символа */
    hl = text_screen_width;
    a = cursor_x;
    a++;
    if (a < l) {
        cursor_x = a;
        return;
    }

    return ConNextLine();
}

void ConEraseInLine() {
    return; //TODO
    hl = cursor_y;
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
        cursor_y = hl = 0;
        EndConsoleChange();
        hl = &CpmConout;
    }
    entry_cpm_conout_address = hl;
}

void CpmConout() {
    /* ESC последовательности */
    a = c;
    if (a == 27) {
        entry_cpm_conout_address = hl = &CpmConoutEsc;
        return;
    }

    /* Подключаем видеопамять и стираем курсор */
    push_pop(a) {
        BeginConsoleChange();
    }

    /* ESC последовательности */
    if (a >= 28) {
        ConPrintChar(a); /* Для ускорения */
    } else if (a == 7) {
        // TODO: Beep
    } else if (a == 8) {
        a = cursor_x;
        a--;
        if (flag_p) {
            cursor_x = a;
        } else {
            a = cursor_y;
            a--;
            if (flag_p) {
                cursor_y = a;
                cursor_x = a = text_screen_width;
            }
        }
    } else if (a == 10) {
    } else if (a == 12) {
        ClearScreen();
        cursor_y = hl = 0;
    } else if (a == 26) {
        ClearScreen();
        cursor_y = hl = 0;
    } else if (a == 13) {
        ConNextLine();
    } else {
        ConPrintChar(a);
    }

    /* Отключаем видеопамять и возвращаем курсор */
    return EndConsoleChange();
}

void CpmConst() {
    CheckKeyboard();
    d = 0; /* Empty */
    if (flag_z) return;
    d--; /* Not empty */
}

void CpmConin() {
    do {
        ReadKeyboard();
    } while (flag_z);

    /* Специальные клавиши */
    if (a == KEY_F1) {
        BeginConsoleChange();
        SetScreenBw();
        ConClear();
        EndConsoleChange();
        return CpmConin();
    }
    if (a == KEY_F2) {
        BeginConsoleChange();
        ConClear();
        SetScreenColor();
        ConClear();
        EndConsoleChange();
        return CpmConin();
    }

    d = a;
}
