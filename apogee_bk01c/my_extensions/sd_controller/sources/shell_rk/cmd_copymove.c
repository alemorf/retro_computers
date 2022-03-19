// Shell for Computer "Radio 86RK" / "Apogee BK01"
// (c) 12-05-2014 vinxru (aleksey.f.morozov@gmail.com)

#include <n.h>
#include "shell.h"
#include "32.h"

uchar cmd_copyFile(char* from, char* to) {
  char buf[16];
  uchar e, progress_i=0;
  ulong progress;
  ulong progress_x, progress_step;

  // Открываем исходный файл и получаем его длину
  if(e = fs_open(from)) return e;
  if(e = fs_getsize()) return e;

  //  Расчет шага прогресса
  set32(&progress_step, &fs_result);
  div32_16(&progress_step, 40);

  // Интерфейс
  drawWindow(" kopirowanie ");
  drawWindowText(0, 0, "iz:");
  drawWindowText(4, 0, from);
  drawWindowText(0, 1, "w:");
  drawWindowText(4, 1, to);
  drawWindowText(0, 2, "skopirowano           /           bajt");
  drawWindowProgress(0, 3, 40, 0x7F);
  i2s32(buf, &fs_result, 10, ' ');
  drawWindowText(23, 2, buf);
  drawEscButton();

  // Создаем новый файл
  if(e = fs_swap()) return e;
  if(e = fs_create(to)) return e;

  // Копирование
  SET32IMM(&progress, 0);
  SET32IMM(&progress_x, 0);
  for(;;) {
    // Вывод прогресса
    i2s32(buf, &progress, 10, ' ');
    drawWindowText(12, 2, buf); 

    // Копирование блока
    if(e = fs_swap()) return e;
    if(e = fs_read(panelB.files1, 1024) ) return e;
    if(fs_low == 0) return 0; // С перезагрузкой файлов
    if(e = fs_swap()) return e;
    if(e = fs_write(panelB.files1, fs_low)) return e;

    // Это недоработка компилятора, Он не поддерживает 32-х битной арифметиики
    add32_16(&progress, fs_low);

    // Прогресс
    add32_16(&progress_x, fs_low);
    while(progress_i < 40 && cmp32_32(&progress_x, &progress_step) != 1) {
      sub32_32(&progress_x, &progress_step);
      drawWindowText(progress_i, 3, "\x17");
      ++progress_i;
    }

    // Прерывание
    if(bioskey1() == KEY_ESC) { e = ERR_USER; break; }
  }

  // Удалить файл в случае ошибки. Ошибку удаления не обрабатываем.
  fs_delete(to);
  return e;
}

//---------------------------------------------------------------------------

void applyMask1(char* dest, char* mask, uchar i) {
  register char m;
  for(;;) {
    m = *mask;
    if(m == '*') return;
    if(m != '?') *dest = m;
    --i;
    if(i==0) return;
    ++mask, ++dest;
  }
}

//---------------------------------------------------------------------------

#define COPY_STACK 8

char cmd_copyFolder(char* from, char* to) {
  char e;
  uint i;
  uchar level=0;
  uint stack[COPY_STACK];
  FileInfo* f;

  // Создаем папку
  e = fs_mkdir(to); 
  if(e) return e;

  for(i=0;;++i) {
    // Слишком много файлов
    if(i == maxFiles) return ERR_MAX_FILES;

    // Получить список файлов этой папки.
    // Получаем по чуть-чуть каждый раз, так как cmd_copyFile портит этот список.
    e = fs_findfirst(from, panelB.files1, i+1);
    if(e != 0 && e != ERR_MAX_FILES) return e; // Мы всегда будем получить ERR_MAX_FILES

    // А нет больше файлов.
    if(i >= fs_low) {
      // Нет рекурсии
      if(level==0) return 0;
      // Возврат
      dropPathInt(from, 0);
      dropPathInt(to, 0);
      --level;
      i = stack[level];
      continue;
    }
    f = panelB.files1 + i;

    // Вычисляем имена файлов
    if(catPathAndUnpack(from, f->fname)) return ERR_RECV_STRING;
    if(catPathAndUnpack(to,   f->fname)) return ERR_RECV_STRING;

    // Подпапка
    if(f->fattrib & 0x10) {
      // Сохраянем позицию в стеке
      if(level == COPY_STACK-1) return ERR_RECV_STRING;
      stack[level] = i;
      level++;
      // Создаем папку
      e = fs_mkdir(to); 
      if(e) return e;
      // Цикл начнется с нуля
      i = -1;
      continue;
    }

    // Копируем файл
    e = cmd_copyFile(from, to);

    // Восстанавливаем путь
    dropPathInt(from, 0);
    dropPathInt(to, 0);

    // Выходим если ошибка
    if(e) return e;
  }
}

