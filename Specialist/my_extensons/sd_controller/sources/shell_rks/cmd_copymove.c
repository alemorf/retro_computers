#include <n.h>
#include "shell.h"
#include "graph.h"

uchar cmd_copy(char* from, char* to) {
  uint readed;
  char buf[16];
  uchar flag = 1, e;
  ushort progress_l, progress_h;

  progress_l = progress_h = 0;

  // Открываем исходный файл
  if(e = fs_open(from)) { drawError("Невозможно открыть исходный файл", e); return 1 /*Без перезагрузки файлов*/; } 

  // Интерфейс
  drawWindow(" Копирование ");
  print1(PRINTARGS(13, 9), 64, "Из:");
  print1(PRINTARGS(17, 9), 34, from);
  print1(PRINTARGS(13,10), 64, "В:");
  print1(PRINTARGS(17,10), 34, to);
  print1(PRINTARGS(28,13), 32, "[ ESC ]");

  // Вывод общей длины
  if(e = fs_getsize()) { drawError("Ошибка чтения файла", e); return 1 /*Без перезагрузки файлов*/; } 
  i2s32(buf, 10, &fs_result, ' ');
  print1(PRINTARGS(13,11), 64, "Скопировано           /           байт");
  print1(PRINTARGS(36,11), 10, buf); 

  // Создаем новый файл
  if(e = fs_swap()) { drawError("Ошибка fs_swap 1", e); return 1 /*Без перезагрузки файлов*/; } 
  if(e = fs_create(to)) { drawError("Невозможно создать файл", e); return 1 /*Без перезагрузки файлов*/; } 

  // Копирование
  while(1) {
    // kbhit

    // Вывод прогресса
    i2s32(buf, 10, (ulong*)&progress_l, ' ');
    print1(PRINTARGS(25,11), 10, buf); 

    // Копирование блока
    if(e = fs_swap()) { drawError("Ошибка fs_swap 3", e); break; }
    if(e = fs_read(panelA.files1, (MAX_FILES*sizeof(FileInfo)) & ~511) ) { drawError("Ошибка чтения файла", e); break; }
    if(fs_low == 0) return 0; /* С перезагрузкой файлов */;
    if(e = fs_swap()) { drawError("Ошибка fs_swap 2", e); break; }
    if(e = fs_write(panelA.files1, fs_low)) { drawError("Ошибка записи файла", e); break; }

    // 32-х битная арифметика pl:ph += fs_low;
    asm {
      lhld fs_low
      xchg
      lhld cmd_copy_progress_l
      dad d
      shld cmd_copy_progress_l
      jnc fs_copy_l2
      lhld cmd_copy_progress_h
      inx h
      shld cmd_copy_progress_h
fs_copy_l2:
    }
  }

  // Удалить файл в случае ошибки. Ошибку удаления не обрабатываем.
  fs_delete(to);

  return 0 /* С перезагрузкой файлов */;
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

void cmd_copymove(uchar copymode) {
  char *name, e, *title;
  uint l;
  uint old;
  char buf[256];

  title = copymode ? " Копирование " : " Переименование/Перенос ";

  // Помещаем в буфер имя исходного файла
  addPath1(A_CMDLINE);
  if(cmdline[0] == 0) return;
//  absolutePath();
  strcpy(buf, cmdline);

  if(shiftPressed()) {
    // Копируем имя c первой панели
    getSelectedName(cmdLine);
    cmdline_pos = strlen(cmdline);
  } else {
    // Копируем путь со второй панели
    strcpy(cmdline, panelB.path);
    cmdline_pos = strlen(cmdline);
  
    // Добавляем в конец пути /, что бы потом
    // автоматом добавилось имя файла
    if(cmdline_pos != 1) {
      if(cmdline_pos == 255) { // Буфер переполнен 
        drawError(title, ERR_RECV_STRING);
        goto end;
      }
      strcpy(cmdline+cmdline_pos, "/");
      ++cmdline_pos;
    }
  }

  // Отключаем перезагрузку файлов
  e=1; 
  
  // Позволяем пользователю именить путь или имя
  if(inputBox(title)) {

    // Если на конце пути назначения /, значит надо добавить имя    
    if(cmdline[cmdline_pos - 1] == '/') {      
      name = getName(buf);
      if(strlen(name) + cmdline_pos >= 256) { 
        drawError(title, ERR_RECV_STRING);
        goto end;      
      }
      strcpy(cmdline + cmdline_pos, name);
    }

    // Преобразование относительного пути в абсолютный
    absolutePath();
    
    if(copymode) {
      e = cmd_copy(buf, cmdline);
    } else {
      // Перенос файла или папки
      e = fs_move(buf, cmdline);

      // Вывод ошибки
      drawError("Ошибка переноса/переименования", e);
    }
  }

  // При переносе файла надо обновить обе панели
  // А при копировании список файов используется под буфер
  // Только если не было ошибки
  if(!e) {
    getFiles();
    swapPanels(); getFiles(); swapPanels();
  }

  // Восстанавлиаем экран и ком строку
end:
  repairScreen(0);
}
