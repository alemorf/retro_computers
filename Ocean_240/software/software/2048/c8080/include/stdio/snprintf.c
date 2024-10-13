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

#include <stdio.h>
#include "__printf.h"

static void __snprintf(char *buffer, size_t buffer_size, const char *format, va_list va) {
    __printf_out_pointer = buffer;
    size_t s = buffer_size;
    if (s > 0)
        s--;
    __printf_out_end = buffer + s;
    __printf(format, va);
    if (buffer_size != 0)
        *__printf_out_pointer = '\0';
}

int __stdcall snprintf(char *buffer, size_t buffer_size, const char *format, ...) {
    va_list va;
    va_start(va, format);
    __snprintf(buffer, buffer_size, format, va);
    va_end(va);
    return __printf_out_total;
}
