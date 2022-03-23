#include <mem.h>
#include <lvov/bios.h>
#include <lvov/video.h>
#include <lvov/pilotsound.h>
#include "interface.h"
#include "string.h"
#include "lvov_sprites.h"
#include "lvov_music.h"

#define KEY_COLOR 100

uchar spriteMode = 1;

#define PLAYFIELD_Y 32
#define PLAYFIELD_X 12

void drawSprite_12_16(uchar* d, uchar* s);
void drawSpriteBallOr(uchar* d, uchar* s);
void bitBlt(uchar* d, uchar* s, uchar w, uchar h);

//---------------------------------------------------------------------------
// Расчет адреса 

uchar* cellAddr(uchar x, uchar y) {
  return COORDS(PLAYFIELD_X + x$3, PLAYFIELD_Y + y$16);
}

//---------------------------------------------------------------------------

void drawSpriteBall(uchar x, uchar y, uchar* s) {
  drawSprite_12_16(cellAddr(x, y), s);
}

//---------------------------------------------------------------------------
// Рисуем курсор

void drawCursor() {
  drawSpriteBallOr(cellAddr(cursorX, cursorY), imgBalls + 21*16*11 + 3);
}

//---------------------------------------------------------------------------
// Рисуем шарик

void drawSprite(uchar x, uchar y, uchar c) {
  if(c==0) drawSpriteBall(x, y, imgBalls + 21*16*11);
      else drawSpriteBall(x, y, imgBalls - 3 + (c + c + c));
}

//---------------------------------------------------------------------------
// Анимация исчезнование шарика

uchar* removeAnimation[5] = { imgBalls-3, imgBalls+21*16*6-3, imgBalls+21*16*7-3, imgBalls+21*16*8-3 };

void drawSpriteRemove(uchar x, uchar y, uchar s, uchar n) {
  drawSpriteBall(x, y, removeAnimation[n] + (s + s + s));
}

//---------------------------------------------------------------------------
// Анимация появляющего шарика

uchar* newAnimation[5] = { imgBalls+21*16*4-3, imgBalls+21*16*3-3, imgBalls+21*16*2-3, imgBalls+21*16*1-3, imgBalls-3 };

void drawSpriteNew(uchar x, uchar y, uchar s, uchar n) {
  drawSpriteBall(x, y, newAnimation[n] + (s + s + s));
}

//---------------------------------------------------------------------------
// Рисуем шаги на кретках

void drawSpriteStep(uchar x, uchar y, uchar n) {
  drawSpriteBall(x, y, imgBalls + 21*16*11 + 9 + (n + n + n));
}

//---------------------------------------------------------------------------
// Рисуем анимацию прыгающего шарика

uchar* selAnimation[4] = { imgBalls-3, imgBalls+21*16*9-3, imgBalls+21*16*10-3, imgBalls+21*16*9-3 };

void drawSpriteSel(uchar x, uchar y, uchar s, uchar c, uchar t) {
  drawSpriteBall(x, y, selAnimation[t] + (s+s+s));  
  if(c) drawCursor();
}

//---------------------------------------------------------------------------

uchar playerSpriteTop;
uchar kingLoseSpriteDrawed;
        
void drawPlayer(uchar y) {
  uchar i, win;
  register uchar* s;
  
  playerSpriteTop = y;
  win=0;
  if(y==18) y=17, win=1;
  for(i=18-y, s=COORDS(40, 33+9); i; --i, s+=4*LVOV_VIDEO_BPL)
    bitBlt(s, imgPlayer, 10, 4);
  bitBlt(s, imgPlayer+10*4, 10, 50); s+=50*LVOV_VIDEO_BPL;
  if(win) {
    bitBlt(COORDS(40+4, 33+9), imgPlayerWin, 4, 16);
    if(!kingLoseSpriteDrawed)  {
      kingLoseSpriteDrawed=1;
      bitBlt(COORDS(0, 33), imgKingLose, 11, 62);
    }
  } else {
    if(kingLoseSpriteDrawed)  {
      kingLoseSpriteDrawed=0;
      bitBlt(COORDS(0, 33), imgKing, 11, 62);
    }
  }
  for(i=y; i; --i, s+=4*LVOV_VIDEO_BPL)
    bitBlt(s, imgPlayer+10*54, 10, 4);
  bitBlt(s, imgPlayer+10*58, 10, 8);
}

//---------------------------------------------------------------------------

