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

typedef void *va_list;

#define va_start(v, arg) (v) = (void *)(&(arg) + 1)
#define va_copy(destination, source) (destination) = (source)
#define va_arg(v, type) ((v) = (char *)(v) + sizeof(type), *(type *)((char *)(v) - sizeof(type)))
#define va_end(v)
