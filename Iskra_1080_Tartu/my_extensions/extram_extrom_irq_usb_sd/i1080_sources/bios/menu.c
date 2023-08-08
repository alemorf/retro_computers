#include "../i1080.h"
#include "menu.h"
#include "macro.h"
#include "graph.h"
#include "keyboard.h"

/* Константы меню */

const int MENU_FIRST_ITEM_Y = 3;
const int MENU_ITEMS_X = 3;
const int MENU_VALUES_X = 20;
const int MENU_COLOR_TITLE = 2;
const int MENU_COLOR_VALUE = 3;
const int MENU_COLOR_ITEM = 1;
const int MENU_COLOR_CURSOR = 2;
const int MENU_CURSOR_X = 1;

void GetMenuItemAddress(...) {
    a = e;
    a *= 8; /* Размер опиcания элемента меню */
    a += 2; /* Заголовок элемента меню */
    ADD_HL_A
}

void MenuMoveCursor(...) {
    push_pop(hl) {
        do {
            (a = e) += b;
            /* Выходим, если это самый верхний элемент */
            if (a == 0xFF)
                break;;
            /* Выходим, если это самый нижний элемент */
            a *= 8; /* Размер опичания элемента меню */
            a += 2; /* Заголовок элемента меню */
            ADD_HL_A
            a = *hl; hl++; h = *hl; l = a; /* Адрес текста элемента в HL */
            if (((a = h) |= l) == 0) { /* Елси адрес нулевой */
                pop(hl);
                return;
            }
            /* Изменяем положение курсора */
            e = ((a = e) += b);
            /* Если это не разделитель, то выходим */
        } while((a = *hl) == 0);
    }
}

/* Поиск элемента меню
 * Вход:
 *     hl - Адрес описания меню
 *     b  - Код элемента, который нужно найти
 * Выход:
 *     zf - Флаг установлен, если элемент найден
 *     e  - Порядковый номер элемента
 *     hl - Адрес элемента + 2
 */

void MenuFindItem(...) {
    e = 0;
    hl++; hl++; /* Пропускаем заголовок меню */
    for (;;) {
        /* Выходим с фпагом NZ, если это последний элемент */
        a = *hl; hl++; a |= *hl; hl++;
        if (flag_z) {
            a++;
            return;
        }
        hl++; hl++; /* Адрес значения в HL */
        if ((a = b) == *hl) /* Если это наше значение */
            return;
        hl++; hl++; hl++; hl++; /* Cледующий элемент в HL*/
        e++;
    }
}

