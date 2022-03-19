#include "interface.h"
#include <apogey/screen_constrcutor.h>
#include <apogey/video.h>
#include "game.h"
#include "screen.h"

// Кол-во байт в строке экрана
#define APOGEY_VIDEO_BPL 94

// Скорость анимации перемещения кубиков
#define DK 10

uchar* cellSprite;
uchar  cellColor;
uchar  scrollSize;
uchar* scrollAddr;
uchar* scrollSpcA;
uchar  scrollSpcAbuf[64];
uchar  scrollSpc;
uchar  cursorT=0;
uint   swapVideoPages_n;

// Изображение в верхней части экрана
uchar topSprite[1] = {
0,128,0,128,0,128,0,128,0,128,0,128,0,128,0,128,0,132,101,132,88,132,92,132,93,132,92,132,93,132,92,132,0,93,92,0,93,92,93,88,88,92,93,92,93,88,88,88,0,88,88,88,88,88,88,88,88,88,88,88,88,88,0,88,88,88,88,88,88,88,88,88,88,88,88,88,88,88,88,88,88,88,88,88,88,88,102,0,0,0,0,0,0,0,
0,132,0,132,0,132,0,132,0,132,0,132,0,132,0,108,0,137,113,92,93,92,93,92,132,88,137,93,92,132,88,137,93,92,93,88,88,92,93,92,93,88,88,111,113,88,0,133,82,0,94,64,82,82,94,64,82,0,137,88,111,0,129,94,82,94,82,88,82,0,0,101,64,82,82,101,82,82,82,101,82,101,82,101,82,0,132,105,0,0,0,0,0,0,
0,132,0,132,0,132,0,132,0,132,0,132,0,0,0,105,0,136,82,87,0,93,92,137,88,136,93,92,137,88,136,93,92,0,94,88,0,93,92,0,82,87,0,137,88,111,0,128,82,0,94,0,77,82,94,0,82,0,137,113,88,0,128,94,82,94,64,94,64,88,0,82,0,94,82,94,82,88,82,94,82,82,82,94,82,132,108,0,0,0,0,0,0,0,
0,132,0,132,0,132,0,132,0,132,0,132,0,132,0,132,108,132,0,132,0,140,95,93,0,82,87,0,82,81,0,82,87,0,94,92,0,82,87,0,82,87,0,136,88,88,0,133,88,64,88,64,81,64,88,204,88,0,136,88,88,0,129,64,64,64,0,88,64,0,0,88,64,64,64,64,64,0,64,64,64,64,64,64,64,0,132,105,0,0,0,0,0,0,
0,132,0,132,0,132,0,132,0,132,0,132,0,132,0,132,0,132,105,132,0,140,82,140,92,140,0,140,82,140,87,0,82,72,0,82,87,0,82,87,0,94,96,0,94,96,0,88,88,88,88,88,88,88,88,88,88,88,88,88,88,88,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,132,108,0,0,0,0,0,0,0,
0,132,0,132,0,132,0,132,0,132,0,132,0,132,0,132,108,132,0,132,0,136,82,136,87,0,92,93,0,92,93,0,92,93,0,95,93,0,82,87,0,82,87,0,88,88,88,88,88,0,133,94,64,88,82,136,88,88,88,88,88,0,0,0,0,129,94,70,82,0,0,101,82,0,94,82,94,82,101,82,94,64,94,64,0,0,132,105,0,0,0,0,0,0,
0,132,0,132,0,132,0,132,0,132,0,132,0,132,0,132,0,132,105,132,0,132,0,0,137,93,92,93,88,92,93,88,92,93,92,91,93,92,91,91,91,91,91,112,88,88,88,88,111,0,128,94,82,113,82,137,113,88,88,88,88,0,0,0,0,128,94,0,82,88,0,82,82,0,82,82,94,64,82,82,82,0,94,0,0,132,108,0,0,0,0,0,0,0,
0,132,0,132,0,132,0,132,0,132,0,132,0,132,0,132,108,132,0,137,113,88,88,132,93,92,93,88,92,93,88,92,93,92,91,93,92,0,0,0,0,0,0,137,113,88,88,88,88,0,133,88,64,0,64,137,88,88,88,88,111,0,0,0,0,129,64,0,64,0,0,88,64,0,64,64,64,0,88,64,64,0,88,64,0,0,132,105,0,0,0,0,0,0,
0,132,0,132,0,132,0,132,0,132,0,132,0,132,0,132,0,132,105,132,88,132,88,132,88,132,0,132,0,132,0,132,0,0,0,0,0,0,0,0,0,0,88,88,88,88,88,88,0,88,88,88,88,88,88,88,88,88,88,88,88,88,0,88,88,88,88,88,88,88,88,88,88,88,88,88,88,88,88,88,88,88,88,88,88,88,108,0,0,0,0,0,0,0,
};

