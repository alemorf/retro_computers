#include "interface.h"
#include "lines.h"
#include "font.h"
#include "sprites.h"
#include <apogey/video.h>
#include <apogey/bios.h>
#include <apogey/sound.h>
#include <apogey/screen_constrcutor.h>
#include <mem.h>
#include <music.h>

void drawChar(uchar* d, uchar c);

#define APOGEY_VIDEO_MEM ((uchar*)(0xE000-94*51-2+9))
#define APOGEY_VIDEO_BPL 94
#define COORDS(X,Y) (APOGEY_VIDEO_MEM+(X)+(Y)*APOGEY_VIDEO_BPL)

#define PLAYFIELD_Y 6
#define PLAYFIELD_X 18

uchar colors[8] = { 0x81, 0x84, 0x85, 0x88, 0x89, 0x8C, 0x80, 0x8D };

void drawChar(uchar* d, uchar c) {
  register uchar *s;

  if(c>='0' && c<='9') s = font    + 6 * (c - '0'); else
  if(c>='A' && c<='Z') s = fontEng + 6 * (c - 'A'); else
  if(c>='`' && c<='~') s = font2   + 6 * (c - '`'); else s = fontSpace;
            
  *d = *s; ++d; ++s;
  *d = *s; ++s; d += APOGEY_VIDEO_BPL - 1;
  *d = *s; ++d; ++s;
  *d = *s; ++s; d += APOGEY_VIDEO_BPL - 1;
  *d = *s; ++d; ++s;
  *d = *s;
}

void drawText(uchar* d, uchar* text) {
  uchar c;
  for(;c=*text; text++) {
    drawChar(d, c);
    d += 2; 
  }
}

void drawSprite0(uchar* dd, uchar c, char* s) {
  register uchar* d = dd;
  c = colors[c];

  *d = c;  ++d;  
  *d = *s; ++d; ++s;
  *d = *s; ++d; ++s;
  *d = *s; ++d; ++s;
  *d = *s; ++s; d += APOGEY_VIDEO_BPL - 4;
  *d = c;  ++d;  
  *d = *s; ++d; ++s;
  *d = *s; ++d; ++s;
  *d = *s; ++d; ++s;
  *d = *s; ++s; d += APOGEY_VIDEO_BPL - 4;
  *d = c;  ++d;  
  *d = *s; ++d; ++s;
  *d = *s; ++d; ++s;
  *d = *s; ++d; ++s;
  *d = *s; ++s; d += APOGEY_VIDEO_BPL - 4;
  *d = c;  ++d;  
  *d = *s; ++d; ++s;
  *d = *s; ++d; ++s;
  *d = *s; ++d; ++s;
  *d = *s;
}

void drawSprite(uchar x, uchar y, uchar c, char* s) {
  drawSprite0(COORDS(x$5 + PLAYFIELD_X, y$4+PLAYFIELD_Y), c, s);
}

void fillScreen(uchar* s) {
  uchar i;
  uchar* d = apogeyVideoMem;

  for(i=51; i; --i, d += APOGEY_VIDEO_BPL, s += 80)
    memcpy(d, s, 80);
}

extern uint op_div16_mod;

void i2s(char* buf, uint x) {
  uchar i;
  *buf = ' '; ++buf;
  *buf = ' '; ++buf;
  *buf = ' '; ++buf;
  *buf = ' '; ++buf;
  for(i=0; i<5; i++) {
    x/=10, *buf = (uchar)op_div16_mod + '0', --buf; 
    if(x==0) break;
  }
}

void drawNumber(uchar* addr, uint x) {
  char buf[16];
  i2s(buf, x);
  drawText(addr, buf);
}

uchar playerSpriteTop, kingSprite;

void superDraw(uchar* dd, uchar a, uchar b, uchar c, uchar* s, uchar w, uchar bpl) {
  register uchar* d = dd;
  for(; a; --a, d += APOGEY_VIDEO_BPL) memcpy(d, s, w);
  for(; b; --b, d += APOGEY_VIDEO_BPL, s+=bpl) memcpy(d, s, w);
  for(; c; --c, d += APOGEY_VIDEO_BPL) memcpy(d, s, w);
}

void drawScore(uint score) {
  uchar n;  

  drawNumber(COORDS(67, 1), score);

  if(score < hiScores[0].score) n = (score / (hiScores[0].score / 6));
                           else n = 7;

  if(playerSpriteTop != n) {
    playerSpriteTop = n;
    waitHorzSync();
    if(n > 6) { superDraw(COORDS(63, 6), 0, 23, 7, rightSprite, 17, 17); n=1; }
         else { superDraw(COORDS(63, 6), 6-n, 23, n, gameScreen + 63 + 12*80, 17, 80); n=0; }  
    if(kingSprite != n) {
      kingSprite = n;
      if(n) superDraw(COORDS(0, 6), 5, 16, 0, leftSprite, 18, 18);
       else superDraw(COORDS(0, 6), 0, 21, 0, gameScreen + 0 + 6*80, 18, 80);
    }
  }
}

