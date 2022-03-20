#include <mem.h>
#include "graph.h"
#include <spec/color.h>
#include <spec/bios.h>
//#include <lvov/video.h>
//#include <lvov/pilotsound.h>
#include "interface.h"
#include "unmlz.h"
#include "keyb.h"
#include <string.h>
#include "spec_music.h"

void sound(uchar s, uint d) {
  asm {
    xchg
    lxi h, 0F802h
sound_l3:
    mvi m, 0
    lda sound_1
sound_l0:
    dcr a 
    jnz sound_l0
    mvi m, 20h
    lda sound_1
sound_l1:
    dcr a 
    jnz sound_l1
    dcx d
    mov a, d
    ora e
    jnz sound_l3
  } 
}

void bitBlt(uchar* d, uchar* s, uint wh) {
  asm {
    ; lhld bitBlt_3
    push b
    mov b, h
    mov c, l
    lhld bitBlt_1
    xchg    
    lhld bitBlt_2
bitBlt_l1:
    push d
    push b                    
bitBlt_l2:
    mov a, m
    inx h
    sta 0F802h
    mov a, m
    inx h
    stax d
    inx d
    dcr c
    jnz bitBlt_l2
    pop b
    pop d
    inr d
    dcr b
    jnz bitBlt_l1
    pop b
  }
}

void bitBlt_bw(uchar* d, uchar* s, uint wh) {
  asm {
    ; lhld bitBlt_bw_3
    push b
    mov b, h
    mov c, l
    lhld bitBlt_bw_1
    xchg    
    lhld bitBlt_bw_2
bitBlt_bw_l1:
    push d
    push b                    
bitBlt_bw_l2:
    mov a, m
    inx h
    stax d
    inx d
    dcr c
    jnz bitBlt_bw_l2
    pop b
    pop d
    inr d
    dcr b
    jnz bitBlt_bw_l1
    pop b
  }
}

extern uchar imgTitle[1], imgTitle_colors[1];
extern uchar imgScreen[1], imgScreen_colors[1];
extern uchar imgBalls[1];
extern uchar imgKingLose[1];
extern uchar imgPlayerWin[1];
extern uchar imgPlayer[1];
extern uchar imgPlayerD[1];
extern uchar imgFree[1];

#define KEY_COLOR 100

uchar spriteMode = 1;

#define PLAYFIELD_Y 28
#define PLAYFIELD_X 11

void colorizer_rand() {
  asm {
    push b
    mvi  b, 0
colorizerr_1:
    call rand
    
    mvi  d, 48h
    mov  e, a
    mvi  h, 90h
    mov  l, a
          
    mvi  c, 48 
colorizerr_2:
    ldax d
    inr  d
    sta  0F802h

    mov  a, m
    mov  m, a
    inr  h    

    dcr  c
    jnz  colorizerr_2

    dcr  b
    jnz  colorizerr_1
    pop  b
  }
}

//---------------------------------------------------------------------------
// Расчет адреса 

uchar* cellAddr(uchar x, uchar y) {
  return PIXELCOORDS(PLAYFIELD_X+x*3, PLAYFIELD_Y+y*20);
}

//---------------------------------------------------------------------------

uchar colors[1] = { COLOR_BLUE, COLOR_WHITE, COLOR_YELLOW, COLOR_VIOLET, COLOR_RED, COLOR_CYAN, COLOR_GREEN, COLOR_BLACK };

void drawBall1(uchar* d, uchar* o, uchar c) {
  SET_COLOR(colors[c-1]);
  bitblt_bw(d, o, 0x20E);
}

void drawBall(uchar x, uchar y, uchar* o, uchar c) {
  register uchar* d = cellAddr(x, y);
  SET_COLOR(COLOR_BLUE);
  d[-1] = 0x55;
  d[0x100-1] = 0x55;  
  drawBall1(d, o, c);
}

//---------------------------------------------------------------------------
// Рисуем курсор

void drawCursor() {
//  drawSpriteBallOr(cellAddr(cursorX, cursorY), imgBalls + 21*16*11 + 3);
  SET_COLOR(COLOR_YELLOW);
  memset(cellAddr(cursorX, cursorY), 255, 2);
  memset(cellAddr(cursorX, cursorY)+0x100, 255, 2);
  memset(cellAddr(cursorX, cursorY)+12, 255, 2);
  memset(cellAddr(cursorX, cursorY)+0x100+12, 255, 2);
}

