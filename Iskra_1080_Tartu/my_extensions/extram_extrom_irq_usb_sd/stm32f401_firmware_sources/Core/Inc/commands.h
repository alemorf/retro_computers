#pragma once
#include <stdint.h>

uint8_t IsProcessRead(uint8_t device, uint32_t offset, uint8_t data[]);
uint8_t IsProcessWrite(uint8_t device, uint32_t offset, const uint8_t data[]);