void drawScore(uint score, char* scoreText) {
  uchar n;

  TEXT_COLOR = 3;
  locate(27, 0, 255);
  puts(scoreText);

  if(score < hiScores[0].score) {
    n = (score / (hiScores[0].score / 17));
    if(n>17) n=17;
  } else {
    n = 18;
  }

  if(playerSpriteTop != n) drawPlayer(n);
}

//---------------------------------------------------------------------------
// Показываем подсказку

void redrawNewBalls(uchar a, uchar b, uchar c) {
  drawSprite_12_16(COORDS(21, 1)-spriteMode, imgBalls - 3 + (a + a + a));
  drawSprite_12_16(COORDS(24, 1),            imgBalls - 3 + (b + b + b));
  drawSprite_12_16(COORDS(27, 1)+spriteMode, imgBalls - 3 + (c + c + c));
}

//---------------------------------------------------------------------------
// Убираем подсказку

void redrawNewBallsOff() {
  drawSprite_12_16(COORDS(21, 1)-spriteMode, imgBalls + 21*16*11);
  drawSprite_12_16(COORDS(24, 1),            imgBalls + 21*16*11);
  drawSprite_12_16(COORDS(27, 1)+spriteMode, imgBalls + 21*16*11);
}

//---------------------------------------------------------------------------
// Изменяем активность кнопки

uchar onOff[1] = { 39, 75, 112 };

void drawOnOff(uchar n, uchar state) {
  paint(onOff[n], 201, state ? 3 : 1, 0);
}

//---------------------------------------------------------------------------
// Звук прыгающего шарика

void soundJumpSel() {  
  beep();
}

//---------------------------------------------------------------------------

void delay(uchar a) {
  uchar i;
  while(--a) {
    i = 64;
    while(--i);
  }
}

//---------------------------------------------------------------------------
// Звук ошибки перемещения шарика

void soundBadMove() {
  sound(100, 10);
  delay(128);
  sound(100, 10);
  delay(128);
}                

//---------------------------------------------------------------------------
// Интро

void intro() { 
  uint* p;
  uchar s;

  // Убираем курсор и очищаем экран
  BORDER_COLOR = 0;
  locate(0,0,0xFF);
  clrscr();

  // Выводим заставку
  bitBlt(COORDS(0, 0), imgIntro, 48, 206);

  // Выводим заставку
  pilotSoundStart();
  p = music;
  while(1) {
    s = *p; ++p;
    if(s==0) { while(!kbhit()); break; }
    if(kbhit()) break;
    pilotSound(s, *p); ++p;
    rand();
  }
  pilotSoundStop();
}

//---------------------------------------------------------------------------
// Вызывается один раз, перед рисованием заставки

void prepareRecordScreen() {
  fillRect(PLAYFIELD_X*4+12, PLAYFIELD_Y+16, PLAYFIELD_X*4+12*9-1-12, PLAYFIELD_Y+16*9-1-16, 0); 
}

//---------------------------------------------------------------------------
// Вызывается множество раз для перерисовки экрана

void drawRecordScreen(uchar pos) {
  struct HiScore* h;
  uchar l, i;
  char buf[14];

  for(i=0, h=hiScores; i<9; ++i, ++h) {
    if(pos==i) TEXT_COLOR = 1; else TEXT_COLOR = 0;
            
    memcpy(buf, "             ", 14);
    memcpy(buf, h->name, strlen(h->name));
    i2s(buf+8, h->score);

    locate(PLAYFIELD_X*4/6 + 2, PLAYFIELD_Y/10+4+i, 255);
    puts(buf);
  }
}

//---------------------------------------------------------------------------
// Вызывается для перерисовки последней строки

void drawRecordLastLine() {
  char buf[9];

  TEXT_COLOR = 1;
  memcpy(buf, "        ", 9);
  memcpy(buf, hiScores[8].name, strlen(hiScores[8].name));

  locate(PLAYFIELD_X*4/6 + 2, PLAYFIELD_Y/10+4+8, 255);
  puts(buf);
}

//---------------------------------------------------------------------------
// Перерисовка рекорда

void updateTopScore() {
  char buf[7];

  TEXT_COLOR = 3;

  // Выводим счет игрока
  buf[5] = 0;
  i2s(buf, hiScores[0].score);
  locate(0, 0, 255);
  puts(buf);

  // Выводим имя игрока
  memcpy(buf, "      ", 7);
  memcpy(buf, hiScores[0].name, strlen(hiScores[0].name));  
  locate(0, 19, 255);
  puts(buf);
}

