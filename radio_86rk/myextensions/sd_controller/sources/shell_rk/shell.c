// Shell for Computer "Radio 86RK" / "Apogee BK01"
// (c) 12-05-2014 vinxru (aleksey.f.morozov@gmail.com)

#include <n.h>
#include <stdlib.h>
#include <mem.h>
#include "32.h"
#include <string.h>
#include "shell.h"

char   editorApp[1] = "BOOT/EDIT.RK";
char   viewerApp[1] = "BOOT/VIEW.RK";
Panel  panelA;
Panel  panelB;
char   cmdline[256]; 
uint   maxFiles;

//---------------------------------------------------------------------------

const char parentDir[20] = { '.','.',' ',' ',' ',' ',' ',' ',' ',' ',' ',0x10,0,0,0,0,0,0,0,0 };

//---------------------------------------------------------------------------
// Перерисовать все файлы на активной панели

void drawFiles() {
  hideFileCursor();
  drawColumn(0);
  drawColumn(1);
}

//---------------------------------------------------------------------------
// Сменить активную панель

void swapPanels() {
  memswap(&panelA, &panelB, sizeof(Panel));  
  drawSwapPanels();
}

//---------------------------------------------------------------------------

FileInfo* getSel() {
  uint n = panelA.offset+panelA.cursorY+panelA.cursorX*ROWS_CNT;
  if(n < panelA.cnt) return panelA.files1 + n;
  panelA.offset = 0;
  panelA.cursorY = 0;
  panelA.cursorX = 0;
  if(panelA.cnt != 0) return panelA.files1;
  return (FileInfo*)parentDir;
}

//---------------------------------------------------------------------------

FileInfo* getSelNoBack() {
  FileInfo* f = getSel();
  if(f->fname[0] == '.') f = 0;
  return f;  
}

//---------------------------------------------------------------------------
// Вывести на экран информацию о выбранном файле

void drawFileInfo() {
  FileInfo* f;
  char buf[18];

  f = getSel();

  if(f->fattrib & 0x10) {
    drawFileInfoDir();
  } else {
    i2s32(buf, &f->fsize, 10, ' ');           
    drawFileInfo1(buf);
  }

  if(f->fdate==0 && f->ftime==0) {
    buf[0] = 0;
  } else {
    i2s(buf, f->fdate & 31, 2, ' ');  
    buf[2] = '-';
    i2s(buf+3, (f->fdate>>5) & 15, 2, '0');
    buf[5] = '-';
    i2s(buf+6, (f->fdate>>9)+1980, 4, '0');
    buf[10] = ' ';
    i2s(buf+11, f->ftime>>11, 2, '0');
    buf[13] = ':';
    i2s(buf+14, (f->ftime>>5)&63, 2, '0');
  }
  drawFileInfo2(buf);
}

//---------------------------------------------------------------------------
// Перерисовать курсор и информацию о выбранном файле

void showFileCursorAndDrawFileInfo() {
  showFileCursor();
  drawFileInfo();  
}
  
//---------------------------------------------------------------------------

void drawFilesCount() {
  ulong total;
  uint i, filesCnt;
  FileInfo* p;   
  
  SET32IMM(&total, 0);
  filesCnt = 0;
  for(p = panelA.files1, i = panelA.cnt; i; ++p, --i) {
    if((p->fattrib & 0x10) == 0) ++filesCnt;
    add32_32(&total, &p->fsize);
  }

  drawFilesCountInt(&total, filesCnt);
}

//---------------------------------------------------------------------------
// Перерисовать все файлы на всех панелях

void drawFiles2() {
  drawFiles();
  drawFilesCount();
  swapPanels();
  drawFiles();
  drawFilesCount();
  drawFileInfo();
  swapPanels();
  showFileCursorAndDrawFileInfo();
}

//---------------------------------------------------------------------------
// Перерисовать весь экран

void drawScreen() {
  cmdline[0] = 0;
  drawScreenInt();
  drawCmdLineWithPath();
  drawFiles2();
}

//---------------------------------------------------------------------------
// Строка ввода

