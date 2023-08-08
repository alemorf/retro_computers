#pragma once

const int MIT_RETURN = 0;
const int MIT_SUBMENU = 1;
const int MIT_JUMP = 2;

/* Меню
 * Вход:
 *     hl - Описание меню
 *     e - Положение курсора
 * Выход:
 *     de - Значение выбранного элемента
 */

void Menu(...);