// Пустой спрайт
uchar sprEmpty[1] = { 
  0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00   
};

// Квадрат со штриховкой 1
uchar spr7F[1] = { 
  0x00, 0x5B, 0x5B, 0x00,  0x57, 0x7A, 0x7A, 0x52,  0x57, 0x7B, 0x7B, 0x52,  0x57, 0x7C, 0x7C, 0x52,  0x00, 0x58, 0x58, 0x00,
};

// Квадрат со штриховкой 2
uchar spr77[1] = { 
  0x00, 0x5B, 0x5B, 0x00,  0x57, 0x79, 0x79, 0x52,  0x57, 0x78, 0x78, 0x52,  0x57, 0x77, 0x77, 0x52,  0x00, 0x58, 0x58, 0x00,
};

// Спрайт - кружок
uchar sprCircle[1] = { 
  0x00, 0x00, 0x00, 0x00,  0x00, 0x65, 0x66, 0x00,  0x00, 0x52, 0x57, 0x00,  0x00, 0x63, 0x64, 0x00,  0x00, 0x00, 0x00, 0x00  
};

// 4 спрайта - стрелки
uchar sprArrow[1] = { 
  0x00, 0x00, 0x00, 0x00,  0x00, 0x45, 0x4C, 0x00,  0x00, 0x41, 0x50, 0x00,  0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x4C, 0x00,  0x00, 0x00, 0x6A, 0x00,  0x00, 0x00, 0x43, 0x00,  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00,  0x00, 0x4A, 0x47, 0x00,  0x00, 0x4E, 0x43, 0x00,  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,  0x00, 0x45, 0x00, 0x00,  0x00, 0x6B, 0x00, 0x00,  0x00, 0x4E, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00
};

// 4 спрайта - стрелки с точкой
uchar sprArrowDone[1] = { 
  0x00, 0x00, 0x00, 0x00,  0x00, 0x45, 0x4C, 0x00,  0x00, 0x41, 0x50, 0x00,  0x00, 0x24, 0x09, 0x00,  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,  0x00, 0x00, 0x4C, 0x00,  0x00, 0x1B, 0x6A, 0x00,  0x00, 0x00, 0x43, 0x00,  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,  0x00, 0x24, 0x09, 0x00,  0x00, 0x4A, 0x47, 0x00,  0x00, 0x4E, 0x43, 0x00,  0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00,  0x00, 0x45, 0x00, 0x00,  0x00, 0x6B, 0x1B, 0x00,  0x00, 0x4E, 0x00, 0x00,  0x00, 0x00, 0x00, 0x00
};

// Анимация курсора
uchar cursor[1] = { 
  0,0,0,0, 0,0, 0,0, 0,0, 0,0,0,0,
  0x6F,0x00,0x00,0x71, 0x00,0x00, 0x00,0x00, 0x00,0x00, 0x70,0x00,0x00,0x72,
  0x5E,0x00,0x00,0x60, 0x40,0x51, 0x00,0x00, 0x49,0x48, 0x5F,0x00,0x00,0x61,
  0x5E,0x6F,0x71,0x60, 0x52,0x57, 0x00,0x00, 0x52,0x57, 0x5F,0x70,0x72,0x61,
  0x5E,0x58,0x58,0x60, 0x52,0x57, 0x52,0x57, 0x52,0x57, 0x5F,0x5B,0x5B,0x61,
};

uchar cursorAnim[1] = { 2*14, 2*14, 2*14, 3*14, 4*14, 3*14 };

#define CURSOR_AMIN_CNT 6

uchar font[1] = {
  94,82,82,82,88,64,
  69,82, 0,82, 0,64,
  88,82,94,64,88,64,
  88,82,88,82,88,64,
  82,82,88,82, 0,64,
  94,64,88,82,88,64,
  94,64,94,82,88,64,
  88,82,113,82,0,64,
  94,82,94,82,88,64,
  94,82,88,82,88,64,
  0, 0, 0, 0, 0, 0
};

void gchar(uchar* d, uchar c) {
  uchar *s;
  if(c>='0' && c<='9') s = font + (uchar)(6 * (uchar)(c-'0')); else s = font+60;
  *d = *s; ++d; ++s;
  *d = *s; ++s; d += APOGEY_VIDEO_BPL - 1;
  *d = *s; ++d; ++s;
  *d = *s; ++s; d += APOGEY_VIDEO_BPL - 1;
  *d = *s; ++d; ++s;
  *d = *s;
}