void processInput(uchar c) {
  register uint cmdline_pos = strlen(cmdline);
  if(c==KEY_BKSPC) {
    if(cmdline_pos==0) return;
    --cmdline_pos;    
    cmdline[cmdline_pos] = 0;
    return;
  }
  if(c>=32) {
    if(cmdline_pos==255) return; 
    cmdline[cmdline_pos] = c;
    ++cmdline_pos;
    cmdline[cmdline_pos] = 0;
  }
}

//---------------------------------------------------------------------------
// Окно с ошибкой

void drawError(const char* text, uchar e) {
  char buf[4];

  // Нет ошибки
  if(e == 0) return;
  
  // Рисуем окно
  drawWindow(" o{ibka ");
  drawAnyKeyButton();
  drawWindowText(0, 0, text);

  // Описание ошибки
  switch(e) {
    case ERR_NO_FILESYSTEM: text = "net fajlowoj sistemy"; break;
    case ERR_DISK_ERR: text = "o{ibka nakopitelq"; break;
    case ERR_DIR_NOT_EMPTY: text = "papka ne pusta"; break;
    case ERR_NOT_OPENED: text = "fajl ne otkryt"; break;
    case ERR_NO_PATH: text = "putx ne najden"; break;
    case ERR_DIR_FULL: text = "maksimum fajlow w papke"; break;
    case ERR_NO_FREE_SPACE: text = "disk zapolnen"; break;
    case ERR_FILE_EXISTS: text = "fail su}estwuet"; break;
    case ERR_USER: text = "prerwano polxzowatelem"; break;
    case ERR_RECV_STRING: text = "putx bolx{e 255 simwolow"; break;
    default: i2s(buf, e, 3, '0'); text = buf; break;
  };

  // Выводим описание ошибки
  drawWindowText(0, 2, text);

  // Ждем
  getch1();
}

//---------------------------------------------------------------------------
// Окно со строкой ввода

char inputBox(const char* title) {
  register uchar c, clearFlag;
  clearFlag = 1;

  // Рисуем окно
  drawWindow(title);
  drawWindowText(3, 1, "imq:");
  drawWindowText(6, 4, "[ wk - ok ]  [ ar2 - otmena ]");

  // Обрабатываем нажатия клавиш
  while(1) {
    drawWindowInput(3, 2, 32);
    c = getch1();
    if(c==KEY_RIGHT) clearFlag = 0;
    if(c==KEY_LEFT) clearFlag = 0;
    if(c==KEY_ENTER) { hideTextCursor(); return 1; }
    if(c==KEY_ESC) { hideTextCursor(); return 0; }
    if(clearFlag) clearFlag = 0, cmdline[0] = 0;
    processInput(c);
  }
}

//---------------------------------------------------------------------------
// Окно подтверждения

char confirm(const char* title, const char* text) {
  // Рисуем окно
  drawWindow(title);
  drawWindowText(3, 1, text);
  drawWindowText(6, 4, "[ wk - ok ]  [ ar2 - otmena ]");

  // Обрабатываем нажатия клавиш
  while(1) {
    switch(getch1()) {
      case KEY_ENTER: return 1;
      case KEY_ESC: return 0;
    }
  }
}

//---------------------------------------------------------------------------
// Перерисовываем все файлы в панели
	 
void unpackName(char* d, const char* s) {
  register uchar i;
  for(i=0; i!=11; ++i, ++s) {
    if(i==8) *d = '.', ++d;
    if(*s!=' ') *d = *s, ++d;
  }
  if(d[-1]=='.') --d;
  *d = 0;
}

//---------------------------------------------------------------------------

char catPathAndUnpack(char* str, char* fileName) {
  uint len = strlen(str);
  if(len) {
    if(len >= 255-13) return 1; // Не влезает разделитель плюс имя файла  
    str[len] = '/';  
    str += len+1;
  }
  unpackName(str, fileName);
  return 0;
}

//---------------------------------------------------------------------------
// Скопировать имя выбранного файла в буфер

uint nextSelectedCnt;
FileInfo* nextSelectedFile;

char getFirstSelected(char* name) {
  char type;
  nextSelectedCnt = panelA.cnt;
  nextSelectedFile = panelA.files1;
  if(type = getNextSelected(name)) return type; 

  nextSelectedFile = getSelNoBack();
  if(!nextSelectedFile) return 0;
  unpackName(name, nextSelectedFile->fname);
  if(nextSelectedFile->fattrib & 0x10) return 2;
  return 1;
}

