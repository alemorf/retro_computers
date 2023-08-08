#pragma once

extern uint8_t cursor_blink_counter;
extern uint8_t cursor_visible;
extern uint8_t cursor_y;
extern uint8_t cursor_x;

extern uint8_t con_color_0;
extern uint8_t con_color_1;
extern uint8_t con_color_2;
extern uint8_t con_color_3;

void ConSetXlat(...);
void ConClear();
void ConReset();
void ConNextLine();
void ConUpdateColor();
