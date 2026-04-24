/*
 * Iskra 1080 Extension card firmware
 * Copyright (c) 2026 Aleksey Morozov aleksey.f.morozov@gmail.com aleksey.f.morozov@yandex.ru
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

#define SET_HL_A_PLUS_CONST(CONST)             \
    {                                          \
        l = (a += (CONST));                    \
        carry_add(a, (uintptr_t)(CONST) >> 8); \
        h = (a -= l);                          \
    }

#define ADD_HL_A         \
    {                    \
        l = (a += l);    \
        carry_add(a, h); \
        h = (a -= l);    \
    }

#define MEMCPY8(T, F, S)        \
    {                           \
        hl = (T);               \
        de = (F);               \
        c = (S);                \
        do {                    \
            *hl = a = *de;      \
            hl++;               \
            de++;               \
        } while (flag_nz(c--)); \
    }

#define A_MUL_5(TMP) \
    {                \
        TMP = a;     \
        a += a += a; \
        a += TMP;    \
    }
