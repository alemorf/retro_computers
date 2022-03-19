#include "interface.h"
#include "mem.h"
#include <stdlib.h>

#define ANIMATION_SPEED 64
#define STEP_SPEED      64
#define RECORD_SPEED    64


#define GAME_WIDTH 9
#define GAME_HEIGHT 9

uchar game[GAME_WIDTH][GAME_HEIGHT];

uchar gameOver = 0;
uchar cursorX=4, cursorY=4;
uchar selX=-1, selY;
uint  score=0;
uchar newBall1, newBall2, newBall3;
uchar showPath=1, playSound=1, showHelp=1;

uchar nx,ny;

struct HiScore hiScores[9] = {
  { "VINXRU",     40 },
  { "ELTARO",     18  },
  { "ERR404",     16  },
  { "SYSCAT",     14  },
  { "MICK",       12  },
  { "SCL MC",     10  },
  { "SVOFSK",      8  },
  { "TITUS",       6  },
  { "B2M",         4  } 
};                 
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

void drawScore1() {
  char buf[6];
  buf[5] = 0;
  i2s(buf, score);
  drawScore(score, buf);
}

void drawCell(uchar x, uchar y) {
  drawSprite(x, y, game[x][y]);
}

void drawCells() {
  uchar x,y;
  for(y=0; y<9; y++)
    for(x=0; x<9; x++)
      drawCell(x,y);
  drawCursor();
}

void clearCursor() {
  drawCell(cursorX, cursorY);
}

//---------------------------------------------------------------------------
// Убираем линии

void clearLine(uchar x0, uchar y0, uchar dx, uchar dy, uchar n) {      
  register uchar c, x, y, o, i;

  c =  game[x0][y0];

  for(o=0; o<4; o++) {
    for(x=x0, y=y0, i=n; i; --i, x=x+dx, y=y+dy)
      drawSpriteRemove(x, y, c, o);
    delay(ANIMATION_SPEED);
  }

  // баг x+=dx
  for(x=x0, y=y0, i=n; i; --i, x=x+dx, y=y+dy) {
    game[x][y] = 0;
    drawSprite(x, y, 0);
  }
}

//---------------------------------------------------------------------------
// Ищем линни из 5 шариков

uchar check() {
  register uchar x, y;
  uchar prevx, prevy;
  uchar c, n, total=0;
  uchar* p;
  
  for(y=0; y!=GAME_HEIGHT; ++y) {
    for(p=&game[0][y], x=0; x<GAME_WIDTH;) {
      prevx = x;
      c = *p;
      ++x;
      p += GAME_WIDTH;
      if(c==0) continue;
      while(x!=GAME_WIDTH && c==*p) p+=GAME_WIDTH, ++x;
      n = x - prevx;
      if(n<5) continue;
      clearLine(prevx, y, 1, 0, n);
      total += n;
      break;
    }
  }
  for(x=0; x!=9; ++x) {
    for(p=&game[x][0], y=0; y<5;) {
      c = *p;  
      prevy = y;
      ++y;
      ++p;
      if(c==0) continue;
      while(y!=9 && c==*p) ++p, ++y;
      n = y - prevy;
      if(n<5) continue;      
      clearLine(x, prevy, 0, 1, n);
      total += n;
      break;
    }
  }
  for(y=0; y!=6; ++y) {
    for(x=0; x!=6; ++x) {
      p = &game[x][y];
      c = *p;  
      if(c==0) continue;
      prevx = x;
      prevy = y;
      while(1) {
        ++prevy;
        ++prevx;
        p += GAME_WIDTH+1;
        if(prevx==9) break;
        if(prevy==9) break;
        if(c!=*p) break;
      }
      n = prevy-y;
      if(n<5) continue;
      clearLine(x, y, 1, 1, n);
      total += n;
    }
  }
  for(y=0; y!=6; ++y) {
    for(x=4; x!=9; ++x) {
      p = &game[x][y];
      c = *p;  
      if(c==0) continue;
      prevx = x;
      prevy = y;
      while(1) {
        ++prevy;
        --prevx;
        p += 1-GAME_WIDTH;
        if(prevx==-1) break;
        if(prevy==9) break;
        if(c!=*p) break;
      }
      n = prevy-y;
      if(n<5) continue;
      clearLine(x, y, -1, 1, n);
      total += n;
    }
  }
  if(total==0) return 0;

  // Результат был изменен, перерисуем его
  score += total*2;
  drawScore1();
  return 1;
}