void gprint(uchar x, uchar y, char* text) {
  uchar* a = (uchar*)apogeyVideoMem + x + y*APOGEY_VIDEO_BPL;
  for(;*text; ++text, a+=2)
     gchar(a, *text);
}

void initInterface() {
  memcpy(introScreenData, apogeyVideoMem-(7+2*8), 2*8+APOGEY_VIDEO_BPL*51+1);
}

// Получить адрес ячейки игрового поля на экране
uchar* cellAddr(uchar x, uchar y) {
  return apogeyVideoMem + (9*APOGEY_VIDEO_BPL + 4)  + y*(5*APOGEY_VIDEO_BPL) + (uchar)(x*5);
}

// Вывод спрайта на экран
void drawSprite(uchar color, uchar* src, uchar* dest) {
  asm {
    push b
    ; Куда
    xchg
    ; Сохраняем стек
    lxi h, 0
    dad sp
    shld drawSprite_oldSP+1
    ; Цвет
    lda drawSprite_1
    mov b, a    
    ; Откуда
    lhld drawSprite_2
    sphl
    ; Куда
    xchg
    ; Графика
    mvi c, 5
drawSprite_l1:
    mov m, b
    inx h
    pop d
    mov m, e
    inx h
    mov m, d
    inx h
    pop d
    mov m, e
    inx h
    mov m, d
    inx h
    lxi d, 94-5
    dad d
    dcr c
    jnz drawSprite_l1
    ; Восстановление SP
drawSprite_oldSP:
    lxi sp, 0
    pop b
  }     
}


void calcCellSprite(uchar x, uchar y) {
  uchar c, d;
  x += y*MAPBPL;
  c = map2[x], d = map1[x];
  if(c != 0xFF) {
    cellColor = (c & 15) | 0x90;
    cellSprite = ((d < 16 && d == (c & 15)) ? sprArrowDone : sprArrow) + (uchar)(20*(c>>4));
    return;
  }        
  if(d != 0xFF) {
    if(d >= 16) {
      cellColor = 0x80;
      cellSprite = sprArrow + (uchar)(20*(uchar)(d-16));
      return;
    }
    cellSprite = sprCircle;
    cellColor = d | 0x80;
    return;
  }        
  cellColor = 0x80;
  cellSprite = sprEmpty;
}

void nextLevelAnim1(uchar f) {
  uchar x, y, xx, c, *p;
  uchar i, u, *rom = (uchar*)0xF000;

  i=0;
  do {
    x = rand();
    y = (x>>4) & 15;
    x ^= y;
    x &= 15;
    x--;  
    if(x<MAPW_ && y<MAPH) {
      p = cellAddr(x,y);
      if(f) {
	calcCellSprite(x, y);
        drawSprite(cellColor, cellSprite, p);
//        redrawCell(p, map2[c], map1[c]);
//        drawSprite(0x80, sprEmpty, p);
      } else {
        p += (2+APOGEY_VIDEO_BPL);
        if(*p != 0x7A && *p != 0x79) {
          c = (*rom & (1+4+8));
          if(c == 1+4+8) c=1;
          drawSprite(0x80 ^ c, (*rom&15) ? spr77 : spr7F, p-(2+APOGEY_VIDEO_BPL));
          rom++;
        }
      }
      for(u=0; u<200; u++);
//if(u) --u; else u=2, musicTick();
    }
  } while(++i);
}

// Анимация между уровнями
void nextLevelAnim() {
  nextLevelAnim1(0);
  nextLevelAnim1(1);
}

// Вывести номер уровня на экран
void drawLevelNumber() {
  char buf[3];
  i2s(buf, level+1, 2, ' ');
  gprint(43, 5, buf);  
}

void delay(uchar i) {  
  for(; i; --i)
    while((*(uchar*)61185 & 0x20)==0);
}

void scrollDownLow() {
 uchar* p = scrollAddr, height;
  for(height = scrollSize; height; --height) {
    p[0] = p[-APOGEY_VIDEO_BPL];    
    p += -APOGEY_VIDEO_BPL;
  } 
  p[0] = scrollSpc;
}

