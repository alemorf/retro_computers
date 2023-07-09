#pragma once

extern uint8_t cursor_blink_counter;
extern uint8_t cursor_visible;
extern uint8_t cursor_y;
extern uint8_t cursor_x;

void ConSetXlat(...);
void ConClear();
void ConReset();
void ConNextLine();