//---------------------------------------------------------------------------

char getNextSelected(char* name) {
  for(;;) {
    if(nextSelectedCnt == 0) return 0;
    if(nextSelectedFile->fattrib & 0x80) break;
    ++nextSelectedFile, --nextSelectedCnt;
  }

  nextSelectedFile->fattrib &= 0x7F;
  unpackName(name, nextSelectedFile->fname);
  ++nextSelectedFile, --nextSelectedCnt;
  if(nextSelectedFile[-1].fattrib & 0x10) return 2;
  return 1;
}

//---------------------------------------------------------------------------

#define SORT_STACK_MAX 32

uchar cmpFileInfo(FileInfo* a, FileInfo* b) {
  register uchar i, j;
  i = (a->fattrib&0x10);
  j = (b->fattrib&0x10);
  if(i<j) return 1;
  if(j<i) return 0;
  if(1==memcmp(a->fname, b->fname, sizeof(a->fname))) return 1;
  return 0;
}

//---------------------------------------------------------------------------

void sort(FileInfo* low, FileInfo* high) {
  FileInfo *i, *j, *x;
  FileInfo *st_[SORT_STACK_MAX*2], **st = st_;
  uchar stc = 0;
  while(1) {
    i = low;
    j = high;
    x = low + (high-low)/2;
    while(1) {
      while(0!=cmpFileInfo(x, i)) i++;
      while(0!=cmpFileInfo(j, x)) j--;
      if(i <= j) {
        memswap(i, j, sizeof(FileInfo));
        if(x==i) x=j; else if(x==j) x=i;
        i++; j--;   
      }
      if(j<=i) break;
    }
    if(i < high) {
      if(low < j) if(stc != SORT_STACK_MAX) *st = low, ++st, *st = j, ++st, ++stc;
      low = i; 
      continue;
    }
    if(low < j) { 
      high = j;
      continue; 
    }
    if(stc==0) break;
    --stc, --st, high = *st, --st, low = *st; 
  }
}

//---------------------------------------------------------------------------

void packName(char* buf, char *path) {
  register uchar c, f, i;

  memset(buf, ' ', 11);    

  i = 8;
  f = '.';
  for(;;) {
    c = *path;
    if(c == 0) return;
    ++path;
    if(c == f) { buf += i; i = 3; f = 0; continue; }
    if(i) { *buf = c; ++buf; --i; }
  }                                      
}

//---------------------------------------------------------------------------

void getFiles() {
  FileInfo *f, *st;
  char *n;
  uchar i;
  uint j;
  FileInfo dir;

  // Долгая операция
  hideTextCursor();
    
  // Сбрасываем курсор, смещение и кол во файлов
  panelA.cnt = 0;
  panelA.offset = 0;
  panelA.cursorX = 0;
  panelA.cursorY = 0;

  f = panelA.files1;

  // Добавляем в список файлов элемент ..
  if(panelA.path1[0]) {
    memcpy(f, parentDir, sizeof(FileInfo));
    ++f;
    ++panelA.cnt;    
  }

  st = f;
  for(;;) {
    i = fs_findfirst(panelA.path1, f, maxFiles-panelA.cnt);  
    if(i==ERR_MAX_FILES) i=0; //! Вывести бы ошибки
    if(i==0) break;    
    if(panelA.path1[0]==0) return; //! Вывести бы ошибки
    panelA.path1[0] = 0;
  }

  f += fs_low;
  panelA.cnt += fs_low;
 
  for(j=panelA.cnt, f=panelA.files1; j; --j, ++f) { 
    f->fattrib &= 0x7F;
    n=f->fname;
    for(i=12; i; --i, ++n)
      if((uchar)*n>='a' && (uchar)*n<='z')
        *n = *n-('a'-'A');
  }

  if(panelA.cnt > 1)
    sort(st, ((FileInfo*)panelA.files1) + (panelA.cnt-1));
}

//---------------------------------------------------------------------------

