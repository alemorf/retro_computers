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

#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <c8080/delay.h>
#include <c8080/div16mod.h>
#include "lines.h"
#include "hal.h"
#include "path.h"
#include "iskra1080/keyboard.h"

uint8_t game[GAME_WIDTH][GAME_HEIGHT];
uint8_t cursorX, cursorY;
uint8_t selX, selY;
uint16_t score;
uint8_t newBalls[NEW_BALL_COUNT];
bool showPath = true;
bool soundEnabled = true;
bool showHelp = true;
uint8_t selAnimationDelay;
uint8_t selAnimationFrame;

struct HiScore hiScores[9] = {
    {"Alemorf", 400}, {"B2M", 350},  {"Eltaron", 300}, {"Error404", 250},
    {"SYSCAT", 200},  {"Mick", 150}, {"SVOFSK", 100},  {"Titus", 50},
};

// Удаляем линни из 5 шариков и больше

static void ClearLine(uint8_t x0, uint8_t y0, uint8_t dx, uint8_t dy, uint8_t length) {
    register uint8_t x, y, o, i;

    // Анимация исчезновения шариков
    uint8_t color = game[x0][y0];  // TODO: const вызывает сбой
    for (o = 0; o < REMOVE_ANIMATION_COUNT; o++) {
        x = x0;
        y = y0;
        for (i = length; i != 0; --i) {
            DrawSpriteRemove(x, y, color, o);
            x += dx;
            y += dy;
        }
        Delay(REMOVE_ANIMATION_DELAY);
    }

    // Очищаем экран и массив
    x = x0;
    y = y0;
    for (i = length; i != 0; --i) {
        game[x][y] = 0;
        DrawEmptyCell(x, y);
        x += dx;
        y += dy;
    }
}

// Ищем линни из 5 шариков и больше

static uint8_t FindLines() {
    register uint8_t x, y;
    uint8_t prevx, prevy;
    uint8_t c, n, total = 0;
    uint8_t* p;

    for (y = 0; y != GAME_HEIGHT; y++) {
        for (p = &game[0][y], x = 0; x < GAME_WIDTH;) {
            prevx = x;
            c = *p;
            ++x;
            p += GAME_WIDTH;
            if (c == 0) continue;
            while (x != GAME_WIDTH && c == *p) {
                p += GAME_WIDTH;
                ++x;
            }
            n = x - prevx;
            if (n < 5) continue;
            ClearLine(prevx, y, 1, 0, n);
            total += n;
            break;
        }
    }
    for (x = 0; x != GAME_WIDTH; ++x) {
        for (p = &game[x][0], y = 0; y < 5;) {
            c = *p;
            prevy = y;
            ++y;
            ++p;
            if (c == 0) continue;
            while (y != GAME_HEIGHT && c == *p) {
                ++p;
                ++y;
            }
            n = y - prevy;
            if (n < 5) continue;
            ClearLine(x, prevy, 0, 1, n);
            total += n;
            break;
        }
    }
    for (y = 0; y != 6; ++y) {
        for (x = 0; x != 6; ++x) {
            p = &game[x][y];
            c = *p;
            if (c == 0) continue;
            prevx = x;
            prevy = y;
            while (1) {
                ++prevy;
                ++prevx;
                p += GAME_WIDTH + 1;
                if (prevx == GAME_WIDTH) break;
                if (prevy == GAME_HEIGHT) break;
                if (c != *p) break;
            }
            n = prevy - y;
            if (n < 5) continue;
            ClearLine(x, y, 1, 1, n);
            total += n;
        }
    }
    for (y = 0; y != 6; ++y) {
        for (x = 4; x != GAME_WIDTH; ++x) {
            p = &game[x][y];
            c = *p;
            if (c == 0) continue;
            prevx = x;
            prevy = y;
            while (1) {
                ++prevy;
                --prevx;
                p += 1 - GAME_WIDTH;
                if (prevx == -1) break;
                if (prevy == GAME_HEIGHT) break;
                if (c != *p) break;
            }
            n = prevy - y;
            if (n < 5) continue;
            ClearLine(x, y, -1, 1, n);
            total += n;
        }
    }
    if (total == 0) return 0;

    // Результат был изменен, перерисуем его
    score += total * 2;
    // TODO Overflow
    DrawScoreAndCreatures();
    return 1;
}

// Посчитать кол-во свободных клеток

static uint8_t CalcFreeCellCount() {
    uint8_t* cell = &game[0][0];
    uint8_t freeCellCount = 0;
    uint8_t i;
    for (i = GAME_WIDTH * GAME_HEIGHT; i != 0; --i) {
        if (*cell == 0) freeCellCount++;
        cell++;
    }
    return freeCellCount;
}

