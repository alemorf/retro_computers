// SD Controller for Computer "Specialst"
// (c) 26-05-2013 vinxru (aleksey.f.morozov@gmail.com)

// Based on sources CC Dharmani, Chennai (India)
// 1 May 2013 vinxru

#include "spi.h"
#include <delay.h>

#ifndef SPI2X
#define SPI2X 0
#endif
         
void spi_init(void) {
  SPCR = 0x52; // setup SPI: Master mode, MSB first, SCK phase low, SCK idle low
  SPSR = 0x00;    
}
                    
BYTE spi_transmit(BYTE data) {
  SPDR = data;  
  while(!(SPSR & 0x80)); // Wait for transmission complete
  return SPDR;
}

BYTE spi_receive() {        
  SPDR = 0xFF;
  while(!(SPSR & 0x80)); // Wait for reception complete
  return SPDR;
}

void spi_highSpeed() {
  SPCR = 0x50;
  SPSR |= (1<<SPI2X);
  delay_ms(1);
}
