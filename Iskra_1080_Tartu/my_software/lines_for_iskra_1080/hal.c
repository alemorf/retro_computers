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

#include <stdlib.h>
#include <stdbool.h>
#include <cmm/delay.h>
#include <cmm/div16mod.h>
#include <string.h>
#include "unmlz.h"
#include "music.h"
#include "graph/imgTitle.h"
#include "graph/imgScreen.h"
#include "graph/imgBalls.h"
#include "graph/imgBoard.h"
#include "graph/imgPlayer.h"
#include "graph/imgPlayerD.h"
#include "graph/imgPlayerWin.h"
#include "graph/imgKingLose.h"
#include "iskra1080/drawtext.h"
#include "iskra1080/palette.h"
#include "iskra1080/drawimage.h"
#include "iskra1080/playtone.h"
#include "iskra1080/keyboard.h"
#include "iskra1080/fillrect.h"
#include "lines.h"
#include "hal.h"

static const uint8_t PLAYFIELD_Y = 28;
static const uint8_t PLAYFIELD_X = 11;
static const uint8_t HISCORE_Y = 5;
static const uint8_t BALL_IMAGE_SIZEOF = 64;
static const uint16_t BALL_IMAGE_WH = 0x210;
static const uint8_t UINT16TOSTRING_OUTPUT_SIZE = 5;
static const uint8_t RIGHT_CREATURE_Y_MAX = 14;

static uint8_t rightCreatureY;

// Вспомогательная функция

static void Uint16ToString(char* buf, uint16_t value) {
    *buf = ' ';
    ++buf;
    *buf = ' ';
    ++buf;
    *buf = ' ';
    ++buf;
    *buf = ' ';
    ++buf;
    // Тут первая цифра
    ++buf;
    *buf = 0;
    do {
        value /= 10;
        --buf;
        *buf = (uint8_t)__div_16_mod + '0';
    } while (value != 0);
}

// Звук

void PlaySoundJump() {
    PLAY_SOUND_TICK;
}

void PlaySoundCantMove() {
    PlayTone(2000, 100);
    Delay(2000);
    PlayTone(2000, 100);
}

// Игровое поле

static uint8_t* CellAddress(uint8_t x, uint8_t y) {
    return PIXELCOORDS(PLAYFIELD_X + x * 3, PLAYFIELD_Y + y * 20);
}

static void DrawBall1(uint8_t* graphAddr, uint8_t* image, uint8_t color) {
    DrawImage(graphAddr, image + (BALL_IMAGE_SIZEOF * 10) * (color - 1), BALL_IMAGE_WH);
}

static void DrawBall(uint8_t x, uint8_t y, uint8_t* image, uint8_t color) {
    DrawBall1(CellAddress(x, y), image, color);
}

static void DrawEmptyCell1(uint8_t* graphAddr) {
    DrawImage(graphAddr, imgBoard + BALL_IMAGE_SIZEOF * 4, BALL_IMAGE_WH);
}

void DrawEmptyCell(uint8_t x, uint8_t y) {
    DrawEmptyCell1(CellAddress(x, y));
}

void DrawCell1(uint8_t* graphAddr, uint8_t color) {
    uint8_t* image;
    if (color == 0)
        image = imgBoard + BALL_IMAGE_SIZEOF * 4;
    else
        image = imgBalls + (BALL_IMAGE_SIZEOF * 10) * (color - 1);
    DrawImage(graphAddr, image, BALL_IMAGE_WH);
}

void DrawCell(uint8_t x, uint8_t y, uint8_t color) {
    DrawCell1(CellAddress(x, y), color);
}

static uint8_t* removeAnimationImages[3] = {imgBalls + 5 * BALL_IMAGE_SIZEOF, imgBalls + 6 * BALL_IMAGE_SIZEOF,
                                            imgBalls + 7 * BALL_IMAGE_SIZEOF};

void DrawSpriteRemove(uint8_t x, uint8_t y, uint8_t c, uint8_t n) {
    DrawImage(CellAddress(x, y), removeAnimationImages[n] + (BALL_IMAGE_SIZEOF * 10) * (c - 1), BALL_IMAGE_WH);
}

void DrawSpriteNew1(uint8_t* graphAddress, uint8_t color, uint8_t phase) {
    DrawImage(graphAddress, imgBalls + (BALL_IMAGE_SIZEOF * 10) * (color - 1) + (4 - phase) * BALL_IMAGE_SIZEOF,
              BALL_IMAGE_WH);
}

void DrawSpriteNew(uint8_t x, uint8_t y, uint8_t color, uint8_t phase) {
    DrawSpriteNew1(CellAddress(x, y), color, phase);
}

void DrawSpriteStep(uint8_t x, uint8_t y, uint8_t color) {
    DrawImage(CellAddress(x, y), imgBoard + color * BALL_IMAGE_SIZEOF, BALL_IMAGE_WH);
    if (soundEnabled) {
        PLAY_SOUND_TICK
    }
}