void selectFile(char* sfile) {
  register ushort l;
  FileInfo* f;
  for(l=0, f=panelA.files1; l<panelA.cnt; ++l, ++f) {
    if(0==memcmp(f->fname, sfile, 11)) {
      // Найдено. Если курсор будет за краем экрана, сдвигаем скролл.
      if(l>=2*ROWS_CNT) {
        panelA.offset = l-ROWS_CNT-(l%ROWS_CNT);
        l-=panelA.offset;
      }
      // Устанавлиаем курсор
      panelA.cursorX = l/ROWS_CNT;
      panelA.cursorY = op_div16_mod;
      break;
    }
  }
}

//---------------------------------------------------------------------------
// Перезагрузить список файлов

void reloadFiles(char* sfile) {  
  // Нарисовать путь в заголовке
  drawPanelTitle(1);   
  drawCmdLineWithPath();

  // Загрузить список файлов
  getFiles();

  // Нарисовать путь в заголовке и ком строке (они могли изменится)
  drawPanelTitle(1);   
  drawCmdLineWithPath();

  // Ищем в папке файл и ставим на него курсор
  if(sfile) {
    selectFile(sfile);
  }

  // Перерисовываем остальной интерфейс
  drawFilesCount();
  drawFiles();
  showFileCursorAndDrawFileInfo();
 
  // Показываем аппаратный курсор //! Наверное не надо
  drawCmdLine(); 
}

//---------------------------------------------------------------------------
// Преобразовать относительный путь в абсолютный

char absolutePath(char* str) {
  uint l;

  // Он уже абсолютный
  if(str[0] == '/') {
    strcpy(str, str+1);
    return 1;
  }

  // Длина пути
  l = strlen(panelA.path1);

  // Если это не корневая папка, прибавляем место для разделителя /
  if(l != 0) l++;

  // Контроль переполнения
  if(strlen(str) + l >= 255) return 0;

  // Добавляем в ком строку
  memcpy_back(str+l, str, strlen(str)+1);
  memcpy(str, panelA.path1, l);

  // Если это не корневая папка, добавляем разделитель /
  if(l != 0) str[l-1] = '/';

  return 1;
}

//---------------------------------------------------------------------------

const char* getName(const char* name) {
  const char* p;
  for(p = name; *p; p++)
    if(*p == '/')
      name = p+1;
  return name;
}

//---------------------------------------------------------------------------
// Выход из папки

void dropPathInt(char* src, char* preparedName) {
  char *p;

  // Отделяем от пути последнюю папку
  p = getname(src);

  // Сохраняем имя папки из которой вышли
  if(preparedName) packName(preparedName, p);

  // Удаляем последнюю папку
  if(p != src) --p;
  *p = 0;
}

//---------------------------------------------------------------------------
// Выход из папки

void dropPath() {
  char buf[11]; 
  dropPathInt(panelA.path1, buf);
  reloadFiles(buf);
}

//---------------------------------------------------------------------------
// Перемещение курсора влево

void cursor_left() {
  if(panelA.cursorX) { 
    --panelA.cursorX; 
  } else
  if(panelA.offset) { 
    if(ROWS_CNT > panelA.offset) { 
      panelA.offset = 0; 
      drawFiles();
    } else {
      panelA.offset -= ROWS_CNT; 
      drawFiles();
    }
  } else
  if(panelA.cursorY) {
    panelA.cursorY = 0; 
  }

  showFileCursorAndDrawFileInfo();
}

//---------------------------------------------------------------------------
// Перемещение курсора вправо

void cursor_right() {
  uint w;

  // Переместится вправо нельзя
  w = panelA.offset + panelA.cursorY + panelA.cursorX*22;
  if(w + ROWS_CNT >= panelA.cnt) { //! перепутаны > и >=
    // Это последний файл
    if(w + 1 >= panelA.cnt) { 
      return;
    }
    // Вычисляем положение по Y
    panelA.cursorY = panelA.cnt - (panelA.offset + panelA.cursorX*ROWS_CNT + 1);
    // Корректируем курсор
    if(panelA.cursorY>ROWS_CNT-1) {
      panelA.cursorY -= ROWS_CNT;
      if(panelA.cursorX == 1) { 
        panelA.offset += ROWS_CNT;
        drawFiles();
      } else {
        panelA.cursorX++; 
      }
    }
  } else
  if(panelA.cursorX == 1) { 
    panelA.offset += ROWS_CNT;
    drawFiles();
  } else {
    panelA.cursorX++;
  }

  showFileCursorAndDrawFileInfo();
}

