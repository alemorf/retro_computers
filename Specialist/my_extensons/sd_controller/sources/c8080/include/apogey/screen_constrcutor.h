#include <apogey/video.h>

#define VG75 ((uchar*)0xEF00)
#define VT57 ((uchar*)0xF000)

#define APOGEY_SCREEN_ECONOMY_EXT(FULL_HEIGHT, HEIGHT, TOP_INVISIBLE, FONT, BPL, FILL_EOL, HIDDEN_ATTRIB, CHAR_GEN) \
  APOGEY_SCREEN_ECONOMY(0xE0FF - (BPL)*(HEIGHT) - (TOP_INVISIBLE)*2 - 2, FULL_HEIGHT, HEIGHT, TOP_INVISIBLE, FONT, BPL, FILL_EOL, HIDDEN_ATTRIB, CHAR_GEN)

#define APOGEY_SCREEN_ECONOMY(MEM_ADDR, FULL_HEIGHT, HEIGHT, TOP_INVISIBLE, FONT, BPL, FILL_EOL, HIDDEN_ATTRIB, CHAR_GEN) \
  register uchar *v; \
  uchar i; \
  memset((uchar*)MEM_ADDR, 0, (HEIGHT)*(BPL)+(TOP_INVISIBLE)*2+2); \
  for(v=(uchar*)(MEM_ADDR)-1, i=TOP_INVISIBLE; i; --i) \
    v+=2, *v = 0xF1; \
  if(FILL_EOL) \
    for(i = HEIGHT; i; --i) \
      v += (BPL), *v = 0xF1; \
  ((uchar*)MEM_ADDR)[(HEIGHT)*(BPL)+(TOP_INVISIBLE)*2+1] = 0xFF; \
  apogeyVideoMem = (uchar*)(MEM_ADDR) + (TOP_INVISIBLE)*2 + 8; \
  apogeyVideoBpl = (BPL); \
  APOGEY_SCREEN_END(MEM_ADDR, FULL_HEIGHT, FONT, (HEIGHT)*(BPL)+(TOP_INVISIBLE)*2+2, HIDDEN_ATTRIB, CHAR_GEN);

#define APOGEY_SCREEN_STD(MEM_ADDR, FULL_HEIGHT, HEIGHT, TOP_INVISIBLE, FONT, BPL, FILL_EOL, HIDDEN_ATTRIB, CHAR_GEN) \
  register uchar *v; \
  uchar i; \
  memset((uchar*)(MEM_ADDR), 0, (FULL_HEIGHT)*(BPL)); \
  if(FILL_EOL) { \
    v = (uchar*)(MEM_ADDR)-1; \
    for(i = FULL_HEIGHT; i; --i) \
      { v += apogeyVideoBpl; *v = 0xF1; } \
  } \
  apogeyVideoMem = (uchar*)(MEM_ADDR) + (TOP_INVISIBLE)*(BPL) + 8; \
  apogeyVideoBpl = (BPL); \
  APOGEY_SCREEN_END(MEM_ADDR, FULL_HEIGHT, FONT, (FULL_HEIGHT)*(BPL), HIDDEN_ATTRIB, CHAR_GEN);
  
#define APOGEY_SCREEN_END(MEM_ADDR, FULL_HEIGHT, FONT, MEM_SIZE, HIDDEN_ATTRIB, CHAR_GEN) \
  VG75[1] = 0; \
  VG75[0] = 78-1; \
  VG75[0] = 0x80 | (FULL_HEIGHT-1); \
  VG75[0] = FONT; \
  VG75[0] = ((HIDDEN_ATTRIB) ? 0 : 0x40) | ((FONT&0xF)==9 ? 0x80 : 0) | 0x13; \
  VT57[8] = 0x80; \
  VT57[4] = (uchar)(MEM_ADDR); \
  VT57[4] = (uchar)((MEM_ADDR)>>8); \
  VT57[5] = (uchar)((MEM_SIZE)-1); \
  VT57[5] = 0x40 | (uchar)(((MEM_SIZE)-1)>>8); \
  VT57[8] = 0xA4; \
  VG75[1] = 0x27; \
  if(CHAR_GEN) asm { ei } else asm { di } 