//---------------------------------------------------------------------------
// Считаем кол во свободных клеток

uchar calcFreeCell() {
  register uchar* p;
  uchar c, i;
  for(c=0, p=&game[0][0], i=81; i; --i, ++p)
    if(*p==0)
      c++;
  return c;
}

//---------------------------------------------------------------------------
// Помещаем шарик с случайную свободную ячейку

extern uint op_div_mod;

void newBall(uchar color) {
  uchar i, c;
  register uchar* p;
  
  // Считаем кол во свободных клеток
  c = calcFreeCell();
  if(c==0) { nx=-1; gameover=1; return; }

  // Выбираем случайную клетку
  c = rand()%c;

  // Определяем координаты этой клетки
  for(p=&game[0][0], i=81; i; --i, ++p)
    if(*p==0) {
      if(c==0) break;
      c--;
    }
      
  // Преобразуем координаты
  nx = (81-i)/9, ny = op_div_mod;

  // Заносим шарик
  game[nx][ny] = color;
}

//---------------------------------------------------------------------------
// Загадываем новые шарики

void randNewBall() {
  newBall1 = rand()%7+1;
  newBall2 = rand()%7+1;
  newBall3 = rand()%7+1;
}

//---------------------------------------------------------------------------

void redrawNewBalls1() {
  if(showHelp) redrawNewBalls(newBall1, newBall2, newBall3);
}

void redrawNewBalls2() {
  if(showHelp) redrawNewBalls1(); else redrawNewBallsOff();
}

//---------------------------------------------------------------------------
// Ищем линии и добавляем шарики

void gameStep() {
  uchar nx1,ny1,nx2,ny2,o;

  // Ищем готовые линии
  if(!check()) {

    // Добавляем три шарика
    newBall(newBall1); nx1=nx; ny1=ny;
    newBall(newBall2); nx2=nx; ny2=ny;
    newBall(newBall3);

    // Рисуем анимацию
    for(o=0; o<5; o++) {
      if(nx1!=-1) drawSpriteNew(nx1, ny1, newBall1, o);
      if(nx2!=-1) drawSpriteNew(nx2, ny2, newBall2, o);
      if(nx !=-1) drawSpriteNew(nx,  ny,  newBall3, o);
      delay(ANIMATION_SPEED);
    }
  
    // Загадываем три новых шарика
    randNewBall();
    redrawNewBalls1();

    if(!gameOver) {    
      // Ищем готовые линии
      check();
   
      // Считаем кол во свободных клеток
      if(calcFreeCell()==0) gameOver=1;
    }
  }

  drawCursor(); 
}

//---------------------------------------------------------------------------
// Ищем путь из selX, selY в cursorX, cursorY

uchar path_c;
uchar *path_p, path_n, path_x, path_y;
uchar *path_p1, path_n1, path_x1, path_y1;

#define PATH_START_VAL 10
#define LAST_STEP (PATH_START_VAL-1)

void path_end(); // forward

uchar path_find() {
  register uchar* p;
  
  path_c = game[selX][selY];  
  game[selX][selY] = 255;
  game[cursorX][cursorY] = PATH_START_VAL;

  // Ищем путь
  for(path_n = PATH_START_VAL; path_n != PATH_START_VAL+GAME_WIDTH*GAME_HEIGHT; ++path_n)
    for(p = &game[0][0], path_x=0; path_x != GAME_WIDTH; ++path_x)
      for(path_y=0; path_y != GAME_HEIGHT; ++path_y, ++p)
        if(*p == path_n) {
          if(path_y != 0            ) { p-=1;           if(*p==255) { --path_y; path_p=p; return 1; } else if(*p==0) *p=path_n+1; p+=1;           }
          if(path_y != GAME_HEIGHT-1) { p+=1;           if(*p==255) { ++path_y; path_p=p; return 1; } else if(*p==0) *p=path_n+1; p-=1;           }
          if(path_x != 0            ) { p-=GAME_HEIGHT; if(*p==255) { --path_x; path_p=p; return 1; } else if(*p==0) *p=path_n+1; p+=GAME_HEIGHT; }
          if(path_x != GAME_WIDTH -1) { p+=GAME_HEIGHT; if(*p==255) { ++path_x; path_p=p; return 1; } else if(*p==0) *p=path_n+1; p-=GAME_HEIGHT; }
        }

  // Путь не найден
  path_end();
  game[selX][selY] = path_c;
  return 0;
}

