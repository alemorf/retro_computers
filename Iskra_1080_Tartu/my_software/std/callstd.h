/* Load, run and save a standard Basic and binary programs for Iskra 1080 Tartu
 * Copyright (c) 2026 Aleksey Morozov aleksey.f.morozov@gmail.com
 * aleksey.f.morozov@yandex.ru
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

#include <stdint.h>

/* Запуск стандартного Бейсика или Монитора с сохранением загруженной */
/* во встроенную память программы */
/* Если type = 0xD3, то запускается Бейсик, иначе Монитор */

void CallStd(uint8_t type);
