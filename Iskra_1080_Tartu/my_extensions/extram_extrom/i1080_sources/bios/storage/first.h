/*
 * Iskra 1080 Extension card firmware
 * Calculating the additional attribute "block does not contain
 * useful data" when writing
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
 *
 */

#pragma once

#include <stdint.h>

/* Дополнительная информация от CP/M: */
/* 0 - Запись данных можно отложить */
/* 1 - Нужно записать все данные на дискету сейчас */
/* 2 - Запись в блок файловой системы, который до этого не использовался */
/* Сообщается только о первом 128-секторе 1024 или 2048 байтного блока */

extern uint8_t storage_write_mode;

void CpmSelDsk(/*c*/);
void CpmRead(void);
void CpmWrite(/*c*/);