static uint8_t* bouncingAnimation[6] = {imgBalls,
                                        imgBalls,
                                        imgBalls,
                                        imgBalls + BALL_IMAGE_SIZEOF * 8,
                                        imgBalls + BALL_IMAGE_SIZEOF * 9,
                                        imgBalls + BALL_IMAGE_SIZEOF * 8};

void DrawBouncingBall(uint8_t x, uint8_t y, uint8_t color, uint8_t phase) {
    uint8_t* graphAddress = CellAddress(x, y);
    if (phase == 1) {
        graphAddress[0] = 0;
        graphAddress[-0x100] = 0;
        graphAddress++;
    }
    DrawBall1(graphAddress, bouncingAnimation[phase], color);
}

static uint8_t* helpCoords[NEW_BALL_COUNT] = {
    PIXELCOORDS(20, 3),
    PIXELCOORDS(23, 3),
    PIXELCOORDS(26, 3),
};

void DrawHelp() {
    uint8_t i;
    for (i = 0; i < NEW_BALL_COUNT; i++) {
        if (showHelp != 0) {
            DrawSpriteNew1(helpCoords[i], newBalls[i], 3 /* Размер шарика */);
        } else {
            DrawEmptyCell1(helpCoords[i]);
        }
    }
}

// Курсор

static void DrawCursorXor(void* hl) {
    asm {
        ld de, 0x100 - 0x4000
        add hl, de
        ld a, 0x03
        xor (hl)
        ld (hl), a
        dec hl
        ld a, 0x02
        xor (hl)
        ld (hl), a
        dec hl
        ld a, 0x02
        xor (hl)
        ld (hl), a
        ld de, -11
        add hl, de
        ld a, 0x02
        xor (hl)
        ld (hl), a
        dec hl
        ld a, 0x02
        xor (hl)
        ld (hl), a
        dec hl
        ld a, 0x03
        xor (hl)
        ld (hl), a
        ld de, -0x300
        add hl, de
        ld a, 0xC0
        xor (hl)
        ld (hl), a
        inc hl
        ld a, 0x40
        xor (hl)
        ld (hl), a
        inc hl
        ld a, 0x40
        xor (hl)
        ld (hl), a
        ld de, 11
        add hl, de
        ld a, 0x40
        xor (hl)
        ld (hl), a
        inc hl
        ld a, 0x40
        xor (hl)
        ld (hl), a
        inc hl
        ld a, 0xC0
        xor (hl)
        ld (hl), a
    }
}

void DrawCursor() {
    DrawCursorXor(CellAddress(cursorX, cursorY));
}

void ClearCursor() {
    DrawCursor();
}

// Кнопки: Путь, Звук, Подсказка

static const uint8_t BUTTON_WIDTH_BYTES = 8;
static const uint8_t BUTTON_HEIGHT = 4;

void DrawButton(uint8_t* graphAddress, bool state) {
    uint8_t i;
    for (i = BUTTON_HEIGHT; i != 0; --i) {
        if (state) {
            memcpy(graphAddress - 0x4000, graphAddress, BUTTON_WIDTH_BYTES);
        } else {
            memset(graphAddress - 0x4000, 0, BUTTON_WIDTH_BYTES);
        }
        graphAddress += 0x100;
    }
}

// Палитра

static const uint8_t introPalette[4] = {PALETTE_BLACK, PALETTE_RED, PALETTE_CYAN, PALETTE_YELLOW};
uint8_t gamePalette[4] = {PALETTE_BLACK, PALETTE_RED, PALETTE_DARK_CYAN, PALETTE_WHITE};
uint8_t gamePalette2[4] = {PALETTE_BLACK, PALETTE_BLUE, PALETTE_DARK_YELLOW, PALETTE_WHITE};

void ChangePalette() {
    memswap(gamePalette, gamePalette2, sizeof(gamePalette));
    SetPalette(gamePalette);
}

// Заставка

void Intro() {
    SetBlackPalette();
    void* next = unmlz((uint8_t*)0xD000, imgTitle);  // TODO: replace magic
    unmlz((uint8_t*)0x9000, next);                   // TODO: replace magic
    SetPaletteSlowly(introPalette);

    // Играем мелодию
    const uint16_t* p = music;
    for (;;) {
        const uint8_t s = *p;
        p++;
        if (s == 0) {
            ReadKeyboard(false);
            break;
        }
        if (ReadKeyboard(true) != 0) break;
        PlayTone(*p, s);
        p++;
        rand();
    }
}

// Таблица рекордов

