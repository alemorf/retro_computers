#pragma once

#include "../i1080.h"

static const int TEXT_SCREEN_HEIGHT = 25;
static const int FONT_HEIGHT = 10;
static const int FONT_WIDTH = 3;

extern uint8_t text_screen_width;

extern uint16_t DrawCharAddress __address("drawchar + 1");
extern uint16_t SetColorAddress __address("setcolor + 1");
extern uint16_t DrawCursorAddress __address("drawcursor + 1");

void SetScreenBw6();
void SetScreenColor6();
void SetColor(...);
void SetColorSave(...);
void ClearScreen();
void DrawText(...);
void DrawChar(...);
void DrawCursor(...);
void ScrollUp(...);

void SetScreenBw();
void SetScreenColor();
