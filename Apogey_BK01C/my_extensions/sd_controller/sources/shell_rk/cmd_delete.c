// Shell for Computer "Radio 86RK" / "Apogee BK01"
// (c) 12-05-2014 vinxru (aleksey.f.morozov@gmail.com)

#include "shell.h"

char cmd_deleteFile() {
  // Удаление файла
  drawWindow(" udalenie ");
  drawWindowText(0, 1, cmdline);
  drawEscButton();

  // Прерывание
  if(bioskey1() == KEY_ESC) return ERR_USER;

  // Удаление файла
  return fs_delete(cmdline);
}

//---------------------------------------------------------------------------

char cmd_deleteFolder() {
  uchar level; // 8 бит хватит, так как длина пути всего 255 символов.
  char e;
  FileInfo* p;
  uint i;

  level = 0;

  while(1) {
    // Получить список файлов этой папки
    e = fs_findfirst(cmdline, panelB.files1, maxFiles);  
    if(e != 0 && e != ERR_MAX_FILES) return e;
    panelB.cnt = fs_low;

    // Удлаяем всё, пока оно удаляется
    e = 0;
    for(p=panelB.files1, i=panelB.cnt; i; --i, ++p) {
      if(catPathAndUnpack(cmdLine, p->fname)) return ERR_RECV_STRING;
      e = cmd_deleteFile();
      if(e == ERR_DIR_NOT_EMPTY) break;
      dropPathInt(cmdLine, 0);
      // Если ошибка, выходим
      if(e) return e;
    }

    // Если удаляемая папка не пуста заходим в неё
    if(e == ERR_DIR_NOT_EMPTY) { 
      ++level;
      continue;
    }

    // Мы могли получили ERR_MAX_FILES, поэтому делаем повторный запрос.
    if(panelB.cnt == maxFiles) continue;

    // Удаляем эту папку
    e = cmd_deleteFile();
    if(e) return e;

    // Выходим из папки
    if(level == 0) return 0;
    --level;
    dropPathInt(cmdLine, 0);
  }
}

//---------------------------------------------------------------------------

void cmd_delete() {
  uchar e, needRefresh2;

  // Спросить у пользователя 
  if(confirm(" udalitx ", "wy hotite udalitx fail(y)?")) {
    needRefresh2 = 0;

    // Поместить в буфер имя без пути
    if(getFirstSelected(cmdLine)) {
      for(;;) {
        if(!absolutePath(cmdline)) { e = ERR_RECV_STRING; break; }

        // Удаление файла
        e = cmd_deleteFile();

        // Если это папка с файлами, то удаляем её рекурсивно
        if(e == ERR_DIR_NOT_EMPTY) {
          needRefresh2 = 1; // Правая панель будет испорчена
          e = cmd_deleteFolder();
        }
        if(e) break;

        // Следующий файл
        if(!getNextSelected(cmdLine)) break;
      }

      // Вывод ошибок
      drawError("o{ibka udaleniq", e);

      // Обновление списка файлов
      getFiles();
      dupFiles(needRefresh2);
    }
  }

  drawScreen();
}
