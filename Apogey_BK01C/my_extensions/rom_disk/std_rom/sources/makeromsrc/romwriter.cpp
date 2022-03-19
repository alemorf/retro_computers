// ROM-диск Апогей БК01 на основе стандартных ПЗУ
// (с) 6-12-2011 vinxru

#include <stdafx.h>
#include <assert.h>
#include "romwriter.h"
#include "vinlib/exception.h"

void RomWriter::alloc(int s) {
  buf.resize(s);
  fill(buf.begin(), buf.end(), 0xFF);
  ptr = 0;
}

void RomWriter::put(const void* wptr, uint len) {
  if(!_int(ptr, wptr, len)) 
    raise("Нет места в прошивке");
}

bool RomWriter::put_ne(const void* wptr, uint len) {
  return _int(ptr, wptr, len); 
}

void RomWriter::randomPut(uint ptr, const void* wptr, uint len) {
  if(!_int(ptr, wptr, len))
    raise("Нет места в прошивке");
}

bool RomWriter::_int(uint& ptr, const void* wptr1, uint len) {
  const byte_t* wptr = (const byte_t*)wptr1;

  while(len>0) {
    uint next = (ptr&~0x7FFF)+0x8000;
    uint o = next-ptr;
    assert(ptr<next);
    if(len < o) {
      if(ptr+len>buf.size()) return false;
      memcpy(&buf[ptr], wptr, len);
      ptr += len;
      break;
    }
    if(ptr+o+1>buf.size()) return false;
    memcpy(&buf[ptr], wptr, o);
    wptr += o;
    ptr += o;
    len -= o;
    ptr += loader0size;
  }
  return true;
}