//---------------------------------------------------------------------------
// Рисуем шарик

void drawSprite(uchar x, uchar y, uchar c) {
  if(c==0) drawBall(x, y, imgBalls+28*16, 1);
      else drawBall(x, y, imgBalls, c);
}

//---------------------------------------------------------------------------
// Анимация исчезнование шарика

uchar* removeAnimation[4] = { imgBalls+5*28, imgBalls+6*28, imgBalls+7*28, imgBalls+8*28 };

void drawSpriteRemove(uchar x, uchar y, uchar s, uchar n) {
  drawBall(x, y, removeAnimation[n], s);
}

//---------------------------------------------------------------------------
// Анимация появляющего шарика

void drawSpriteNew(uchar x, uchar y, uchar s, uchar n) {
  drawBall(x, y, imgBalls+(4-n)*28, s);
}

//---------------------------------------------------------------------------
// Рисуем шаги на кретках

void drawSpriteStep(uchar x, uchar y, uchar n) {
  drawBall(x, y, imgBalls+(12+n)*28, 1);
  sound(1, 10);
}

//---------------------------------------------------------------------------
// Рисуем анимацию прыгающего шарика

uchar* selAnimation[6] = { imgBalls, imgBalls, imgBalls, imgBalls+28*10, imgBalls+28*11, imgBalls+28*10 };

void drawSpriteSel(uchar x, uchar y, uchar s, uchar c, uchar t) {
  uchar* d;
  if(t==1) {
    d = cellAddr(x, y)-1;
    SET_COLOR(COLOR_BLUE);
    d[14] = 0x55;
    d[0x100+14] = 0x55;  
    drawBall1(d, selAnimation[t], s);  
  } else {
    drawBall(x, y, selAnimation[t], s);  
  }

  if(c) drawCursor();

  if(t==3) sound(1, 10);
}

//---------------------------------------------------------------------------

uchar playerSpriteTop;
        
void drawScore(uint score, char* scoreText) {
  uchar n;
  register uchar* s;  

  SET_COLOR(COLOR_GREEN);
  print1(PIXELCOORDS(40,7),2,5,scoreText);
  
  if(score < hiScores[0].score) {
    n = (score / (hiScores[0].score / 13));
    if(n>13) n=13;
  } else {
    n = 14;
  }

  if(playerSpriteTop != n) {
    playerSpriteTop = n;
    for(s=PIXELCOORDS(40, 167); n; --n, s-=4)
      bitBlt(s, imgPlayerD, 5*256+4);  
    bitBlt(s-46, imgPlayer, 5*256+50);                                         
    if(playerSpriteTop == 14) {
      bitBlt(s-50+0x200, imgPlayerWin, 3*256+16);
      bitBlt(PIXELCOORDS(3, 53), imgKingLose, 6*256+62);                                         
    }
  }
}

//---------------------------------------------------------------------------
// Показываем подсказку

void redrawNewBalls(uchar a, uchar b, uchar c) {
  drawBall1(PIXELCOORDS(20, 3), imgBalls, a);
  drawBall1(PIXELCOORDS(23, 3), imgBalls, b);
  drawBall1(PIXELCOORDS(26, 3), imgBalls, c);
}

//---------------------------------------------------------------------------
// Убираем подсказку

void redrawNewBallsOff() {
  redrawNewBalls(8,8,8);
}
                                          
//---------------------------------------------------------------------------
// Изменяем активность кнопки

uchar* onOff[1] = { PIXELCOORDS(10, 240), PIXELCOORDS(18, 240), PIXELCOORDS(26, 240) };

void drawOnOff(uchar n, uchar state) {
  uchar i;
  uchar* d = onOff[n];
  if(state) SET_COLOR(COLOR_GREEN) else SET_COLOR(COLOR_BLUE);
  for(i=4; i; --i, d+=0x100)
    memcpy(d, d, 8);
}

//---------------------------------------------------------------------------
// Звук прыгающего шарика