void DrawHiScoresScreen1(uint8_t i, uint8_t pos) {
    struct HiScore* h = hiScores + i;
    for (; i < HISCORE_COUNT; ++i) {
        char text[sizeof(h->name) + UINT16TOSTRING_OUTPUT_SIZE];
        memset(text, ' ', sizeof(h->name) - 1);
        memcpy(text, h->name, strlen(h->name));
        Uint16ToString(text + (sizeof(h->name) - 1), h->score);
        SetTextColor(pos == i ? 1 : 3);
        DrawText((TEXT_WIDTH - 14) / 2, (HISCORE_Y + 2) + i, 0x7F, text);
        h++;
    }
}

void DrawHiScores(bool enterNameMode) {
    SetFillRectColor(0);
    FillRect1(FILLRECTARGS(108, PLAYFIELD_Y + 18, 274, PLAYFIELD_Y + 156));
    SetTextColor(2);
    DrawText1(DRAWTEXTARGS((TEXT_WIDTH - 17) / 2, HISCORE_Y), 0x7F, "Лучшие результаты");
    if (enterNameMode != 0) {
        DrawText1(DRAWTEXTARGS((TEXT_WIDTH - 16) / 2, HISCORE_Y + 4 + HISCORE_COUNT), 0x7F, "Введите своё имя");
        DrawHiScoresScreen1(0, HISCORE_COUNT - 1);
    } else {
        DrawText1(DRAWTEXTARGS((TEXT_WIDTH - 21) / 2, HISCORE_Y + 3 + HISCORE_COUNT), 0x7F, "Нажмите любую клавишу");
        DrawText1(DRAWTEXTARGS((TEXT_WIDTH - 15) / 2, HISCORE_Y + 4 + HISCORE_COUNT), 0x7F, "для продолжения");
        DrawHiScoresScreen1(0, HISCORE_COUNT);
    }
}

void DrawHiScoresScreen(uint8_t pos) {
    DrawHiScoresScreen1(0, pos);
}

void DrawHiScoresLastLine() {
    DrawHiScoresScreen1(HISCORE_COUNT - 1, HISCORE_COUNT - 1);
}

// Очки и правый чудик

void DrawScoreAndCreatures() {
    char scoreText[UINT16TOSTRING_OUTPUT_SIZE + 1];
    Uint16ToString(scoreText, score);
    DrawText1(PIXELCOORDS(40, 7), 2, UINT16TOSTRING_OUTPUT_SIZE, scoreText);

    uint8_t n;
    if (score < hiScores[0].score) {
        n = score / (hiScores[0].score / (RIGHT_CREATURE_Y_MAX - 1));
        if (n > RIGHT_CREATURE_Y_MAX - 1) n = RIGHT_CREATURE_Y_MAX - 1;
    } else {
        n = RIGHT_CREATURE_Y_MAX;
    }

    if (rightCreatureY != n) {
        rightCreatureY = n;
        uint8_t* s;
        for (s = PIXELCOORDS(40, 168); n; --n, s += 4) DrawImage(s, imgPlayerD, 5 * 0x100 + 4);
        DrawImage(s + 46, imgPlayer, 5 * 0x100 + 50);
        if (rightCreatureY == 14) {
            DrawImage(s + 50 - 0x200, imgPlayerWin, 3 * 0x100 + 16);
            DrawImage(PIXELCOORDS(3, 54), imgKingLose, 6 * 0x100 + 62);
        }
    }
}

// Весь экран

void DrawScreen() {
    // Гасим экран
    SetBlackPaletteSlowly();

    // Рисуем фон
    void* next = unmlz((uint8_t*)0xD000, imgScreen);
    unmlz((uint8_t*)0x9000, next);

    // Ваше имя
    SetTextColor(3);
    DrawText(56, 19, 0x7F, "Вы");

    // Нужно перерисовать короля и претендента
    rightCreatureY = 0xFF;

    // Ваш результат и изображение бойца слева
    DrawScoreAndCreatures();

    // Максимальный результат
    char buf[UINT16TOSTRING_OUTPUT_SIZE + 1];
    Uint16ToString(buf, hiScores[0].score);
    DrawText1(PIXELCOORDS(3, 7), 1, UINT16TOSTRING_OUTPUT_SIZE, buf);

    // Имя набравшено максимальный результат
    DrawText(3 + (9 - strlen(hiScores[0].name)) / 2, 19, 9, hiScores[0].name);

    // Рисуем состояние кнопок
    if (showPath) DrawButton(BUTTON_PATH, true);
    if (soundEnabled) DrawButton(BUTTON_SOUND, true);
    if (showHelp) {
        DrawButton(BUTTON_HELP, true);
        DrawHelp();
    }

    uint8_t x, y;
    for (y = 0; y < GAME_HEIGHT; y++) {
        for (x = 0; x < GAME_WIDTH; x++) {
            uint8_t color = game[x][y];
            if (color != 0) DrawCell(x, y, color);
        }
    }

    DrawCursor();

    // Показываем графику
    SetPaletteSlowly(gamePalette);
}