//---------------------------------------------------------------------------

void applyMask(char* dest, char* mask) {
  applyMask1(dest, mask, 8);
  applyMask1(dest+8, mask+8, 3);
}

//---------------------------------------------------------------------------

char cmd_copymove1(uchar copymode, uchar shiftPressed) {
  char *name;
  char e;
  FileInfo* f;
  char sourceFile[256];
  char mask[11];
  char forMask[11];
  char type;
  uint i;

  if(shiftPressed) {
    // Копируем имя c первой панели (без пути)
    f = getSelNoBack();
    if(!f) return 0; // Файл не выбран, выходим без ошибки
    unpackName(cmdLine, f->fname);
  } else {
    // Копируем путь со второй панели
    i = strlen(panelB.path1);
    if(i >= 254) return ERR_RECV_STRING; // Так как прибавим 2 символа
    cmdLine[0] = '/';
    strcpy(cmdline+1, panelB.path1);
    if(i != 0) strcpy(cmdline+i+1, "/");
  }

  // Позволяем пользователю изменить путь или имя
  if(!inputBox(copymode ? " kopirowatx " : " pereimenowatx/peremestitx ") && cmdline[0]!=0) return 0;

  // Преобразование относительного пути в абсолютный
  if(!absolutePath(cmdline)) return ERR_RECV_STRING;

  // Используется ли маска?
  mask[0] = 0;  
  name = getname(cmdline);
  if(name[0] != 0) {
    // Сохраняем маску
    packName(mask, name);
    // Убираем из пути маску
    dropPathInt(cmdLine, 0);
  } else {
    // Если в ком строке что то есть, а имя не выделено, значит ком строка оканчивается на /.
    // Этот символ надо удалить
    if(cmdline[0] != 0 && name[0] == 0) name[-1] = 0;
  }

  // Ищем первый файл
  type = getFirstSelected(sourceFile);
  if(type == 0) return 0; // Нет выбранных файлов

  for(;;) {
    // Преобразование относительного пути в абсолютный
    if(!absolutePath(sourceFile)) { e = ERR_RECV_STRING; break; }

    // Добавляем имя
    packName(forMask, getname(sourceFile));
    if(mask[0]) applyMask(forMask, mask);
    if(catPathAndUnpack(cmdline, forMask)) return ERR_RECV_STRING;

    // Самого в мебя не копируем и не переименовываем
    if(0!=strcmp(sourceFile, cmdline)) {
      // Выполнение операции
      if(copymode) {
        if(type==2) {
          e = cmd_copyFolder(sourceFile, cmdline);
        } else {
          e = cmd_copyFile(sourceFile, cmdline);
        }
      } else {
        // Простое окно
        drawWindow(" pereimenowanie/pereme}enie ");
        drawWindowText(0, 1, "iz:");
        drawWindowText(4, 1, sourceFile);
        drawWindowText(0, 2, "w:");
        drawWindowText(4, 2, cmdline);
        drawAnyKeyButton();

        // Прерывание
        if(bioskey1() == KEY_ESC) { e = ERR_USER; break; }

        e = fs_move(sourceFile, cmdline);    
      }

      if(e) break;
    }

    // Убираем из пути имя файла
    dropPathInt(cmdLine, 0);

    // Следующий выбранный файл
    type = getNextSelected(sourceFile);
    if(type == 0) { e=0; break; }
  } // конец цикла

  // При переносе файла надо обновить обе панели
  // А при копировании список файов используется под буфер
  getFiles();
  dupFiles(1);

  return e;
}

//---------------------------------------------------------------------------

char cmd_copymove(uchar copymode, uchar shiftPressed) {
  drawError(copymode ? "o{ibka kopirowaniq" : "o{ibka pereme}eniq", cmd_copymove1(copymode, shiftPressed));
  drawScreen();
}