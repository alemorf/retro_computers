// ROM-диск Апогей БК01 на основе 49LF040/49LF020/49LF010
// (с) 5-12-2011 vinxru

#include <stdafx.h>
#include <assert.h>
#include "romwriter.h"
#include "vinlib/exception.h"

void RomWriter::alloc(int s) {
  buf.resize(s);
  fill(buf.begin(), buf.end(), 0xFF);
  ptr = 1;
}

void RomWriter::put(const void* wptr, unsigned int len) {
  if(!_int(ptr, wptr, len)) 
    raise("Нет места в прошивке");
}

bool RomWriter::put_ne(const void* wptr, unsigned int len) {
  return _int(ptr, wptr, len); 
}

void RomWriter::randomPut(unsigned int ptr, const void* wptr, unsigned int len) {
  if(!_int(ptr, wptr, len))
    raise("Нет места в прошивке");
}

bool RomWriter::_int(unsigned int& ptr, const void* wptr1, unsigned int len) {
  const byte_t* wptr = (const byte_t*)wptr1;

  while(len>0) {
    uint w = ptr%(256*1024);
    uint next = (w/0x801+1)*0x801;
    if(next>=256*1024) 
      next = 256*1024;
    next += ptr-w;
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
    ptr++;
  }
  return true;
}