//---------------------------------------------------------------------------
// Рисуеи игровое поле

#define XX0 PLAYFIELD_X*4-2
#define YY0 PLAYFIELD_Y-2
#define XX1 PLAYFIELD_X*4+12*9+1
#define YY1 PLAYFIELD_Y+16*9+1

void initGameScreen2() {
  uchar *s, i;

  color(spriteMode ? 0 : 5, 0);

  bitBlt(COORDS(-1, -4), imgGameScreen, 52, 26);
  bitBlt(COORDS(-1, 225-34), imgGameScreen+52*26, 52, 34);

  // Рисуем короля
  bitBlt(COORDS(0, 33), imgKing, 11, 63);
  for(i=17, s=COORDS(0, 33+63); i; --i, s+=4*LVOV_VIDEO_BPL)
    bitBlt(s, imgKing+11*63, 11, 4);
  bitBlt(s, imgKing+11*67, 11, 8);
  
  // Рисуем игрока
  drawPlayer(0);

  line(-4, 0, -4, 223, 1);
  line(203, 0, 203, 223, 1);

  line(XX0, YY0, XX1, YY0, 3);
  line(XX0, YY0, XX0, YY1, 3);
  line(XX1, YY0, XX1, YY1, 1);
  line(XX0, YY1, XX1, YY1, 1);

  TEXT_COLOR = 3;
  locate(29, 19, 255);
  puts("wy");

  updateTopScore();
  drawScore1();
  redrawNewBalls2();
  if(!showPath ) drawOnOff(0, 0);
  if(!playSound) drawOnOff(1, 0);
  if(!showHelp ) drawOnOff(2, 0);
  drawCells();
}

//---------------------------------------------------------------------------
// Замена спрайтов

void changeColor() {
  // Меняем спрайты местами
  spriteMode = 1-spriteMode;
  memswap(imgBalls,      imgBalls2,      sizeof(imgBalls));
  memswap(imgKing,       imgKing2,       sizeof(imgKing));
  memswap(imgPlayer,     imgPlayer2,     sizeof(imgPlayer));	
  memswap(imgPlayerWin,  imgPlayerWin2,  sizeof(imgPlayerWin));
  memswap(imgGameScreen, imgGameScreen2, 3172); //sizeof(imgGameScreen));
  memcpy(imgGameScreen, imgGameScreen2, sizeof(imgGameScreen));
  memswap(imgKingLose,   imgKingLose2,   sizeof(imgKingLose));

  // Перерисовываем экран
  initGameScreen2();
}

//---------------------------------------------------------------------------

void initGameScreen() {
  BORDER_COLOR = 0;
  locate(0,0,0xFF);
  clrscr();

  initGameScreen2();
}               

//---------------------------------------------------------------------------

char getch_() {
  return getch();
}

//---------------------------------------------------------------------------

void outport(uchar a, uchar v) {  
  asm {
    lda outport_1
    sta outport_v2
    lda outport_2
    .db 0D3h ; OUT
outport_v2: .db 0
  }
}

//---------------------------------------------------------------------------

uchar inport(uchar a) {
  asm {
    lda inport_1
    sta inport_v2    
    .db 0DBh ; IN
inport_v2: .db 0
  }
}

//---------------------------------------------------------------------------

char bioskey_() {
  outport(0xD2, ~(1<<1));
  switch(inport(0xD2)|0x0F) {
    case ~0x80: return KEY_SOUND; // F2
    case ~0x40: return KEY_PATH;  // F1
  }
  outport(0xD2, ~(1<<2));
  switch(inport(0xD2)|0x0F) {
    case ~0x80: return KEY_HELP;   // F3
    case ~0x40: return KEY_RECORD; // F4
    case ~0x20: return KEY_NEW;    // F5
  }
  outport(0xD2, ~(1<<3));
  switch(inport(0xD2)|0x0F) {
    case ~0x80: return KEY_DOWN;
    case ~0x40: return KEY_LEFT;
    case ~0x20: return KEY_UP;
    case ~0x10: return KEY_RIGHT;
  }
  outport(0xD0, 0xF7);
  if(inport(0xD1)==0xFE) return KEY_SPACE; //changeColor(); 
  outport(0xD0, 0xEF);
  if(inport(0xD1)==0xFE) changeColor(); 
}	