// Вычисляем цвета новых шариков

static void GenerateNewBalls() {
    uint8_t i;
    for (i = 0; i < NEW_BALL_COUNT; i++) newBalls[i] = rand() % COLORS_COUNT + 1;
}

// Помещаем шарик в случайную свободную ячейку

struct XY {
    uint8_t x, y;
};

// Удалить линии или добавить 3 шарика.

static uint8_t GameStep(uint8_t newGame) {
    // Ищем готовые линии
    if (FindLines()) return 0;

    // Считаем кол во свободных клеток
    uint8_t freeCellCount = CalcFreeCellCount();
    if (freeCellCount == 0) return 1;  // Такого не может быть

    // Кол-во добавляемых шариков
    uint8_t newBallCount = freeCellCount;
    if (newBallCount > NEW_BALL_COUNT) newBallCount = NEW_BALL_COUNT;

    // Вычисляем координаты новых шариков
    uint8_t i;
    struct XY coords[NEW_BALL_COUNT];
    for (i = 0; i < newBallCount; i++) {
        uint8_t n = rand() % freeCellCount;
        freeCellCount--;
        uint8_t* p = &game[0][0];
        for (;;) {
            if (*p == 0) {
                if (n == 0) break;
                n--;
            }
            p++;
        }

        // Заносим шарик
        *p = newBalls[i];

        // ЗАпоминаем координаты для анимации
        coords[i].x = (p - &game[0][0]) / GAME_WIDTH;
        coords[i].y = __div_16_mod;
    }

    // Рисуем анимацию
    if (!newGame) {
        for (i = 0; i < NEW_ANIMATION_COUNT; i++) {
            uint8_t j;
            for (j = 0; j < newBallCount; j++) {
                DrawSpriteNew(coords[j].x, coords[j].y, newBalls[j], i);
            }
            Delay(NEW_ANIMATION_DELAY);
        }
    }

    // Вычисляем цвета новых шариков
    GenerateNewBalls();

    // Рисуем цвета новых шариков
    if (newGame) return 0;
    DrawHelp();

    // Ищем готовые линии
    if (FindLines()) return 0;

    // Если свободных клеток не осталось и целых линий не обнаружено, то конец игры
    return freeCellCount == 0;
}

// Добавить результат в таблицу рекордов

static void AddToHiScores() {
    // В нижнюю стрку пользователь будет вводить своё имя
    hiScores[HISCORE_COUNT - 1].score = score;
    hiScores[HISCORE_COUNT - 1].name[0] = 0;

    // Вывод таблицы на экран
    DrawHiScores(true);

    // Ввод имени
    uint8_t i = 0;
    for (;;) {
        char c = ReadKeyboard(false);
        if (c == KEY_ENTER) break;
        if (c == KEY_BACKSPACE || c == KEY_DEL) {
            if (i == 0) continue;
            --i;
            hiScores[HISCORE_COUNT - 1].name[i] = 0;
            DrawHiScoresLastLine();
            continue;
        }
        if (c < ' ') continue;
        if (i == sizeof(hiScores[HISCORE_COUNT - 1].name) - 1) continue;
        hiScores[HISCORE_COUNT - 1].name[i] = c;
        ++i;
        hiScores[HISCORE_COUNT - 1].name[i] = 0;
        DrawHiScoresLastLine();
    }

    // Анимация перемещения новой позиции вверх
    struct HiScore* p = hiScores + HISCORE_COUNT - 1;
    for (i = HISCORE_COUNT - 1; i != 0; i--) {
        if (p->score < p[-1].score) break;
        p--;
        struct HiScore tmp;
        memcpy(&tmp, p + 1, sizeof(tmp));
        memcpy(p + 1, p, sizeof(tmp));
        memcpy(p, &tmp, sizeof(tmp));
        DrawHiScoresScreen(i - 1);
        Delay(HISCORE_ANIMATION_DELAY);
    }
}

// Начать новую игру

static void NewGame() {
    cursorX = GAME_WIDTH / 2;
    cursorY = GAME_HEIGHT / 2;
    selX = NO_SEL;
    score = 0;

    uint8_t x, y;
    for (y = 0; y != GAME_HEIGHT; ++y)
        for (x = 0; x != GAME_WIDTH; ++x) game[x][y] = 0;

    GenerateNewBalls();
    GameStep(true);
    DrawScreen();
}

// Переместить шарик

