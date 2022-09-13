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

#include <stdio.h>
#include <c8080/printfinternal.h>

int __stdcall printfOutString(int c) { // TODO: static
    printfOutTotal++;
    if (printfOutPointer != printfOutEnd) {
        *printfOutPointer = c;
        printfOutPointer++;
    }
}

static void snprintfInternal(char* buffer, size_t buffer_size, const char* format, va_list va) {
    printfOut = printfOutString;
    if (buffer_size > 0) buffer_size--;
    printfOutPointer = buffer;
    printfOutEnd = buffer + buffer_size;
    printfInternal(format, va);
    *printfOutPointer = 0;
}

int __stdcall snprintf(char* buffer, size_t buffer_size, const char* format, ...) {
    va_list va;
    va_start(va, format);
    snprintfInternal(buffer, buffer_size, format, va);
    va_end(va);
    return printfOutTotal;
}
