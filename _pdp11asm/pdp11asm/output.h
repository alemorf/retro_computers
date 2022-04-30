// PDP11 Assembler (c) 15-01-2015 vinxru

#pragma once

#include <string.h>
#include <stdexcept>

class Output {
public:
  char writeBuf[65536];
  size_t writePtr;
  bool writePosChanged;
  size_t min, max;

  inline Output() {
    init();
  }

  inline void init() {
    writePtr = 0;
    writePosChanged = 0;
    min = 0xFFFF, max = 0;
    memset(writeBuf, 0, sizeof(writeBuf));
  }

  inline void write(const void* data, size_t n) {
    if(writePtr + n > 65536) throw std::runtime_error("64K overflow");
    if(min > writePtr) min = writePtr;
    memcpy(writeBuf + writePtr, data, n);
    writePtr += n;
    if(max < writePtr) max = writePtr; 
  }

  inline void write16(int n) { 
    write(&n, 2); 
  }

  inline void write8(unsigned char n) {
    write(&n, 1);
  }
};
