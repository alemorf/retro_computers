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

#include "menu.h"
#include <cmm.h>
#include "../i1080.h"
#include "graph/graph.h"
#include "keyboard.h"

static const uint8_t MENU_FIRST_ITEM_Y = 3;
static const uint8_t MENU_ITEMS_X = 3;
static const uint8_t MENU_VALUES_X = 20;
static const uint8_t MENU_COLOR_TITLE = 2;
static const uint8_t MENU_COLOR_VALUE = 3;
static const uint8_t MENU_COLOR_ITEM = 1;
static const uint8_t MENU_COLOR_CURSOR = 2;
static const uint8_t MENU_CURSOR_X = 1;

static void GetMenuItemAddress(/* hl - меню, e - номер элемента */) {
    push_pop(de) {
        push(hl);
        /* Умножение на 6, на размер элемента меню */
        d = 0;
        h = d;
        l = e;
        hl += de;
        hl += de;
        hl += hl;
        /* Пропуск заголовока меню */
        hl++;
        hl++;
        /* Смещение меню */
        pop(de);
        hl += de;
    }
}

static void FindMenuItemByCode(/* hl - меню, b - код элемента */) {
    /* Пропуск заголовока меню */
    hl++;
    hl++;

    e = 0;
    for (;;) {
        /* Если это терминатор, то выход с E = 0 и HL = "?" */
        a = *hl;
        hl++;
        a |= *hl;
        hl++;
        if (flag_z) {
            e = a;
            hl = "?";
            return;
        }
        /* Тип элемента */
        a = *hl;
        hl++;
        c = *hl;
        hl++;
        /* Если это нужный элемент, то выход с E = смещение, HL = текст */
        if (a == MIT_RETURN_ID) {
            if ((a = c) == 0) {
                if ((a = b) == *hl) {
                    hl--;
                    hl--;
                    hl--;
                    a = *hl;
                    hl--;
                    l = *hl;
                    h = a;
                    return;
                }
            }
        }
        /* Следующий элемент */
        hl++;
        hl++;
        e++;
    }
}

static void MenuMoveCursor(/* hl -  меню, e - номер элемента, b - направление */) {
    do {
        /* Перемещение курсора вверх или вниз */
        a = e;
        a += b;
        /* Выход, если был выбран самый верхний элемент */
        if (flag_m)
            return;
        e = a;
        push_pop(hl) {
            /* Адрес элемента в HL */
            GetMenuItemAddress(hl, e);
            /* Адрес текста элемента в HL */
            a = *hl;
            hl++;
            h = *hl;
            l = a;
            /* Выход, если это терминатор */
            if (flag_z((a = h) |= l)) {
                pop(hl);
                e--;
                return;
            }
            /* Продолжить цикл, если это разделитель */
            (a = *hl) |= a;
        }
    } while (flag_z);
}

void Menu(/* hl - меню, e - положение курсора */) {
    /* Скрыть меню */
    out(PORT_PALETTE(0), a = PALETTE_DARK_BLUE);
    out(PORT_PALETTE(1), a);
    out(PORT_PALETTE(2), a);
    out(PORT_PALETTE(3), a);

    /* Рисование */
    push_pop(de) {
        push_pop(hl) {
            SetColor(a = MENU_COLOR_TITLE);
            ClearScreen();
        }
        push_pop(hl) {
            /* Рисование заголовка */
            e = *hl;
            hl++;
            d = *hl;
            hl++;
            push_pop(hl) {
                swap(hl, de);
                DrawText(de = 0x301, hl);
                SetColor(a = MENU_COLOR_ITEM);
            }
            /* Рисование элементов меню */
            b = MENU_FIRST_ITEM_Y;
            for (;;) {
                /* Адрес адреса текста элемента в DE */
                e = *hl;
                hl++;
                d = *hl;
                hl++;
                /* Это последний элемент */
                if (flag_z((a = d) |= e))
                    break;
                /* Рисование текста */
                push_pop(hl, bc) {
                    swap(hl, de);
                    DrawText(d = MENU_ITEMS_X, e = b, hl);
                }
                /* Тип элемента в DE */
                e = *hl;
                hl++;
                d = *hl;
                hl++;
                /* Это переменная */
                d++;
                d--;
                if (flag_nz) {
                    push_pop(hl) {
                        push_pop(bc, de) {
                            /* Значение переменной в A */
                            b = a = *de;
                            /* Адрес подменю в HL */
                            c = *hl;
                            hl++;
                            h = *hl;
                            l = c;
                            FindMenuItemByCode(hl, b);
                        }
                        push_pop(bc) {
                            /* Рисование значения элемента */
                            SetColorSafe(a = MENU_COLOR_VALUE);
                            DrawText(d = MENU_VALUES_X, e = b, hl);
                            SetColorSafe(a = MENU_COLOR_ITEM);
                        }
                    }
                }
                /* Пропуск указателя на подменю, адреса функции */
                hl++;
                hl++;
                /* Позиция на экране */
                b++;
            }
        }
    }

    /* Показать меню */
    out(PORT_PALETTE(1), a = PALETTE_WHITE);
    out(PORT_PALETTE(2), a = PALETTE_YELLOW);
    out(PORT_PALETTE(3), a = PALETTE_CYAN);

    /* Работа */
    SetColorSafe(a = MENU_COLOR_CURSOR);
    b--;
    d = e;
    do {
        /* Рисование курсора */
        push_pop(hl) {
            if ((a = d) != e) {
                push_pop(de) {
                    e = ((a = d) += MENU_FIRST_ITEM_Y);
                    DrawText(d = MENU_CURSOR_X, hl = " ");
                }
            }
            push_pop(de) {
                e = ((a = e) += MENU_FIRST_ITEM_Y);
                DrawText(d = MENU_CURSOR_X, hl = "\x10");
            }
            d = e;
        }

        push_pop(de, hl) {
            do {
                ReadKeyboard();
            } while (flag_z);
        }

        if (a == KEY_UP) {
            MenuMoveCursor(hl, e, b = -1);
            continue;
        }

        if (a == KEY_DOWN) {
            MenuMoveCursor(hl, e, b = 1);
            continue;
        }
    } while (a != KEY_ENTER);

    push(hl, de);
    GetMenuItemAddress(hl, e);
    /* Пропуск названия элемента */
    hl++;
    hl++;
    /* Загрузка типа элемента в A */
    e = *hl;
    hl++;
    d = *hl;
    hl++;
    /* Проверка типа элемента */
    if ((a = d) == 0) {
        a = e;
        if (a == MIT_RETURN_ID) {
            /* Выход с кодом элемента в HL */
            d = *hl;
            hl++;
            h = *hl;
            l = d;
            pop(de, de);
            return;
        }
        if (a == MIT_EXECUTE_ID) {
            /* Запуск подпрограммы */
            d = *hl;
            hl++;
            h = *hl;
            l = d;
            pop(de, de);
            return hl();
        }
    }
    /* Текущее значение в B */
    b = a = *de;
    push_pop(de) {
        /* Адрес подменю в HL */
        d = *hl;
        hl++;
        h = *hl;
        l = d;
        /* Курсор на выбранный элемент */
        push_pop(hl) {
            FindMenuItemByCode(b, hl);
        }
        /* Запуск подменю */
        Menu(hl);
    }
    /* Изменение значения */
    *de = a = l;
    /* Перезапуск меню */
    pop(hl, de);
    Menu(hl, de);
}
