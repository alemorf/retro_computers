#include <radio86rk/video.h>

// Ардеса микросхем

#define VG75 ((uchar*)0xC000)
#define VT57 ((uchar*)0xE000)

// Экономный видеорежим со стандартным адресом

#define RADIO86RK_SCREEN_ECONOMY_EXT(FULL_HEIGHT, HEIGHT, TOP_INVISIBLE, FONT, BPL, FILL_EOL, HIDDEN_ATTRIB, CHAR_GEN) \
  RADIO86RK_SCREEN_ECONOMY(0x8000 - (BPL)*(HEIGHT) - (TOP_INVISIBLE)*2 - 2, FULL_HEIGHT, HEIGHT, TOP_INVISIBLE, FONT, BPL, FILL_EOL, HIDDEN_ATTRIB, CHAR_GEN)

// Экономный видеорежим с произвольным адресом

#define RADIO86RK_SCREEN_ECONOMY(MEM_ADDR, FULL_HEIGHT, HEIGHT, TOP_INVISIBLE, FONT, BPL, FILL_EOL, HIDDEN_ATTRIB, CHAR_GEN) \
  register uchar *v; \
  uchar i; \
  memset((uchar*)MEM_ADDR, 0, (HEIGHT)*(BPL)+(TOP_INVISIBLE)*2+2); \
  for(v=(uchar*)(MEM_ADDR)-1, i=TOP_INVISIBLE; i; --i) \
    v+=2, *v = 0xF1; \
  if(FILL_EOL) \
    for(i = HEIGHT; i; --i) \
      v += (BPL), *v = 0xF1; \
  ((uchar*)MEM_ADDR)[(HEIGHT)*(BPL)+(TOP_INVISIBLE)*2+1] = 0xFF; \
  radio86rkVideoMem = (uchar*)(MEM_ADDR) + (TOP_INVISIBLE)*2 + 9; \
  radio86rkVideoBpl = (BPL); \
  RADIO86RK_SCREEN_END(MEM_ADDR, FULL_HEIGHT, FONT, (HEIGHT)*(BPL)+(TOP_INVISIBLE)*2+2, HIDDEN_ATTRIB, CHAR_GEN);

// Стандартный режим экрана

#define RADIO86RK_SCREEN_STD(MEM_ADDR, FULL_HEIGHT, HEIGHT, TOP_INVISIBLE, FONT, BPL, FILL_EOL, HIDDEN_ATTRIB, CHAR_GEN) \
  register uchar *v; \
  uchar i; \
  memset((uchar*)(MEM_ADDR), 0, (FULL_HEIGHT)*(BPL)); \
  if(FILL_EOL) { \
    v = (uchar*)(MEM_ADDR)-1; \
    for(i = FULL_HEIGHT; i; --i) \
      { v += radio86rkVideoBpl; *v = 0xF1; } \
  } \
  radio86rkVideoMem = (uchar*)(MEM_ADDR) + (TOP_INVISIBLE)*(BPL) + ((HIDDEN_ATTRIB) ? 9 : 8); \
  radio86rkVideoBpl = (BPL); \
  RADIO86RK_SCREEN_END(MEM_ADDR, FULL_HEIGHT, FONT, (FULL_HEIGHT)*(BPL), HIDDEN_ATTRIB, CHAR_GEN);

// Настройка видео
//   MEM_ADDR      - адрес видеопамяти
//   FULL_HEIGHT   - количество строк в кадре (включая невидимые)
//   FONT          - высота шрифта - 1 (4 младших бита) и высота курсора (4 старших)
//   MEM_SIZE      - размер видеопамяти
//   HIDDEN_ATTRIB - скрывать спецсимволы
//   CHAR_GEN      - знакогенератор

// Длительность КСИ зависит от шрифта - (((FONT&0xF) >= 9) ? 0 : 0x40)
// Для шрифтов высотой 10 символов включается разделитель ((FONT&0xF)==9 ? 0x80 : 0)
//  VG75[0] = (((FONT&0xF) >= 9) ? 0 : (((FONT&0xF) >= 4) ? 0x40 : 0x80)) | (FULL_HEIGHT-1); \
  
#define RADIO86RK_SCREEN_END(MEM_ADDR, FULL_HEIGHT, FONT, MEM_SIZE, HIDDEN_ATTRIB, CHAR_GEN) \
  VG75[1] = 0; \
  VG75[0] = 78-1; \
  VG75[0] = (((FONT&0xF) >= 9) ? 0 : 0x40) | (FULL_HEIGHT-1); \
  VG75[0] = FONT; \
  VG75[0] = ((HIDDEN_ATTRIB) ? 0 : 0x40) | ((FONT&0xF)==9 ? 0x80 : 0) | 0x13; \
  VG75[1] = 0x23; \
  while((VG75[1] & 0x20) == 0); \
  while((VG75[1] & 0x20) == 0); \
  VT57[8] = 0x80; \
  VT57[4] = (uchar)(MEM_ADDR); \
  VT57[4] = (uchar)((MEM_ADDR)>>8); \
  VT57[5] = (uchar)((MEM_SIZE)-1); \
  VT57[5] = 0x40 | (uchar)(((MEM_SIZE)-1)>>8); \
  VT57[8] = 0xA4; \
  if(CHAR_GEN) asm { ei } else asm { di } 