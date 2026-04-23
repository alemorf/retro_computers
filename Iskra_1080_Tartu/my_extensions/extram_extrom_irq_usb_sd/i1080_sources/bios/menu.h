#pragma once

static const int MIT_RETURN = 0;
static const int MIT_SUBMENU = 1;
static const int MIT_JUMP = 2;

/* Меню
 * Вход:
 *     hl - Описание меню
 *     e - Положение курсора
 * Выход:
 *     de - Значение выбранного элемента
 */

void Menu(...);