//---------------------------------------------------------------------------
// Следующий шаг найденного пути

uchar path_nextStep() {
  register uchar* p = path_p;
  if(path_y != 0            ) { p -= 1;           if(*p == path_n) { --path_y; --path_n; path_p=p; return 1; } p+=1;           }
  if(path_y != GAME_HEIGHT-1) { p += 1;           if(*p == path_n) { ++path_y; --path_n; path_p=p; return 2; } p-=1;           }
  if(path_x != 0            ) { p -= GAME_HEIGHT; if(*p == path_n) { --path_x; --path_n; path_p=p; return 3; } p+=GAME_HEIGHT; }
  if(path_x != GAME_WIDTH -1) { p += GAME_HEIGHT; if(*p == path_n) { ++path_x; --path_n; path_p=p; return 4; } p-=GAME_HEIGHT; }
  while(1);
}

//---------------------------------------------------------------------------

void path_save() {
  path_p1 = path_p;
  path_x1 = path_x; 
  path_y1 = path_y;
  path_n1 = path_n;
}

//---------------------------------------------------------------------------

void path_load() {
  path_p = path_p1;
  path_x = path_x1;
  path_y = path_y1;
  path_n = path_n1;
}

//---------------------------------------------------------------------------
// Убираем мусор оставленный алгоритмом поиска пути

void path_end() {
  register uchar* p;
  for(p=&game[0][0]; p != &game[8][8]+1; ++p)
    if(*p >= PATH_START_VAL)
      *p=0;
}

//---------------------------------------------------------------------------
// Перемещение шарика

void move() {
  // Для алгоритма поиска поути
  if(!path_find()) {
    if(playSound) soundBadMove();
    return;
  }

  if(showPath) {
    // Рисуем шаги на экране
    path_save();
    while(1) {
      switch(path_nextStep()) {
        case 1: drawSpriteStep(path_x, path_y+1, 0); break;
        case 2: drawSpriteStep(path_x, path_y-1, 1); break;
        case 3: drawSpriteStep(path_x+1, path_y, 2); break;
        case 4: drawSpriteStep(path_x-1, path_y, 3); break;
      }
      drawSprite(path_x, path_y, path_c);
      if(path_n==LAST_STEP) break;
      if(playSound) soundJumpSel();
      delay(STEP_SPEED);
    };
 
    // Удаляем нарисованные шаги с экрана
    path_load();
    while(1) {
      drawSprite(path_x, path_y, 0);
      path_nextStep();
      if(path_n==LAST_STEP) break;
    };
  } else {
    drawSprite(selX, selY, 0);
    drawSprite(cursorX, cursorY, path_c);
  }

  // Реально перемещаем шарик. Все выше было лишь анимацией.
  game[cursorX][cursorY] = path_c;

  // Снимаем курсор
  selX = -1;

  // Очищаем игровое поле от временных значений
  path_end();
  
  // Добавляем 3 шарика
  gameStep();
}

//---------------------------------------------------------------------------
// Начало новой игры

void startGame() {
  register uchar x,y;

  selX = -1;
  score = 0;
  gameOver = 0;

  
  initGameScreen();
//  drawScore1();

  for(y=0; y!=GAME_HEIGHT; ++y)
    for(x=0; x!=GAME_WIDTH; ++x)
      game[x][y] = 0;
 
  randNewBall();
  gameStep();
}

