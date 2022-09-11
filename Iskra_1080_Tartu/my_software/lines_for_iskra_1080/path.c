/*
 * Game "Color Lines" for Iskra 1080 Tartu
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

#include "lines.h"
#include "path.h"

static uint8_t path_c;
uint8_t *path_p, path_n, path_x, path_y;
uint8_t *path_p1, path_n1, path_x1, path_y1;

static const uint8_t PATH_START_VAL = 10;
static const uint8_t PATH_END_VAL = 255;
static const uint8_t PATH_EMPTY_VAL = 0;

static uint8_t PathFounded(uint8_t* p) {
    path_p1 = path_p = p;
    path_x1 = path_x;
    path_y1 = path_y;
    path_n1 = path_n;
    return 1;
}

// Найти пусть от точки selX, selY до точки cursorX, cursorY

uint8_t PathFind() {
    path_c = game[selX][selY];
    game[selX][selY] = PATH_END_VAL;
    game[cursorX][cursorY] = PATH_START_VAL;

    // Ищем путь
    for (path_n = PATH_START_VAL; path_n != PATH_START_VAL + GAME_WIDTH * GAME_HEIGHT; ++path_n) {
        uint8_t* p = &game[0][0];
        for (path_x = 0; path_x != GAME_WIDTH; ++path_x) {
            for (path_y = 0; path_y != GAME_HEIGHT; ++path_y, ++p) {
                if (*p == path_n) {
                    if (path_y != 0) {
                        p--;
                        if (*p == PATH_END_VAL) {
                            --path_y;
                            return PathFounded(p);
                        } else if (*p == PATH_EMPTY_VAL)
                            *p = path_n + 1;
                        p++;
                    }
                    if (path_y != GAME_HEIGHT - 1) {
                        p++;
                        if (*p == PATH_END_VAL) {
                            ++path_y;
                            return PathFounded(p);
                        } else if (*p == PATH_EMPTY_VAL)
                            *p = path_n + 1;
                        p--;
                    }
                    if (path_x != 0) {
                        p -= GAME_HEIGHT;
                        if (*p == PATH_END_VAL) {
                            --path_x;
                            return PathFounded(p);
                        } else if (*p == PATH_EMPTY_VAL)
                            *p = path_n + 1;
                        p += GAME_HEIGHT;
                    }
                    if (path_x != GAME_WIDTH - 1) {
                        p += GAME_HEIGHT;
                        if (*p == PATH_END_VAL) {
                            ++path_x;
                            return PathFounded(p);
                        } else if (*p == PATH_EMPTY_VAL)
                            *p = path_n + 1;
                        p -= GAME_HEIGHT;
                    }
                }
            }
        }
    }

    // Путь не найден
    PathFree();
    return 0;
}

// С начала

void PathRewind() {
    path_p = path_p1;
    path_x = path_x1;
    path_y = path_y1;
    path_n = path_n1;
}

// Получить следующий шаг

uint8_t PathGetNextStep() {
    uint8_t* p = path_p;
    if (path_y != 0) {
        p--;
        if (*p == path_n) {
            --path_y;
            --path_n;
            path_p = p;
            return 1;
        }
        p++;
    }
    if (path_y != GAME_HEIGHT - 1) {
        p++;
        if (*p == path_n) {
            ++path_y;
            --path_n;
            path_p = p;
            return 2;
        }
        p--;
    }
    if (path_x != 0) {
        p -= GAME_HEIGHT;
        if (*p == path_n) {
            --path_x;
            --path_n;
            path_p = p;
            return 3;
        }
        p += GAME_HEIGHT;
    }
    if (path_x != GAME_WIDTH - 1) {
        p += GAME_HEIGHT;
        if (*p == path_n) {
            ++path_x;
            --path_n;
            path_p = p;
            return 4;
        }
    }
    return 0;
}

// Убираем мусор оставленный алгоритмом поиска пути

void PathFree() {
    register uint8_t* p;
    for (p = &game[0][0]; p != &game[GAME_WIDTH - 1][GAME_HEIGHT - 1] + 1; ++p)
        if (*p >= PATH_START_VAL) *p = PATH_EMPTY_VAL;
    game[selX][selY] = path_c;
}