void scrollDown(uchar* addr, uchar size) {
  uchar frame, width, height, def, *p;

  scrollAddr = addr;
  scrollSize = size * 5;
  for(frame = 5; frame; --frame) {    
    scrollSpc = cellColor; // Цвет по умолчанию
    for(width = 5; width; --width) {
      scrollDownLow();
      scrollSpc = *cellSprite; cellSprite++; // Цвет только в первой колонке
      scrollAddr++;
    }  
    cellSprite--;
    scrollAddr -= 5-APOGEY_VIDEO_BPL; // Смещаемся на строку ниже
    delay(DK/5);
  }
//  redraw();
}

void scrollUpLow() {
  uchar* p = scrollAddr, height;
  for(height = scrollSize; height; --height) {
    p[0] = p[APOGEY_VIDEO_BPL];    
    p += APOGEY_VIDEO_BPL;
  } 
  p[0] = scrollSpc;
}

void scrollUp(uchar* addr, uchar size) {
  uchar frame, width;

  cellSprite += 4*4;
  scrollSize = size * 5;
  scrollAddr = addr;
  for(frame = 5; frame; --frame) {    
    scrollSpc = cellColor; // Цвет по умолчанию
    for(width = 5; width; --width) {
      scrollUpLow();
      scrollSpc = *cellSprite; cellSprite++; // Цвет только в первой колонке      
      scrollAddr++;
    }  
    cellSprite -= 9;
    scrollAddr -= APOGEY_VIDEO_BPL+5; // Смещаемся на строку ниже
    delay(DK/5);
  }
//  redraw();
}

void beforeScroll(uchar spc, uchar*) {
  asm {
    lda beforeScroll_1
    mov m, a
    lxi d, 94
    dad d
    mov m, a
    dad d
    mov m, a
    dad d
    mov m, a
    dad d
    mov m, a
  }
}

void swapVideoPages() {
  if(swapVideoPages_n) {
    apogeyVideoMem = swapVideoPages_n;
    swapVideoPages_n = 0;
  } else {
    swapVideoPages_n = apogeyVideoMem;
    apogeyVideoMem = introScreenData+(2*8+7);
  }
}

void memcpyf(void* arg1, void* arg2, uint arg3) {  
  asm {
    ; start
    push b
    ; de = count
    xchg
    ; save sp
    lxi h, 0
    dad sp
    shld memcpyf_sp+1
    ; sp = from
    lhld memcpyf_2
    sphl
    ; hl = to
    lhld memcpyf_1
    ; enter loop
    inr d
    xra a
    ora e
    jz memcpyf_l2
memcpyf_l1:
    ; *dest++ = *src++
    pop b
    mov m, c
    inx h
    mov m, b
    inx h
    pop b
    mov m, c
    inx h
    mov m, b
    inx h
    pop b
    mov m, c
    inx h
    mov m, b
    inx h
    pop b
    mov m, c
    inx h
    mov m, b
    inx h
    ; while(--cnt)
    dcr e
    jnz memcpyf_l1
memcpyf_l2:
    dcr d
    jnz memcpyf_l1
memcpyf_sp:
    lxi sp, 0
    pop b
  }
}


void copyVideoPages() {    
  uchar* old = apogeyVideoMem;
  swapVideoPages();
  memcpyf(apogeyVideoMem+APOGEY_VIDEO_BPL*5, old+APOGEY_VIDEO_BPL*5, (APOGEY_VIDEO_BPL*(50-5)+7)/8);
  swapVideoPages();
}

void showVideoPage() {
  uchar* x = apogeyVideoMem-(2*8+7);
  VT57[6] = ((uint)x)&0xFF;
  VT57[6] = ((uint)x)>>8;
}

// Перерисовать экран
void redraw() {
  uchar i, j, *p;
  p = cellAddr(0, 0);
  for(i=0; i<MAPH; i++) {
    for(j=0; j<MAPW_; j++) {	
      calcCellSprite(j, i);
      drawSprite(cellColor, cellSprite, p);
      p+=5;
    }
    p += 94*5-5*MAPW_;
  }
  copyVideoPages();
}

void scrollCom() {
  uchar *p, i;
  swapVideoPages();
  p = cellAddr(0, cy);
  for(i=0; i<MAPW_; i++) {
    calcCellSprite(i, cy);
    drawSprite(cellColor, cellSprite, p);
    p += 5;
  }
  beforeScroll(0x84, p);
  p++;
  beforeScroll(0, p);
  p++;
  beforeScroll(0x84, p);
  delay(DK/4);
  showVideoPage();
}

