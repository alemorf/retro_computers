/*
 * i8080 stdlib
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

#include <c8080/printfinternal.h>
#include <c8080/uint16tostring.h>

// TODO: В процессе!

int __stdcall (*printfOut)(int c);
char* printfOutPointer;
char* printfOutEnd;
size_t printfOutTotal;

void printfText(const char *text) {
    for (;;) {
        uint8_t c = *text;
        if (c == 0) break;
        printfOut(c);
        text++;
    }
}

static void printSpaces(unsigned need, unsigned ready) {
    if (ready >= need) return;
    need -= ready;
    do {
        printfOut(' ');
        need--;
    } while(need != 0);
}

void printfInternal(const char* format, va_list va) {
    printfOutTotal = 0;
    char buf[UINT16_TO_STRING_SIZE];
    for (;;) {
        uint8_t c = *format;
        switch (c) {
            case 0:
                return;
            case '%':
                unsigned width = 0;
                format++;
                c = *format;
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
                switch (c) {
                    case 0:
                        return;
                    case 'u':
                    case 'd':
                    case 'i': {
                        unsigned i = va_arg(va, unsigned);
                        if (c != 'u' && (int16_t)i < 0) {
                            printfOut('-');
                            i = 0 - i;
                        }
                        char* text = Uint16ToString(buf, (uint16_t)i);
                        printSpaces(width, &buf[UINT16_TO_STRING_SIZE] - text);
                        printfText(text);
                        break;
                    }
                    case 's': {
                        uint16_t prevTotal = printfOutTotal;
                        printfText(va_arg(va, char*));
                        printSpaces(width, printfOutTotal - prevTotal);
                        break;
                    }
                }
                break;
            default:
                printfOut(c);
        }
        format++;
    }
}