static void MoveBall() {
    if (game[cursorX][cursorY] != 0) {
        if (selX != NO_SEL) DrawCell(selX, selY, game[selX][selY]);
        selX = cursorX;
        selY = cursorY;
        return;
    }

    if (selX == NO_SEL) return;

    uint8_t c = game[selX][selY];

    // Алгоритм поиска поути
    if (!PathFind()) {
        if (soundEnabled) PlaySoundCantMove();
        return;
    }

    if (showPath) {
        // Рисуем шаги на экране
        for (;;) {
            uint8_t x = path_x;
            uint8_t y = path_y;
            uint8_t dir = PathGetNextStep();
            DrawSpriteStep(x, y, dir - 1);
            DrawCell(path_x, path_y, c);
            if (path_n == LAST_STEP) break;
            if (soundEnabled) PlaySoundJump();
            Delay(STEP_ANIMATION_DELAY);
        };

        // Удаляем нарисованные шаги с экрана
        PathRewind();
        do {
            DrawEmptyCell(path_x, path_y);
            PathGetNextStep();
        } while (path_n != LAST_STEP);
    } else {
        DrawEmptyCell(selX, selY);
        DrawCell(cursorX, cursorY, c);
    }

    // Очищаем игровое поле от временных значений
    PathFree();

    // Реально перемещаем шарик. Все выше было лишь анимацией.
    game[selX][selY] = 0;
    game[cursorX][cursorY] = c;

    // Снимаем выделение
    selX = NO_SEL;

    // Добавляем 3 шарика
    if (!GameStep(false)) return;

    // Если не получилось добавить, то конец игры.

    // Если игрок набал мало очков, то просто показываем таблицу
    if (score < hiScores[HISCORE_COUNT - 1].score) {
        DrawHiScores(0);
    } else {
        AddToHiScores();
    }

    ReadKeyboard(false);
    NewGame();
}

// Анимация прыгающего шарика

static void BouncingBallAnimation() {
    if (selX == NO_SEL) return;
    selAnimationDelay++;
    if (selAnimationDelay >= BOUNCE_ANIMATION_DELAY) {
        selAnimationDelay = 0;
        DrawBouncingBall(selX, selY, game[selX][selY], selAnimationFrame);
        selAnimationFrame++;
        if (selAnimationFrame >= BOUNCE_ANIMATION_COUNT) {
            selAnimationFrame = 0;
        } else if (soundEnabled && selAnimationFrame == 4) {
            PlaySoundJump();
        }
    }
}

// Главная функция

void main() {
    Intro();
    NewGame();
    char previousPressedKey = 0;
    uint8_t keybTimeout = 0;
    for (;;) {
        // Детаем генератор случайных чисел более случайным
        (void)rand();

        // Анимация выбранного шарика
        BouncingBallAnimation();

        char pressedKey = ReadKeyboard(true);

        // Устранение дребезга контактов
        if (keybTimeout != 0) {
            keybTimeout--;
            continue;
        }

        // Только факт нажатия
        if (pressedKey == previousPressedKey) {
            Delay(50);
            continue;
        }
        previousPressedKey = pressedKey;
        if (pressedKey == 0) continue;
        keybTimeout = 50;  // TODO: magic

        switch (pressedKey) {
            case '1':
                ChangePalette();
                break;
            case '2':
                showPath ^= 1;
                DrawButton(BUTTON_PATH, showPath);
                break;
            case '3':
                soundEnabled ^= 1;
                DrawButton(BUTTON_SOUND, soundEnabled);
                break;
            case '4':
                showHelp ^= 1;
                DrawButton(BUTTON_HELP, showHelp);
                DrawHelp();
                break;
            case '5':
                DrawHiScores(0);
                ReadKeyboard(false);
                DrawScreen();
                break;
            case '6':
                NewGame();
                break;
            case KEY_UP:
                ClearCursor();
                if (cursorY == 0)
                    cursorY = GAME_HEIGHT - 1;
                else
                    cursorY--;
                DrawCursor();
                break;
            case KEY_DOWN:
                ClearCursor();
                if (cursorY == GAME_HEIGHT - 1)
                    cursorY = 0;
                else
                    cursorY++;
                DrawCursor();
                break;
            case KEY_LEFT:
                ClearCursor();
                if (cursorX == 0)
                    cursorX = GAME_WIDTH - 1;
                else
                    cursorX--;
                DrawCursor();
                break;
            case KEY_RIGHT:
                ClearCursor();
                if (cursorX == GAME_WIDTH - 1)
                    cursorX = 0;
                else
                    cursorX++;
                DrawCursor();
                break;
            case KEY_ENTER:
            case KEY_RIGHT_5:
            case ' ':
                MoveBall();
                break;
        }
    }
}
