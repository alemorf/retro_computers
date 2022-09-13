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

#pragma once

#include <stddef.h>
#include <stdint.h>
#include <c8080/c8080.h>

__link("memcmp.c") int8_t __fastcall memcmp(const void* buffer1, const void* buffer2, size_t size);
__link("memcpy.c") void* __fastcall memcpy(void* destination, const void* source, size_t size);
__link("memmove.c") void* __fastcall memmove(void* destination, const void* source, size_t size);
__link("memset.c") void* __fastcall memset(void* destination, uint8_t byte, size_t size);
__link("memswap.c") void __fastcall memswap(void* buffer1, void* buffer2, size_t size);
__link("strchr.c") const char* __fastcall strchr(const char string[], char byte);
__link("strcmp.c") int8_t __fastcall strcmp(const char string1[], const char string2[]);
__link("strcpy.c") char* __fastcall strcpy(char destination[], const char source[]);
__link("strlen.c") size_t __fastcall strlen(const char string[]);