//---------------------------------------------------------------------------

//#include <apogey/bios.h>

//uchar* selAnimation[4] = { ballSprite, selAnimation1, selAnimation2, selAnimation1 };
//uchar* selCursorAnimation[4] = { ballCursorSprite, selCursorAnimation1, selCursorAnimation2, selCursorAnimation1 };

void recordAnimation() {
  uchar c, i;
  struct HiScore* p;
  struct HiScore tmp;

  prepareRecordScreen();

  if(score < hiScores[8].score) {
    return; 
  }

  hiScores[8].score = score;

  memset(hiScores[8].name, 0, 6);
  i = 0;

  drawRecordScreen(8);

  while(1) {
    c = getch_();
    if(c==13) break;  
    if(c==8) {
      if(i==0) continue;
      --i;   
      hiScores[8].name[i] = 0;
      drawRecordLastLine();
      continue;
    }
    if(c>=32) {
      if(i==6) continue;
      hiScores[8].name[i] = c;
      hiScores[8].name[i+1] = 0;
      ++i;   
      drawRecordLastLine();
    }
  }
  c = 8;
  p = hiScores+8;
  while(1) {
    if(p->score < p[-1].score) break;    
    p--;
    memcpy(&tmp, p+1, sizeof(tmp));
    memcpy(p+1, p, sizeof(tmp));
    memcpy(p, &tmp, sizeof(tmp));
    c--;    
    drawRecordScreen(c);
    delay(RECORD_SPEED);
    if(c==0) {
      updateTopScore();      
      break;
    }
  }

  getch_();
}

void main() {
  uchar c, c1;
  uchar selAnimationT = 0;
  uint selAnimationTT = 0, keybTimeout=0; 

  intro();
    
  // Запускаем игру
  startGame();

 // score=14;
 //         recordAnimation();
 //         startGame();

  while(1) {
    rand();

    if(selX!=-1) {
      selAnimationTT++;
      if(selAnimationTT==150) {
        selAnimationTT=0;
        drawSpriteSel(selX, selY, game[selX][selY], selX==cursorX && selY==cursorY, selAnimationT);
        selAnimationT++;
        if(selAnimationT>=6) selAnimationT=0; else
        if(playSound && selAnimationT==2) soundJumpSel();
      }
    }

    c1 = bioskey_();

    if(keybTimeout) {
      keybTimeout--;
      continue;
    }
    
    if(c == c1) continue;
    c = c1;

    switch(c) {
      case KEY_PATH:       showPath  = !showPath;  drawOnOff(0, showPath);  break;
      case KEY_SOUND:      playSound = !playSound; drawOnOff(1, playSound); break;
      case KEY_HELP:       showHelp  = !showHelp;  drawOnOff(2, showHelp);  redrawNewBalls2(); break;
      case KEY_RECORD:
        prepareRecordScreen();
        drawRecordScreen(-1);
        getch_();
        initGameScreen();
        if(showHelp) redrawNewBalls1();
        drawCells();
        break;
      case KEY_NEW:        startGame(); break;
/*      case KEY_UP:
        if(score>0)
          score-=1;
        drawScore1();
        break;
      case KEY_DOWN:
        score+=1;
        drawScore1();
        break;*/
      case KEY_UP:    clearCursor(); if(cursorY==0) cursorY=8; else cursorY--; drawCursor(); break;
      case KEY_DOWN:  clearCursor(); if(cursorY==8) cursorY=0; else cursorY++; drawCursor(); break;
      case KEY_LEFT:  clearCursor(); if(cursorX==0) cursorX=8; else cursorX--; drawCursor(); break;
      case KEY_RIGHT: clearCursor(); if(cursorX==8) cursorX=0; else cursorX++; drawCursor(); break;
      case KEY_SPACE: 
        if(game[cursorX][cursorY]) { if(selX!=-1) drawCell(selX, selY); selX=cursorX, selY=cursorY; break; }
        if(selX==-1) break;
        move();
        if(gameOver) {
          recordAnimation();
          startGame();
        }
        break;        
      default:
        continue;
    }

    keybTimeout=50;
  }
}