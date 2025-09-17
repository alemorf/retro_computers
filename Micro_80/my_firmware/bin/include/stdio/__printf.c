/*
 * c8080 stdlib
 * Copyright (c) 2022 Aleksey Morozov aleksey.f.morozov@gmail.com aleksey.f.morozov@yandex.ru
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

#include "__printf.h"
#include <c8080/uint16tostring.h>
#include <c8080/uint32tostring.h>
#include <string.h>
#include <stdio.h>
#include <stddef.h>

char *__printf_out_pointer;
char *__printf_out_end;
size_t __printf_out_total;

static void __printf_out(char c) {
    __printf_out_total++;
    if (__printf_out_pointer == NULL) {
        putchar((uint8_t)c);
        return;
    }
    if (__printf_out_pointer == __printf_out_end)
        return;
    *__printf_out_pointer = c;
    __printf_out_pointer++;
}

static void __printf_text(const char *text) {
    for (;;) {
        uint8_t c = *text;
        if (c == '\0')
            break;
        __printf_out(c);
        text++;
    }
}

static void __printf_spaces(unsigned need, unsigned ready, char fill_char) {
    if (ready >= need)
        return;
    need -= ready;
    do {
        __printf_out(fill_char);
        need--;
    } while (need != 0);
}

// TODO: -  выводимое значение выравнивается по левому краю в пределах минимальной ширины поля
// TODO: +  всегда указывать знак (плюс или минус) для выводимого десятичного числового значения
// TODO:    помещать перед результатом пробел, если первый символ значения не знак
// TODO: #  «альтернативная форма» вывода значения

// TODO: hh &= 0xFF
// TODO: h  Ничего, у нас и так 16 бит
// TODO: z  Ничего, у нас и так 16 бит
// TODO: t  Ничего, у нас и так 16 бит
// TODO: j  32 бита
// TODO: l  32 бита или long double

void __printf(const char *format, va_list va) {
    __printf_out_total = 0;
    for (;;) {
        uint8_t c = *format;
        switch (c) {
            case '\0':
                return;
            case '%':
                unsigned width = 0;
                format++;
                c = *format;
                char fill_char = c == '0' ? '0' : ' ';
                if (c == '*') {
                    width = va_arg(va, unsigned);
                    format++;
                    c = *format;
                } else {
                    while (c >= '0' && c <= '9') {
                        width = width * 10 + (c - '0');
                        format++;
                        c = *format;
                    }
                }
#ifndef C8080_PRINTF_NO_LONG
                uint8_t longMode = 0;
                if (c == 'l') {
                    longMode = 1;
                    format++;
                    c = *format;
                }
#endif
                uint8_t radix = 10;
                switch (c) {
                    case 0:
                        return;
                    // TODO: o  radix = 8
                    case 'x':
                    case 'X':
                    case 'p':
                    case 'u':
                    case 'd':
                    case 'i': {
#ifndef C8080_PRINTF_NO_LONG
                        char buf[UINT32_TO_STRING_SIZE];
                        uint32_t value32 = longMode ? va_arg(va, uint32_t) : va_arg(va, uint16_t);
                        if (c == 'i' || c == 'd') {
                            if (!longMode) {
                                int16_t value = value32;  // TODO: OPTIMIZE
                                value32 = value;
                            }
                            if ((int32_t)value32 < 0) {
                                __printf_out('-');
                                value32 = -value32;
                            }
                        }
                        char *text = Uint32ToString(buf, value32, (c == 'x' || c == 'p') ? 16 : 10);
#else
                        char buf[UINT16_TO_STRING_SIZE];
                        uint16_t value16 = va_arg(va, uint16_t);
                        if ((c == 'i' || c == 'd') && (int16_t)value16 < 0) {
                            __printf_out('-');
                            value16 = 0 - value16;
                        }
                        char *text = Uint16ToString(buf, value16, (c == 'x' || c == 'p') ? 16 : 10);
#endif
                        __printf_spaces(width, strlen(text), fill_char);
                        __printf_text(text);
                        break;
                    }
                    case 'c': {
                        __printf_out(va_arg(va, uint16_t) & 0xFF);
                        break;
                    }
                    case 'n': {
                        size_t *out = va_arg(va, size_t *);
                        *out = __printf_out_total;
                        break;
                    }
                    case '%':
                        __printf_out('%');
                        break;
                    case 's': {
                        uint16_t prevTotal = __printf_out_total;
                        __printf_text(va_arg(va, char *));
                        __printf_spaces(width, __printf_out_total - prevTotal, ' ');
                        break;
                    }
                }
                break;
            default:
                __printf_out(c);
        }
        format++;
    }
}