void soundJumpSel() {  
 // beep();
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
  sound(255, 10);
  delay(128);
  sound(255, 10);
  delay(128);
}                

//---------------------------------------------------------------------------
// Интро

void intro() { 
  uint* p;
  uchar s;

  // Выводим заставку
  SET_COLOR(COLOR_BLACK);
  unmlz((uchar*)0x9000, imgTitle);
  unmlz((uchar*)0x4800, imgTitle_colors);
  colorizer_rand();    

  // Выводим заставку
  p = music;
  while(1) {
    s = *p; ++p;
    if(s==0) { while(!getch1(1)); break; }
    if(getch1(1)) break;
    sound(s, *p); ++p;
    rand();
  }
}

//---------------------------------------------------------------------------
// Вызывается один раз, перед рисованием заставки

void prepareRecordScreen() {
  SET_COLOR(COLOR_BLUE);
  graph0();
  fillRect1(FILLRECTARGS(108, PLAYFIELD_Y+18, 274, PLAYFIELD_Y+156)); 
}

//---------------------------------------------------------------------------
// Вызывается множество раз для перерисовки экрана

void drawRecordScreen1(uchar i, uchar pos) {
  struct HiScore* h;
  uchar l;
  char buf[14];

  for(h=hiScores+i; i<9; ++i, ++h) {
    if(pos==i) { SET_COLOR(COLOR_YELLOW); } else SET_COLOR(COLOR_WHITE);
            
    memcpy(buf, "             ", 14);
    memcpy(buf, h->name, strlen(h->name));
    i2s(buf+8, h->score);
  
    print(25, 7+i, 14, buf);
  }
}
    	
void drawRecordScreen(uchar pos) {
  drawRecordScreen1(0, pos);
}

//---------------------------------------------------------------------------
// Вызывается для перерисовки последней строки

void drawRecordLastLine() {
  drawRecordScreen1(8, 8);
}

//---------------------------------------------------------------------------
// Перерисовка рекорда

void updateTopScore() {
  char buf[7];

  // Выводим счет игрока
  i2s(buf, hiScores[0].score);
  SET_COLOR(COLOR_GREEN);
  print1(PIXELCOORDS(3,7),1,5,buf);

  // Выводим имя игрока
  print1(PRINTARGS(5,19),7|0x80,hiScores[0].name);
}

//---------------------------------------------------------------------------
// Рисуеи игровое поле

#define XX0 PLAYFIELD_X*4-2
#define YY0 PLAYFIELD_Y-2
#define XX1 PLAYFIELD_X*4+12*9+1
#define YY1 PLAYFIELD_Y+16*9+1

void initGameScreen2() {
  uchar *s, i, x, y;

  SET_COLOR(COLOR_BLACK);                                                    
  unmlz((uchar*)0x9000, imgScreen);
  unmlz((uchar*)0x4800, imgScreen_colors);
  colorizer_rand();
    
  SET_COLOR(COLOR_GREEN);
  print(56,19,8,"ВЫ");
  
  updateTopScore();
  playerSpriteTop = -1;
  drawScore1();
//  redrawNewBalls2();
  if(!showPath ) drawOnOff(0, 0);
  if(!playSound) drawOnOff(1, 0);
  if(!showHelp ) drawOnOff(2, 0);
//  drawCells();
}

//---------------------------------------------------------------------------
// Замена спрайтов

void changeColor() {
  // Меняем спрайты местами
  spriteMode = 1-spriteMode;
//  memswap(imgBalls,      imgBalls2,      sizeof(imgBalls));

  // Перерисовываем экран
  initGameScreen2();
}

//---------------------------------------------------------------------------

void initGameScreen() {
  memset((uchar*)0x4800, 0xF0, 0x3000);
  colorizer_rand();    
  initGameScreen2();
}               

//---------------------------------------------------------------------------

char getch_() {
  return getch1(0);
}

char bioskey_() {
  return getch1(1);
}

/*	
  SET_COLOR(COLOR_BLUE);
  for(x=0, s=PIXELCOORDS(PLAYFIELD_X, PLAYFIELD_Y-3); x<8; x++, s+=0x300-180)
    for(y=0; y<9; y++, s+=20)
      bitblt_bw(s, imgFree, 3*256+20);
*/  