//---------------------------------------------------------------------------
// Перемещение курсора вверх

void cursor_up() {
  if(panelA.cursorY) { 
    --panelA.cursorY;
  } else        
  if(panelA.cursorX) { 
    --panelA.cursorX;
    panelA.cursorY = ROWS_CNT-1; 
  } else        
  if(panelA.offset) {
    --panelA.offset; 
    drawFiles();
  }

  showFileCursorAndDrawFileInfo();
}

//---------------------------------------------------------------------------
// Перемещение курсора вниз

void cursor_down() {
  if(panelA.offset + panelA.cursorX*ROWS_CNT + panelA.cursorY + 1 >= panelA.cnt) return;

  if(panelA.cursorY < ROWS_CNT-1) {
    ++panelA.cursorY;
  } else        
  if(panelA.cursorX == 0) {
    panelA.cursorY = 0;
    ++panelA.cursorX; 
  } else { 
    ++panelA.offset; 
    drawFiles();
  }

  showFileCursorAndDrawFileInfo();
}

//---------------------------------------------------------------------------
// Изменение активной панели

void cmd_tab() {
  hideFileCursor();
  drawPanelTitle(0);
  swapPanels();
  showFileCursor();
  drawPanelTitle(1);
  drawCmdLineWithPath();
}

//---------------------------------------------------------------------------
// Запуск ком строки

void runCmdLine() {
  register char *cmdLine2;

  // Преобразование относительного пути в абсолютный
  if(!absolutePath(cmdline)) return;

  // Разделение ком строки по первому пробелу
  cmdLine2 = strchr(cmdLine, ' ');
  if(cmdLine2) {
    *cmdLine2 = 0;
    ++cmdLine2;
  } else {
    cmdLine2 = "";
  }

  // Запуск
  run(cmdLine, cmdLine2);
}

//---------------------------------------------------------------------------

void dupFiles(uchar reload) {
  swapPanels();
  // Если пути одинаковые, то просто копируем список файлов
  if(0==strcmp(panelA.path1, panelB.path1)) {
    memcpy(panelA.files1, panelB.files1, maxFiles*sizeof(FileInfo));
    panelA.cnt = panelB.cnt;    
  } else {
    // Иначе можем загрузить
    if(reload) getFiles();
  }
  // Если курсор за пределаем экрана
  getSel();
  swapPanels();
}

//---------------------------------------------------------------------------

void loadState() {
  uint i;
  i = strlen(fs_selfName);
  if(i < 4) return;
  i -= 3;
  if(0 != strcmp(fs_selfName + i, ".RK")) return;
  strcpy(fs_selfName + i, ".IN");

  if(fs_open(fs_selfName)) return;
  fs_read(cmdline, 12);
  if(cmdline[11]) swapPanels();
  fs_read(panelA.path1, 256); panelA.path1[255] = 0;
  fs_read(panelB.path1, 256); panelB.path1[255] = 0;
}

//---------------------------------------------------------------------------

void saveState() {
  if(fs_create(fs_selfName) && fs_open(fs_selfName)) return;
  fs_write(getSel()->fname, 11);
  fs_write(&activePanel, 1);
  fs_write(panelA.path1, 256);
  fs_write(panelB.path1, 256);
}

//---------------------------------------------------------------------------
// Запустить программу. В случае ошибки вывести ошибку на экран, а потом
// очистить ком строку и восстановить экран

void run(const char* prog, const char* cmdLine) {
  saveState();
  drawError(prog, fs_exec(prog, cmdLine)); 
  drawScreen(); // Там происходит очистка ком строки
}

//---------------------------------------------------------------------------

void cmd_editview(char* app) {
  FileInfo* f = getSel();
  if(f->fattrib & 0x10) return;
  unpackName(cmdLine, f->fname);
  if(!absolutePath(cmdLine)) {
    drawScreen();
    return;
  }
  run(app, cmdLine);
}

//---------------------------------------------------------------------------

