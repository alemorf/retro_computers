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

#include <stdint.h>

enum { MIT_SEPARATOR_ID, MIT_RETURN_ID, MIT_EXECUTE_ID };

#define MENU_SEPARATOR "", MIT_SEPARATOR_ID, 0
#define MENU_RETURN(TEXT, VALUE) (TEXT), MIT_RETURN_ID, (VALUE)
#define MENU_EXECUTE(TEXT, FUNCTION_ADDRESS) (TEXT), MIT_EXECUTE_ID, (FUNCTION_ADDRESS)
#define MENU_VARIABLE(TEXT, VARIABLE_ADDRESS, SUBMENU) (TEXT), (VARIABLE_ADDRESS), (SUBMENU)
#define MENU_END 0

void Menu(/* hl - меню, e - положение курсора */);
