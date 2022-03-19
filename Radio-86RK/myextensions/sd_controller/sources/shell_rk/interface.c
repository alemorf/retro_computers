// Shell for Computer "Radio 86RK"
// (c) 12-05-2014 vinxru (aleksey.f.morozov@gmail.com)

#include "shell.h"
#include "interface.h"
#include <radio86rk/video.h>
#include <radio86rk/bios.h>

uchar  activePanel;
uchar* fileCursorAddr;

//---------------------------------------------------------------------------

void drawInit() {
  INTERFACE_VIDEO_MODE
  maxFiles = getMemTop() - START_FILE_BUFFER;
  maxFiles /= sizeof(FileInfo)*2;
  activePanel = 0;
  fileCursorAddr = 0;  
}

//---------------------------------------------------------------------------

void showTextCursor(uchar x, uchar y) {
  HARDWARE_CURSOR
}

//---------------------------------------------------------------------------

void hideTextCursor() {
  showTextCursor(255, 255);
}

//---------------------------------------------------------------------------

void drawSwapPanels() {
  activePanel = 32-activePanel;
}

//---------------------------------------------------------------------------
// Скрыть курсор

void hideFileCursor() {
  if(!fileCursorAddr) return;
  fileCursorAddr[0] = ' ';
  fileCursorAddr[13] = ' ';
  fileCursorAddr = 0;
}

//---------------------------------------------------------------------------

void showFileCursor() {
  // Скрыть прошлый курсор
  hideFileCursor();
  
  // Адрес нового курсора в видеопамяти
  fileCursorAddr = charAddr(panelA.cursorX*15 + 2 + activePanel, 2 + panelA.cursorY);
  fileCursorAddr[0]  = '[';
  fileCursorAddr[13] = ']';
}

//---------------------------------------------------------------------------

void vLine(uchar* a, uchar h, uchar c) {
  asm {
    push b
    mov d, a
    lda radio86rkVideoBpl
    mov c, a
    mvi b, 0
    lda vLine_2
    mov e, a
    lhld vLine_1
vLine_l0:
    mov m, d
    dad b
    dcr e 
    jnz vLine_l0
    pop b
  }
}

//---------------------------------------------------------------------------

void drawRect(uchar* a, uchar w, uchar h) {
  uchar i;
  a[0] = 0x04; memset(a+1, 0x1C, w); a[w] = 0x10; a += VIDEO_BPL;
  for(i=h; i; --i) {
    a[0] = 0x06; a[w] = 0x11; a += VIDEO_BPL;
  }
  a[0] = 0x02; memset(a+1, 0x1C, w); a[w] = 0x01;
}

//---------------------------------------------------------------------------

void fillRect(uchar* a, uchar w, uchar h, uchar c) {
  asm {
    push b
    lda radio86rkVideoBpl
    mov c, a
    mvi b, 0
    lhld fillRect_1
    lda fillRect_3
    mov d, a
    lda fillRect_4
    mov e, a
fillRect_l1:  
    lda fillRect_2
    push h
fillRect_l0:
    mov m, e
    inx h
    dcr a
    jnz fillRect_l0
    pop h
    dad b    
    dcr d
    jnz fillRect_l1
    pop b
  }
}

//---------------------------------------------------------------------------

void drawFilesCountInt(ulong* total, uint filesCnt) { 
  uchar v;
  uchar* a;
  a = charAddr(2+activePanel, 4+ROWS_CNT);
  i2s32((char*)a, total, 10, ' ');
  print2(a+11, "bajt w    ");
  if(filesCnt < 1000) i2s((char*)a+18, filesCnt, 3, ' ');
  v = filesCnt % 100;
  print2(a+22, (!(v >= 10 && v < 20) && v % 10 == 1) ? "fajle " : "fajlah ");
}

//---------------------------------------------------------------------------

void drawPanel(uchar* a) { 
  drawRect(a, 30, ROWS_CNT + 4);
  memset(a + (VIDEO_BPL * (2 + ROWS_CNT) + 1), 0x1C, 29); // hLine
  vLine(a + (VIDEO_BPL + 15), ROWS_CNT+1, 0x1B);
  print2(a + (VIDEO_BPL + 6 ), "imq");
  print2(a + (VIDEO_BPL + 21), "imq");  
}

//---------------------------------------------------------------------------
// Рисуем весь экран

void drawScreenInt() {
  // Очистка экрана
  fillRect(radio86rkVideoMem, 64, ROWS_CNT+8, ' ');

  // Рисуем подсказку    
  print(1, ROWS_CNT+7, "F1 FREE F2 NEW  F3 VIEW  F4 EDIT F5 COPY F6 REN  F7 DIR  F8 DEL"); 

  // Рисуем панели
  drawPanel(radio86rkVideoMem + 1);
  drawPanel(radio86rkVideoMem + 33);

  // Рисуем заголовки панелей
  drawPanelTitle(1);
  swapPanels();
  drawPanelTitle(0);
  swapPanels();

  // Курсора нет
  fileCursorAddr = 0;
}

//---------------------------------------------------------------------------
// Перерисовываем заголовок панели

