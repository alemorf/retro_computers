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

#pragma once

#include <stddef.h>
#include <c8080/c8080.h>

__link("stdio/snprintf.c") int __stdcall snprintf(char *buffer, size_t bufer_size, const char *format, ...);
__link("stdio/printf.c") int __stdcall printf(const char *format, ...);
__link("stdio/getchar.c") int getchar();
__link("stdio/putchar.c") int putchar(int c);
__link("stdio/puts.c") int puts(const char* text);