void scrollLeft2(uchar pn) {
  uchar d, n, px, *p;
  for(d=4; d!=1; d--) {
    swapVideoPages();
    px=cx;
    for(n=MAPW_-1; n>px; n--) {
      calcCellSprite(n, cy);
      drawSprite(cellColor, cellSprite, cellAddr(n, cy)+1);
    }
    beforeScroll(cellColor, cellAddr(px+1, cy)+d);
    p = cellAddr(MAPW_, cy);
    beforeScroll(0x84, p+1);
    beforeScroll(0, p+2);
    for(n=pn; n; n--) {
      calcCellSprite(px, cy);
      drawSprite(cellColor, cellSprite, cellAddr(px, cy)+d);
      px--;
    }
    showVideoPage();
    delay(DK/4);
  }
  scrollCom();
}

void scrollRight2(uchar pn) {
  uchar d, ix, *p, i;
  uchar* lastCellSprite = cellSprite;
  uchar lastCellColor = cellColor;

  for(d=2; d<5; d++) {
    swapVideoPages();

    ix = cx+pn-1;
    p = cellAddr(ix, cy); // Если поставить +1 будет глюк
    p++;
    drawSprite(lastCellColor, lastCellSprite, p); 
    ix++;
    p+=5;   

    while(ix<MAPW_) {
      calcCellSprite(ix, cy);
      drawSprite(cellColor, cellSprite, p);
      p+=5;
      ix++;
    }

    beforeScroll(0x84, p);
    beforeScroll(0, p+1);

    p = cellAddr(cx-1, cy);
    calcCellSprite(cx-1, cy);
    drawSprite(cellColor, cellSprite, p);

    for(i=pn, ix=cx; i; i--, ix++) {
      calcCellSprite(ix, cy);
      drawSprite(cellColor, cellSprite, p+d);
      p += 5;
    }
    beforeScroll(lastCellColor, p+d); 

    showVideoPage();
    delay(DK/4);
  }
  scrollCom();
}

void scrollAnimation1(uchar x, uchar y, uchar dx, uchar dy, uchar px, uchar py, uchar pn) {
  if(dx==1) calcCellSprite(x, y); 
}

void scrollAnimation2(uchar x, uchar y, uchar dx, uchar dy, uchar px, uchar py, uchar pn) {
  if(dy==1 ) { calcCellSprite(x, y); scrollDown(cellAddr(px, py), pn); } else
  if(dy==-1) { calcCellSprite(x, y); scrollUp(cellAddr(px, py) + APOGEY_VIDEO_BPL*4, pn); } else
  if(dx==1 ) scrollRight2(pn); else
  if(dx==-1) scrollLeft2(pn);
}

void drawCursor(uchar* s) {
  uchar* p = cellAddr(cx, cy)+1;
  memcpy(p, s, 4); s+=4; p+=APOGEY_VIDEO_BPL;
  *p=*s; s++; p+=3; *p=*s; s++; p+=APOGEY_VIDEO_BPL-3;
  *p=*s; s++; p+=3; *p=*s; s++; p+=APOGEY_VIDEO_BPL-3;
  *p=*s; s++; p+=3; *p=*s; s++; p+=APOGEY_VIDEO_BPL-3;
  memcpy(p, s, 4);
}

void showCursor() {
  uchar *p, *s, i;
  cursorT++;
  if(cursorT >= CURSOR_AMIN_CNT) cursorT = 0;
  drawCursor(cursor + cursorAnim[cursorT]);
}

void hideCursor() {
  drawCursor(cursor);
}

void prepareScreen() {
  uchar i, j, *p;

  // Скрываем курсор       
  VG75[1] = 0x80;
  VG75[0] = 0xFF;
  VG75[0] = 0xFF;
  
  // Включаем видео
  apogeyScreen3C();

  // Размечаем экран
  memcpy(apogeyVideoMem-8, topSprite, 94*9);
  p = apogeyVideoMem + 94*9;
  for(i=41; i; --i) {
    if(i&1) p[0] = 0x6C; else p[1] = 0x69;
    p += 4;
    for(j=15; j; --j) {
      *p = 0x81;
      p += 5;
    }
    p[-3] = 0x84;
    if(i&1) p[0] = 0x69; else p[-1] = 0x6C;
    p += (94-79);
  } 
  p+=1;
  for(j=8; j; --j) {
    *p = 0x84; p++;
    *p = 0x63; p++;
    *p = 0x65; p++;
    *p = 0x63; p++;
    *p = 0x65; p++;
  }
  for(j=7; j; --j) {
    *p = 0x84; p++;
    *p = 0x66; p++;
    *p = 0x64; p++;
    *p = 0x66; p++;
    *p = 0x64; p++;
  }
  *p = 0x66; p++;
  *p = 0x64; p++;
  *p = 0x84; p++;
}