void cmd_enter() {
  char *d, i;
  FileInfo* f;
  uint l, o;

  // Запуск ком строки
  if(cmdLine[0]) {
    runCmdLine(); // Функция восстановит экран
    return;
  }

  // Выбранный файл
  f = getSelNoBack();

  // Выход из папки
  if(f == 0) { 
    dropPath(); 
    return; 
  }

  // Получаем полное имя файла
  unpackName(cmdLine, f->fname);
  if(!absolutePath(cmdLine)) { drawScreen(); return; }

  // Входим в папку
  if((f->fattrib & 0x10) != 0) { 
    strcpy(panelA.path1, cmdline);
    cmdline[0] = 0;
    reloadFiles(0);
    return;
  }
  
  // Запускаем файл
  run(cmdline, "");
}  

//---------------------------------------------------------------------------

void cmd_esc() {
  if(cmdLine[0]) {
     cmdline[0] = 0;
     drawCmdLine();
     return;
  }
  dropPath();
}

//---------------------------------------------------------------------------

void cmd_inverseOne() {
  FileInfo* f = getSelNoBack();
  if(!f) return;
  f->fattrib ^= 0x80;
  drawFile(panelA.cursorX, panelA.cursorY, f);
  cursor_down();
}

//---------------------------------------------------------------------------

void cmd_inverseAll() {
  FileInfo* f;
  uint i;
  for(f = panelA.files1, i = panelA.cnt; i; --i, ++f) {
    if(f->fattrib & 0x10) {
      f->fattrib &= 0x7F;
    } else {
      f->fattrib ^= 0x80;
    }
  }
  drawFiles();
  showFileCursor();
}

//---------------------------------------------------------------------------
// Главная программа

void main() {
  register uchar c;

  // Инициализация файловой системы (пока в регистрах нужные значения)
  fs_init();

  // Инициализация экрана
  drawInit();  

  // Распределение памяти
  panelA.files1 = ((FileInfo*)START_FILE_BUFFER);
  panelB.files1 = ((FileInfo*)START_FILE_BUFFER)+maxFiles;

  // Путь по умолчанию
  panelA.path1[0] = 0;
  panelB.path1[0] = 0;

  // Пустая ком строка
  cmdline[0] = 0;
  
  // Перерисовываем весь экран, пока без файлов
  drawScreenInt();
  drawCmdLineWithPath();

  // Загрузка состояния
  loadState();

  // Загрузка файлов в левую панель
  getFiles();

  // Правая панель будет копией левой
  dupFiles(1);

  // Восстановление файла под курсором
  selectFile(cmdline);
  cmdline[0] = 0;

  // Выводим список файлов на экран. GПуть мог изменится, поэтому перерисовываем всё.
  drawPanelTitle(1);
  swapPanels();
  drawPanelTitle(0);
  swapPanels();
  drawFiles2();
  drawCmdLineWithPath();

  // Бесконечный цикл обработки клавиш
  while(1) {
    c = getch1();

    switch(c) {
      case KEY_F1:    cmd_freespace();         continue;
      case KEY_F2:    cmd_new(0);              continue;
      case KEY_F3:    cmd_editview(viewerApp); continue;
      case KEY_F4:    cmd_editview(editorApp); continue;
      case KEY_ENTER: cmd_enter();             continue;
      case KEY_ESC:   cmd_esc();               continue;
      case KEY_LEFT:  cursor_left();           continue;
      case KEY_RIGHT: cursor_right();          continue; 
      case KEY_DOWN:  cursor_down();           continue;
      case KEY_UP:    cursor_up();             continue; 
      case KEY_TAB:   cmd_tab();               continue; 
    }    

    // Клавиши только для пустой ком строки
    if(!cmdLine[0]) {
      switch(c) {
        case '1':     cmd_freespace();         continue;
        case '2':     cmd_new(0);              continue;
        case '3':     cmd_editview(viewerApp); continue;
        case '4':     cmd_editview(editorApp); continue;
        case '%':     cmd_copymove(1, 1);      continue;
        case '5':     cmd_copymove(1, 0);      continue;
        case '&':     cmd_copymove(0, 1);      continue;
        case '6':     cmd_copymove(0, 0);      continue;
        case '7':     cmd_new(1);              continue;
        case '8':     cmd_delete();            continue;
        case KEY_STR: cmd_inverseOne();        continue;
        case ':':     cmd_inverseAll();        continue; // *
        case ';':     cmd_sel(1);              continue; // +
        case '-':     cmd_sel(0);              continue;
      }                   
    }

    // Вывод символа в ком строку
    processInput(c);
    drawCmdLine();
  }
}