void redrawNewBall(uchar* p, uchar c) {
  c = colors[c];
  *p = c; p += 94;
  *p = c; p += 94;
  *p = c;
}

void redrawNewBalls(uchar a, uchar b, uchar c) {
  redrawNewBall(COORDS(36, 1), a);
  redrawNewBall(COORDS(41, 1), b);
  redrawNewBall(COORDS(46, 1), c);
}

void drawOnOff(uchar n, uchar state) {
  uchar i;
  uchar* addr;

  switch(n) {
    case 0: addr = COORDS(5,  43); break;
    case 1: addr = COORDS(19, 43); break;
    case 2: addr = COORDS(34, 43); break;
    default: return;
  }

  state = state ? 0x84 : 0x80;

  for(i=0; i<4; i++, addr+=APOGEY_VIDEO_BPL)
    *addr = state;
}

void soundJumpSel() {
  register uchar x;
  SET_SOUND(0, 1000);
  for(x=255; x; x--);
  MUTE_SOUND(0);
}

void delayX(uint x) {
  while(--x);
}

void soundBadMove() {
  uchar i;
  for(i=0; i<2; i++) {
    SET_SOUND(0, 10000);
    delayX(2000);
    MUTE_SOUND(0);
    delayX(2000);
  }
}

void showGameOver() {
  drawText(COORDS(1, 39), "k");
  drawText(COORDS(4, 39), "o");
  drawText(COORDS(7, 39), "n");
  drawText(COORDS(10, 39), "e");
  drawText(COORDS(12, 39), "c  ");
}

void delayHS(uchar f) {
  while(f--)
    waitHorzSync();
}

void demo() { 
  uchar* p = music;
  uint x, s;
  uchar d;

  APOGEY_SCREEN_END(((int)startScreen), 64, 0x33, (52*94+7*2+1)*2, 1, 1);

  VG75[1] = 0x80;
  VG75[0] = 0xFF;
  VG75[0] = 0xFF;

  while(d = * p) {
    ++p;
    s = musicFreq[d-1];
    SET_SOUND(0, s);
    s += 10; 
    SET_SOUND(1, s);
    s += 15;
    SET_SOUND(2, s);
    d = *p; ++p;
    d >>= 1; 
    delayHS(d); 
    MUTE_SOUND(2);
    d <<= 1; 
    delayHS(d); 
    MUTE_SOUND(1);
    d <<= 1; 
    delayHS(d);
    MUTE_SOUND(0);
    delayHS(2);
    if(bioskey()!=255) return;
  }
  while(bioskey()==255);
}

void printCenter(uchar cl, uchar* a, char* text, uchar l) {
  uchar c;
  while(1) {
    *a = cl;   a += APOGEY_VIDEO_BPL;
    *a = cl;   a += APOGEY_VIDEO_BPL;
    *a = cl;   a += APOGEY_VIDEO_BPL;
    *a = 0x8D; a -= APOGEY_VIDEO_BPL*3-1;

    c = *text;
    ++text;
    drawChar(a, c);
    a += 2;

    c = *text;
    ++text;
    drawChar(a, c);
    a += 2;

    if(--l==0) return;
  }
}

void showRecordScreen(uchar pos) {
  register uchar *a;
  struct HiScore* h;
  uchar c, i, x, y;
  char buf[7];
  char* text;

  a = COORDS(18, 6);

  buf[0]=' ';
  buf[6]=0;

  for(i=0, h=hiScores; i<9; ++i, ++h) {
    if(i==pos) c=0x84; else c=0x80;
            
    printCenter(c, a, buf, 1);

    printCenter(c, a + 5, h->name, 4);

    i2s(buf+1, h->score);
    printCenter(c, a + 5*5, buf, 4);
    
    a += APOGEY_VIDEO_BPL*4;
  }
}

uchar topScoreNamePos[6] = { 3,3,3,2,2 };

void updateTopScore() {
  drawNumber(COORDS(5, 1), hiScores[0].score);

  drawChar(COORDS(1,  39), hiScores[0].name[0]);
  drawChar(COORDS(4,  39), hiScores[0].name[1]);
  drawChar(COORDS(7,  39), hiScores[0].name[2]);
  drawChar(COORDS(10, 39), hiScores[0].name[3]);
  drawChar(COORDS(12, 39), hiScores[0].name[4]);
  drawChar(COORDS(14, 39), hiScores[0].name[5]);
}

void initGameScreen() {
  register uchar y, x;  
  apogeyScreen3c();
  fillScreen(gameScreen);
//  apogeyScreen3c2();

  for(y=0; y<9; y++)
    for(x=0; x<9; x++)
      drawSprite(x, y, 0, emptySprite);
      
  updateTopScore();
}               	