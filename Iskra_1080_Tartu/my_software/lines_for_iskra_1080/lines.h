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

#pragma once

#include <stdint.h>

static const uint8_t GAME_WIDTH = 9;
static const uint8_t GAME_HEIGHT = 9;
static const uint8_t LAST_STEP = 9;
static const uint8_t HISCORE_COUNT = 8;
static const uint8_t COLORS_COUNT = 7;
static const uint8_t NEW_BALL_COUNT = 3;
static const uint8_t NO_SEL = 0xFF;  // Значение для selX

struct HiScore {
    char name[10];
    uint16_t score;
};

extern uint8_t game[GAME_WIDTH][GAME_HEIGHT];
extern uint8_t newBalls[NEW_BALL_COUNT];
extern uint8_t cursorX, cursorY;
extern uint8_t selX, selY;
extern uint8_t showPath, showHelp, soundEnabled;
extern uint16_t score;
extern struct HiScore hiScores[HISCORE_COUNT];
