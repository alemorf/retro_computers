// SD Controller for Computer "Specialst"
// (c) 26-05-2013 vinxru (aleksey.f.morozov@gmail.com)

// Based on sources CC Dharmani, Chennai (India)
// 1 May 2013 vinxru

#ifndef _SPI_ROUTINES_H_
#define _SPI_ROUTINES_H_

#include "common.h"

void spi_init();
BYTE spi_transmit(BYTE);
BYTE spi_receive();
void spi_highSpeed();

#endif
