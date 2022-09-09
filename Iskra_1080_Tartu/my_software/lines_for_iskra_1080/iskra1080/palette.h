#pragma once

#include <stdint.h>

static const uint8_t PALETTE_WHITE = 0;
static const uint8_t PALETTE_CYAN = 1;
static const uint8_t PALETTE_MAGENTA = 2;
static const uint8_t PALETTE_BLUE = 3;
static const uint8_t PALETTE_YELLOW = 4;
static const uint8_t PALETTE_GREEN = 5;
static const uint8_t PALETTE_RED = 6;
static const uint8_t PALETTE_XXX = 7;
static const uint8_t PALETTE_GRAY = 8;
static const uint8_t PALETTE_DARK_CYAN = 9;
static const uint8_t PALETTE_DARK_MAGENTA = 10;
static const uint8_t PALETTE_DARK_BLUE = 11;
static const uint8_t PALETTE_DARK_YELLOW = 12;
static const uint8_t PALETTE_DARK_GREEN = 13;
static const uint8_t PALETTE_DARK_RED = 14;
static const uint8_t PALETTE_BLACK = 15;

void SetBlackPalette();
void SetBlackPaletteSlowly();
void SetPaletteSlowly(const uint8_t* palette);
void SetPalette(const uint8_t* palette);
