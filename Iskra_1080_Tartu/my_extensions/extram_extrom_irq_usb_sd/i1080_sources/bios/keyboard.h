#pragma once

extern uint8_t frame_counter;
extern uint8_t key_rus;

const int MOD_CTR = 1;
const int MOD_SHIFT = 2;
const int MOD_CAPS = 0x10;
const int MOD_NUM = 0x20;

#define KEY_BUFFER_SIZE 16

void ReadKeyboard();
void CheckKeyboard();