void drawPanelTitle(uchar active) {
  char* p; 
  ushort l;
  uchar x;

  // Восстанавливаем памку
  memset((char*)charAddr(activePanel + 2, 0), 0x1C, 29);

  // Выводим путь по центру
  p = panelA.path1;
  if(p[0]==0) p = "/";
  l = strlen(p);
  if(l>=27) p=p+(l-27), l=27;
  x = 2 + (30 - l) / 2 + activePanel;
  printn(x, 0, l, p);
  if(!active) return;
  print(x-1, 0, "[");
  print(x+l, 0, "]");
}

//---------------------------------------------------------------------------

void drawFile2(uchar* a, FileInfo* f) {
  print2n(a, 8, f->fname); 
  a[8] = (f->fattrib&0x80) ? '*' : ((f->fattrib & 0x06) ? 0x7F : ' ');
  print2n(a + 9, 3, f->fname + 8); 
}

//---------------------------------------------------------------------------

void drawColumn(uchar i) {
  uchar* a;
  uchar y;
  register ushort n = panelA.offset+i*ROWS_CNT;
  FileInfo* f = panelA.files1 + n;  

  a = charAddr(i*15+3+activePanel,2);
  for(y=ROWS_CNT; y; --y, a+=VIDEO_BPL) {
    if(n>=panelA.cnt) {
      print2cn(a, 12, ' ');
      continue;
    }
    drawFile2(a, f);
    ++f; ++n; 
  }
}

//---------------------------------------------------------------------------

void drawFile(uchar x, uchar y, FileInfo* f) {
  drawFile2(charAddr(x*15+3+activePanel, 2+y), f);
}

//---------------------------------------------------------------------------
// Вывод информации о файле под курсором. Имя.

void drawFileInfo1(char* buf) {
  printm(3+activePanel, ROWS_CNT+3, 10, buf);
}

//---------------------------------------------------------------------------

void drawFileInfoDir() {
  drawFileInfo1("     <DIR>");
}

//---------------------------------------------------------------------------
// Вывод информации о файле под курсором. Размер и дата.

void drawFileInfo2(char* buf) {
  printm(14+activePanel, ROWS_CNT+3, 16, buf);
}

//---------------------------------------------------------------------------
// Рисуем командную строку и путь в ней

void drawCmdLineWithPath() {
  register ushort o, l, old;

  // Выводим только последние 30 символов пути
  print(1, ROWS_CNT+6, "/");
  l = strlen(panelA.path1);
  if(l>=30) o=l-30, l=30; else o=0;
  printn(2, ROWS_CNT+6, l, panelA.path1+o);
  print(l+2, ROWS_CNT+6, ">");

  // Сохраняем значение для drawCmdLine
  panelA.cmdLineOff = l+3;

  // Выводим ком строку
  drawCmdLine();
}

//---------------------------------------------------------------------------
// Рисуем окно

void drawWindow(const char* title) { 
  register uchar i; 

  hideTextCursor();
  
  fillRect(charAddr(WINDOW_X-5,WINDOW_Y-3), 49, 11, ' ');
  drawRect(charAddr(WINDOW_X-4,WINDOW_Y-2), 46, 7);

  print((64-strlen(title)) >> 1, WINDOW_Y-2, title);
}

//---------------------------------------------------------------------------
// Рисуем кнопку ANY KEY в окне

void drawAnyKeyButton() {
  print(WINDOW_X+14, WINDOW_Y+4, "[ ANY KEY ]");
}

//---------------------------------------------------------------------------

void drawEscButton() {
  print(WINDOW_X+12, WINDOW_Y+4, "[ ar2 - stop ]");
}

//---------------------------------------------------------------------------
// Рисуем текст в окне

void drawWindowText(uchar ox, uchar oy, char* text) {
  printn(WINDOW_X+ox, WINDOW_Y+oy, 40-ox, text);
}

//---------------------------------------------------------------------------
// Рисуем текст в окне

void drawWindowProgress(uchar ox, uchar oy, uchar n, char chr) {
  if(n==0) return;
  printcn(WINDOW_X+ox, WINDOW_Y+oy, n, chr);
}

//---------------------------------------------------------------------------

void drawCmdLine() {
  drawInput(panelA.cmdLineOff, ROWS_CNT+6, 62-panelA.cmdLineOff);
}

//---------------------------------------------------------------------------
// Рисуем поле ввода

void drawInput(uchar x, uchar y, uchar max) {
  register ushort c, c1, old;
  uint cmdline_offset;
  uint cmdline_pos;
 
  cmdline_pos = strlen(cmdline);
  --max;
  if(cmdline_pos < max) cmdline_offset = 0; else cmdline_offset = cmdline_pos-max;
  c1 = cmdline_pos - cmdline_offset;
  cmdline[cmdline_pos] = 0;
  ++c1;
  if(c1 > max) c1 = max;
  ++c1;
  ++max;
  printm(x, y, max, cmdline + cmdline_offset);

  // Устаналиваем аппаратный курсор
  showTextCursor(x+cmdline_pos-cmdline_offset, y);
}

//---------------------------------------------------------------------------

void drawWindowInput(uchar x, uchar y, uchar max) {
  drawInput(WINDOW_X+x, WINDOW_Y+y, max);
}

//---------------------------------------------------------------------------

char getch1() {
  return getch();
}

//---------------------------------------------------------------------------

char bioskey1() {
  return bioskey();
}