void Menu(...) {
    /* Скрыть меню */
    out(PORT_PALETTE(0), a = PALETTE_DARK_BLUE);
    out(PORT_PALETTE(1), a);
    out(PORT_PALETTE(2), a);
    out(PORT_PALETTE(3), a);
    out(PORT_VIDEO_MODE_0_LOW, a);
    out(PORT_VIDEO_MODE_1_HIGH, a);

    /* Рисование */
    push_pop(de) {
        /* Очистка экрана */
        push_pop(hl) {
            SetColor(a = MENU_COLOR_TITLE);
            ClearScreen();
        }
        push_pop(hl) {
            /* Рисование заголовка */
            e = *hl; hl++; d = *hl; hl++;
            push_pop(hl) {
                swap(hl, de);
                DrawText(c = 0, de = 0x301, hl);
                SetColor(a = MENU_COLOR_ITEM);
            }
            /* Рисование элементов меню */
            b = MENU_FIRST_ITEM_Y; /* Позиция на экране */
            for (;;) {
                e = *hl; hl++; d = *hl; hl++; /* Адрес адреса текста элемента в DE */
                if ((a = d) == 0) /* Это последний элемент */
                    break;
                /* Рисуем текст элемента */
                push_pop(hl, bc) {
                    swap(hl, de);
                    d = MENU_ITEMS_X;
                    e = b;
                    DrawText(c = 0, de, hl);
                }
                /* Ищем текст значения элемента по коду текущего значения и рисуем */
                hl++; hl++; hl++; hl++; /* Адрес текущего значения в HL */
                push_pop(hl, bc) {
                    e = b;
                    c = *hl; hl++; b = *hl; /* Адрес текущего значения в BC  */
                    if (((a = b) |= c) != 0) { /* Если адрес не нулевой */
                        b = a = *bc; /* Значение в B */
                        hl--; hl--; c = *hl; hl--; l = *hl; h = c; /* Адрес подменю в HL */
                        hl++; hl++; /* Пропускаем заголовок меню */
                        for (;;) {
                            /* Выходим, если это последний элемент */
                            a = *hl; hl++; a |= *hl; hl++;
                            if (flag_z)
                                break;
                            hl++; hl++; /* Адрес значения в HL */
                            if ((a = b) == *hl) { /* Если это наше значение */
                                hl--; hl--; hl--; hl--; /* Адрес адреса текста в HL*/
                                c = *hl; hl++; h = *hl; l = c; /* Адрес текста в HL */
                                SetColorSave(a = MENU_COLOR_VALUE);
                                d = MENU_VALUES_X;
                                DrawText(c = 0, de, hl);
                                SetColorSave(a = MENU_COLOR_ITEM);
                                break;
                            }
                            hl++; hl++; hl++; hl++; /* Переменная -> Следующий элемент в HL*/
                        }
                    }
                }
                hl++; hl++; /* Адрес текущего значения -> Следующий элемент в HL */
                b++; /* Позиция на экране */
            }
        }
    }

    /* Показать меню */
    out(PORT_VIDEO_MODE_0_HIGH, a);
    out(PORT_VIDEO_MODE_1_LOW, a);
    out(PORT_PALETTE(0), a = PALETTE_DARK_BLUE);
    out(PORT_PALETTE(1), a = PALETTE_WHITE);
    out(PORT_PALETTE(2), a = PALETTE_YELLOW);
    out(PORT_PALETTE(3), a = PALETTE_CYAN);

    /* Работа */
    SetColorSave(a = MENU_COLOR_CURSOR);
    b--;
    d = e;
    for(;;) {
        /* Рисование курсора */
        push_pop(hl) {
            if ((a = d) != e) {
                push_pop(de) {
                    e = ((a = d) += MENU_FIRST_ITEM_Y);
                    DrawText(c = 0, d = MENU_CURSOR_X, hl = " ");
                }
            }
            push_pop(de) {
                e = ((a = e) += MENU_FIRST_ITEM_Y);
                DrawText(c = 0, d = MENU_CURSOR_X, hl = "\x10");
            }
            d = e;
        }

        for (;;) {
            /* Ожидание нажатия клавиши */
            do {
                push_pop(de, hl)
                    ReadKeyboard();
            } while(flag_z);

            /* Обработка нажатых клавиш */
            if (a == KEY_ENTER) {
                push(hl);
                GetMenuItemAddress(hl, e);
                hl++; hl++; /* Адрес типа элемента в HL */
                a = *hl; /* Тип в A */
                if (a == MIT_RETURN) {
                    hl++; hl++; /* Адрес возвращаемого значения в HL */
                    e = *hl; hl++; d = *hl; /* Значение в DE */
                    pop(hl); /* Освобождаем стек */
                    return;
                }
                if (a == MIT_JUMP) {
                    hl++; hl++;  /* Адрес адреса перехода в HL */
                    d = *hl; hl++; h = *hl; l = d; /* Адрес перехода в HL */
                    pop(de); /* Освобождаем стек */
                    return hl();
                }
                if (a == MIT_SUBMENU) {
                    push_pop(de) { /* Сохраняем положение курсора */
                        hl++; hl++; hl++; hl++; /* Адрес адреса текущего значения в HL */
                        e = *hl; hl++; d = *hl; hl--; /* Адрес текущего значения в DE */
                        push_pop(de) {
                            b = a = *de; /* Текущее значение в B */
                            hl--; hl--; /* Адрес адреса подменю в HL */
                            d = *hl; hl++; h = *hl; l = d; /* Адрес подменю в HL */
                            push_pop(hl) {
                                MenuFindItem(b, hl);
                                if (flag_nz)
                                    e = 0;
                            }
                            Menu(hl);
                            a = e;
                        }
                        *de = a;
                    }
                }
                pop(hl);
                return Menu(hl, de);
            }
            if (a == KEY_UP) {
                MenuMoveCursor(hl, e, b = -1);
                break;
            }
            if (a == KEY_DOWN) {
                MenuMoveCursor(hl, e, b = 1);
                break;
            }
        }
    }
}
