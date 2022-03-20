#include "graph.h"
#include "shell.h"

uint cmdline_offset = 0;

void drawWindow(const char* title) { 
  uint i; 
  graph1();
  i = 48;
  while(1) {
    //fillRect1(FILLRECTARGS(56,70-10,326,155+10));
    fillRect(56+i+i, 60+i, 326-i-i, 165-i);
    if(i==0) break;
    i-=8;
  }
  graph0();
  rect1(RECTARGS(70,85-10,314,140+10));
  rect1(RECTARGS(68,83-10,316,142+10));
  graph1();
  print((64-strlen(title)) >> 1, 7, 32, title);
}

void drawInput(uchar* a, uchar a1, uchar max) {
  ushort c, c1, old;

  old = graphOffset;
  graphOffset = 0;

  --max;
  if(cmdline_pos < max) cmdline_offset = 0; else cmdline_offset = cmdline_pos-max;
  c1 = cmdline_pos - cmdline_offset;
  cmdline[cmdline_pos] = '_';
  cmdline[cmdline_pos+1] = 0;
  ++c1;
  if(c1 > max) c1 = max;
  ++c1;
  ++max;
  print1(a, a1, max|0x80, cmdline + cmdline_offset);
  cmdline[cmdline_pos] = 0;
	
  graphOffset = old;
}

void processInput(uchar c) {
    if(c==8) {
      if(cmdline_pos==0) return;
      --cmdline_pos;    
      cmdline[cmdline_pos] = 0;
    }
    if(c>=32 && c<0xF0) {
      if(cmdline_pos==255) return; 
      cmdline[cmdline_pos] = c;
      ++cmdline_pos;
      cmdline[cmdline_pos] = 0;
    }
}

const char* errors[8] = {
  "Файловая система не найдена",
  "Ошибка диска",
  "Файл не открыт",
  "Путь не найден",
  "Максимум файлов в папке",
  "Диск заполнен",
  "Папка не пуста",
  "Файл существует" 
};

void drawError(const char* text, uchar e) {
  char buf[16];
  uint old;

  if(e==0) return;

  old=graphOffset;
  graphOffset=0;

  setColor(COLOR_RED);
  drawWindow(" Ошибка ");
  print1(PRINTARGS(27,13), 32, "[ ANY KEY ]");
  print1(PRINTARGS(13,09), 34, text);
//  --e;
//  if(e >= 8) {
//    ++e;
    i2s(buf, e, 3, '0');
    text = buf;
//  } else {
//    text = errors[e];
//  }
  print1(PRINTARGS(13,11), 34, text);
  getch1();

  graphOffset=old;
}

char inputBox(const char* title) {
  uchar c;
  uint old;

  old=graphOffset;
  graphOffset=0;

  drawWindow(title);
  print1(PRINTARGS(23,13), 32, "[ ENTER ]   [ ESC ]");
//  print1(TEXTCOORDS(14,10)-4, 1, 32, "Куда");
  graph0();  
  fillRect1(FILLRECTARGS(88,109,294,120));
//  cmdline_pos = 0;
//  cmdline[cmdline_pos] = 0;

  while(1) {
    graph0();
    setColor(COLOR_CYAN);
    drawInput(PRINTARGS(16, 11), 32);

    c = getch1();
    if(c==13) { graphOffset=old; return 1; }
    if(c==27) { graphOffset=old; return 0; }
    processInput(c);
  }
}

char inputBoxR(const char* title) {
  char r = inputBox(title);
  repairScreen(0);  
  return r;
}