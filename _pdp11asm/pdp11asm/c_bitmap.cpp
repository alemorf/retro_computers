// PDP11 Assembler (c) 15-01-2015 vinxru

#include "stdafx.h"
#include "compiler.h"
#include <stdint.h>
#include <vector>
#include <fstream>

static void convertBitmap2(std::vector<char>& dest, char* src, size_t w, size_t h, size_t bpl, bool t) {
  size_t destbpl = (w+3)/4 * (t ? 2 : 1);
  dest.resize(destbpl * h);
  char* destp = &dest[0];
  memset(destp, 0, h*destbpl);
  for(size_t y=0; y<h; y++) {
    for(size_t x=0; x<w; x++) {
      int32_t c = (*(int32_t*)(src+x*3+(h-1-y)*bpl)) & 0xFFFFFF;
      bool tr = c==0xFF00FF;
      if(c==0) c=0;
      else if(c==0x0000FF) c=1;
      else if(c==0x00FF00) c=2; 
      else c=3;
      if(t) {
        if(!tr) {
          if(w>=16) {
            destp[x/4+x/4/2*2+2+y*destbpl] |= c << ((x&3)*2);
            destp[x/4+x/4/2*2+y*destbpl] |= 3 << ((x&3)*2);
          } else {
            destp[x/4*2+1+y*destbpl] |= c << ((x&3)*2);
            destp[x/4*2+y*destbpl] |= 3 << ((x&3)*2);
          }
        }
      } else {
        destp[x/4+y*destbpl] |= (c << ((x&3)*2));
      }
    }
  }
}

//-----------------------------------------------------------------------------

static void convertBitmap1(std::vector<char>& dest, char* src, size_t w, size_t h, size_t bpl, bool t) {
  size_t destbpl = (w+7)/8 * (t ? 2 : 1);
  dest.resize(destbpl * h);
  char* destp = &dest[0];
  memset(destp, 0, h*destbpl);
  for(size_t y=0; y<h; y++) {
    for(size_t x=0; x<w; x++) {
      int32_t c = (*(int32_t*)(src+x*3+(h-1-y)*bpl)) & 0xFFFFFF;
      bool tr = c==0xFF00FF;
      if(c==0) c=0; else c=1;
      if(t) {
        if(!tr) {
          if(w>=16) {
            if(c) destp[x/8+x/8/2*2+2+y*destbpl] |= 1 << (x&7);
            destp[x/8+x/8/2*2+y*destbpl] |= 1 << (x&7);
          } else {
            if(c) destp[x/8*2+1+y*destbpl] |= 1 << (x&7);
            destp[x/8*2+y*destbpl] |= 1 << (x&7);
          }
        }
      } else {
        if(c) destp[x/8+y*destbpl] |= c << (x&7);
      }
    }
  }
}

//-----------------------------------------------------------------------------

bool Compiler::compileLine_bitmap() {
  bool t = p.ifToken("insert_bitmap2t");
  if(t || p.ifToken("insert_bitmap2")) {
    p.needToken(ttString2);
    Parser::TokenText fileName;
    strcpy_s(fileName, p.loadedText);
    p.needToken(",");
    size_t width = ullong2size_t(readConst3());
    p.needToken(",");
    size_t height = ullong2size_t(readConst3());
    if(step2) {
      size_t bpl = (width*3+3)/4*4;
      if(width<=0 || height<=0 || bpl*height+out.writePtr>65536) p.syntaxError();
      std::ifstream f;
      f.open(fileName, std::ifstream::in|std::ifstream::binary);
      if(!f.is_open()) p.syntaxError("Can't open file");
      f.rdbuf()->pubseekoff(-std::streamoff(height*bpl), std::fstream::end);
      std::vector<char> data;
      data.resize(height*bpl+4);
      f.rdbuf()->sgetn(&data[0], height*bpl);
      std::vector<char> dest;
      convertBitmap2(dest, &data[0], width, height, bpl, t);
      out.write(&dest[0], dest.size());
    } else {
      size_t s = (width+3)/4*height*(t ? 2 : 1);
      out.writePtr += s;
    }
    if(out.writePtr&1) out.writePtr++;
    return true;
  }

  t = p.ifToken("insert_bitmap1t");
  if(t || p.ifToken("insert_bitmap1")) {
    p.needToken(ttString2);
    Parser::TokenText fileName;
    strcpy_s(fileName, p.loadedText);
    p.needToken(",");
    size_t width = ullong2size_t(readConst3());
    p.needToken(",");
    size_t height = ullong2size_t(readConst3());
    if(step2) {
      size_t bpl = (width*3+3)/4*4;
      if(width<=0 || height<=0 || bpl*height+out.writePtr>65536) p.syntaxError();
      std::ifstream f;
      f.open(fileName, std::ifstream::in|std::ifstream::binary);
      if(!f.is_open()) p.syntaxError("Can't open file");
      f.rdbuf()->pubseekoff(-std::streamoff(height*bpl), std::fstream::end);
      std::vector<char> data;
      data.resize(height*bpl+4);
      f.rdbuf()->sgetn(&data[0], height*bpl);
      std::vector<char> dest;
      convertBitmap1(dest, &data[0], width, height, bpl, t);
      out.write(&dest[0], dest.size());
   } else {
      size_t s = (width+7)/8*height*(t ? 2 : 1);
      out.writePtr += s;
    }
    if(out.writePtr&1) out.writePtr++;
    return true;
  }

  return false;
}