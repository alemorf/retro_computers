#include "stdafx.h"
#include "bitmap.h"
#include "output.h"
#include "src.h"
#include "asm.h"

void convertBitmap2(char* src, int w, int h, int bpl, bool t) {
  int destbpl = (w+3)/4 * (t ? 2 : 1);
  std::vector<char> dest;
  dest.resize(destbpl * h);
  char* destp = &dest[0];
  memset(destp, 0, h*destbpl);
  for(int y=0; y<h; y++)
    for(int x=0; x<w; x++) {
      int c = (*(int*)(src+x*3+(h-1-y)*bpl)) & 0xFFFFFF;
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
  write(destp, dest.size());
}

void convertBitmap1(char* src, int w, int h, int bpl, bool t) {
  int destbpl = (w+7)/8 * (t ? 2 : 1);
  std::vector<char> dest;
  dest.resize(destbpl * h);
  char* destp = &dest[0];
  memset(destp, 0, h*destbpl);
  for(int y=0; y<h; y++)
    for(int x=0; x<w; x++) {
      int c = (*(int*)(src+x*3+(h-1-y)*bpl)) & 0xFFFFFF;
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
  write(destp, dest.size());
}

bool parse_insert_bitmap() {
  bool t;
  if((t=p.ifToken("insert_bitmap2t")) || p.ifToken("insert_bitmap2")) {
    string fileName = p.needString2();
    p.needToken(",");
    int width = needAddr();
    p.needToken(",");
    int height = needAddr();
    if(step2) {
      int bpl = (width*3+3)/4*4;
      if(width<=0 || height<=0 || bpl*height+writePos>65536) p.syntaxError();
      File f;
      f.openR(fileName);
      f.setPosition(f.size64()-height*bpl);
      std::vector<char> data;
      data.resize(height*bpl+4);
      f.read(&data[0], height*bpl);
      convertBitmap2(&data[0], width, height, bpl, t);
    } else {
      int s = (width+3)/4*height*(t ? 2 : 1);
      writePos += s;
    }
    if(writePos&1) writePos++;
    return true;
  }

  if((t=p.ifToken("insert_bitmap1t")) || p.ifToken("insert_bitmap1")) {
    string fileName = p.needString2();
    p.needToken(",");
    int width = needAddr();
    p.needToken(",");
    int height = needAddr();
    if(step2) {
      int bpl = (width*3+3)/4*4;
      if(width<=0 || height<=0 || bpl*height+writePos>65536) p.syntaxError();
      File f;
      f.openR(fileName);
      f.setPosition(f.size64()-height*bpl);
      std::vector<char> data;
      data.resize(height*bpl+4);
      f.read(&data[0], height*bpl);
      convertBitmap1(&data[0], width, height, bpl, t);
    } else {
      int s = (width+7)/8*height*(t ? 2 : 1);
      writePos += s;
    }
    if(writePos&1) writePos++;
    return true;
  }

  return false;
}